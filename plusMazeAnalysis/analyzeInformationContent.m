function output = analyzeInformationContent( telemetry, spikeData, selectedTelIdxs, selectedSpikeIdxs, spikeFiringRate, shufflesToDo, binResolution, minimumSpatialSampling )  

%    minimumSpatialSampling = 2; % seconds.    this value will depend on bin size and session length.

    if nargin < 6
        shufflesToDo = 0;
    end
    
    if nargin < 7
        binResolution = 20;
    end
    
    if nargin < 8
        minimumSpatialSampling = 2; % seconds.    this value will depend on bin size and session length.
    end

    freqXY = twoDHistogram( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), binResolution, 300, 300, 150  );
    %
    % eliminate low sampling bins; replacing with NaN should eliminate the
    % possibility of producing division by zero and therefore Infinities
    %
    % one possible way to try to set this automatically is divide total
    % session length in seconds by the number of bins with data :
    %
    disp([ 'removed ' num2str(nansum(nansum(  (freqXY< round(minimumSpatialSampling*29.97) & (freqXY>0) )))) ' ('  num2str( round(100*nansum(nansum(  (freqXY< round(minimumSpatialSampling*29.97) & (freqXY>0) )))/nansum(nansum( (freqXY>0) )) ))  '%)  spatial bins due to low sampling' ]);
    freqXY(freqXY< round(minimumSpatialSampling*29.97) ) = NaN;
    probOccupyXY = freqXY./nansum(freqXY(:));  % probability of being in place
    
    cellXYHist=twoDHistogram( spikeData.x(selectedSpikeIdxs>0), spikeData.y(selectedSpikeIdxs>0), binResolution, 300, 300, 150  );
    avgFiring=nansum(cellXYHist(:))/(sum((selectedTelIdxs>0))/29.97);
    
    %% measure spike information content    Skagg's formulation
    %
    rateMap = cellXYHist./(freqXY./29.97);
    [ spikePlaceInfoPerSpike, spikePlaceInfoPerSecond, spikePlaceSparsity, spatialFiringRateCoherence, skaggsRatio, spikePlaceInfoArray ] = skaggsSpatialInfo( probOccupyXY, rateMap, avgFiring );

    
%% Shuffle Skaggs
    if shufflesToDo > 0
        telemetryIdxList = find(selectedTelIdxs);
        
        spikePlaceInfoPerSpikeShuf     = zeros( 1, shufflesToDo );
        spikePlaceInfoPerSecondShuf    = zeros( 1, shufflesToDo );
        spikePlaceSparsityShuf         = zeros( 1, shufflesToDo );
        spatialFiringRateCoherenceShuf = zeros( 1, shufflesToDo );
        
        rateInfosJointSuffled          = zeros( 1, shufflesToDo );
        rateInfosCondSuffled           = zeros( 1, shufflesToDo );

        % set up shift wrapping
        %
        % this code is convoluted because not all telemetry locations are
        % valid for shift wrapping. In effect, this code 
        %    (1) selects out a list of valid telemetry indices (e.g. when the rat is on the maze running)  
        %    (2) finds the indices of the valid telemetry indices (pointer to pointer) which matches the spike indices
        %            - this is done to preserve the ISI information later
        %    (3) 
        %    
        % this effectively set up an array of pointers to pointers.
        % "selectedTelIdxs" is a set of pointers to good positions in logical array form (so not really pointers)
        % "telemetryIdxList" is a set of pointers indexing good position data
        % "spikeTelIdxList" is a set of pointers to 'telemetryIdxList' indicating where spikes occur
        % later we will shift the spikeTelIdxList, preserving their
        % relative offsets but moving the incidence of the surrogate spikes
        % against the position data.
        spikeTelIdx=zeros(1,length(telemetryIdxList));
        spikeIdxList = floor(spikeData.timesSeconds(selectedSpikeIdxs>0)*29.97)+1;
        spikeTelIdxList = zeros(1,length(spikeIdxList));
        for pp=1:length(spikeIdxList)
            [ val, idx ] = min( abs( telemetryIdxList - spikeIdxList(pp)) );
            if val > 30
                warning('>1 s offset detected between telemetry and spike data')
            end
        end

        for shf = 1:shufflesToDo
            
            % THE SKAGGS PART
            %
            % pull random times for spikes by generating random index into
            % the valid telemetry timestamps. Use randi( maxInt, 1, countOfValues ) 
            % to generate indices with replacement, as spikes can occur
            % within bins.
            %
            % makes the spike locations totally random :  
            % seems to make everything significant
            % shufSpikeIdxs  = telemetryIdxList( randi( length(telemetryIdxList), 1, sum(selectedSpikeIdxs>0) ) );
            %
            % jitter version
            % runs risk of false negative on place fields because spikes are concentrated in the same spatial location anyway
            % shufSpikeIdxs  = telemetryIdxList + -1^(round(rand(1))+1)*( randi( 30, 1, sum(selectedSpikeIdxs>0) ) + 15);
            %
            % shift version
            % mod to shift-wrap
            % see above.
            shufSpikeIdxs  = telemetryIdxList( mod(spikeTelIdxList+600+ randi(3000,1), length(telemetryIdxList)-1)+1 );
            
            cellXYHistShuf = twoDHistogram( telemetry.x(shufSpikeIdxs), telemetry.y(shufSpikeIdxs), binResolution, 300, 300, 150  );
            rateMapShuf    = cellXYHistShuf./(freqXY./29.97); % spike rate
            
            [ spikePlaceInfoPerSpikeShuf(shf), spikePlaceInfoPerSecondShuf(shf), spikePlaceSparsityShuf(shf), spatialFiringRateCoherenceShuf(shf) ] = skaggsSpatialInfo( probOccupyXY, rateMapShuf, avgFiring );

            
            % THE MUTUAL INFORMATION PART
            %
            % Rebuild the rate signal with the surrogate randomized data

%             tempSpikeTimesShuf = telemetry.xytimestampSeconds( shufSpikeIdxs );
%             spikeFiringRateShuf = zeros(3,length(telemetry.x));
%             for ii=16:length(spikeFiringRateShuf)-16
%                 spikeFiringRateShuf(1,ii) = sum( ( tempSpikeTimesShuf > telemetry.xytimestampSeconds(ii-15) ) .* ( tempSpikeTimesShuf < telemetry.xytimestampSeconds(ii+14) ) );
%                 spikeFiringRateShuf(2,ii) = sum( ( tempSpikeTimesShuf > telemetry.xytimestampSeconds(ii-7) ) .* ( tempSpikeTimesShuf < telemetry.xytimestampSeconds(ii+7) ) )*2;
%                 spikeFiringRateShuf(3,ii) = sum( ( tempSpikeTimesShuf > telemetry.xytimestampSeconds(ii-3) ) .* ( tempSpikeTimesShuf < telemetry.xytimestampSeconds(ii+3) ) )*4;
%             end
%             spikeFiringRateShuf = mean(spikeFiringRateShuf);
%     
%             freqRatePositionShuf = threeDHistogram( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRateShuf(selectedTelIdxs>0), binResolution, binResolution, 5,  300,  300,   50,     150,     150,       0, 0);
%             freqRatePositionShuf(freqRatePositionShuf==0) = NaN;
%             probRatePositionShuf = freqRatePositionShuf./nansum(freqRatePositionShuf(:));
%             
%             [ rateInfosJointSuffled(shf), rateInfosCondSuffled(shf) ] = miThreeD( probRatePositionShuf );
    
        end
        
        spikePlaceInfoPerSpikePval     = (sum(spikePlaceInfoPerSpikeShuf>spikePlaceInfoPerSpike))/shufflesToDo; 
        %disp([ 'median spikeInfoShuf = ' num2str(median(spikePlaceInfoPerSpikeShuf)) ' real ' num2str(spikePlaceInfoPerSpike) ])
        spikePlaceInfoPerSecondPval    = (sum(spikePlaceInfoPerSecondShuf>spikePlaceInfoPerSecond))/shufflesToDo;
        spikePlaceSparsityPval         = (sum(spikePlaceSparsityShuf>spikePlaceSparsity))/shufflesToDo;
        spatialFiringRateCoherencePval = (sum(spatialFiringRateCoherenceShuf>spatialFiringRateCoherence))/shufflesToDo;
                
    else
        spikePlaceInfoPerSpikePval     = NaN; 
        spikePlaceInfoPerSecondPval    = NaN;
        spikePlaceSparsityPval         = NaN;
        spatialFiringRateCoherencePval = NaN;
    end
    
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
    freqPhasePosition=threeDHistogram( spikeData.x(selectedSpikeIdxs>0), spikeData.y(selectedSpikeIdxs>0), spikeData.thetaPhase(selectedSpikeIdxs>0), binResolution,   binResolution,              10,  300,  300,  360,     150,     150,       0,                  0, [ 36*1 36*2 36*3 36*4 36*5 36*6 36*7 36*8 36*9 ]);
    freqPhasePosition(freqPhasePosition==0) = NaN;
%     % this is an optional control for the amount of time spent in the
%     % spatial bin; don't want spatial bins where the rat spent less than 1s
%     % soooo.... This is not a bad idea, but it would eliminate almost all
%     % the bins in some data selection situations.
%     freqPosition=nansum( freqPhasePosition, 3 );
%     for aa=1:size(freqPosition,1);
%         for bb = 1:size(freqPosition, 2)
%             if ~isnan(freqPosition(aa,bb)) && ( freqPosition(aa,bb) < 29  )
%                 freqPhasePosition(aa,bb,:) = NaN;
%             end
%         end
%     end    
%     freqPosition(freqPosition==0)=NaN;
%     % visualize how much sampling there is; manipulate color axis to see
%     % what would be eliminated
%     figure; pcolor(freqPosition); caxis([0 30]); % caxis([ 0 10]);
%figure; histogram(freqPosition(find(freqPosition)),1:200)
    
    probPhasePosition=freqPhasePosition./nansum(freqPhasePosition(:)); 
    [ phaseInfoJoint, phaseInfoConditional, entropyPhaseJoint, MIphaseJoint, expViolPhaseJoint ] = miThreeD( probPhasePosition, probOccupyXY );
    
    % significance testing with a shuffle.
    % because we care about the relationship between space and phase, we
    % shall randomly reorder the phase and location data relationship,
    % rather than jittering (at least for now)
    %
    % NOTE! : it is possible that the RNG may have a non-trivial amount of MI
    % (generating matrices of random probability distributions produces an
    % MI of ~.25 on average)
    %
    spikeX = spikeData.x(selectedSpikeIdxs>0); 
    spikeY = spikeData.y(selectedSpikeIdxs>0);
    phase  = spikeData.thetaPhase(selectedSpikeIdxs>0);
    rng(0)
    %repmat(swrData.timestampSeconds(selectedSwr)',1000,1) + (((-1).^(round(rand(shufflesToDo,length(phase)))+1)).*( 0.5+( 1.5*rand(shufflesToDo,length(phase)))));
    %
    % I don't think this works entirely correctly. It might be better to
    % jitter the spike times and re-determine theta, rather than just
    % resampling the theta. (All the info metrics come out significant.)
    %
    %
    if shufflesToDo > 0
        phaseInfosJointSuffled = zeros(1,shufflesToDo);
        phaseInfosCondSuffled = phaseInfosJointSuffled;
        for shufIdx = 1:shufflesToDo
            
            shufPhase = phase(randperm(length(phase),length(phase)));
            
            freqPhasePosition=threeDHistogram( spikeX, spikeY, shufPhase, binResolution, binResolution, 10, 300, 300, 360, 150, 150, 0, 0, [ 36*1 36*2 36*3 36*4 36*5 36*6 36*7 36*8 36*9 ]);
            freqPhasePosition(freqPhasePosition==0) = NaN;
            probPhasePosition=freqPhasePosition./nansum(freqPhasePosition(:)); 

            [ phaseInfoJointThisShuff, phaseInfoConditionalThisShuff ] = miThreeD( probPhasePosition, probOccupyXY );
            phaseInfosJointSuffled(shufIdx) = phaseInfoJointThisShuff;
            phaseInfosCondSuffled(shufIdx) = phaseInfoConditionalThisShuff;
        end
        % summarize
        %
        pValMIjointPhase = (sum(phaseInfosJointSuffled>phaseInfoJoint)+1)/(shufflesToDo+1) ;
        medianMIjointPhaseShuff = median(phaseInfosJointSuffled);
        madamMIjointPhaseShuff = median( abs(phaseInfosJointSuffled-medianMIjointPhaseShuff));
        nineninePctMIjointPhaseShuff = prctile( phaseInfosJointSuffled, 99 );
        %
        pValMICondPhase = (sum(phaseInfosCondSuffled>phaseInfoConditional)+1)/(shufflesToDo+1) ;
        medianMIcondPhaseShuff = median(phaseInfosCondSuffled);
        madamMIcondPhaseShuff = median( abs(phaseInfosCondSuffled-medianMIcondPhaseShuff));
        nineninePctMIcondPhaseShuff = prctile( phaseInfosCondSuffled, 99 );

        try
            entropyOccupancy = entropyPhaseJoint.occupancy;
            entropyPhase = entropyPhaseJoint.spikeMetric;
        catch
            entropyOccupancy = NaN;
            entropyPhase = NaN;
        end

    else
        pValMIjointPhase = NaN;
        medianMIjointPhaseShuff =  NaN;
        madamMIjointPhaseShuff =  NaN;
        nineninePctMIjointPhaseShuff =  NaN;
        %
        pValMICondPhase =  NaN;
        medianMIcondPhaseShuff =  NaN;
        madamMIcondPhaseShuff =  NaN;
        nineninePctMIcondPhaseShuff =  NaN;
        
        entropyOccupancy = NaN;
        entropyPhase = NaN;
    end
    
    totalSpikesAnalyzed = sum(selectedSpikeIdxs>0);

    %% calculate spike rate Mutual Information
    %
    %threeDHistogram(                                 xx,                               yy,                         zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ )
    freqRatePosition=threeDHistogram( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRate(selectedTelIdxs>0), binResolution, binResolution, 5,  300,  300,   50,     150,     150,       0, 0);
    freqRatePosition(freqRatePosition==0)=NaN;    
    probRatePosition=freqRatePosition./nansum(freqRatePosition(:));
    [ spikeRateMIjoint, spikeRateMIconditional, entropyRateJoint, MIrateJoint, expViolRateJoint ] = miThreeD( probRatePosition );
    
        % significance testing with a shuffle.
    % because we care about the relationship between space and phase, we
    % shall randomly reorder the phase and location data relationship,
    % rather than jittering (at least for now)
    %
    % NOTE! : it is possible that the RNG may have a non-trivial amount of MI
    % (generating matrices of random probability distributions produces an
    % MI of ~.25 on average)
    %
    spikeX = telemetry.x(selectedTelIdxs>0); 
    spikeY = telemetry.y(selectedTelIdxs>0);
    rates  = spikeFiringRate(selectedTelIdxs>0);
    rng(0)
    %repmat(swrData.timestampSeconds(selectedSwr)',1000,1) + (((-1).^(round(rand(shufflesToDo,length(phase)))+1)).*( 0.5+( 1.5*rand(shufflesToDo,length(phase)))));
    %
    % there is a lot of data here. I guess I can try the shift wrapping
    % thing to prevent lots of extreme jumps in the firing rate. It seems
    % important to maintain the smoothness. Alternatively, I could shuffle
    % the spikes and rebuild the rate estimate. hmm...
    %
    %
    if shufflesToDo > 0

% ==== MOVED ABOVE =====
%
        rateInfosJointSuffled = zeros(1,shufflesToDo);
        rateInfosCondSuffled = rateInfosJointSuffled;
        for shufIdx = 1:shufflesToDo
            
            shufRates = rates(randperm(length(rates),length(rates)));
            
            freqRatePosition=threeDHistogram( spikeX, spikeY, shufRates, binResolution, binResolution, 5,  300,  300,   50,     150,     150,       0, 0);
            freqRatePosition(freqRatePosition==0) = NaN;
            probRatePosition=freqRatePosition./nansum(freqRatePosition(:)); 

            [ rateInfoJointThisShuff, rateInfoConditionalThisShuff ] = miThreeD( probRatePosition );
            rateInfosJointSuffled(shufIdx) = rateInfoJointThisShuff;
            rateInfosCondSuffled(shufIdx) = rateInfoConditionalThisShuff;
        end

        % summarize
        %
        pValMIjointRate = (sum(rateInfosJointSuffled>spikeRateMIjoint)+1)/(shufflesToDo+1) ;
        medianMIjointRateShuff = median(rateInfosJointSuffled);
        madamMIjointRateShuff = median( abs(rateInfosJointSuffled-medianMIjointRateShuff));
        nineninePctMIjointRateShuff = prctile( rateInfosJointSuffled, 99 );
        %
        pValMICondRate = (sum(rateInfosCondSuffled>spikeRateMIconditional)+1)/(shufflesToDo+1) ;
        medianMIcondRateShuff = median(rateInfosCondSuffled);
        madamMIcondRateShuff = median( abs(rateInfosCondSuffled-medianMIcondRateShuff));
        nineninePctMIcondRateShuff = prctile( rateInfosCondSuffled, 99 );
        
        try
            entropySpikeRate = entropyRateJoint.spikeMetric;
        catch
            entropySpikeRate = NaN;
        end
        
    else
        pValMIjointRate = NaN;
        medianMIjointRateShuff =  NaN;
        madamMIjointRateShuff =  NaN;
        nineninePctMIjointRateShuff =  NaN;
        %
        pValMICondRate =  NaN;
        medianMIcondRateShuff =  NaN;
        madamMIcondRateShuff =  NaN;
        nineninePctMIcondRateShuff =  NaN;
        
        entropyOccupancy = NaN;
        entropySpikeRate = NaN;
    end    
    
    %% outputs
    output.spikePlaceInfoPerSecond    = spikePlaceInfoPerSecond;
    output.spikePlaceInfoPerSpike     = spikePlaceInfoPerSpike;
    output.spikePlaceSparsity         = spikePlaceSparsity;
    output.spatialFiringRateCoherence = spatialFiringRateCoherence;
    output.firingAreaProportion       = firingAreaProportion;
    output.spatialFields              = spatialFields;
    output.firingAreaProportion       = firingAreaProportion;
    output.phaseInfoJoint             = phaseInfoJoint;
    
    output.phaseInfoConditional       = phaseInfoConditional;
    
    output.spikeRateMIjoint           = spikeRateMIjoint;
    
    output.spikeRateMIconditional     = spikeRateMIconditional;
    
    output.totalSpikesAnalyzed        = totalSpikesAnalyzed;
    output.totalTimeAnalyzed          = sum(selectedTelIdxs>0)/29.97;

    
    
    output.pValMIjointRate = pValMIjointRate;
    output.medianMIjointRateShuff  = medianMIjointRateShuff;
    output.madamMIjointRateShuff  = madamMIjointRateShuff;
    output.nineninePctMIjointRateShuff  =nineninePctMIjointRateShuff;
    %
    output.pValMICondRate = pValMICondRate;
    output.medianMIcondRateShuff = medianMIcondRateShuff;
    output.madamMIcondRateShuff = madamMIcondRateShuff;
    output.nineninePctMIcondRateShuff = nineninePctMIcondRateShuff;
    

    output.pValMIjointPhase = pValMIjointPhase;
    output.medianMIjointPhaseShuff =  medianMIjointPhaseShuff;
    output.madamMIjointPhaseShuff =  madamMIjointPhaseShuff;
    output.nineninePctMIjointPhaseShuff =  nineninePctMIjointPhaseShuff;
    %
    output.pValMICondPhase =  pValMICondPhase;
    output.medianMIcondPhaseShuff =  medianMIcondPhaseShuff;
    output.madamMIcondPhaseShuff =  madamMIcondPhaseShuff;
    output.nineninePctMIcondPhaseShuff =  nineninePctMIcondPhaseShuff;
    
    output.entropyOccupancy  = entropyOccupancy;
    output.entropySpikeRate  = entropySpikeRate;
    output.entropyPhase      = entropyPhase;
    
    
    output.entropyPhase = entropyPhaseJoint;
    output.MIphaseJoint = MIphaseJoint;
    output.expViolPhaseJoint = expViolPhaseJoint;
    
    output.entropyRate = entropyRateJoint;
    output.MIrateJoint = MIrateJoint;
    output.expViolRateJoint = expViolRateJoint;

    output.skaggsRatio = skaggsRatio;
    output.spikePlaceInfoArray = spikePlaceInfoArray;
    

    output.spikePlaceInfoPerSpikePval     = spikePlaceInfoPerSpikePval; 
    output.spikePlaceInfoPerSecondPval    = spikePlaceInfoPerSecondPval;
    output.spikePlaceSparsityPval         = spikePlaceSparsityPval;
    output.spatialFiringRateCoherencePval = spatialFiringRateCoherencePval;
    
    
return;






