function detectorOutput = detectPeaksEdgesDa5( signalEnvelope, signalTimes, signalSampleRate, streakThreshold, extentThreshold, MinPeakDistance, peakThreshold )

% CrunchEnv -- envelope to detect over
% filterToApply -- filterToApply -- what it says
%
% TODO this code could be cleaned up and improved, but for now, 
% it works for its intended purpose
%
if nargin < 6
    MinPeakDistance = 1;
end
if nargin < 4
    streakThreshold = round(signalSampleRate);
else
    streakThreshold = round(streakThreshold);
end

% correct for artifacts of filtering by ignoring the first and last 5 sec
EpisodeIdxs=round(signalSampleRate*5):round(length(signalEnvelope) - signalSampleRate*5 );
if nargin < 7
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
    peakThreshold = (0.5 * ( maxPeak ) ); % -->> ????!?!??    - mode(signalEnvelope( EpisodeIdxs ))))+mode(signalEnvelope( EpisodeIdxs ));
    %extentThreshold =  (0.02 * ( maxPeak - mode(signalEnvelope( EpisodeIdxs ))))+mode(signalEnvelope( EpisodeIdxs ));
end
if nargin < 5
    %extentThreshold = mean(signalEnvelope); % mode(signalEnvelope)+std(signalEnvelope);
    extentThreshold = max([ peakThreshold/3  1.1*mean(signalEnvelope) ]);
end
    % find peaks
[ EpisodePeakValues, ...
  EpisodePeakTimes, ...
  EpisodePeakProminances, ...
  EpisodePeakWidths ] = findpeaks(  signalEnvelope( EpisodeIdxs ),                              ... % data
                                        signalTimes( EpisodeIdxs ),                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    peakThreshold, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  MinPeakDistance  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
% 
% Matlab's width method doesn't do what I want.
%
%
% == DETECT START AND END OF AN EPISODE OF CRUNCHING ==
%
% given the locations of the peaks of the Crunch episodes, find the extents
% of the episodes
%
% starting at the peak, ride the signal envelope until it stays below a
% threshold for a while (rather heuristic)
%
%
EpisodeStartIdxs = ones( 1, length( EpisodePeakTimes ) );
EpisodeEndIdxs = ones( 1, length( EpisodePeakTimes ) );% * length(signalEnvelope);
%
% TODO use while instead of some arbitrary cut off
%
for jj=1:length(EpisodePeakTimes)
    % find the nearest index
    [vv envIdx]=min(abs(signalTimes-EpisodePeakTimes(jj)));
    envIdx = envIdx(1); % we only need one. (could cause bugs if repeat values)
    EpisodeStartIdxs(jj) = 0;
    minValStreak = 0;
    %pctThreshold = EpisodePeakValues(jj)*.05;
    for ii=1:length(signalEnvelope)
        if envIdx-ii < 1
            break;
        end
        if signalEnvelope(envIdx-ii) < extentThreshold % pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if EpisodeStartIdxs(jj) == 1
                EpisodeStartIdxs(jj) = envIdx - ii;
            end
        elseif minValStreak > streakThreshold  % TODO should really be a proportion of sample rate
            break;
        elseif EpisodeStartIdxs(jj) ~= 1
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            EpisodeStartIdxs(jj) = 1;
            minValStreak = 0;
        end
    end
    %
    % now go up
    %EpisodeEndIdxs(ii) = 0;
    minValStreak = 0;
    %pctThreshold = EpisodePeakValues(jj)*.05;
    for ii=1:length(signalEnvelope)
        if envIdx+ii > length(signalEnvelope)
            break;
        end
        if signalEnvelope(envIdx+ii) < extentThreshold % pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if  EpisodeEndIdxs(jj) == 1
                 EpisodeEndIdxs(jj) = envIdx + ii;
            end
        elseif minValStreak > streakThreshold  % TODO should really be a proportion of sample rate
            break;
        elseif  EpisodeEndIdxs(jj) ~= 1
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            EpisodeEndIdxs(jj) = 1;
            minValStreak = 0;
        end
    end 
    %
end


EpisodeStartIdxs(EpisodeStartIdxs<1)=1;

%% now remove duplicate peaks that fall inside the extents
% it is possible that this might break some other things that remove SWR
% interference
idxToRemove = [];
if length(EpisodePeakTimes) > 3
    for ii=2:length(EpisodePeakTimes)
        %disp( [ num2str(EpisodeStartIdxs(ii-1))  '  '  num2str(EpisodeEndIdxs(ii-1))])
        if (ii-1 > 0) && ( EpisodePeakTimes(ii) > signalTimes(EpisodeStartIdxs(ii-1)) ) && ( EpisodePeakTimes(ii) < signalTimes(EpisodeEndIdxs(ii-1)) )
            idxToRemove = [ idxToRemove ii ];
        end
    end
end
EpisodePeakValues(idxToRemove)=[];
EpisodePeakTimes(idxToRemove)=[];
EpisodeStartIdxs(idxToRemove)=[];
EpisodeEndIdxs(idxToRemove)=[];


detectorOutput.EpisodeStartIdxs  = EpisodeStartIdxs;
detectorOutput.EpisodeEndIdxs    = EpisodeEndIdxs;
detectorOutput.EpisodePeakValues = EpisodePeakValues;
detectorOutput.EpisodePeakTimes  = EpisodePeakTimes;

return;


% 
% 
% 
% so, separate the visualization out
% 
% % plotMarkers = {'+','o','*','.','x','s','d','^','>','<','p','h'};
% % fixed location; might break things later
% load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%     %
%     if visualizeAll
%        % figure; plot( EnvTimes(envIdx-2000:envIdx+2000), temp(envIdx-2000:envIdx+2000) ); hold on; plot( EnvTimes(envIdx-2000:envIdx+2000), tempEnv(envIdx-2000:envIdx+2000) ); hold on; plot( EnvTimes(episodeStartIdx), tempEnv(episodeStartIdx), '*')
%        if EpisodeStartIdxs(jj) > 0
%            scatter( signalTimes( EpisodeStartIdxs(jj) ), -0.01, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%        else
%            scatter( signalTimes( 1 ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%        end
%     end
% 
%     %
%     if visualizeAll
%        scatter( signalTimes( EpisodeEndIdxs(jj) ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%     end