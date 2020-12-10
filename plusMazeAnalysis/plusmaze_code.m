%% Process a whole day


rat = { 'da5' 'da10' 'h1' 'h5' 'h7' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC64.ncs' 'CSC44.ncs' };
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };

ratIdx = 5;
thisTheta = 1;
ffIdx = 26;  % good place cell example
%ffIdx = 8;  % good place cell example

buildTtPositionDatabase;

% **center trajectory
% placeRate_h7_CA1_2018-08-10_TT15_C5

% on arms -- interesting **
% placeRate_h7_CA1_2018-08-10_TT15_C10

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
baseOutputPath='~/data/phaseTest/'

% LOAD TELEMETRY DATA
load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );
load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx}  '_telemetry.mat' ], '-mat');

% BUILD SOME DATA STRUCTURES
speedOnMaze=telemetry.speed.*(telemetry.onMaze>0);
circColor=buildCircularGradient(360);

% THIS IS A BIG SECTION
% HERE WE ARE GOING TO USE THE SPEED SIGNAL WHILE THE ANIMAL IS ON THE MAZE
% TO LOCATE PERIODS WHEN HE IS ENGAGING IN A MOVEMENT. this requires some
% peak finding, then descent down the peaks to the end of the movement,
% then clean up so that episodes do not overlap. There is checking to see
% if the peak occurs at the very start of the maze trial, as the rat can
% pop out of the bucket at speed and then stop. Later, some clean up occurs
% to eliminate movement episodes where the rat isn't moving vert long or
% doesn't move far enough away from his origin.

signalEnvelope = telemetry.speed.*(telemetry.onMaze>0);
signalTimes = telemetry.xytimestampSeconds;
signalSampleRate = 29.97;
[ EpisodePeakValues, EpisodePeakTimes] = findpeaks(  signalEnvelope, ...
                                        signalTimes,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    22, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  3  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
                                    
%streakThreshold = round(signalSampleRate);
streakThreshold = 5;  % temporal threshold; how many samples must be under sequentially to count as end of peak?
extentThreshold = 10; % signal threshold; value signal should exceed to count as part of peak feature

% == DETECT START AND END OF AN EPISODE OF CRUNCHING ==
%
% given the locations of the peaks of the Crunch episodes, find the extents
% of the episodes
%
% starting at the peak, ride the signal envelope until it stays below a
% threshold for a while (rather heuristic)
%
%
EpisodeStartIdxs = ones( 1, length( EpisodePeakTimes ) );
EpisodeEndIdxs = ones( 1, length( EpisodePeakTimes ) );% * length(signalEnvelope);
%
% TODO use while instead of some arbitrary cut off
%
for jj=1:length(EpisodePeakTimes)
    % find the nearest index
    [vv envIdx]=min(abs(signalTimes-EpisodePeakTimes(jj)));
    envIdx = envIdx(1); % we only need one. (could cause bugs if repeat values)
    EpisodeStartIdxs(jj) = 0;
    minValStreak = 0;
    %pctThreshold = EpisodePeakValues(jj)*.05;
    for ii=1:length(signalEnvelope)
        % handles cases where there is a peak as the rat runs out of the
        % bucket
        if (envIdx-10 > 0) && ( signalEnvelope(envIdx-10) < 1)
            EpisodeStartIdxs(jj)=envIdx-1;
            break;
        end
        if envIdx-ii < 1
            break;
        end
        if signalEnvelope(envIdx-ii) < extentThreshold % pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if EpisodeStartIdxs(jj) == 1
                EpisodeStartIdxs(jj) = envIdx - ii;
            end
        elseif minValStreak > streakThreshold  % TODO should really be a proportion of sample rate
            break;
        elseif EpisodeStartIdxs(jj) ~= 1
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            EpisodeStartIdxs(jj) = 1;
            minValStreak = 0;
        end
    end
    %
    % now go up
    %EpisodeEndIdxs(ii) = 0;
    minValStreak = 0;
    %pctThreshold = EpisodePeakValues(jj)*.05;
    for ii=1:length(signalEnvelope)
        % handles cases where there is a peak as the rat runs into the
        % bucket
        if (envIdx+10 < length(signalEnvelope)) && ( signalEnvelope(envIdx+10) < 1)
            EpisodeEndIdxs(jj)=envIdx+1;
            break;
        end
        if envIdx+ii > length(signalEnvelope)
            break;
        end
        if signalEnvelope(envIdx+ii) < extentThreshold % pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if  EpisodeEndIdxs(jj) == 1
                 EpisodeEndIdxs(jj) = envIdx + ii;
            end
        elseif minValStreak > streakThreshold  % TODO should really be a proportion of sample rate
            break;
        elseif  EpisodeEndIdxs(jj) ~= 1
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            EpisodeEndIdxs(jj) = 1;
            minValStreak = 0;
        end
    end 
    %
end


EpisodeStartIdxs(EpisodeStartIdxs<1)=1;

% NOW REMOVE DUPLICATE PEAKS THAT FALL INSIDE THE EXTENTS
% it is possible that this might break some other things that remove SWR
% interference
idxToRemove = [];
if length(EpisodePeakTimes) > 3
    for ii=2:length(EpisodePeakTimes)
        %disp( [ num2str(EpisodeStartIdxs(ii-1))  '  '  num2str(EpisodeEndIdxs(ii-1))])
        if (ii-1 > 0) && ( EpisodePeakTimes(ii) > signalTimes(EpisodeStartIdxs(ii-1)) ) && ( EpisodePeakTimes(ii) < signalTimes(EpisodeEndIdxs(ii-1)) )
            idxToRemove = [ idxToRemove ii ];
        end
    end
end
EpisodePeakValues(idxToRemove)=[];
EpisodePeakTimes(idxToRemove)=[];
EpisodeStartIdxs(idxToRemove)=[];
EpisodeEndIdxs(idxToRemove)=[];

% BUILD A RUN MASK TO EXTRACT RUNS FROM DATA
runMaskAll = zeros(size(telemetry.x));
for ii=1:length(EpisodeStartIdxs)
    runMaskAll(EpisodeStartIdxs(ii):EpisodeEndIdxs(ii)) = ii;
end

% ELIMINATE EPISODES THAT ARE TOO SHORT, OR DON'T RESULT IN A LONG ENOUGH
% TRAJECTORY
%
idxToRemove = [];
correctionFactor=0;  % every time we remove an episode, we need to walk the number back for all the subsequent episodes
temporalThreshold = 1.5; % seconds ; how long should the minimum episode be?
spatialOffsetThresold = 50; % cm ; how far should the rat move between start and finish?
% warning -- spatialOffsetThresold might reject some runs that last a long
% time, move a far distance, but start and end in roughly the same place
distDurations = zeros(1,max(runMaskAll));
distDisplacement = zeros(1,max(runMaskAll));
distDistTraveled = zeros(1,max(runMaskAll));
runMaskSelected = runMaskAll;
for ii=1:max( runMaskAll )
    whichTelIdxs = ( runMaskAll == ii );
    
    distDurations(ii) = sum(whichTelIdxs)/29.97;
    distDisplacement(ii) = sqrt( (telemetry.x(find(whichTelIdxs,1,'last'))-telemetry.x(find(whichTelIdxs,1,'first')))^2 + (telemetry.y(find(whichTelIdxs,1,'last'))-telemetry.y(find(whichTelIdxs,1,'first')))^2 ) ;
    distDistTraveled(ii) = sum(telemetry.speed(whichTelIdxs)/29.97);
    
    if (sum(whichTelIdxs)/29.97) < (temporalThreshold)
        runMaskSelected(find(whichTelIdxs)) = 0;
        correctionFactor = correctionFactor + 1;
    elseif ( spatialOffsetThresold > sqrt( (telemetry.x(find(whichTelIdxs,1,'last'))-telemetry.x(find(whichTelIdxs,1,'first')))^2 + (telemetry.y(find(whichTelIdxs,1,'last'))-telemetry.y(find(whichTelIdxs,1,'first')))^2 ) )
        runMaskSelected(find(whichTelIdxs)) = 0;
        correctionFactor = correctionFactor + 1;
    else
        runMaskSelected(find(whichTelIdxs)) = ii-correctionFactor;
    end
end
disp( [ 'REMOVED ' num2str(correctionFactor) ' of ' num2str(ii) ' movement episode trajectories (' num2str(round(100*correctionFactor/ii)) '%) due to short duration or low offset' ] )


% % visualize some metrics of the trajectories
% figure; 
% subplot(1,3,1); histogram(distDurations, 0:max(distDurations) ); legend('durations');
% subplot(1,3,2); histogram(distDisplacement,0:5:max(distDisplacement)); legend('displacement (cm)');
% subplot(1,3,3); histogram(distDistTraveled,0:10:max(distDistTraveled)); legend('travel (cm)');
% %
% figure; scatter3( distDurations, distDisplacement, distDistTraveled )
% % it looks like there are is some bimodality.
% 
% figure;
% subplot(1,2,1);
% scatter(telemetry.x(telemetry.onMaze>0),telemetry.y(telemetry.onMaze>0),10,'k','filled'); hold on;
% for ii = 1:max(runMask); plot(telemetry.x(runMask==ii),telemetry.y(runMask==ii));
% scatter(telemetry.x(find(runMask==ii,1,'first')),telemetry.y(find(runMask==ii,1,'first')), 'o', 'g');
% scatter(telemetry.x(find(runMask==ii,1,'last')),telemetry.y(find(runMask==ii,1,'last')), 'x', 'r');
% end;
% axis([ -150 150 -150 150]); axis square;
% subplot(1,2,2);
% scatter(telemetry.x(telemetry.onMaze>0),telemetry.y(telemetry.onMaze>0),10,'k','filled'); hold on;
% for ii = 1:max(runMaskSelected); plot(telemetry.x(runMaskSelected==ii),telemetry.y(runMaskSelected==ii));
%         scatter(telemetry.x(find(runMaskSelected==ii,1,'first')),telemetry.y(find(runMaskSelected==ii,1,'first')), 'o', 'g');
%         scatter(telemetry.x(find(runMaskSelected==ii,1,'last')),telemetry.y(find(runMaskSelected==ii,1,'last')), 'x', 'r');
% end;
% axis([ -150 150 -150 150]); axis square;
% I suspect that this bimodality arises from the times when the rat runs
% into the bucket at the end. For now, I've just put in a cutoff at >50 cm
% displacement, but I'm probably going to have to implement something more
% sophisticated that throws out trajectories at the very end of the episode
% TODO



%
% NOW WE HAVE OUR TRAJECTORIES
% 


dateStr = folders.(rat{ratIdx}){ffIdx};

for whatTT = 15 % 25:32
    ttNum=whatTT;
    if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' )

        disp( [ 'AVAILABLE : ' basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'])

        load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );

        for cellId =   1:max(spikeData.cellNumber)

                % build an index mask for the spike & telemetry data for specific trajectories we want to look at
                telemetryMask = zeros(size(telemetry.x));
                telemetryMaskNS = zeros(size(telemetry.x));
                telemetryMaskSelected = zeros(size(telemetry.x));
                spikeMaskSelected = zeros(size(spikeData.x));
                
                spikeMaskNS = zeros(size(spikeData.x));
                totalRunsSelected = 0;
                for ii=1:max(runMaskSelected)
                    % select telemetry idxs
                    whichTelIdxs=(runMaskSelected==ii);
                    % for today, if he's starting  somewhere in the start region and he
                    % ends up North

                    % now grab the spikes
                    runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
                    runEndTime   = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));
                    % 
                    whichSpikeIdxs = (spikeData.cellNumber == cellId) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
                    spikeMaskSelected(whichSpikeIdxs) = ii;
                    telemetryMaskSelected(whichTelIdxs) = ii;
                    % this says "select all runs that start in the start position and end
                    % either on the north or south arm"
                    %
                    % it is NOT transferable between days yet.
                    if telemetry.x(find(whichTelIdxs,1,'first')) > 30 && ( telemetry.y(find(whichTelIdxs,1,'last')) > 30 )
                        telemetryMask(whichTelIdxs) = 1;
                        spikeMaskSelected(whichSpikeIdxs) = 1;
                        totalRunsSelected = totalRunsSelected + 1;
                    elseif telemetry.x(find(whichTelIdxs,1,'first')) > 30 && ( telemetry.y(find(whichTelIdxs,1,'last')) > -30 )
                        telemetryMask(whichTelIdxs) = 3;
                        spikeMaskSelected(whichSpikeIdxs) = 3;
                        totalRunsSelected = totalRunsSelected + 1;
                    end

                    if ( telemetry.y(find(whichTelIdxs,1,'last')) > 30 )
                        spikeMaskNS(whichSpikeIdxs) = 1;
                        telemetryMaskNS(whichTelIdxs) = 1;
                    elseif ( telemetry.y(find(whichTelIdxs,1,'last')) > -30 )
                        spikeMaskNS(whichSpikeIdxs) = 3;
                        telemetryMaskNS(whichTelIdxs) = 3;
                    elseif ( telemetry.x(find(whichTelIdxs,1,'last')) > -30 )
                        spikeMaskNS(whichSpikeIdxs) = 4;
                        telemetryMaskNS(whichTelIdxs) = 4;
                    elseif ( telemetry.x(find(whichTelIdxs,1,'last')) > 30 )
                        spikeMaskNS(whichSpikeIdxs) = 2;
                        telemetryMaskNS(whichTelIdxs) = 2;

                    end
                end
                disp( [ num2str(totalRunsSelected) ' runs start to end of ' num2str(max(runMaskSelected)) ' runs, in ' num2str(max(telemetry.trial)) ' total trials' ] )
                
                % build spike mask for all runs
                telemetryMaskAllRuns = zeros(size(telemetry.x));
                spikeMaskAllRuns = zeros(size(spikeData.x));
                for ii=1:max(runMaskAll)
                    % select telemetry idxs
                    whichTelIdxs=(runMaskAll==ii);
                    % now grab the spikes
                    runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
                    runEndTime   = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));
                    % 
                    whichSpikeIdxs = (spikeData.cellNumber == cellId) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
                    spikeMaskAllRuns(whichSpikeIdxs) = ii;
                end




                gcf(1)=figure(1);

                speedThreshold = 10;

                ax(1)=subplot(2,4,1);
                binResolution = 5;
                selectedIdxs = telemetry.onMaze>0; % & telemetry.speed<=speedThreshold 
                hold off; [ occupancy ] = twoDHistogram( telemetry.x(selectedIdxs), telemetry.y(selectedIdxs), binResolution, 300, 300, 150  );
                occupancy(occupancy(:)==0)=NaN;
                pcolor( ax(1), occupancy ); colormap( ax(1), 'jet' ); colorbar;
                caxis( ax(1), [ prctile(occupancy(find(occupancy)), 5) prctile(occupancy(find(occupancy)), 97) ] ); axis square;  shading flat; 
                % shading interp; % looks cooler, but probably covers over some details?
                title(['occupancy_{all}']);
                

                ax(4)=subplot(2,4,5);
                % PHASE BY PLACE 
                % this is like building the place maps by building a 2D histogram, but
                % instead of simply accumulating how many spikes ocurred in each spatial
                % bin, we are building a distribution of all the phases that the spike
                % occurred on and then taking a circular measure of central tendency
                binResolution = 5;
                selectedIdxs = (spikeData.cellNumber == cellId)  & (spikeData.onMaze>0); %& (spikeData.speed<=speedThreshold)
                [ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(selectedIdxs), spikeData.y(selectedIdxs), deg2rad(spikeData.thetaPhase(selectedIdxs)-180), binResolution, 300, 300, 150  );
                output = rad2deg( output )+180;
                pcolor( ax(4), output ); colormap( ax(4), circColor ); colorbar; caxis( ax(4), [0 360] ); shading flat; % NO shading interp; % interp does weird things to circular maps
                axis square; shading flat;
                title(['spike phase_{all}'])
                
                
                ax(2)=subplot(2,4,2);
                binResolution = 5;
                selectedIdxs = (telemetry.speed>speedThreshold) & (telemetry.onMaze>0);
                hold off; [ occupancy ] = twoDHistogram( telemetry.x( selectedIdxs), telemetry.y(selectedIdxs), binResolution, 300, 300, 150  );
                occupancy(occupancy(:)==0)=NaN;
                pcolor( ax(2), occupancy ); colormap( ax(2), 'jet' ); colorbar;
                caxis( ax(2), [ prctile(occupancy(find(occupancy)), 5) prctile(occupancy(find(occupancy)), 97) ] ); axis square;  shading flat; 
                % shading interp; % looks cooler, but probably covers over some details?
                title(['occupancy_{>' num2str(speedThreshold) 'cm/s}']);
                

                ax(5)=subplot(2,4,6);
                % PHASE BY PLACE 
                % this is like building the place maps by building a 2D histogram, but
                % instead of simply accumulating how many spikes ocurred in each spatial
                % bin, we are building a distribution of all the phases that the spike
                % occurred on and then taking a circular measure of central tendency
                binResolution = 5;
                selectedIdxs = (spikeData.cellNumber == cellId) & (spikeData.speed>speedThreshold) & (spikeData.onMaze>0);
                [ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(selectedIdxs), spikeData.y(selectedIdxs), deg2rad(spikeData.thetaPhase(selectedIdxs)-180), binResolution, 300, 300, 150  );
                output = rad2deg( output )+180;
                pcolor( ax(5), output ); colormap( ax(5), circColor ); colorbar; caxis( ax(5), [0 360] ); shading flat; % NO shading interp; % interp does weird things to circular maps
                axis square; shading flat;
                title(['spike phase_{>' num2str(speedThreshold) 'cm/s}'])
                

                ax(3)=subplot(2,4,3);
                binResolution = 5;
                hold off; [ occupancy ] = twoDHistogram( telemetry.x(runMaskAll>0), telemetry.y(runMaskAll>0), binResolution, 300, 300, 150  );
                occupancy(occupancy(:)==0)=NaN;
                pcolor( ax(3), occupancy ); colormap( ax(3), 'jet' ); colorbar;
                caxis( ax(3), [ prctile(occupancy(find(occupancy)), 5) prctile(occupancy(find(occupancy)), 97) ] ); axis square;
                title('occupancy_{all trajectory}');  shading flat;


                ax(6)=subplot(2,4,7);
                % PHASE BY PLACE 
                % this is like building the place maps by building a 2D histogram, but
                % instead of simply accumulating how many spikes ocurred in each spatial
                % bin, we are building a distribution of all the phases that the spike
                % occurred on and then taking a circular measure of central tendency
                binResolution = 5;
                [ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(spikeMaskAllRuns>0), spikeData.y(spikeMaskAllRuns>0), deg2rad(spikeData.thetaPhase(spikeMaskAllRuns>0)-180), binResolution, 300, 300, 150  );
                output = rad2deg( output )+180;
                pcolor( ax(6), output ); colormap( ax(6), circColor ); colorbar; caxis( ax(6), [0 360] );
                title('spike phase_{all trajectory}'); axis square; shading flat;

  
                ax(3)=subplot(2,4,4);
                binResolution = 5;
                hold off; [ occupancy ] = twoDHistogram( telemetry.x(runMaskSelected>0), telemetry.y(runMaskSelected>0), binResolution, 300, 300, 150  );
                occupancy(occupancy(:)==0)=NaN;
                pcolor( ax(3), occupancy ); colormap( ax(3), 'jet' ); colorbar;
                caxis( ax(3), [ prctile(occupancy(find(occupancy)), 5) prctile(occupancy(find(occupancy)), 97) ] ); axis square;
                title('occupancy_{long trajectory}');  shading flat;


                ax(6)=subplot(2,4,8);
                % PHASE BY PLACE 
                % this is like building the place maps by building a 2D histogram, but
                % instead of simply accumulating how many spikes ocurred in each spatial
                % bin, we are building a distribution of all the phases that the spike
                % occurred on and then taking a circular measure of central tendency
                binResolution = 5;
                [ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(spikeMaskSelected>0), spikeData.y(spikeMaskSelected>0), deg2rad(spikeData.thetaPhase(spikeMaskSelected>0)-180), binResolution, 300, 300, 150  );
                output = rad2deg( output )+180;
                pcolor( ax(6), output ); colormap( ax(6), circColor ); colorbar; caxis( ax(6), [0 360] );
                title('spike phase_{long trajectory}'); axis square; shading flat;

                
                
                

                % VISUALIZE THE LOCATION OF THE SPIKES, THE SPEED AT THE SPIKE TIME AND THE
                % PHASE
                ax(3)=subplot(3,4,[ 3 4 7 8 ]);
                hold off;
                scatter( ax(3), telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
                scatter( ax(3), telemetry.x(telemetryMask>0), telemetry.y(telemetryMask>0), 10, 'k', 'fillled' );
                scatter( ax(3), spikeData.x(spikeMaskSelected>0), spikeData.y(spikeMaskSelected>0), spikeData.speed(spikeMaskSelected>0)/5, circColor(floor(spikeData.thetaPhase(spikeMaskSelected>0))+1,:), 'filled'  );
                alpha(.8);
                colormap( ax(3), circColor); colorbar; caxis( ax(3), [0 360]); axis( ax(3), [ -150 150 -150 150 ]); axis square;
                title([ 'phase_{allRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId) ]);


                % VISUALIZE THE LOCATION OF THE SPIKES, THE SPEED AT THE SPIKE TIME AND THE
                % PHASE
                ax(3)=subplot(3,4,[ 1 2 5 6 ]);
                hold off;
                scatter( ax(3), telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
                scatter( ax(3), telemetry.x(runMaskAll>0), telemetry.y(runMaskAll>0), 10, 'k', 'fillled' );
                scatter( ax(3), spikeData.x(spikeMaskAllRuns>0), spikeData.y(spikeMaskAllRuns>0), spikeData.speed(spikeMaskAllRuns>0)/5, circColor(floor(spikeData.thetaPhase(spikeMaskAllRuns>0))+1,:), 'filled'  );
                alpha(.8);
                colormap( ax(3), circColor); colorbar; caxis( ax(3), [0 360]); axis( ax(3), [ -150 150 -150 150 ]); axis square;
                title([ 'phase_{longRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId) ]);

                print( gcf(1), [ baseOutputPath rat{ratIdx} '_phaseMap_' folders.(rat{ratIdx}){ffIdx} '_' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}   '_TT' int2str(ttNum) '_C' num2str(cellId) '_.png'],'-dpng','-r200');



                gcf(2)=figure(2);

                % VISUALIZE THE LOCATION OF THE SPIKES, THE SPEED AT THE SPIKE TIME AND THE
                % PHASE
                ax(3)=subplot(2,4,[ 3 4 7 8 ]);
                hold off;
                scatter( ax(3), telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
                scatter( ax(3), telemetry.x(telemetryMaskNS==1), telemetry.y(telemetryMaskNS==1), 10, 'k', 'fillled' );
                scatter( ax(3), spikeData.x(spikeMaskNS==1), spikeData.y(spikeMaskNS==1), spikeData.speed(spikeMaskNS==1)/5, circColor(floor(spikeData.thetaPhase(spikeMaskNS==1))+1,:), 'filled'  );
                alpha(.8);
                colormap( ax(3), circColor); colorbar; caxis( ax(3), [0 360]); axis( ax(3), [ -150 150 -150 150 ]); axis square;
                title([ 'phase_{northRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId)  ]);

                % VISUALIZE THE LOCATION OF THE SPIKES, THE SPEED AT THE SPIKE TIME AND THE
                % PHASE
                ax(3)=subplot(2,4,[ 1 2 5 6 ]);
                hold off;
                scatter( ax(3), telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
                scatter( ax(3), telemetry.x(telemetryMaskNS==3), telemetry.y(telemetryMaskNS==3), 10, 'k', 'fillled' );
                scatter( ax(3), spikeData.x(spikeMaskNS==3), spikeData.y(spikeMaskNS==3), spikeData.speed(spikeMaskNS==3)/5, circColor(floor(spikeData.thetaPhase(spikeMaskNS==3))+1,:), 'filled'  );
                alpha(.8);
                colormap( ax(3), circColor); colorbar; caxis( ax(3), [0 360]); axis( ax(3), [ -150 150 -150 150 ]); axis square;
                title(['phase_{southRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId)  ]);

                print( gcf(2), [ baseOutputPath rat{ratIdx} '_phaseMapNS_' folders.(rat{ratIdx}){ffIdx}  '_' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '_TT' int2str(ttNum) '_C' num2str(cellId)  '_.png'],'-dpng','-r200');

                %
                gcf(3)=figure(4);
                subplot(2,2,1);
                cx=-55; cy=55;
                anglizedPosition = atan2(spikeData.x(spikeMaskNS==4)-cx, spikeData.y(spikeMaskNS==4)-cy);
                scatter( [anglizedPosition; anglizedPosition; anglizedPosition+2*pi; anglizedPosition+2*pi], [spikeData.thetaPhase(spikeMaskNS==4); spikeData.thetaPhase(spikeMaskNS==4)+360; spikeData.thetaPhase(spikeMaskNS==4); spikeData.thetaPhase(spikeMaskNS==4)+360], [ spikeData.speed(spikeMaskNS==4)/5; spikeData.speed(spikeMaskNS==4)/5; spikeData.speed(spikeMaskNS==4)/5; spikeData.speed(spikeMaskNS==4)/5 ], circColor([ floor(spikeData.thetaPhase(spikeMaskNS==4))+1; floor(spikeData.thetaPhase(spikeMaskNS==4))+1; floor(spikeData.thetaPhase(spikeMaskNS==4))+1; floor(spikeData.thetaPhase(spikeMaskNS==4))+1 ] ,:), 'o', 'filled' );
                alpha(.8);
                colormap(circColor); colorbar; caxis( [0 360]); axis([ -pi 3*pi 0 720 ]); axis square;
                title(['phase_{westRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId)  ]);
                xlabel('linearized position (radians)'); ylabel('firing phase');

                subplot(2,2,2);
                cx=55; cy=55;
                anglizedPosition = atan2(spikeData.x(spikeMaskNS==1)-cx, spikeData.y(spikeMaskNS==1)-cy);
                scatter( [anglizedPosition; anglizedPosition; anglizedPosition+2*pi; anglizedPosition+2*pi], [spikeData.thetaPhase(spikeMaskNS==1); spikeData.thetaPhase(spikeMaskNS==1)+360; spikeData.thetaPhase(spikeMaskNS==1); spikeData.thetaPhase(spikeMaskNS==1)+360], [ spikeData.speed(spikeMaskNS==1)/5; spikeData.speed(spikeMaskNS==1)/5; spikeData.speed(spikeMaskNS==1)/5; spikeData.speed(spikeMaskNS==1)/5 ], circColor([ floor(spikeData.thetaPhase(spikeMaskNS==1))+1; floor(spikeData.thetaPhase(spikeMaskNS==1))+1; floor(spikeData.thetaPhase(spikeMaskNS==1))+1; floor(spikeData.thetaPhase(spikeMaskNS==1))+1 ] ,:), 'o', 'filled' );
                alpha(.8);
                colormap(circColor); colorbar; caxis( [0 360]); axis([ -pi 3*pi 0 720 ]); axis square;
                title(['phase_{northRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId)  ]);
                xlabel('linearized position (radians)'); ylabel('firing phase');

                subplot(2,2,3);
                cx=55; cy=55;
                anglizedPosition = atan2(spikeData.x(spikeMaskNS==2)-cx, spikeData.y(spikeMaskNS==2)-cy);
                scatter( [anglizedPosition; anglizedPosition; anglizedPosition+2*pi; anglizedPosition+2*pi], [spikeData.thetaPhase(spikeMaskNS==2); spikeData.thetaPhase(spikeMaskNS==2)+360; spikeData.thetaPhase(spikeMaskNS==2); spikeData.thetaPhase(spikeMaskNS==2)+360], [ spikeData.speed(spikeMaskNS==2)/5; spikeData.speed(spikeMaskNS==2)/5; spikeData.speed(spikeMaskNS==2)/5; spikeData.speed(spikeMaskNS==2)/5 ], circColor([ floor(spikeData.thetaPhase(spikeMaskNS==2))+1; floor(spikeData.thetaPhase(spikeMaskNS==2))+1; floor(spikeData.thetaPhase(spikeMaskNS==2))+1; floor(spikeData.thetaPhase(spikeMaskNS==2))+1 ] ,:), 'o', 'filled' );
                alpha(.8);
                colormap(circColor); colorbar; caxis( [0 360]); axis([ -pi 3*pi 0 720 ]); axis square;
                title(['phase_{eastRuns} ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  ' TT' int2str(ttNum) ' C' num2str(cellId)  ]);
                xlabel('linearized position (radians)'); ylabel('firing phase');
                
                
                print( gcf(3), [ baseOutputPath rat{ratIdx} '_phaseMapNLinearized_' folders.(rat{ratIdx}){ffIdx}  '_' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '_TT' int2str(ttNum) '_C' num2str(cellId)  '_.png'],'-dpng','-r200');
        end
    end
end




return;




%% Markov Model approach to finding trajectories
% tile space, assign each position while on the maze to a 2D bin,
% linearized as rowXcol 
% then build transition matrix to visualize network of trajectories
% I don't know if there is a way to add time to this, like as in run from
% start to end, and then to bucket would look somewhat differently
% connected in time than ignorant of time

binResolution = 5;
maxXBin = (300/binResolution)+1;
% shift to positive quadrant, then convert to bin index

xBin(runMaskAll>0) = floor((telemetry.x(runMaskAll>0)+150)/binResolution)+1;
yBin(runMaskAll>0) = floor((telemetry.y(runMaskAll>0)+150)/binResolution)+1;

xBin(runMaskAll>0) = floor((telemetry.x(runMaskAll>0)+150)/binResolution)+1;
yBin(runMaskAll>0) = floor((telemetry.y(runMaskAll>0)+150)/binResolution)+1;
linearizedBin = xBin+((maxXBin-1)*yBin);
transitionMatrix = zeros(maxXBin^2,maxXBin^2);
for ii=1:length(linearizedBin)-1
    if ( linearizedBin(ii) > 0 ) & ( linearizedBin(ii+1) > 0 )
        transitionMatrix( linearizedBin(ii), linearizedBin(ii+1) ) = transitionMatrix( linearizedBin(ii), linearizedBin(ii+1) ) + 1;
    end
end
transitionMatrix(transitionMatrix==0)=NaN;
figure; pcolor(transitionMatrix); shading flat;


[ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(spikeMaskAllRuns>0), spikeData.y(spikeMaskAllRuns>0), deg2rad(spikeData.thetaPhase(spikeMaskAllRuns>0)-180), binResolution, 300, 300, 150  );
output = rad2deg( output )+180;
pcolor( ax(6), output ); colormap( ax(6), circColor ); colorbar; caxis( ax(6), [0 360] );
title('spike phase_{trajectory}'); axis square; shading flat;


figure; h=histogram(linearizedBin(linearizedBin>0),0:max(linearizedBin));



figure; h=histogram(linearizedBin(linearizedBin>0),0:max(linearizedBin));

binResolution = 5;
[ occupancy ] = twoDHistogram( telemetry.x(runMaskSelected>0), telemetry.y(runMaskSelected>0), binResolution, 300, 300, 150  );
[ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(spikeMaskSelected>0), spikeData.y(spikeMaskSelected>0), deg2rad(spikeData.thetaPhase(spikeMaskSelected>0)-180), binResolution, 300, 300, 150  );

figure;
plot( find(occupancy), occupancy(find(occupancy))./sum(occupancy(:)) ); hold on;
yyaxis right;
scatter( find(~isnan(output)), output(find(~isnan(output))), 11, circColor(floor(((output(find(~isnan(output))))+pi)*180/pi)+1,:), 'filled' );

size(output(~isnan(output)))

cm=hsv(360);



binResolution = 5;
[ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(spikeMaskSelected>0), spikeData.y(spikeMaskSelected>0), deg2rad(spikeData.thetaPhase(spikeMaskSelected>0)-180), binResolution, 300, 300, 150  );
output = rad2deg( output )+180;
title('spike phase_{long trajectory}'); axis square; shading flat;


figure; 
ax=subplot(2,2,1);              
pcolor( ax, output ); colormap( ax, buildCircularGradient ); colorbar; caxis( ax, [0 360] ); shading flat;
ax=subplot(2,2,3);
outputFreq(outputFreq==0)=NaN;
pcolor( ax, outputFreq ); colormap( ax, jet ); colorbar; shading flat;
ax=subplot(2,2,2);
outputFreq(outputFreq==0)=NaN; outputProb=outputFreq./max(outputFreq(:)); 
pp=pcolor( ax, output ); colormap( ax, buildCircularGradient ); colorbar; caxis( ax, [0 360] ); shading flat;
pp.AlphaData=outputProb; colormap( ax, bone ); colorbar; shading flat;
pp.

ax=subplot(2,2,4);
hold off;
pp=pcolor( ax, output ); colormap( ax, buildCircularGradient ); colorbar; caxis( ax, [0 360] ); shading flat;
[rr,cc] = find( ~isnan(output) ); hold on;
ss=scatter( cc, rr, 100, 'k', 's', 'filled'  );
ss.MarkerFaceAlpha= outputProb(~isnan(output));

sz=size(output)
hold off;
for rr=1:sz(1)
    for cc = 1:sz(2)
        if ~isnan(output(rr,cc)) & output(rr,cc)>0 & ~isnan(outputProb(rr,cc))
            thisColor = circColor( floor(output(rr,cc))+1, :);
            scatter( cc, rr, 100, thisColor, 's', 'filled'  ); hold on;
            scatter( cc, rr, 100, 's', 'MarkerFaceColor', [ 0 0 0 outputProb(rr,cc) ]  );
        end
    end
end


outputProb(rr,cc)


%% calculate phase information
%threeDHistogram(                                 xx,                               yy,                                        zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ )
freqPhasePosition=threeDHistogram( spikeData.x(spikeMaskSelected>0), spikeData.y(spikeMaskSelected>0), spikeData.thetaPhase(spikeMaskSelected>0), binResolution, binResolution, 10, 300, 300, 360, 150, 150, 0);
freqPhase=histcounts(spikeData.thetaPhase(spikeMaskSelected>0),0:10:370);
freqXY = twoDHistogram( telemetry.x(runMaskSelected>0), telemetry.y(runMaskSelected>0), binResolution, 300, 300, 150  );
probPhasePosition=freqPhasePosition./sum(freqPhasePosition(:));
probPhase = freqPhase./sum(freqPhase(:));
probXY = freqXY./sum(freqXY(:));
phaseMImat = zeros(size(probPhasePosition));
sz=size(probPhasePosition);
countDivByZeros = 0;
for rr=1:sz(1)
    for cc=1:sz(2)
        for dd=1:sz(3)
            if ( probXY(rr,cc) * probPhase(dd) ) > 0
                phaseMImat(rr,cc,dd) = probPhasePosition(rr,cc,dd) * log2( probPhasePosition(rr,cc,dd) / ( probXY(rr,cc) * probPhase(dd) ) );
            elseif (probPhasePosition(rr,cc,dd)>0)
                countDivByZeros = countDivByZeros + 1;
            end
        end
    end
end
disp([ 'ignored ' num2str(countDivByZeros) ' division by zero '  ])
nansum(phaseMImat(:))

figure
subplot(1,3,1); 
tempa=freqXY; tempa(tempa==0)=NaN;
pcolor(tempa); shading flat;
subplot(1,3,3);  
tempb=nansum(freqPhasePosition,3); tempb(tempb==0)=NaN;
pcolor(tempb');  shading flat;
subplot(1,3,2);
pcolor(tempb'.*tempa); shading flat;


tempb=zeros(61,61);
for ii=1:61;
    for jj=1:61;
        tempb(ii,jj)=nansum(freqPhasePosition(ii,jj,:));
    end
end
tempb(tempb==0)=NaN;



size(probXY*probPhase)

%% tables

table=readtable('~/Desktop/tt_report_shuff_h5h7_swr_xcorr.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);

figure;
subplot( 2,3,1 ); histogram(dbLS.maxPwr(:),200); title('maxPwr');
subplot( 2,3,2 ); histogram(dbLS.maxZScoreVal(:),200); title('maxZScoreVal');
subplot( 2,3,3 ); histogram(dbLS.peakXcorrLagTime(:),200); title('peakXcorrLagTime');
subplot( 2,3,4 ); histogram(dbLS.ptsAbove(:),200); title('ptsAbove');
subplot( 2,3,5 ); histogram(dbLS.sumNegPwr(:),200); title('sumNegPwr');
subplot( 2,3,6 ); histogram(dbLS.sumPosPwr(:),200); title('sumPosPwr');


figure; scatter( log10(dbLS.maxZScoreVal(:)), log10(dbLS.ptsAbove(:)), 'o', 'filled')


                 /Volumes/AGHTHESIS2/rats/summaryFigures/tt_unit_behavior_enhanced.csv
table=readtable('~/Desktop/tt_unit_behavior_enhanced.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);

figure; scatter( dbLS.thetaIndex(:), dbLS.rateOnMaze(:) )

figure; scatter( dbLS.thetaIndex(:), dbLS.totalOnMazeMoving (:) )



spikeTable=readtable('~/Desktop/tt_unit_behavior_enhanced.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
swrCorrTable=readtable('~/Desktop/tt_report_shuff_h5h7_swr_xcorr.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
newTable = innerjoin(spikeTable,swrCorrTable);
ds = table2dataset(newTable);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);
selectWhat =  ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLAll = ds( selectWhat, :);
selectWhat = ( strcmp( 'CA1', ds.region )) & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLCA = ds( selectWhat, :);
figure; 
subplot(2,3,1); hold off; scatter( dbLAll.thetaIndex(:), log10(dbLAll.rateOnMaze(:)) ); xlabel('thetaIndex');  ylabel('rateOnMaze'); hold on;
subplot(2,3,2); hold off; scatter( dbLAll.thetaIndex(:), log10(dbLAll.totalOnMazeMoving(:)) ); xlabel('thetaIndex'); ylabel('totalOnMazeMoving');  hold on;
subplot(2,3,3); hold off; scatter( dbLAll.thetaIndex(:), log10(dbLAll.sumPosPwr(:)) );  xlabel('thetaIndex'); ylabel('sumPosPwr');  hold on;
subplot(2,3,4); hold off; scatter( dbLAll.thetaIndex(:), log10(dbLAll.maxZScoreVal(:)) );  xlabel('thetaIndex'); ylabel('maxZScoreVal');  hold on;
subplot(2,3,5); hold off; scatter( log10(dbLAll.rateOnMaze(:)), log10(dbLAll.sumPosPwr(:)) );  xlabel('rateOnMaze'); ylabel('sumPosPwr');  hold on;
subplot(2,3,6); hold off; scatter( log10(dbLAll.rateOnMaze(:)), log10(dbLAll.maxZScoreVal(:)) );  xlabel('rateOnMaze'); ylabel('maxZScoreVal');  hold on;

subplot(2,3,1); scatter( dbLS.thetaIndex(:), log10(dbLS.rateOnMaze(:)), 'filled' );
subplot(2,3,2); scatter( dbLS.thetaIndex(:), log10(dbLS.totalOnMazeMoving(:)), 'filled' ); 
subplot(2,3,3); scatter( dbLS.thetaIndex(:), log10(dbLS.sumPosPwr(:)), 'filled' ); 
subplot(2,3,4); scatter( dbLS.thetaIndex(:), log10(dbLS.maxZScoreVal(:)), 'filled' );
subplot(2,3,5); scatter( log10(dbLS.rateOnMaze(:)), log10(dbLS.sumPosPwr(:)), 'filled' );  
subplot(2,3,6); scatter( log10(dbLS.rateOnMaze(:)), log10(dbLS.maxZScoreVal(:)),  'filled' ); 


subplot(2,3,1); scatter( dbLS.thetaIndex(dbLS.sumPosPwr(:)>1.57), log10(dbLS.rateOnMaze(dbLS.sumPosPwr(:)>1.57)), 'filled' );


subplot(2,3,1); scatter( dbLCA.thetaIndex(:), log10(dbLCA.rateOnMaze(:)), 'filled' );
subplot(2,3,2); scatter( dbLCA.thetaIndex(:), log10(dbLCA.totalOnMazeMoving(:)), '+','filled' ); 
subplot(2,3,3); scatter( dbLCA.thetaIndex(:), log10(dbLCA.sumPosPwr(:)), '+', 'filled' ); 
subplot(2,3,4); scatter( dbLCA.thetaIndex(:), log10(dbLCA.maxZScoreVal(:)), '+', 'filled' );
subplot(2,3,5); scatter( log10(dbLCA.rateOnMaze(:)), log10(dbLCA.sumPosPwr(:)), '+', 'filled' );  
subplot(2,3,6); scatter( log10(dbLCA.rateOnMaze(:)), log10(dbLCA.maxZScoreVal(:)),  'filled' ); 


%% leftovers from above, but might need them

% PLOT THE EXTRACTED RUNS
figure; plot(telemetry.xytimestampSeconds,telemetry.x.*(telemetry.onMaze>0), 'b'); hold on; 
plot(telemetry.xytimestampSeconds,telemetry.y.*(telemetry.onMaze>0), 'r'); 
plot(telemetry.xytimestampSeconds,telemetry.speed.*(telemetry.onMaze>0), 'k'); 
scatter(EpisodePeakTimes,EpisodePeakValues,'v','filled');
scatter(telemetry.xytimestampSeconds(EpisodeStartIdxs),zeros(size(EpisodeEndIdxs)),'>','filled','g');
scatter(telemetry.xytimestampSeconds(EpisodeEndIdxs),zeros(size(EpisodeEndIdxs)),'<','filled','r');


round(100*sum(runMask>0)/sum(telemetry.onMaze>0))
round(100*sum(runMask>0)/length(telemetry.onMaze))

figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
whichIdxs=runMask>0;
scatter( telemetry.x(whichIdxs), telemetry.y(whichIdxs), (telemetry.speed(whichIdxs)/10)+1, telemetry.speed(whichIdxs), 'filled'  );
colorbar; axis([ -150 150 -150 150]); axis square;
                                    


% DISPLAY A HISTOGRAM OF HOW MANY SECONDS EACH RUN EPISODE IS
[C,ia,ic] = unique(runMask);
a_counts = accumarray(ic,1);
%value_counts = [C, a_counts];
figure; histogram( a_counts(2:end)/29.97, 0:15 );




whichIdxs = (spikeData.cellNumber == 5) & (spikeData.speed > 10) & (spikeData.onMaze > 0);
distFromFieldCenter=medianFilter(distFromPoint( telemetry.x, telemetry.y, 12, 16 ).*(telemetry.onMaze>0),30);


% VISUALIZE THE DISTANCE FROM KEY POINTS AND ALSO VARIOUS OTHER SPATIAL METRICS OVER TIME
figure; plot(telemetry.xytimestampSeconds,telemetry.x.*(telemetry.onMaze>0), 'b'); hold on; 
plot(telemetry.xytimestampSeconds,telemetry.y.*(telemetry.onMaze>0), 'r'); 
plot(telemetry.xytimestampSeconds,telemetry.speed.*(telemetry.onMaze>0), 'k'); 
distWest  = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0),  70,   0);
distNorth = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0),   0,  70);
distSouth = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0),   0, -70);
distEast  = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0), -70,   0);
plot(telemetry.xytimestampSeconds,distWest, '--');
plot(telemetry.xytimestampSeconds,distNorth, '--');
plot(telemetry.xytimestampSeconds,distSouth, '--');
accel=diff(telemetry.speed.*(telemetry.onMaze>0));
accelSmooth=medianFilter( accel, 2);
plot(telemetry.xytimestampSeconds(2:end),10.*accelSmooth, '-.');
line([ 0 telemetry.xytimestampSeconds(end)],[0 0])
[ peakValues, peakTimes ] =  findpeaks( telemetry.speed.*(telemetry.onMaze>0), telemetry.xytimestampSeconds, 'MinPeakHeight', 20, 'MinPeakDistance', 60 );



figure; plot(telemetry.xytimestampSeconds,telemetry.x.*(telemetry.onMaze>0), 'b'); hold on; 
plot(telemetry.xytimestampSeconds,telemetry.y.*(telemetry.onMaze>0), 'r'); 
plot(telemetry.xytimestampSeconds,telemetry.speed.*(telemetry.onMaze>0), 'k'); 
dHeadDir=[ 0 diff(unwrap(-telemetry.headDir))].*(telemetry.onMaze>0);
smoothDHeadDir=medianFilter( dHeadDir, 2);
plot(telemetry.xytimestampSeconds,50.*smoothDHeadDir, '-.');
dMovDir=[ 0 diff(unwrap((telemetry.movDir-180).*pi/180))].*(telemetry.onMaze>0);
smoothDMovDir=medianFilter( dMovDir, 2);
plot(telemetry.xytimestampSeconds,50.*smoothDMovDir, '-.');



(telemetry.onMaze>0)




% PLOT A SPECIFIC EXAMPLE OF A TRAJECTORY ON THE MAZE
%
startIdxs=(find(diff(telemetry.onMaze)>1));
endIdxs=(find(diff(telemetry.onMaze)<-1));
startTime = telemetry.xytimestampSeconds(startIdxs(ii));
endTime = telemetry.xytimestampSeconds(endIdxs(ii));
startIdx=find(telemetry.xytimestampSeconds>startTime,1);
endIdx=find(telemetry.xytimestampSeconds>endTime,1);
% this is a slightly goofy way to do this but it works without changing the
% later stuff
 figure(100);
for ii=1 %max(telemetry.trial)
    figure(100);
    whichTelIdxs = (telemetry.trial == ii);
    ax(1)=subplot(2,3,1);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', telemetry.xytimestampSeconds(whichTelIdxs)' );
    colormap(ax(1),'jet'); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title('time flow');
    ax(2)=subplot(2,3,2);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', telemetry.speed(whichTelIdxs)' );
    colormap(ax(2),'jet'); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title([ 'speed; trial ' num2str(ii) ]);
    ax(3)=subplot(2,3,3);
    whichIdxs = (spikeData.cellNumber == 5) & (spikeData.speed > 10) & (spikeData.onMaze > 0) & (spikeData.trial == ii );
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
    scatter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), 50, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  );
    colormap(ax(3), circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square;
    title('phase');
    ax(4)=subplot(2,3,4);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    % the shifting stuff that's happening here with the headDir makes it
    % equal to the movement direction, which is correct. 
    % TODO : go through and correct all the telementry files to have
    % reasonable headDir variables
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', mod((((-telemetry.headDir(whichTelIdxs))'+pi).*180/pi)+45,360) );
    colormap(ax(4),circColor); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title('head dir');
    ax(5)=subplot(2,3,5);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', telemetry.movDir(whichTelIdxs)' );
    colormap(ax(5),circColor); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title('move dir');
    drawnow;
    pause(.5);
end





% VISUALIZE THE LOCATION OF THE SPIKES, THE SPEED AT THE SPIKE TIME AND THE
% PHASE
whichIdxs = (spikeData.cellNumber == 5) & (spikeData.speed > 20) & (spikeData.onMaze > 0);
figure; hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
scatter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), spikeData.speed(whichIdxs)/2, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  );
colormap( circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square;
title('phase');









% DISPLAY TRAJECTORIES WE LIKE
whichCell=5;
figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'k', 'filled'); hold on;
for ii=1:max( runMask )
    whichTelIdxs = ( runMask == ii );
    if sum(whichTelIdxs) > 60
        runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
        runEndTime =  telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));

        whichSpikeIdxs = (spikeData.cellNumber == whichCell) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
        scatter( spikeData.x(whichSpikeIdxs), spikeData.y(whichSpikeIdxs), spikeData.speed(whichSpikeIdxs)/10, circColor(floor(spikeData.thetaPhase(whichSpikeIdxs))+1,:), 'filled'  );
    end    
%    scatter( telemetry.x(find(whichTelIdxs,1)), telemetry.y(find(whichTelIdxs,1)), 10, 'o', 'g', 'filled'  );
%    scatter( telemetry.x(find(whichTelIdxs,1,'last')), telemetry.y(find(whichTelIdxs,1,'last')), 10, 'x', 'r' );
end
colormap(circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square; title('phase');



axis([ -150 150 -150 150]); axis square;




% 
whichCell = ttNum;
angularBin = zeros(size(telemetry.x));
angularBinSpike = zeros(size(spikeData.x));
endpointMaskPos = zeros(size(spikeData.x));
endpointMaskSpike = zeros(size(spikeData.x));
for ii=1:max(runMask)
    whichTelIdxs=(runMask==ii);
    % for today, if he's starting  somewhere in the start region and he
    % ends up North
    if 1==1 % telemetry.x(find(whichTelIdxs,1,'first')) > 60 && telemetry.y(find(whichTelIdxs,1,'last')) > 60
        if telemetry.x(find(whichTelIdxs,1,'last')) > 0
            cx = 55;
        else
            cx = -55;
        end
        if telemetry.y(find(whichTelIdxs,1,'last')) > 0
            cy = 55;
        else
            cy = -55;
        end
        angularBin(whichTelIdxs) = atan2( telemetry.x(whichTelIdxs)-cx, telemetry.y(whichTelIdxs)-cy );
        % now fix the spikes
        runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
        runEndTime =  telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));
        % 
        whichSpikeIdxs = (spikeData.cellNumber == whichCell) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
        angularBinSpike(whichSpikeIdxs) = atan2( spikeData.x(whichSpikeIdxs)-cx, spikeData.y(whichSpikeIdxs)-cy );
        %
        %
        if telemetry.y(find(whichTelIdxs,1,'last')) > 50
            endpointMaskPos(find(whichTelIdxs)) = 1;
            endpointMaskSpike(find(whichSpikeIdxs)) = 1;
        elseif telemetry.y(find(whichTelIdxs,1,'last')) < -50
            endpointMaskPos(find(whichTelIdxs)) = -1;
            endpointMaskSpike(find(whichSpikeIdxs)) = -1;
        end
    end
end

angularPositions = angularBin(find(angularBin(endpointMaskPos>0)))*180/pi;
angularSpikePositions = angularBinSpike(find(endpointMaskSpike>0))*180/pi;

figure; subplot(2,1,1); histogram( angularPositions, -180:10:180); subplot(2,1,2); histogram( angularSpikePositions, -180:10:180)

figure; scatter( [ angularSpikePositions; angularSpikePositions ], [ spikeData.thetaPhase(find((endpointMaskSpike>0))); spikeData.thetaPhase(find((endpointMaskSpike>0)))+360 ] );




figure;
scatter( cx,cy,'x','k' ); radius = 200;
for ii=-pi:pi/10:pi;
    line( [ cx cx+radius*cos(ii) ], [ cy cy+radius*sin(ii) ], 'Color', 'c')
end
axis square;




% DISPLAY TRAJECTORIES WE LIKE in 3D!!!!  Wowee wow!
whichCell=5;
figure; hold off; scatter3( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), zeros(size(telemetry.y(telemetry.onMaze>0))), 10, 'k', 'filled'); hold on;
for ii=1:max( runMask )
    whichTelIdxs = ( runMask == ii );
    if sum(whichTelIdxs) > 60
        runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
        runEndTime =  telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));

        whichSpikeIdxs = (spikeData.cellNumber == whichCell) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
        scatter3( [ spikeData.x(whichSpikeIdxs); spikeData.x(whichSpikeIdxs)], [ spikeData.y(whichSpikeIdxs); spikeData.y(whichSpikeIdxs)], [ spikeData.thetaPhase(whichSpikeIdxs); spikeData.thetaPhase(whichSpikeIdxs)+360 ], [ spikeData.speed(whichSpikeIdxs)/10; spikeData.speed(whichSpikeIdxs)/10 ], circColor([ floor(spikeData.thetaPhase(whichSpikeIdxs))+1; floor(spikeData.thetaPhase(whichSpikeIdxs))+1 ],:) , 'filled'  );
    end    
%    scatter( telemetry.x(find(whichTelIdxs,1)), telemetry.y(find(whichTelIdxs,1)), 10, 'o', 'g', 'filled'  );
%    scatter( telemetry.x(find(whichTelIdxs,1,'last')), telemetry.y(find(whichTelIdxs,1,'last')), 10, 'x', 'r' );
end
colormap(circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square; title('phase');





figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
scatter( telemetry.x(find(angularBin)), telemetry.y(find(angularBin)), 10, 'k', 'filled' );
scatter( spikeData.x(find(angularBinSpike)), spikeData.y(find(angularBinSpike)), spikeData.speed(find(angularBinSpike))/10, circColor(floor(spikeData.thetaPhase((find(angularBinSpike))))+1,:), 'filled'  );
colorbar; caxis([ 0 360 ]); colormap(circColor); axis([ -150 150 -150 150]); axis square;


figure; scatter( [ angularSpikePositions; angularSpikePositions ], [ spikeData.thetaPhase(find(angularBinSpike)); spikeData.thetaPhase(find(angularBinSpike))+360 ] );


    plot( telemetry.x(whichIdxs), telemetry.y(whichIdxs) );


55,55













% FIND CENTER FOR CIRULAR LINEARIZATION OF A RUN
%
% There are some different possibilities for the phase coding. It could be
% spatial, or it could be trajectory-based. For trajectory based coding
% along a curved path, one would need to circularly linearize the path to
% perform the analysis. This code identifies where the center along an arc
% shaped trajectory is located

% visualize start and ends of runs
figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'k', 'filled'); hold on;
for ii=1:max(runMask)
    whichIdxs=(runMask==ii);
    %plot( telemetry.x(whichIdxs), telemetry.y(whichIdxs) );
    scatter( telemetry.x(find(whichIdxs,1,'first')), telemetry.y(find(whichIdxs,1,'first')), 10, 'o', 'g', 'filled'  );
    scatter( telemetry.x(find(whichIdxs,1,'last')), telemetry.y(find(whichIdxs,1,'last')), 10, 'x', 'r' );
end
axis([ -150 150 -150 150]); axis square;

midXs=zeros(1,max(runMask));
midYs=zeros(1,max(runMask));
for ii=1:max(runMask)
    whichIdxs=(runMask==ii);
    chordLength = sqrt((telemetry.x(find(whichIdxs,1,'last'))-telemetry.x(find(whichIdxs,1,'first')))^2+(telemetry.y(find(whichIdxs,1,'last'))-telemetry.y(find(whichIdxs,1,'first')))^2);
    % midpoint
    midX=(telemetry.x(find(whichIdxs,1,'last'))+telemetry.x(find(whichIdxs,1,'first')))/2;
    midY=(telemetry.y(find(whichIdxs,1,'last'))+telemetry.y(find(whichIdxs,1,'first')))/2;
    scatter( midX, midY, 'v' );
    %figure; histogram(sqrt((telemetry.x(find(whichIdxs))-midX).^2+(telemetry.y(find(whichIdxs))-midY).^2))
    median(sqrt((telemetry.x(find(whichIdxs))-midX).^2+(telemetry.y(find(whichIdxs))-midY).^2));
    %
    midxx=-150:150;
    midyy=midxx;
    %
    midxx = midxx * midX/abs(midX);
    midyy = midyy * midY/abs(midY);
    %
    aa=[];
    for ii=1:length(midxx)
        aa(ii)=median(sqrt((telemetry.x(find(whichIdxs))-midxx(ii)).^2+(telemetry.y(find(whichIdxs))-midyy(ii)).^2));
    end
    %figure; plot(midxx,aa)
    [v,ind]=min(aa);
    %
    scatter( midxx(ind), midyy(ind), 'v', 'filled' );
    midXs(ii) = midX;
    midYs(ii) = midY;
end



midX(end)
midY(end)

atan(telemetry.y(find(whichIdxs,1,'last'))-telemetry.y(find(whichIdxs,1,'first'))/telemetry.x(find(whichIdxs,1,'last'))-telemetry.x(find(whichIdxs,1,'first')))












%% TESTING USING A PLACE CELL


rat = { 'da5' 'da10' 'h1' 'h5' 'h7' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC64.ncs' 'CSC44.ncs' };
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };

ratIdx = 5;
thisTheta = 1;

% **center trajectory
% placeRate_h7_CA1_2018-08-10_TT15_C5

% on arms -- interesting **
% placeRate_h7_CA1_2018-08-10_TT15_C10

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';


% LOAD DATA
%   load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );
load( [ basePathData 'h7_2018-08-10_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT15.mat'] );
load([ basePathData 'h7_2018-08-10_telemetry.mat' ], '-mat');

% BUILD SOME DATA STRUCTURES
speedOnMaze=telemetry.speed.*(telemetry.onMaze>0);
circColor=buildCircularGradient(360);
whichIdxs = (spikeData.cellNumber == 5) & (spikeData.speed > 10) & (spikeData.onMaze > 0);
distFromFieldCenter=medianFilter(distFromPoint( telemetry.x, telemetry.y, 12, 16 ).*(telemetry.onMaze>0),30);

% % not so obvious on this visualization :
% figure; plot(telemetry.xytimestampSeconds, speedOnMaze); hold on; 
% plot(telemetry.xytimestampSeconds, 300./distFromFieldCenter);
% yyaxis right; scatter( spikeData.timesSeconds(whichIdxs), spikeData.thetaPhase(whichIdxs), 10, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  ); ylim([0 360]); % plot( spikeData.timesSeconds(whichIdxs), spikeData.thetaPhase(whichIdxs) );
% 
% % pretty obvious on this visualization :
% figure; scatter(telemetry.x(telemetry.onMaze>0),telemetry.y(telemetry.onMaze>0), 'k', 'filled'); alpha(.1); hold on;
% scatter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), 50, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  ); alpha(.5)
% axis([ -150 150 -150 150 ]); axis square;


% PHASE BY PLACE 
% this is like building the place maps by building a 2D histogram, but
% instead of simply accumulating how many spikes ocurred in each spatial
% bin, we are building a distribution of all the phases that the spike
% occurred on and then taking a circular measure of central tendency

% let's try spatially binning and taking the average of the bins.
binResolution = 5;
% output = twoDPopulationCenter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), spikeData.thetaPhase(whichIdxs), binResolution, 300, 300, 150  );
% 
% xx = spikeData.x(whichIdxs); yy = spikeData.y(whichIdxs); data = deg2rad(spikeData.thetaPhase(whichIdxs)-180); divisionFactor =  binResolution; maxX = 300; maxY = 300; offset = 150;
% output = twoDPopulationCenter( xx, yy, data, divisionFactor, maxX, maxY, offset );
% 
[ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), deg2rad(spikeData.thetaPhase(whichIdxs)-180), binResolution, 300, 300, 150  );
output = rad2deg( output )+180;
figure; pcolor(output); colormap(circColor); colorbar; caxis([0 360])

% PLOT THE DISTRIBUTION OF VARIOUS BINS
figure; rose(hologram{16,21},30); hold on;rose(hologram{16,19},30); rose(hologram{17,17},30); rose(hologram{15,19},30);

% an attempt to choose some bins that might have a statistically different
% distribution of phases. It passes the test, but it also complains about
% some sort of difficulty with satisfying some requirements.
% 
% IDEA / TODO :
% try joining some bins together to see if that helps satisfy the
% assumptions.
circ_wwtest( hologram{16,18}, hologram{19,16} )



% VISUALIZE THE DISTANCE FROM KEY POINTS AND ALSO VARIOUS OTHER SPATIAL METRICS OVER TIME
figure; plot(telemetry.xytimestampSeconds,telemetry.x.*(telemetry.onMaze>0), 'b'); hold on; 
plot(telemetry.xytimestampSeconds,telemetry.y.*(telemetry.onMaze>0), 'r'); 
plot(telemetry.xytimestampSeconds,telemetry.speed.*(telemetry.onMaze>0), 'k'); 
distWest  = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0),  70,   0);
distNorth = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0),   0,  70);
distSouth = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0),   0, -70);
distEast  = distFromPoint( telemetry.x.*(telemetry.onMaze>0), telemetry.y.*(telemetry.onMaze>0), -70,   0);
plot(telemetry.xytimestampSeconds,distWest, '--');
plot(telemetry.xytimestampSeconds,distNorth, '--');
plot(telemetry.xytimestampSeconds,distSouth, '--');
accel=diff(telemetry.speed.*(telemetry.onMaze>0));
accelSmooth=medianFilter( accel, 2);
plot(telemetry.xytimestampSeconds(2:end),10.*accelSmooth, '-.');
line([ 0 telemetry.xytimestampSeconds(end)],[0 0])
[ peakValues, peakTimes ] =  findpeaks( telemetry.speed.*(telemetry.onMaze>0), telemetry.xytimestampSeconds, 'MinPeakHeight', 20, 'MinPeakDistance', 60 );



figure; plot(telemetry.xytimestampSeconds,telemetry.x.*(telemetry.onMaze>0), 'b'); hold on; 
plot(telemetry.xytimestampSeconds,telemetry.y.*(telemetry.onMaze>0), 'r'); 
plot(telemetry.xytimestampSeconds,telemetry.speed.*(telemetry.onMaze>0), 'k'); 
dHeadDir=[ 0 diff(unwrap(-telemetry.headDir))].*(telemetry.onMaze>0);
smoothDHeadDir=medianFilter( dHeadDir, 2);
plot(telemetry.xytimestampSeconds,50.*smoothDHeadDir, '-.');
dMovDir=[ 0 diff(unwrap((telemetry.movDir-180).*pi/180))].*(telemetry.onMaze>0);
smoothDMovDir=medianFilter( dMovDir, 2);
plot(telemetry.xytimestampSeconds,50.*smoothDMovDir, '-.');



(telemetry.onMaze>0)




% PLOT A SPECIFIC EXAMPLE OF A TRAJECTORY ON THE MAZE
%
startIdxs=(find(diff(telemetry.onMaze)>1));
endIdxs=(find(diff(telemetry.onMaze)<-1));
startTime = telemetry.xytimestampSeconds(startIdxs(ii));
endTime = telemetry.xytimestampSeconds(endIdxs(ii));
startIdx=find(telemetry.xytimestampSeconds>startTime,1);
endIdx=find(telemetry.xytimestampSeconds>endTime,1);
% this is a slightly goofy way to do this but it works without changing the
% later stuff
 figure(100);
for ii=1 %max(telemetry.trial)
    figure(100);
    whichTelIdxs = (telemetry.trial == ii);
    ax(1)=subplot(2,3,1);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', telemetry.xytimestampSeconds(whichTelIdxs)' );
    colormap(ax(1),'jet'); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title('time flow');
    ax(2)=subplot(2,3,2);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', telemetry.speed(whichTelIdxs)' );
    colormap(ax(2),'jet'); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title([ 'speed; trial ' num2str(ii) ]);
    ax(3)=subplot(2,3,3);
    whichIdxs = (spikeData.cellNumber == 5) & (spikeData.speed > 10) & (spikeData.onMaze > 0) & (spikeData.trial == ii );
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
    scatter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), 50, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  );
    colormap(ax(3), circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square;
    title('phase');
    ax(4)=subplot(2,3,4);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    % the shifting stuff that's happening here with the headDir makes it
    % equal to the movement direction, which is correct. 
    % TODO : go through and correct all the telementry files to have
    % reasonable headDir variables
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', mod((((-telemetry.headDir(whichTelIdxs))'+pi).*180/pi)+45,360) );
    colormap(ax(4),circColor); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title('head dir');
    ax(5)=subplot(2,3,5);
    hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
    plotColoredLine( telemetry.x(whichTelIdxs)', telemetry.y(whichTelIdxs)', telemetry.movDir(whichTelIdxs)' );
    colormap(ax(5),circColor); colorbar; axis([ -150 150 -150 150 ]); axis square;
    title('move dir');
    drawnow;
    pause(.5);
end





% VISUALIZE THE LOCATION OF THE SPIKES, THE SPEED AT THE SPIKE TIME AND THE
% PHASE
whichIdxs = (spikeData.cellNumber == 5) & (spikeData.speed > 20) & (spikeData.onMaze > 0);
figure; hold off; scatter( telemetry.x, telemetry.y, 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
scatter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), spikeData.speed(whichIdxs)/2, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  );
colormap( circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square;
title('phase');






% THIS IS A BIG SECTION
% HERE WE ARE GOING TO USE THE SPEED SIGNAL WHILE THE ANIMAL IS ON THE MAZE
% TO LOCATE PERIODS WHEN HE IS ENGAGING IN A MOVEMENT. this requires some
% peak finding, then descent down the peaks to the end of the movement,
% then clean up so that episodes do not overlap. There is checking to see
% if the peak occurs at the very start of the maze trial, as the rat can
% pop out of the bucket at speed and then stop. Later, some clean up occurs
% to eliminate movement episodes where the rat isn't moving vert long or
% doesn't move far enough away from his origin.

signalEnvelope = telemetry.speed.*(telemetry.onMaze>0);
signalTimes = telemetry.xytimestampSeconds;
signalSampleRate = 29.97;
[ EpisodePeakValues, EpisodePeakTimes] = findpeaks(  signalEnvelope, ...
                                        signalTimes,                        ... % time discontinuities cause inapproriate shifting; this argument provides the correct times   %sampleRate,                                  ... % sampling frequency
                                        'MinPeakHeight',                    22, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                        'MinPeakDistance',                  3  ); % assumes "lockout" for  events; don't detect peaks within 70 ms on either side of peak
                                    
%streakThreshold = round(signalSampleRate);
streakThreshold = 5;  % temporal threshold; how many samples must be under sequentially to count as end of peak?
extentThreshold = 10; % signal threshold; value signal should exceed to count as part of peak feature

% == DETECT START AND END OF AN EPISODE OF CRUNCHING ==
%
% given the locations of the peaks of the Crunch episodes, find the extents
% of the episodes
%
% starting at the peak, ride the signal envelope until it stays below a
% threshold for a while (rather heuristic)
%
%
EpisodeStartIdxs = ones( 1, length( EpisodePeakTimes ) );
EpisodeEndIdxs = ones( 1, length( EpisodePeakTimes ) );% * length(signalEnvelope);
%
% TODO use while instead of some arbitrary cut off
%
for jj=1:length(EpisodePeakTimes)
    % find the nearest index
    [vv envIdx]=min(abs(signalTimes-EpisodePeakTimes(jj)));
    envIdx = envIdx(1); % we only need one. (could cause bugs if repeat values)
    EpisodeStartIdxs(jj) = 0;
    minValStreak = 0;
    %pctThreshold = EpisodePeakValues(jj)*.05;
    for ii=1:length(signalEnvelope)
        % handles cases where there is a peak as the rat runs out of the
        % bucket
        if (envIdx-10 > 0) && ( signalEnvelope(envIdx-10) < 1)
            EpisodeStartIdxs(jj)=envIdx-1;
            break;
        end
        if envIdx-ii < 1
            break;
        end
        if signalEnvelope(envIdx-ii) < extentThreshold % pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if EpisodeStartIdxs(jj) == 1
                EpisodeStartIdxs(jj) = envIdx - ii;
            end
        elseif minValStreak > streakThreshold  % TODO should really be a proportion of sample rate
            break;
        elseif EpisodeStartIdxs(jj) ~= 1
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            EpisodeStartIdxs(jj) = 1;
            minValStreak = 0;
        end
    end
    %
    % now go up
    %EpisodeEndIdxs(ii) = 0;
    minValStreak = 0;
    %pctThreshold = EpisodePeakValues(jj)*.05;
    for ii=1:length(signalEnvelope)
        % handles cases where there is a peak as the rat runs into the
        % bucket
        if (envIdx+10 < length(signalEnvelope)) && ( signalEnvelope(envIdx+10) < 1)
            EpisodeEndIdxs(jj)=envIdx+1;
            break;
        end
        if envIdx+ii > length(signalEnvelope)
            break;
        end
        if signalEnvelope(envIdx+ii) < extentThreshold % pctThreshold
            % we found a potential endpoint
            minValStreak = minValStreak + 1;
            if  EpisodeEndIdxs(jj) == 1
                 EpisodeEndIdxs(jj) = envIdx + ii;
            end
        elseif minValStreak > streakThreshold  % TODO should really be a proportion of sample rate
            break;
        elseif  EpisodeEndIdxs(jj) ~= 1
            % we found a potential endpoint, but it ended before the cutoff so
            % so reset and keep going back
            EpisodeEndIdxs(jj) = 1;
            minValStreak = 0;
        end
    end 
    %
end


EpisodeStartIdxs(EpisodeStartIdxs<1)=1;

% NOW REMOVE DUPLICATE PEAKS THAT FALL INSIDE THE EXTENTS
% it is possible that this might break some other things that remove SWR
% interference
idxToRemove = [];
if length(EpisodePeakTimes) > 3
    for ii=2:length(EpisodePeakTimes)
        %disp( [ num2str(EpisodeStartIdxs(ii-1))  '  '  num2str(EpisodeEndIdxs(ii-1))])
        if (ii-1 > 0) && ( EpisodePeakTimes(ii) > signalTimes(EpisodeStartIdxs(ii-1)) ) && ( EpisodePeakTimes(ii) < signalTimes(EpisodeEndIdxs(ii-1)) )
            idxToRemove = [ idxToRemove ii ];
        end
    end
end
EpisodePeakValues(idxToRemove)=[];
EpisodePeakTimes(idxToRemove)=[];
EpisodeStartIdxs(idxToRemove)=[];
EpisodeEndIdxs(idxToRemove)=[];


% BUILD A RUN MASK TO EXTRACT RUNS FROM DATA
runMask = zeros(size(telemetry.x));
for ii=1:length(EpisodeStartIdxs)
    runMask(EpisodeStartIdxs(ii):EpisodeEndIdxs(ii)) = ii;
end



% ELIMINATE EPISODES THAT ARE TOO SHORT, OR DON'T RESULT IN A LONG ENOUGH
% TRAJECTORY
%
idxToRemove = [];
correctionFactor=0;  % every time we remove an episode, we need to walk the number back for all the subsequent episodes
temporalThreshold = 2; % seconds ; how long should the minimum episode be?
spatialOffsetThresold = 30; % cm ; how far should the rat move between start and finish?
% warning -- spatialOffsetThresold might reject some runs that last a long
% time, move a far distance, but start and end in roughly the same place
for ii=1:max( runMask )
    whichTelIdxs = ( runMask == ii );
    if sum(whichTelIdxs) < round(temporalThreshold*29.97)
        runMask(find(whichTelIdxs)) = 0;
        correctionFactor = correctionFactor + 1;
    elseif ( spatialOffsetThresold < sqrt( telemetry.x(find(whichTelIdxs,1,'last'))-telemetry.x(find(whichTelIdxs,1,'first'))^2 + telemetry.y(find(whichTelIdxs,1,'last'))-telemetry.y(find(whichTelIdxs,1,'first'))^2 ) )
        runMask(find(whichTelIdxs)) = 0;
        correctionFactor = correctionFactor + 1;        
    else
        runMask(find(whichTelIdxs)) = ii-correctionFactor;
    end
end
disp( [ 'REMOVED ' num2str(correctionFactor) ' of ' num2str(ii) ' movement episode trajectories (' num2str(round(100*correctionFactor/ii)) '%)' ] )



% PLOT THE EXTRACTED RUNS
figure; plot(telemetry.xytimestampSeconds,telemetry.x.*(telemetry.onMaze>0), 'b'); hold on; 
plot(telemetry.xytimestampSeconds,telemetry.y.*(telemetry.onMaze>0), 'r'); 
plot(telemetry.xytimestampSeconds,telemetry.speed.*(telemetry.onMaze>0), 'k'); 
scatter(EpisodePeakTimes,EpisodePeakValues,'v','filled');
scatter(telemetry.xytimestampSeconds(EpisodeStartIdxs),zeros(size(EpisodeEndIdxs)),'>','filled','g');
scatter(telemetry.xytimestampSeconds(EpisodeEndIdxs),zeros(size(EpisodeEndIdxs)),'<','filled','r');


round(100*sum(runMask>0)/sum(telemetry.onMaze>0))
round(100*sum(runMask>0)/length(telemetry.onMaze))

figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
whichIdxs=runMask>0;
scatter( telemetry.x(whichIdxs), telemetry.y(whichIdxs), (telemetry.speed(whichIdxs)/10)+1, telemetry.speed(whichIdxs), 'filled'  );
colorbar; axis([ -150 150 -150 150]); axis square;
                                    


% DISPLAY A HISTOGRAM OF HOW MANY SECONDS EACH RUN EPISODE IS
[C,ia,ic] = unique(runMask);
a_counts = accumarray(ic,1);
%value_counts = [C, a_counts];
figure; histogram( a_counts(2:end)/29.97, 0:15 );
                                    
                                    
% DISPLAY TRAJECTORIES WE LIKE
whichCell=5;
figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'k', 'filled'); hold on;
for ii=1:max( runMask )
    whichTelIdxs = ( runMask == ii );
    if sum(whichTelIdxs) > 60
        runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
        runEndTime =  telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));

        whichSpikeIdxs = (spikeData.cellNumber == whichCell) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
        scatter( spikeData.x(whichSpikeIdxs), spikeData.y(whichSpikeIdxs), spikeData.speed(whichSpikeIdxs)/10, circColor(floor(spikeData.thetaPhase(whichSpikeIdxs))+1,:), 'filled'  );
    end    
%    scatter( telemetry.x(find(whichTelIdxs,1)), telemetry.y(find(whichTelIdxs,1)), 10, 'o', 'g', 'filled'  );
%    scatter( telemetry.x(find(whichTelIdxs,1,'last')), telemetry.y(find(whichTelIdxs,1,'last')), 10, 'x', 'r' );
end
colormap(circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square; title('phase');



axis([ -150 150 -150 150]); axis square;




% 
whichCell = 5
angularBin = zeros(size(telemetry.x));
angularBinSpike = zeros(size(spikeData.x));
endpointMaskPos = zeros(size(spikeData.x));
endpointMaskSpike = zeros(size(spikeData.x));
for ii=1:max(runMask)
    whichTelIdxs=(runMask==ii);
    % for today, if he's starting  somewhere in the start region and he
    % ends up North
    if 1==1 % telemetry.x(find(whichTelIdxs,1,'first')) > 60 && telemetry.y(find(whichTelIdxs,1,'last')) > 60
        if telemetry.x(find(whichTelIdxs,1,'last')) > 0
            cx = 55;
        else
            cx = -55;
        end
        if telemetry.y(find(whichTelIdxs,1,'last')) > 0
            cy = 55;
        else
            cy = -55;
        end
        angularBin(whichTelIdxs) = atan2( telemetry.x(whichTelIdxs)-cx, telemetry.y(whichTelIdxs)-cy );
        % now fix the spikes
        runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
        runEndTime =  telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));
        % 
        whichSpikeIdxs = (spikeData.cellNumber == whichCell) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
        angularBinSpike(whichSpikeIdxs) = atan2( spikeData.x(whichSpikeIdxs)-cx, spikeData.y(whichSpikeIdxs)-cy );
        %
        %
        if telemetry.y(find(whichTelIdxs,1,'last')) > 50
            endpointMaskPos(find(whichTelIdxs)) = 1;
            endpointMaskSpike(find(whichSpikeIdxs)) = 1;
        elseif telemetry.y(find(whichTelIdxs,1,'last')) < -50
            endpointMaskPos(find(whichTelIdxs)) = -1;
            endpointMaskSpike(find(whichSpikeIdxs)) = -1;
        end
    end
end

angularPositions = angularBin(find(angularBin(endpointMaskPos>0)))*180/pi;
angularSpikePositions = angularBinSpike(find(endpointMaskSpike>0))*180/pi;

figure; subplot(2,1,1); histogram( angularPositions, -180:10:180); subplot(2,1,2); histogram( angularSpikePositions, -180:10:180)

figure; scatter( [ angularSpikePositions; angularSpikePositions ], [ spikeData.thetaPhase(find((endpointMaskSpike>0))); spikeData.thetaPhase(find((endpointMaskSpike>0)))+360 ] );

figure;
scatter( cx,cy,'x','k' ); radius = 200;
for ii=-pi:pi/10:pi;
    line( [ cx cx+radius*cos(ii) ], [ cy cy+radius*sin(ii) ], 'Color', 'c')
end
axis square;




% DISPLAY TRAJECTORIES WE LIKE in 3D!!!!  Wowee wow!
whichCell=5;
figure; hold off; scatter3( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), zeros(size(telemetry.y(telemetry.onMaze>0))), 10, 'k', 'filled'); hold on;
for ii=1:max( runMask )
    whichTelIdxs = ( runMask == ii );
    if sum(whichTelIdxs) > 60
        runStartTime = telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'first' ));
        runEndTime =  telemetry.xytimestampSeconds( find( whichTelIdxs, 1, 'last' ));

        whichSpikeIdxs = (spikeData.cellNumber == whichCell) & (spikeData.timesSeconds >= runStartTime) & (spikeData.timesSeconds <= runEndTime);
        scatter3( [ spikeData.x(whichSpikeIdxs); spikeData.x(whichSpikeIdxs)], [ spikeData.y(whichSpikeIdxs); spikeData.y(whichSpikeIdxs)], [ spikeData.thetaPhase(whichSpikeIdxs); spikeData.thetaPhase(whichSpikeIdxs)+360 ], [ spikeData.speed(whichSpikeIdxs)/10; spikeData.speed(whichSpikeIdxs)/10 ], circColor([ floor(spikeData.thetaPhase(whichSpikeIdxs))+1; floor(spikeData.thetaPhase(whichSpikeIdxs))+1 ],:) , 'filled'  );
    end    
%    scatter( telemetry.x(find(whichTelIdxs,1)), telemetry.y(find(whichTelIdxs,1)), 10, 'o', 'g', 'filled'  );
%    scatter( telemetry.x(find(whichTelIdxs,1,'last')), telemetry.y(find(whichTelIdxs,1,'last')), 10, 'x', 'r' );
end
colormap(circColor); colorbar; caxis([0 360]); axis([ -150 150 -150 150 ]); axis square; title('phase');





figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'filled', 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); alpha(.05); hold on;
scatter( telemetry.x(find(angularBin)), telemetry.y(find(angularBin)), 10, 'k', 'filled' );
scatter( spikeData.x(find(angularBinSpike)), spikeData.y(find(angularBinSpike)), spikeData.speed(find(angularBinSpike))/10, circColor(floor(spikeData.thetaPhase((find(angularBinSpike))))+1,:), 'filled'  );
colorbar; caxis([ 0 360 ]); colormap(circColor); axis([ -150 150 -150 150]); axis square;


figure; scatter( [ angularSpikePositions; angularSpikePositions ], [ spikeData.thetaPhase(find(angularBinSpike)); spikeData.thetaPhase(find(angularBinSpike))+360 ] );


    plot( telemetry.x(whichIdxs), telemetry.y(whichIdxs) );


55,55













% FIND CENTER FOR CIRULAR LINEARIZATION OF A RUN
%
% There are some different possibilities for the phase coding. It could be
% spatial, or it could be trajectory-based. For trajectory based coding
% along a curved path, one would need to circularly linearize the path to
% perform the analysis. This code identifies where the center along an arc
% shaped trajectory is located

% visualize start and ends of runs
figure; hold off; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'k', 'filled'); hold on;
for ii=1:max(runMask)
    whichIdxs=(runMask==ii);
    %plot( telemetry.x(whichIdxs), telemetry.y(whichIdxs) );
    scatter( telemetry.x(find(whichIdxs,1,'first')), telemetry.y(find(whichIdxs,1,'first')), 10, 'o', 'g', 'filled'  );
    scatter( telemetry.x(find(whichIdxs,1,'last')), telemetry.y(find(whichIdxs,1,'last')), 10, 'x', 'r' );
end
axis([ -150 150 -150 150]); axis square;

midXs=zeros(1,max(runMask));
midYs=zeros(1,max(runMask));
for ii=1:max(runMask)
    whichIdxs=(runMask==ii);
    chordLength = sqrt((telemetry.x(find(whichIdxs,1,'last'))-telemetry.x(find(whichIdxs,1,'first')))^2+(telemetry.y(find(whichIdxs,1,'last'))-telemetry.y(find(whichIdxs,1,'first')))^2);
    % midpoint
    midX=(telemetry.x(find(whichIdxs,1,'last'))+telemetry.x(find(whichIdxs,1,'first')))/2;
    midY=(telemetry.y(find(whichIdxs,1,'last'))+telemetry.y(find(whichIdxs,1,'first')))/2;
    scatter( midX, midY, 'v' );
    %figure; histogram(sqrt((telemetry.x(find(whichIdxs))-midX).^2+(telemetry.y(find(whichIdxs))-midY).^2))
    median(sqrt((telemetry.x(find(whichIdxs))-midX).^2+(telemetry.y(find(whichIdxs))-midY).^2));
    %
    midxx=-150:150;
    midyy=midxx;
    %
    midxx = midxx * midX/abs(midX);
    midyy = midyy * midY/abs(midY);
    %
    aa=[];
    for ii=1:length(midxx)
        aa(ii)=median(sqrt((telemetry.x(find(whichIdxs))-midxx(ii)).^2+(telemetry.y(find(whichIdxs))-midyy(ii)).^2));
    end
    %figure; plot(midxx,aa)
    [v,ind]=min(aa);
    %
    scatter( midxx(ind), midyy(ind), 'v', 'filled' );
    midXs(ii) = midX;
    midYs(ii) = midY;
end



midX(end)
midY(end)

atan(telemetry.y(find(whichIdxs,1,'last'))-telemetry.y(find(whichIdxs,1,'first'))/telemetry.x(find(whichIdxs,1,'last'))-telemetry.x(find(whichIdxs,1,'first')))






aa= telemetry.speed.*(telemetry.onMaze>0);
[~,~,vals]=find(aa);
figure; histogram(vals,0:130);



%% one version of this


clear;


load( '/Volumes/AGHTHESIS2/rats/summaryData/h7_2018-07-12_telemetry.mat' )
load( '/Volumes/AGHTHESIS2/rats/summaryData/h7_2018-07-12_theta-CSC64_TT31.mat' )



baseDir = '/Volumes/AGHTHESIS2/rats/summaryData/';
session = 'h7_2018-07-12';
spdthresh = 2.5;
cx=65; cy=65;
centerMultipliers = [ 1 1; -1 1; 1 -1; -1 -1 ];

%load([ baseDir session '_telemetry']);
figure(101); clf; 
figure(201); clf; 

%find start and end times for maze trials
donmaze = diff(telemetry.onMaze);
tstart = find(donmaze>1);
tend = find(donmaze<-1);
tlen = telemetry.xytimestampSeconds(tend)-telemetry.xytimestampSeconds(tstart);


% compute position bins along RIGHT arm journeys  (turn relative to rat)
% here, I am flipping the x axis left to right to find these journeys
[ angposR, r ] = cart2pol((-telemetry.x)-cx,telemetry.y-cy);
angposR(angposR<0) = 2*pi+angposR(angposR<0); 
angposR = rad2deg(angposR);
angvelR = diff(angposR);

%compute position bins along LEFT arm journeys  (turn relative to rat)
[ angposL, r ] = cart2pol(telemetry.x-cx,telemetry.y-cy);
angposL(angposL<0) = 2*pi+angposL(angposL<0); 
angposL = rad2deg(angposL);
angvelL = diff(angposL);
minang=90;
maxang=170-13.75;

for ii=1:12
     thisbin = find(angposL>minang & angposL<=maxang);
     telemetry.binL(thisbin) = ii;
     thisbin = find(angposR>minang & angposR<=maxang);
     telemetry.binR(thisbin) = ii;
     minang=maxang;
     maxang=maxang+13.75;
     if ii==12
         maxang=350;
     end
end




figureOffset = 1;
subplotDim = [ 3, 4 ];
subplotMax = subplotDim(1) * subplotDim(2);
subplotIdx = 1;


% trying to find places where the rat has made a trajectory. peak finder
% tells where it is sorta centered
distFromStart=medianFilter(distFromPoint( telemetry.x, telemetry.y, 0, 105 ).*(telemetry.onMaze>0)',4*30);
speedOnMaze=telemetry.speed.*(telemetry.onMaze>0);
figure; plot(telemetry.xytimestampSeconds, speedOnMaze); 
hold on; plot(telemetry.xytimestampSeconds, distFromStart ); 
[ peakValues, peakTimes ] =  findpeaks( distFromStart, telemetry.xytimestampSeconds, 'MinPeakHeight', 75, 'MinPeakDistance', 60 );
scatter( peakTimes, peakValues, 'v', 'filled' );
plot(telemetry.xytimestampSeconds, medianFilter(speedOnMaze,30)); 



max(spikeData.cellNumber)
whichCell = 3;
whichIdxs = (spikeData.cellNumber == whichCell) & (spikeData.speed > 5) & (spikeData.onMaze > 0);
sum(whichIdxs)
spikeTimes = spikeData.timesSeconds(whichIdxs);
figure; histogram(diff(spikeTimes),0:0.005:.2)

circColor=buildCircularGradient(360);

% 1,2,3,5,7
whichIdxs = (spikeData.cellNumber == 7) & (spikeData.speed > 10) & (spikeData.onMaze > 0);
figure; plot(telemetry.xytimestampSeconds, speedOnMaze); hold on; yyaxis right; scatter( spikeData.timesSeconds(whichIdxs), spikeData.thetaPhase(whichIdxs), 10, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  ); ylim([0 360]); % plot( spikeData.timesSeconds(whichIdxs), spikeData.thetaPhase(whichIdxs) );

% visualize the phase at a location for a given spike
whichIdxs = (spikeData.cellNumber == 7) & (spikeData.speed > 10) & (spikeData.onMaze > 0); % 
figure; scatter(spikeData.x(spikeData.onMaze>0),spikeData.y(spikeData.onMaze>0), 2, 'k', 'filled');
hold on; scatter( spikeData.x(whichIdxs), spikeData.y(whichIdxs), 20, circColor(floor(spikeData.thetaPhase(whichIdxs))+1,:), 'filled'  );
colormap(circColor); colorbar; caxis([0 360])


load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );

% this cell has some unfortunately close spikes -- probably means the cut was difficult
figure; histogram(diff(spikeData.timesSeconds(whichIdxs))*1000, 0:2000)
figure; plot( spikeData.timesSeconds(whichIdxs), [0 1./diff(spikeData.timesSeconds(whichIdxs))' ] )
% find the firing rate of the cell per second of recording
figure; histogram( spikeData.timesSeconds(whichIdxs), 0:telemetry.xytimestamps(end))

% unwrapping didn't work
% phaseChange = [0 diff(spikeData.thetaPhase(whichIdxs))'];
% tempdata = spikeData.thetaPhase(whichIdxs);
% tempout = tempdata;
% for ii = 2:length(tempdata); if 
% figure; scatter( spikeData.timesSeconds(whichIdxs), phaseChange, 'filled' );



data = speedOnMaze;
baseWidth = 60;
width=baseWidth;
signal = zeros(size(data));

for ii=1:baseWidth+1
    signal(ii) = median(data(1:width+ii));
end
for ii=baseWidth+1:length(data)-baseWidth-1
    if data(ii) > 15
        width = round(baseWidth*15/data(ii));
    else
        width = baseWidth; 
    end
    signal(ii) = median(data(ii-width:ii+width));
end
for ii=length(data)-baseWidth-1:length(data)
    signal(ii) = median(data(ii:length(data)));
end

figure; plot(telemetry.xytimestampSeconds, speedOnMaze); hold on;  plot(telemetry.xytimestampSeconds, signal);




%extract start and end times of beeline journeys
seltrials=[];  selectedXyTimestamps=[];
for ii=1:length(tstart)
    goodex = tstart(ii) + find(telemetry.speed(tstart(ii):tend(ii)) > spdthresh & angvelL(tstart(ii):tend(ii))'>0) - 1;
    if ~any(telemetry.y(goodex)<-30) & ~any(telemetry.x(goodex)<-50)
        runstart = find( telemetry.binL(goodex)>=4, 1, 'first' );
        while telemetry.binL(goodex(runstart)) > 1
            runstart=runstart-1;
        end
        goodex = goodex( find( telemetry.xytimestampSeconds(goodex) > telemetry.xytimestampSeconds(goodex(runstart))-1) ); 
        runend = find( telemetry.binL(goodex)>=max(telemetry.binL(goodex)), 1, 'first' ) ;
        if ~isempty(runend)
            while (telemetry.binL(goodex(runend)) >= max(telemetry.binL(goodex))) & runend<=(length(goodex)-1)
                runend=runend+1;
            end
            goodex = goodex( 1:(runend-1) );
        end
        seltrials = [seltrials; [ii tlen(ii) telemetry.xytimestampSeconds(goodex(1)) telemetry.xytimestampSeconds(goodex(end))]];
        selectedXyTimestamps = [ selectedXyTimestamps;  telemetry.xytimestamps(goodex) ] ;
        
        if subplotIdx > subplotMax
            subplotIdx = 1;
            subplotOffset = subplotOffset + 1;
        end
        
        figure(100+figureOffset);
        subplot( subplotDim(1), subplotDim(2), subplotIdx );
        scatter(telemetry.x(goodex),telemetry.y(goodex),'.r'); hold on;
        set(gca,'XLim',[-50 150],'YLim',[-50 150],'XTick',[],'YTick',[]);
        scatter(cx,cy,'k');
        for ii=0:10
            [x, y]=pol2cart(deg2rad(170-13.75+13.75*ii),100); line(cx+[0 x],cy+[0 y]);
        end
        axis square;
        
        figure(200+figureOffset); 
        subplot( subplotDim(1), subplotDim(2), subplotIdx );
        scatter(telemetry.xytimestampSeconds(goodex)-telemetry.xytimestampSeconds(goodex(1)),telemetry.binL(goodex),'.'); hold on;
        %plot(unwrap(telemetry.headDir(goodex)));
        subplotIdx = subplotIdx + 1;
        
        
        figure(500+figureOffset);
        for whichSubplot = 1:subplotMax
            subplot( subplotDim(1), subplotDim(2), whichSubplot );
            scatter(telemetry.x(goodex),telemetry.y(goodex),'.k'); hold on;
            set(gca,'XLim',[-50 150],'YLim',[-50 150],'XTick',[],'YTick',[]);
            axis square;
        end
        
    end
end



%compute position bins along LEFT arm journeys  (turn relative to rat)
[ angposL, r ] = cart2pol(spikeData.x-cx,spikeData.y-cy);
angposL(angposL<0) = 2*pi+angposL(angposL<0); 
angposL = rad2deg(angposL);
angvelL = diff(angposL);
minang=90;
maxang=170-13.75;

for ii=1:12
     thisbin = find(angposL>minang & angposL<=maxang);              
     spikeData.binL(thisbin) = ii;
     minang=maxang;
     maxang=maxang+13.75;
     if ii==12
         maxang=350;
     end
end

circColor=buildCircularGradient(360);

load([ baseDir ttlist(4).name]);
figure(500+figureOffset);
for whichCell=1:max(spikeData.cellNumber)
    subplot(subplotDim(1), subplotDim(2), whichCell );
    relevantSpike = ismember( round(spikeData.timestamps/1e6), round(selectedXyTimestamps/1e6) ) & ismember( spikeData.cellNumber, whichCell );
    scatter( spikeData.x(relevantSpike), spikeData.y(relevantSpike), 10, circColor(floor(spikeData.thetaPhase(relevantSpike)),:), 'filled'  );
end

medianPhasePerBin = zeros(1,12);
for whichBin = 1:12
    relevantSpike = ismember( round(spikeData.timestamps/1e6), round(selectedXyTimestamps/1e6) ) & ismember( spikeData.cellNumber, whichCell ) & ismember( spikeData.binL, whichBin)';
    medianPhasePerBin(whichBin) = median(spikeData.thetaPhase(relevantSpike));
end
figure; plot(medianPhasePerBin); ylim([0 360])


return;
seltrials

%read in the lfp data and compute its phase

% IIR theta LFP
load([ baseDir session '_thetaLfp']);
th_phase = angle(hilbert(lfp.thetaLfp));
th_env = abs(hilbert(lfp.thetaLfp));
 
basefig=0;
 
%extract time stamps for each theta cycle peak during beeline journeys 
ttlist=dir([ baseDir session '*_TT*']);
figure(301); clf;
cyclepeaks=[];
cl=4;
for ii=1:size(seltrials,1) %loop through the selected trials
    lfps=find(lfp.timestampSeconds>=seltrials(ii,3),1,'first');
    lfpe=find(lfp.timestampSeconds>=seltrials(ii,4),1,'first');
    cyclepeaks = [cyclepeaks; lfp.timestampSeconds(-1 + lfps + find(th_phase(lfps:(lfpe-1))<0 & th_phase((lfps+1):lfpe)>=0 & th_env((lfps+1):lfpe)>=nanmedian(th_env)))];  
    subplot(3,4,ii);
    %plot(lfp.timestampSeconds(lfps:lfpe),th_phase(lfps:lfpe)); hold on;
    yyaxis left;
    plot(lfp.timestampSeconds(lfps:lfpe),lfp.thetaLfp(lfps:lfpe)); hold on;
    yyaxis right;
    speedS = find(telemetry.xytimestampSeconds >= seltrials(ii,3), 1, 'first' );
    speedE = find(telemetry.xytimestampSeconds >= seltrials(ii,4), 1, 'first' );    
    plot( telemetry.xytimestampSeconds(speedS:speedE), telemetry.speed(speedS:speedE) ); hold on;
    %plfps=find(pseudolfp(cl).time>lfp.timestampSeconds(lfps),1,'first');
    %plfpe=find(pseudolfp(cl).time>lfp.timestampSeconds(lfpe),1,'first');
    %plot(pseudolfp(cl).time(plfps:plfpe),pseudolfp(cl).sig(plfps:plfpe)/20);
    axis tight;
end

%----loop through tetrodes
for tt=1:length(ttlist)
    figure(basefig+tt); clf; 
    figure(10+tt); clf; 
    load([ baseDir ttlist(tt).name]);
    %---loop through clusters
    for cl = 1:max(spikeData.cellNumber)
        %compute autocorrelograms and theta index
        goodspikes = find( (spikeData.cellNumber==cl & spikeData.speed>spdthresh & spikeData.onMaze==1) );
        [autocorrs(tt,cl).curve, aedges] = acorrEventTimes(spikeData.timesSeconds(goodspikes),.01,.5);
        autocorrs(tt,cl).p = max(autocorrs(tt,cl).curve([33:41 60:68]));
        autocorrs(tt,cl).v = min(autocorrs(tt,cl).curve([27:36 65:74]));
        autocorrs(tt,cl).thdex = (autocorrs(tt,cl).p - autocorrs(tt,cl).v) / autocorrs(tt,cl).p;       
        figure(10+tt);
        subplot(3,3,cl); 
        plot(autocorrs(tt,cl).curve); 
        title(num2str(autocorrs(tt,cl).thdex),'FontSize',8);
        
        pseudophase = interp1(lfp.timestampSeconds,unwrap(th_phase),spikeData.timesSeconds(goodspikes));
        posbin = round(interp1(telemetry.xytimestampSeconds,telemetry.binL,spikeData.timesSeconds(goodspikes))); 
        
        [x, pbin] = histc(mod(pseudophase,2*pi),0:2*pi/12:2*pi);
        phasebits = PhaseInfo(posbin,pbin);
        numbeats = 0; numiter=1000;
        for sh=1:numiter
             pbin=sortrows([pbin rand(length(pbin),1)]);
             pbin = pbin(:,1);
             temp=PhaseInfo(posbin,pbin);
             if temp>phasebits %if scrambled info is higher than unscrambled
                 numbeats=numbeats+1;
             end
        end
        
        meanphase=NaN(1,12);
        WW1=[]; WW2=[]; WW3=[]; WW4=[];
        for ii=1:12
            thispos = find(posbin==ii);
            if ~isempty(thispos)
               meanphase(ii) = circ_mean(pseudophase(thispos));            
            end
            if ii<4 
                WW1=[WW1; pseudophase(thispos)];
            elseif ii<7
                WW2=[WW2; pseudophase(thispos)];
            elseif ii<10
                WW3=[WW3; pseudophase(thispos)];
            elseif ii>9 
                WW4=[WW4; pseudophase(thispos)];
            end
        end
        if ~isempty(WW1) & ~isempty(WW2)
            p=circ_wwtest([WW1; WW2; WW3; WW4],[1+0*WW1; 2+0*WW2; 3+0*WW3; 4+0*WW4]);            
        else
            p=1;
        end
        figure(basefig+tt);
        subplot(3,3,cl); 
        plot(1:12,unwrap(meanphase),'o-'); set(gca,'XLim',[-.5 12.5],'XTick',[]);
        title(num2str(numbeats/numiter),'FontSize',8);
        xlabel(num2str(cl));
    end
end






%% Rewriting Tad's algorithm because I can't get it to reverse direction nicely.








%% Rehash of Tad's stuff

spdthresh = 20;
cx=65; cy=65;
centerMultipliers = [ 1 1; -1 1; 1 -1; -1 -1 ];

%load([ baseDir session '_telemetry']);
figure(101); clf; 
figure(201); clf; 

%find start and end times for maze trials
donmaze = diff(telemetry.onMaze);
tstart = find(donmaze>1);
tend = find(donmaze<-1);
tlen = telemetry.xytimestampSeconds(tend)-telemetry.xytimestampSeconds(tstart);


% compute position bins along RIGHT arm journeys  (turn relative to rat)
% here, I am flipping the x axis left to right to find these journeys
[ angposR, r ] = cart2pol((telemetry.x)-cx,(-telemetry.y)-cy);
angposR(angposR<0) = 2*pi+angposR(angposR<0); 
angposR = rad2deg(angposR);
angvelR = -diff(angposR);

%compute position bins along LEFT arm journeys  (turn relative to rat)
[ angposL, r ] = cart2pol(telemetry.x-cx,telemetry.y-cy);
angposL(angposL<0) = 2*pi+angposL(angposL<0); 
angposL = rad2deg(angposL);
angvelL = diff(angposL);
minang=90;
maxang=170-13.75;

for ii=1:12
     thisbin = find(angposL>minang & angposL<=maxang);
     telemetry.binL(thisbin) = ii;
     thisbin = find(angposR>minang & angposR<=maxang);
     telemetry.binR(thisbin) = ii;
     minang=maxang;
     maxang=maxang+13.75;
     if ii==12
         maxang=350;
     end
end

telemetry.binL=fliplr ( telemetry.binL);
telemetry.binR=fliplr ( telemetry.binR);



aa
movDir(5:end-5)

aa=zeros(size(telemetry.x));
aa(3:end-1) = (atan2( telemetry.x(4:end)-telemetry.x(1:end-3), telemetry.y(4:end)-telemetry.y(1:end-3) ));
figure; histogram((diff(unwrap(aa)))*180/pi)


bb=medianFilter(abs((telemetry.onMaze(2:end)>0).*(diff(unwrap(aa)))*180/pi),4);
figure; plot( telemetry.xytimestampSeconds, telemetry.speed.*(telemetry.onMaze>0) ); hold on; plot( telemetry.xytimestampSeconds(2:end), -abs((telemetry.onMaze(2:end)>0).*(diff(unwrap(aa)))*180/pi) );

(diff(unwrap(aa)))*180/pi





figureOffset = 1;
subplotDim = [ 3, 4 ];
subplotMax = subplotDim(1) * subplotDim(2);
subplotIdx = 1;
subplotOffset = 0;

%extract start and end times of beeline journeys
seltrials=[];  selectedXyTimestamps=[];
for ii=1:length(tstart)
    goodex = tstart(ii) + find(  (telemetry.speed(tstart(ii):tend(ii)) > spdthresh) & (angvelL(tstart(ii):tend(ii))>0) ) - 1;
    if ~any(telemetry.y(goodex)<-30) & ~any(telemetry.x(goodex)<-50)
        runstart = find( telemetry.binL(goodex)>=4, 1, 'first' );
        while telemetry.binL(goodex(runstart)) > 1 && runstart > 1
            runstart=runstart-1;
        end
        goodex = goodex( find( telemetry.xytimestampSeconds(goodex) > telemetry.xytimestampSeconds(goodex(runstart))-1) ); 
        runend = find( telemetry.binL(goodex)>=max(telemetry.binL(goodex)), 1, 'first' ) ;
        if ~isempty(runend)
            while (telemetry.binL(goodex(runend)) >= max(telemetry.binL(goodex))) & runend<=(length(goodex)-1)
                runend=runend+1;
            end
            goodex = goodex( 1:(runend-1) );
        end
        seltrials = [seltrials; [ii tlen(ii) telemetry.xytimestampSeconds(goodex(1)) telemetry.xytimestampSeconds(goodex(end))]];
        selectedXyTimestamps = [ selectedXyTimestamps  telemetry.xytimestamps(goodex) ] ;
        
        if subplotIdx > subplotMax
            subplotIdx = 1;
            subplotOffset = subplotOffset + 1;
        end
        
        figure(100+figureOffset);
        subplot( subplotDim(1), subplotDim(2), subplotIdx );
        scatter(telemetry.x(goodex),telemetry.y(goodex),'.r'); hold on;
        set(gca,'XLim',[-50 150],'YLim',[-50 150],'XTick',[],'YTick',[]);
        scatter(cx,cy,'k');
        for ii=0:10
            [x, y]=pol2cart(deg2rad(170-13.75+13.75*ii),100); line(cx+[0 x],cy+[0 y]);
        end
        axis square;
        
        figure(200+figureOffset); 
        subplot( subplotDim(1), subplotDim(2), subplotIdx );
        scatter(telemetry.xytimestampSeconds(goodex)-telemetry.xytimestampSeconds(goodex(1)),telemetry.binL(goodex),'.'); hold on;
        %plot(unwrap(telemetry.headDir(goodex)));
        subplotIdx = subplotIdx + 1;
        
        
        figure(500+figureOffset);
        for whichSubplot = 1:subplotMax
            subplot( subplotDim(1), subplotDim(2), whichSubplot );
            scatter(telemetry.x(goodex),telemetry.y(goodex),'.k'); hold on;
            set(gca,'XLim',[-50 150],'YLim',[-50 150],'XTick',[],'YTick',[]);
            axis square;
        end
        
    end
end



%compute position bins along LEFT arm journeys  (turn relative to rat)
[ angposL, r ] = cart2pol(spikeData.x-cx,spikeData.y-cy);
angposL(angposL<0) = 2*pi+angposL(angposL<0); 
angposL = rad2deg(angposL);
angvelL = diff(angposL);
minang=90;
maxang=170-13.75;

for ii=1:12
     thisbin = find(angposL>minang & angposL<=maxang);              
     spikeData.binL(thisbin) = ii;
     minang=maxang;
     maxang=maxang+13.75;
     if ii==12
         maxang=350;
     end
end

circColor=buildCircularGradient(360);

load([ baseDir ttlist(4).name]);
figure(500+figureOffset);
for whichCell=1:max(spikeData.cellNumber)
    subplot(subplotDim(1), subplotDim(2), whichCell );
    relevantSpike = ismember( round(spikeData.timestamps/1e6), round(selectedXyTimestamps/1e6) ) & ismember( spikeData.cellNumber, whichCell );
    scatter( spikeData.x(relevantSpike), spikeData.y(relevantSpike), 10, circColor(floor(spikeData.thetaPhase(relevantSpike)),:), 'filled'  );
end

medianPhasePerBin = zeros(1,12);
for whichBin = 1:12
    relevantSpike = ismember( round(spikeData.timestamps/1e6), round(selectedXyTimestamps/1e6) ) & ismember( spikeData.cellNumber, whichCell ) & ismember( spikeData.binL, whichBin)';
    medianPhasePerBin(whichBin) = median(spikeData.thetaPhase(relevantSpike));
end
figure; plot(medianPhasePerBin); ylim([0 360])


return;