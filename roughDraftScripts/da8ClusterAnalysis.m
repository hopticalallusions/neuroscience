%close all; clear all;

% TODO -- add
% still & moving correlegrams for all components
%
% gamma?
% 
% per day :
% swr occurrances on maze




% NOTE : PARAMETERS WILL FAIL FOR DAYS BEFORE MAY 1 AND MAY 2

dir='/Volumes/AHOWETHESIS/da8/2016-11-05_training3/';
ttFilenames={ 'TT3a.ntt' 'TT5a.ntt' 'TT6a.ntt' 'TT7a.ntt' };
dateStr='2018-05-02';
%2018-05-02
startCoordinate = [98 280]; startRadius = 32;%  {130,280}  start area  {radius}
bucketCoordinate = [214, 232; 231, 343 ]; bucketRadius = [ 34  34 ];
%214, 232    {184,232} bucket1 {radius}
%231, 343  {203,324} bucket2 {radius}





subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

speedThreshold = 10; % cm/s

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
speed=speedAll;

gcf(1)=figure(1); 
subplot(2,2,1); hold off; plot(xpos,ypos);
[xrpos,yrpos]=rotateXYPositions(xpos,ypos,324,251,-45,410,400);
subplot(2,2,3); plot(xrpos,yrpos);
subplot(2,2,2); hold off; histogram(speed,0:100); hold on; histogram(speedAll,0:100); hold on;
%print(gcf, [ '~/data/h5_positionPlot1_' dateStr '_.png'],'-dpng','-r200');

binResolution = round(15*2.9); % px/bin

% if the rat is in the bucket, adjust the speed such that he is below
% the speed threshold. (these are mutually exclusive positions, so add them
% together.ç
inBucket = (distFromPoint( xrpos,yrpos, bucketCoordinate(1,1), bucketCoordinate(1,2) )<bucketRadius(1)) + (distFromPoint( xrpos,yrpos, bucketCoordinate(2,1), bucketCoordinate(2,2) )<bucketRadius(2));
speed(inBucket>0) = speedAll(inBucket>0)/10;

yrpos=yrpos+12;


makeFilters;



% tt13, tt19 - theta   ch48, ch72
[ lfpTheta, lfpTimestamps ]=csc2mat( [ dir 'CSC28.ncs' ] );
lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
thetaPhase = angle(hilbert(thetaLfp));

%% SWR band

% tt10, tt22 - swr  ch36; ch87
[ lfpSwr ]=csc2mat( [ dir 'CSC36.ncs' ] );
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
print(gcf(1), [ '~/data/h5_positionPlot_' dateStr '_.png'],'-dpng','-r200');

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
    for whichCell=1:max(cellNFast)
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
            print(gcf(1), [ '~/data/h5_placeMap_' dateStr  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
            clf(gcf(1));
            
        else
            warning([ ' not enough spikes w/ ' num2str(sum(cellNFast==whichCell)) ]);
        end
    end
end
    
return; 

    
    
figure; hold on; temp=(spikeWaveforms(2,1,:)); plot(-7:24,temp(:));
temp=(spikeWaveforms(2,2,:));plot(-7:24,temp(:));
temp=(spikeWaveforms(2,3,:));plot(-7:24,temp(:));
    


    size(mean(spikeWaveforms((cellNumber==1),1,:),3))
    
%% test rig for autocorrelation
    
dir='/Volumes/Seagate Expansion Drive/h5/2018-05-08_training7_bananas/';
ttFilenames={ 'TT5_recut.NTT' };
[ ~, spiketimes, ~, ~, cellNumber ]=ntt2mat([ dir ttFilenames{1} ]);
spiketimesSeconds = (spiketimes-lfpTimestamps(1))/1e6;
spikeidx=floor(32000*(spiketimes-lfpTimestamps(1))/1e6)+1;
raster=zeros(1,length(lfpTimestamps));
raster(1,spikeidx(cellNumber==7))=1;
[xcm,lag]=xcorr(raster,32000);
xcm(32001)=0;  % cancel out the self-correlation
figure; plot(lag,xc); hold on;
[xca]=xcorrSparseSets(raster,raster,32000);
xca(32001)=0;  % cancel out the self-correlation
plot(lag,xca); hold on;
figure; hold on;
[ xcorrValues, lagtimes] = acorrEventTimes( spiketimesSeconds(cellNumber==7), 0.02, 1, 'sets' );
plot(lagtimes,xcorrValues);

%%

            % plot details of cluster
            
            figure(gcf(2)); clf;

            subplot(4,5,8); hold off; histogram( real(log10(diff(cellTimesAllSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
            % plot waveforms
            temp=(spikeWaveforms((cellNumber==whichCell),:,:)); ttYLims=[ min(temp(:)) max(temp(:)) ]; 
            subplot(4,5,6); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
            subplot(4,5,7); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
            subplot(4,5,11); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
            subplot(4,5,12); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
            
            %
            print(gcf(2), [ '~/data/h5_cluster_' dateStr  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
            clf(gcf(2));







x = [-3:3]; norm = normpdf(x,0,2);
figure; plot(x,norm); surf(norm'*norm)



makeFilters;
dir='/Volumes/Seagate Expansion Drive/h5/2018-05-02_training4_bananas/';    
[ spikeLfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC36.ncs']); % hippocampus ; clear theta
lfpTimestampsSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
spikeLfp = filtfilt( filters.so.spike, spikeLfp );
[ spikePeakValues,      ...
  spikePeakTimes,       ...
  spikePeakProminances, ...
  spikePeakWidths ] = findpeaks( spikeLfp,                        ... % data
                             lfpTimestampSeconds,                     ... % sampling frequency
                             'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

    
    
 
% correct for the entrance/exit conditions
yrpos(yrpos<6) = 6;
 
warning('linearization is invalid without defining a proper center origin')
[angle, radius] = cart2pol( xrpos-267, yrpos-287 ); angle=angle*180/pi+180;
rad=radius;
% we are going to convert this to centimeters here, while also linearizing the data
xylinearized(find((rad <= 25))) =  120; % Center Point                                                                                     px / cm  + offset
xylinearized(find((rad > 25) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 25) .* ( angle >  45 ) .* ( angle <= 135 )))/(280/106) + (120*2); % South
xylinearized(find((rad > 25) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 25) .* ( angle > 135 ) .* ( angle <= 225 )))/(310/106) + 120; % East
xylinearized(find((rad > 25) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 25) .* ( angle > 225 ) .* ( angle <= 315 )))/(260/106) + (120*3); % North  ; invert this so the rat starts at x=0
xylinearized(find((rad > 25) .* ( angle > 315 )  + ( angle <=  45 ))) = 120-(rad(find((rad > 25) .* ( angle > 315 )  + ( angle <=  45 )))/(250/106)) ; % West
radiusFromCenter=rad;    

speedThreshold = 7;

gcf(1)=figure; histogram( xylinearized, 0:11:max(xylinearized) );
hold on;
histogram( xylinearized( speed>speedThreshold ), 0:11:max( xylinearized ) );
print(gcf(1), [ '~/data/da5_occupancySpeed_'  dateStr '_.png'],'-dpng','-r200');

%% load LFPs

% makeFilters;
% 
% % has chewing artifacts.
% 
% [ thetaLfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC44.ncs']); % hippocampus ; clear theta
% lfpTimestampsSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
% thetaLfp = filtfilt( filters.so.theta, thetaLfp );
% 
% [ spikeLfp ] = csc2mat([ dir 'CSC4.ncs']); % hippcampus TT wire; large spikes 
% spikeLfp = filtfilt( filters.so.spike, spikeLfp );
% 
% [ swrLfp ] = csc2mat([ dir 'CSC24.ncs']); % hippcampus TT wire; smaller spikes; 4, 24, 28, 36 could all work
% swrLfp = filtfilt( filters.so.swr, swrLfp );
% swrLfpEnv = abs( hilbert(swrLfp) );
% 
% swrEnvMedian = median(swrLfpEnv);
% swrEnvMadam  = median(abs(swrLfpEnv-swrEnvMedian));
% % empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% % it equivalent to the std(xx)*6 previously used; this change was made
% % because some SWR channels had no events due to 1 large noise artifact
% % wrecking the threshold; the threshold was slightly relaxed on the premise
% % that extra SWR could be removed at later processing stages.
% swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );
% 
% [ swrPeakValues,      ...
%   swrPeakTimes,       ...
%   swrPeakProminances, ...
%   swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
%                              lfpTimestampSeconds,                     ... % sampling frequency
%                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

% 
% figure;
% xrange=[ 1650 1660 ];
% subplot(4,1,1); plot( lfpTimestampsSeconds, thetaLfp, 'b' ); xlim(xrange);
% subplot(4,1,2); plot( lfpTimestampsSeconds, spikeLfp, 'k' );xlim(xrange);
% subplot(4,1,3); plot( lfpTimestampsSeconds, swrLfp, 'r' );xlim(xrange);
% subplot(4,1,4); plot( xytimestampSeconds, speed, 'g'); xlim(xrange);


%% evaluate cell characteristics
metricList.ttIdx = [];
metricList.cell = [];
metricList.info = [];
metricList.peakrate = [];

disp(dateStr);

gcf(2)=figure; 

for ttIdx=1:length(ttFilenames)

    [ ~, spiketimes, spikeheader, ~, cellNumber ]=ntt2mat([ dir ttFilenames{ttIdx} ]);

    cellPosAll = zeros(size(spiketimes));
    cellSpeedAll = cellPosAll;
    for ii=1:length(spiketimes)
        tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
            if ~isempty(tempIdx)
                cellPosAll(ii)=xylinearized(tempIdx);
                cellSpeedAll(ii) = speed(tempIdx);
            end
    end
    % simple speed filter hack
    speedThreshold = 7; %9; % cm/s
    cellPos=cellPosAll(cellSpeedAll>speedThreshold);
    cellN=cellNumber(cellSpeedAll>speedThreshold);
    [ positionHistogram, positionBins ] = histcounts( xylinearized(speed>speedThreshold), 0:11:max(xylinearized) );
    ppxy = positionHistogram./sum(positionHistogram); % probability of being in place
    % 

    disp(ttFilenames{ttIdx})
    for cellId=1:max(cellN); 
        subplotRows = subplotCheatTable(max(cellN),1);
        subplotCols = subplotCheatTable(max(cellN),2);
        subplot( subplotRows, subplotCols, cellId); 
        qq = histcounts(cellPos(cellN==cellId),positionBins); 
        ppspike = qq./(positionHistogram./29.97); % spike rate
        spikePlaceInfo = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
        disp(['cellId ' num2str(cellId) ' spatial info = ' num2str(nansum(spikePlaceInfo(:))) '  |  peak rate = ' num2str(max(ppspike)) ]);
        hold off;
        plot( positionBins(1:end-1)+diff(positionBins)/2, ppxy );
        hold on;
        %plot( positionBins(1:end-1)+diff(positionBins)/2, qq );
        plot( positionBins(1:end-1)+diff(positionBins)/2, ppspike ); xlim( [min(positionBins) max(positionBins) ] );
        %legend(num2str(nansum(spikePlaceInfo(:))));
        %imagesc(flipud(ppspike)); colormap(build_NOAA_colorgradient);
        %imagesc(flipud(qq)); colormap(build_NOAA_colorgradient);
        
        metricList.ttIdx = [ metricList.ttIdx ttIdx  ];
        metricList.cell = [ metricList.cell cellId ];
        metricList.info = [ metricList.info nansum(spikePlaceInfo(:)) ];
        metricList.peakrate = [ metricList.peakrate max(ppspike) ];
    end;
    print(gcf(2), [ '~/data/h5_place_'  dateStr '_ttIdx_' num2str(ttIdx)  '_.png'],'-dpng','-r200');
    clf(gcf(2));
end


gcf(3)=figure; subplot(2,1,1); histogram(metricList.info, -1:.5:10); subplot(2,1,2);  histogram(metricList.peakrate, 1:2:140);
print(gcf(3), [ '~/data/h5_placeInfo_' dateStr  '_ttIdx_' num2str(ttIdx)  '_.png'],'-dpng','-r200');




        %
        % barfy plotting routines to make NaNs white and min values black,
        % hopefully...
%         plotppspike = ppspike; newMin=-(max(ppspike(:))-min(ppspike(~isnan(ppspike))))/(3+length(colormap('jet')));
%         for kk=1:length(ppspike(:)); if isnan(plotppspike(kk)); plotppspike(kk)=newMin; end; end;
%         xyHistprob=xyHist/sum(xyHist(:));
%         plotxyHist = xyHistprob; newMin=-(max(xyHistprob(:))-min(xyHistprob(~isnan(xyHistprob))))/(3+length(colormap('jet')));
%         for kk=1:length(xyHistprob(:)); if isnan(plotxyHist(kk)); plotxyHist(kk)=newMin; end; end;
        %
        
%         idxs = floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1;
%         fullVersion = zeros(1,length(lfpTimestamps)); fullVersion(idxs)=1;
%         lagtimes = (-32000:32000)/32000;
%         xcorrValues=xcorrSparseSets(fullVersion,fullVersion,32000); xcorrValues(32001)=0;
        
        %
        %plotppspike = ppspike+min(ppspike((ppspike>0)));