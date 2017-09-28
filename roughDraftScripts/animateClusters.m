figure;
for where=1:30
    
    [aa]=ntt2mat('/Users/andrewhowe/Downloads/TT4.ntt', 1+(1000*(where-1)), where*1000);

    hold off;
    for id=1:447; 
        subplot(2,2,1); 
        hold on; 
        ur=[ max(aa(id,1,:)) max(aa(id,2,:)) ]; 
        plot(ur(1),ur(2),'.'); 
        subplot(2,2,2); 
        hold on; ur=[ max(aa(id,3,:)) max(aa(id,4,:)) ]; 
        plot(ur(1),ur(2),'.'); subplot(2,2,3); 
        hold on; ur=[ min(aa(id,1,:)) min(aa(id,2,:)) ]; 
        plot(ur(1),ur(2),'.'); subplot(2,2,4); 
        hold on; ur=[ min(aa(id,3,:)) min(aa(id,4,:)) ]; 
        plot(ur(1),ur(2),'.'); 
    end;
    drawnow;
end






figure;
temp=aa(530,2,:);
temp=temp(:);
subplot(3,1,1);
plot(temp);
hold on;
plot(diff(temp));
plot(diff(diff(temp)));
plot(cumsum(temp));
subplot(3,1,2);
plot(temp);
hold on;
plot(find(temp==max(temp)),max(temp),'o');
plot(find(temp==min(temp)),min(temp),'o');
%plot(find(temp==min(temp)),min(temp),'o');
subplot(3,1,3);
plot(temp);
hold on;
line([ 0 32 ],[mean(temp) mean(temp)])
line([ 0 32 ],[median(temp) median(temp)])





threshold = 2000; % currently arbitrary
absoluteRefractorySamples = 32; % how many sample will we wait before accepting another super threshold crossing?
%thresholdExceededIdxs = find(correctedCsc(1:20000) > threshold); % demo
thresholdExceededIdxs = find(correctedCsc > threshold);
thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
spikesSeven=zeros(48,length(putativeSpikeIdxs));
for spikesIdx = 1:length(putativeSpikeIdxs)
    spikesSeven(:,spikesIdx) = correctedCsc(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
end
goodSpikeIdxs=thresholdExceededIdxs(thresholdExceededIdxStarts(find(metrics.group)));
sevenSpikeTimes=( (nlxCscTimestamps(goodSpikeIdxs)-nlxCscTimestamps(1)))/1e6; %seconds
spikeBins=zeros(1,ceil((max(nlxCscTimestampseighteen)-nlxCscTimestampseighteen(1))/1e6));
for idx=1:length(spikeBins)
    spikeBins(idx)=sum((sevenSpikeTimes<idx+1).*(sevenSpikeTimes>=idx-1));
end


figure; plot(spikesSeven); %debugging

thresholdExceededIdxs = find(correctedCscfortyfour > threshold);
thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
spikesFortyfour=zeros(48,length(putativeSpikeIdxs));
for spikesIdx = 1:length(putativeSpikeIdxs)
    spikesFortyfour(:,spikesIdx) = correctedCscfortyfour(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
end
figure; plot(spikesFortyfour); %debugging
size(spikesFortyfour)
figure; plot(mean(spikesSeven'))
figure; plot(diff(spikesSeven(:,1)))

peakIdxsFortyFour=peakDetector(correctedCscfortyfour,2000,32,1);




%% Frequency Domain Analysis
% http://www.gaussianwaves.com/2011/01/fft-and-spectral-leakage-2/
Fs=32000; %Sampling Frequency
x=temp; 
%Perform FFT
NFFX=2.^(ceil(log(length(x))/log(2)));
FFTX=fft(x,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(x);
f1=(0:NumUniquePts-1)*Fs/NFFX;
% MY contains the frequency peaks
figure;
stem(f1,MY,'k');
title('FFT of the signal');xlabel('Frequency');ylabel('Amplitude');





Fs=32000; %Sampling Frequency
x=temp; 
%Perform FFT
NFFX=2.^(ceil(log(length(x))/log(2)));
FFTX=fft(x,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(x);
f1=(0:NumUniquePts-1)*Fs/NFFX;
% MY contains the frequency peaks
figure;
stem(f1,MY,'k');
title('FFT of the signal');xlabel('Frequency');ylabel('Amplitude');
