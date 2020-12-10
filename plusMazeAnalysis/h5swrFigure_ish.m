dir='~/data/h5_orientation2_rawExtract/';
lfp=loadCExtractedNrdChannelData( [ dir 'rawChannel_87.dat' ] );
lfpTimestamps=loadCExtractedNrdTimestampData([ dir '~/data/timestamps.dat' ]);
lfpTimeSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
lfp=loadCExtractedNrdChannelData( [ dir 'rawChannel_87.dat' ] );
lfpTimestamps=loadCExtractedNrdTimestampData([ dir 'timestamps.dat' ]);
lfpTimeSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
swrLfp = filtfilt( filters.so.swr, swrLfp );
swrLfpEnv = abs( hilbert( swrLfp ) );
swrLfp = filtfilt( filters.so.swr, lfp );
swrLfpEnv = abs( hilbert( swrLfp ) );
swrThreshold = mean(swrLfp) + ( 3  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
lfpTimeSeconds,                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
length(swrPeakValues)/max(lfpTimeSeconds)
figure; plot(lfpTimeSeconds, lfp)
figure;
plot(lfpTimeSeconds, lfp);
hold on;
plot(lfpTimeSeconds, swrLfp);
scatter(swrPeakTimes, swrPeakValues, 'v', 'filled');
liaLfp = filtfilt( filters.so.lia, lfp );
sleepLfp = filtfilt( filters.so.spindle, lfp );
plot(lfpTimeSeconds, liaLfp-0.25);
plot(lfpTimeSeconds, sleepLfp-0.5);
sleepLfp = filtfilt( filters.so.nrem, lfp );
plot(lfpTimeSeconds, sleepLfp-0.5);
swrThreshold = mean(swrLfp) + ( 5  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
lfpTimeSeconds,                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
swrThreshold = mean(swrLfp) + ( 4  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
lfpTimeSeconds,                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
figure;
plot(lfpTimeSeconds, lfp);
hold on;
plot(lfpTimeSeconds, swrLfp);
scatter(swrPeakTimes, swrPeakValues, 'v', 'filled');
%plot(lfpTimeSeconds, liaLfp-0.25);
plot(lfpTimeSeconds, sleepLfp-0.5);
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
speed = calculateSpeed( xpos, ypos, 1, 2.63);
speedNormed = speed/max(speed);
plot(xytimestampSeconds, speedNormed/2-.8);
legend('rawCh87','swrLfp','swrEvents','sleepLfp','norm.speed');
axis tight;
ylabel('millivolts');
xlabel('time (s)');
title( 'h5 demo data ch 87' )

lfpSpikes=loadCExtractedNrdChannelData( [ dir 'rawChannel_39.dat' ] );
spikeLfp = filtfilt( filters.so.spike , lfpSpikes );
plot(lfpTimeSeconds, spikeLfp-0.6);

figure;
plot(lfpTimeSeconds, spikeLfp-0.6);
spikeLfp = filtfilt( filters.ao.spike , lfpSpikes );
hold on;
plot(lfpTimeSeconds, spikeLfp-0.6);
plot(lfpTimeSeconds, lfpSpikes);
%-- 4/27/18, 12:36 AM --%