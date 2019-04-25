%% load data

% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-22_orientation1/1.maze-habituation/';
% ttFilenames={'TT2CUTaftermerge.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
% dateStr='2016-08-22';

%placeCellScreenerFxn(dir,ttFilenames,dateStr)


dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-23_orientation2/1.maze-habituation/';
ttFilenames={ 'TT1cut.NTT' 'TT2cut.NTT' 'TT5cut.NTT' 'TT7tadcut.NTT' 'TT8tadcut.NTT' 'TT10cut.NTT' 'TT11cut.NTT' 'TT14cut.NTT' 'TT15cut.ntt' }
dateStr='2016-08-23';
%2018-05-07
startCoordinate = [98 280]; startRadius = 32;%  {130,280}  start area  {radius}
bucketCoordinate =[ 226,168 ; 233, 416 ]; bucketRadius = [ 47  47 ];
% TODO the bucket coordinates aren't very good.



dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-24_training1/';
ttFilenames={'TT1cut.NTT' 'TT2cut.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT'  'TT15cut.NTT'};
dateStr='2016-08-24';



dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/';
ttFilenames={ 'TT1pcacut.NTT' 'TT2tadcut.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
dateStr='2016-08-28';


subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

speedThreshold = 10; % cm/s

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
speed=speedAll;

gcf(1)=figure(1); 
subplot(2,2,1); hold off; plot(xpos,ypos);
[xrpos,yrpos]=rotateXYPositions(xpos,ypos,428,251,-50,415,260);
%subplot(2,2,2); plot(xrpos,yrpos);
subplot(2,2,2); hold off; histogram(speed,0:100); hold on; histogram(speedAll,0:100); hold on;
%print(gcf, [ '~/data/h5_positionPlot1_' dateStr '_.png'],'-dpng','-r200');

% not a great plan...
xrpos(xrpos<1) = 1;
yrpos(yrpos<1) = 1;


binResolution = round(15*2.9); % px/bin

% if the rat is in the bucket, adjust the speed such that he is below
% the speed threshold. (these are mutually exclusive positions, so add them
% together.ç
inBucket = (distFromPoint( xrpos,yrpos, bucketCoordinate(1,1), bucketCoordinate(1,2) )<bucketRadius(1)) + (distFromPoint( xrpos,yrpos, bucketCoordinate(2,1), bucketCoordinate(2,2) )<bucketRadius(2));
speed(inBucket>0) = speedAll(inBucket>0)/10;

yrpos=yrpos+12;


makeFilters;



% tt13, tt19 - theta   ch48, ch72
[ lfpTheta, lfpTimestamps ]=csc2mat( [ dir 'CSC44.ncs' ] );
lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
thetaPhase = angle(hilbert(thetaLfp));

%% SWR band

% tt10, tt22 - swr  ch36; ch87
[ lfpSwr ]=csc2mat( [ dir 'CSC24.ncs' ] );
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
hiGammaPosFast=swrPosAll(:,hiGammaSpeedAll>speedThreshold);
hiGammaPosSlow=swrPosAll(:,hiGammaSpeedAll<=speedThreshold);


gcf(2)=figure(2);




%% PLOTTING ROUTINES

xyHist = twoDHistogram( xrpos(speed>speedThreshold), yrpos(speed>speedThreshold), binResolution , 650, 650 );
subplot(2,2,3); hold off; plot(xrpos,yrpos); ylim([0 650]); xlim([0 650]); title('xy position'); hold on; scatter(xrpos(speed>speedThreshold),yrpos(speed>speedThreshold), '.');
subplot(2,2,4); hold off; imagesc(flipud(xyHist./29.97)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist[<speed]')
print(gcf(1), [ '~/data/da5_positionPlot_' dateStr '_.png'],'-dpng','-r200');

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





dir
dateStr

for ttIdx=1:length(ttFilenames)

    [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ dir ttFilenames{ttIdx} ]);

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
            disp([ ttFilenames{ttIdx} ' | cell ' num2str(whichCell) ' | place info = ' num2str(spikePlaceInfo) ' bits | spike sparsity = ' num2str(spikePlaceSparsity) ' | peak firing rate = ' num2str(max(ppspike(:))) ' Hz  | n = ' num2str(sum(cellNFast==whichCell)) ' spikes ' ]);
            %
            figure(gcf(1)); clf;
            subplot(4,5,1); pcolor(ppspike); colormap('jet');   colorbar; title('rough ratemap'); % hold off; imagesc(flipud(xyHist>0)); colormap([ 1 1 1; 0 0 0; colormap('jet')]);
            % plot cell autocorrelegrams
            subplot(4,5,3); hold off
            [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell) );
            plot( lagtimes, xcorrValues, 'k' ); 
            hold on;
            [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell) );
            plot( lagtimes, xcorrValues, 'r' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell) );
            plot( lagtimes, xcorrValues, 'g' ); 
            title('spk autocorrelegram')
            %
            subplot(4,5,[4 5 9 10]); hold off;
            plot(xrpos,yrpos, 'Color', [ 0 0 0 .15]); hold on; 
            scatter(cellPosSlow(1,(cellNSlow==whichCell)), cellPosSlow(2,(cellNSlow==whichCell)), 20, '.' ); 
            if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
            scatter(cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), 20, 'o', 'filled' ); 
            if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
            xlim([0 825]); ylim([0 650]); title([ 'trace plot; ' num2str(sum(cellNFast==whichCell)) ' spikes']);
            %
            subplot(4,5,2); hold off; 
            [ xcorrValues, lagtimes ] = acorrEventTimes( hiGammaPeakTimes );
            hold on;
            plot( lagtimes, xcorrValues, 'k' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( hiGammaPeakTimes(hiGammaSpeedAll<=speedThreshold) );
            plot( lagtimes, xcorrValues, 'r' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( hiGammaPeakTimes(hiGammaSpeedAll>speedThreshold) );
            plot( lagtimes, xcorrValues, 'g' ); 
            scatter( 0, 0, 1, '.', 'k' ); alpha( .01 ); %hack to force to zero.
            title('hi \gamma autocorrelegram');
            %
            subplot(4,5,8); hold off; histogram( real(log10(diff(cellTimesAllSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
            % plot waveforms
            temp=(spikeWaveforms((cellNumber==whichCell),:,:)); ttYLims=[ min(temp(:)) max(temp(:)) ]; 
            subplot(4,5,6); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
            subplot(4,5,7); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
            subplot(4,5,11); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
            subplot(4,5,12); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
            %subplot(1,2,1); imagesc(flipud(cellXHist)); colormap([ 1 1 1; colormap('jet')]); colorbar; title('cell spike X place (n)');
            subplot(4,5,[ 14 15 19 20 ]); hold off; toPlot=twoDGuassianSmooth(ppspike); pcolor(toPlot); colormap('jet'); toPlotFlat=toPlot(:); caxis([ min(toPlotFlat(toPlotFlat>0)) max(toPlot(:)) ] ); colorbar; title(['smooth ratemap | info=' num2str(spikePlaceInfo)]); ylabel(['peakRate=' num2str(max(ppspike(:))) ' Hz'])
              % imagesc(flipud(plotppspike)); colormap([ 1 1 1; 0 0 0; colormap('jet')]);  
            colormap([ 1 1 1; 0 0 0; colormap('jet')]);
            % plot swr X cell firing
            subplot(4,5,13);  hold off;
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes );
            plot(lagtimes,xcorrValues, 'k'); % ylim([0 max(xcorrValues)]); % assume that all will have the max?
            hold on;
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), swrPeakTimes(swrSpeedAll>speedThreshold) );
            plot(lagtimes,xcorrValues,'g'); 
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), swrPeakTimes(swrSpeedAll<=speedThreshold) );
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            plot(lagtimes,xcorrValues,'r'); 
            title('swr Xcorr spike');
            % plot multiple cross correlations
            subplot(4,5,18); hold off;
            [ xcorrValues, lagtimes ] = acorrEventTimes( swrPeakTimes );
            hold on;
            plot( lagtimes, xcorrValues, 'k' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll<=speedThreshold) );
            plot( lagtimes, xcorrValues, 'r' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll>speedThreshold) );
            plot( lagtimes, xcorrValues, 'g' ); 
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            title('swr autocorrelegram');
            %
            try
                subplot(4,5,17); hold off;
                rose(thetaPhase(floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1),36);
                hold on;
                rose(thetaPhase(floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1),36);
                rose(thetaPhase(floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1),36);
                title('\Theta phase')
            catch
                subplot(4,5,17); hold off;
                tidx=floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1; tidx=tidx(tidx>0);
                rose(thetaPhase(tidx),36);
                hold on;
                tidx=floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1; tidx=tidx(tidx>0);
                rose(thetaPhase(tidx),36);
                tidx=floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1; tidx=tidx(tidx>0);
                rose(thetaPhase(tidx),36);
                title('\Theta phase');
                subplot(4,5,17); rose(thetaPhase(tidx),36); title('\Theta phase')
                warning(['removed ' num2str(sum(tidx>0)) ' entries from rose plot'])
            end
            %
            subplot( 4, 5, 16); hold off;
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
            print(gcf(1), [ '~/data/da5_placeMap_' dateStr  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
            clf(gcf(1));
            
        else
            warning([ ' not enough spikes w/ ' num2str(sum(cellNFast==whichCell)) ]);
        end
    end
end
    
return; 

    

















return;


placeCellScreenerFxn(dir,ttFilenames,dateStr)

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-24_training1/';
ttFilenames={'TT1cut.NTT' 'TT2cut.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT'  'TT15cut.NTT'};
dateStr='2016-08-24';

placeCellScreenerFxn(dir,ttFilenames,dateStr)

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-25_training2/';
ttFilenames={'TT1cut.NTT' 'TT2cut.NTT' 'TT7cut.NTT'};
dateStr='2016-08-25';

placeCellScreenerFxn(dir,ttFilenames,dateStr)

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-26_probe1/';
ttFilenames={'TT1cut.NTT' 'TT1pcacut.NTT' 'TT2cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT'};
dateStr='2016-08-26';

placeCellScreenerFxn(dir,ttFilenames,dateStr)

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-27_training3/';
ttFilenames={'TT1pcacut.NTT' 'TT2cut.NTT' };
dateStr='2016-08-27';

placeCellScreenerFxn(dir,ttFilenames,dateStr)



dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/';
ttFilenames={ 'TT1pcacut.NTT' 'TT2tadcut.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
dateStr='2016-08-28';

placeCellScreenerFxn(dir,ttFilenames,dateStr)

%figure; histogram(cellN,1:max(cellN))

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-29_training5/';
ttFilenames={ 'TT1pcacut.NTT' 'TT2cut.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
dateStr='2016-08-29';

placeCellScreenerFxn(dir,ttFilenames,dateStr)


dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-30_training6/';
ttFilenames={ 'TT1pcacut.NTT' 'TT2cut.NTT' 'TT15cut.NTT'};
dateStr='2016-08-30';

placeCellScreenerFxn(dir,ttFilenames,dateStr)



dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-31_training7/';
ttFilenames={ 'TT1pcacut.NTT' 'TT2cut.NTT' 'TT5cut.NTT'  'TT10cuttad.NTT' };
dateStr='2016-08-31';

placeCellScreenerFxn(dir,ttFilenames,dateStr)




dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-09-01_training8/';
ttFilenames={ 'TT2cut.NTT' 'TT5cut.NTT'  'TT10cut.NTT' };
dateStr='2016-09-01';

placeCellScreenerFxn(dir,ttFilenames,dateStr)
