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

    if true
    
        lagFrames = 1:25;
        laggedAccel = zeros(length(lagFrames), length(speed));
        for ii = 1 : length(lagFrames)
            for jj=lagFrames(ii)+1:length(xpos)-lagFrames(ii)
                % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
                laggedAccel(ii,jj) = ( speed(jj+lagFrames(ii)) - speed(jj-lagFrames(ii)) ) * (1/(2*lagFrames(ii))) * 1/pxPerCm * framesPerSecond;
            end
        end
        % figure; plot(laggedAccel(:, (1:1e3)+1e4 )');
        % legend('1','2','3','4','5','6')
        predictedSpeed = zeros(length(lagFrames),length(speed));
        predictedSpeedErrs = predictedSpeed;
        bestAccelIdx = zeros(1,length(xpos));
        accel = zeros(1,length(xpos));
        errDistance =  zeros(1,length(xpos));
        for ii = 2:length(ypos)
            predictedSpeed(:,ii) = speed(ii-1)*ones(length(lagFrames),1)+(laggedAccel(:,ii)*pxPerCm/framesPerSecond);
            predictedSpeedErrs(:,ii) = speed(ii)*ones(length(lagFrames),1) - predictedSpeed(:,ii);
            [errDistance(ii),bestAccelIdx(ii)] = min(abs(predictedSpeedErrs(:,ii)));
            accel(ii) = laggedAccel(bestAccelIdx(ii),ii);
        end
    
        figure; subplot(2,2,1); selectedTel=round(8*60*29.97):83424; plotColoredLine(xpos(selectedTel),ypos(selectedTel),speed(selectedTel)); colormap('jet'); colorbar; axis square;
        selectedTel=84000:length(xpos); subplot(2,2,2); plotColoredLine(xpos(selectedTel),ypos(selectedTel),speed(selectedTel)); colormap('jet'); colorbar; axis square;
        subplot(2,2,3); selectedTel=round(8*60*29.97):83424; plotColoredLine(xpos(selectedTel),ypos(selectedTel),accel(selectedTel)); colormap('jet'); colorbar; axis square;
        selectedTel=84000:length(xpos); subplot(2,2,4); plotColoredLine(xpos(selectedTel),ypos(selectedTel),accel(selectedTel)); colormap('jet'); colorbar; axis square;
        
    else
        
        % old version
        
        lagCenterIdx = round(lagTime*framesPerSecond); % neuralynx default.

        lagFrames = lagCenterIdx-5:lagCenterIdx+5; % frames; this is to mitigate jumps that may occur
        laggedAccel = zeros(length(lagFrames), length(speed));
        for ii = 1 : length(lagFrames)
            for jj=lagFrames(ii)+1:length(speed)-lagFrames(ii)
                % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
                laggedAccel(ii,jj) = speed(jj+lagFrames(ii)) - speed(jj-lagFrames(ii));
            end
        end

        oldaccel = median(laggedAccel);
    end
        
    return;

end

