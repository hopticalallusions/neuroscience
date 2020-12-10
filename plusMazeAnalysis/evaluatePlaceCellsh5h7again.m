% '2018-07-11' -- this telemetry file doesn't work for some reason.
rat = { 'h5' 'h7' }; %'da5' 'da10' 'h1'  };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-08-31' '2018-09-04' '2018-09-05' };
folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC44.ncs' 'CSC64.ncs'};
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% SWR channels to use
swrLfpNames.da5  = { 'CSC6.ncs'  'CSC26.ncs' 'CSC28.ncs'  };
swrLfpNames.da10 = { 'CSC81.ncs' 'CSC61.ncs' 'CSC32.ncs' };
swrLfpNames.h5   = { 'CSC36.ncs' 'CSC87.ncs' };
swrLfpNames.h7   = { 'CSC44.ncs' 'CSC56.ncs' 'CSC54.ncs' }; 
swrLfpNames.h1   = { 'CSC84.ncs' 'CSC20.ncs' 'CSC17.ncs'  'CSC32.ncs'  'CSC64.ncs' };  % first two are the favorites

buildTtPositionDatabase;

gcf=figure(1);

thisTheta = 1; % 1:length(thetaLfpNames.(rat{ratIdx}))
thisSwr = 1; 
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
speedThreshold = 10;
binResolution = 10;

fileID = fopen([ basePathOutput 'tt_unit_placeInfo.csv'],'w');
%make header
message = [ 'rat,' 'folder,' 'TT,' 'unit,' 'placeInfo,' 'spikeSparsity,' 'peakFiringRate,' 'spikeCount,' 'region' ];
fprintf( fileID, '%s\n' , message);

for ratIdx =  1:length( rat )
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')

            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');

            %% smooth the telemetry speed data
            speedOnMaze=telemetry.speed(telemetry.onMaze>0);
            % not doing this right now because it will warp the spatial
            % information metric, which is not so good
%             data = speedOnMaze;
%             baseWidth = 60;
%             width=baseWidth;
%             smoothedSpeedOnMaze = zeros(size(speedOnMaze));
%             for ii=1:baseWidth+1
%                 smoothedSpeedOnMaze(ii) = median(speedOnMaze(1:width+ii));
%             end
%             for ii=baseWidth+1:length(speedOnMaze)-baseWidth-1
%                 if speedOnMaze(ii) > 15
%                     width = round(baseWidth*15/data(ii));
%                 else
%                     width = baseWidth; 
%                 end
%                 smoothedSpeedOnMaze(ii) = median(speedOnMaze(ii-width:ii+width));
%             end
%             for ii=length(speedOnMaze)-baseWidth-1:length(speedOnMaze)
%                 smoothedSpeedOnMaze(ii) = median(speedOnMaze(ii:length(speedOnMaze)));
%             end

            idxs  = (telemetry.onMaze > 0) & (telemetry.speed >= speedThreshold );
            xOnMazeMoving = telemetry.x(idxs);
            yOnMazeMoving = telemetry.y(idxs);
            idxs  = (telemetry.onMaze > 0) & (telemetry.speed < speedThreshold );
            xOnMazeStill = telemetry.x(idxs);
            yOnMazeStill = telemetry.y(idxs);
            
            
            %% PLOTTING ROUTINES
            xyHistStill = twoDHistogram( xOnMazeStill, yOnMazeStill, binResolution, 300, 300, 150 );
            %subplot(2,5,1); hold off; scatter(xOnMazeStill,yOnMazeStill,10,'k','filled'); alpha(.05); ylim([-150 150]); xlim([-150 150]); title('xy position'); axis square;
            %subplot(2,5,2); hold off; imagesc(flipud(xyHistStill./29.97)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist[<speed]');  axis square;
            xyHistMoving = twoDHistogram( xOnMazeMoving, yOnMazeMoving, binResolution, 300, 300, 150 );
            %subplot(2,5,6); hold off; scatter(xOnMazeMoving,yOnMazeMoving,10,'k','filled'); alpha(.05); ylim([-150 150]); xlim([-150 150]); title('xy position'); axis square;
            %subplot(2,5,7); hold off; imagesc(flipud(xyHistMoving./29.97)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist[>speed]');  axis square;            
            
                for ttNum =  1:32
                    if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' )
                    
                        disp( [ 'AVAILABLE : ' basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'])
                        
                        load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );

                        for cellId =   1:max(spikeData.cellNumber)
                            try 
                           
                                idxs  = (spikeData.onMaze > 0) & (spikeData.speed > speedThreshold ) & (spikeData.cellNumber == cellId );
                                spikeEventsOnMaze = sum(idxs);

                                if spikeEventsOnMaze > 10
                                    spikeXOnMazeStill = spikeData.x(idxs);
                                    spikeYOnMazeStill = spikeData.y(idxs);
                                    subplot(1,2,1); hold off; scatter(xOnMazeMoving,yOnMazeMoving,10,'k','filled'); alpha(.05); ylim([-150 150]); xlim([-150 150]); title('xy position'); axis square;
                                    subplot(1,2,1); hold on; scatter(spikeXOnMazeStill,spikeYOnMazeStill,10,'xr'); alpha(.2); ylim([-150 150]); xlim([-150 150]); title('unit position'); axis square;
                                    spikeXYHistMoving = twoDHistogram( spikeXOnMazeStill, spikeYOnMazeStill, binResolution, 300, 300, 150  );
                                    %subplot(1,2,2); hold off; imagesc(flipud(spikeXYHistMoving./29.97)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('unit heat[<speed]');  axis square;
                                    %
                                    rateMap=(spikeXYHistMoving./xyHistMoving)*29.97;
                                    subplot(1,2,2); hold off; imagesc(flipud(rateMap)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('unit rate');  axis square;
                                    %
                                    ppxy = xyHistMoving/sum(xyHistMoving(:)); % probability of being in place
                                    ppspike = spikeXYHistMoving./(xyHistMoving./30); % spike rate
                                    spikePlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
                                    spikePlaceInfo = nansum(spikePlaceInfoVector(:));
                                    %
                                    spikePlaceSparsityVector = ( ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
                                    spikePlaceSparsity = nansum(spikePlaceSparsityVector(:));

                                    message = ([ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str(ttNum) ',' num2str(cellId) ',' num2str(spikePlaceInfo) ',' num2str(spikePlaceSparsity) ',' num2str(max(ppspike(:))) ',' num2str(spikeEventsOnMaze) ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ]);
                                    disp(message);
                                    fprintf( fileID, '%s\n' , message);

                                    print(gcf(1), [ basePathOutput  'placeRate_' rat{ratIdx} '_' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '_' folders.(rat{ratIdx}){ffIdx} '_TT' int2str(ttNum) '_C' num2str(cellId) '.png'],'-dpng','-r200');
                                    clf(gcf(1));
                                else
                                    disp(['SKIPPED : Insufficient spikes ' rat{ratIdx} '_' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '_' folders.(rat{ratIdx}){ffIdx} '_TT' int2str(ttNum) '_C' num2str(cellId) ])
                                end
                            catch err
                                disp( [ 'FAILED : ' rat{ratIdx} '_' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} '_' folders.(rat{ratIdx}){ffIdx} '_TT' int2str(ttNum) '_C' num2str(cellId) ] );
                                err.getReport
                            end
                        end
                    end
                end
        end
    end
end


fclose(fileID);

return;


for cellId =   1:max(spikeData.cellNumber)
    idxs  = (spikeData.onMaze > 0) & (spikeData.speed > speedThreshold ) & (spikeData.cellNumber == cellId );
    spikeEventsOnMaze = sum(idxs);
    disp(num2str(spikeEventsOnMaze));
end









if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ], 'file' )
            
                load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );

                idxs  = (swrData.onMaze > 0) & (swrData.speed < speedThreshold );
                swrEventsOnMaze = sum(idxs);
                swrXOnMazeStill = swrData.x(idxs);
                swrYOnMazeStill = swrData.y(idxs);
                subplot(2,5,3); hold off; scatter(swrXOnMazeStill,swrYOnMazeStill,10,'r','filled'); alpha(.05); ylim([-150 150]); xlim([-150 150]); title('swr position'); axis square;
                swrXYHistStill = twoDHistogram( swrXOnMazeStill, swrYOnMazeStill, binResolution, 300, 300, 150  );
                subplot(2,5,4); hold off; imagesc(flipud(swrXYHistStill./29.97)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('swr heat[<speed]');  axis square;
                %
                rateMap=(swrXYHistStill./xyHistStill)*29.97;
                subplot(2,5,5); hold off; imagesc(flipud(rateMap)); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('swr rate');  axis square;
                %
                ppxy = xyHistStill/sum(xyHistStill(:)); % probability of being in place
                ppspike = swrXYHistStill./(xyHistStill./30); % spike rate
                spikePlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
                spikePlaceInfo = nansum(spikePlaceInfoVector(:));
                %
                spikePlaceSparsityVector = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
                spikePlaceSparsity = nansum(spikePlaceSparsityVector(:));
                disp([  ' | cell '  ' | place info = ' num2str(spikePlaceInfo) ' bits | spike sparsity = ' num2str(spikePlaceSparsity) ' | peak firing rate = ' num2str(max(ppspike(:))) ' Hz  | n = ' num2str(swrEventsOnMaze) ' events ' ]);
  
end




for ttIdx=1:length(ttFilenames)

    [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ dir ttFilenames{ttIdx} ]);

    % simple speed filter hack
    cellPosFast = cellPosAll(:,cellSpeedAll>speedThreshold);
    cellNFast = cellNumber(cellSpeedAll>speedThreshold);
    cellTimesFast = cellTimesAll(cellSpeedAll>speedThreshold);
    cellTimesFastSeconds = (cellTimesFast-lfpTimestamps(1))/1e6;
    %
    cellPosSlow = cellPosAll(:,cellSpeedAll<=speedThreshold);
    cellNSlow = cellNumber(cellSpeedAll<=speedThreshold);
    cellTimesSlow = cellTimesAll(cellSpeedAll<=speedThreshold);
    cellTimesSlowSeconds = (cellTimesSlow-lfpTimestamps(1))/1e6;
    %
    for whichCell=0:max(cellNFast)
        if sum(cellNFast==whichCell) > 2
            cellXHist = twoDHistogram( cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), binResolution, 650, 650 ); 
            %
            %rateMap=(cellXHist./xyHist)*29.97;
            %
            ppxy = xyHistMoving/sum(xyHistMoving(:)); % probability of being in place
            ppspike = cellXHist./(xyHistMoving./30); % spike rate
            spikePlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
            spikePlaceInfo = nansum(spikePlaceInfoVector(:));
            %
            spikePlaceSparsityVector = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
            spikePlaceSparsity = nansum(spikePlaceSparsityVector(:));
            %
            disp([ ttFilenames{ttIdx} ' | cell ' num2str(whichCell) ' | place info = ' num2str(spikePlaceInfo) ' bits | spike sparsity = ' num2str(spikePlaceSparsity) ' | peak firing rate = ' num2str(max(ppspike(:))) ' Hz  | n = ' num2str(sum(cellNFast==whichCell)) ' spikes ' ]);
            %
            figure(gcf(1)); clf;
            subplot(4,5,1); pcolor(ppspike); colormap('jet');   colorbar; title('rough ratemap'); % hold off; imagesc(flipud(xyHist>0)); colormap([ 1 1 1; 0 0 0; colormap('jet')]);
            % plot cell autocorrelegrams
            subplot(4,5,3); hold off
            [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell) );
            plot( lagtimes, xcorrValues, 'k' ); 
            hold on;
            [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell) );
            plot( lagtimes, xcorrValues, 'r' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell) );
            plot( lagtimes, xcorrValues, 'g' ); 
            title('spk autocorrelegram')
            %
            subplot(4,5,[4 5 9 10]); hold off;
            plot(xrpos,yrpos, 'Color', [ 0 0 0 .15]); hold on; 
            scatter(cellPosSlow(1,(cellNSlow==whichCell)), cellPosSlow(2,(cellNSlow==whichCell)), 20, '.' ); 
            if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
            scatter(cellPosFast(1,(cellNFast==whichCell)), cellPosFast(2,(cellNFast==whichCell)), 20, 'o', 'filled' ); 
            if sum(cellNFast==whichCell) < 2000 ; alpha(.2); else alpha(500/sum((cellNFast==whichCell))); end; 
            xlim([0 825]); ylim([0 650]); title([ 'trace plot; ' num2str(sum(cellNFast==whichCell)) ' spikes']);
            %
            subplot(4,5,2); hold off; 
            [ xcorrValues, lagtimes ] = acorrEventTimes( hiGammaPeakTimes );
            hold on;
            plot( lagtimes, xcorrValues, 'k' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( hiGammaPeakTimes(hiGammaSpeedAll<=speedThreshold) );
            plot( lagtimes, xcorrValues, 'r' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( hiGammaPeakTimes(hiGammaSpeedAll>speedThreshold) );
            plot( lagtimes, xcorrValues, 'g' ); 
            scatter( 0, 0, 1, '.', 'k' ); alpha( .01 ); %hack to force to zero.
            title('hi \gamma autocorrelegram');
            %
            subplot(4,5,8); hold off; histogram( real(log10(diff(cellTimesAllSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
            % plot waveforms
            temp=(spikeWaveforms((cellNumber==whichCell),:,:)); ttYLims=[ min(temp(:)) max(temp(:)) ]; 
            subplot(4,5,6); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
            subplot(4,5,7); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
            subplot(4,5,11); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
            subplot(4,5,12); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
            %subplot(1,2,1); imagesc(flipud(cellXHist)); colormap([ 1 1 1; colormap('jet')]); colorbar; title('cell spike X place (n)');
            subplot(4,5,[ 14 15 19 20 ]); hold off; toPlot=twoDGuassianSmooth(ppspike); pcolor(toPlot); colormap('jet'); toPlotFlat=toPlot(:); caxis([ min(toPlotFlat(toPlotFlat>0)) max(toPlot(:)) ] ); colorbar; title(['smooth ratemap | info=' num2str(spikePlaceInfo)]); ylabel(['peakRate=' num2str(max(ppspike(:))) ' Hz'])
              % imagesc(flipud(plotppspike)); colormap([ 1 1 1; 0 0 0; colormap('jet')]);  
            colormap([ 1 1 1; 0 0 0; colormap('jet')]);
            % plot swr X cell firing
            subplot(4,5,13);  hold off;
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes );
            plot(lagtimes,xcorrValues, 'k'); % ylim([0 max(xcorrValues)]); % assume that all will have the max?
            hold on;
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), swrPeakTimes(swrSpeedAll>speedThreshold) );
            plot(lagtimes,xcorrValues,'g'); 
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), swrPeakTimes(swrSpeedAll<=speedThreshold) );
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            plot(lagtimes,xcorrValues,'r'); 
            title('swr Xcorr spike');
            % plot multiple cross correlations
            subplot(4,5,18); hold off;
            [ xcorrValues, lagtimes ] = acorrEventTimes( swrPeakTimes );
            hold on;
            plot( lagtimes, xcorrValues, 'k' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll<=speedThreshold) );
            plot( lagtimes, xcorrValues, 'r' ); 
            [ xcorrValues, lagtimes] = acorrEventTimes( swrPeakTimes(swrSpeedAll>speedThreshold) );
            plot( lagtimes, xcorrValues, 'g' ); 
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            title('swr autocorrelegram');
            %
            try
                subplot(4,5,17); hold off;
                rose(thetaPhase(floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1),36);
                hold on;
                rose(thetaPhase(floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1),36);
                rose(thetaPhase(floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1),36);
                title('\Theta phase')
            catch
                subplot(4,5,17); hold off;
                tidx=floor(cellTimesAllSeconds(cellNumber==whichCell)*32000)+1; tidx=tidx(tidx>0);
                rose(thetaPhase(tidx),36);
                hold on;
                tidx=floor(cellTimesFastSeconds(cellNFast==whichCell)*32000)+1; tidx=tidx(tidx>0);
                rose(thetaPhase(tidx),36);
                tidx=floor(cellTimesSlowSeconds(cellNSlow==whichCell)*32000)+1; tidx=tidx(tidx>0);
                rose(thetaPhase(tidx),36);
                title('\Theta phase');
                subplot(4,5,17); rose(thetaPhase(tidx),36); title('\Theta phase')
                warning(['removed ' num2str(sum(tidx>0)) ' entries from rose plot'])
            end
            %
            subplot( 4, 5, 16); hold off;
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), hiGammaPeakTimes );
            plot( lagtimes, xcorrValues, 'k' ); % ylim([0 max(xcorrValues)]); % assume that all will have the max?
            hold on;
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), hiGammaPeakTimes(hiGammaSpeedAll>speedThreshold) );
            plot( lagtimes, xcorrValues, 'g' ); 
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), hiGammaPeakTimes(hiGammaSpeedAll<=speedThreshold) );
            scatter( 0, 0, 1, '.', 'k' ); alpha(.01); % hack to force to zero.
            plot( lagtimes, xcorrValues, 'r' ); 
            title('hi \gamma Xcorr spike');
            %
            print(gcf(1), [ '~/data/h1_placeMap_' dateStr  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
            clf(gcf(1));
            
        else
            warning([ ' not enough spikes w/ ' num2str(sum(cellNFast==whichCell)) ]);
        end
    end
end
    
return; 