% 
% the point of this file is to set up analysis preliminaries for running
% the Mockingbird FPGA real time analysis pipeline on theta, gamma, sharp
% wave ripples and spikes
%
% Tad's notes supplemented by my additions. Tad's comments begin the
% records, my own follow the first set of semicolons
%
% tt1  - chew   ; 
% tt2  - chew   ; 
% tt3  - chew   ; 
% tt4  - chew   ; units? (cross connected)
% tt5  - chew   ; units (small); 
% tt6  - chew   ; units (small); 
% tt7  -        ; off, dead?
% tt8  -        ; units (small); 
% tt9  -        ; nothing exciting
% tt10 - swr    ; lots of units
% tt11 -        ; off, dead?
% tt12 -        ; 
% tt13 - theta  ; 
% tt14 -        ; 
% tt15 -        ; 
% tt16 - gamma  ; ch60
% tt17 - gamma  ; ch64
% tt18 -        ; 
% tt19 - theta  ; 
% tt20 - gamma  ; 
% tt21 -        ; 
% tt22 - swr    ; (channel 87)
% tt23 -        ; 
% tt24 -        ; 
% tt25 -        ; 
% tt26 -        ; 
% tt27 -        ; 
% tt28 -        ; 
% tt29 -        ; 
% tt30 -        ;  
% tt31 -        ; 
% tt32 -        ; 

makeFilters;

dir='~/data/h5_orientation2_rawExtract/';

lfp=loadCExtractedNrdChannelData( [ dir 'rawChannel_87.dat' ] );
lfpTimestamps=loadCExtractedNrdTimestampData([ dir 'timestamps.dat' ]);
lfpTimeSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

swrFilterWide      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   99, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % 
swrFilterNarrow      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   120, 'HalfPowerFrequency2',  220, 'SampleRate', 32000); % 
%swrFilterMedium      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   125, 'HalfPowerFrequency2',  220, 'SampleRate', 32000); %


swrLfpWide = filtfilt(  swrFilterWide, lfp );
swrLfpNarrow = filtfilt(  swrFilterNarrow, lfp );
%swrLfpMedium = filtfilt(  swrFilterMedium, lfp );

swrLfpEnvWide = abs( hilbert( swrLfpWide ) );
swrLfpEnvNarrow = abs( hilbert( swrLfpNarrow ) );
%swrLfpEnvMedium = abs( hilbert( swrLfpMedium ) );

figure;
hold on;
plot(lfpTimeSeconds, swrLfpWide)
plot(lfpTimeSeconds, swrLfpNarrow)
%plot(lfpTimeSeconds, swrLfpMedium)



lfpGamma=loadCExtractedNrdChannelData( [ dir 'rawChannel_60.dat' ] );
gammaLfp = filtfilt(  filters.so.gamma , lfpGamma );
plot(lfpTimeSeconds, gammaLfp)




swrThreshold = mean(swrLfp) + ( 3  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number

[swrPeakValues,      ...
 swrPeakTimes,       ... 
 swrPeakProminances, ...
 swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                              lfpTimeSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
                          
length(swrPeakValues)/max(lfpTimeSeconds)

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
speed = calculateSpeed( xpos, ypos, 1, 2.63);
speedNormed = speed/max(speed);

