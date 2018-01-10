

%% some analysis on the raw video 
% ** load and scale mask file
% ** setup video object
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
vidObj = VideoReader([ dir 'VT1_01.mpg']);
vidHeight = vidObj.Height; vidWidth = vidObj.Width; 
%frame = readFrame(vidObj);
% ** get average frame
vidObj.CurrentTime = 0;
numFrames = 0;
while hasFrame( vidObj )
    frame = readFrame( vidObj );
    frame = mean( frame, 3 );   % make black and white
    if numFrames > 0
        avgFrame = avgFrame + frame;
    else
        avgFrame = frame;
    end
    numFrames = numFrames + 1;
end
avgFrame = avgFrame./numFrames;
%
% now analyze video
%
% *** 
%
maskDir = '/Users/andrewhowe/src/MATLAB/defaultFolder/';
mazeMask.surround=imread([ maskDir 'mazeSurroundMask.png' ]);
mazeMask.surround=mean(mazeMask.surround,3); 
mazeMask.surround=mazeMask.surround/max(mazeMask.surround(:));
%
mazeMask.bucketRest=imread([ maskDir 'mazeBucketRestRegionsMask.png' ]);
mazeMask.bucketRest=mean(mazeMask.bucketRest,3); 
mazeMask.bucketRest=mazeMask.bucketRest/max(mazeMask.bucketRest(:));
%
mazeMask.bucketRunPosition=imread([ maskDir 'bucketRunPositionMask.png' ]);
mazeMask.bucketRunPosition=mean(mazeMask.bucketRunPosition,3); 
mazeMask.bucketRunPosition=mazeMask.bucketRunPosition/max(mazeMask.bucketRunPosition(:));
%
maskIdxs.surround=find(mazeMask.surround>0.95);
maskIdxs.bucketRest=find(mazeMask.bucketRest>0.95);
maskIdxs.bucketRunPosition=find(mazeMask.bucketRunPosition>0.95);
%
vidObj.CurrentTime = 0;   % rewind
sumEdgeChange = zeros( 1, numFrames );
sumBucketChange = zeros( 1, numFrames );
sumBucketRun = zeros( 1, numFrames );
%
ii=1;
while hasFrame( vidObj )
    frame = readFrame( vidObj );
    frame = mean( frame, 3 );   % make black and white
    bkDiff = frame-avgFrame;
    sumEdgeChange(ii) = sum(sum(abs(bkDiff(maskIdxs.surround))));
    sumBucketChange(ii) = sum(sum(abs(bkDiff(maskIdxs.bucketRest))));
    % sumBucketRun(ii) =
    % sum(sum(abs((bkDiff(maskIdxs.bucketRunPosition)))); doesn't work
    ii = ii + 1;
end
figure; 
plot(timestampSeconds,electricEnv./max(electricEnv));
hold on;
plot( (1:numFrames)/29.97, sumEdgeChange/max(sumEdgeChange) );
plot( (1:numFrames)/29.97, sumBucketChange/max(sumBucketChange) );
plot( (1:numFrames)/29.97, sumBucketRun/max(sumBucketRun) );
axis tight;






























%% misc code notes



vidObj.CurrentTime = 10;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
vidObj.CurrentTime = vidObj.CurrentTime + .3;
idx=1;
while hasFrame( vidObj ) && ( vidObj.CurrentTime < 200 );
    
    frame = readFrame( vidObj );
    frame = mean( frame, 3 );   % make black and white
    idx = idx + 1;

    objs = ( frame - lastFrame ); 
%    objs = ( frame - extractedBackground ).*mazeMask; 
%    objs(find(objs<5))=0;

    % region-finding -- doesn't quite work correctly
    % [labeledMatrix,regionLabels,regionSizes]=findBoundaries(abs(objs)>15,.1,10);

    figure(11); % colormap default;
    present = ( objs > 12 ).*2; % present
    %subplot(1,2,1); imagesc(present);
    past = ( objs < -12 );  % past
    subplot(1,2,1);
    imagesc(past+present); caxis([0 3]);
    
    subplot(1,2,2); 
    deltaFrame = ( frame - avgFrame );
    imagesc( deltaFrame );
    
    
%    objs = ( frame - extractedBackground ).*mazeMask; 
    %figure(11);imagesc(objs); caxis([0 255]);
    
    drawnow;
    lastFrame = frame;
    vidObj.CurrentTime = vidObj.CurrentTime + .3;  % advance ~10 frames
    
end

figure; imagesc(frame); colormap('bone');


figure; histogram(objs(:),100);






maskDir = '/Users/andrewhowe/src/MATLAB/defaultFolder/';
mazeMask.cableTrace=imread([ maskDir 'traceCableMazeMask2.png' ]);
mazeMask.cableTrace=mean(mazeMask.cableTrace,3); 
mazeMask.cableTrace=mazeMask.cableTrace/max(mazeMask.cableTrace(:));

vidObj.CurrentTime = 30;
frame = readFrame( vidObj );
frame = mean( frame, 3 );   % make black and white
lastFrame = mean( frame, 3 );
mvgAvgFrame = lastFrame;
vidObj.CurrentTime = vidObj.CurrentTime + .5;
idx=1;
figure(11);
while hasFrame( vidObj ) && ( vidObj.CurrentTime < 140 );
    
    frame = readFrame( vidObj );
    frame = mean( frame, 3 );   % make black and white
    idx = idx + 1;

    bgDeltaFrame = abs(frame - avgFrame).*mazeMask.cableTrace;
    mavDeltaFrame = abs(frame - mvgAvgFrame).*mazeMask.cableTrace;
    deltaFrame = abs(frame - lastFrame).*mazeMask.cableTrace; %lastFrame; % get the delta between the frames
    deltaFrameThreshold = prctile( deltaFrame(:), 97 );  % get a threshold
    deltaFrameNow = deltaFrame > deltaFrameThreshold ;
    subplot( 1,3,1 ); hold off;
    imagesc(bgDeltaFrame);
    hold on;
    for rowIdx=10:10:480
        [~,colIdx] = max(bgDeltaFrame(rowIdx,:));
        %colIdx=colIdx(1); % eliminate the duplicates due to thresholding
        scatter(colIdx(1),rowIdx,'o', 'filled', 'm');
    end
    [~,ii]=max(bgDeltaFrame(:));
    scatter(floor(ii/480),mod(ii,480),'*','r');
    subplot( 1,3,2 );
    hold off;
    imagesc(deltaFrame);
    hold on;
    for rowIdx=10:10:480
        [~,colIdx] = max(deltaFrame(rowIdx,:));
        scatter(colIdx(1),rowIdx,'>', 'filled', 'm');
        %scatter(colIdx(end),rowIdx,'<', 'filled', 'c');
    end
    subplot( 1,3,3 ); hold off;
    imagesc(mavDeltaFrame);
    hold on;
    for rowIdx=10:10:480
        [~,colIdx] = max(mavDeltaFrame(rowIdx,:));
        %colIdx=colIdx(1); % eliminate the duplicates due to thresholding
        scatter(colIdx(1),rowIdx,'o', 'filled', 'm');
    end
    drawnow;
    lastFrame = frame;
    mvgAvgFrame = 0.9.*mvgAvgFrame + 0.1.*frame;
    vidObj.CurrentTime = vidObj.CurrentTime + .3;
end
    
    
    
    
    


filters.ao.slow    = designfilt( 'bandpassiir', 'StopbandFrequency1', .1, 'PassbandFrequency1',  .3, 'PassbandFrequency2',    3, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 4, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
slow = filtfilt( filters.ao.slow, lfp88 );
figure; plot(timestampSeconds, lfp88); hold on; plot(timestampSeconds, slow)



theta = filtfilt( filters.ao.theta, avgLfp );
figure; plot(timestampSeconds, theta)



figure; 
subplot(5,1,1); plot( timestampSeconds, swrLfp88 ); axis tight; ylabel('ch88_{SWR}');
hold on;     scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
subplot(5,1,2); plot( timestampSeconds, lfp88 ); axis tight; ylabel('ch88');
subplot(5,1,3); plot( timestampSeconds, avgLfp ); axis tight; ylabel('avgLfp');




















% NOTE visualize the situation
if visualizeAll
%    subplot(4,1,3); hold on; 
%    plot( timestampSeconds, avgChew); plot(chewCrunchEnvTimes, chewCrunchEnv);
%    subplot(2,1,2); spectrogram(chewCrunchEnv,80,20,128,chewEnvSampleRate,'yaxis');
end
% the Crunchs are pretty clear in the spectrogram, and would become more
% obvious in the modulogram I guess (see above).





%% auto-detect chews to differentiate from potential SWR events
swrLfp88 = filtfilt( filters.so.swr, lfp88 );
swrLfp88Env = abs( hilbert(swrLfp88) );
[ swrPeakValues, ...
  swrPeakTimes, ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks(  swrLfp88Env,                              ... % data
                             timestampSeconds,                                  ... % sampling frequency
                             'MinPeakHeight',   std(swrLfp88Env)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


figure; 
subplot(5,1,1); plot( timestampSeconds, swrLfp88 ); axis tight; ylabel('ch88_{SWR}');
hold on;     scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
subplot(5,1,2); plot( timestampSeconds, lfp88 ); axis tight; ylabel('ch88');
subplot(5,1,3); plot( timestampSeconds, avgLfp ); axis tight; ylabel('avgLfp');




%%



%     elseif episodeStartIdx ~= 0
%         % we found a potential endpoint, but it ended before the cutoff so
%         % so reset and keep going back
%         episodeStartIdx = 0;
%         minValStreak = 0;
%     elseif minValStreak > 30
%         break;



%% identify chews packets as peaks in filtered raw average LFP
% this method works, but would require other types of refinements to use as
% a detector. The rat used for testing appears to chew "loudly" and then
% brux after being placed in the waiting bucket, which creates a confound
% in the chew event detection. Each chew has a strong onset and more
% gradual decay pattern. The bruxing looks more like a heaviside function,
% and can be picked up effectively with a different filterset.
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% 
filelist = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
avgLfp=avgLfpFromList( dir, filelist );  % build average LFP
%
sampleRate=32000;
% ignore the first and last seconds of the filtered signal to eliminate
% artifacts arising from the filtering process.
idxs=sampleRate*1:length(avgChew)-sampleRate*1;
[ chewPeakValues, ...
  chewPeakTimes, ...
  chewPeakProminances, ...
  chewPeakWidths ] = findpeaks(  avgChew(idxs),                              ... % data
                                 timestampSeconds(idxs),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                 'MinPeakHeight',   max(avgChew(idxs))*.2, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                 'MinPeakDistance', 0.1  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
%figure; plot(timestampSeconds, avgChew); hold on; plot(chewPeakTimes, chewPeakValues, '*')

%% maybe there is a way to tweak this filter so chewing and bruxing are better separated?
filters.ao.chew     = designfilt( 'bandpassiir', 'StopbandFrequency1',   80, 'PassbandFrequency1',  100, 'PassbandFrequency2', 1000, 'StopbandFrequency2', 1200, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order, settings by testing
avgChew = filtfilt( filters.so.chew, avgLfp );

%%

chewEnvSampleRate


centerIdx=round(length(tempEnv)/2);
max(tempEnv(centerIdx-round(10*60*chewEnvSampleRate):centerIdx+round(10*60*chewEnvSampleRate)))
figure; plot((tempEnv(centerIdx-round(10*60*chewEnvSampleRate):centerIdx+round(10*60*chewEnvSampleRate))))
    
figure; plot(tempEnv)


figure; hist( abs(hilbert(temp)), 200)

mean(abs(hilbert(temp)))
median()

aa=abs(hilbert(temp));


                         
% swr
swrLfp = filtfilt( filters.so.swr, lfp88 ); 
sampleRate=32000;
[ swrPeakValues, ...
  swrPeakTimes, ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks(  (swrLfp),                              ... % data
                               timestampSeconds,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %%%sampleRate,                                  ... % sampling frequency
                             'MinPeakHeight',   std(swrLfp)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak

figure;
subplot(3,1,1); hold off; plot(timestampSeconds, avgChew); hold on; plot( chewPeakTimes, chewPeakValues, 'o' ); %xlim([ 831 836 ]); legend('avg lfp');
subplot(3,1,2); hold off; plot(timestampSeconds, lfp88);   legend('lfp88(h.f.)'); %hold on; plot( peakTimes, peakValues, 'o' ); xlim([ 831 836 ]);
subplot(3,1,3); hold off; plot(timestampSeconds, swrLfp); hold on; plot( swrPeakTimes, swrPeakValues, 'o' ); %xlim([ 831 836 ]); legend('swr band');


subplot(3,1,1); xlim([ min(timestampSeconds) max(timestampSeconds) ] ); subplot(3,1,2); xlim([ min(timestampSeconds) max(timestampSeconds) ] );subplot(3,1,3); xlim([ min(timestampSeconds) max(timestampSeconds) ] );


return;

idxs=[ round(831*sampleRate):round(836*sampleRate) ];
figure; subplot(9,1,1); hold off; plot(timestampSeconds(idxs), lfp6(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp6(Rnac)'); %  xlim([ 831 836 ]); 
subplot(9,1,2); hold off; plot(timestampSeconds(idxs), lfp12(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp12(Rhf)');
subplot(9,1,3); hold off; plot(timestampSeconds(idxs), lfp16(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp16(Rhf)');
subplot(9,1,4); hold off; plot(timestampSeconds(idxs), lfp36(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp36(Rhf)');
subplot(9,1,5); hold off; plot(timestampSeconds(idxs), lfp46(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp46(vta)');
subplot(9,1,6); hold off; plot(timestampSeconds(idxs), lfp61(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp61(Lhf)');
subplot(9,1,7); hold off; plot(timestampSeconds(idxs), lfp64(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp64(Lhf)');
subplot(9,1,8); hold off; plot(timestampSeconds(idxs), lfp76(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp76(Lhf)');
subplot(9,1,9); hold off; plot(timestampSeconds(idxs), lfp88(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp88(Lhf)');


return;




633.5 - 636
586

61.2-29.4






avgChew = filtfilt( filters.so.chew, avgLfp ); 
figure; plot(timestampSeconds, avgChew)
sampleRate=32000;
[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  (avgChew),                              ... % data
                             sampleRate,                                  ... % sampling frequency
                             'MinPeakHeight',   .04, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
hold on; plot( peakTimes, peakValues, 'o' );

figure; [zz,xx]=hist(avgChew,200); plot(xx,zz);

%spectrogram(data,windowLength,overlap,dft pts, sampleRate, 'yaxis')
%figure; spectrogram(avgChew,sampleRate/4,sampleRate/16,128,sampleRate,'yaxis')
%not doing what I want; big power in 200-1kHz band, cant see low freq


sampleRate = 32000; % samples/second
windowSize = 2; % seconds
jumpSize = 1.5 % seconds
mvgAvg=[]; mvgStd=[]; mvgTt=[];
for ii=1:round(sampleRate*jumpSize):length(avgChew)-round(windowSize*sampleRate)
    mvgAvg = [ mvgAvg mean(avgChew(ii:ii+round(sampleRate*jumpSize))) ];
    mvgStd = [ mvgStd std(avgChew(ii:ii+round(sampleRate*jumpSize))) ];
    mvgTt  = [ mvgTt timestampSeconds(ii+round((sampleRate*jumpSize)/2)) ];
end
    






%235:245

%239.41
%239.31

%100 ms from peak to valley

winMax=[];
tt=[];
for ii=round(sampleRate*235):round(.1*sampleRate):round(sampleRate*245)
    tt=[ tt ii/sampleRate ];
    win=round(.025*sampleRate);
    winMax=[ winMax max(avgChew(ii-win:ii+win)) ];
end
plot(tt,winMax)


env=abs(hilbert(avgChew)); hold on; plot(timestampSeconds, env);


avgSpindle = filtfilt( filters.so.nrem, moreLfp ); figure; plot(timestampSeconds, avgSpindle)
env=abs(hilbert(avgSpindle)); hold on; plot(timestampSeconds, env);



%% example to find a profile over Crunchs
% this funny looking indexing is because there is a gap in the timestamps
idxs=round((584.5-31.8)*32000):round((587.5-31.8)*32000); [r,lags] = xcorr( avgChew(idxs)); figure; plot(lags,r)
%
aChew=avgChew(idxs);
aChewTimes=timestampSeconds(idxs);
maxes=[];
for ii=251:length(aChewTimes)-250
    maxes(ii)=max(abs(aChew(ii-250:ii+250)));
end
figure; plot(aChew); hold on; plot(maxes);



ee=abs(hilbert(electricAvgLfp));
gmodel=fitgmdist(ee,3);
gmodel.mu
gmodel.Sigma
disp(gmodel)
[yy,xx]=hist(ee,0:max(ee)/200:max(ee));
figure; plot(xx,yy/sum(yy)); axis tight; hold on;
norm = normpdf(xx,gmodel.mu(1),gmodel.Sigma(1)); plot(xx,norm*gmodel.ComponentProportion(1));
norm = normpdf(xx,gmodel.mu(2),gmodel.Sigma(2)); plot(xx,norm*gmodel.ComponentProportion(2));
norm = normpdf(xx,gmodel.mu(3),gmodel.Sigma(3)); plot(xx,norm*gmodel.ComponentProportion(3));


figure; subplot(2,2,1); plot(xx,yy/sum(yy));
subplot(2,2,2); norm = normpdf(xx,gmodel.mu(1),gmodel.Sigma(1)); plot(xx,norm);
subplot(2,2,3); norm = normpdf(xx,gmodel.mu(2),gmodel.Sigma(2)); plot(xx,norm);
subplot(2,2,4); norm = normpdf(xx,gmodel.mu(3),gmodel.Sigma(3)); plot(xx,norm);

figure; plot(xx,yy/sum(yy)); hold on; plot(gmodel.mu,zeros(1,3),'*');

plot(gmodel.mu+gmodel.Sigmas*2,zeros(1,3),'o');

norm = normpdf(xx,gmodel.mu(1),0.025); plot(xx,norm);

norm1 = normpdf(xx,gmodel.mu(1),0.0012); norm2 = normpdf(xx,0.009,0.002); 
zz=(max(yy/sum(yy))*norm1/max(norm1))+(0.025*norm2/max(norm2));  plot(xx,zz,'k');










%% trying to find signal jumps

% attempt to test for diff distributions
inputElements = length(electricEnv);
sampleRate = 32000;
halfWindowSize = 32000; % elements
overlapSize = 2*-32000;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( (2*halfWindowSize+1) - overlapSize ) ) ;
overlap = zeros(1,outputPoints);
eeMean  = zeros(1,outputPoints);
overlapTimes = zeros(1,outputPoints);
newSampleRate=sampleRate/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-jumpSize
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    population1 = electricEnv(ii);
    population2 = electricEnv(ii+jumpSize);
    eeMean(outputIdx)=mean(population1);
    if mean(population1) > mean(population2)
        overlap(outputIdx)=sum( population2 > min(population1) )/(2*halfWindowSize);
    else
        overlap(outputIdx)=sum( population1 > min(population2) )/(2*halfWindowSize);
    end
    overlapTimes(outputIdx) = timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end

figure;hold on; plot(overlapTimes,0.02*(overlap<0.05),'r'); plot(timestampSeconds,ee);


figure; hold on; plot(timestampSeconds,electricEnv); plot(overlapTimes, eeMean); plot(overlapTimes(2:end), diff(eeMean)); 





% what do the mean & std look like
% doesn't add anything peak detect doesn't already have
inputElements = length(ee);
sampleRate = 32000;
halfWindowSize = 64000; % elements
overlapSize = 16000;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( (2*halfWindowSize+1) - overlapSize ) ) ;
vars = zeros(1,outputPoints);
means = zeros(1,outputPoints);
statTimes = zeros(1,outputPoints);
newSampleRate=sampleRate/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-jumpSize
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    population1 = ee(ii);
    vars(outputIdx)=std(population1);
    means(outputIdx)=mean(population1);
    statTimes(outputIdx) = timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end

figure; plot(timestampSeconds,ee); hold on; plot(statTimes,vars); plot(statTimes,means);





%% this will plot outputs from peakEdges  %%%%%%%%
% detect peaks on the Max Enveloped signal
elecLfp=filtfilt( filters.so.electric, electricAvgLfp );
ee=abs(hilbert(elecLfp));
extents=detectPeaksEdges( ee, timestampSeconds, 32000 )
figure; hold on; plot(timestampSeconds,ee);
scatter( extents.chewEpisodePeakTimes, extents.chewEpisodePeakValues, 'v', 'filled');
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
for jj=1:length(extents.chewEpisodeEndIdxs);
   if  extents.chewEpisodeStartIdxs(jj) > 0
       scatter( timestampSeconds( extents.chewEpisodeStartIdxs(jj) ), -0.01, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( timestampSeconds( 1 ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
   if  extents.chewEpisodeEndIdxs(jj) < length(timestampSeconds)
       scatter( timestampSeconds(  extents.chewEpisodeEndIdxs(jj) ), -0.01, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( timestampSeconds( end ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end

%
episodeMask=zeros(1,length(ee));
for ii=1:length(extents.chewEpisodeEndIdxs)
    episodeMask(extents.chewEpisodeStartIdxs:extents.chewEpisodeEndIdxs)=1;
end


%,  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));


% fixed location; might break things later
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%
if visualizeAll
   % figure; plot( chewEnvTimes(envIdx-2000:envIdx+2000), temp(envIdx-2000:envIdx+2000) ); hold on; plot( chewEnvTimes(envIdx-2000:envIdx+2000), tempEnv(envIdx-2000:envIdx+2000) ); hold on; plot( chewEnvTimes(episodeStartIdx), tempEnv(episodeStartIdx), '*')
   if chewEpisodeStartIdxs(jj) > 0
       scatter( chewCrunchEnvTimes( chewEpisodeStartIdxs(jj) ), -0.01, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( chewCrunchEnvTimes( 1 ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end

%
if visualizeAll
   scatter( chewCrunchEnvTimes( chewEpisodeEndIdxs(jj) ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
end