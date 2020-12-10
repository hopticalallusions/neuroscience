
clear all;

% '2018-07-11' -- this telemetry file doesn't work for some reason.
rat = { 'h5' 'h7' 'h1' }; %'da5' 'da10' 'h1'  };
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

thisTheta = 1;
thisSwr = 1; 

figure(1);

basePathData = '/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';


% Read in behavioral data
table=readtable('~/data/dissertation/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);


eventTitle = 'reward'

accumulatedEventCounts = zeros(5000,50);
labels={};
recordIdx = 1;
pvals=zeros(5000,1);


for ratIdx =  1:length( rat )
    % 26     % h7 2018-07-27 LS 32  cell 1  (folder 14) has  a bang on
    % phase precession cell example
    for ffIdx =  1:length( folders.(rat{ratIdx}) )
        if exist([ basePathData '/telemetryEnhanced/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], 'file')
            load([ basePathData '/telemetryEnhanced/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
            
            for ttNum = 1:32
                % BELOW FOR ALL TT
                if exist( [ basePathData '/ttDataOld/' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' )
                %
                % BELOW FOR LS ONLY
                %if exist( [ basePathData '/ttDataOld/'  rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && ~isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'LS' ) )
                %
                % BELOW FOR CA ONLY
                %if exist( [ basePathData '/ttDataOld/'  rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && ~isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'CA' ) )
                %
                %BELOW FOR NOT LS OR CA
                %if exist( [ basePathData '/ttData/'  rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'], 'file' ) && isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'LS' ) ) && isempty( strfind( ( ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ) , 'CA' ) )

                
                    load( [ basePathData '/ttDataOld/'  rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttNum) '.mat'] );                    
                    
                    for cellId = 1:max(spikeData.cellNumber)

                        trialRewardTimes = ds( (strcmp( ds.Folder, folders.(rat{ratIdx}){ffIdx}) .*strcmp( ds.Rat,rat{ratIdx}))>0 , 8);
                        trialRewardTimes = trialRewardTimes.TimeSugarSec(:);
                        
                        trialOutcome = ds( (strcmp( ds.Folder, folders.(rat{ratIdx}){ffIdx}) .*strcmp( ds.Rat,rat{ratIdx}))>0 , 11);
                        trialOutcome = trialOutcome.error(:);
                        
                        validEventTimes = trialRewardTimes(trialOutcome==0);
                        
                        
                        
                        tempSpikeTimes = spikeData.timesSeconds(spikeData.cellNumber==cellId);

                        windowSize = 5;
                        rasterTimes = [];
                        eventIdx = [];

                        eventActivations = 0;

                        for ii=1:length(validEventTimes)
                            circaSpikeTimes = tempSpikeTimes( ( ( validEventTimes(ii)-windowSize < tempSpikeTimes ) & ( tempSpikeTimes < validEventTimes(ii) + windowSize ) ) ) - validEventTimes(ii);
                            rasterTimes = [ rasterTimes; circaSpikeTimes ];
                            eventIdx = [ eventIdx ii*ones(1,length(circaSpikeTimes)) ];

                            eventActive = tempSpikeTimes( ( ( validEventTimes(ii)-0.1 < tempSpikeTimes ) & ( tempSpikeTimes < validEventTimes(ii) + 0.1 ) ) ) - validEventTimes(ii);
                            if ~isempty(eventActive)
                                eventActivations = eventActivations + 1;
                            end
                        end

                        
                        
                        accumulatedEventCounts(recordIdx,:) = histcounts( rasterTimes, -windowSize:.2:windowSize ); % ylabel( 'PETH ' eventTitle ' (freq)' );
                        labels{recordIdx} = [ rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_tt' int2str(ttNum) '_c' num2str(cellId) ];
                        recordIdx = recordIdx + 1;
               
                        % require the cell to fire at least 100 times during the set
                        if ( length(eventIdx) > 99 ) 
                            histo=zeros(max(eventIdx),11);
                            for ii = 1:length(eventIdx)
                                histo(eventIdx(ii),round(rasterTimes(ii))+6) = histo(eventIdx(ii),round(rasterTimes(ii))+6) + 1;
                            end
                            % require the cell to fire at least 5 times on at least 75% of the trials
                            if ( ( sum(sum(histo,2)>5)./size(histo,2) ) > .75 )
                                % pvals(recordIdx) = anova1( histo, [], 'off' );
                                pvals(recordIdx) = kruskalwallis( histo, [], 'off' );
                            else
                                pvals(recordIdx) = NaN;
                            end
                        else
                            pvals(recordIdx) = NaN;
                        end
                        
                        
                          if  0==1 %eventActivations > 0
                            figure(2); clf; 

                            subplot(6,2,1); 
                            [ xcorrValues, lagtimes] = acorrEventTimes( spikeData.timesSeconds(  (spikeData.onMaze>0) & (spikeData.speed<7) & (spikeData.cellNumber==cellId)), .01, 1 ); 
                            plot( lagtimes, xcorrValues); hold on; yyaxis right; 
                            plot(lagtimes, xcorrValues ./ (0.01*(sum( (spikeData.onMaze>0) & (spikeData.speed<7))./29.97)) );

                            subplot(6,2,2); rose( deg2rad(spikeData.thetaPhase(  (spikeData.onMaze>0) & (spikeData.speed<10) & (spikeData.cellNumber==cellId))), 36);

                            subplot(6,2,3:4);   histogram( rasterTimes, -windowSize:.2:windowSize ); ylabel( 'PETH (freq)' );
                            title([ rat{ratIdx} ' ' folders.(rat{ratIdx}){ffIdx} ' tt' int2str(ttNum) ' c' num2str(cellId) ])
                            subplot(6,2,5:12); scatter( rasterTimes, eventIdx, 'k+' ); xlim([-windowSize windowSize]); ylim( [ 0 max(eventIdx)+1 ] ); xlabel(['time relative to ' eventTitle ' (s)']); ylabel([ eventTitle ' event       (cell fires on '  num2str( round(100*eventActivations/max(eventIdx)))  '% )']);
drawnow; pause(1)
%                             print([ basePathOutput '/peths/' eventTitle 'AvgRatePethRaster_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_tt' int2str(ttNum) '_c' num2str(cellId) '.png'],'-dpng','-r200');
                         end

                         % disp([ rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_tt' int2str(ttNum) '_c' num2str(cellId) ] );

                    end
                end
            end
        end
    end
end
% 
recordIdx = recordIdx-1;
accumulatedEventCounts=accumulatedEventCounts(1:recordIdx,:);


kernel = [ .1 .2 .4 .2 .1 ]';
smoothed = accumulatedEventCounts;
for ii = 1:size(accumulatedEventCounts,1)
    for jj = 3:size(accumulatedEventCounts,2)-3
        smoothed(ii,jj) = accumulatedEventCounts(ii,jj-2:jj+2) * kernel;
    end
end
normalized = smoothed;
for ii = 1:size(accumulatedEventCounts,1)
    normalized(ii,:) = smoothed(ii,:)./max(smoothed(ii,:));
end


[~,ii]=sort(mean(normalized(:,20:30),2)./(1+mean([ normalized(:,1:10)  normalized(:,41:50)] ,2) ));  imagesc(normalized(ii,:)); colormap('jet'); colorbar;







%anova


%rasterTimes, eventIdx



p = anova1( histo, 'off');


