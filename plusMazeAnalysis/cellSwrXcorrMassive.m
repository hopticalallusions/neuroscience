 %% load data

% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-22_orientation1/1.maze-habituation/';
% ttFilenames={'TT2CUTaftermerge.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
% dateStr='2016-08-22';

function cellSwrXcorrMassive( path, ratName, dateStr, swrFilename, figureOutputPath  )
    

    disp([ 'start cellSwrXcorrMassive ' ] )
    disp([ '   path                   ' path ]);
    disp([ '   rat name               ' ratName ]);
    disp([ '   date                   ' dateStr ]);
    disp([ '   swr filename           ' swrFilename ]);
    disp([ '   output into            ' figureOutputPath ]);
    
    gcf(1)=figure(1); 
    clf(gcf(1));
    fig = gcf(1);
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 16 9]; 

    %%
    if exist( [ figureOutputPath '/' ratName '_' dateStr '_chewBruxEpisodes.mat' ] )
        load(  [ figureOutputPath '/' ratName '_' dateStr '_chewBruxEpisodes.mat' ] );
        removeChewsReady = 1;
    else
        removeChewsReady = 0;
    end
    
    
%%
    
    ttFilenames = dir( [path 'TT*']);
    tetrodeExtension = '.ntt';
    %
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*a.NTT']);
        tetrodeExtension = '.NTT';
    end
     if isempty(ttFilenames)
        ttFilenames = dir( [path '*cut.ntt']);
        tetrodeExtension = '.ntt';
    end
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*cut.NTT']);
        tetrodeExtension = '.NTT';
    end
    
    subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

    speedThreshold = 10; % cm/s

    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
    speed=speedAll;



    %% SWR band

    disp( ' SWR Detection Block' )
    
   
 
    %% This is about to get crazy. There are two copies of this routine because matlab dies when the files are too long.
    %load part of the file; you always need the first timestamp
    if  strcmp( swrFilename(1:3), 'SWR');
        [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 1, 1000 );
    else
        [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 1, 1000 );
    end

    storedSwrFileName =  [ figureOutputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat' ];
    if exist( storedSwrFileName );
        load( storedSwrFileName );
        swrPeakTimestamps = swrData.timestamps;
        swrPeakTimes = swrData.times;
        swrPeakValues = swrData.peaks;
        swrFilename  = swrData.file;
    else
        clear swrLfp lfpSwr lfpTimestamps
        disp( ' loading SWR LFP ' )

        %matlab crashes if the file is longer than about 95 minutes. So...
        if xytimestampSeconds(end) < 80*60
             disp( 'simple load' )

            % sometimes we might want to use a pre-filtered LFP
            if  strcmp( swrFilename(1:3), 'SWR');
                [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ] );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) < -5
                    disp('fixing timestamps SWR')
                    [lfpTimestamps,idxUniq,~]=unique(lfpTimestamps);
                    swrLfp=swrLfp(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    swrLfp=swrLfp(idx);
                end
            else
                [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ] );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) < -5
                    disp('fixing timestamps CSC')
                    [lfpTimestamps,idxUniq,~]=unique(lfpTimestamps);
                    lfpSwr=lfpSwr(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    lfpSwr=lfpSwr(idx);
                end
                % now filter
                swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
                swrLfp = filtfilt( swrFilter, lfpSwr );
            end
            %
            lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
            swrLfpEnv = abs(hilbert(swrLfp));
            swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
            % find SWR bursts
            [ swrPeakValues,      ...
              swrPeakTimes,       ... 
              ~, ...
              ~ ] = findpeaks( swrLfpEnv,                        ... % data
                               lfpTimestampSeconds,                     ... % sampling frequency
                               'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                               'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
            % clear up some variables
            clear swrLfpEnv swrLfp lfpSwr;
            % save the data so we don't have to do that again.
            swrData.times = swrPeakTimes;
            swrData.peaks = swrPeakValues;
            swrData.file = swrFilename;
            save( [ path '/swrData' ], 'swrData' )
        else
            disp( 'split load' )
            % this file is long, and will cause some matlabs to explode.
            % thus. we shall chop it up.
            if  xytimestampSeconds(end) > 150*60
                disp(num2str(xytimestampSeconds(end)))
                error('this session is > 2 hr 30 min long! I am not authorized to process this!');
            end
            %
            % Do the first hour
            %
            %
            % sometimes we might want to use a pre-filtered LFP
            if  strcmp( swrFilename(1:3), 'SWR');
                [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 1, 32000*60*60 );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) <= 0
                    disp('suspicious timestamps hr 1 SWR*ncs; I fixed them!')
                    [lfpTimestamps,idxUniq,~]=unique(lfpTimestamps);
                    swrLfp=swrLfp(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    swrLfp=swrLfp(idx);
                end
            else
                [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 1, 32000*60*60 );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) <= 0
                    disp('suspicious timestamps hr 1 CSC*ncs; I fixed them!')
                    [lfpTimestamps,idxUniq,~]=unique(lfpTimestamps);
                    lfpSwr=lfpSwr(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    lfpSwr=lfpSwr(idx);
                end
                % now filter
                swrFilter = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
                swrLfp    = filtfilt( swrFilter, lfpSwr );
            end
            %
            lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
            swrLfpEnv = abs(hilbert(swrLfp));
            swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
            % find SWR bursts
            [ swrPeakValuesA,  ...
              swrPeakTimesA,   ... 
              ~, ...
              ~ ] = findpeaks( swrLfpEnv,                        ... % data
                               lfpTimestampSeconds,                     ... % sampling frequency
                               'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                               'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
           %
            % Do the second hour
            %
            %
            % sometimes we might want to use a pre-filtered LFP
            if  strcmp( swrFilename(1:3), 'SWR');
                [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 32000*60*60+1, xytimestampSeconds(end)*32000+10 );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) <= 0
                    disp('suspicious timestamps hr 2 SWR*ncs; I fixed them!')
                    [lfpTimestamps,idxUniq,idxAll]=unique(lfpTimestamps);
                    swrLfp=swrLfp(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    swrLfp=swrLfp(idx);
                end
            else
                [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 32000*60*60+1, xytimestampSeconds(end)*32000+10 );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) <= 0
                    disp('suspicious timestamps hr 2 CSC*ncs; I fixed them!')
                    [lfpTimestamps,idxUniq,idxAll]=unique(lfpTimestamps);
                    lfpSwr=lfpSwr(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    lfpSwr=lfpSwr(idx);
                end
                % now filter
                swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
                swrLfp = filtfilt( swrFilter, lfpSwr );
            end
            %
            lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
            swrLfpEnv = abs(hilbert(swrLfp));
            swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
            % find SWR bursts
            [ swrPeakValuesB,      ...
              swrPeakTimesB,       ... 
              ~, ...
              ~ ] = findpeaks( swrLfpEnv,                        ... % data
                               lfpTimestampSeconds,                     ... % sampling frequency
                               'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                               'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

            %
            clear swrLfpEnv swrLfp lfpSwr;
            %
            swrPeakTimes = [ swrPeakTimesA; swrPeakTimesB ];
            swrPeakValues = [ swrPeakValuesA; swrPeakValuesB ];
            %
            % save the data so we don't have to do *that* again.
            swrData.times = swrPeakTimes;
            swrData.peaks = swrPeakValues;
            swrData.file = swrFilename;
            save( [ path '/swrData' ], 'swrData' )
        end
    end
    
    
    
    if removeChewsReady > 0
        disp ( 'removing chew noise' )
        validSwrs = ones(1,length(swrPeakTimes));
        for ii=1:length(chewBruxArtifactDetectorOut.chewData.chewStartTimes)
            idxs =  ( swrPeakTimes > chewBruxArtifactDetectorOut.chewData.chewStartTimes(ii) ) .*  ( swrPeakTimes < chewBruxArtifactDetectorOut.chewData.chewEndTimes(ii) );
            validSwrs(idxs>0) = 0;
        end
        for ii=1:length(chewBruxArtifactDetectorOut.bruxData.bruxStartTimes)
            idxs =  ( swrPeakTimes > chewBruxArtifactDetectorOut.bruxData.bruxStartTimes(ii) ) .*  ( swrPeakTimes < chewBruxArtifactDetectorOut.bruxData.bruxEndTimes(ii) );
            validSwrs(idxs>0) = 0;
        end
        %
        validSwrs=validSwrs>0;
        swrPeakTimes = swrPeakTimes(validSwrs);
        swrPeakValues = swrPeakValues(validSwrs);

        disp ([ ' removed '  num2str( length(swrPeakTimes) - length(swrPeakTimes) ) ])
        disp('build SWR Position data');

        % build some structures for later SWR analysis
        swrPosAll=zeros(2,length(swrPeakTimes));
        swrSpeedAll=zeros(1,length(swrPeakTimes));
        for ii=1:length(swrPeakTimes)
            tempIdx=find(swrPeakTimes(ii)<=xytimestampSeconds, 1 );
            if ~isempty(tempIdx)
                swrPosAll(1,ii) = xpos (tempIdx);
                swrPosAll(2,ii) = ypos (tempIdx);
                swrSpeedAll(ii) = speed (tempIdx);
            end
        end
        swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
        swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);
    else
        disp ( 'No data to remove chew noise' )
        % build some structures for later SWR analysis
        swrPosAll=zeros(2,length(swrPeakTimes));
        swrSpeedAll=zeros(1,length(swrPeakTimes));
        for ii=1:length(swrPeakTimes)
            tempIdx=find(swrPeakTimes(ii)<=xytimestampSeconds, 1 );
            if ~isempty(tempIdx)
                swrPosAll(1,ii) = xpos (tempIdx);
                swrPosAll(2,ii) = ypos (tempIdx);
                swrSpeedAll(ii) = speed (tempIdx);
            end
        end
        swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
        swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);
    end
    %
    temptext = path;
    disp( temptext );
    
    temptext = dateStr;
    disp( temptext );

    
    
    subplot(7,14,1);
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes );
    plot(lagtimes,xcorrValues, 'k');
    hold on;
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll>speedThreshold) );
    plot(lagtimes,xcorrValues,'g'); 
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll<=speedThreshold) );
    scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
    plot(lagtimes,xcorrValues,'r'); 
    set( gca, 'XTick', [], 'YTick', [] )
    title('acorr SWR')    
    
    subplotIdx = 2;
    plateCounter = 1;
    for ttIdx=1:length(ttFilenames)
        
        try
            disp( ttFilenames{ttIdx} );
        catch
            disp( ttFilenames(ttIdx).name );
        end

        try
 %           [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            thisTtFilename = ttFilenames{ttIdx};
            disp( thisTtFilename );
        catch
            %[ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            thisTtFilename = ttFilenames(ttIdx).name;
            disp( thisTtFilename );
        end
        
        cellPosAll = zeros(2,length(spiketimes));   % row 1 is X, row 2 is Y
        cellSpeedAll = zeros(1,length(spiketimes)); % collect all the speeds
        cellTimesAll = zeros(1,length(spiketimes));
        for ii=1:length(spiketimes)
            tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
                if ~isempty(tempIdx)
                    cellPosAll(1,ii) = xpos (tempIdx);
                    cellPosAll(2,ii) = ypos (tempIdx);
                    cellSpeedAll(ii) = speed (tempIdx);
                    cellTimesAll(ii) = spiketimes(ii);
                end
        end
        cellTimesAllSeconds = (cellTimesAll-lfpTimestamps(1))/1e6;
        % simple speed filter hack
        cellNFast = cellNumber(cellSpeedAll>speedThreshold);
        cellTimesFast = cellTimesAll(cellSpeedAll>speedThreshold);
        cellTimesFastSeconds = (cellTimesFast-lfpTimestamps(1))/1e6;
        %
        cellNSlow = cellNumber(cellSpeedAll<=speedThreshold);
        cellTimesSlow = cellTimesAll(cellSpeedAll<=speedThreshold);
        cellTimesSlowSeconds = (cellTimesSlow-lfpTimestamps(1))/1e6;
        %
        for whichCell=0:max(cellNumber)
            disp( [ num2str(ttIdx) ' of ' num2str(length(ttFilenames)) ' TT files || ' num2str(whichCell) ' of ' num2str(max(cellNumber)) ' these clusters' ] );
%            if sum(cellNFast==whichCell) > 2                
%%                % plot swr X cell firing
                subplot(7,14,subplotIdx);
                hold off;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes );
                plot(lagtimes,xcorrValues, 'k');
                hold on;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), swrPeakTimes(swrSpeedAll>speedThreshold) );
                plot(lagtimes,xcorrValues,'g'); 
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), swrPeakTimes(swrSpeedAll<=speedThreshold) );
                scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
                plot(lagtimes,xcorrValues,'r'); 
                set( gca, 'XTick', [], 'YTick', [] )
                %subplot tight;
                try
                    title( [ '_{' strrep(ttFilenames{ttIdx},tetrodeExtension,'') ' c' num2str(whichCell) '}' ]);
                catch
                    title( [ '_{' ttFilenames(ttIdx).name(1:end-4) ' c' num2str(whichCell) '}' ]);
                end
%%              
                if ( subplotIdx > 14*7 )
                    if isempty( figureOutputPath )
                        figureOutputPath = path;
                    end
                    try
                        print(gcf(1), [ figureOutputPath ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_nospdfilt_.png'],'-dpng','-r250');
                    catch
                        print(gcf(1), [ figureOutputPath ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_nospdfilt_.png'],'-dpng','-r250');
                    end
                    plateCounter = plateCounter + 1;
                    clf(gcf(1));
                    subplotIdx = 2;
                    subplot(7,14,1);
                    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes );
                    plot(lagtimes,xcorrValues, 'k');
                    hold on;
                    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll>speedThreshold) );
                    plot(lagtimes,xcorrValues,'g'); 
                    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll<=speedThreshold) );
                    scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
                    plot(lagtimes,xcorrValues,'r'); 
                    set( gca, 'XTick', [], 'YTick', [] )
                    title('acorr SWR')    
                else
                    subplotIdx = subplotIdx + 1;
                end
               
%            else
%                warning([ ' not enough spikes w/ ' num2str(sum(cellNFast==whichCell)) ]);
%            end
        end
    end
    
    
if isempty( figureOutputPath )
    figureOutputPath = path;
end
try
    print(gcf(1), [ figureOutputPath ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_nospdfilt_.png'],'-dpng','-r250');
catch
    print(gcf(1), [ figureOutputPath ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_nospdfilt_.png'],'-dpng','-r250');
end
clf(gcf(1));

return; 
