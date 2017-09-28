function xcb = xcorr_binned_1D(ISI, TS, TS_1D, val_1D, edges_1D, binsize, maxISI, minpairs, circular)

% computes cross correlograms for different binned values of a 1D variable
% to maximize speed, this takes spike pair data (not raw spikes) as input

% example call for computing xcorr in directional bins:
% xcorr_binned_1D(ISI, TS, Position_HD(:,2), unwrap(deg2rad(Position_HD(:,1))), deg2rad(0:30:360), .002, .5, 100)

% ISI = interspike interval for each spike pair
% TS = time stamp for each spike pair (e.g., midpoint between the two spikes)
% TS_1D = time stamps for each measured value of the 1D variable
% val_1D = measured values of the 1D variable
% edges_1D = bin edges for the 1D variable
% binsize = time bin size for the cross correlogram
% maxISI = maximum time inteerval for cross correlogram
% minpairs = minimum number of spike pairs from which to compute a cross correlogram in each bin
% circular = flag for circular variable (in which case val_1D and edges_1D must be specified in radians)

blocksize = 10000000; %number of spike pairs to interpolate at a time (set lower if memory errors occur)
numblocks = round(.5+length(TS)/blocksize); %divide pairs up into blocks to prevent memory errors

xcorr_edges = -maxISI:binsize:maxISI;

xcb = zeros((length(edges_1D)-1),length(xcorr_edges)-1);

for b=1:numblocks

    %compute value of the 1D variable at each spike pair time stamp

    if (b<numblocks)
        pair_1D = interp1(TS_1D, val_1D, TS(((b-1)*blocksize+1):(b*blocksize)));
    else
        pair_1D = interp1(TS_1D, val_1D, TS(((b-1)*blocksize+1):end));
    end

    if circular
        pair_1D = mod(pair_1D,2*pi); %confine values between 0 - 2*pi
    end

    TSpercent = length(pair_1D)/length(TS);

    [bincount, bindex] = histc(pair_1D,edges_1D); %bindex contains bin numbers of all spike pairs

    %compute xcorrelograms for each bin
    for b=1:(length(edges_1D)-1)  %loop through bins of the 1D variable

        bdex = find(bindex == b);  %indices of all spike pairs residing in the current bin

        if (~isempty(bdex) & (length(bdex)>minpairs)) %if there are at least the minimum number of spike pairs in this bin
            temp = histc(ISI(bdex),-maxISI:binsize:maxISI); %cross correlogram for spike pairs in the current bin
            xcb(b,:) = squeeze(xcb(b,:))' + TSpercent * temp(1:(length(temp)-1));
        end

    end

end %for b=1:numblocks