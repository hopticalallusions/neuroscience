

table=readtable('/Volumes/AGHTHESIS2/rats/summaryFigures/tt_unit_info_metrics.csv', 'ReadVariableNames',true);
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);

figure; histogram(ds.spikePlaceInfoPerSpikeAllTrajectory, [ -10 -1 0 .2 .4 .6 .8 1 2 4 8 16 32 64 128 256 512 1024 ] )

figure; scatter( ds.phaseInfoConditionalAllTrajectory(:), ds.spikePlaceInfoPerSpikeAllTrajectory (:) )


figure; scatter( ds.spikeRateMIconditionalAllTrajectory(:), ds.spikePlaceInfoPerSecondAllTrajectory(:) )

figure; scatter( ds.spikeRateMIconditionalAllTrajectory(:), ds.spikeRateMIjointAllTrajectory(:))

figure; scatter( ds.phaseInfoConditionalAllTrajectory(:), ds.phaseInfoJointAllTrajectory (:) )

figure; scatter( ds.spikeRateMIconditionalAllTrajectory(:), ds.phaseInfoJointAllTrajectory (:) )

figure; histogram(ds.phaseInfoJointAllTrajectory,100)


ds.region(find(ds.spikeRateMIconditionalAllTrajectory>.5))


figure; scatter( ds.spikeRateMIconditionalAllTrajectory(:), ds.spikeRateMIjointAllTrajectory(:), 20, 'MarkerFaceColor', [ 0 0 0 ], 'MarkerEdgeColor', 'none' ); alpha(.3)


figure; histogram(ds.spikePlaceInfoPerSpikeAllTrajectory,100)


figure; scatter(ds.spikePlaceInfoPerSpikeOnMazeMoving,ds.totalOnMazeMoving)





figure; scatter( ds.spikeRateMIconditionalAllTrajectory(:), ds.phaseInfoJointAllTrajectory(:) ); hold on; scatter( ds.spikeRateMIconditionalAllTrajectory(3111), ds.phaseInfoJointAllTrajectory(3111), 'x', 'r')


find(strcmp(ds.ratratIdxFolders_ratratIdxffIdxTtNumCellIdTotalSpikesTotalOnMaz,'h7') & strcmp(ds.folder,'2018-08-10') & (ds.TT==15) & (ds.unit==5))

% 
%                figure;
%                scatter( telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0), 10, 'MarkerFaceColor', [ .5 .5 .5 ], 'MarkerEdgeColor', [ .5 .5 .5 ] ); hold on;
%                 scatter( telemetry.x(runMaskSelected>0), telemetry.y(runMaskSelected>0), 10, 'k', 'fillled' );
%                 scatter(  spikeData.x(spikeMaskSelectRuns>0), spikeData.y(spikeMaskSelectRuns>0), spikeData.speed(spikeMaskSelectRuns>0)/5, circColor(floor(spikeData.thetaPhase(spikeMaskSelectRuns>0))+1,:), 'filled'  );
%                 alpha(.8); colormap( circColor); colorbar; caxis( [0 360]); axis( [ -150 150 -150 150 ]); axis square;
%                 
%                 selectedTelIdxs = runMaskSelected;
%                 selectedSpikeIdxs = spikeMaskSelectRuns;
%                 
%                 selectedTelIdxs = runMaskAll;
%                 selectedSpikeIdxs = spikeMaskAllRuns;
%                 
%                 selectedTelIdxs = (telemetry.onMaze > 0) & (telemetry.speed > 10);
%                 selectedSpikeIdxs = (spikeData.onMaze > 0) & (spikeData.cellNumber == cellId) & (spikeData.speed > 10);
%                 
%                 binResolution = 10;
%                 freqXY = twoDHistogram( telemetry.x(selectedTelIdxs>0), telemetry.y(selectedTelIdxs>0), binResolution, 300, 300, 150  );
%                 probOccupyXY = freqXY./sum(freqXY(:));  % probability of being in place
%                 cellXYHist=twoDHistogram( spikeData.x(selectedSpikeIdxs>0), spikeData.y(selectedSpikeIdxs>0), binResolution, 300, 300, 150  );
%                 rateMap = cellXYHist./(freqXY./29.97); % spike rate
%                 figure; pcolor(rateMap); shading flat; colorbar; colormap('jet');
%                 



spatialInfoTable=readtable('/Volumes/AGHTHESIS2/rats/summaryFigures/tt_unit_info_metrics_v2019-June-05b_LSonly-v3.csv', 'ReadVariableNames',true);
swrCorrTable=readtable('~/Desktop/tt_report_shuff_h5h7_swr_xcorr.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
swrInfoTable = innerjoin(spatialInfoTable,swrCorrTable);
behaviortable=readtable('~/Downloads/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
newTable = innerjoin(swrInfoTable,behaviortable, 'Keys', [ 1 2 3 4 ]);



ds = table2dataset(newTable);

% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) ;%& ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);

figure; histogram(ds.spikePlaceInfoPerSpikeAllTrajectory, [ -10 -1 0 .2 .4 .6 .8 1 2 4 8 16 32 64 128 256 512 1024 ] )

figure; scatter( ds.phaseInfoConditionalAllTrajectory(:), ds.spikePlaceInfoPerSpikeAllTrajectory (:) )


figure; scatter( (ds.phaseInfoJointAllTrajectory(:)), (ds.spikePlaceInfoPerSecondAllTrajectory(:)) )



figure; scatter( (ds.thetaIndex(:)), (ds.spikePlaceInfoPerSpikeAllTrajectory(:)) )
figure; scatter( log10(ds.rateOnMazeMoving(:)), log10(ds.spikePlaceInfoPerSpikeAllTrajectory(:)) )
figure; scatter( (ds.thetaIndex(:)), (ds.phaseInfoJointAllTrajectory(:)) )
figure; scatter( log10(ds.rateOnMazeMoving(:)), log10(ds.phaseInfoJointAllTrajectory(:)) )
figure; scatter( (ds.thetaIndex(:)), (ds.rateOnMazeMoving(:))  )


selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ds.totalSpikesAnalyzedAllTrajectory > 100 ;%& ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
figure; scatter3( (ds.thetaIndex(selectWhat)), log10(ds.phaseInfoJointAllTrajectory(selectWhat)),  log10(ds.maxZScoreVal(selectWhat)), 'filled' ); hold on;
selectWhat = ( strcmp( 'CA1', ds.region ) & ds.totalSpikesAnalyzedAllTrajectory > 100 ) ;
selectWhat = strcmp( 'CA1', ds.region ) & ds.totalSpikesAnalyzedAllTrajectory > 100 & ds.thetaIndex > .3 & ds.thetaIndex < .45;
scatter3( (ds.thetaIndex(selectWhat)), log10(ds.phaseInfoJointAllTrajectory(selectWhat)),  log10(ds.maxZScoreVal(selectWhat)) , 'filled');
xlabel('theta index'); ylabel('phase info'); zlabel('SWR xcorr index');



selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ds.totalSpikesAnalyzedAllTrajectory > 100 ;%& ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
figure; scatter3( (ds.thetaIndex(selectWhat)), log10(ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat)),  log10(ds.maxZScoreVal(selectWhat)), 'filled' ); hold on;
selectWhat = ( strcmp( 'CA1', ds.region ) & ds.totalSpikesAnalyzedAllTrajectory > 100 ) ;
scatter3( (ds.thetaIndex(selectWhat)), log10(ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat)),  log10(ds.maxZScoreVal(selectWhat)), 'filled' );
xlabel('theta index'); ylabel('phase info'); zlabel('SWR xcorr index');

figure; histogram( log10(ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat)), -2.5:.02:1 )


selectWhat = strcmp( 'CA1', ds.region ) & ds.totalSpikesAnalyzedAllTrajectory > 100  & strcmp(ds.folder, '2018-08-10') & ds.TT==15 & ds.unit == 5 ;

scatter3( (ds.thetaIndex(selectWhat)), log10(ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat)),  log10(ds.maxZScoreVal(selectWhat)) , '*');

selectWhat = strcmp( 'CA1', swrCorrTable.region ) & strcmp(swrCorrTable.folder, '2018-08-10') & swrCorrTable.TT==15 & swrCorrTable.unit == 5 ;



selectWhat = strcmp( 'CA1', ds.region ) & strcmp(ds.folder, '2018-08-10') & ds.TT==15 & ds.unit == 5 ;




figure; scatter( (ds.maxZScoreVal(:)), (ds.spikePlaceInfoPerSpikeAllTrajectory(:)) )

figure; scatter( log10(ds.maxZScoreVal(:)), log10(ds.phaseInfoJointAllTrajectory(:)) )

figure; scatter( (ds.spikePlaceInfoPerSpikeAllTrajectory(:)), (ds.phaseInfoJointAllTrajectory(:)) )

selectWhat = (ds.spikePlaceInfoPerSpikeAllTrajectory < .1) & (ds.spikePlaceInfoPerSpikeAllTrajectory > 0);


figure; scatter( (ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat)), (ds.phaseInfoJointAllTrajectory(selectWhat)) )
figure; scatter( (ds.maxZScoreVal(selectWhat)), (ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat)) )



figure; scatter( (ds.spikePlaceInfoPerSpikeAllTrajectory(:)), (ds.phaseInfoJointAllTrajectory(:)) )


selectWhat = strcmp( 'CA1', ds.region ) & ds.totalSpikesAnalyzedAllTrajectory > 100;
figure; subplot(2,2,1); histogram(ds.spikePlaceInfoPerSpikeAllTrajectory(selectWhat),0:.05:7); title('skaggs')
subplot(2,2,2); histogram(ds.thetaIndex(selectWhat),0:.05:1); title('theta index')
subplot(2,2,3); histogram(ds.maxZScoreVal(selectWhat),0:.2:7); title('swr score')
subplot(2,2,4); histogram(ds.firingAreaProportionAllTrajectory(selectWhat),50); title('swr score')




selectWhat = strcmp( 'CA1', ds.region ) & ds.totalSpikesAnalyzedAllTrajectory > 100 & log10(ds.maxZScoreVal) > 1.7 & -0.5 > log10(ds.phaseInfoJointAllTrajectory);
tt=find(selectWhat);
for ii=1:length(tt);
     disp([ ds.rat(tt(ii)) ' ' ds.folder(tt(ii)) ' ' ds.TT(tt(ii))  ' ' ds.unit(tt(ii)) ]);
end
