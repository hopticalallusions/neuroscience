function xcb = xcorr_radial_2D(ISI, TS, TS_2D, xval, yval, xcenters, ycenters, binsize, maxISI, minpairs, radius)

% computes cross correlograms for spike pairs within a radii of points on a 2D lattice
% to maximize speed, this takes spike pair data (not raw spikes) as input

% example call for computing xcorr in directional bins:
% xcorr_by_1D(ISI, TS, Position_HD(:,2), unwrap(deg2rad(Position_HD(:,1))), deg2rad(0:30:360), .002, .5, 100)

% ISI = interspike interval for each spike pair
% TS = time stamp for each spike pair (e.g., midpoint between the two spikes)
% TS_2D = time stamps for each measured value of the 2D variable
% xval = measured x values of the 2D variable
% yval = measured y values of the 2D variable
% xcenters = x coordinates of radius centers
% ycenters = y coordinates of radius centers
% binsize = time bin size for the cross correlogram
% maxISI = maximum time inteerval for cross correlogram
% minpairs = minimum number of spike pairs from which to compute a cross correlogram in each bin
% radius = radius surrounding each lattice points from which to sample

blocksize = 10000000; %number of spike pairs to interpolate at a time (set lower if memory errors occur)
numblocks = round(.5+length(TS)/blocksize); %divide pairs up into blocks to prevent memory errors

xcorr_edges = -maxISI:binsize:maxISI;

%compute x and y values at each spike pair time stamp

xcb = zeros(length(xcenters),length(ycenters),length(xcorr_edges)-1);

for b=1:numblocks
    if (b<numblocks)
        pair_x = interp1(TS_2D, xval, TS(((b-1)*blocksize+1):(b*blocksize)));
        pair_y = interp1(TS_2D, yval, TS(((b-1)*blocksize+1):(b*blocksize)));
    else
        pair_x = interp1(TS_2D, xval, TS(((b-1)*blocksize+1):end));
        pair_y = interp1(TS_2D, yval, TS(((b-1)*blocksize+1):end));
    end

    TSpercent = length(pair_x)/length(TS);

    %compute xcorrelograms for each bin
    for xbin=1:length(xcenters)  %loop through the x coordinates of radius centers
        for ybin=1:length(ycenters)  %loop through bins of the 1D variable

            %compute indices of spike pairs that lie within the specified radiua of the current center point:
            bdex = find( sqrt ( (pair_x-xcenters(xbin)).^2 + (pair_y-ycenters(ybin)).^2 ) <= radius );

            if (~isempty(bdex) & (length(bdex)>minpairs)) %if the are at least the minimum number of spike pairs in this bin
                temp = histc(ISI(bdex),-maxISI:binsize:maxISI); %cross correlogram for spike pairs in the current bin
                xcb(xbin,ybin,:) = squeeze(xcb(xbin,ybin,:)) + TSpercent * temp(1:(length(temp)-1));
            end

        end
    end

end %for b=1:numblocks
