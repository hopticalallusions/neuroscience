function [ spikePlaceInfoPerSpike, spikePlaceInfoPerSecond, spikePlaceSparsity, spatialFiringRateCoherence, skaggsRatio, spikePlaceInfoArray ] = skaggsSpatialInfo( probOccupyXY, rateMap, avgFiring )


    spikePlaceInfoArray = probOccupyXY .* rateMap .* log2( rateMap./avgFiring );
    spikePlaceInfoPerSpike = nansum(spikePlaceInfoArray(:))./avgFiring;
    spikePlaceInfoPerSecond = nansum(spikePlaceInfoArray(:)); %.*nanmean(rateMap(:));
    skaggsRatio = nansum((spikePlaceInfoArray(:)>0))/nansum(~isnan(spikePlaceInfoArray(:)));
    %
    % Markus, Barnes, McNaughton, Gladden, Skaggs 1994 
    % Markus et al 1994 suggest that randomly shuffling the location and spike
    % train can be used to determine significance levels and produce a z score
    % for information metrics.

    %% sparsity metric  Skagg's formulation
    %
    %    this metric tells us how selective the cell's firing was on the maze.
    %    thus a cell which fires everywhere will not be sparse, whereas one
    %    with a very small and precise place field will be sparse
    spikePlaceSparsity = (nansum((probOccupyXY(:) .* rateMap(:) )).^2 )./(  nansum(probOccupyXY(:) .* (rateMap(:).^2) )  );


    %% Spatial Coherence
    %
    % Muller Kubie 1989
    %
    % first order autocorrelation 
    %
    % z-xform of 
    %   correlation between
    %       list of firing rates in each pixel
    %       AND
    %       mean( 8 surrounding pixels)
    %
    % INPUT : spatial rate map matrix
    % 

    sz=size(rateMap);
    signal = zeros(1,sz(1)*sz(2));
    surround = zeros(1,sz(1)*sz(2));
    for ii=2:sz(1)-1
        for jj=2:sz(2)-1
            kk = (ii-1)*sz(1)+jj;
            signal(kk) = rateMap(ii,jj);
            surround(kk) = nanmean([ rateMap(ii-1,jj-1)  rateMap(ii-1,jj) rateMap(ii-1,jj+1)  rateMap(ii,jj-1) rateMap(ii,jj+1)  rateMap(ii+1,jj-1) rateMap(ii+1,jj)  rateMap(ii+1,jj+1) ]);
        end
    end
    spatialFiringRateCoherence = nansum( (signal-nanmean(signal)) .* (surround-nanmean(surround))/( sqrt(nansum((signal-nanmean(signal)).^2)) .* sqrt(nansum((surround-nanmean(surround)).^2)) ));

return;