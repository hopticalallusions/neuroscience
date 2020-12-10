 %% load data

% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-22_orientation1/1.maze-habituation/';
% ttFilenames={'TT2CUTaftermerge.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
% dateStr='2016-08-22';

%placeCellScreenerFxn(dir,ttFilenames,dateStr)

% list to edit for TTs
% 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT11a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT14a.NTT' 'TT15a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT18a.NTT' 'TT19a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT23a.NTT' 'TT24a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 'TT30a.NTT' 'TT31a.NTT' 'TT32a.NTT'



% path='/Volumes/AHOWETHESIS/h7/2018-09-05_17-04-14/';
% ratName = 'h7';
% ttFilenames={ 'TT12a.NTT' }
% dateStr='2018-09-05';
% thetaFilename='CSC84.ncs';
% swrFilename='CSC56.ncs';  % 36 56  
% rotationalParameters.centerX = 370;
% rotationalParameters.centerY = 255;
% rotationalParameters.degToRotate = 48;
% rotationalParameters.xoffset = 300;
% rotationalParameters.yoffset = 300;
% behaviorData.trial           = [	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44 ];
% 
% behaviorData.timeToMazeSec   = [	348	475	568	643	742	814	912	996 	1096	1180	1296	1461	1584	1648	1699	1754	1813	1890	1978	2092	2153	2222	2323	2394	2500	2569	2666	2732	2859	2938	3046	3154	3282	3375	3435	3536	3604	3706	3813	3934	4040	4156	4295	4419 ];
% behaviorData.timeToJump1Sec  = [	416	481	573	650	748	819	918	1001	1100	1185	1300	1468	1589	1651	1705	1760	1834	1923	1992	2100	2173	2241	2344	2401	2515	2577	2678	2772	2881	2945	3063	3171	3287	3380	3440	3543	3612	3738	3820	3950	4058	4161	4861	4423 ];
% behaviorData.timeToSugarSec  = [	418	483	575	652	750	821	919	1002	1102	1187	1302	1470	1591	1653	1708	1762	1836	1925	1994	2101	2175	2243	2345	2402	2517	2578	2680	2775	2883	2947	3065	3174	3289	3383	3442	3545	3614	3741	3823	3951	4060	4163	4322	4424 ];
% behaviorData.timeToBucketSec = [	428	497	593	665	767	839	930	1021	1109	1220	1317	1516	1600	1657	1712	1767	1843	1931	2020	2104	2177	2257	2349	2412	2522	2598	2684	2783	2889	2963	3077	3211	3303	3416	3458	3549	3629	3746	3850	3966	4079	4172	4344	4450 ];
% 
% behaviorData.madeError       = [	1	0	1	0	1	0	0	0	0	0	0	0	1	1	1	1	1	1	0	1	1	0	1	0	1	0	1	0	1	0	0	0	0	1	0	1	0	1	0	0	0	0	0	0 ];
% behaviorData.barrierHeight   = [	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15 ];
% 



function placeCellVisualizer( path, ratName, ttFilenames, dateStr, thetaFilename, swrFilename, rotationalParameters, behaviorData )



%%
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

    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
    speed=speedAll;

    gcf(1)=figure(1); 
    subplot(2,2,1); hold off; plot(xpos,ypos);
    [xrpos,yrpos]=rotateXYPositions(xpos,ypos,rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
    % not a great plan...
    xrpos(xrpos<1) = 1;
    yrpos(yrpos<1) = 1;
    % 
    subplot(2,2,3); plot(xrpos,yrpos);
    subplot(2,2,2); hold off; histogram(speed,0:100); hold on; histogram(speedAll,0:100); hold on;

    try
        print(gcf(1), [ path ratName '_positionPlot1_' dateStr '_.png'],'-dpng','-r200');
    catch
        print(gcf(1), [ path ratName '_positionPlot1_' dateStr '_.png'],'-dpng','-r200');
    end

    binResolution = round(15*2.9); % px/bin

    % if the rat is in the bucket, adjust the speed such that he is below
    % the speed threshold. (these are mutually exclusive positions, so add them
    % together.ç
    %inBucket = (distFromPoint( xrpos,yrpos, bucketCoordinate(1,1), bucketCoordinate(1,2) )<bucketRadius(1)) + (distFromPoint( xrpos,yrpos, bucketCoordinate(2,1), bucketCoordinate(2,2) )<bucketRadius(2));

    if (behaviorData.timeToMazeSec(1) > 0)
        segmentStartIdx = 1;
        segmentEndIdx = floor(behaviorData.timeToMazeSec(1)*29.97);
    end
    inBucket(segmentStartIdx:segmentEndIdx) = 1;
    for ii=2:length(behaviorData.timeToMazeSec)
        segmentStartIdx =  floor(behaviorData.timeToBucketSec(ii-1)*29.97);
        segmentEndIdx = floor(behaviorData.timeToMazeSec(ii)*29.97);
        inBucket(segmentStartIdx:segmentEndIdx) = 1;
    end
    segmentStartIdx = floor(behaviorData.timeToBucketSec(ii)*29.97);
    inBucket(segmentStartIdx:end) = 1;
    %
    speed(inBucket>0) = speedAll(inBucket>0)/10;

    makeFilters;

    [ lfpTheta, lfpTimestamps ]=csc2mat( [ path thetaFilename ] );
    lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
    thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
    thetaPhase = angle(hilbert(thetaLfp));

    %% SWR band

    % tt10, tt22 - swr  ch56; ch84; ch92; ch44; ch40; ch60; ch64
    [ lfpSwr ]=csc2mat( [ path swrFilename ] );
    swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article

    swrLfp = filtfilt( swrFilter, lfpSwr );
    swrLfpEnv = abs(hilbert(swrLfp));

    swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

    [swrPeakValues,      ...
     swrPeakTimes,       ... 
     swrPeakProminances, ...
     swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                  lfpTimestampSeconds,                     ... % sampling frequency
                                  'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                  'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

    % build some structures for later SWR analysis
    swrPosAll=zeros(2,length(swrPeakTimes));
    swrSpeedAll=zeros(1,length(swrPeakTimes));
    for ii=1:length(swrPeakTimes)
        tempIdx=find(swrPeakTimes(ii)<=xytimestampSeconds, 1 );
        if ~isempty(tempIdx)
            swrPosAll(1,ii) = xrpos (tempIdx);
            swrPosAll(2,ii) = yrpos (tempIdx);
            swrSpeedAll(ii) = speed (tempIdx);
        end
    end
    swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
    swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);
    %

    %% high gamma

    hiGammaFilter    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   85, 'HalfPowerFrequency2',  160, 'SampleRate', 32000); % Sullivan, Csicsvari ... Buzsaki, J Neuro 2011; Fig 1D

    hiGammaLfp = filtfilt( hiGammaFilter, lfpSwr );
    hiGammaLfpEnv = abs(hilbert(hiGammaLfp));

    hiGammaThreshold = mean(hiGammaLfpEnv) + ( 3  * std(hiGammaLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

    [hiGammaPeakValues,      ...
     hiGammaPeakTimes,       ... 
     hiGammaPeakProminances, ...
     hiGammaPeakWidths ] = findpeaks( hiGammaLfpEnv,                        ... % data
                                  lfpTimestampSeconds,                     ... % sampling frequency
                                  'MinPeakHeight',  hiGammaThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                  'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

    % build some structures for later SWR analysis
    hiGammaPosAll=zeros(2,length(hiGammaPeakTimes));
    hiGammaSpeedAll=zeros(1,length(hiGammaPeakTimes));
    for ii=1:length(hiGammaPeakTimes)
        tempIdx=find(hiGammaPeakTimes(ii)<=xytimestampSeconds, 1 );
        if ~isempty(tempIdx)
            hiGammaPosAll(1,ii) = xrpos (tempIdx);
            hiGammaPosAll(2,ii) = yrpos (tempIdx);
            hiGammaSpeedAll(ii) = speed (tempIdx);
        end
    end
    hiGammaPosFast=hiGammaPosAll(:,hiGammaSpeedAll>speedThreshold);
    hiGammaPosSlow=hiGammaPosAll(:,hiGammaSpeedAll<=speedThreshold);


    gcf(2)=figure(2);




    %% PLOTTING ROUTINES

    xyHist = twoDHistogram( xrpos(speed>speedThreshold), yrpos(speed>speedThreshold), binResolution , 650, 650 );
    subplot(2,2,3); hold off; plot(xrpos,yrpos); ylim([0 650]); xlim([0 650]); title('xy position'); hold on; scatter(xrpos(speed>speedThreshold),yrpos(speed>speedThreshold), '.');
    subplot(2,2,4); hold off; imagesc(flipud(xyHist./29.97)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist[<speed]')

    try
        print(gcf(1), [ path ratName '_positionPlot_' dateStr  '_.png'],'-dpng','-r200');
    catch
        print(gcf(1), [ path ratName '_positionPlot_' dateStr  '_.png'],'-dpng','-r200');
    end


    %%
    figure;
    pcolor((xyHist)); colormap('jet');  colorbar; title('occupany'); %colormap([ 1 1 1; 0 0 0; colormap('jet')]); 



    %% SWR map  should make a SWR figure
    figure; hold off;
    plot( xrpos, yrpos, 'Color', [ 0 0 0 .15]); hold on; 
    %scatter(swrPosAll(1,:), swrPosAll(2,:), 20, 'o', 'filled' ); 
    %if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
    scatter(swrPosFast(1,:), swrPosFast(2,:), 10, 'x' ); 
    if length(swrPosFast(1,:)) < 2000 ; alpha(.2); else alpha(500/length(swrPosFast(1,:))); end; 
    scatter(swrPosSlow(1,:), swrPosSlow(2,:), 10, 'o', 'filled' ); 
    if length(swrPosSlow(1,:)) < 2000 ; alpha(.2); else alpha(500/length(swrPosSlow(1,:))); end; 
    xlim([0 825]); ylim([0 650]); title([ 'trace plot; ' num2str(length(swrPeakTimes)) ' SWRs']);
    %


    temptext = path;
    disp( temptext );
    fprintf( fid, temptext ); fprintf( fid, '\n' );

    temptext = dateStr;
    disp( temptext );
    fprintf( fid, temptext ); fprintf( fid, '\n' );


    for ttIdx=1:length(ttFilenames)

        try
 %           [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            thisTtFilename = ttFilenames{ttIdx};
            disp( thisTtFilename );
            fprintf( fid, thisTtFilename ); fprintf( fid, '\n' );
        catch
            %[ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
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
        cellTimesAllSeconds = (cellTimesAll-lfpTimestamps(1))/1e6;
        % simple speed filter hack
        cellPosFast = cellPosAll(:,cellSpeedAll>speedThreshold);
        cellNFast = cellNumber(cellSpeedAll>speedThreshold);
        cellTimesFast = cellTimesAll(cellSpeedAll>speedThreshold);
        cellTimesFastSeconds = (cellTimesFast-lfpTimestamps(1))/1e6;
        %
        cellPosSlow = cellPosAll(:,cellSpeedAll<=speedThreshold);
        cellNSlow = cellNumber(cellSpeedAll<=speedThreshold);
        cellTimesSlow = cellTimesAll(cellSpeedAll<=speedThreshold);
        cellTimesSlowSeconds = (cellTimesSlow-lfpTimestamps(1))/1e6;
        %
        for whichCell=0:max(cellNFast)
            if sum(cellNFast==whichCell) > 2                
%%                %
                figure(gcf(1)); clf;
                subplot(4,5,16:20 );
                hold off;
                yyaxis right;
                %scatter( cellTimesAllSeconds(cellNumber==whichCell), -1*rand(length(cellTimesAllSeconds(cellNumber==whichCell)),1), 2, 'k', 'filled'  ); alpha(.01);
                hold on;
                plot(xytimestampSeconds, xpos, '--', 'Color', [ .7 .2 .2 ]); 
                plot(xytimestampSeconds, ypos, '--', 'Color', [ .1 .2 .7 ]);  
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
                xlim([ 0 max(xytimestampSeconds) ])
%%              %
                %
                cellXHist = twoDHistogram( cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), binResolution, 650, 650 ); 
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
                subplot(4,5,14); pcolor(ppspike); colormap('jet');   colorbar; title('rough ratemap'); % hold off; imagesc(flipud(xyHist>0)); colormap([ 1 1 1; 0 0 0; colormap('jet')]);
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
%%                %
                subplot(4,5,[4 5 9 10]); hold off;
                plot(xrpos,yrpos, 'Color', [ 0 0 0 .15]); hold on; 
                scatter(cellPosSlow(1,(cellNSlow==whichCell)), cellPosSlow(2,(cellNSlow==whichCell)), 20, '.' ); 
                if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
                scatter(cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), 20, 'o', 'filled' ); 
                if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
                xlim([0 825]); ylim([0 650]); title([ 'trace plot; ' num2str(sum(cellNFast==whichCell)) ' fast spikes']);
                %
%                 subplot(4,5,2); hold off; 
%                 [ xcorrValues, lagtimes ] = acorrEventTimes( hiGammaPeakTimes );
%                 hold on;
%                 plot( lagtimes, xcorrValues, 'k' ); 
%                 [ xcorrValues, lagtimes] = acorrEventTimes( hiGammaPeakTimes(hiGammaSpeedAll<=speedThreshold) );
%                 plot( lagtimes, xcorrValues, 'r' ); 
%                 [ xcorrValues, lagtimes] = acorrEventTimes( hiGammaPeakTimes(hiGammaSpeedAll>speedThreshold) );
%                 plot( lagtimes, xcorrValues, 'g' ); 
%                 scatter( 0, 0, 1, '.', 'k' ); alpha( .01 ); %hack to force to zero.
%                 title('hi \gamma autocorrelegram');
%%                %
                subplot(4,5,2); hold off; histogram( real(log10(diff(cellTimesAllSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
                legend([ num2str(sum(cellNumber==whichCell)) ' spks' ] )
                % plot waveforms
%                 temp=(spikeWaveforms((cellNumber==whichCell),:,:)); ttYLims=[ min(temp(:)) max(temp(:)) ]; 
%                 subplot(4,5,6); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
%                 subplot(4,5,7); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
%                 subplot(4,5,11); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
%                 subplot(4,5,12); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
%                 %subplot(1,2,1); imagesc(flipud(cellXHist)); colormap([ 1 1 1; colormap('jet')]); colorbar; title('cell spike X place (n)');
                subplot(4,5,15); hold off; toPlot=twoDGuassianSmooth(ppspike); pcolor(toPlot); colormap('jet'); toPlotFlat=toPlot(:); caxis([ min(toPlotFlat(toPlotFlat>0)) max(toPlot(:)) ] ); colorbar; title(['smooth ratemap | info=' num2str(spikePlaceInfo)]); ylabel(['peakRate=' num2str(max(ppspike(:))) ' Hz'])
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
%                 % plot multiple cross correlations
%                 subplot(4,5,18); hold off;
%                 [ xcorrValues, lagtimes ] = acorrEventTimes( swrPeakTimes );
%                 hold on;
%                 plot( lagtimes, xcorrValues, 'k' ); 
%                 [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll<=speedThreshold) );
%                 plot( lagtimes, xcorrValues, 'r' ); 
%                 [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll>speedThreshold) );
%                 plot( lagtimes, xcorrValues, 'g' ); 
%                 scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
%                 title('swr autocorrelegram');
%%                %
                try
                    subplot(4,5,3); hold off;
                    rose(thetaPhase(floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1),36);
                    hold on;
                    rose(thetaPhase(floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1),36);
                    rose(thetaPhase(floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1),36);
                    title('\Theta phase')
                catch
                    subplot(4,5,3); hold off;
                    tidx=floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1; tidx=tidx(tidx>0);
                    rose(thetaPhase(tidx),36);
                    hold on;
                    tidx=floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1; tidx=tidx(tidx>0);
                    rose(thetaPhase(tidx),36);
                    tidx=floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1; tidx=tidx(tidx>0);
                    rose(thetaPhase(tidx),36);
                    title('\Theta phase');
                    subplot(4,5,3); rose(thetaPhase(tidx),36); title('\Theta phase')
                    warning(['removed ' num2str(sum(tidx>0)) ' entries from rose plot'])
                end
%%                %%%
                subplot( 4, 5, 6); hold off;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), hiGammaPeakTimes );
                plot( lagtimes, xcorrValues, 'k' ); % ylim([0 max(xcorrValues)]); % assume that all will have the max?
                hold on;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), hiGammaPeakTimes(hiGammaSpeedAll>speedThreshold) );
                plot( lagtimes, xcorrValues, 'g' ); 
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), hiGammaPeakTimes(hiGammaSpeedAll<=speedThreshold) );
                scatter( 0, 0, 1, '.', 'k' ); alpha(.01); % hack to force to zero.
                plot( lagtimes, xcorrValues, 'r' ); 
                title('hi \gamma Xcorr spike');
                %
%%
 


 

                windowSize = 6;
                divisionSize = 0.25;
                pethX = -windowSize:divisionSize:windowSize;
                %
                subplot(4,5,11);
                oo=periEventtimeHistogram( behaviorData.timeToMazeSec, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                bar(pethX,oo,'k');
                title('PETH start');
                xlim([-windowSize windowSize]);
                %
                subplot(4,5,12);
                hold off;
                oo=periEventtimeHistogram( behaviorData.timeToSugarSec, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                bar( pethX, oo, 'k'); hold on; alpha(.4)
                oo=periEventtimeHistogram( behaviorData.timeToSugarSec(behaviorData.madeError>0), cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                bar( pethX, oo, 'r');  alpha(.4)
                oo=periEventtimeHistogram( behaviorData.timeToSugarSec(behaviorData.madeError<1), cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                bar( pethX, oo, 'g');  alpha(.4)
                title('PETH reward');
                xlim([-windowSize windowSize]);
                %
                subplot(4,5,13);
                oo=periEventtimeHistogram( behaviorData.timeToJump1Sec, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                bar(pethX,oo,'k');
                title('PETH jump');
                xlim([-windowSize windowSize]);
                %
                subplot(4,5,8);
                oo=periEventtimeHistogram( behaviorData.timeToBucketSec, cellTimesAllSeconds(cellNumber==whichCell), windowSize, divisionSize );
                bar(pethX,oo,'k');
                title('PETH end');
                xlim([-windowSize windowSize]);
                
%%                
                try
                    print(gcf(1), [ path ratName '_placeMap_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                catch
                    print(gcf(1), [ path ratName '_placeMap_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                end
                clf(gcf(1));

            else
                warning([ ' not enough spikes w/ ' num2str(sum(cellNFast==whichCell)) ]);
            end
        end
    end

fclose(fid);

return; 
