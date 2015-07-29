

windowSize=3200;
idealPeakCenter=round(windowSize/2);
idx = 1;
meanCscWindow=(zeros(windowSize,1));
iterations = 0;
while idx + windowSize < length(csc)
    % cut out a window of the data
    snip=csc(idx:idx+windowSize-1);
    % center on the max value
    mx=max(snip);
    mxRelativeIdx=find(mx==snip);
    mxRelativeIdx=mxRelativeIdx(1);
    newOffset = idealPeakCenter - mxRelativeIdx;
    idx = idx - newOffset;
    snip=csc(idx:idx+windowSize-1);
    meanCscWindow = (iterations*meanCscWindow + snip)/(iterations+1);
    iterations = iterations + 1;
    % close the loop
    idx = idx + windowSize;
end


idx = 1;
iterations = 0;
correctedCsc=csc;
while idx + windowSize < length(csc)
    % cut out a window of the data
    snip=correctedCsc(idx:idx+windowSize-1);
    % center on the max value
    mx=max(snip);
    mxRelativeIdx=find(mx==snip);
    mxRelativeIdx=mxRelativeIdx(1);
    newOffset = idealPeakCenter - mxRelativeIdx;
    idx = idx - newOffset;
    scalingFactor=(max(meanCscWindow)-min(meanCscWindow))/(max(snip)-min(snip));
    correctedCsc(idx:idx+windowSize-1) = correctedCsc(idx:idx+windowSize-1) - (meanCscWindow/scalingFactor);
    % close the loop
    idx = idx + windowSize;
end

break;



figure;
snip=csc(248987-1600:248987+1600-1);
scalingFactor=(max(smallMeanCscWindow)-min(smallMeanCscWindow))/(max(snip)-min(snip));
plot(snip,'b');
hold on; plot(smallMeanCscWindow/scalingFactor,':','Color',[.7 .7 .7] );
plot(snip-(smallMeanCscWindow/scalingFactor), 'g');
legend(['raw         '; 'scaledMean  '; 'rawCorrected'])

break;


windowSize=3200;
idealPeakCenter=round(windowSize/2);
idx = 1;
bigMeanCscWindow=(zeros(windowSize,1));
smallMeanCscWindow=(zeros(windowSize,1));
iterations = 0;
while idx + windowSize < length(csc)
    % cut out a window of the data
    snip=csc(idx:idx+windowSize-1);
    % center on the max value
    mx=max(snip);
    mxRelativeIdx=find(mx==snip);
    mxRelativeIdx=mxRelativeIdx(1);
    newOffset = idealPeakCenter - mxRelativeIdx;
    idx = idx - newOffset;
    snip=csc(idx:idx+windowSize-1);
    if mx > 8500
        bigMeanCscWindow = (iterations*bigMeanCscWindow + csc(idx:idx+windowSize-1))/(iterations+1);
    else
        smallMeanCscWindow = (iterations*smallMeanCscWindow + csc(idx:idx+windowSize-1))/(iterations+1);
    end
    iterations = iterations + 1;
    % close the loop
    idx = idx + windowSize;
end

figure;
plot(smallMeanCscWindow,'k');
hold on; 
plot(bigMeanCscWindow,'r');
%
scalingFactor=(max(smallMeanCscWindow)-min(smallMeanCscWindow))/(max(bigMeanCscWindow)-min(bigMeanCscWindow));
plot(smallMeanCscWindow*1/scalingFactor,'c','LineWidth',4);
plot(bigMeanCscWindow*scalingFactor,'Color', [.3 .95 .5],'LineWidth',4);
plot(smallMeanCscWindow,'k');
plot(bigMeanCscWindow,'r');
%
legend(['smMean';'bgMean';'smEnlg';'bgRedc'])
title('Scaling the mean noise trace');
ylabel('potential (\muV?)');
xlabel('time (data points)');


break;

windowSize=3200;
mxs=[];
mns=[];
xmxs=[];
xmns=[];
idealPeakCenter=round(windowSize/2);
idx = 1;
meanCscWindow=(zeros(windowSize,1));
range=(max(csc)-min(csc));
bins=250;
distYShift=round(1+abs(bins*min(csc)/range));
distro=zeros(bins+5,windowSize);
while idx + windowSize < length(csc)
    % cut out a window of the data
    snip=csc(idx:idx+windowSize-1);
    % find max and min value
    mx=max(snip);
    mn=min(snip);
    % find where these values lie in the snip of data
    mxRelativeIdx=find(mx==snip);
    mnRelativeIdx=find(mn==snip);
    % get only one value
    mxRelativeIdx=mxRelativeIdx(1);
    mnRelativeIdx=mnRelativeIdx(1);
    % 
    % find max and min value
    mxs=[mxs , mx(1) ];
    mns=[mns , mn(1) ];
    xmxs = [ xmxs ; mxRelativeIdx];
    xmns = [ xmns ; mnRelativeIdx];
    % get distribution
    newOffset = idealPeakCenter - mxRelativeIdx;
    idx = idx - newOffset;
    snip=csc(idx:idx+windowSize-1);
    temp=round(bins*snip/range)+distYShift;
    for hidx = 1:length(temp)
        distro(temp(hidx),hidx) = distro(temp(hidx),hidx) + 1;
    end
    idx = idx + windowSize;
end
figure;
colormap('default');
cmap=colormap;
cmap=[1 1 1 ; cmap ];
colormap(cmap);
imagesc(distro);
colorbar;




figure;
plot(mns,mxs)
title('min vs. max values');
ylabel('min value');
xlabel('max value');


figure;
mnsRange=(max(mns)-min(mns));
mxsRange=(max(mxs)-min(mxs));
bins=257;
hmns=round((bins-1)*(mns-min(mns))/mnsRange)+1;
hmxs=round((bins-1)*(mxs-min(mxs))/mxsRange)+1;
distro=zeros(bins,bins);
for idx=1:length(hmns)
    distro(hmns(idx),hmxs(idx)) = distro(hmns(idx),hmxs(idx)) + 1;
end
colormap('default');
cmap=colormap;
cmap=[1 1 1 ; cmap ];
colormap(cmap);
%flip because it's now mirrored over the Y axis for the negative (min)
%values
imagesc(fliplr(distro));
colorbar;
title('distribution of min vs. max values');
ylabel('min value (rescaled)');
xlabel('max value (rescaled)');









