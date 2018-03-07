function output = twoDHistogram( xx, yy, divisionFactor, maxX, maxY )

if nargin < 4
    xx = xx - min(xx);
    yy = yy - min(yy);
    maxX = max(xx);
    maxY = max(yy);
    output=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
end 
if nargin < 3
    divisionFactor = floor(max([ max(xx) max(yy) ]) * .05);
end
if ( nargin == 5 ) || ( nargin == 4 )
    % this part is for handling assumptions about the video data.
    % this should make it easy to align data bins
    %maxX = 720;
    %maxY = 420;
    output=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
end

for ii=1:length(xx)
    xxs = floor(xx(ii)/divisionFactor)+1;
    yys = floor(yy(ii)/divisionFactor)+1;
    if xxs > ceil(maxX/divisionFactor)+1
        xxs = ceil(maxX/divisionFactor)+1;
    end
    if yys > ceil(maxY/divisionFactor)+1
        yys = ceil(maxY/divisionFactor)+1;
    end
    output( yys, xxs ) = output( yys, xxs ) + 1;
end
