%vidObj = VideoReader('~/Downloads/RatTY4_Rev_CNO_092820.mp4');
vidObj = VideoReader('~/data/izquierdo/wyzeTest_JL14/raw/48.mp4');

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


figure; colormap('jet');
vidObj.CurrentTime = 0;
frame = mean(readFrame(vidObj),3);
pFrame = frame;
frame = mean(readFrame(vidObj),3);
ppFrame = pFrame;
while hasFrame(vidObj)
    frame = mean(readFrame(vidObj),3);
    meanSubtractedFrame = double(frame)-meanFrame;
    subplot(1,2,1); hold off; imagesc(meanSubtractedFrame); caxis([ -max(abs(meanSubtractedFrame(:))) max(abs(meanSubtractedFrame(:))) ]);
    hold on; 
    [ rr, cc, ~ ]=find( ( meanSubtractedFrame>prctile(meanSubtractedFrame(:),99)) + meanSubtractedFrame<prctile(meanSubtractedFrame(:),1) );
    scatter( median(cc), median(rr), 'r', 'sq', 'filled' );
    lastSubtractedFrame = double(frame) - ppFrame;
    subplot(1,2,2); imagesc(lastSubtractedFrame);  caxis([ -max(abs(lastSubtractedFrame(:))) max(abs(lastSubtractedFrame(:))) ]);
    drawnow;
    ppFrame = pFrame;
    pFrame = frame;
end


1000:end
1380:end