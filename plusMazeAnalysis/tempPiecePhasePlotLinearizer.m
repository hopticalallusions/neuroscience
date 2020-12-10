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
%         rejectedTrials = rejectedTrials + 1;
%         figure;
%         plot(telemetry.x(trialStartIdx:trialEndIdx),telemetry.y(trialStartIdx:trialEndIdx)); hold on;
%         scatter(telemetry.x(trialStartIdx),telemetry.y(trialStartIdx),'>','g','filled');
%         scatter(telemetry.x(trialEndIdx),telemetry.y(trialEndIdx),'s', 'r', 'filled');
%         title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' trial ' num2str(trialIdx) ]);
%         axis([ -150 150 -150 150]); axis square;
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
                            %
                            % linearized angular position window size :
                            %   the whole run thus fits in a ~160 degree
                            %   window, but this window will shift
                            angPosWindowSize = 170; % degrees  see ;; P0 = [ 60,  60]; P1 = [130,   0]; P2 = [  0, 130]; n1 = (P2 - P0) / norm(P2 - P0); n2 = (P1 - P0) / norm(P1 - P0); atan2(norm(det([n2; n1])), dot(n1, n2))*180/pi 
                            %
                            % set the center position and angular offset
                            if strcmp( [ startLoc endLoc], 'NE') || strcmp( [ startLoc endLoc], 'EN')
                                linearizationCircleCenter.x=60;
                                linearizationCircleCenter.y=60;
                                angPosOffset = 
                                % depending on 
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
                            % linearize the position
                            thisTrialIdxs = trialStartIdx:idxFirstAtRewardZone;
                            % this angular position is shifted and
                            % converted to be on the range [0, 360 ]
                            % degrees
                            [ trialAngleRads, trialRadius ] = cart2pol( telemetry.x(thisTrialIdxs)-linearizationCircleCenter.x, telemetry.y(thisTrialIdxs)-linearizationCircleCenter.y );
                            trialSpeeds = telemetry.speed(thisTrialIdxs);
                            trialAngle = (trialAngleRads+pi)*180/pi;
                            % TODO do a complete job of reorganizing the
                            % variables for plotting by comparing their
                            % size(1) and size(2)
                            if size(trialSpeeds) ~= size(trialAngle)
                                trialSpeeds = trialSpeeds';
                            end
                            %
                            % re-filter this result
                            %
                            % speed filter
                            %
                            % estimated the maximum allowed radius as ~105 cm; somewhat
                            % depends on which quadrant he is in, but I'm going to sort
                            % of ignore that.
                            %
                            % minimum allowed radius 55 cm
                            validTrialMask = ( ( trialSpeeds > speedThreshold ) & ( trialRadius < 105 ) & ( trialRadius > 55 ));
                            trialAngle = trialAngle((validTrialMask));
                            trialRadius = trialRadius((validTrialMask));
                            %
                            % so now we have screened trajectories
                            %
                            % now I need to obtain spike data
                            % 
                            thisTrialTimeTelemetryResolution = floor(telemetry.xytimestampSeconds(thisTrialIdxs(validTrialMask)) * 29.97);
                            % intersect the telemetry resolution time data
                            % to pull out the indices to the relevant spikes
                            [ values, idxA, idxB ] = intersect( thisTrialTimeTelemetryResolution, thisSpikeTimesTelemetryResolution );
                            
                            
                            % select the appropriate graph
                            % select the appropriate graph
                            if strcmp( [ startLoc endLoc], 'NE')
                                sp = 1;
                            elseif strcmp( [ startLoc endLoc], 'NW')
                                sp = 2;
                            elseif strcmp( [ startLoc endLoc], 'SE')
                                sp = 3;
                            elseif strcmp( [ startLoc endLoc], 'SW')
                                sp = 4;
                            elseif strcmp( [ startLoc endLoc], 'EN')
                                sp = 5;
                            elseif strcmp( [ startLoc endLoc], 'WN')
                                sp = 6;
                            elseif strcmp( [ startLoc endLoc], 'ES')
                                sp = 7;
                            elseif strcmp( [ startLoc endLoc], 'WS')
                                sp = 8;
                            else
                                sp = 9;
                            end
                            
                            figure(101);
                            ax(sp)=subplot(3,3,sp);
                            % enable double stacking of data
                            txx = trialAngle(idxA);                                                    % x values
                            tyy = spikeData.thetaPhase(thisSpikeFileIdxs(idxB));                       % y values
                            tss = floor(spikeData.speed(thisSpikeFileIdxs(idxB))/speedThreshold)+1;    % size values
                            tcc = circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxB)))+1,:); % color values
                            scatter( [txx txx txx+2*pi txx+2*pi ], [ tyy; tyy+360; tyy; tyy+360], [tss; tss; tss; tss], [ tcc; tcc; tcc; tcc ], 'filled'  );  hold on;
                            %scatter( trialAngle, spikeData.thetaPhase(thisSpikeFileIdxs(idxB)), floor(spikeData.speed(thisSpikeFileIdxs(idxB))/speedThreshold)+1, circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxB)))+1,:), 'filled' ); hold on;
                            colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; ylim([0 720])
                            xlabel('linearized position');
                            ylabel('theta phase');
                            
                            
                            selectedTelIdxs = trialStartIdx:idxFirstAtRewardZone;
                            figure(102);
                            ax(sp)=subplot(3,3,sp);
                            %scatter( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 'k', 'filled' ); alpha(.2); hold on;
                            plot( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), 'Color', [ 0 0 0 .1 ] ); hold on;
                            scatter( spikeData.x(thisSpikeFileIdxs(idxB)), spikeData.y(thisSpikeFileIdxs(idxB)), floor(spikeData.speed(thisSpikeFileIdxs(idxB))/speedThreshold)+1, circColor(floor(spikeData.thetaPhase(thisSpikeFileIdxs(idxB)))+1,:), 'filled'  ); alpha(.3);
                            colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; axis([-150 150 -150 150]);
                            title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} '  ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '  TT' num2str(ttNum) ' c' num2str(cellId)    ])
                            xlabel(['spike speed phase']);

                            
                            
                        end