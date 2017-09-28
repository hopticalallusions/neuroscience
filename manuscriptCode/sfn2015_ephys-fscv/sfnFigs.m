close all; clear all;

%% get the lag
basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/platter/'],[basedir '/nlx/platter/'],7)
%alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/maze/'],[basedir '/nlx/maze/'],7)

%% load the fscv data
daConc=loadTarheelCsvData([basedir '/fscv/platter/'],.993);
%daConc=loadTarheelCsvData([basedir '/fscv/maze/'],.993);
[daCorr,lag]=xcorr(daConc,daConc, 1800); %max lag of 3 minutes * 600 samples per minute
[~,I]=max(abs(daCorr));
% check that there are not 1 minute stitching artifacts
figure; plot(lag/600, daCorr); axis([ -2.1 2.1 min(daCorr) 1e6 ]);
title('detrended DA autocorrelegram'); xlabel('lag (min)'); ylabel('corr')


sigma = 10;
filterWindowLength = 50;
x = linspace(-filterWindowLength / 2, filterWindowLength / 2, filterWindowLength);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
%and in order to apply it you can use filter:
%yfilt = filter (gaussFilter,1, daConc);  % phase shifted
yfilt = conv (daConc, gaussFilter, 'same');  % not phase shifted
figure; plot(daConc); hold on; plot(yfilt);
%and don't forget the filter has latency, which means the filtered signal is shifted as compared to the input signal. Since this filter is symmetric, you can get a non-shifted output by using conv instead of filter, and use the same option:
figure; plot(daConc-yfilt);
dafilt=(daConc-yfilt);


plotFft(daConc,10);


%% get the video data and fix it
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat([basedir '/nlx/platter/VT0.nvt']);
%[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat([basedir '/nlxmaze/VT0.nvt']);
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);
figure;
plot(xpos,ypos);

%% visualize the rat's behavior during quarters of the behavior
% i.e. does he change his behavior over the task in a grossly recognizable
% way?
figure;
subplot(2,2,1); plot(xpos(1:round(end*1/4)),ypos(1:round(end*1/4))); legend('1st Qtr');
subplot(2,2,2); plot(xpos(round(end*1/4):round(end*2/4)),ypos(round(end*1/4):round(end*2/4))); legend('2nd Qtr');
subplot(2,2,3); plot(xpos(round(end*2/4):round(end*3/4)),ypos(round(end*2/4):round(end*3/4))); legend('3rd Qtr');
subplot(2,2,4); plot(xpos(round(end*3/4):round(end*4/4)),ypos(round(end*3/4):round(end*4/4))); legend('4th Qtr');

%% load the events during recording
[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat([basedir '/nlx/platter/Events.nev']);
%[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat([basedir '/nlx/maze/Events.nev']);

%% make pretty graphs and find events
% TODO make this more robust; nlx tells you the up and the down of all
% output ttls every time one changes. woooo.
ttlRewardCSevenIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x0007).') )));
%
vidIdxSevens=zeros(length(ttlRewardCSevenIdx),1);
for idx=1:length((ttlRewardCSevenIdx))
    vidIdxSevens(idx) = min(find((EventStamps(ttlRewardCSevenIdx(idx))<xyPositionTimestamps)));
end
figure; plot(xpos,ypos,'Color', [ .5 .5 .5]);
hold on; plot(xpos(vidIdxSevens), ypos(vidIdxSevens), '*');
%plot(xpos(vidIdxSevens(end-10:end)), ypos(vidIdxSevens(end-10:end)), 'o');
%
zoneZeroIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
zoneZeroIdxs=[zoneZeroIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Exited') )))];
vidIdxZoneZero=zeros(length(zoneZeroIdxs),1);
for idx=1:length((zoneZeroIdxs))
    vidIdxZoneZero(idx) = min(find((EventStamps(zoneZeroIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneZero), ypos(vidIdxZoneZero), '.', 'MarkerSize',16);
zoneOneIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Entered') )));
zoneOneIdxs=[zoneOneIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Exited') )))];
vidIdxZoneOne=zeros(length(zoneOneIdxs),1);
for idx=1:length((zoneOneIdxs))
    vidIdxZoneOne(idx) = min(find((EventStamps(zoneOneIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneOne), ypos(vidIdxZoneOne), '.', 'MarkerSize',16);
zoneTwoIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone2 Entered') )));
zoneTwoIdxs=[zoneTwoIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone2 Exited') )))];
vidIdxZoneTwo=zeros(length(zoneTwoIdxs),1);
for idx=1:length((zoneTwoIdxs))
    vidIdxZoneTwo(idx) = min(find((EventStamps(zoneTwoIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneTwo), ypos(vidIdxZoneTwo), '.', 'MarkerSize',16);
zoneThreeIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone3 Entered') )));
zoneThreeIdxs=[zoneThreeIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone3 Exited') )))];
vidIdxZoneThree=zeros(length(zoneThreeIdxs),1);
for idx=1:length((zoneThreeIdxs))
    vidIdxZoneThree(idx) = min(find((EventStamps(zoneThreeIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneThree), ypos(vidIdxZoneThree), '.', 'MarkerSize',16);
legend('position','rewarded','zone 0','zone 1','zone 2','zone 3');
text(200,460,'wall w/ light')
text(200,35,'wall w/ dark')
text(580,140,'connection chair')


%% try to extract some dopamine information
% positive lag = nlx started after da, so look into future of daConc. data
nlxStartRecordingIdx = find(not(cellfun('isempty', strfind(EventStrings, 'Starting Recording'))));
nlxEndRecordingIdx = find(not(cellfun('isempty', strfind(EventStrings, 'Stopping Recording'))));
numFscvWindowsNlx = ceil((EventStamps(nlxEndRecordingIdx) - EventStamps(nlxStartRecordingIdx))/100000);
%I think the alignment lag is in units of 100 ms
%procedure will be
% find idx of event
% find time of event
% divide time of event by 100,000 to makie it 100's of a second
% ceil or round or whatever
% add the offset above
% pull da values
daIdx=alignmentLag+ceil((EventStamps(ttlRewardCSevenIdx)-EventStamps(1))/100000);
daRewards = daConc(daIdx);
figure; subplot(3,1,1); hist(daConc,min(daConc):max(daConc));
subplot(3,1,2); hist(daConc(daIdx-5),min(daConc):max(daConc));
subplot(3,1,3); hist( [daConc(daIdx);daConc(daIdx+1);daConc(daIdx+2);daConc(daIdx+3);daConc(daIdx+4)],min(daConc):max(daConc));
figure;
subplot(2,3,1); hist(daConc,min(daConc):max(daConc)); legend('all');
subplot(2,3,2); daIdx=alignmentLag+ceil((EventStamps(zoneZeroIdxs)-EventStamps(1))/100000); hist(daConc(daIdx),min(daConc):5:max(daConc)); legend('Zero');
subplot(2,3,3); daIdx=alignmentLag+ceil((EventStamps(zoneOneIdxs)-EventStamps(1))/100000); hist(daConc(daIdx),min(daConc):5:max(daConc)); legend('One');
subplot(2,3,4); daIdx=alignmentLag+ceil((EventStamps(zoneTwoIdxs)-EventStamps(1))/100000); hist(daConc(daIdx),min(daConc):5:max(daConc)); legend('Two');
subplot(2,3,5); daIdx=alignmentLag+ceil((EventStamps(zoneThreeIdxs)-EventStamps(1))/100000); hist(daConc(daIdx),min(daConc):5:max(daConc)); legend('Three');


%% second version of the above, using a different reward criteria
zoneZeroEntryIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
daIdx=alignmentLag+ceil((EventStamps(zoneZeroEntryIdxs)-EventStamps(1))/100000);
vidIdxZoneZero=zeros(length(zoneZeroEntryIdxs),1);
for idx=1:length((zoneZeroEntryIdxs))
    vidIdxZoneZero(idx) = min(find((EventStamps(zoneZeroEntryIdxs(idx))<xyPositionTimestamps)));
end
figure;
for jj=-5:6
    subplot(3,4,jj+6);
    hist(daConc(daIdx+jj),-50:1:50);
    axis( [ -52 52 -1 12 ] );
    legend(['DA @ ' num2str(jj)])
end
% figure; %animate
% pause(3);
% for jj=-10:30
%     subplot(2,3,[ 2 3 5 6 ]);
%     plot( daConc(daIdx+jj), ypos(vidIdxZoneZero(1:end)+3*jj), '.', 'MarkerSize',16);
%     legend(['DA vs y @ ' num2str(jj/10) ' s'])
%     axis( [ -50 50 50 450 ] ) 
%     subplot(2,3,1);
%     hist(daConc(daIdx(find(ypos(vidIdxZoneZero(1:end)+3*jj)>260))),-50:10:50)
%     axis( [ -50 50 0 25 ] ) 
%     subplot(2,3,4);
%     hist(daConc(daIdx(find(ypos(vidIdxZoneZero(1:end)+3*jj)<250))),-50:10:50)
%     axis( [ -50 50 0 25 ] ) 
%     pause(.3)
% end
% do it again, but with the known reward firings
% note y axis scale change
daIdx=alignmentLag+ceil((EventStamps(ttlRewardCSevenIdx)-EventStamps(1))/100000);
figure;
for jj=-5:6
    subplot(3,4,jj+6);
    hist(daConc(daIdx+jj),-50:1:50);
    axis( [ -52 52 -1 8 ] );
    legend(['DA @ ' num2str(jj)])
end
figure; plot(daConc(daIdx+3), ypos(15+daIdx+10), 'o');
title('\Delta DA vs ypos(t+1s?)'); xlabel('\Delta DA (nM)'); ylabel('ypos');

meanDaBefore=zeros(length(daIdx),1);
meanDaAfter=zeros(length(daIdx),1);
for ii=1:length(daIdx);
    meanDaBefore(ii) = mean(daConc(daIdx(ii)-5:daIdx(ii)-1));
    meanDaAfter(ii) = mean(daConc(daIdx(ii)+1:daIdx(ii)+5));
end
figure; hist([meanDaBefore meanDaAfter],-50:10:50); axis tight; legend('before', 'after')
title('\Delta DA (nM) Before & After'); ylabel('freq'); xlabel('bins');



%% calculate velocity
velocity=sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'));

%% set up triggered xyz's
lookbackward=25; % dopamine samples
lookforward=40; % dopamine samples

%% event triggered velocity
%posIdx=ceil((EventStamps(zoneIdxs)-EventStamps(1))/(1e6/30)); % weirdly,
%this doesn't work too well
traces=length(vidIdxZoneZero)/2;
xstack=zeros(1+3*lookbackward+3*lookforward, traces);
ystack=zeros(1+3*lookbackward+3*lookforward, traces);
posTime=(-lookbackward*3:lookforward*3)/30;
for ii=1:traces
    xstack(:,ii)=xpos(vidIdxZoneZero(ii)-3*lookbackward:vidIdxZoneZero(ii)+3*lookforward);
    ystack(:,ii)=ypos(vidIdxZoneZero(ii)-3*lookbackward:vidIdxZoneZero(ii)+3*lookforward);
end
figure; hold on; % neato transparent graphics
plot(xpos,ypos, 'Color', [.3 .3 .3 .25], 'LineWidth', 3)
for ii=1:traces; plot( xstack(:,ii), ystack(:,ii), 'LineWidth', 3, 'Color', [ (.1+(rand(1,3)*.8)) .3] ); end;
%plot( xstack, ystack, 'LineWidth', 1, 'Color', [ .1 .3 .7 .3 ] );
plot(xstack(1,:), ystack(1,:), 'og');
plot(xstack(1+lookbackward*3,:), ystack(1+lookbackward*3,:), '+c');
plot(xstack(end,:), ystack(end,:), 'xr');
title('reward triggered paths'); xlabel('xpos'); ylabel('ypos');
%
velocityStack=sqrt(cast(((diff(xstack)).^2+(diff(ystack)).^2), 'double'));

%% event triggered average dopamine
zoneIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
daIdx=alignmentLag+ceil((EventStamps(zoneIdxs)-EventStamps(1))/100000);
daIdxBetter=daIdx(diff(daIdx)>20); % this is attempting to lock out times where he's hovering at the border
stack=zeros(1+lookbackward+lookforward,length(daIdx));
for ii=1:length(daIdxBetter)
    stack(:,ii) = daConc(daIdxBetter(ii)-lookbackward:daIdxBetter(ii)+lookforward);
end
figure; subplot(2,1,1); hold off; dims=size(stack);
meanofdata=mean(stack');
meanofdata=meanofdata-min(meanofdata);
stdev=std(stack');
stder=stdev/sqrt(dims(2));
tt=(-lookbackward:lookforward)/10;
fill_between_lines(tt,meanofdata-stder,meanofdata+stder,[.6 .9 .6])
hold on;
plot(tt,meanofdata);
title(['Zone 0 Triggered DA Average n=' num2str(length(daIdxBetter)) ' entries']);
xlabel('Time Relative to Zone Entry (s)');
ylabel('DA (nM)');
legend('std err','vel');
subplot(2,1,2);
hold on;
meanofdata=mean(velocityStack');
stdev=std(velocityStack');
stder=stdev/sqrt(dims(2));
tt=(-lookbackward*3:lookforward*3)/30;
ttPrime=tt(1:end-1)+mean(diff(tt));
fill_between_lines(ttPrime,meanofdata-stder,meanofdata+stder,[.6 .9 .6])
plot(ttPrime, mean(velocityStack'));
title('Zone 0 Triggered Velocity Average');
xlabel('Time Relative to Zone Entry (s)');
ylabel('speed (pixels per frame)');
legend('std err','vel');

figure; surf(stack)


%% DA trace surface
numBins=20;
mx=max(max(stack));
mn=min(min(stack));
bincenters=mn:(mx-mn)/(numBins-1):mx;
heatmap=zeros(numBins,1+lookforward+lookbackward);
for ii=1:1+lookforward+lookbackward
    heatmap(:,ii)=hist(stack(ii,:),bincenters);
end
figure; 
imagesc( tt, bincenters, heatmap ); 
colorbar;
title('Zone 0 Triggered DA Heatmap');
xlabel('Time Relative to Zone Entry (s)');
ylabel('DA (nM)');

%% when did events happen on the dopamine trace?
% no where consistent. :-/
figure;
plot((1:length(daConc))/600,daConc, 'Color', [ .8 .2 .2 ]);
hold on;
plot( daIdxBetter/600, daConc(daIdxBetter), 'ok','MarkerFaceColor', [ .2 1 .2 ] );
axis tight;
title('Zone 0 Triggered DA Heatmap');
xlabel('Time Relative to Zone Entry (s)');
ylabel('DA (nM)');
legend('\Delta DA (nM)','event')

%% look at baseline FSCV data
% datUncut=csvread('~/blairlab/blairlab_data/sampleBackgrounds.csv');
% dat=datUncut(:,1:990);
% vt=(((1:500)/500)*1.7)-0.4; vt=[vt fliplr(vt)]; vt=vt(1:990);
% figure; plot(vt, dat(1,:)); hold on; plot(vt, mean(dat)); legend('trace 1', 'mean trace'); ylabel('current (nA)'); xlabel('applied potential (V)'); title('representative fscv backgrounds');
% figure; hold on; for ii=1:length(dat); plot(vt, dat(ii,:)- mean(dat) ); end; ylabel('current (nA)'); xlabel('applied potential (V)'); title('representative fscv currents'); % all the traces, "background subtraced"
% figure; plot(dat(:,200)); hold on; plot(dat(:,300)); legend([ num2str(vt(200)) 'V'],[ num2str(vt(300)) 'V']); ylabel('current (nA)'); xlabel('time'); title('current at specific voltages'); 
% figure; hold on; for ii=1:length(dat); plot(vt, dat(ii,:), 'LineWidth', 1, 'Color', [ .2 .3 .6 .05]);end; ylabel('current (nA)'); xlabel('applied potential (V)'); title('all fscv currents');
% figure; hold on; plot(vt, mean(dat(1:600,:)) ); plot(vt, mean(dat(601:1200,:)) ); plot(vt, mean(dat(1201:end,:)) ); legend('min 0', 'min 20', 'min 45' ); ylabel('current (nA)'); xlabel('applied potential (V)'); title('mean bg at 3 different minutes');

%% the hunt for correlations
tempIdxs=(1:max(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))<1)));
figure;
subplot(6,1,1); plot((1:600)/600,daConc(1:600)); legend('\Delta DA (nM)');
subplot(6,1,2); plot(tempIdxs/(60*30),xpos(tempIdxs)); legend('xpos');
subplot(6,1,3); plot(tempIdxs/(60*30),ypos(tempIdxs)); legend('ypos');
tempVelocity=sqrt(cast(((diff(xpos(tempIdxs))).^2+(diff(ypos(tempIdxs))).^2), 'double'));
tempTimePrime=(tempIdxs(1:end-1)/(3*600)+mean(diff(tempIdxs/(60*30))));
subplot(6,1,4); plot(tempTimePrime, tempVelocity); legend('velocity');
subplot(6,1,5); plot(tempIdxs/(60*30), distFromPoint( xpos(tempIdxs), ypos(tempIdxs), 367, 121 )); legend('dist from lower');
subplot(6,1,6); plot(tempIdxs/(60*30), distFromPoint( xpos(tempIdxs), ypos(tempIdxs), 376, 376 )); legend('dist from upper');

startMinute=10;
endMinute=15;
tempNlxIdxs=min(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))>startMinute)):max(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))<endMinute));
tempDaIdxs = (ceil(startMinute*600):ceil(endMinute*600))+alignmentLag+17;
figure;
subplot(5,1,1); plot((tempDaIdxs)/600,daConc(tempDaIdxs)); legend('\Delta DA (nM)'); axis tight;
subplot(5,1,2); plot(tempNlxIdxs/(60*30), distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 367, 121 )); legend('dist from lower');
subplot(5,1,3); plot(tempNlxIdxs/(60*30), distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 376, 376 )); legend('dist from upper');
subplot(5,1,4); plot(tempNlxIdxs/(60*30), distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 508, 250 )); legend('dist from trigger');
tempVelocity=sqrt(cast(((diff(xpos(tempNlxIdxs))).^2+(diff(ypos(tempNlxIdxs))).^2), 'double'));
tempTimePrime=(tempNlxIdxs(1:end-1)/(3*600)+mean(diff(tempNlxIdxs/(60*30))));
subplot(5,1,2); plot(tempTimePrime, tempVelocity); legend('velocity');

figure;
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(distFromPoint( xpos, ypos, 508, 250 ),3)]);
plot(lag/10,corr); hold on;
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(distFromPoint( xpos, ypos, 376, 376 ),3)]);
plot(lag/10,corr);
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(distFromPoint( xpos, ypos, 367, 121 ),3)]);
plot(lag/10,corr);
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(distFromPoint( xpos, ypos, 275, 281 ),3)]);
plot(lag/10,corr);
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(distFromPoint( xpos, ypos, 288, 283 ),3)]);
plot(lag/10,corr);
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(velocity,3)]);
plot(lag/10,corr);
legend('zero','upper','lower','middle','left center', 'velocity');

%% distance from rewards
distLower=decimate(distFromPoint( xpos, ypos, 367, 121 ), 3);
distUpper=decimate(distFromPoint( xpos, ypos, 376, 376 ), 3);
[distLowerCorr,lagLower]=xcorr(distLower,daConc, 50); % fix lag at a behaviorally relevant timescale
[distUpperCorr,lagUpper]=xcorr(distUpper,daConc, 50); % fix lag at a behaviorally relevant timescale
[~,ILower]=max(abs(distLowerCorr)); [~,IUpper]=max(abs(distUpperCorr)); 
figure; plot((lagLower+alignmentLag)/10, distLowerCorr); title('Distace to Reward Cups vs \Delta DA correlegram'); xlabel('lag (s)'); ylabel('correlation');
hold on; plot((lagUpper+alignmentLag)/10, distUpperCorr); legend('lower','upper'); axis tight;
%lag plus offset, to correct for sync

figure;
subplot(2,2,1); hist(xpos,0:20:730); axis tight; legend('xpos'); % 720 pixels 
subplot(2,2,2); hist(ypos,0:20:490); axis tight; legend('ypos');
subplot(2,2,3); hist(distLower,0:20:490); axis tight; legend('distLower');
subplot(2,2,4); hist(distUpper,0:20:490); axis tight; legend('distUpper');

% cup positions
% off the matlab graph
%376,376  upper
%367,121 lower
% off GIMP, which is backwards
%377,349 lower cup
%390, 87 upper cup

%%
[mycorr,lag]=xcorr(daConc,decimate(velocity,3), 1800); %max lag of 3 minutes * 600 samples per minute
% check that there are not 1 minute stitching artifacts
figure; subplot(2,1,1); plot(lag/600, mycorr); title('Correlation \Delta DA vs Velocity'); legend('w/ slow oscillation');
[mycorr,lag]=xcorr(daConc-yfilt,decimate(velocity,3), 1800); %max lag of 3 minutes * 600 samples per minute
% check that there are not 1 minute stitching artifacts
subplot(2,1,2); plot(lag/600, mycorr); legend('w/o slow oscillation'); 


%%
figure; 
plot( decimate(xpos,3), daConc(6:28200-(28200-27809-5)),'.','Color',[ .4 .4 .4 .1], 'MarkerSize', 5);
title('xpos vs DA'); xlabel('xpos'); ylabel('DA (nM)');
figure; 
plot( decimate(ypos,3), daConc(6:28200-(28200-27809-5)),'.','Color',[ .4 .4 .4 .1], 'MarkerSize', 5);
title('ypos vs DA'); xlabel('ypos'); ylabel('DA (nM)');


%% place preference 
CameraViewSize=[ 720 480 ];
numBins=20;
% remember, rows are Y axis, columns are x axis in this case
placePreferenceHeatmap=zeros(2+ceil(CameraViewSize(2)/numBins), 2+ceil(CameraViewSize(1)/numBins));
compressedXpos=round(xpos/numBins);
compressedYpos=round(ypos/numBins);
tempVelocity=[ 0; velocity ];
velocityAvgMap=zeros(2+ceil(CameraViewSize(2)/numBins), 2+ceil(CameraViewSize(1)/numBins));
velocityAvgCount=zeros(2+ceil(CameraViewSize(2)/numBins), 2+ceil(CameraViewSize(1)/numBins));
% this is probably "inefficient", but it works.
for ii=1:length(compressedXpos)
    placePreferenceHeatmap(compressedYpos(ii), compressedXpos(ii)) = 1 + placePreferenceHeatmap(compressedYpos(ii), compressedXpos(ii));
    velocityAvgMap(compressedYpos(ii), compressedXpos(ii)) = tempVelocity(ii) + velocityAvgMap(compressedYpos(ii), compressedXpos(ii));
    velocityAvgCount(compressedYpos(ii), compressedXpos(ii)) = 1 + velocityAvgCount(compressedYpos(ii), compressedXpos(ii));
end
placePreferenceHeatmap(round(450/numBins),2:round(CameraViewSize(1)/5/numBins)) = max(max(placePreferenceHeatmap)); % insert a marker for where the light is located
placePreferenceHeatmap = flipud(placePreferenceHeatmap); % re-orient the map because matlab imagesc is silly
figure; colormap([  0 0 0 ; colormap]); imagesc(placePreferenceHeatmap/max(max(placePreferenceHeatmap))); colorbar;
title('place preference heatmap'); xlabel('x pos bins'); ylabel('y pos bins');
velocityAvgMap(round(450/numBins),2:round(CameraViewSize(1)/5/numBins)) = max(max(velocityAvgMap)); % insert a marker for where the light is located
velocityAvgCount(round(450/numBins),2:round(CameraViewSize(1)/5/numBins)) = max(max(velocityAvgCount)); % insert a marker for where the light is located
figure; colormap([  0 0 0 ; colormap]); imagesc(flipud(velocityAvgMap./velocityAvgCount)); colorbar; title('avg velocity heatmap'); xlabel('x pos bins'); ylabel('y pos bins');


%% pull snippets of paths from the position data and plot them

startMinute=21; endMinute=22;
startMinute=14+(15/60); endMinute=14+(46/60);
inDelta=endMinute-startMinute;
figure; plot(xpos,ypos,'Color', [.2 .2 .2 .2 ]);hold on; 
plot(xpos(alignmentLag*3+(startMinute*30*60)), ypos(alignmentLag*3+(startMinute*30*60)),'g.', 'MarkerSize', 18);
plot(xpos(alignmentLag*3+(endMinute*30*60)), ypos(alignmentLag*3+(endMinute*30*60)),'mx', 'MarkerSize', 8);
for ii=0:0.1:.9*inDelta
    txidx=round(alignmentLag*3+((startMinute+ii)*30*60:(endMinute+ii+.1)*30*60));
    tyidx=round(alignmentLag*3+((startMinute+ii)*30*60:(endMinute+ii+.1)*30*60));
    plot(xpos(txidx), ypos(tyidx));
    plot(xpos(txidx(1)), ypos(tyidx(1)), '^');
end
legend('all', 'start', 'end','seg. 1', 'brk. 1','seg. 2', 'brk. 2','seg. 3', 'brk. 3','seg. 4', 'brk. 4','seg. 5', 'brk. 5', 'seg. 6')
title('Rat Position @ Minute 14 Seconds 15-46');
xlabel('xpos');
ylabel('ypos');








startMinute=15+(52/60); endMinute=16+(0/60);
figure; 
plot(xpos,ypos,'Color', [.2 .2 .2 .2 ]);
hold on; 
txyidx=round(alignmentLag*3+(startMinute*30*60:endMinute*30*60));
plot(xpos(txyidx), ypos(txyidx));
plot(xpos(txyidx(1)), ypos(txyidx(1)),'g.', 'MarkerSize', 16);
plot(xpos(txyidx(end)), ypos(txyidx(end)),'mx', 'MarkerSize', 5);
%% my brain is fried.
zoneZeroEntryIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
maskLessThan=(((EventStamps(zoneZeroEntryIdxs)-EventStamps(1))/60e6)<endMinute);
maskGreaterThan=(((EventStamps(zoneZeroEntryIdxs)-EventStamps(1))/60e6)>startMinute);
eventIdxs = find(maskLessThan.*maskGreaterThan.*zoneZeroEntryIdxs);
xyZeroEntryIdx=min(find(xyPositionTimestamps>EventStamps(zoneZeroEntryIdxs(eventIdxs))));
plot(xpos(xyZeroEntryIdx),ypos(xyZeroEntryIdx),'*r')
title('Representative Rewarded Behavior');
xlabel('x position (pixels)');
ylabel('y position (pixels)');
legend('all positions','in 16th min.','start','finish','reward trigger');
text(200,460,'wall w/ light')
text(200,35,'wall w/ dark')
text(580,140,'connection chair')
%
(xyPositionTimestamps(xyZeroEntryIdx)-EventStamps(1))/60e6
%16 minutes 24 seconds







tempTimes=(xyPositionTimestamps-xyPositionTimestamps(1))/(1e6);
(xyPositionTimestamps(txyidx(1))-EventStamps(1))/60e6


min(find(tempTimes(zoneZeroIdxs)<17))
zoneZeroIdxs


txyidx=round(alignmentLag*3+(16.53*30*60:16.54*30*60));
plot(xpos(txyidx), ypos(txyidx));



plot(xpos(15+(16*30*60:17*30*60)), ypos(15+(16*30*60:17*30*60))); 

plot( xpos(round(15+[16.13*30*60 16.41*30*60 16.63*30*60 ] )), ypos(round(15+[16.13*30*60 16.41*30*60 16.63*30*60 ])),'*'); 

%%
mx=max(max(stack));
mn=min(min(stack));
bincenters=mn:(mx-mn)/(numBins-1):mx;
heatmap=zeros(numBins,1+lookforward+lookbackward);
for ii=1:1+lookforward+lookbackward
    heatmap(:,ii)=hist(stack(ii,:),bincenters);
end
figure; 
imagesc( tt, bincenters, heatmap ); 
colorbar;
title('Zone 0 Triggered DA Heatmap');
xlabel('Time Relative to Zone Entry (s)');
ylabel('DA (nM)');





%%
%64 cm separation between lights
%80 cm diameter platter

% unless otherwise noted, these are in overhead image space
% cup locations
%377,349 lower cup
%390, 87 upper cup

% edges of circle 
%223,233 ->  565,233
%395,375 -> 395, 78

% locations of actual reward machines
%352,460
%338,10

% coordinate of zone 0 center in matlab pixel space
%500,299


% mean negative and mean positive in the 0.5 - 1 second after Event X
% also figure out the distance to the cups

% calculate 
% 
% velocity=()
% 
% 
% create a vector that is interp
% -1e6::1e6
% correlate running speed with dopamine
% 
% 
% 
% [ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC7.ncs']);
% foodTimes=EventStamps(zoneOneIdxs);
% cscIdx=find(nlxCscTimestamps>foodTimes(29), 1 )-60*32000*10;
% figure; plot(correctedCsc(cscIdx:cscIdx+96000));
% [ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( cscLFP(60*32000*10:end), nlxCscTimestamps(60*32000*10:end) );
% 
% 
% 
% 
% 
% 
% 
% 
% dad=1+((daConc+abs(min(daConc)))/(max(daConc)-min(daConc)));