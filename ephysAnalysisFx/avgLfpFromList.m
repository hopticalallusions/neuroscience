function avgLfp = avgLfpFromList(dir, filelist)

for ii=1:length(filelist)
    temp = csc2mat([ dir filelist{ii} ]);
    if ii == 1
        accumulator = temp;
    else
        accumulator = accumulator + temp;
    end
end
avgLfp = accumulator/length(filelist);

return;














% % this function averages together a list of LFPs and tries to identify
% % certain kinds of events common to all channels.
% 
% %% build an average LFP
% 
% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-20_/';
% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% 
% % 
% filelist = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
% 
% [ lfp88, lfpTimestamps ] = csc2mat([ dir 'CSC88.ncs' ]);
% timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
% for ii=1:length(filelist)
%     temp = csc2mat([ dir filelist{ii} ]);
%     if ii == 1
%         accumulator = temp;
%     else
%         accumulator = accumulator + temp;
%     end
% end
% avgLfp = accumulator/length(filelist);
% clear accumulator temp
% 
% %% look for events in the average LFP
% 
% makeFilters;
% 
% % try to eliminate chews from SWR events
% 
% avgChew = filtfilt( filters.so.chew, avgLfp ); 
% sampleRate=32000;
% [ chewPeakValues, ...
%   chewPeakTimes, ...
%   chewPeakProminances, ...
%   chewPeakWidths ] = findpeaks(  (avgChew),                              ... % data
%                                 timestampSeconds,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
%                              'MinPeakHeight',   .04, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                              'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
% % swr
% swrLfp = filtfilt( filters.so.swr, lfp88 ); 
% sampleRate=32000;
% [ swrPeakValues, ...
%   swrPeakTimes, ...
%   swrPeakProminances, ...
%   swrPeakWidths ] = findpeaks(  (swrLfp),                              ... % data
%                                timestampSeconds,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %%%sampleRate,                                  ... % sampling frequency
%                              'MinPeakHeight',   std(swrLfp)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                              'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
% 
% figure;
% subplot(3,1,1); hold off; plot(timestampSeconds, avgChew); hold on; plot( chewPeakTimes, chewPeakValues, 'o' ); %xlim([ 831 836 ]); legend('avg lfp');
% subplot(3,1,2); hold off; plot(timestampSeconds, lfp88);   legend('lfp88(h.f.)'); %hold on; plot( peakTimes, peakValues, 'o' ); xlim([ 831 836 ]);
% subplot(3,1,3); hold off; plot(timestampSeconds, swrLfp); hold on; plot( swrPeakTimes, swrPeakValues, 'o' ); %xlim([ 831 836 ]); legend('swr band');
% 
% 
% subplot(3,1,1); xlim([ min(timestampSeconds) max(timestampSeconds) ] ); subplot(3,1,2); xlim([ min(timestampSeconds) max(timestampSeconds) ] );subplot(3,1,3); xlim([ min(timestampSeconds) max(timestampSeconds) ] );
% 
% 
% return;
% 
% idxs=[ round(831*sampleRate):round(836*sampleRate) ];
% figure; subplot(9,1,1); hold off; plot(timestampSeconds(idxs), lfp6(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp6(Rnac)'); %  xlim([ 831 836 ]); 
% subplot(9,1,2); hold off; plot(timestampSeconds(idxs), lfp12(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp12(Rhf)');
% subplot(9,1,3); hold off; plot(timestampSeconds(idxs), lfp16(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp16(Rhf)');
% subplot(9,1,4); hold off; plot(timestampSeconds(idxs), lfp36(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp36(Rhf)');
% subplot(9,1,5); hold off; plot(timestampSeconds(idxs), lfp46(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp46(vta)');
% subplot(9,1,6); hold off; plot(timestampSeconds(idxs), lfp61(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp61(Lhf)');
% subplot(9,1,7); hold off; plot(timestampSeconds(idxs), lfp64(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp64(Lhf)');
% subplot(9,1,8); hold off; plot(timestampSeconds(idxs), lfp76(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp76(Lhf)');
% subplot(9,1,9); hold off; plot(timestampSeconds(idxs), lfp88(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp88(Lhf)');
% 
% 
% return;
% 
% 
% 
% 
% 633.5 - 636
% 586
% 
% 61.2-29.4
% 
% idxs=round((584.5-31.8)*32000):round((587.5-31.8)*32000); [r,lags] = xcorr( avgChew(idxs)); figure; plot(lags,r)
% 
% 
% %% good at capturing chew events as an envelope-ish thing
% aChew=avgChew(idxs);
% aChewTimes=timestampSeconds(idxs);
% maxes=[];
% for ii=251:length(aChewTimes)-250
%     maxes(ii)=max(abs(aChew(ii-250:ii+250)));
% end
% figure; plot(aChew); hold on; plot(maxes);
% 
% 
% 
% 
% 
% avgChew = filtfilt( filters.so.chew, avgLfp ); 
% figure; plot(timestampSeconds, avgChew)
% sampleRate=32000;
% [ peakValues, ...
%   peakTimes, ...
%   peakProminances, ...
%   peakWidths ] = findpeaks(  (avgChew),                              ... % data
%                              sampleRate,                                  ... % sampling frequency
%                              'MinPeakHeight',   .04, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                              'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
% hold on; plot( peakTimes, peakValues, 'o' );
% 
% figure; [zz,xx]=hist(avgChew,200); plot(xx,zz);
% 
% %spectrogram(data,windowLength,overlap,dft pts, sampleRate, 'yaxis')
% %figure; spectrogram(avgChew,sampleRate/4,sampleRate/16,128,sampleRate,'yaxis')
% %not doing what I want; big power in 200-1kHz band, cant see low freq
% 
% 
% sampleRate = 32000; % samples/second
% windowSize = 2; % seconds
% jumpSize = 1.5 % seconds
% mvgAvg=[]; mvgStd=[]; mvgTt=[];
% for ii=1:round(sampleRate*jumpSize):length(avgChew)-round(windowSize*sampleRate)
%     mvgAvg = [ mvgAvg mean(avgChew(ii:ii+round(sampleRate*jumpSize))) ];
%     mvgStd = [ mvgStd std(avgChew(ii:ii+round(sampleRate*jumpSize))) ];
%     mvgTt  = [ mvgTt timestampSeconds(ii+round((sampleRate*jumpSize)/2)) ];
% end
%     
% 
% 
% 
% 
% 
% 
% %235:245
% 
% %239.41
% %239.31
% 
% %100 ms from peak to valley
% 
% winMax=[];
% tt=[];
% for ii=round(sampleRate*235):round(.1*sampleRate):round(sampleRate*245)
%     tt=[ tt ii/sampleRate ];
%     win=round(.025*sampleRate);
%     winMax=[ winMax max(avgChew(ii-win:ii+win)) ];
% end
% plot(tt,winMax)
% 
% 
% env=abs(hilbert(avgChew)); hold on; plot(timestampSeconds, env);
% 
% 
% avgSpindle = filtfilt( filters.so.nrem, moreLfp ); figure; plot(timestampSeconds, avgSpindle)
% env=abs(hilbert(avgSpindle)); hold on; plot(timestampSeconds, env);
% 