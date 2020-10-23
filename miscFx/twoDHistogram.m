function output = twoDHistogram( xx, yy, divisionFactorX, maxX, maxY, offset, divisionFactorY )

if nargin < 7
    divisionFactorY = divisionFactorX;
end

if nargin >= 6
    xx = xx + offset;
    yy = yy + offset;
    output=zeros( ceil(maxY/divisionFactorY)+1 , ceil(maxX/divisionFactorX)+1 );
end

if nargin < 4
    xx = xx - min(xx);
    yy = yy - min(yy);
    maxX = max(xx);
    maxY = max(yy);
    output=zeros( ceil(maxY/divisionFactorY)+1 , ceil(maxX/divisionFactorX)+1 );
end 
if nargin < 3
    divisionFactorX = floor(max([ max(xx) max(yy) ]) * .05);
end
if ( nargin == 5 ) || ( nargin == 4 )
    % this part is for handling assumptions about the video data.
    % this should make it easy to align data bins
    %maxX = 720;
    %maxY = 420;
    output=zeros( ceil(maxY/divisionFactorY)+1 , ceil(maxX/divisionFactorX)+1 );
end

for ii=1:length(xx)
    xxs = floor(xx(ii)/divisionFactorX)+1;
    yys = floor(yy(ii)/divisionFactorY)+1;
    if xxs > ceil(maxX/divisionFactorX)+1
        xxs = ceil(maxX/divisionFactorX)+1;
    end
    if yys > ceil(maxY/divisionFactorY)+1
        yys = ceil(maxY/divisionFactorY)+1;
    end
    output( yys, xxs ) = output( yys, xxs ) + 1;
end
