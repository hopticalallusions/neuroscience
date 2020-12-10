%%
% test for significance of SWR cross correlations with 

% h1 -- 2018-08-27a -- TT1 -- C1 --

clear all;

% '2018-07-11' -- this telemetry file doesn't work for some reason.
rat = { 'da5' 'da10' 'h1' }; % 'h5' 'h7' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC44.ncs'  'CSC64.ncs'};
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% SWR channels to use
swrLfpNames.da5  = { 'CSC6.ncs'  'CSC26.ncs' 'CSC28.ncs'  };
swrLfpNames.da10 = { 'CSC81.ncs' 'CSC61.ncs' 'CSC32.ncs' };
swrLfpNames.h5   = { 'CSC36.ncs' 'CSC87.ncs' };
swrLfpNames.h7   = { 'CSC44.ncs' 'CSC56.ncs' 'CSC54.ncs' }; 
swrLfpNames.h1   = { 'CSC84.ncs' 'CSC20.ncs' 'CSC17.ncs'  'CSC32.ncs'  'CSC64.ncs' };  % first two are the favorites


thisTheta = 1; % 1:length(thetaLfpNames.(rat{ratIdx}))
thisSwr = 1; 

shufflesToDo = 1000;
xcorrBinSize = 0.05;
maxLagTime = 2;

figure(1);

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';

fileID = fopen([ basePathOutput 'tt_report.txt'],'w');

for ratIdx =  1:length( rat )
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')

            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');

            if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ], 'file' )
            
                load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );

                for ttNum =  1:32
                    if exist( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' )
                    
                        disp( [ 'AVAILABLE : ' basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'])
                        
                        load( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );

                        for cellId =   1:max(spikeData.cellNumber)
                            clf(1);
                            
                            selectedSwr = (swrData.onMaze < 0) & (swrData.speed<10);
                            selectedSpikes = (spikeData.onMaze < 0) & (spikeData.speed<10) & (spikeData.cellNumber == cellId);
                            
                            [ xcorrValues, lagtimes] = xcorrEventTimes( spikeData.timesSeconds( selectedSpikes ), swrData.timestampSeconds(selectedSwr), xcorrBinSize, maxLagTime );
                            reshifts = zeros(1,shufflesToDo);
                            xcorrShuff = zeros(shufflesToDo,length(xcorrValues));
                            xcorrShuffZscored = zeros(size(xcorrShuff));
                            rng(0)
                            swrShuffled = repmat(swrData.timestampSeconds(selectedSwr)',1000,1)+ (((-1).^(round(rand(shufflesToDo,length(swrData.timestampSeconds(selectedSwr))))+1)).*( 0.5+( 1.5*rand(shufflesToDo,length(swrData.timestampSeconds(selectedSwr))))));
                            binsToZscore=round(.5/xcorrBinSize);
                            for shuffleIdx = 1:shufflesToDo
                                xcShuf = xcorrEventTimes( spikeData.timesSeconds( selectedSpikes ), swrShuffled(shuffleIdx,:), xcorrBinSize, maxLagTime );
                                xcorrShuff(shuffleIdx,:) = xcShuf;
                                xcorrShuffZscored(shuffleIdx,:) = (xcShuf-mean( [ xcShuf(1:binsToZscore) xcShuf(end-binsToZscore:end) ]))./std( [ xcShuf(1:binsToZscore) xcShuf(end-binsToZscore:end) ]);
                            end
                            subplot(2,1,1);
                            hold off;
                            scatter(0,0,1,'.','k'); alpha(.01); %hack to force to zero.
                            hold on;
                            line( [ lagtimes(1) lagtimes(end)], [ 0 0 ], 'Color', 'b', 'LineStyle' ,':' );
                            fill_between_lines(lagtimes, prctile(xcorrShuffZscored,0.5), prctile(xcorrShuffZscored,99.5),1); alpha(.2); hold on;
                            fill_between_lines(lagtimes, prctile(xcorrShuffZscored,2.5), prctile(xcorrShuffZscored,97.5),2); alpha(.2);
                            fill_between_lines(lagtimes, prctile(xcorrShuffZscored,25), prctile(xcorrShuffZscored,75),3); alpha(.2);
                            plot(lagtimes, prctile(xcorrShuffZscored,50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
                            zScore = (xcorrValues-mean( [ xcorrValues(1:binsToZscore) xcorrValues(end-binsToZscore:end) ]))./std( [ xcorrValues(1:binsToZscore) xcorrValues(end-binsToZscore:end) ]);
                            plot(lagtimes,zScore, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
                            ninetyninthpctl = prctile(xcorrShuffZscored,99.5);
                            idxCircaSwr = (1+round(maxLagTime/xcorrBinSize))-round(.5/xcorrBinSize):(1+round(maxLagTime/xcorrBinSize))+round(.5/xcorrBinSize);
                            totalPosDeviance = (zScore(idxCircaSwr)-ninetyninthpctl(idxCircaSwr));
                            totalPosDeviance = sum( totalPosDeviance( totalPosDeviance > 0 ) );
                            firstpctl = prctile(xcorrShuffZscored,0.5);
                            totalNegDeviance = firstpctl(idxCircaSwr)-zScore(idxCircaSwr);
                            totalNegDeviance = sum( totalNegDeviance( totalNegDeviance > 0 ) );
                            title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' tt' int2str(ttNum) ' c' int2str(cellId) '' ]);
                            ylabel('SWR X spike (z-score)');
                            subplot(2,1,2);
                            hold off;
                            logPVal=1-(((1+sum(xcorrShuffZscored>repmat(zScore,1000,1)))/(shufflesToDo+1)));
                            plot(lagtimes,logPVal)
                            hold on;
                            tempIdx=find(logPVal>.99 | logPVal<0.01);
                            scatter(lagtimes(tempIdx),logPVal(tempIdx), 'o');
                            ylabel('1-sum(real>shuf) ')
                            xlabel('lag time (s)')
                            legend( ['sumPwr ' num2str(totalPosDeviance)], [ 'ptsAbove ' num2str(length(lagtimes(tempIdx))) ] );
                            
                            [ maxZScoreVal, maxZScoreIdx ] = max( abs( zScore ) );
                            message = ([ rat{ratIdx} ' -- ' folders.(rat{ratIdx}){ffIdx} ' -- TT' int2str(ttNum) ' -- C' num2str(cellId) ' -- binSize ' num2str(round(xcorrBinSize*1000)) ' ms -- sumPosPwr ' num2str(totalPosDeviance) ' -- sumNegPwr ' num2str(totalNegDeviance) ' -- ptsAbove ' num2str(length(lagtimes(tempIdx))) ' -- maxZScoreVal ' num2str(maxZScoreVal) ' -- peakXcorrLagTime ' lagtimes( maxZScoreIdx )  ]);
                            disp(message)
                            fprintf( fileID, '%s\n' , message);
                            %
                            print(gcf,[ basePathOutput rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_swrXspike_shuff_TT' int2str(ttNum) '_C' num2str(cellId) '_binSize_' num2str(round(xcorrBinSize*1000)) 'ms.png'],'-dpng','-r200');
                            %
                            shuffleData.xcorrBinSize         = xcorrBinSize;
                            shuffleData.shufflesDid          = shufflesToDo;
                            shuffleData.maxLagTime           = maxLagTime;
                            shuffleData.xcZScore             = zScore;
                            shuffleData.xcorrValues          = xcorrValues;
                            shuffleData.xcShuf               = xcShuf;
                            shuffleData.xcorrShuffZscored    = xcorrShuffZscored;
                            shuffleData.xcShufZNineNineLower = prctile( xcorrShuffZscored,  0.5 );
                            shuffleData.xcShufZNineNineUpper = prctile( xcorrShuffZscored, 99.5 );
                            shuffleData.xcShufZNineFiveLower = prctile( xcorrShuffZscored,  2.5 );
                            shuffleData.xcShufZNineFiveUpper = prctile( xcorrShuffZscored, 97.5 );
                            shuffleData.xcShufZFiveOhLower   = prctile( xcorrShuffZscored, 25   );
                            shuffleData.xcShufZFiveOhUpper   = prctile( xcorrShuffZscored, 75   );
                            shuffleData.xcShufZFifty         = prctile( xcorrShuffZscored, 50   );
                            shuffleData.peakXcorrLagTime     = lagtimes( maxZScoreIdx );
                            shuffleData.maxZScoreVal         = maxZScoreVal;
                            shuffleData.lagtimes             = lagtimes;  % this didn't get saved for a bunch of things. arg.
                            %
                            save( [ basePathOutput rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_swrXspike_shuff_TT' int2str(ttNum) '_C' num2str(cellId) '_binSize_' num2str(round(xcorrBinSize*1000)) 'ms.mat'], 'shuffleData' );
                        end
                    else
                        disp([ 'SKIPPING : '  basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) 'a.mat' ])
                    end
                end
            else
                disp( [ 'UNAVAILABLE : '  basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ])
            end
        else
            disp( [ 'UNAVAILABLE : '  basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ] )
        end
    end
end

fclose(fileID);

return;













%%
% test for significance of SWR cross correlations with 

xcorrBinSize=0.02; % seconds
maxLagTime=2; % seconds


clear all; close all;

% '2018-07-11' -- this telemetry file doesn't work for some reason.
rat = { 'h5' 'h7'};
folders.h5 = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7 = {  '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-27' };
% all the putative LS tetrodes
ttFilenames.h5 = { 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' };
ttFilenames.h7 = { 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT30a.NTT' 'TT31a.NTT' 'TT32a.NTT'  };



for ratIdx = 1:length( rat )
    for ffIdx = 1:length( folders.(rat{ratIdx}) )
        if exists([ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ])
            basePath = [ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '/' ];
            load([ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            for ttNum = 1:32
                if exists( [ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' int2str(ttNum) 'a.mat'] )

                    load( [ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' int2str(ttNum) 'a.mat'] );

                    for cellId = 1:max(spikeData.cellNumber)
                        [ xcorrValues, lagtimes] = xcorrEventTimes( spikeData.timesSeconds( spikeData.cellNumber==cellId), swrData.timestampSeconds(selected), xcorrBinSize, maxLagTime );
                        shufflesToDo = 1000;
                        reshifts = zeros(1,shufflesToDo);
                        xcorrShuff = zeros(shufflesToDo,length(xcorrValues));
                        xcorrShuffZscored = zeros(size(xcorrShuff));

                        swrShuffled = repmat(swrData.timestampSeconds(selected)',1000,1)+ (((-1).^(round(rand(shufflesToDo,length(swrData.timestampSeconds(selected))))+1)).*( 0.5+( 1.5*rand(shufflesToDo,length(swrData.timestampSeconds(selected))))));

                        for shuffleIdx = 1:shufflesToDo
                            xcShuf = xcorrEventTimes( spikeData.timesSeconds( spikeData.cellNumber==cellId), swrShuffled(shuffleIdx,:), xcorrBinSize, maxLagTime );
                            xcorrShuff(shuffleIdx,:) = xcShuf;
                            xcorrShuffZscored(shuffleIdx,:) = (xcShuf-mean( [ xcShuf(1:25) xcShuf(end-24:end) ]))./std( [ xcShuf(1:25) xcShuf(end-24:end) ]);
                        end
                        figure;
                        subplot(2,1,1);
                        scatter(0,0,1,'.','k'); alpha(.01); %hack to force to zero.
                        fill_between_lines(lagtimes, prctile(xcorrShuffZscored,0.5), prctile(xcorrShuffZscored,99.5),1); alpha(.2); hold on;
                        fill_between_lines(lagtimes, prctile(xcorrShuffZscored,2.5), prctile(xcorrShuffZscored,98.5),2); alpha(.2);
                        fill_between_lines(lagtimes, prctile(xcorrShuffZscored,25), prctile(xcorrShuffZscored,75),3); alpha(.2);
                        plot(lagtimes, prctile(xcorrShuffZscored,50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
                        zScore = (xcorrValues-mean( [ xcorrValues(1:25) xcorrValues(end-24:end) ]))./std( [ xcorrValues(1:25) xcorrValues(end-24:end) ]);
                        plot(lagtimes,zScore, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
                        title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' tt' int2str(ttAvail(ttIdx)) ' c' int2str(cellId) '' ]);
                        subplot(2,1,2);
                        logPVal=log10((1+sum(xcorrShuffZscored>repmat(zScore,1000,1)))/(shufflesToDo+1));
                        plot( lagtimes, logPVal );

                        %
                        print(gcf,[ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_swrXspike_shuff_TT' int2str(ttAvail(ttIdx)) '_C' num2str(cellId) '.png'],'-dpng','-r200');
                    end

                end
            end
        end
    end
end



return;

%%
selected = (swrData.onMaze<0) & (swrData.speed<10);
for ttIdx = 1:length(ttAvail)
    load( [ '~/Desktop/h7_2018-07-12_TT' int2str(ttAvail(ttIdx)) 'a.mat'] )
    for cellId = 1:max(spikeData.cellNumber)
        [ xcorrValues, lagtimes] = xcorrEventTimes( spikeData.timesSeconds( spikeData.cellNumber==cellId), swrData.timestampSeconds(selected), xcorrBinSize, maxLagTime );
        shufflesToDo = 1000;
        reshifts = zeros(1,shufflesToDo);
        xcorrShuff = zeros(shufflesToDo,length(xcorrValues));
        xcorrShuffZscored = zeros(size(xcorrShuff));
        
        swrShuffled = repmat(swrData.timestampSeconds(selected)',1000,1)+ (((-1).^(round(rand(shufflesToDo,length(swrData.timestampSeconds(selected))))+1)).*( 0.5+( 1.5*rand(shufflesToDo,length(swrData.timestampSeconds(selected))))));
        
        for shuffleIdx = 1:shufflesToDo
            xcShuf = xcorrEventTimes( spikeData.timesSeconds( spikeData.cellNumber==cellId), swrShuffled(shuffleIdx,:), xcorrBinSize, maxLagTime );
            xcorrShuff(shuffleIdx,:) = xcShuf;
            xcorrShuffZscored(shuffleIdx,:) = (xcShuf-mean( [ xcShuf(1:25) xcShuf(end-24:end) ]))./std( [ xcShuf(1:25) xcShuf(end-24:end) ]);
        end
        figure; subplot(2,1,1);
        scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
        fill_between_lines(lagtimes, prctile(xcorrShuff,0.5), prctile(xcorrShuff,99.5),1); alpha(.2); hold on;
        fill_between_lines(lagtimes, prctile(xcorrShuff,2.5), prctile(xcorrShuff,98.5),2); alpha(.2);
        fill_between_lines(lagtimes, prctile(xcorrShuff,25), prctile(xcorrShuff,75),3); alpha(.2);
        plot(lagtimes, prctile(xcorrShuff,50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
        plot(lagtimes,xcorrValues, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
        title([' h7 2018-07-12 TT_{' int2str(ttAvail(ttIdx)) '} c_{' int2str(cellId) '}' ]);
        subplot(2,1,2);
        scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
        fill_between_lines(lagtimes, prctile(xcorrShuffZscored,0.5), prctile(xcorrShuffZscored,99.5),1); alpha(.2); hold on;
        fill_between_lines(lagtimes, prctile(xcorrShuffZscored,2.5), prctile(xcorrShuffZscored,98.5),2); alpha(.2);
        fill_between_lines(lagtimes, prctile(xcorrShuffZscored,25), prctile(xcorrShuffZscored,75),3); alpha(.2);
        plot(lagtimes, prctile(xcorrShuffZscored,50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
        zScore = (xcorrValues-mean( [ xcorrValues(1:25) xcorrValues(end-24:end) ]))./std( [ xcorrValues(1:25) xcorrValues(end-24:end) ]);
        plot(lagtimes,zScore, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
        title([' h7 2018-07-12 TT_{' int2str(ttAvail(ttIdx)) '} c_{' int2str(cellId) '}' ]);
        %
        print(gcf,[ '~/Desktop/h7_2018-07-12_swrXspike_shuff_TT' int2str(ttAvail(ttIdx)) '_C' num2str(cellId) '.png'],'-dpng','-r200');
    end        
end
