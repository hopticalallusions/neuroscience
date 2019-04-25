output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-11_spikeData.dat');


output=importdata('/Users/andrewhowe/data/cache/h5_2018-06-08_spikeData.dat');

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
grps=output.swrLocationLabelIdx;

%% construct missing data

inBucketSmoothed = inBucketSmoothed > 0;
swrInBucket = inBucketSmoothed(floor(swrPeakTimes*29.97)+1) > 0;
hiGammaInBucket = inBucketSmoothed(floor(hiGammaAvgPeakTimes*29.97)+1) > 0;
xytimestampSeconds = (0:length(xrpos)-1)/29.97;


%% check how well the bucket time was isolated

% display the square wave plot for being in the bucket
% figure; plot( (1:length(inBucketSmoothed))/29.97, inBucketSmoothed)

figure; hold on; title('display the positions marked as bucket')
scatter( xrpos(inBucketSmoothed), yrpos(inBucketSmoothed), 5, 'o', 'filled', 'MarkerFaceColor', [ .9 .6 .6 ], 'MarkerEdgeColor', [ .9 .6 .6 ] );
plot( xrpos, yrpos, 'Color', [ 0 0 0 .2 ] );

% figure;
% hold on;
% scatter(output.xrpos(output.inBucketSmoothed>0), output.yrpos(output.inBucketSmoothed>0),5,'o', 'filled', 'MarkerFaceColor', [ .9 .6 .6 ],'MarkerEdgeColor', [ .9 .6 .6 ]);
% plot(output.xrpos, output.yrpos, 'Color', [ 0 0 0 .2 ]);

% [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ input.dir 'VT0.nvt']);
% xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
% figure; plot(xpos,ypos);
% [xrpos,yrpos]=rotateXYPositions(xpos,ypos,input.center(1),input.center(2),input.rotationAmount,360,320);
% figure; plot(xrpos,yrpos);   % % hold on; plot(output.xrpos,output.yrpos)

%% PLOTTING ROUTINES

xyMazeMovingIdxs = ((speed>=speedThreshold) .* ~inBucketSmoothed) > 0;
xyMazeStillnessIdxs = ((speed<speedThreshold) .* ~inBucketSmoothed) > 0;

xyHist = twoDHistogram( xrpos(xyMazeStillnessIdxs), yrpos(xyMazeStillnessIdxs), binResolution , 650, 650 );
subplot(2,3,1); hold off; histogram( swrSpeedAll, 0:100); hold on; histogram( swrSpeedAll( ~swrInBucket > 0), 0:100); histogram( swrSpeedAll(swrInBucket > 0), 0:100);
subplot(2,3,2); hold off; rose( swrThetaPhaseAll, 36); hold on;  rose( swrThetaPhaseAll( ~swrInBucket > 0), 36);   rose( swrThetaPhaseAll( swrInBucket > 0), 36); 
subplot(2,3,3); hold off; plot(xrpos,yrpos); ylim([0 650]); xlim([0 650]); title('xy position'); hold on; scatter(xrpos(xyMazeStillnessIdxs),yrpos(xyMazeStillnessIdxs), '.');
subplot(2,3,4); hold off; pcolor((xyHist./29.97)); colormap([ 1 1 1; colormap('jet')]);  colorbar; title('xy occupany');
subplot(2,3,5); hold off; histogram( abs(swrThetaAll), 100); hold on; histogram( abs(swrThetaAll( ~swrInBucket > 0)), 100); histogram( abs(swrThetaAll(swrInBucket > 0)), 100);

%print(gcf(1), [ '~/data/h5_positionPlot_' dateStr '_.png'],'-dpng','-r200');



% time by position
figure; subplot(1,3,1);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(1,3,2);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(1,3,3);
histogram(speed,1:100);
title('speed distribution');
xlabel('speed (cm/s)');
ylabel('count');










% time by position
figure;
hold off;
tidxs=1:round(1100*29.97);
x = xrpos(tidxs);
y = yrpos(tidxs);
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(tidxs); xytimestampSeconds(tidxs)]', ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')





xytimestampSeconds=(1:length(output.xrpos))/29.97;

figure;
hold off;
%tidxs=1:round(1100*29.97);
x = output.xrpos;
y = output.yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], [xytimestampSeconds(:), xytimestampSeconds(:)] , 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')









%% SWR map should make a SWR figure
figure; hold off;
plot( xrpos, yrpos, 'Color', [ 0 0 0 .15 ] ); hold on; 
%scatter(swrPosAll(1,:), swrPosAll(2,:), 20, 'o', 'filled' ); 
%if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
scatter( swrPosFast(1,:), swrPosFast(2,:), 10, 'x' ); 
if length( swrPosFast(1,:)) < 2000 ; alpha(.2); else alpha( 500/length(swrPosFast(1,:)) ); end; 
scatter( swrPosSlow(1,:), swrPosSlow(2,:), 10, 'o', 'filled' ); 
if length( swrPosSlow(1,:) ) < 2000 ; alpha(.2); else alpha( 500/length(swrPosSlow(1,:)) ); end; 
xlim([0 825]); ylim([0 650]); title([ 'trace plot; ' num2str(length(swrPeakTimes)) ' SWRs']);
%

%% 

eliminationResolution = 1000/50; % 1000 ms / 20 ms bins
[ swrNoiseTimes, swrAvgPeakTimesUnionIdxs, swrPeakTimesUnionIdxs ]=intersect( round(swrAvgPeakTimes*eliminationResolution), round(swrPeakTimes*eliminationResolution) );
figure;
subplot(2,2,1); hold off; plot(xrpos,yrpos, 'Color', [ 0 0 0 .2]); hold on; scatter( swrPosAll(1,:), swrPosAll(2,:), 10, 'filled', 'k');
subplot(2,2,2); hold off; plot(xrpos,yrpos, 'Color', [ 0 0 0 .2]); hold on; scatter( swrAvgPosAll(1,:), swrAvgPosAll(2,:), 10, 'x', 'r');
subplot(2,2,3); hold off; plot(xrpos,yrpos, 'Color', [ 0 0 0 .2]); hold on; scatter( swrPosAll(1,swrPeakTimesUnionIdxs), swrPosAll(2,swrPeakTimesUnionIdxs), 'filled');
cleanSwrIdxs=1:length(swrPeakTimes); cleanSwrIdxs(swrPeakTimesUnionIdxs)=[];
subplot(2,2,4); hold off; plot(xrpos,yrpos, 'Color', [ 0 0 0 .2]); hold on; scatter( swrPosAll(1,cleanSwrIdxs), swrPosAll(2,cleanSwrIdxs), 'filled', 'g');



% k-means clustering of the SWR
opts = statset('Display','final');
[idx,C] = kmeans(swrPosAll(:,cleanSwrIdxs)',4,'Distance','cityblock',...
    'Replicates',5,'Options',opts);
tSwrPos = swrPosAll(:,cleanSwrIdxs)';
figure;
plot(xrpos,yrpos, 'Color', [ 0 0 0 .2]); hold on;
scatter(tSwrPos(idx==1,1),tSwrPos(idx==1,2),12);
scatter(tSwrPos(idx==2,1),tSwrPos(idx==2,2),12);
scatter(tSwrPos(idx==3,1),tSwrPos(idx==3,2),12);
scatter(tSwrPos(idx==4,1),tSwrPos(idx==4,2),12);
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off


options = statset('MaxIter',5000);
GMModel2 = fitgmdist(tSwrPos,10, 'Options', options);
figure; 
groupLabel = [ zeros( length(tSwrPos),1), ones( length(tSwrPos),1) ];
grps = cluster(GMModel2,tSwrPos);
h = gscatter(tSwrPos(:,1),tSwrPos(:,2), grps ); hold on;
scatter(GMModel2.mu(:,1),GMModel2.mu(:,2), 'b', 'filled')


GMModel = fitgmdist(tSwrPos,5, 'Start', [ 370, 606; 239, 428; 82, 311; 340, 77; 350, 337 ] );

options = statset('MaxIter',5000);
GMModel = fitgmdist(tSwrPos,8, 'Options', options);
figure
groupLabel = [ zeros( length(tSwrPos),1), ones( length(tSwrPos),1) ];
h = gscatter(tSwrPos(:,1),tSwrPos(:,2), grps );
hold on
scatter(GMModel.mu(:,1),GMModel.mu(:,2), 'b', 'filled')
figure; ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]))

f = @(x,y) sin(x) + cos(y);




% check to see if the GMModel can slice apart the spatial data
% it can! Sometimes, it does a better job parsing out the bucket than my
% other method.
options = statset('MaxIter',5000);
GMModel2 = fitgmdist([xrpos yrpos],5, 'Options', options);
figure; 
grps = cluster(GMModel2,[xrpos yrpos]);
h = gscatter(xrpos,yrpos, grps ); hold on;
scatter(GMModel2.mu(:,1),GMModel2.mu(:,2), 'b', 'filled')



figure; subplot(1,2,1);
groupLabel = [ zeros( length(tSwrPos),1), ones( length(tSwrPos),1) ];
grps = cluster(GMModel,tSwrPos);
h = gscatter(tSwrPos(:,1),tSwrPos(:,2), grps ); hold on;
scatter(GMModel.mu(:,1),GMModel.mu(:,2), 'b', 'filled')
haxis = gca;
xlim = haxis.XLim;
ylim = haxis.YLim;
d = (max([xlim ylim])-min([xlim ylim]))/1000; % division factor controls contour smoothness
[X1Grid,X2Grid] = meshgrid(xlim(1):d:xlim(2),ylim(1):d:ylim(2));
hold on
subplot(1,2,2);
h = gscatter(tSwrPos(:,1),tSwrPos(:,2), grps ); hold on;
contour(X1Grid,X2Grid,reshape(pdf(GMModel,[X1Grid(:) X2Grid(:)]),...
    size(X1Grid,1),size(X1Grid,2)),1000)




fcontour(@(x1,x2)pdf(GMModel,[x1 x2]))


,get(gca,{'XLim','YLim'}))
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
legend(h,'Model 0','Model1')
hold off





tSwrAll=swrPosAll';

options = statset('MaxIter',5000);
GMModel = fitgmdist(tSwrAll,10, 'Options', options);
figure; 
%grps = cluster(GMModel,tSwrAll);
hold on;
h = gscatter(tSwrAll(:,1),tSwrAll(:,2), grps ); hold on;
scatter(GMModel.mu(:,1),GMModel.mu(:,2), 'b', 'filled')


grps( grps==3 ) = 2;
grps( grps==4 ) = 2;
grps( grps==7 ) = 2;
grps( grps==10 ) = 2;
grps( grps==9 ) = 5;
unique(grps)
grps( grps==1 ) = 3;
grps( grps==2 ) = 1;
grps( grps==5 ) = 2;
grps( grps==8 ) = 4;
grps( grps==6 ) = 5;

output.swrLocationLabelIdx=grps;
output.swrLocationLabels = { 'bucket' 'start' 'maze' 'north' 'south'  };


grps == 9




% spikeTimeStamps = ...
%     [ tt.TT12a.spiketimestamps( tt.TT12a.cellNumber>0 ); ...
%     tt.TT13a.spiketimestamps( tt.TT13a.cellNumber==1 ); ...
%     tt.TT13a.spiketimestamps( tt.TT13a.cellNumber==2 ); ...
%     tt.TT13a.spiketimestamps( tt.TT13a.cellNumber==1 ); ...
%     tt.TT21a.spiketimestamps( tt.TT21a.cellNumber==2 ); ...
%     tt.TT21a.spiketimestamps( tt.TT21a.cellNumber==5 ); ...
%     tt.TT21a.spiketimestamps( tt.TT21a.cellNumber==8 ) ];





[ ~, lfpTimestamps ]=csc2mat( [ '/Volumes/Seagate Expansion Drive/h5/2018-05-11_training10_bananas/CSC68.ncs' ] );
% all the HF tetrodes
spikeTimeStamps = ...
    [ tt.TT12a.spiketimestamps( tt.TT12a.cellNumber>0 ); ...
    tt.TT13a.spiketimestamps( tt.TT13a.cellNumber>0 ); ...
    tt.TT16a.spiketimestamps( tt.TT16a.cellNumber>0 ); ...
    tt.TT17a.spiketimestamps( tt.TT17a.cellNumber>0 ); ...
    tt.TT19a.spiketimestamps( tt.TT19a.cellNumber>0 ); ...
    tt.TT21a.spiketimestamps( tt.TT21a.cellNumber>0 ) ];
spikeTimestampSeconds = (spikeTimeStamps - lfpTimestamps(1))/1e6;
nearestSpike = zeros(1,length(cleanSwrIdxs));
spikeCountWithinOneHundredMs = zeros(1,length(cleanSwrIdxs));
for ii=1:length(cleanSwrIdxs)
    nearestSpike(ii) = min(abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) ));
    spikeCountWithinOneHundredMs(ii) = sum( abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) )<0.1);
end
figure;
subplot(1,2,1); hold on; histogram(nearestSpike,0:.01:1); title('time delay to nearest spike');
subplot(1,2,2); hold on; histogram(spikeCountWithinOneHundredMs,0:10); title('Dist. of # spikes within 100ms of SWR');
%
spikeTimeStamps = ...
    [ tt.TT12a.spiketimestamps( tt.TT12a.cellNumber>0 ); ...
    tt.TT13a.spiketimestamps( tt.TT13a.cellNumber>0 ); ];
spikeTimestampSeconds = (spikeTimeStamps - lfpTimestamps(1))/1e6;
nearestSpike = zeros(1,length(cleanSwrIdxs));
spikeCountWithinOneHundredMs = zeros(1,length(cleanSwrIdxs));
for ii=1:length(cleanSwrIdxs)
    nearestSpike(ii) = min(abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) ));
    spikeCountWithinOneHundredMs(ii) = sum( abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) )<0.1);
end
subplot(1,2,1); hold on; histogram(nearestSpike,0:.01:1); title('time delay to nearest spike');
subplot(1,2,2); hold on; histogram(spikeCountWithinOneHundredMs,0:10); title('Dist. of # spikes within 100ms of SWR');
%
spikeTimeStamps = ...
    [ tt.TT5a.spiketimestamps( tt.TT5a.cellNumber>0 ); ...
    tt.TT6a.spiketimestamps( tt.TT6a.cellNumber>0 ); ];
spikeTimestampSeconds = (spikeTimeStamps - lfpTimestamps(1))/1e6;
nearestSpike = zeros(1,length(cleanSwrIdxs));
spikeCountWithinOneHundredMs = zeros(1,length(cleanSwrIdxs));
for ii=1:length(cleanSwrIdxs)
    nearestSpike(ii) = min(abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) ));
    spikeCountWithinOneHundredMs(ii) = sum( abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) )<0.1);
end
subplot(1,2,1); hold on; histogram(nearestSpike,0:.01:1); title('time delay to nearest spike');
subplot(1,2,2); hold on; histogram(spikeCountWithinOneHundredMs,0:10); title('Dist. of # spikes within 100ms of SWR');
%
spikeTimeStamps = ...
    [ tt.TT28a.spiketimestamps( tt.TT27a.cellNumber>0 );  ];
spikeTimestampSeconds = (spikeTimeStamps - lfpTimestamps(1))/1e6;
nearestSpike = zeros(1,length(cleanSwrIdxs));
spikeCountWithinOneHundredMs = zeros(1,length(cleanSwrIdxs));
for ii=1:length(cleanSwrIdxs)
    nearestSpike(ii) = min(abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) ));
    spikeCountWithinOneHundredMs(ii) = sum( abs( spikeTimestampSeconds-swrPeakTimes(cleanSwrIdxs(ii)) )<0.1);
end
subplot(1,2,1); hold on; histogram(nearestSpike,0:.01:1); title('time delay to nearest spike');
subplot(1,2,2); hold on; histogram(spikeCountWithinOneHundredMs,0:10); title('Dist. of # spikes within 100ms of SWR');



figure;
scatter3( swrThetaAll(cleanSwrIdxs), swrSpeedAll(cleanSwrIdxs), swrPeakValues(cleanSwrIdxs), 'filled', 'k' ); alpha(.2); xlabel('theta env'); ylabel('speed');

figure; histogram( swrPeakValues(cleanSwrIdxs) )

cleanSwrIdxs=1:length(swrPeakTimes); cleanSwrIdxs(swrPeakTimesUnionIdxs)=[];

cleanerSwrIdxs = cleanSwrIdxs;
cleanerSwrIdxs( swrSpeedAll(cleanSwrIdxs)>.1 ) = [];
figure;
subplot(4,4,[ 2 3 4 6 7 8 10 11 12 ]); scatter( swrThetaAll(cleanerSwrIdxs), swrSpeedAll(cleanerSwrIdxs), 'filled', 'k' ); alpha(.2); xlabel('theta env'); ylabel('speed');
subplot(4,4,[ 14 15 16 ]); histogram( swrThetaAll(cleanerSwrIdxs), 0:.05:1.2 );
subplot(4,4,[ 1 5 9 ]); histogram( swrSpeedAll(cleanerSwrIdxs), 0:.5:10, 'Orientation', 'horizontal' );



figure; hold on;
scatter3( swrThetaAll(grps==1), swrSpeedAll(grps==1), swrPeakValues(grps==1), 'filled' ); alpha(.2);
scatter3( swrThetaAll(grps==2), swrSpeedAll(grps==2), swrPeakValues(grps==2), 'filled' ); alpha(.2);
scatter3( swrThetaAll(grps==3), swrSpeedAll(grps==3), swrPeakValues(grps==3), 'filled' ); alpha(.2);
scatter3( swrThetaAll(grps==4), swrSpeedAll(grps==4), swrPeakValues(grps==4), 'filled' ); alpha(.2);
scatter3( swrThetaAll(grps==5), swrSpeedAll(grps==5), swrPeakValues(grps==5), 'filled' ); alpha(.2);
xlabel('theta env'); ylabel('speed'); zlabel('peak');
legend('bckt','strt','ctr','nrth','sth')




%% cross correlations


% select certain, clean, low speed SWR
cleanSwrMask = ones(length(swrPeakTimes),1); cleanSwrMask(swrPeakTimesUnionIdxs)=0;
tempMask = (cleanSwrMask .* (grps==1) .* (swrSpeedAll<=10)' ) > 0 ;

gcf=figure(11);

tetrodeList = fieldnames(output.tt);
plotIdx = 1; printIdx = 1;
for ttIdx=1:length(tetrodeList)
    % set up variables
    cellTimesAllSeconds = (output.tt.(tetrodeList{ttIdx}).spiketimestamps-thetaTimestamps(1))/1e6;
    cellNumber = output.tt.(tetrodeList{ttIdx}).cellNumber;
    for whichCell = 1:max(cellNumber)
        % plot swr X cell firing
        subplot(3,4,plotIdx);
        hold off;
        tempMask = (cleanSwrMask .* (grps==1) .* (swrSpeedAll<=10)' ) > 0 ;
        [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask) );
        plot(lagtimes,xcorrValues/max(xcorrValues), 'k', 'LineWidth', 2);
        hold on;
        tempMask = (cleanSwrMask .* (grps==2) .* (swrSpeedAll<=10)' ) > 0 ;
        [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask) );
        plot(lagtimes,xcorrValues/max(xcorrValues), 'Color', [ .9 .2 .2 ], 'LineWidth', 1); 
        tempMask = (cleanSwrMask .* (grps==3) .* (swrSpeedAll<=10)' ) > 0 ;
        [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask) );
        scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
        plot(lagtimes,xcorrValues/max(xcorrValues), 'Color', [ .2 .9 .2 ], 'LineWidth', 1);
        tempMask = (cleanSwrMask .* (grps==4) .* (swrSpeedAll<=10)' ) > 0 ;
        [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask) );
        scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
        plot(lagtimes,xcorrValues/max(xcorrValues), 'Color', [ .2 .2 .9 ], 'LineWidth', 1); 
        tempMask = (cleanSwrMask .* (grps==5) .* (swrSpeedAll<=10)' ) > 0 ;
        [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask) );
        scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
        plot(lagtimes,xcorrValues/max(xcorrValues), 'Color', [ .8 .2 .8 ], 'LineWidth', 1); 
        title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) '; n=' num2str(sum(cellNumber==whichCell)) ]);
        %legend('bucket','start','center','north','south');
        plotIdx = plotIdx + 1;
        if plotIdx > 12
            print(gcf, [ '~/data/h5_May-11-2018_swrXspike_norm_' num2str(printIdx) '_.png'],'-dpng','-r200');
            plotIdx = 1;
            printIdx = printIdx + 1;
            clf;
        end
    end
end






%% shuffle corrected xcorr

eliminationResolution = 1000/50; % 1000 ms / 20 ms bins
[ swrNoiseTimes, swrAvgPeakTimesUnionIdxs, swrPeakTimesUnionIdxs ]=intersect( round(swrAvgPeakTimes*eliminationResolution), round(swrPeakTimes*eliminationResolution) );

% select certain, clean, low speed SWR
cleanSwrMask = ones(length(swrPeakTimes),1); cleanSwrMask(swrPeakTimesUnionIdxs)=0;
tempMask = (cleanSwrMask .* (grps==1) .* (swrSpeedAll<=10)' .* (swrPeakTimes<1100) ) > 0 ;

tetrodeList = fieldnames(output.tt);
plotIdx = 1; printIdx = 1;
xcorrBinSize=0.02; % seconds
maxLagTime=2; % seconds
shuffleRepeats = 1000; % repeats
jitterWindow = 2; % seconds
forcedOffset = 1; % seconds
%
rng(1); s = RandStream('mlfg6331_64');  % repeatability!
precalculatedPolarity=ones(shuffleRepeats,length(swrPeakTimes)); % build binary vector to precalculate add or subtract
for ii=1:shuffleRepeats
    tempIdx = datasample(s,1:length(swrPeakTimes),round(length(swrPeakTimes)/2),'Replace',false);
    precalculatedPolarity( ii, tempIdx )=-1; % set said polarity vector
end
precalculatedShuffle=precalculatedPolarity.*(forcedOffset+jitterWindow*rand(shuffleRepeats,length(swrPeakTimes)));
%precalculatedShuffle=-(forcedOffset+rand(shuffleRepeats,length(swrPeakTimes)));
%
gcf=figure(11); plotIdx=1; printIdx=1;
%

            ttIdx= 8; whichCell= 1; gr = 1;

for ttIdx = 1:length(tetrodeList)
    % set up variables
    cellTimesAllSeconds = (output.tt.(tetrodeList{ttIdx}).spiketimestamps-thetaTimestamps(1))/1e6;
    cellNumber = output.tt.(tetrodeList{ttIdx}).cellNumber;
    for whichCell = 1:max(cellNumber)
        % plot swr X cell firing
        for gr=1:5
            subplot(3,2,plotIdx);
            tempMask = (cleanSwrMask .* (grps==gr) .* (swrSpeedAll<=10)'  .* (swrPeakTimes>=1100) ) > 0 ;
            xcorrs = zeros( 1+2*(maxLagTime/xcorrBinSize), shuffleRepeats ); dims = size( cellTimesAllSeconds(cellNumber==whichCell) );
            for whichShuffle=1:shuffleRepeats
                xcorrs(:,whichShuffle) = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask)+precalculatedShuffle(whichShuffle,tempMask)', xcorrBinSize, maxLagTime );
            end
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask), xcorrBinSize, maxLagTime );
            %hold off;
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) ' ' (output.swrLocationLabels{gr})  '; n=' num2str(sum(cellNumber==whichCell)) ]);
            fill_between_lines(lagtimes, prctile(xcorrs',0.5), prctile(xcorrs',99.5),1); alpha(.2); hold on;
            fill_between_lines(lagtimes, prctile(xcorrs',2.5), prctile(xcorrs',98.5),2); alpha(.2);
            fill_between_lines(lagtimes, prctile(xcorrs',25), prctile(xcorrs',75),3); alpha(.2);
            plot(lagtimes, prctile(xcorrs',50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
            plot(lagtimes,xcorrValues, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
            title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) ' ' (output.swrLocationLabels{gr}) '; n=' num2str(sum(cellNumber==whichCell)) ]);
            %
            plotIdx = plotIdx+1;
            if plotIdx > 5
%                print(gcf,[ '~/data/h5_May-11-2018_swrXspike_reshift_' (tetrodeList{ttIdx}) '_C' num2str(whichCell) '_' (output.swrLocationLabels{gr}) '_.png'],'-dpng','-r200');
                %print(gcf, [ '~/data/h5_May-11-2018_swrXspike_norm_' num2str(printIdx) '_.png'],'-dpng','-r200');
                plotIdx = 1;
                printIdx = printIdx + 1;
                %clf;
            end
        end
    end
end



figure;
tempMask = (cleanSwrMask .* (grps==1) .* (swrSpeedAll<=10)' ) > 0 ;
histogram( swrPeakTimes(tempMask), 1:round(xytimestampSeconds(end))+1 );
hold on;
tempMask = (cleanSwrMask .* (grps==2) .* (swrSpeedAll<=10)' ) > 0 ;
histogram( swrPeakTimes(tempMask), 1:round(xytimestampSeconds(end))+1 );
tempMask = (cleanSwrMask .* (grps==3) .* (swrSpeedAll<=10)' ) > 0 ;
histogram( swrPeakTimes(tempMask), 1:round(xytimestampSeconds(end))+1 );
tempMask = (cleanSwrMask .* (grps==4) .* (swrSpeedAll<=10)' ) > 0 ;
histogram( swrPeakTimes(tempMask), 1:round(xytimestampSeconds(end))+1 );
tempMask = (cleanSwrMask .* (grps==5) .* (swrSpeedAll<=10)' ) > 0 ;
histogram( swrPeakTimes(tempMask), 1:round(xytimestampSeconds(end))+1 );



tSwrPos = swrPosAll( :, cleanSwrMask )';
figure;
h = gscatter( swrPosAll(1,:), swrPosAll(2,:), grps );


isSouth=distFromPoint(xrpos,yrpos,344,0)<145;  % r
isNorth=distFromPoint(xrpos,yrpos,376,656)<135;  % r
isWest=distFromPoint(xrpos,yrpos,0,313)<145;  % r
figure; plot(inBucketSmoothed, 'k'); hold on; plot(isSouth, 'r'); plot(isNorth, 'b'); plot(isWest, 'g'); ylim([ 0 2]);

positionGroups = ( ((inBucketSmoothed==1)) + isWest*2 + isNorth*3 + isSouth*4 );
figure; h = gscatter( xrpos, yrpos, positionGroups );



% build code for all xy positions for firing zone
isSouth=distFromPoint(xrpos,yrpos,344,0)<145;  % r
isNorth=distFromPoint(xrpos,yrpos,376,656)<135;  % r
isWest=distFromPoint(xrpos,yrpos,0,313)<145;  % r
positionGroups = ( ((inBucketSmoothed==1)) + isWest*2 + isNorth*3 + isSouth*4 );
figure; h = gscatter( xrpos, yrpos, positionGroups );

figure; subplot(8,1,1:2);
bins = sort(unique([ 0 xytimestampSeconds(find(abs(diff(positionGroups)))) xytimestampSeconds(end) ]));
histogram( swrPeakTimes, bins');
subplot(8,1,3);
plot(xytimestampSeconds,inBucketSmoothed, 'k+'); hold on; plot(xytimestampSeconds,isSouth, 'r+'); plot(xytimestampSeconds,isNorth, 'b+'); plot(xytimestampSeconds,isWest, 'g+'); ylim([ 0 2]);
%plot(xytimestampSeconds, positionGroups);
subplot(8,1,4:5);
[yy]=histcounts( swrPeakTimes, bins);
plot(bins(2:end)-diff(bins)/2,yy./diff(bins));
xlabel('SWR rate');
subplot(8,1,6:8);
swrRate=yy./diff(bins);
swrRateTimes=bins(2:end)-diff(bins)/2;
transGrp=positionGroups(find(abs(diff(positionGroups)))); hold off;
plot(swrRateTimes(transGrp==0), swrRate(transGrp==0)); hold on;
plot(swrRateTimes(transGrp==1), swrRate(transGrp==1));
plot(swrRateTimes(transGrp==2), swrRate(transGrp==2));
plot(swrRateTimes(transGrp==3), swrRate(transGrp==3));
plot(swrRateTimes(transGrp==4), swrRate(transGrp==4));
legend('maze','bucket','start','rew1','rew2')


figure; plot(swrRateTimes(transGrp==2), swrRate(transGrp==2), '-o'); hold on; plot(swrRateTimes(transGrp==1), swrRate(transGrp==1), '+-');




% find out which zone a particular cell is firing in
isSouth=distFromPoint( tt.TT12a.cellPosAll(1,tt.TT12a.cellNumber==1), tt.TT12a.cellPosAll(2,tt.TT12a.cellNumber==1), 344, 0 )<145;  % r
isNorth=distFromPoint( tt.TT12a.cellPosAll(1,tt.TT12a.cellNumber==1), tt.TT12a.cellPosAll(2,tt.TT12a.cellNumber==1),376,656)<135;  % r
isWest=distFromPoint( tt.TT12a.cellPosAll(1,tt.TT12a.cellNumber==1), tt.TT12a.cellPosAll(2,tt.TT12a.cellNumber==1),0,313)<145;  % r
positionGroups = ( ((tt.TT12a.cellInBucket(tt.TT12a.cellNumber==1)==0)) + isWest*2 + isNorth*3 + isSouth*4 );
figure; h = gscatter( tt.TT12a.cellPosAll(1,tt.TT12a.cellNumber==1), tt.TT12a.cellPosAll(2,tt.TT12a.cellNumber==1), positionGroups );

thisCellFireTime = ( tt.TT12a.spiketimestamps(tt.TT12a.cellNumber==1) - thetaTimestamps(1))/1e6;
figure; subplot(8,1,1:2);

histogram( thisCellFireTime, bins');
subplot(8,1,3);
plot(thisCellFireTime,inBucketSmoothed, 'k+'); hold on; plot(thisCellFireTime,isSouth, 'r+'); plot(thisCellFireTime,isNorth, 'b+'); plot(thisCellFireTime,isWest, 'g+'); ylim([ 0 2]);
%plot(xytimestampSeconds, positionGroups);
subplot(8,1,4:5);
[yy]=histcounts( thisCellFireTime, bins);
plot(bins(2:end)-diff(bins)/2,yy./diff(bins));
xlabel('SWR rate');
subplot(8,1,6:8);
swrRate=yy./diff(bins);
swrRateTimes=bins(2:end)-diff(bins)/2;
transGrp=positionGroups(find(abs(diff(positionGroups)))); hold off;
plot(swrRateTimes(transGrp==0), swrRate(transGrp==0)); hold on;
plot(swrRateTimes(transGrp==1), swrRate(transGrp==1));
plot(swrRateTimes(transGrp==2), swrRate(transGrp==2));
plot(swrRateTimes(transGrp==3), swrRate(transGrp==3));
plot(swrRateTimes(transGrp==4), swrRate(transGrp==4));
legend('maze','bucket','start','rew1','rew2')

figure; histogram(thisCellFireTime,1:xytimestampSeconds(end));






%% break the session up by trial and stage and plot the SWR rate during that stage.

bins=[ 0 sort(trialTransitionTimes(:))'  xytimestampSeconds(end) ];
[yy]=histcounts( swrPeakTimes, bins);
swrRate=yy./diff(bins);
swrRateTimes=bins(2:end)-diff(bins)/2;
figure;
subplot( 10, 1, 1:6 );
title('behavioral performance');
plot(swrRate(5:4:length(swrRate)), '+-', 'LineWidth', 2)
hold on;
plot(swrRate(2:4:length(swrRate)), '+-', 'LineWidth', 2)
plot(swrRate(3:4:length(swrRate)), '+-', 'LineWidth', 2)
plot(swrRate(4:4:length(swrRate)), '+-', 'LineWidth', 2)
legend('bucket','start','maze','reward')
ylabel('SWR Rate (Hz)');
subplot( 10, 1, 7 );
plot( (trialTimeToReward), '+-', 'Color', [ .3 .9 .3 ], 'LineWidth', 2);
ylabel( 'time to reward' );
subplot( 10, 1, 8 );
bar(trialError, 'r', 'BarWidth', 1); ylim([ -.5 1.5 ]);
ylabel('error');
subplot( 10, 1, 9 );
bar(trialRewardReversed, 'FaceColor', [ .4 .5 .8 ], 'BarWidth', 1); ylim([ -.5 1.5 ]);
ylabel('reverse');
subplot( 10, 1, 10 );
%plot(trialBarrierSize); ylim([ -.5 3.5 ]);
bar(trialBarrierSize, 'FaceColor', [ .7 .2 .7 ] , 'BarWidth', 1); ylim([ -.5 3.5 ]);
ylabel('barrier');
xlabel('trial number');



ylabel('SWR rate');
histogram( swrPeakTimes, bins');
subplot(8,1,3);
plot(xytimestampSeconds,inBucketSmoothed, 'k+'); hold on; plot(xytimestampSeconds,isSouth, 'r+'); plot(xytimestampSeconds,isNorth, 'b+'); plot(xytimestampSeconds,isWest, 'g+'); ylim([ 0 2]);
%plot(xytimestampSeconds, positionGroups);
subplot(8,1,4:5);

plot(bins(2:end)-diff(bins)/2,yy./diff(bins));




%% stuff

figure; plot((output.thetaTimestamps-output.thetaTimestamps(1))/1e6 ,output.thetaLfp);






%% cross correlation code for unclustered SWR days

% output=importdata('/Users/andrewhowe/data/cache/h5_2018-04-25_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-04-30_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-01_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-02_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-07_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-08_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-09_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-11_spikeData.dat');
output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-14_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-15_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-16_spikeData.dat');
% output=importdata('/Users/andrewhowe/data/cache/h5_2018-05-18_spikeData.dat');



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

grps=output.swrLocationLabelIdx;

%% construct missing data

inBucketSmoothed = inBucketSmoothed > 0;
swrInBucket = inBucketSmoothed(floor(swrPeakTimes*29.97)+1) > 0;
hiGammaInBucket = inBucketSmoothed(floor(hiGammaAvgPeakTimes*29.97)+1) > 0;
xytimestampSeconds = (0:length(xrpos)-1)/29.97;



% select certain, clean, low speed SWR
cleanSwrMask = ones(length(swrPeakTimes),1); cleanSwrMask(swrPeakTimesUnionIdxs)=0;
tempMask = (cleanSwrMask .* (grps==1) .* (swrSpeedAll<=10)' ) > 0 ;

tetrodeList = fieldnames(output.tt);
plotIdx = 1; printIdx = 1;
xcorrBinSize=0.02; % seconds
maxLagTime=2; % seconds
shuffleRepeats = 1000; % repeats
jitterWindow = 2; % seconds
forcedOffset = 1; % seconds
%
rng(1); s = RandStream('mlfg6331_64');  % repeatability!
precalculatedPolarity=ones(shuffleRepeats,length(swrPeakTimes)); % build binary vector to precalculate add or subtract
for ii=1:shuffleRepeats
    tempIdx = datasample(s,1:length(swrPeakTimes),round(length(swrPeakTimes)/2),'Replace',false);
    precalculatedPolarity( ii, tempIdx )=-1; % set said polarity vector
end
precalculatedShuffle=precalculatedPolarity.*(forcedOffset+jitterWindow*rand(shuffleRepeats,length(swrPeakTimes)));
%precalculatedShuffle=-(forcedOffset+rand(shuffleRepeats,length(swrPeakTimes)));
%
gcf=figure(11); plotIdx=1; printIdx=1;
%

            ttIdx= 9; whichCell= 4; gr = 1;

for ttIdx = 1:length(tetrodeList)
    % set up variables
    cellTimesAllSeconds = (output.tt.(tetrodeList{ttIdx}).spiketimestamps-thetaTimestamps(1))/1e6;
    cellNumber = output.tt.(tetrodeList{ttIdx}).cellNumber;
    for whichCell = 1:max(cellNumber)
        % plot swr X cell firing
        for gr=1:5
            subplot(3,2,plotIdx);
            tempMask = (cleanSwrMask .* (grps==gr) .* (swrSpeedAll<=10)' ) > 0 ;
            xcorrs = zeros( 1+2*(maxLagTime/xcorrBinSize), shuffleRepeats ); dims = size( cellTimesAllSeconds(cellNumber==whichCell) );
            for whichShuffle=1:shuffleRepeats
                xcorrs(:,whichShuffle) = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask)+precalculatedShuffle(whichShuffle,tempMask)', xcorrBinSize, maxLagTime );
            end
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask), xcorrBinSize, maxLagTime );
            %hold off;
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) ' ' (output.swrLocationLabels{gr})  '; n=' num2str(sum(cellNumber==whichCell)) ]);
            fill_between_lines(lagtimes, prctile(xcorrs',0.5), prctile(xcorrs',99.5),1); alpha(.2); hold on;
            fill_between_lines(lagtimes, prctile(xcorrs',2.5), prctile(xcorrs',98.5),2); alpha(.2);
            fill_between_lines(lagtimes, prctile(xcorrs',25), prctile(xcorrs',75),3); alpha(.2);
            plot(lagtimes, prctile(xcorrs',50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
            plot(lagtimes,xcorrValues, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
            title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) ' ' (output.swrLocationLabels{gr}) '; n=' num2str(sum(cellNumber==whichCell)) ]);
            %
            plotIdx = plotIdx+1;
            if plotIdx > 5
                print(gcf,[ '~/data/h5_May-11-2018_swrXspike_reshift_' (tetrodeList{ttIdx}) '_C' num2str(whichCell) '_' (output.swrLocationLabels{gr}) '_.png'],'-dpng','-r200');
                %print(gcf, [ '~/data/h5_May-11-2018_swrXspike_norm_' num2str(printIdx) '_.png'],'-dpng','-r200');
                plotIdx = 1;
                printIdx = printIdx + 1;
                clf;
            end
        end
    end
end




















xcorrBinSize = 0.01;
maxLagTime = 2;
ttIdx=12;
whichCell=3;

cellTimesAllSeconds = (output.tt.(tetrodeList{ttIdx}).spiketimestamps-thetaTimestamps(1))/1e6;
cellNumber = output.tt.(tetrodeList{ttIdx}).cellNumber;
hold on; %figure;
[ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes, xcorrBinSize, maxLagTime );
scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
plot(lagtimes,xcorrValues/max(xcorrValues), 'LineWidth', 1); %, 'Color', [ .8 .2 .8 ]









dir
dateStr

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