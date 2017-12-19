clear all; close all;

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

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% FOR THIS PARTICULAR DAY, SKIP THE INTRODUCTION
lfpStartIdx = 1954992;
% 
filelist = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
avgLfp=avgLfpFromList( dir, filelist, lfpStartIdx );  % build average LFP

% load a good SWR file
% TODO (this one eventually has SWR, but check the turn log)
[ lfp88, lfpTimestamps ] = csc2mat( [ dir 'CSC88.ncs' ], lfpStartIdx );
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

makeFilters;
% auto-detect chews to differentiate from potential SWR events
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


%% look for events in the average LFP
makeFilters;
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
%
%
%
% == "MAX FILTER" OF CHEWING-FILTERED AVERAGE LFP ==
% TODO could be a function
inputElements = length(avgChew);
sampleRate = 32000;
halfWindowSize = 250; % elements
overlapSize = 100;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( (2*halfWindowSize+1) - overlapSize ) ) ;
chewCrunchEnv = zeros(1,outputPoints);
chewCrunchEnvTimes = zeros(1,outputPoints);
chewCrunchEnvSampleRate=sampleRate/jumpSize;
outputIdx = 1;
for ii=halfWindowSize+1:jumpSize:inputElements-250
    chewCrunchEnv(outputIdx)=max(abs(avgChew(ii-halfWindowSize:ii+halfWindowSize)));
    chewCrunchEnvTimes(outputIdx) = timestampSeconds(ii);
    outputIdx = outputIdx + 1;
end
% NOTE visualize the situation
if visualizeAll
%    subplot(4,1,3); hold on; 
%    plot( timestampSeconds, avgChew); plot(chewCrunchEnvTimes, chewCrunchEnv);
%    subplot(2,1,2); spectrogram(chewCrunchEnv,80,20,128,chewEnvSampleRate,'yaxis');
end
% the Crunchs are pretty clear in the spectrogram, and would become more
% obvious in the modulogram I guess (see above).
%
%
% == DETECT PEAKS OF CHEWING EPISODES ==
filters.ao.nomnom    = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux    = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%filters.ao.nombrux    = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
% VISUALIZE
%figure; hold on; plot(chewEnvTimes,temp); plot(chewEnvTimes, abs(hilbert(temp)));  temp=filtfilt( filters.ao.brux, chewEnv ); plot(chewEnvTimes, abs(hilbert(temp))); 
%
% detect peaks on the Max Enveloped signal
chewEpisodeLFP=filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv=abs(hilbert(chewEpisodeLFP));
% correct for artifacts of filtering by ignoring the first and last 1 sec
chewEpisodeIdxs=round(chewCrunchEnvSampleRate*1):round(length(chewEpisodeEnv) - chewCrunchEnvSampleRate*1 );
% set a threshold -- this is a rough idea based on looking at the data
% MADAM method
%    threshold = median(tempEnv) + ( 10 * median(abs(temp-median(tempEnv))) );
% 20% of max value method
threshold = 0.2 * max(  chewEpisodeEnv( chewEpisodeIdxs ));
% find peaks
[ chewEpisodePeakValues, ...
  chewEpisodePeakTimes, ...
  chewEpisodePeakProminances, ...
  chewEpisodePeakWidths ] = findpeaks(  chewEpisodeEnv( chewEpisodeIdxs ),                              ... % data
                                        chewCrunchEnvTimes( chewEpisodeIdxs ),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    threshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  1.5  ); % assumes "lockout" for chew events; don't detect peaks within 70 ms on either side of peak
           % the MinPeakDistance variable is tricky to set. how long is a
           % burst? this will require some clean up later.
if visualizeAll
    subplot(5,1,4); hold on;
    plot( timestampSeconds, avgChew/max(avgChew(sampleRate*3:end-sampleRate*3))*max(chewEpisodePeakValues) );
    plot( chewCrunchEnvTimes, chewEpisodeEnv );
    scatter( chewEpisodePeakTimes, chewEpisodePeakValues, 'v', 'filled');
    axis tight; ylim([ -0.013 max(chewEpisodePeakValues) ]); ylabel( 'chew' ); 
%    %    
%    maxY=max(  abs( chewEpisodeEnv( chewEpisodeIdxs )))*1.02;
%    figure; plot( chewCrunchEnvTimes, chewEpisodeLFP ); hold on; 
%    plot( chewCrunchEnvTimes, chewEpisodeEnv );
%    plot( chewEpisodePeakTimes, chewEpisodePeakValues, 'o')
%    ylim([ -maxY maxY ]); xlim([0 max(chewCrunchEnvTimes)]);
end
clear chewEpisodeIdxs
% == DETECT START AND END OF AN EPISODE OF CRUNCHING ==
%
% given the locations of the peaks of the Crunch episodes, find the extents
% of the episodes
%
% starting at the peak, ride the signal envelope until it stays below a
% threshold for a while (rather heuristic)
%
plotMarkers = {'+','o','*','.','x','s','d','^','>','<','p','h'};
load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%
chewEpisodeStartIdxs = zeros( 1, length( chewEpisodePeakTimes ) );
chewEpisodeEndIdxs = zeros( 1, length( chewEpisodePeakTimes ) );
for jj=1:length(chewEpisodePeakTimes)
    % find the nearest index
    [vv envIdx]=min(abs(chewCrunchEnvTimes-chewEpisodePeakTimes(jj)));
    envIdx = envIdx(1); % we only need one. (could cause bugs if repeat values)
    chewEpisodeStartIdxs(jj) = 0;
    minValStreak = 0;
    pctThreshold = chewEpisodePeakValues(jj)*.05;
    for ii=1:2000
        if envIdx-ii < 1
            break;
        end
        if chewEpisodeEnv(envIdx-ii) < pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if chewEpisodeStartIdxs(jj) == 0
                chewEpisodeStartIdxs(jj) = envIdx - ii;
            end
        elseif minValStreak > 20  % TODO should really be a proportion of sample rate
            break;
        elseif chewEpisodeStartIdxs(jj) ~= 0
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            chewEpisodeStartIdxs(jj) = 0;
            minValStreak = 0;
        end
    end
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
    % now go up
    %chewEpisodeEndIdxs(ii) = 0;
    minValStreak = 0;
    pctThreshold = chewEpisodePeakValues(jj)*.05;
    for ii=1:2000
        if envIdx-ii > length(chewEpisodeEnv)
            break;
        end
        if chewEpisodeEnv(envIdx+ii) < pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if  chewEpisodeEndIdxs(jj) == 0
                 chewEpisodeEndIdxs(jj) = envIdx + ii;
            end
        elseif minValStreak > 20  % TODO should really be a proportion of sample rate
            break;
        elseif  chewEpisodeEndIdxs(jj) ~= 0
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
             chewEpisodeEndIdxs(jj) = 0;
            minValStreak = 0;
        end
    end 
    %
    if visualizeAll
       scatter( chewCrunchEnvTimes( chewEpisodeEndIdxs(jj) ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
    end
    %
end
% == store the data because we're about to do some ugly copy paste ==
chewDetectOutput.chewEpisodeStartIdxs = chewEpisodeStartIdxs;
chewDetectOutput.chewEpisodeEndIdxs = chewEpisodeEndIdxs;
chewDetectOutput.chewEpisodePeakValues = chewEpisodePeakValues;
chewDetectOutput.chewEpisodePeakTimes = chewEpisodePeakTimes;




% ====================
% == DETECT BRUXING ==
% ====================
bruxEpisodeLFP=filtfilt( filters.ao.brux, chewCrunchEnv );
bruxEpisodeEnv=abs(hilbert(bruxEpisodeLFP));
% correct for artifacts of filtering by ignoring the first and last 1 sec
bruxEpisodeIdxs=round(chewCrunchEnvSampleRate*1):round(length(bruxEpisodeEnv) - chewCrunchEnvSampleRate*1 );
% set a threshold -- this is a rough idea based on looking at the data
% MADAM method
%    threshold = median(tempEnv) + ( 10 * median(abs(temp-median(tempEnv))) );
% 20% of max value method
threshold = 0.2 * max(  bruxEpisodeEnv( bruxEpisodeIdxs ));
% find peaks
[ bruxEpisodePeakValues, ...
  bruxEpisodePeakTimes, ...
  bruxEpisodePeakProminances, ...
  bruxEpisodePeakWidths ] = findpeaks(  bruxEpisodeEnv( bruxEpisodeIdxs ),                              ... % data
                                        chewCrunchEnvTimes( bruxEpisodeIdxs ),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    threshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  1.5  ); % assumes "lockout" for brux events; don't detect peaks within 70 ms on either side of peak
           % the MinPeakDistance variable is tricky to set. how long is a
           % burst? this will require some clean up later.
if visualizeAll
    subplot(5,1,5); hold on;
    plot( timestampSeconds, avgChew/max(avgChew(sampleRate*3:end-sampleRate*3))*max(bruxEpisodePeakValues) );
    plot( chewCrunchEnvTimes, bruxEpisodeEnv );
    scatter( bruxEpisodePeakTimes, bruxEpisodePeakValues, 'v', 'filled')
    ylabel( 'brux' ); axis tight; ylim([ -0.013 max(bruxEpisodePeakValues) ]);
%     %
%     maxY=max(  abs( bruxEpisodeEnv( bruxEpisodeIdxs )))*1.02;
%     figure; plot( chewCrunchEnvTimes, bruxEpisodeLFP ); hold on; 
%     plot( chewCrunchEnvTimes, bruxEpisodeEnv );
%     plot( bruxEpisodePeakTimes, bruxEpisodePeakValues, 'o')
%     ylim([ -maxY maxY ]); xlim([0 max(chewCrunchEnvTimes)]);
end
clear bruxEpisodeIdxs
% == DETECT START AND END OF AN EPISODE OF CRUNCHING ==
%
% given the locations of the peaks of the Crunch episodes, find the extents
% of the episodes
%
% starting at the peak, ride the signal envelope until it stays below a
% threshold for a while (rather heuristic)
%
bruxEpisodeStartIdxs = zeros( 1, length( bruxEpisodePeakTimes ) );
bruxEpisodeEndIdxs = zeros( 1, length( bruxEpisodePeakTimes ) );
for jj=1:length(bruxEpisodePeakTimes)
    % find the nearest index
    [vv envIdx]=min(abs(chewCrunchEnvTimes-bruxEpisodePeakTimes(jj)));
    envIdx = envIdx(1); % we only need one. (could cause bugs if repeat values)
    bruxEpisodeStartIdxs(jj) = 0;
    minValStreak = 0;
    pctThreshold = bruxEpisodePeakValues(jj)*.05;
    for ii=1:10000
        if envIdx-ii < 1
            break;
        elseif ii > 9998
            disp('warning');
        end
        if bruxEpisodeEnv(envIdx-ii) < pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if bruxEpisodeStartIdxs(jj) == 0
                bruxEpisodeStartIdxs(jj) = envIdx - ii;
            end
        elseif minValStreak > 20  % TODO should really be a proportion of sample rate
            break;
        elseif bruxEpisodeStartIdxs(jj) ~= 0
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            bruxEpisodeStartIdxs(jj) = 0;
            minValStreak = 0;
        end
    end
    %
    if visualizeAll
       % figure; plot( bruxEnvTimes(envIdx-2000:envIdx+2000), temp(envIdx-2000:envIdx+2000) ); hold on; plot( bruxEnvTimes(envIdx-2000:envIdx+2000), tempEnv(envIdx-2000:envIdx+2000) ); hold on; plot( bruxEnvTimes(episodeStartIdx), tempEnv(episodeStartIdx), '*')
       if bruxEpisodeStartIdxs(jj) > 0
           scatter( chewCrunchEnvTimes( bruxEpisodeStartIdxs(jj) ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
       else
           scatter( chewCrunchEnvTimes( 1 ),  -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
       end
    end
    %
    % now go up
    %bruxEpisodeEndIdxs(ii) = 0;
    minValStreak = 0;
    pctThreshold = bruxEpisodePeakValues(jj)*.05;
    for ii=1:10000
        if envIdx-ii > length(bruxEpisodeEnv)
            break;
        elseif ii > 9998
            disp('warning')
        end
        if bruxEpisodeEnv(envIdx+ii) < pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if  bruxEpisodeEndIdxs(jj) == 0
                 bruxEpisodeEndIdxs(jj) = envIdx + ii;
            end
        elseif minValStreak > 20  % TODO should really be a proportion of sample rate
            break;
        elseif  bruxEpisodeEndIdxs(jj) ~= 0
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
             bruxEpisodeEndIdxs(jj) = 0;
            minValStreak = 0;
        end
    end 
    %
    if visualizeAll
       scatter( chewCrunchEnvTimes( bruxEpisodeEndIdxs(jj) ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
    end
    %
end








return;
% == END ==


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






