%%
% test for significance of SWR cross correlations with 

% h1 -- 2018-08-27a -- TT1 -- C1 --

clear all;

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
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC44.ncs'  'CSC64.ncs'};
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% SWR channels to use
swrLfpNames.da5  = { 'CSC6.ncs'  'CSC26.ncs' 'CSC28.ncs'  };
swrLfpNames.da10 = { 'CSC81.ncs' 'CSC61.ncs' 'CSC32.ncs' };
swrLfpNames.h5   = { 'CSC36.ncs' 'CSC87.ncs' };
swrLfpNames.h7   = { 'CSC44.ncs' 'CSC56.ncs' 'CSC54.ncs' }; 
swrLfpNames.h1   = { 'CSC84.ncs' 'CSC20.ncs' 'CSC17.ncs'  'CSC32.ncs'  'CSC64.ncs' };  % first two are the favorites


buildTtPositionDatabase;

thisTheta = 1; % 1:length(thetaLfpNames.(rat{ratIdx}))
thisSwr = 1; 

shufflesToDo = 1000;
xcorrBinSize = 0.05;
maxLagTime = 2;

figure(1);

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';

fileID = fopen([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-08-05.csv'],'w');
message = ([ 'rat,' 'folder,' 'TT,'  'unit,' 'region,'  'sumPosPwr,'  'sumNegPwr,'  'ptsAbove,'  'maxZScoreVal,'  'peakXcorrLagTime,'    'peakProminenceDifference,' 'peakProminenceRatio,' 'peakProminenceZ,'  'medianXcorr,' 'MADAMxcorr,' 'meanXcorr,' 'stdXcorr,'  'pvalSwrShuff,' 'avgRatioCtrSwr' ',medRatioCtr' ',avgRatioPre' ',medRatioPre'  ',avgRatioPost'  ',medRatioPost' ]);
fprintf( fileID, '%s\n' , message);


for ratIdx =  1:length( rat )
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        for ttNum =  1:32
            for cellId =   1:30
                fileToLoad = [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_swrXspike_shuff_TT' int2str(ttNum) '_C' num2str(cellId) '_binSize_' num2str(round(xcorrBinSize*1000)) 'ms.mat'];
                if exist( fileToLoad, 'file' )
                    load( fileToLoad );

                    ninetyninthpctl = prctile( shuffleData.xcorrShuffZscored, 99 );
                    idxCircaSwr = ( 1+round( shuffleData.maxLagTime/shuffleData.xcorrBinSize ))-round(.5/shuffleData.xcorrBinSize):(1+round(shuffleData.maxLagTime/shuffleData.xcorrBinSize))+round(.5/shuffleData.xcorrBinSize);
                    totalPosDeviance = ( shuffleData.xcZScore(idxCircaSwr) - ninetyninthpctl(idxCircaSwr) );
                    totalPosDeviance = sum( totalPosDeviance( totalPosDeviance > 0 ) );
                    firstpctl = prctile( shuffleData.xcorrShuffZscored, 1 );
                    totalNegDeviance = firstpctl(idxCircaSwr) - shuffleData.xcZScore(idxCircaSwr);
                    totalNegDeviance = sum( totalNegDeviance( totalNegDeviance > 0 ) );
                    logPVal=1-(((1+sum(shuffleData.xcorrShuffZscored>repmat(shuffleData.xcZScore,1000,1)))/(shuffleData.shufflesDid+1)));
                    tempIdx=find(logPVal>.99 | logPVal<0.01);
                    lagtimes = -shuffleData.maxLagTime:shuffleData.xcorrBinSize:shuffleData.maxLagTime;
                    [ maxZScoreVal, maxZScoreIdx ] = max( abs( shuffleData.xcZScore ) );
                    if shuffleData.xcZScore(41) < 0
                        peakProminence = shuffleData.xcZScore(maxZScoreIdx)-firstpctl(maxZScoreIdx);
                        peakProminenceRatio = shuffleData.xcZScore(maxZScoreIdx)/firstpctl(maxZScoreIdx);
                        peakProminenceZ = peakProminence/firstpctl(maxZScoreIdx);
                        %pvalue = (sum ( maxZScoreVal > shuffleData.xcorrShuffZscored(:,maxZScoreIdx) )/shufflesToDo);
                        pvalue = mean( [ sum(shuffleData.xcZScore(40) > shuffleData.xcorrShuffZscored(:,40))/ shufflesToDo ; sum(shuffleData.xcZScore(41) > shuffleData.xcorrShuffZscored(:,41))/ shufflesToDo ; sum(shuffleData.xcZScore(42) > shuffleData.xcorrShuffZscored(:,42))/ shufflesToDo ]);
                        %
                        avgRatioCtr = median(shuffleData.xcZScore(40:42)./firstpctl(40:42).*(shuffleData.xcZScore(40:42)./abs(shuffleData.xcZScore(40:42))));
                        medRatioCtr = median(shuffleData.xcZScore(40:42)./firstpctl(40:42).*(shuffleData.xcZScore(40:42)./abs(shuffleData.xcZScore(40:42))));
                        windowIdxs = 37:39;
                        avgRatioPre = median(shuffleData.xcZScore(windowIdxs)./firstpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                        medRatioPre = median(shuffleData.xcZScore(windowIdxs)./firstpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                        windowIdxs = 43:45;
                        avgRatioPost = median(shuffleData.xcZScore(windowIdxs)./firstpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                        medRatioPost = median(shuffleData.xcZScore(windowIdxs)./firstpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                    else
                        peakProminence = shuffleData.xcZScore(maxZScoreIdx)-ninetyninthpctl(maxZScoreIdx);
                        peakProminenceRatio = shuffleData.xcZScore(maxZScoreIdx)/ninetyninthpctl(maxZScoreIdx);
                        peakProminenceZ = peakProminence/ninetyninthpctl(maxZScoreIdx);
                        %pvalue = (sum ( maxZScoreVal < shuffleData.xcorrShuffZscored(:,maxZScoreIdx) )/shufflesToDo);
                        pvalue = median( [ sum(shuffleData.xcZScore(40) < shuffleData.xcorrShuffZscored(:,40))/ shufflesToDo ;  sum(shuffleData.xcZScore(41) < shuffleData.xcorrShuffZscored(:,41))/ shufflesToDo ; sum(shuffleData.xcZScore(42) < shuffleData.xcorrShuffZscored(:,42))/ shufflesToDo ; ]);
                        avgRatioCtr = mean(shuffleData.xcZScore(40:42)./ninetyninthpctl(40:42).*(shuffleData.xcZScore(40:42)./abs(shuffleData.xcZScore(40:42))));
                        medRatioCtr = median(shuffleData.xcZScore(40:42)./ninetyninthpctl(40:42).*(shuffleData.xcZScore(40:42)./abs(shuffleData.xcZScore(40:42))));
                        windowIdxs = 37:39;
                        avgRatioPre = median(shuffleData.xcZScore(windowIdxs)./ninetyninthpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                        medRatioPre = median(shuffleData.xcZScore(windowIdxs)./ninetyninthpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                        windowIdxs = 43:45;
                        avgRatioPost = median(shuffleData.xcZScore(windowIdxs)./ninetyninthpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                        medRatioPost = median(shuffleData.xcZScore(windowIdxs)./ninetyninthpctl(windowIdxs).*(shuffleData.xcZScore(windowIdxs)./abs(shuffleData.xcZScore(windowIdxs))));
                    end
                    
                    
                    
%                    message = ([ rat{ratIdx} ' -- ' folders.(rat{ratIdx}){ffIdx} ' -- TT' int2str(ttNum) ' -- C' num2str(cellId) ' -- sumPosPwr ' num2str(totalPosDeviance) ' -- sumNegPwr ' num2str(totalNegDeviance) ' -- ptsAbove ' num2str(length(lagtimes(tempIdx))) ' -- maxZScoreVal ' num2str(shuffleData.maxZScoreVal) ' -- peakXcorrLagTime ' num2str(lagtimes( maxZScoreIdx ))  ' -- region ' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ]);
%                    disp(message);
                    %            'rat,'         'folder,'                         'TT,'              'unit,'             'region'                                                                                               'sumPosPwr,'                  'sumNegPwr,'                  'ptsAbove,'                           'maxZScoreVal,'                        'peakXcorrLagTime,'                'peakProminenceDifference,'   'peakProminenceRatio,'             'peakProminenceZ'           'medianXcorr,'                            'MADAMxcorr,'                                                                   'meanXcorr,'                            'stdXcorr,'                            'pval,'             
                    message = ([ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str(ttNum) ',' num2str(cellId) ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ',' num2str(totalPosDeviance) ',' num2str(totalNegDeviance) ',' num2str(length(lagtimes(tempIdx))) ',' num2str(shuffleData.maxZScoreVal) ',' num2str(lagtimes( maxZScoreIdx )) ',' num2str(peakProminence) ',' num2str(peakProminenceRatio)  ',' num2str(peakProminenceZ) ',' num2str(median(shuffleData.xcZScore)) ',' num2str( median( abs(shuffleData.xcZScore-median(shuffleData.xcZScore)) ) ) ',' num2str(mean(shuffleData.xcZScore)) ',' num2str(std(shuffleData.xcZScore)) ',' num2str(pvalue) ',' num2str(avgRatioCtr)  ',' num2str(medRatioCtr)  ',' num2str(avgRatioPre) ',' num2str(medRatioPre) ',' num2str(avgRatioPost) ',' num2str( medRatioPost) ]);
                    fprintf( fileID, '%s\n' , message);
                end
            end
        end
    end
end

fclose(fileID);

return;









