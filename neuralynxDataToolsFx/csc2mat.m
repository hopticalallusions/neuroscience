function [data, fulltimestamps, header, ADBitVolts, sampFreq, channel, nValSamp ]=csc2mat(fname, recordStart, recordEnd)

% now returns microvolts

% Jeffrey Erlich, March 5, 2007
% jerlich@princeton.edu
% 
% modified by ahowe April 2015

if nargin > 1
    recordStart = floor(recordStart/512);
end
if nargin > 2
    recordEnd = floor(recordEnd/512); % the records come in blocks of 512, so specifying how many samples in will cause problems.
end

if nargin < 2
    recordStart = 1;
end

fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
    [fname, pathname, filterindex] = uigetfile('*.Ncs', 'Pick an CSC file');
    fid=fopen([pathname filesep fname],'r');
end

header=fread(fid,16384);
header=char(header');

% go to end of file to get filesize.
% note, that this info is also in the header... maybe in future do a double
% check of the header info and the file size.

fseek(fid, 0, 1);
pos=ftell(fid);

if recordStart <1
    recordStart = 1;
end

% go to the start of the data, after the header
fseek(fid, 16384+((recordStart-1)*1044), 'bof');
%fseek(fid, 16384, 'bof');

% the file is a 16K header with a bunch of CSC records afterwards.
% each CSC record is 64+32+32+32+512*16 bits = 1044 bytes

num_recs=(pos-16384)/1044;

if mod(num_recs,1)>0
    warning('some bad records or sumptin')
    return;
elseif recordStart > num_recs
    warning('record start cannot be greater than the number of records in the file.');
    return;
end

if nargin < 3
    recordEnd = num_recs;
elseif recordEnd > num_recs
    recordEnd = num_recs;
elseif recordEnd < recordStart
    warning( [ 'recordStart is larger then recordEnd, defaulting to record 1 through ' num2str(recordEnd) ] );
    recordStart = 1;
end

recordsToRead = recordEnd - recordStart + 1;

timestamps = zeros( recordsToRead,   1 );
channel    = zeros( recordsToRead,   1 );
sampFreq   = zeros( recordsToRead,   1 );
nValSamp   = zeros( recordsToRead,   1 );
data       = zeros( recordsToRead, 512 );

% records 1 through records to read because we already moved the file to an
% appropriate location.

for recX=1:recordsToRead
    
    timestamps(recX) = fread( fid,   1, 'int64' );
    channel(recX)    = fread( fid,   1, 'int32' );
    sampFreq(recX)   = fread( fid,   1, 'int32' );
    nValSamp(recX)   = fread( fid,   1, 'int32' );
    data(recX,:)     = fread( fid, 512, 'int16' );

end


if numel(unique(channel))==1
	channel=channel(1);
else
    warning('inconsistent channel information')
    channel=channel;
end

if numel(unique(sampFreq))==1
    sampFreq=sampFreq(1);
else
    warning('inconsistent sample frequency (sampFreq) infomation')
    sampFreq=sampFreq;
end


if sum(nValSamp < 512) 
    warning('some of the records have fewer than 512 valid samples!');
end

if numel(unique(nValSamp))==1
    nValSamp=nValSamp(1);
else
    warning('inconsistent number of valid samples (nValSamp) infomation')
    nValSamp=nValSamp;
end


data = data';
data = data(:);

% make a continuous time vector, preserving the original timestamps and
% interpolating between these markers
fulltimestamps = zeros( length( timestamps ) * 512, 1 );
if (length(timestamps) > 1)
    for idx = 1: (length( timestamps )-1)

        deltaTime = ( timestamps(idx+1) - timestamps(idx) )/512;
        if idx < length(timestamps)
            tempTimes = timestamps(idx):deltaTime:timestamps(idx+1);
        else
            tempTimes = timestamps(idx):deltaTime:timestamps(idx)+(deltaTime*512);
        end

        fulltimestamps( 1+(512*(idx-1)):512+(512*(idx-1)) ) = tempTimes(1:512);
    end
    % TODO clean up this tail-end full timestamps array fixer.
    tmpIdx = strfind(header, 'SamplingFrequency');
    sampFreq = sscanf(header(tmpIdx(1) + length('SamplingFrequency'):end), '%g', 1);
    fulltimestamps(end-512:end) = timestamps(end):1e6/32000:timestamps(end)+(512*1e6/32000);
elseif (length(timestamps) == 1 )
        tmpIdx = strfind(header, 'SamplingFrequency');
        sampFreq = sscanf(header(tmpIdx(1) + length('SamplingFrequency'):end), '%g', 1);
        fulltimestamps = timestamps(1):1e6/32000:timestamps(1)+(512*1e6/32000);
end
if (sum(fulltimestamps==0)>0)
    disp(['problem : ', num2str(sum(fulltimestamps==0))  ,' bad timestamps'])
    %fulltimestamps(end-512:end)=fulltimestamps(end-1024:end-512)+(fulltimestamps(end-1024)-fulltimestamps(end-513));
end

% don't adjust the timestamps. makes it hard to align things from events .
% fulltimestamps = ( fulltimestamps - fulltimestamps(1) )/1e6;

% method to extract bitvolts
% there are others, but this one was a new one.
tmpIdx = strfind(header, 'ADBitVolts');
ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
data = data * ADBitVolts * 1000; % milivolts


fclose(fid);

return;

end