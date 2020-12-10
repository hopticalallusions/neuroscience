vidObj = VideoReader('~/Desktop/izquierdoLab/tonyVideoAnalysis/RatTY4_Rev_CNO_092820.mp4');
vidObj = VideoReader('~/src/DeepLabCut/test3-agh-2020-10-05/videos/RatTY4_Rev_CNO_092820DLC_resnet50_test3Oct5shuffle1_1000_bx_bp_labeled.mp4');

illuminationDistribution = zeros( vidObj.Height, vidObj.Width, 256);
vidObj.CurrentTime = 0;
while hasFrame(vidObj)
    frame = uint8(floor(mean(readFrame(vidObj),3)))+1;
    [ row, col, val ] = find(frame);
    tIdx = sub2ind([ vidObj.Height vidObj.Width 256 ], row, col, val);
    illuminationDistribution(tIdx) = illuminationDistribution(tIdx) + 1;
end

meanFrame = zeros(vidObj.Height, vidObj.Width);
for ii=1:vidObj.Height
    for jj=1:vidObj.Width
        meanFrame(ii,jj)=([1:256]*squeeze(illuminationDistribution(ii,jj,:)))./sum(squeeze(illuminationDistribution(ii,jj,:)));
    end
end
figure; imagesc(meanFrame)


figure;
for ii=1:vidObj.Height
    for jj=1:vidObj.Width
        plot(0:255,squeeze(illuminationDistribution(ii,jj,:)), 'Color', [ 0 0 0 .1]); hold on;
    end
end
xlim([0 256])
        


pp=kmeans(meanFrame,12);











load(['~/data/izquierdo/tonyVideo/avgFrameRaw.mat'],'avgFrameRaw');
figure; imagesc(avgFrameRaw)

figure; for ii=200:300; plot(0:255, squeeze(illuminationDistribution(ii,200,:))); hold on; end


vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
frame = readFrame(vidObj);
panelsMask = (mean(frame,3)>70);
panelsMask(1:50,:)=0;
panelsMask(:,270:end)=0;
figure; subplot(1,2,1); imagesc(frame); subplot(1,2,2); imagesc(panelsMask); 
%ratLocationMovie = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
totalFrames=ceil(vidObj.Duration*vidObj.FrameRate);
panelIllumination = zeros(1,totalFrames);
illumination = zeros(1,totalFrames);
allFrames = zeros( vidHeight, vidWidth, 13189 , 'uint8' );
frameIdx=1;
figure;
vidObj.CurrentTime = 0;
while hasFrame(vidObj)
    imagesc(readFrame(vidObj));
    frame = mean(readFrame(vidObj),3);
    allFrames(:,:,frameIdx) = uint8(frame);
    panelIllumination(frameIdx) = mean(frame(panelsMask>0));
    illumination(frameIdx) = mean(frame(panelsMask<1));
    frameIdx = frameIdx + 1;
end
panelIllumination = panelIllumination(1:frameIdx-1);
illumination = illumination(1:frameIdx-1);
figure; plot((1:length(panelIllumination))./ vidObj.FrameRate, [ illumination panelIllumination])


minFrameRaw=zeros(vidHeight,vidWidth);
maxFrameRaw=zeros(vidHeight,vidWidth);
avgFrameRaw=zeros(vidHeight,vidWidth);
skewFrameRaw=zeros(vidHeight,vidWidth);
varFrameRaw=zeros(vidHeight,vidWidth);
stdFrameRaw=zeros(vidHeight,vidWidth);
medFrameRaw=zeros(vidHeight,vidWidth);
madamFrameRaw=zeros(vidHeight,vidWidth);
kurtFrameRaw=zeros(vidHeight,vidWidth);

for rowIdx=1:vidHeight
    for colIdx=1:vidWidth
        minFrameRaw(rowIdx,colIdx) = min(allFrames(rowIdx,colIdx,:));
        maxFrameRaw(rowIdx,colIdx) = max(allFrames(rowIdx,colIdx,:));
        avgFrameRaw(rowIdx,colIdx) = mean(allFrames(rowIdx,colIdx,:));
        skewFrameRaw(rowIdx,colIdx) = skewness(double(allFrames(rowIdx,colIdx,:)));
        varFrameRaw(rowIdx,colIdx) = var(double(allFrames(rowIdx,colIdx,:)));
        stdFrameRaw(rowIdx,colIdx) = std(double(allFrames(rowIdx,colIdx,:)));
        medFrameRaw(rowIdx,colIdx) = median(allFrames(rowIdx,colIdx,:));
        kurtFrameRaw(rowIdx,colIdx) = kurtosis(double(allFrames(rowIdx,colIdx,:)));
        madamFrameRaw(rowIdx,colIdx) = median(abs(double(allFrames(rowIdx,colIdx,:))-median(double(allFrames(rowIdx,colIdx,:)))));
    end
end
rangeFrameRaw=maxFrameRaw-minFrameRaw;

save(['~/data/izquierdo/tonyVideo/minFrameRaw.mat'],'minFrameRaw');
save(['~/data/izquierdo/tonyVideo/maxFrameRaw.mat'],'maxFrameRaw');
save(['~/data/izquierdo/tonyVideo/avgFrameRaw.mat'],'avgFrameRaw');
save(['~/data/izquierdo/tonyVideo/skewFrameRaw.mat'],'skewFrameRaw');
save(['~/data/izquierdo/tonyVideo/varFrameRaw.mat'],'varFrameRaw');
save(['~/data/izquierdo/tonyVideo/stdFrameRaw.mat'],'stdFrameRaw');
save(['~/data/izquierdo/tonyVideo/medFrameRaw.mat'],'medFrameRaw');
save(['~/data/izquierdo/tonyVideo/madamFrameRaw.mat'],'madamFrameRaw');
save(['~/data/izquierdo/tonyVideo/kurtFrameRaw.mat'],'kurtFrameRaw');
save(['~/data/izquierdo/tonyVideo/rangeFrameRaw.mat'],'rangeFrameRaw');

%
% BASIC FIGURE
%
% figure;
% subplot(3,4,1); imagesc(allFrames(:,:,814)); title('frame 814'); colormap(build_NOAA_colorgradient); colorbar;
% subplot(3,4,2); imagesc(minFrameRaw); title('minimum'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( minFrameRaw(:), 99) ])
% subplot(3,4,3); imagesc(maxFrameRaw); title('max'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( maxFrameRaw(:), 99) ])
% subplot(3,4,4); imagesc(avgFrameRaw); title('mean'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( avgFrameRaw(:), 99) ])
% subplot(3,4,5); imagesc(skewFrameRaw); title('skewness'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( skewFrameRaw(:), 99) ])
% subplot(3,4,6); imagesc(varFrameRaw); title('var'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( varFrameRaw(:), 99) ])
% subplot(3,4,7); imagesc(stdFrameRaw); title('std'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( stdFrameRaw(:), 99) ])
% subplot(3,4,8); imagesc(medFrameRaw); title('median'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( medFrameRaw(:), 99) ])
% subplot(3,4,9); imagesc(madamFrameRaw); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( madamFrameRaw(:), 99) ])
% subplot(3,4,10); imagesc(kurtFrameRaw); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( kurtFrameRaw(:), 99) ])
% subplot(3,4,11); imagesc(rangeFrameRaw); title('range'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( rangeFrameRaw(:), 99) ])


figure;
subplot(3,3,1); imagesc(allFrames(:,:,814)); title('frame 814'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,3,2); imagesc(minFrameRaw); title('minimum'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( minFrameRaw(:), 99) ])
subplot(3,3,3); imagesc(log2(maxFrameRaw)); title('log2(max)'); colormap(build_NOAA_colorgradient); colorbar;% caxis([0 prctile( log2(maxFrameRaw(:)), 99) ])
subplot(3,3,4); imagesc(avgFrameRaw); title('mean'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( avgFrameRaw(:), 99) ])
subplot(3,3,6); imagesc(skewFrameRaw); title('skewness'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( skewFrameRaw(:), 99) ])
subplot(3,3,8); imagesc(varFrameRaw); title('var'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( varFrameRaw(:), 99) ])
subplot(3,3,5); imagesc(stdFrameRaw); title('std'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( stdFrameRaw(:), 99) ])
subplot(3,3,7); imagesc(madamFrameRaw); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( madamFrameRaw(:), 99) ])
subplot(3,3,9); imagesc(kurtFrameRaw); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar; caxis([0 prctile( kurtFrameRaw(:), 99) ])





se = strel('disk',5);
%meh
imagesc(imopen(imclose(log2(single(((allFrames(:,:,ii)-uint8(medFrameRaw))))),se),se));

figure; 
for ii=4500:6000 %1:length(allFrames)
    %bgSubtracted = log2(single(((allFrames(:,:,ii)-uint8(medFrameRaw))))+realmin);
    ii=4945;
    bgSubtracted = ((allFrames(:,:,ii)-uint8(avgFrameRaw)));
    bgSubtracted( 30:50, 1:280 ) = 0;
%    subplot(1,2,1);
    imagesc(bgSubtracted); colormap('bone')
    [ mxVal, mxIdx] = max( bgSubtracted(:) );
    [yy xx] = ind2sub( size(bgSubtracted), mxIdx(1) );
    hold on; scatter( xx, yy, 'ro' ); hold off;
%    subplot(1,2,2);
%    histogram(bgSubtracted(:),-100:2:256);
    drawnow; pause(0.0005);
end

rewardZoneMask = zeros(size(bgSubtracted)); rewardZoneMask( 250:338, 830:947) = 1;
rewardZone = uint8(rewardZoneMask).*bgSubtracted; figure; imagesc(rewardZone>120);
rewardLightsMask = rewardZone>120;
se = strel('disk',5);
rewardLightsMask = imclose(rewardLightsMask,se);



% % % BAD ISLAND FILLING ATTEMPT
% [ panelCoordinatesY panelCoordinatesX ] = ind2sub( size(panelsMask), find(panelsMask) );
% islandID = zeros(size(panelCoordinatesX));
% maxIslandID = 0;
% queue=[];
% for ii=1:length(panelCoordinatesX)
%     distance = sqrt( (panelCoordinatesX - panelCoordinatesX(ii) ).^2 + (panelCoordinatesY - panelCoordinatesY(ii)).^2 );
%     currentID = islandID(ii);
%     if max( islandID(distance==1))>0
%         currentID = min( islandID((distance==1)&(islandID>0)));
%     elseif islandID(ii) == 0
%         currentID = max(islandID) + 1;
%     end
%     % 8 way
%     %islandID(find((distance>0).*(distance<2).*(islandID==0))) = currentID;
%     % 4 way
%     islandID(find((distance==1).*(islandID==0))) = currentID;
%     
%     panels = uint8(panelsMask);
%     panels((panelsMask==1))=islandID;
%     figure(100); imagesc(panels); colormap('colorcube'); caxis([0 52]); drawnow;
% end






% GOOD ISLAND FILLING ATTEMPT

areaThreshold = 100;
currentLabel = 2;
panels = uint8(panelsMask);
for ii=1:length(panelCoordinatesX)
    if panels(panelCoordinatesY(ii), panelCoordinatesX(ii)) == 1 
        panels = floodFillBinary(  panelCoordinatesX(ii), panelCoordinatesY(ii), panels,currentLabel);
        currentLabel = currentLabel + 1;
    end
end
% visual check
%figure; imagesc(panels); colormap('colorcube'); colorbar;
% 
panels(panels>0) = panels(panels>0)-1;
labels = unique(panels(:));
labelCounts = [];
for ii=1:length(labels)
    labelCounts(ii) = sum(panels(:)==labels(ii));
end
% %
currentLabel = 1;
for ii = 1:length(labels)
    if labelCounts(ii) < areaThreshold
        % delete small islands in ...
        panels(panels==labels(ii)) = 0;            % labeled output
        disp(['deleting ' num2str(labels(ii))])
    end
end
% %
labels(labelCounts<areaThreshold)=[];      % label list summary
labelCounts(labelCounts<areaThreshold)=[]; % island size summary
% visual check
%figure; imagesc(panels); colormap('colorcube'); colorbar;
% 
% ADD IN THE REWARD ZONE
panels(find(rewardLightsMask))=max(panels(:))+1;
% visual check
%figure; imagesc(panels); colormap('colorcube'); colorbar;
%
%
% I HAPPEN TO KNOW THAT PANELS 2 and 5 ARE THE SAME, SO I WILL COMBINE THEM
% HERE (there is an unfortunate splitter between them)
%
% there might be some clever way to do some sort of statistical analysis
% that would reveal the correlation and automatically associate these
% regions, but I am not that clever today.
%
panels( panels == 5 ) = 1;
labelCounts( labels == 1 ) = labelCounts(labels==5) + labelCounts(labels==1);
labelCounts( labels == 5 ) = [];
labels( labels == 5) = [];
%
% while we're at it, turn the reward lights into 4 
panels( panels == 6 ) = 4;
labels = [labels; 4];
labelCounts = [ labelCounts  sum(sum( panels == 4) ) ];
%
%
% NOW LET'S ANALYZE THE REGIONS

xxMax  = zeros(1,length(allFrames));
yyMax  = zeros(1,length(allFrames));
maxVal = zeros(1,length(allFrames));
rewardLight = zeros(1,length(allFrames));
panelLeft   = zeros(1,length(allFrames));
panelMiddle = zeros(1,length(allFrames));
panelRight  = zeros(1,length(allFrames));
% alt
altxxMax = zeros(1,length(allFrames));
altyyMax = zeros(1,length(allFrames));
radius   = zeros(1,length(allFrames));
altMax   = zeros(1,length(allFrames));

for ii=1:length(allFrames)
    bgSubtracted = ((allFrames(:,:,ii)-uint8(avgFrameRaw)));
    % 
    rewardLight(ii) = sum(sum(bgSubtracted .* uint8( panels == 4 ) ))/labelCounts(5);
    panelRight(ii)  = sum(sum(bgSubtracted .* uint8( panels == 3 ) ))/labelCounts(4);
    panelMiddle(ii) = sum(sum(bgSubtracted .* uint8( panels == 2 ) ))/labelCounts(3);
    panelLeft(ii)   = sum(sum(bgSubtracted .* uint8( panels == 1 ) ))/labelCounts(2);
    %
    bgSubtracted( 30:50, 1:280 ) = 0;  % block out the time letters, which mess things up
    if rewardLight(ii) > 100  % yay magic numbers...    
        bgSubtracted( panels == 4 ) = 0;
    end
    % track the location of the brightest pixel in the chamber
    [ tmxVal, mxIdx] = max( bgSubtracted(:) );
    maxVal(ii) = tmxVal(1);
    [ yyMax(ii) xxMax(ii) ] = ind2sub( size(bgSubtracted), mxIdx(1) );
    
    % use alternative, local neighborhood tracking
    if ii > 1
        radius(ii) = 5;
        altMax(ii) = 0;
        while( ( altMax(ii) < 150 ) && ( radius(ii) < 50 ) );
            localMask = zeros(size(panels));
            
            loLimY = lastGoodY-radius(ii); if loLimY < 1; loLimY = 1; end;
            hiLimY = lastGoodY+radius(ii); if hiLimY > size(bgSubtracted,1); hiLimY = size(bgSubtracted,1); end;
            loLimX = lastGoodX-radius(ii); if loLimX < 1; loLimX = 1; end;
            hiLimX = lastGoodX+radius(ii); if hiLimX > size(bgSubtracted,2); hiLimX = size(bgSubtracted,2); end;
            
            localMask( loLimY:hiLimY, loLimX:hiLimX ) = 1;
            temp = bgSubtracted .* uint8(localMask);
            
            [ tmxVal, mxIdx] = max( bgSubtracted(:) );
            altMax(ii) = tmxVal(1);
            [ altyyMax(ii), altxxMax(ii) ] = ind2sub( size(bgSubtracted), mxIdx(1) );
            radius(ii) = 2 * radius(ii);
        end
    else
        radius(ii) = 5;
        altMax(ii) = tmxVal(1);
        altyyMax(ii) = yyMax(ii);
        altxxMax(ii) = xxMax(ii);
        lastGoodX = xxMax(ii);
        lastGoodY = yyMax(ii);
    end
    if altMax(ii) < 150
        altMax(ii) = NaN;
    else
        lastGoodX = xxMax(ii);
        lastGoodY = yyMax(ii);
    end
end


figure; scatter( xxMax, yyMax );
figure; 
hold off; plot( (1:length(panelMiddle))./vidObj.FrameRate, panelMiddle./max(panelMiddle), 'Color', [ .1 .1 .9 ], 'LineWidth', 1  );  hold on;
plot( (1:length(panelMiddle))./vidObj.FrameRate, panelRight./max(panelRight),   'Color', [ .8 .1 .1 ], 'LineWidth', 2, 'LineStyle', ':'  );
plot( (1:length(panelMiddle))./vidObj.FrameRate, panelLeft./max(panelLeft),     'Color', [ .6 .1 .9 ], 'LineWidth', 1.5, 'LineStyle', '--' );
plot( (1:length(panelMiddle))./vidObj.FrameRate, rewardLight./max(rewardLight), 'Color', [ .1 .7 .1 ], 'LineWidth', 1  );
legend('middle','right','left','reward'); xlabel('time (s)'); ylabel('mean luminance (normalized)'); title('Panel & Reward Light Status');


figure; 
subplot(2,2,1); imagesc(allFrames(:,:,ii)); title('raw')
subplot(2,2,2); imagesc(bgSubtracted); colormap('bone'); title('raw'); title('bgSubtracted')
subplot(2,2,3); imagesc(log2(single(allFrames(:,:,ii)))); colormap('bone'); title('log2( raw )')
subplot(2,2,4); imagesc(log2(bgSubtracted)); colormap('bone'); title('log2( bgSubtracted )')


%
%
%figure; plot( (1:length(panelMiddle))./vidObj.FrameRate, xxMax ); hold on; plot( (1:length(panelMiddle))./vidObj.FrameRate, yyMax );
xMax=xxMax; yMax = yyMax; altxMax=altxxMax; altyMax = altyyMax;
figure; plot(xMax,yMax)
%
timestampSeconds = (1:length(xMax))./vidObj.FrameRate;
%
% the trick here is to select the GOOD points, not the BAD points.
idx=find(maxVal > 150);
xMax = pchip( timestampSeconds(idx), xMax(idx), timestampSeconds);
yMax = pchip( timestampSeconds(idx), yMax(idx), timestampSeconds);
hold on; plot(xMax,yMax)
%figure; histogram(maxVal)
tempSpeed = calculateSpeed(xMax, yMax, 0.01, 1, vidObj.FrameRate);
%figure; plot( timestampSeconds, xMax); hold on; plot( timestampSeconds, yMax); plot(timestampSeconds, maxVal); plot(timestampSeconds, tempSpeed); legend('x','y','max', 'speed');
%
% based on a fairly quick turn, measured by hand
% calculateSpeed([289 320 372 460 534 675 792 813], [472 472 459 440 436 386 345 295], 0.01, 1, vidObj.FrameRate)
% 
% in px/s these are quite high. ~1300 px/s. It's probably fair to assume
% the rat can hit at least 1500 px/s in this rig.
%
% between frames, it is a more reasonable 45.5 px difference
%
% using an immediate frame to frame analysis, the rat hits a smokin' 150 px
% delta between frames
% 
% tx=[289 320 372 460 534 675 792 813]; ty=[472 472 459 440 436 386 345 295]; sqrt( (tx(1:end-1)-tx(2:end)).^2 + (ty(1:end-1)-ty(2:end)).^2 ) 
%    31.0000   53.6004   90.0278   74.1080  149.6028  123.9758   54.2310
%
% 150*29 = 4350  !!! per second!!
%
for jj=1:4  % this number is completely made up; it can asymptote above zero, which is not great
    instantaneousSpeed = [0 sqrt( (xMax(1:end-1)-xMax(2:end)).^2 + (yMax(1:end-1)-yMax(2:end)).^2 ) ] ;
    %figure; histogram(instantaneousSpeed)
    idx=find(instantaneousSpeed < 125);
    xMax = pchip( timestampSeconds(idx), xMax(idx), timestampSeconds);
    yMax = pchip( timestampSeconds(idx), yMax(idx), timestampSeconds);
    sum(instantaneousSpeed > 125)
    hold on; plot(xMax,yMax)
end
%
%
%
% might eventually work. key word : eventually.
% while max(tempSpeed) > 1500
%     idx=find(tempSpeed < 1500);
%     xMax = pchip( timestampSeconds(idx), xMax(idx), timestampSeconds);
%     yMax = pchip( timestampSeconds(idx), yMax(idx), timestampSeconds);
%     tempSpeed = calculateSpeed(xMax, yMax, 0.01, 1, vidObj.FrameRate);
% end
% figure; plot(xMax,yMax)

idx=find(altMax > 100);
if ~isempty(idx)
    altxMax = pchip( timestampSeconds(idx), altxMax(idx), timestampSeconds);
    altyMax = pchip( timestampSeconds(idx), altyMax(idx), timestampSeconds);
end
%
% gentle median smoothing -- removes sudden pops
% for ii = 2:length(xxMax)-1
%     xMax(ii) = median(xMax(ii-1:ii+1));
%     yMax(ii) = median(yMax(ii-1:ii+1));
%     
%     altxMax(ii) = median(altxMax(ii-1:ii+1));
%     altyMax(ii) = median(altyMax(ii-1:ii+1));
% end
%plot( (1:length(panelMiddle))./vidObj.FrameRate, xMax ); hold on; plot( (1:length(panelMiddle))./vidObj.FrameRate, yMax );
%
% mild Gaussian-ish smoothing
%
for ii = 3:length(xxMax)-2
    xMax(ii) = [ .05 .2 .5 .2 .05 ] * xMax(ii-2:ii+2)';
    yMax(ii) = [ .05 .2 .5 .2 .05 ] * yMax(ii-2:ii+2)';
    altxMax(ii) = [ .05 .2 .5 .2 .05 ] * altxMax(ii-2:ii+2)';
    altyMax(ii) = [ .05 .2 .5 .2 .05 ] * altyMax(ii-2:ii+2)';
end
figure; plot( xMax, yMax ); hold on; plot(altxMax,altyMax)


plot( (1:length(panelMiddle))./vidObj.FrameRate, xMax ); hold on; plot( (1:length(panelMiddle))./vidObj.FrameRate, yMax );

figure; plot( altxMax ); hold on; plot( altyMax ); plot(radius); plot(altMax); plot(altSpeed./4);

speed = calculateSpeed(xMax, yMax, 0.01, 1, vidObj.FrameRate);
figure; plot( (1:length(panelMiddle))./vidObj.FrameRate, xMax ); hold on; plot( (1:length(panelMiddle))./vidObj.FrameRate, yMax ); plot( (1:length(panelMiddle))./vidObj.FrameRate, speed );

altSpeed = calculateSpeed(altxMax, altyMax, 0.01, 1, vidObj.FrameRate);
figure; plot( altxMax ); hold on; plot( altyMax ); plot(radius); plot(altMax); plot(altSpeed./4);




figure; plot( xxMax, yyMax ); hold on; plot( xMax, yMax );

figure; plotColoredLine( xMax, yMax, maxVal )


figure; plot( xMax, yMax, 'Color', [ 0 0 0 .2 ] ); set(gca, 'YDir','reverse')

figure; scatter( xMax, yMax, 'k', 'filled'); alpha (.1); set(gca, 'YDir','reverse'); xlim([0 vidObj.Width ]); ylim([0 vidObj.Height ])

figure; 
hold off; imagesc(avgFrameRaw); colormap('bone'); hold on;
plot( xMax, yMax, 'Color', [ 0 .9 1 .1 ], 'LineWidth', 2 );
dotObj=scatter( xMax, yMax, 'filled', 'MarkerFaceColor', [ 1 .9 0 ], 'MarkerEdgeColor', 'none' ); 
alpha (dotObj,0.2); 
title('occupancy')
%set(gca, 'YDir','reverse');



hold off; imgHandle = imagesc(avgFrameRaw); hold on;
plotColoredLine( xMax, yMax, speed ); colormap(build_NOAA_colorgradient); colorbar;
colormap(imgHandle, 'bone');



%
% OUTPUT movie
%
cmap=build_NOAA_colorgradient(16);
figure; 
v = VideoWriter('~/Desktop/tracking.avi');
open(v);
for ii=20:length(allFrames)
    imagesc(allFrames(:,:,ii)); colormap('bone')
    hold on; plot( xMax(ii-15:ii), yMax(ii-15:ii), 'g', 'LineWidth', 1 ); scatter( xMax(ii-15:ii), yMax(ii-15:ii), (10:2:40), cmap, 'filled' ); 
    % this might work, but it would require using some other colormap and attaching it to the object.
    % I don't want to do that right now.
    % plotColoredLine( xMax(ii-15:ii), yMax(ii-15:ii), ([1:16])' );
    hold off; title(num2str(ii))
    % write video
    frameOut = getframe(gcf);
    writeVideo(v,frameOut);
    drawnow;
end



%
% SUBTRACTION METHOD
%
cmapDiff = [ colormap('jet') ; 0 0 0; flipud(colormap('jet')) ];
for ii=1000:5200 %1:length(allFrames)
    localDiff = int16(allFrames(:,:,ii))-int16(allFrames(:,:,ii-3));
    localDiff( 30:50, 1:280 ) = 0; 
    imagesc(localDiff); colormap(cmapDiff); colorbar;
    caxis([-max(abs(localDiff(:))) max(abs(localDiff(:)))])
    hold on; scatter( xMax(ii-15:ii), yMax(ii-15:ii), (10:2:40), cmap, 'filled' ); 
    plot( xMax(ii-15:ii), yMax(ii-15:ii), 'g' )
    hold off; title(num2str(ii))
    drawnow; pause(.01)
end

figure; imagesc(allFrames(:,:,ii))


figure; 
lastCornerData = [];
for ii=1000:5200 %1:length(allFrames)
    bgSubtracted = ((allFrames(:,:,ii)-uint8(avgFrameRaw)));
    bgSubtracted( 30:50, 1:280 ) = 0; 
    bgSubtracted(  510:531, 693:795 ) = 0;
    bgSubtracted = log2(single(bgSubtracted)+2);
    cornerData=corner(bgSubtracted,'MinimumEigenvalue');
    imagesc(bgSubtracted); colormap('bone');
    hold on; 
    if isempty(lastCornerData)
        plot(cornerData(:,1),cornerData(:,2),'r*');
    else
        % NOT USEFUL
%         ptPairs = []; curRow = 1;
%         for jj=1:length(lastCornerData)-1
%             lengths=sqrt(  (cornerData(:,1)-lastCornerData(jj,1)).^2 + (cornerData(:,2)-lastCornerData(jj,2)).^2 );
%             [ mnVal, mnIdx ] = min(lengths);
%             if ( mnVal > 5 ) && ( mnVal < 200 )
%                 ptPairs(curRow,1:2) = lastCornerData(jj,:);
%                 ptPairs(curRow,3:4) = cornerData(mnIdx,:);
%             end
%         end 
%         for jj=1:size(ptPairs,1)
%             plot( ptPairs(jj,[1 3]),ptPairs(jj,[2 4]),'r');
%             scatter( ptPairs(jj,3), ptPairs(jj,4), 'or' )
%         end
    end
    lastCornerData = cornerData;
    hold off; title(num2str(ii))
    drawnow;
end













%
% examine frames
%
figure; subplotidx=1;
for ii=4930:4949 %1:length(allFrames)
    subplot(4,5,subplotidx);
    %imagesc(allFrames(:,:,ii)); colormap('bone')
    bgSubtracted = single(((allFrames(:,:,ii)-uint8(avgFrameRaw))));
    %
    if rewardLight(ii) > 100  % yay magic numbers...    
        bgSubtracted( panels == 4 ) = 0;
    end
    % track the location of the brightest pixel in the chamber
    bgSubtracted( 30:50, 1:280 ) = 0;  % block out the time letters, which mess things up
    %
    imagesc(log2(bgSubtracted)); colormap('bone'); hold on;
%    hold on; scatter( xMax(ii-16:ii-1), yMax(ii-16:ii-1), (10:2:40), cmap, 'filled' ); 
    scatter( xMax(ii), yMax(ii), 45, 'c*' ); 
    plot( xMax(ii-2:ii), yMax(ii-2:ii), 'g' );
%
    [ tmxVal, mxIdx] = max( bgSubtracted(:) );
    [ yyMaxTemp xxMaxTemp ] = ind2sub( size(bgSubtracted), mxIdx(1) );
    scatter(xxMaxTemp, yyMaxTemp, 's')
    %
    subplotidx = subplotidx + 1;
end




cmap=build_NOAA_colorgradient(16);
figure; 
for ii=20:5200 %1:length(allFrames)
    imagesc(allFrames(:,:,ii)-allFrames(:,:,ii-)); colormap('bone')
    hold on; scatter( xMax(ii-15:ii), yMax(ii-15:ii), (10:2:40), cmap, 'filled' ); 
    plot( xxMax(ii-15:ii), yyMax(ii-15:ii), 'g' )
    hold off; title(num2str(ii))
    drawnow; pause(.01)
end







%visual check
figure; imagesc(panels); colormap('colorcube'); colorbar;




panels = uint8(panelsMask);
panels = floodFillBinary(  panelCoordinatesX(ii), panelCoordinatesY(ii), panels,10);


panelsMask




figure; subplot(1,2,1); imagesc((minFrameRaw>30)+(avgFrameRaw>100)); subplot(1,2,2); imagesc(panelsMask)






     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xyMaxCoords(1,rgbIdx,frameIdx) = xx(1);
     xyMaxCoords(2,rgbIdx,frameIdx) = yy(1);



[ mxVal, mxIdx] = max(bgSubtracted(:));
[mxIdxX mxIdxY] = ind2sub(size(bgSubtracted),mxIdx)







vidObj = VideoReader('~/src/DeepLabCut/test3-agh-2020-10-05/videos/RatTY4_Rev_CNO_092820DLC_resnet50_test3Oct5shuffle1_1000_bx_bp_labeled.mp4');
allFrames = read(vidObj);
   
   
   for rgbIdx = 3:3
     tempFrame=frame(:,:,rgbIdx);
     [maxVal, maxIdx ] = max(tempFrame(:));
     % just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
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

