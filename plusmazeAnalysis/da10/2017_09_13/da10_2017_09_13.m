clear all; close all;
figure; 

%% weirdness
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% This day has a weird gap in the LFP datafrom ~29.392 seconds to ~61.09 
% (so ~31.7 seconds long). It isn't devoid of points, but it looks like the
% clock gets ahead of itself or many data points are lost. If one uses the 
% first and last timestamp to calculate the elapsed time in the trial, one 
% gets max(timestampSeconds)/60 = 54.5870 minutes. The video is 53:34 in
% duration. There is another video that is 29 seconds long which has a
% modification date prior to this one. I think that we must have recorded,
% then stopped recording and started recording again. (There are still
% about 520 ms missing...) So basically, using the video timestamps would
% actually be wrong in this case without adjusting all the times.
%
% so adjust all the times by 62 seconds
% 
% there is some weirdness at about 2500 seconds (or 41:40 LFP time/ 40:38
% video time). I am not entirely certain what causes this. The rat is up in
% the air flying around in the bucket. It seems like his head wobbles
% around at a pace maybe similar to the oscillation in the EEG? Not really
% certain.



%% parameters to analysis
% 
% startIdx
% endIdx
% yLims
% 
% lfpList
% % can do it with numbers for the channels and we can then use those as indexes to parameters
% lfpsActive
%     average
%     NAC
%     hf
%     vta
%     for60HzDetection
%     
% can 


%function avgLfpFromList


% this function averages together a list of LFPs and tries to identify
% certain kinds of events common to all channels.

%% build an average LFP
visualizeAll=true;

sampleRate=32000;

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% FOR THIS PARTICULAR DAY, SKIP THE INTRODUCTION
lfpStartIdx = 1954981;   % round(61.09316*32000);
% 
fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
avgLfp=avgLfpFromList( dir, fileListGoodLfp, lfpStartIdx );  % build average LFP

fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
avgDisconnectedLfp=avgLfpFromList( dir, fileListDisconnectedLfp, lfpStartIdx );  % build average LFP

% load a good SWR file
% TODO (this one eventually has SWR, but check the turn log)
[ lfp88, lfpTimestamps ] = csc2mat( [ dir 'CSC88.ncs' ], lfpStartIdx );
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

makeFilters;

%% look for events in the average LFP
% auto-detect chews to differentiate from potential SWR events
avgChew = filtfilt( filters.so.chew, avgLfp );

% chewing creates little Crunchs of ~100 ms of ~100-1000 Hz noise where the
% Crunchs occur with a frequency around 3-6 Hz. They are stereotypical and 
% obvious to the ear and eye (eye w/ proper filtering), and should 
% therefore be detectable with an algorithm.
%
% Several strategies could be employed to detect these.
%     Wavelets -- slow, so not explored
%     Crunch detection -- see below
%     filtering for low freq. -- didn't work well
%     filtering the high-resolution envelope -- too sensitive to signal
%     autocorrelation -- could work, but not developed (see below)
%
% The strategy employed here involves a "max filter" to concoct a
% psuedo-envelope from the filtered raw average data. The max filter
% follows the contours of the "chew packets" more smoothly than the
% analytical signal derived envelope. (The envelope has a fairly high
% component of higher-freqnuencies which makes it look messy over the 
% signal.) The "max filter" also downsamples the signal, making some
% subsequent analysis faster.
%
% After Max Filtering, the signal has a strong low frequency component
% which can be filtered in the "chew Crunch" band of around 3-6 Hz. The
% envelope of this signal produces a satisfying hill over the duration of
% the chewing.
%
% This signal is suitable for peak detection, and then descent down the 
% sides of the peak to 10-15% of the peak value provides nice boundaries
% around the chewing event.
%
% This technique still suffers from confounds with the bruxing, but
% applying the same approach on a brux filtered envelope of the max filter
% should work to ID these bruxing episodes. Then the chewing and bruxing
% can be separated from each other.
%
% This is all sufficiently complex that it would be wise to provide a
% compelling visualization of the output in every case to convince the user
% that the analysis succeeded.
%
% Potentially useful references :
%
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4731741/  Fig. 3
%    this article shows how humans can learn to detect meaningless rhythmic
%    noise in other noise; suggests a digital signal processing technique
%    called the "modulation spectrum", which involves mapping the signal
%    onto a cochleogram (spectrogram) and then the "modulation spectrum"
%   refs both :
%      http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%      http://www.auditoryneuroscience.com/patternsinnoise
%
% Lecture : "Periodicity Detection, Time-series Correlation, Crunch Detection"
% http://www.l3s.de/~anand/tir14/lectures/ws14-tir-foundations-2.pdf
% Avishek Anand
%
% 
% -- Autocorrelation Approach --
%
% Autocorrelating a chew episode with itself produces an autocorrelogram
% with an obvious undulation to its profile. However, I think one would
% have to go along autocorrelating small, overlapping blocks to construct a
% psuedo-signal of low frequency oscillation as detected by
% autocorrelation. Not sure how efficient this would be.




% =====================
% == DETECT ELECTRIC ==
% =====================
%
% the baseline of the rat's 60 hz is correlated with the distance from the
% light. in the bucket is usually best, but the baseline subtely depends on
% where the bucket is. on the maze, his 60 hz is lowest in the center.
% Spikes occur when I touch the rat or the wire.
electricLFP=filtfilt( filters.so.electric, avgDisconnectedLfp );
electricEnv=abs(hilbert(electricLFP));
% ** running this particular call will attempt to find the edges of the
% plateaus; it does this by requiring a long period of time at a low value
% but it never quite worked the way I wanted it too. a very long (10
% seconds? 30 s? of low value might help, as the rat is in the low state
% for at least 1-2 minutes between trials
% electricDetectorOutput = detectPeaksEdges( electricEnv, timestampSeconds, sampleRate );
%
% ** call this to try to detect just the sharp, tall peaks
electricDetectorOutput = detectPeaksEdges( electricEnv, timestampSeconds, sampleRate, round(sampleRate/10) );
%% this will plot outputs from peakEdges  %%%%%%%%
% detect peaks on the Max Enveloped signal
figure(1);
subplot(7,1,1);
hold off;
plot(timestampSeconds,electricEnv); hold on; 
scatter( electricDetectorOutput.EpisodePeakTimes, electricDetectorOutput.EpisodePeakValues, 'v', 'filled');
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
for jj=1:length(electricDetectorOutput.EpisodeEndIdxs);
   if  electricDetectorOutput.EpisodeStartIdxs(jj) > 0
       scatter( timestampSeconds( electricDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( timestampSeconds( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
   if  electricDetectorOutput.EpisodeEndIdxs(jj) < length(timestampSeconds)
       scatter( timestampSeconds(  electricDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( timestampSeconds( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end
ylabel('elec.'); 
xlim([0 timestampSeconds(end)]); 
ylim([-0.001 max(electricDetectorOutput.EpisodePeakValues)]);

%
%
[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, timestampSeconds );
%
%
% == DETECT PEAKS OF CHEWING EPISODES ==
filters.ao.nomnom    = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux    = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%filters.ao.nombrux    = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
% VISUALIZE
%figure; hold on; plot(chewEnvTimes,temp); plot(chewEnvTimes, abs(hilbert(temp)));  temp=filtfilt( filters.ao.brux, chewEnv ); plot(chewEnvTimes, abs(hilbert(temp))); 
%
%
% detect peaks on the Max Enveloped signal
% ====================
% == DETECT CHEWING ==
% ====================
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));
chewDetectorOutput = detectPeaksEdges( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );
figure(1);
subplot(7,1,2);
hold off; 
plot(chewCrunchEnvTimes,chewEpisodeEnv); hold on; 
scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, '*'); %, 'filled');
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
for jj=1:length(chewDetectorOutput.EpisodeEndIdxs);
   if  chewDetectorOutput.EpisodeStartIdxs(jj) > 0
       scatter( chewCrunchEnvTimes( chewDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
   if  chewDetectorOutput.EpisodeEndIdxs(jj) < length(timestampSeconds)
       scatter( chewCrunchEnvTimes(  chewDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end
ylabel('chew/brx'); 
xlim([0 timestampSeconds(end)]); 
ylim([-0.001 max(chewDetectorOutput.EpisodePeakValues)]);


% ====================
% == DETECT BRUXING ==
% ====================
bruxEpisodeLFP=filtfilt( filters.ao.brux, chewCrunchEnv );
bruxEpisodeEnv=abs(hilbert(bruxEpisodeLFP));
bruxDetectorOutput = detectPeaksEdges( bruxEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );
%% this will plot outputs from peakEdges  %%%%%%%%
% detect peaks on the Max Enveloped signal
figure(1);
subplot(7,1,2);
hold on; 
plot( chewCrunchEnvTimes, bruxEpisodeEnv );
scatter( bruxDetectorOutput.EpisodePeakTimes, bruxDetectorOutput.EpisodePeakValues, 'v', 'filled');
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
for jj=1:length(bruxDetectorOutput.EpisodeEndIdxs);
   if  bruxDetectorOutput.EpisodeStartIdxs(jj) > 0
       scatter( chewCrunchEnvTimes( bruxDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
   if  bruxDetectorOutput.EpisodeEndIdxs(jj) < length(chewCrunchEnvTimes)
       scatter( chewCrunchEnvTimes(  bruxDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end
ylabel('chew/brx'); 
xlim([0 timestampSeconds(end)]); 
%ylim([-0.001 max(bruxDetectorOutput.EpisodePeakValues)]);


% =====================
% ==  SWR -- LFP 88  ==
% =====================
swrLfp88 = filtfilt( filters.so.swr, lfp88 );
swrLfp88Env = abs( hilbert(swrLfp88) );
[ swrPeakValues, ...
  swrPeakTimes, ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks(  swrLfp88Env,                              ... % data
                             timestampSeconds,                                  ... % sampling frequency
                             'MinPeakHeight',   std(swrLfp88Env)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% ** DISPLAY SWR **
figure(1);
subplot(7,1,3); 
hold on;                 
plot( timestampSeconds, swrLfp88 ); 
%scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
ylabel('SWR_{88}'); xlim([0 timestampSeconds(end)]); ylim([-0.001 max(swrPeakValues)]);


% =====================
% == DETECT LIA      ==
% =====================
liaLFP=filtfilt( filters.so.lia, lfp88 );
liaEnv=abs(hilbert(liaLFP));
%liaDetectorOutput = detectPeaksEdges( liaEnv, timestampSeconds, sampleRate );
%% this will plot outputs from peakEdges  %%%%%%%%
[ liaPeakValues,      ...
  liaPeakTimes,       ...
  liaPeakProminances, ...
  liaPeakWidths       ] = findpeaks( liaEnv,                             ... % data
                                     timestampSeconds ,                  ... % sampling frequency
                                     'MinPeakHeight'  ,   std(liaEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                     'MinPeakDistance', 0.5  );              % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
%scatter( liaPeakTimes, liaPeakValues, 'v', 'filled');

% ** DISPLAY LIA  **
figure(1);
subplot(7,1,4);
hold on; 
plot( timestampSeconds, liaEnv );
ylabel('LIA_{88}'); 
xlim([0 timestampSeconds(end)]); 
ylim([-0.001 max(liaPeakValues)]);


% ** DISPLAY AVGLFP  **
swrAvgLfp = filtfilt( filters.so.swr, avgLfp );
figure(1);
subplot(7,1,5); 
hold off;
plot( timestampSeconds, swrAvgLfp ); % or avgChew; not sure which yet
ylabel('avgLfp_{SWR}'); 
xlim([0 timestampSeconds(end)]); 
ylim([ min(swrAvgLfp(sampleRate*5:end-sampleRate*5)) max(swrAvgLfp(sampleRate*5:end-sampleRate*5)) ]);


% =====================
% ==   DETECT SWS    ==
% =====================
swsLFP=filtfilt( filters.so.nrem, avgLfp );
swsEnv=abs(hilbert(swsLFP));
%swsDetectorOutput = detectPeaksEdges( swsEnv, timestampSeconds, sampleRate );
[ swsPeakValues,      ...
  swsPeakTimes,       ...
  swsPeakProminances, ...
  swsPeakWidths       ] = findpeaks(  swsEnv,                           ... % data
                                      timestampSeconds,                 ... % sampling frequency
                                      'MinPeakHeight',   std(swsEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                      'MinPeakDistance', 0.5  );            % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% ** DISPLAY SWS  **
% figure(2);
% subplot(7,1,5); 
% hold on; 
% plot( timestampSeconds, swsLFP ); plot( timestampSeconds, swsEnv );
% scatter( swsPeakTimes, swsPeakValues, 'v', 'filled');
% ylabel('SWS'); xlim([0 timestampSeconds(end)]); ylim([-0.001 max(swsPeakValues)]);


% =====================
% ==     THETA       ==
% =====================
% Doesn't look very meaningful.
% theta = filtfilt( filters.so.theta, avgLfp );
% thetaEnv=abs(hilbert(theta));
% ** DISPLAY THETA  **
% figure(2);
% subplot(7,1,6); 
% plot( timestampSeconds, thetaEnv )
% ylabel('\Theta'); 
% xlim([0 timestampSeconds(end)]); 
% ylim([-0.001 max(thetaEnv(sampleRate:end-sampleRate))]);




% =====================
% ==    VELOCITY     ==
% =====================
% velocity is difficult to look at because during bucket time, the system
% inappropriately teleports the rat. Fixing this will probably involve
% giving analysis code some kind of knowledge about when the rat is in the
% bucket vs on the maze.
% Ideas to define trial states :
%       manually input all the times
%       try to use electric baseline & jumps
%       try to use proximity -- these should be smooth-ish and shouldn't
%            oscillate sharply between two locations no matter how long
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(xytimestamps-lfpTimestamps(1)));
xpos=nlxPositionFixer(xpos(xyStartIdx:end)); 
ypos=nlxPositionFixer(ypos(xyStartIdx:end));
xytimestamps=xytimestamps(xyStartIdx:end);
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
% ** DISPLAY VELOCITY **
% figure(2);
% subplot(7,1,7);
% plot( xytimestampSeconds, speed );
% ylabel('speed'); 
% xlim([0 timestampSeconds(end)]); 
% ylim([0 max(speed)]);


% ==============================
% ==  PROXIMITY TO LANDMARKS  ==
% ==============================
proxToCenter=proxToPoint( xpos, ypos, 317, 229 );
proxToStart=proxToPoint( xpos, ypos, 81, 412 );
proxToRewardSite=proxToPoint( xpos, ypos, 119, 45 );
proxToIncorrectSite=proxToPoint( xpos, ypos, 525, 429 );
figure(1);
subplot(7,1,7);
hold on; 
plot( xytimestampSeconds, proxToStart); 
plot( xytimestampSeconds, proxToCenter); 
plot( xytimestampSeconds, proxToIncorrectSite); 
plot( xytimestampSeconds, proxToRewardSite); 
ylabel('prox'); 
xlim([0 timestampSeconds(end)]); 
ylim([0 1]);


% ==========================================
% ==    COUNT SWR, EXCLUDE CHEW/BRUX      ==
% ==========================================
%
% subtract each peak time and eliminate those within 1 s of the peak on
% either side
%
swrPeakTimesDenoise=swrPeakTimes;
swrPeakValuesDenoise=swrPeakValues;
for ii=1:length(chewDetectorOutput.EpisodePeakTimes)
    idx = find( ( swrPeakTimesDenoise > chewCrunchEnvTimes(chewDetectorOutput.EpisodeStartIdxs(ii)) ) .* ( swrPeakTimesDenoise < chewCrunchEnvTimes(chewDetectorOutput.EpisodeEndIdxs(ii)) ) );
    swrPeakTimesDenoise(idx)=NaN;
    swrPeakValuesDenoise(idx)=NaN;
end
for ii=1:length(bruxDetectorOutput.EpisodePeakTimes)
    idx = find( ( swrPeakTimesDenoise > chewCrunchEnvTimes(bruxDetectorOutput.EpisodeStartIdxs(ii)) ) & ( swrPeakTimesDenoise < chewCrunchEnvTimes(bruxDetectorOutput.EpisodeEndIdxs(ii)) ) );
    swrPeakTimesDenoise(idx)=NaN;
    swrPeakValuesDenoise(idx)=NaN;
    %swrPeakTimesDenoise(find(abs(swrPeakTimesDenoise-bruxDetectorOutput.EpisodePeakTimes(ii))<1))=[];
end
for ii=1:length(electricDetectorOutput.EpisodePeakTimes)
    idx = find(abs(swrPeakTimesDenoise-electricDetectorOutput.EpisodePeakTimes(ii))<1);
    swrPeakTimesDenoise(idx)=NaN;
    swrPeakValuesDenoise(idx)=NaN;
end
swrPeakTimesDenoise(isnan(swrPeakTimesDenoise))=[];
swrPeakValuesDenoise(isnan(swrPeakValuesDenoise))=[];
roughEdges = sort([ electricDetectorOutput.EpisodePeakTimes' 2318 2616 2781 3000]);
counts = histcounts( swrPeakTimesDenoise, roughEdges);
xx=roughEdges(1:end-1)+diff(roughEdges)/2;
yy=counts./diff(roughEdges); % over time
figure(1);
subplot(7,1,1); 
hold on; 
plot( xx, yy*0.05, 'x-' );

figure(1);
subplot(7,1,3);
scatter( swrPeakTimesDenoise, swrPeakValuesDenoise, 'v', 'filled');

%xlimits=[ 450 500 ]; subplot(7,1,1); xlim(xlimits); subplot(7,1,2); xlim(xlimits); subplot(7,1,3); xlim(xlimits); subplot(7,1,4); xlim(xlimits);



% ========================
% ==  SWR Instant Rate  ==
% ========================
subplot(7,1,6);
swrRate = 1./diff(swrPeakTimesDenoise);
plot( swrPeakTimesDenoise(1:end-1)+(diff(swrPeakTimesDenoise)/2), swrRate )
ylabel('SWR_{rate}'); 
xlim([0 timestampSeconds(end)]); 
ylim([-0.001 max(swrRate)]);



return;
% =============
% ==   END   ==
% =============



%% zoom x axis manually

xlimits=[ 300 500 ]; 
for ii=1:7
    subplot(7,1,ii);
    xlim(xlimits);
end

%subplot(7,1,1); xlim(xlimits); subplot(7,1,2); xlim(xlimits); subplot(7,1,3); xlim(xlimits); subplot(7,1,4); xlim(xlimits);




%%




filters.ao.slow    = designfilt( 'bandpassiir', 'StopbandFrequency1', .1, 'PassbandFrequency1',  .3, 'PassbandFrequency2',    3, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 4, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
slow = filtfilt( filters.ao.slow, lfp88 );
figure; plot(timestampSeconds, lfp88); hold on; plot(timestampSeconds, slow)



theta = filtfilt( filters.ao.theta, avgLfp );
figure; plot(timestampSeconds, theta)



figure; 
subplot(5,1,1); plot( timestampSeconds, swrLfp88 ); axis tight; ylabel('ch88_{SWR}');
hold on;     scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
subplot(5,1,2); plot( timestampSeconds, lfp88 ); axis tight; ylabel('ch88');
subplot(5,1,3); plot( timestampSeconds, avgLfp ); axis tight; ylabel('avgLfp');




















% NOTE visualize the situation
if visualizeAll
%    subplot(4,1,3); hold on; 
%    plot( timestampSeconds, avgChew); plot(chewCrunchEnvTimes, chewCrunchEnv);
%    subplot(2,1,2); spectrogram(chewCrunchEnv,80,20,128,chewEnvSampleRate,'yaxis');
end
% the Crunchs are pretty clear in the spectrogram, and would become more
% obvious in the modulogram I guess (see above).





%% auto-detect chews to differentiate from potential SWR events
swrLfp88 = filtfilt( filters.so.swr, lfp88 );
swrLfp88Env = abs( hilbert(swrLfp88) );
[ swrPeakValues, ...
  swrPeakTimes, ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks(  swrLfp88Env,                              ... % data
                             timestampSeconds,                                  ... % sampling frequency
                             'MinPeakHeight',   std(swrLfp88Env)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


figure; 
subplot(5,1,1); plot( timestampSeconds, swrLfp88 ); axis tight; ylabel('ch88_{SWR}');
hold on;     scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
subplot(5,1,2); plot( timestampSeconds, lfp88 ); axis tight; ylabel('ch88');
subplot(5,1,3); plot( timestampSeconds, avgLfp ); axis tight; ylabel('avgLfp');




%%



%     elseif episodeStartIdx ~= 0
%         % we found a potential endpoint, but it ended before the cutoff so
%         % so reset and keep going back
%         episodeStartIdx = 0;
%         minValStreak = 0;
%     elseif minValStreak > 30
%         break;



%% identify chews packets as peaks in filtered raw average LFP
% this method works, but would require other types of refinements to use as
% a detector. The rat used for testing appears to chew "loudly" and then
% brux after being placed in the waiting bucket, which creates a confound
% in the chew event detection. Each chew has a strong onset and more
% gradual decay pattern. The bruxing looks more like a heaviside function,
% and can be picked up effectively with a different filterset.
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% 
filelist = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
avgLfp=avgLfpFromList( dir, filelist );  % build average LFP
%
sampleRate=32000;
% ignore the first and last seconds of the filtered signal to eliminate
% artifacts arising from the filtering process.
idxs=sampleRate*1:length(avgChew)-sampleRate*1;
[ chewPeakValues, ...
  chewPeakTimes, ...
  chewPeakProminances, ...
  chewPeakWidths ] = findpeaks(  avgChew(idxs),                              ... % data
                                 timestampSeconds(idxs),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                 'MinPeakHeight',   max(avgChew(idxs))*.2, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                 'MinPeakDistance', 0.1  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
%figure; plot(timestampSeconds, avgChew); hold on; plot(chewPeakTimes, chewPeakValues, '*')

%% maybe there is a way to tweak this filter so chewing and bruxing are better separated?
filters.ao.chew     = designfilt( 'bandpassiir', 'StopbandFrequency1',   80, 'PassbandFrequency1',  100, 'PassbandFrequency2', 1000, 'StopbandFrequency2', 1200, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order, settings by testing
avgChew = filtfilt( filters.so.chew, avgLfp );

%%

chewEnvSampleRate


centerIdx=round(length(tempEnv)/2);
max(tempEnv(centerIdx-round(10*60*chewEnvSampleRate):centerIdx+round(10*60*chewEnvSampleRate)))
figure; plot((tempEnv(centerIdx-round(10*60*chewEnvSampleRate):centerIdx+round(10*60*chewEnvSampleRate))))
    
figure; plot(tempEnv)


figure; hist( abs(hilbert(temp)), 200)

mean(abs(hilbert(temp)))
median()

aa=abs(hilbert(temp));


                         
% swr
swrLfp = filtfilt( filters.so.swr, lfp88 ); 
sampleRate=32000;
[ swrPeakValues, ...
  swrPeakTimes, ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks(  (swrLfp),                              ... % data
                               timestampSeconds,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %%%sampleRate,                                  ... % sampling frequency
                             'MinPeakHeight',   std(swrLfp)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak

figure;
subplot(3,1,1); hold off; plot(timestampSeconds, avgChew); hold on; plot( chewPeakTimes, chewPeakValues, 'o' ); %xlim([ 831 836 ]); legend('avg lfp');
subplot(3,1,2); hold off; plot(timestampSeconds, lfp88);   legend('lfp88(h.f.)'); %hold on; plot( peakTimes, peakValues, 'o' ); xlim([ 831 836 ]);
subplot(3,1,3); hold off; plot(timestampSeconds, swrLfp); hold on; plot( swrPeakTimes, swrPeakValues, 'o' ); %xlim([ 831 836 ]); legend('swr band');


subplot(3,1,1); xlim([ min(timestampSeconds) max(timestampSeconds) ] ); subplot(3,1,2); xlim([ min(timestampSeconds) max(timestampSeconds) ] );subplot(3,1,3); xlim([ min(timestampSeconds) max(timestampSeconds) ] );


return;

idxs=[ round(831*sampleRate):round(836*sampleRate) ];
figure; subplot(9,1,1); hold off; plot(timestampSeconds(idxs), lfp6(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp6(Rnac)'); %  xlim([ 831 836 ]); 
subplot(9,1,2); hold off; plot(timestampSeconds(idxs), lfp12(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp12(Rhf)');
subplot(9,1,3); hold off; plot(timestampSeconds(idxs), lfp16(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp16(Rhf)');
subplot(9,1,4); hold off; plot(timestampSeconds(idxs), lfp36(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp36(Rhf)');
subplot(9,1,5); hold off; plot(timestampSeconds(idxs), lfp46(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp46(vta)');
subplot(9,1,6); hold off; plot(timestampSeconds(idxs), lfp61(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp61(Lhf)');
subplot(9,1,7); hold off; plot(timestampSeconds(idxs), lfp64(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp64(Lhf)');
subplot(9,1,8); hold off; plot(timestampSeconds(idxs), lfp76(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp76(Lhf)');
subplot(9,1,9); hold off; plot(timestampSeconds(idxs), lfp88(idxs)); hold on; plot( peakTimes, peakValues, 'o' ); legend('lfp88(Lhf)');


return;




633.5 - 636
586

61.2-29.4






avgChew = filtfilt( filters.so.chew, avgLfp ); 
figure; plot(timestampSeconds, avgChew)
sampleRate=32000;
[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  (avgChew),                              ... % data
                             sampleRate,                                  ... % sampling frequency
                             'MinPeakHeight',   .04, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
hold on; plot( peakTimes, peakValues, 'o' );

figure; [zz,xx]=hist(avgChew,200); plot(xx,zz);

%spectrogram(data,windowLength,overlap,dft pts, sampleRate, 'yaxis')
%figure; spectrogram(avgChew,sampleRate/4,sampleRate/16,128,sampleRate,'yaxis')
%not doing what I want; big power in 200-1kHz band, cant see low freq


sampleRate = 32000; % samples/second
windowSize = 2; % seconds
jumpSize = 1.5 % seconds
mvgAvg=[]; mvgStd=[]; mvgTt=[];
for ii=1:round(sampleRate*jumpSize):length(avgChew)-round(windowSize*sampleRate)
    mvgAvg = [ mvgAvg mean(avgChew(ii:ii+round(sampleRate*jumpSize))) ];
    mvgStd = [ mvgStd std(avgChew(ii:ii+round(sampleRate*jumpSize))) ];
    mvgTt  = [ mvgTt timestampSeconds(ii+round((sampleRate*jumpSize)/2)) ];
end
    






%235:245

%239.41
%239.31

%100 ms from peak to valley

winMax=[];
tt=[];
for ii=round(sampleRate*235):round(.1*sampleRate):round(sampleRate*245)
    tt=[ tt ii/sampleRate ];
    win=round(.025*sampleRate);
    winMax=[ winMax max(avgChew(ii-win:ii+win)) ];
end
plot(tt,winMax)


env=abs(hilbert(avgChew)); hold on; plot(timestampSeconds, env);


avgSpindle = filtfilt( filters.so.nrem, moreLfp ); figure; plot(timestampSeconds, avgSpindle)
env=abs(hilbert(avgSpindle)); hold on; plot(timestampSeconds, env);



%% example to find a profile over Crunchs
% this funny looking indexing is because there is a gap in the timestamps
idxs=round((584.5-31.8)*32000):round((587.5-31.8)*32000); [r,lags] = xcorr( avgChew(idxs)); figure; plot(lags,r)
%
aChew=avgChew(idxs);
aChewTimes=timestampSeconds(idxs);
maxes=[];
for ii=251:length(aChewTimes)-250
    maxes(ii)=max(abs(aChew(ii-250:ii+250)));
end
figure; plot(aChew); hold on; plot(maxes);



ee=abs(hilbert(electricAvgLfp));
gmodel=fitgmdist(ee,3);
gmodel.mu
gmodel.Sigma
disp(gmodel)
[yy,xx]=hist(ee,0:max(ee)/200:max(ee));
figure; plot(xx,yy/sum(yy)); axis tight; hold on;
norm = normpdf(xx,gmodel.mu(1),gmodel.Sigma(1)); plot(xx,norm*gmodel.ComponentProportion(1));
norm = normpdf(xx,gmodel.mu(2),gmodel.Sigma(2)); plot(xx,norm*gmodel.ComponentProportion(2));
norm = normpdf(xx,gmodel.mu(3),gmodel.Sigma(3)); plot(xx,norm*gmodel.ComponentProportion(3));


figure; subplot(2,2,1); plot(xx,yy/sum(yy));
subplot(2,2,2); norm = normpdf(xx,gmodel.mu(1),gmodel.Sigma(1)); plot(xx,norm);
subplot(2,2,3); norm = normpdf(xx,gmodel.mu(2),gmodel.Sigma(2)); plot(xx,norm);
subplot(2,2,4); norm = normpdf(xx,gmodel.mu(3),gmodel.Sigma(3)); plot(xx,norm);

figure; plot(xx,yy/sum(yy)); hold on; plot(gmodel.mu,zeros(1,3),'*');

plot(gmodel.mu+gmodel.Sigmas*2,zeros(1,3),'o');

norm = normpdf(xx,gmodel.mu(1),0.025); plot(xx,norm);

norm1 = normpdf(xx,gmodel.mu(1),0.0012); norm2 = normpdf(xx,0.009,0.002); 
zz=(max(yy/sum(yy))*norm1/max(norm1))+(0.025*norm2/max(norm2));  plot(xx,zz,'k');










%% trying to find signal jumps

% attempt to test for diff distributions
inputElements = length(electricEnv);
sampleRate = 32000;
halfWindowSize = 32000; % elements
overlapSize = 2*-32000;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( (2*halfWindowSize+1) - overlapSize ) ) ;
overlap = zeros(1,outputPoints);
eeMean  = zeros(1,outputPoints);
overlapTimes = zeros(1,outputPoints);
newSampleRate=sampleRate/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-jumpSize
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    population1 = electricEnv(ii);
    population2 = electricEnv(ii+jumpSize);
    eeMean(outputIdx)=mean(population1);
    if mean(population1) > mean(population2)
        overlap(outputIdx)=sum( population2 > min(population1) )/(2*halfWindowSize);
    else
        overlap(outputIdx)=sum( population1 > min(population2) )/(2*halfWindowSize);
    end
    overlapTimes(outputIdx) = timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end

figure;hold on; plot(overlapTimes,0.02*(overlap<0.05),'r'); plot(timestampSeconds,ee);


figure; hold on; plot(timestampSeconds,electricEnv); plot(overlapTimes, eeMean); plot(overlapTimes(2:end), diff(eeMean)); 





% what do the mean & std look like
% doesn't add anything peak detect doesn't already have
inputElements = length(ee);
sampleRate = 32000;
halfWindowSize = 64000; % elements
overlapSize = 16000;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( (2*halfWindowSize+1) - overlapSize ) ) ;
vars = zeros(1,outputPoints);
means = zeros(1,outputPoints);
statTimes = zeros(1,outputPoints);
newSampleRate=sampleRate/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-jumpSize
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    population1 = ee(ii);
    vars(outputIdx)=std(population1);
    means(outputIdx)=mean(population1);
    statTimes(outputIdx) = timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end

figure; plot(timestampSeconds,ee); hold on; plot(statTimes,vars); plot(statTimes,means);





%% this will plot outputs from peakEdges  %%%%%%%%
% detect peaks on the Max Enveloped signal
elecLfp=filtfilt( filters.so.electric, electricAvgLfp );
ee=abs(hilbert(elecLfp));
extents=detectPeaksEdges( ee, timestampSeconds, 32000 )
figure; hold on; plot(timestampSeconds,ee);
scatter( extents.chewEpisodePeakTimes, extents.chewEpisodePeakValues, 'v', 'filled');
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
for jj=1:length(extents.chewEpisodeEndIdxs);
   if  extents.chewEpisodeStartIdxs(jj) > 0
       scatter( timestampSeconds( extents.chewEpisodeStartIdxs(jj) ), -0.01, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( timestampSeconds( 1 ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
   if  extents.chewEpisodeEndIdxs(jj) < length(timestampSeconds)
       scatter( timestampSeconds(  extents.chewEpisodeEndIdxs(jj) ), -0.01, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( timestampSeconds( end ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end

%
episodeMask=zeros(1,length(ee));
for ii=1:length(extents.chewEpisodeEndIdxs)
    episodeMask(extents.chewEpisodeStartIdxs:extents.chewEpisodeEndIdxs)=1;
end


%,  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));


% fixed location; might break things later
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%
if visualizeAll
   % figure; plot( chewEnvTimes(envIdx-2000:envIdx+2000), temp(envIdx-2000:envIdx+2000) ); hold on; plot( chewEnvTimes(envIdx-2000:envIdx+2000), tempEnv(envIdx-2000:envIdx+2000) ); hold on; plot( chewEnvTimes(episodeStartIdx), tempEnv(episodeStartIdx), '*')
   if chewEpisodeStartIdxs(jj) > 0
       scatter( chewCrunchEnvTimes( chewEpisodeStartIdxs(jj) ), -0.01, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( chewCrunchEnvTimes( 1 ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end

%
if visualizeAll
   scatter( chewCrunchEnvTimes( chewEpisodeEndIdxs(jj) ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
end