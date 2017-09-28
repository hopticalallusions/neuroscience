[ cscLFP12, nlxCscTimestamps12, cscHeader12, channel12, sampFreq12, nValSampt ] = csc2mat( '/Volumes/SILVRSURFER/theta12_day6-sharpwaves/CSC17.ncs' );

[ cscLFP12, nlxCscTimestamps12, cscHeader12, channel12, sampFreq12, nValSampt ] = csc2mat( '/Volumes/SILVRSURFER/theta12_day7-sharpwaves/CSC17.ncs' );

[ cscLFP12, nlxCscTimestamps12, cscHeader12, channel12, sampFreq12, nValSampt ] = csc2mat( '/Volumes/SILVRSURFER/theta12_day8-sharpwaves/CSC17.ncs' );

Fs = 32000;  % Sampling Frequency
N   = 20;   % Order
Fc1 = 110;  % First Cutoff Frequency
Fc2 = 240;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hdswr = design(h, 'butter');
cscLFP12=filter(Hdswr,cscLFP12);
csclfppower=abs(hilbert(cscLFP12));





max(cscLFP12)
find(cscLFP12==max(cscLFP12))
figure; plot(cscLFP12(53589957-10000:53589957+10000))
cscLFP12=filter(Hdswr,cscLFP12);
max(cscLFP12)
find(cscLFP12==max(cscLFP12))
plot(cscLFP12(53590513-10000:53590513+10000))


exampleSwrSignal=filter(Hdswr, theta12swr16(19910133-50000:19910133+200000)); % this magic number came from finding the max of the whole trace.
exampleSwrSignalTime=(1:length(exampleSwrSignal))/32000;
figure;
subplot(2,1,1);
plot(exampleSwrSignalTime , theta12swr16(19910133-50000:19910133+200000), 'Color', [ .7 .7 .7 ]);
subplot(2,1,2);
plot(exampleSwrSignalTime, exampleSwrSignal, 'b')



cscLFP12=filter(Hdswr,cscLFP12);

70 ms 

70/1000 = x/32000


timeThresh=32000 * 50 / 1000; % in data points 70 ms / 1000ms per second * 32000 sample per second = samples
swrTimes=zeros(10000,3);  % start, end, max
swrIdxs=find(csclfppower>1000); 
startOfEpoch = -1;
swrTimesIdx = 1;
for idx=1:length(swrIdxs); 
    if startOfEpoch < 0 
        startOfEpoch = swrIdxs(idx);
    elseif swrIdxs(idx) - startOfEpoch > timeThresh
        swrTimes(swrTimesIdx,1) = startOfEpoch; % start
        if ( swrIdxs(idx) - startOfEpoch > 3*timeThresh )
            swrTimes(swrTimesIdx,2) = startOfEpoch + timeThresh*3;
        else
            swrTimes(swrTimesIdx,2) = swrIdxs(idx); % end of episode
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
        end
        swrTimesIdx = swrTimesIdx + 1;
        startOfEpoch = -1;
    end
    if swrTimesIdx > length(swrTimes)
        break
    end
end
disp(num2str(swrTimesIdx))
disp(max(csclfppower))
save('/Volumes/SILVERSURFER/' ,'


figure; ids=round(swrTimes(1,1)-10000):round(swrTimes(1,2)+15000); plot(cscLFP12(ids)); hold on; plot(csclfppower(ids),'r')
% to look
figure; 
for ii=1:200
    ids=round(swrTimes(ii,1)-10000):round(swrTimes(ii,1)+15000);
    plot((1:length(ids))/3200, cscLFP12(ids)); 
    hold on; 
    plot((1:length(ids))/3200,csclfppower(ids),'r'); 
    pause(4); 
    hold off;
end

'/z/Theta_sessions/theta12/day8/'

labTimeSpaceSWRs=100+((nlxCscTimestamps12(swrTimes(1:200,1))-nlxCscTimestamps12(1))/1e6);


tic;imf=emd_n(bigMessy(5133000:5153600),10);toc;figure; subplot(6,4,[1 2]); plot(bigMessy(1:10000),'g'); subplot(6,4,[3 4]); plot(imf(1,:), 'r'); subplot(6,4,[5 6]); plot(imf(2,:)); subplot(6,4,[7 8]);plot(imf(3,:), 'r');subplot(6,4,[9 10]);plot(imf(4,:));subplot(6,4,[11 12]);plot(imf(5,:), 'r');subplot(6,4,[13 14]);plot(imf(6,:));subplot(6,4,[15 16]);plot(imf(7,:), 'r');subplot(6,4,[17 18]);plot(imf(8,:));subplot(6,4,[19 20]);plot(imf(9,:), 'r');subplot(6,4,[21 22]);plot(imf(10,:));


% empirical mode decomposition

daRaw=load([basedir '/fscv/platter/Stacked_Cal']);
daRaw=daRaw(:,2:end);
daRaw=daRaw(:);
tic;imf=emd(daRaw(1:600*5));toc;
figure; 
plotRows=numel(imf)/length(imf);
for rowIdx=1:plotRows
    subplot(ceil(plotRows/2),2,rowIdx);
    plot((1:length(imf))/600,imf(rowIdx,:), 'Color', .1+(rand(1,3)*.8) );
end



tic;imf=emd(daConc(1:2400));toc;
tic;imf=emd_n(daConc(1:2400),10);toc;
figure;
subplot(6,4,[1 2]); plot(daConc(1:2400),'g'); subplot(6,4,[3 4]); plot(imf(1,:), 'r'); 
subplot(6,4,[5 6]); plot(imf(2,:)); subplot(6,4,[7 8]);plot(imf(3,:), 'r');
subplot(6,4,[9 10]);plot(imf(4,:));subplot(6,4,[11 12]);plot(imf(5,:), 'r');
subplot(6,4,[13 14]);plot(imf(6,:));subplot(6,4,[15 16]);plot(imf(7,:), 'r');
subplot(6,4,[17 18]);plot(imf(8,:));subplot(6,4,[19 20]);plot(imf(9,:), 'r');
subplot(6,4,[21 22]);plot(imf(10,:));

