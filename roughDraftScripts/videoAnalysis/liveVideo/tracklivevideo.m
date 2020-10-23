


%% seagate video version

vidObj = VideoReader('/Volumes/BlueMiniSeagateData/da11-day1-cpp/VT1.mpg');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
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

return;

xyMaxCoordsFixed=xyMaxCoords;
for ii=1:2
    for jj=1:3
        xyMaxCoordsFixed(ii,jj,:)=nlxPositionFixer(xyMaxCoords(ii,jj,:));
    end
end

xxFixed=nlxPositionFixer(xyMaxCoords(1,1,:));


figure;
subplot(2,1,1); aa=(xyMaxCoords(1,1,:)); plot(aa(:),'o'); hold on;
subplot(2,1,2); aa=(xyMaxCoords(2,1,:)); plot(aa(:),'o'); hold on;
subplot(2,1,1); aa=(xyMaxCoords(1,2,:)); plot(aa(:),'*'); hold on;
subplot(2,1,2); aa=(xyMaxCoords(2,2,:)); plot(aa(:),'*'); hold on;
subplot(2,1,1); aa=(xyMaxCoords(1,3,:)); plot(aa(:)); hold on;
subplot(2,1,2); aa=(xyMaxCoords(2,3,:)); plot(aa(:));



hold on;
qq=xyMaxCoords(1,1,100);
ww=xyMaxCoords(2,1,100);
plot(ww,qq,'*c');

hold on;
ww=xyMaxCoords(1,1,end);
qq=xyMaxCoords(2,1,end);
plot(ww,qq,'*c');


aa=(xyMaxCoords(1,1,:)); bb=(xyMaxCoords(2,1,:)); cc=(xyMaxCoords(1,2,:));
dd=(xyMaxCoords(2,2,:)); ee=(xyMaxCoords(1,3,:)); ff=(xyMaxCoords(2,3,:));

