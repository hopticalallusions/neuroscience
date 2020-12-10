clear all; close all;

includeSetupMetaData;

% '2018-07-11' -- this telemetry file doesn't work for some reason.
% rat = { 'da5' 'da10' 'h1' 'h5' 'h7' };
% % folders/dates
% folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
% folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
% folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
% folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
% folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };
% % theta channels
% thetaLfpNames.da5  = { 'CSC44.ncs' 'CSC0.ncs'  }; % 12 doesn't look so great in screenshot; 0, 36, 44 look better
% thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' }; % 
% thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC64.ncs' 'CSC44.ncs' 'CSC68.ncs' };
% thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
% thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% 
% makeFilters;

skipExisting = true;

for ratIdx = 5 %:length( rat )
    for thisFolder = length( folders.(rats{ratIdx}) )
        for thisTheta = 1%:length(thetaLfpNames.(rat{ratIdx}))
            try
                disp( [ 'TRY : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') ] ) 

                filepath = [ '/Volumes/AGHTHESIS2/rats/' rats{ratIdx} '/' folders.(rats{ratIdx}){thisFolder} '/' ];

                load([ '/Volumes/AGHTHESIS2/rats/summaryData/telemetryEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');

                [ ~, IA ] = unique(telemetry.xytimestamps);
                telemetry.xytimestamps        = telemetry.xytimestamps(IA);
                telemetry.headDir             = telemetry.headDir(IA);
                telemetry.movDir              = telemetry.movDir(IA);
                telemetry.onMaze              = telemetry.onMaze(IA);
                telemetry.speed               = telemetry.speed(IA);
                telemetry.speedBumpy          = telemetry.speedBumpy(IA);
                telemetry.trial               = telemetry.trial(IA);
                telemetry.x                   = telemetry.x(IA);
                telemetry.xytimestampSeconds  = telemetry.xytimestampSeconds(IA);
                telemetry.y                   = telemetry.y(IA);
                
                
                
                
                [ lfpTheta, lfpTimestamps ]=csc2mat( [ filepath thetaLfpNames.(rats{ratIdx}){thisTheta} ] );
                thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
                % DECIMATE//DOWNSAMPLE for efficiency
                thetaLfp = decimate(thetaLfp,100);
                thetaPhase = angle(hilbert(thetaLfp));
                thetaEnv = abs(hilbert(thetaLfp));

                lfpTimestamps = downsample(lfpTimestamps,100);
                lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;

                for ttIdx=1:32 %length(ttFilenames.(rat{ratIdx}))

                    if exist([ filepath  'TT' int2str(ttIdx) 'a.ntt' ], 'file')
                        if ~exist([ '/Volumes/AGHTHESIS2/rats/summaryData/ttDataRevised/' rats{ratIdx} '_' (folders.(rats{ratIdx}){thisFolder}) '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttIdx) '.mat' ], 'file' ) && skipExisting

                            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ filepath 'TT' int2str(ttIdx) 'a.ntt'  ]);

                            disp([ rats{ratIdx} ' : ' folders.(rats{ratIdx}){thisFolder}  ' : ' 'TT' int2str(ttIdx) 'a.ntt' ])
                            totalFrames = length(spiketimes);
                            % here we are going to REMOVE all unclustered spikes for
                            % efficiency
                            spiketimes = spiketimes(cellNumber>0);
                            cellNumber = cellNumber(cellNumber>0);

                            spikeData.timestamps   = spiketimes;
                            spikeData.cellNumber   = cellNumber;
                            spikeData.x            = interp1( telemetry.xytimestamps, telemetry.x, spiketimes );
                            spikeData.y            = interp1( telemetry.xytimestamps, telemetry.y, spiketimes );
                            spikeData.speed        = interp1( telemetry.xytimestamps, telemetry.speed, spiketimes );
                            spikeData.speedBumpy   = interp1( telemetry.xytimestamps, telemetry.speedBumpy, spiketimes );
                            spikeData.movDir       = interp1( telemetry.xytimestamps, telemetry.movDir, spiketimes );
                            spikeData.headDir      = interp1( telemetry.xytimestamps, telemetry.movDir, spiketimes );
                            % IMPORTANT -- unwrap and mod or else linear interpolation will
                            % produce bad phase data.
                            spikeData.thetaPhase   = mod(interp1( lfpTimestamps, unwrap(thetaPhase), spiketimes ), 2*pi)*180/pi;
                            spikeData.thetaEnv     = interp1( lfpTimestamps, thetaEnv, spiketimes );
                            spikeData.onMaze       = interp1( telemetry.xytimestamps, telemetry.onMaze, spiketimes );
                            spikeData.trial        = interp1( telemetry.xytimestamps, telemetry.trial, spiketimes );
                            spikeData.timesSeconds = (spiketimes-lfpTimestamps(1))/1e6;
                            spikeData.thetaLfpName = thetaLfpNames.(rats{ratIdx}){thisTheta};

                            save([ '/Volumes/AGHTHESIS2/rats/summaryData/ttDataRevised/' rats{ratIdx} '_' (folders.(rats{ratIdx}){thisFolder}) '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttIdx) '.mat' ], 'spikeData')
                            disp( [ 'SUCCESS : ' rats{ratIdx} '_' (folders.(rats{ratIdx}){thisFolder}) '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttIdx) '.mat' ] );
                        else
                            disp( [ 'SKIPPED : ' rats{ratIdx} '_' (folders.(rats{ratIdx}){thisFolder}) '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttIdx) '.mat' ] );
                        end
                    end
                end
            catch err
                disp( [ 'FAILED : ' rats{ratIdx} '_' (folders.(rats{ratIdx}){thisFolder}) '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', ''), '.mat' ] );
                err.getReport
            end
        end 
    end
end

return;



clear all; close all;

rat = 'h7';
% all the putative LS dates
folders = { '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-27' };
% all the dates
folders.h7 = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
% all the putative LS tetrodes
ttFilenames.h7 = { 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT30a.NTT' 'TT31a.NTT' 'TT32a.NTT'  };
makeFilters;

for ffIdx = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ffIdx} '/' ];
    
    load([ '~/Desktop/' rat '_' folders{ffIdx} '_telemetry.mat' ], '-mat');
    
    [ lfpTheta, lfpTimestamps ]=csc2mat( [ filepath 'CSC84.ncs' ] );
    thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
    % DECIMATE//DOWNSAMPLE for efficiency
    thetaLfp = decimate(thetaLfp,100);
    thetaPhase = angle(hilbert(thetaLfp));
    thetaEnv = abs(hilbert(thetaLfp));
    
    lfpTimestamps = downsample(lfpTimestamps,100);
    lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;

    for ttIdx=1:length(ttFilenames)

        if exist([ filepath ttFilenames{ttIdx} ], 'file')

            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ filepath ttFilenames{ttIdx} ]);

            disp([ rat ' : ' folders{ffIdx} ' : ' ttFilenames{ttIdx}])
            totalFrames = length(spiketimes);
            % here we are going to REMOVE all unclustered spikes for
            % efficiency
            spiketimes = spiketimes(cellNumber>0);
            cellNumber = cellNumber(cellNumber>0);
            
            spikeData.timestamps   = spiketimes;
            spikeData.cellNumber   = cellNumber;
            spikeData.x            = interp1( telemetry.xytimestamps, telemetry.x, spiketimes );
            spikeData.y            = interp1( telemetry.xytimestamps, telemetry.y, spiketimes );
            spikeData.speed        = interp1( telemetry.xytimestamps, telemetry.speed, spiketimes );
            spikeData.movDir       = interp1( telemetry.xytimestamps, telemetry.movDir, spiketimes );
            spikeData.headDir      = interp1( telemetry.xytimestamps, telemetry.movDir, spiketimes );
            spikeData.thetaPhase   = interp1( lfpTimestamps, thetaPhase, spiketimes )*180/pi;
            spikeData.thetaEnv     = interp1( lfpTimestamps, thetaEnv, spiketimes );
            spikeData.onMaze       = interp1( telemetry.xytimestamps, telemetry.onMaze, spiketimes );
            spikeData.timesSeconds = (spiketimes-lfpTimestamps(1))/1e6;
            
            save([ '~/Desktop/' rat '_' folders{ffIdx} '_' ttFilenames{ttIdx} '.mat' ], 'spikeData')
        end
    end
end


return;
            
            
%             
%             cellsPos = zeros(2,length(spiketimes));   % row 1 is X, row 2 is Y
%             cellsSpeed = zeros(1,length(spiketimes)); % collect all the speeds
%             cellsMovDir = zeros(1,length(spiketimes));
%             cellsHeadDir = zeros(1,length(spiketimes));
%             cellsThetaPhase = zeros(1,length(spiketimes));
%             cellsThetaEnv = zeros(1,length(spiketimes));
%             cellsOnMaze = zeros(1,length(spiketimes));
%             
%             
%             
%             for ii=1:length(spiketimes)
%                 tempIdx=find(spiketimes(ii)<=telemetry.xytimestamps, 1 );
%                     if ~isempty(tempIdx)
%                         cellsPos(1,ii) = telemetry.x(tempIdx);
%                         cellsPos(2,ii) = telemetry.y(tempIdx);
%                         cellsSpeed(ii) = telemetry.speed(tempIdx);
%                         cellsMovDir(ii) = telemetry.movDir(tempIdx);
%                         cellsHeadDir(ii) = telemetry.headDir(tempIdx);
%                         cellsOnMaze(ii) = telemetry.onMaze(tempIdx);
%                     end
%                 tempIdx=find(spiketimes(ii)<=lfpTimestampSeconds, 1 );
%                     if ~isempty(tempIdx)
%                         cellsThetaPhase(ii) = thetaPhase(tempIdx);
%                         cellsThetaEnv(ii) = thetaEnv(tempIdx);
%                     end
%             end




% 
% figure;  plot( telemetry.x, telemetry.y)
% plot(telemetry.xytimestampSeconds(2:end),  diff(telemetry.onMaze)*500)
% startIdxs=find(diff(telemetry.onMaze)>0);
% endIdxs=find(diff(telemetry.onMaze)<0);
% 
% max(diff(telemetry.onMaze))
% 
% figure;
% for ii=1:length(startIdxs)
%     hold on; plot(telemetry.x(startIdxs(ii):endIdxs(ii)), telemetry.y(startIdxs(ii):endIdxs(ii)) );
% end    



% test.h7 = { '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-11' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-27' };
% test.h5  = { '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
% rr='h5';
% test.(rr)


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

        if exist([ '~/Desktop/' rat '_' folders{ffIdx} '_' ttFilenames{ttIdx} ], 'file')

            load([ '~/Desktop/' rat '_' folders{ffIdx} '_' ttFilenames{ttIdx} ], 'spikeData')
            
            for cellId = min(spikeData.cellNumber):max(spikeData.cellNumber)
                
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
                startIdxs=find(diff(telemetry.onMaze)>0);
                endIdxs=find(diff(telemetry.onMaze)<0);
                for ii=1:length(startIdxs)
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

    
figure; histogram(thetaPhase)

figure; histogram

min(spikeData.cellsThetaPhase)


% code to find parts on maze and off maze            
%            hold on;
%            scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 5, 'filled', 'b' );
%            scatter( telemetry.x(telemetry.onMaze<=0), telemetry.y(telemetry.onMaze<=0), 5, 'filled', 'r' );



clear all; close all;

rat = { 'h5' 'h7'};
folders.h5 = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7 = { '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-27' };
% all the putative LS tetrodes
thetaLfpName.h5 = 'CSC76.ncs';
thetaLfpName.h7 = 'CSC84.ncs';
makeFilters;

for ratIdx = 2:length( rat )
    for ffIdx = 1:length( folders.(rat{ratIdx}) )
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat{ratIdx} '/' folders.(rat{ratIdx}){ffIdx} '/' ];

        [ lfpTheta, lfpTimestamps ]=csc2mat( [ filepath thetaLfpName.(rat{ratIdx}) ] );
        thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
        % DECIMATE//DOWNSAMPLE for efficiency
        lfp.thetaLfp = decimate(thetaLfp,100);
        lfp.timestamps = downsample(lfpTimestamps,100);
        lfp.timestampSeconds = (lfp.timestamps-lfp.timestamps(1))/1e6;

        save([ '~/Desktop/' rat{ratIdx} '_' (folders.(rat{ratIdx}){ffIdx}) '_thetaLfp', '.mat' ], 'lfp')
    end
end
