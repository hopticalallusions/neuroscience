function detectorOutput = detectPeaksEdges( chewCrunchEnv, chewCrunchEnvTimes, filters.ao.nomnom, chewCrunchEnvSampleRate )

% chewCrunchEnv -- envelope to detect over
% filters.ao.nomnom -- filterToApply -- what it says
%
% TODO this code could be cleaned up and improved, but for now, 
% it works for its intended purpose
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
chewEpisodeStartIdxs = zeros( 1, length( chewEpisodePeakTimes ) );
chewEpisodeEndIdxs = zeros( 1, length( chewEpisodePeakTimes ) );
%
% TODO use while instead of some arbitrary cut off
%
for jj=1:length(chewEpisodePeakTimes)
    % find the nearest index
    [vv envIdx]=min(abs(chewCrunchEnvTimes-chewEpisodePeakTimes(jj)));
    envIdx = envIdx(1); % we only need one. (could cause bugs if repeat values)
    chewEpisodeStartIdxs(jj) = 0;
    minValStreak = 0;
    pctThreshold = chewEpisodePeakValues(jj)*.05;
    for ii=1:10000
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
    % now go up
    %chewEpisodeEndIdxs(ii) = 0;
    minValStreak = 0;
    pctThreshold = chewEpisodePeakValues(jj)*.05;
    for ii=1:10000
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
end

detectorOutput.chewEpisodeStartIdxs  = chewEpisodeStartIdxs;
detectorOutput.chewEpisodeEndIdxs    = chewEpisodeEndIdxs;
detectorOutput.chewEpisodePeakValues = chewEpisodePeakValues;
detectorOutput.chewEpisodePeakTimes  = chewEpisodePeakTimes;

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
%        % figure; plot( chewEnvTimes(envIdx-2000:envIdx+2000), temp(envIdx-2000:envIdx+2000) ); hold on; plot( chewEnvTimes(envIdx-2000:envIdx+2000), tempEnv(envIdx-2000:envIdx+2000) ); hold on; plot( chewEnvTimes(episodeStartIdx), tempEnv(episodeStartIdx), '*')
%        if chewEpisodeStartIdxs(jj) > 0
%            scatter( chewCrunchEnvTimes( chewEpisodeStartIdxs(jj) ), -0.01, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%        else
%            scatter( chewCrunchEnvTimes( 1 ), -0.01, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%        end
%     end
% 
%     %
%     if visualizeAll
%        scatter( chewCrunchEnvTimes( chewEpisodeEndIdxs(jj) ), -0.01, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%     end