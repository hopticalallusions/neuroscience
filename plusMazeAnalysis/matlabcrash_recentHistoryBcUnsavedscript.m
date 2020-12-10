basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
basedir='/Users/andrewhowe/data/ratData/ephysAndTelemetry/v4/march5_twotasks1/';
alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/platter/'],[basedir '/nlx/platter/'],7)
% load the fscv data
daConc=loadTarheelCsvData([basedir '/fscv/platter/'],.993);
close all;
[ cscLFPSeven, nlxCscTimestampsSeven, cscHeaderSeven ] = csc2mat([basedir '/nlx/platter/CSC7.ncs']);
[ correctedCscSeven, idxsSeven, mxValuesSeven, meanCscWindowSeven ] = cscCorrection( cscLFPSeven(60*32000*10:end), nlxCscTimestampsSeven(60*32000*10:end) );
length(find(correctedCscSeven>2000))
peakIdxsSeven=peakDetector(correctedCscSeven,2000,1,1);
peakIdxsSeven=peakDetector(correctedCscSeven,2000,32,1);
length(peakIdxsSeven)
threshold = 2000; % currently arbitrary
absoluteRefractorySamples = 32; % how many sample will we wait before accepting another super threshold crossing?
thresholdExceededIdxs = find(correctedCscSeven > threshold);
thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
spikes=zeros(48,length(putativeSpikeIdxs));
for spikesIdx = 1:length(putativeSpikeIdxs)
spikes(:,spikesIdx) = correctedCscSeven(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
end
%figure; plot(spikes); %debugging; this figure makes matlab angry.
% make metrics
metrics.max=max(spikes);
metrics.max=max(spikes);
metrics.maxLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.maxLocation(idx)=find(spikes(:,idx)==max(spikes(:,idx)));
end
metrics.min=min(spikes);
metrics.minLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.minLocation(idx)=find(spikes(:,idx)==min(spikes(:,idx)));
end
metrics.width=abs(metrics.maxLocation-metrics.minLocation);
%amplitude
metrics.amplitude=metrics.max-metrics.min;
% average of signal
metrics.mean=mean(spikes);
% standard deviation of signal
metrics.std=std(spikes);
% median of signal
metrics.median=median(spikes);
for idx = 1:length(spikes)
metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end
metrics.median=median(spikes);
metrics.madam=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end
metrics.rmsSignal=sqrt(mean(spikes.^2));
metrics.rmsFreq=sqrt(sum(abs(fft(spikes)./length(spikes)).^2))
metrics.avgAbsVakue=mean(abs(spikes));
metrics.avgAbsValue=mean(abs(spikes));
metrics.medianAbsValue=median(abs(spikes));
metrics.madamMedianAbsValue=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.madamMedianAbsValue(idx)=median(abs(spikes(:,idx)-metrics.medianAbsValue(idx)));
end
metrics.sqrtEnergy=sqrt(sum(spikes.^2));
metrics.peakCurvyness=zeros(1,length(spikes));
for idx=1:length(spikes)
% the min and the max here are in case there are more than one index
tempIdx=min(metrics.maxLocation(idx))-2:max(metrics.maxLocation(idx))+2;
if ( tempIdx(1) > 1 ) && ( tempIdx(end) <= length(spikes(:,idx) ) )
secondDerivPeak=diff(diff(spikes(tempIdx,idx)));
% is it negative? (i.e. convex pointing up, concave pointing down?)
metrics.peakPointyness(idx)=mean(secondDerivPeak<0); % this should be 1
% how curvy is it? maybe this tells us that?
metrics.peakCurvyness(idx)=mean(secondDerivPeak);
end
end
figure;plot(spikes(:,21))
plot(.5:46.5,diff(spikes(:,21)))
plot(.5:45.5,diff(diff(spikes(:,21))))
figure;plot(spikes(:,21));hold on;plot(1.5:47.5,diff(spikes(:,21)));plot(1.75:46.75,diff(diff(spikes(:,21))))
figure; hist(metrics.max,100)
figure; hist(metrics.rmsSignal,100)
figure; hist(metrics.maxLocation,100)
figure; hist(metrics.width,100)
% psuedo QA
metrics.group=zeros(1,length(metrics.max));
metrics.group(find(metrics.maxLocation>14))=1;
metrics.group(find((metrics.group>0).*(metrics.min<-500)))=1;
metrics.group(find((metrics.group>0).*(metrics.rmsFreq<1.5)))=1;
sum(metrics.group)/length(metrics.group)
goodSpikeIdxs=thresholdExceededIdxs(thresholdExceededIdxStarts(find(metrics.group)));
sevenSpikeTimes=( (nlxCscTimestampsSeven(goodSpikeIdxs)-nlxCscTimestampsSeven(1)))/1e5; %ms
% 60 s/min * 32000 samples/s * 10 minutes
daConcPostPop=daConc(60*10*10+alignmentLag:end);
figure; hist(daConcPostPop(round(sevenSpikeTimes)+1),100);
%7 seconds
% spike triggered average ...
before=50; after=50; % 100's of ms
daSpikeStack=zeros(length(sevenSpikeTimes), before+after+1 );
for i=1:length(sevenSpikeTimes)
daSpikeStack(i,:)=interp1(1:length(daConcPostPop),daConcPostPop,(sevenSpikeTimes(i)-before):(sevenSpikeTimes(i)+after) );
end
figure; hold on;
shift=min(nanmean(daSpikeStack));
timeAxis=(-before:after)/10;
meanofdata=nanmean(daSpikeStack);
stder=nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes));
fill_between_lines(timeAxis,meanofdata-stder-shift,meanofdata+stder-shift,[.6 .7 .9])
plot(timeAxis,meanofdata-shift);
%plot(timeAxis,nanmean(daSpikeStack)-(nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes)))-shift,'b');
%plot(timeAxis,nanmean(daSpikeStack)+(nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes)))-shift,'b');
title(['Spike Triggered Avg \Delta DA n=' num2str(length(sevenSpikeTimes)) ' spikes'])
xlabel('relative time (s)');
ylabel('\Delta DA (nM)');
legend('std err','mean');
goodSpikeIdxs=thresholdExceededIdxs(thresholdExceededIdxStarts(find(metrics.group)));
sevenSpikeTimes=( (nlxCscTimestampsSeven(goodSpikeIdxs)-nlxCscTimestampsSeven(1)))/1e5; %ms
% 60 s/min * 32000 samples/s * 10 minutes
daConcPostPop=daConc(60*10*10+alignmentLag:end);
figure; hist(daConcPostPop(round(sevenSpikeTimes)+1),100);
%7 seconds
% spike triggered average ...
before=50; after=50; % 100's of ms
daSpikeStack=zeros(length(sevenSpikeTimes), before+after+1 );
for i=1:length(sevenSpikeTimes)
daSpikeStack(i,:)=interp1(1:length(daConcPostPop),daConcPostPop,(sevenSpikeTimes(i)-before):(sevenSpikeTimes(i)+after) );
end
sfnLastMinuteSpikeStuff
3/51
%-- 10/14/17, 8:06 PM --%
miniscopeEnhancement_v1
size(max(framesMedFlattened))
size(max(framesMedFlattened,3))
minFrameFlattened=zeros(480,752);
maxFrameFlattened=zeros(480,752);
avgFrameFlattened=zeros(480,752);
skewFrameFlattened=zeros(480,752);
varFrameFlattened=zeros(480,752);
stdFrameFlattened=zeros(480,752);
medFrameFlattened=zeros(480,752);
madamFrameFlattened=zeros(480,752);
kurtFrameFlattened=zeros(480,752);
for rowIdx=1:480
for colIdx=1:752
minFrameFlattened(rowIdx,colIdx) = min(framesMedFlattened(rowIdx,colIdx,1,:));
maxFrameFlattened(rowIdx,colIdx) = max(framesMedFlattened(rowIdx,colIdx,1,:));
avgFrameFlattened(rowIdx,colIdx) = mean(framesMedFlattened(rowIdx,colIdx,1,:));
skewFrameFlattened(rowIdx,colIdx) = skewness(double(framesMedFlattened(rowIdx,colIdx,1,:)));
varFrameFlattened(rowIdx,colIdx) = var(double(framesMedFlattened(rowIdx,colIdx,1,:)));
stdFrameFlattened(rowIdx,colIdx) = std(double(framesMedFlattened(rowIdx,colIdx,1,:)));
medFrameFlattened(rowIdx,colIdx) = median(framesMedFlattened(rowIdx,colIdx,1,:));
kurtFrameFlattened(rowIdx,colIdx) = kurtosis(double(framesMedFlattened(rowIdx,colIdx,1,:)));
madamFrameFlattened(rowIdx,colIdx) = median(abs(double(framesMedFlattened(rowIdx,colIdx,1,:))-median(double(framesMedFlattened(rowIdx,colIdx,1,:)))));
end
end
rangeFrameFlattened=maxFrameFlattened-minFrameFlattened;
figure;
subplot(3,4,1); imagesc(framesMedFlattened(:,:,1,814)); title('frame 814'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,2); imagesc(minFrameFlattened); title('minimum'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,3); imagesc(maxFrameFlattened); title('max'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,4); imagesc(avgFrameFlattened); title('mean'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,5); imagesc(skewFrameFlattened); title('skewness'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,6); imagesc(varFrameFlattened); title('var'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,7); imagesc(stdFrameFlattened); title('std'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,8); imagesc(medFrameFlattened); title('median'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,9); imagesc(madamFrameFlattened); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,10); imagesc(kurtFrameFlattened); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,11); imagesc(rangeFrameFlattened); title('range'); colormap(build_NOAA_colorgradient); colorbar;
figure;
for ii=1:1000  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
imagesc(double(currentFrame));  % colormap of the frame
%colormap(build_NOAA_colorgradient);colorbar; % comment this out if you don't have the colormap
title(num2str(ii));
colormap('bone'); colorbar;
caxis([-25 35]); % should be automated; manually determined by range plot, and then playing around
drawnow;
%hold on;
%[maxVal, maxIdx ] = max(currentFrame(:));
% just use the first thing returned
%[yy,xx] = ind2sub(size(currentFrame), maxIdx(1));
%plot(xx,yy,'or');
end
figure;
for ii=1:400  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
imagesc(double(currentFrame));  % colormap of the frame
%colormap(build_NOAA_colorgradient);colorbar; % comment this out if you don't have the colormap
title(num2str(ii));
colormap('bone'); colorbar;
caxis([0 35]); % should be automated; manually determined by range plot, and then playing around
drawnow;
%hold on;
%[maxVal, maxIdx ] = max(currentFrame(:));
% just use the first thing returned
%[yy,xx] = ind2sub(size(currentFrame), maxIdx(1));
%plot(xx,yy,'or');
end
figure;
for ii=1:500  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
imagesc(double(currentFrame));  % colormap of the frame
%colormap(build_NOAA_colorgradient);colorbar; % comment this out if you don't have the colormap
title(num2str(ii));
colormap('bone'); colorbar;
caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
drawnow;
%hold on;
%[maxVal, maxIdx ] = max(currentFrame(:));
% just use the first thing returned
%[yy,xx] = ind2sub(size(currentFrame), maxIdx(1));
%plot(xx,yy,'or');
end
vidObj = VideoReader('/Users/andrewhowe/data/calciumData/tsai-yi-striatum-enhance/msCam3.avi');
vidHeight = vidObj.Height; vidWidth = vidObj.Width; frame=read(vidObj);
avgFrameRaw=zeros(480,752);
medFrameRaw=zeros(480,752);
for rowIdx=1:480
for colIdx=1:752
%        minFrameRaw(rowIdx,colIdx) = min(frame(rowIdx,colIdx,1,:));
%        maxFrameRaw(rowIdx,colIdx) = max(frame(rowIdx,colIdx,1,:));
avgFrameRaw(rowIdx,colIdx) = mean(frame(rowIdx,colIdx,1,:));
%        skewFrameRaw(rowIdx,colIdx) = skewness(double(frame(rowIdx,colIdx,1,:)));
%        varFrameRaw(rowIdx,colIdx) = var(double(frame(rowIdx,colIdx,1,:)));
%        stdFrameRaw(rowIdx,colIdx) = std(double(frame(rowIdx,colIdx,1,:)));
medFrameRaw(rowIdx,colIdx) = median(frame(rowIdx,colIdx,1,:));
%        kurtFrameRaw(rowIdx,colIdx) = kurtosis(double(frame(rowIdx,colIdx,1,:)));
%        madamFrameRaw(rowIdx,colIdx) = median(abs(double(frame(rowIdx,colIdx,1,:))-median(double(frame(rowIdx,colIdx,1,:)))));
end
end
rangeFrameRaw=maxFrameRaw-minFrameRaw;
framesMedFlattened=zeros(size(frame));
for idx=1:1000
framesMedFlattened(:,:,1,idx)=double(frame(:,:,1,idx))-(medFrameRaw);
end
figure;
nnxx=[]; nnyy=[]; nntt=[];
for ii=1:1000  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
imagesc(double(currentFrame));  % colormap of the frame
[x, y, button]=ginput(1);
if  (button==1); nnxx = [nnxx x]; nnyy = [nnyy y]; nntt=[nntt ii]; end;
%colormap(build_NOAA_colorgradient);colorbar; % comment this out if you don't have the colormap
title(num2str(ii));
colormap('bone'); colorbar;
caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
drawnow;
%hold on;
%[maxVal, maxIdx ] = max(currentFrame(:));
% just use the first thing returned
%[yy,xx] = ind2sub(size(currentFrame), maxIdx(1));
%plot(xx,yy,'or');
end
figure;
nnxx=[]; nnyy=[]; nntt=[];
for ii=1:1000  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
imagesc(double(currentFrame));  % colormap of the frame
%colormap(build_NOAA_colorgradient);colorbar; % comment this out if you don't have the colormap
title(num2str(ii));
colormap('bone'); colorbar;
caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
drawnow;
%hold on;
%[maxVal, maxIdx ] = max(currentFrame(:));
% just use the first thing returned
%[yy,xx] = ind2sub(size(currentFrame), maxIdx(1));
%plot(xx,yy,'or');
end
figure;
for ii=1:1000  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
subplot(1,2,1); imagesc(double(currentFrame));  % colormap of the frame    colormap('bone'); colorbar;
caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
subplot(1,2,2); imagesc(double(currentFrame-median(median(currentFrame))));
colormap('bone'); colorbar;
caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
title(num2str(ii));
drawnow;
end
figure;
for ii=1:1000  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
%subplot(1,2,1); imagesc(double(currentFrame));  % colormap of the frame    colormap('bone'); colorbar;
%caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
%subplot(1,2,2);
imagesc(double(currentFrame-median(median(currentFrame))));
colormap('bone'); colorbar;
caxis([-10 20]); % should be automated; manually determined by range plot, and then playing around
title(num2str(ii));
drawnow;
end
figure;
for ii=1:1000  % number of frames in the video
pause(0.01); % controls the speed; smaller is faster
currentFrame=framesMedFlattened(:,:,1,ii);
subplot(1,2,1); imagesc(double(currentFrame));  % colormap of the frame    colormap('bone'); colorbar;
%caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
%subplot(1,2,2);
displayMe=double(currentFrame-median(median(currentFrame)));
imagesc(displayMe);
colormap('bone'); colorbar;
caxis([-10 20]); % should be automated; manually determined by range plot, and then playing around
subplot(1,2,2);
whereMaxIs=imregionalmax(displayMe); colormap('bone'); colorbar;
caxis([0 1]);
imagesc(whereMaxIs);
title(num2str(ii));
drawnow;
end
figure; imagesc(max(medFrameFlattened))
figure; imagesc(max(medFrameFlattened,3))
medFrameFlattened(1,1,1,1)
medFrameFlattened(222,322,1,77)
figure; imagesc(max(framesMedFlattened,3))
minFrameFlattened=zeros(480,752);
maxFrameFlattened=zeros(480,752);
avgFrameFlattened=zeros(480,752);
skewFrameFlattened=zeros(480,752);
varFrameFlattened=zeros(480,752);
stdFrameFlattened=zeros(480,752);
medFrameFlattened=zeros(480,752);
madamFrameFlattened=zeros(480,752);
kurtFrameFlattened=zeros(480,752);
for rowIdx=1:480
for colIdx=1:752
minFrameFlattened(rowIdx,colIdx) = min(framesMedFlattened(rowIdx,colIdx,1,:));
maxFrameFlattened(rowIdx,colIdx) = max(framesMedFlattened(rowIdx,colIdx,1,:));
avgFrameFlattened(rowIdx,colIdx) = mean(framesMedFlattened(rowIdx,colIdx,1,:));
skewFrameFlattened(rowIdx,colIdx) = skewness(double(framesMedFlattened(rowIdx,colIdx,1,:)));
varFrameFlattened(rowIdx,colIdx) = var(double(framesMedFlattened(rowIdx,colIdx,1,:)));
stdFrameFlattened(rowIdx,colIdx) = std(double(framesMedFlattened(rowIdx,colIdx,1,:)));
medFrameFlattened(rowIdx,colIdx) = median(framesMedFlattened(rowIdx,colIdx,1,:));
kurtFrameFlattened(rowIdx,colIdx) = kurtosis(double(framesMedFlattened(rowIdx,colIdx,1,:)));
madamFrameFlattened(rowIdx,colIdx) = median(abs(double(framesMedFlattened(rowIdx,colIdx,1,:))-median(double(framesMedFlattened(rowIdx,colIdx,1,:)))));
end
end
rangeFrameFlattened=maxFrameFlattened-minFrameFlattened;
figure;
subplot(3,4,1); imagesc(framesMedFlattened(:,:,1,814)); title('frame 814'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,2); imagesc(minFrameFlattened); title('minimum'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,3); imagesc(maxFrameFlattened); title('max'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,4); imagesc(avgFrameFlattened); title('mean'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,5); imagesc(skewFrameFlattened); title('skewness'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,6); imagesc(varFrameFlattened); title('var'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,7); imagesc(stdFrameFlattened); title('std'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,8); imagesc(medFrameFlattened); title('median'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,9); imagesc(madamFrameFlattened); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,10); imagesc(kurtFrameFlattened); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,11); imagesc(rangeFrameFlattened); title('range'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,10); caxis([0 10])
subplot(3,4,10); caxis([5 15])
subplot(3,4,10); caxis([2 15])
subplot(3,4,10); caxis([3 15])
subplot(3,4,3); caxis([3 50])
subplot(3,4,3); caxis([5 50])
subplot(3,4,3); colormap('bone')
figure;
subplot(3,4,1); imagesc(framesMedFlattened(:,:,1,814)); title('frame 814'); % colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,2); imagesc(minFrameFlattened); title('minimum'); %colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,3); imagesc(maxFrameFlattened); title('max'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,4); imagesc(avgFrameFlattened); title('mean'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,5); imagesc(skewFrameFlattened); title('skewness'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,6); imagesc(varFrameFlattened); title('var'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,7); imagesc(stdFrameFlattened); title('std'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,8); imagesc(medFrameFlattened); title('median'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,9); imagesc(madamFrameFlattened); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,10); imagesc(kurtFrameFlattened); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,11); imagesc(rangeFrameFlattened); title('range'); colormap(build_NOAA_colorgradient); colorbar;
colormap('bone')
figure; imagesc(rangeFrameFlattened); title('range'); colormap('bone'); colorbar;
caxis([10 60]);
caxis([5 55]);
caxis([0 55]);
figure;
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
subplot(1,2,1);
imagesc(double(frame(:,:,1,j)));
subplot(1,2,2);
imagesc(double(frame(:,:,1,j))-(medianFrameRaw));
colormap('bone');
caxis([0 45]);
drawnow
F(j) = getframe;
end
figure;
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
subplot(1,2,1);
imagesc(double(frame(:,:,1,j)));
subplot(1,2,2);
imagesc(double(frame(:,:,1,j))-(medFrameRaw));
colormap('bone');
caxis([0 45]);
drawnow
F(j) = getframe;
end
myVideo = VideoWriter('~/Desktop/msCam2_rebaselined.avi'); %, 'Uncompressed AVI');
myVideo.FrameRate = 30;  % Default 30
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);
figure;
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
subplot(1,2,1);
imagesc(double(frame(:,:,1,j)));
subplot(1,2,2);
imagesc(double(frame(:,:,1,j))-(medFrameRaw));
colormap('bone');
caxis([-10 30]);
drawnow
F(j) = getframe;
end
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
subplot(1,2,1);
imagesc(double(frame(:,:,1,j)));
subplot(1,2,2);
imagesc(double(frame(:,:,1,j))-(medFrameRaw));
colormap('bone');
caxis([-10 30]);
drawnow
F(j) = getframe;
end
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
subplot(1,2,1);
imagesc(double(frame(:,:,1,j)));
subplot(1,2,2);
imagesc(double(frame(:,:,1,j))-(medFrameRaw));
colormap('bone');
caxis([0 30]);
drawnow
F(j) = getframe;
end
myVideo = VideoWriter('~/Desktop/msCam2_rebaselined.avi'); %, 'Uncompressed AVI');
myVideo.FrameRate = 30;  % Default 30
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
imagesc(double(frame(:,:,1,j)));
%    imagesc(double(frame(:,:,1,j))-(medFrameRaw));
colormap('bone');
%caxis([0 30]);
drawnow
F(j) = getframe;
end
figure;
loops = 1000;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
imagesc(double(frame(:,:,1,j)));
%    imagesc(double(frame(:,:,1,j))-(medFrameRaw));
colormap('bone');
%caxis([0 30]);
drawnow
F(j) = getframe;
end
myVideo = VideoWriter('~/Desktop/msCam2_og.avi'); %, 'Uncompressed AVI');
myVideo.FrameRate = 30;  % Default 30
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);
1000/15
55*.07
55*77
155/2*77
155/2.2*77
175/2.2*77
%-- 10/25/17, 1:38 PM --%
dir='/Users/andrewhowe/data/ratData/ephysAndTelemetry/da12/day1-plus-maze/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
figure; plot(xpos,ypos)
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
figure; plot(xpos,ypos)
sqrt((544-112)^2+(446-46)^2)/218
pxPerCm = 2.7;   % ???? in cage... sqrt((544-112)^2+(446-46)^2) px/218 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
xyFramesPerSecond = 29.97;
lfp32=loadCExtractedNrdChannelData('rawChannel_32.dat');
lfp36=loadCExtractedNrdChannelData('rawChannel_36.dat');
lfp40=loadCExtractedNrdChannelData('rawChannel_40.dat');
lfp44=loadCExtractedNrdChannelData('rawChannel_44.dat');
lfp48=loadCExtractedNrdChannelData('rawChannel_48.dat');
lfp52=loadCExtractedNrdChannelData('rawChannel_52.dat');
lfp56=loadCExtractedNrdChannelData('rawChannel_56.dat');
lfp60=loadCExtractedNrdChannelData('rawChannel_60.dat');
lfp32=loadCExtractedNrdChannelData([ dir 'rawChannel_32.dat']);
lfp36=loadCExtractedNrdChannelData([ dir 'rawChannel_36.dat']);
lfp40=loadCExtractedNrdChannelData([ dir 'rawChannel_40.dat']);
lfp44=loadCExtractedNrdChannelData([ dir 'rawChannel_44.dat']);
lfp48=loadCExtractedNrdChannelData([ dir 'rawChannel_48.dat']);
lfp52=loadCExtractedNrdChannelData([ dir 'rawChannel_52.dat']);
lfp56=loadCExtractedNrdChannelData([ dir 'rawChannel_56.dat']);
lfp60=loadCExtractedNrdChannelData([ dir 'rawChannel_60.dat']);
tsdata=loadCExtractedNrdTimestampData([ dir 'timestamps.dat']);
lfpTimestamps=loadCExtractedNrdTimestampData([ dir 'timestamps.dat']);
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
figure(2); hold off; clf;
fig = gcf;
ax = axes('Parent', fig);
plotInterval = 10; % seconds
lfpSampleRate = 32000; % Hz
videoSampleRate = 29.97; % Hz
startIdx = 1;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6);
bumps=[];
% % keymap
% %
% %   1  left mouse
% %  91  [
% %  93  ]
% %  28  left
% %  29  right
% %  30  up
% %  31  down
% %  27  esc
% % 113  q
while 1
[x, y, button]=ginput(1);
if  (button==1); bumps = [bumps x]; end;
if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
if (button==113) || (button==27); break; end;
if ( ( startIdx + plotInterval*lfpSampleRate ) < length (timestampSeconds) )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
elseif ( startIdx > 0 )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
else
beep();
end
plot( sax1, lfpTimestampSeconds(ii), lfp36(ii) );  axis tight; ylabel( sax1, 'c6');
plot( sax2, lfpTimestampSeconds(ii), lfp48(ii) ); axis tight; ylabel( sax2, 'c61');
plot( sax3, lfpTimestampSeconds(ii), lfp52(ii) ); axis tight; ylabel( sax3, 'c88');
plot( sax4, lfpTimestampSeconds(ii), lfp56(ii) ); axis tight; ylabel( sax4, 'c64');
plot( sax5, lfpTimestampSeconds(ii), lfp60(ii) ); axis tight; ylabel( sax5, 'c76');
plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
end
while 1
[x, y, button]=ginput(1);
if  (button==1); bumps = [bumps x]; end;
if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
if (button==113) || (button==27); break; end;
if ( ( startIdx + plotInterval*lfpSampleRate ) < length (lfpTimestampSeconds) )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
elseif ( startIdx > 0 )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
else
beep();
end
plot( sax1, lfpTimestampSeconds(ii), lfp36(ii) );  axis tight; ylabel( sax1, 'c6');
plot( sax2, lfpTimestampSeconds(ii), lfp48(ii) ); axis tight; ylabel( sax2, 'c61');
plot( sax3, lfpTimestampSeconds(ii), lfp52(ii) ); axis tight; ylabel( sax3, 'c88');
plot( sax4, lfpTimestampSeconds(ii), lfp56(ii) ); axis tight; ylabel( sax4, 'c64');
plot( sax5, lfpTimestampSeconds(ii), lfp60(ii) ); axis tight; ylabel( sax5, 'c76');
plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
end
startIdx = 1;
bumps=[];
while 1
[x, y, button]=ginput(1);
if  (button==1); bumps = [bumps x]; end;
if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
if (button==113) || (button==27); break; end;
if ( ( startIdx + plotInterval*lfpSampleRate ) < length (lfpTimestampSeconds) )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
elseif ( startIdx > 0 )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
else
beep();
end
plot( sax1, lfpTimestampSeconds(ii), lfp36(ii) );  axis( sax1, 'tight'); ylabel( sax1, 'c6');
plot( sax2, lfpTimestampSeconds(ii), lfp48(ii) ); axis( sax2, 'tight'); ylabel( sax2, 'c61');
plot( sax3, lfpTimestampSeconds(ii), lfp52(ii) ); axis( sax3, 'tight'); ylabel( sax3, 'c88');
plot( sax4, lfpTimestampSeconds(ii), lfp56(ii) ); axis( sax4, 'tight'); ylabel( sax4, 'c64');
plot( sax5, lfpTimestampSeconds(ii), lfp60(ii) ); axis( sax5, 'tight'); ylabel( sax5, 'c76');
plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
end
ctrDistance=sqrt((xpos-320).^2 + (ypos-229).^2);
figure; plot(ctrDist)
figure; plot(ctrDistance)
ctrProximity = (max(ctrDistance)-ctrDistance)/max(ctrDistance);
figure; plot(ctrDistance); hold on; plot(ctrProximity);
figure; plot(ctrDistance); hold on; plot(ctrProximity*300);
normSpeed = (speed/max(speed));
figure(2); hold off; clf;
fig = gcf;
ax = axes('Parent', fig);
plotInterval = 10; % seconds
lfpSampleRate = 32000; % Hz
videoSampleRate = 29.97; % Hz
startIdx = 1;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6);
bumps=[];
while 1
[x, y, button]=ginput(1);
if  (button==1); bumps = [bumps x]; end;
if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
if (button==113); break; end; if (button==27); break; end;
if ( ( startIdx + plotInterval*lfpSampleRate ) < length (lfpTimestampSeconds) )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
elseif ( startIdx > 0 )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
else
beep();
end
plot( sax1, lfpTimestampSeconds(ii), lfp36(ii) );  axis( sax1, 'tight'); ylabel( sax1, 'c6');
plot( sax2, lfpTimestampSeconds(ii), lfp48(ii) ); axis( sax2, 'tight'); ylabel( sax2, 'c61');
plot( sax3, lfpTimestampSeconds(ii), lfp52(ii) ); axis( sax3, 'tight'); ylabel( sax3, 'c88');
plot( sax4, lfpTimestampSeconds(ii), lfp56(ii) ); axis( sax4, 'tight'); ylabel( sax4, 'c64');
plot( sax5, lfpTimestampSeconds(ii), lfp60(ii) ); axis( sax5, 'tight'); ylabel( sax5, 'c76');
plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), normSpeed(1+round(videoSampleRate*ii/lfpSampleRate))); hold on;plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), ctrProximity(1+round(videoSampleRate*ii/lfpSampleRate))); axis( sax6, 'tight'); ylim( sax6, [0 1]); ylabel( sax6, 'norm')
end
figure(2); hold off; clf;
fig = gcf;
ax = axes('Parent', fig);
plotInterval = 10; % seconds
lfpSampleRate = 32000; % Hz
videoSampleRate = 29.97; % Hz
startIdx = 1;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6);
bumps=[];
while 1
[x, y, button]=ginput(1);
if  (button==1); bumps = [bumps x]; end;
if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
if (button==113); break; end; if (button==27); break; end;
if ( ( startIdx + plotInterval*lfpSampleRate ) < length (lfpTimestampSeconds) )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
elseif ( startIdx > 0 )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
else
beep();
end
plot( sax1, lfpTimestampSeconds(ii), lfp36(ii) );  axis( sax1, 'tight'); ylabel( sax1, 'c6');
plot( sax2, lfpTimestampSeconds(ii), lfp48(ii) ); axis( sax2, 'tight'); ylabel( sax2, 'c61');
plot( sax3, lfpTimestampSeconds(ii), lfp52(ii) ); axis( sax3, 'tight'); ylabel( sax3, 'c88');
plot( sax4, lfpTimestampSeconds(ii), lfp56(ii) ); axis( sax4, 'tight'); ylabel( sax4, 'c64');
plot( sax5, lfpTimestampSeconds(ii), lfp60(ii) ); axis( sax5, 'tight'); ylabel( sax5, 'c76');
plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), normSpeed(1+round(videoSampleRate*ii/lfpSampleRate))); hold(sax6, 'on'); plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), ctrProximity(1+round(videoSampleRate*ii/lfpSampleRate))); axis( sax6, 'tight'); ylim( sax6, [0 1]); ylabel( sax6, 'norm'); hold(sax6, 'off');
end
1002/60
10e6 / 2^15
131e3 / 2^23
5e3 / 2^15
5e2 / 2^15
5e4 / 2^15
262e3 / 2^24
.262 / 2^24
.01 / 2^24
.01 / 2^16
1.5616e-08
15.616e-08
.15616e-08
.01 / 2^16
123/26.2
dir='/Volumes/BlueMiniSeagateData/ratData/da12/da12-day10-plusmaze-train8_2017-11-07/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xyFramesPerSecond = 29.97;
pxPerCm = 2.7;   % ???? in cage... sqrt((544-112)^2+(446-46)^2) px/218 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
figure; plot( xpos,ypos, 'Color', [ 1 1 1 .05 ]);
figure; plot( xpos,ypos, 'Color', [ 0 0 0 .05 ]);
figure; plot( xpos,ypos, 'Color', [ 0 0 0 .15 ]);
lfp32=loadCExtractedNrdChannelData([ dir 'rawChannel_32.dat']);
lfp36=loadCExtractedNrdChannelData([ dir 'rawChannel_36.dat']);
lfp40=loadCExtractedNrdChannelData([ dir 'rawChannel_40.dat']);
lfp44=loadCExtractedNrdChannelData([ dir 'rawChannel_44.dat']);
lfp48=loadCExtractedNrdChannelData([ dir 'rawChannel_48.dat']);
lfp52=loadCExtractedNrdChannelData([ dir 'rawChannel_52.dat']);
lfp56=loadCExtractedNrdChannelData([ dir 'rawChannel_56.dat']);
lfp60=loadCExtractedNrdChannelData([ dir 'rawChannel_60.dat']);
lfpTimestamps=loadCExtractedNrdTimestampData([ dir 'timestamps.dat']);
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
ctrDistance=sqrt((xpos-320).^2 + (ypos-229).^2);
ctrProximity = (max(ctrDistance)-ctrDistance)/max(ctrDistance);
figure; plot(ctrDistance); hold on; plot(ctrProximity*300);
normSpeed = (speed/max(speed));
figure(2); hold off; clf;
fig = gcf;
ax = axes('Parent', fig);
plotInterval = 10; % seconds
lfpSampleRate = 32000; % Hz
videoSampleRate = 29.97; % Hz
startIdx = 1;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6);
bumps=[];
while 1
[x, y, button]=ginput(1);
if  (button==1); bumps = [bumps x]; end;
if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
if (button==113); break; end; if (button==27); break; end;
if ( ( startIdx + plotInterval*lfpSampleRate ) < length (lfpTimestampSeconds) )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
elseif ( startIdx > 0 )
endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
else
beep();
end
plot( sax1, lfpTimestampSeconds(ii), lfp36(ii) ); axis( sax1, 'tight'); ylabel( sax1, 'c36');
plot( sax2, lfpTimestampSeconds(ii), lfp48(ii) ); axis( sax2, 'tight'); ylabel( sax2, 'c48');
plot( sax3, lfpTimestampSeconds(ii), lfp52(ii) ); axis( sax3, 'tight'); ylabel( sax3, 'c52');
plot( sax4, lfpTimestampSeconds(ii), lfp56(ii) ); axis( sax4, 'tight'); ylabel( sax4, 'c56');
plot( sax5, lfpTimestampSeconds(ii), lfp60(ii) ); axis( sax5, 'tight'); ylabel( sax5, 'c60');
plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), normSpeed(1+round(videoSampleRate*ii/lfpSampleRate))); hold(sax6, 'on'); plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), ctrProximity(1+round(videoSampleRate*ii/lfpSampleRate))); axis( sax6, 'tight'); ylim( sax6, [0 1]); ylabel( sax6, 'norm'); hold(sax6, 'off');
end
%-- 11/18/17, 1:35 PM --%
behaviorDraft1
figure; subplot(1,3,1); imagesc(frame(:,:,1)); colormap('bone'); subplot(1,3,2); imagesc(frame(:,:,2)); colormap('bone'); subplot(1,3,3); imagesc(frame(:,:,3)); colormap('bone');
close(vidObj);
%-- 11/18/17, 5:32 PM --%
vidObj = VideoReader('/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/2017-11-01_training4/VT1.mpg');
vidHeight = vidObj.Height; vidWidth = vidObj.Width;
frame = readFrame(vidObj);
figure; subplot(1,3,1); imagesc(frame(:,:,1)); colormap('bone'); subplot(1,3,2); imagesc(frame(:,:,2)); colormap('bone'); subplot(1,3,3); imagesc(frame(:,:,3)); colormap('bone');
temp=frame(:,:,1); std(temp(:))
temp=frame(:,:,2); std(temp(:))
temp=frame(:,:,3); std(temp(:))
temp=frame(:,:,1); std(double(temp(:)))
temp=frame(:,:,2); std(double(temp(:)))
temp=frame(:,:,3); std(double(temp(:)))
subplot(1,3,1); temp=frame(:,:,1); hist(double(temp(:)), 1:255);
subplot(1,3,2); temp=frame(:,:,2); hist(double(temp(:)), 1:255);
subplot(1,3,3); temp=frame(:,:,3); hist(double(temp(:)), 1:255);
subplot(2,3,1); imagesc(frame(:,:,1)); colormap('bone'); subplot(1,3,2); imagesc(frame(:,:,2)); colormap('bone'); subplot(1,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(2,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(2,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(2,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
subplot(2,3,1); imagesc(frame(:,:,1)); colormap('bone'); subplot(2,3,2); imagesc(frame(:,:,2)); colormap('bone'); subplot(2,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(2,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(2,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(2,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
readLimit=500;
frames=zeros(480,720,3,readLimit);
idx=1;
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
idx=idx+1;
subplot(3,3,1); imagesc(frame(:,:,1)); colormap('bone');
subplot(3,3,2); imagesc(frame(:,:,2)); colormap('bone');
subplot(3,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(3,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(3,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(3,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
temp=double(frames(:,:,2,idx-1)-frame(:,:,2));
subplot(3,3,7); imagesc(temp ); colormap('bone');
subplot(3,3,8); hist(temp(:),0:255);
end
temp=double(frames(:,:,2,idx-1))-double(frame(:,:,2));
readLimit=500;
frames=zeros(480,720,3,readLimit);
idx=1;
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
idx=idx+1;
subplot(3,3,1); imagesc(frame(:,:,1)); colormap('bone');
subplot(3,3,2); imagesc(frame(:,:,2)); colormap('bone');
subplot(3,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(3,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(3,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(3,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
temp=double(frames(:,:,2,idx-1))-double(frame(:,:,2));
subplot(3,3,7); imagesc(temp ); colormap('bone');
subplot(3,3,8); hist(temp(:),0:255);
end
readLimit=500;
frames=zeros(480,720,3,readLimit);
idx=1;
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
idx=idx+1;
subplot(3,3,1); imagesc(frame(:,:,1)); colormap('bone');
subplot(3,3,2); imagesc(frame(:,:,2)); colormap('bone');
subplot(3,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(3,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(3,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(3,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
temp=double(frames(:,:,2,idx-1))-double(frame(:,:,2));
subplot(3,3,7); imagesc(temp ); colormap('bone');
subplot(3,3,8); hist(temp(:),0:255);
drawnow;
end
vidObj.CurrentTime = 3*60+17;
readLimit=500;
frames=zeros(480,720,3,readLimit);
idx=1;
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
idx=idx+1;
subplot(3,3,1); imagesc(frame(:,:,1)); colormap('bone');
subplot(3,3,2); imagesc(frame(:,:,2)); colormap('bone');
subplot(3,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(3,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(3,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(3,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
temp=double(frames(:,:,2,idx-1))-double(frame(:,:,2));
subplot(3,3,7); imagesc(temp ); caxis([ -15 15]);
subplot(3,3,8); hist(temp(:),-255:255);
drawnow;
end
vidObj.CurrentTime = 3*60+17;
readLimit=1000;
frames=zeros(480,720,3,readLimit);
idx=1;
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
idx=idx+1;
subplot(3,3,1); imagesc(frame(:,:,1)); colormap('bone');
subplot(3,3,2); imagesc(frame(:,:,2)); colormap('bone');
subplot(3,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(3,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(3,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(3,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
temp=double(frames(:,:,2,idx-1))-double(frame(:,:,2));
subplot(3,3,7); imagesc(temp ); caxis([ -15 15]);
subplot(3,3,8); [yy,xx]=hist(temp(:),-255:255); plot(xx,log(yy));
drawnow;
end
vidObj.CurrentTime = 3*60+17;
readLimit=700;
frames=zeros(480,720,3,readLimit);
idx=1;
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
idx=idx+1;
subplot(3,3,1); imagesc(frame(:,:,1)); colormap('bone');
subplot(3,3,2); imagesc(frame(:,:,2)); colormap('bone');
subplot(3,3,3); imagesc(frame(:,:,3)); colormap('bone');
subplot(3,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
subplot(3,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
subplot(3,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);
temp=double(frames(:,:,2,idx-1))-double(frame(:,:,2));
subplot(3,3,7); imagesc(temp ); caxis([ -15 15]);
subplot(3,3,8); hist(abs(temp(:)),0:255);
drawnow;
end
close(vidObj)
fclose('all')
%-- 11/19/17, 11:52 AM --%
vidObj = VideoReader('/Users/andrewhowe/data/ratData/behavior/da12-2ndlastday/VT1.mpg');
vidHeight = vidObj.Height; vidWidth = vidObj.Width;
frame = readFrame(vidObj);
size(mean(frame))
size(mean(frame),3)
size(mean(frame,3))
vidObj.CurrentTime = 3*60+17;
readLimit=700;
frames=zeros(480,720,readLimit);
idx=1;
frame=mean(frame,3);
while idx<readLimit
frames(:,:,:,idx)=frame;
frame = readFrame(vidObj);
frame = mean(frame,3);
idx=idx+1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
subplot(2,2,4); hist( (temp(:) ), 0:255);
drawnow;
end
vidObj.CurrentTime = 3*60+17;
readLimit=700;
frames=zeros(480,720,readLimit);
idx=1;
frame=mean(frame,3);
while idx<readLimit
frames(:,:,idx)=frame;
frame = readFrame(vidObj);
frame = mean(frame,3);
idx=idx+1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
subplot(2,2,4); hist( (temp(:) ), 0:255);
drawnow;
end
vidObj.CurrentTime = 3*60+17;
readLimit=700;
frames=zeros(480,720,readLimit);
idx=1;
frame=mean(frame,3);
while idx<readLimit
frames(:,:,idx)=frame;
frame = readFrame(vidObj);
frame = mean(frame,3);
idx=idx+1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
subplot(2,2,4); hist( (temp(:) ), 0:255);
drawnow;
end
vidObj.CurrentTime = 6*60+45;
readLimit=700;
frames=zeros(480,720,readLimit);
idx=1;
frame=mean(frame,3);
while idx<readLimit
frames(:,:,idx)=frame;
frame = readFrame(vidObj);
frame = mean(frame,3);
idx=idx+1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
subplot(2,2,4); hist( (temp(:) ), 0:255);
drawnow;
end
vidObj.CurrentTime = 6*60+45;
readLimit=2500;
frames=zeros(480,720,readLimit);
idx=1;
frame=mean(frame,3);
while idx<readLimit
frames(:,:,idx)=frame;
frame = readFrame(vidObj);
frame = mean(frame,3);
idx=idx+1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
subplot(2,2,4); hist( (temp(:) ), 0:255);
drawnow;
end
480*720
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 1:15, readLimit );
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
%subplot(2,2,4); hist( (temp(:) ), 0:255);
for ii=1:15;
deltaPx(1,ii) = sum(temp(:)> ii)/ 345600;
end
drawnow;
end
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
subplot(2,2,1); imagesc(frame); colormap('bone');
subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2); imagesc( (temp) ); caxis([ -15 15]);
%subplot(2,2,4); hist( (temp(:) ), 0:255);
for ii=1:15;
deltaPx(1,ii) = sum(temp(:)> ii)/ 345600;
end
drawnow;
end
figure
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2);
imagesc( (temp) ); caxis([ -15 15]);
%subplot(2,2,4); hist( (temp(:) ), 0:255);
for ii=1:15;
deltaPx(1,ii) = sum(temp(:)> ii)/ 345600;
end
drawnow;
end
figure; imagesc(mean(frames,3))
figure; plot(deltaPx);
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
figure(1); colorbar;
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2);
imagesc( (temp) ); caxis([ 0 25]);
%subplot(2,2,4); hist( (temp(:) ), 0:255);
for ii=1:15;
deltaPx(ii,idx) = sum(temp(:)> ii)/ 345600;
end
drawnow;
end
figure; plot(deltaPx);
figure; plot(deltaPx'); legend('1','2','3','4','5','6','7','8','9')
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
figure(1); colorbar;
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2);
imagesc( (temp) ); caxis([ 5 25]); colormap; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
%    for ii=1:15;
%        deltaPx(ii,idx) = sum(temp(:)> ii)/ 345600;
%    end
drawnow;
end
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
figure(1); colorbar;
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2);
imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
%    for ii=1:15;
%        deltaPx(ii,idx) = sum(temp(:)> ii)/ 345600;
%    end
drawnow;
end
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
figure(1); colorbar;
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2);
%imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
for ii=1:15;
tt=temp(:);
deltaPx(ii,idx) = sum(tt(find(tt)>ii));
end
%drawnow;
end
figure; plot(deltaPx'); legend('1','2','3','4','5','6','7','8','9')
vidObj.CurrentTime = 6*60+45;
readLimit = 2500;
frames = zeros( 480, 720, readLimit );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 15, readLimit );
figure(1); colorbar;
while idx<readLimit
frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames(:,:,idx-1) - frame(:,:) );
%subplot(2,2,2);
%imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
tt=temp(:);
for ii=1:15;
deltaPx(ii,idx) = sum(tt(find(tt>ii)));
end
%drawnow;
end
figure; plot(deltaPx'); legend('1','2','3','4','5','6','7','8','9')
vidObj.CurrentTime = 0;
readLimit = 2;
frames = zeros( 480, 720, readLimit );
avgFrame = zeros( 480, 720 );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 1, readLimit );
figure(1); colorbar;
%while idx<readLimit
while hasFrame( vidObj )
%frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
avgFrame = avgFrame.+frame;
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames( :, :, idx-1 ) - frame( :, : ) );
%subplot(2,2,2);
%imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
tt=temp(:);
%    for ii=1:15;
deltaPx(idx) = sum(tt(find(tt>10)));
%    end
%drawnow;
end
vidObj.CurrentTime = 0;
readLimit = 2;
frames = zeros( 480, 720, readLimit );
avgFrame = zeros( 480, 720 );
idx = 1;
frame = mean( frame, 3 );
deltaPx = zeros( 1, readLimit );
figure(1); colorbar;
%while idx<readLimit
while hasFrame( vidObj )
%frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
avgFrame = avgFrame+frame;
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames( :, :, idx-1 ) - frame( :, : ) );
%subplot(2,2,2);
%imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
tt=temp(:);
%    for ii=1:15;
deltaPx(idx) = sum(tt(find(tt>10)));
%    end
%drawnow;
end
vidObj.CurrentTime = 0;
readLimit = 2;
frames = zeros( 480, 720, readLimit );
avgFrame =  mean( frame, 3 );
idx = 1;
lastFrame = mean( frame, 3 );
deltaPx = zeros( 1, readLimit );
%figure(1); colorbar;
%while idx<readLimit
while hasFrame( vidObj )
%frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
avgFrame = avgFrame+frame;
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( frames( :, :, idx-1 ) - frame( :, : ) );
%subplot(2,2,2);
%imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
tt=temp(:);
%    for ii=1:15;
deltaPx(idx) = sum(tt(find(tt>10)));
%    end
%drawnow;
end
vidObj.CurrentTime = 0;
readLimit = 2;
frames = zeros( 480, 720, readLimit );
avgFrame =  mean( frame, 3 );
idx = 1;
lastFrame = mean( frame, 3 );
deltaPx = zeros( 1, readLimit );
%figure(1); colorbar;
%while idx<readLimit
while hasFrame( vidObj )
%frames( :, :, idx ) = frame;
frame = readFrame( vidObj );
frame = mean( frame, 3 );
avgFrame = avgFrame+frame;
idx= idx + 1;
%subplot(2,2,1); imagesc(frame); colormap('bone');
%subplot(2,2,3); hist( frame(:), 0:255);
temp = abs( lastFrame - frame );
%subplot(2,2,2);
%imagesc( (temp) ); caxis([ 10 45]); colorbar; title(num2str(idx));
%subplot(2,2,4); hist( (temp(:) ), 0:255);
tt=temp(:);
%    for ii=1:15;
deltaPx(idx) = sum(tt(find(tt>10)));
%    end
%drawnow;
end
figure; plot(deltaPx);
figure; imagesc(avgFrame/idx);
frames = zeros( 480, 720, 64746 );
mod(128,16)
mod(129,16)
frames = zeros( 480, 720, round(64746/32) );
totalAvgFrame=avgFrame/idx;
median(frame(373:393,248:272))
median(frame(373:393,248:272),:)
median(frame(373:393,248:272),1:2)
behaviorDraft1
figure; imagesc(median(frames,3))
extractedBackground=median(frames,3);
figure; imagesc(frame)
figure; subplot(2,2,1); imagesc(frame); subplot(2,2,2); imagesc(extractedBackground); subplot(2,2,3); imagesc(frame-extractedBackground);
colorbar
32*255
extractedBackground=extractedBackground/32;
subplot(2,2,1); imagesc(frame); subplot(2,2,2); imagesc(extractedBackground); subplot(2,2,3); imagesc(frame-extractedBackground);
vidObj.CurrentTime = 0;
idx = 1;
while hasFrame( vidObj )
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
%     avgFrame = avgFrame + frame;
%     if mod( idx, 32 ) == 0
%         % aggregate frames for median bg estimate
%         frames( :, :, idx/32 ) = avgFrame;
%         avgFrame =  mean( frame, 3 );
%     end
idx = idx + 1;
temp = abs( lastFrame - frame );
tt=temp(:);
deltaPx( idx ) = sum( tt( find( tt > 10 ) ) );
tt = frame( 373:393, 248:272 );
brickLuminance(idx)=median( tt(:) );
end
subplot(2,2,4); plot(brickLuminance);
subplot(2,2,3); colorbar;
subplot(2,2,1); colorbar;
subplot(2,2,2); colorbar;
%-- 11/20/17, 7:53 AM --%
vidObj = VideoReader('/Users/andrewhowe/data/ratData/behavior/da12-2ndlastday/VT1.mpg');
vidHeight = vidObj.Height; vidWidth = vidObj.Width;
frame = readFrame(vidObj);
figure; imagesc(frame);
behaviorDraft1
figure; subplot(2,2,1); imagesc(frame); colorbar;
subplot(2,2,3); imagesc(extractedBackground); colorbar;
objs=frame-extractedBackground;
subplot(2,2,2); imagesc(objs); colorbar;
objsT=objs; objsT(find(objs<0))=0;
subplot(2,2,4); imagesc(objsT); colorbar;
vidObj.CurrentTime = 5*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 60*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
temp = abs( lastFrame - frame );
objs=frame-extractedBackground;
objs(find(objs<0))=0;
imagesc(objs); colorbar;
drawnow;
end
figure(2);
subplot(3,3,1); hold on;
plot( roiLum.brick.min, 'b');
plot( roiLum.brick.med, 'g');
plot( roiLum.brick.max, 'b');
plot( roiLum.brick.std + roiLum.brick.med, 'r');
subplot(3,3,2); hold on;
plot( roiLum.start.min, 'b');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
subplot(3,3,3); hold on;
plot( roiLum.wrongEnd.min, 'b');
plot( roiLum.wrongEnd.med, 'g');
plot( roiLum.wrongEnd.max, 'b');
plot( roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
subplot(3,3,4); hold on;
plot( roiLum.rightEnd.min, 'b');
plot( roiLum.rightEnd.med, 'g');
plot( roiLum.rightEnd.max, 'b');
plot( roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
subplot(3,3,5); hold on;
plot( roiLum.choicePoint.min, 'b');
plot( roiLum.choicePoint.med, 'g');
plot( roiLum.choicePoint.max, 'b');
plot( roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
subplot(3,3,6); hold on;
plot( roiLum.wrongChoice.min, 'b');
plot( roiLum.wrongChoice.med, 'g');
plot( roiLum.wrongChoice.max, 'b');
plot( roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
subplot(3,3,7); hold on;
plot( roiLum.rightChoice.min, 'b');
plot( roiLum.rightChoice.med, 'g');
plot( roiLum.rightChoice.max, 'b');
plot( roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
subplot(3,3,8); hold on;
plot( roiLum.jumpBarrier.min, 'b');
plot( roiLum.jumpBarrier.med, 'g');
plot( roiLum.jumpBarrier.max, 'b');
plot( roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
subplot(3,3,9); hold on; plot(deltaPx);
figure(2);
subplot(3,3,1); hold on;
plot( roiLum.brick.min, 'b');
plot( roiLum.brick.med, 'g');
plot( roiLum.brick.max, 'b');
plot( roiLum.brick.std + roiLum.brick.med, 'r');
axis tight;
subplot(3,3,2); hold on;
plot( roiLum.start.min, 'b');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
axis tight;
subplot(3,3,3); hold on;
plot( roiLum.wrongEnd.min, 'b');
plot( roiLum.wrongEnd.med, 'g');
plot( roiLum.wrongEnd.max, 'b');
plot( roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
axis tight;
subplot(3,3,4); hold on;
plot( roiLum.rightEnd.min, 'b');
plot( roiLum.rightEnd.med, 'g');
plot( roiLum.rightEnd.max, 'b');
plot( roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
axis tight;
subplot(3,3,5); hold on;
plot( roiLum.choicePoint.min, 'b');
plot( roiLum.choicePoint.med, 'g');
plot( roiLum.choicePoint.max, 'b');
plot( roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
axis tight;
subplot(3,3,6); hold on;
plot( roiLum.wrongChoice.min, 'b');
plot( roiLum.wrongChoice.med, 'g');
plot( roiLum.wrongChoice.max, 'b');
plot( roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
axis tight;
subplot(3,3,7); hold on;
plot( roiLum.rightChoice.min, 'b');
plot( roiLum.rightChoice.med, 'g');
plot( roiLum.rightChoice.max, 'b');
plot( roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
axis tight;
subplot(3,3,8); hold on;
plot( roiLum.jumpBarrier.min, 'b');
plot( roiLum.jumpBarrier.med, 'g');
plot( roiLum.jumpBarrier.max, 'b');
plot( roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
axis tight;
subplot(3,3,9); hold on; plot(deltaPx); axis tight;
figure(2);
subplot(3,3,1); hold on;
plot( roiLum.brick.min, 'b');
plot( roiLum.brick.med, 'g');
plot( roiLum.brick.max, 'b');
plot( roiLum.brick.std + roiLum.brick.med, 'r');
axis tight; title('brick');
subplot(3,3,2); hold on;
plot( roiLum.start.min, 'b');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
axis tight; title('start');
subplot(3,3,3); hold on;
plot( roiLum.wrongEnd.min, 'b');
plot( roiLum.wrongEnd.med, 'g');
plot( roiLum.wrongEnd.max, 'b');
plot( roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
axis tight; title('anti reward');
subplot(3,3,4); hold on;
plot( roiLum.rightEnd.min, 'b');
plot( roiLum.rightEnd.med, 'g');
plot( roiLum.rightEnd.max, 'b');
plot( roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
axis tight; title('reward');
subplot(3,3,5); hold on;
plot( roiLum.choicePoint.min, 'b');
plot( roiLum.choicePoint.med, 'g');
plot( roiLum.choicePoint.max, 'b');
plot( roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
axis tight; title('choice');
subplot(3,3,6); hold on;
plot( roiLum.wrongChoice.min, 'b');
plot( roiLum.wrongChoice.med, 'g');
plot( roiLum.wrongChoice.max, 'b');
plot( roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
axis tight; title('anti choice');
subplot(3,3,7); hold on;
plot( roiLum.rightChoice.min, 'b');
plot( roiLum.rightChoice.med, 'g');
plot( roiLum.rightChoice.max, 'b');
plot( roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
axis tight;  title('reward choice');
subplot(3,3,8); hold on;
plot( roiLum.jumpBarrier.min, 'b');
plot( roiLum.jumpBarrier.med, 'g');
plot( roiLum.jumpBarrier.max, 'b');
plot( roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
axis tight; title('jump');
subplot(3,3,9); hold on; plot(deltaPx); axis tight;  title('total change');
figure(2);
subplot(3,3,1); hold on;
plot( roiLum.brick.min, 'k');
plot( roiLum.brick.med, 'g');
plot( roiLum.brick.max, 'b');
plot( roiLum.brick.std + roiLum.brick.med, 'r');
axis tight; title('brick');
subplot(3,3,2); hold on;
plot( roiLum.start.min, 'k');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
axis tight; title('start');
subplot(3,3,3); hold on;
plot( roiLum.wrongEnd.min, 'k');
plot( roiLum.wrongEnd.med, 'g');
plot( roiLum.wrongEnd.max, 'b');
plot( roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
axis tight; title('anti reward');
subplot(3,3,4); hold on;
plot( roiLum.rightEnd.min, 'k');
plot( roiLum.rightEnd.med, 'g');
plot( roiLum.rightEnd.max, 'b');
plot( roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
axis tight; title('reward');
subplot(3,3,5); hold on;
plot( roiLum.choicePoint.min, 'k');
plot( roiLum.choicePoint.med, 'g');
plot( roiLum.choicePoint.max, 'b');
plot( roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
axis tight; title('choice');
subplot(3,3,6); hold on;
plot( roiLum.wrongChoice.min, 'k');
plot( roiLum.wrongChoice.med, 'g');
plot( roiLum.wrongChoice.max, 'b');
plot( roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
axis tight; title('anti choice');
subplot(3,3,7); hold on;
plot( roiLum.rightChoice.min, 'k');
plot( roiLum.rightChoice.med, 'g');
plot( roiLum.rightChoice.max, 'b');
plot( roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
axis tight;  title('reward choice');
subplot(3,3,8); hold on;
plot( roiLum.jumpBarrier.min, 'k');
plot( roiLum.jumpBarrier.med, 'g');
plot( roiLum.jumpBarrier.max, 'b');
plot( roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
axis tight; title('jump');
subplot(3,3,9); hold on; plot(deltaPx); axis tight;  title('total change');
vidObj.CurrentTime = 6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 60*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
temp = abs( lastFrame - frame );
objs=frame-extractedBackground;
objs(find(objs<0))=0;
imagesc(objs); colorbar;
drawnow;
end
vidObj.CurrentTime = 7*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 60*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
temp = abs( lastFrame - frame );
objs=frame-extractedBackground;
objs(find(objs<0))=0;
imagesc(objs); colorbar;
drawnow;
end
720/20
480/20
720/40
720/80
480/80
behaviorDraft1
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 60*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
temp = abs( lastFrame - ( frame + adjustment ) );
objs=frame-extractedBackground;
objs(find(objs<0))=0;
imagesc(objs); colorbar;
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 5*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground + adjustment);
objs(find(objs<0))=0;
imagesc(objs); colorbar; caxis([0 255]);
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground + adjustment);
objs(find(objs<0))=0;
imagesc(objs); colorbar; caxis([0 255]);
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.9*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground + adjustment);
objs(find(objs<0))=0;
imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.9*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 5*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - extractedBackground - adjustment;
objs(find(objs<0))=0;
imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 6*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,2,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,2,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
drawnow;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-lastFrame); colorbar; caxis([0 255]);
drawnow;
lastFrame=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
lastLastFrame = lastFrame;
figure(10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-lastLastFrame); colorbar; caxis([0 255]);
drawnow;
lastFrame=frame;
lastLastFrame = lastFrame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-lastFrame); colorbar; caxis([0 255]);
drawnow;
if mod( idx, 10 ) == 0;
lastFrame=frame;
end
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10))); colorbar; caxis([0 255]);
drawnow;
localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
drawnow;
localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
adjustment = overallMedLum - median(frame(:));
adjustment = median(localHistory(:)) - median(frame(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
drawnow;
localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
adjustment = median(frame - extractedBackground);
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
drawnow;
localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
tt = median(frame - extractedBackground);
adjustment = tt(:);
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
drawnow;
localHistory(:,:,mod(idx,10)+1)=frame;
end
tt = median(frame - extractedBackground);
objs = frame - ( extractedBackground - adjustment );
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
tt = (frame - extractedBackground);
adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground - adjustment );
objs(find(objs<0))=0;
subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
subplot(1,3,2); imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
drawnow;
localHistory(:,:,mod(idx,10)+1)=frame;
end
figure;
for kk=1:length(lumGradient);
imagesc(lumGradient); caxis([0 255]);
end
figure;
for kk=1:length(lumGradient);
imagesc(lumGradient(:,:,kk)); caxis([0 255]);
end
figure; for kk=1:length(lumGradient);
imagesc(lumGradient(:,:,kk)); caxis([0 255]); drawnow;
end
figure; for kk=1:length(lumGradient);
imagesc(lumGradient(:,:,kk)); caxis([0 50]); drawnow;
end
figure; for kk=1:length(lumGradient);
imagesc(lumGradient(:,:,kk)); colorbar; drawnow;
end
vidObj.CurrentTime = 0;
readLimit = 2;
frames = zeros( 480, 720, round(64746/32)+1 );
avgFrame =  mean( frame, 3 );
idx = 1;
lastFrame = mean( frame, 3 );
deltaPx = zeros( 1, readLimit );
% problem : want to get median, rathther than average frame, but data is too big.
% solution : average every ~ 1s of frames, and take the median of that. (still big, but doable...)
%
% big problem : track events in video
%
% sub solution 1 : attempt to track Andrew motion by detecting total frame to frame delta
% sub solution 2 : attempt to track the brick at the front of the maze by tracking avg luminance for an ROI
roiLum.brick.med=zeros(1,64746);
roiLum.start.med=zeros(1,64746);
roiLum.wrongEnd.med=zeros(1,64746);
roiLum.rightEnd.med=zeros(1,64746);
roiLum.choicePoint.med=zeros(1,64746);
roiLum.wrongChoice.med=zeros(1,64746);
roiLum.rightChoice.med=zeros(1,64746);
roiLum.jumpBarrier.med=zeros(1,64746);
roiLum.brick.min=zeros(1,64746);
roiLum.start.min=zeros(1,64746);
roiLum.wrongEnd.min=zeros(1,64746);
roiLum.rightEnd.min=zeros(1,64746);
roiLum.choicePoint.min=zeros(1,64746);
roiLum.wrongChoice.min=zeros(1,64746);
roiLum.rightChoice.min=zeros(1,64746);
roiLum.jumpBarrier.min=zeros(1,64746);
roiLum.brick.max=zeros(1,64746);
roiLum.start.max=zeros(1,64746);
roiLum.wrongEnd.max=zeros(1,64746);
roiLum.rightEnd.max=zeros(1,64746);
roiLum.choicePoint.max=zeros(1,64746);
roiLum.wrongChoice.max=zeros(1,64746);
roiLum.rightChoice.max=zeros(1,64746);
roiLum.jumpBarrier.max=zeros(1,64746);
roiLum.brick.std=zeros(1,64746);
roiLum.start.std=zeros(1,64746);
roiLum.wrongEnd.std=zeros(1,64746);
roiLum.rightEnd.std=zeros(1,64746);
roiLum.choicePoint.std=zeros(1,64746);
roiLum.wrongChoice.std=zeros(1,64746);
roiLum.rightChoice.std=zeros(1,64746);
roiLum.jumpBarrier.std=zeros(1,64746);
roiLum.bucketRun.min = zeros(1,64746);
roiLum.bucketRun.med = zeros(1,64746);
roiLum.bucketRun.max = zeros(1,64746);
roiLum.bucketRun.std = zeros(1,64746);
roiLum.probeBarrier.min = zeros(1,64746);
roiLum.probeBarrier.med = zeros(1,64746);
roiLum.probeBarrier.max = zeros(1,64746);
roiLum.probeBarrier.std = zeros(1,64746);
lumGradient = zeros( 6, 9, 64746 );
totalLum = zeros(1,64746);
while hasFrame( vidObj )
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
avgFrame = avgFrame + frame;
if mod( idx, 32 ) == 0
% aggregate frames for median bg estimate
frames( :, :, idx/32 ) = avgFrame/32;
avgFrame =  mean( frame, 3 );
end
idx = idx + 1;
temp = abs( lastFrame - frame );
tt=temp(:);
deltaPx( idx ) = sum( tt( find( tt > 10 ) ) );
tt = frame( 373:393, 248:272 ); % brick
roiLum.brick.min(idx) = min( tt(:) );
roiLum.brick.med(idx) = median( tt(:) );
roiLum.brick.max(idx) = max( tt(:) );
roiLum.brick.std(idx) = std( tt(:) );
tt = frame( 402:440, 200:245 );  % start
roiLum.start.min(idx) = min( tt(:) );
roiLum.start.med(idx) = median( tt(:) );
roiLum.start.max(idx) = max( tt(:) );
roiLum.start.std(idx) = std( tt(:) );
tt = frame( 65:115, 143:195 );   % wrong choice
roiLum.wrongEnd.min(idx) = min( tt(:) );
roiLum.wrongEnd.med(idx) = median( tt(:) );
roiLum.wrongEnd.max(idx) = max( tt(:) );
roiLum.wrongEnd.std(idx) = std( tt(:) );
tt = frame( 395:432, 548:600 );  % reward place
roiLum.rightEnd.min(idx) = min( tt(:) );
roiLum.rightEnd.med(idx) = median( tt(:) );
roiLum.rightEnd.max(idx) = max( tt(:) );
roiLum.rightEnd.std(idx) = std( tt(:) );
tt = frame( 245:290, 360:400 );  % intersection
roiLum.choicePoint.min(idx) = min( tt(:) );
roiLum.choicePoint.med(idx) = median( tt(:) );
roiLum.choicePoint.max(idx) = max( tt(:) );
roiLum.choicePoint.std(idx) = std( tt(:) );
tt = frame( 210:255, 325:362 );  % wrong choice at intersection
roiLum.wrongChoice.min(idx) = min( tt(:) );
roiLum.wrongChoice.med(idx) = median( tt(:) );
roiLum.wrongChoice.max(idx) = max( tt(:) );
roiLum.wrongChoice.std(idx) = std( tt(:) );
tt = frame( 265:310, 390:430 );  % right choice at intersection
roiLum.rightChoice.min(idx) = min( tt(:) );
roiLum.rightChoice.med(idx) = median( tt(:) );
roiLum.rightChoice.max(idx) = max( tt(:) );
roiLum.rightChoice.std(idx) = std( tt(:) );
tt = frame( 210:255, 400:440 );  % jump middle barrier
roiLum.jumpBarrier.min(idx) = min( tt(:) );
roiLum.jumpBarrier.med(idx) = median( tt(:) );
roiLum.jumpBarrier.max(idx) = max( tt(:) );
roiLum.jumpBarrier.std(idx) = std( tt(:) );
tt = frame( 445:475, 155:185 );  % bucket storage area -- high signal should mean "running"
roiLum.bucketRun.min(idx) = min( tt(:) );
roiLum.bucketRun.med(idx) = median( tt(:) );
roiLum.bucketRun.max(idx) = max( tt(:) );
roiLum.bucketRun.std(idx) = std( tt(:) );
tt = frame( 85:118, 530:565 );  % where the brick barrier would be for a probe
roiLum.probeBarrier.min(idx) = min( tt(:) );
roiLum.probeBarrier.med(idx) = median( tt(:) );
roiLum.probeBarrier.max(idx) = max( tt(:) );
roiLum.probeBarrier.std(idx) = std( tt(:) );
% collecting this because I suspect that the luminance changes,
% and that modifes the subtracted image. Should correct for luminance changes.
totalLum(idx)=median(frame(:));
rIdx=1; cIdx=1;
for ii=1:80:480
cIdx=1;
for jj=1:80:720
tt=frame(ii:ii+79,jj:jj+79);
lumGradient(rIdx,cIdx,idx)=median(tt(:));
cIdx=cIdx+1;
end
rIdx=rIdx+1;
end
end
extractedBackground=median(frames,3);
figure; subplot(2,2,1); imagesc(frame); colorbar;
subplot(2,2,3); imagesc(extractedBackground); colorbar;
objs=frame-extractedBackground;
subplot(2,2,2); imagesc( objs ); colorbar;
objsT=objs; objsT( find( objs < 0 ) )=0;
subplot(2,2,4); imagesc( objsT ); colorbar;
figure; for kk=1:length(lumGradient);
imagesc(lumGradient(:,:,kk)); colorbar; drawnow;
end
figure; for kk=1:length(lumGradient);
imagesc(lumGradient(:,:,kk)); colorbar; caxis([0 95 ]); drawnow;
end
figure; hold on; for kk=1:6; for ll=1:9; plot(lumGradient(kk,ll,:)); end; end; axis tight;
figure; hold on; for kk=1:6; for ll=1:9; pp=lumGradient(kk,ll,:); plot(pp(:)); end; end; axis tight;
figure(2);
subplot(3,4,1); hold on;
plot( roiLum.brick.min, 'k');
plot( roiLum.brick.med, 'g');
plot( roiLum.brick.max, 'b');
plot( roiLum.brick.std + roiLum.brick.med, 'r');
axis tight; title('brick');
subplot(3,4,2); hold on;
plot( roiLum.start.min, 'k');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
axis tight; title('start');
subplot(3,4,3); hold on;
plot( roiLum.wrongEnd.min, 'k');
plot( roiLum.wrongEnd.med, 'g');
plot( roiLum.wrongEnd.max, 'b');
plot( roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
axis tight; title('anti reward');
subplot(3,4,4); hold on;
plot( roiLum.rightEnd.min, 'k');
plot( roiLum.rightEnd.med, 'g');
plot( roiLum.rightEnd.max, 'b');
plot( roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
axis tight; title('reward');
subplot(3,4,5); hold on;
plot( roiLum.choicePoint.min, 'k');
plot( roiLum.choicePoint.med, 'g');
plot( roiLum.choicePoint.max, 'b');
plot( roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
axis tight; title('choice');
subplot(3,4,6); hold on;
plot( roiLum.wrongChoice.min, 'k');
plot( roiLum.wrongChoice.med, 'g');
plot( roiLum.wrongChoice.max, 'b');
plot( roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
axis tight; title('anti choice');
subplot(3,4,7); hold on;
plot( roiLum.rightChoice.min, 'k');
plot( roiLum.rightChoice.med, 'g');
plot( roiLum.rightChoice.max, 'b');
plot( roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
axis tight;  title('reward choice');
subplot(3,4,8); hold on;
plot( roiLum.jumpBarrier.min, 'k');
plot( roiLum.jumpBarrier.med, 'g');
plot( roiLum.jumpBarrier.max, 'b');
plot( roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
axis tight; title('jump');
subplot(3,4,9); hold on;
plot( roiLum.bucketRun.min, 'k');
plot( roiLum.bucketRun.med, 'g');
plot( roiLum.bucketRun.max, 'b');
plot( roiLum.bucketRun.std + roiLum.bucketRun.med, 'r');
axis tight; title('bucket @ start');
subplot(3,4,10); hold on;
plot( roiLum.probeBarrier.min, 'k');
plot( roiLum.probeBarrier.med, 'g');
plot( roiLum.probeBarrier.max, 'b');
plot( roiLum.probeBarrier.std + roiLum.probeBarrier.med, 'r');
axis tight; title('probe barrier');  % this is the brick at the probe
subplot(3,4,11); hold on; plot(deltaPx); axis tight;  title('total change');
subplot(3,4,12); hold on; plot(totalLum); axis tight;  title('median Lum');
figure
hold on;
plot( roiLum.start.min, 'k');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
axis tight; title('start');
roiFilter = designfilt( 'lowpassiir',                     ...
'FilterOrder',              8  , ...
'PassbandFrequency',        5  , ...
'PassbandRipple',           0.2, ...
'SampleRate',              30);
correctedStartBucketLuminance = filtfilt( roiFilter, roiLum.start.med);
figure; hold on; plot(roiLum.start.med); plot(smoothedStartBucketLuminance);
smoothedStartBucketLuminance = filtfilt( roiFilter, roiLum.start.med);
figure; hold on; plot(roiLum.start.med); plot(smoothedStartBucketLuminance);
roiFilter = designfilt( 'lowpassiir',                     ...
'FilterOrder',              8  , ...
'PassbandFrequency',        1  , ...
'PassbandRipple',           0.2, ...
'SampleRate',              30);
smoothedStartBucketLuminance = filtfilt( roiFilter, roiLum.start.med);
figure; hold on; plot(roiLum.start.med); plot(smoothedStartBucketLuminance);
std(smoothedStartBucketLuminance)
4*28
tt=(1:length(roiLum.start.med))/(60*29.97);
figure; hold on; plot(roiLum.start.med); plot(smoothedStartBucketLuminance);
tt=(1:length(roiLum.start.med))/(60*29.97);
figure; hold on; plot(tt,roiLum.start.med); plot(tt,smoothedStartBucketLuminance);
[ peakValues, ...
peakTimes, ...
peakProminances, ...
peakWidths ] = findpeaks(  smoothedStartBucketLuminance,                              ... % data
29.97,                                  ... % sampling frequency
'MinPeakHeight',   std(smoothedStartBucketLuminance)*4, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance',  25 ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
plot(peakTimes,peakValues, 'o')
figure; hold on; plot(tt,roiLum.start.med); plot(tt,smoothedStartBucketLuminance);
plot(peakTimes,peakValues, 'o')
figure; hold on; plot(tt,roiLum.start.med); plot(tt,smoothedStartBucketLuminance);
plot(peakTimes/60,peakValues, 'o')
peakWidths
mx=max(frame( 460:480, 200:600),1)
mx=max(frame( 460:480, 200:600))
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.8*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 7*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
mx=max(max(frame( 460:480, 200:600))); mx=mx(1);
[rr,cc] = find( mask.*frame == mx );
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%    subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
%subplot(1,3,2);
imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
%    subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
hold on; plot( cc, rr, '*c' ); hold off;
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%    subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]); title(num2str(vidObj.CurrentTime))
%subplot(1,3,2);
imagesc(objs); colorbar; caxis([0 255]); title(num2str(adjustment))
%    subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,20,10);
figure; imagesc(labeledMatrix);
colormap
regionColormap=[   0 0 0;...
0 0 1;...
0 1 0;...
1 0 0;...
1 1 0;...
1 0 1;...
0 1 1;...
1 1 1;...
.5 0 0;...
0 .5 0;...
0 0 .5;...
.5 1 0;...
.5 0 1;...
0 .5 1;...
1 .5 0;...
1 0 .5;...
0 1 .5 ];
colormap(regionColormap);
regionColormap=[   0 0 0;...
0 0 1;...
0 1 0;...
1 0 0;...
1 1 0;...
1 0 1;...
0 1 1;...
1 1 1;...
.5 0 0;...
0 .5 0;...
0 0 .5;...
.5 1 0;...
.5 0 1;...
0 .5 1;...
1 .5 0;...
1 0 .5;...
0 1 .5;...
.75 0 0;...
0 .75 0;...
0 0 .75;...
.75 .7 0;...
.75 0 .7;...
0 .75 .7;...
.7 .75 0;...
.7 0 .75;...
0 .7 .75;
0 0 1;...
0 1 0;...
1 0 0;...
1 1 0;...
1 0 1;...
0 1 1;...
1 1 1;...
.5 0 0;...
0 .5 0;...
0 0 .5;...
.5 1 0;...
.5 0 1;...
0 .5 1;...
1 .5 0;...
1 0 .5;...
0 1 .5;...
.75 0 0;...
0 .75 0;...
0 0 .75;...
.75 .7 0;...
.75 0 .7;...
0 .75 .7;...
.7 .75 0;...
.7 0 .75;...
0 .7 .75  ];
colormap(regionColormap);
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
subplot(1,2,1);
imagesc(objs); caxis([0 255]); % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,20,10);
subplot(1,2,2); imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
subplot(1,2,1);
imagesc(objs); caxis([0 255]); colormap('fire'); % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
subplot(1,2,2); imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
subplot(1,2,1);
imagesc(objs); caxis([0 255]); colormap('default'); % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
subplot(1,2,2); imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
subplot(1,2,1);
imagesc(objs); caxis([0 255]);
colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
drawnow;
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
subplot(1,2,2); imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
overallMedLum=median(totalLum);
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); caxis([0 255]);
colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%subplot(1,2,2);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
mazeMask=mask;
figure; imagesc(log(frame))
figure; imagesc(log(frame)); colorbar;
figure; imagesc(log(frame*1e4+1)); colorbar;
figure; imagesc(log(frame*1e4+1)<11); colorbar;
mazeMask=log(frame*1e4+1)<11);
mazeMask=log(frame*1e4+1)<11;
mazeMask(:,1:43)=0
imagesc(mazeMask)
mazeMask(:,1:100)=0;
imagesc(mazeMask)
mazeMask(446:480,:)=0;
imagesc(mazeMask)
mazeMask(:,618:720)=0;
imagesc(mazeMask)
exp(0)
figure; imagesc(exp(extractedBackground))
figure; imagesc((extractedBackground))
imagesc(mazeMask)
imagesc(mazeMask.*frame)
imagesc(mazeMask.*(frame+.3))
imagesc((mazeMask.+.3).*frame)
imagesc((mazeMask+.3).*frame)
imagesc((mazeMask+frame))
imagesc((mazeMask+.1).*frame)
imagesc((mazeMask+.05).*frame)
imwrite(frame,'egFrame.png')
imwrite(frame,'egFrame.jpg', 'jpg')
imagesc(frame)
frame = readFrame( vidObj );
imwrite(frame,'egFrame.jpg', 'jpg')
mazeMask=imread('mazeMask.png');
imagesc(mazeMask)
imagesc(mean(mazeMask,3))
mazeMask=mean(mazeMask,3);
imagesc(mazeMask.*frame)
imagesc(mazeMask.*mean(frame,3))
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = frame - ( extractedBackground );
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
%    figure(10);
%    imagesc(objs); caxis([0 255]);
%    colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( mask.*objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs.*mazeMask,25,10);
%subplot(1,2,2);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); caxis([0 255]);
colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
%    mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
%    [elasticR,elasticC] = find( objs == mx );
%    mx=max(max(objs)); mx=mx(1);
%    [ratR,ratC] = find( objs == mx );
%    hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%    [labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%    figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%    drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); colorbar; %caxis([0 255]);
% colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
%    mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
%    [elasticR,elasticC] = find( objs == mx );
%    mx=max(max(objs)); mx=mx(1);
%    [ratR,ratC] = find( objs == mx );
%    hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%    [labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%    figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%    drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
max(mazeMask(:))
mazeMask=imread('mazeMaskBlurred.png');
mazeMask=mean(mazeMask,3); mazeMask=mazeMask/max(mazeMask(:));
figure; imagesc(mazeMask)
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<0))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); colorbar; %caxis([0 255]);
% colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
%    mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
%    [elasticR,elasticC] = find( objs == mx );
%    mx=max(max(objs)); mx=mx(1);
%    [ratR,ratC] = find( objs == mx );
%    hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%    [labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%    figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%    drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<5))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); colorbar; %caxis([0 255]);
% colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
%    mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
%    [elasticR,elasticC] = find( objs == mx );
%    mx=max(max(objs)); mx=mx(1);
%    [ratR,ratC] = find( objs == mx );
%    hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%    [labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%    figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%    drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<5))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); colorbar; caxis([0 255]);    % colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%    [labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%    figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%    drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
mazeMask=imread('mazeMask.png');
mazeMask=mean(mazeMask,3); mazeMask=mazeMask/max(mazeMask(:));
figure; imagesc(mazeMask)
figure; imagesc(mazeMask>.95)
figure; imagesc(mazeMask>.85)
figure; imagesc(mazeMask>.75)
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
%adjustment = overallMedLum - median(frame(:));
%    tt = (frame - extractedBackground);
%    adjustment = median(tt(:));
%temp = abs( lastFrame - ( frame + adjustment ) );
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<5))=0;
%   subplot(1,3,1); imagesc(frame); colorbar; caxis([0 255]);title(num2str(vidObj.CurrentTime))
%   subplot(1,3,2);
%subplot(1,2,1);
figure(10);
imagesc(objs); colorbar; caxis([0 255]);    % colormap default; % colorbar; % title(num2str(adjustment))
%   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
[elasticR,elasticC] = find( objs == mx );
mx=max(max(objs)); mx=mx(1);
[ratR,ratC] = find( objs == mx );
hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
drawnow;
%    [labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%    figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%    drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<5))=0;
figure(10);
%     imagesc(objs); colorbar; caxis([0 255]);    % colormap default; % colorbar; % title(num2str(adjustment))
% %   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
%     mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
%     [elasticR,elasticC] = find( objs == mx );
%     mx=max(max(objs)); mx=mx(1);
%     [ratR,ratC] = find( objs == mx );
%     hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
%     drawnow;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.6*60;
idx=1;
lastFrame = mean( frame, 3 );
figure(10);
localHistory = zeros( 480, 720, 10);
adjustment = 9;
mask=zeros(480,720); mask( 460:480, 200:600)=1;
while hasFrame( vidObj ) && ( idx < 20*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - extractedBackground ).*mazeMask;
objs(find(objs<5))=0;
%     figure(10);
%     imagesc(objs); colorbar; caxis([0 255]);    % colormap default; % colorbar; % title(num2str(adjustment))
% %   subplot(1,3,3); imagesc(frame-localHistory(:,:,mod(idx+1,10)+1)); colorbar; caxis([0 255]);
%     mx=max(max(objs( 460:480, 200:600))); mx=mx(1);
%     [elasticR,elasticC] = find( objs == mx );
%     mx=max(max(objs)); mx=mx(1);
%     [ratR,ratC] = find( objs == mx );
%     hold on; plot( elasticC, elasticR, '*c' ); plot( ratC, ratR, 'om' ); hold off;
%     drawnow;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
%localHistory(:,:,mod(idx,10)+1)=frame;
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
%[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,25,10);
%figure(11);imagesc(labeledMatrix); colormap(regionColormap);
figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs),15,10);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
II=imfill(objs); figure; subplot(1,2,1); imagesc(objs); subplot(1,2,2); imagesc(II);
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
[labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
imagesc(frame.*mazeMask)
14625/24
2,708.33*12
2708.33*12
(5,607.59*3)/12
(5607.59*3)/12
3*2167.49
(3*2167.49)/12
1562 +  50 + 559 + 541
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
labeledMatrix = ( objs > 5 )*2 + ( objs < -5 );
figure(11);imagesc(labeledMatrix); colormap(regionColormap);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11);
labeledMatrix = ( objs > 10 );
subplot(1,2,1); imagesc(labeledMatrix);
labeledMatrix = ( objs < -10 );
subplot(1,2,1); imagesc(labeledMatrix);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11);
labeledMatrix = ( objs > 10 );
subplot(1,2,1); imagesc(labeledMatrix);
labeledMatrix = ( objs < -10 );
subplot(1,2,2); imagesc(labeledMatrix);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11);
present = ( objs > 12 ).*2; % present
subplot(1,2,1); imagesc(labeledMatrix);
past = ( objs < -12 );  % past
subplot(1,2,2); imagesc(labeledMatrix);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11);
present = ( objs > 12 ).*2; % present
subplot(1,2,1); imagesc(present);
past = ( objs < -12 );  % past
subplot(1,2,2); imagesc(past);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
max(present(:))
max(past(:))
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11); colormap default;
present = ( objs > 12 ).*2; % present
%subplot(1,2,1); imagesc(present);
past = ( objs < -12 );  % past
%subplot(1,2,2);
imagesc(past+present); caxis([0 4]);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11); colormap default;
present = ( objs > 12 ).*2; % present
%subplot(1,2,1); imagesc(present);
past = ( objs < -12 );  % past
%subplot(1,2,2);
imagesc(past+present); caxis([0 3]);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
mazeMask=imread('mazeOnlyMask.png');
mazeMask=mean(mazeMask,3); mazeMask=mazeMask/max(mazeMask(:));
figure; imagesc(mazeMask)
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11); colormap default;
present = ( objs > 12 ).*2; % present
%subplot(1,2,1); imagesc(present);
past = ( objs < -12 );  % past
%subplot(1,2,2);
imagesc(past+present); caxis([0 3]);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
mazeMask=imread('mazePermittedRegions.png');
mazeMask=mean(mazeMask,3); mazeMask=mazeMask/max(mazeMask(:));
figure; imagesc(mazeMask)
vidObj.CurrentTime = 7.1*60;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( idx < 10*29 );
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
idx = idx + 1;
objs = ( frame - lastFrame ).*mazeMask;
%    objs = ( frame - extractedBackground ).*mazeMask;
%    objs(find(objs<5))=0;
% region-finding -- doesn't quite work correctly
% [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);
figure(11); colormap default;
present = ( objs > 12 ).*2; % present
%subplot(1,2,1); imagesc(present);
past = ( objs < -12 );  % past
%subplot(1,2,2);
imagesc(past+present); caxis([0 3]);
%figure(11);imagesc(objs); caxis([0 255]);
drawnow;
lastFrame = frame;
vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
end
tt=(1:length(roiLum.brick.min))/(29.97*60);
figure(2);
subplot(3,4,1); hold on;
%    plot( tt, roiLum.brick.min, 'k');
%    plot( tt, roiLum.brick.med, 'g');
plot( tt, roiLum.brick.max, 'b');
plot( tt, roiLum.brick.std + roiLum.brick.med, 'r');
axis tight; title('brick');
subplot(3,4,2); hold on;
%    plot( tt, roiLum.start.min, 'k');
%    plot( tt, roiLum.start.med, 'g');
plot( tt, roiLum.start.max, 'b');
plot( tt, roiLum.start.std + roiLum.start.med, 'r');
axis tight; title('start');
subplot(3,4,3); hold on;
%    plot( tt, roiLum.wrongEnd.min, 'k');
%    plot( tt, roiLum.wrongEnd.med, 'g');
plot( tt, roiLum.wrongEnd.max, 'b');
plot( tt, roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
axis tight; title('anti reward');
subplot(3,4,4); hold on;
%    plot( tt, roiLum.rightEnd.min, 'k');
%    plot( tt, roiLum.rightEnd.med, 'g');
plot( tt, roiLum.rightEnd.max, 'b');
plot( tt, roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
axis tight; title('reward');
subplot(3,4,5); hold on;
%    plot( tt, roiLum.choicePoint.min, 'k');
%    plot( tt, roiLum.choicePoint.med, 'g');
plot( tt, roiLum.choicePoint.max, 'b');
plot( tt, roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
axis tight; title('choice');
subplot(3,4,6); hold on;
%    plot( tt, roiLum.wrongChoice.min, 'k');
%    plot( tt, roiLum.wrongChoice.med, 'g');
plot( tt, roiLum.wrongChoice.max, 'b');
plot( tt, roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
axis tight; title('anti choice');
subplot(3,4,7); hold on;
%    plot( tt, roiLum.rightChoice.min, 'k');
%    plot( tt, roiLum.rightChoice.med, 'g');
plot( tt, roiLum.rightChoice.max, 'b');
plot( tt, roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
axis tight;  title('reward choice');
subplot(3,4,8); hold on;
%    plot( tt, roiLum.jumpBarrier.min, 'k');
%    plot( tt, roiLum.jumpBarrier.med, 'g');
plot( tt, roiLum.jumpBarrier.max, 'b');
plot( tt, roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
axis tight; title('jump');
subplot(3,4,9); hold on;
%    plot( tt, roiLum.bucketRun.min, 'k');
%    plot( tt, roiLum.bucketRun.med, 'g');
plot( tt, roiLum.bucketRun.max, 'b');
plot( tt, roiLum.bucketRun.std + roiLum.bucketRun.med, 'r');
axis tight; title('bucket @ start');
subplot(3,4,10); hold on;
%    plot( tt, roiLum.probeBarrier.min, 'k');
%    plot( tt, roiLum.probeBarrier.med, 'g');
plot( tt, roiLum.probeBarrier.max, 'b');
plot( tt, roiLum.probeBarrier.std + roiLum.probeBarrier.med, 'r');
axis tight; title('probe barrier');  % this is the brick at the probe
subplot(3,4,11); hold on; plot( tt,deltaPx); axis tight;  title('total change');
subplot(3,4,12); hold on; plot( tt,totalLum); axis tight;  title('median Lum');
tt=(1:length(roiLum.brick.min))/(29.97*60);
figure(3)
subplot(10,1,1); hold on;
plot( tt, roiLum.start.max, 'b');
plot( tt, roiLum.start.std + roiLum.start.med, 'r');
axis tight; legend('start');
subplot(10,1,2); hold on;
plot( tt, roiLum.bucketRun.max, 'b');
plot( tt, roiLum.bucketRun.std + roiLum.bucketRun.med, 'r');
axis tight; legend('bucket @ start');
subplot(10,1,3); hold on;
plot( tt, roiLum.brick.max, 'b');
plot( tt, roiLum.brick.std + roiLum.brick.med, 'r');
axis tight; legend('brick');
subplot(10,1,4); hold on;
plot( tt, roiLum.choicePoint.max, 'b');
plot( tt, roiLum.choicePoint.std + roiLum.choicePoint.med, 'r');
axis tight; legend('choice');
subplot(10,1,5); hold on;
plot( tt, roiLum.wrongChoice.max, 'b');
plot( tt, roiLum.wrongChoice.std + roiLum.wrongChoice.med, 'r');
axis tight; legend('anti choice');
subplot(10,1,6); hold on;
plot( tt, roiLum.rightChoice.max, 'b');
plot( tt, roiLum.rightChoice.std + roiLum.rightChoice.med, 'r');
axis tight;  legend('reward choice');
subplot(10,1,7); hold on;
plot( tt, roiLum.wrongEnd.max, 'b');
plot( tt, roiLum.wrongEnd.std + roiLum.wrongEnd.med, 'r');
axis tight; legend('anti reward');
subplot(10,1,8); hold on;
plot( tt, roiLum.rightEnd.max, 'b');
plot( tt, roiLum.rightEnd.std + roiLum.rightEnd.med, 'r');
axis tight; legend('reward');
subplot(10,1,9); hold on;
plot( tt, roiLum.jumpBarrier.max, 'b');
plot( tt, roiLum.jumpBarrier.std + roiLum.jumpBarrier.med, 'r');
axis tight; legend('jump');
subplot(10,1,10); hold on;
plot( tt, roiLum.probeBarrier.max, 'b');
plot( tt, roiLum.probeBarrier.std + roiLum.probeBarrier.med, 'r');
axis tight; legend('probe barrier');  % this is the brick at the probe
5,607.59*3
21850*.15
%-- 11/28/17, 3:44 PM --%
plusTrials=zeros(23,8);
plusErrors=zeros(23,8);
plusTrialTimes=zeros(23,8);
figure; plot(plusTrials)
figure;
subplot(3,1,1); plot(plusTrials); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,2); plot(plusErrors); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,3); plot(plusTrialTimes); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,1); plot(plusTrials); title('trials'); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,2); plot(plusErrors); title('errors'); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,3); plot(plusTrialTimes); title('mean trial times'); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
figure;
subplot(3,1,1); plot(plusTrials(:,7)); title('trials'); axis tight;
subplot(3,1,2); plot(plusErrors(:,7)); title('errors'); axis tight;
subplot(3,1,3); plot(plusTrialTimes(:,7)); title('mean trial times'); axis tight;
figure;  % da5
subplot(3,1,1); plot(plusTrials(1:13,7)); title('trials'); axis tight;
subplot(3,1,2); plot(plusErrors(1:13,7)); title('errors'); axis tight;
subplot(3,1,3); plot(plusTrialTimes(1:13,7)); title('mean trial times'); axis tight;
figure;  % da5
subplot(3,1,1); plot(plusTrials(1:13,5:8)); title('trials'); axis tight; ylim([0 20]);
subplot(3,1,2); plot(plusErrors(1:13,5:8)); title('errors'); axis tight;  ylim([0 20]);
subplot(3,1,3); plot(plusTrialTimes(1:13,5:8)); title('mean trial times'); axis tight; ylim([0 200]);
figure;  % da5
subplot(3,1,1); plot(plusTrials(1:13,5:8)); title('trials'); axis tight; ylim([0 20]);
subplot(3,1,2); plot(plusErrors(1:13,5:8)./plusTrials(1:13,5:8)); title('errors'); axis tight;  ylim([0 1]);
subplot(3,1,3); plot(plusTrialTimes(1:13,5:8)); title('mean trial times'); axis tight; ylim([0 85]);
legend('da10','da12','da5','da8');
da5=zeros(121,6);
figure; % da5
subplot(5,1,1); plot(da5(:,1), da5(:,2)); legend('trial time'); axis tight;
subplot(5,1,2); plot(da5(:,1), da5(:,3)); legend('error'); axis tight;
subplot(5,1,3); plot(da5(:,1), da5(:,4)); legend('probe'); axis tight;
subplot(5,1,4); plot(da5(:,1), da5(:,5)); legend('out bounds'); axis tight;
subplot(5,1,5); plot(da5(:,1), da5(:,6)); legend('brick jump'); axis tight;
subplot(5,1,1); plot(da5(:,1), da5(:,2), '*-' ); legend('trial time'); axis tight;
subplot(5,1,2); plot(da5(:,1), da5(:,3), '*-' ); legend('error'); axis tight;
subplot(5,1,3); plot(da5(:,1), da5(:,4), '*-' ); legend('probe'); axis tight;
subplot(5,1,4); plot(da5(:,1), da5(:,5), '*-' ); legend('out bounds'); axis tight;
subplot(5,1,5); plot(da5(:,1), da5(:,6), '*-' ); legend('brick jump'); axis tight;
bh1=zeros(188,9);
bh2=zeros(146,9);
bh3=zeros(188,9);
bh4=zeros(177,9);
da5=zeros(121,9);
da8=zeros(44,9);
da10=zeros(78,9);
da12=zeros(76,9);
figure; % bh1
subplot(8,1,1); plot(bh1(:,1), bh1(:,2) );  hold on; plot(bh1(:,1), bh1(:,2), 'o' ); title('bh1'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh1(:,1), bh1(:,3) );  hold on; plot(bh1(:,1), bh1(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh1(:,1), bh1(:,4) );  hold on; plot(bh1(:,1), bh1(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,5) );  hold on; plot(bh1(:,1), bh1(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,6) );  hold on; plot(bh1(:,1), bh1(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh1(:,1), bh1(:,7) );  hold on; plot(bh1(:,1), bh1(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh1(:,1), bh1(:,8) );  hold on; plot(bh1(:,1), bh1(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh1(:,1), bh1(:,9) );  hold on; plot(bh1(:,1), bh1(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh2
subplot(8,1,1); plot(bh2(:,1), bh2(:,2) );  hold on; plot(bh2(:,1), bh2(:,2), 'o' ); title('bh2'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh2(:,1), bh2(:,3) );  hold on; plot(bh2(:,1), bh2(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh2(:,1), bh2(:,4) );  hold on; plot(bh2(:,1), bh2(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,5) );  hold on; plot(bh2(:,1), bh2(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,6) );  hold on; plot(bh2(:,1), bh2(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh2(:,1), bh2(:,7) );  hold on; plot(bh2(:,1), bh2(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh2(:,1), bh2(:,8) );  hold on; plot(bh2(:,1), bh2(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh2(:,1), bh2(:,9) );  hold on; plot(bh2(:,1), bh2(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh3
subplot(8,1,1); plot(bh3(:,1), bh3(:,2) );  hold on; plot(bh3(:,1), bh3(:,2), 'o' ); title('bh3'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh3(:,1), bh3(:,3) );  hold on; plot(bh3(:,1), bh3(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh3(:,1), bh3(:,4) );  hold on; plot(bh3(:,1), bh3(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,5) );  hold on; plot(bh3(:,1), bh3(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,6) );  hold on; plot(bh3(:,1), bh3(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh3(:,1), bh3(:,7) );  hold on; plot(bh3(:,1), bh3(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh3(:,1), bh3(:,8) );  hold on; plot(bh3(:,1), bh3(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh3(:,1), bh3(:,9) );  hold on; plot(bh3(:,1), bh3(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh4
subplot(8,1,1); plot(bh4(:,1), bh4(:,2) );  hold on; plot(bh4(:,1), bh4(:,2), 'o' ); title('bh4'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh4(:,1), bh4(:,3) );  hold on; plot(bh4(:,1), bh4(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh4(:,1), bh4(:,4) );  hold on; plot(bh4(:,1), bh4(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,5) );  hold on; plot(bh4(:,1), bh4(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,6) );  hold on; plot(bh4(:,1), bh4(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh4(:,1), bh4(:,7) );  hold on; plot(bh4(:,1), bh4(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh4(:,1), bh4(:,8) );  hold on; plot(bh4(:,1), bh4(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh4(:,1), bh4(:,9) );  hold on; plot(bh4(:,1), bh4(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da5
subplot(8,1,1); plot(da5(:,1), da5(:,2) );  hold on; plot(da5(:,1), da5(:,2), 'o' ); title('da5'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da5(:,1), da5(:,3) );  hold on; plot(da5(:,1), da5(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da5(:,1), da5(:,4) );  hold on; plot(da5(:,1), da5(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,5) );  hold on; plot(da5(:,1), da5(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,6) );  hold on; plot(da5(:,1), da5(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da5(:,1), da5(:,7) );  hold on; plot(da5(:,1), da5(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da5(:,1), da5(:,8) );  hold on; plot(da5(:,1), da5(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da5(:,1), da5(:,9) );  hold on; plot(da5(:,1), da5(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da8
subplot(8,1,1); plot(da8(:,1), da8(:,2) );  hold on; plot(da8(:,1), da8(:,2), 'o' ); title('da8'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da8(:,1), da8(:,3) );  hold on; plot(da8(:,1), da8(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da8(:,1), da8(:,4) );  hold on; plot(da8(:,1), da8(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,5) );  hold on; plot(da8(:,1), da8(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,6) );  hold on; plot(da8(:,1), da8(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da8(:,1), da8(:,7) );  hold on; plot(da8(:,1), da8(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da8(:,1), da8(:,8) );  hold on; plot(da8(:,1), da8(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da8(:,1), da8(:,9) );  hold on; plot(da8(:,1), da8(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da10
subplot(8,1,1); plot(da10(:,1), da10(:,2) );  hold on; plot(da10(:,1), da10(:,2), 'o' ); title('da10'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da10(:,1), da10(:,3) );  hold on; plot(da10(:,1), da10(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da10(:,1), da10(:,4) );  hold on; plot(da10(:,1), da10(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,5) );  hold on; plot(da10(:,1), da10(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,6) );  hold on; plot(da10(:,1), da10(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da10(:,1), da10(:,7) );  hold on; plot(da10(:,1), da10(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da10(:,1), da10(:,8) );  hold on; plot(da10(:,1), da10(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da10(:,1), da10(:,9) );  hold on; plot(da10(:,1), da10(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da12
subplot(8,1,1); plot(da12(:,1), da12(:,2) );  hold on; plot(da12(:,1), da12(:,2), 'o' ); title('da12'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da12(:,1), da12(:,3) );  hold on; plot(da12(:,1), da12(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da12(:,1), da12(:,4) );  hold on; plot(da12(:,1), da12(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,5) );  hold on; plot(da12(:,1), da12(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,6) );  hold on; plot(da12(:,1), da12(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da12(:,1), da12(:,7) );  hold on; plot(da12(:,1), da12(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da12(:,1), da12(:,8) );  hold on; plot(da12(:,1), da12(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da12(:,1), da12(:,9) );  hold on; plot(da12(:,1), da12(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh1
subplot(8,1,1); plot(bh1(:,1), bh1(:,2) );  hold on; plot(bh1(:,1), bh1(:,2), 'o' ); title('bh1'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh1(:,1), bh1(:,3) );  hold on; plot(bh1(:,1), bh1(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh1(:,1), bh1(:,4) );  hold on; plot(bh1(:,1), bh1(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,5) );  hold on; plot(bh1(:,1), bh1(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,6) );  hold on; plot(bh1(:,1), bh1(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh1(:,1), bh1(:,7) );  hold on; plot(bh1(:,1), bh1(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh1(:,1), bh1(:,8) );  hold on; plot(bh1(:,1), bh1(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh1(:,1), bh1(:,9) );  hold on; plot(bh1(:,1), bh1(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh2
subplot(8,1,1); plot(bh2(:,1), bh2(:,2) );  hold on; plot(bh2(:,1), bh2(:,2), 'o' ); title('bh2'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh2(:,1), bh2(:,3) );  hold on; plot(bh2(:,1), bh2(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh2(:,1), bh2(:,4) );  hold on; plot(bh2(:,1), bh2(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,5) );  hold on; plot(bh2(:,1), bh2(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,6) );  hold on; plot(bh2(:,1), bh2(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh2(:,1), bh2(:,7) );  hold on; plot(bh2(:,1), bh2(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh2(:,1), bh2(:,8) );  hold on; plot(bh2(:,1), bh2(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh2(:,1), bh2(:,9) );  hold on; plot(bh2(:,1), bh2(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh3
subplot(8,1,1); plot(bh3(:,1), bh3(:,2) );  hold on; plot(bh3(:,1), bh3(:,2), 'o' ); title('bh3'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh3(:,1), bh3(:,3) );  hold on; plot(bh3(:,1), bh3(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh3(:,1), bh3(:,4) );  hold on; plot(bh3(:,1), bh3(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,5) );  hold on; plot(bh3(:,1), bh3(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,6) );  hold on; plot(bh3(:,1), bh3(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh3(:,1), bh3(:,7) );  hold on; plot(bh3(:,1), bh3(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh3(:,1), bh3(:,8) );  hold on; plot(bh3(:,1), bh3(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh3(:,1), bh3(:,9) );  hold on; plot(bh3(:,1), bh3(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh4
subplot(8,1,1); plot(bh4(:,1), bh4(:,2) );  hold on; plot(bh4(:,1), bh4(:,2), 'o' ); title('bh4'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh4(:,1), bh4(:,3) );  hold on; plot(bh4(:,1), bh4(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh4(:,1), bh4(:,4) );  hold on; plot(bh4(:,1), bh4(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,5) );  hold on; plot(bh4(:,1), bh4(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,6) );  hold on; plot(bh4(:,1), bh4(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh4(:,1), bh4(:,7) );  hold on; plot(bh4(:,1), bh4(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh4(:,1), bh4(:,8) );  hold on; plot(bh4(:,1), bh4(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh4(:,1), bh4(:,9) );  hold on; plot(bh4(:,1), bh4(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da5
subplot(8,1,1); plot(da5(:,1), da5(:,2) );  hold on; plot(da5(:,1), da5(:,2), 'o' ); title('da5'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da5(:,1), da5(:,3) );  hold on; plot(da5(:,1), da5(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da5(:,1), da5(:,4) );  hold on; plot(da5(:,1), da5(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,5) );  hold on; plot(da5(:,1), da5(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,6) );  hold on; plot(da5(:,1), da5(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da5(:,1), da5(:,7) );  hold on; plot(da5(:,1), da5(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da5(:,1), da5(:,8) );  hold on; plot(da5(:,1), da5(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da5(:,1), da5(:,9) );  hold on; plot(da5(:,1), da5(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da8
subplot(8,1,1); plot(da8(:,1), da8(:,2) );  hold on; plot(da8(:,1), da8(:,2), 'o' ); title('da8'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da8(:,1), da8(:,3) );  hold on; plot(da8(:,1), da8(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da8(:,1), da8(:,4) );  hold on; plot(da8(:,1), da8(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,5) );  hold on; plot(da8(:,1), da8(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,6) );  hold on; plot(da8(:,1), da8(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da8(:,1), da8(:,7) );  hold on; plot(da8(:,1), da8(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da8(:,1), da8(:,8) );  hold on; plot(da8(:,1), da8(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da8(:,1), da8(:,9) );  hold on; plot(da8(:,1), da8(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da10
subplot(8,1,1); plot(da10(:,1), da10(:,2) );  hold on; plot(da10(:,1), da10(:,2), 'o' ); title('da10'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da10(:,1), da10(:,3) );  hold on; plot(da10(:,1), da10(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da10(:,1), da10(:,4) );  hold on; plot(da10(:,1), da10(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,5) );  hold on; plot(da10(:,1), da10(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,6) );  hold on; plot(da10(:,1), da10(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da10(:,1), da10(:,7) );  hold on; plot(da10(:,1), da10(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da10(:,1), da10(:,8) );  hold on; plot(da10(:,1), da10(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da10(:,1), da10(:,9) );  hold on; plot(da10(:,1), da10(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da12
subplot(8,1,1); plot(da12(:,1), da12(:,2) );  hold on; plot(da12(:,1), da12(:,2), 'o' ); title('da12'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da12(:,1), da12(:,3) );  hold on; plot(da12(:,1), da12(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da12(:,1), da12(:,4) );  hold on; plot(da12(:,1), da12(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,5) );  hold on; plot(da12(:,1), da12(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,6) );  hold on; plot(da12(:,1), da12(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da12(:,1), da12(:,7) );  hold on; plot(da12(:,1), da12(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da12(:,1), da12(:,8) );  hold on; plot(da12(:,1), da12(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da12(:,1), da12(:,9) );  hold on; plot(da12(:,1), da12(:,9), 'o' ); hold off; legend('teleports'); axis tight;
close all;
figure; % bh1
subplot(8,1,1); plot(bh1(:,1), bh1(:,2) );  hold on; plot(bh1(:,1), bh1(:,2), 'o' ); title('bh1'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh1(:,1), bh1(:,3) );  hold on; plot(bh1(:,1), bh1(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh1(:,1), bh1(:,4) );  hold on; plot(bh1(:,1), bh1(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,5) );  hold on; plot(bh1(:,1), bh1(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh1(:,1), bh1(:,6) );  hold on; plot(bh1(:,1), bh1(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh1(:,1), bh1(:,7) );  hold on; plot(bh1(:,1), bh1(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh1(:,1), bh1(:,8) );  hold on; plot(bh1(:,1), bh1(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh1(:,1), bh1(:,9) );  hold on; plot(bh1(:,1), bh1(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh2
subplot(8,1,1); plot(bh2(:,1), bh2(:,2) );  hold on; plot(bh2(:,1), bh2(:,2), 'o' ); title('bh2'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh2(:,1), bh2(:,3) );  hold on; plot(bh2(:,1), bh2(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh2(:,1), bh2(:,4) );  hold on; plot(bh2(:,1), bh2(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,5) );  hold on; plot(bh2(:,1), bh2(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh2(:,1), bh2(:,6) );  hold on; plot(bh2(:,1), bh2(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh2(:,1), bh2(:,7) );  hold on; plot(bh2(:,1), bh2(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh2(:,1), bh2(:,8) );  hold on; plot(bh2(:,1), bh2(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh2(:,1), bh2(:,9) );  hold on; plot(bh2(:,1), bh2(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh3
subplot(8,1,1); plot(bh3(:,1), bh3(:,2) );  hold on; plot(bh3(:,1), bh3(:,2), 'o' ); title('bh3'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh3(:,1), bh3(:,3) );  hold on; plot(bh3(:,1), bh3(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh3(:,1), bh3(:,4) );  hold on; plot(bh3(:,1), bh3(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,5) );  hold on; plot(bh3(:,1), bh3(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh3(:,1), bh3(:,6) );  hold on; plot(bh3(:,1), bh3(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh3(:,1), bh3(:,7) );  hold on; plot(bh3(:,1), bh3(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh3(:,1), bh3(:,8) );  hold on; plot(bh3(:,1), bh3(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh3(:,1), bh3(:,9) );  hold on; plot(bh3(:,1), bh3(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh4
subplot(8,1,1); plot(bh4(:,1), bh4(:,2) );  hold on; plot(bh4(:,1), bh4(:,2), 'o' ); title('bh4'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh4(:,1), bh4(:,3) );  hold on; plot(bh4(:,1), bh4(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh4(:,1), bh4(:,4) );  hold on; plot(bh4(:,1), bh4(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,5) );  hold on; plot(bh4(:,1), bh4(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh4(:,1), bh4(:,6) );  hold on; plot(bh4(:,1), bh4(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh4(:,1), bh4(:,7) );  hold on; plot(bh4(:,1), bh4(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh4(:,1), bh4(:,8) );  hold on; plot(bh4(:,1), bh4(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh4(:,1), bh4(:,9) );  hold on; plot(bh4(:,1), bh4(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da5
subplot(8,1,1); plot(da5(:,1), da5(:,2) );  hold on; plot(da5(:,1), da5(:,2), 'o' ); title('da5'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da5(:,1), da5(:,3) );  hold on; plot(da5(:,1), da5(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da5(:,1), da5(:,4) );  hold on; plot(da5(:,1), da5(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,5) );  hold on; plot(da5(:,1), da5(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da5(:,1), da5(:,6) );  hold on; plot(da5(:,1), da5(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da5(:,1), da5(:,7) );  hold on; plot(da5(:,1), da5(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da5(:,1), da5(:,8) );  hold on; plot(da5(:,1), da5(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da5(:,1), da5(:,9) );  hold on; plot(da5(:,1), da5(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da8
subplot(8,1,1); plot(da8(:,1), da8(:,2) );  hold on; plot(da8(:,1), da8(:,2), 'o' ); title('da8'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da8(:,1), da8(:,3) );  hold on; plot(da8(:,1), da8(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da8(:,1), da8(:,4) );  hold on; plot(da8(:,1), da8(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,5) );  hold on; plot(da8(:,1), da8(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da8(:,1), da8(:,6) );  hold on; plot(da8(:,1), da8(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da8(:,1), da8(:,7) );  hold on; plot(da8(:,1), da8(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da8(:,1), da8(:,8) );  hold on; plot(da8(:,1), da8(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da8(:,1), da8(:,9) );  hold on; plot(da8(:,1), da8(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da10
subplot(8,1,1); plot(da10(:,1), da10(:,2) );  hold on; plot(da10(:,1), da10(:,2), 'o' ); title('da10'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da10(:,1), da10(:,3) );  hold on; plot(da10(:,1), da10(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da10(:,1), da10(:,4) );  hold on; plot(da10(:,1), da10(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,5) );  hold on; plot(da10(:,1), da10(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da10(:,1), da10(:,6) );  hold on; plot(da10(:,1), da10(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da10(:,1), da10(:,7) );  hold on; plot(da10(:,1), da10(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da10(:,1), da10(:,8) );  hold on; plot(da10(:,1), da10(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da10(:,1), da10(:,9) );  hold on; plot(da10(:,1), da10(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da12
subplot(8,1,1); plot(da12(:,1), da12(:,2) );  hold on; plot(da12(:,1), da12(:,2), 'o' ); title('da12'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da12(:,1), da12(:,3) );  hold on; plot(da12(:,1), da12(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da12(:,1), da12(:,4) );  hold on; plot(da12(:,1), da12(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,5) );  hold on; plot(da12(:,1), da12(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da12(:,1), da12(:,6) );  hold on; plot(da12(:,1), da12(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da12(:,1), da12(:,7) );  hold on; plot(da12(:,1), da12(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da12(:,1), da12(:,8) );  hold on; plot(da12(:,1), da12(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da12(:,1), da12(:,9) );  hold on; plot(da12(:,1), da12(:,9), 'o' ); hold off; legend('teleports'); axis tight;
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/2017-10-27_training1/VT0.nvt';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos); tt=(xytimestamps-xytimestamps(1))/60e6;
figure; subplot(1,2,1); plot(xpos,ypos,'Color',[ 1 1 1 .05 ]); subplot(1,2,2); plot3(tt,xpos,ypos);
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/2017-10-27_training1/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos); tt=(xytimestamps-xytimestamps(1))/60e6;
figure; subplot(1,2,1); plot(xpos,ypos,'Color',[ 1 1 1 .05 ]); subplot(1,2,2); plot3(tt,xpos,ypos);
figure; subplot(1,2,1); plot(xpos,ypos,'Color',[ 0 0 0 .05 ]); subplot(1,2,2); plot3(tt,xpos,ypos);
x = xpos;
y = ypos;
z = zeros(size(x));
figure;
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [tt(:), tt(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap( build_NOAA_colorgradient ); colorbar;
title('place by speed plot');
legend(legendText);
figure;
h = surface([x(:), x(:)], [y(:), y(:)], [tt(:), tt(:)], [tt(:), tt(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap( build_NOAA_colorgradient ); colorbar;
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/2017-11-06_training7/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos); tt=(xytimestamps-xytimestamps(1))/60e6;
figure; subplotIdx=0;
for ii=1:round(5*60*29.97):length(xx)-round(5*60*29.97)
pp=ii:ii+round(5*60*29.97); subplotIdx=subplotIdx+1;
subplot(3,4,subplotIdx);  h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar;
end
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/2017-11-06_training7/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos); tt=(xytimestamps-xytimestamps(1))/60e6;
figure; subplotIdx=0;
for ii=1:round(5*60*29.97):length(xpos)-round(5*60*29.97)
pp=ii:ii+round(5*60*29.97); subplotIdx=subplotIdx+1;
subplot(3,4,subplotIdx);  h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar;
end
figure; subplotIdx=0;
for ii=1:round(5*60*29.97):length(xpos)-round(5*60*29.97)
pp=ii:ii+round(5*60*29.97); subplotIdx=subplotIdx+1;
subplot(3,3,subplotIdx);  h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar;
xlim([0 720]); ylim([0 420]);
end
figure; pp=round(6*5*60*29.97):round(7*5*60*29.97);  subplot(3,3,subplotIdx);  h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 720]); ylim([0 420]);
figure; pp=round(6*5*60*29.97):round(7*5*60*29.97); h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 720]); ylim([0 420]);
figure; pp=round(5*5*60*29.97):round(6*5*60*29.97); h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 720]); ylim([0 420]);
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-20_/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos); tt=(xytimestamps-xytimestamps(1))/60e6;
figure; pp=1:round(2*5*60*29.97); h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 720]); ylim([0 420]);
figure; pp=1:round(1*5*60*29.97); h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 720]); ylim([0 420]);
figure; pp=1:round(1*5*60*29.97); h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 480]); ylim([0 720]);
figure; pp=1:round(1*5*60*29.97); h = surface([xpos(pp), xpos(pp)], [ypos(pp), ypos(pp)], [tt(pp), tt(pp)], [tt(pp), tt(pp)], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.2); colormap( build_NOAA_colorgradient ); colorbar; xlim([0 720]); ylim([0 480]);
45/3
23-15
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-20_/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos); tt=(xytimestamps-xytimestamps(1))/60e6;
[ lfp88, lfpTimestamps ] = csc2mat([ dir 'CSC88.ncs']); % inverted SWR; below layer
[ lfp61 ] = csc2mat([ dir 'CSC61.ncs']); % above layer (non inverted SWR)
[ lfp6 ] = csc2mat([ dir 'CSC6.ncs']); % NAc, to eliminate noise from bucket slam vs SWR
[ lfp76 ] = csc2mat([ dir 'CSC76.ncs']); %
[ lfp64 ] = csc2mat([ dir 'CSC64.ncs']); %
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
makeFilters
[ lfp88, lfpTimestamps ] = csc2mat([ dir 'CSC88.ncs']); % inverted SWR; below layer
[ lfp61 ] = csc2mat([ dir 'CSC61.ncs']); % above layer (non inverted SWR)
[ lfp6 ] = csc2mat([ dir 'CSC6.ncs']); % NAc, to eliminate noise from bucket slam vs SWR
[ lfp76 ] = csc2mat([ dir 'CSC76.ncs']); %
[ lfp64 ] = csc2mat([ dir 'CSC64.ncs']); %
figure; hold on;
thisLfp=lfp88;
filterBandLfp = filtfilt( filters.swr, thisLfp );
% find the envelope (to limit the peak detection)
filterBandLfpHilbert = hilbert( filterBandLfp );
env=abs(filterBandHilbert);
plot(timestampSeconds,env);
thisLfp=lfp88;
filterBandLfp = filtfilt( filters.ao.swr, thisLfp );
% find the envelope (to limit the peak detection)
filterBandLfpHilbert = hilbert( filterBandLfp );
env=abs(filterBandHilbert);
plot(timestampSeconds,env);
[yy,xx]=hist(env,1:1000);
env=abs(filterBandLfpHilbert);
plot(timestampSeconds,env);
[yy,xx]=hist(env,1:1000);
%-- 11/30/17, 11:49 PM --%



figure; plot(xytimestampSeconds,xraw); hold on; plot(xytimestampSeconds,xpos);
plot(xytimestampSeconds,nlxPositionFixer(xraw,30,1));


figure; plot(xraw,yraw); hold on; plot(xpos,ypos); plot(nlxPositionFixer(xraw,60,1),nlxPositionFixer(yraw,60,1));

subplot(7,1,7); hold on; plot(xytimestampSeconds(2:end),diff(speed));