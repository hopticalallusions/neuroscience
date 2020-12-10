%close all; clear all;
% filePath = '/Volumes/AHOWETHESIS/h1/2018-09-07_16-02-21/'; vidObj = VideoReader([ filePath 'VT0.0001.mpg' ]);
% 
% filePath = '/Volumes/AHOWETHESIS/h1/2018-08-27_11-37-31/'; vidObj = VideoReader([ filePath 'VT0.mpg' ]);
% 
% filePath = '/Volumes/AHOWETHESIS/h1/2018-09-08_17-11-31/'; vidObj = VideoReader([ filePath 'VT0.mpg' ]);
% 
% filePath = '/Volumes/AHOWETHESIS/h1/recut-tt21_2018-09-05_13-01-23/'; vidObj = VideoReader([ filePath 'VT0.mpg' ]);
% 
% % THIS ONE REQUIRES CHANGES
% % the green light is the only one available and the video is hella noisy at
% % first and we turn the lights on halfway which jacks everything up.
% filePath = '/Volumes/AGHTHESIS2/rats/h7/2018-08-31/'; vidObj = VideoReader([ filePath 'VT0.mpg' ]);
% 
% 
% filePath = '/Volumes/AGHTHESIS2/rats/h1/2018-09-09/'; vidObj = VideoReader([ filePath 'VT0.mpg' ]);


%filePath = '/Volumes/AHOWETHESIS/h7/2018-08-06_14-51-31/'; vidObj = VideoReader([ filePath 'VT0.mpg' ]);


%filePath = '/Volumes/AHOWETHESIS/h7/2018-07-11_day1_bananas_incomplete/'; vidObj = VideoReader([ filePath 'VT1.mpg' ]);



%filePath = '/Volumes/AGHTHESIS2/rats/h7/2018-08-08/';  vidObj = VideoReader([ filePath 'VT0.mpg' ]);

filePath = '/Volumes/AGHTHESIS2/rats/h7/2018-08-08/';  vidObj = VideoReader([ filePath 'VT0.0001.mpg' ]);

% THINGS TO DO TO IMPROVE THIS SCRIPT
%
% 1. clean up the code; most useful is the xxMedianMaxG type data
% 2. convert loaders to nanmean and convert broken lights to NaN
% 3. double check the direction thing
% 4. when one or both lights disappear, one could concieveably have an ever
% growing circle of uncertainty about where the rat is, because he's
% unlikely to move really far from where he just was in an instant
% 5. maybe use ratio of 95% percentile values vs 75% values as a
% "certainty" metric. When the lights disappear, this should be low.

figure;

plotFrames=true;

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
ratLocationMovie = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);
xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);
xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);
frameIdx=1;  plotFrames = 0;
valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);
ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);
vidObj.CurrentTime = 0; plotFrames = 1;
while hasFrame(vidObj)
   frame = readFrame(vidObj);

   %      tempFrame=frame(:,:,1);
%      ambientLightR(frameIdx) = median(tempFrame(:));
%      [maxVal, maxIdx ] = max(tempFrame(:));
% %     just use the first thing returned
%      [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
%      valMaxR(frameIdx) = maxVal;
%      xxMaxR(frameIdx)=xx(1);
%      yyMaxR(frameIdx)=yy(1);
%      valMaxR(frameIdx)=maxVal(1);
%      
%      tempFrame=frame(:,:,2);
%      ambientLightG(frameIdx) = median(tempFrame(:));
%      tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3))); 
%      tred=tempFrame;
%      [maxVal, maxIdx ] = max(tempFrame(:));
% %     just use the first thing returned
%      [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
%      valMaxG(frameIdx) = maxVal;
%      xxMaxG(frameIdx)=xx(1);
%      yyMaxG(frameIdx)=yy(1);
%      valMaxG(frameIdx)=maxVal(1);
     
     
     tempFrame=frame(:,:,1);
     tempFrame=tempFrame - uint8(round(mean(frame(:,:,[2 3]),3)));
     tred=tempFrame;
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
%     just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
 %    just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
     if plotFrames && frameIdx < 200
         subplot(3,3,1); imagesc(frame(:,:,1)); title('red')
         subplot(3,3,2); imagesc(frame(:,:,2)); title('green')
         subplot(3,3,3); imagesc(frame(:,:,3)); title('blue')
         subplot(3,3,4); imagesc(tred);
         subplot(3,3,5); imagesc(tempFrame);
         subplot(3,3,6); imagesc(mean(frame(:,:,:),3)); title('luminance')
         subplot(3,3,7); scatter( [ xxMedianMaxR(frameIdx)  ], [ yyMedianMaxR(frameIdx) ] ); xlim([ 0 720 ]); ylim([0 480]);
         subplot(3,3,8); scatter( [ xxMedianMaxG(frameIdx) ], [ yyMedianMaxG(frameIdx) ] ); xlim([ 0 720 ]); ylim([0 480]);
         subplot(3,3,9); plot( [ xxMedianMaxG ], [ yyMedianMaxG ] )
         drawnow
     end
%       
     if mod(frameIdx,round((.05*totalFrames))) == 0
        disp([num2str(round(100*frameIdx/totalFrames)) '%'])
     end
   frameIdx=frameIdx+1;
end

xcMaxG = xxMaxG;
ycMaxG = yyMaxG;
for ii=2:length(xxMaxR)
    if valMaxG(ii) < 25
        xcMaxG(ii) = xcMaxG(ii-1);
        ycMaxG(ii) = ycMaxG(ii-1);
    end
end
figure; plot( (1:length(xxMaxR))/29.97, xxMaxG  ); hold on; plot( (1:length(xxMaxR))/29.97, xcMaxG );
plot( (1:length(xxMedianMaxG))/29.97, xxMedianMaxG );
plot( (1:length(xxMedianMaxG))/29.97, nlxPositionFixer(xxMedianMaxG) );

xGpos=nlxPositionFixer(xxMedianMaxG); yGpos=nlxPositionFixer(yyMedianMaxG);
figure; plot(xGpos,yGpos);
xRpos=nlxPositionFixer(xxMedianMaxR); yRpos=nlxPositionFixer(yyMedianMaxR);
hold on; plot(xRpos,yRpos);


figure;  plot(xGpos); hold on; plot(yGpos);



% position.valMaxG = valMaxG;
% position.valMaxR = valMaxR;
% 
% position.xxMaxG = xxMaxG;
% position.yyMaxG = yyMaxG;
% position.xxMaxR = xxMaxR;
% position.yyMaxR = yyMaxR;

position.xxMedianMaxG = xxMedianMaxG;
position.yyMedianMaxG = yyMedianMaxG;
position.xxMedianMaxR = xxMedianMaxR;
position.yyMedianMaxR = yyMedianMaxR;

position.xxMedianMaxG = xxMedianMaxG;
position.xxMedianMaxG = xxMedianMaxG;

position.xRpos=xRpos;
position.yRpos=yRpos;
position.xGpos=xGpos;
position.yGpos=yGpos;

position.angle = atan2(nlxPositionFixer(yGpos)-nlxPositionFixer(yRpos),nlxPositionFixer(xGpos)-nlxPositionFixer(xRpos));


save([ filePath 'position3.mat' ],'position')



return;




figure; plot( (1:length(xxMaxR))/29.97, mean([xxMaxR; xxMaxG ])); hold on; 

figure; plot( (1:length(xxMaxR))/29.97, mean([xxMaxR xxMaxG ],2)); hold on; plot( (1:length(xxMaxR))/29.97, valMaxG );

figure; histogram( xxMaxG(2:length(xxMaxR))-xxMaxG(1:length(xxMaxR)-1), 100 )

xxcMaxG = xxMaxG;
yycMaxG = yyMaxG;
flag=0;
for ii=2:length(xxMaxR)
    if xxcMaxG(ii) - xxcMaxG(ii-1) > 55
        flag = 1;
    elseif xxcMaxG(ii) - xxcMaxG(ii-1) < -55
        flag = 0;
    end
    if flag == 1
        xxcMaxG(ii) = xxcMaxG(ii-1);
        yycMaxG(ii) = yycMaxG(ii-1);
    end
end
figure; plot( (1:length(xxMaxR))/29.97, xxMaxG  ); hold on; plot( (1:length(xxMaxR))/29.97, xxcMaxG );


