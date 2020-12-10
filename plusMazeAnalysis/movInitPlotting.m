figure; plot(movInitBlob.goTrigSpeedStack', 'Color', [ 0 0 0 .1 ]);
figure; imagesc(movInitBlob.goTrigSpeedStack);
figure; imagesc(movInitBlob.stopTrigSpeedStack);
figure; plot(movInitBlob.stopTrigSpeedStack', 'Color', [ 0 0 0 .1 ]);


[B,I]=sort(mean(movInitBlob.goTrigSpeedStack(:,1:90),2));
motionStillSpeed=movInitBlob.goTrigSpeedStack(I,:);
motionSwrEvents=movInitBlob.goTrigSwrMag(I,:);


figure; histogram(motionSwrEvents(motionSwrEvents(:)>0))

figure;
subplot(1,2,1); imagesc(motionStillSpeed); colorbar;
subplot(1,2,2);  spy(motionSwrEvents>.1); 
figure; plot(sum(motionSwrEvents'>.1),1:length(motionSwrEvents))



