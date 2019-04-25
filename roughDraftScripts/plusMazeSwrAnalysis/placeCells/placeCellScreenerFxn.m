function placeCellScreenerFxn(dir,ttFilenames,dateStr)

subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
speed=calculateSpeed(xpos, ypos, 1, 2.7);

figure; subplot(1,2,1); plot(xpos,ypos)
[xrpos,yrpos]=rotateXYPositions(xpos,ypos,310,234,40,260,280);
 subplot(1,2,2); plot(xrpos,yrpos)

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
    print(gcf(2), [ '~/data/da5_place_'  dateStr '_ttIdx_' num2str(ttIdx)  '_.png'],'-dpng','-r200');
    clf(gcf(2));
end


    gcf(3)=figure; subplot(2,1,1); histogram(metricList.info, -1:.5:10); subplot(2,1,2);  histogram(metricList.peakrate, 1:2:140);
print(gcf(3), [ '~/data/da5_placeInfo_' dateStr  '_ttIdx_' num2str(ttIdx)  '_.png'],'-dpng','-r200');

