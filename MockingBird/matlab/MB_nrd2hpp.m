function nlxstruct = MB_nrd2hpp( fname, channelsRequested, DS, DCO, plotflag )

% ARGUMENTS
% fname = name of input nrd file to process (e.g., '/CheetahData/RawDataFile.nrd')
% channelRequested = vector of Neuralynx channels numbers (0 based counting) to process (e.g., [63 88 121])
% DS = vector of integer factors by which to downsample each channel (e.g., [200 25 9])
% DCO = vector of DCO window widths (length must be same as DS, values must be powers of 2) for removing drift from the LFP (e.g., [256 128 32])
% plotflag = 1=plot graphs, 0=no plotting (default is 0 if omitted)

% RETURN VALUES
% nlxstruct is a vector of structure variables with length equal to the number extracted channels
% fields of the structure are as follows:
% nlxstruct(i).gapstart = any gaps in the data are filled with NaNs; this vector contains the start index of each gap
% nlxstruct(i).gaplength = this vector contains the length (number of NaNs) of each NaN gap
% nlxstruct(i).channel = channel number for this data
% nlxstruct(i).dsfactor = downsampling factor (DS) for this data
% nlxstruct(i).dt = sample interval for this data
% nlxstruct(i).dcowidth = DCO window size for this data
% nlxstruct(i).data = 24 bit signed integer data, downsampled and DCO filtered (centered at zero)
% nlxstruct(i).filtered = substructure containing filtered versions of the data (returns empty from this function)

if nargin < 5
    plotflag = 0;
end
% % error checking
% if recordStart <1
%     recordStart = 1;
% end


status=unix(['nrdExtractor -T ' fname ' ' channelsRequested]);
d=importdata('headerOutputFile.txt',' ',13); %read in header file
samplerate=d.data(1); %get sampling rate
['Neuralynx sampling rate is ' num2str(samplerate) ' Hz']
[ timestamps ] = loadCExtractedNrdTimestampData( 'timestamps.dat' );
timestamps=(timestamps-timestamps(1))/1000000;
temp=diff(timestamps);
negstamps=find(temp<0);
bigstamps=find(temp>=(2/samplerate));

if ~isempty(negstamps) %if there are redundant copies of data spliced into nrd file
    bigoff=find(bigstamps==negstamps(1)+128);
    %remove any redundant copies of data spliced into nrd file
    fixts=timestamps(1:negstamps(1));
    for ii=1:length(negstamps)-1
        fixts=[fixts; timestamps((bigstamps(bigoff+(ii-1)*2)+1):negstamps(ii+1))];
    end
    %truncate beginning of data after any unfixed time jumps
%     if bigoff>1
%         fixts=fixts((bigstamps(bigoff-1)+5):end);
%     end
else
    fixts=timestamps;
end
%interpolate timestamps across any remaining gaps
fxdif=diff(fixts);
fxbig=(find(fxdif>=(2/samplerate)));
dt=mean(fxdif);
temp=fixts(1:fxbig(1));
for ii=1:length(fxbig)
    newtimes(ii).ts=[(fixts(fxbig(ii))+dt):dt:(fixts(fxbig(ii)+1)-dt)]';
    newts=interp1([fixts(fxbig(ii)) fixts(fxbig(ii)+1)],[fixts(fxbig(ii)) fixts(fxbig(ii)+1)],newtimes(ii).ts);
    if ii<length(fxbig)
        temp=[temp; newts; fixts((fxbig(ii)+1):fxbig(ii+1))];
    else
        temp=[temp; newts; fixts((fxbig(ii)+1):end)];
    end
end
prefixts=fixts;
fixts=temp;

spdex=strfind(channelsRequested,' ');
if ~isempty(spdex)
    sdex=1;
    for i=1:length(spdex)
        DCOwin = [ones(1,DCO(i)) zeros(1,DCO(i))]/DCO(i);
        gapthresh=1+round(.0065/((1.04/((samplerate/DS(i))/12))/12)); %wacky formula computes maximum allowable gap size
        chnum=channelsRequested(sdex:(spdex(i)-1));
        sdex=spdex(i)+1;
        chData = loadCExtractedNrdChannelData( ['rawChannel_' chnum '.dat'] );
        if ~isempty(negstamps) %if there are redundant copies of data spliced into nrd file
        temp=chData(1:negstamps(1));
        for ii=1:length(negstamps)-1
            temp=[temp; chData((bigstamps(bigoff+(ii-1)*2)+1):negstamps(ii+1))];
        end
        chData=temp;
        end
%         if bigoff>1
%             temp=temp((bigstamps(bigoff-1)+5):end);
%         end
        temp=chData(1:fxbig(1));
        for ii=1:length(fxbig)
            newvals=[(chData(fxbig(ii))+dt):dt:(chData(fxbig(ii)+1)-dt)]';
            newdat=interp1([prefixts(fxbig(ii)) prefixts(fxbig(ii)+1)],[chData(fxbig(ii)) chData(fxbig(ii)+1)],newtimes(ii).ts)*NaN;
            if ii<length(fxbig)
                temp=[temp; newdat; chData((fxbig(ii)+1):fxbig(ii+1))];
            else
                temp=[temp; newdat; chData((fxbig(ii)+1):end)];
            end
        end
        [chData, gapstart, gaplength] = jumpfill1D(fixts(1:DS(i):end), temp(1:DS(i):end), gapthresh); %downsample and interpolate across small NaN gaps
        if ~isempty(gapstart)
            ['WARNING!! ch# ' chnum ' data contains ' num2str(length(gapstart)) ' NaN gaps!']
            nlxstruct(i).gapstart = gapstart;
            nlxstruct(i).gaplength = gaplength;
        else
            nlxstruct(i).gapstart = [];
            nlxstruct(i).gaplength = [];
        end
        truncdata=chData-conv(chData,DCOwin,'same'); truncdata=truncdata(DCO(i)+1:end); %truncate beginning prior to DCO window averaging
        chData = [str2num(chnum); DS(i); DCO(i); truncdata];
%         fileID = fopen(['rawChannel_' chnum '.hpp'],'w');
%         fprintf(fileID,'%d\n',chData);
%         fclose(fileID);
        nlxstruct(i).channel = str2num(chnum);
        nlxstruct(i).dsfactor = DS(i);
        nlxstruct(i).dt = nlxstruct(i).dsfactor/samplerate;
        nlxstruct(i).dcowidth = DCO(i);
        nlxstruct(i).data = round(chData(4:end));
        nlxstruct(i).filtered = [];
        if plotflag
          figure; clf;
          tempts=fixts(1:DS(i):end);
          plot(tempts(DCO(i)+1:end),nlxstruct(i).data);
          title(['ch#' num2str(nlxstruct(i).channel) ' DS-' num2str(nlxstruct(i).dsfactor) ' DCO-' num2str(nlxstruct(i).dcowidth)]);
        end
    end
    DCOwin = [ones(1,DCO(end)) zeros(1,DCO(end))]/DCO(end);
    gapthresh=round(.0065/((1.04/((samplerate/DS(end))/12))/12)); %wacky formula computes maximum allowable gap size
    chnum=channelsRequested(sdex:end);
    chData = loadCExtractedNrdChannelData( ['rawChannel_' chnum '.dat'] );
    if ~isempty(negstamps) %if there are redundant copies of data spliced into nrd file
    temp=chData(1:negstamps(1));
    for ii=1:length(negstamps)-1
        temp=[temp; chData((bigstamps(bigoff+(ii-1)*2)+1):negstamps(ii+1))];
    end
    chData=temp;
    end
%     if bigoff>1
%         temp=temp((bigstamps(bigoff-1)+5):end);
%     end
    temp=chData(1:fxbig(1));
    for ii=1:length(fxbig)
        newvals=[(chData(fxbig(ii))+dt):dt:(chData(fxbig(ii)+1)-dt)]';
        newdat=interp1([prefixts(fxbig(ii)) prefixts(fxbig(ii)+1)],[chData(fxbig(ii)) chData(fxbig(ii)+1)],newtimes(ii).ts)*NaN;
        if ii<length(fxbig)
            temp=[temp; newdat; chData((fxbig(ii)+1):fxbig(ii+1))];
        else
            temp=[temp; newdat; chData((fxbig(ii)+1):end)];
        end
    end
    [chData, gapstart, gaplength] = jumpfill1D(fixts(1:DS(end):end), temp(1:DS(end):end), gapthresh); %downsample and interpolate across small NaN gaps
        if ~isempty(gapstart)
            ['WARNING!! ch# ' chnum ' data contains ' num2str(length(gapstart)) ' NaN gaps!']
            nlxstruct(length(spdex)+1).gapstart = gapstart;
            nlxstruct(length(spdex)+1).gaplength = gaplength;
        else
            nlxstruct(length(spdex)+1).gapstart = [];
            nlxstruct(length(spdex)+1).gaplength = [];
        end
    truncdata=chData-conv(chData,DCOwin,'same'); truncdata=truncdata(DCO(end)+1:end);
    chData = [str2num(chnum); DS(end); DCO(end); truncdata];
%     fileID = fopen(['rawChannel_' chnum '.hpp'],'w');
%     fprintf(fileID,'%d\n',chData);
%     fclose(fileID);
    nlxstruct(length(spdex)+1).channel = str2num(chnum);
    nlxstruct(length(spdex)+1).dsfactor = DS(end);
    nlxstruct(length(spdex)+1).dt = nlxstruct(length(spdex)+1).dsfactor/samplerate;
    nlxstruct(length(spdex)+1).dcowidth = DCO(end);
    nlxstruct(length(spdex)+1).data = round(chData(4:end));
    nlxstruct(length(spdex)+1).filtered = [];
    if plotflag
        figure; clf;
        tempts=fixts(1:DS(end):end);
        plot(tempts(DCO(end)+1:end),nlxstruct(length(spdex)+1).data);
        title(['ch#' num2str(nlxstruct(length(spdex)+1).channel) ' DS-' num2str(nlxstruct(length(spdex)+1).dsfactor) ' DCO-' num2str(nlxstruct(length(spdex)+1).dcowidth)]);
    end
else
    DCOwin = [ones(1,DCO) zeros(1,DCO)]/DCO;
    gapthresh=round(.0065/((1.04/((samplerate/DS)/12))/12)); %wacky formula computes maximum allowable gap size
    chData = loadCExtractedNrdChannelData( ['rawChannel_' channelsRequested '.dat'] );
    if ~isempty(negstamps) %if there are redundant copies of data spliced into nrd file
    temp=chData(1:negstamps(1));
    for ii=1:length(negstamps)-1
        temp=[temp; chData((bigstamps(bigoff+(ii-1)*2)+1):negstamps(ii+1))];
    end
    chData=temp;
    end
%     if bigoff>1
%         temp=temp((bigstamps(bigoff-1)+5):end);
%     end
    temp=chData(1:fxbig(1));
    for ii=1:length(fxbig)
        newvals=[(chData(fxbig(ii))+dt):dt:(chData(fxbig(ii)+1)-dt)]';
        newdat=interp1([prefixts(fxbig(ii)) prefixts(fxbig(ii)+1)],[chData(fxbig(ii)) chData(fxbig(ii)+1)],newtimes(ii).ts)*NaN;
        if ii<length(fxbig)
            temp=[temp; newdat; chData((fxbig(ii)+1):fxbig(ii+1))];
        else
            temp=[temp; newdat; chData((fxbig(ii)+1):end)];
        end
    end
    [chData, gapstart, gaplength] = jumpfill1D(fixts(1:DS:end), temp(1:DS:end), gapthresh); %downsample and interpolate across small NaN gaps
        if ~isempty(gapstart)
            ['WARNING!! ch# ' chnum ' data contains ' num2str(length(gapstart)) ' NaN gaps!']
            nlxstruct(i).gapstart = gapstart;
            nlxstruct(i).gaplength = gaplength;
        else
            nlxstruct(i).gapstart = [];
            nlxstruct(i).gaplength = [];
        end
    truncdata=chData-conv(chData,DCOwin,'same'); truncdata=truncdata(DCO+1:end);
    chData = [str2num(chnum); DS; DCO; truncdata];
%     fileID = fopen(['rawChannel_' chnum '.hpp'],'w');
%     fprintf(fileID,'%d\n',chData);
%     fclose(fileID);
    nlxstruct.channel = str2num(chnum);
    nlxstruct.dsfactor = DS;
    nlxstruct.dt = nlxstruct.dsfactor/samplerate;
    nlxstruct.dcowidth = DCO;
    nlxstruct.data = round(chData(4:end));
    nlxstruct.filtered = [];
    if plotflag
        figure; clf;
        tempts=fixts(1:DS:end);
        plot(tempts(DCO+1:end),nlxstruct.data);
        title(['ch#' num2str(nlxstruct.channel) ' DS-' num2str(nlxstruct.dsfactor) ' DCO-' num2str(nlxstruct.dcowidth)]);
    end
end


