tic;

clear all; close all;

%% build an average LFP
visualizeAll=true;
sampleRate=32000;

dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% FOR da10 2017-09-13, SKIP THE INTRODUCTION
lfpStartIdx = 1954981;   % round(61.09316*32000);

fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
avgLfp=avgLfpFromList( dir, fileListGoodLfp, lfpStartIdx );  % build average LFP

fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
avgDisconnectedLfp=avgLfpFromList( dir, fileListDisconnectedLfp, lfpStartIdx );  % build average LFP
% make sure there are timestamps
[ ~, lfpTimestamps ] = csc2mat( [ dir fileListDisconnectedLfp{1} ], lfpStartIdx );
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

makeFilters;

%% look for events in the average LFP

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
figure(2);
subplot(2,1,1);
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
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% now find the
%   (1) onto maze trial starts
%   (2) trial run start
%   (3) returns to start?



%
%
%
%
% == DETECT PEAKS OF CHEWING EPISODES ==

% auto-detect chews to differentiate from potential SWR events
avgChew = filtfilt( filters.so.chew, avgLfp );
[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, timestampSeconds );

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






%% detect reward times + trial end (into bucket)
rewardTimes = [];
intoBucketTimes = [];
for ii = 1:length(chewDetectorOutput.EpisodePeakTimes)
    if ( ii > 1 ) && ( (chewDetectorOutput.EpisodePeakTimes(ii)-chewDetectorOutput.EpisodePeakTimes(ii-1)) < 20 )
        disp('skipping a chew peak');
    else
        relativeTimes = electricDetectorOutput.EpisodePeakTimes - chewDetectorOutput.EpisodePeakTimes(ii);
        [ ~, jj ] = min( abs( relativeTimes ));
        % if the closest time is negative AND it's not the last element AND
        % the next closest time less than 
        if ( relativeTimes(jj) > 0 )
            % things are OK
            rewardTimes = [ rewardTimes chewDetectorOutput.EpisodePeakTimes(ii) ];
            intoBucketTimes = [ intoBucketTimes electricDetectorOutput.EpisodePeakTimes(jj) ];
        else
            if ( jj < length(relativeTimes) )
                if ( relativeTimes(jj+1) < 40 )
                    % use this event
                    rewardTimes = [ rewardTimes chewDetectorOutput.EpisodePeakTimes(ii) ];
                    intoBucketTimes = [ intoBucketTimes electricDetectorOutput.EpisodePeakTimes(jj+1) ];
                else
                    disp('could not find bucket placement event after reward receipt; too far in futre')
                end
            else
                disp('could not find bucket placement event after reward receipt; no more events')
            end
        end
    end
end
subplot(2,1,1);
scatter(rewardTimes, ones(1,length(rewardTimes)).*-0.001, 'o', 'filled', 'c');
scatter(intoBucketTimes, ones(1,length(intoBucketTimes)).*-0.001, 'o', 'filled', 'r');

%% identify the trial starts

inputElements = length(electricEnv);
sampleRate = 32000;
halfWindowSize = round(10*sampleRate); % elements
overlapSize = round(.95*halfWindowSize);    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
mvgMedian = zeros( 1, outputPoints );
mvgMedianTimes = zeros( 1, outputPoints );
mvgMedianSampleRate = sampleRate/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mvgMedian(outputIdx)=median(electricEnv(ii));
    mvgMedianTimes(outputIdx) = timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end

figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; 
subplot(2,1,2);  plot(mvgMedianTimes,mvgMedian); 
hold on; plot(mvgMedianTimes(2:end),diff(mvgMedian));  axis tight;
% find peaks in the moving median
transMvgMedian=diff(mvgMedian);
maxPeak = max(  transMvgMedian );
peakThreshold = (0.2 * maxPeak );
minPeakDistance = 20; % seconds
[ transMvgMedPeakValues, ...
  transMvgMedPeakTimes, ...
  transMvgMedProminances, ...
  transMvgMedPeakWidths ] = findpeaks(  transMvgMedian,                              ... % data
                                        mvgMedianTimes(2:end),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    peakThreshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
subplot(2,1,2); hold on; scatter( transMvgMedPeakTimes, transMvgMedPeakValues, '*'); %, 'filled');
%
% we know from chews and tail grabs (bucket placements) when episodes end.
% so now start at the bucket placement, and look forward through the peaks
% in the electric transitions to find start points
ontoMazeTimes = zeros(size(intoBucketTimes));
if ( median(transMvgMedian(1:20)) > (median(transMvgMedian)*2) )
    ontoMazeTimes(1) = mvgMedianTimes(1); % this is a cheap hack
else
    disp('implement something here!');
end
for idxTrialEnd=1:length(intoBucketTimes)-1
        relativeTimes = transMvgMedPeakTimes - intoBucketTimes(idxTrialEnd);
        [ ~, jj ] = min( abs( relativeTimes ));
        offset = 0;
        while ( (jj+offset < length(relativeTimes) ) && (relativeTimes(jj+offset) < 40 )   ) 
            offset = offset + 1;
        end
        ontoMazeTimes(idxTrialEnd)=transMvgMedPeakTimes(jj+offset);
        
end
scatter(ontoMazeTimes, ones(1,length(rewardTimes)).*-0.001, 'o', 'filled');



%% smooth the jumps in the XY position data caused by being in the bucket
%

if length(ontoMazeTimes) ~= length(intoBucketTimes)
    warning('trial start and end time arrays are of unequal size!!!')
    % not going to correct for this possible error.
end

% TODO move this elsewhere later
old.xpos = xpos; old.ypos = ypos;
telemetrySampleRate = 29.97;
for ii = 1:length(intoBucketTimes)
    % find start and end indices of the bucket episode
    % try to offset the time by a few seconds to account for time to put
    % him down or pick him up (high accel/vel makes sense during these
    % brief episodes of teleportation)
    startIdx = round((intoBucketTimes(ii)+5) * telemetrySampleRate);
    endIdx   = round((ontoMazeTimes(ii)-5) * telemetrySampleRate);
    if endIdx < startIdx
        startIdx = round((intoBucketTimes(ii)) * telemetrySampleRate);
        endIdx   = round((ontoMazeTimes(ii)) * telemetrySampleRate);
    end
    if ( endIdx < startIdx ) && ( ii == length(intoBucketTimes) ) % TODO it doesn't find an end for out bucket time, because trials end
        endIdx = length(xpos);
    end
    if endIdx < startIdx; error('endIdx > startIdx in bucket position correction routine.'); end
    xpos(startIdx:endIdx) = median(xpos(startIdx:endIdx))+5*rand(size(xpos(startIdx:endIdx)));
    ypos(startIdx:endIdx) = median(ypos(startIdx:endIdx))+5*rand(size(xpos(startIdx:endIdx)));
end
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


% ==================================================
% ==  RECALCULATE TELEMETRY BASED ON CORRECTIONS  ==
% ==================================================
proxToCenter=proxToPoint( xpos, ypos, 317, 229 );
proxToStart=proxToPoint( xpos, ypos, 81, 412 );
proxToRewardSite=proxToPoint( xpos, ypos, 119, 45 );
proxToIncorrectSite=proxToPoint( xpos, ypos, 525, 429 );
figure(2);
subplot(2,1,2); hold off;
plot( xytimestampSeconds, proxToStart); hold on; 
plot( xytimestampSeconds, proxToCenter); 
plot( xytimestampSeconds, proxToIncorrectSite); 
plot( xytimestampSeconds, proxToRewardSite); 
ylabel('prox'); 
xlim([0 timestampSeconds(end)]); 
ylim([0 1]);






%% identify brick passage times
%
% CALCULATE PERIODS WHEN THE RAT IS AT THE START
inputElements = length(proxToStart);
sampleRate = 29.97;
halfWindowSize = round(5*sampleRate); % elements
overlapSize = round(.99*2*halfWindowSize); % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
mvgMedian = zeros( 1, outputPoints );
mvgMedianTimes = zeros( 1, outputPoints );
mvgMedianSampleRate = sampleRate/jumpSize;
outputIdx = 1;

for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mvgMedian(outputIdx)=median(proxToStart(ii));
    mvgMedianTimes(outputIdx) = xytimestampSeconds(idx);
    outputIdx = outputIdx + 1;
end
% DISPLAY RESULTS FROM THE ABOVE
figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; 
subplot(2,1,2);  plot(mvgMedianTimes,mvgMedian); 
hold on; plot(mvgMedianTimes(2:end),-diff(mvgMedian));  axis tight;
startEpisodes = detectPeaksEdges( mvgMedian, mvgMedianTimes, mvgMedianSampleRate, mvgMedianSampleRate, .75, 10, .85 );
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
%

% CALCULATE TIMEPOINTS WHEN THE RAT IS PLACED ON THE MAZE
figure; subplot(2,1,1); plot(timestampSeconds,electricEnv); axis tight; 
subplot(2,1,2);  plot(mvgMedianTimes,mvgMedian); 
hold on; plot(mvgMedianTimes(2:end),-diff(mvgMedian));  axis tight;
plot(xytimestampSeconds, proxToCenter)
% find peaks in the moving median
transMvgMedian=diff(mvgMedian);
maxPeak = max(  transMvgMedian );
peakThreshold = (0.2 * maxPeak );
minPeakDistance = 20; % seconds
[ transMvgMedPeakValues, ...
  transMvgMedPeakTimes, ...
  transMvgMedProminances, ...
  transMvgMedPeakWidths ] = findpeaks(  transMvgMedian,                              ... % data
                                        mvgMedianTimes(2:end),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    peakThreshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
subplot(2,1,2); hold on; scatter( transMvgMedPeakTimes, transMvgMedPeakValues, '*'); %, 'filled');
%
% we know from chews and tail grabs (bucket placements) when episodes end.
% so now start at the bucket placement, and look forward through the peaks
% in the electric transitions to find start points
ontoMazeTimes = zeros(size(intoBucketTimes));
if ( median(transMvgMedian(1:20)) > (median(transMvgMedian)*2) )
    ontoMazeTimes(1) = mvgMedianTimes(1); % this is a cheap hack
else
    disp('implement something here!');
end
for idxTrialEnd=1:length(intoBucketTimes)-1
        relativeTimes = transMvgMedPeakTimes - intoBucketTimes(idxTrialEnd);
        [ ~, jj ] = min( abs( relativeTimes ));
        offset = 0;
        while ( (jj+offset < length(relativeTimes) ) && (relativeTimes(jj+offset) < 40 )   ) 
            offset = offset + 1;
        end
        ontoMazeTimes(idxTrialEnd)=transMvgMedPeakTimes(jj+offset);
        
end
scatter(ontoMazeTimes, ones(1,length(rewardTimes)).*-0.001, 'o', 'filled');



for jj=1:length(startEpisodes.EpisodeEndIdxs);
   if  startEpisodes.EpisodeStartIdxs(jj) > 0
       scatter( mvgMedianTimes( startEpisodes.EpisodeStartIdxs(jj) ), 0, 'v',  'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
   else
       scatter( mvgMedianTimes( 1 ), 0, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
   end
   if  startEpisodes.EpisodeEndIdxs(jj) < length(timestampSeconds)
       scatter( mvgMedianTimes(  startEpisodes.EpisodeEndIdxs(jj) ), 0, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ] );
   else
       scatter( mvgMedianTimes( end ), 0, '>', 'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ] );
   end
end
ontoMazeTimes = mvgMedianTimes( startEpisodes.EpisodeStartIdxs);
runStartTimes = mvgMedianTimes( startEpisodes.EpisodeEndIdxs);





%% GRAPHICALLY SUMARIZE TIMEPOINTS DETECTED


figure; 
subplot(3,1,1); plot( timestampSeconds, electricEnv, 'k' );      axis tight;  ylabel('Avg; 60 Hz');
subplot(3,1,2); plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .1 .8 .1 ] ); axis tight;  ylabel('reward/chew');
subplot(3,1,3); hold off; plot( mvgMedianTimes, mvgMedian ); 
hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
scatter( ontoMazeTimes, ones(1,length(ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( runStartTimes, ones(1,length(runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( rewardTimes, ones(1,length(rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( intoBucketTimes, ones(1,length(intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);


%% ; make a list of times for bins

% sampleRate=32000;
% 
% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/';
% % FOR THIS PARTICULAR DAY, SKIP THE INTRODUCTION
% lfpStartIdx = 1954981;   % round(61.09316*32000);
% % 
% fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs'  'CSC88.ncs' };
% avgLfp=avgLfpFromList( dir, fileListGoodLfp, lfpStartIdx );  % build average LFP
% 
% fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
% avgDisconnectedLfp=avgLfpFromList( dir, fileListDisconnectedLfp, lfpStartIdx );  % build average LFP
% 
% % load a good SWR file
% % TODO (this one eventually has SWR, but check the turn log)
% [ lfp88, lfpTimestamps ] = csc2mat( [ dir 'CSC88.ncs' ], lfpStartIdx );
% timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
% 
% makeFilters;

swrAnalysisBins = sort([ 0 ontoMazeTimes runStartTimes rewardTimes intoBucketTimes xytimestampSeconds(end) ]);
histogram( swrAnalysisBins );








%% terminate the script
toc

return;

% =============
% ==   END   ==
% =============

%% zoom x axis manually

xlimits=[ 0 3100 ]; subplot(2,1,1); xlim(xlimits); subplot(2,1,2); xlim(xlimits);

xlimits=[ 300 500 ]; 
for ii=1:7
    subplot(7,1,ii);
    xlim(xlimits);
end

timeLabels={ 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'pickup', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket', 'onto maze', 'start trial', 'rewarded', 'into bucket' };
timePoints=[ 17.25 43 60.98 82.81 292.8 375.5 391.5 493.4 525.6 778.2 812 832 863 1104 1187 1302 1332 1583 1639 1661 1691 1891 1973 2026 2044 2320 2351 2375 2401 2619 2664 2751 2778 3003 3039 3076 3097 ];



























    
    
    


    


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
sampleRate = 32000;
halfWindowSize = 10*32000; % elements
overlapSize = 30*-32000;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
%jumpSize=(2*halfWindowSize+1) - overlapSize ;
jumpSize = sampleRate*2 ;

outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
meanDiff = zeros( 1, outputPoints );
eeMean  = zeros( 1, outputPoints );
overlapTimes = zeros( 1, outputPoints );
newSampleRate = sampleRate/jumpSize;
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
EpisodeIdxs=round(signalSampleRate*1):round(length(signalEnvelope) - signalSampleRate*1 );
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


