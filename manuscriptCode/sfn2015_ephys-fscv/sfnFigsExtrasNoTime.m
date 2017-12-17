%% Maze

% get the lag
%basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
basedir='/Users/andrewhowe/data/ratData/ephysAndTelemetry/v4/march5_twotasks1/';
%alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/platter/'],[basedir '/nlx/platter/'],7)
alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/maze/'],[basedir '/nlx/maze/'],7)

% load the fscv data
%daConc=loadTarheelCsvData([basedir '/fscv/platter/'],.993);
daConc=loadTarheelCsvData([basedir '/fscv/maze/'],.993);
close all;

% get the video data and fix it
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat([basedir '/nlx/maze/VT0.nvt']);
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);

% calculate velocity
velocity=sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'));
pxPerCm = 2;
lagTime = 1.5; % seconds
velocity=calculateSpeed(xpos, ypos, lagTime, pxPerCm);

startMinute=16;
endMinute=19;
tempNlxIdxs=min(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))>startMinute)):max(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))<endMinute));
tempDaIdxs = (ceil(startMinute*600):ceil(endMinute*600))+alignmentLag;

figure;
subplot(3,1,1);hold on; plot((tempDaIdxs)/600, daConc(tempDaIdxs), 'Color', [ .7 .1 .8 ]); legend('\Delta DA (nM)'); axis tight; %(daConc(tempDaIdxs)-min(daConc(tempDaIdxs)))/(max(daConc(tempDaIdxs)-min(daConc(tempDaIdxs)))), 'Color', [ .7 .1 .8 ]); legend('\Delta DA (nM)'); axis tight;
tempVelocity=velocity(tempNlxIdxs);%sqrt(cast(((diff(xpos(tempNlxIdxs))).^2+(diff(ypos(tempNlxIdxs))).^2), 'double'));
tempTimePrime=(alignmentLag/600)+(tempNlxIdxs(1:end)/(3*600)+mean(diff(tempNlxIdxs/(60*30))));
subplot(3,1,2); %plot(tempTimePrime, (tempVelocity-min(tempVelocity))/max(tempVelocity-min(tempVelocity)), 'Color', [ .1 .8 .4 ] ); legend('velocity'); axis tight;
hold on; plot(tempTimePrime, tempVelocity, 'Color', [ .1 .8 .4 ] ); legend('velocity'); axis tight;

subplot(3,1,3); %plot((alignmentLag/600)+tempNlxIdxs/(60*30), distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 367, 121 )); %legend('dist from lower');
figure; dd=distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 367, 121 ); dd=(dd-min(dd))/max(dd); plot(dd); hold on; 
%hold on;plot((alignmentLag/600)+tempNlxIdxs/(60*30), distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 376, 376 )); legend('dist from lower','dist from upper'); axis tight;

figure; hold on;
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(distFromPoint( xpos, ypos, 376, 376 ),3)],80);
plot(lag/10,corr/(max(corr)-min(corr)));
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(350-distFromPoint( xpos, ypos, 367, 121 ),3)],80);
plot(lag/10,corr/(max(corr)-min(corr)));
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(velocity,3)'],80);
plot(lag/10,corr/(max(corr)-min(corr)), 'Color', [ .1 .8 .4 ]);
legend('\Delta DA vs prox upper','\Delta DA vs prox lower','\Delta DA vs speed')
axis([ -8 8 -1 1]);



%% Platter

% get the lag
alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/platter/'],[basedir '/nlx/platter/'],7)

% load the fscv data
daConc=loadTarheelCsvData([basedir '/fscv/platter/'],.993);


% get the video data and fix it
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat([basedir '/nlx/platter/VT0.nvt']);
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);


% calculate velocity
velocity=sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'));
velocity=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
% sfn 2015 FSCV data information -- the favorite colorplot
%14:18.1 and 14:44.
startMinute=13.5;
endMinute=15;
tempNlxIdxs=min(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))>startMinute)):max(find(((xyPositionTimestamps-xyPositionTimestamps(1))/(60e6))<endMinute));
tempDaIdxs = (ceil(startMinute*600):ceil(endMinute*600))+alignmentLag;
figure;
subplot(2,1,1);hold on; plot((tempDaIdxs)/600, (daConc(tempDaIdxs)-min(daConc(tempDaIdxs)))/(max(daConc(tempDaIdxs)-min(daConc(tempDaIdxs)))), 'Color', [ .7 .1 .8 ]); 
tempVelocity=sqrt(cast(((diff(xpos(tempNlxIdxs))).^2+(diff(ypos(tempNlxIdxs))).^2), 'double'));
tempTimePrime=(alignmentLag/600)+(tempNlxIdxs(1:end-1)/(3*600)+mean(diff(tempNlxIdxs/(60*30))));
subplot(2,1,1); plot(tempTimePrime, (tempVelocity-min(tempVelocity))/max(tempVelocity-min(tempVelocity)), 'Color', [ .1 .8 .4 ] ); legend('\Delta DA (nM)', 'velocity'); axis tight;
subplot(2,1,2); plot((alignmentLag/600)+tempNlxIdxs/(60*30), 350-distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 367, 121 )); %legend('dist from lower');
hold on;plot((alignmentLag/600)+tempNlxIdxs/(60*30), 350-distFromPoint( xpos(tempNlxIdxs), ypos(tempNlxIdxs), 376, 376 )); legend('dist from lower','dist from upper'); axis tight;
figure; hold on;
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(350-distFromPoint( xpos, ypos, 376, 376 ),3)],80);
plot(lag/10,corr/(max(corr)-min(corr)));
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(350-distFromPoint( xpos, ypos, 367, 121 ),3)],80);
plot(lag/10,corr/(max(corr)-min(corr)));
[corr,lag]=xcorr(daConc,[zeros(alignmentLag,1); decimate(velocity,3)'],80);
plot(lag/10,corr/(max(corr)-min(corr)), 'Color', [ .1 .8 .4 ]);
axis([ -8 8 -1 1]);
legend('\Delta DA vs dist upper','\Delta DA vs dist lower','\Delta DA vs velocity')