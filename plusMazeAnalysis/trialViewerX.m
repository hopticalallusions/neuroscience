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


basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';


speedThreshold = 3;
rejectedTrials = 0;

for ratIdx =  1:length( rat )
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            
                            % NOW PROCESS EVERY TRIAL
                            
                            figure(102);
%                            subplot(1,3,1);
%                            hold off; scatter( telemetry.x, telemetry.y, 'k', 'filled' ); hold on; axis square; axis([-150 150 -150 150]);
                            subplot(1,2,1);
                            hold off; scatter( telemetry.x, telemetry.y, 'MarkerFaceColor', [ .2 .2 .2 ],'MarkerEdgeColor', [ .2 .2 .2 ] ); hold on; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 'k', 'filled' );  hold on; axis square; axis([-150 150 -150 150]);
                            subplot(1,2,2);
                            hold off; scatter( telemetry.x, telemetry.y, 'MarkerFaceColor', [ .2 .2 .2 ],'MarkerEdgeColor', [ .2 .2 .2 ] ); hold on; scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 'k', 'filled' ); hold on; axis square; axis([-150 150 -150 150]);
                            
                            nTrajectoryIdxs = 0;
                            nAngularizedIdxs = 0;
                            
                            for trialIdx = 1:max(telemetry.trial)
                                % obtain start and end indices for the trial
                                trialStartIdx = find(telemetry.trial == trialIdx, 1, 'first');
                                trialEndIdx = find(telemetry.trial == trialIdx, 1, 'last');
                                % set half of the central location based on the start
                                if telemetry.x(trialStartIdx) > 60  
                                    startLoc = 'E';  % east and west are flipped in the data, relative to what we always labelled
                                elseif telemetry.x(trialStartIdx) < -60 
                                    startLoc = 'W';
                                elseif telemetry.y(trialStartIdx) > 60
                                    startLoc = 'N';
                                elseif telemetry.y(trialStartIdx) < -60
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
                                
                                idxFirstAtRewardZone=trialStartIdx+find( sqrt( (telemetry.x(trialStartIdx:trialEndIdx)-telemetry.x(trialStartIdx)).^2 + (telemetry.y(trialStartIdx)-telemetry.y(trialStartIdx)).^2 ) > 90 & ( sqrt( (0-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (100-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold | sqrt( (100-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (0-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold ),1,'first');
                                % if this yields no results, the trial is a bust
                                while isempty(idxFirstAtRewardZone)
                                    rewardDistanceThreshold = rewardDistanceThreshold + 5;
                                    if rewardDistanceThreshold > 40;
                                        break;
                                    end
                                    idxFirstAtRewardZone=trialStartIdx+find( sqrt( (telemetry.x(trialStartIdx:trialEndIdx)-telemetry.x(trialStartIdx)).^2 + (telemetry.y(trialStartIdx)-telemetry.y(trialStartIdx)).^2 ) > 90 & ( sqrt( (0-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (100-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold | sqrt( (100-abs(telemetry.x(trialStartIdx:trialEndIdx))).^2 + (0-abs(telemetry.y(trialStartIdx:trialEndIdx))).^2 ) < rewardDistanceThreshold ),1,'first');
                                end 
                                    
                                 if isempty(idxFirstAtRewardZone)
                                     disp([ 'rat did not complete trial ' rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ]);
                            %         rejectedTrials = rejectedTrials + 1;
                            %         figure;
                            %         plot(telemetry.x(trialStartIdx:trialEndIdx),telemetry.y(trialStartIdx:trialEndIdx)); hold on;
                            %         scatter(telemetry.x(trialStartIdx),telemetry.y(trialStartIdx),'>','g','filled');
                            %         scatter(telemetry.x(trialEndIdx),telemetry.y(trialEndIdx),'s', 'r', 'filled');
                            %         title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ]);
                            %         axis([ -150 150 -150 150]); axis square;
                                     break;
                                 end
                                 
                                
                                % now that we know the trial ends somewhere
                                % uesful, but where?
                                %
                                if telemetry.x(idxFirstAtRewardZone) > 60
                                    endLoc = 'E';
                                elseif telemetry.x(idxFirstAtRewardZone) < -60 
                                    endLoc = 'W';
                                elseif  telemetry.y(idxFirstAtRewardZone) > 70
                                    endLoc = 'N';
                                elseif  telemetry.y(idxFirstAtRewardZone) < -70
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
                                   disp ('boooo'); 
                                end
                                % set the linearization correction switch (for e.g. EN, rat is traveling "backwards" in degrees)
                                % alo set up the direction filter. it will have
                                % some redundancies
                                if strcmp( [ startLoc endLoc], 'NE')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [    0  15  255 360  ];
                                elseif strcmp( [ startLoc endLoc], 'NW')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [    0 105  345 360  ];
                                elseif strcmp( [ startLoc endLoc], 'SE')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [  165 285  165 285  ];
                                elseif strcmp( [ startLoc endLoc], 'SW')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [   75 195   75 195 ];
                                elseif strcmp( [ startLoc endLoc], 'EN')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [   75 195   75 195  ];
                                elseif strcmp( [ startLoc endLoc], 'WN')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [  165 285  165 285 ];
                                elseif strcmp( [ startLoc endLoc], 'ES')
                                    flipLinearization = false;
                                    turnDir = 'left';
                                    movDirLimits = [    0 105  345 360 ];
                                elseif strcmp( [ startLoc endLoc], 'WS')
                                    flipLinearization = true;
                                    turnDir = 'right';
                                    movDirLimits = [  255 360    0  15 ];
                                else
                                    flipLinearization = false;
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
                                validTrialMask = ( ( trialSpeeds > speedThreshold ) & ( trialRadius < 105 ) & ( trialRadius > 55 )) & (( movDirLimits(1) <= trialMovDirs ) & ( movDirLimits(2) >= trialMovDirs ) ) | ( ( movDirLimits(3) <= trialMovDirs ) & ( movDirLimits(4) >= trialMovDirs ));
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
                                if trialEndIdx<trialStartIdx
                                    disp([ rat{ratIdx} ' day ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ])
                                end
                                
                                subplot(1,2,1);
                                scatter( telemetry.x(trialStartIdx:trialEndIdx), telemetry.y(trialStartIdx:trialEndIdx), 2, 'filled' );
                                subplot(1,2,2);
                                scatter( telemetry.x(thisTrialIdxs(validTrialMask)), telemetry.y(thisTrialIdxs(validTrialMask)), 2, 'filled'  ); 
                                
                                nTrajectoryIdxs = nTrajectoryIdxs + (trialEndIdx-trialStartIdx);
                                nAngularizedIdxs = nAngularizedIdxs +sum(validTrialMask) ;
                                
                            end
                            subplot(1,2,1); title([ rat{ratIdx} ' day ' folders.(rat{ratIdx}){ffIdx} ]);
                            subplot(1,2,2); title([ 'traj/onMaze ' num2str(round(100*nTrajectoryIdxs/sum(telemetry.onMaze>0))) '%  ang/traj ' num2str(round(100*nAngularizedIdxs/nTrajectoryIdxs))  '%' ]);
                            
                            [x,y,button]=ginput(1);

        end
    end
end
