
function [ output ] = detectH5chewBruxEpisodes( path, fileListGoodLfp, ratName, dateStr, outputPath )
%% I. SETUP THE ANALYSIS RUN
% 
% this version of this script intends to just identify packets where mouth
% movements contaminate the LFP.

%% LOAD AVERAGE LFPs


    if ~exist( [ outputPath '/' ratName '_' dateStr '_avgLfp.mat' ], 'file' )
        disp('building avg signal LFP');
        [ avgLfp, lfpTimestamps ] = avgLfpFromList( path, fileListGoodLfp, 1 );  % build average LFP
        save( [ outputPath '/' ratName '_' dateStr '_avgLfp.mat' ], 'avgLfp');
        save( [ outputPath '/' ratName '_' dateStr 'lfpTimestamps.mat' ], 'lfpTimestamps');
    else
        disp('loading avg signal LFP');
        load( [ outputPath '/' ratName '_' dateStr '_avgLfp.mat' ], 'avgLfp' );
        load( [ outputPath '/' ratName '_' dateStr 'lfpTimestamps.mat' ], 'lfpTimestamps');
    end







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

chewFilter     = designfilt( 'bandpassiir', 'StopbandFrequency1',   80, 'PassbandFrequency1',  100, 'PassbandFrequency2', 1000, 'StopbandFrequency2', 1200, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order, settings by testing

chewLfp=filtfilt(chewFilter, avgLfp);

[ chewCrunchEnv, chewCrunchEnvTimestamps, chewCrunchEnvSampleRate ] = boxcarMaxFilter( chewLfp, lfpTimestamps );

filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
%
% Next, find groups of crunches, refered to as "chewing episodes"/"reward"
%
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));



chewDetectorOutput = detectPeaksEdgesDa5( chewEpisodeEnv, chewCrunchEnvTimestamps, chewCrunchEnvSampleRate );

chewStartTimestamps = chewCrunchEnvTimestamps( chewDetectorOutput.EpisodeStartIdxs );
chewEndTimestamps   = chewCrunchEnvTimestamps( chewDetectorOutput.EpisodeEndIdxs   );


% %  ====================
% %% == DETECT BRUXING ==
% %  ====================
disp('DETECT BRUXING')
% %
filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
bruxEpisodeLFP     = filtfilt( filters.ao.brux, chewCrunchEnv );
bruxEpisodeEnv     = abs(hilbert(bruxEpisodeLFP));
bruxDetectorOutput = detectPeaksEdgesDa5( bruxEpisodeEnv, chewCrunchEnvTimestamps, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );
%
bruxStartTimestamps = chewCrunchEnvTimestamps( bruxDetectorOutput.EpisodeStartIdxs );
bruxEndTimestamps   = chewCrunchEnvTimestamps( bruxDetectorOutput.EpisodeEndIdxs   );

% 
% save([metadata.outputDir metadata.rat '_' metadata.day '_' strrep(metadata.swrLfpFile, '.ncs', '') '_output'], 'output' );
% 
% 
% %% terminate the script
disp('COMPLETE')

chewDetectorOutput.chewStartTimestamps = chewStartTimestamps;
chewDetectorOutput.chewEndTimestamps = chewEndTimestamps;
bruxDetectorOutput.bruxStartTimestamps = bruxStartTimestamps;
bruxDetectorOutput.bruxEndTimestamps = bruxEndTimestamps;
%
chewDetectorOutput.chewStartTimes = ( chewStartTimestamps-lfpTimestamps(1))/1e6;
chewDetectorOutput.chewEndTimes = ( chewEndTimestamps-lfpTimestamps(1))/1e6;
bruxDetectorOutput.bruxStartTimes = ( bruxStartTimestamps-lfpTimestamps(1))/1e6;
bruxDetectorOutput.bruxEndTimes = ( bruxEndTimestamps-lfpTimestamps(1))/1e6;
% crunch times
output.chewData = chewDetectorOutput;
% brux times
output.bruxData = bruxDetectorOutput;
output.filesAvg = fileListGoodLfp;
output.lfpTimestampZero = lfpTimestamps(1);


return;

% =============
% ==   END   ==
% =============
