function output = analyzeSWRda5( metadata )

metadata.dir=[ metadata.baseDir metadata.rat '/' metadata.day '/'  ];
disp(metadata.dir);

metadata.dayOld = metadata.day;
metadata.day = strrep(metadata.day, '/', '');

tic;

close all;

disp('SETUP ANALYSIS RUN')
if metadata.autobins
    disp('using automatic bin detection');
end

%% I. SETUP THE ANALYSIS RUN
% 

if ~exist( [ metadata.outputDir 'cache/filters.mat' ], 'file' )
    disp('building filters');
    makeFilters;
    save( [ metadata.outputDir 'cache/filters.mat' ], 'filters');
else
    disp('loading filters');
    load([metadata.outputDir 'cache/filters.mat'], 'filters');
end


%% LOAD AVERAGE LFPs

if ~exist( [ metadata.outputDir '/cache/' metadata.rat '_' metadata.day '_avgLfp.mat' ], 'file' )
    disp('building avg signal LFP');
    avgLfp=avgLfpFromList( metadata.dir, metadata.fileListGoodLfp, metadata.lfpStartIdx );  % build average LFP
    save( [ metadata.outputDir '/cache/' metadata.rat '_' metadata.day '_avgLfp.mat' ], 'avgLfp');
else
    disp('loading avg signal LFP');
    load( [ metadata.outputDir '/cache/' metadata.rat '_' metadata.day '_avgLfp.mat' ], 'avgLfp' );
end

if ~exist( [ metadata.outputDir '/cache/' metadata.rat '_' metadata.day '_avgDisconnectedLfp.mat' ], 'file' )
    disp('building avg electrical LFP');
    avgDisconnectedLfp=avgLfpFromList( metadata.dir, metadata.fileListDisconnectedLfp, metadata.lfpStartIdx );  % build average LFP
    save( [ metadata.outputDir metadata.rat '_' metadata.day '_avgDisconnectedLfp.mat' ], 'avgDisconnectedLfp');
else
    disp('loading avg electrical LFP');
    load( [ metadata.outputDir '/cache/' metadata.rat '_' metadata.day '_avgDisconnectedLfp.mat' ], 'avgDisconnectedLfp' );
end


%% LOAD SWR CANDIDATE
% 88, 61, 32 suspected SWR channel
toc
disp('loading SWR file');
[ blob.swrLfp, blob.lfpTimestamps ] = csc2mat( [ metadata.dir metadata.swrLfpFile ], metadata.lfpStartIdx );
blob.lfpTimestampSeconds=(blob.lfpTimestamps-blob.lfpTimestamps(1))/1e6;
% [ lfp61 ] = csc2mat( [ metadata.dir 'CSC61.ncs' ], metadata.lfpStartIdx );
% [ lfp32 ] = csc2mat( [ metadata.dir 'CSC32.ncs' ], metadata.lfpStartIdx );

% load telemetry data
[ blob.xpos, blob.ypos, blob.xytimestamps, ~, ~ ]=nvt2mat([ metadata.dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(blob.xytimestamps-blob.lfpTimestamps(1)));
blob.xpos=nlxPositionFixer(blob.xpos(xyStartIdx:end)); 
blob.ypos=nlxPositionFixer(blob.ypos(xyStartIdx:end)); 
blob.xytimestamps=blob.xytimestamps(xyStartIdx:end);
xyblob.xytimestampSeconds = ( blob.xytimestamps - blob.xytimestamps(1) )/1e6;

[~, antiRadius ] = cart2pol(blob.xpos-metadata.waypoints.antireward.x, blob.ypos-metadata.waypoints.antireward.y);
[~, rewardRadius ] = cart2pol(blob.xpos-metadata.waypoints.reward.x, blob.ypos-metadata.waypoints.reward.y);
antiProx = 800-antiRadius;
rewardProx = 800-rewardRadius;
[ ~, antiProxTimes, ~, ~ ] = findpeaks( antiProx, xyblob.xytimestampSeconds, 'MinPeakHeight', 700, 'MinPeakDistance', 10  ); 
[ ~, rewardProxTimes, ~, ~ ] = findpeaks( rewardProx, xyblob.xytimestampSeconds, 'MinPeakHeight', 700, 'MinPeakDistance', 10  ); 


%  =============================
%% == DETECT ELECTRICAL NOISE ==
%  =============================
toc
disp('DETECT ELECTRICAL NOISE')
%
% the baseline of the rat's 60 hz is correlated with the distance from the
% light. in the bucket is usually best, but the baseline subtely depends on
% where the bucket is. on the maze, his 60 hz is lowest in the center.
% Spikes occur when I touch the rat or the wire, thus there is always a
% spike when the rat is picked up at the end of a run, and not necesarilly
% at the beginning. (sometimes rats voluntarily jump onto start)
%
% Here, we use the disconnected LFP. I suspect it has a stronger, clearer
% 60 Hz signal, but this has not been thoroughly tested. That said, it
% works quite well as written.
%
electricLFP=filtfilt( filters.so.electric, avgDisconnectedLfp );
blob.electricEnv=abs(hilbert(electricLFP));                  % Env -- envelope
%
% ** call this to try to detect just the sharp, tall peaks

% [ ~, electricLfpTimestamps ] = csc2mat( [ metadata.dir (metadata.fileListDisconnectedLfp{1}) ], metadata.lfpStartIdx );
% electricLfpTimestampSeconds = (electricLfpTimestamps-electricLfpTimestamps(1))/1e6;
% electricLfpTimestampSeconds=sort(electricLfpTimestampSeconds);

electricSignal.EpisodeIdxs = round( metadata.sampleRate.lfp*2):round(length(blob.electricEnv) - metadata.sampleRate.lfp*2 );
electricSignal.maxPeak = max( blob.electricEnv(electricSignal.EpisodeIdxs) );
electricSignal.peakThreshold = (0.5 * electricSignal.maxPeak );
electricSignal.minPeakDistance = 20; % seconds
[ electricSignal.PeakValues,  ...
  electricSignal.PeakTimes,   ...
  electricSignal.PeakProminances, ...
  electricSignal.PeakWidths ] = findpeaks( blob.electricEnv,                    ... % data
                                           blob.lfpTimestampSeconds,             ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                          'MinPeakHeight',   electricSignal.peakThreshold,  ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                          'MinPeakDistance', electricSignal.minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak


%  ====================
%% == DETECT CHEWING ==
%  ====================
%
toc
disp('DETECT CHEWING')
% detect chewing events -- refered to as "crunch" because that's what they
% sound like. First, filter a fairly wide band to see the crunches
%
avgChew = filtfilt( filters.so.chew, avgLfp );
%
% These crunches occur at about 3-6 Hz, so I build a wide envelope-like
% signal in which to seek these groups; regular envelope at this sample
% rate is too wobbly to detect the dead-obvious to the eye crunch groups.
%

[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, blob.lfpTimestampSeconds );
% these filters depend on the ouput above.
filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%
% Next, find groups of crunches, refered to as "chewing episodes"/"reward"
%
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));



chewDetectorOutput = detectPeaksEdgesDa5( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );



%  =========================================================
%% == DETECT TRIAL BREAKPOINTS : REWARDS & BUCKET ENTRIES ==
%  =========================================================
toc
disp('DETECT TRIAL BREAKPOINTS : REWARDS & BUCKET ENTRIES')
%
% this is accomplished by finding each reward chewing episode, and finding
% the nearest electrical band signal spike that occurs afterwards because
% the rat is always placed in the bucket after the reward is obtained, and
% that always involves grabbing his tail
%
output.sugarConsumeTimes = [];
output.leaveMazeToBucket = [];
for ii = 1:length(chewDetectorOutput.EpisodePeakTimes)
    if ( ii > 1 ) && ( (chewDetectorOutput.EpisodePeakTimes(ii)-chewDetectorOutput.EpisodePeakTimes(ii-1)) < 20 )
        disp('skipping a chew peak');
    else
        relativeTimes = electricSignal.PeakTimes - chewDetectorOutput.EpisodePeakTimes(ii);
        [ ~, jj ] = min( abs( relativeTimes ));
        % if the closest time is negative AND it's not the last element AND
        % the next closest time less than 
        if ( relativeTimes(jj) > 0 )
            % things are OK
            output.sugarConsumeTimes = [ output.sugarConsumeTimes chewDetectorOutput.EpisodePeakTimes(ii) ];
            output.leaveMazeToBucket = [ output.leaveMazeToBucket electricSignal.PeakTimes(jj) ];
        else
            if ( jj < length(relativeTimes) )
                if ( relativeTimes(jj+1) < 40 )
                    % use this event
                    output.sugarConsumeTimes = [ output.sugarConsumeTimes chewDetectorOutput.EpisodePeakTimes(ii) ];
                    output.leaveMazeToBucket = [ output.leaveMazeToBucket electricSignal.PeakTimes(jj+1) ];
                else
                    disp('could not find bucket placement event after reward receipt; too far in futre')
                end
            else
                disp('could not find bucket placement event after reward receipt; no more events')
            end
        end
    end
end



if abs( length(find(output.sugarConsumeTimes)) - length(find(output.leaveMazeToBucket)) ) > 2
    error('reward and bucket entrance detection failed; unequal number of events');
elseif length(find(output.sugarConsumeTimes)) ~= length(find(output.leaveMazeToBucket))
    warning('reward and bucket entrance detection; unequal number of events detected');
end



%  ===============================
%% == FIND THE MAZE ENTRY TIMES ==
%  ===============================
toc
disp('FIND THE MAZE ENTRY TIMES')
%
% this is tricky because in order to get the rat on the maze oriented in
% the right way, I pick up the bucket and tilt it towards myself and the
% wall so he can only face the intended direction. I did this because the
% first rats always squirmed around and I had no control over their initial
% view of space.
%
% the approach is long. Because the rat is not always picked up, and can
% walk out voluntarily, but the electrical signal increases due to closer
% proximity to a light, there is generally at least a small increase in the
% 60 hz baseline, but not always a big spike. Thus, the system averages
% over a long time window to make a smooth, low freqneucy signal suitable
% for detecting those changes in baseline. The baselines shifts are 
% detected in the derivative of this signal.
%
% % obtain A MOVING, WINDOWED MEDIAN     %% TODO -- this could be made into a function
inputElements = length(blob.electricEnv);
halfWindowSize = round(30*metadata.sampleRate.lfp);  % elements
overlapSize = round(1.8*halfWindowSize);    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
%
mazeEntries.outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
mazeEntries.mvgMedian = zeros( 1, mazeEntries.outputPoints );
mazeEntries.mvgMedianTimes = zeros( 1, mazeEntries.outputPoints );
mazeEntries.mvgMedianSampleRate = metadata.sampleRate.lfp/jumpSize;
mazeEntries.outputIdx = 1;
%
% initialize...
mazeEntries.mvgMedian(1)=median(blob.electricEnv(1:metadata.sampleRate.lfp));
mazeEntries.mvgMedianTimes(1) = blob.lfpTimestampSeconds(1);
%
mazeEntries.outputIdx = 2;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(blob.electricEnv(1:round(halfWindowSize/2)));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = blob.lfpTimestampSeconds(round(halfWindowSize/4));
%
mazeEntries.outputIdx = 3;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(blob.electricEnv(1:halfWindowSize));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = blob.lfpTimestampSeconds(round(halfWindowSize/2));
%
mazeEntries.outputIdx = 4;
for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(blob.electricEnv(ii));
    mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = blob.lfpTimestampSeconds(idx);
    mazeEntries.outputIdx = mazeEntries.outputIdx + 1;
end
%
% finalize
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(blob.electricEnv(end-halfWindowSize:end));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = blob.lfpTimestampSeconds(end-round(halfWindowSize/2));
mazeEntries.outputIdx = mazeEntries.outputIdx+1;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(blob.electricEnv(end-round(halfWindowSize/2):end));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = blob.lfpTimestampSeconds(end-round(halfWindowSize/4));
mazeEntries.outputIdx = mazeEntries.outputIdx+1;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(blob.electricEnv(end-metadata.sampleRate.lfp:end));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = blob.lfpTimestampSeconds(end);
% find peaks in the differential of the moving median
mazeEntries.elecBaseline=diff(mazeEntries.mvgMedian);
mazeEntries.maxPeak = max(  mazeEntries.elecBaseline );
mazeEntries.peakThreshold = (0.15 * mazeEntries.maxPeak );
mazeEntries.minPeakDistance = 20; % seconds
[ elecBaselineJumpValues,  ...
  elecBaselineJumpTimes,   ...
  transMvgMedProminances, ...
  transMvgMedPeakWidths ] = findpeaks( mazeEntries.elecBaseline,                    ... % data
                                       mazeEntries.mvgMedianTimes(2:end),             ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                       'MinPeakHeight',   mazeEntries.peakThreshold,  ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                       'MinPeakDistance', mazeEntries.minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak

mazeEntries.maxPeak = max(  -mazeEntries.elecBaseline );
mazeEntries.peakThreshold = (0.1 * mazeEntries.maxPeak );
mazeEntries.minPeakDistance = 20; % seconds
[ elecBaselineDropValues,  ...
  elecBaselineDropTimes,   ...
  transMvgMedProminances, ...
  transMvgMedPeakWidths ] = findpeaks( mazeEntries.elecBaseline,                    ... % data
                                       mazeEntries.mvgMedianTimes(2:end),             ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                       'MinPeakHeight',   mazeEntries.peakThreshold,  ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                       'MinPeakDistance', mazeEntries.minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
             
                                   
                                   %
% we know from chews and tail grabs (bucket placements) when episodes end.
% so now start at the bucket placement, and look forward through the peaks
% in the electric transitions to find start points
output.leaveBucketToMaze = zeros(size(output.leaveMazeToBucket));
if ( median(mazeEntries.mvgMedian(1:20)) < (median(mazeEntries.mvgMedian)*2) )
    output.leaveBucketToMaze(1) = mazeEntries.mvgMedianTimes(1); % this is a cheap hack
    startIdx=2;
else
    startIdx=1;
    disp('check ontoMaze times!');
end
for idxTrialEnd=startIdx:length(output.leaveMazeToBucket)
        if idxTrialEnd > 1
            relativeTimes = elecBaselineJumpTimes - output.leaveMazeToBucket(idxTrialEnd-1);
        else
            relativeTimes = elecBaselineJumpTimes - output.leaveMazeToBucket(idxTrialEnd);
        end
        [ ~, jj ] = min( abs( relativeTimes ));
        offset = 0;
        while ( (jj+offset < length(relativeTimes) ) && (relativeTimes(jj+offset) < 40 )   ) 
            offset = offset + 1;
        end
        output.leaveBucketToMaze(idxTrialEnd)=elecBaselineJumpTimes(jj+offset);
end



% =========================================
%% ==  CALCULATE PROXIMITY TO WAYPOITNS  ==
% =========================================
toc
disp('CALCULATE PROXIMITY TO WAYPOITNS')
%
proxToCenter=proxToPoint( blob.xpos, blob.ypos, metadata.waypoints.center.x, metadata.waypoints.center.y );
proxToStart=proxToPoint( blob.xpos, blob.ypos, metadata.waypoints.start.x, metadata.waypoints.start.y );
proxToRewardSite=proxToPoint( blob.xpos, blob.ypos, metadata.waypoints.reward.x, metadata.waypoints.reward.y );
proxToIncorrectSite=proxToPoint( blob.xpos, blob.ypos, metadata.waypoints.antireward.x, metadata.waypoints.antireward.y );



%  ====================================
%% ==  IDENTIFY BRICK PASSAGE TIMES  ==
%  ====================================
toc
disp('IDENTIFY BRICK PASSAGE TIMES')
%
% CALCULATE PERIODS WHEN THE RAT IS AT THE START
%
inputElements = length(proxToStart);
halfWindowSize = round(9*metadata.sampleRate.telemetry); % elements
overlapSize = round(.99*2*halfWindowSize); % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
%
outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
mvgMedian = zeros( 1, outputPoints );
mvgMedianTimes = zeros( 1, outputPoints );
mvgMedianSampleRate = metadata.sampleRate.telemetry/jumpSize;
outputIdx = 1;
%
for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mvgMedian(outputIdx)=median(proxToStart(ii));
    mvgMedianTimes(outputIdx) = xyblob.xytimestampSeconds(idx);
    outputIdx = outputIdx + 1;
end
outputIdx = outputIdx - 1;
%
% sometimes the rounding leaves a zero at the end and findpeaks can't
% handle that.
mvgMedian = mvgMedian( 1:outputIdx );
mvgMedianTimes = mvgMedianTimes( 1:outputIdx );

startEpisodes = detectPeaksEdgesDa5( mvgMedian, mvgMedianTimes, mvgMedianSampleRate, mvgMedianSampleRate, .75, 10, .85 );

% find peaks in the moving median
elecBaseline=diff(mvgMedian);
maxPeak = max(  elecBaseline );
peakThreshold = (0.75 * maxPeak );
minPeakDistance = 20; % seconds
[ elecBaselineJumpValues, ...
  elecBaselineJumpTimes, ...
  transMvgMedProminances, ...
  transMvgMedPeakWidths ] = findpeaks(  elecBaseline,                              ... % data
                                        mvgMedianTimes(2:end),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    peakThreshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
%subplot(2,1,2); hold on; scatter( transMvgMedPeakTimes, transMvgMedPeakValues, '*'); %, 'filled');
%
% we know from chews and tail grabs (bucket placements) when episodes end.
% so now start at the bucket placement, and look forward through the peaks
% in the electric transitions to find start points
output.leaveBucketToMaze = zeros(size(output.leaveMazeToBucket));
if ( median(elecBaseline(1:20)) < (median(elecBaseline)*2) )
    output.leaveBucketToMaze(1) = mvgMedianTimes(1); % this is a cheap hack
else
    disp('implement something here!');
end
for idxTrialEnd=1:length(output.leaveMazeToBucket)-1
        relativeTimes = elecBaselineJumpTimes - output.leaveMazeToBucket(idxTrialEnd);
        [ ~, jj ] = min( abs( relativeTimes ));
        offset = 0;
        while ( (jj+offset < length(relativeTimes) ) && (relativeTimes(jj+offset) < 40 )   ) 
            offset = offset + 1;
        end
        output.leaveBucketToMaze(idxTrialEnd)=elecBaselineJumpTimes(jj+offset);
        
end

output.leaveBucketToMaze = mvgMedianTimes( startEpisodes.EpisodeStartIdxs);
output.trialStartAction = mvgMedianTimes( startEpisodes.EpisodeEndIdxs);


%
% ; make a list of times for trial events
%
if metadata.autobins
    swrAnalysisBins = sort([ 0 output.leaveBucketToMaze output.trialStartAction output.sugarConsumeTimes output.leaveMazeToBucket xyblob.xytimestampSeconds(end) ]);
else
    swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket xyblob.xytimestampSeconds(end) ]);
end



%  ====================
%% == DETECT BRUXING ==
%  ====================
toc
disp('DETECT BRUXING')
%
bruxEpisodeLFP=filtfilt( filters.ao.brux, chewCrunchEnv );
bruxEpisodeEnv=abs(hilbert(bruxEpisodeLFP));
bruxDetectorOutput = detectPeaksEdgesDa5( bruxEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );



% =====================
%% ==  SWR -- LFP 88  ==
% =====================
toc
disp('PROCESS SWR FILE')
%
swrblob.swrLfp = filtfilt( filters.so.swr, blob.swrLfp );
swrblob.swrLfpEnv = abs( hilbert(swrblob.swrLfp) );

swrEnvMedian = median(swrblob.swrLfpEnv);
swrEnvMadam  = median(abs(swrblob.swrLfpEnv-swrEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );

[ swrPeakValues,      ...
  swrPeakTimes,       ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks( swrblob.swrLfpEnv,                        ... % data
                             blob.lfpTimestampSeconds,                     ... % sampling frequency
                             'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak



%  ============================
%% ==   CALCULATE VELOCITY   ==
%  ============================
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(blob.xpos, blob.ypos, lagTime, pxPerCm);


%  ==========================================
%% ==    EXCLUDE CHEW/BRUX CONFOUNDS       ==
%  ==========================================
toc
disp('EXCLUDE CHEW/BRUX CONFOUNDS')
%
% subtract each peak time and eliminate those within 1 s of the peak on
% either side
%
% store swr times and potential confound data
output.swrPeakTimes=swrPeakTimes;
output.chewTimes.start = chewCrunchEnvTimes(chewDetectorOutput.EpisodeStartIdxs);
output.chewTimes.end = chewCrunchEnvTimes(chewDetectorOutput.EpisodeEndIdxs);
output.chewTimes.end = chewDetectorOutput.EpisodePeakTimes;
output.bruxTimes = chewCrunchEnvTimes(bruxDetectorOutput.EpisodeStartIdxs);
output.chewTimes.end = chewCrunchEnvTimes(bruxDetectorOutput.EpisodeEndIdxs);
output.chewTimes.end = bruxDetectorOutput.EpisodePeakTimes;
output.electricTimes = electricSignal.PeakTimes;
%
output.swrPeakTimesDenoise=swrPeakTimes;
output.swrPeakValuesDenoise=swrPeakValues;

if metadata.chewRemovalEnabled
    for ii=1:length(chewDetectorOutput.EpisodePeakTimes)
        idx = find( ( output.swrPeakTimesDenoise > chewCrunchEnvTimes(chewDetectorOutput.EpisodeStartIdxs(ii)) ) .* ( output.swrPeakTimesDenoise < chewCrunchEnvTimes(chewDetectorOutput.EpisodeEndIdxs(ii)) ) );
        output.swrPeakTimesDenoise(idx)=NaN;
        output.swrPeakValuesDenoise(idx)=NaN;
    end
    for ii=1:length(bruxDetectorOutput.EpisodePeakTimes)
        idx = find( ( output.swrPeakTimesDenoise > chewCrunchEnvTimes(bruxDetectorOutput.EpisodeStartIdxs(ii)) ) & ( output.swrPeakTimesDenoise < chewCrunchEnvTimes(bruxDetectorOutput.EpisodeEndIdxs(ii)) ) );
        output.swrPeakTimesDenoise(idx)=NaN;
        output.swrPeakValuesDenoise(idx)=NaN;
        %output.swrPeakTimesDenoise(find(abs(output.swrPeakTimesDenoise-bruxDetectorOutput.EpisodePeakTimes(ii))<1))=[];
    end
%     for ii=1:length(electricSignal.PeakTimes)
%         idx = find(abs(output.swrPeakTimesDenoise-electricSignal.PeakTimes(ii))<1);
%         output.swrPeakTimesDenoise(idx)=NaN;
%         output.swrPeakValuesDenoise(idx)=NaN;
%     end
    output.swrPeakTimesDenoise(isnan(output.swrPeakTimesDenoise))=[];
    output.swrPeakValuesDenoise(isnan(output.swrPeakValuesDenoise))=[];
else
    warning('not removing chews')
end




%  =======================================================
%% ==    display trial auto-partitioning summary data   ==
%  =======================================================
toc
disp('display trial auto-partitioning summary data')
%
gcf(4)=figure(4); 
subplot(4,1,1); 
plot( blob.lfpTimestampSeconds, blob.electricEnv, 'k' );    
hold on;
plot( mazeEntries.mvgMedianTimes, mazeEntries.mvgMedian, 'r' );
%plot( mazeEntries.mvgMedianTimes(2:end), mazeEntries.elecBaseline );
scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
axis tight;  
ylim([ min(mazeEntries.elecBaseline) max(electricSignal.PeakValues) ]);
ylabel('Avg; 60 Hz');
subplot(4,1,2); 
plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .2 .7 .2 ] ); 
hold on;
scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
axis tight;
ylim([0 max(chewDetectorOutput.EpisodePeakValues)]);
ylabel('reward/chew');
subplot(4,1,3); 
plot( chewCrunchEnvTimes, bruxEpisodeEnv, 'Color', [ .7 .2 .2 ] ); 
hold on;
scatter( bruxDetectorOutput.EpisodePeakTimes, bruxDetectorOutput.EpisodePeakValues, 'v', 'filled');
axis tight;
ylim([0 max(bruxDetectorOutput.EpisodePeakValues)]);
ylabel('brux');
subplot(4,1,4); 
hold off; 
plot( mvgMedianTimes, mvgMedian ); 
hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
plot( xyblob.xytimestampSeconds, proxToRewardSite ); 
scatter( output.leaveBucketToMaze, ones(1,length(output.leaveBucketToMaze)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.trialStartAction, ones(1,length(output.trialStartAction)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.sugarConsumeTimes, ones(1,length(output.sugarConsumeTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.leaveMazeToBucket, ones(1,length(output.leaveMazeToBucket)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
print( gcf(4), [metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '')  '_finalAutoTrialMarking.png'],'-dpng','-r200');



output.autopartition.ontoMazeTimes = output.leaveBucketToMaze;
output.autopartition.runStartTimes = output.trialStartAction;
output.autopartition.rewardTimes = output.sugarConsumeTimes;
output.autopartition.intoBucketTimes = output.leaveMazeToBucket;


% for manual intervention, use the provided markers for the subsequent
% analysis
if ~metadata.autobins
    
    output.leaveBucketToMaze = metadata.leaveBucketToMaze; 
    output.trialStartAction  = metadata.trialStartAction; 
    output.sugarConsumeTimes = metadata.sugarConsumeTimes;
    output.leaveMazeToBucket = metadata.leaveMazeToBucket;
    
    output.ratPickupTeleport = metadata.ratPickupTeleport;
    output.restartmaze       = metadata.restartmaze;
    output.restartTrial      = metadata.restartTrial;
    
    swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket xyblob.xytimestampSeconds(end) ]);
    
end



%  ================================================
%% ==        display SWR rate summary data       ==
%  ================================================
toc
disp('display SWR rate summary data')
%
gcf(5)=figure(5); 
subplot(4,1,1); 
output.swrRateRaw = 1./diff(output.swrPeakTimes);
output.swrRate = 1./diff(output.swrPeakTimesDenoise);
plot( output.swrPeakTimes(1:end-1)+(diff(output.swrPeakTimes)/2), output.swrRateRaw ); hold on;
plot( output.swrPeakTimesDenoise(1:end-1)+(diff(output.swrPeakTimesDenoise)/2), output.swrRate )
hold on;
scatter( output.leaveBucketToMaze, zeros(1,length(output.leaveBucketToMaze)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.trialStartAction, zeros(1,length(output.trialStartAction)), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.sugarConsumeTimes, zeros(1,length(output.sugarConsumeTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .7 .95 ]);
scatter( output.leaveMazeToBucket, zeros(1,length(output.leaveMazeToBucket)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel('SWR_{rate}'); 
xlim([0 blob.lfpTimestampSeconds(end)]); 
ylim([-0.1 max(output.swrRate)]);
subplot(4,1,2); 
plot( mvgMedianTimes, mvgMedian ); 
hold on;
scatter( output.leaveBucketToMaze, ones(1,length(output.leaveBucketToMaze)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.trialStartAction, ones(1,length(output.trialStartAction)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.sugarConsumeTimes, ones(1,length(output.sugarConsumeTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.leaveMazeToBucket, ones(1,length(output.leaveMazeToBucket)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
%
scatter( output.autopartition.ontoMazeTimes, zeros(1,length(output.autopartition.ontoMazeTimes)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ .7 .5 0 ] );
scatter( output.autopartition.runStartTimes, zeros(1,length(output.autopartition.runStartTimes)), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .1 .3 0 ]);
scatter( output.autopartition.rewardTimes, zeros(1,length(output.autopartition.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .2 .2 .7 ]);
scatter( output.autopartition.intoBucketTimes, zeros(1,length(output.autopartition.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .6 .1 .1 ]);
%
ylabel( 'start prox./trial ev.' ); 
axis tight; 
ylim([ 0 1 ]);
subplot(4,1,3); 
histogram( output.swrPeakTimesDenoise, swrAnalysisBins ); 
title('SWR Frequency'); 
xlabel('time (s)'); ylabel('counts'); axis tight;
subplot(4,1,4); hold off;
xx=swrAnalysisBins(1:end-1)+diff(swrAnalysisBins)/2;
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
plot( xx, yy ); 
hold on;
title('SWR rate'); xlabel('time (s)'); ylabel('Hz'); axis tight;
[vals,idxs]=intersect(swrAnalysisBins,output.leaveBucketToMaze);
scatter( xx(idxs), yy(idxs), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );;
output.swrAnalysisBinLabels(idxs) = 1;
[vals,idxs]=intersect(swrAnalysisBins,output.trialStartAction);
scatter( xx(idxs), yy(idxs), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
output.swrAnalysisBinLabels(idxs) = 2;
[vals,idxs]=intersect(swrAnalysisBins,output.sugarConsumeTimes);
scatter( xx(idxs), yy(idxs), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
output.swrAnalysisBinLabels(idxs) = 3;
[vals,idxs]=intersect(swrAnalysisBins,output.leaveMazeToBucket);
scatter( xx(idxs), yy(idxs), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
output.swrAnalysisBinLabels(idxs) = 4;
xlim([-0.05 blob.lfpTimestampSeconds(end)]);
print( gcf(5), [metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '')  '_SWRrateSummary.png'],'-dpng','-r200');



%  ==============================
%% ==        save data         ==
%  ==============================
toc
disp('save data')
%
output.blob.electricEnv = blob.electricEnv;
output.blob.lfpTimestampSeconds = blob.lfpTimestampSeconds;
output.blob.xpos = blob.xpos;
output.blob.ypos = blob.ypos;
output.proxToStart = proxToStart;
ouput.chewCrunchEnv = chewCrunchEnv;
ouput.chewCrunchEnvTimes = chewCrunchEnvTimes;
ouput.chewCrunchEnvSampleRate = chewCrunchEnvSampleRate;
output.elecBaselineJumpValues = elecBaselineJumpValues;
output.elecBaselineJumpTimes = elecBaselineJumpTimes;
output.elecBaselineDropValues = elecBaselineDropValues;
output.elecBaselineDropTimes = elecBaselineDropTimes;

% electric peaks
output.electricPeakTimes = electricSignal.PeakTimes;
% crunch times
output.chewPeakTimes = chewDetectorOutput.EpisodePeakTimes;
% brux times
output.bruxPeaksTimes = bruxDetectorOutput.EpisodePeakTimes;
% all swr times
output.swrPeaksTimes = swrPeakTimes;
% eliminated swr times
output.swrDenoisePeaksTimes = output.swrPeakTimesDenoise;

output.swrEnvMedian = swrEnvMedian;
output.swrEnvMadam  = swrEnvMadam ;
output.swrThreshold = swrThreshold;

output.antiRadius = antiProx;
output.rewardRadius = rewardProx;
output.antiProxTimes = antiProxTimes;
output.rewardProxTimes = rewardProxTimes;

save([metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '') '_output'], 'output' );


%% terminate the script
toc
disp('COMPLETE')

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
