function speed = calculateSpeed( xpos, ypos, lagTime, pxPerCm, framesPerSecond )

    if nargin < 4
        warning('NO cm/px value provided!! returning px/s!')
        pxPerCm = 1;
    end
    
    if nargin < 5
        warning('framesPerSecond defaulted to 29.97.')
        framesPerSecond = 29.97; % neuralynx default.
    end
    
    if nargin < 3
        lagTime = 1.5; % second
    end

    lagCenterIdx = round(lagTime*framesPerSecond); % neuralynx default.

    lagFrames = lagCenterIdx-5:lagCenterIdx+5; % frames; this is to mitigate jumps that may occur
    laggedSpeed = zeros(length(lagFrames), length(xpos));
    for ii = 1 : length(lagFrames)
        for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
            % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
            laggedSpeed(ii,jj) = sqrt( ( ypos(jj+lagFrames(ii)) - ypos(jj-lagFrames(ii)) ).^2 + ( xpos(jj+lagFrames(ii)) - xpos(jj-lagFrames(ii)) ).^2 ) * (1/lagFrames(ii)) * 1/pxPerCm * framesPerSecond;
        end
    end

    speed = median(laggedSpeed);

    return;

end

%% a variety of experiments on this are below.













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
% COULD filter, but this tends to introduce negative values, which is not
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