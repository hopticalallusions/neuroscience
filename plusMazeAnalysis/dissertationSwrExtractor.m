%% EXTRACT SWR

includeSetupMetaData;

% 
% figure; subplot(3,1,1);  scatter(swrData.duration(swrData.mask & (swrData.onMaze == 1)), swrData.peakValues(swrData.mask & (swrData.onMaze == 1)));hold on;scatter(swrData.duration(swrData.mask & (swrData.onMaze == -1)), swrData.peakValues(swrData.mask & (swrData.onMaze == -1)));
% subplot(3,1,2); ; histogram(swrData.peakValues(swrData.mask & (swrData.onMaze == 1)));hold on;histogram( swrData.peakValues(swrData.mask & (swrData.onMaze == -1)));
% subplot(3,1,3); ; histogram(swrData.duration(swrData.mask & (swrData.onMaze == 1)),0:2:150);hold on;histogram( swrData.duration(swrData.mask & (swrData.onMaze == -1)),0:2:150);
% 
% [~,p,~,stats]=ttest2(swrData.peakValues(swrData.mask & (swrData.onMaze == 1)) , swrData.peakValues(swrData.mask & (swrData.onMaze == -1)))
% [~,p,~,stats]=ttest2(swrData.duration(swrData.mask & (swrData.onMaze == 1)) , swrData.duration(swrData.mask & (swrData.onMaze == -1)))
% 
% subplot(3,1,3); ; histogram(swrData.duration(swrData.mask & (swrData.onMaze == 1)),0:2:150);hold on;histogram( swrData.duration(swrData.mask & (swrData.onMaze == -1)),0:2:150);
% 

% 
% %% ENHANCER SCRIPT
% 
% skipFiles = false;
% 
% % stopped here TRY : h1_2018-08-13_theta-CSC32_swr-CSC84
% 
% for ratIdx = 1:length(rats)
%     % folder 29 for rat idx 4 has great SWR events
%     for thisFolder = 1:length(folders.(rats{ratIdx}))  % length(folders.(rat{ratIdx}))-3
%         for thisTheta =  1 %1:length(thetaLfpNames.(rat{ratIdx}))
%             for thisSwr = 1:length(swrLfpNames.(rats{ratIdx}))
%                 try
% %                    disp( [ 'TRY : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') ] ) 
% 
%                     if true %skipFiles && ~exist([ '~/data/dissertation/swrEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ], 'file' ) 
% 
%                         filepath = [ '/Volumes/AGHTHESIS2/rats/' rats{ratIdx} '/' folders.(rats{ratIdx}){thisFolder} '/' ];
%                         load([ '/Volumes/AGHTHESIS2/rats/summaryData/telemetryEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');
%                         %load([ '~/data/dissertation/telemetryEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');
% 
%                         load( [ '~/data/dissertation/swrEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] , 'swrData' );
%                         %
%                         % fix the flip-flopped start and end times
%                         %if ~exist('swrData.startEndFixFlag','var')
%                         if sum( (swrData.swrEndTimes - swrData.swrStartTimes) > 0 ) < 20
%                             temp = swrData.swrStartTimes;
%                             swrData.swrStartTimes = swrData.swrEndTimes;
%                             swrData.swrEndTimes = temp;
%                             swrData.startEndFixFlag = 1;
%                         end
%                         
% %                        if max(swrData.duration) < 10 
%                             swrData.duration = 1000*(swrData.swrEndTimes - swrData.swrStartTimes); % milliseconds
% %                        end
%                         swrData.speedBumpy       = interp1( telemetry.xytimestamps, telemetry.speedBumpy , swrData.timestamps );
%                         
%                         swrData.mask    =  (swrData.speedBumpy<5) & (swrData.duration>10);
% 
%                         save( [ '~/data/dissertation/swrEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] , 'swrData' );
% 
% %                        disp( [ 'SUCCESS : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') ] ) 
% 
%                         
%                         [~,pPeak,~,stats]=ttest2(swrData.peakValues(swrData.mask & (swrData.onMaze == 1)) , swrData.peakValues(swrData.mask & (swrData.onMaze == -1)));
%                         [~,pDur,~,stats]=ttest2(swrData.duration(swrData.mask & (swrData.onMaze == 1)) , swrData.duration(swrData.mask & (swrData.onMaze == -1)));
% 
%                         disp( [ rats{ratIdx} ',' folders.(rats{ratIdx}){thisFolder} ',' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') ',' num2str(pPeak) ',' num2str(pDur) ] ) 
%                         
%                     else
%                         disp( [ 'SKIPPED : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
%                     end
%                 catch err
%                     disp( [ 'FAILED : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
%                     err.getReport
%                 end
%             end                              
%         end
%     end
% end
% 
% return;

%% MAIN EXTRACTION LOOP 

skipFiles = false;

% stopped here TRY : h1_2018-08-13_theta-CSC32_swr-CSC84

for ratIdx = 5 %1:length(rats)
    % folder 29 for rat idx 4 has great SWR events
    for thisFolder = length(folders.(rats{ratIdx}))  % length(folders.(rat{ratIdx}))-3
        for thisTheta =  1 %1:length(thetaLfpNames.(rat{ratIdx}))
            for thisSwr = 1:length(swrLfpNames.(rats{ratIdx}))
                try
                    disp( [ 'TRY : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') ] ) 

                    if true %skipFiles && ~exist([ '~/data/dissertation/swrEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ], 'file' ) 

                        filepath = [ '/Volumes/AGHTHESIS2/rats/' rats{ratIdx} '/' folders.(rats{ratIdx}){thisFolder} '/' ];
                        load([ '/Volumes/AGHTHESIS2/rats/summaryData/telemetryEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');
                        %load([ '~/data/dissertation/telemetryEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');
                        telemetry.speedBumpy = calculateSpeed( telemetry.x, telemetry.y, .1, 1 )';
                        
                        [ swrChannel, swrLfpTimestamps ] = csc2mat([ filepath   swrLfpNames.(rats{ratIdx}){thisSwr} ]);
                        swrLfpTimestampSeconds = (swrLfpTimestamps-swrLfpTimestamps(1))/1e6;
                        swrLfp = filtfilt( filters.so.swr, swrChannel );
                        swrLfpEnv = abs(hilbert(swrLfp));

                        swrEnvMedian = median(swrLfpEnv);
                        swrEnvMadam  = median(abs(swrLfpEnv-swrEnvMedian));

                        % this is intentionally low. we will save the peak values and
                        % deal with selection later.
        %                swrThresholdMedian = swrEnvMedian + 3*swrEnvMadam; % mean(swrLfp) + ( 3  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
        %                swrThresholdMean = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );
        
                        % swrThreshold = quantile(swrLfpEnv,.95);
                        
%                        liaLfp = filtfilt( filters.so.lia, swrChannel );
                        

                        temp.onMaze        = interp1( telemetry.xytimestampSeconds, telemetry.onMaze, swrLfpTimestampSeconds, 'nearest' );         
             %           temp.speedBumpy    = interp1( telemetry.xytimestampSeconds, telemetry.speedBumpy, swrLfpTimestampSeconds );
                        swrThresholdMaze   = mean(swrLfpEnv(temp.onMaze == 1)) + ( 3  * std(swrLfpEnv(temp.onMaze == 1)) ); %quantile(swrLfpEnv,.95);
                        

                        [ swrPeakValues,  ...
                          swrPeakTimes,   ... 
                          swrPeakWidths,  ...
                          swrPeakProminances ] = findpeaks( swrLfpEnv,                    ... % data
                                                      swrLfpTimestampSeconds,             ... % sampling frequency
                                                      'MinPeakHeight',  swrThresholdMaze, ... % std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
                                                      'MinPeakDistance', 0.05  );             % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

                        
                        % find the extents of the ripple; 
                        % record start and end times
                        extentThreshold = mean(swrLfpEnv(telemetry.onMaze == 1)) + ( 1.2  * std(swrLfpEnv(telemetry.onMaze == 1)) );
                        %extentThresholdHigher = mean(swrLfpEnv(telemetry.onMaze == 1)) + ( 1.2  * std(swrLfpEnv(telemetry.onMaze == 1)) );
                        mask = (swrLfpEnv>(extentThreshold*0.99)) & (swrLfpEnv<(extentThreshold*1.01));
                        extentTimeList = swrLfpTimestampSeconds( mask );
                        swrStartTimes = zeros(size(swrPeakTimes));
                        swrEndTimes = zeros(size(swrPeakTimes));
                        for thisPeak = 1:length(swrPeakTimes)
                            swrDiffs = extentTimeList - swrPeakTimes(thisPeak);
                            if isempty(min(swrDiffs(swrDiffs>0)))
                                swrEndTimes(thisPeak) = swrPeakTimes(thisPeak);
                            else
                               swrEndTimes(thisPeak) = swrPeakTimes(thisPeak) + min(swrDiffs(swrDiffs>0));
                            end
                            if isempty(max(swrDiffs(swrDiffs<0)))
                                swrStartTimes(thisPeak) = swrPeakTimes(thisPeak);
                            else
                                swrStartTimes(thisPeak) = swrPeakTimes(thisPeak) + max( swrDiffs(swrDiffs<0) );
                            end
                        end   
                        %
                        swrData.swrStartTimes          = swrStartTimes;
                        swrData.swrEndTimes            = swrEndTimes;
                        swrData.duration               = swrEndTimes - swrStartTimes;
                        swrData.extentTreshold         = extentThreshold;
                        swrData.swrThresholdMaze       = swrThresholdMaze;
                        %
                        swrData.timestampSeconds       = swrPeakTimes;
                        swrData.timestamps             = interp1( swrLfpTimestampSeconds, swrLfpTimestamps, swrPeakTimes );
                        swrData.peakValues             = swrPeakValues;
                        swrData.swrPeakWidths          = swrPeakWidths;
                        swrData.extentTimeList         = extentTimeList;

                        % envelope distribution data
                        hh = histogram(swrLfpEnv,500);
                        swrData.swrEnvDistVals         = hh.Values;
                        swrData.swrEnvDistBins         = hh.BinEdges;
                        swrData.swrEnvMedian           = swrEnvMedian;
                        swrData.swrEnvMadam            = swrEnvMadam;
                        swrData.swrEnvMean             = mean(swrLfpEnv);
                        swrData.swrEnvStd              = std(swrLfpEnv);
                        %
                        hh = histogram(swrLfpEnv(temp.onMaze == 1),swrData.swrEnvDistBins);
                        swrData.swrEnvDistValsOnMaze   = hh.Values;
                        swrData.swrEnvMedianOnMaze     = median(swrLfpEnv(temp.onMaze == 1));
                        swrData.swrEnvMadamOnMaze      = median(abs(swrLfpEnv(temp.onMaze == 1)- swrData.swrEnvMedianOnMaze));
                        swrData.swrEnvMeanOnMaze       = mean(swrLfpEnv(temp.onMaze == 1));
                        swrData.swrEnvStdOnMaze        = std(swrLfpEnv(temp.onMaze == 1));
                        %
                        hh = histogram(swrLfpEnv(temp.onMaze == -1),swrData.swrEnvDistBins);
                        swrData.swrEnvDistValsBucket   = hh.Values;
                        swrData.swrEnvMedianBucket     = median(swrLfpEnv(temp.onMaze == -1));
                        swrData.swrEnvMadamBucket      = median(abs(swrLfpEnv(temp.onMaze == -1)- swrData.swrEnvMedianBucket));
                        swrData.swrEnvMeanBucket       = mean(swrLfpEnv(temp.onMaze == -1));
                        swrData.swrEnvStdBucket        = std(swrLfpEnv(temp.onMaze == -1));
                        %
                        temp.speedBumpy    = interp1( telemetry.xytimestampSeconds, telemetry.speedBumpy, swrLfpTimestampSeconds );
                        hh = histogram(swrLfpEnv((temp.onMaze == 1) & (temp.speedBumpy < 5)),swrData.swrEnvDistBins);
                        swrData.swrEnvDistValsOnMazeStill   = hh.Values;
                       swrData.swrEnvMedianOnMazeStill      = median(swrLfpEnv((temp.onMaze == 1) & (temp.speedBumpy < 5)));
                        swrData.swrEnvMadamOnMazeStill      = median(abs(swrLfpEnv((temp.onMaze == 1) & (temp.speedBumpy < 5)) - swrData.swrEnvMedianOnMazeStill));;
                        swrData.swrEnvMeanOnMazeStill       = mean(swrLfpEnv((temp.onMaze == 1) & (temp.speedBumpy < 5)));
                        swrData.swrEnvStdOnMazeStill        = std(swrLfpEnv((temp.onMaze == 1) & (temp.speedBumpy < 5)));
                        

                        swrData.speedBumpy       = interp1( telemetry.xytimestamps, telemetry.speedBumpy , swrData.timestamps );
                        swrData.mask    =  (swrData.speedBumpy<5) & (swrData.duration>10);
                        
                        
                        % free memory
                        clear swrLfpEnv swrLfpTimestamps swrLfpTimestampSeconds temp.onMaze temp.speedBumpy
% 
%                         % Theta information
%                         [ thetaChannel, thetaLfpTimestamps ]=csc2mat([ filepath   thetaLfpNames.(rats{ratIdx}){thisTheta} ]);
%                         thetaLfpTimestampSeconds = (thetaLfpTimestamps-thetaLfpTimestamps(1))/1e6;
%                         thetaLfp = filtfilt( filters.so.theta, thetaChannel );
%                         thetaAnalytic = hilbert(thetaLfp);
%                         thetaLfpEnv = abs(thetaAnalytic);
%                         %thetaPhase = angle(thetaAnalytic);
% 
%                         hh = histogram(thetaLfpEnv,500);
% 
%                         swrData.thetaEnvDistVals  = hh.Values;
%                         swrData.thetaEnvDistBins  = hh.BinEdges;
%                         swrData.thetaEnvMedian    = median(thetaLfpEnv);
%                         swrData.thetaEnvMadam     = median(abs(thetaLfpEnv-median(thetaLfpEnv)));
%                         swrData.thetaEnvMean      = mean(thetaLfpEnv);
%                         swrData.thetaEnvStd       = std(thetaLfpEnv);
%                         % IMPORTANT -- unwrap and mod or else linear interpolation will produce bad phase data.
%                         %swrData.thetaPhase       = mod(interp1( thetaLfpTimestamps, unwrap(thetaPhase), swrData.timestamps ), 2*pi)*180/pi;
%                         swrData.thetaEnv         = interp1( thetaLfpTimestamps, thetaLfpEnv, swrData.timestamps );
%                         swrData.thetaLfpName     = thetaLfpNames.(rats{ratIdx}){thisTheta};
%                         swrData.swrLfpName       = swrLfpNames.(rats{ratIdx}){thisSwr};
% 
%                         % free memory
%                         clear thetaLfpEnv thetaLfpTimestamps thetaLfpTimestampSeconds

                        swrData.x                = interp1( telemetry.xytimestamps, telemetry.x     , swrData.timestamps );
                        swrData.y                = interp1( telemetry.xytimestamps, telemetry.y     , swrData.timestamps );
                        swrData.speed            = interp1( telemetry.xytimestamps, telemetry.speed , swrData.timestamps );
                        swrData.speedBumpy       = interp1( telemetry.xytimestamps, telemetry.speedBumpy , swrData.timestamps );
                        swrData.movDir           = interp1( telemetry.xytimestamps, telemetry.movDir, swrData.timestamps );
                        swrData.headDir          = interp1( telemetry.xytimestamps, telemetry.movDir, swrData.timestamps );
                        swrData.onMaze           = interp1( telemetry.xytimestamps, telemetry.onMaze, swrData.timestamps );
                        swrData.trial            = interp1( telemetry.xytimestamps, telemetry.trial , swrData.timestamps );

                        save( [ '~/data/dissertation/swrEnhanced/' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] , 'swrData' );

                        disp( [ 'SUCCESS : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') ] ) 

                    else
                        disp( [ 'SKIPPED : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
                    end
                catch err
                    disp( [ 'FAILED : ' rats{ratIdx} '_' folders.(rats{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rats{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rats{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] );
                    err.getReport
                end
            end                              
        end
    end
end



return;





















for ratIdx = 5 %1:length(rat)
    % folder 29 for rat idx 4 has great SWR events
    for thisFolder = 1:length(folders)
        for thisTheta = 1 % 1:length(thetaLfpNames.(rat{ratIdx}))
            for thisSwr = 2 % 1:length(swrLfpNames.(rat{ratIdx}))

                filepath = [ '/Volumes/AGHTHESIS2/rats/' rat{ratIdx} '/' folders.(rat{ratIdx}){thisFolder} '/' ];
                load([ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_telemetry.mat' ], '-mat');

                [ swrChannel, swrLfpTimestamps ]=csc2mat([ filepath   swrLfpNames.(rat{ratIdx}){thisSwr} ]);
                swrLfpTimestampSeconds = (swrLfpTimestamps-swrLfpTimestamps(1))/1e6;
                swrLfp = filtfilt( filters.so.swr, swrChannel );
                swrLfpEnv = abs(hilbert(swrLfp));

                swrEnvMedian = median(swrLfpEnv);
                swrEnvMadam  = median(abs(swrLfpEnv-swrEnvMedian));

                % this is intentionally low. we will save the peak values and
                % deal with selection later.
%                swrThresholdMedian = swrEnvMedian + 3*swrEnvMadam; % mean(swrLfp) + ( 3  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
%                swrThresholdMean = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );
                swrThreshold = quantile(swrLfpEnv,.95);
                
                [swrPeakValues,      ...
                 swrPeakTimes,       ... 
                 swrPeakProminances, ...
                 swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                              swrLfpTimestampSeconds,                     ... % sampling frequency
                                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
                                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

                hh = histogram(swrLfpEnv,500);
                                          
                
                swrData.timestampSeconds = swrPeakTimes;
                swrData.timestamps       = interp1( swrLfpTimestampSeconds, swrLfpTimestamps, swrPeakTimes );
                swrData.peakValues    = swrPeakValues;
                
                % envelope distribution data
                swrData.swrEnvDistVals   = hh.Values;
                swrData.swrEnvDistBins   = hh.BinEdges;
                swrData.swrThreshold     = swrThreshold;
                swrData.swrEnvMedian     = swrEnvMedian;
                swrData.swrEnvMadam      = swrEnvMadam;
                swrData.swrEnvMean       = mean(swrLfpEnv);
                swrData.swrEnvStd        = std(swrLfpEnv);
                % free memory
                clear swrLfpEnv swrLfpTimestamps swrLfpTimestampSeconds
                
                % Theta information
                [ thetaChannel, thetaLfpTimestamps ]=csc2mat([ filepath   thetaLfpNames.(rat{ratIdx}){thisTheta} ]);
                thetaLfpTimestampSeconds = (thetaLfpTimestamps-thetaLfpTimestamps(1))/1e6;
                thetaLfp = filtfilt( filters.so.theta, thetaChannel );
                thetaAnalytic = hilbert(thetaLfp);
                thetaLfpEnv = abs(thetaAnalytic);
                thetaPhase = angle(thetaAnalytic);
                
                hh = histogram(thetaLfpEnv,500);
                
                swrData.thetaEnvDistVals  = hh.Values;
                swrData.thetaEnvDistBins  = hh.BinEdges;
                swrData.thetaEnvMedian    = median(thetaLfpEnv);
                swrData.thetaEnvMadam     = median(abs(thetaLfpEnv-median(thetaLfpEnv)));
                swrData.thetaEnvMean      = mean(thetaLfpEnv);
                swrData.thetaEnvStd       = std(thetaLfpEnv);
                % IMPORTANT -- unwrap and mod or else linear interpolation will produce bad phase data.
                swrData.thetaPhase       = mod(interp1( thetaLfpTimestamps, unwrap(thetaPhase), swrData.timestamps ), 2*pi)*180/pi;
                swrData.thetaEnv         = interp1( thetaLfpTimestamps, thetaLfpEnv, swrData.timestamps );
                swrData.thetaLfpName     = thetaLfpNames.(rat{ratIdx}){thisSwr};
                swrData.swrLfpName       = swrLfpNames.(rat{ratIdx}){thisSwr};

                
                % free memory
                clear thetaLfpEnv thetaLfpTimestamps thetaLfpTimestampSeconds

                swrData.x                = interp1( telemetry.xytimestamps, telemetry.x     , swrData.timestamps );
                swrData.y                = interp1( telemetry.xytimestamps, telemetry.y     , swrData.timestamps );
                swrData.speed            = interp1( telemetry.xytimestamps, telemetry.speed , swrData.timestamps );
                swrData.movDir           = interp1( telemetry.xytimestamps, telemetry.movDir, swrData.timestamps );
                swrData.headDir          = interp1( telemetry.xytimestamps, telemetry.movDir, swrData.timestamps );
                swrData.onMaze           = interp1( telemetry.xytimestamps, telemetry.onMaze, swrData.timestamps );
                swrData.trial            = interp1( telemetry.xytimestamps, telemetry.trial , swrData.timestamps );
               
                
                
                save( [ '~/Desktop/' rat{ratIdx} '_' folders.(rat{ratIdx}){thisFolder} '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_swr-' strrep( swrLfpNames.(rat{ratIdx}){thisSwr}, '.ncs', '') '.mat' ] , 'swrData' );
            end                              
        end
    end
end



return;



load('~/data/dissertation/swrEnhanced/h1_2018-08-28_theta-CSC20_swr-CSC20.mat');
[ swrChannel, swrLfpTimestamps ] = csc2mat('/Volumes/AGHTHESIS2/rats/h1/2018-08-28/CSC20.ncs');
swrLfpTimestampSeconds = (swrLfpTimestamps-swrLfpTimestamps(1))/1e6;
liaLfp = filtfilt( filters.so.lia, swrChannel ); 
swrLfp = filtfilt( filters.so.swr, swrChannel );
figure; plot(swrLfpTimestampSeconds,liaLfp); hold on; plot( swrLfpTimestampSeconds, swrLfp ); scatter( swrData.timestampSeconds, swrData.peakValues );






load([ '~/Desktop/' rat '_' folders{ffIdx} '_' ttFilenames{ttIdx} '.mat' ])

%%

% select certain, clean, low speed SWR
cleanSwrMask = ones(length(swrPeakTimes),1); cleanSwrMask(swrPeakTimesUnionIdxs)=0;
tempMask = (cleanSwrMask .* (grps==1) .* (swrSpeedAll<=10)' ) > 0 ;

tetrodeList = fieldnames(output.tt);
plotIdx = 1; printIdx = 1;
xcorrBinSize=0.02; % seconds
maxLagTime=2; % seconds
shuffleRepeats = 1000; % repeats
jitterWindow = 2; % seconds
forcedOffset = 1; % seconds
%
rng(1); s = RandStream('mlfg6331_64');  % repeatability!
precalculatedPolarity=ones(shuffleRepeats,length(swrPeakTimes)); % build binary vector to precalculate add or subtract
for ii=1:shuffleRepeats
    tempIdx = datasample(s,1:length(swrPeakTimes),round(length(swrPeakTimes)/2),'Replace',false);
    precalculatedPolarity( ii, tempIdx )=-1; % set said polarity vector
end
precalculatedShuffle=precalculatedPolarity.*(forcedOffset+jitterWindow*rand(shuffleRepeats,length(swrPeakTimes)));
%precalculatedShuffle=-(forcedOffset+rand(shuffleRepeats,length(swrPeakTimes)));
%
gcf=figure(11); plotIdx=1; printIdx=1;
%

            ttIdx= 9; whichCell= 4; gr = 1;

for ttIdx = 1:length(tetrodeList)
    % set up variables
    cellTimesAllSeconds = (output.tt.(tetrodeList{ttIdx}).spiketimestamps-thetaTimestamps(1))/1e6;
    cellNumber = output.tt.(tetrodeList{ttIdx}).cellNumber;
    for whichCell = 1:max(cellNumber)
        % plot swr X cell firing
        for gr=1:5
            subplot(3,2,plotIdx);
            tempMask = (cleanSwrMask .* (grps==gr) .* (swrSpeedAll<=10)' ) > 0 ;
            xcorrs = zeros( 1+2*(maxLagTime/xcorrBinSize), shuffleRepeats ); dims = size( cellTimesAllSeconds(cellNumber==whichCell) );
            for whichShuffle=1:shuffleRepeats
                xcorrs(:,whichShuffle) = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask)+precalculatedShuffle(whichShuffle,tempMask)', xcorrBinSize, maxLagTime );
            end
            [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes(tempMask), xcorrBinSize, maxLagTime );
            %hold off;
            scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
            title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) ' ' (output.swrLocationLabels{gr})  '; n=' num2str(sum(cellNumber==whichCell)) ]);
            fill_between_lines(lagtimes, prctile(xcorrs',0.5), prctile(xcorrs',99.5),1); alpha(.2); hold on;
            fill_between_lines(lagtimes, prctile(xcorrs',2.5), prctile(xcorrs',98.5),2); alpha(.2);
            fill_between_lines(lagtimes, prctile(xcorrs',25), prctile(xcorrs',75),3); alpha(.2);
            plot(lagtimes, prctile(xcorrs',50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
            plot(lagtimes,xcorrValues, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);
            title([ (tetrodeList{ttIdx}) ' c' num2str(whichCell) ' ' (output.swrLocationLabels{gr}) '; n=' num2str(sum(cellNumber==whichCell)) ]);
            %
            plotIdx = plotIdx+1;
            if plotIdx > 5
                print(gcf,[ '~/data/h5_May-11-2018_swrXspike_reshift_' (tetrodeList{ttIdx}) '_C' num2str(whichCell) '_' (output.swrLocationLabels{gr}) '_.png'],'-dpng','-r200');
                plotIdx = 1;
                printIdx = printIdx + 1;
                clf;
            end
        end
    end
end















return;


figure; 
scatter(swrData.speed(swrData.onMaze<0), swrData.peakValues(swrData.onMaze<0), 'o', 'filled'); alpha(.2); hold on;
scatter(swrData.speed(swrData.onMaze>0), -swrData.peakValues(swrData.onMaze>0), 'o', 'filled'); alpha(.2)

figure;
scatter(swrData.speed(swrData.onMaze<0), swrData.thetaEnv(swrData.onMaze<0), 'o', 'filled'); alpha(.2); hold on;
scatter(swrData.speed(swrData.onMaze>0), -swrData.thetaEnv(swrData.onMaze>0), 'o', 'filled'); alpha(.2)


selector = (swrData.onMaze<0) & (swrData.speed<10);

figure; scatter(swrData.speed(selector), swrData.thetaEnv(selector), 'o', 'filled'); alpha(.2); hold on;


swrData.thetaEnvDistVals


% trying to directly detect things in the average LFP that might be
% contaminating the SWR detection doesn't work so well. It picks up a
% gajillion things including chewing, which is what I really care about.


noiseLfpNames.h7

[ avgLfp, ~ ] = avgLfpFromList( '/Volumes/AGHTHESIS2/rats/h7/2018-08-15/', noiseLfpNames.h7 );
noiseSwr=filtfilt( filters.so.chew, avgLfp );
noiseEnv = abs(hilbert(noiseSwr));

noiseThreshold = quantile( noiseEnv, .97 );
[noisePeakValues, noisePeakTimes ] = findpeaks( noiseSwr,                        ... % data
                              (1:length(avgLfp))/32000,                     ... % sampling frequency
                              'MinPeakHeight',  noiseThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


[A,B]=meshgrid( swrData.timestampSeconds(selector), noisePeakTimes );
 min(min(abs(A-B)))                         
figure; histogram(abs(A-B))


sum(.05<min(abs(A-B))) 


figure; plot((1:length(avgLfp))/32000,noiseSwr); hold on; scatter( noisePeakTimes, noisePeakValues, 'v', 'filled' );

 

%% Chewing
disp('DETECT CHEWING')
% detect chewing events -- refered to as "crunch" because that's what they
% sound like. First, filter a fairly wide band to see the crunches
%
avgChew = filtfilt( filters.so.chew, avgLfp );
%
% These crunches occur at about 3-6 Hz, so I build a wide envelope-like
% signal in which to seek these groups; regular envelope at this sample
% rate is too wobbly to detect the dead-obvious to the eye crunch groups.
%
[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, (1:length(avgLfp))/32000 );
% these filters depend on the ouput above.
filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%
% Next, find groups of crunches, refered to as "chewing episodes"/"reward"
%
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));
chewDetectorOutput = detectPeaksEdges( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );

%% bruxing
disp('DETECT BRUXING')
%
bruxEpisodeLFP=filtfilt( filters.ao.brux, chewCrunchEnv );
bruxEpisodeEnv=abs(hilbert(bruxEpisodeLFP));
bruxDetectorOutput = detectPeaksEdges( bruxEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate, chewCrunchEnvSampleRate/10  );

%%


figure; histogram(swrLfpEnv);
hh=histogram(swrLfpEnv);
aa=normpdf( hh.BinEdges(1:end-1)+diff(hh.BinEdges)/2, mean(swrLfpEnv) , std(swrLfpEnv) );
hold on; plot(hh.BinEdges(1:end-1)+diff(hh.BinEdges)/2, aa*max(hh.Values)/max(aa));
bb=normpdf( hh.BinEdges(1:end-1)+diff(hh.BinEdges)/2, median(swrLfpEnv) , median(abs(swrLfpEnv-median(swrLfpEnv))) );
hold on; plot(hh.BinEdges(1:end-1)+diff(hh.BinEdges)/2, bb*max(hh.Values)/max(bb));



max(aa)





figure; plot(chewCrunchEnvTimes,-chewCrunchEnv);hold on; plot( chewCrunchEnvTimes, chewEpisodeEnv);
scatter(chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v','filled');
 scatter(bruxDetectorOutput.EpisodePeakTimes, bruxDetectorOutput.EpisodePeakValues, 'v','filled');
 scatter(swrData.timestampSeconds(selector), swrData.peakValues(selector), 'v','filled')
 
figure;
ifreq=(32000/(2*pi))*diff(unwrap(thetaPhase));
subThetaEnv = decimate(thetaLfpEnv,1000);
subIfreq = decimate(ifreq, 1000);
subLfpTime = decimate( thetaLfpTimestampSeconds, 1000 );
plot(telemetry.xytimestampSeconds, telemetry.speed); hold on;
plot(subLfpTime, subThetaEnv*100/max(subThetaEnv));
plot(telemetry.xytimestampSeconds, telemetry.onMaze*100);
plot(subLfpTime, subIfreq );


subLfpOnMaze=interp1( telemetry.xytimestampSeconds, telemetry.onMaze, subLfpTime );
subLfpSpeed=interp1( telemetry.xytimestampSeconds, telemetry.speed, subLfpTime );


figure; scatter( subIfreq(subLfpOnMaze>0), subThetaEnv(subLfpOnMaze>0),'o', 'filled' ); alpha(.1)

figure; scatter( subLfpSpeed(subLfpOnMaze>0), subThetaEnv(subLfpOnMaze>0),'o', 'filled' ); alpha(.1)

figure; scatter( subLfpSpeed(subLfpOnMaze>0), subIfreq(subLfpOnMaze>0),'o', 'filled' ); alpha(.1)

subAcc=[0; diff(subLfpSpeed)];
figure; scatter( subAcc(subLfpOnMaze>0), subIfreq(subLfpOnMaze>0),'o', 'filled' ); alpha(.1)

quantile(subThetaEnv,.9)

figure; scatter( subLfpSpeed(subThetaEnv>.2 & subLfpOnMaze>0), subIfreq(subThetaEnv>.2 & subLfpOnMaze>0),'o', 'filled' ); alpha(.1)
