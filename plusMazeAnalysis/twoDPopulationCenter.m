function [ output, outputDev, binCounts, hologram, outputResultant ] = twoDPopulationCenter( xx, yy, data, divisionFactor, maxX, maxY, offset, circularData )

if nargin < 8
    circularData = true;
end

if nargin >= 7
    xx = xx + offset;
    yy = yy + offset;
    output=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
end

if nargin < 5
    xx = xx - min(xx);
    yy = yy - min(yy);
    maxX = max(xx);
    maxY = max(yy);
    output=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
end 
if nargin < 4
    divisionFactor = floor(max([ max(xx) max(yy) ]) * .05);
end
if ( nargin == 6 ) || ( nargin == 5 )
    % this part is for handling assumptions about the video data.
    % this should make it easy to align data bins
    %maxX = 720;
    %maxY = 420;
    output=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
end

hologram = cell( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );

for ii=1:length(xx)
    xxs = floor(xx(ii)/divisionFactor)+1;
    yys = floor(yy(ii)/divisionFactor)+1;
    if xxs > ceil(maxX/divisionFactor)+1
        xxs = ceil(maxX/divisionFactor)+1;
    end
    if yys > ceil(maxY/divisionFactor)+1
        yys = ceil(maxY/divisionFactor)+1;
    end
    hologram{ yys, xxs } = [ (hologram{ yys, xxs }) data(ii) ];
end

binCounts=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
outputDev=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );
outputResultant=zeros( ceil(maxY/divisionFactor)+1 , ceil(maxX/divisionFactor)+1 );

for rr=1:(maxX/divisionFactor)+1
    for cc=1:(maxY/divisionFactor)+1
        binCounts(cc,rr) = length(hologram{cc,rr});
        if ~isempty(hologram{cc,rr})
            if circularData
                if length(hologram{cc,rr}) == 1
                    output(cc,rr) = hologram{cc,rr}';
                    outputDev(cc,rr) = NaN;
                    outputResultant(cc,rr) = NaN;
                else
                    %output(cc,rr) =  circ_mean( hologram{cc,rr}' );
                    output(cc,rr) =  circ_median( hologram{cc,rr}' );
                    outputDev(cc,rr) = circ_std( hologram{cc,rr}' );
                    outputResultant(cc,rr) = circ_r( hologram{cc,rr}' );
                end
            else
                output(cc,rr) =  nanmedian( hologram{cc,rr}' );
                outputDev(cc,rr) = nanstd( hologram{cc,rr}' );
                outputResultant = NaN;
            end
        else
            output(cc,rr) = NaN;
            outputDev(cc,rr) = NaN;
            outputResultant(cc,rr) = NaN;
        end
    end
end

binCounts(binCounts==0)=NaN;