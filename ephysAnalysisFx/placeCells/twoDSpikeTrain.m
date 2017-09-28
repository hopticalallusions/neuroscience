function output = twoDSpikeTrain( xx, yy, xyTimesForPlots, speedFilteredSpikeXyIdxs, divisionFactor, maxX, maxY )

if nargin < 6
    xx = xx - min(xx);
    yy = yy - min(yy);
    maxX = max(xx);
    maxY = max(yy);
end 
if nargin < 5
    divisionFactor = floor(max([ max(xx) max(yy) ]) * .05);
end
if ( nargin == 5 ) || ( nargin == 6 )
    % this part is for handling assumptions about the video data.
    % this should make it easy to align data bins
    maxX = 720;
    maxY = 420;
end

    output=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1, length(xyTimesForPlots) );

    xxx = xx(speedFilteredSpikeXyIdxs);
    yyy = yy(speedFilteredSpikeXyIdxs);
    
for ii=1:length(speedFilteredSpikeXyIdxs)
    xxs = floor(xxx(ii)/divisionFactor)+1;
    yys = floor(yyy(ii)/divisionFactor)+1;
    if xxs > ceil(maxX/divisionFactor)+1
        xxs = ceil(maxX/divisionFactor)+1;
    end
    if yys > ceil(maxY/divisionFactor)+1
        yys = ceil(maxY/divisionFactor)+1;
    end
    output( yys, xxs, speedFilteredSpikeXyIdxs(ii) ) =  1;
end
