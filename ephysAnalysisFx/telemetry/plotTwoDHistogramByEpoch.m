function plotTwoDHistogramByEpoch( xpos, ypos, epochTime, sessionStartTime, sessionEndTime )

    xyFramesPerSecond = 29.97; % neuralynx default

    if nargin < 2
        error('requires 2 inputs!');
    end

    if nargin < 3
        epochTime = 5; % minutes
    end

    if nargin < 4
        sessionStartTime = 0; % minutes
    end

    if nargin < 5 
        sessionEndTime = length(xpos)/(xyFramesPerSecond*60); % minutes 
        sessionEndIdx = length(xpos);
    else
        sessionEndIdx=floor(sessionEndTime*60*30);
    end

    sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
    
    epochIdxSize=floor(epochTime*60*30);

    subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
    subplotCols=ceil(subplotsToMake/3);
    subplotRows=ceil(subplotsToMake/subplotCols);

    figure;
    epochIdx=1;
    subplotIdx=1;
    for ii=1:subplotRows
        for jj=1:2:subplotCols
            % caluclate position indices
            tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
            if tmpEndIdx > sessionEndIdx
                tmpEndIdx = sessionEndIdx;
            end
            tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
            % don't bother plotting anything if  we've exceeded the maximum time
            % or if there's only a minute of time left to the plot
            if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
                %
                subplot(subplotRows,subplotCols,subplotIdx); plot( xpos(tmpIdxs), ypos(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
                % plotNlxZone(zoneCoords1); 
                % hold on; scatter(xposFilt(LaserPosIdx), yposFilt(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
                subplotIdx = subplotIdx+1;
                subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xpos(tmpIdxs), ypos(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient);
                caxis([0 10]); %colorbar;
                %
                epochIdx=epochIdx+1;
                subplotIdx = subplotIdx+1;
            end
        end
    end

end