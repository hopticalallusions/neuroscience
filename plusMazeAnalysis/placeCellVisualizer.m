
% list to edit for TTs
% 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT11a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT14a.NTT' 'TT15a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT18a.NTT' 'TT19a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT23a.NTT' 'TT24a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 'TT30a.NTT' 'TT31a.NTT' 'TT32a.NTT'


function placeCellVisualizer( path, ratName, ttFilenames, dateStr, thetaFilename, swrFilename, rotationalParameters, behaviorData, outputPath )


    disp([ 'start cellSwrXcorrMassive ' ] )
    disp([ '   path                   ' path ]);
    disp([ '   rat name               ' ratName ]);
    disp([ '   date                   ' dateStr ]);
    disp([ '   swr filename           ' swrFilename ]);
    disp([ '   output into            ' outputPath ]);


%% Load chewing and Bruxing information.
    if exist( [ outputPath '/' ratName '_' dateStr '_chewBruxEpisodes.mat' ] )
        load(  [ outputPath '/' ratName '_' dateStr '_chewBruxEpisodes.mat' ] );
        removeChewsReady = 1;
    else
        removeChewsReady = 0;
    end

%% load movement initiation data
    
    if exist( [ '/Users/andrewhowe/src/MATLAB/defaultFolder' '/' 'movInitv3.mat' ] )
        load( [ '/Users/andrewhowe/src/MATLAB/defaultFolder' '/' 'movInitv3.mat' ] );
        movInitDataLoaded = 1;
        
        % this is stupid...
        initMovementEpisodeTimes=[];
        for ii = 1:length(movInitBlob.goTrigRatLabel)
            if strcmp( movInitBlob.goTrigRatLabel{ii}, ratName)
                if strcmp( movInitBlob.goTrigSession{ii}, dateStr)
                    initMovementEpisodeTimes = [ initMovementEpisodeTimes movInitBlob.goTrigTime(ii) ];
                end
            end
        end

        stopMovementEpisodeTimes=[];
        for ii = 1:length(movInitBlob.goTrigRatLabel)
            if strcmp( movInitBlob.goTrigRatLabel{ii}, ratName)
                if strcmp( movInitBlob.goTrigSession{ii}, dateStr)
                    stopMovementEpisodeTimes = [ stopMovementEpisodeTimes movInitBlob.stopTrigTime(ii) ];
                end
            end
        end
        
    else
        movInitDataLoaded = 0;
    end
        


%%
    if isempty(ttFilenames)
        ttFilenames = dir( [path 'TT*']);
        tetrodeExtension = '.ntt';
    end
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*a.ntt']);
        tetrodeExtension = '.ntt';
    end
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
    

    fid=fopen([ path '/clusterdata.log' ],'w');
    
    subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

    speedThreshold = 10; % cm/s

    if exist([path '/position.mat'],'file');
        load([path '/position.mat'])        
        %xpos=median([ position.xGpos; position.xRpos ]);
        %ypos=median([ position.yGpos; position.yRpos ]);
        xpos=median([ position.xGpos; position.xRpos ]);
        ypos=median([ position.yGpos; position.yRpos ]);
        xytimestampSeconds = (0:length(ypos)-1)/29.97;
        [ ~, ~, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
    else
        [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
        xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    end    
    speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
    speed=speedAll;

    gcf(1)=figure(1); 
    clf(gcf(1));
    subplot(3,5,1); hold off; plot(xpos,ypos);
    [xrpos,yrpos]=rotateXYPositions(xpos,ypos,rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
    % not a great plan...
    xrpos(xrpos<1) = 1;
    yrpos(yrpos<1) = 1;
    % 
    subplot(3,5,2); plot(xrpos,yrpos);
%    subplot(3,5,3); hold off; histogram(speed,0:100); hold on; histogram(speedAll,0:100); hold on;

    binResolution = round(15*2.9); % px/bin


    

    
    
    
    
    
    
    %% This is about to get crazy. There are two copies of this routine because matlab dies when the files are too long.
    %load part of the file; you always need the first timestamp
    if  strcmp( swrFilename(1:3), 'SWR');
        [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 1, 1000 );
    else
        [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 1, 1000 );
    end

    storedSwrFileName =  [ outputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat' ];
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
            firstTimestamp = lfpTimestamps(1);
            lfpTimestampSeconds = (lfpTimestamps-firstTimestamp)/1e6;
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
            save( [ outputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat' ], 'swrData' )
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
                [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 1, 32000*60*60 );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) <= 0
                    disp('suspicious timestamps hr 1 SWR*ncs; I fixed them!')
                    [lfpTimestamps,idxUniq,~]=unique(lfpTimestamps);
                    swrLfp=swrLfp(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    swrLfp=swrLfp(idx);
                end
            else
                [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 1, 32000*60*60 );
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
            firstTimestamp = lfpTimestamps(1);
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
                [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 32000*60*60+1, xytimestampSeconds(end)*32000+10 );
                % data can get out of order and repeated.
                if min(diff(lfpTimestamps)) <= 0
                    disp('suspicious timestamps hr 2 SWR*ncs; I fixed them!')
                    [lfpTimestamps,idxUniq,idxAll]=unique(lfpTimestamps);
                    swrLfp=swrLfp(idxUniq);
                    [lfpTimestamps, idx] = sort(lfpTimestamps);
                    swrLfp=swrLfp(idx);
                end
            else
                [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 32000*60*60+1, xytimestampSeconds(end)*32000+10 );
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
            lfpTimestampSeconds = (lfpTimestamps-firstTimestamp(1))/1e6;
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
    fprintf( fid, temptext ); fprintf( fid, '\n' );

    temptext = dateStr;
    disp( temptext );
    fprintf( fid, temptext ); fprintf( fid, '\n' );


    for ttIdx=1:length(ttFilenames)

        try
            [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            %[ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            thisTtFilename = ttFilenames{ttIdx};
            disp( thisTtFilename );
            fprintf( fid, thisTtFilename ); fprintf( fid, '\n' );
        catch
            [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            %[ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            thisTtFilename = ttFilenames(ttIdx).name;
            disp( thisTtFilename );
            fprintf( fid, thisTtFilename ); fprintf( fid, '\n' );
        end
        
        cellPosAll = zeros(2,length(spiketimes));   % row 1 is X, row 2 is Y
        cellSpeedAll = zeros(1,length(spiketimes)); % collect all the speeds
        cellTimesAll = zeros(1,length(spiketimes));
        for ii=1:length(spiketimes)
            tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
                if ~isempty(tempIdx)
                    cellPosAll(1,ii) = xrpos (tempIdx);
                    cellPosAll(2,ii) = yrpos (tempIdx);
                    cellSpeedAll(ii) = speed (tempIdx);
                    cellTimesAll(ii) = spiketimes(ii);
                end
        end
        cellTimesAllSeconds = (cellTimesAll-firstTimestamp)/1e6;
        % simple speed filter hack
        cellPosFast = cellPosAll(:,cellSpeedAll>speedThreshold);
        cellNFast = cellNumber(cellSpeedAll>speedThreshold);
        cellTimesFast = cellTimesAll(cellSpeedAll>speedThreshold);
        cellTimesFastSeconds = (cellTimesFast-firstTimestamp)/1e6;
        %
        cellPosSlow = cellPosAll(:,cellSpeedAll<=speedThreshold);
        cellNSlow = cellNumber(cellSpeedAll<=speedThreshold);
        cellTimesSlow = cellTimesAll(cellSpeedAll<=speedThreshold);
        cellTimesSlowSeconds = (cellTimesSlow-firstTimestamp)/1e6;
        %
        for whichCell=0:max(cellNumber)
            if sum(cellNFast==whichCell) < 50e3
%%                %
                figure(gcf(1)); clf;
                subplot(4,5,16:20 );
                hold off;
                yyaxis right;
                %scatter( cellTimesAllSeconds(cellNumber==whichCell), -1*rand(length(cellTimesAllSeconds(cellNumber==whichCell)),1), 2, 'k', 'filled'  ); alpha(.01);
                hold on;
                plot(xytimestampSeconds, xpos, 'Color', [ .7 .2 .2 ]); 
                plot(xytimestampSeconds, ypos, 'Color', [ .1 .2 .7 ]);  
                yyaxis left;
                plot(xytimestampSeconds, speed, 'Color', [ .1 .7 .2 ]);
                %xtemp = (cellTimesAllSeconds(cellNumber==whichCell)); xtemp=xtemp(1:end-1)+((xtemp(2)-xtemp(1))/2);
                %ytemp = 1./diff(cellTimesAllSeconds(cellNumber==whichCell));
                % plot( xtemp, ytemp );
                scatter( cellTimesAllSeconds(cellNumber==whichCell), -5*rand(length(cellTimesAllSeconds(cellNumber==whichCell)),1), 5, 'k', 'filled'  ); alpha(.2); %*10000/sum(cellNumber==whichCell));
                ylim([ -5 130 ]);
                scatter( behaviorData.timeToMazeSec,  zeros(1,length(behaviorData.timeToMazeSec)), 'v', 'filled', 'MarkerFaceColor', [ .1 .8 .7 ] );  
                scatter( behaviorData.timeToJump1Sec, zeros(1,length(behaviorData.timeToMazeSec)), '*' );
                scatter( behaviorData.timeToSugarSec, zeros(1,length(behaviorData.timeToMazeSec)), 'o', 'filled');
                scatter( behaviorData.timeToSugarSec, -1*behaviorData.madeError, 'o', 'filled');
                scatter( behaviorData.timeToBucketSec, zeros(1,length(behaviorData.timeToMazeSec)), '^', 'filled', 'r');
                oo=histogram(cellTimesAllSeconds(cellNumber==whichCell), 0:max(xytimestampSeconds) );
                plot( 0:max(xytimestampSeconds), oo, 'k' )
                xlim([ 0 max(xytimestampSeconds) ])
%%              %
                %
                subplot(4,5,7)
                binResolution = round(15*2.9); % px/bin
                xyHist = twoDHistogram( xrpos(speed>speedThreshold), yrpos(speed>speedThreshold), binResolution , 700, 700 );
                pcolor(log10(flipud(xyHist./29.97))); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist')
                title('log10(xy 2d hist)')
                %
                cellXHist = twoDHistogram( cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), binResolution, 700, 700 ); 
                %
                %rateMap=(cellXHist./xyHist)*29.97;
                %
                ppxy = xyHist/sum(xyHist(:)); % probability of being in place
                ppspike = cellXHist./(xyHist./30); % spike rate
                spikePlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
                spikePlaceInfo = nansum(spikePlaceInfoVector(:));
                %
                spikePlaceSparsityVector = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
                spikePlaceSparsity = nansum(spikePlaceSparsityVector(:));
                %
                temptext=[ thisTtFilename ' | cell ' num2str(whichCell) ' | place info = ' num2str(spikePlaceInfo) ' bits | spike sparsity = ' num2str(spikePlaceSparsity) ' | peak firing rate = ' num2str(max(ppspike(:))) ' Hz  | n_fast = ' num2str(sum(cellNFast==whichCell)) ' spikes  | n_all = ' num2str(sum(cellNumber==whichCell)) ' spikes ' ];
                disp( temptext );
                fprintf( fid, temptext ); fprintf( fid, '\n' );
%%                %
                subplot(4,5,14); pcolor(ppspike);  colormap([ 1 1 1; 0 0 0; colormap('jet')]); colormap('jet');   colorbar; title('rough ratemap'); %hold off;% imagesc(flipud(xyHist>0));
                % plot cell autocorrelegrams
                subplot(4,5,1); hold off
                [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell) );
                plot( lagtimes, xcorrValues, 'k' ); 
                hold on;
                [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell) );
                plot( lagtimes, xcorrValues, 'r' ); 
                [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell) );
                plot( lagtimes, xcorrValues, 'g' ); 
                title('spk autocorrelegram')
%% 
                subplot(4,5,[4 5 9 10]); hold off;
                plot(xrpos,yrpos, 'Color', [ 0 0 0 .15]); hold on; 
                scatter(cellPosSlow(1,(cellNSlow==whichCell)), cellPosSlow(2,(cellNSlow==whichCell)), 20, '.' ); 
                if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
                scatter(cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), 20, 'o', 'filled' ); 
                if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
                xlim([0 825]); ylim([0 650]); 
                title([ 'trace plot; ' num2str(sum(cellNFast==whichCell)) ' n fast spk; ' num2str(sum(cellNumber==whichCell)) ' n spks '  ratName ' ' dateStr]);
%%
                subplot(4,5,2); hold off; histogram( real(log10(diff(cellTimesAllSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
                legend([ num2str(sum(cellNumber==whichCell)) ' spks' ] )
%%              % plot waveforms
                temp=(spikeWaveforms((cellNumber==whichCell),:,:)); ttYLims=[ min(temp(:)) max(temp(:)) ]; 
                subplot(4,5,3); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); %xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]); 
                %    tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
                subplot(4,5,3); hold on; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:));% xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);  
                %   tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
                subplot(4,5,3); hold on; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:));% xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);  
                %   tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
                subplot(4,5,3); hold on; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);  
                %   tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
                %subplot(1,2,1); imagesc(flipud(cellXHist)); colormap([ 1 1 1; colormap('jet')]); colorbar; title('cell spike X place (n)');
%%
                subplot(4,5,15); hold off; toPlot=twoDGuassianSmooth(ppspike); pcolor(toPlot); colormap('jet'); 
                toPlotFlat=toPlot(:); 
                %caxis([ min(toPlotFlat(toPlotFlat>0))-.0001 max(toPlot(:)) ] ); 
                colorbar; 
                title(['smooth ratemap | info=' num2str(spikePlaceInfo)]); 
                ylabel(['peakRate=' num2str(max(ppspike(:))) ' Hz'])
                  % imagesc(flipud(plotppspike)); colormap([ 1 1 1; 0 0 0; colormap('jet')]);  
                colormap([ 1 1 1; 0 0 0; colormap('jet')]);
%%                % plot swr X cell firing
                subplot(4,5,7);  hold off;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes );
                plot(lagtimes,xcorrValues, 'k'); % ylim([0 max(xcorrValues)]); % assume that all will have the max?
                hold on;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), swrPeakTimes(swrSpeedAll>speedThreshold) );
                plot(lagtimes,xcorrValues,'g'); 
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), swrPeakTimes(swrSpeedAll<=speedThreshold) );
                scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
                plot(lagtimes,xcorrValues,'r'); 
                title('swr Xcorr spike');
%%                %
%                 try
%                     subplot(4,5,3); hold off;
%                     rose(thetaPhase(floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1),36);
%                     hold on;
%                     rose(thetaPhase(floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1),36);
%                     rose(thetaPhase(floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1),36);
%                     title('\Theta phase')
%                 catch
%                     subplot(4,5,3); hold off;
%                     tidx=floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1; tidx=tidx(tidx>0);
%                     rose(thetaPhase(tidx),36);
%                     hold on;
%                     tidx=floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1; tidx=tidx(tidx>0);
%                     rose(thetaPhase(tidx),36);
%                     tidx=floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1; tidx=tidx(tidx>0);
%                     rose(thetaPhase(tidx),36);
%                     title('\Theta phase');
%                     subplot(4,5,3); rose(thetaPhase(tidx),36); title('\Theta phase')
%                     warning(['removed ' num2str(sum(tidx>0)) ' entries from rose plot'])
%                 end
%%                %%%
%                 subplot( 4, 5, 6); hold off;
%                 [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), hiGammaPeakTimes );
%                 plot( lagtimes, xcorrValues, 'k' ); % ylim([0 max(xcorrValues)]); % assume that all will have the max?
%                 hold on;
%                 [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), hiGammaPeakTimes(hiGammaSpeedAll>speedThreshold) );
%                 plot( lagtimes, xcorrValues, 'g' ); 
%                 [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), hiGammaPeakTimes(hiGammaSpeedAll<=speedThreshold) );
%                 scatter( 0, 0, 1, '.', 'k' ); alpha(.01); % hack to force to zero.
%                 plot( lagtimes, xcorrValues, 'r' ); 
%                 title('hi \gamma Xcorr spike');
%                 %
%%
                windowSize = 6;
                divisionSize = 0.5;
                pethX = -windowSize:divisionSize:windowSize;
                %
                subplot(4,5,8);
                oo=periEventtimeHistogram( behaviorData.timeToMazeSec, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot(pethX,oo,'k');hold on;
                oo=periEventtimeHistogram( [ behaviorData.timeToMazeSec(behaviorData.madeError>0) ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'Color', [ .7 .1 .1 ]);
                oo=periEventtimeHistogram( [ behaviorData.timeToMazeSec(behaviorData.madeError<1) ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'Color', [ .1 .7 .1 ] );
                title('PETH start');
                xlim([-windowSize windowSize]);
                %
                subplot(4,5,11);
                oo=periEventtimeHistogram( [ behaviorData.timeToJump1Sec behaviorData.timeToJump2Sec], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot(pethX,oo,'k'); hold on;
                oo=periEventtimeHistogram( [ behaviorData.timeToJump1Sec(behaviorData.madeError>0) behaviorData.timeToJump2Sec(behaviorData.madeError>0) ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'Color', [ .9 .1 .1 ]);
                oo=periEventtimeHistogram( [ behaviorData.timeToJump1Sec(behaviorData.madeError<1) behaviorData.timeToJump2Sec(behaviorData.madeError<1) ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'Color', [ .1 .9 .1 ] );
                oo=periEventtimeHistogram( [ behaviorData.timeToJump1Sec ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'Color', [ .9 .1 .9 ] );
                oo=periEventtimeHistogram( [ behaviorData.timeToJump2Sec ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'Color', [ .1 .1 .9 ] );
                title('PETH jump');
                xlim([-windowSize windowSize]);
                %
                subplot(4,5,12);
                hold off;
                oo=periEventtimeHistogram( behaviorData.timeToSugarSec, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'k'); hold on;
                oo=periEventtimeHistogram( behaviorData.timeToSugarSec(behaviorData.madeError>0), cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'r');
                oo=periEventtimeHistogram( behaviorData.timeToSugarSec(behaviorData.madeError<1), cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'g');
                title('PETH reward');
                xlim([-windowSize windowSize]);
                %
                subplot(4,5,13);
                % could also do max([ behaviorData.timeToBucketSec; behaviorData.timeToContRetSec])
                oo=periEventtimeHistogram( [ behaviorData.timeToBucketSec behaviorData.timeToContRetSec ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot(pethX,oo,'k'); hold on;
                oo=periEventtimeHistogram( [ behaviorData.timeToBucketSec(behaviorData.madeError>0) behaviorData.timeToContRetSec(behaviorData.madeError>0) ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'r');
                oo=periEventtimeHistogram( [ behaviorData.timeToBucketSec(behaviorData.madeError<1) behaviorData.timeToContRetSec(behaviorData.madeError<1) ], cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                plot( pethX, oo, 'g');
                title('PETH end');
                xlim([-windowSize windowSize]);
                
                if (movInitDataLoaded > 0)
                    subplot(4,5,6);
                    % could also do max([ behaviorData.timeToBucketSec; behaviorData.timeToContRetSec])
                    hold off;
                    oo=periEventtimeHistogram( stopMovementEpisodeTimes, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                    plot( pethX, oo, 'r'); hold on;
                    oo=periEventtimeHistogram( initMovementEpisodeTimes, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                    plot( pethX, oo, 'g');
                    title('PETH mov go/stop');
                    xlim([-windowSize windowSize]);
                end
%%                
                try
                    print(gcf(1), [ path ratName '_cellSessionInfo_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                catch
                    print(gcf(1), [ path ratName '_cellSessionInfo_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                end
                clf(gcf(1));
            else
                disp( 'Rejected for too many spikes in this cluster.' )
            end

        end
    end

fclose(fid);

return; 
