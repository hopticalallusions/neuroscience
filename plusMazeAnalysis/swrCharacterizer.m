 %% load data

% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-22_orientation1/1.maze-habituation/';
% ttFilenames={'TT2CUTaftermerge.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
% dateStr='2016-08-22';

function swrCharacterizer( path, ratName, dateStr, swrFilename, outputPath  )
    
    if exist( [ outputPath '/' ratName '_' dateStr '_chewBruxEpisodes.mat' ] )
        load(  [ outputPath '/' ratName '_' dateStr '_chewBruxEpisodes.mat' ] );
        removeChewsReady = 1;
    else
        removeChewsReady = 0;
    end


    disp([ 'start swrCharacterizer   ' path ]);
    disp([ '   rat name              ' ratName ]);
    disp([ '   date                  ' dateStr ]);
    disp([ '   swr filename          ' swrFilename ]);
    disp([ '   output into           ' outputPath ]);

    
    
    temptext = path;
    disp( temptext );
    temptext = dateStr;
    disp( temptext );
    
    
    gcf(1)=figure(1); 
    clf(gcf(1));
    fig = gcf(1);
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 16 9]; 

    
    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
    speed=speedAll;

    speedThreshold = 10;
    
    subplot(3,4,1); plot(xpos,ypos, 'Color', [ 0 0 0 .15]); title('xy plot');
    print(gcf(1), [ outputPath '/' ratName '_' dateStr  '_swrCharacterizer_' swrFilename '.png'],'-dpng','-r250');


    
    %% SWR band

    disp( ' SWR Detection Block' )
    
    %% This is about to get crazy. There are two copies of this routine because matlab dies when the files are too long.
    %load part of the file; you always need the first timestamp
    if  strcmp( swrFilename(1:3), 'SWR');
        [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 1, 1000 );
    else
        [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ], 0, 1, 1000 );
    end

    if 0 % exist([outputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat']);
        load( [outputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat'] );
        swrPeakTimes = swrData.times;
        swrPeakValues = swrData.peaks;
        swrFilename  = swrData.file;
    else
        clear swrLfp lfpSwr lfpTimestamps
        disp( [' loading SWR LFP ' num2str( xytimestampSeconds(end))] )

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
            lfpTimestampStart = lfpTimestamps(1);
            %lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
            swrLfpEnv = abs(hilbert(swrLfp));
            swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
            % find SWR bursts
            [ swrPeakValues,      ...
              swrPeakTimestamps,       ... 
              ~, ...
              ~ ] = findpeaks( swrLfpEnv,                        ... % data
                               lfpTimestamps,                     ... % sampling frequency
                               'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                               'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
            % clear up some variables
            clear swrLfpEnv swrLfp lfpSwr;
            swrPeakTimes = (swrPeakTimestamps-lfpTimestampStart(1))/1e6;
            % save the data so we don't have to do that again.
            swrData.timestamps = swrPeakTimestamps;
            swrData.times = swrPeakTimes;
            swrData.peaks = swrPeakValues;
            swrData.file = swrFilename;
            save( [outputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat'], 'swrData' )
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
            lfpTimestampStart = lfpTimestamps(1);
            %lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
            swrLfpEnv = abs(hilbert(swrLfp));
            swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
            % find SWR bursts
            [ swrPeakValuesA,  ...
              swrPeakTimesA,   ... 
              ~, ...
              ~ ] = findpeaks( swrLfpEnv,                        ... % data
                               lfpTimestamps,                     ... % sampling frequency
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
            lfpTimestampSeconds = (lfpTimestamps-lfpTimestampStart(1))/1e6;
            swrLfpEnv = abs(hilbert(swrLfp));
            %swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
            % find SWR bursts
            [ swrPeakValuesB,      ...
              swrPeakTimesB,       ... 
              ~, ...
              ~ ] = findpeaks( swrLfpEnv,                        ... % data
                               lfpTimestamps,                     ... % sampling frequency
                               'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                               'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

            %
            clear swrLfpEnv swrLfp lfpSwr;
            %
            swrPeakTimestamps = [ swrPeakTimesA; swrPeakTimesB ];
            swrPeakTimes = (swrPeakTimestamps-lfpTimestampStart(1))/1e6;
            swrPeakValues = [ swrPeakValuesA; swrPeakValuesB ];
            %
            % save the data so we don't have to do *that* again.
            swrData.timestamps = swrPeakTimestamps;
            swrData.times = swrPeakTimes;
            swrData.peaks = swrPeakValues;
            swrData.file = swrFilename;
            save( [ outputPath '/' ratName '_' dateStr '_' swrFilename(1:end-4) '_swrData.mat' ], 'swrData' )
        end
    end
        

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
    %
    subplot(3,4,2); scatter(swrPosAll(1,:),swrPosAll(2,:), 4, 'o', 'k', 'filled'); alpha(.2); title('swr locations');
    
   
    
    
    subplot(3,4,3);
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
    
    
    
    subplot(3,4,4)
    plot( xpos, ypos, 'Color', [ 0 0 0 .15]); hold on; 
    scatter(swrPosFast(1,:), swrPosFast(2,:), 10, 'v', 'filled' ); 
    if length(swrPosFast(1,:)) < 2000 ; alpha(.1); else alpha(500/length(swrPosFast(1,:))); end; 
    scatter(1,1); % force a better color
    scatter(swrPosSlow(1,:), swrPosSlow(2,:), 10, 'o', 'filled' ); 
    if length(swrPosSlow(1,:)) < 2000 ; alpha(.1); else alpha(500/length(swrPosSlow(1,:))); end; 
    title([ 'swr plot; ' num2str(length(swrPeakTimes)) ' SWRs']);
    %
    
    subplot(3,4,5)
    binResolution = round(15*2.9); % px/bin
    xyHist = twoDHistogram( xpos, ypos, binResolution , 720, 480 );
    imagesc(log10(flipud(xyHist./29.97))); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist')
    title('log10(xy 2d hist)')
    % this is log 10 because he spends a lot of time in the bucket.
    
    
    subplot(3,4,6)
    swrXHist = twoDHistogram( swrPosAll(1,:),swrPosAll(2,:), binResolution, 720, 480 ); 
    %
    %rateMap=(cellXHist./xyHist)*29.97;
    %
    ppxy = xyHist/sum(xyHist(:)); % probability of being in place
    ppspike = swrXHist./(xyHist./30); % spike rate
    swrPlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
    swrPlaceInfo = nansum(swrPlaceInfoVector(:));
    %
    swrPlaceSparsityVector = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
    swrPlaceSparsity = nansum(swrPlaceSparsityVector(:));
    %
    temptext=[ 'swr place info = ' num2str(swrPlaceInfo) ' bits | swr sparsity = ' num2str(swrPlaceSparsity) ' | peak rate = ' num2str(max(ppspike(:))) ' Hz  | n_swr = ' num2str(length(swrPeakTimes)) ' swr ' ];
    disp( temptext );
    title('spatial info')
%    fprintf( fid, temptext ); fprintf( fid, '\n' );
%%                %
    pcolor(ppspike); colorbar; title('rough ratemap'); colormap([ 1 1 1; 0 0 0; colormap('jet')]);
    xlabel(['swr place info = ' num2str(swrPlaceInfo) ' bits']);
    ylabel(['swr sparsity = ' num2str(swrPlaceSparsity)]);
    
    subplot(3,4,5)
    xlabel([ 'peak rate = ' num2str(max(ppspike(:))) ' Hz' ]);
    ylabel([ ' n_swr = ' num2str(length(swrPeakTimes)) ' swr ' ]);
    

    subplot(3,4,7)
    histogram( real(log10(diff(swrPeakTimes).*1000)) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
    
    subplot(3,4,8)
    scatter( log10(swrPeakValues), log10(swrSpeedAll), 'o', 'filled' ); alpha(.2); title('peak val vs speed'); xlabel('log10(\muV)'); ylabel('log10(cm/s)');
    
    subplot(3,4,9:12)
    hold off;
    yyaxis left;
    %scatter( cellTimesAllSeconds(cellNumber==whichCell), -1*rand(length(cellTimesAllSeconds(cellNumber==whichCell)),1), 2, 'k', 'filled'  ); alpha(.01);
    hold on;
    plot(xytimestampSeconds, xpos, '--', 'Color', [ .7 .2 .2 ]); 
    plot(xytimestampSeconds, ypos, '--', 'Color', [ .1 .2 .7 ]);  
    plot(xytimestampSeconds, speed, 'Color', [ .1 .7 .2 ]);
    yyaxis right;
    scatter( swrPeakTimes, log10(swrPeakValues), 5, 'k', 'filled'  ); alpha(.2); %*10000/sum(cellNumber==whichCell));
    %ylim([ -5 130 ]);
    xlim( [ 0 xytimestampSeconds(end) ] );
    
     
     
 if isempty( outputPath )
     outputPath = path;
 end
 
     print(gcf(1), [ outputPath '/' ratName '_' dateStr  '_swrCharacterizer_' swrFilename '.png'],'-dpng','-r250');
 
     clf(gcf(1));

     %%
     
     disp ( 'removing chew noise' )
    if removeChewsReady > 0
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
        swrPeakTimesDeNoise = swrPeakTimes(validSwrs);
        swrPeakValuesDeNoise = swrPeakValues(validSwrs);

        disp ([ ' removed '  num2str( length(swrPeakTimesDeNoise) - length(swrPeakTimes) ) ])
        disp('build SWR Position data');
        
        
        % build some structures for later SWR analysis
        swrPosAllDeNoise=zeros(2,length(swrPeakTimesDeNoise));
        swrSpeedAllDeNoise=zeros(1,length(swrPeakTimesDeNoise));
        for ii=1:length(swrPeakTimesDeNoise)
            tempIdx=find(swrPeakTimesDeNoise(ii)<=xytimestampSeconds, 1 );
            if ~isempty(tempIdx)
                swrPosAllDeNoise(1,ii) = xpos (tempIdx);
                swrPosAllDeNoise(2,ii) = ypos (tempIdx);
                swrSpeedAllDeNoise(ii) = speed (tempIdx);
            end
        end
        swrPosFastDeNoise=swrPosAll(:,swrSpeedAllDeNoise>speedThreshold);
        swrPosSlowDeNoise=swrPosAll(:,swrSpeedAllDeNoise<=speedThreshold);
        
  
    subplot(3,4,1); plot(xpos,ypos, 'Color', [ 0 0 0 .15]); title('xy plot');
    
    
    subplot(3,4,2); scatter(swrPosAllDeNoise(1,:),swrPosAllDeNoise(2,:), 4, 'o', 'k', 'filled'); alpha(.2); title('swr locations');
    
    
    subplot(3,4,3);
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimesDeNoise );
    plot(lagtimes,xcorrValues, 'k');
    hold on;
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAllDeNoise>speedThreshold) );
    plot(lagtimes,xcorrValues,'g'); 
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAllDeNoise<=speedThreshold) );
    scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
    plot(lagtimes,xcorrValues,'r'); 
    %
    threshold = prctile( swrPeakValuesDeNoise, 25)
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimesDeNoise(swrPeakValuesDeNoise>threshold) );
    plot(lagtimes,xcorrValues, '--');
    threshold = prctile( swrPeakValuesDeNoise, 50)
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimesDeNoise(swrPeakValuesDeNoise>threshold) );
    plot(lagtimes,xcorrValues, '--');
    threshold = prctile( swrPeakValuesDeNoise, 75)
    [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimesDeNoise(swrPeakValuesDeNoise>threshold) );
    plot(lagtimes,xcorrValues, '--');
    
    set( gca, 'XTick', [], 'YTick', [] )
    title('acorr SWR')
    
    
    
    subplot(3,4,4)
    plot( xpos, ypos, 'Color', [ 0 0 0 .15]); hold on; 
    scatter(swrPosFastDeNoise(1,:), swrPosFastDeNoise(2,:), 10, 'v', 'filled' ); 
    if length(swrPosFastDeNoise(1,:)) < 2000 ; alpha(.1); else alpha(500/length(swrPosFastDeNoise(1,:))); end; 
    scatter(1,1); % force a better color
    scatter(swrPosSlowDeNoise(1,:), swrPosSlowDeNoise(2,:), 10, 'o', 'filled' ); 
    if length(swrPosSlowDeNoise(1,:)) < 2000 ; alpha(.1); else alpha(500/length(swrPosSlowDeNoise(1,:))); end; 
    title([ 'swr plot; ' num2str(length(swrPeakTimesDeNoise)) ' SWRs']);
    %
    
    subplot(3,4,5)
    binResolution = round(15*2.9); % px/bin
    xyHist = twoDHistogram( xpos, ypos, binResolution , 720, 480 );
    imagesc(log10(flipud(xyHist./29.97))); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist')
    title('log10(xy 2d hist)')
    % this is log 10 because he spends a lot of time in the bucket.
    
    
    subplot(3,4,6)
    swrXHist = twoDHistogram( swrPosAllDeNoise(1,:),swrPosAllDeNoise(2,:), binResolution, 720, 480 ); 
    %
    %rateMap=(cellXHist./xyHist)*29.97;
    %
    ppxy = xyHist/sum(xyHist(:)); % probability of being in place
    ppspike = swrXHist./(xyHist./30); % spike rate
    swrPlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
    swrPlaceInfo = nansum(swrPlaceInfoVector(:));
    %
    swrPlaceSparsityVector = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
    swrPlaceSparsity = nansum(swrPlaceSparsityVector(:));
    %
    temptext=[ 'swr place info = ' num2str(swrPlaceInfo) ' bits | swr sparsity = ' num2str(swrPlaceSparsity) ' | peak rate = ' num2str(max(ppspike(:))) ' Hz  | n_swr = ' num2str(length(swrPeakTimes)) ' swr ' ];
    disp( temptext );
    title('spatial info')
%    fprintf( fid, temptext ); fprintf( fid, '\n' );
%%                %
    pcolor(ppspike); colorbar; title('rough ratemap'); colormap([ 1 1 1; 0 0 0; colormap('jet')]);
    xlabel(['swr place info = ' num2str(swrPlaceInfo) ' bits']);
    ylabel(['swr sparsity = ' num2str(swrPlaceSparsity)]);
    
    subplot(3,4,5)
    xlabel([ 'peak rate = ' num2str(max(ppspike(:))) ' Hz' ]);
    ylabel([ ' n_swr = ' num2str(length(swrPeakTimesDeNoise)) ' swr ' ]);
    

    subplot(3,4,7)
    histogram( real(log10(diff(swrPeakTimesDeNoise).*1000)) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
    
    subplot(3,4,8)
    scatter( log10(swrPeakValuesDeNoise), log10(swrSpeedAllDeNoise), 'o', 'filled' ); alpha(.2); title('peak val vs speed'); xlabel('log10(\muV)'); ylabel('log10(cm/s)');
    
    subplot(3,4,9:12)
    hold off;
    yyaxis left;
    %scatter( cellTimesAllSeconds(cellNumber==whichCell), -1*rand(length(cellTimesAllSeconds(cellNumber==whichCell)),1), 2, 'k', 'filled'  ); alpha(.01);
    hold on;
    plot(xytimestampSeconds, xpos, '--', 'Color', [ .7 .2 .2 ]); 
    plot(xytimestampSeconds, ypos, '--', 'Color', [ .1 .2 .7 ]);  
    plot(xytimestampSeconds, speed, 'Color', [ .1 .7 .2 ]);
    yyaxis right;
    scatter( swrPeakTimesDeNoise, log10(swrPeakValuesDeNoise), 5, 'k', 'filled'  ); alpha(.2); %*10000/sum(cellNumber==whichCell));
    %ylim([ -5 130 ]);
    xlim( [ 0 xytimestampSeconds(end) ] );
    
     
     
 if isempty( outputPath )
     outputPath = path;
 end
 
     print(gcf(1), [ outputPath '/' ratName '_' dateStr  '_swrCharacterizer_Denoised_' swrFilename '.png'],'-dpng','-r250');
 
     clf(gcf(1));
        
        
        
        
        
        
        
        
    end
    
     
     
     
     
     
     
     
     
     
     
     
     
     
return; 
