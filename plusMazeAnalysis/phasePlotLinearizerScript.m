rat = { 'h5' 'h7' }; %{ 'da5' 'da10' 'h5' 'h7' 'h1' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' '2016-09-01' '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04' '2018-09-05' '2018-09-06' '2018-09-08' '2018-09-09' '2018-09-14' };
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

thisTheta = 1; % 1:length(thetaLfpNames.(rat{ratIdx}))
thisSwr = 1; 

subplotCheatTable= [ 1,1; 1,2; 2,2; 2,2; 2,3; 2,3; 2,4; 2,4; 3,4; 3,4; 3,4; 3,4; 4,4; 4,4; 4,4; 4,4; 4,5; 4,5; 4,5; 4,5; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6; 7,6; 7,6; 7,6; 7,6; 7,6; 7,6 ];

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';


speedThresholdSize = 3; % this one controls the size of the scatter dots
speedThreshold =  10; % this one controls the cutoff; if it isn't set up like this, the scattter dots are too small.
rejectedTrials = 0;
buildTrialSwitch = true;



%fileID = fopen([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'],'w');
fileID = fopen([ basePathOutput 'temp.csv'],'w');

%make header
message = [ 'rat,' 'folder,' 'TT,' 'unit,' 'region,turnDir,nSpikes,nSeconds,nTrials,totTrials,totSeconds, rho, pval' ];
fprintf( fileID, '%s\n' , message);


for ratIdx = 2% 1:length( rat )
    for ffIdx = 14% 1:length( folders.(rat{ratIdx}) )  % 1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData 'telemetryEnhanced/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData 'telemetryEnhanced/'  rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            
            for ttNum = 32% 1:32
                % TOP ONE FOR ALL TT
                if exist( [ basePathData 'ttDataOld/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' )
                %
                % THIS ONE FOR LS ONLY
                % if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && ~isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'LS' ) )
                % THIS ONE FOR CA ONLY
                %if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && ~isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'CA' ) )
                    load( [ basePathData 'ttDataOld/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );

                    for cellId = 1% 1:max(spikeData.cellNumber)

                            % clear data structures to aggregate across trials
                            angularCellData.pos.ne = [];
                            angularCellData.pos.en = [];
                            angularCellData.pos.se = [];
                            angularCellData.pos.es = [];
                            angularCellData.pos.sw = [];
                            angularCellData.pos.ws = [];
                            angularCellData.pos.nw = [];
                            angularCellData.pos.wn = [];
                            angularCellData.pos.xx = [];

                            angularCellData.posIdx.ne = [];
                            angularCellData.posIdx.en = [];
                            angularCellData.posIdx.se = [];
                            angularCellData.posIdx.es = [];
                            angularCellData.posIdx.sw = [];
                            angularCellData.posIdx.ws = [];
                            angularCellData.posIdx.nw = [];
                            angularCellData.posIdx.wn = [];
                            angularCellData.posIdx.xx = [];


                            angularCellData.phases.ne = [];
                            angularCellData.phases.en = [];
                            angularCellData.phases.se = [];
                            angularCellData.phases.es = [];
                            angularCellData.phases.sw = [];
                            angularCellData.phases.ws = [];
                            angularCellData.phases.nw = [];
                            angularCellData.phases.wn = [];
                            angularCellData.phases.xx = [];

                            angularCellData.spikeIdxs.ne = [];
                            angularCellData.spikeIdxs.en = [];
                            angularCellData.spikeIdxs.se = [];
                            angularCellData.spikeIdxs.es = [];
                            angularCellData.spikeIdxs.sw = [];
                            angularCellData.spikeIdxs.ws = [];
                            angularCellData.spikeIdxs.nw = [];
                            angularCellData.spikeIdxs.wn = [];
                            angularCellData.spikeIdxs.xx = [];

                            angularCellData.spikePos.ne = [];
                            angularCellData.spikePos.en = [];
                            angularCellData.spikePos.se = [];
                            angularCellData.spikePos.es = [];
                            angularCellData.spikePos.sw = [];
                            angularCellData.spikePos.ws = [];
                            angularCellData.spikePos.nw = [];
                            angularCellData.spikePos.wn = [];
                            angularCellData.spikePos.xx = [];

                            angularCellData.circCorrRho.ne = [];
                            angularCellData.circCorrRho.en = [];
                            angularCellData.circCorrRho.se = [];
                            angularCellData.circCorrRho.es = [];
                            angularCellData.circCorrRho.sw = [];
                            angularCellData.circCorrRho.ws = [];
                            angularCellData.circCorrRho.nw = [];
                            angularCellData.circCorrRho.wn = [];
                            angularCellData.circCorrRho.xx = [];

                            angularCellData.circCorrPval.ne = [];
                            angularCellData.circCorrPval.en = [];
                            angularCellData.circCorrPval.se = [];
                            angularCellData.circCorrPval.es = [];
                            angularCellData.circCorrPval.sw = [];
                            angularCellData.circCorrPval.ws = [];
                            angularCellData.circCorrPval.nw = [];
                            angularCellData.circCorrPval.wn = [];
                            angularCellData.circCorrPval.xx = [];

                            angularCellData.trialList.ne = [];
                            angularCellData.trialList.en = [];
                            angularCellData.trialList.se = [];
                            angularCellData.trialList.es = [];
                            angularCellData.trialList.sw = [];
                            angularCellData.trialList.ws = [];
                            angularCellData.trialList.nw = [];
                            angularCellData.trialList.wn = [];
                            angularCellData.trialList.xx = [];

                            disp([ 'rat ' rat{ratIdx} ' day ' folders.(rat{ratIdx}){ffIdx} ' TT ' num2str(ttNum) ' cell ' num2str(cellId) ]);
                            % obtain candidate relevant spikes
                            initSpikeSelectorMask = ( spikeData.cellNumber == cellId ) & ( spikeData.speed > speedThreshold ) & ( spikeData.onMaze > 0 );
                            % convert them to a telemetry-resolution time basis
                            thisSpikeTimesTelemetryResolution = floor(spikeData.timesSeconds(initSpikeSelectorMask)*29.97);
                            % extract the indices of these spikes so that I can
                            % index the spike thetas later by indexing this :
                            thisSpikeFileIdxs = find(initSpikeSelectorMask)';
                            %
                            % NOW PROCESS EVERY TRIAL
                            for trialIdx = 1:max(telemetry.trial)
%                                disp(['trial ' num2str(trialIdx)]);
                                % obtain start and end indices for the trial
                                trialStartIdx = find(telemetry.trial == trialIdx, 1, 'first');
                                trialEndIdx = find(telemetry.trial == trialIdx, 1, 'last');
                                % set half of the central location based on the start
                                if telemetry.x(trialStartIdx) > 50  
                                    startLoc = 'E';  % east and west are flipped in the data, relative to what we always labelled
                                elseif telemetry.x(trialStartIdx) < -50 
                                    startLoc = 'W';
                                elseif telemetry.y(trialStartIdx) > 50
                                    startLoc = 'N';
                                elseif telemetry.y(trialStartIdx) < -50
                                    startLoc = 'S';
                                else
                                    startLoc = 'X';
                                end
                                
                                %
                                % find the first time the rat is 
                                %    (1) "far enough" away from the start
                                %    (2) "close enough" to a reward area
                                %
                                % To do this, measure the distance from the two absolute
                                % end points (i.e. N & E ), apply a less than operator, and
                                % OR them together. This tells us all the spots where the
                                % animal is within XX cm of an idealized reward zone.
                                %
                                % Next, AND this with a mask where the animal's distance is
                                % greater than YY. This should produce a binary string of
                                % values where the animal is close to the end.
                                %
                                % finally, find the first such instance and call that the
                                % end
                                %
                                rewardDistanceThreshold = 5;
                                
                                if isempty(trialStartIdx)
                                    break;
                                end
                                
                                idxFirstAtRewardZone=trialStartIdx+find( sqrt( (telemetry.x(trialStartIdx:trialEndIdx)-telemetry.x(trialStartIdx)).^2 + (telemetry.y(trialStartIdx)-telemetry.y(trialStartIdx)).^2 ) > 45 & ( sqrt( (0-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (100-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold | sqrt( (100-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (0-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold ),1,'first');
                                % if this yields no results, the trial is a bust
                                while isempty(idxFirstAtRewardZone)
                                    rewardDistanceThreshold = rewardDistanceThreshold + 5;
                                    if rewardDistanceThreshold > 55;
                                         tidx= find( sqrt( (telemetry.x(trialStartIdx:trialEndIdx)-telemetry.x(trialStartIdx)).^2 + (telemetry.y(trialStartIdx)-telemetry.y(trialStartIdx)).^2 ) > 90); 
                                         min( sqrt( (0-abs(telemetry.x(tidx))).^2 + (90-abs(telemetry.y(tidx))).^2 ) )
                                         min( sqrt( (90-abs(telemetry.x(tidx))).^2 + (0-abs(telemetry.y(tidx))).^2 ) )
                                        break;
                                    end
                                    idxFirstAtRewardZone=trialStartIdx+find( sqrt( (telemetry.x(trialStartIdx:trialEndIdx)-telemetry.x(trialStartIdx)).^2 + (telemetry.y(trialStartIdx)-telemetry.y(trialStartIdx)).^2 ) > 45 & ( sqrt( (0-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (100-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold | sqrt( (100-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (0-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold ),1,'first');
                                end 
                                    
                                 if isempty(idxFirstAtRewardZone)
                                     disp([ 'rat did not complete trial ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ]);
                                     continue;
                                 end
                                 
                                
                                % now that we know the trial ends somewhere
                                % uesful, but where?
                                %
                                if telemetry.x(idxFirstAtRewardZone) > 50
                                    endLoc = 'E';
                                elseif telemetry.x(idxFirstAtRewardZone) < -50 
                                    endLoc = 'W';
                                elseif  telemetry.y(idxFirstAtRewardZone) > 50
                                    endLoc = 'N';
                                elseif  telemetry.y(idxFirstAtRewardZone) < -50
                                    endLoc = 'S';
                                else
                                    endLoc = 'X';
                                end
                                % set the center position for angular
                                % linearization
                                if strcmp( [ startLoc endLoc], 'NE') || strcmp( [ startLoc endLoc], 'EN')
                                    linearizationCircleCenter.x=60;
                                    linearizationCircleCenter.y=60;
                                elseif strcmp( [ startLoc endLoc], 'NW') || strcmp( [ startLoc endLoc], 'WN')
                                    linearizationCircleCenter.x=-60;
                                    linearizationCircleCenter.y=60;
                                elseif strcmp( [ startLoc endLoc], 'SE') || strcmp( [ startLoc endLoc], 'ES')
                                    linearizationCircleCenter.x=60;
                                    linearizationCircleCenter.y=-60;
                                elseif strcmp( [ startLoc endLoc], 'SW') || strcmp( [ startLoc endLoc], 'WS')
                                    linearizationCircleCenter.x=-60;
                                    linearizationCircleCenter.y=-60;
                                else
                                   disp ([ 'boooo   '  startLoc endLoc ' trial ' num2str(trialIdx)   ]); 
                                   %message = [ 'rat,' 'folder,' 'TT,' 'unit,' 'region,turnDir,nSpikes,nSeconds,nTrials,totTrials,totSeconds, rho, pval' ];
                                   message = ([ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str(ttNum) ',' num2str(cellId) ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}, ',' startLoc endLoc ',0,0,0,0,0,0,0,' num2str(trialIdx) ]);
                                   fprintf( fileID, '%s\n' , message);
                                end
                                % set the linearization correction switch (for e.g. EN, rat is traveling "backwards" in degrees)
                                % alo set up the direction filter. it will have
                                % some redundancies
                                if strcmp( [ startLoc endLoc], 'NE')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [    0  35  235 360  ];
                                elseif strcmp( [ startLoc endLoc], 'NW')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [    0 125  325 360  ];
                                elseif strcmp( [ startLoc endLoc], 'SE')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [  155 295  155 295  ];
                                elseif strcmp( [ startLoc endLoc], 'SW')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [   65 205   65 205 ];
                                elseif strcmp( [ startLoc endLoc], 'EN')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [   65 205   65 205  ];
                                elseif strcmp( [ startLoc endLoc], 'WN')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [  155 295  155 295 ];
                                elseif strcmp( [ startLoc endLoc], 'ES')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [    0 125  325 360 ];
                                elseif strcmp( [ startLoc endLoc], 'WS')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [  235 360    0  35 ];
                                else
                                    flipLinearization = false
                                    turnDir = 'badTurn';
                                    movDirLimits = [    0 360    0 360  ];
                                end
                                %
                                % linearize the position
                                %
                                % The following block linearizes position by
                                % approximating linearization with angle around
                                % a circle. To ensure linearized position
                                % values increase from the start to the finish,
                                % the code flips any trajectories that are
                                % "backwards". The angles are converted to 360
                                % degrees intead of 2pi.
                                %
                                thisTrialIdxs = trialStartIdx:idxFirstAtRewardZone;
                                [ trialAngleRads, trialRadius ] = cart2pol( telemetry.x(thisTrialIdxs)-linearizationCircleCenter.x, telemetry.y(thisTrialIdxs)-linearizationCircleCenter.y );
                                trialAngle = (trialAngleRads+pi)*180/pi;
                                if flipLinearization
                                    trialAngleRads = pi-trialAngleRads;
                                    trialAngle = 360 - trialAngle;
                                end
                                trialSpeeds = telemetry.speed(thisTrialIdxs);
                                trialMovDirs = telemetry.movDir(thisTrialIdxs);
                                %
                                % ensure variables are a row with many columns
                                if size(trialMovDirs,1) > size(trialMovDirs,2)
                                    trialMovDirs = trialMovDirs';
                                end
                                if size(trialSpeeds,1) > size(trialAngle,2)
                                    trialSpeeds = trialSpeeds';
                                end
                                if size(trialAngle,1) > size(trialAngle,2)
                                    trialAngle = trialAngle';
                                    trialAngleRads = trialAngleRads';
                                end
                                if size(trialRadius,1) > size(trialRadius,2)
                                    trialRadius = trialRadius';
                                end



                                %
                                % re-filter this result
                                %
                                % * in keeping with Tad's thigomotaxic halo
                                % filter, this filter hard limits the path to
                                % an roughly linear trajectory. If the rat goes
                                % down the start arm, then dithers in the
                                % center idly for a while, and then eventually
                                % goes down a goal arm, this filter will chop
                                % off all the ditering and make it appear to be
                                % a fairly continuous path. 
                                % 
                                % THAT IS, there is a big assumption baked into
                                % this method that phase precession will occur
                                % along allocentric space.
                                %
                                % speed filter -- uses a low speed, but can be
                                % reset
                                %
                                % radius filter -- the radius filter helps
                                % exclude parts where the rat goes off into the
                                % center open field away from an "optimal path"
                                % I estimated the maximum allowed radius as 
                                % ~105 cm and the minimum as 55; it somewhat
                                % depends on which quadrant he is in, but I am
                                % ignoring that. THE RADII ARE HARD CODED SO
                                % THIS WILL BREAK IF THE CENTERS ARE MOVED.
                                %
                                % directional filter -- we have reason to
                                % believe that the phase precession may be
                                % directionally dependent, so this filter
                                % further shapes the path such that the rat is
                                % generally advancing through space from start
                                % to finish
                                %
                                % minimum allowed radius 55 cm
                                validTrialMask = ( ( trialSpeeds > speedThreshold ) & ( trialRadius < 75 ) & ( trialRadius > 45 )) & ((( movDirLimits(1) <= trialMovDirs ) & ( movDirLimits(2) >= trialMovDirs ) ) | ( ( movDirLimits(3) <= trialMovDirs ) & ( movDirLimits(4) >= trialMovDirs )));
                                trialAngle = trialAngle((validTrialMask));
                                trialRadius = trialRadius((validTrialMask));
                                %
                                % so now we have screened trajectories
                                %
                                % GET SPIKE DATA
                                %
                                % now I need to obtain spike data
                                % 
                                % convert the times into indices
                                thisTrialTimeTelemetryResolution = floor(telemetry.xytimestampSeconds(thisTrialIdxs(validTrialMask)) * 29.97);
                                % intersect the telemetry-resolution time data
                                % to pull out the indices to the relevant spikes
                                [ values, idxTrialToTelemetryData, idxTrialToSpikeData ] = intersect( thisTrialTimeTelemetryResolution, thisSpikeTimesTelemetryResolution );
                                %
                                % select the appropriate trajectory
                                %
                                % This piece of code looks at the trajectory
                                % and sets up data accumulation for that
                                % trajectory
                                %
                                % it also shifts the angular position such that
                                % start is always at "zero" and end is always
                                % at "180"
                                %
                                % rather than accumulating everything, the
                                % script builds up a set of indices to pull
                                % data in case of some sort of later need.
                                %
                                if strcmp( [ startLoc endLoc], 'NE')
                                    sp = 1;
                                    trialAngle = mod( trialAngle+50, 360);
                                    angularCellData.posIdx.ne = [ angularCellData.posIdx.ne thisTrialIdxs(validTrialMask) ];
                                    angularCellData.pos.ne = [ angularCellData.pos.ne trialAngle ];
                                    angularCellData.spikeIdxs.ne = [ angularCellData.spikeIdxs.ne thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.ne = [ angularCellData.phases.ne spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 315 495 ];
                                    angularCellData.spikePos.ne = [ angularCellData.spikePos.ne trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.ne = turnDir;
                                    angularCellData.trialList.ne = [ angularCellData.trialList.ne trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'NW')
                                    angularCellData.posIdx.nw = [ angularCellData.posIdx.nw thisTrialIdxs(validTrialMask) ];
                                    sp = 2;
                                    trialAngle = mod( trialAngle+235, 360);
                                    angularCellData.pos.nw = [ angularCellData.pos.nw trialAngle ];
                                    angularCellData.spikeIdxs.nw = [ angularCellData.spikeIdxs.nw thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.nw = [ angularCellData.phases.nw spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 45 225 ];
                                    angularCellData.spikePos.nw = [ angularCellData.spikePos.nw trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.nw = turnDir;
                                    angularCellData.trialList.nw = [ angularCellData.trialList.nw trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'SE')
                                    angularCellData.posIdx.se = [ angularCellData.posIdx.se thisTrialIdxs(validTrialMask) ];
                                    sp = 3;
                                    trialAngle = mod( trialAngle+55, 360);
                                    angularCellData.pos.se = [ angularCellData.pos.se trialAngle ];
                                    angularCellData.spikeIdxs.se = [ angularCellData.spikeIdxs.se thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.se = [ angularCellData.phases.se spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 225 405 ];
                                    angularCellData.spikePos.se = [ angularCellData.spikePos.se trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.se = turnDir;
                                    angularCellData.trialList.se = [ angularCellData.trialList.se trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'SW')
                                    trialAngle = mod( trialAngle+240, 360);
                                    angularCellData.posIdx.sw = [ angularCellData.posIdx.sw thisTrialIdxs(validTrialMask) ];
                                    sp = 4;
                                    angularCellData.pos.sw = [ angularCellData.pos.sw trialAngle ];
                                    angularCellData.spikeIdxs.sw = [ angularCellData.spikeIdxs.sw thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.sw = [ angularCellData.phases.sw spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 135 315 ];
                                    angularCellData.spikePos.sw = [ angularCellData.spikePos.sw trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.sw = turnDir;
                                    angularCellData.trialList.sw = [ angularCellData.trialList.sw trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'EN')
                                    trialAngle = mod( trialAngle+45, 360);
                                    angularCellData.posIdx.en = [ angularCellData.posIdx.en thisTrialIdxs(validTrialMask) ];
                                    sp = 5;
                                    trialAngle = mod( trialAngle+100, 360);
                                    angularCellData.pos.en = [ angularCellData.pos.en trialAngle ];
                                    angularCellData.spikeIdxs.en = [ angularCellData.spikeIdxs.en thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.en = [ angularCellData.phases.en spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 315 495 ];
                                    angularCellData.spikePos.en = [ angularCellData.spikePos.en trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.en = turnDir;
                                    angularCellData.trialList.en = [ angularCellData.trialList.en trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'WN')
                                    trialAngle = mod( trialAngle-35, 360);
                                    angularCellData.posIdx.wn = [ angularCellData.posIdx.wn thisTrialIdxs(validTrialMask) ];
                                    sp = 6;
                                    angularCellData.pos.wn = [ angularCellData.pos.wn trialAngle ];
                                    angularCellData.spikeIdxs.wn = [ angularCellData.spikeIdxs.wn thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.wn = [ angularCellData.phases.wn spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 45 225 ];
                                    angularCellData.spikePos.wn = [ angularCellData.spikePos.wn trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.wn = turnDir;
                                    angularCellData.trialList.wn = [ angularCellData.trialList.wn trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'ES')
                                    angularCellData.posIdx.es = [ angularCellData.posIdx.es thisTrialIdxs(validTrialMask) ];
                                    sp = 7;
                                    trialAngle = mod( trialAngle+135, 360);
                                    angularCellData.pos.es = [ angularCellData.pos.es trialAngle ];
                                    angularCellData.spikeIdxs.es = [ angularCellData.spikeIdxs.es thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.es = [ angularCellData.phases.es spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 225 405 ];
                                    angularCellData.spikePos.es = [ angularCellData.spikePos.es trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.es = turnDir;
                                    angularCellData.trialList.es = [ angularCellData.trialList.es trialIdx ];
                                elseif strcmp( [ startLoc endLoc], 'WS')
                                    trialAngle = mod( trialAngle-50, 360);
                                    angularCellData.posIdx.ws = [ angularCellData.posIdx.ws thisTrialIdxs(validTrialMask) ];
                                    sp = 8;
                                    angularCellData.pos.ws = [ angularCellData.pos.ws trialAngle ];
                                    angularCellData.spikeIdxs.ws = [ angularCellData.spikeIdxs.ws thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.ws = [ angularCellData.phases.ws spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 135 315 ];
                                    angularCellData.spikePos.ws = [ angularCellData.spikePos.ws trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.ws = turnDir;
                                    angularCellData.trialList.ws = [ angularCellData.trialList.ws trialIdx ];
                                else
                                    sp = 9;
                                    angularCellData.pos.xx = [ angularCellData.pos.xx trialAngle ];
                                    angularCellData.spikeIdxs.xx = [ angularCellData.spikeIdxs.xx thisSpikeFileIdxs(idxTrialToSpikeData) ];
                                    angularCellData.phases.xx = [ angularCellData.phases.xx spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData))' ];
                                    angPosRange = [ 0 180 ];
                                    angularCellData.spikePos.xx = [ angularCellData.spikePos.xx trialAngle(idxTrialToTelemetryData) ];
                                    angularCellData.turnDir.xx = 'invalid';
                                    angularCellData.trialList.xx = [ angularCellData.trialList.xx trialIdx ];
                                end
%
                                figure(104);
                                ax(sp)=subplot(3,3,sp);
                                % enable double stacking of data
                                txx = trialAngle(idxTrialToTelemetryData);                                                    % x values
                                tyy = spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData));                       % y values
                                tss = floor(spikeData.speed(thisSpikeFileIdxs(idxTrialToSpikeData))/speedThreshold)+1;    % size values
                                tcc = circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData)))+1,:); % color values
                                scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy; tyy+360; tyy; tyy+360], [tss; tss; tss; tss], [ tcc; tcc; tcc; tcc ], 'filled'  );  hold on;
                                %scatter( trialAngle, spikeData.thetaPhase(thisSpikeFileIdxs(idxB)), floor(spikeData.speed(thisSpikeFileIdxs(idxB))/speedThreshold)+1, circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxB)))+1,:), 'filled' ); hold on;
                                colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; ylim([0 720]); xlim([0 180]);
                                xlabel('linearized position');
                                ylabel('theta phase');
                                
                                
%                                 selectedTelIdxs = trialStartIdx:idxFirstAtRewardZone;
%                                 figure(102);
%                                 ax(sp)=subplot(3,3,sp);
%                                 %scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 'k', 'filled' ); alpha(.2); hold on;
%                                 plot( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 'Color', [ 0 0 0 .1 ] ); hold on;
%                                 scatter( spikeData.x(thisSpikeFileIdxs(idxTrialToSpikeData)), spikeData.y(thisSpikeFileIdxs(idxTrialToSpikeData)), floor(spikeData.speed(thisSpikeFileIdxs(idxTrialToSpikeData))/speedThreshold)+1, circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxTrialToSpikeData)))+1,:), 'filled'  ); alpha(.3);
%                                 colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; axis([-150 150 -150 150]);
%                                 title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} '  ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '  TT' num2str(ttNum) ' c' num2str(cellId)    ])
%                                 xlabel(['spike speed phase']);
%


                            end

                            % this code is only required once per session, but
                            % we're doing it every cell because it's more
                            % straightfoward.
                            listOfTrajectories = { 'ne' 'en' 'se' 'es' 'sw' 'ws' 'nw' 'wn' 'xx' };
                            listOfObservedTrajectories = {};
                            for ii= 1:9
                                if ~isempty(angularCellData.posIdx.(listOfTrajectories{ii}))
                                    % despite the [ ], this still produces a
                                    % cell structure. hooray?
                                    listOfObservedTrajectories = [ listOfObservedTrajectories listOfTrajectories{ii} ];
                                end
                            end

                            
                            % calculate the circular linear correlation
                            for ii = 1:length(listOfObservedTrajectories)
                                if ~isempty(deg2rad(angularCellData.phases.(listOfObservedTrajectories{ii}))) && ~isempty(angularCellData.phases.(listOfObservedTrajectories{ii}))
                                    [angularCellData.circCorrRho.(listOfObservedTrajectories{ii}),angularCellData.circCorrPval.(listOfObservedTrajectories{ii})] = circ_corrcl( deg2rad(angularCellData.phases.(listOfObservedTrajectories{ii})), angularCellData.spikePos.(listOfObservedTrajectories{ii}) );
                                end
                            end

                            % save the data
%                            save([ basePathData 'angularCellData_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' num2str(ttNum) '_cell' num2str(cellId) ], 'angularCellData' );
%
                            if ~isempty(listOfObservedTrajectories)
%
%                                 % make graphs of the data
                                subplotDims =  subplotCheatTable(2*length(listOfObservedTrajectories),:); % subplotCheat(2*length(listOfObservedTrajectories));

%                                 figure(103);
%                                 clf(103);
%                                 for ii=1:length(listOfObservedTrajectories)
% 
%                                     ax=subplot( subplotDims(1), subplotDims(2) , 1+(2*(ii-1)) );
%                                     selectedTelIdxs = telemetry.trial>0;
%                                     scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ]  );
%                                     hold on;
%                                     selectedTelIdxs = angularCellData.posIdx.(listOfObservedTrajectories{ii});
%                                     scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'k', 'filled' );
%                                     %alpha(.1);
%                                     hold on;
%                                     selectedSpikeIdxs = angularCellData.spikeIdxs.(listOfObservedTrajectories{ii});
%                                     scatter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), floor(spikeData.speed(selectedSpikeIdxs)/speedThreshold)+1, circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:), 'filled'  ); 
%                                     %if length(selectedSpikeIdxs) > 2000; aa=1-log10(length(selectedSpikeIdxs)/10); if aa>1; aa = .01; elseif aa<0; aa=0.01; end; alpha(aa); end
%                                     colormap( ax, circColor ); colorbar; caxis( ax, [0 360] ); axis square; axis([-150 150 -150 150]);
%                                     xlabel(['spike speed phase']);
%                                     title([rat{ratIdx} '  ' folders.(rat{ratIdx}){ffIdx} '  TT' num2str(ttNum) '  '  ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  '  c' num2str(cellId) ' (' angularCellData.turnDir.(listOfObservedTrajectories{ii}) ')' ] );
%                                     ylabel([  (listOfObservedTrajectories{ii}) '   n=' num2str(length(selectedSpikeIdxs)) ' spikes | ' num2str(round(length(selectedTelIdxs)./29.97)) ' s | '  num2str(length(angularCellData.trialList.(listOfObservedTrajectories{ii}))) ' of ' num2str(max(telemetry.trial)) ' trials' ] )
% 
% 
%                                     ax=subplot( subplotDims(1), subplotDims(2) , 2+(2*(ii-1)) );
%                                     % enable double stacking of data
%                                     txx = angularCellData.spikePos.(listOfObservedTrajectories{ii});                                                % x values
%                                     tyy = angularCellData.phases.(listOfObservedTrajectories{ii});                       % y values
%                                     tss = (floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1)';    % size values
%                                     tcc = circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:); % color values
%                                     scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy tyy+360 tyy tyy+360], [tss tss tss tss], [ tcc; tcc; tcc; tcc ], 'filled'  );  hold on;
%                                     if num2str(length(selectedSpikeIdxs)) > 2000; aval=1-log10(length(selectedSpikeIdxs))/10; if aval>1; aval=1; elseif aval<0.01; aval=0.01; end; alpha(aval);  end;
%                                     colormap( ax, circColor ); colorbar; caxis( ax, [0 360] ); axis square; ylim([0 720]); xlim([0 200]);
%                                     rho = angularCellData.circCorrRho.(listOfObservedTrajectories{ii});
%                                     if ~isempty(rho)
%                                         if size(tyy,2) > size(tyy,1)
%                                             tyy=tyy';
%                                         end
%                                         yOffsetFactor=circ_median(deg2rad(tyy));
%                                         for tempi = 0:2:10
%                                             line([ 0 180],[ (-(rho)*(0)+yOffsetFactor+tempi*pi)*180/pi (-(rho)*(180)+yOffsetFactor+tempi*pi)*180/pi], 'Color',[ .3 .3 .3 ],'LineWidth',.5,'LineStyle','--');
%                                         end
%                                     end
%                                     title(['\rho=' num2str(rho) ' p=' num2str(angularCellData.circCorrPval.(listOfObservedTrajectories{ii})) ] );
%                                     xlabel('linearized position'); 
%                                     ylabel('theta phase'); 
% %                                     
% %                                    %           'rat,'          'folder,'                        'TT,'              'unit,'             'region,                                                                                                turnDir,                             nSpikes,                                                                       nSeconds,                                                                                    nTrials,                                                                         totTrials,                         totSeconds,                                        rho,              pval' ];
%                                     message = ([ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str(ttNum) ',' num2str(cellId) ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}, ',' (listOfObservedTrajectories{ii}) ',' num2str(length(angularCellData.phases.(listOfObservedTrajectories{ii}))) ','   num2str(round(length(angularCellData.posIdx.(listOfObservedTrajectories{ii}))./29.97)) ','   num2str(length(angularCellData.trialList.(listOfObservedTrajectories{ii}))) ','  num2str(max(telemetry.trial)) ','  num2str(round(sum(telemetry.onMaze>0)./29.97)) ',' num2str(rho) ',' num2str(angularCellData.circCorrPval.(listOfObservedTrajectories{ii})) ]);
%                                     fprintf( fileID, '%s\n' , message);
%                                  end       

                                figure(101); clf;
                                if length(listOfObservedTrajectories)<=2
                                    for ii=1:length(listOfObservedTrajectories)
                                        % [ left bottom width height ]
                                        % position plot
                                        ax=subplot('position',[0.03 0.04+(.5*(ii-1)) 0.44 0.44 ]); axis square
                                            selectedTelIdxs = telemetry.trial>0;
                                            scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ]  );
                                            hold on;
                                            selectedTelIdxs = angularCellData.posIdx.(listOfObservedTrajectories{ii});
                                            scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'k', 'filled' );
                                            %alpha(.7);
                                            hold on;
                                            selectedSpikeIdxs = angularCellData.spikeIdxs.(listOfObservedTrajectories{ii});
                                            scatter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1, circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:), 'filled'  ); 
                                            alpha(.5);
                                            %if length(selectedSpikeIdxs) > 2000; aa=1-log10(length(selectedSpikeIdxs)/10); if aa>1; aa = .01; elseif aa<0; aa=0.01; end; alpha(aa); end
                                            colormap( ax, circColor ); colorbar; caxis( ax, [0 360] ); axis square; axis([-150 150 -150 150]);
                                            title([rat{ratIdx} '  ' folders.(rat{ratIdx}){ffIdx} '  TT' num2str(ttNum) '  '  ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  '  c' num2str(cellId) ' (' angularCellData.turnDir.(listOfObservedTrajectories{ii}) ')' ] );
                                            ylabel([  (listOfObservedTrajectories{ii}) '   n=' num2str(length(selectedSpikeIdxs)) ' spikes | ' num2str(round(length(selectedTelIdxs)./29.97)) ' s | '  num2str(length(angularCellData.trialList.(listOfObservedTrajectories{ii}))) ' of ' num2str(max(telemetry.trial)) ' trials' ] )
                                        % phase angular position plot
                                        ax=subplot('position',[0.55 0.04+(.5*(ii-1)) 0.39 0.34 ]);
                                        % enable double stacking of data
                                        txx = angularCellData.spikePos.(listOfObservedTrajectories{ii});                                                % x values
                                        tyy = angularCellData.phases.(listOfObservedTrajectories{ii});                       % y values
                                        tss = (floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1)';    % size values
                                        tcc = circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:); % color values
                                        [ estimatedSlope, phaseOffset, circLinCorrCoef, pval ]= phasePositionCorr( angularCellData.phases.(listOfObservedTrajectories{ii}), angularCellData.spikePos.(listOfObservedTrajectories{ii}) );
                                        estimatedSlopeDeg = estimatedSlope *2*pi*180/pi; %gotta convert from cycles per degree or some shit to degrees.
                                        phaseOffsetDeg = phaseOffset * 180/pi;
                                    %line( [0 200  ],[ ((0)*estimatedSlopeDeg + phaseOffsetDeg) ((200)*estimatedSlopeDeg +phaseOffsetDeg)  ], 'LineWidth', 1, 'Color', [ .5 .5 .5 ] );  
                                    hold on;
                                    %line( [0 200  ],[ ((0)*estimatedSlopeDeg + phaseOffsetDeg - 360) ((200)*estimatedSlopeDeg + phaseOffsetDeg - 360)  ], 'LineWidth', 1, 'Color', [ .5 .5 .5 ]  );
                                    line( [0 200  ],[ ((0)*estimatedSlopeDeg + phaseOffsetDeg+360) ((200)*estimatedSlopeDeg + phaseOffsetDeg+360)  ],   'LineWidth', 2, 'Color', [ .5 .5 .5 ], 'LineStyle', '--' );
                                    line( [0 200  ],[ ((0)*estimatedSlopeDeg + phaseOffsetDeg+720) ((200)*estimatedSlopeDeg + phaseOffsetDeg+720)  ],   'LineWidth', 2, 'Color', [ .5 .5 .5 ], 'LineStyle', '--' );
                                    line( [0 200  ],[ ((0)*estimatedSlopeDeg + phaseOffsetDeg+1080) ((200)*estimatedSlopeDeg + phaseOffsetDeg+1080)  ], 'LineWidth', 2, 'Color', [ .5 .5 .5 ], 'LineStyle', '--' );
                                        scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy tyy+360 tyy tyy+360], [tss tss tss tss], [ tcc; tcc; tcc; tcc ], 'filled'  );
                                        if num2str(length(selectedSpikeIdxs)) > 2000; aval=1-log10(length(selectedSpikeIdxs))/10; if aval>1; aval=1; elseif aval<0.01; aval=0.01; end; alpha(aval);  end;
                                        colormap( ax, circColor ); ylim([0 720]); xlim([0 200]); % colorbar; caxis( ax, [0 360] ); 
                                        title(['\rho=' num2str(estimatedSlope) ' Z= ' num2str(circLinCorrCoef) ' p=' num2str(pval) ] );
                                        xlabel('linearized position'); 
                                        ylabel('theta phase'); 
                                        set(gca,'YTick',[]);

                                        % phase preference
                                        ax=subplot('position',[0.48 0.04+(.5*(ii-1)) 0.05 0.35 ]);
                                        plot( histcounts( [ tyy tyy+360 tyy tyy+360], 0:5:720 ), 2.5:5:720); ylim([ 0 720])

                                        % position preference
                                        ax=subplot('position',[0.55 0.41+(.5*(ii-1)) 0.39 0.07 ]);
                                        hold off; yyaxis left;
                                        histogram( angularCellData.spikePos.(listOfObservedTrajectories{ii}), 0:5:200 )
                                        set(gca,'XTick',[], 'YTick',[]);
                                        yyaxis right;
                                        plot( 2.5:5:200, histcounts( angularCellData.spikePos.(listOfObservedTrajectories{ii}), 0:5:200 )./(histcounts( angularCellData.pos.(listOfObservedTrajectories{ii}), 0:5:200 )./29.97), 'LineWidth', 1 )
                                        ylabel('Hz');

                                        % position histogram -- to check wrapping
                                        ax=subplot('position',[0.48 0.42+(.5*(ii-1)) 0.05 0.06 ]);
                                        histogram( angularCellData.pos.(listOfObservedTrajectories{ii}), 0:5:360 ); xlim([ 0 360 ]);
                                        ylabel('freq.');

                                    end

                                else  %if length(listOfObservedTrajectories) > 2 && length(listOfObservedTrajectories) < 5

                                    obs = 1:length(listOfObservedTrajectories);
                                    if obs  > 4
                                        obs=4;
                                        warning(' removed some trajectories due to graphing problems bro.')
                                    end

                                    for ii=1:length(listOfObservedTrajectories)
                                        % [ left bottom width height ]
                                        % position plot
                                        ax=subplot('position',[0.03+(.25*(ii-1)) 0.65 0.22 0.34 ]); axis square
                                            selectedTelIdxs = telemetry.trial>0;
                                            scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ]  );
                                            hold on;
                                            selectedTelIdxs = angularCellData.posIdx.(listOfObservedTrajectories{ii});
                                            scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'k', 'filled' );
                                            %alpha(.5);
                                            hold on;
                                            selectedSpikeIdxs = angularCellData.spikeIdxs.(listOfObservedTrajectories{ii});
                                            scatter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1, circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:), 'filled'  ); 
                                            %if length(selectedSpikeIdxs) > 2000; aa=1-log10(length(selectedSpikeIdxs)/10); if aa>1; aa = .01; elseif aa<0; aa=0.01; end; alpha(aa); end
                                            colormap( ax, circColor ); colorbar; caxis( ax, [0 360] ); axis square; axis([-150 150 -150 150]);
                                            title([rat{ratIdx} '  ' folders.(rat{ratIdx}){ffIdx} '  TT' num2str(ttNum) '  '  ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  '  c' num2str(cellId) ' (' angularCellData.turnDir.(listOfObservedTrajectories{ii}) ')' ] );
                                        % phase angular position plot
                                        ax=subplot('position',[0.062+(.25*(ii-1)) 0.028 0.17 0.5 ]);
                                        % enable double stacking of data
                                        txx = angularCellData.spikePos.(listOfObservedTrajectories{ii});                                                % x values
                                        tyy = angularCellData.phases.(listOfObservedTrajectories{ii});                       % y values
                                        tss = (floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1)';    % size values
                                        tcc = circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:); % color values
                                        scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy tyy+360 tyy tyy+360], [tss tss tss tss], [ tcc; tcc; tcc; tcc ], 'filled'  );  hold on;
                                        if num2str(length(selectedSpikeIdxs)) > 2000; aval=1-log10(length(selectedSpikeIdxs))/10; if aval>1; aval=1; elseif aval<0.01; aval=0.01; end; alpha(aval);  end;
                                        colormap( ax, circColor ); ylim([0 720]); xlim([0 200]); % colorbar; caxis( ax, [0 360] ); 
                                        rho = angularCellData.circCorrRho.(listOfObservedTrajectories{ii});
                                        if ~isempty(rho)
                                            if size(tyy,2) > size(tyy,1)
                                                tyy=tyy';
                                            end
                                            yOffsetFactor=circ_median(deg2rad(tyy));
                                            for tempi = 0:2:10
                                                line([ 0 180],[ (-(rho)*(0)+yOffsetFactor+tempi*pi)*180/pi (-(rho)*(180)+yOffsetFactor+tempi*pi)*180/pi], 'Color',[ .3 .3 .3 ],'LineWidth',.5,'LineStyle','--');
                                            end
                                        end
                                        title(['\rho=' num2str(rho) ' p=' num2str(angularCellData.circCorrPval.(listOfObservedTrajectories{ii})) ] );
                                        xlabel('linearized position'); 
                                        ylabel('theta phase'); 
                                        set(gca,'YTick',[]);

                                        % phase preference
                                        ax=subplot('position',[0.03+(.25*(ii-1)) 0.03 0.029 0.5 ]);
                                        plot( histcounts( [ tyy tyy+360 tyy tyy+360], 0:5:720 ), 2.5:5:720); ylim([ 0 720])

                                        % position preference
                                        ax=subplot('position',[0.062+(.25*(ii-1)) 0.55 0.17 0.05 ]);
                                        hold off; yyaxis left;
                                        histogram( angularCellData.spikePos.(listOfObservedTrajectories{ii}), 0:5:200 )
                                        set(gca,'XTick',[], 'YTick',[]);
                                        yyaxis right;
                                        plot( 2.5:5:200, histcounts( angularCellData.spikePos.(listOfObservedTrajectories{ii}), 0:5:200 )./(histcounts( angularCellData.pos.(listOfObservedTrajectories{ii}), 0:5:200 )./29.97), 'LineWidth', 1  )
                                        ylabel('Hz');
                                        title([  (listOfObservedTrajectories{ii}) '   n=' num2str(length(selectedSpikeIdxs)) ' spikes | ' num2str(round(length(selectedTelIdxs)./29.97)) ' s | '  num2str(length(angularCellData.trialList.(listOfObservedTrajectories{ii}))) ' of ' num2str(max(telemetry.trial)) ' trials' ] )

                                        % position histogram -- to check wrapping
                                        ax=subplot('position',[0.03+(.25*(ii-1)) 0.55 0.028 0.05 ]);
                                        histogram( angularCellData.spikePos.(listOfObservedTrajectories{ii}), 0:5:360 ); xlim([ 0 360 ]);
                                        ylabel('freq.');

                                    end

                                end

%                                print([ basePathOutput 'angularCellData/angularCellData_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' num2str(ttNum) '_'  ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  '_c' num2str(cellId) '.png'],'-dpng','-r200');
% 
%                             catch err
%                                 disp([ 'angularCellData_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' num2str(ttNum) '_'  ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  '_c' num2str(cellId) ]);
%                                 disp(err.identifier);
%                                 warning(err.message);
%                             end
                        end
                    end
                end        
            end
        end
    end
end

fclose(fileID);
% 
% 
% 1    1    1    .8    .6    .2     .1
% [10 100 1000 5000 10000 50000 100000 ]
% 




return;







ax=subplot('position',[0.03 0.53 0.45 0.45 ]); axis square
ax=subplot('position',[0.48 0.53 0.05 0.35 ]);
ax=subplot('position',[0.55 0.53 0.35 0.35 ]);
ax=subplot('position',[0.55 0.92 0.35 0.06 ]);
ax=subplot('position',[0.48 0.92 0.05 0.06 ]);




% [ left bottom width height ]
ax=subplot('position',[0.03 0.03 0.82 0.2]); % subplot( subplotDims(1), subplotDims(2) , 1+(2*(ii-1)) );
selectedTelIdxs = telemetry.trial>0;
scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ]  );
hold on;
selectedTelIdxs = angularCellData.posIdx.(listOfObservedTrajectories{ii});
scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 12, 'k', 'filled' );
%alpha(.1);
hold on;
selectedSpikeIdxs = angularCellData.spikeIdxs.(listOfObservedTrajectories{ii});
scatter( spikeData.x(selectedSpikeIdxs), spikeData.y(selectedSpikeIdxs), floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1, circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:), 'filled'  ); 
%if length(selectedSpikeIdxs) > 2000; aa=1-log10(length(selectedSpikeIdxs)/10); if aa>1; aa = .01; elseif aa<0; aa=0.01; end; alpha(aa); end
colormap( ax, circColor ); colorbar; caxis( ax, [0 360] ); axis square; axis([-150 150 -150 150]);
xlabel(['spike speed phase']);
title([rat{ratIdx} '  ' folders.(rat{ratIdx}){ffIdx} '  TT' num2str(ttNum) '  '  ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum}  '  c' num2str(cellId) ' (' angularCellData.turnDir.(listOfObservedTrajectories{ii}) ')' ] );
ylabel([  (listOfObservedTrajectories{ii}) '   n=' num2str(length(selectedSpikeIdxs)) ' spikes | ' num2str(round(length(selectedTelIdxs)./29.97)) ' s | '  num2str(length(angularCellData.trialList.(listOfObservedTrajectories{ii}))) ' of ' num2str(max(telemetry.trial)) ' trials' ] )


ax=subplot( subplotDims(1), subplotDims(2) , 2+(2*(ii-1)) );
% enable double stacking of data
txx = angularCellData.spikePos.(listOfObservedTrajectories{ii});                                                % x values
tyy = angularCellData.phases.(listOfObservedTrajectories{ii});                       % y values
tss = (floor(spikeData.speed(selectedSpikeIdxs)/speedThresholdSize)+1)';    % size values
tcc = circColor(floor(spikeData.thetaPhase(selectedSpikeIdxs))+1,:); % color values
scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy tyy+360 tyy tyy+360], [tss tss tss tss], [ tcc; tcc; tcc; tcc ], 'filled'  );  hold on;
if num2str(length(selectedSpikeIdxs)) > 2000; aval=1-log10(length(selectedSpikeIdxs))/10; if aval>1; aval=1; elseif aval<0.01; aval=0.01; end; alpha(aval);  end;
colormap( ax, circColor ); colorbar; caxis( ax, [0 360] ); axis square; ylim([0 720]); xlim([0 200]);
rho = angularCellData.circCorrRho.(listOfObservedTrajectories{ii});
if ~isempty(rho)
    if size(tyy,2) > size(tyy,1)
        tyy=tyy';
    end
    yOffsetFactor=circ_median(deg2rad(tyy));
    for tempi = 0:2:10
        line([ 0 180],[ (-(rho)*(0)+yOffsetFactor+tempi*pi)*180/pi (-(rho)*(180)+yOffsetFactor+tempi*pi)*180/pi], 'Color',[ .3 .3 .3 ],'LineWidth',.5,'LineStyle','--');
    end
end
title(['\rho=' num2str(rho) ' p=' num2str(angularCellData.circCorrPval.(listOfObservedTrajectories{ii})) ] );
xlabel('linearized position'); 
ylabel('theta phase'); 






%figure; plot(telemetry.x);hold on; plot(telemetry.y); plot(telemetry.onMaze*100); plot(telemetry.trial);




% 
% 
% % this figure combines the trajectories onto one angular position by phase plot
% figure;
% % enable double stacking of data
% txx = [ angularCellData.spikePos.en angularCellData.spikePos.es ];    % x values
% tyy = [ angularCellData.phases.en angularCellData.phases.es ];        % y values
% tss = floor(spikeData.speed([angularCellData.spikeIdxs.en angularCellData.spikeIdxs.es ])/speedThresholdSize)+1;                             % size values
% tcc = circColor(floor(tyy)+1,:);                                      % color values
% scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy tyy+360 tyy tyy+360], [tss; tss; tss; tss], [ tcc; tcc; tcc; tcc ], 'filled'  );  hold on;
% %scatter( trialAngle, spikeData.thetaPhase(thisSpikeFileIdxs(idxB)), floor(spikeData.speed(thisSpikeFileIdxs(idxB))/speedThresholdSize)+1, circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxB)))+1,:), 'filled' ); hold on;
% colormap( circColor ); colorbar; caxis( [0 360] ); axis square; ylim([0 720]); xlim([0 180]);
% xlabel('linearized position');
% ylabel('theta phase');
% 
% 
% 
% % this figure shows the angularized coding as color on the XY plot
% figure;
% txx = telemetry.x(angularCellData.posIdx.en);
% tyy = telemetry.y(angularCellData.posIdx.en);
% cm  = colormap('jet');
% %tcc =  floor( (length(cm)-1)*(angularCellData.pos.en/max(angularCellData.pos.en)) )+1; % floor(angularCellData.pos.en)+1; %
% tcc =  floor( (length(cm)-1)*(angularCellData.pos.en/180) )+1;
% tcc(tcc>length(cm)) = 1; % this is hard wrapping some things off the end of the world back onto the range I want.
% scatter( txx, tyy, 5, cm(tcc,:), 'filled');
% hold on;
% txx = telemetry.x(angularCellData.posIdx.es);
% tyy = telemetry.y(angularCellData.posIdx.es);
% cm  = colormap('jet');
% tcc =  floor( (length(cm)-1)*(angularCellData.pos.es/180) )+1; % floor(angularCellData.pos.en)+1; %
% tcc(tcc>length(cm)) = 1;
% scatter( txx, tyy, 5, cm(tcc,:), 'filled');
% colorbar; colormap(cm); caxis([0 180]); axis square; axis([ -150 150 -150 150 ])
% 






%  size( trialSpeeds > speedThreshold )
%  size( trialRadius < 105 )
%  size( trialRadius > 55 )
%  size( movDirLimits(1) <= trialMovDirs )
%  size( movDirLimits(2) >= trialMovDirs )
%  size( movDirLimits(3) <= trialMovDirs )
%  size( movDirLimits(4) >= trialMovDirs )
 