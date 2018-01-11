function output = analyzeSWR( metadata )

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
% I.A. PARAMETERS
sampleRate.lfp=32000;
sampleRate.telemetry=29.97;

makeFilters;

% I.B. LOAD AVERAGE LFP
avgLfp=avgLfpFromList( metadata.dir, metadata.fileListGoodLfp, metadata.lfpStartIdx );  % build average LFP
avgDisconnectedLfp=avgLfpFromList( metadata.dir, metadata.fileListDisconnectedLfp, metadata.lfpStartIdx );  % build average LFP

% 
% 88, 61, 32 suspected SWR channel
[ lfp88, lfpTimestamps ] = csc2mat( [ metadata.dir metadata.lfpFile ], metadata.lfpStartIdx );
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
% [ lfp61 ] = csc2mat( [ metadata.dir 'CSC61.ncs' ], metadata.lfpStartIdx );
% [ lfp32 ] = csc2mat( [ metadata.dir 'CSC32.ncs' ], metadata.lfpStartIdx );

% load telemetry data
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ metadata.dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(xytimestamps-lfpTimestamps(1)));
xpos=nlxPositionFixer(xpos(xyStartIdx:end)); 
ypos=nlxPositionFixer(ypos(xyStartIdx:end));
xytimestamps=xytimestamps(xyStartIdx:end);
xytimestampSeconds = ( xytimestamps - xytimestamps(1) )/1e6;

disp('DETECT ELECTRICAL NOISE')
%  =============================
%% == DETECT ELECTRICAL NOISE ==
%  =============================
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
electricEnv=abs(hilbert(electricLFP));                  % Env -- envelope
%
% ** call this to try to detect just the sharp, tall peaks

electricSignal.EpisodeIdxs = round( sampleRate.lfp*2):round(length(electricEnv) - sampleRate.lfp*2 );
electricSignal.maxPeak = max( electricEnv(electricSignal.EpisodeIdxs) );
electricSignal.peakThreshold = (0.2 * electricSignal.maxPeak );
electricSignal.minPeakDistance = 20; % seconds
[ electricSignal.PeakValues,  ...
  electricSignal.PeakTimes,   ...
  electricSignal.PeakProminances, ...
  electricSignal.PeakWidths ] = findpeaks( electricEnv,                    ... % data
                                           timestampSeconds,             ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                          'MinPeakHeight',   electricSignal.peakThreshold,  ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                          'MinPeakDistance', electricSignal.minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
%electricDetectorOutput = detectPeaksEdges( electricEnv, timestampSeconds, sampleRate.lfp, round(sampleRate.lfp/10) );

if metadata.visualizeAll
   figure(1);
   subplot(4,1,1);
   hold off;
   plot( timestampSeconds, electricEnv ); hold on;
   scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
   load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
   ylabel('elec.');
   xlim([0 timestampSeconds(end)]);
   ylim([-0.001 max(electricSignal.PeakValues)]);
end


disp('DETECT CHEWING')
%  ====================
%% == DETECT CHEWING ==
%  ====================
%
% detect chewing events -- refered to as "crunch" because that's what they
% sound like. First, filter a fairly wide band to see the crunches
%
avgChew = filtfilt( filters.so.chew, avgLfp );
%
% These crunches occur at about 3-6 Hz, so I build a wide envelope-like
% signal in which to seek these groups; regular envelope at this sample
% rate is too wobbly to detect the dead-obvious to the eye crunch groups.
%
[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, timestampSeconds );
% these filters depend on the ouput above.
filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%
% Next, find groups of crunches, refered to as "chewing episodes"/"reward"
%
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));
chewDetectorOutput = detectPeaksEdges( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );

if metadata.visualizeAll
   figure(1);
   subplot(4,1,2);
   hold off;
   plot( chewCrunchEnvTimes, chewEpisodeEnv ); hold on;
   scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
   load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
   for jj=1:length(chewDetectorOutput.EpisodeEndIdxs);
       if  chewDetectorOutput.EpisodeStartIdxs(jj) > 0
           scatter( chewCrunchEnvTimes( chewDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
       else
           scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
       end
       if  chewDetectorOutput.EpisodeEndIdxs(jj) < length(chewCrunchEnvTimes)
           scatter( chewCrunchEnvTimes(  chewDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
       else
           scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
       end
   end
   ylabel('reward');
   xlim([0 timestampSeconds(end)]);
   ylim([-0.001 max([ chewDetectorOutput.EpisodePeakValues electricSignal.PeakValues' ])]);
end


disp('DETECT TRIAL BREAKPOINTS : REWARDS & BUCKET ENTRIES')
%  =========================================================
%% == DETECT TRIAL BREAKPOINTS : REWARDS & BUCKET ENTRIES ==
%  =========================================================
%
% this is accomplished by finding each reward chewing episode, and finding
% the nearest electrical band signal spike that occurs afterwards because
% the rat is always placed in the bucket after the reward is obtained, and
% that always involves grabbing his tail
%
output.rewardTimes = [];
output.intoBucketTimes = [];
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
            output.rewardTimes = [ output.rewardTimes chewDetectorOutput.EpisodePeakTimes(ii) ];
            output.intoBucketTimes = [ output.intoBucketTimes electricSignal.PeakTimes(jj) ];
        else
            if ( jj < length(relativeTimes) )
                if ( relativeTimes(jj+1) < 40 )
                    % use this event
                    output.rewardTimes = [ output.rewardTimes chewDetectorOutput.EpisodePeakTimes(ii) ];
                    output.intoBucketTimes = [ output.intoBucketTimes electricSignal.PeakTimes(jj+1) ];
                else
                    disp('could not find bucket placement event after reward receipt; too far in futre')
                end
            else
                disp('could not find bucket placement event after reward receipt; no more events')
            end
        end
    end
end

gcf=[];

if metadata.visualizeAll
    gcf(1)=figure(1);
    subplot(4,1,4);
    hold off;
    plot( chewCrunchEnvTimes, chewEpisodeEnv );
    hold on;
    plot( timestampSeconds, electricEnv ); 
    scatter( output.rewardTimes, zeros(size(output.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
    scatter( output.intoBucketTimes, zeros(size(output.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
    ylabel('elec.');
    xlim([0 timestampSeconds(end)]);
    ylim([-0.001 max( [ max(electricSignal.PeakValues) max(chewDetectorOutput.EpisodePeakValues) ] ) ]);
end


if length(find(output.rewardTimes)) ~= length(find(output.intoBucketTimes))
    error('reward and bucket entrance detection failed; unequal number of events');
end


disp('FIND THE MAZE ENTRY TIMES')
%  ===============================
%% == FIND THE MAZE ENTRY TIMES ==
%  ===============================
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
inputElements = length(electricEnv);
halfWindowSize = round(30*sampleRate.lfp);  % elements
overlapSize = round(1.8*halfWindowSize);    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
%
mazeEntries.outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
mazeEntries.mvgMedian = zeros( 1, mazeEntries.outputPoints );
mazeEntries.mvgMedianTimes = zeros( 1, mazeEntries.outputPoints );
mazeEntries.mvgMedianSampleRate = sampleRate.lfp/jumpSize;
mazeEntries.outputIdx = 1;
%
% initialize...
mazeEntries.mvgMedian(1)=median(electricEnv(1:sampleRate.lfp));
mazeEntries.mvgMedianTimes(1) = timestampSeconds(1);
%
mazeEntries.outputIdx = 2;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(electricEnv(1:round(halfWindowSize/2)));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = timestampSeconds(round(halfWindowSize/4));
%
mazeEntries.outputIdx = 3;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(electricEnv(1:halfWindowSize));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = timestampSeconds(round(halfWindowSize/2));
%
mazeEntries.outputIdx = 4;
for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(electricEnv(ii));
    mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = timestampSeconds(idx);
    mazeEntries.outputIdx = mazeEntries.outputIdx + 1;
end
%
% finalize
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(electricEnv(end-halfWindowSize:end));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = timestampSeconds(end-round(halfWindowSize/2));
mazeEntries.outputIdx = mazeEntries.outputIdx+1;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(electricEnv(end-round(halfWindowSize/2):end));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = timestampSeconds(end-round(halfWindowSize/4));
mazeEntries.outputIdx = mazeEntries.outputIdx+1;
mazeEntries.mvgMedian(mazeEntries.outputIdx)=median(electricEnv(end-sampleRate.lfp:end));
mazeEntries.mvgMedianTimes(mazeEntries.outputIdx) = timestampSeconds(end);
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

                                   
                                   
                                   
                                   
% figure;
% plot(timestampSeconds,electricEnv);
% hold on;
% plot( mazeEntries.mvgMedianTimes, mazeEntries.mvgMedian );
% plot( mazeEntries.mvgMedianTimes(1:end-1)+diff(mazeEntries.mvgMedianTimes)/2, mazeEntries.elecBaseline );
% scatter( elecBaselineJumpTimes, elecBaselineJumpValues );
% mazeEntries.elecBaseline=-mazeEntries.elecBaseline;
% mazeEntries.maxPeak = max(  mazeEntries.elecBaseline );
% mazeEntries.peakThreshold = (0.2 * mazeEntries.maxPeak );
% [ elecBaselineJumpValues,  ...
%   elecBaselineJumpTimes,   ...
%   transMvgMedProminances, ...
%   transMvgMedPeakWidths ] = findpeaks( mazeEntries.elecBaseline,                    ... % data
%                                        mazeEntries.mvgMedianTimes(2:end),             ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
%                                        'MinPeakHeight',   mazeEntries.peakThreshold,  ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                        'MinPeakDistance', mazeEntries.minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
% scatter( elecBaselineJumpTimes, elecBaselineJumpValues, 'v' );


                                   
                                   
                                   %
% we know from chews and tail grabs (bucket placements) when episodes end.
% so now start at the bucket placement, and look forward through the peaks
% in the electric transitions to find start points
output.ontoMazeTimes = zeros(size(output.intoBucketTimes));
if ( median(mazeEntries.mvgMedian(1:20)) < (median(mazeEntries.mvgMedian)*2) )
    output.ontoMazeTimes(1) = mazeEntries.mvgMedianTimes(1); % this is a cheap hack
    startIdx=2;
else
    startIdx=1;
    disp('check ontoMaze times!');
end
for idxTrialEnd=startIdx:length(output.intoBucketTimes)
        if idxTrialEnd > 1
            relativeTimes = elecBaselineJumpTimes - output.intoBucketTimes(idxTrialEnd-1);
        else
            relativeTimes = elecBaselineJumpTimes - output.intoBucketTimes(idxTrialEnd);
        end
        [ ~, jj ] = min( abs( relativeTimes ));
        offset = 0;
        while ( (jj+offset < length(relativeTimes) ) && (relativeTimes(jj+offset) < 40 )   ) 
            offset = offset + 1;
        end
        output.ontoMazeTimes(idxTrialEnd)=elecBaselineJumpTimes(jj+offset);
end
%
if metadata.visualizeAll
    figure(1);
    subplot(4,1,3);
    hold off;
    plot( mazeEntries.mvgMedianTimes(2:end), mazeEntries.elecBaseline ); hold on;
    scatter( elecBaselineJumpTimes, elecBaselineJumpValues, 'v', 'filled');
    load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
    ylabel('\Delta start.prox.');
    xlim([0 timestampSeconds(end)]);
    ylim([-0.001 max(elecBaselineJumpValues)]);
   %
    subplot(4,1,4);
    hold off;
    plot( chewCrunchEnvTimes, chewEpisodeEnv );
    hold on;
    plot( timestampSeconds, electricEnv ); 
    scatter( output.rewardTimes, zeros(size(output.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
    scatter( output.intoBucketTimes, zeros(size(output.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
    scatter( output.ontoMazeTimes, zeros(size(output.ontoMazeTimes)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
    ylabel('events');
    xlim([0 timestampSeconds(end)]);
    ylim([-0.001 max( [ max(electricSignal.PeakValues) max(chewDetectorOutput.EpisodePeakValues) ] ) ]);
end
print( gcf(1), [metadata.outputDir metadata.rat '_' metadata.day '_autotrial1'],'-dpng','-r200');

if abs ( length(find(output.rewardTimes)) - length(find(output.ontoMazeTimes)) ) > 2
    if metadata.autobins
        error('reward and trial start detection failed; unequal number of events');
    else
        warning('reward and trial start detection failed; unequal number of events');
    end
end


disp('"FIX" WEIRD BUCKET TELEMETRY JUMPS')
%  ========================================
%% == "FIX" WEIRD BUCKET TELEMETRY JUMPS ==
%  ========================================
%
% Now that we know when the rat was in the bucket from the above analysis,
% we can fix the weird jumps that occur when the rat hides his head LEDs
% from the camera in the bucket, and the telemetry signal jumps from the
% bucket to some bright point on the maze.
%
% This is accomplished by simply using the boundaries identified above and 
% taking the median value of the rat's position. This seems to work well. A
% small amount of normally distributed noise is added to the signal to make
% the settling points easier to identify on an X-Y plot. (otherwise they
% are single points, and cannot be identified.)
%
% This may not be the greatest method, and other things could be attempted,
% but it seems to work effectively.
%
% This procedure is performed before the next step to help avoid the next
% step getting confused.
%
if length(output.ontoMazeTimes) ~= length(output.intoBucketTimes)
    warning('trial start and end time arrays are of unequal size!!!')
    % not going to correct for this possible error.
end
% 
old.xpos = xpos; old.ypos = ypos;
%xpos = old.xpos; ypos = old.ypos;
%
% * there should be trials-1 'intermissions'
% * output.ontoMazeTimes need to be offset from intoBucket because one mounts
% maze, then enters bucket, onto maze, enter bucket...
for ii = 1:length(output.intoBucketTimes)-1
    % find start and end indices of the bucket episode
    % try to offset the time by a few seconds to account for time to put
    % him down or pick him up (high accel/vel makes sense during these
    % brief episodes of teleportation)
    startIdx = round((output.intoBucketTimes(ii)+1) * sampleRate.telemetry);
    endIdx   = round((output.ontoMazeTimes(ii+1)-3) * sampleRate.telemetry);
    if endIdx < startIdx
        startIdx = round((output.intoBucketTimes(ii)) * sampleRate.telemetry);
        endIdx   = round((output.ontoMazeTimes(ii+1)) * sampleRate.telemetry);
    end
    if ( endIdx < startIdx ) && ( ii == length(output.intoBucketTimes) ) % TODO it doesn't find an end for out bucket time, because trials end
        endIdx = length(xpos);
    end
    if endIdx < startIdx; error('endIdx > startIdx in bucket position correction routine.'); end
    xpos(startIdx:endIdx) = median(xpos(startIdx:endIdx))+5*rand(size(xpos(startIdx:endIdx)));
    ypos(startIdx:endIdx) = median(ypos(startIdx:endIdx))+5*rand(size(xpos(startIdx:endIdx)));
end
% ==================================================
% ==  RECALCULATE TELEMETRY BASED ON CORRECTIONS  ==
% ==================================================
proxToCenter=proxToPoint( xpos, ypos, 317, 229 );
proxToStart=proxToPoint( xpos, ypos, 81, 412 );
proxToRewardSite=proxToPoint( xpos, ypos, 119, 45 );
proxToIncorrectSite=proxToPoint( xpos, ypos, 525, 429 );
%
if metadata.visualizeAll
    gcf(2)=figure(2); % demonstrate position correction to check if it was appropriate
    subplot(3,1,1);
    title('confirm bucket telemetry corrections');
    plot( timestampSeconds, electricEnv );
    hold on;
    ylabel('elec.');
    axis tight;
    subplot(3,1,2);
    plot( xytimestampSeconds, old.xpos, 'k' );
    ylabel('xpos_{before}');
    axis tight;
    subplot(3,1,3);
    plot( xytimestampSeconds, xpos, 'r' );
    ylabel('xpos_{after}');
    axis tight;
end
print( gcf(2), [metadata.outputDir metadata.rat '_' metadata.day '_bucketCorrection'],'-dpng','-r200');


disp('IDENTIFY BRICK PASSAGE TIMES')
%  ====================================
%% ==  IDENTIFY BRICK PASSAGE TIMES  ==
%  ====================================
%
% CALCULATE PERIODS WHEN THE RAT IS AT THE START
%
inputElements = length(proxToStart);
halfWindowSize = round(9*sampleRate.telemetry); % elements
overlapSize = round(.99*2*halfWindowSize); % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
%
outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) ;
mvgMedian = zeros( 1, outputPoints );
mvgMedianTimes = zeros( 1, outputPoints );
mvgMedianSampleRate = sampleRate.telemetry/jumpSize;
outputIdx = 1;
%
for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mvgMedian(outputIdx)=median(proxToStart(ii));
    mvgMedianTimes(outputIdx) = xytimestampSeconds(idx);
    outputIdx = outputIdx + 1;
end
outputIdx = outputIdx - 1;
%
% sometimes the rounding leaves a zero at the end and findpeaks can't
% handle that.
mvgMedian = mvgMedian( 1:outputIdx );
mvgMedianTimes = mvgMedianTimes( 1:outputIdx );

startEpisodes = detectPeaksEdges( mvgMedian, mvgMedianTimes, mvgMedianSampleRate, mvgMedianSampleRate, .75, 10, .85 );

% find peaks in the moving median
elecBaseline=diff(mvgMedian);
maxPeak = max(  elecBaseline );
peakThreshold = (0.2 * maxPeak );
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
output.ontoMazeTimes = zeros(size(output.intoBucketTimes));
if ( median(elecBaseline(1:20)) < (median(elecBaseline)*2) )
    output.ontoMazeTimes(1) = mvgMedianTimes(1); % this is a cheap hack
else
    disp('implement something here!');
end
for idxTrialEnd=1:length(output.intoBucketTimes)-1
        relativeTimes = elecBaselineJumpTimes - output.intoBucketTimes(idxTrialEnd);
        [ ~, jj ] = min( abs( relativeTimes ));
        offset = 0;
        while ( (jj+offset < length(relativeTimes) ) && (relativeTimes(jj+offset) < 40 )   ) 
            offset = offset + 1;
        end
        output.ontoMazeTimes(idxTrialEnd)=elecBaselineJumpTimes(jj+offset);
        
end
%scatter(output.ontoMazeTimes, ones(1,length(output.rewardTimes)).*-0.001, 'o', 'filled');
%
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
output.ontoMazeTimes = mvgMedianTimes( startEpisodes.EpisodeStartIdxs);
output.runStartTimes = mvgMedianTimes( startEpisodes.EpisodeEndIdxs);


%% GRAPHICALLY SUMARIZE TIMEPOINTS DETECTED
%
gcf(3)=figure(3); 
subplot(3,1,1); 
hold on;
plot( timestampSeconds, electricEnv );       % 'k'
%disp([ 'elecEnvSize fig 3, circa line 464 ' num2str(size(electricEnv)) ]);
axis tight;  
ylabel('Avg; 60 Hz');
scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
subplot(3,1,2); 
hold on;
plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .1 .8 .1 ] ); 
axis tight;  
ylabel('reward/chew');
subplot(3,1,3); 
hold off; 
plot( mvgMedianTimes, mvgMedian ); 
hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
print( gcf(3), [metadata.outputDir metadata.rat '_' metadata.day '_prelimAutoTrialMarking'],'-dpng','-r200');


%
%% ; make a list of times for trial events
%
if metadata.autobins
    swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes xytimestampSeconds(end) ]);
else
    swrAnalysisBins = sort([ 0 metadata.touchdownTimes metadata.brickTimes metadata.sugarTimes metadata.liftoffTimes xytimestampSeconds(end) ]);
end

%histogram( swrAnalysisBins );
%
%
disp('DETECT BRUXING')
%  ====================
%% == DETECT BRUXING ==
%  ====================
bruxEpisodeLFP=filtfilt( filters.ao.brux, chewCrunchEnv );
bruxEpisodeEnv=abs(hilbert(bruxEpisodeLFP));
bruxDetectorOutput = detectPeaksEdges( bruxEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );
%% this will plot outputs from peakEdges  %%%%%%%%
% detect peaks on the Max Enveloped signal
% figure(4);
% subplot(7,1,2);
% hold on; 
% plot( chewCrunchEnvTimes, bruxEpisodeEnv );
% scatter( bruxDetectorOutput.EpisodePeakTimes, bruxDetectorOutput.EpisodePeakValues, 'v', 'filled');
% load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
% for jj=1:length(bruxDetectorOutput.EpisodeEndIdxs);
%    if  bruxDetectorOutput.EpisodeStartIdxs(jj) > 0
%        scatter( chewCrunchEnvTimes( bruxDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%    else
%        scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%    end
%    if  bruxDetectorOutput.EpisodeEndIdxs(jj) < length(chewCrunchEnvTimes)
%        scatter( chewCrunchEnvTimes(  bruxDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%    else
%        scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%    end
% end
% ylabel('chew/brx'); 
% xlim([0 timestampSeconds(end)]); 
%ylim([-0.001 max(bruxDetectorOutput.EpisodePeakValues)]);
%
%
disp('PROCESS SWR FILE')
% =====================
% ==  SWR -- LFP 88  ==
% =====================
swrLfp88 = filtfilt( filters.so.swr, lfp88 );
swrLfp88Env = abs( hilbert(swrLfp88) );
[ swrPeakValues,      ...
  swrPeakTimes,       ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks( swrLfp88Env,                        ... % data
                             timestampSeconds,                     ... % sampling frequency
                             'MinPeakHeight',  std(swrLfp88Env)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% ** DISPLAY SWR **
% figure(4);
% subplot(7,1,3); 
% hold on;                 
% plot( timestampSeconds, swrLfp88 ); 
% %scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
% ylabel('SWR_{88}'); xlim([0 timestampSeconds(end)]); ylim([-0.001 max(swrPeakValues)]);


% =====================
% == DETECT LIA      ==
% % =====================
% liaLFP=filtfilt( filters.so.lia, lfp88 );
% liaEnv=abs(hilbert(liaLFP));
% %liaDetectorOutput = detectPeaksEdges( liaEnv, timestampSeconds, sampleRate );
% %% this will plot outputs from peakEdges  %%%%%%%%
% [ liaPeakValues,      ...
%   liaPeakTimes,       ...
%   liaPeakProminances, ...
%   liaPeakWidths       ] = findpeaks( liaEnv,                             ... % data
%                                      timestampSeconds ,                  ... % sampling frequency
%                                      'MinPeakHeight'  ,   std(liaEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                      'MinPeakDistance', 0.5  );              % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% %scatter( liaPeakTimes, liaPeakValues, 'v', 'filled');

% % ** DISPLAY LIA  **
% figure(4);
% subplot(7,1,4);
% hold on; 
% plot( timestampSeconds, liaEnv );
% ylabel('LIA_{88}'); 
% xlim([0 timestampSeconds(end)]); 
% ylim([-0.001 max(liaPeakValues)]);


% % ** DISPLAY AVGLFP  **
% swrAvgLfp = filtfilt( filters.so.swr, avgLfp );
% figure(4);
% subplot(7,1,5); 
% hold off;
% plot( timestampSeconds, swrAvgLfp ); % or avgChew; not sure which yet
% ylabel('avgLfp_{SWR}'); 
% xlim([0 timestampSeconds(end)]); 
%this next line always fails during a scripted run, but succeeds
%immediately after when manually executed. weird.
%ylim([ min(swrAvgLfp(round(sampleRate.lfp*5):round(end-sampleRate.lfp*5))) max(swrAvgLfp(round(sampleRate.lfp*5):round(end-sampleRate.lfp*5))) ]);


%  =====================
%% ==   DETECT SWS    ==
%  =====================
% swsLFP=filtfilt( filters.so.nrem, avgLfp );
% swsEnv=abs(hilbert(swsLFP));
% [ swsPeakValues,      ...
%   swsPeakTimes,       ...
%   swsPeakProminances, ...
%   swsPeakWidths       ] = findpeaks(  swsEnv,                           ... % data
%                                       timestampSeconds,                 ... % sampling frequency
%                                       'MinPeakHeight',   std(swsEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                       'MinPeakDistance', 0.5  );            % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% ** DISPLAY SWS  **
% figure(2);
% subplot(7,1,5); 
% hold on; 
% plot( timestampSeconds, swsLFP ); plot( timestampSeconds, swsEnv );
% scatter( swsPeakTimes, swsPeakValues, 'v', 'filled');
% ylabel('SWS'); xlim([0 timestampSeconds(end)]); ylim([-0.001 max(swsPeakValues)]);


%  =====================
%% ==     THETA       ==
%  =====================
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



%  ===============================
%% ==   RE-CALCULATE VELOCITY   ==
%  ===============================
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);


disp('EXCLUDE CHEW/BRUX CONFOUNDS')
%  ==========================================
%% ==    EXCLUDE CHEW/BRUX CONFOUNDS       ==
%  ==========================================
%
% subtract each peak time and eliminate those within 1 s of the peak on
% either side
%
output.swrPeakTimesDenoise=swrPeakTimes;
output.swrPeakValuesDenoise=swrPeakValues;
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
for ii=1:length(electricSignal.PeakTimes)
    idx = find(abs(output.swrPeakTimesDenoise-electricSignal.PeakTimes(ii))<1);
    output.swrPeakTimesDenoise(idx)=NaN;
    output.swrPeakValuesDenoise(idx)=NaN;
end
output.swrPeakTimesDenoise(isnan(output.swrPeakTimesDenoise))=[];
output.swrPeakValuesDenoise(isnan(output.swrPeakValuesDenoise))=[];





%% old code for partitioning

% roughEdges = sort([ electricSignal.PeakTimes' 2318 2616 2781 3000]);
% counts = histcounts( output.swrPeakTimesDenoise, roughEdges);
% xx=roughEdges(1:end-1)+diff(roughEdges)/2;
% yy=counts./diff(roughEdges); % over time
% 
% figure(4);
% subplot(7,1,3); hold on;
% scatter( output.swrPeakTimesDenoise, output.swrPeakValuesDenoise, 'v', 'filled');

%xlimits=[ 450 500 ]; subplot(7,1,1); xlim(xlimits); subplot(7,1,2); xlim(xlimits); subplot(7,1,3); xlim(xlimits); subplot(7,1,4); xlim(xlimits);



% ========================
% ==  SWR Instant Rate  ==
% ========================
% figure(4);
% subplot(7,1,6);
% swrRate = 1./diff(output.swrPeakTimesDenoise);
% plot( output.swrPeakTimesDenoise(1:end-1)+(diff(output.swrPeakTimesDenoise)/2), swrRate )
% ylabel('SWR_{rate}'); 
% xlim([0 timestampSeconds(end)]); 
% ylim([-0.001 max(swrRate)]);



%% display trial auto-partitioning summary data
gcf(4)=figure(4); 
subplot(3,1,1); 
plot( timestampSeconds, electricEnv, 'k' );      
axis tight;  
ylabel('Avg; 60 Hz');
subplot(3,1,2); 
plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .1 .8 .1 ] ); 
axis tight;  
ylabel('reward/chew');
subplot(3,1,3); 
hold off; 
plot( mvgMedianTimes, mvgMedian ); 
hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
print( gcf(4), [metadata.outputDir metadata.rat '_' metadata.day '_finalAutoTrialMarking'],'-dpng','-r200');



% for manual intervention, use the provided markers for the subsequent
% analysis
if ~metadata.autobins

    swrAnalysisBins = sort([ 0 metadata.touchdownTimes metadata.brickTimes metadata.sugarTimes metadata.liftoffTimes xytimestampSeconds(end) ]);

    output.autopartition.ontoMazeTimes = output.ontoMazeTimes;
    output.autopartition.runStartTimes = output.runStartTimes;
    output.autopartition.rewardTimes = output.rewardTimes;
    output.autopartition.intoBucketTimes = output.intoBucketTimes;
    
    output.ontoMazeTimes = metadata.touchdownTimes; 
    output.runStartTimes = metadata.brickTimes; 
    output.rewardTimes = metadata.sugarTimes;
    output.intoBucketTimes = metadata.liftoffTimes;
    
end


%% display SWR rate summary data 
gcf(5)=figure(5); 
subplot(3,1,1); 
plot( mvgMedianTimes, mvgMedian ); 
hold on;
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trial ev.' ); 
axis tight; 
ylim([ 0 1 ]);
subplot(3,1,2); 
histogram( output.swrPeakTimesDenoise, swrAnalysisBins ); 
title('SWR Frequency'); 
xlabel('time (s)'); ylabel('counts'); axis tight;
subplot(3,1,3); hold off;
xx=swrAnalysisBins(1:end-1)+diff(swrAnalysisBins)/2;
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
plot( xx, yy ); 
hold on;
title('SWR rate'); xlabel('time (s)'); ylabel('Hz'); axis tight;
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
scatter( xx(idxs), yy(idxs), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );;
output.swrAnalysisBinLabels(idxs) = 1;
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
scatter( xx(idxs), yy(idxs), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
output.swrAnalysisBinLabels(idxs) = 2;
[vals,idxs]=intersect(swrAnalysisBins,output.rewardTimes);
scatter( xx(idxs), yy(idxs), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
output.swrAnalysisBinLabels(idxs) = 3;
[vals,idxs]=intersect(swrAnalysisBins,output.intoBucketTimes);
scatter( xx(idxs), yy(idxs), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
output.swrAnalysisBinLabels(idxs) = 4;
xlim([0 timestampSeconds(end)]);
print( gcf(5), [metadata.outputDir metadata.rat '_' metadata.day '_SWRrateSummary'],'-dpng','-r200');

save([metadata.outputDir metadata.rat '_' metadata.day '_output'], 'output' );


%%
output.electricEnv = electricEnv;
output.timestampSeconds = timestampSeconds;
output.xpos = old.xpos;
output.ypos = old.ypos;
output.proxToStart = proxToStart;
ouput.chewCrunchEnv = chewCrunchEnv;
ouput.chewCrunchEnvTimes = chewCrunchEnvTimes;
ouput.chewCrunchEnvSampleRate = chewCrunchEnvSampleRate;
output.elecBaselineJumpValues = elecBaselineJumpValues;
output.elecBaselineJumpTimes = elecBaselineJumpTimes;
output.elecBaselineDropValues = elecBaselineDropValues;
output.elecBaselineDropTimes = elecBaselineDropTimes;

disp('COMPLETE')

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
