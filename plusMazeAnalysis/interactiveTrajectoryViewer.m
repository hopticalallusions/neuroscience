rat = { 'h5' 'h7' }; %{ 'da5' 'da10' 'h5' 'h7' 'h1' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' '2016-09-01' '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04' '2018-09-05' '2018-09-06' '2018-09-08' '2018-09-09' '2018-09-14' };

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';

linearizationCircleCenter.x=60;
linearizationCircleCenter.y=60;
speedThreshold = 3;
rejectedTrials = 0;

close all;
for ratIdx =   1:length( rat )
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');            
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
                    rejectedTrials = rejectedTrials + 1;
                    figure;
                    plot(telemetry.x(trialStartIdx:trialEndIdx),telemetry.y(trialStartIdx:trialEndIdx)); hold on;
                    scatter(telemetry.x(trialStartIdx),telemetry.y(trialStartIdx),'>','g','filled');
                    scatter(telemetry.x(trialEndIdx),telemetry.y(trialEndIdx),'s', 'r', 'filled');
                    title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ]);
                    axis([ -150 150 -150 150]); axis square;
                    break;
                end
                % now that we can tell the trial ends somewhere uesful
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
                figure(101);
                clf;
                drawnow;
                pause(.1);
                hold off;
                tidx=max([ 1 trialStartIdx-200]):trialStartIdx;
                plot( telemetry.x(tidx), telemetry.y(tidx), 'b' );
                hold on;
                tidx=trialStartIdx:trialEndIdx;
                plot( telemetry.x(tidx), telemetry.y(tidx), 'k' );
                tidx = trialEndIdx:min([ trialEndIdx+200 length(telemetry.x)]);
                plot( telemetry.x(tidx), telemetry.y(tidx), 'r' );
                scatter( telemetry.x(idxFirstAtRewardZone), telemetry.y(idxFirstAtRewardZone), 'x', 'm' )
                scatter( telemetry.x(trialStartIdx), telemetry.y(trialStartIdx), '>', 'g', 'filled' )
                scatter( telemetry.x(trialEndIdx), telemetry.y(trialEndIdx), 's', 'r', 'filled' )
                axis([ -150 150 -150 150]); axis square;
                title([rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ' ' startLoc endLoc ])
                drawnow;
                [x,y,button]=ginput(1);
             %   startIdx:idxFirstAtRewardZone
            end
        end
    end
end

%figure; plot(telemetry.x);hold on; plot(telemetry.y); plot(telemetry.onMaze*100); plot(telemetry.trial);