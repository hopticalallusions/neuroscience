%%
% test for significance of SWR cross correlations with 

% h1 -- 2018-08-27a -- TT1 -- C1 --

clear all;

% '2018-07-11' -- this telemetry file doesn't work for some reason.
rat = { 'h5' 'h7' 'h1' }; %'da5' 'da10' 'h1'  };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-08-31' '2018-09-04' '2018-09-05' };
folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC44.ncs' 'CSC64.ncs'};
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% SWR channels to use
swrLfpNames.da5  = { 'CSC6.ncs'  'CSC26.ncs' 'CSC28.ncs'  };
swrLfpNames.da10 = { 'CSC81.ncs' 'CSC61.ncs' 'CSC32.ncs' };
swrLfpNames.h5   = { 'CSC36.ncs' 'CSC87.ncs' };
swrLfpNames.h7   = { 'CSC44.ncs' 'CSC56.ncs' 'CSC54.ncs' }; 
swrLfpNames.h1   = { 'CSC84.ncs' 'CSC20.ncs' 'CSC17.ncs'  'CSC32.ncs'  'CSC64.ncs' };  % first two are the favorites

circColor = buildCircularGradient;
buildTtPositionDatabase;
shadyCircularColorPlot=[ .2*circColor; .4*circColor; .7*circColor; .9*circColor; circColor; ];
shadeLevels = length(shadyCircularColorPlot)/360-1;
binResolution = 10;

thisTheta = 1;
thisSwr = 1; 

shufflesToDo = 1000;
xcorrBinSize = 0.05;
maxLagTime = 2;

figure(1);

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';

makeGraphs = false;
%fileID = fopen([ basePathOutput 'tt_unit_info_metrics_v2019-August-02_others-v3.csv'],'w');
fileID = fopen([ basePathOutput 'tt_unit_info_metrics_v2019-August-02_others-xx.csv'],'w');

%make header
%message = [ 'rat,' 'folder,' 'TT,' 'unit,' 'totalSpikes,' 'totalOnMaze,' 'totalOffMaze,' 'totalStill,' 'totalMoving,' 'totalOnMazeStill,' 'totalOnMazeMoving,' '%_totalOnMaze,'  '%_totalOffMaze,' '%_totalStill,' '%_totalMoving,' '%_totalOnMazeStill,' '%_totalOnMazeMoving,' 'region,'  'thetaIndex,totalOnMazeMovingFast,rateOverall,rateOnMaze,rateOffMaze,rateStill,rateMoving,rateOnMazeStill,rateOnMazeMoving,rateOnMazeMovingFast,rateISINinetyNinth,rateISINinetyFifth,rateISIEightyth,rateISIMedian,rateISITwentieth,rateISIFifth,rateISIFirst,' 'phaseMaxBucket,phaseResultantBucket,phaseMaxOnMaze,phaseResultantOnMaze,phaseMaxOnMazeStill,phaseResultantOnMazeStill,phaseMaxOnMazeMoving,phaseResultantOnMazeMoving,phaseMaxAllTrajectories,phaseResultantAllTrajectories,phaseMaxSelectedTrajectories,phaseResultantSelectedTrajectories,' 'spikePlaceInfoPerSecondBucket,spikePlaceInfoPerSpikeBucket,spikePlaceSparsityBucket,spatialFiringRateCoherenceBucket,spatialFieldsBucket,firingAreaProportionBucket,phaseInfoJointBucket,phaseInfoConditionalBucket,spikeRateMIjointBucket,spikeRateMIconditionalBucket,spikePlaceInfoPerSecondOnMaze,spikePlaceInfoPerSpikeOnMaze,spikePlaceSparsityOnMaze,spatialFiringRateCoherenceOnMaze,spatialFieldsOnMaze,firingAreaProportionOnMaze,phaseInfoJointOnMaze,phaseInfoConditionalOnMaze,spikeRateMIjointOnMaze,spikeRateMIconditionalOnMaze,spikePlaceInfoPerSecondOnMazeStill,spikePlaceInfoPerSpikeOnMazeStill,spikePlaceSparsityOnMazeStill,spatialFiringRateCoherenceOnMazeStill,spatialFieldsOnMazeStill,firingAreaProportionOnMazeStill,phaseInfoJointOnMazeStill,phaseInfoConditionalOnMazeStill,spikeRateMIjointOnMazeStill,spikeRateMIconditionalOnMazeStill,spikePlaceInfoPerSecondOnMazeMoving,spikePlaceInfoPerSpikeOnMazeMoving,spikePlaceSparsityOnMazeMoving,spatialFiringRateCoherenceOnMazeMoving,spatialFieldsOnMazeMoving,firingAreaProportionOnMazeMoving,phaseInfoJointOnMazeMoving,phaseInfoConditionalOnMazeMoving,spikeRateMIjointOnMazeMoving,spikeRateMIconditionalOnMazeMoving,spikePlaceInfoPerSecondAllTrajectory,spikePlaceInfoPerSpikeAllTrajectory,spikePlaceSparsityAllTrajectory,spatialFiringRateCoherenceAllTrajectory,firingAreaProportionAllTrajectory,spatialFieldsAllTrajectory,phaseInfoJointAllTrajectory,phaseInfoConditionalAllTrajectory,spikeRateMIjointAllTrajectory,spikeRateMIconditionalAllTrajectory,spikePlaceInfoPerSecondSelectTrajectory,spikePlaceInfoPerSpikeSelectTrajectory,spikePlaceSparsitySelectTrajectory,spatialFiringRateCoherenceSelectTrajectory,firingAreaProportionSelectTrajectory,spatialFieldsSelectTrajectory,phaseInfoJointSelectTrajectory,phaseInfoConditionalSelectTrajectory,spikeRateMIjointSelectTrajectory,spikeRateMIconditionalSelectTrajectory,' 'phaseInfoConditionalNeg,phaseInfoConditionalAbs,spikeRateMIjointNeg,spikeRateMIjointAbs,spikeRateMIconditionalNeg,spikeRateMIconditionalAbs,totalSpikesAnalyzed,totalTimeAnalyzed,' 'phaseInfoConditionalNegBucket,phaseInfoConditionalAbsBucket,spikeRateMIjointNegBucket,spikeRateMIjointAbsBucket,spikeRateMIconditionalNegBucket,spikeRateMIconditionalAbsBucket,totalSpikesAnalyzedBucket,totalTimeAnalyzedBucket,phaseInfoConditionalNegOnMaze,phaseInfoConditionalAbsOnMaze,spikeRateMIjointNegOnMaze,spikeRateMIjointAbsOnMaze,spikeRateMIconditionalNegOnMaze,spikeRateMIconditionalAbsOnMaze,totalSpikesAnalyzedOnMaze,totalTimeAnalyzedOnMaze,phaseInfoConditionalNegOnMazeStill,phaseInfoConditionalAbsOnMazeStill,spikeRateMIjointNegOnMazeStill,spikeRateMIjointAbsOnMazeStill,spikeRateMIconditionalNegOnMazeStill,spikeRateMIconditionalAbsOnMazeStill,totalSpikesAnalyzedOnMazeStill,totalTimeAnalyzedOnMazeStill,phaseInfoConditionalNegOnMazeMoving,phaseInfoConditionalAbsOnMazeMoving,spikeRateMIjointNegOnMazeMoving,spikeRateMIjointAbsOnMazeMoving,spikeRateMIconditionalNegOnMazeMoving,spikeRateMIconditionalAbsOnMazeMoving,totalSpikesAnalyzedOnMazeMoving,totalTimeAnalyzedOnMazeMoving,phaseInfoConditionalNegAllTrajectory,phaseInfoConditionalAbsAllTrajectory,spikeRateMIjointNegAllTrajectory,spikeRateMIjointAbsAllTrajectory,spikeRateMIconditionalNegAllTrajectory,spikeRateMIconditionalAbsAllTrajectory,totalSpikesAnalyzedAllTrajectory,totalTimeAnalyzedAllTrajectory,phaseInfoConditionalNegSelectTrajectory,phaseInfoConditionalAbsSelectTrajectory,spikeRateMIjointNegSelectTrajectory,spikeRateMIjointAbsSelectTrajectory,spikeRateMIconditionalNegSelectTrajectory,spikeRateMIconditionalAbsSelectTrajectory,totalSpikesAnalyzedSelectTrajectory,totalTimeAnalyzedSelectTrajectory,spikePlaceInfoPerSpikeNegBucket,spikePlaceInfoPerSecondNegBucket,spikePlaceInfoPerSecondNegOnMaze,spikePlaceInfoPerSpikeNegOnMazeStill,spikePlaceInfoPerSecondNegOnMazeStill,spikePlaceInfoPerSpikeNegOnMazeMoving,spikePlaceInfoPerSecondNegOnMazeMoving,spikePlaceInfoPerSpikeNegAllTrajectory,spikePlaceInfoPerSecondNegAllTrajectory,spikePlaceInfoPerSpikeNegSelectTrajectory,spikePlaceInfoPerSecondNegSelectTrajectory,skaggsRatioAllTrajectory,spikePlaceInfoPerSpikePvalAllTrajectory,spikePlaceInfoPerSecondPvalAllTrajectory,spikePlaceSparsityPvalAllTrajectory,spatialFiringRateCoherencePvalAllTrajectory' ];
message = 'rat,date,tt,unit,totalSpikes,totalOnMaze,totalOffMaze,totalStill,totalMoving,totalOnMazeStill,totalOnMazeMoving,pctSpikesOnMaze,pctSpikesOffMaze,pctSpikesStill,pctSpikesMoving,pctSpikesOnMazeStill,pctSpikesOnMazeMoving,region,thetaIndex,totalOnMazeMovingFast,rateOverall,rateOnMaze,rateOffMaze,rateStill,rateMoving,rateOnMazeStill,rateOnMazeMoving,rateOnMazeMovingFast,phaseMaxBucket,phaseResultantBucket,phaseMaxOnMaze,phaseResultantOnMaze,phaseMaxOnMazeStill,phaseResultantOnMazeStill,phaseMaxOnMazeMoving,phaseResultantOnMazeMoving,phaseMaxAllTrajectories,phaseResultantAllTrajectories,phaseMaxSelectedTrajectories,phaseResultantSelectedTrajectories,spikePlaceInfoPerSecondBucket,spikePlaceInfoPerSpikeBucket,spikePlaceSparsityBucket,spatialFiringRateCoherenceBucket,spatialFieldsBucket,firingAreaProportionBucket,phaseInfoJointBucket,phaseInfoConditionalBucket,spikeRateMIjointBucket,spikeRateMIconditionalBucket,spikePlaceInfoPerSecondOnMaze,spikePlaceInfoPerSpikeOnMaze,spikePlaceSparsityOnMaze,spatialFiringRateCoherenceOnMaze,spatialFieldsOnMaze,firingAreaProportionOnMaze,phaseInfoJointOnMaze,phaseInfoConditionalOnMaze,spikeRateMIjointOnMaze,spikeRateMIconditionalOnMaze,spikePlaceInfoPerSecondOnMazeStill,spikePlaceInfoPerSpikeOnMazeStill,spikePlaceSparsityOnMazeStill,spatialFiringRateCoherenceOnMazeStill,spatialFieldsOnMazeStill,firingAreaProportionOnMazeStill,phaseInfoJointOnMazeStill,phaseInfoConditionalOnMazeStill,spikeRateMIjointOnMazeStill,spikeRateMIconditionalOnMazeStill,spikePlaceInfoPerSecondOnMazeMoving,spikePlaceInfoPerSpikeOnMazeMoving,spikePlaceSparsityOnMazeMoving,spatialFiringRateCoherenceOnMazeMoving,spatialFieldsOnMazeMoving,firingAreaProportionOnMazeMoving,phaseInfoJointOnMazeMoving,phaseInfoConditionalOnMazeMoving,spikeRateMIjointOnMazeMoving,spikeRateMIconditionalOnMazeMoving,skaggsRatioOnMazeMoving,spikePlaceInfoPerSpikePvalOnMazeMoving,spikePlaceInfoPerSecondPvalOnMazeMoving,spikePlaceSparsityPvalOnMazeMoving,spatialFiringRateCoherencePvalOnMazeMoving,spikePlaceInfoPerSecondAllTrajectory,spikePlaceInfoPerSpikeAllTrajectory,spikePlaceSparsityAllTrajectory,spatialFiringRateCoherenceAllTrajectory,firingAreaProportionAllTrajectory,spatialFieldsAllTrajectory,phaseInfoJointAllTrajectory,phaseInfoConditionalAllTrajectory,spikeRateMIjointAllTrajectory,spikeRateMIconditionalAllTrajectory,spikePlaceInfoPerSecondSelectTrajectory,spikePlaceInfoPerSpikeSelectTrajectory,spikePlaceSparsitySelectTrajectory,spatialFiringRateCoherenceSelectTrajectory,firingAreaProportionSelectTrajectory,spatialFieldsSelectTrajectory,phaseInfoJointSelectTrajectory,phaseInfoConditionalSelectTrajectory,spikeRateMIjointSelectTrajectory,spikeRateMIconditionalSelectTrajectory,totalSpikesAnalyzedSelectTrajectory,totalTimeAnalyzedSelectTrajectory,totalSpikesAnalyzedBucket,totalTimeAnalyzedBucket,totalSpikesAnalyzedOnMaze,totalTimeAnalyzedOnMaze,totalSpikesAnalyzedOnMazeStill,totalTimeAnalyzedOnMazeStill,totalSpikesAnalyzedOnMazeMoving,totalTimeAnalyzedOnMazeMoving,totalSpikesAnalyzedAllTrajectory,totalTimeAnalyzedAllTrajectory,totalSpikesAnalyzedSelectTrajectory,totalTimeAnalyzedSelectTrajectory,skaggsRatioAllTrajectory,spikePlaceInfoPerSpikePvalAllTrajectory,spikePlaceInfoPerSecondPvalAllTrajectory,spikePlaceSparsityPvalAllTrajectory,spatialFiringRateCoherencePvalAllTrajectory' ;
fprintf( fileID, '%s\n' , message);

for ratIdx =  1:length( rat )
    % 26     % h7 2018-07-27 LS 32  cell 1  (folder 14) has  a bang on
    % phase precession cell example
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData '/telemetry/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData '/telemetry/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            
            
            
            
            
            
            telTotalTime = length(telemetry.x)/29.97;

            selectedIdxs = (telemetry.onMaze > 0);
            telTotalOnMaze = sum(selectedIdxs)/29.97;
            selectedIdxs = (telemetry.onMaze < 0);
            telTotalOffMaze = sum(selectedIdxs)/29.97;

            selectedIdxs = (telemetry.speed < 10);
            telTotalStill = sum(selectedIdxs)/29.97;
            selectedIdxs = (telemetry.speed >= 10);
            telTotalMoving = sum(selectedIdxs)/29.97;

            selectedIdxs = (telemetry.onMaze > 0) & (telemetry.speed<10);
            telTotalOnMazeStill = sum(selectedIdxs)/29.97;
            selectedIdxs = (telemetry.onMaze > 0) & (telemetry.speed>=10);
            telTotalOnMazeMoving = sum(selectedIdxs)/29.97;
            
            selectedIdxs = (telemetry.onMaze > 0) & (telemetry.speed>20);
            telTotalOnMazeMovingFast = sum(selectedIdxs)/29.97;
            
            % 15 % for testing
            for ttNum = 1:32
                % BELOW FOR ALL TT
                %if exist( [ basePathData '/ttData/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' )
                %
                % BELOW FOR LS ONLY
                %if exist( [ basePathData '/ttData/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && ~isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'LS' ) )
                %
                % BELOW FOR CA ONLY
                %if exist( [ basePathData '/ttData/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && ~isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'CA' ) )
                %
                %BELOW FOR NOT LS OR CA
                if exist( [ basePathData  '/ttData/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'LS' ) ) && isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'CA' ) )
                    load( [ basePathData  '/ttData/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );                    
                    
                    for cellId = 1:max(spikeData.cellNumber)
                        
                        totalSpikes = sum(spikeData.cellNumber == cellId);
                        
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId);
                        totalOnMaze = sum(selectedSpikes);
                        selectedSpikes = (spikeData.onMaze < 0) & (spikeData.cellNumber == cellId);
                        totalOffMaze = sum(selectedSpikes);
                        
                        selectedSpikes = (spikeData.speed<10) & (spikeData.cellNumber == cellId);
                        totalStill = sum(selectedSpikes);                        
                        selectedSpikes = (spikeData.speed>=10) & (spikeData.cellNumber == cellId);
                        totalMoving = sum(selectedSpikes);
                        
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.speed<10) & (spikeData.cellNumber == cellId);
                        totalOnMazeStill = sum(selectedSpikes);
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.speed>=10) & (spikeData.cellNumber == cellId);
                        totalOnMazeMoving = sum(selectedSpikes);
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.speed>20) & (spikeData.cellNumber == cellId);
                        totalOnMazeMovingFast = sum(selectedSpikes);
                        
                        % "theta index"
                        %
                        % PMC6364943 ; see also classic Skaggs, McNaughton on phase precession
                        %
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.speed > 10) & (spikeData.cellNumber == cellId);
                        % this was previously WRONG. the bins were for 500
                        % seconds, not 500 milliseconds
                        [ xcorrValues, lagtimes] = acorrEventTimes( spikeData.timesSeconds(selectedSpikes),.10,.500);
                        if min( xcorrValues([ 27:36 65:74 ])) > 0
                            thetaIndex = 1 - (  min( xcorrValues([ 27:36 65:74 ]))  / max( xcorrValues([ 33:41 60:68 ])) );
                        else
                            thetaIndex = 0;
                        end
                        %
                        %
                        %                        
                        rateOverall = totalSpikes/telTotalTime;
                        
                        rateOnMaze = totalOnMaze/telTotalOnMaze;
                        rateOffMaze = totalOffMaze/telTotalOffMaze;
                        
                        rateStill = totalStill/telTotalStill;
                        rateMoving = totalMoving/telTotalMoving;
                        
                        rateOnMazeStill = totalOnMazeStill/telTotalOnMazeStill;
                        rateOnMazeMoving = totalOnMazeMoving/telTotalOnMazeMoving;
                        rateOnMazeMovingFast = totalOnMazeMovingFast/telTotalOnMazeMovingFast;
                        %
                        %
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.speed > 10) & (spikeData.cellNumber == cellId);
                        %
                        % construct an instantaneous firing rate estimate
                        % based on the number of spikes that occur within a
                        % window of a given time frame. This window is
                        % implemented as a boxcar in this code.
                        %
                        % changing the window from 1s to 500 ms to 250 ms 
                        % size revealed that 1s is slow to react and shifts
                        % the peak firing rate. 500 and 250 ms report
                        % essentially the same peak, but taking the average
                        % across all three smoothes out the kinks.
                        %
                        % I also tried convolving with a Gaussian kernel,
                        % but I don't like it as much. It always seems to
                        % underestimate the firing rate, over smooth or
                        % both.
                        % Gaussian Stuff : spkTrain = zeros(size(telemetry.x)); tempIdxs = floor(tempSpikeTimes*29.97)+1; for ii=1:length(tempIdxs); spkTrain(tempIdxs(ii)) = spkTrain(tempIdxs(ii)) + 1; end; spikeFiringRate = conv(spkTrain,gausswin(500,20), 'same'); figure; plot(gausswin(0,10)) figure; plot(gausswin(30, 2.5)); hold on; plot(gausswin(30, 1.5)); plot(gausswin(30, 0.5)); plot(gausswin(30, 5));
                        tempSpikeTimes = spikeData.timesSeconds(selectedSpikes);
                        spikeFiringRate = zeros(3,length(telemetry.x));
                        for ii=16:length(spikeFiringRate)-16
                            spikeFiringRate(1,ii) = sum( ( tempSpikeTimes > telemetry.xytimestampSeconds(ii-15) ) .* ( tempSpikeTimes < telemetry.xytimestampSeconds(ii+14) ) );
                            spikeFiringRate(2,ii) = sum( ( tempSpikeTimes > telemetry.xytimestampSeconds(ii-7) ) .* ( tempSpikeTimes < telemetry.xytimestampSeconds(ii+7) ) )*2;
                            spikeFiringRate(3,ii) = sum( ( tempSpikeTimes > telemetry.xytimestampSeconds(ii-3) ) .* ( tempSpikeTimes < telemetry.xytimestampSeconds(ii+3) ) )*4;
                        end
                        spikeFiringRate = mean(spikeFiringRate);
                        
                        % calculate phase resultant under various conditions
                        spikeData.thetaPhaseRads = spikeData.thetaPhase * pi/180;
                        %
                        % in bucket
                        selectedSpikes = (spikeData.onMaze < 0) & (spikeData.cellNumber == cellId);
                        % not using median because it spike Matlab's memory usage to 40 GB...
                        phaseMaxBucket = circ_mean(spikeData.thetaPhaseRads(selectedSpikes));
                        phaseResultantBucket = circ_r(spikeData.thetaPhaseRads(selectedSpikes));
                        % on Maze
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId);
                        % not using median because it spike Matlab's memory usage to 40 GB...
                        phaseMaxOnMaze = circ_mean(spikeData.thetaPhaseRads(selectedSpikes));
                        phaseResultantOnMaze = circ_r(spikeData.thetaPhaseRads(selectedSpikes));                        
                        % on Maze still {speed} < {threshold}
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId)  & (spikeData.speed<10) ;
                        % not using median because it spike Matlab's memory usage to 40 GB...
                        phaseMaxOnMazeStill = circ_mean(spikeData.thetaPhaseRads(selectedSpikes));
                        phaseResultantOnMazeStill = circ_r(spikeData.thetaPhaseRads(selectedSpikes));
                        % on Maze where {speed} > {threshold}
                        selectedSpikes = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId)  & (spikeData.speed>=10) ;
                        % not using median because it spike Matlab's memory usage to 40 GB...
                        phaseMaxOnMazeMoving = circ_mean(spikeData.thetaPhaseRads(selectedSpikes));
                        phaseResultantOnMazeMoving = circ_r(spikeData.thetaPhaseRads(selectedSpikes));
                        % on Maze in trajectory
                        % build masks
                        % build an index mask for the spike & telemetry data for specific trajectories we want to look at
                        %
                        % build spike mask for all runs
                        spikeMaskAllRuns = zeros(size(spikeData.x));
                        for ii=1:max(telemetry.runMaskAll)
                            % select telemetry idxs
                            whichTelIdxs=(telemetry.runMaskAll==ii);
                            % now grab the spikes
                            runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
                            runEndTime   = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));
                            % 
                            whichSpikeIdxs = (spikeData.cellNumber == cellId) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
                            spikeMaskAllRuns(whichSpikeIdxs) = ii;
                        end
                        %
                        spikeMaskSelectRuns = zeros(size(spikeData.x));
                        for ii=1:max(telemetry.runMaskSelected)
                            % select telemetry idxs
                            whichTelIdxs=(telemetry.runMaskSelected==ii);
                            % now grab the spikes
                            runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
                            runEndTime   = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));
                            % 
                            whichSpikeIdxs = (spikeData.cellNumber == cellId) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
                            spikeMaskSelectRuns(whichSpikeIdxs) = ii;
                        end      
                        %
                        % not using median because it spike Matlab's memory usage to 40 GB...
                        phaseMaxAllTrajectories = circ_mean(spikeData.thetaPhase(spikeMaskAllRuns>0));
                        phaseResultantAllTrajectories = circ_r(spikeData.thetaPhaseRads(spikeMaskAllRuns>0));
                        %
                        % not using median because it spike Matlab's memory usage to 40 GB...
                        phaseMaxSelectedTrajectories = circ_mean(spikeData.thetaPhase(spikeMaskSelectRuns>0));
                        phaseResultantSelectedTrajectories = circ_r(spikeData.thetaPhaseRads(spikeMaskSelectRuns>0));

                        
                        
                        % BUILD INPUTS TO INFORMATION METRICS

                        selectedTelIdxs = (telemetry.onMaze < 0);
                        selectedSpikeIdxs = (spikeData.onMaze < 0) & (spikeData.cellNumber == cellId);                        
                        output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate );
                        spikePlaceInfoPerSecondBucket     = output.spikePlaceInfoPerSecond;
                        spikePlaceInfoPerSpikeBucket      = output.spikePlaceInfoPerSpike;
                        spikePlaceSparsityBucket          = output.spikePlaceSparsity;
                        spatialFiringRateCoherenceBucket  = output.spatialFiringRateCoherence;
                        spatialFieldsBucket               = output.spatialFields;
                        firingAreaProportionBucket        = output.firingAreaProportion;
                        phaseInfoJointBucket              = output.phaseInfoJoint;
                        phaseInfoConditionalBucket        = output.phaseInfoConditional;
                        spikeRateMIjointBucket            = output.spikeRateMIjoint;
                        spikeRateMIconditionalBucket      = output.spikeRateMIconditional;
                        
                        totalSpikesAnalyzedBucket       = output.totalSpikesAnalyzed;
                        totalTimeAnalyzedBucket         = output.totalTimeAnalyzed;
                        
                        
                        selectedTelIdxs = (telemetry.onMaze > 0);
                        selectedSpikeIdxs = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId);                        
                        output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate );  
                        spikePlaceInfoPerSecondOnMaze     = output.spikePlaceInfoPerSecond;
                        spikePlaceInfoPerSpikeOnMaze      = output.spikePlaceInfoPerSpike;
                        spikePlaceSparsityOnMaze          = output.spikePlaceSparsity;
                        spatialFiringRateCoherenceOnMaze  = output.spatialFiringRateCoherence;
                        spatialFieldsOnMaze               = output.spatialFields;
                        firingAreaProportionOnMaze        = output.firingAreaProportion;
                        phaseInfoJointOnMaze              = output.phaseInfoJoint;
                        phaseInfoConditionalOnMaze        = output.phaseInfoConditional;
                        spikeRateMIjointOnMaze            = output.spikeRateMIjoint;
                        spikeRateMIconditionalOnMaze      = output.spikeRateMIconditional;

                        totalSpikesAnalyzedOnMaze       = output.totalSpikesAnalyzed;
                        totalTimeAnalyzedOnMaze         = output.totalTimeAnalyzed;


                        
                        selectedTelIdxs = (telemetry.onMaze > 0) & (telemetry.speed <= 10);
                        selectedSpikeIdxs = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId) & (spikeData.speed <= 10);                        
                        output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate );  
                        spikePlaceInfoPerSecondOnMazeStill     = output.spikePlaceInfoPerSecond;
                        spikePlaceInfoPerSpikeOnMazeStill      = output.spikePlaceInfoPerSpike;
                        spikePlaceSparsityOnMazeStill          = output.spikePlaceSparsity;
                        spatialFiringRateCoherenceOnMazeStill  = output.spatialFiringRateCoherence;
                        spatialFieldsOnMazeStill               = output.spatialFields;
                        firingAreaProportionOnMazeStill        = output.firingAreaProportion;
                        phaseInfoJointOnMazeStill              = output.phaseInfoJoint;
                        phaseInfoConditionalOnMazeStill        = output.phaseInfoConditional;
                        spikeRateMIjointOnMazeStill            = output.spikeRateMIjoint;
                        spikeRateMIconditionalOnMazeStill      = output.spikeRateMIconditional;

                        totalSpikesAnalyzedOnMazeStill       = output.totalSpikesAnalyzed;
                        totalTimeAnalyzedOnMazeStill         = output.totalTimeAnalyzed;

                        
                        
                        selectedTelIdxs = (telemetry.onMaze > 0) & (telemetry.speed > 10);
                        selectedSpikeIdxs = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId) & (spikeData.speed > 10);
                        output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate, 1000 );  
                        spikePlaceInfoPerSecondOnMazeMoving     = output.spikePlaceInfoPerSecond;
                        spikePlaceInfoPerSpikeOnMazeMoving      = output.spikePlaceInfoPerSpike;
                        spikePlaceSparsityOnMazeMoving          = output.spikePlaceSparsity;
                        spatialFiringRateCoherenceOnMazeMoving  = output.spatialFiringRateCoherence;
                        spatialFieldsOnMazeMoving               = output.spatialFields;
                        firingAreaProportionOnMazeMoving        = output.firingAreaProportion;
                        phaseInfoJointOnMazeMoving              = output.phaseInfoJoint;
                        phaseInfoConditionalOnMazeMoving        = output.phaseInfoConditional;
                        spikeRateMIjointOnMazeMoving            = output.spikeRateMIjoint;
                        spikeRateMIconditionalOnMazeMoving      = output.spikeRateMIconditional;

                        totalSpikesAnalyzedOnMazeMoving       = output.totalSpikesAnalyzed;
                        totalTimeAnalyzedOnMazeMoving         = output.totalTimeAnalyzed;


                        skaggsRatioOnMazeMoving = output.skaggsRatio;
                        spikePlaceInfoPerSpikePvalOnMazeMoving = output.spikePlaceInfoPerSpikePval; 
                        spikePlaceInfoPerSecondPvalOnMazeMoving = output.spikePlaceInfoPerSecondPval;
                        spikePlaceSparsityPvalOnMazeMoving = output.spikePlaceSparsityPval;
                        spatialFiringRateCoherencePvalOnMazeMoving = output.spatialFiringRateCoherencePval;



                        if ( totalSpikesAnalyzedOnMazeMoving > 200 ) && ( makeGraphs )
                                                    % Visualize
                            figure(2); clf;
                            try
                                sp=1;
                                ax(sp)=subplot(2,3,sp); hold off;
                                [ occupancy ] = twoDHistogram( telemetry.x( selectedTelIdxs), telemetry.y(selectedTelIdxs), binResolution, 300, 300, 150  );
                                occupancy(occupancy(:)==0)=NaN; occupancy=(occupancy./29.97); % convert to seconds
                                pcolor( ax(sp), occupancy ); colormap( ax(sp), 'jet' ); colorbar;
                                caxis( ax(sp), [ prctile(occupancy(find(occupancy)), 5) prctile(occupancy(find(occupancy)), 97) ] ); axis square;  shading flat; 
                                % shading interp; % looks cooler, but probably covers over some details?
                                title(['occupancy    total ' num2str(round(sum(selectedTelIdxs)/29.97)) ' s']);
                                ylabel('>= 10 cm/s')
                                try
                                 xlabel([ 'entropy pos. ' num2str(output.entropyPhase.occupancy) ])
                                catch; 
                                end;

                                sp = 2;
                                ax(sp)=subplot(2,3,sp);
                                scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs),'k', 'filled' ); alpha(.2); hold on;
                                scatter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), floor(spikeData.speed(selectedSpikeIdxs)/5)+1, circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:), 'filled'  ); 
                                %scatter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), (3*log2(spikeData.speed(selectedSpikeIdxs)))+1, circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:), 'filled'  ); 
                                if sum(selectedSpikeIdxs) > 8000; alpha(.2); elseif sum(selectedSpikeIdxs) > 4000; alpha(.4); elseif sum(selectedSpikeIdxs) > 2000; alpha(.6); elseif sum(selectedSpikeIdxs) > 1000; alpha(.8); end;
                                %if length(selectedSpikeIdxs) > 2000; aa=1-log2(length(selectedSpikeIdxs)); if aa>1; aa = .3; elseif aa<0; aa=0.3; end; alpha(aa); end
                                colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; axis([-150 150 -150 150]); shading flat;
                                title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} '  ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '  TT' num2str(ttNum) ' c' num2str(cellId)    ])
                                xlabel(['spike speed phase']);
                                ylabel([ 'n_{spikes} ' num2str(output.totalSpikesAnalyzed) ])

                                sp = 3;
                                ax(sp)=subplot(2,3,sp); hold off;
                                % == This version plots the firing rate map using the average firing rate population center, which is "pre-smoothed" ==
                                %
                                %[ avgRateMap, outputDev, outputFreq, hologram ]
                                [ avgRateMap ] = twoDPopulationCenter( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRate(selectedTelIdxs>0), binResolution, 300, 300, 150, false  );
                                pcolor(avgRateMap); shading flat; colorbar; colormap('jet');
                                title(['avg rate map_{MI style} | Skaggs.Ratio ' num2str(round(100*output.skaggsRatio)) '%'])
                                ylabel([ 'Skaggs sparsity ' num2str(output.spikePlaceSparsity) ' | p = ' num2str(output.spikePlaceSparsityPval) ]);
                                xlabel([ 'bits/spk ' num2str(output.spikePlaceInfoPerSpike) ' | p = ' num2str(output.spikePlaceInfoPerSpikePval) ]);

                                sp=4;
                                ax(sp)=subplot(2,3,sp); hold off;
                                expectViol=output.expViolPhaseJoint;
                                %for ii=1:size(expectViol,1); for jj=1:size(expectViol,2); ff=expectViol(ii,jj,:); infoMap(ii,jj)=nanmax(ff(~isnan(ff))); end; end;
                                infoMap = max(expectViol,[],3);
                                infoMap(infoMap==0)=NaN;
                                pcolor( infoMap ); colormap( 'jet' ); colorbar; axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
                                title(['avg.Exp.Val.Viol.Phase_{' num2str(round(100*sum( expectViol(:)>0 & ~isnan(expectViol(:)) ) / sum( ~isnan(expectViol(:)) & (expectViol(:)~=0) ) )  ) '% pos 3d elmnts}'])
                                xlabel([ 'MI_{phase} ' num2str(output.phaseInfoJoint) ' bits | p_{val} ' num2str(output.pValMIjointPhase) ] )
                                try
                                    ylabel([ 'entropy_{phase} ' num2str(output.entropyPhase.spikeMetric)])
                                catch;
                                end

                                sp=5;
                                ax(sp)=subplot(2,3,sp); hold off;
                                [ avgPhaseMap, outputDev, outputFreq, hologram, resultants ] = twoDPopulationCenter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), (spikeData.thetaPhaseRads(selectedSpikeIdxs)), binResolution, 300, 300, 150  );
                                avgPhaseMap = rad2deg( mod((avgPhaseMap-pi/4),2*pi) );
                                phaseBinConfidence = log(resultants .* (1-(max(outputFreq(:))-outputFreq)./max(outputFreq(:)))); %figure; histogram((phaseBinConfidence))
                                phaseBinConfidence = round(shadeLevels*(phaseBinConfidence-min(phaseBinConfidence(:)))./(max(phaseBinConfidence(:))-min(phaseBinConfidence(:))));
                                shadyAvgPhaseMap = avgPhaseMap + (360.*phaseBinConfidence);
                                pcolor( ax(sp), shadyAvgPhaseMap ); colormap( ax(sp), shadyCircularColorPlot ); colorbar; 
                                caxis( ax(sp), [0 length(shadyCircularColorPlot)] ); axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
                                title(['shady median phase map'])
                                ylabel([ 'pref.phase ' num2str(round(phaseMaxOnMazeMoving)) ' deg. | resultant ' num2str(phaseResultantOnMazeMoving) ]);
                                xlabel(['resultants_{cells} | min ' num2str(min(resultants(:))) ' | max ' num2str(max(resultants(:))) ])

                                sp=6;
                                ax(sp)=subplot(2,3,sp); hold off;
                                %for ii=1:61; for jj=1:61; ff=infoMat(ii,jj,:); infoMap(ii,jj)=nanmax(ff(~isnan(ff))); end; end;
                                expectViol=output.expViolRateJoint;
                                infoMap = max(expectViol,[],3);
                                %infoMap = nanmean(expectViol,3);
                                infoMap(infoMap==0)=NaN;
                                pcolor( infoMap ); colormap( 'jet' ); colorbar; axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
                                title(['avg.Exp.Val.Viol.Rate_{' num2str(round(100*sum( expectViol(:)>0 & ~isnan(expectViol(:)) ) / sum( ~isnan(expectViol(:)) & (expectViol(:)~=0) ) )  ) '% pos 3d elmnts}'])
                                xlabel([ 'MI_{rate} ' num2str(output.spikeRateMIjoint) ' bits | p_{val} ' num2str(output.pValMIjointRate ) ] );
                                ylabel([ 'entropy_{rate} ' num2str(output.entropyRate.spikeMetric) ]);

                                print( [ basePathOutput rat{ratIdx}  '_infoGraphics_allTrajectories_' folders.(rat{ratIdx}){ffIdx}  '_TT' num2str(ttNum) '_cluster_' num2str(cellId) '_.png'],'-dpng','-r200');
                            catch
                                 disp([ 'died on'  basePathOutput rat{ratIdx}  '_infoGraphics_allTrajectories_' folders.(rat{ratIdx}){ffIdx}  '_TT' num2str(ttNum) '_cluster_' num2str(cellId) ])
                            end

                        end


                        selectedTelIdxs = telemetry.runMaskAll>0;
                        selectedSpikeIdxs = spikeMaskAllRuns>0;
                        output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate );
                        spikePlaceInfoPerSecondAllTrajectory     = output.spikePlaceInfoPerSecond;
                        spikePlaceInfoPerSpikeAllTrajectory      = output.spikePlaceInfoPerSpike;
                        spikePlaceSparsityAllTrajectory          = output.spikePlaceSparsity;
                        spatialFiringRateCoherenceAllTrajectory  = output.spatialFiringRateCoherence;
                        firingAreaProportionAllTrajectory        = output.firingAreaProportion;
                        spatialFieldsAllTrajectory               = output.spatialFields;
                        phaseInfoJointAllTrajectory              = output.phaseInfoJoint;
                        phaseInfoConditionalAllTrajectory        = output.phaseInfoConditional;
                        spikeRateMIjointAllTrajectory            = output.spikeRateMIjoint;
                        spikeRateMIconditionalAllTrajectory      = output.spikeRateMIconditional;

                        totalSpikesAnalyzedAllTrajectory       = output.totalSpikesAnalyzed;
                        totalTimeAnalyzedAllTrajectory         = output.totalTimeAnalyzed;

                        skaggsRatioAllTrajectory = output.skaggsRatio;
                        spikePlaceInfoPerSpikePvalAllTrajectory = output.spikePlaceInfoPerSpikePval; 
                        spikePlaceInfoPerSecondPvalAllTrajectory = output.spikePlaceInfoPerSecondPval;
                        spikePlaceSparsityPvalAllTrajectory = output.spikePlaceSparsityPval;
                        spatialFiringRateCoherencePvalAllTrajectory = output.spatialFiringRateCoherencePval;

                        
                        
                        output = analyzeInformationContent( telemetry, spikeData, telemetry.runMaskSelected, spikeMaskSelectRuns, spikeFiringRate, 1000 );  
                        spikePlaceInfoPerSecondSelectTrajectory     = output.spikePlaceInfoPerSecond;
                        spikePlaceInfoPerSpikeSelectTrajectory      = output.spikePlaceInfoPerSpike;
                        spikePlaceSparsitySelectTrajectory          = output.spikePlaceSparsity;
                        spatialFiringRateCoherenceSelectTrajectory  = output.spatialFiringRateCoherence;
                        firingAreaProportionSelectTrajectory        = output.firingAreaProportion;
                        spatialFieldsSelectTrajectory               = output.spatialFields;
                        phaseInfoJointSelectTrajectory              = output.phaseInfoJoint;
                        phaseInfoConditionalSelectTrajectory        = output.phaseInfoConditional;
                        spikeRateMIjointSelectTrajectory            = output.spikeRateMIjoint;
                        spikeRateMIconditionalSelectTrajectory      = output.spikeRateMIconditional;

                        totalSpikesAnalyzedSelectTrajectory       = output.totalSpikesAnalyzed;
                        totalTimeAnalyzedSelectTrajectory	      = output.totalTimeAnalyzed;
   
                        
                        message = ([ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str( ttNum) ',' num2str( cellId) ',' num2str( totalSpikes) ',' num2str( totalOnMaze) ',' num2str( totalOffMaze) ',' num2str( totalStill) ',' num2str( totalMoving) ',' num2str( totalOnMazeStill) ',' num2str( totalOnMazeMoving) ',' num2str( round(100*totalOnMaze/totalSpikes))  '%' ',' num2str( round(100*totalOffMaze/totalSpikes))  '%' ',' num2str( round(100*totalStill/totalSpikes))  '%' ',' num2str( round(100*totalMoving/totalSpikes))  '%' ',' num2str( round(100*totalOnMazeStill/totalSpikes))  '%' ',' num2str( round(100*totalOnMazeMoving/totalSpikes)) '%'  ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ',' num2str( thetaIndex )  ',' num2str( totalOnMazeMovingFast )  ',' num2str( rateOverall )  ',' num2str( rateOnMaze )  ',' num2str( rateOffMaze )  ',' num2str( rateStill )  ',' num2str( rateMoving )  ',' num2str( rateOnMazeStill )  ',' num2str( rateOnMazeMoving )  ',' num2str( rateOnMazeMovingFast )  ',' num2str( phaseMaxBucket) ',' num2str( phaseResultantBucket) ',' num2str( phaseMaxOnMaze) ',' num2str( phaseResultantOnMaze) ',' num2str( phaseMaxOnMazeStill) ',' num2str( phaseResultantOnMazeStill) ',' num2str( phaseMaxOnMazeMoving) ',' num2str( phaseResultantOnMazeMoving) ',' num2str( phaseMaxAllTrajectories) ',' num2str( phaseResultantAllTrajectories) ',' num2str( phaseMaxSelectedTrajectories) ',' num2str( phaseResultantSelectedTrajectories)  ',' num2str( spikePlaceInfoPerSecondBucket) ',' num2str( spikePlaceInfoPerSpikeBucket) ',' num2str( spikePlaceSparsityBucket) ',' num2str( spatialFiringRateCoherenceBucket) ',' num2str( spatialFieldsBucket) ',' num2str( firingAreaProportionBucket) ',' num2str( phaseInfoJointBucket) ',' num2str( phaseInfoConditionalBucket) ',' num2str( spikeRateMIjointBucket) ',' num2str( spikeRateMIconditionalBucket) ',' num2str( spikePlaceInfoPerSecondOnMaze) ',' num2str( spikePlaceInfoPerSpikeOnMaze)  ',' num2str( spikePlaceSparsityOnMaze) ',' num2str( spatialFiringRateCoherenceOnMaze) ',' num2str( spatialFieldsOnMaze) ',' num2str( firingAreaProportionOnMaze) ',' num2str( phaseInfoJointOnMaze) ',' num2str( phaseInfoConditionalOnMaze) ',' num2str( spikeRateMIjointOnMaze) ',' num2str( spikeRateMIconditionalOnMaze) ',' num2str( spikePlaceInfoPerSecondOnMazeStill) ',' num2str( spikePlaceInfoPerSpikeOnMazeStill) ',' num2str( spikePlaceSparsityOnMazeStill) ',' num2str( spatialFiringRateCoherenceOnMazeStill) ',' num2str( spatialFieldsOnMazeStill) ',' num2str( firingAreaProportionOnMazeStill) ',' num2str( phaseInfoJointOnMazeStill) ',' num2str( phaseInfoConditionalOnMazeStill) ',' num2str( spikeRateMIjointOnMazeStill) ',' num2str( spikeRateMIconditionalOnMazeStill) ',' num2str( spikePlaceInfoPerSecondOnMazeMoving) ',' num2str( spikePlaceInfoPerSpikeOnMazeMoving)  ',' num2str( spikePlaceSparsityOnMazeMoving) ',' num2str( spatialFiringRateCoherenceOnMazeMoving) ',' num2str( spatialFieldsOnMazeMoving) ',' num2str( firingAreaProportionOnMazeMoving) ',' num2str( phaseInfoJointOnMazeMoving) ',' num2str( phaseInfoConditionalOnMazeMoving) ',' num2str( spikeRateMIjointOnMazeMoving) ',' num2str( spikeRateMIconditionalOnMazeMoving) ',' num2str( skaggsRatioOnMazeMoving) ',' num2str( spikePlaceInfoPerSpikePvalOnMazeMoving)  ',' num2str( spikePlaceInfoPerSecondPvalOnMazeMoving)  ',' num2str( spikePlaceSparsityPvalOnMazeMoving)  ',' num2str( spatialFiringRateCoherencePvalOnMazeMoving)   ',' num2str( spikePlaceInfoPerSecondAllTrajectory) ',' num2str( spikePlaceInfoPerSpikeAllTrajectory)  ',' num2str( spikePlaceSparsityAllTrajectory) ',' num2str( spatialFiringRateCoherenceAllTrajectory) ',' num2str( firingAreaProportionAllTrajectory) ',' num2str( spatialFieldsAllTrajectory) ',' num2str( phaseInfoJointAllTrajectory) ',' num2str( phaseInfoConditionalAllTrajectory) ',' num2str( spikeRateMIjointAllTrajectory) ',' num2str( spikeRateMIconditionalAllTrajectory) ',' num2str( spikePlaceInfoPerSecondSelectTrajectory) ',' num2str( spikePlaceInfoPerSpikeSelectTrajectory)  ',' num2str( spikePlaceSparsitySelectTrajectory) ',' num2str( spatialFiringRateCoherenceSelectTrajectory) ',' num2str( firingAreaProportionSelectTrajectory) ',' num2str( spatialFieldsSelectTrajectory) ',' num2str( phaseInfoJointSelectTrajectory) ',' num2str( phaseInfoConditionalSelectTrajectory) ',' num2str( spikeRateMIjointSelectTrajectory) ',' num2str( spikeRateMIconditionalSelectTrajectory) ',' num2str( output.totalSpikesAnalyzed ) ',' num2str( output.totalTimeAnalyzed ) ',' num2str( totalSpikesAnalyzedBucket) ',' num2str( totalTimeAnalyzedBucket) ',' num2str( totalSpikesAnalyzedOnMaze) ',' num2str( totalTimeAnalyzedOnMaze) ',' num2str( totalSpikesAnalyzedOnMazeStill) ',' num2str( totalTimeAnalyzedOnMazeStill) ',' num2str( totalSpikesAnalyzedOnMazeMoving) ',' num2str( totalTimeAnalyzedOnMazeMoving) ',' num2str( totalSpikesAnalyzedAllTrajectory) ',' num2str( totalTimeAnalyzedAllTrajectory) ',' num2str( totalSpikesAnalyzedSelectTrajectory) ',' num2str( totalTimeAnalyzedSelectTrajectory) ',' num2str( skaggsRatioAllTrajectory) ',' num2str( spikePlaceInfoPerSpikePvalAllTrajectory)  ',' num2str( spikePlaceInfoPerSecondPvalAllTrajectory)  ',' num2str( spikePlaceSparsityPvalAllTrajectory)  ',' num2str( spatialFiringRateCoherencePvalAllTrajectory)  ]);
                        disp([ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str( ttNum) ',' num2str( cellId)]);
                        fprintf( fileID, '%s\n' , message);
                    end
                end
            end
        end
    end
end

fclose(fileID);

return;

