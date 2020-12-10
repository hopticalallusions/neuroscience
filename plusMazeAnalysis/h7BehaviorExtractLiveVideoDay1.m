 % In some of these live video processing scripts, try to normalize the 
   % illumination of the frame, as this will help reduce artifacts arising
   % from illumination changes vs the motion of objects against a static
   % background

%vidObj = VideoReader('/Volumes/Seagate Expansion Drive/h7/2018-07-11/VT1.mpg');
%vidHeight = vidObj.Height; vidWidth = vidObj.Width;


% vidObj.CurrentTime = 600;
% frame = readFrame(vidObj);
% vidObj.CurrentTime = 605;
% frame2= readFrame(vidObj);
% figure; subplot(2,2,1); imshow(frame(:,:,1)); subplot(2,2,2); imshow(frame(:,:,2));subplot(2,2,3); imshow(frame(:,:,3)); subplot(2,2,4); imshow(frame(:,:,:));
% figure; imshow(frame2-frame);
% 
% diffTreshold=140;
% diffFrame=mean((frame2-frame),3)>diffTreshold;
% [rr,cc,vv]=find(diffFrame);







%figure;
%subplot(2,3,1); imagesc(frame(:,:,1)); colormap('bone'); subplot(2,3,2); imagesc(frame(:,:,2)); colormap('bone'); subplot(2,3,3); imagesc(frame(:,:,3)); colormap('bone');
%subplot(2,3,4); temp=frame(:,:,1); hist(double(temp(:)), 0:255);
%subplot(2,3,5); temp=frame(:,:,2); hist(double(temp(:)), 0:255);
%subplot(2,3,6); temp=frame(:,:,3); hist(double(temp(:)), 0:255);


% 2:30 pick up bucket
% 3:00 onto maze
% 3:18 brick jumping
% 3:40 reaches goal

% vidObj.CurrentTime = 0;
% readLimit = 2;
% frames = zeros( 480, 720, round(64746/32)+1 );
% avgFrame =  mean( frame, 3 );
% idx = 1;
% lastFrame = mean( frame, 3 );
% deltaPx = zeros( 1, readLimit );

% problem : want to get median, rather than average frame, but data is too big.
% solution : average every ~ 1s of frames, and take the median of that. (still big, but doable...)
%
% big problem : track events in video
%
% sub solution 1 : attempt to track Andrew motion by detecting total frame to frame delta
% sub solution 2 : attempt to track the brick at the front of the maze by tracking avg luminance for an ROI

lumGradient = zeros( 6, 9, 64746 );

totalLum = zeros(1,64746);


xx=zeros(ceil(vidObj.Duration*vidObj.FrameRate),1);
yy=zeros(ceil(vidObj.Duration*vidObj.FrameRate),1);
vidObj.CurrentTime = 0;
diffThreshold=210;
currFrameIdx=1;
frameBuffer{10}=[];


while hasFrame( vidObj )
    
    frame = readFrame( vidObj );
    frame = mean( frame, 3 );   % make black and white
    frameBufferIdx = mod(currFrameIdx,10)+1; 
    frameBuffer{frameBufferIdx} = frame;
    
    if currFrameIdx > 10
        frameDiff = (frame-frameBuffer{mod(currFrameIdx+9,10)+1})>diffThreshold;
        [rr,cc,vv]=find(frameDiff);
        xx(currFrameIdx)=median(cc);
        yy(currFrameIdx)=median(rr);
        if isnan(xx(currFrameIdx)); xx(currFrameIdx)=xx(currFrameIdx-1); end;
        if isnan(yy(currFrameIdx)); yy(currFrameIdx)=yy(currFrameIdx-1); end;
    else
        xx(currFrameIdx)=0;
        yy(currFrameIdx)=0;        
    end
    
    
    currFrameIdx = currFrameIdx + 1;
    
end


figure; imagesc(frame)
figure; imagesc(frameDiff)
figure; plot(xx,yy)

[xc,xy]=nlxPositionFixer(xx,yy);
figure; plot(xc,xy)

return;


extractedBackground=median(frames,3);

figure; subplot(2,2,1); imagesc(frame); colorbar;
subplot(2,2,3); imagesc(extractedBackground); colorbar;
objs=frame-extractedBackground; 
subplot(2,2,2); imagesc( objs ); colorbar;
objsT=objs; objsT( find( objs < 0 ) )=0;
subplot(2,2,4); imagesc( objsT ); colorbar;

%figure; imagesc(median(frames,3));  %   b & w image

%%

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






%%

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





return;






hold on;
plot( roiLum.start.min, 'k');
plot( roiLum.start.med, 'g');
plot( roiLum.start.max, 'b');
plot( roiLum.start.std + roiLum.start.med, 'r');
axis tight; title('start');


        roiFilter = designfilt( 'lowpassiir',                     ...
                             'FilterOrder',              8  , ...
                             'PassbandFrequency',        1  , ...
                             'PassbandRipple',           0.2, ...
                             'SampleRate',              30);
        smoothedStartBucketLuminance = filtfilt( roiFilter, roiLum.start.med);

        tt=(1:length(roiLum.start.med))/(60*29.97); 
        figure; hold on; plot(tt,roiLum.start.med); plot(tt,smoothedStartBucketLuminance);

[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  smoothedStartBucketLuminance,                              ... % data
                             29.97,                                  ... % sampling frequency
                             'MinPeakHeight',   std(smoothedStartBucketLuminance)*4, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance',  25 ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
plot(peakTimes/60,peakValues, 'o')




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

overallMedLum=median(totalLum);





mazeMask=imread('mazeOnlyMask.png');
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



[labeledMatrix,regionLabels,regionSizes]=findBoundaries(objs,20,10);
figure; imagesc(labeledMatrix); colormap(regionColormap);


figure; for kk=1:length(lumGradient);
    imagesc(lumGradient(:,:,kk)); colorbar; caxis([0 95 ]); drawnow;
end


figure; hold on; for kk=1:6; for ll=1:9; pp=lumGradient(kk,ll,:); plot(pp(:)); end; end; axis tight;



%%

mazeMask=imread('mazeOnlyMask.png');

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









%%

% once the background is subtracted, anything less than zero should become
% zero.

totalAvgFrame=avgFrame/idx;

ratLocationMovie = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);
xxMax=zeros(1,totalFrames);
yyMax=zeros(1,totalFrames);
valMax=zeros(1,totalFrames);
frameIdx=1;
figure;
while hasFrame(vidObj)
   frame = readFrame(vidObj);
   if ( frameIdx < 1000)
    ratLocationMovie(frameIdx).cdata = frame;
   end
   for rgbIdx = 3:3  
     tempFrame=frame(:,:,rgbIdx);
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMax(frameIdx)=xx(1);
     yyMax(frameIdx)=yy(1);
     valMax(frameIdx)=maxVal(1);
     %xyMaxCoords(1,rgbIdx,frameIdx) = xx(1);
     %xyMaxCoords(2,rgbIdx,frameIdx) = yy(1);
     subplot(1,3,2);
     imshow(frame);
     subplot(1,3,3);
     plot(xx(1),yy(1),'r*'); axis([0 720 0 480]); axis ij;
     if frameIdx > 1
        subplot(1,3,1); imagesc(tempFrame-lastTempFrame); colormap(build_NOAA_colorgradient); caxis([-20 20 ]);
     end
     if mod(frameIdx,round((.05*totalFrames))) == 0
        disp([num2str(round(100*frameIdx/totalFrames)) '%'])
     end
   end
   lastTempFrame=tempFrame;
   drawnow;
   frameIdx=frameIdx+1;
end


figure; subplot(1,3,1); imagesc(frame(:,:,1)); colormap('bone'); subplot(1,3,2); imagesc(frame(:,:,2)); colormap('bone'); subplot(1,3,3); imagesc(frame(:,:,3)); colormap('bone'); 


return;







vidObj = VideoReader('/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/2017-11-01_training4/VT1.mpg');
% there's a big event that occurs right around frame 550 in msCam2 that
% screws things up.
vidHeight = vidObj.Height; vidWidth = vidObj.Width; frame=read(vidObj);
%close(vidObj);
minFrameRaw=zeros(480,752);
maxFrameRaw=zeros(480,752);
avgFrameRaw=zeros(480,752);
skewFrameRaw=zeros(480,752);
varFrameRaw=zeros(480,752);
stdFrameRaw=zeros(480,752);
medFrameRaw=zeros(480,752);
madamFrameRaw=zeros(480,752);
kurtFrameRaw=zeros(480,752);

for rowIdx=1:480
    for colIdx=1:752
        minFrameRaw(rowIdx,colIdx) = min(frame(rowIdx,colIdx,1,:));
        maxFrameRaw(rowIdx,colIdx) = max(frame(rowIdx,colIdx,1,:));
        avgFrameRaw(rowIdx,colIdx) = mean(frame(rowIdx,colIdx,1,:));
        skewFrameRaw(rowIdx,colIdx) = skewness(double(frame(rowIdx,colIdx,1,:)));
        varFrameRaw(rowIdx,colIdx) = var(double(frame(rowIdx,colIdx,1,:)));
        stdFrameRaw(rowIdx,colIdx) = std(double(frame(rowIdx,colIdx,1,:)));
        medFrameRaw(rowIdx,colIdx) = median(frame(rowIdx,colIdx,1,:));
        kurtFrameRaw(rowIdx,colIdx) = kurtosis(double(frame(rowIdx,colIdx,1,:)));
        madamFrameRaw(rowIdx,colIdx) = median(abs(double(frame(rowIdx,colIdx,1,:))-median(double(frame(rowIdx,colIdx,1,:)))));
    end
end
rangeFrameRaw=maxFrameRaw-minFrameRaw;


figure;
subplot(3,4,1); imagesc(frame(:,:,1,814)); title('frame 814'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,2); imagesc(minFrameRaw); title('minimum'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,3); imagesc(maxFrameRaw); title('max'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,4); imagesc(avgFrameRaw); title('mean'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,5); imagesc(skewFrameRaw); title('skewness'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,6); imagesc(varFrameRaw); title('var'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,7); imagesc(stdFrameRaw); title('std'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,8); imagesc(medFrameRaw); title('median'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,9); imagesc(madamFrameRaw); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,10); imagesc(kurtFrameRaw); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,11); imagesc(rangeFrameRaw); title('range'); colormap(build_NOAA_colorgradient); colorbar;





























frames = zeros( 480, 720, round(64746/32)+1 );
idx = 1;
lastFrame = mean( frame, 3 );
deltaPx = zeros( 1, readLimit );

while hasFrame( vidObj )
    frame = readFrame( vidObj );
    frame = mean( frame, 3 );   % make black and white
    avgFrame = avgFrame + frame;
    if mod( idx, 32 ) == 0
        % aggregate frames for median bg estimate
        frames( :, :, idx/32 ) = avgFrame/32;
        avgFrame =  mean( frame, 3 );
    end
end






    idx = idx + 1;
    temp = abs( lastFrame - frame );
    tt=temp(:);
    %deltaPx( idx ) = sum( tt( find( tt > 10 ) ) );
