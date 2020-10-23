%%

close all; clear all;

filepath='/Volumes/AGHTHESIS2/rats/h7/2018-08-01c/';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


compTime = (cscTimestamps(1:1000:end)-cscTimestamps(1))/1e6;
aa=diff(compTime);
aa(aa>2)

compTime(find((aa>2))+1)


plot(compTime(2:end),aa)
plot(compTime(2:end),cumsum(aa))

    1860.2
    2333.1
    3039.3
    3228.5
    3272.5



vidObj = VideoReader([ filepath 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0.mat' ],'position')






% 


vidObj = VideoReader([ filepath 'VT0.0002.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0002.mat' ],'position')



vidObj = VideoReader([ filepath 'VT0.0003.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0003.mat' ],'position')



load([ filepath 'position_VT0.mat' ]);
position1=position;
load([ filepath 'position_VT0_0002.mat' ]);
position3=position;
load([ filepath 'position_VT0_0003.mat' ]);
position4=position;
position=[];
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position3.xGpos; position3.xRpos ]) ];
ypos = [ ypos mean([ position3.yGpos; position3.yRpos ]) ];
xpos = [ xpos mean([ position4.xGpos; position4.xRpos ]) ];
ypos = [ ypos mean([ position4.yGpos; position4.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( filepath );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
    disp([ 'removing ' num2str( (length(xytimestamps) - length(xpos))/29.97 ) ' seconds of timestamp data']);
elseif length(xytimestamps) < length(xpos)
    warning([ 'interpolating ' num2str( (length(xpos ) - length(xytimestamps))/29.97 ) ' seconds of timestamp data']);
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
%
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


position.valMaxG = [ position1.valMaxG position3.valMaxG position4.valMaxG ];
position.valMaxR = [ position1.valMaxR position3.valMaxR position4.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position3.xxMaxG position4.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position3.yyMaxG position4.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position3.xxMaxR position4.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position3.yyMaxR position4.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position3.xxMedianMaxG position4.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position3.yyMedianMaxG position4.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position3.xxMedianMaxR position4.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position3.yyMedianMaxR position4.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position3.xxMedianMaxG position4.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position3.xxMedianMaxG position4.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position3.xRpos position4.xRpos ];
position.yRpos = [ position1.yRpos position3.yRpos position4.yRpos ];
position.xGpos = [ position1.xGpos position3.xGpos position4.xGpos ];
position.yGpos = [ position1.yGpos position3.yGpos position4.yGpos ];


figure; plot(xpos, ypos)

save([ filepath 'position.mat' ],'position')
return;























close all; clear all;
filepath = [ '/Volumes/AGHTHESIS2/rats/h7/2018-08-03b/' ];

% this folder has a raw file in it.
% 1:12:29   VT0
% the stats on this one are weird looking, but it is OK. there is a raw
% file that occurs after the first "real" recording session.
% For now we can just ignore that data.

vidObj = VideoReader([ filepath 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

frame = readFrame(vidObj);

%vidObj.CurrentTime = 7*60+52;
vidObj.CurrentTime = 0;
while hasFrame(vidObj)
     frame = readFrame(vidObj);
     tempFrame=frame(:,:,1);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

position.angle = atan2( position.yGpos-position.yRpos, position.xGpos-position.xRpos );

save([ filepath 'position.mat' ],'position')

figure; plot(xRpos,yRpos);

return;




close all; clear all;
filepath = [ '/Volumes/AGHTHESIS2/rats/h7/2018-07-11/' ];

% this folder has a raw file in it.
% 1:12:29   VT0
% the stats on this one are weird looking, but it is OK. there is a raw
% file that occurs after the first "real" recording session.
% For now we can just ignore that data.


vidObj = VideoReader([ filepath 'VT1.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

frame = readFrame(vidObj);
allFrame = zeros(size(frame)); frames = 1;
vidObj.CurrentTime = 0;
while hasFrame(vidObj)
   frame = readFrame(vidObj);
   allFrame = double(frame) + allFrame;
   frames = frames + 1;
end
   figure; imagesc(mean(allFrame./frames,3))

avgFrame=mean(allFrame./frames,3);



vidObj.CurrentTime = 7*60+55;  % test with this

% extract with this :
yesPlot = false;
vidObj.CurrentTime = 0;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
     if yesPlot
         subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
         subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
         subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
         subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
         subplot(2,3,5); imagesc(tempFrameR);
         subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] ); ylim([0 480]); xlim([0 720]);
         drawnow
     end
     
     if mod(frameIdx,round((.05*totalFrames))) == 0
        disp([num2str(round(100*frameIdx/totalFrames)) '%'])
     end
   frameIdx=frameIdx+1;
end


tx=xxMedianMaxG; ty=yyMedianMaxG;
tx( (tx<177)&(ty>333) ) = 0;
ty( (tx<177)&(ty>333) ) = 0;
tx( (tx<33) ) = 0;
ty( (tx<33) ) = 0;
scatter( tx, ty, 'k', 'filled' ); alpha(.1)



txg=xxMaxG; tyg=yyMaxG;
txg( (txg<177)&(tyg>333) ) = 0;
tyg( (txg<177)&(tyg>333) ) = 0;
txg( (txg<33) ) = 0;
tyg( (txg<33) ) = 0;
xGpos=nlxPositionFixer(txg); yGpos=nlxPositionFixer(tyg);
figure; plot(xGpos,yGpos);
txr=xxMaxR; tyr=yyMaxR;
txr( (txr<190)&(tyr>230) ) = 0;
tyr( (txr<190)&(tyr>230) ) = 0;
txr( (txr<100) ) = 0;
tyr( (txr<100) ) = 0;
xRpos=nlxPositionFixer(txr); yRpos=nlxPositionFixer(tyr);
hold on; plot( xRpos, yRpos );


telData.maxmethxg = txg;
telData.maxmethyg = tyg;
telData.maxmethxr = txr;
telData.maxmethyr = tyr;





figure; scatter( xxMaxR, yyMaxR, 'k', 'filled' ); alpha(.1)


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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

position.xxMedianMaxG = xxMedianMaxG;
position.yyMedianMaxG = yyMedianMaxG;
position.xxMedianMaxR = xxMedianMaxR;
position.yyMedianMaxR = yyMedianMaxR;

position.xxMedianMaxG = xxMedianMaxG;
position.xxMedianMaxG = xxMedianMaxG;

position.xRpos=txr; % xRpos;
position.yRpos=tyr; % yRpos;
position.xGpos=txg; % xGpos;
position.yGpos=tyg; % yGpos;

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

position.angle = atan2( position.yGpos-position.yRpos, position.xGpos-position.xRpos );


save([ filepath 'position.mat' ],'position')












% extract with this :
yesPlot = false;
vidObj.CurrentTime = 0;

% % test with this
% vidObj.CurrentTime = 7*60+55;  
% yesPlot = true;

totalFrames = ceil(vidObj.Duration*vidObj.FrameRate);

ratBodX  = zeros( 1, totalFrames );
ratBodY  = zeros( 1, totalFrames );
ratLumX  = zeros( 1, totalFrames );
ratLumY  = zeros( 1, totalFrames );
ratRX    = zeros( 1, totalFrames );
ratRY    = zeros( 1, totalFrames );
ratGX    = zeros( 1, totalFrames );
ratGY    = zeros( 1, totalFrames );
ratBX    = zeros( 1, totalFrames );
ratBY    = zeros( 1, totalFrames );
frameIdx = 1;

frameBlock = uint8(zeros( 480, 720, 3, 10 ));


while hasFrame(vidObj)    
    frameBlock( :, :, :, mod( frameIdx, 9 )+1 ) = readFrame(vidObj);
    
    newFrame = frameBlock( :, :, :, mod( frameIdx, 9 )+1 );
    oldFrame = frameBlock( :, :, :, mod( frameIdx+1, 9 )+1 );
    
    diffFrame =  newFrame - oldFrame;
    diffMat = int16(newFrame) - int16(oldFrame);
    
    luminance = mean( diffFrame, 3);
    [rowsL,colsL,vals] = find( luminance>200 );
    luminanceR = mean( diffFrame(:,:,1), 3);
    [rowsR,colsR,valsR] = find( luminanceR>200 );
    luminanceg = mean( diffFrame(:,:,2), 3);
    [rowsg,colsg,valsg] = find( luminanceg>200 );
    luminanceB = mean( diffFrame(:,:,3), 3);
    [rowsB,colsB,valsB] = find( luminanceB>200 );
    luminanceBod = mean( diffFrame, 3);
    [rowsBod,colsBod,valsBod] = find( (luminanceBod<200).*(luminanceBod>50) );
%
     ratBodX(frameIdx) =  median(colsBod)   ;
     ratBodY(frameIdx) =  median(rowsBod)   ;
     ratLumX(frameIdx) =  median(colsL)   ;
     ratLumY(frameIdx) =  median(rowsL)   ;
     ratRX(frameIdx)   =  median(colsR)  ;
     ratRY(frameIdx)   =  median(rowsR)  ;
     ratGX(frameIdx)   =  median(colsg)  ;
     ratGY(frameIdx)   =  median(rowsg)  ;
     ratBX(frameIdx)   =  median(colsB)  ;
     ratBY(frameIdx)   =  median(rowsB)  ;
   
    %subplot(1,3,3);
%     subplot(1,3,1); image(diffFrame(:,:,1));
%     subplot(1,3,2); image(diffFrame(:,:,2));
%     subplot(1,3,3); hold off; image(newFrame); hold on; 
%     scatter( median(cols), median(rows), 'co', 'filled');
%     scatter( median(colsR), median(rowsR), 'r^', 'filled');
%     scatter( median(colsg), median(rowsg), 'gV', 'filled');
%     scatter( median(colsB), median(rowsB), 'b*', 'filled');
%     drawnow;
%    subplot(1,3,2); image(diffFrame); drawnow;
     if mod(frameIdx,round((.05*totalFrames))) == 0
        disp([num2str(round(100*frameIdx/totalFrames)) '%'])
     end
     frameIdx=frameIdx+1;
end


figure;
scatter( ratBodX, ratBodY, 'y', 'filled' ); alpha(.1); hold on;
scatter( ratLumX, ratLumY, 'k', 'filled' ); alpha(.1);
scatter( ratRX, ratRY, 'r', 'filled' ); alpha(.1);
scatter( ratGX, ratGY, 'g', 'filled' ); alpha(.1);
scatter( ratBX, ratBY, 'b', 'filled' ); alpha(.1);




figure;
scatter( ratRX, ratRY, 'r', 'filled' ); alpha(.1); hold on;
scatter( ratGX, ratGY, 'g', 'filled' ); alpha(.1);
scatter( ratBodX, ratBodY, 'y', 'filled' ); alpha(.1); hold on;
scatter( ratLumX, ratLumY, 'k', 'filled' ); alpha(.1);

tx=ratRX; ty=ratRY;
tx( (tx<450)&(ty>400) ) = 0;
ty( (tx<450)&(ty>400) ) = 0;
tx( (tx<200)&(ty>200) ) = 0;
ty( (tx<200)&(ty>200) ) = 0;
tx( (tx<450)&(ty<40) ) = 0;
ty( (tx<450)&(ty<40) ) = 0;
tx(isnan(tx)) = 0;
ty(isnan(ty)) = 0;
txr=nlxPositionFixer(tx);
tyr=nlxPositionFixer(ty);
figure;
scatter( tx, ty, 'k', 'filled' ); alpha(.1); hold on;
scatter( nlxPositionFixer(tx), nlxPositionFixer(ty), 'filled' ); alpha(.1)
plot( nlxPositionFixer(tx), nlxPositionFixer(ty) ); 
figure; plot(nlxPositionFixer(tx)); hold on;  plot(nlxPositionFixer(ty))


tx=ratGX; ty=ratGY;
tx( (tx<450)&(ty>400) ) = 0;
ty( (tx<450)&(ty>400) ) = 0;
tx( (tx<200)&(ty>200) ) = 0;
ty( (tx<200)&(ty>200) ) = 0;
tx( (tx<450)&(ty<40) ) = 0;
ty( (tx<450)&(ty<40) ) = 0;
tx(isnan(tx)) = 0;
ty(isnan(ty)) = 0;
txg=nlxPositionFixer(tx);
tyg=nlxPositionFixer(ty);


tx=ratLumX; ty=ratLumY;
tx( (tx<450)&(ty>400) ) = 0;
ty( (tx<450)&(ty>400) ) = 0;
tx( (tx<200)&(ty>200) ) = 0;
ty( (tx<200)&(ty>200) ) = 0;
tx( (tx<450)&(ty<40) ) = 0;
ty( (tx<450)&(ty<40) ) = 0;
tx(isnan(tx)) = 0;
ty(isnan(ty)) = 0;
txl=nlxPositionFixer(tx);
tyl=nlxPositionFixer(ty);




figure; hold on; plot(txr); plot(txg); plot(txl); plot(nlxPositionFixer(position.xRpos)); plot(nlxPositionFixer(position.xGpos))

position.xRpos=txr; % xRpos;
position.yRpos=tyr; % yRpos;
position.xGpos=txg; % xGpos;
position.yGpos=tyg; % yGpos;

xx=(mean([ smoothWithGaussian(txr,30); smoothWithGaussian(txg,30); smoothWithGaussian(txl,30);  smoothWithGaussian(nlxPositionFixer(position.xRpos),30); smoothWithGaussian(nlxPositionFixer(position.xGpos),30) ]));
yy=(mean([ smoothWithGaussian(tyr,30); smoothWithGaussian(tyg,30); smoothWithGaussian(tyl,30);  smoothWithGaussian(nlxPositionFixer(position.yRpos),30); smoothWithGaussian(nlxPositionFixer(position.yGpos),30) ]));

figure; plot(xx); hold on; plot(yy)


position.superX = xx;
position.superY = yy;




figure; plot(xx(350:end),xx(1:end-349))





tx=ratRX; ty=ratRY;
tx( (tx<450)&(ty>400) ) = 0;
ty( (tx<450)&(ty>400) ) = 0;









figure; plot(ratRX); hold on; plot(tx); plot(xcm)


xpositions = tx;

    correctedXPosition = xpositions;
    smoothFactor = 3;
    xcm=xpositions;
    for ii = (smoothFactor+1):length(xpositions)-(smoothFactor+1)
        xcm(ii) = nanmedian(xcm(ii-smoothFactor:ii+smoothFactor));
    end
    % zero jump smoothing
    xz=xcm;
    for ii=2:length(xpositions)
        if xz(ii) < 5
            if ii > 16
                lookback = 15;
            else
                lookback = ii-1;
            end
            xz(ii) = nanmedian(xz(ii-lookback:ii-1));
        end
    end
    % re-smooth median
    smoothFactor = 8;
    correctedXPosition=xz;
    for ii = (smoothFactor+1):length(correctedXPosition)-(smoothFactor+1)
        correctedXPosition(ii) = nanmedian(correctedXPosition(ii-smoothFactor:ii+smoothFactor));
    end






figure;
plot( ratBodX, ratBodY ); hold on;
plot( ratLumX, ratLumY ); 
plot( ratRX, ratRY ); 
plot( ratGX, ratGY  ); 
plot( ratBX, ratBY ); 



figure;
plot( nlxPositionFixer(ratBodX), nlxPositionFixer(ratBodY),  'k'  ); hold on;
plot( nlxPositionFixer(ratLumX), nlxPositionFixer(ratLumY),  ); 
plot( nlxPositionFixer(ratRX), nlxPositionFixer(ratRY),  ); 
plot( nlxPositionFixer(ratGX), nlxPositionFixer(ratGY),   ); 
plot( nlxPositionFixer(ratBX), nlxPositionFixer(ratBY) ); 



figure; plot(ratGX)




figure; imagesc(diffMat(:,:,1))

figure; histogram(diffMat(:,:,1))



     tempFrame=frame(:,:,1);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame(find(tempFrame>250))=1;  % this is to eliminate parts of the image that are saturated in favor of the "halo"
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
     if yesPlot
         subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
         subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
         subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
         subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
         subplot(2,3,5); imagesc(tempFrameR);
         subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] ); ylim([0 480]); xlim([0 720]);
         drawnow
     end
     
     if mod(frameIdx,round((.05*totalFrames))) == 0
        disp([num2str(round(100*frameIdx/totalFrames)) '%'])
     end
   frameIdx=frameIdx+1;
end


















figure; plot(xRpos,yRpos);


return;



%%

close all; clear all;

filepath='/Volumes/AGHTHESIS2/rats/h7/2018-08-28/';

vidObj = VideoReader([ filepath 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0.mat' ],'position')






% 


vidObj = VideoReader([ filepath 'VT0.0002.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0002.mat' ],'position')



vidObj = VideoReader([ filepath 'VT0.0003.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0003.mat' ],'position')



load([ filepath 'position_VT0.mat' ]);
position1=position;
load([ filepath 'position_VT0_0002.mat' ]);
position3=position;
load([ filepath 'position_VT0_0003.mat' ]);
position4=position;
position=[];
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position3.xGpos; position3.xRpos ]) ];
ypos = [ ypos mean([ position3.yGpos; position3.yRpos ]) ];
xpos = [ xpos mean([ position4.xGpos; position4.xRpos ]) ];
ypos = [ ypos mean([ position4.yGpos; position4.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( filepath );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
    disp([ 'removing ' num2str( (length(xytimestamps) - length(xpos))/29.97 ) ' seconds of timestamp data']);
elseif length(xytimestamps) < length(xpos)
    warning([ 'interpolating ' num2str( (length(xpos ) - length(xytimestamps))/29.97 ) ' seconds of timestamp data']);
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
%
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


position.valMaxG = [ position1.valMaxG position3.valMaxG position4.valMaxG ];
position.valMaxR = [ position1.valMaxR position3.valMaxR position4.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position3.xxMaxG position4.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position3.yyMaxG position4.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position3.xxMaxR position4.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position3.yyMaxR position4.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position3.xxMedianMaxG position4.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position3.yyMedianMaxG position4.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position3.xxMedianMaxR position4.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position3.yyMedianMaxR position4.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position3.xxMedianMaxG position4.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position3.xxMedianMaxG position4.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position3.xRpos position4.xRpos ];
position.yRpos = [ position1.yRpos position3.yRpos position4.yRpos ];
position.xGpos = [ position1.xGpos position3.xGpos position4.xGpos ];
position.yGpos = [ position1.yGpos position3.yGpos position4.yGpos ];


figure; plot(xpos, ypos)

save([ filepath 'position.mat' ],'position')
return;




%%


close all; clear all;

filepath='/Volumes/AGHTHESIS2/rats/h7/2018-07-20/';


vidObj = VideoReader([ filepath 'VT0.0001.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0.mat' ],'position')


clear all;
filepath='/Volumes/AGHTHESIS2/rats/h7/2018-07-20/';

vidObj = VideoReader([ filepath 'VT0.0001.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0001.mat' ],'position')



% 
load([ filepath 'position_VT0.mat' ]);
position1=position;
position=[];
load([ filepath 'position_VT0_0001.mat' ]);
position2=position;
position=[];
%
disp( [ 'position1 length : ' num2str(1/60*length(position1.xGpos)/29.97) ]);
disp( [ 'position2 length : ' num2str(1/60*length(position2.xGpos)/29.97) ]);
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position2.xGpos; position2.xRpos ]) ];
ypos = [ ypos mean([ position2.yGpos; position2.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( filepath );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
    disp([ 'removing ' num2str( (length(xytimestamps) - length(xpos))/29.97 ) ' seconds of timestamp data']);
elseif length(xytimestamps) < length(xpos)
    warning([ 'interpolating ' num2str( (length(xpos ) - length(xytimestamps))/29.97 ) ' seconds of timestamp data']);
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
%
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


position.valMaxG = [ position1.valMaxG position2.valMaxG ];
position.valMaxR = [ position1.valMaxR position2.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position2.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position2.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position2.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position2.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position2.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position2.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position2.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position2.xRpos ];
position.yRpos = [ position1.yRpos position2.yRpos ];
position.xGpos = [ position1.xGpos position2.xGpos ];
position.yGpos = [ position1.yGpos position2.yGpos ];


figure; plot(xpos, ypos)

save([ filepath 'position.mat' ],'position')
return;



%%

close all; clear all;

filepath='/Volumes/AGHTHESIS2/rats/h1/2018-09-07/';


vidObj = VideoReader([ filepath 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0.mat' ],'position')




% 
% vidObj = VideoReader([ filepath 'VT0.0001.mpg' ]);
% 
% vidHeight = vidObj.Height;
% vidWidth = vidObj.Width;
% 
% xyMaxCoords=zeros(2,3,1);
% totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);
% 
% xxMaxR=zeros(1,totalFrames);
% yyMaxR=zeros(1,totalFrames);
% valMaxR=zeros(1,totalFrames);
% 
% xxMaxG=zeros(1,totalFrames);
% yyMaxG=zeros(1,totalFrames);
% valMaxG=zeros(1,totalFrames);
% 
% frameIdx=1;
% 
% valMaxR=zeros(1,totalFrames);
% valMaxG=zeros(1,totalFrames);
% 
% ambientLightG = zeros(1,totalFrames);
% ambientLightR = zeros(1,totalFrames);
% 
% %vidObj.CurrentTime = 17*60+43;
% while hasFrame(vidObj)
% %while vidObj.CurrentTime > 8*60
%    frame = readFrame(vidObj);
% %    if ( frameIdx < 1000)
% %     ratLocationMovie(frameIdx).cdata = frame;
% %    end
%      tempFrame=frame(:,:,1);
%      ambientLightR(frameIdx) = median(tempFrame(:));
%      tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
%      [maxVal, maxIdx ] = max(tempFrame(:));
%      % just use the first thing returned
%      [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
%      valMaxR(frameIdx) = maxVal;
%      xxMaxR(frameIdx)=xx(1);
%      yyMaxR(frameIdx)=yy(1);
%      valMaxR(frameIdx)=maxVal(1);
%      %
%      tempFrame=frame(:,:,2);
%      ambientLightG(frameIdx) = median(tempFrame(:));
%      tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
%      [maxVal, maxIdx ] = max(tempFrame(:));
%      % just use the first thing returned
%      [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
%      valMaxG(frameIdx) = maxVal;
%      xxMaxG(frameIdx)=xx(1);
%      yyMaxG(frameIdx)=yy(1);
%      valMaxG(frameIdx)=maxVal(1);
%      %
%      %
%      tempFrame=frame(:,:,1);
%      tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
%      [maxVal, maxIdx ] = max(tempFrame(:)>20);
%      % just use the first thing returned
%      [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
%      xxMedianMaxR(frameIdx)=median(xx);
%      yyMedianMaxR(frameIdx)=median(yy);
%      tempFrameR = tempFrame;
%      %
%      tempFrame=frame(:,:,2);
%      tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
%      [maxVal, maxIdx ] = max(tempFrame(:)>20);
%      % just use the first thing returned
%      [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
%      xxMedianMaxG(frameIdx)=median(xx);
%      yyMedianMaxG(frameIdx)=median(yy);
%      
% %      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
% %      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
% %      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
% %      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
% %      subplot(2,3,5); imagesc(tempFrameR);
% %      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
% %      drawnow
%      
%      if mod(frameIdx,round((.05*totalFrames))) == 0
%         disp([num2str(round(100*frameIdx/totalFrames)) '%'])
%      end
%    frameIdx=frameIdx+1;
% end
% 
% xcMaxG = xxMaxG;
% ycMaxG = yyMaxG;
% for ii=2:length(xxMaxR)
%     if valMaxG(ii) < 25
%         xcMaxG(ii) = xcMaxG(ii-1);
%         ycMaxG(ii) = ycMaxG(ii-1);
%     end
% end
% figure; plot( (1:length(xxMaxR))/29.97, xxMaxG  ); hold on; plot( (1:length(xxMaxR))/29.97, xcMaxG );
% plot( (1:length(xxMedianMaxG))/29.97, xxMedianMaxG );
% plot( (1:length(xxMedianMaxG))/29.97, nlxPositionFixer(xxMedianMaxG) );
% 
% xGpos=nlxPositionFixer(xxMedianMaxG); yGpos=nlxPositionFixer(yyMedianMaxG);
% figure; plot(xGpos,yGpos);
% xRpos=nlxPositionFixer(xxMedianMaxR); yRpos=nlxPositionFixer(yyMedianMaxR);
% hold on; plot(xRpos,yRpos);
% 
% figure; hold on; plot(xGpos); plot(yGpos);
% 
% figure; plot(ambientLightG); hold on; plot(ambientLightR);
% 
% figure; plot(valMaxG); hold on; plot(valMaxR);
% figure; histogram(valMaxG); hold on; histogram(valMaxR);
% 
% position.valMaxG = valMaxG;
% position.valMaxR = valMaxR;
% 
% position.xxMaxG = xxMaxG;
% position.yyMaxG = yyMaxG;
% position.xxMaxR = xxMaxR;
% position.yyMaxR = yyMaxR;
% 
% position.xxMedianMaxG = xxMedianMaxG;
% position.yyMedianMaxG = yyMedianMaxG;
% position.xxMedianMaxR = xxMedianMaxR;
% position.yyMedianMaxR = yyMedianMaxR;
% 
% position.xxMedianMaxG = xxMedianMaxG;
% position.xxMedianMaxG = xxMedianMaxG;
% 
% position.xRpos=xRpos;
% position.yRpos=yRpos;
% position.xGpos=xGpos;
% position.yGpos=yGpos;
% 
% position.ambientLightR=ambientLightR;
% position.ambientLightG=ambientLightG;
% 
% save([ filepath 'position_VT0_0001.mat' ],'position')



% 
load([ filepath 'position_VT0.mat' ]);
position1=position;
load([ filepath 'position_VT0_0001.mat' ]);
position2=position;
position=[];
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position2.xGpos; position2.xRpos ]) ];
ypos = [ ypos mean([ position2.yGpos; position2.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( filepath );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
    disp([ 'removing ' num2str( (length(xytimestamps) - length(xpos))/29.97 ) ' seconds of timestamp data']);
elseif length(xytimestamps) < length(xpos)
    warning([ 'interpolating ' num2str( (length(xpos ) - length(xytimestamps))/29.97 ) ' seconds of timestamp data']);
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
%
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


position.valMaxG = [ position1.valMaxG position2.valMaxG ];
position.valMaxR = [ position1.valMaxR position2.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position2.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position2.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position2.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position2.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position2.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position2.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position2.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position2.xRpos ];
position.yRpos = [ position1.yRpos position2.yRpos ];
position.xGpos = [ position1.xGpos position2.xGpos ];
position.yGpos = [ position1.yGpos position2.yGpos ];


figure; plot(xpos, ypos)

save([ filepath 'position.mat' ],'position')
return;






%%
 
close all; clear all;
filepath = [ '/Volumes/AGHTHESIS2/rats/h7/2018-08-10/' ];

% this folder has a raw file in it.
% 1:12:29   VT0
% the stats on this one are weird looking, but it is OK. there is a raw
% file that occurs after the first "real" recording session.
% For now we can just ignore that data.


vidObj = VideoReader([ filepath 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0.mat' ],'position')





close all; clear all;
filepath = [ '/Volumes/AGHTHESIS2/rats/h7/2018-08-10/' ];

vidObj = VideoReader([ filepath 'VT0.0001.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0001.mat' ],'position')



% 
load([ filepath 'position_VT0.mat' ]);
position1=position;
position=[];
load([ filepath 'position_VT0_0001.mat' ]);
position2=position;
position=[];
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position2.xGpos; position2.xRpos ]) ];
ypos = [ ypos mean([ position2.yGpos; position2.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( filepath );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
    disp([ 'removing ' num2str( (length(xytimestamps) - length(xpos))/29.97 ) ' seconds of timestamp data']);
elseif length(xytimestamps) < length(xpos)
    warning([ 'interpolating ' num2str( (length(xpos ) - length(xytimestamps))/29.97 ) ' seconds of timestamp data']);
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
%
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC10.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


position.valMaxG = [ position1.valMaxG position2.valMaxG ];
position.valMaxR = [ position1.valMaxR position2.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position2.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position2.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position2.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position2.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position2.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position2.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position2.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position2.xRpos ];
position.yRpos = [ position1.yRpos position2.yRpos ];
position.xGpos = [ position1.xGpos position2.xGpos ];
position.yGpos = [ position1.yGpos position2.yGpos ];

position.ambientLightR = [ position1.ambientLightR position2.ambientLightR ];
position.ambientLightG = [ position1.ambientLightG position2.ambientLightG ];


save([ filepath 'position.mat' ],'position')


% load([ '~/Desktop/' 'h7_2018-08-10_telemetry.dat' ], '-mat' );
% filepath='/Volumes/AGHTHESIS2/rats//h7/2018-08-10';
% [ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
% disp([ 'start offset : ' num2str( (cscTimestamps(1)-telemetry.xytimestamps(1))/1e6 ) ' s' ] )
% disp([ 'end   offset : ' num2str( (cscTimestamps(end)-telemetry.xytimestamps(end))/1e6 ) ' s' ] )
% disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
% disp([ 'telem elapsd : ' num2str( telemetry.xytimestampSeconds(end)/60 ) ' min' ] )
% % TODO -- this one's fucked.

return;




%%

close all; clear all;
filepath = [ '/Volumes/AGHTHESIS2/rats/h7/2018-08-08/' ];


vidObj = VideoReader([ filepath 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0.mat' ],'position')





vidObj = VideoReader([ filepath 'VT0.0001.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ filepath 'position_VT0_0001.mat' ],'position')



% 
load([ filepath 'position_VT0.mat' ]);
position1=position;
load([ filepath 'position_VT0_0001.mat' ]);
position2=position;
position=[];
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position2.xGpos; position2.xRpos ]) ];
ypos = [ ypos mean([ position2.yGpos; position2.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( filepath );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
elseif length(xytimestamps) < length(xpos)
    warning('WTF!?')
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
%
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC10.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );

% debugging introduced a weird error here.
% 
% csc  elapsed : 124.0741 min
% 
% % 0:10:53  %  10*60+53  % VT0
% % 1:51:17  %  3600+51*60+17  % VT0.0001
% % 113 second gap
% (113 + 10*60+53  + 3600+51*60+17)/60
% 124 minutes <-- so this should be OK, but it is not.
% 200090/29.97






position.valMaxG = [ position1.valMaxG position2.valMaxG ];
position.valMaxR = [ position1.valMaxR position2.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position2.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position2.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position2.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position2.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position2.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position2.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position2.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position2.xRpos ];
position.yRpos = [ position1.yRpos position2.yRpos ];
position.xGpos = [ position1.xGpos position2.xGpos ];
position.yGpos = [ position1.yGpos position2.yGpos ];

position.ambientLightR = [ position1.ambientLightR position2.ambientLightR ];
position.ambientLightG = [ position1.ambientLightG position2.ambientLightG ];


save([ filepath 'position.mat' ],'position')







%%



return;











close all; clear all;
% THIS ONE REQUIRES CHANGES
% the green light is the only one available and the video is hella noisy at
% first and we turn the lights on halfway which jacks everything up.
%dir = '/Volumes/AGHTHESIS2/rats/h7/2018-08-31/'; vidObj = VideoReader([ dir 'VT0.mpg' ]);
%dir = '/Volumes/AGHTHESIS2/rats/h1/2018-09-09/'; vidObj = VideoReader([ dir 'VT0.mpg' ]);


% 2018-08-14 -- unknown; index exceeds matrix dimensions

%dir = '/Volumes/AGHTHESIS2/rats/h7/2018-08-14/'; vidObj = VideoReader([ dir 'VT0.mpg' ]);


dir = '/Volumes/AGHTHESIS2/rats/h1/2018-08-10/'; vidObj = VideoReader([ dir 'VT0.mpg' ]);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ dir 'position_VT0.mat' ],'position')





dir = '/Volumes/AGHTHESIS2/rats/h1/2018-08-10/'; vidObj = VideoReader([ dir 'VT0.0001.mpg' ]);



vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

xyMaxCoords=zeros(2,3,1);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);

xxMaxR=zeros(1,totalFrames);
yyMaxR=zeros(1,totalFrames);
valMaxR=zeros(1,totalFrames);

xxMaxG=zeros(1,totalFrames);
yyMaxG=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

frameIdx=1;

valMaxR=zeros(1,totalFrames);
valMaxG=zeros(1,totalFrames);

ambientLightG = zeros(1,totalFrames);
ambientLightR = zeros(1,totalFrames);

%vidObj.CurrentTime = 17*60+43;
while hasFrame(vidObj)
%while vidObj.CurrentTime > 8*60
   frame = readFrame(vidObj);
%    if ( frameIdx < 1000)
%     ratLocationMovie(frameIdx).cdata = frame;
%    end
     tempFrame=frame(:,:,1);
     ambientLightR(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxR(frameIdx) = maxVal;
     xxMaxR(frameIdx)=xx(1);
     yyMaxR(frameIdx)=yy(1);
     valMaxR(frameIdx)=maxVal(1);
     %
     tempFrame=frame(:,:,2);
     ambientLightG(frameIdx) = median(tempFrame(:));
     tempFrame=frame(:,:,2)-uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     valMaxG(frameIdx) = maxVal;
     xxMaxG(frameIdx)=xx(1);
     yyMaxG(frameIdx)=yy(1);
     valMaxG(frameIdx)=maxVal(1);
     %
     %
     tempFrame=frame(:,:,1);
     tempFrame=frame(:,:,1)-uint8(round(mean(frame(:,:,[2 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     tempFrameR = tempFrame;
     %
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
%      subplot(2,3,1); imagesc(frame(:,:,1)); title('red')
%      subplot(2,3,2); imagesc(frame(:,:,2)); title('green')
%      subplot(2,3,3); imagesc(frame(:,:,3)); title('blue')
%      subplot(2,3,4); imagesc(mean(frame(:,:,:),3)); title('luminance')
%      subplot(2,3,5); imagesc(tempFrameR);
%      subplot(2,3,6); scatter( [ xxMedianMaxG xxMaxG ], [ yyMedianMaxG yyMaxG ] )
%      drawnow
     
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

figure; hold on; plot(xGpos); plot(yGpos);

figure; plot(ambientLightG); hold on; plot(ambientLightR);

figure; plot(valMaxG); hold on; plot(valMaxR);
figure; histogram(valMaxG); hold on; histogram(valMaxR);

position.valMaxG = valMaxG;
position.valMaxR = valMaxR;

position.xxMaxG = xxMaxG;
position.yyMaxG = yyMaxG;
position.xxMaxR = xxMaxR;
position.yyMaxR = yyMaxR;

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

position.ambientLightR=ambientLightR;
position.ambientLightG=ambientLightG;

save([ dir 'position_VT0_0001.mat' ],'position')



% 
position2=position;
load([ dir 'position_VT0.mat' ]);
position1=position;
position=[];
% 
xpos = mean([ position1.xGpos; position1.xRpos ]);
ypos = mean([ position1.yGpos; position1.yRpos ]);
xpos = [ xpos mean([ position2.xGpos; position2.xRpos ]) ];
ypos = [ ypos mean([ position2.yGpos; position2.yRpos ]) ];
% 
headDir = atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos );
headDir = [ headDir atan2( position1.yGpos-position1.yRpos, position1.xGpos-position1.xRpos ) ];
% 
[ vidElapsedSec, xytimestamps ] = smi2mat( dir );
if length(xytimestamps) > length(xpos)
    xytimestamps = xytimestamps(1:length(xpos));
    vidElapsedSec = vidElapsedSec(1:length(xpos));
elseif length(xytimestamps) < length(xpos)
    warning('WTF!?')
    for kk = length(xytimestamps)+1:length(xpos)
        vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
        xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
    end
end
%
filepath='/Volumes/AGHTHESIS2/rats/h1/2018-08-10/';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC10.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );


position.valMaxG = [ position1.valMaxG position2.valMaxG ];
position.valMaxR = [ position1.valMaxR position2.valMaxR ];

position.xxMaxG = [ position1.xxMaxG position2.xxMaxG  ];
position.yyMaxG = [ position1.yyMaxG position2.yyMaxG ];
position.xxMaxR = [ position1.xxMaxR position2.xxMaxR ];
position.yyMaxR = [ position1.yyMaxR position2.yyMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.yyMedianMaxG = [ position1.yyMedianMaxG position2.yyMedianMaxG ];
position.xxMedianMaxR = [ position1.xxMedianMaxR position2.xxMedianMaxR ];
position.yyMedianMaxR = [ position1.yyMedianMaxR position2.yyMedianMaxR ];

position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];
position.xxMedianMaxG = [ position1.xxMedianMaxG position2.xxMedianMaxG ];

position.xRpos = [ position1.xRpos position2.xRpos ];
position.yRpos = [ position1.yRpos position2.yRpos ];
position.xGpos = [ position1.xGpos position2.xGpos ];
position.yGpos = [ position1.yGpos position2.yGpos ];

position.ambientLightR = [ position1.ambientLightR position2.ambientLightR ];
position.ambientLightG = [ position1.ambientLightG position2.ambientLightG ];


save([ dir 'position.mat' ],'position')






%% VESTIGIAL



% figure; plot( (1:length(xxMaxR))/29.97, mean([xxMaxR; xxMaxG ])); hold on; 
% 
% figure; plot( (1:length(xxMaxR))/29.97, mean([xxMaxR xxMaxG ],2)); hold on; plot( (1:length(xxMaxR))/29.97, valMaxG );
% 
% figure; histogram( xxMaxG(2:length(xxMaxR))-xxMaxG(1:length(xxMaxR)-1), 100 )
% 
% xxcMaxG = xxMaxG;
% yycMaxG = yyMaxG;
% flag=0;
% for ii=2:length(xxMaxR)
%     if xxcMaxG(ii) - xxcMaxG(ii-1) > 55
%         flag = 1;
%     elseif xxcMaxG(ii) - xxcMaxG(ii-1) < -55
%         flag = 0;
%     end
%     if flag == 1
%         xxcMaxG(ii) = xxcMaxG(ii-1);
%         yycMaxG(ii) = yycMaxG(ii-1);
%     end
% end
% figure; plot( (1:length(xxMaxR))/29.97, xxMaxG  ); hold on; plot( (1:length(xxMaxR))/29.97, xxcMaxG );


