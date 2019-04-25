function direction = calculateDirection( xpos, ypos, lagTime, framesPerSecond )
    
    if nargin < 4
        framesPerSecond = 29.97; % neuralynx default.
    end
    
    if nargin < 3
        lagTime = 1.5; % second
    end

    lagCenterIdx = round(lagTime*framesPerSecond); % neuralynx default.

    lagFrames = lagCenterIdx-5:lagCenterIdx+5; % frames; this is to mitigate jumps that may occur
    laggedDir = zeros(length(lagFrames), length(xpos));
    for ii = 1 : length(lagFrames)
        for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
            % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
            laggedDir(ii,jj) = atan( ( ypos(jj+lagFrames(ii)) - ypos(jj-lagFrames(ii)) ) / ( xpos(jj+lagFrames(ii)) - xpos(jj-lagFrames(ii)) ) );
        end
    end

    direction = median(laggedDir)*(180/pi);

    return;

end
