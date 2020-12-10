function output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate, shuffles )

    if nargin < 6
        shuffles = 0;
    end

    binResolution = 10;

    freqXY = twoDHistogram( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), binResolution, 300, 300, 150  );
    %freqXY(freqXY==0)=NaN; 
    probOccupyXY = freqXY./sum(freqXY(:));  % probability of being in place

    cellXYHist=twoDHistogram( spikeData.x(selectedSpikeIdxs>0), spikeData.y(selectedSpikeIdxs>0), binResolution, 300, 300, 150  );
    %cellXYHist(cellXYHist==0)=NaN;

    %% measure spike information content    Skagg's formulation
    %
    rateMap = cellXYHist./(freqXY./29.97); % spike rate
    spikePlaceInfoArray = probOccupyXY .* ( rateMap./nanmean(rateMap(:)) ) .* log2( rateMap./nanmean(rateMap(:)) );
    spikePlaceInfoPerSecond = nansum(spikePlaceInfoArray(spikePlaceInfoArray(:)>0));
    spikePlaceInfoPerSecondNeg = nansum(spikePlaceInfoArray(spikePlaceInfoArray(:)<0));
    spikePlaceInfoPerSpike = spikePlaceInfoPerSecond/nanmean(rateMap(:));
    spikePlaceInfoPerSpikeNeg = spikePlaceInfoPerSecondNeg/nanmean(rateMap(:));
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


    %% how many fields are there? How big are they?
    %  %labeledMatrix, %regionLabels, %regionSizes
    [~,regionLabels,regionSizes]=findBoundaries(rateMap,1,3);
    spatialFields = length(unique(regionLabels));
    


    %% how much area does firing cover?
    % normalized for what the rat visited, of course

    % only count bins that have a firing rate higher than 1 Hz
    
    firingAreaProportion = (sum(sum(rateMap>1))/sum(sum(freqXY>0)));


    %
    %% calculate phase Mutual Information
    %
    % 1) JOINT PROBABILITY
    %
    %threeDHistogram(                                 xx,                               yy,                                        zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ )
    freqPhasePosition=threeDHistogram( spikeData.x(selectedSpikeIdxs>0), spikeData.y(selectedSpikeIdxs>0), spikeData.thetaPhase(selectedSpikeIdxs>0), binResolution, binResolution, 10, 300, 300, 360, 150, 150, 0, 0, [ 36*1 36*2 36*3 36*4 36*5 36*6 36*7 36*8 36*9 ]);
    freqPhasePosition(freqPhasePosition==0) = NaN;
    
    probPhasePosition=freqPhasePosition./nansum(freqPhasePosition(:)); 

    
    
%     if ( nansum(probPhasePosition(:)) < .99 ) || ( nansum(probPhasePosition(:)) > 1.01 ); warning('BAD probPhasePosition!!!'); end;
%     probOccupyXY = nansum(probPhasePosition,3);
%     probOccupyXY(probOccupyXY(:)==0)=NaN;
%     if ( nansum(probOccupyXY(:)) < .99 ) || ( nansum(probOccupyXY(:)) > 1.01 ); warning('BAD probOccupyXY!!!'); end;
%     probPhase = squeeze(nansum(squeeze(nansum(probPhasePosition,2))));
%     if ( nansum(probPhase(:)) < .99 ) || ( nansum(probPhase(:)) > 1.01 ); warning('BAD probPhase!!!'); end;
%     
% %     size(probOccupyXY)
% %     size(probPhase)
%     
%     
% %    figure; subplot(1,4,1:2); pcolor(probOccupyXY); subplot(1,4,3); plot(probPhase(:)); hold on; plot(squeeze(nansum(squeeze(nansum( probPhasePosition,1))))); subplot(1,4,4); histogram(spikeData.thetaPhase(selectedSpikeIdxs>0), 0:36:360)
%     
% %    figure; subplot(1,3,1); zz = squeeze(nansum(probPhasePosition,1)); zz(zz(:)==0)=NaN; pcolor(zz); 
% %    subplot(1,3,2); zz = squeeze(nansum(probPhasePosition,2)); zz(zz(:)==0)=NaN; pcolor(zz); 
% %    subplot(1,3,3); zz = squeeze(nansum(probPhasePosition,3)); zz(zz(:)==0)=NaN; pcolor(zz); 
%     
%     phaseMImat = zeros(size(probPhasePosition));
%     sz=size(probPhasePosition);
%     countDivByZeros = 0;
%     for rr=1:sz(1)
%         for cc=1:sz(2)
%             for dd=1:sz(3)
%                 if ( probOccupyXY(rr,cc) * probPhase(dd) ) > 0
%                     phaseMImat(rr,cc,dd) = probPhasePosition(rr,cc,dd) * log2( probPhasePosition(rr,cc,dd) / ( probOccupyXY(rr,cc) * probPhase(dd) ) );
%                 elseif (probPhasePosition(rr,cc,dd)>0)
%                     disp([ ' phase joint info ' numstr(rr) ' ' num2str(cc) ' ' num2str(dd) ' : ' num2str(probOccupyXY(rr,cc)) ' * ' num2str(probPhase(dd)) ])
%                     countDivByZeros = countDivByZeros + 1;
%                 end
%             end
%         end
%     end
%     if countDivByZeros > 0
%         disp([ 'ignored ' num2str(countDivByZeros) ' division by zero '  ])
%     end
%     phaseInfoJoint = nansum(phaseMImat(:));
%         
%     %phaseInfoJointNeg = nansum(phaseMImat((phaseMImat(:)<0)));
%     %phaseInfoJointAbs = nansum(abs(phaseMImat(:)));
%     phaseMImatJoint = phaseMImat;
%     
%     %
%     % 2) CONDITIONAL PROBABILITY
%     %
%     % threeDHistogram(                                 xx,                               yy,                                        zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ )
%     % sum( P_k|xi   log( P_k|xi  / P_k ) )
%     phaseMImat = zeros(size(probPhasePosition));
%     sz=size(probPhasePosition);
%     countDivByZeros = 0;
%     phaseMIalt = phaseMImat; 
%     for rr=1:sz(1)
%         for cc=1:sz(2)
%             for dd=1:sz(3)
%                 conditionalProb = (probPhasePosition(rr,cc,dd)/probOccupyXY(rr,cc,:));
%                 if ( probPhase(dd)  > 0 )
%                     phaseMImat(rr,cc,dd) = conditionalProb * log2( conditionalProb / probPhase(dd) );
%                 elseif (conditionalProb>0) && (conditionalProb~=Inf)
%                     disp([ ' phase cond. info ' num2str(rr) ' ' num2str(cc) ' ' num2str(dd) ' : ' num2str(conditionalProb) ' / ' num2str(probPhase(dd)) ])
%                     countDivByZeros = countDivByZeros + 1;
%                 end
%                 if ( probOccupyXY(rr,cc) > 0 )
%                     phaseMIalt(rr,cc,dd) = phaseMImatJoint(rr,cc,dd)/probOccupyXY(rr,cc);
%                 end
%             end
%         end
%     end
%     if countDivByZeros > 0
%         disp([ 'ignored ' num2str(countDivByZeros) ' division by zero '  ])
%     end
%     phaseInfoConditional = nansum(phaseMImat(:));
    
    
    [ phaseInfoJoint, phaseInfoConditional ] = miThreeD( probPhasePosition );
    
    
    
    
    
    
    
    totalSpikesAnalyzed = sum(selectedSpikeIdxs>0);
    %phaseInfoConditionalNeg = nansum(phaseMImat((phaseMImat(:)<0)));
    %phaseInfoConditionalAbs = nansum(abs(phaseMImat(:)));
 %   disp([ 'alt cond : ' num2str(nansum(phaseMIalt(:))) ] );


    %% calculate spike rate Mutual Information
    %
    % 1) JOINT PROBABILITY
    %
    %threeDHistogram(                                 xx,                               yy,                         zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ )
    freqRatePosition=threeDHistogram( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRate(selectedTelIdxs>0), binResolution, binResolution, 5,  300,  300,   50,     150,     150,       0, 0);
    freqRatePosition(freqRatePosition==0)=NaN;
    
    
    
    probRatePosition=freqRatePosition./nansum(freqRatePosition(:));

    
    
    
%     if ( nansum(probRatePosition(:)) < .99 ) || ( nansum(probRatePosition(:)) > 1.01 ); warning('BAD probRatePosition!!!'); end;
%     probOccupyXY = nansum(probRatePosition,3);
%     if ( nansum(probOccupyXY(:)) < .99 ) || ( nansum(probOccupyXY(:)) > 1.01 ); warning('BAD probOccupyXY!!!'); end;
%     probFiringRates = nansum(nansum(probRatePosition,2));
%     if ( nansum(probFiringRates(:)) < .99 ) || ( nansum(probFiringRates(:)) > 1.01 ); warning('BAD probFiringRates!!!'); end;
%     
%     rateMImat = zeros(size(probRatePosition));
%     sz=size(probRatePosition);
%     countDivByZeros = 0;
%     for rr=1:sz(1)
%         for cc=1:sz(2)
%             for dd=1:sz(3)
%                 if ( probOccupyXY(rr,cc) * probFiringRates(dd) ) > 0
%                     rateMImat(rr,cc,dd) = probRatePosition(rr,cc,dd) * log2( probRatePosition(rr,cc,dd) / ( probOccupyXY(rr,cc) * probFiringRates(dd) ) );
%                 elseif (probRatePosition(rr,cc,dd)>0)
%                     disp([ ' spikerate joint info ' num2str(rr) ' ' num2str(cc) ' ' num2str(dd) ' : ' num2str(probOccupyXY(rr,cc)) ' * ' num2str(probFiringRates(dd)) ])
%                     countDivByZeros = countDivByZeros + 1;
%                 end
%             end
%         end
%     end
%     if countDivByZeros > 0
%         disp([ 'ignored ' num2str(countDivByZeros) ' division by zero '  ]);
%     end
%     spikeRateMIjoint = nansum(rateMImat(:));
%     %spikeRateMIjointNeg = nansum(rateMImat((rateMImat(:)<0)));
%     %spikeRateMIjointAbs = nansum(abs(rateMImat(:)));
% 
%     %
%     % 2) CONDITIONAL PROBABILITY
%     %
%     % threeDHistogram(                                 xx,                               yy,                                        zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ )
%     % sum( P_k|xi *  log( P_k|xi  / P_k ) )
%     rateMImat = zeros(size(probRatePosition));
%     sz=size(probRatePosition);
%     countDivByZeros = 0;
%     for rr=1:sz(1)
%         for cc=1:sz(2)
%             for dd=1:sz(3)
%                 conditionalProb = (probRatePosition(rr,cc,dd)/nansum(probRatePosition(rr,cc,:)));
%                 if (  probFiringRates(dd) ) > 0    
%                     rateMImat(rr,cc,dd) = conditionalProb * log2( conditionalProb / probFiringRates(dd) );
%                 elseif (conditionalProb>0) && (conditionalProb~=Inf)
%        %             disp([ ' spike rate cond. info ' num2str(rr) ' ' num2str(cc) ' ' num2str(dd) ' : ' num2str(conditionalProb) ' / ' num2str(probFiringRates(dd)) ])
%                     countDivByZeros = countDivByZeros + 1;
%                 end
%             end
%         end
%     end
%     if countDivByZeros > 0
%         disp([ 'spike rate cond. info  ignored ' num2str(countDivByZeros) ' division by zero '  ])
%     end
%     spikeRateMIconditional = nansum(rateMImat(:));
    %spikeRateMIconditionalNeg = nansum(rateMImat((rateMImat(:)<0)));
    %spikeRateMIconditionalAbs = nansum(abs(rateMImat(:)));
    

    [ spikeRateMIjoint, spikeRateMIconditional ] = miThreeD( probRatePosition );

%     figure;
%     binResolution = 5;
%     [ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRate(selectedTelIdxs>0), binResolution, 300, 300, 150, false  );
%     pcolor(output); shading flat; colorbar; colormap('jet');
    
    
    
    output.spikePlaceInfoPerSecond    = spikePlaceInfoPerSecond;
    output.spikePlaceInfoPerSpike     = spikePlaceInfoPerSpike;
    output.spikePlaceSparsity         = spikePlaceSparsity;
    output.spatialFiringRateCoherence = spatialFiringRateCoherence;
    output.firingAreaProportion       = firingAreaProportion;
    output.spatialFields              = spatialFields;
    output.firingAreaProportion       = firingAreaProportion;
    output.phaseInfoJoint             = phaseInfoJoint;
%    output.phaseInfoJointNeg          = phaseInfoJointNeg;
%    output.phaseInfoJointAbs          = phaseInfoJointAbs;
    
    output.phaseInfoConditional       = phaseInfoConditional;
%    output.phaseInfoConditionalNeg    = phaseInfoConditionalNeg;
%    output.phaseInfoConditionalAbs    = phaseInfoConditionalAbs;
    
    output.spikeRateMIjoint           = spikeRateMIjoint;
%    output.spikeRateMIjointNeg        = spikeRateMIjointNeg;
%    output.spikeRateMIjointAbs        = spikeRateMIjointAbs;
    
    output.spikeRateMIconditional     = spikeRateMIconditional;
%    output.spikeRateMIconditionalNeg  = spikeRateMIconditionalNeg;
%    output.spikeRateMIconditionalAbs  = spikeRateMIconditionalAbs;
    
    output.totalSpikesAnalyzed        = totalSpikesAnalyzed;
    output.totalTimeAnalyzed          = sum(selectedTelIdxs>0)/29.97;

%    output.spikePlaceInfoPerSpikeNeg  = spikePlaceInfoPerSpikeNeg;
%    output.spikePlaceInfoPerSecondNeg = spikePlaceInfoPerSecondNeg;
    
return;






