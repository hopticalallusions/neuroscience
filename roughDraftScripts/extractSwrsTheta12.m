
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
powerThresh = 1000;
timeThresh=32000 * 50 / 1000; % in data points 70 ms / 1000ms per second * 32000 sample per second = samples
swrTimes=zeros(10000,4);  % start, end, max
swrIdxs=find(csclfppower > powerThresh); 
startOfEpoch = -1;
swrTimesIdx = 1;
for idx=1:length(swrIdxs); 
    if startOfEpoch < 0 
        startOfEpoch = swrIdxs(idx);
    elseif swrIdxs(idx) - startOfEpoch > timeThresh
        swrTimes(swrTimesIdx,1) = startOfEpoch; % start
        if ( swrIdxs(idx) - startOfEpoch > 3*timeThresh )
            swrTimes(swrTimesIdx,2) = startOfEpoch + timeThresh*3;
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
            swrTimes(swrTimesIdx,4) = 100 + (( nlxCscTimestamps12(swrTimes(swrTimesIdx,1)) - nlxCscTimestamps12(1))/1e6);
        else
            swrTimes(swrTimesIdx,2) = swrIdxs(idx); % end of episode
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
            swrTimes(swrTimesIdx,4) = 100 + (( nlxCscTimestamps12(swrTimes(swrTimesIdx,1)) - nlxCscTimestamps12(1))/1e6);
        end
        swrTimesIdx = swrTimesIdx + 1;
        startOfEpoch = -1;
    end
    if swrTimesIdx > length(swrTimes)
        break
    end
end
swrTimes=swrTimes(1:swrTimesIdx,:);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day8csc17_thresh' num2str(powerThresh) '.mat'], 'swrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh),4); 
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day8csc17_thresh' num2str(powerThresh) '_nex.mat'], 'swrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*2),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day8csc17_thresh' num2str(powerThresh*2) '_nex.mat'], 'nexSwrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*4),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day8csc17_thresh' num2str(powerThresh*4) '_nex.mat'], 'nexSwrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*8),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day8csc17_thresh' num2str(powerThresh*8) '_nex.mat'], 'nexSwrTimes');



[ cscLFP12, nlxCscTimestamps12, cscHeader12, channel12, sampFreq12, nValSampt ] = csc2mat( '/Volumes/SILVRSURFER/theta12_day6-sharpwaves/CSC17.ncs' );

Fs = 32000;  % Sampling Frequency
N   = 20;   % Order
Fc1 = 110;  % First Cutoff Frequency
Fc2 = 240;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hdswr = design(h, 'butter');
cscLFP12=filter(Hdswr,cscLFP12);
csclfppower=abs(hilbert(cscLFP12));
powerThresh = 1000;
timeThresh=32000 * 50 / 1000; % in data points 70 ms / 1000ms per second * 32000 sample per second = samples
swrTimes=zeros(10000,4);  % start, end, max
swrIdxs=find(csclfppower > powerThresh); 
startOfEpoch = -1;
swrTimesIdx = 1;
for idx=1:length(swrIdxs); 
    if startOfEpoch < 0 
        startOfEpoch = swrIdxs(idx);
    elseif swrIdxs(idx) - startOfEpoch > timeThresh
        swrTimes(swrTimesIdx,1) = startOfEpoch; % start
        if ( swrIdxs(idx) - startOfEpoch > 3*timeThresh )
            swrTimes(swrTimesIdx,2) = startOfEpoch + timeThresh*3;
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
            swrTimes(swrTimesIdx,4) = 100 + (( nlxCscTimestamps12(swrTimes(swrTimesIdx,1)) - nlxCscTimestamps12(1))/1e6);
        else
            swrTimes(swrTimesIdx,2) = swrIdxs(idx); % end of episode
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
            swrTimes(swrTimesIdx,4) = 100 + (( nlxCscTimestamps12(swrTimes(swrTimesIdx,1)) - nlxCscTimestamps12(1))/1e6);
        end
        swrTimesIdx = swrTimesIdx + 1;
        startOfEpoch = -1;
    end
    if swrTimesIdx > length(swrTimes)
        break
    end
end
swrTimes=swrTimes(1:swrTimesIdx,:);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day6csc17_thresh' num2str(powerThresh) '.mat'], 'swrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh),4); 
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day6csc17_thresh' num2str(powerThresh) '_nex.mat'], 'swrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*2),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day6csc17_thresh' num2str(powerThresh*2) '_nex.mat'], 'nexSwrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*4),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day6csc17_thresh' num2str(powerThresh*4) '_nex.mat'], 'nexSwrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*8),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day6csc17_thresh' num2str(powerThresh*8) '_nex.mat'], 'nexSwrTimes');



[ cscLFP12, nlxCscTimestamps12, cscHeader12, channel12, sampFreq12, nValSampt ] = csc2mat( '/Volumes/SILVRSURFER/theta12_day7-sharpwaves/CSC17.ncs' );

Fs = 32000;  % Sampling Frequency
N   = 20;   % Order
Fc1 = 110;  % First Cutoff Frequency
Fc2 = 240;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hdswr = design(h, 'butter');
cscLFP12=filter(Hdswr,cscLFP12);
csclfppower=abs(hilbert(cscLFP12));
powerThresh = 1000;
timeThresh=32000 * 50 / 1000; % in data points 70 ms / 1000ms per second * 32000 sample per second = samples
swrTimes=zeros(10000,4);  % start, end, max
swrIdxs=find(csclfppower > powerThresh); 
startOfEpoch = -1;
swrTimesIdx = 1;
for idx=1:length(swrIdxs); 
    if startOfEpoch < 0 
        startOfEpoch = swrIdxs(idx);
    elseif swrIdxs(idx) - startOfEpoch > timeThresh
        swrTimes(swrTimesIdx,1) = startOfEpoch; % start
        if ( swrIdxs(idx) - startOfEpoch > 3*timeThresh )
            swrTimes(swrTimesIdx,2) = startOfEpoch + timeThresh*3;
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
            swrTimes(swrTimesIdx,4) = 100 + (( nlxCscTimestamps12(swrTimes(swrTimesIdx,1)) - nlxCscTimestamps12(1))/1e6);
        else
            swrTimes(swrTimesIdx,2) = swrIdxs(idx); % end of episode
            swrTimes(swrTimesIdx,3) = max(csclfppower(swrTimes(swrTimesIdx,1):swrTimes(swrTimesIdx,2)));
            swrTimes(swrTimesIdx,4) = 100 + (( nlxCscTimestamps12(swrTimes(swrTimesIdx,1)) - nlxCscTimestamps12(1))/1e6);
        end
        swrTimesIdx = swrTimesIdx + 1;
        startOfEpoch = -1;
    end
    if swrTimesIdx > length(swrTimes)
        break
    end
end
swrTimes=swrTimes(1:swrTimesIdx,:);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day7csc17_thresh' num2str(powerThresh) '.mat'], 'swrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh),4); 
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day7csc17_thresh' num2str(powerThresh) '_nex.mat'], 'swrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*2),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day7csc17_thresh' num2str(powerThresh*2) '_nex.mat'], 'nexSwrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*4),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day7csc17_thresh' num2str(powerThresh*4) '_nex.mat'], 'nexSwrTimes');
nexSwrTimes=swrTimes(find(swrTimes(:,3)>powerThresh*8),4);
save(['/Volumes/SILVRSURFER/theta12_day7-sharpwaves/swrTimes_theta12day7csc17_thresh' num2str(powerThresh*8) '_nex.mat'], 'nexSwrTimes');

% 
% figure;
% plot( cscLFP12( swrTimes(21,:)-10000:swrTimes(21,:)+10000 ), 'Color', [ .7 .7 .7 ] );
% hold on;
% plot( filter(Hdswr, cscLFP12(swrTimes(21,:)-10000:swrTimes(21,:)+10000)), 'Color', [ .1 .1 .8 ] );
% plot( csclfppower( swrTimes(21,:)-10000:swrTimes(21,:)+10000 ), 'r' );
% 
% 
% figure;
% subplot(5,1,1);
% plot( cscLFP12( swrTimes(21,:)-10000:swrTimes(21,:)+10000 ), 'Color', [ .7 .7 .7 ] );
% ylabel('bit-uV-ish');
% subplot(5,1,2);
% plot( filter(Hdswr, cscLFP12(swrTimes(21,:)-10000:swrTimes(21,:)+10000)), 'Color', [ .1 .1 .8 ] );
% ylabel('bit-uV-ish');
% subplot(5,1,3);
% plot( csclfppower( swrTimes(21,:)-10000:swrTimes(21,:)+10000 ), 'r' );
% ylabel('bit-uV-ish');
% subplot(5,1,4);
% plot( (ww(swrTimes(21,:)-10000:swrTimes(21,:)+10000 )+pi)*360/(2*pi), 'k' );
% ylabel('degrees');
% subplot(5,1,5);
% plot( Fs/(2*pi)*diff(unwrap(ww(swrTimes(21,:)-10000:swrTimes(21,:)+10000 )  ))) % diff(ww(swrTimes(21,:)-10000:swrTimes(21,:)+10000 )+pi)*360/(2*pi) );
% ylabel('Hz');
% 
% 
% 
% z = hilbert(y);
% instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));


