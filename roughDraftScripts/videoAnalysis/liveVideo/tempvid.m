%this process is slow.

'/Users/andrewhowe/Downloads/placePreference/'
'da1-2-7_lpp_day1_Jul22'
'da1-2-7_llpp_day2_Jul25'	
'da1-2_lpp_day3_Jul26'	
'da2_lpp_day4_Aug3'	
'da2_lpp_day5_Aug4'
'da5_lpp_day1_Aug4'


frame = read(obj, 100);
figure; imshow(frame);
hold on; 
figure;


figure; hold on;
qq=xyMaxCoordsFixed(1,1,:);
ww=xyMaxCoordsFixed(2,1,:);
plot(ww(:),qq(:),'r')
qq=xyMaxCoordsFixed(1,2,:);
ww=xyMaxCoordsFixed(2,2,:);
plot(ww(:),qq(:),'g')
qq=xyMaxCoordsFixed(1,3,:);
ww=xyMaxCoordsFixed(2,3,:);
plot(ww(:),qq(:),'b')





% open video
vidObj = VideoReader('/Users/andrewhowe/data/placePreference/da2_lpp-square-tray_day1_Aug2/VT1.mpg');
% pull 1 frame
frame = readFrame(vidObj);
% display
figure;
imshow(frame);



vidObj = VideoReader('/Users/andrewhowe/Downloads/placePreference/da2_lpp-square-tray_day1_Aug2/VT0.mpg');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
ratLocationMovie = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
xyMaxCoords=zeros(2,3,1);
frameIdx=1;
while hasFrame(vidObj)
   frame = readFrame(vidObj);
   if ( frameIdx < 1000)
    ratLocationMovie(frameIdx).cdata = frame;
   end
   for rgbIdx = 1:3  
     tempFrame=frame(:,:,rgbIdx);
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xyMaxCoords(1,rgbIdx,frameIdx) = xx(1);
     xyMaxCoords(2,rgbIdx,frameIdx) = yy(1);
     if frameIdx == 22000
        disp('22000')
     elseif frameIdx == 2000
        disp('2000')
     end
   end
   frameIdx=frameIdx+1;
end

xyMaxCoordsFixed=xyMaxCoords;
for ii=1:2
    for jj=1:3
        xyMaxCoordsFixed(ii,jj,:)=nlxPositionFixer(xyMaxCoords(ii,jj,:));
    end
end



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







% get the video data and fix it
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat('~/Downloads/da5-rtpp/VT0.nvt');
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);
xyTime = 100+(xyPositionTimestamps-xyPositionTimestamps(1))/1e6;
% calculate velocity
velocity=[0; sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'))];
%
figure; plot(xpos,ypos);
figure; plot(velocity)

[zc,zn]=nzv2mat('~/Downloads/da5-rtpp/laserMazev2-da2-place-prefd-linear-2-box2.nzv');

figure; 
subplot(2,5,1:4);
rectangle('Position', [ min(xyTime) zc(1,1) max(xyTime)-min(xyTime) min([zc(1,3) max(xpos) ])-zc(1,1) ], 'FaceColor',[ .8 1 1],'EdgeColor', [.8 1 1])
hold on;plot(xyTime,xpos,'k');
%line([ min(xyTime) max(xyTime) ], [ zc(1,1) zc(1,1) ], 'Color', [ .4 .4 .8 ], 'LineWidth', 1)

ylabel('x coordinate'); xlabel('time (s)'); legend('da5');
subplot(2,5,5);
[yy,xx]=hist(xpos,40);
plot(yy./sum(yy),xx, 'o-');  xlabel('p(x)');
line([0 max(yy./sum(yy))], [ zc(1,1) zc(1,1) ], 'Color', [ .4 .4 .8 ], 'LineWidth', 1)
subplot(2,5,6:9); 
plot(xyTime,velocity,'r'); ylabel('velocity'); xlabel('time (s)');
subplot(2,5,10);
[yy,xx]=hist(velocity,15);
plot(log(yy./sum(yy)),xx, 'o-'); xlabel('log(p(v))')


subplot(2,5,1:4); hold on; 
line([100 max(xyTime)], [ zc(1,1) zc(1,1) ], 'Color', [ .1 .1 .6 ])
line([100 max(xyTime)], [ zc(7,3) zc(7,3) ], 'Color', [ 1 .5 0 ])
subplot(2,5,5); 
plot(yy./sum(yy),xx, 'o-'); legend('dist');


'laserMazev2-da2-place-prefd-linear-2-box2.nzv';







% get the video data and fix it
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat('~/Downloads/da2-aug4-2016/VT0.nvt');
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);
xyTime = 100+(xyPositionTimestamps-xyPositionTimestamps(1))/1e6;
% calculate velocity
velocity=[0; sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'))];
%
figure; plot(xpos,ypos);
figure; plot(velocity)

[zc,zn]=nzv2mat('~/Downloads/da5-rtpp/laserMazev2-da2-place-prefd-linear-2-box2.nzv');

figure; 
subplot(2,5,1:4);
rectangle('Position', [ min(xyTime) zc(1,1) max(xyTime)-min(xyTime) min([zc(1,3) max(xpos) ])-zc(1,1) ], 'FaceColor',[ .8 1 1],'EdgeColor', [.8 1 1])
hold on;plot(xyTime,xpos,'k');
%line([ min(xyTime) max(xyTime) ], [ zc(1,1) zc(1,1) ], 'Color', [ .4 .4 .8 ], 'LineWidth', 1)
ylabel('x coordinate'); xlabel('time (s)'); legend('da2');
subplot(2,5,5);
[yy,xx]=hist(xpos,40);
plot(yy./sum(yy),xx, 'o-');  xlabel('p(x)');
line([0 max(yy./sum(yy))], [ zc(1,1) zc(1,1) ], 'Color', [ .4 .4 .8 ], 'LineWidth', 1)
subplot(2,5,6:9); 
plot(xyTime,velocity,'r'); ylabel('velocity'); xlabel('time (s)');
subplot(2,5,10);
[yy,xx]=hist(velocity,15);
plot(log(yy./sum(yy)),xx, 'o-'); xlabel('log(p(v))')s




figure;
subplot(2,5,1:4);
rectangle('Position', [ min(xyTime) zc(1,1) max(xyTime)-min(xyTime) min([zc(1,3) max(xpos) ])-zc(1,1) ], 'FaceColor',[ .8 1 1],'EdgeColor', [.8 1 1])
hold on;plot(xyTime,xpos,'k');
%line([ min(xyTime) max(xyTime) ], [ zc(1,1) zc(1,1) ], 'Color', [ .4 .4 .8 ], 'LineWidth', 1)
ylabel('x coordinate'); xlabel('time (s)'); legend('da2');
subplot(2,5,5);
[yy,xx]=hist(xpos,40);
plot(yy./sum(yy),xx, 'o-');  xlabel('p(x)');
line([0 max(yy./sum(yy))], [ zc(1,1) zc(1,1) ], 'Color', [ .4 .4 .8 ], 'LineWidth', 1)
subplot(2,5,6:9);
plot(xyTime,velocity,'r'); ylabel('velocity'); xlabel('time (s)');
subplot(2,5,10);
[yy,xx]=hist(velocity,15);
plot(log(yy./sum(yy)),xx, 'o-'); xlabel('log(p(v))')




'/Users/andrewhowe/Downloads/placePreference/da2_lpp-square-tray_day1_Aug2/'

xy.red.x = xyMaxCoords(1,1,:);
xy.red.y = xyMaxCoords(2,1,:);
xy.green.x = xyMaxCoords(1,2,:);
xy.green.y = xyMaxCoords(2,2,:);
xy.blue.x = xyMaxCoords(1,3,:);
xy.blue.y = xyMaxCoords(2,3,:);
save('/Users/andrewhowe/Downloads/placePreference/da2_lpp-square-tray_day1_Aug2/xyCoords.mat','xy');



% get the video data and fix it
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat('/Users/andrewhowe/Downloads/placePreference/2016-08-08_11-39-01_da2_lpp-square-reverse_day1/VT0.nvt');
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);
xyTime = 100+(xyPositionTimestamps-xyPositionTimestamps(1))/1e6;
% calculate velocity
velocity=[0; sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'))];
%
figure; plot(xpos,ypos);
figure; plot(velocity)
figure; plot(xpos)





%HDR Microscope stuff
microscopeFiles = [ '~/Downloads/FF_20xSliceAChR2GrnzstckHiExp1o8.png   ';
'~/Downloads/FF_20xSliceAChR2Greenzstck.png         ';
'~/Downloads/FF_20xSliceAChR2GrnzstckLoExp1o20.png  ';
'~/Downloads/FF_20xSliceAChR2GreenzstckLowerExp.png ';
'~/Downloads/FF_20xSliceAChR2GreenzstckLoExp1o35.png';
'~/Downloads/FF_20xSliceATHredzstck.png             ';
'~/Downloads/FF_20xSliceADAPIzstck.png              '];
microscopeFiles=cellstr(microscopeFiles);
exposures=[ 1/8.5 1/12 1/20 1/25 1/35 1/15  1/12 ];
hdr = makehdr(microscopeFiles, 'ExposureValues', exposures );
rgb = tonemap(hdr); %,'AdjustLightness', [0.001 1]);
figure; imshow(rgb)


% Average Video Stuff
vidObj = VideoReader('~/Downloads/t-maze-orientation-5-min-VT1.mpg');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
ratLocationMovie = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
avgFrame=readFrame(vidObj);
avgFrame=cast(avgFrame,'double');
frameIdx=2;
while hasFrame(vidObj)
    frame=readFrame(vidObj);
    frame = cast(frame, 'double');
    avgFrame = ((avgFrame*(frameIdx-1))+frame)/frameIdx;
    if ( frameIdx > 30*90) && (frameIdx < 5400+30*90)
        ratLocationMovie(frameIdx).cdata = frame;
    end
    frameIdx=frameIdx+1;
end

maxVals=zeros(1, length(30*90:5400+30*90));
maxRows=zeros(1, length(30*90:5400+30*90));
maxCols=zeros(1, length(30*90:5400+30*90));
minVals=zeros(1, length(30*90:5400+30*90));
minRows=zeros(1, length(30*90:5400+30*90));
minCols=zeros(1, length(30*90:5400+30*90));
ii=1;
figure;
means=minCols; stds=means;
for idx=30*150+1:5400+30*90-4
    
    aa=ratLocationMovie(idx+3).cdata(:,:,1)-ratLocationMovie(idx).cdata(:,:,1);
    [xx,yy]=find(abs(aa)>30);
    maxRows(ii)=median(yy);
    maxCols(ii)=median(xx);
    imagesc(aa); hold on; plot(maxRows(ii),maxCols(ii),'oy'); hold off; drawnow;
    ii=ii+1;
end
figure; imagesc(ratLocationMovie(idx).cdata(:,:,1))
%    [maxVals(ii),mxidx]=max(aa(:));   
%     if (maxVals(ii)>40) || ii==1
%         [maxRows(ii),maxCols(ii)]=ind2sub([vidHeight vidWidth],mxidx);
%     else
%         maxRows(ii)=maxRows(ii-1); maxCols(ii)=maxCols(ii-1);
%     end
% %    means(ii)=mean(aa(:)); stds(ii)=std(aa(:));
    %imagesc(aa); hold on; plot(maxRows(ii),maxCols(ii),'*m'); hold off; drawnow;
    %[minVals(ii),mnidx]=min(aa(:));
    %[minRows(ii),minCols(ii)]=ind2sub([vidHeight vidWidth],mnidx);
%    ii=ii+1;
%end
figure;plot(minRows,minCols,'Color', [ 1 0 0 .3 ]); hold on; plot(maxRows,maxCols,'Color', [ 0 1 0 .3 ]);
figure; plot(minVals)

figure;subplot(2,1,1); plot(maxRows); hold on; plot(maxVals)
subplot(2,1,2); plot(maxCols); hold on; plot(maxVals)

figure;plot(maxRows, vidHeight- maxCols)

2675:2843

figure; aa=ratLocationMovie(30*150+1+2700+3).cdata(:,:,1)-ratLocationMovie(30*150+1+2700).cdata(:,:,1); imagesc(aa)
30*150+1+2700

figure; plot(nlxPositionFixer(maxRows))
figure; imagesc(ratLocationMovie(30*150+1).cdata(:,:,1))
[mx,mxidx]=max(aa(:));
[mxrr,mxcc]=ind2sub([vidHeight vidWidth],mxidx);
[mn,mnidx]=min(aa(:));
[mnrr,mncc]=ind2sub([vidHeight vidWidth],mnidx);



figure; 
subplot(3,2,1);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6000).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,2);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6001).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,3);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6002).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,4);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6003).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,5);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6004).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,6);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6005).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;





figure; aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6000).cdata(:,:,1);
imagesc((abs(aa)>20)); colormap(build_NOAA_colorgradient); colorbar;
[yy,xx]=find(abs(aa)>20);
hold on; plot(median(xx),median(yy),'*m')


figure; 
subplot(3,2,1);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6000).cdata(:,:,1);
imagesc((abs(aa)>15)); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,2);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6001).cdata(:,:,1);
imagesc((abs(aa)>30)); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,3);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6002).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,4);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6003).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,5);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6004).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,2,6);
aa=ratLocationMovie(6006).cdata(:,:,1)-ratLocationMovie(6005).cdata(:,:,1);
imagesc(aa); colormap(build_NOAA_colorgradient); colorbar;










%HDR Microscope stuff
microscopeFiles = [ '~/Downloads/FF_20xSliceAChR2GrnzstckHiExp1o8.png   ';
'~/Downloads/FF_20xSliceAChR2Greenzstck.png         ';
'~/Downloads/FF_20xSliceAChR2GrnzstckLoExp1o20.png  ';
'~/Downloads/FF_20xSliceAChR2GreenzstckLowerExp.png ';
'~/Downloads/FF_20xSliceAChR2GreenzstckLoExp1o35.png';
'~/Downloads/FF_20xSliceATHredzstck.png             ';
'~/Downloads/FF_20xSliceADAPIzstck.png              '];
microscopeFiles=cellstr(microscopeFiles);
exposures=[ 1/8.5 1/12 1/20 1/25 1/35 1/15  1/12 ];
hdr = makehdr(microscopeFiles, 'ExposureValues', exposures );
rgb = tonemap(hdr); %,'AdjustLightness', [0.001 1]);
figure; imshow(rgb)