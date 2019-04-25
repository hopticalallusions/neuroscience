% here, I am focusing on DA5. I am trying to figure out if one particular
% LFP has substantially more SWR events than others, or if there are a lot
% of coincidences of SWR events.

baseDir = '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/';
dataDirs = { '2016-08-22_orientation1/1.maze-habituation/'  '2016-08-22_orientation1/2.bucket-rest/'  '2016-08-23_orientation2/1.maze-habituation/'  '2016-08-23_orientation2/2.bucket-rest/'  '2016-08-24_training1/'  '2016-08-25_training2/'  '2016-08-26_probe1/'  '2016-08-27_training3/'  '2016-08-28_training4/'  '2016-08-29_training5/'  '2016-08-30_training6/'  '2016-08-31_training7/'  '2016-09-01_training8/'  '2016-09-02_probe2/'  '2016-09-06_training9_x2/'  '2016-09-07_training10_x2/'  '2016-09-08_probe3_training11/' };

swrLfpFiles = { 'CSC4.ncs' 'CSC24.ncs' 'CSC28.ncs' 'CSC36.ncs' }; % TT2,TT7,TT8 ;; ch4, ch24, ch28,

makeFilters;

eventCounts = zeros( length(swrLfpFiles), length(dataDirs) );
eventTimespan = zeros( length(swrLfpFiles), length(dataDirs) );
eventRates = zeros( length(swrLfpFiles), length(dataDirs) );

% [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
% xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
% xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
% speed=calculateSpeed(xpos, ypos, 1, 2.7);

for dataDirIdx = 1:length(dataDirs);
    for swrLfpFilesIdx = 1:length(swrLfpFiles);

        [ swrLfp, lfpTimestamps ] = csc2mat( [ baseDir (dataDirs{dataDirIdx}) (swrLfpFiles{swrLfpFilesIdx}) ] );
        lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;


        swrLfp = filtfilt( filters.so.swr, swrLfp );
        swrLfpEnv = abs( hilbert(swrLfp) );

        swrEnvMedian = median(swrLfpEnv);
        swrEnvMadam  = median(abs(swrLfpEnv-swrEnvMedian));
        % empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
        % it equivalent to the std(xx)*6 previously used; this change was made
        % because some SWR channels had no events due to 1 large noise artifact
        % wrecking the threshold; the threshold was slightly relaxed on the premise
        % that extra SWR could be removed at later processing stages.
        swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );

        [ swrPeakValues,      ...
          swrPeakTimes,       ...
          swrPeakProminances, ...
          swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                     lfpTimestampSeconds,                     ... % sampling frequency
                                     'MinPeakHeight',  swrThreshold, ...  %std(swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                     'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

        disp( dataDirs{dataDirIdx}) 
        disp( (swrLfpFiles{swrLfpFilesIdx}) )
        disp( [ ' swr events ' num2str(length(swrPeakTimes)) ] )

        save([ '~/data/da5_' strrep((dataDirs{dataDirIdx}), '/', '_') '_' strrep((swrLfpFiles{swrLfpFilesIdx}), '.ncs', '') '_swrPeakTimes.dat'], 'swrPeakTimes' ); 
        
        eventCounts( dataDirIdx, swrLfpFilesIdx ) = length(swrPeakTimes);
        eventTimespan( dataDirIdx, swrLfpFilesIdx ) = lfpTimestampSeconds(end)-lfpTimestampSeconds(1);
        eventRates( dataDirIdx, swrLfpFilesIdx ) = eventCounts( dataDirIdx, swrLfpFilesIdx )/eventTimespan( dataDirIdx, swrLfpFilesIdx );
        
    end
end
