
speedThreshold = 10;
binResolution = round(15*2.9); % px/bin


%% extract the stored variables to individual variables

speed = output.speed;
inBucket = output.inBucket;
inBucketSmoothed = output.inBucketSmoothed;
xrpos = output.xrpos;
yrpos = output.yrpos;
swrPeakValues = output.swrPeakValues;
swrPeakTimes = output.swrPeakTimes;
swrPosAll = output.swrPosAll;
swrSpeedAll = output.swrSpeedAll;
swrPosFast = output.swrPosFast;
swrPosSlow = output.swrPosSlow;
swrThetaAll = output.swrThetaAll;
swrThetaPhaseAll = output.swrThetaPhaseAll;
hiGammaPeakValues = output.hiGammaPeakValues;
hiGammaPeakTimes = output.hiGammaPeakTimes;
hiGammaPosAll = output.hiGammaPosAll;
hiGammaSpeedAll = output.hiGammaSpeedAll;
hiGammaPosFast = output.hiGammaPosFast;
hiGammaPosSlow = output.hiGammaPosSlow;
swrAvgPeakValues = output.swrAvgPeakValues;
swrAvgPeakTimes = output.swrAvgPeakTimes;
swrAvgPosAll = output.swrAvgPosAll;
swrAvgSpeedAll = output.swrAvgSpeedAll;
swrAvgPosFast = output.swrAvgPosFast;
swrAvgPosSlow = output.swrAvgPosSlow;
hiGammaAvgPeakValues = output.hiGammaAvgPeakValues;
hiGammaAvgPeakTimes = output.hiGammaAvgPeakTimes;
hiGammaAvgPosAll = output.hiGammaAvgPosAll;
hiGammaAvgSpeedAll = output.hiGammaAvgSpeedAll;
hiGammaAvgPosFast = output.hiGammaAvgPosFast;
hiGammaAvgPosSlow = output.hiGammaAvgPosSlow;
thetaTimestamps = output.thetaTimestamps;
thetaLfp = output.thetaLfp;
tt = output.tt;
%grps=output.swrLocationLabelIdx;

%% construct missing data

inBucketSmoothed = inBucketSmoothed > 0;
swrInBucket = inBucketSmoothed(floor(swrPeakTimes*29.97)+1) > 0;
hiGammaInBucket = inBucketSmoothed(floor(hiGammaAvgPeakTimes*29.97)+1) > 0;
xytimestampSeconds = (0:length(xrpos)-1)/29.97;




%% words
tetrodeList = fieldnames(output.tt);

for ttIdx=1:length(tetrodeList)

    % set up variables
    spiketimestamps = output.tt.(tetrodeList{ttIdx}).spiketimestamps;
    output.tt.(tetrodeList{ttIdx}).cellGammaEnv;
    output.tt.(tetrodeList{ttIdx}).cellInBucket;
    output.tt.(tetrodeList{ttIdx}).cellNumber;
    output.tt.(tetrodeList{ttIdx}).cellPosAll;
    output.tt.(tetrodeList{ttIdx}).cellSpeedAll;
    output.tt.(tetrodeList{ttIdx}).cellThetaEnv;
    output.tt.(tetrodeList{ttIdx}).cellThetaPhase;
    output.tt.(tetrodeList{ttIdx}).spiketimestamps;
    
    
    cellTimesAllSeconds = (cellTimesAll-cellTimesAll(1))/1e6;
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




max(output.tt.TT6a.cellNumber)


cellN=6;
% time by position
figure; subplot(1,3,1);
hold off;
x = output.tt.TT6a.cellPosAll(1,output.tt.TT6a.cellNumber==cellN);
y = output.tt.TT6a.cellPosAll(2,output.tt.TT6a.cellNumber==cellN);
z = zeros(size(x));
s = output.tt.TT6a.spiketimestampSeconds(output.tt.TT6a.cellNumber==cellN);
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [s(:), s(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(1,3,2);
hold off;
x = output.tt.TT6a.cellPosAll(1,output.tt.TT6a.cellNumber==cellN);
y = output.tt.TT6a.cellPosAll(2,output.tt.TT6a.cellNumber==cellN);
z = zeros(size(x));
s = output.tt.TT6a.cellSpeedAll(output.tt.TT6a.cellNumber==cellN);
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [s(:), s(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(1,3,3);
hold off;
x = output.tt.TT6a.cellPosAll(1,output.tt.TT6a.cellNumber==cellN);
y = output.tt.TT6a.cellPosAll(2,output.tt.TT6a.cellNumber==cellN);
z = zeros(size(x));
s = output.tt.TT6a.cellThetaPhase(output.tt.TT6a.cellNumber==cellN);
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [s(:), s(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap( buildCircularGradient );
colorbar;
title('position by \Phi');











histogram(speed,1:100);
title('speed distribution');
xlabel('speed (cm/s)');
ylabel('count');



figure;
for nn=1:9
    dx = zeros(size(xrpos));
    dy = zeros(size(yrpos));
    for jj=1+nn:length(xrpos)-nn
        dy(jj)=( yrpos(jj+nn) - yrpos(jj-nn) );
        dx(jj)=( xrpos(jj+nn) - xrpos(jj-nn) );
    end
    dxy = sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/((2*nn)+1)) * 1/2.75 * 29.97;  % sqrt() * ?? * 1/pxPerCm * framesPerSec
    subplot(3,3,nn);
    histogram(dxy,0:100);
end
    
boxcarSize = 45;  % samples
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
dxy = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;  % sqrt() * ?? * 1/pxPerCm * framesPerSec



dx = zeros(size(xpos));
for posIdx=61:length(xpos)-61
    for posLookAround = 1:60
            posBack = xpos(posIdx-posLookAround);
            posForward = ypos(posIdx+posLookAround);
            dx(posIdx)=( posForward - posBack )/( (posLookAround*2 + 1) * 1/29.97 );
            
end








