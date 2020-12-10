rawChannel_36.dat
rawChannel_37.dat
rawChannel_38.dat
rawChannel_39.dat
timestamps.dat


makeFilters;

dir='~/data/h5/2018-04-09/';

lfp=loadCExtractedNrdChannelData( [ dir 'rawChannel_36.dat' ] );

lfpTimestamps=loadCExtractedNrdTimestampData([ dir 'timestamps.dat' ]);
lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;

spikeLfp = filtfilt( filters.so.spike, lfp );




spikeThreshold = median(abs(spikeLfp))/0.6745; % H.G. Rey et al. / Brain Research Bulletin 119 (2015) 106?117


[spikePeakValues,      ...
 spikePeakTimes,       ... 
 spikePeakProminances, ...
 spikePeakWidths ] = findpeaks( spikeLfp,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  spikeThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.001  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

