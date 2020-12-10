
% metadata.rat = 'da10';
% metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
% metadata.visualizeAll = true;
% metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
% metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
% metadata.swrLfpFile = 'CSC88.ncs'; % 63, 88, HF; best visual guess unfiltered.   also try 44-47, 52-55 from vta  44 is vta
% metadata.lfpStartIdx = 1;   % round(61.09316*32000);
% metadata.outputDir = [ '/Users/andrewhowe/data/plusMazeEphys/' metadata.rat '/' ];


recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };


byTrial.


byTrial.day               = [ ];
byTrial.trial             = [ ];
byTrial.isSubTrial        = [ ];
byTrial.error             = [ ];
byTrial.outOfBounds       = [ ];
byTrial.probe             = [ ];
byTrial.beeline           = [ ];
byTrial.sugarConsumed     = [ ];
byTrial.wasTeleported     = [ ];
for ii=1:length(recDays)
    byTrial.day               = [ byTrial.day            (ii-1)*ones(size(agg.(recDays{ii}).probe)) ];
    byTrial.trial             = [ byTrial.trial          agg.(recDays{ii}).trial                    ];
    byTrial.isSubTrial        = [ byTrial.isSubTrial     agg.(recDays{ii}).isSubTrial               ];
    byTrial.error             = [ byTrial.error          agg.(recDays{ii}).error                    ];
    byTrial.outOfBounds       = [ byTrial.outOfBounds    agg.(recDays{ii}).outOfBounds              ];
    byTrial.probe             = [ byTrial.probe          agg.(recDays{ii}).probe                    ];
    byTrial.beeline           = [ byTrial.beeline        agg.(recDays{ii}).beeline                  ];
    byTrial.sugarConsumed     = [ byTrial.sugarConsumed  agg.(recDays{ii}).sugarConsumed            ];
    byTrial.wasTeleported     = [ byTrial.wasTeleported  agg.(recDays{ii}).wasTeleported            ];
end

for ii=1:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        trialIdx=(ii-1)+jj;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
        xyIdxs  = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) .* ( agg.(recDays{ii}).xytimestampSeconds < agg.(recDays{ii}).leaveMazeToBucket(jj) ) );
        swrIdxs = find( ( agg.(recDays{ii}).swrTimes > agg.(recDays{ii}).leaveBucketToMaze(jj) ) .* ( agg.(recDays{ii}).swrTimes < agg.(recDays{ii}).leaveMazeToBucket(jj) ) );
        perTrial(trialIdx).xpos     = agg.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = agg.(recDays{ii}).ypos(xyIdxs);
        perTrial(trialIdx).xytimestampSeconds = agg.(recDays{ii}).xytimestampSeconds(xyIdxs);
        perTrial(trialIdx).swrTimes = agg.(recDays{ii}).swrTimes(swrIdxs)
        perTrial(trialIdx).swrXpos  = agg.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos  = agg.(recDays{ii}).swrYpos(swrIdxs);
        
    end
end






figure; 
binResolution = 50;
for ii=1:length(recDays)
    subPlotIdx = 11*floor(ii/6) + mod(ii,6) ;
    xyHist = twoDHistogram( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, binResolution , 720, 480 );
    swrXyHist = twoDHistogram( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, binResolution , 720, 480 );
    subplot(4,5,subPlotIdx);
%    idxsToCancel = find(xyHist(:)./29.97 < 1 );
%    swrXyHistAdj    = swrXyHist;
%    swrXyHistAdj(idxsToCancel) = 0;
    imagesc(flipud(swrXyHist./xyHist));
    colormap(build_NOAA_colorgradient);
    subPlotIdx = subPlotIdx + 5 ;
    subplot(4,5,subPlotIdx);
    x   = agg.(recDays{ii}).xpos';
    y   = agg.(recDays{ii}).ypos';
    z   = zeros(size(x));
    col = agg.(recDays{ii}).xytimestampSeconds';  % This is the color, vary with x in this case.
    surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    %plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 'Color', [.1 .1 .1 .1], 'LineWidth', 1 ); 
    xlim([ 0 720 ]); ylim([ 0 480 ]); hold on;
    scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, 10, 'ok', 'MarkerEdgeAlpha', 0.5 );
end


for ii=1:length(recDays)
 disp( num2str(  11*floor(ii/6) + mod(ii,6) + 5 ));
end




x =  agg.(recDays{ii}).xpos;
y =  agg.(recDays{ii}).ypos;
z =  zeros(size(x));
col =  agg.(recDays{ii}).xytimestampSeconds;  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);

    
    
figure;
    x   = agg.(recDays{ii}).xpos';
    y   = agg.(recDays{ii}).ypos';
    z   = zeros(size(x));
    col = agg.(recDays{ii}).xytimestampSeconds';  % This is the color, vary with x in this case.
    surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
xlim([ 0 720 ]); ylim([ 0 480 ]); hold on;

    scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, 2.5, 'o', 'MarkerEdgeAlpha', 0.2 );



% xyHist = twoDHistogram( xposOg, yposOg, 1 , 720, 480 );
% figure; %xyHist(1,1)=0;
% imagesc(flipud(xyHist));
% colormap(build_NOAA_colorgradient); colorbar;
% caxis([-5 25])
% 
% xyHist = twoDHistogram( xpos, ypos, 1 , 720, 480 );
% figure; %xyHist(1,1)=0;
% imagesc(flipud(xyHist));
% colormap(build_NOAA_colorgradient); colorbar;
% caxis([-5 25])


    %figure;
    %subplot(1,3,1); imagesc(flipud(cellXHist)); colormap(build_NOAA_colorgradient); title('speed filtered firing map'); xlabel('x position'); ylabel('y position');
    %subplot(1,3,2); plot( xpos, ypos, 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); xlim([ 0 720 ]); ylim([ 0 480 ]); scatter( xpos( speedFilteredSpikeXyIdxs ), ypos( speedFilteredSpikeXyIdxs ), 10*speed( speedFilteredSpikeXyIdxs ), 'o', 'Filled', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1 ); legend(['cell ' num2str( cellId )] ); title('firing locations'); xlabel('x position'); ylabel('y position');
    %subplot(1,3,3); imagesc(flipud(cellXHist./xyHist)); colormap(build_NOAA_colorgradient); title('firing locations'); xlabel('x position'); ylabel('y position');
