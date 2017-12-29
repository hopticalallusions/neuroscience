function accel = calculateAcceleration( speed, lagTime, pxPerCm, framesPerSecond )


    if nargin < 3
        warning('NO cm/px value provided!! returning px/s!')
        pxPerCm = 1;
    end
    
    if nargin < 4
        warning('framesPerSecond defaulted to 29.97.')
        framesPerSecond = 29.97; % neuralynx default.
    end
    
    if nargin < 2
        lagTime = 1.5; % second
    end

    lagCenterIdx = round(lagTime*framesPerSecond); % neuralynx default.

    lagFrames = lagCenterIdx-5:lagCenterIdx+5; % frames; this is to mitigate jumps that may occur
    laggedAccel = zeros(length(lagFrames), length(speed));
    for ii = 1 : length(lagFrames)
        for jj=lagFrames(ii)+1:length(speed)-lagFrames(ii)
            % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
            laggedAccel(ii,jj) = speed(jj+lagFrames(ii)) - speed(jj-lagFrames(ii));
        end
    end

    accel = median(laggedAccel);

    return;

end

