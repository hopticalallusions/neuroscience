%% EXTRACT SWR

rat = { 'da5' 'da10' 'h5' 'h7' 'h1' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' '2016-09-01' '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04' '2018-09-05' '2018-09-06' '2018-09-08' '2018-09-09' '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC64.ncs' 'CSC44.ncs' };
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% SWR channels to use
swrLfpNames.da5  = { 'CSC6.ncs'  'CSC26.ncs' 'CSC28.ncs'  };
swrLfpNames.da10 = { 'CSC81.ncs' 'CSC61.ncs' 'CSC32.ncs' };
swrLfpNames.h5   = { 'CSC36.ncs' 'CSC87.ncs' };
swrLfpNames.h7   = { 'CSC44.ncs' 'CSC56.ncs' 'CSC54.ncs' }; 
swrLfpNames.h1   = { 'CSC84.ncs' 'CSC20.ncs' 'CSC17.ncs'  'CSC32.ncs'  'CSC64.ncs' };  % first two are the favorites

noiseLfpNames.h7 = { 'CSC12.ncs'  'CSC24.ncs'  'CSC28.ncs'  'CSC32.ncs'  'CSC4.ncs'   'CSC108.ncs' };

filters.so.theta     = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent

filters.so.swr       = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  180, 'HalfPowerFrequency2',  250, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article

filters.so.highGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  80, 'HalfPowerFrequency2',  150, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article

filters.so.delta    = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.1, 'HalfPowerFrequency2',    4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal

skipExisting = true;



filters.so.theta    = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
filters.so.delta    = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  1.5, 'HalfPowerFrequency2',    4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal



% enhance the SWR dataset with the ratio for the Theta


for ratIdx = 4 % 1:length(rat)
    % folder 29 for rat idx 4 has great SWR events
    for thisFolder = 10 % 1:length(folders.(rat{ratIdx}))  % length(folders.(rat{ratIdx}))-3
        for thisTheta = 1 %1:length(thetaLfpNames.(rat{ratIdx}))
            for thisSwr = 1 %:2 %1:length(swrLfpNames.(rat{ratIdx}))
                try
                    disp( [ 'TRY : ' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') ] ) 

                    if true % ~exist([ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ], 'file' ) 

                       % load( [ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
                       % swrData

                        
                        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat{ratIdx} '/' folders.(rat{ratIdx}){thisFolder} '/' ];
                        load([ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');

                        [ swrChannel, swrLfpTimestamps ]=csc2mat([ filepath   swrLfpNames.(rat{ratIdx}){thisSwr} ]);
                        swrLfpTimestampSeconds = (swrLfpTimestamps-swrLfpTimestamps(1))/1e6;
                        swrLfp = filtfilt( filters.so.swr, swrChannel );
                        swrLfpEnv = abs(hilbert(swrLfp));

                        swrEnvMedian = median(swrLfpEnv);
                        swrEnvMadam  = median(abs(swrLfpEnv-swrEnvMedian));

                        % this is intentionally low. we will save the peak values and
                        % deal with selection later.
        %                swrThresholdMedian = swrEnvMedian + 3*swrEnvMadam; % mean(swrLfp) + ( 3  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
        %                swrThresholdMean = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );
                        swrThreshold = quantile(swrLfpEnv,.95);

                        [swrPeakValues,      ...
                         swrPeakTimes,       ... 
                         swrPeakProminances, ...
                         swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                                      swrLfpTimestampSeconds,                     ... % sampling frequency
                                                      'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
                                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

                        hh = histogram(swrLfpEnv,500);

                        swrData.timestampSeconds = swrPeakTimes;
                        swrData.timestamps       = interp1( swrLfpTimestampSeconds, swrLfpTimestamps, swrPeakTimes );
                        swrData.peakValues    = swrPeakValues;

                        % envelope distribution data
                        swrData.swrEnvDistVals   = hh.Values;
                        swrData.swrEnvDistBins   = hh.BinEdges;
                        swrData.swrThreshold     = swrThreshold;
                        swrData.swrEnvMedian     = swrEnvMedian;
                        swrData.swrEnvMadam      = swrEnvMadam;
                        swrData.swrEnvMean       = mean(swrLfpEnv);
                        swrData.swrEnvStd        = std(swrLfpEnv);
                        
                        % find start and finish of SWR
                        
                        
                        
                        
                        % free memory
%                        clear swrLfpEnv swrLfpTimestamps swrLfpTimestampSeconds

                        
                        % Theta information
                        [ thetaChannel, thetaLfpTimestamps ]=csc2mat([ filepath   thetaLfpNames.(rat{ratIdx}){thisTheta} ]);
                        thetaLfpTimestampSeconds = (thetaLfpTimestamps-thetaLfpTimestamps(1))/1e6;
                        thetaLfp = filtfilt( filters.so.theta, thetaChannel );
                        thetaAnalytic = hilbert(thetaLfp);
                        thetaLfpEnv = abs(thetaAnalytic);
                        thetaPhase = angle(thetaAnalytic);

                        hh = histogram(thetaLfpEnv,500);

                        swrData.thetaEnvDistVals  = hh.Values;
                        swrData.thetaEnvDistBins  = hh.BinEdges;
                        swrData.thetaEnvMedian    = median(thetaLfpEnv);
                        swrData.thetaEnvMadam     = median(abs(thetaLfpEnv-median(thetaLfpEnv)));
                        swrData.thetaEnvMean      = mean(thetaLfpEnv);
                        swrData.thetaEnvStd       = std(thetaLfpEnv);
                        % IMPORTANT -- unwrap and mod or else linear interpolation will produce bad phase data.
                        swrData.thetaPhase       = mod(interp1( thetaLfpTimestamps, unwrap(thetaPhase), swrData.timestamps ), 2*pi)*180/pi;
                        swrData.thetaEnv         = interp1( thetaLfpTimestamps, thetaLfpEnv, swrData.timestamps );
                        swrData.thetaLfpName     = thetaLfpNames.(rat{ratIdx}){thisTheta};
                        swrData.swrLfpName       = swrLfpNames.(rat{ratIdx}){thisSwr};

                        %
                        % build relative ne
                        %
                        
                        %
                        deltaLfp = filtfilt( filters.so.delta, thetaChannel );
                        deltaAnalytic = hilbert(deltaLfp);
                        deltaLfpEnv = abs(deltaAnalytic);
                        
                        
                        
                        % free memory
%                        clear thetaLfpEnv thetaLfpTimestamps thetaLfpTimestampSeconds  delta LfpEnv

                        swrData.x                = interp1( telemetry.xytimestamps, telemetry.x     , swrData.timestamps );
                        swrData.y                = interp1( telemetry.xytimestamps, telemetry.y     , swrData.timestamps );
                        swrData.speed            = interp1( telemetry.xytimestamps, telemetry.speed , swrData.timestamps );
                        swrData.movDir           = interp1( telemetry.xytimestamps, telemetry.movDir, swrData.timestamps );
                        swrData.headDir          = interp1( telemetry.xytimestamps, telemetry.movDir, swrData.timestamps );
                        swrData.onMaze           = interp1( telemetry.xytimestamps, telemetry.onMaze, swrData.timestamps );
                        swrData.trial            = interp1( telemetry.xytimestamps, telemetry.trial , swrData.timestamps );

%                        save( [ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] , 'swrData' );

                        disp( [ 'SUCCESS : ' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') ] ) 

                    else
                        disp( [ 'SKIPPED : ' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
                    end
                catch err
                    disp( [ 'FAILED : ' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
                    err.getReport
                end
            end                              
        end
    end
end



return;



figure; plot(thetaLfpTimestampSeconds, deltaLfpEnv); hold on; plot(thetaLfpTimestampSeconds, thetaLfpEnv); 
figure;  plot(tt, dE); hold on; plot(tt, tE);  plot(tt, 0.01*tE./dE); plot( telemetry.xytimestampSeconds, telemetry.onMaze/10)
 
figure; histogram( tE./dE, 0:.1:10)
figure; histogram( dE); hold on; histogram( tE)


dE = decimate( deltaLfpEnv, 3200 );
tE = decimate( thetaLfpEnv, 3200 );
tt = decimate( thetaLfpTimestampSeconds, 3200 );

figure; plot(telemetry.xytimestampSeconds, telemetry.speed); hold on; plot( tt, tE./dE);
plot(telemetry.xytimestampSeconds, telemetry.onMaze);

plot( thetaLfpTimestampSeconds, thetaLfp); plot( thetaLfpTimestampSeconds, deltaLfp);

spuds=(interp1(telemetry.xytimestampSeconds, telemetry.speed, tt));
figure;  scatter( spuds, log10(tE), 'filled' ); alpha(.3);
hold on; scatter( spuds, log10(dE), 'filled' ); alpha(.3);
hold on; scatter( spuds, log10(tE./dE), 'filled' ); alpha(.3);
figure; plot(thetaLfpTimestampSeconds, thetaChannel);

figure; scatter( tE(spuds<=0), dE(spuds<=0) )

figure; histogram( tE(spuds>0 & spuds<10)./dE(spuds>0& spuds<10), 0:.1:10  )
hold on;  histogram( tE(spuds>10)./dE(spuds>10), 0:.1:10  )

% 
% try theta delta on this :
% '/Volumes/AGHTHESIS2/rats/h7/2018-08-07/CSC48.ncs'
% '/Volumes/AGHTHESIS2/rats/h7/2018-08-07/CSC56.ncs'
% 
% Redish style :
% 2-4 delta
% 6-10 theta
% 
% seems like teh LFP is always taken on the CA1 channel, which is kinda whack, but OK.
% 




filters.so.theta  = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1', 6, 'HalfPowerFrequency2', 10, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
filters.so.delta  = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1', 2, 'HalfPowerFrequency2',  4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal

[ thetaChannel, thetaLfpTimestamps ]=csc2mat([ filepath   '/Volumes/AGHTHESIS2/rats/h7/2018-08-07/CSC48.ncs' ]);
thetaLfpTimestampSeconds = (thetaLfpTimestamps-thetaLfpTimestamps(1))/1e6;
thetaLfp = filtfilt( filters.so.theta, thetaChannel );
thetaAnalytic = hilbert(thetaLfp);
thetaLfpEnv = abs(thetaAnalytic);

deltaLfp = filtfilt( filters.so.delta, thetaChannel );
deltaAnalytic = hilbert(deltaLfp);
deltaLfpEnv = abs(deltaAnalytic);




dE = decimate( deltaLfpEnv, 3200 );
tE = decimate( thetaLfpEnv, 3200 );
tt = decimate( thetaLfpTimestampSeconds, 3200 );

figure; plot(telemetry.xytimestampSeconds, telemetry.speed); hold on; plot( tt, tE./dE);
plot(telemetry.xytimestampSeconds, telemetry.onMaze);



%samplingFreq, windowSize, overlap
    [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,16), decimate(thetaChannel,16), 32000/16, 512,0  );
    figure(102); 
    pcolor(coherence); 
    shading flat; 
    colormap(build_NOAA_colorgradient); 
    colorbar;
    sortedCoherence=sort(coherence(:),2);
    caxis([0 sortedCoherence(3) ]);
    title(filename);
    axis square;
    xlabel('cortex');
    ylabel('striatum');

    
    
    
    
    
[ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,16), decimate(swrChannel,16), 32000/16, 512,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
[ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,16), decimate(thetaChannel,16), 32000/16, 512,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
[ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(thetaChannel,16), decimate(thetaChannel,16), 32000/16, 512,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;




factor=8; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,factor), decimate(swrChannel,factor), 32000/factor, (32000/4)/factor,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
factor=16; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,factor), decimate(swrChannel,factor), 32000/factor, (32000/4)/factor,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
factor=32; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,factor), decimate(swrChannel,factor), 32000/factor, (32000/4)/factor,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
factor=64; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,factor), decimate(swrChannel,factor), 32000/factor, (32000/4)/factor,0  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;



factor=16; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(swrChannel,factor), decimate(swrChannel,factor), 32000/factor, (32000/2)/factor, round(.1*32000/factor)  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;


% nice looking ripple chart for cross frequency coupling of amplitude.
factor=16; decLfp = decimate(swrChannel,factor); [ coherence, cyclicalFreq ] = crossFreqCoherence( decLfp, decLfp , 32000/factor, .5, .1  ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;






factor=16; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(thetaChannel,factor), decimate(thetaChannel,factor), 32000/factor, 1, .2 ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
factor=16; [ coherence, cyclicalFreq ] = crossFreqCoherence( decimate(thetaChannel,factor), decimate(thetaChannel,factor), 32000/factor, .333, .1 ); figure;  pcolor(coherence);  shading flat;  colormap(build_NOAA_colorgradient);  colorbar;
