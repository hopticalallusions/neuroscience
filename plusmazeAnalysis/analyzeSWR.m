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

if ~exist( [ metadata.outputDir 'filters.mat' ], 'file' )
    disp('building filters');
    makeFilters;
    save( [ metadata.outputDir 'filters.mat' ], 'filters');
else
    disp('loading filters');
    load([metadata.outputDir 'filters.mat'], 'filters');
end


% LOAD AVERAGE LFPs

if ~exist( [ metadata.outputDir metadata.rat '_' metadata.day '_avgLfp.mat' ], 'file' )
    disp('building avg signal LFP');
    avgLfp=avgLfpFromList( metadata.dir, metadata.fileListGoodLfp, metadata.lfpStartIdx );  % build average LFP
    save( [ metadata.outputDir metadata.rat '_' metadata.day '_avgLfp.mat' ], 'avgLfp');
else
    disp('loading avg signal LFP');
    load( [ metadata.outputDir metadata.rat '_' metadata.day '_avgLfp.mat' ], 'avgLfp' );
end

if ~exist( [ metadata.outputDir metadata.rat '_' metadata.day '_avgDisconnectedLfp.mat' ], 'file' )
    disp('building avg electrical LFP');
    avgDisconnectedLfp=avgLfpFromList( metadata.dir, metadata.fileListDisconnectedLfp, metadata.lfpStartIdx );  % build average LFP
    save( [ metadata.outputDir metadata.rat '_' metadata.day '_avgDisconnectedLfp.mat' ], 'avgDisconnectedLfp');
else
    disp('loading avg electrical LFP');
    load( [ metadata.outputDir metadata.rat '_' metadata.day '_avgDisconnectedLfp.mat' ], 'avgDisconnectedLfp' );
end


% LOAD SWR CANDIDATE
% 
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
xyblob.lfpTimestampSeconds = ( blob.xytimestamps - blob.xytimestamps(1) )/1e6;

toc
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
blob.electricEnv=abs(hilbert(electricLFP));                  % Env -- envelope
%
% ** call this to try to detect just the sharp, tall peaks

electricSignal.EpisodeIdxs = round( metadata.sampleRate.lfp*2):round(length(blob.electricEnv) - metadata.sampleRate.lfp*2 );
electricSignal.maxPeak = max( blob.electricEnv(electricSignal.EpisodeIdxs) );
electricSignal.peakThreshold = (0.2 * electricSignal.maxPeak );
electricSignal.minPeakDistance = 20; % seconds
[ electricSignal.PeakValues,  ...
  electricSignal.PeakTimes,   ...
  electricSignal.PeakProminances, ...
  electricSignal.PeakWidths ] = findpeaks( blob.electricEnv,                    ... % data
                                           blob.lfpTimestampSeconds,             ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                          'MinPeakHeight',   electricSignal.peakThreshold,  ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                          'MinPeakDistance', electricSignal.minPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
%electricDetectorOutput = detectPeaksEdges( blob.electricEnv, blob.lfpTimestampSeconds, metadata.sampleRate.lfp, round(metadata.sampleRate.lfp/10) );

% gcf=[];
% 
% if metadata.visualizeAll
%    gcf(1)=figure(1);
%    subplot(4,1,1);
%    hold off;
%    plot( blob.lfpTimestampSeconds, blob.electricEnv ); hold on;
%    scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
%    load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%    ylabel('elec.');
%    xlim([0 blob.lfpTimestampSeconds(end)]);
%    ylim([-0.001 max(electricSignal.PeakValues)]);
% end


toc
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
[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, blob.lfpTimestampSeconds );
% these filters depend on the ouput above.
filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%
% Next, find groups of crunches, refered to as "chewing episodes"/"reward"
%
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));
chewDetectorOutput = detectPeaksEdges( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );

% if metadata.visualizeAll
%    figure(1);
%    subplot(4,1,2);
%    hold off;
%    plot( chewCrunchEnvTimes, chewEpisodeEnv ); hold on;
%    scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
%    load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%    for jj=1:length(chewDetectorOutput.EpisodeEndIdxs);
%        if  chewDetectorOutput.EpisodeStartIdxs(jj) > 0
%            scatter( chewCrunchEnvTimes( chewDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%        else
%            scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%        end
%        if  chewDetectorOutput.EpisodeEndIdxs(jj) < length(chewCrunchEnvTimes)
%            scatter( chewCrunchEnvTimes(  chewDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%        else
%            scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%        end
%    end
%    ylabel('reward');
%    xlim([0 blob.lfpTimestampSeconds(end)]);
%    ylim([-0.001 max([ chewDetectorOutput.EpisodePeakValues electricSignal.PeakValues' ])]);
% end


toc
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

% 
% if metadata.visualizeAll
%     gcf(1)=figure(1);
%     subplot(4,1,4);
%     hold off;
%     plot( chewCrunchEnvTimes, chewEpisodeEnv );
%     hold on;
%     plot( blob.lfpTimestampSeconds, blob.electricEnv ); 
%     scatter( output.rewardTimes, zeros(size(output.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
%     scatter( output.intoBucketTimes, zeros(size(output.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
%     ylabel('trial interp');
%     xlim([0 blob.lfpTimestampSeconds(end)]);
%     ylim([-0.001 max( [ max(electricSignal.PeakValues) max(chewDetectorOutput.EpisodePeakValues) ] ) ]);
% end


if abs( length(find(output.rewardTimes)) - length(find(output.intoBucketTimes)) ) > 2
    error('reward and bucket entrance detection failed; unequal number of events');
elseif length(find(output.rewardTimes)) ~= length(find(output.intoBucketTimes))
    warning('reward and bucket entrance detection; unequal number of events detected');
end


toc
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

                                   
                                   
                                   
                                   
% figure;
% plot(blob.lfpTimestampSeconds,blob.electricEnv);
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
% if metadata.visualizeAll
%     figure(1);
%     subplot(4,1,3);
%     hold off;
%     plot( mazeEntries.mvgMedianTimes(2:end), mazeEntries.elecBaseline ); hold on;
%     scatter( elecBaselineJumpTimes, elecBaselineJumpValues, 'v', 'filled');
%     load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%     ylabel('\Delta start.prox.');
%     xlim([0 blob.lfpTimestampSeconds(end)]);
%     ylim([-0.001 max(elecBaselineJumpValues)]);
%    %
%     subplot(4,1,4);
%     hold off;
%     plot( chewCrunchEnvTimes, chewEpisodeEnv );
%     hold on;
%     plot( blob.lfpTimestampSeconds, blob.electricEnv ); 
%     scatter( output.rewardTimes, zeros(size(output.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
%     scatter( output.intoBucketTimes, zeros(size(output.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
%     scatter( output.ontoMazeTimes, zeros(size(output.ontoMazeTimes)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
%     ylabel('events');
%     xlim([0 blob.lfpTimestampSeconds(end)]);
%     ylim([-0.001 max( [ max(electricSignal.PeakValues) max(chewDetectorOutput.EpisodePeakValues) ] ) ]);
% end
% print( gcf(1), [metadata.outputDir metadata.rat '_' metadata.day '_autotrial1'],'-dpng','-r200');
% 
% if abs ( length(find(output.rewardTimes)) - length(find(output.ontoMazeTimes)) ) > 2
%     if metadata.autobins
%         error('reward and trial start detection failed; unequal number of events');
%     else
%         warning('reward and trial start detection failed; unequal number of events');
%     end
% end


toc
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
old.blob.xpos = blob.xpos; old.blob.ypos = blob.ypos;
%blob.xpos = old.blob.xpos; blob.ypos = old.blob.ypos;
%
% * there should be trials-1 'intermissions'
% * output.ontoMazeTimes need to be offset from intoBucket because one mounts
% maze, then enters bucket, onto maze, enter bucket...
disp('telemetry correction disabled.')
% for ii = 1:length(output.intoBucketTimes)-1
%     % find start and end indices of the bucket episode
%     % try to offset the time by a few seconds to account for time to put
%     % him down or pick him up (high accel/vel makes sense during these
%     % brief episodes of teleportation)
%     startIdx = round((output.intoBucketTimes(ii)+1) * metadata.sampleRate.telemetry);
%     endIdx   = round((output.ontoMazeTimes(ii+1)-3) * metadata.sampleRate.telemetry);
%     if endIdx < startIdx
%         startIdx = round((output.intoBucketTimes(ii)) * metadata.sampleRate.telemetry);
%         endIdx   = round((output.ontoMazeTimes(ii+1)) * metadata.sampleRate.telemetry);
%     end
%     if ( endIdx < startIdx ) && ( ii == length(output.intoBucketTimes) ) % TODO it doesn't find an end for out bucket time, because trials end
%         endIdx = length(blob.xpos);
%     end
%     if endIdx < startIdx; error('endIdx > startIdx in bucket position correction routine.'); end
%     blob.xpos(startIdx:endIdx) = median(blob.xpos(startIdx:endIdx))+5*rand(size(blob.xpos(startIdx:endIdx)));
%     blob.ypos(startIdx:endIdx) = median(blob.ypos(startIdx:endIdx))+5*rand(size(blob.xpos(startIdx:endIdx)));
% end
% ==================================================
% ==  RECALCULATE TELEMETRY BASED ON CORRECTIONS  ==
% ==================================================
proxToCenter=proxToPoint( blob.xpos, blob.ypos, 317, 229 );
proxToStart=proxToPoint( blob.xpos, blob.ypos, 81, 412 );
proxToRewardSite=proxToPoint( blob.xpos, blob.ypos, 119, 45 );
proxToIncorrectSite=proxToPoint( blob.xpos, blob.ypos, 525, 429 );
%
% if metadata.visualizeAll
%     gcf(2)=figure(2); % demonstrate position correction to check if it was appropriate
%     subplot(3,1,1);
%     title('confirm bucket telemetry corrections');
%     plot( blob.lfpTimestampSeconds, blob.electricEnv );
%     hold on;
%     ylabel('elec.');
%     axis tight;
%     subplot(3,1,2);
%     plot( xyblob.lfpTimestampSeconds, old.blob.xpos, 'k' );
%     ylabel('blob.xpos_{before}');
%     axis tight;
%     subplot(3,1,3);
%     plot( xyblob.lfpTimestampSeconds, blob.xpos, 'r' );
%     ylabel('blob.xpos_{after}');
%     axis tight;
% end
% print( gcf(2), [metadata.outputDir metadata.rat '_' metadata.day '_bucketCorrection'],'-dpng','-r200');


toc
disp('IDENTIFY BRICK PASSAGE TIMES')
%  ====================================
%% ==  IDENTIFY BRICK PASSAGE TIMES  ==
%  ====================================
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
    mvgMedianTimes(outputIdx) = xyblob.lfpTimestampSeconds(idx);
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
% scatter(output.ontoMazeTimes, ones(1,length(output.rewardTimes)).*-0.001, 'o', 'filled');
% %
% for jj=1:length(startEpisodes.EpisodeEndIdxs);
%    if  startEpisodes.EpisodeStartIdxs(jj) > 0
%        scatter( mvgMedianTimes( startEpisodes.EpisodeStartIdxs(jj) ), 0, 'v',  'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
%    else
%        scatter( mvgMedianTimes( 1 ), 0, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
%    end
%    if  startEpisodes.EpisodeEndIdxs(jj) < length(blob.lfpTimestampSeconds)
%        scatter( mvgMedianTimes(  startEpisodes.EpisodeEndIdxs(jj) ), 0, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ] );
%    else
%        scatter( mvgMedianTimes( end ), 0, '>', 'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ] );
%    end
% end
output.ontoMazeTimes = mvgMedianTimes( startEpisodes.EpisodeStartIdxs);
output.runStartTimes = mvgMedianTimes( startEpisodes.EpisodeEndIdxs);


%% GRAPHICALLY SUMARIZE TIMEPOINTS DETECTED
%
% gcf(3)=figure(3); 
% subplot(3,1,1); 
% hold on;
% plot( blob.lfpTimestampSeconds, blob.electricEnv );       % 'k'
% %disp([ 'elecEnvSize fig 3, circa line 464 ' num2str(size(blob.electricEnv)) ]);
% axis tight;  
% ylabel('Avg; 60 Hz');
% scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
% subplot(3,1,2); 
% hold off;
% plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .1 .8 .1 ] ); 
% hold on;
% scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
% axis tight;
% ylim([0 max(chewDetectorOutput.EpisodePeakValues)]);
% ylabel('reward/chew');
% subplot(3,1,3); 
% hold off; 
% plot( mvgMedianTimes, mvgMedian ); 
% hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
% scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
% scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
% scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
% scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
% ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
% print( gcf(3), [metadata.outputDir metadata.rat '_' metadata.day '_prelimAutoTrialMarking'],'-dpng','-r200');


%
%% ; make a list of times for trial events
%
if metadata.autobins
    swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes xyblob.lfpTimestampSeconds(end) ]);
else
    swrAnalysisBins = sort([ 0 metadata.touchdownTimes metadata.brickTimes metadata.sugarTimes metadata.liftoffTimes xyblob.lfpTimestampSeconds(end) ]);
end

%histogram( swrAnalysisBins );
%
%
toc
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
% xlim([0 blob.lfpTimestampSeconds(end)]); 
%ylim([-0.001 max(bruxDetectorOutput.EpisodePeakValues)]);
%
%

toc
disp('PROCESS SWR FILE')
% =====================
% ==  SWR -- LFP 88  ==
% =====================
swrblob.swrLfp = filtfilt( filters.so.swr, blob.swrLfp );
swrblob.swrLfpEnv = abs( hilbert(swrblob.swrLfp) );
[ swrPeakValues,      ...
  swrPeakTimes,       ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks( swrblob.swrLfpEnv,                        ... % data
                             blob.lfpTimestampSeconds,                     ... % sampling frequency
                             'MinPeakHeight',  std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% ** DISPLAY SWR **
% figure(4);
% subplot(7,1,3); 
% hold on;                 
% plot( blob.lfpTimestampSeconds, swrblob.swrLfp ); 
% %scatter( swrPeakTimes, swrPeakValues, 'v', 'filled');
% ylabel('SWR_{88}'); xlim([0 blob.lfpTimestampSeconds(end)]); ylim([-0.001 max(swrPeakValues)]);


% =====================
% == DETECT LIA      ==
% % =====================
% liaLFP=filtfilt( filters.so.lia, blob.swrLfp );
% liaEnv=abs(hilbert(liaLFP));
% %liaDetectorOutput = detectPeaksEdges( liaEnv, blob.lfpTimestampSeconds, sampleRate );
% %% this will plot outputs from peakEdges  %%%%%%%%
% [ liaPeakValues,      ...
%   liaPeakTimes,       ...
%   liaPeakProminances, ...
%   liaPeakWidths       ] = findpeaks( liaEnv,                             ... % data
%                                      blob.lfpTimestampSeconds ,                  ... % sampling frequency
%                                      'MinPeakHeight'  ,   std(liaEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                      'MinPeakDistance', 0.5  );              % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% %scatter( liaPeakTimes, liaPeakValues, 'v', 'filled');

% % ** DISPLAY LIA  **
% figure(4);
% subplot(7,1,4);
% hold on; 
% plot( blob.lfpTimestampSeconds, liaEnv );
% ylabel('LIA_{88}'); 
% xlim([0 blob.lfpTimestampSeconds(end)]); 
% ylim([-0.001 max(liaPeakValues)]);


% % ** DISPLAY AVGLFP  **
% swrAvgLfp = filtfilt( filters.so.swr, avgLfp );
% figure(4);
% subplot(7,1,5); 
% hold off;
% plot( blob.lfpTimestampSeconds, swrAvgLfp ); % or avgChew; not sure which yet
% ylabel('avgLfp_{SWR}'); 
% xlim([0 blob.lfpTimestampSeconds(end)]); 
%this next line always fails during a scripted run, but succeeds
%immediately after when manually executed. weird.
%ylim([ min(swrAvgLfp(round(metadata.sampleRate.lfp*5):round(end-metadata.sampleRate.lfp*5))) max(swrAvgLfp(round(metadata.sampleRate.lfp*5):round(end-metadata.sampleRate.lfp*5))) ]);


%  =====================
%% ==   DETECT SWS    ==
%  =====================
% swsLFP=filtfilt( filters.so.nrem, avgLfp );
% swsEnv=abs(hilbert(swsLFP));
% [ swsPeakValues,      ...
%   swsPeakTimes,       ...
%   swsPeakProminances, ...
%   swsPeakWidths       ] = findpeaks(  swsEnv,                           ... % data
%                                       blob.lfpTimestampSeconds,                 ... % sampling frequency
%                                       'MinPeakHeight',   std(swsEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                       'MinPeakDistance', 0.5  );            % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% ** DISPLAY SWS  **
% figure(2);
% subplot(7,1,5); 
% hold on; 
% plot( blob.lfpTimestampSeconds, swsLFP ); plot( blob.lfpTimestampSeconds, swsEnv );
% scatter( swsPeakTimes, swsPeakValues, 'v', 'filled');
% ylabel('SWS'); xlim([0 blob.lfpTimestampSeconds(end)]); ylim([-0.001 max(swsPeakValues)]);


%  =====================
%% ==     THETA       ==
%  =====================
% Doesn't look very meaningful.
% theta = filtfilt( filters.so.theta, avgLfp );
% thetaEnv=abs(hilbert(theta));
% ** DISPLAY THETA  **
% figure(2);
% subplot(7,1,6); 
% plot( blob.lfpTimestampSeconds, thetaEnv )
% ylabel('\Theta'); 
% xlim([0 blob.lfpTimestampSeconds(end)]); 
% ylim([-0.001 max(thetaEnv(sampleRate:end-sampleRate))]);



%  ===============================
%% ==   RE-CALCULATE VELOCITY   ==
%  ===============================
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(blob.xpos, blob.ypos, lagTime, pxPerCm);


toc
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
% xlim([0 blob.lfpTimestampSeconds(end)]); 
% ylim([-0.001 max(swrRate)]);


% gcf(3)=figure(3); 
% subplot(3,1,1); 
% hold on;
% plot( blob.lfpTimestampSeconds, blob.electricEnv );       % 'k'
% %disp([ 'elecEnvSize fig 3, circa line 464 ' num2str(size(blob.electricEnv)) ]);
% axis tight;  
% ylabel('Avg; 60 Hz');
% scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
% subplot(3,1,2); 
% hold off;
% plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .1 .8 .1 ] ); 
% hold on;
% scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
% axis tight;
% ylim([0 max(chewDetectorOutput.EpisodePeakValues)]);
% ylabel('reward/chew');
% subplot(3,1,3); 
% hold off; 
% plot( mvgMedianTimes, mvgMedian ); 
% hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
% scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
% scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
% scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
% scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
% ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
% print( gcf(3), [metadata.outputDir metadata.rat '_' metadata.day '_prelimAutoTrialMarking'],'-dpng','-r200');





%% display trial auto-partitioning summary data
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
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
print( gcf(4), [metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '')  '_finalAutoTrialMarking.png'],'-dpng','-r200');



output.autopartition.ontoMazeTimes = output.ontoMazeTimes;
output.autopartition.runStartTimes = output.runStartTimes;
output.autopartition.rewardTimes = output.rewardTimes;
output.autopartition.intoBucketTimes = output.intoBucketTimes;


% for manual intervention, use the provided markers for the subsequent
% analysis
if ~metadata.autobins

    swrAnalysisBins = sort([ 0 metadata.touchdownTimes metadata.brickTimes metadata.sugarTimes metadata.liftoffTimes xyblob.lfpTimestampSeconds(end) ]);
    
    output.ontoMazeTimes = metadata.touchdownTimes; 
    output.runStartTimes = metadata.brickTimes; 
    output.rewardTimes = metadata.sugarTimes;
    output.intoBucketTimes = metadata.liftoffTimes;
    
end


%% display SWR rate summary data 
gcf(5)=figure(5); 
subplot(4,1,1); 
output.swrRate = 1./diff(output.swrPeakTimesDenoise);
plot( output.swrPeakTimesDenoise(1:end-1)+(diff(output.swrPeakTimesDenoise)/2), output.swrRate )
hold on;
scatter( output.ontoMazeTimes, zeros(1,length(output.ontoMazeTimes)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, zeros(1,length(output.runStartTimes)), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, zeros(1,length(output.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .7 .95 ]);
scatter( output.intoBucketTimes, zeros(1,length(output.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel('SWR_{rate}'); 
xlim([0 blob.lfpTimestampSeconds(end)]); 
ylim([-0.1 max(output.swrRate)]);
subplot(4,1,2); 
plot( mvgMedianTimes, mvgMedian ); 
hold on;
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
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
xlim([-0.05 blob.lfpTimestampSeconds(end)]);
print( gcf(5), [metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '')  '_SWRrateSummary.png'],'-dpng','-r200');

save([metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '') '_output'], 'output' );


%%
output.blob.electricEnv = blob.electricEnv;
output.blob.lfpTimestampSeconds = blob.lfpTimestampSeconds;
output.blob.xpos = old.blob.xpos;
output.blob.ypos = old.blob.ypos;
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
