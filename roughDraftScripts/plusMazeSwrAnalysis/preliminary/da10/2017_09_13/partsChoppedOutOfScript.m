% ======================
% == DISPLAY ELECTRIC ==
% ======================

% ** running this particular call will attempt to find the edges of the
% plateaus; it does this by requiring a long period of time at a low value
% but it never quite worked the way I wanted it too. a very long (10
% seconds? 30 s? of low value might help, as the rat is in the low state
% for at least 1-2 minutes between trials
% electricDetectorOutput = detectPeaksEdges( electricEnv, timestampSeconds, sampleRate.lfp );


% this will plot outputs from peakEdges  %%%%%%%%
% detect peaks on the Max Enveloped signal


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% now find the
%   (1) onto maze trial starts
%   (2) trial run start
%   (3) returns to start?



%filters.ao.nombrux    = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
% VISUALIZE
%figure; hold on; plot(chewEnvTimes,temp); plot(chewEnvTimes, abs(hilbert(temp)));  temp=filtfilt( filters.ao.brux, chewEnv ); plot(chewEnvTimes, abs(hilbert(temp))); 
%







figure(2);
subplot(2,1,1);
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





subplot(2,1,1);
scatter(rewardTimes, ones(1,length(rewardTimes)).*-0.001, 'o', 'filled', 'c');
scatter(intoBucketTimes, ones(1,length(intoBucketTimes)).*-0.001, 'o', 'filled', 'r');






% figure;
% subplot(2,1,1); plot( xytimestampSeconds, old.xpos); hold on; plot( xytimestampSeconds, xpos);
% subplot(2,1,2); plot( xytimestampSeconds, old.ypos); hold on; plot( xytimestampSeconds, ypos);
% figure; plot( xpos, ypos)

    % peakfind on the velocity for that segment
%     bucketSpeeds = diff(ypos( startIdx:endIdx+1 ));
%     bucketTimes = xytimestampSeconds( startIdx:endIdx );
%     maxPeak = max(  bucketSpeeds );
%     MinPeakDistance = .5;
%     peakThreshold = (0.2 * ( maxPeak ) );
%     [ EpisodePeakValues, ...
%       EpisodePeakTimes, ...
%       EpisodePeakProminances, ...
%       EpisodePeakWidths ] = findpeaks(  bucketSpeeds,                              ... % data
%                                             bucketTimes,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
%                                             'MinPeakHeight',                    peakThreshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                             'MinPeakDistance',                  MinPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
% 
%     figure; subplot(2,1,1);
%     plot( bucketTimes, bucketSpeeds ); hold on;
%     scatter( EpisodePeakTimes, EpisodePeakValues, 'v', 'filled'); axis tight;
%     subplot(2,1,2); plot( bucketTimes, proxToStart( startIdx:endIdx )); axis tight;
%     expectedValue = median( bucketSpeeds );
%     fixypos = ypos;
%     for jj= 2:length(EpisodePeakTimes)
%         tstartIdx = floor( (EpisodePeakTimes(jj-1) - EpisodePeakTimes(1)) * telemetrySampleRate )+1;
%         tendIdx = ceil( (EpisodePeakTimes(jj) - EpisodePeakTimes(1)) * telemetrySampleRate );
% %        if abs( expectedValue - median( bucketSpeeds(tstartIdx:tendIdx) ) ) > .1
%             fixypos( tstartIdx:tendIdx ) = median( ypos(tstartIdx:tendIdx) ) ;
% %        end
%     end
%     figure; subplot(3,1,1); hold on; plot( bucketTimes, ypos( startIdx:endIdx )); plot( EpisodePeakTimes, ypos(round(EpisodePeakTimes*29.97)),'o' );axis tight;
%     plot( bucketTimes, ypos(startIdx:endIdx)-fixypos(startIdx:endIdx)+median(ypos(startIdx:endIdx)) );
%     subplot(3,1,2); plot( bucketTimes, fixypos( startIdx:endIdx ), 'r' ); axis tight;
%     subplot(3,1,3); plot( bucketTimes, bucketSpeeds ); axis tight;
%     
%     figure; plot( bucketTimes, ypos( startIdx:endIdx )-bucketSpeeds)
%     
%     temp=startIdx:endIdx;
%     figure; subplot(2,1,1); plot( xpos(temp), xpos(temp+30)); subplot(2,1,2); plot( ypos(temp), ypos(temp+30));
%     figure; subplot(2,1,1); plot( xpos ); axis tight; subplot(2,1,2); plot( ypos );  axis tight;
%    
%     figure; hold on; plot(bucketTimes, proxToStart( startIdx:endIdx ));
%     expectedValue = median(proxToStart( startIdx:endIdx ));
%     adjustment = expectedValue - proxToStart( startIdx:endIdx )
%     plot(bucketTimes, proxToStart( startIdx:endIdx ) -  );    
% end




% 
% figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; 
% subplot(2,1,2);  plot(mvgMedianTimes,mvgMedian); 
% hold on; plot(mvgMedianTimes(2:end),diff(mvgMedian));  axis tight;
% subplot(2,1,2); hold on; scatter( transMvgMedPeakTimes, transMvgMedPeakValues, '*'); %, 'filled');
% scatter(ontoMazeTimes, ones(1,length(rewardTimes)).*-0.001, 'o', 'filled');






figure(2);
subplot(2,1,2); hold off;
plot( xytimestampSeconds, proxToStart); hold on; 
plot( xytimestampSeconds, proxToCenter); 
plot( xytimestampSeconds, proxToIncorrectSite); 
plot( xytimestampSeconds, proxToRewardSite); 
ylabel('prox'); 
xlim([0 timestampSeconds(end)]); 
ylim([0 1]);



% DISPLAY THE RESULTS WHERE THE RAT LEAVES THE START AREA
%
% DISPLAY RESULTS FROM THE ABOVE
figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; 
subplot(2,1,2);  plot(mvgMedianTimes,mvgMedian); 
hold on; plot(mvgMedianTimes(2:end),-diff(mvgMedian));  axis tight;
%
scatter( startEpisodes.EpisodePeakTimes, startEpisodes.EpisodePeakValues, '*'); %, 'filled');
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
scatter( startEpisodes.EpisodePeakTimes, startEpisodes.EpisodePeakValues, '*'); %, 'filled');
for jj=1:length(startEpisodes.EpisodeEndIdxs);
   if  startEpisodes.EpisodeStartIdxs(jj) > 0
       scatter( mvgMedianTimes( startEpisodes.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( mvgMedianTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
   if  startEpisodes.EpisodeEndIdxs(jj) < length(timestampSeconds)
       scatter( mvgMedianTimes(  startEpisodes.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
   else
       scatter( mvgMedianTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
   end
end
% CALCULATE TIMEPOINTS WHEN THE RAT IS PLACED ON THE MAZE
figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; 
subplot(2,1,2);  plot(mvgMedianTimes,mvgMedian); 
hold on; plot(mvgMedianTimes(2:end),-diff(mvgMedian));  axis tight;
plot(xytimestampSeconds, proxToCenter)












    
    
    


    


%% NO MANS LAND
% ==============================
% ==   MISC CODE BELOW HERE   ==
% ==============================
%
% ==============================
% ==   MISC CODE BELOW HERE   ==
% ==============================
%
% ==============================
% ==   MISC CODE BELOW HERE   ==
% ==============================






    
%% trying to find signal jumps

% attempt to test for diff distributions
inputElements = length(electricEnv);
halfWindowSize = 10*32000; % elements
overlapSize = 30*-32000;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
%jumpSize=(2*halfWindowSize+1) - overlapSize ;
jumpSize = sampleRate*2 ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
meanDiff = zeros( 1, outputPoints );
eeMean  = zeros( 1, outputPoints );
overlapTimes = zeros( 1, outputPoints );
newSampleRate = sampleRate.lfp/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-(jumpSize+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    population1 = electricEnv(ii);
    population2 = electricEnv(ii+jumpSize);
    meanDiff(outputIdx)=median(population1) - median(population2);
    overlapTimes(outputIdx) = timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end

figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; subplot(2,1,2); 
plot(overlapTimes,meanDiff); axis tight;



% correct for artifacts of filtering by ignoring the first and last 1 sec
EpisodeIdxs=round(signalSampleRate.lfp*1):round(length(signalEnvelope) - signalSampleRate.lfp*1 );
% set a threshold -- this is a rough idea based on looking at the data
% MADAM method
%    threshold = median(tempEnv) + ( 10 * median(abs(temp-median(tempEnv))) );
% 20% of max value method
maxPeak = max(  signalEnvelope( EpisodeIdxs ));
% the idea here is to try to protect against a scenario where the minimum
% value is 50 and the max is 100 -- 20% of 100 is 20, which will never
% occur if the minimum is 50. So take 20% of the difference between some
% estimate of the central tendency of the baseline (visually, the mode
% looked like a better estimate), find the height of the max, take 20% of
% that and then add it to the peak height
peakThreshold = (0.2 * ( maxPeak - mode(signalEnvelope( EpisodeIdxs ))))+mode(signalEnvelope( EpisodeIdxs ));
%extentThreshold =  (0.02 * ( maxPeak - mode(signalEnvelope( EpisodeIdxs ))))+mode(signalEnvelope( EpisodeIdxs ));
if nargin < 5
    %extentThreshold = mean(signalEnvelope); % mode(signalEnvelope)+std(signalEnvelope);
    extentThreshold = max([ peakThreshold/4 mean(signalEnvelope)]);
end
    % find peaks
[ EpisodePeakValues, ...
  EpisodePeakTimes, ...
  EpisodePeakProminances, ...
  EpisodePeakWidths ] = findpeaks(  signalEnvelope( EpisodeIdxs ),                              ... % data
                                        signalTimes( EpisodeIdxs ),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    peakThreshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  MinPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak








hold on; plot( overlapTimes, cumsum(meanDiff) )



figure;hold on; plot(overlapTimes,0.02*(overlap<0.05),'r'); plot(timestampSeconds,ee);


figure; hold on; plot(timestampSeconds,electricEnv); plot(overlapTimes, eeMean); plot(overlapTimes(2:end), diff(eeMean)); 













































































clear all; close all;
figure; 

%% weirdness
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


%% =====================
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
% % this will plot outputs from peakEdges  %%%%%%%%
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
%% look for events in the average LFP
% ====================
% == DETECT CHEWING ==
% ====================

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

load('/Users/andrewhowe/Desktop/swrAnalysisBins.mat');

figure; subplot(3,1,2); histogram( swrPeakTimesDenoise, swrAnalysisBins ); title('SWR Frequency'); xlabel('time (s)'); ylabel('counts'); axis tight;
subplot(3,1,3); plot( swrAnalysisBins(2:end), histcounts( swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins), '*-' ); title('SWR rate'); xlabel('time (s)'); ylabel('Hz'); axis tight;

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




