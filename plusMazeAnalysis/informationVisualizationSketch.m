speedThreshold=12;

circColor=buildCircularGradient;
for cellId = 5 1:max(spikeData.cellNumber)

figure; 

sp=1;
ax(sp)=subplot(2,3,sp); hold off;
binResolution = 5;
selectedIdxs = (telemetry.speed>speedThreshold) & (telemetry.onMaze>0);
[ occupancy ] = twoDHistogram( telemetry.x( selectedIdxs), telemetry.y(selectedIdxs), binResolution, 300, 300, 150  );
occupancy(occupancy(:)==0)=NaN;
pcolor( ax(sp), occupancy ); colormap( ax(sp), 'jet' ); colorbar;
caxis( ax(sp), [ prctile(occupancy(find(occupancy)), 5) prctile(occupancy(find(occupancy)), 97) ] ); axis square;  shading flat; 
% shading interp; % looks cooler, but probably covers over some details?
title(['occupancy_{' num2str(sum(selectedIdxs)/29.97) ' s}']);


sp = 2;
ax(sp)=subplot(2,3,sp);
binResolution = 5;
selectedIdxs = (telemetry.speed>speedThreshold) & (telemetry.onMaze>0); hold off;
scatter( telemetry.x(selectedIdxs), telemetry.y(selectedIdxs),'k', 'filled' ); alpha(.2); hold on;
selectedIdxs = (spikeData.cellNumber == cellId) & (spikeData.speed>speedThreshold) & (spikeData.onMaze>0);
scatter( spikeData.x(selectedIdxs), spikeData.y(selectedIdxs), spikeData.speed(selectedIdxs)/speedThreshold, circColor(floor(spikeData.thetaPhase(selectedIdxs))+1,:), 'filled'  );
colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; axis([-150 150 -150 150]); shading flat;
title(['spike speed phase_{>' num2str(speedThreshold) 'cm/s}'])


sp = 3;
ax(sp)=subplot(2,3,sp); hold off;
binResolution = 5;
% selectedIdxs = (spikeData.cellNumber == cellId) & (spikeData.speed>speedThreshold) & (spikeData.onMaze>0);
% tempSpikeTimes = spikeData.timesSeconds(selectedIdxs);
% spikeFiringRate = zeros(3,length(telemetry.x));
% for ii=16:length(spikeFiringRate)-16
%     spikeFiringRate(1,ii) = sum( ( tempSpikeTimes > telemetry.xytimestampSeconds(ii-15) ) .* ( tempSpikeTimes < telemetry.xytimestampSeconds(ii+14) ) );
%     spikeFiringRate(2,ii) = sum( ( tempSpikeTimes > telemetry.xytimestampSeconds(ii-7) ) .* ( tempSpikeTimes < telemetry.xytimestampSeconds(ii+7) ) )*2;
%     spikeFiringRate(3,ii) = sum( ( tempSpikeTimes > telemetry.xytimestampSeconds(ii-3) ) .* ( tempSpikeTimes < telemetry.xytimestampSeconds(ii+3) ) )*4;
% end
% spikeFiringRate = mean(spikeFiringRate);
% 
% selectedIdxs = (telemetry.speed>speedThreshold) & (telemetry.onMaze>0);
% [ output, outputDev, outputFreq, hologram ] = twoDHistogram( telemetry.x(selectedIdxs), telemetry.y(selectedIdxs), spikeFiringRate, binResolution, 300, 300, 150, 0  );
% 
% == This version plots the firing rate map Skaggs style ==
%
% selectedIdxs = (spikeData.cellNumber == cellId) & (spikeData.speed>speedThreshold) & (spikeData.onMaze>0);
% [ spikeCountsPerPlace ] = twoDHistogram( spikeData.x( selectedIdxs), spikeData.y(selectedIdxs), binResolution, 300, 300, 150  );
% spikeCountsPerPlace(spikeCountsPerPlace(:)==0)=NaN;
% firingRate = spikeCountsPerPlace ./ (occupancy./29.97);
% pcolor( ax(sp), firingRate ); colormap( ax(sp), 'jet' ); colorbar;
% ss=sort(firingRate(:)); ss(isnan(ss))=[]; 
% caxis( ax(sp), [ prctile(occupancy(find(firingRate)), 5) ss(end-10) ] ); axis square;  shading flat; 
% pcolor( ax(4), output ); colormap( ax(4), 'jet' ); colorbar; shading flat; % NO shading interp; % interp does weird things to circular maps
% caxis( ax(4), [ prctile(output(find(output)), 5) prctile(output(find(output)), 97) ] );
% 
% == This version plots the firing rate map using the average firing rate population center, which is "pre-smoothed" ==
%
binResolution = 5;
[ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRate(selectedTelIdxs>0), binResolution, 300, 300, 150, false  );
pcolor(output); shading flat; colorbar; colormap('jet');
title(['rate map_{>' num2str(speedThreshold) 'cm/s}'])




sp=4;
ax(sp)=subplot(2,3,sp); hold off;
%for ii=1:61; for jj=1:61; ff=infoMat(ii,jj,:); infoMap(ii,jj)=nanmax(ff(~isnan(ff))); end; end;
infoMap = nanmean(expectViol,3);
infoMap(infoMap==0)=NaN;
pcolor( infoMap ); colormap( 'jet' ); colorbar; axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
title(['avg.Exp.Val.Viol.Phase_{' num2str(round(100*sum( expectViol(:)>0 & ~isnan(expectViol(:)) ) / sum( ~isnan(expectViol(:)) & (expectViol(:)~=0) ) )  ) '% pos 3d elmnts}'])



sp=5;
ax(sp)=subplot(2,3,sp); hold off;
binResolution = 5;
selectedIdxs = (spikeData.cellNumber == cellId) & (spikeData.speed>speedThreshold) & (spikeData.onMaze>0);
[ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( spikeData.x(selectedIdxs), spikeData.y(selectedIdxs), (spikeData.thetaPhaseRads(selectedIdxs)), binResolution, 300, 300, 150  );
output = rad2deg( output );
pcolor( ax(sp), output ); colormap( ax(sp), circColor ); colorbar; caxis( ax(sp), [0 360] ); axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
title(['avg phase map_{>' num2str(speedThreshold) 'cm/s}'])


sp=6;
ax(sp)=subplot(2,3,sp); hold off;
%for ii=1:61; for jj=1:61; ff=infoMat(ii,jj,:); infoMap(ii,jj)=nanmax(ff(~isnan(ff))); end; end;
infoMap = nanmean(expectViol,3);
infoMap(infoMap==0)=NaN;
pcolor( infoMap ); colormap( 'jet' ); colorbar; axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
title(['avg.Exp.Val.Viol.Rate_{' num2str(round(100*sum( expectViol(:)>0 & ~isnan(expectViol(:)) ) / sum( ~isnan(expectViol(:)) & (expectViol(:)~=0) ) )  ) '% pos 3d elmnts}'])



end




%% Visualize Expectation Violation
% This demononstrates how to visualize expectation violation in the
% probability matrix.

% 3D version
selectedSpikeIdxs = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId);
selectedSpikeIdxs = spikeMaskSelectRuns>0;
freqPhasePosition=threeDHistogram( spikeData.x(selectedSpikeIdxs>0), spikeData.y(selectedSpikeIdxs>0), spikeData.thetaPhase(selectedSpikeIdxs>0), binResolution, binResolution, 10, 300, 300, 360, 150, 150, 0, 0, [ 36*1 36*2 36*3 36*4 36*5 36*6 36*7 36*8 36*9 ]);
freqPhasePosition(freqPhasePosition==0) = NaN;
probPhasePosition=freqPhasePosition./nansum(freqPhasePosition(:));

[ phaseInfoJoint, phaseInfoConditional, entropy, infoMat, expectViol ] = miThreeD( probPhasePosition );
figure;
ccc=[];
colors=colormap('jet');
for aa=1:size(expectViol,1)
    for bb=1:size(expectViol,2)
        for cc=1:size(expectViol,3)
            if ~isnan(expectViol(aa,bb,cc)) && ( (round(expectViol(aa,bb,cc)*25) > 0) || (round(expectViol(aa,bb,cc)*25) < 0) )
                ccc= ceil( size(colors,1) * (expectViol(aa,bb,cc)-min(expectViol(:))) / ((max(expectViol(:))-min(expectViol(:))))) ;
                if ccc == 0; ccc = 1; elseif ccc>size(colors,1); cc=size(colors,1); end;
                thisColor = colors( ccc,:);
                scatter3(aa,bb,cc,abs(expectViol(aa,bb,cc)*25),thisColor,'filled'); hold on;
            end
        end
    end
end
colorbar


% 2D Version
figure;
%for ii=1:61; for jj=1:61; ff=expectViol(ii,jj,:); infoMap(ii,jj)=nanmax(ff(~isnan(ff))); end; end;
infoMap = nanmean(expectViol,3);
infoMap(infoMap==0)=NaN;
pcolor( infoMap ); colormap( 'jet' ); colorbar; axis square; shading flat; % NO shading interp; % interp does weird things to circular maps
title(['spike phase_{>' num2str(speedThreshold) 'cm/s}'])








colors(floor(size(colors,1) * (expectViol(aa,bb,cc)) * ((max(expectViol(:))-min(expectViol(:)))*25))+1,:)




expectViol = 

xx=spikeData.x(selectedIdxs);
yy=spikeData.y(selectedIdxs);
data=spikeData.thetaPhaseRads(selectedIdxs);

    figure;
    binResolution = 5;
    selectedTelIdxs = (telemetry.speed>speedThreshold) & (telemetry.onMaze>0);
    [ output, outputDev, outputFreq, hologram ] = twoDPopulationCenter( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), spikeFiringRate(selectedTelIdxs>0), binResolution, 300, 300, 150, false  );
    pcolor(output); shading flat; colorbar; colormap('jet');
