clear all; close all;

baseDir = '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/';
dataDirs = { '2016-08-22_orientation1/1.maze-habituation/'  '2016-08-22_orientation1/2.bucket-rest/'  '2016-08-23_orientation2/1.maze-habituation/'  '2016-08-23_orientation2/2.bucket-rest/'  '2016-08-24_training1/'  '2016-08-25_training2/'  '2016-08-26_probe1/'  '2016-08-27_training3/'  '2016-08-28_training4/'  '2016-08-29_training5/'  '2016-08-30_training6/'  '2016-08-31_training7/'  '2016-09-01_training8/'  '2016-09-02_probe2/'  '2016-09-06_training9_x2/'  '2016-09-07_training10_x2/'  '2016-09-08_probe3_training11/' };

fileListGoodLfp = { 'CSC2.ncs'  'CSC10.ncs'  'CSC14.ncs'  'CSC18.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  };  % theta 'CSC46.ncs'  lots of cells 'CSC6.ncs'  'CSC26.ncs'


makeFilters;

tic

    

for dataDirIdx = 1:length(dataDirs);

    [ ~, lfpTimestamps ] = csc2mat( [ baseDir (dataDirs{dataDirIdx}) (fileListGoodLfp{1}) ] );
    lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
    
    avgLfp=avgLfpFromList( [ baseDir (dataDirs{dataDirIdx}) ], fileListGoodLfp, 1 );  % build average LFP

    %  ====================
    %% == DETECT CHEWING ==
    %  ====================
    %
    toc
    disp('DETECT CHEWING')
    % detect chewing events -- refered to as "crunch" because that's what they
    % sound like. First, filter a fairly wide band to see the crunches
    %
    avgChew = filtfilt( filters.so.chew, avgLfp );
    %
    % These crunches occur at about 3-6 Hz, so I build a wide envelope-like
    % signal in which to seek these groups; regular envelope at this sample
    % rate is too wobbly to detect the dead-obvious to the eye crunch groups.
    %

    [ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, lfpTimestampSeconds );
    % these filters depend on the ouput above.
    filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
    filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
    %
    % Next, find groups of crunches, refered to as "chewing episodes"/"reward"
    %
    chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
    chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));

    chewDetectorOutput = detectPeaksEdgesDa5( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );

    chewDetectorOutput.startTimes = chewCrunchEnvTimes( chewDetectorOutput.EpisodeStartIdxs );
    chewDetectorOutput.endTimes   = chewCrunchEnvTimes( chewDetectorOutput.EpisodeEndIdxs   );
    
    save([ '~/data/da5_' strrep((dataDirs{dataDirIdx}), '/', '_') '_chewTimes.dat'], 'chewDetectorOutput' ); 
    
    
    %  ====================
    %% == DETECT BRUXING ==
    %  ====================
    toc
    disp('DETECT BRUXING')
    %
    bruxEpisodeLFP = filtfilt( filters.ao.brux, chewCrunchEnv );
    bruxEpisodeEnv = abs( hilbert(bruxEpisodeLFP) );
    bruxDetectorOutput = detectPeaksEdgesDa5( bruxEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );

    bruxDetectorOutput.startTimes = chewCrunchEnvTimes( bruxDetectorOutput.EpisodeStartIdxs );
    bruxDetectorOutput.endTimes   = chewCrunchEnvTimes( bruxDetectorOutput.EpisodeEndIdxs   );
    
    save( [ '~/data/da5_' strrep((dataDirs{dataDirIdx}), '/', '_') '_bruxTimes.dat'], 'bruxDetectorOutput' ); 

    toc
    
end

toc
