
function [ chewPeakTimestampSeconds, chewPeakTimestamps, chewPeakValues ] = detectH5chews( path, fileListGoodLfp )
%% I. SETUP THE ANALYSIS RUN
% 
% this version of this script intends to just identify packets where mouth
% movements contaminate the LFP.

%% LOAD AVERAGE LFPs
[ avgLfp, lfpTimestamps ] = avgLfpFromList( path, fileListGoodLfp, 1 );  % build average LFP


%  ====================
%% == DETECT CHEWING ==
%  ====================
%

disp('DETECT CHEWING')
% detect chewing events -- refered to as "crunch" because that's what they
% sound like. First, filter a fairly wide band to see the crunches
%

%
% These crunches occur at about 3-6 Hz, so I build a wide envelope-like
% signal in which to seek these groups; regular envelope at this sample
% rate is too wobbly to detect the dead-obvious to the eye crunch groups.
%

swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrBandLfp=filtfilt(swrFilter, avgLfp);

[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( swrBandLfp, lfpTimestamps );

%    swrLfpEnv = abs(hilbert(swrBandLfp));
swrThreshold = mean(chewCrunchEnv) + ( 3  * std(chewCrunchEnv) );  % 3 is a Karlsson & Frank 2009 number
[chewPeakValues,      ...
 chewPeakTimestamps ] = findpeaks( chewCrunchEnv,                        ... % data
                              chewCrunchEnvTimes,                     ... % sampling frequency
                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

chewPeakTimestampSeconds = (chewPeakTimestamps-lfpTimestamps(1))/1e6;



                          
                          
% figure;
% plot(lfpTimestampSeconds,swrBandLfp);
% hold on;
% plot( chewCrunchEnvTimes, chewCrunchEnv );
% scatter(swrPeakTimes,swrPeakValues,'o');
% 
% lfpZero = csc2mat( [ path 'CSC0.ncs'] );
% swrBandLfpZero=filtfilt(swrFilter, avgLfp);
% lfpTimestampSeconds = (0:length(swrBandLfp)-1)/32000;
% [ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( swrBandLfpZero, lfpTimestampSeconds );
% 
%     %    swrLfpEnv = abs(hilbert(swrBandLfp));
%         swrThreshold = mean(chewCrunchEnv) + ( 3  * std(chewCrunchEnv) );  % 3 is a Karlsson & Frank 2009 number
%         [swrPeakValues,      ...
%          swrPeakTimes,       ... 
%          swrPeakProminances, ...
%          swrPeakWidths ] = findpeaks( chewCrunchEnv,                        ... % data
%                                       chewCrunchEnvTimes,                     ... % sampling frequency
%                                       'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                                       'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


% % these filters depend on the ouput above.
% filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
% filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
% %
% % Next, find groups of crunches, refered to as "chewing episodes"/"reward"
% %
% chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
% chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));
% 
% chewDetectorOutput = detectPeaksEdgesDa5( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );
% 
% %  ====================
% %% == DETECT BRUXING ==
% %  ====================
% toc
% disp('DETECT BRUXING')
% %
% bruxEpisodeLFP=filtfilt( filters.ao.brux, chewCrunchEnv );
% bruxEpisodeEnv=abs(hilbert(bruxEpisodeLFP));
% bruxDetectorOutput = detectPeaksEdgesDa5( bruxEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );
% 
% save([metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '') '_output'], 'output' );
% 
% 
% %% terminate the script
% toc
% disp('COMPLETE')

return;

% =============
% ==   END   ==
% =============

%% zoom x axis manually
