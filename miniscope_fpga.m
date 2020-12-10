vidObj = VideoReader('/Volumes/Seagate Expansion Drive/fpgaTest/H12_M5_S45/msCam1.avi');
vidHeight = vidObj.Height; vidWidth = vidObj.Width; frame=read(vidObj);
%close(vidObj);

vidObj

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

figure; histogram(frame(:),0:2^10);


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


framesMedFlattened=zeros(size(frame));
for idx=1:1000
    framesMedFlattened(:,:,1,idx)=double(frame(:,:,1,idx))-(medFrameRaw);
end

% check it out live
figure;
nnxx=[]; nnyy=[]; nntt=[];
for ii=1:1000  % number of frames in the video
    pause(0.01); % controls the speed; smaller is faster
    currentFrame=framesMedFlattened(:,:,1,ii);
    subplot(1,2,1); imagesc(double(currentFrame));  % colormap of the frame
    subplot(1,2,2); imagesc(double(currentFrame-median(median(currentFrame)))); 
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
    %caxis([-10 30]); % should be automated; manually determined by range plot, and then playing around
    %subplot(1,2,2); 
    displayMe=double(currentFrame-median(median(currentFrame)));
    imagesc(displayMe); 
    colormap('bone'); colorbar;
    caxis([-10 20]); % should be automated; manually determined by range plot, and then playing around
    title(num2str(ii));
    drawnow;
end


    %subplot(1,2,2);
    % didn't work... whereMaxIs=imregionalmax(displayMe); colormap('bone'); colorbar;
    %caxis([0 1]);
    %imagesc(whereMaxIs);



figure; temp=framesMedFlattened(:,:,1,:); imagesc(max(,3))



% near or on frames with big events 723 820 965
%765 vs 802
figure; imagesc(double(framesMedFlattened(:,:,1,965))); colormap(build_NOAA_colorgradient); colorbar; caxis([-25 35]);

% big shift in the center of the pixels during big event
figure; subplot(1,2,1); qq=double(framesMedFlattened(:,:,1,765)); hist(qq(:),30); subplot(1,2,2); qq=double(framesMedFlattened(:,:,1,802)); hist(qq(:),30);


figure; qq=maxFrameFlattened(:); hist(qq,30);

% % let's see the central pixel  value of the video move around
% medianFrame=zeros(1,1000);
% meanFrame=zeros(1,1000);
% for ii=1:1000  % number of frames in the video
%     tt=framesMedFlattened(:,:,1,ii);
%     medianFrame(ii)=median(tt(:));
%     meanFrame(ii)=mean(tt(:));
% end
% figure; plot(medianFrame); hold on; plot(meanFrame); title('central tendency by frames'); legend('median','mean'); ylabel('brilliance'); xlabel('time (sample)');


% followNeuron=zeros(1,1000);
% for ii=1:1000
%     tt=framesMedFlattened(405:415,405:415,1,ii);
%     followNeuron(ii)=median(tt(:));
% end
% figure; plot(followNeuron);
% followNeuron=zeros(1,1000);
% for ii=1:1000
%     tt=framesMedFlattened(449:457,432:440,1,ii);
%     followNeuron(ii)=median(tt(:));
% end
% figure; plot(followNeuron);




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
caxis([0 55]);



figure;
subplot(3,4,1); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,2); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,3); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,4); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,5); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,6); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,7); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,8); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,9); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,10); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,11); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);
subplot(3,4,12); fRow=(round(rand(1)*439)+1); fCol=(round(rand(1)*752)+1); temp=frame(fRow, fCol, 1, :); temp=double(temp(:)); hist(temp,30);



return;
%movie(F)


% make output video 
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


% check it out live
figure;
for ii=1:1000  % number of frames in the video
    pause(0.02); % controls the speed; smaller is faster
    imagesc(double(frame(:,:,1,ii))-(avgFrameRaw));  % colormap of the frame
    %colormap(build_NOAA_colorgradient); % comment this out if you don't have the colormap
    colormap('bone'); colorbar;
    caxis([0 40]); % should be automated; manually determined by range plot, and then playing around
end

return;

% output to disk
myVideo = VideoWriter('~/Desktop/msCam2_og.avi'); %, 'Uncompressed AVI');
myVideo.FrameRate = 30;  % Default 30
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);





return;


%this process is slow.

'/Users/andrewhowe/Downloads/placePreference/'
'da1-2-7_lpp_day1_Jul22'
'da1-2-7_llpp_day2_Jul25'	
'da1-2_lpp_day3_Jul26'	
'da2_lpp_day4_Aug3'	
'da2_lpp_day5_Aug4'
'da5_lpp_day1_Aug4'



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

