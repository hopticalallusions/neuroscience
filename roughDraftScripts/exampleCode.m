% This code demonstrates how to obtain data from the files to perform
% analyses.
%
% The input data is a rat name, a folder name (which is also the date) and 
% the TT file name.
%
% Telemetry files contain a structure, "telemetry" with the following
% contents :
%
%   telemetry.x                  -- x position
%   telemetry.y                  -- y position
%   telemetry.xytimestamps       -- microsecond absolute timestamps from NLX
%   telemetry.xytimestampSeconds -- elapsed time in seconds
%   telemetry.movDir             -- movement direction; calculated @ 300 ms offsets from pairs of xy data; when the rat doesn't move, the technique corrects the direction to avoid snapping the direction back to 180 every time the rat doesn't move enough to calculate this 
%   telemetry.headDir            -- based on the NLX head direction file or on the custom extracted lights, depending on whether the tracking system failed 
%   telemetry.speed              -- in cm/s
%   telemetry.onMaze             -- marks whether the rat was on the maze or in the bucket 
%
% onMaze does not take into account whether the rat was in motion at the
% time during the transitions between bucket and maze, although it
% indicates onMaze with a "1" and in bucket with a "-1", so this data could
% be input at a later time if it becomes important.
%
% onMaze is based on the manually entered timing data marking starts and
% stops of trials from watching videos of the rat behavior.
%
%
% TTa.mat files contain a structure with a compressed version of the
% tettrode spike data from Neuralynx. Un-clustered cells are not included.
% Every spike is described with several other data points.
%
% Each file contains a structure with the following data :
%
%    spikeData.timestamps   -- NLX raw timestamp in microseconds
%    spikeData.cellNumber   -- cluster ID
%    spikeData.x            -- x position
%    spikeData.y            -- y position
%    spikeData.speed        -- speed in cm/s
%    spikeData.movDir       -- movement direction
%    spikeData.headDir      -- head direction
%    spikeData.thetaPhase   -- theta phase
%    spikeData.thetaEnv     -- theta envelope
%    spikeData.onMaze       -- is the rat on the maze or in the bucket
%    spikeData.timesSeconds -- elapsed time in seconds
%
%
%
%
%
% In the following demonstration code, figures are generated in a loop
% which segregate trials that end on one side or another. Spike location,
% and its relationship to theta phase are plotted for speed filtered
% spikes.


rat = 'h7';
% all the putative LS dates
folders = { '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-11' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-27' };
% all the putative LS tetrodes
ttFilenames = { 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT30a.NTT' 'TT31a.NTT' 'TT32a.NTT'  };


rightTripsAngle = [];
leftTripsAngle = [];
rightThetas = [];
leftThetas = [];

circColor=buildCircularGradient(360);
for ffIdx = 2:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ffIdx} '/' ];
    
    load([ '~/Desktop/' rat '_' folders{ffIdx} '_telemetry.dat' ], '-mat');
        
    for ttIdx=1:length(ttFilenames)

        % not all putative LS tetrodes yielded data on all days
        if exist([ '~/Desktop/' rat '_' folders{ffIdx} '_' ttFilenames{ttIdx} ], 'file')

            load([ '~/Desktop/' rat '_' folders{ffIdx} '_' ttFilenames{ttIdx} ], 'spikeData')
            
            for cellId = min(spikeData.cellNumber):max(spikeData.cellNumber)
                
                % set up a figure and plot all the trials where the rat was
                % on the maze in 4 different panels
                figure;
                subplot( 2,2,1);
                plot( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 'Color', [ 0 0 0 .2 ] );
                hold on; 
                title([ rat ' ' folders{ffIdx} ' ' ttFilenames{ttIdx} ' c'  ]); %num2str()
                subplot( 2,2,2);
                plot( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 'Color',  [ 0 0 0 .2 ] );
                hold on; 
                title([ rat ' ' folders{ffIdx} ' ' ttFilenames{ttIdx} ' c'  ]); %num2str()
                subplot( 2,2,3);
                plot( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 'Color',  [ 0 0 0 .2 ] );
                hold on; 
                subplot( 2,2,4);
                plot( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 'Color',  [ 0 0 0 .2 ] );
                hold on;
                % find the boundaries of the trials
                startIdxs=find(diff(telemetry.onMaze)>0);
                endIdxs=find(diff(telemetry.onMaze)<0);
                for ii=1:length(startIdxs)
                    % trials must be longer than 2 seconds long, and the
                    % subsequent logical test determines whether the rat
                    % ends up on the right or the left; left and right
                    % trajectories are color coded
                    if length(startIdxs(ii):endIdxs(ii))>61 && median(telemetry.x(endIdxs(ii)-60:endIdxs(ii))) > 0
                        subplot( 2, 2, 1 );
                        plot(telemetry.x(startIdxs(ii):endIdxs(ii)), telemetry.y(startIdxs(ii):endIdxs(ii)), 'Color',  [ 0 1 0 .2 ] );
                        subplot( 2, 2, 2 );
                        plot(telemetry.x(startIdxs(ii):endIdxs(ii)), telemetry.y(startIdxs(ii):endIdxs(ii)), 'Color',  [ 1 0  0 .2 ] );
                    else
                        subplot( 2, 2, 1 );
                        plot(telemetry.x(startIdxs(ii):endIdxs(ii)), telemetry.y(startIdxs(ii):endIdxs(ii)), 'Color',  [ 1 0 0 .2] );
                        subplot( 2, 2, 2 );
                        plot(telemetry.x(startIdxs(ii):endIdxs(ii)), telemetry.y(startIdxs(ii):endIdxs(ii)), 'Color',  [ 0 1 0 .2] );
                    end
                    
                    % identify the cell firing data for the current cell
                    % for each trajectory
                    tempCellIdx  = find( spikeData.cellNumber == cellId );
                    tempCellStartIdx = find( spikeData.timestamps > telemetry.xytimestamps(startIdxs(ii)),1);
                    tempCellEndIdx   = find( spikeData.timestamps > telemetry.xytimestamps(endIdxs(ii)),1);
                    tempCellSpeedIdx = find( spikeData.speed > 10 );
                    cellIdx = intersect( tempCellIdx, tempCellStartIdx:tempCellEndIdx );
                    cellIdx = intersect( cellIdx, tempCellSpeedIdx );
                    
                    if length(startIdxs(ii):endIdxs(ii))>61 && median(telemetry.x(endIdxs(ii)-60:endIdxs(ii))) > 0
                        subplot( 2, 2, 3 );
                        scatter( spikeData.x(cellIdx), spikeData.y(cellIdx), 10, circColor(floor( spikeData.thetaPhase(cellIdx)+181),:), 'filled' );
                        alpha(.5);
                        axis square; axis([ -150 150 -150 150]);
                        rightTripsAngle = [ rightTripsAngle; atan2( 130-spikeData.x(cellIdx), 130-spikeData.y(cellIdx) ) ];
                        rightThetas = [ rightThetas; spikeData.thetaPhase(cellIdx) ];
                    else
                        subplot( 2, 2, 4 );
                        scatter( spikeData.x(cellIdx), spikeData.y(cellIdx), 10, circColor(floor( spikeData.thetaPhase(cellIdx)+181),:), 'filled' );
                        alpha(.5);
                        axis square; axis([ -150 150 -150 150]);
                        leftTripsAngle = [ leftTripsAngle; atan2( -130-spikeData.x(cellIdx), 130-spikeData.y(cellIdx) ) ];
                        leftThetas = [ leftThetas; spikeData.thetaPhase(cellIdx) ];
                    end
                end
            end
        end
    end
end




figure; scatter(rightTripsAngle, rightThetas)
figure; histogram( rightThetas ); hold on;histogram( leftThetas );
figure; scatter( leftTripsAngle, leftThetas)