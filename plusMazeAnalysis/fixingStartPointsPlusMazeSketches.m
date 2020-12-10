rat = { 'da5' 'da10' 'h5' 'h7' 'h1' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' '2016-09-01' '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04' '2018-09-05' '2018-09-06' '2018-09-08' '2018-09-09' '2018-09-14' };


binResolution = 1;
clear freqXY
for ratIdx = 1:length( rat )
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData '/telemetry/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            
            if exist([ basePathData '/swrPreprocessed/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
                load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');

                    %speedOnMaze=telemetry.speed.*(telemetry.onMaze>0);

                    %selectedTelIdxs = speedOnMaze > 11; 
                    
                    selectedTelIdxs = telemetry.onMaze>0 & telemetry.speed>10;
                    
                    if ~exist('freqXY', 'var')
                        freqXY = twoDHistogram( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), binResolution, 300, 300, 150  );
                    else
                        freqXY = freqXY + twoDHistogram( telemetry.x(selectedTelIdxs), telemetry.y(selectedTelIdxs), binResolution, 300, 300, 150  );
                    end
        end
    end
end


probXY=freqXY./sum(freqXY(:));
probXY(probXY==0)=NaN;
figure; pcolor(probXY); shading interp; colormap('jet'); colorbar;

figure; surf(probXY); shading interp;




    mazeMask=imread( [ '~/Desktop/' 'newRemapMaskRaw.jpg' ] );
    mazeMask=max( mazeMask, 3 );
    mazeMask = mazeMask < 200; %figure; imshow(mazeMask);
    figure; imshow(mazeMask);
    
        figure; imshow(mazeMask(mazeMask < 200));
length(find(mazeMask(mazeMask < 200)))
size(mazeMask(mazeMask > 200))

temp=mazeMask; 
temp=nansum(temp,3);
temp(temp>740)=NaN;
temp(temp<740)=1;

figure; pcolor(temp); shading flat;


figure; imshow(mazeMask(mazeMask > 200));

figure; pcolor(squeeze(nansum(temp,3)))
temp=(nanmax(temp,3));


temp=nanmean(temp,3);


save('/Volumes/AGHTHESIS2/rats/summaryData/plusMazeLinearizationMap.mat','plusMazeLinearizationMap')
% BEGIN

plusMazeXyToMaskMap = zeros(301,301);
plusMazeLinearizationMap(isnan(plusMazeLinearizationMap)) = 0;
[ validXs, validYs, linearizedPosition ] = find(plusMazeLinearizationMap);
for aa=1:301
    for bb=1:301
        if freqXY(bb,aa) > 0
            distances = sqrt( (validXs-bb).^2 + (validYs-aa).^2  );
            [ ~, tempIdx ]=min(distances);
            plusMazeXyToMaskMap( bb, aa ) = linearizedPosition(tempIdx);
        end
    end
end
plusMazeXyToMaskMap(plusMazeXyToMaskMap==0) = NaN;
figure; pcolor(plusMazeXyToMaskMap); shading flat; colormap(build_NOAA_colorgradient(1000)); colorbar;


linearizedHistogram = zeros(1,max(plusMazeLinearizationMap(:)));
for aa=1:300
    for bb = 1:300
        if freqXY(aa,bb) > 0 && plusMazeXyToMaskMap(bb,aa) > 0
            linearizedHistogram( plusMazeXyToMaskMap(bb,aa) ) = linearizedHistogram( plusMazeXyToMaskMap(bb,aa) ) + freqXY(bb,aa);
        end
    end
end
figure; plot(linearizedHistogram)


% END






plusMazeXyToMaskMap = zeros(300,300);
[ validXs, validYs ] = find(temp);
[ visitedXs, visitedYs ] = find(freqXY);
remappedMazeXs = zeros(1,300);
remappedMazeYs = zeros(1,300);
linearizedMazeXY = zeros(size(visitedXs));
for aa=1:length(visitedXs)
    distances = sqrt( (validXs-visitedXs(aa)).^2 + (validYs-visitedYs(aa)).^2  );
    [ ~, tempIdx ]=min(distances);
    remappedMazeXs(tempIdx) = validXs(tempIdx);
    remappedMazeYs(tempIdx) = validXs(tempIdx);
    linearizedMazeXY(tempIdx) = plusMazeLinearizationMap( remappedMazeXs(tempIdx), remappedMazeYs(tempIdx) );
    plusMazeXyToMaskMap(visitedYs(aa),visitedXs(aa)) = linearizedMazeXY(tempIdx);
end
plusMazeXyToMaskMap(plusMazeXyToMaskMap==0) = NaN;
figure; pcolor(plusMazeXyToMaskMap); shading flat;









% visualize result
for aa=1:length(visitedXs)
    plusMazeXyToMaskMap()

for aa=1:300
    for bb=1:300
        


% indices to unique values in column 3
[~, ind] = unique(plusMazeLinearizationMap(~isnan(plusMazeLinearizationMap)), 'rows');
% duplicate indices
duplicate_ind = setdiff(1:size(plusMazeLinearizationMap, 1), ind);
% duplicate values
duplicate_value = plusMazeLinearizationMap(duplicate_ind, 3)









rat = { 'h5' 'h7' }; %'da5' 'da10' 'h1'  };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23'  '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31'  '2016-09-01'  '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22'  '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12'  '2018-06-13'  '2018-06-14'  '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06'  '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23'  '2018-07-24'  '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-08-31' '2018-09-04' '2018-09-05' };
folders.h1    = { '2018-08-09' '2018-08-10'  '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04'  '2018-09-05'  '2018-09-06'  '2018-09-08' '2018-09-09'  '2018-09-14' };


close all;
distToValidStartPoint = [];
for ratIdx =   2:length( rat )
    % 26
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            figure;
            for trialIdx = 1:max(telemetry.trial)
                startIdx = find(telemetry.trial == trialIdx, 1, 'first');
                endIdx = find(telemetry.trial == trialIdx, 1, 'last');
                if ~isempty(startIdx) && ~isempty(endIdx)
                    plot( telemetry.x(startIdx:endIdx), telemetry.y(startIdx:endIdx), 'Color', [ 0 0 0 .1 ] );
                    hold on;
%                     if     abs(telemetry.y(startIdx)) < 27   % ( abs(telemetry.x(startIdx)) < 80  && abs(telemetry.y(startIdx)) < 27  )  
%                         distToValidStartPoint = [ distToValidStartPoint sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 ) ];
%                     elseif abs(telemetry.x(startIdx)) < 27 
%                         distToValidStartPoint = [ distToValidStartPoint sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 ) ];
%                     end
                    %if     abs(telemetry.y(startIdx)) < 27   % ( abs(telemetry.x(startIdx)) < 80  && abs(telemetry.y(startIdx)) < 27  )  
                    %    distToValidStartPoint = sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 );
                    %elseif abs(telemetry.x(startIdx)) < 27 
                    %    distToValidStartPoint = sqrt( (100-abs(telemetry.x(startIdx)))^2 + (0-abs(telemetry.y(startIdx)))^2 );
                    %end
                    distToValidStartPoint = min([ sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 )   sqrt( (100-abs(telemetry.x(startIdx)))^2 + (0-abs(telemetry.y(startIdx)))^2 )]);
                    lastDistToStart = 500;
                    scatter( telemetry.x(startIdx), telemetry.y(startIdx), 'v', 'b', 'filled' );

                    %
                    moves = 0;
                    while ( distToValidStartPoint > 25)
                       if ( startIdx == 1 ) || ( startIdx == length(telemetry.y) ) || moves > 30 %|| ( distToValidStartPoint - lastDistToStart ) <= 0
                           break;
                       end
                       lastDistToStart = distToValidStartPoint;
                       startIdx = startIdx + 1;                    
%                        if     abs(telemetry.y(startIdx)) < 27   % ( abs(telemetry.x(startIdx)) < 80  && abs(telemetry.y(startIdx)) < 27  )  
%                             distToValidStartPoint = sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 );
%                         elseif abs(telemetry.x(startIdx)) < 27 
%                             distToValidStartPoint = sqrt( (100-abs(telemetry.x(startIdx)))^2 + (0-abs(telemetry.y(startIdx)))^2 );
%                        end
                       distToValidStartPoint = min([ sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 )   sqrt( (100-abs(telemetry.x(startIdx)))^2 + (0-abs(telemetry.y(startIdx)))^2 )]);
                       moves = moves + 3;
                        
                    end
                    %
                    scatter( telemetry.x(endIdx), telemetry.y(endIdx), 's', 'r', 'filled' );
                    if   ( abs(telemetry.x(startIdx)) < 80  && abs(telemetry.y(startIdx)) < 27  ) || ( abs(telemetry.y(startIdx)) < 80 && abs(telemetry.x(startIdx)) < 27 )
                        scatter( telemetry.x(startIdx), telemetry.y(startIdx), '*', 'm' );
                        disp( [ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx}  ' ' num2str(trialIdx) ' ' num2str(round(telemetry.x(startIdx))) ' '  num2str(round(telemetry.y(startIdx)))  ' ' num2str(round(telemetry.xytimestampSeconds(startIdx)))  ] )
                    else
                        scatter( telemetry.x(startIdx), telemetry.y(startIdx), 'o', 'g', 'filled' );
                    end
                    
                end
            end
            title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ]);
            axis([-150 150 -150 150]); axis square;
        end
    end
end

figure; histogram( distToValidStartPoint, 1:100 )


 


%% TODO TODO TODO -- fix this data

%%
% H7
% IGNORED  8-8 ,, 8-6  -- this approach doesn't work well for the continuous version of the task.
% 8-31 has bad trial data

% 2018-08-31 is broken  -- this one is all continuous, so fixing the start points is not important
% the file below is the correct version of the data, but it is missing
% important fields and requires repair.
% load([ '~/Desktop/telemetry/h7_2018-08-31_telemetry.dat' ], '-mat');

% one weird trial to double check for 7-25, 7-26, 7-30, 8-2
%
% H5 one weird trial to double check for 5-18, 6-13, 6-15

folders.h7    = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-07' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22' '2018-09-04' '2018-09-05'  };
close all;
distToValidStartPoint = [];
offsets=[];
for ratIdx =   1:length( rat )
    % 26
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            %figure;
            for trialIdx = 1:max(telemetry.trial)
                startIdx = find(telemetry.trial == trialIdx, 1, 'first');
                endIdx = find(telemetry.trial == trialIdx, 1, 'last');
                originalStartIdx = startIdx;
                if ~isempty(startIdx) && ~isempty(endIdx)
                    plot( telemetry.x(startIdx:endIdx), telemetry.y(startIdx:endIdx), 'Color', [ 0 0 0 .1 ] );
                    hold on;
                    scatter( telemetry.x(startIdx), telemetry.y(startIdx), 'o', 'b', 'filled' );
                    offset = 0;
                    if 20 < min([ sqrt( (0-abs(telemetry.x(startIdx)))^2 + (100-abs(telemetry.y(startIdx)))^2 )   sqrt( (100-abs(telemetry.x(startIdx)))^2 + (0-abs(telemetry.y(startIdx)))^2 )])
                        offset = [];
                        offsetSeconds = 1;
                        while (isempty(offset))
                            tidxs=startIdx-(round(offsetSeconds*29.97)):startIdx+(round(offsetSeconds*29.97));
                            tidxs(tidxs<1) = []; % remove negative indices
                            tidxs(tidxs>length(telemetry.x)) = []; % remove too large indices
                            % find the first time he is within the start box
                            %offset=find((min([ sqrt( (0-abs(telemetry.x(tidxs))).^2 + (100-abs(telemetry.y(tidxs))).^2 )';   sqrt( (100-abs(telemetry.x(tidxs))).^2 + (0-abs(telemetry.y(tidxs))).^2 )']))<26,1,'first');
                            offset=min( [ find( sqrt( (0-abs(telemetry.x(tidxs))).^2 + (100-abs(telemetry.y(tidxs))).^2 )<20,1,'first')  find( sqrt( (100-abs(telemetry.x(tidxs))).^2 + (0-abs(telemetry.y(tidxs))).^2 )<20,1,'first') ] );
                            % find the closest time he is to the start point
                            %[~, offset]=min(min([ sqrt( (0-abs(telemetry.x(tidxs))).^2 + (100-abs(telemetry.y(tidxs))).^2 )';   sqrt( (100-abs(telemetry.x(tidxs))).^2 + (0-abs(telemetry.y(tidxs))).^2 )']));
                            offsetSeconds = offsetSeconds + 1;
                        end
                        startIdx = startIdx-(startIdx-tidxs(1))+offset;
                        offsets = [ offsets offset ];
                    else
                        offsets = [ offsets offset ];
                    end
                    if offset > 3*30
                        disp([ 'warning : '  rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' ' num2str(trialIdx) ' has large offset ']);
                        if originalStartIdx > 91
                            scatter( telemetry.x(originalStartIdx-90), telemetry.y(originalStartIdx-90), '^', 'y', 'filled' );
                        end
                        if originalStartIdx > length(telemetry.x)-91
                            scatter( telemetry.x(originalStartIdx+90), telemetry.y(originalStartIdx+90), 'd', 'y', 'filled' );                    
                        end
                    end
                    %
                    scatter( telemetry.x(startIdx), telemetry.y(startIdx), '>', 'g', 'filled' );
                    scatter( telemetry.x(endIdx), telemetry.y(endIdx), 's', 'r', 'filled' );
                    %
                    % fix the trial data
                    if originalStartIdx < startIdx
                        telemetry.onMaze(originalStartIdx:startIdx) = -1;
                        telemetry.trial(originalStartIdx:startIdx) =  -1;
                    elseif originalStartIdx > startIdx
                        telemetry.onMaze(startIdx:originalStartIdx) = 1;
                        telemetry.trial(startIdx:originalStartIdx) = telemetry.trial(originalStartIdx);
                    end
                end
            end
            title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ]);
            axis([-150 150 -150 150]); axis square;
            
            if ~exist([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry_preStartFix.mat' ], 'file')
                movefile([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry_preStartFix.mat' ]);
                disp('moved a file')
            end
            save( [ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'telemetry' )
        end
    end
end





figure; 
plot(telemetry.xytimestampSeconds,telemetry.onMaze); hold on; plot(telemetry.xytimestampSeconds,telemetry.trial);
plot(telemetry.xytimestampSeconds,telemetry.x); plot(telemetry.xytimestampSeconds,telemetry.y);









