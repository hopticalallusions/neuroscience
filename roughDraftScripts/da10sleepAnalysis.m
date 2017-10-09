% particularly good day
%
% CSC available to look at :
% 3, 4, 8, 12, 16, 20, 36, 44, 50, 54, 58, 61, 64, 72, 76, 84, 88
%
% TT Available to look at :
% 12, 14

dir='/Users/andrewhowe/data/ratData/ephysAndTelemetry/da10/da10_2017-09-22_11-57-33/';

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
pxPerCm = 2.706;   % sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;

% tested : all the LFP timestamps are the same
[ lfp88, lfpTimestamps ] = csc2mat([ dir 'CSC88.ncs']); % inverted SWR; below layer
[ lfp61 ] = csc2mat([ dir 'CSC61.ncs']); % above layer (non inverted SWR)
[ lfp4 ] = csc2mat([ dir 'CSC4.ncs']); % NAc, to eliminate noise from bucket slam vs SWR
[ lfp76 ] = csc2mat([ dir 'CSC76.ncs']); % 
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

figure;
subplot(4,1,1); plot(timestampSeconds/60, lfp88); axis tight;
subplot(4,1,2); plot(timestampSeconds/60, lfp61); axis tight;
subplot(4,1,3); plot(timestampSeconds/60, lfp76); axis tight;
subplot(4,1,4); plot(timestampSeconds/60, lfp4); axis tight;

%120 ms per cycle
startIdx = round( 43.23 * 60 * 32000);
endIdx = round( 43.42 * 60 * 32000);
ii=(startIdx:endIdx);
figure; plot( timestampSeconds(ii), lfp76(ii)); axis tight;
figure; hist(1/lfp76(ii),100);


figure; plot(lfp76(ii-2000), lfp76(ii), 'color', [0 0 0 .05])
figure; plot(lfp76(ii))

7.558e4  - 7.341e4

lfpHilbert = hilbert( lfp76(ii) );
lfpEnvelope = abs( lfpHilbert );


figure;
subplot(3,1,1); plot( timestampSeconds(ii), real(lfpHilbert) ); hold on; plot( peakTimes+timestampSeconds(ii(1)), lfp76(round( 32000* (peakTimes+timestampSeconds(ii(1))) )), 'o'); % hold on; plot( imag(lfpHilbert) );
subplot(3,1,2); plot( timestampSeconds(ii), lfpEnvelope ); hold on; plot( peakTimes+timestampSeconds(ii(1)), lfpEnvelope(round( 32000*peakTimes )), 'o'); 

[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  ...
                          lfpEnvelope,    ... % data
                          32000,                 ... % sampling frequency
                          'MinPeakHeight',   prctile( lfpEnvelope, 90 ), ... % default 95th percentile peak height
                          'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

% peak finding on the inverted lfp
                      
[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  ...
                          -lfp76(ii),    ... % data
                          32000,                 ... % sampling frequency
                          'MinPeakHeight',   prctile( -lfp76(ii), 95 ), ... % default 95th percentile peak height
                          'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

figure; plot( timestampSeconds(ii), lfp76(ii) ); hold on; plot( peakTimes+timestampSeconds(ii(1)), lfp76(round( 32000* (peakTimes+timestampSeconds(ii(1))) )), 'o'); 

                      
skw=zeros(size(lfp76));
windowSize=32000;
for idx=1:round(windowSize/4):length(lfp76)-windowSize
    skw(idx)=skewness(lfp76(idx:idx+windowSize));
end
%tmpIdx = find(skw); figure; subplot(2,1,1); plot( timestampSeconds(tmpIdx), skw(tmpIdx) ); subplot(2,1,2); plot( downsample(timestampSeconds,16),  downsample(lfp76,16) );
tmpIdx = find(skw); figure; plot( timestampSeconds(tmpIdx), skw(tmpIdx) ); hold on; plot( downsample(timestampSeconds,16),  downsample(lfp76,16) );




plotFft( lfp76(2956 * 32000 : 2964 * 32000), 32000, 1);
plotFft( lfp76(3040 * 32000 : 3054 * 32000), 32000, 1);


disp([ num2str( (lfpTimestamps(end)-lfpTimestamps(1))/(60e6) ) ' minutes' ])
figure; plot(timestampSeconds/60, lfp);




6 to 12 

startIdx = round( 43.23 * 60 * 32000);


%% filter high ranges to obtain low freq. signal (seems to work better than bandpass?)
startIdx = round( 39 * 60 * 32000);
endIdx = round( 43.42 * 60 * 32000);
ii=(startIdx:endIdx);
figure; plot(lfp76);
deltaFilter = designfilt( 'bandpassiir',                 ...
                        'FilterOrder',              12, ...
                        'HalfPowerFrequency1',    50, ...
                        'HalfPowerFrequency2',    8000, ...
                        'SampleRate',           32000);
deltaBandLfp = filtfilt( deltaFilter, lfp76(ii));
figure; subplot(3,1,1); plot(timestampSeconds(ii),  lfp76(ii)); ylim([ -0.25 0.1  ]);; subplot(3,1,2); plot(timestampSeconds(ii),deltaBandLfp); ylim([ -0.25 0.1  ]); subplot(3,1,3); plot(timestampSeconds(ii),lfp76(ii)-deltaBandLfp); ylim([ -0.25 0.1  ]);


deltaBandHilbert = hilbert(deltaBandLfp); subplot(3,1,2); hold on; plot(imag(deltaBandHilbert)); plot(abs(deltaBandHilbert)); ylim([ -0.25  0.1 ]);


plot(abs(hilbert(abs(deltaBandHilbert))));


%% energy
% metrics.sqrtEnergy=sqrt(sum(spikes.^2)); % this is 

energy=zeros(size(lfp76(ii)));
windowSize=32000/4;
for idx=1:round(windowSize/16):length(energy)-windowSize
    energy(idx)=sqrt(sum(lfp76(ii(idx:idx+windowSize)).^2));
end
tmpIdx = find(energy); figure;  hold on; plot( timestampSeconds(ii), lfp76(ii) ); plot( timestampSeconds(ii(tmpIdx)),    energy(tmpIdx)/50 );
%tmpIdx = find(skw); figure; subplot(2,1,1); plot( timestampSeconds(tmpIdx), skw(tmpIdx) ); subplot(2,1,2); plot( downsample(timestampSeconds,16),  downsample(lfp76,16) );



%% filter low ranges to obtain sleep signal signature
startIdx = round( 39 * 60 * 32000);
endIdx = round( 43.42 * 60 * 32000);
ii=(startIdx:endIdx);
figure; plot(lfp76);
deltaFilter = designfilt( 'bandpassiir',             ...
                        'FilterOrder',           4, ...  % too high a filter order screws things up!
                        'HalfPowerFrequency1',    6, ...
                        'HalfPowerFrequency2',   40, ...
                        'SampleRate',         32000  );
fvtool(deltaFilter);
deltaBandLfp = filtfilt( deltaFilter, lfp76(ii));
figure; subplot(3,1,1); plot(timestampSeconds(ii),  lfp76(ii)); ylim([ -0.25 0.1  ]);; subplot(3,1,2); plot(timestampSeconds(ii),deltaBandLfp); ylim([ -0.25 0.1  ]); subplot(3,1,3); plot(timestampSeconds(ii),lfp76(ii)-deltaBandLfp); ylim([ -0.25 0.1  ]);
% 6-40 Hz this leaves a ~4.5 hz carrier out of the signal, and makes it
% much more negative-going; might be helpful.

deltaBandLfp

temp=downsample(deltaBandLfp(round( 39 * 60 * 32e3):round( 44 * 60 * 32e3)),32);
figure; plot(temp)
    x = flipud(temp(1:end-100));
    y = flipud(temp(101:end));
    z = zeros(size(x));
    speed=(1:length(temp)-100);
    figure;
    h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
                 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1);
    colormap( flip(build_NOAA_colorgradient) ); colorbar;
    title('place by speed plot');
    legend(legendText);

    
hilbertTemp=hilbert(temp); tsTemp=(1:length(temp))/(1000);
figure; subplot(4,1,1); plot(tsTemp,real(hilbertTemp)); hold on; plot(tsTemp,abs(hilbertTemp)); xlim([255 260]);
subplot(4,1,2); plot( tsTemp, real(hilbertTemp)); hold on; plot(tsTemp,imag(hilbertTemp)); xlim([255 260]);
subplot(4,1,3); plot( tsTemp, angle(hilbertTemp)); xlim([255 260]);
subplot(4,1,4); plot( tsTemp, real(hilbertTemp)); hold on; plot(tsTemp,abs(((temp)))); xlim([255 260]);

energy=zeros(size(temp));
windowSize=150;
for idx=windowSize+1:length(energy)
    %energy(idx)=sqrt(sum(temp(idx:idx+windowSize).^2)); % actual energy calculation
    energy(idx)=sum(abs(temp(idx-windowSize:idx))); % cheaper calculation
end
subplot(4,1,4); hold off; plot( tsTemp, real(hilbertTemp)); hold on; plot(tsTemp,energy/(10*max(energy))); xlim([225 280]);



subplot(4,1,4); plot( tsTemp(2:end), 1000*diff(unwrap(angle(hilbertTemp)))); xlim([255 260]);
    
    

%% filter low ranges to obtain wall electric noise signal
deltaFilter = designfilt( 'bandpassiir',                 ...
                        'FilterOrder',              12, ...
                        'HalfPowerFrequency1',    59, ...
                        'HalfPowerFrequency2',    61, ...
                        'SampleRate',           32000);
deltaBandLfp = filtfilt( deltaFilter, lfp76(ii));
figure; subplot(3,1,1); plot(timestampSeconds(ii),  lfp76(ii)); ylim([ -0.25 0.1  ]);; subplot(3,1,2); plot(timestampSeconds(ii),deltaBandLfp); ylim([ -0.25 0.1  ]); subplot(3,1,3); plot(timestampSeconds(ii),lfp76(ii)-deltaBandLfp); ylim([ -0.25 0.1  ]);
% 6-40 Hz this leaves a ~4.5 hz carrier out of the signal, and makes it
% much more negative-going; might be helpful.



%% filter low ranges to obtain SWR signature
deltaFilter = designfilt( 'bandpassiir',                 ...
                        'FilterOrder',              12, ...
                        'HalfPowerFrequency1',    110, ...
                        'HalfPowerFrequency2',    240, ...
                        'SampleRate',           32000);
deltaBandLfp = filtfilt( deltaFilter, lfp76(ii));
figure; subplot(3,1,1); plot(timestampSeconds(ii),  lfp76(ii)); ylim([ -0.25 0.1  ]);; subplot(3,1,2); plot(timestampSeconds(ii),deltaBandLfp); ylim([ -0.25 0.1  ]); subplot(3,1,3); plot(timestampSeconds(ii),lfp76(ii)-deltaBandLfp); ylim([ -0.25 0.1  ]);



%% chewing filter demonstration
startIdx = round( 39 * 60 * 32000);
endIdx = round( 43.42 * 60 * 32000);
ii=(startIdx:endIdx);
% filter values guess-and-checked empirically
deltaFilter = designfilt( 'bandpassiir',                 ...
                          'FilterOrder',             20, ...
                          'HalfPowerFrequency1',    100, ...
                          'HalfPowerFrequency2',   1000, ...
                          'SampleRate',           32000);
deltaBandLfp = filtfilt( deltaFilter, lfp76(ii));
figure; subplot(3,1,1); plot( timestampSeconds(ii), lfp76(ii)); ylim([ -0.25 0.25 ]);; subplot(3,1,2); plot(timestampSeconds(ii),deltaBandLfp); ylim([ -0.25 0.25  ]); subplot(3,1,3); plot(timestampSeconds(ii),lfp76(ii)-deltaBandLfp); ylim([ -0.25 0.25  ]);
% the filter will successfully subtract the chewing events at 2476 to 2482
% it might be possible to improve it because there's some unknown something
% going on 2530 - 2555 ; rat chews 24 times in 5 seconds, so ~4.8 Hz
% Most chewing probably occurs in the 4-5 Hz range per crunch?
% the LFP contains other frequencies of the noise



swrFilter = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    110, 'HalfPowerFrequency2',    240, 'SampleRate',           32000);
swrFilter = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    110, 'HalfPowerFrequency2',    240, 'SampleRate',           32000);
swrLfp = filtfilt( swrFilter, lfp61); dsRate=10;
figure; 
subplot(6,1,1); plot( downsample(timestampSeconds,dsRate) , downsample(lfp88,dsRate) );
subplot(6,1,2); plot( downsample(timestampSeconds,dsRate), downsample(lfp61,dsRate) ); %ylim([ -0.25 0.1  ]);; 
subplot(6,1,3); plot( downsample(timestampSeconds,dsRate), downsample(swrLfp,dsRate) );% ylim([ -0.25 0.1  ]);
subplot(6,1,4); plot( downsample(timestampSeconds,dsRate), downsample(lfp61-swrLfp,dsRate) ); %ylim([ -0.25 0.1  ]);
subplot(6,1,5); plot( downsample(timestampSeconds,dsRate), downsample(abs(hilbert(swrLfp)),dsRate) );% ylim([ -0.25 0.1  ]);
subplot(6,1,6); plot( xytimestampSeconds, speed ); ylabel('cm/s')

startIdx = 1691.5; for ii=1:6; subplot(6,1,ii); xlim([ startIdx startIdx+3 ]); end;

1692
1838


%% da10 August 21

dir='/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/';

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
pxPerCm = 2.0;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;

% tested : all the LFP timestamps are the same
lfp88=loadCExtractedNrdChannelData([ dir 'rawChannel_88.dat']);
lfp61=loadCExtractedNrdChannelData([ dir 'rawChannel_61.dat']);
lfp76=loadCExtractedNrdChannelData([ dir 'rawChannel_76.dat']);
lfpTimestamps=loadCExtractedNrdTimestampData([ dir 'timestamps.dat']);
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

% Buzsaki says gamma is :
%     slow  30-80  Hz
%     mid   60-120 Hz
%     fast  >100Hz

% Delta wave ? (0.1 ? 4 Hz)
% Theta wave ? (4 ? 8 Hz)
% Alpha wave ? (8 ? 14 Hz)
%       Mu wave ? (7 ? 13 Hz) (sensirimotor)
%       SMR wave ? (12.5 ? 15.5 Hz)
% Beta wave ? (14 ? 31 Hz)
% Gamma wave ? (32 ? 90 Hz)
% fast Gamma wave ? (90 ? 130 Hz)
% sharp wave ? (130 ? 250 Hz)

deltaFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',   0.1, 'HalfPowerFrequency2',      4, 'SampleRate',           32000);
slowSwrFilter   = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',     1, 'HalfPowerFrequency2',     50, 'SampleRate',           32000);
thetaFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',     4, 'HalfPowerFrequency2',     12, 'SampleRate',           32000);
alphaFilter  = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',     8, 'HalfPowerFrequency2',     14, 'SampleRate',           32000);
betaFilter      = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    14, 'HalfPowerFrequency2',     31, 'SampleRate',           32000);
lowGammaFilter  = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    30, 'HalfPowerFrequency2',     80, 'SampleRate',           32000);
midGammaFilter  = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    60, 'HalfPowerFrequency2',    120, 'SampleRate',           32000);
swrFilter       = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    99, 'HalfPowerFrequency2',    260, 'SampleRate',           32000);
highLfpFilter   = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',   250, 'HalfPowerFrequency2',    600, 'SampleRate',           32000);
spikeFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',   600, 'HalfPowerFrequency2',   6000, 'SampleRate',           32000);

deltaLfp     = filtfilt( deltaFilter, lfp88);
slowSwrLfp   = filtfilt( slowSwrFilter, lfp88);
thetaLfp     = filtfilt( thetaFilter, lfp88);
alphaSwrLfp  = filtfilt( alphaFilter, lfp88);
betaLfp      = filtfilt( betaFilter, lfp88);
lowGammaLfp  = filtfilt( lowGammaFilter, lfp88);
midGammaLfp  = filtfilt( midGammaFilter, lfp88);
swrLfp       = filtfilt( swrFilter, lfp88);
highLfp      = filtfilt( highLfpFilter, lfp88);
spikeLfp     = filtfilt( spikeFilter, lfp88);


deltaLfpEnv     = abs(hilbert(deltaLfp));
slowSwrLfpEnv   = abs(hilbert(slowSwrLfp));
thetaLfpEnv     = abs(hilbert(thetaLfp));
alphaSwrLfpEnv  = abs(hilbert(alphaSwrLfp));
betaLfpEnv      = abs(hilbert(betaLfp));
lowGammaLfpEnv  = abs(hilbert(lowGammaLfp));
midGammaLfpEnv  = abs(hilbert(midGammaLfp));
swrLfpEnv       = abs(hilbert(swrLfp));
highLfpEnv      = abs(hilbert(highLfp));
spikeLfpEnv     = abs(hilbert(spikeLfp));


deltaLfpNorm     = (deltaLfpEnv-min(deltaLfpEnv))/max(deltaLfpEnv-min(deltaLfpEnv));
slowSwrLfpNorm   = (slowSwrLfpEnv-min(slowSwrLfpEnv))/max(slowSwrLfpEnv-min(slowSwrLfpEnv));
thetaLfpNorm     = (thetaLfpEnv-min(thetaLfpEnv))/max(thetaLfpEnv-min(thetaLfpEnv));
alphaSwrLfpNorm  = (alphaSwrLfpEnv-min(alphaSwrLfpEnv))/max(alphaSwrLfpEnv-min(alphaSwrLfpEnv));
betaLfpNorm      = (betaLfpEnv-min(betaLfpEnv))/max(betaLfpEnv-min(betaLfpEnv));
lowGammaLfpNorm  = (lowGammaLfpEnv-min(lowGammaLfpEnv))/max(lowGammaLfpEnv-min(lowGammaLfpEnv));
midGammaLfpNorm  = (midGammaLfpEnv-min(midGammaLfpEnv))/max(midGammaLfpEnv-min(midGammaLfpEnv));
swrLfpNorm       = (swrLfpEnv-min(swrLfpEnv))/max(swrLfpEnv-min(swrLfpEnv));
highLfpNorm      = (highLfpEnv-min(highLfpEnv))/max(highLfpEnv-min(highLfpEnv));
spikeLfpNorm     = (spikeLfpEnv-min(spikeLfpEnv))/max(spikeLfpEnv-min(spikeLfpEnv));

figure; imagesc([deltaLfpNorm     ,...
slowSwrLfpNorm   ,...
thetaLfpNorm     ,...
alphaSwrLfpNorm  ,...
betaLfpNorm      ,...
lowGammaLfpNorm  ,...
midGammaLfpNorm  ,...
swrLfpNorm       ,...
highLfpNorm      ,...
spikeLfpNorm     ]); colormap(build_NOAA_colorgradient); colorbar;



figure; plot(slowLfp(ii)-slowLfp(ii-3200)); hold on; plot(abs(hilbert(slowLfp(ii)-slowLfp(ii-3200)))); 
plot(cumsum(slowLfp(ii)-slowLfp(ii-3200)));




startIdx = 1+round( 110 * 32000); endIdx = startIdx + 5*32000; ii=(startIdx:endIdx); % 110 to +5 has a good couple examples?

startIdx = 1+round( 80 * 32000); endIdx = startIdx + 35*32000; ii=(startIdx:endIdx);

figure(2); 
subplot(6,1,1); hold off; plot( timestampSeconds(ii), lfp61(ii) ); ylabel('c61');  axis tight;
hold on; plot( timestampSeconds(ii), lfp76(ii) ); ylabel('c76');   axis tight;
subplot(6,1,2); plot( timestampSeconds(ii), swrLfp(ii), 'Color', [ .9 .1 .2 ] );  ylabel('swr');  axis tight;
subplot(6,1,3); plot( timestampSeconds(ii), midGamLfp(ii), 'Color', [ .2 .9 .3 ] ); ylabel('{\gamma}_{mid}');   axis tight;
subplot(6,1,4); plot( timestampSeconds(ii), gamLfp(ii), 'Color', [ .3 .3 .3 ] ); ylabel('{\gamma}_{slow}');   axis tight;
subplot(6,1,5); plot( timestampSeconds(ii), lfp88(ii) ); hold on; plot(timestampSeconds(ii), slowLfp(ii)); plot(timestampSeconds(ii), slowLfp(ii)-slowLfp(ii-3200)); ylabel('c88'); hold off;  axis tight;
subplot(6,1,6); plot( xytimestampSeconds(1+round(29.97*ii/32000)), speed(1+round(29.97*ii/32000))); axis tight; ylabel('cm/s')

peakLag=slowLfp(ii)-slowLfp(ii-3200);

startIdx = 1691.5; for ii=1:6; subplot(6,1,ii); xlim([ startIdx startIdx+3 ]); end;














return; 

%/Volumes/BlueMiniSeagateData/da10/da10_2017-09-22_11-57-33
% screenshot at 51 minutes showing nice looking sleep.


% file | TT# | reg. | ref |   notes
% ----------------------------------
% CSC3   TT1   Nac   h1r1  inverted, small
% CSC6   TT2   Nac   h1r1  sync, strong
% CSC10  TT3   Nac   h1r1  sync, strong
% CSC14  TT4   hf    h1r1  sync
% CSC18  TT5   hf    h1r1  inverted, small
% CSC64  TT17  hf    h1r1  less sync
% CSC72  TT19  hf    h3r1  sync, small, not inverted
% CSC76  TT20  hf    h3r1  sync, small, not inverted
% CSC84  TT22  Nac   h1r1  sync, bigger, not inverted
% CSC86  TT22  Nac   h3r1  sync, bigger, not inverted looks clear
% CSC88  TT23  hf    h1r1  sync, bigger, SWR inverted (prob below hf cell layer)
% CSC61  TT16  hf    h1r1  sync, less clear, maybe SWR
% ** tt21 also ref. to  h3r1


%'da10_2017-08-22_random-walkin.nzv'
%'/Volumes/BlueMiniSeagateData/da10/da10_201-08-22_has-raw-sleep-theta-swr-location/Events.nev'

%% load data

tt=(lfpTimestamps-lfpTimestamps(1))/60e6;

bitvolts = 0.045777763801879701 % microvolts


tt=(lfpTimestamps-lfpTimestamps(1))/1e6;
min(find(tt>5300))

idxs=153203170-64000:153203170+64000;
figure; plot(tt(idxs),lfp(idxs)); axis tight;


xyFramesPerSecond = 29.97;
xyTimesForPlots = (xytimestamps-xytimestamps(1))/1e6; % seconds

%% plot the location preferences of the rat at various epochs
plotTwoDHistogramByEpoch( xpos, ypos, 10)

%% plot a 3D version of the rat's trajectory in time 
%figure; plot3((xytimestamps-xytimestamps(1))/60e6,xpos,ypos);

%% smooth the speed out
% estimating from the graph of the locations
% sqrt((512-137).^2+(365-53).^2) = ~488 px per long arm of the plus maze;
% 218cm
pxPerCm = 2.385;
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);

figure; subplot( 1, 8, 1:7 ); plot( xyTimesForPlots, speed ); title('speed plot'); xlabel('time (s)'); ylabel('speed (cm/s)'); axis tight;
subplot( 1, 8, 8); [yy,xx]=hist(speed, 0:3:90 ); plot(yy/sum(yy),xx); title('speed PDF'); xlabel('prob.');
