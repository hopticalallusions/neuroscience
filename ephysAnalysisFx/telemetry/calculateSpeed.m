function [ speed, direction ] = calculateSpeed( xpos, ypos, lagTime, pxPerCm, framesPerSecond )

% This function calculates speed by generating estimates across a wide
% range of intervals. It then predicts the next position from the current
% using speed estimates from every interval. The interval that produces the
% most accurate position estimate is used as the speed. This is effectively
% a variable interval estimation scheme that is sensitive to the speed of
% the animal.
%
% It is not biased by the fact that it is predicting one step ahead; the
% speed estimation is based on a symmetric distance traveled around the
% current point, which is different from the reference below. (The
% reference below is designed for real-time prediction, so it cannot
% operate on the same design.)
%
% This implementation is not at all optimized, 
% but it runs fairly quickly anyway.
% 
% F Janabi-Sharifi, V Hayward, & CSJ Chen.
% "Discrete-Time Adaptive Windowing for Velocity Estimation."
% IEEE TRANSACTIONS ON CONTROL SYSTEMS TECHNOLOGY 8(6):1003-1009; Nov 2000



    if nargin < 4
        warning('NO cm/px value provided!! returning px/s!')
        pxPerCm = 1;
    end
    
    if nargin < 5
        %warning('framesPerSecond defaulted to 29.97.')
        framesPerSecond = 29.97; % neuralynx default.
    end
    
    if nargin < 3
        lagTime = 0.5; % second
    end
    

    lagFrames = 1:25;
    
    laggedYSpeed = zeros(length(lagFrames), length(ypos));
    for ii = 1 : length(lagFrames)
        for jj=lagFrames(ii)+1:length(ypos)-lagFrames(ii)
            % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
            laggedYSpeed(ii,jj) = ( ypos(jj+lagFrames(ii)) - ypos(jj-lagFrames(ii)) ) * (1/(2*lagFrames(ii))) * 1/pxPerCm * framesPerSecond;
        end
    end
    % figure; plot(laggedSpeed(:, (1:1e3)+1e4 )');
    % legend('1','2','3','4','5','6')
    predictedYs = zeros(length(lagFrames),length(ypos));
    predictedYsErrs = predictedYs;
    bestYSpeedIdx = zeros(1,length(ypos));
    bestYSpeed = zeros(1,length(ypos));
    errDistanceY =  zeros(1,length(ypos));
    for ii = 2:length(ypos)
        predictedYs(:,ii) = ypos(ii-1)*ones(length(lagFrames),1)+(laggedYSpeed(:,ii)*pxPerCm/framesPerSecond);
        predictedYsErrs(:,ii) = ypos(ii)*ones(length(lagFrames),1) - predictedYs(:,ii);
        [errDistanceY(ii),bestYSpeedIdx(ii)] = min(abs(predictedYsErrs(:,ii)));
        bestYSpeed(ii) = laggedYSpeed(bestYSpeedIdx(ii),ii);
    end
    
    
    laggedXSpeed = zeros(length(lagFrames), length(ypos));
    for ii = 1 : length(lagFrames)
        for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
            % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
            laggedXSpeed(ii,jj) = ( xpos(jj+lagFrames(ii)) - xpos(jj-lagFrames(ii)) ) * (1/(2*lagFrames(ii))) * 1/pxPerCm * framesPerSecond;
        end
    end
    % figure; plot(laggedSpeed(:, (1:1e3)+1e4 )');
    % legend('1','2','3','4','5','6')
    predictedXs = zeros(length(lagFrames),length(xpos));
    predictedXsErrs = predictedXs;
    bestXSpeedIdx = zeros(1,length(xpos));
    bestXSpeed = zeros(1,length(xpos));
    errDistanceX =  zeros(1,length(xpos));
    for ii = 2:length(ypos)
        predictedXs(:,ii) = ypos(ii-1)*ones(length(lagFrames),1)+(laggedXSpeed(:,ii)*pxPerCm/framesPerSecond);
        predictedXsErrs(:,ii) = ypos(ii)*ones(length(lagFrames),1) - predictedXs(:,ii);
        [errDistanceX(ii),bestXSpeedIdx(ii)] = min(abs(predictedXsErrs(:,ii)));
        bestXSpeed(ii) = laggedXSpeed(bestXSpeedIdx(ii),ii);
    end
    
    
    speed = sqrt( bestXSpeed.^2 + bestYSpeed.^2 );
    
    direction = atan( bestYSpeed ./ bestXSpeed );
    
    return;

end



%% an averaging solution
% 
% lagTime = .5
%     lagCenterIdx = round(lagTime*framesPerSecond); 
%     if ( lagCenterIdx < 3 ); lagCenterIdx = 3; end;
%     lagFrames = lagCenterIdx-2:lagCenterIdx+2; % frames; this is to mitigate jumps that may occur
%     laggedSpeed = zeros(length(lagFrames), length(xpos));
%     for ii = 1 : length(lagFrames)
%         for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
%             % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%             laggedSpeed(ii,jj) = sqrt( ( ypos(jj+lagFrames(ii)) - ypos(jj-lagFrames(ii)) ).^2 + ( xpos(jj+lagFrames(ii)) - xpos(jj-lagFrames(ii)) ).^2 ) * (1/(2*lagFrames(ii))) * 1/pxPerCm * framesPerSecond;
%         end
%     end
%     speed = median(laggedSpeed);
%         


%% a variety of experiments on this are below.

%%
% this is for looking at the way speed is calculated across the different
% delays. 
%
%     %figure; histogram((laggedSpeed(1,:)),0:2:120); hold on; histogram((laggedSpeed(2,:)),0:2:120); histogram((laggedSpeed(3,:)),0:2:120); histogram((laggedSpeed(4,:)),0:2:120); histogram((laggedSpeed(5,:)),0:2:120); histogram((speed),0:2:120);
%     figure; plot(mean(laggedSpeed),'k', 'LineWidth', 1.5); hold on; plot(median(laggedSpeed),'r', 'LineWidth', 1.5); plot(laggedSpeed');
%     plot(mean(laggedSpeed)-median(laggedSpeed));
%     plot((laggedSpeed(3,:))-median(laggedSpeed));
%     
%     figure;
%     histogram(mean(laggedSpeed)-median(laggedSpeed),-10:10); hold on;
%     histogram((laggedSpeed(3,:))-median(laggedSpeed),-10:10);
%     
%     figure;
%     histogram(diff(mean(laggedSpeed)),-10:10); hold on;
%     histogram(diff(median(laggedSpeed)),-10:10); 


%% previous method
%
%     if round(lagTime*framesPerSecond) > 5
%         lagCenterIdx = round(lagTime*framesPerSecond); 
% 
%         lagFrames = lagCenterIdx-5:lagCenterIdx+5; % frames; this is to mitigate jumps that may occur
%         laggedSpeed = zeros(length(lagFrames), length(xpos));
%         for ii = 1 : length(lagFrames)
%             for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
%                 % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%                 laggedSpeed(ii,jj) = sqrt( ( ypos(jj+lagFrames(ii)) - ypos(jj-lagFrames(ii)) ).^2 + ( xpos(jj+lagFrames(ii)) - xpos(jj-lagFrames(ii)) ).^2 ) * (1/(2*lagFrames(ii))) * 1/pxPerCm * framesPerSecond;
%             end
%         end
%     else
%         lagCenterIdx = 4;
%         lagFrames = lagCenterIdx-3:lagCenterIdx+3; % frames; this is to mitigate jumps that may occur
%         laggedSpeed = zeros(length(lagFrames), length(xpos));
%         for ii = 1 : length(lagFrames)
%             for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
%                 % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%                 laggedSpeed(ii,jj) = sqrt( ( ypos(jj+lagFrames(ii)) - ypos(jj-lagFrames(ii)) ).^2 + ( xpos(jj+lagFrames(ii)) - xpos(jj-lagFrames(ii)) ).^2 ) * (1/(2*lagFrames(ii))) * 1/pxPerCm * framesPerSecond;
%             end
%         end
%     end
    


%% % instantaneous speed calculation -- 1 frame in either direction

% instantSpeed = zeros(size(xpos));
% for jj=2:length(xpos)-1
% 	% px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%     instantSpeed(jj) = sqrt( ( ypos(jj-1) - ypos(jj+1) ).^2 + ( xpos(jj-1) - xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
% end


% %% lagged speed by 2 s

% lagSpeed = zeros(size(xpos));
% for jj=31:length(xpos)-31
% 	% px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%     lagSpeed(jj) = sqrt( ( ypos(jj-29) - ypos(jj+30) ).^2 + ( xpos(jj-30) - xpos(jj+29) ).^2 ) * (1/60) * 1/2.75 * 29.97;
% end


%% smoothed instantaneous speed

% dx = zeros(size(xpos));
% dy = zeros(size(ypos));
% for jj=2:length(xpos)-1
%     dy(jj)=( ypos(jj-1) - ypos(jj+1) );
%     dx(jj)=( xpos(jj-1) - xpos(jj+1) );
% end
% boxcarSize = 45;  % samples
% dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
% dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
% dxy = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;  % sqrt() * ?? * 1/pxPerCm * framesPerSec







%%
% 
% velocity = [ 0; diff(sqrt( (xpos.^2) + (ypos.^2)))]*4/30;  % cm/s
% speed = [ 0; sqrt( diff(xpos).^2 + diff(ypos).^2 )]; % pixels per frame
% 
% 
% xSpeed = abs(diff(xpos));
% ySpeed = abs(diff(ypos));
% speed = [ 0; sqrt( diff(xpos).^2 + diff(ypos).^2 )]; % pixels per frame
% 
% framesPerSecond = 30;
% lagFrames = [ 60 90 120 150 180 210 ]; % frames
% laggedSpeed = zeros(length(lagFrames), length(xpos));
% for ii = 1 : length(lagFrames)
%     for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
%         % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%         laggedSpeed(ii,jj) = sqrt( ( ypos(jj) - ypos(jj-lagFrames(ii)) ).^2 + ( xpos(jj) - xpos(jj-lagFrames(ii)) ).^2 ) * (1/lagFrames(ii)) * 1/pxPerCm * framesPerSecond;
%     end
% end
% 
% 
% 
% 
% circa=1; frameRate = 30;
% spikeTriggeredSpeedEstimate = zeros(size(idxs));
% for ii=1:length(idxs)
%     endIdx=idxs(ii)+(circa*frameRate);
%     if endIdx > length(xpos)
%         endIdx = length(xpos);
%     end
%     beginIdx=idxs(ii)-(circa*frameRate);
%     if beginIdx < 1
%         beginIdx = 1;
%     end
%     numFrames = abs( endIdx - beginIdx + 1);
%     xDisplacement = xpos( endIdx ) - xpos( beginIdx );
%     yDisplacement = ypos( endIdx ) - ypos( beginIdx );
%     spikeTriggeredSpeedEstimate(ii) = sqrt(xDisplacement^2 + yDisplacement^2)  * (1/(numFrames)) * 1/pxPerCm * framesPerSecond;
% end

% smoothFactor=10;
% smoothSpeed = speed;
% for ii = (smoothFactor+1):length(smoothSpeed)-(smoothFactor+1)
%     smoothSpeed(ii) = median(smoothSpeed(ii-smoothFactor:ii+smoothFactor));
% end
% 


%
%% COULD filter, but this tends to introduce negative values, which is not
% desireable.
%
% xyFilter = designfilt( 'lowpassiir',                     ...
%                        'FilterOrder',              8  , ...
%                        'PassbandFrequency',        .5  , ...
%                        'PassbandRipple',           0.2, ...
%                        'SampleRate',              30    );
% filteredSpeed = filtfilt( xyFilter, filteredSpeed );


% 
% figure; plot(laggedSpeed'); hold on; plot (mean(laggedSpeed), 'k', 'LineWidth', 2); plot (median(laggedSpeed), 'r--', 'LineWidth', 2);
% smoothedSpeedEstimate=median(laggedSpeed);
% 
% 
% [ peakValues, ...
%   peakTimes, ...
%   peakProminances, ...
%   peakWidths ] = findpeaks(  ...
%                           1./smoothedSpeedEstimate,    ... % data
%                           30,                 ... % sampling frequency
%                           'MinPeakHeight',   1/5, ... % default 95th percentile peak height
%                           'MinPeakDistance', 1  ); % 
% figure; plot( (1:length(smoothedSpeedEstimate))/30, smoothedSpeedEstimate); hold on; plot(peakTimes,1./peakValues,'o');


%% peri-event method
% 
% % take the idxs and generate a peri-firing speed estimate
% circa=1; frameRate = 30;
% spikeTriggeredSpeedEstimate = zeros(size(idxs));
% for ii=1:length(idxs)
%     endIdx=idxs(ii)+(circa*frameRate);
%     if endIdx > length(xpos)
%         endIdx = length(xpos);
%     end
%     beginIdx=idxs(ii)-(circa*frameRate);
%     if beginIdx < 1
%         beginIdx = 1;
%     end
%     numFrames = abs( endIdx - beginIdx + 1);
%     xDisplacement = xpos( endIdx ) - xpos( beginIdx );
%     yDisplacement = ypos( endIdx ) - ypos( beginIdx );
%     spikeTriggeredSpeedEstimate(ii) = sqrt(xDisplacement^2 + yDisplacement^2)  * (1/(numFrames)) * 1/pxPerCm * framesPerSecond;
% end