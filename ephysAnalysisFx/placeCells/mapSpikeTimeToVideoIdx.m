function idxs = mapSpikeTimeToVideoIdx( spikeTimes, cellNumber, cellToMap, xyFramesPerSecond )

if nargin < 4
    xyFramesPerSecond = 29.97;
end

% video frames have a temporal resolution of ~33      ms
% spike events have a temporal resolution of   0.0312 ms
%
% roughly, 1000x finer than the video data.
%
% so, imagine the microsecond timestamps of each arranged in time; most
% spike events will fall between places. By rescaling the spike event times
% and rounding them to the same resolution as the video frames, we can
% obtain an index vector mapping spike events to video times.
%
idxs=round(((spikeTimes(cellNumber==cellToMap)-spikeTimes(1))/1e6)*xyFramesPerSecond); % remap spiketime to video indexes/times

end