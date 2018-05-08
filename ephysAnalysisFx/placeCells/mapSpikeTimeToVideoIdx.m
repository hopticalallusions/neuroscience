function xyIdxs = mapSpikeTimeToVideoIdx( spikeTimes, xytimestamps )

    % NOTE
    % the old version of this function is wrong. do not use it.
    %
    % this change will probably break some old script, but that's ok!
    % because it was wrong.

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

    xyIdxs=zeroes(size(spiketimes))

    for whichSpike=1:length(spiketimes)
        xyIdxs(whichSpike) = find( spiketimes(whichSpike) <= xytimestamps, 1 );
    end

end