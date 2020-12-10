function movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob )

%% get ahold of position data    
    if exist([path '/position.mat'],'file');
        load([path '/position.mat'])        
        %xpos=median([ position.xGpos; position.xRpos ]);
        %ypos=median([ position.yGpos; position.yRpos ]);
        xpos=median([ position.xGpos; position.xRpos ]);
        ypos=median([ position.yGpos; position.yRpos ]);
        xytimestampSeconds = (0:length(ypos)-1)/29.97;
        [ ~, ~, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
    else
        [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
        xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    end    
    %speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
    smoothSpeed=calculateSmoothedSpeed(xpos, ypos, 45, 2.8);
    speed=smoothSpeed;
    
%% determine whether the rat is in the bucket or not

    inBucket = zeros(size(speed));
    if (behaviorData.timeToMazeSec(1) > 0)
        segmentStartIdx = 1;
        segmentEndIdx = floor(behaviorData.timeToMazeSec(1)*29.97);
        inBucket(segmentStartIdx:segmentEndIdx) = 1;
    else
        warning(' marking rat as starting on the maze')
    end
    for ii=2:length(behaviorData.timeToMazeSec)
        if behaviorData.timeToBucketSec(ii-1) > 0
            segmentStartIdx =  floor( max([ behaviorData.timeToBucketSec(ii-1) behaviorData.timeToContRetSec(ii-1) ])*29.97);
            segmentEndIdx = floor( behaviorData.timeToMazeSec(ii)*29.97);
            inBucket(segmentStartIdx:segmentEndIdx) = 1;
        end
    end
    if behaviorData.timeToBucketSec(ii) > 0
        segmentStartIdx = floor(behaviorData.timeToBucketSec(ii)*29.97);
        inBucket(segmentStartIdx:end) = 1;
    end
    %
    
%% obtain SWR data

    if  strcmp( swrFilename(1:3), 'SWR');
        [ swrLfp, lfpTimestamps ]=csc2mat( [ path swrFilename ] );
    else
        [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ] );
        swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
        swrLfp = filtfilt( swrFilter, lfpSwr );
    end
    
    if ~exist([path '/swrData_' swrFilename(1:end-4) '.mat']);
        lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
        swrLfpEnv = abs(hilbert(swrLfp));
        swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
        [swrPeakValues,      ...
         swrPeakTimes,       ... 
         swrPeakProminances, ...
         swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                      lfpTimestampSeconds,                     ... % sampling frequency
                                      'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
    
                                  
         % build some structures for later SWR analysis
        swrPosAll=zeros(2,length(swrPeakTimes));
        swrSpeedAll=zeros(1,length(swrPeakTimes));
        for ii=1:length(swrPeakTimes)
            tempIdx=find(swrPeakTimes(ii)<=xytimestampSeconds, 1 );
            if ~isempty(tempIdx)
                swrPosAll(1,ii) = xrpos (tempIdx);
                swrPosAll(2,ii) = yrpos (tempIdx);
                swrSpeedAll(ii) = speed (tempIdx);
            end
        end
        swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
        swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);
        %
        swrData.swrPosAll = swrPosAll;
        swrData.swrSpeedAll = swrSpeedAll;
        swrData.times = swrPeakTimes;
        swrData.peaks = swrPeakValues;
        swrData.file = swrFilename;
        save( [ path '/swrData_' swrFilename(1:end-4) '.mat' ], 'swrData' )
    else
        load( [ path '/swrData_' swrFilename(1:end-4) '.mat' ] );
        swrPeakTimes  = swrData.times;
        swrPeakValues = swrData.peaks;
        swrFilename   = swrData.file;
        swrPosAll     = swrData.swrPosAll;
        swrSpeedAll   = swrData.swrSpeedAll;
    end


% %% find velocities near SWR events
% 
%     if isempty(movInitBlob.swrTrigSpeedStack)
%         stackIdx = 1;
%     else
%         stackIdx = length(movInitBlob.swrTrigSpeedStack)+1;
%     end
% 
%     for ii=1:length(swrPeakTimes)
%             startIdx = floor((swrPeakTimes(ii)-3)*29.97)+1;
%             endIdx   = floor((swrPeakTimes(ii)+3)*29.97)+1;
%         if ( startIdx > 0 ) && ( endIdx <= length(speed) ) && sum(inBucket(startIdx:endIdx) == 0)
%             snippet = speed(startIdx:endIdx);
%             if length(snippet) > 91
%                 snippet=snippet(1:91);
%             end
%             %
%             movInitBlob.swrTrigSpeedStack(stackIdx,:) = snippet;
%             movInitBlob.swrTrigRatLabel{stackIdx} = ratName;
%             movInitBlob.swrTrigSession{stackIdx} = dateStr;
%             movInitBlob.swrTrigTime(stackIdx) = swrPeakTimes(ii);
%             movInitBlob.swrTrigMag(stackIdx) = swrPeakValues(ii);
%             movInitBlob.swrTrigCh{stackIdx} = swrFilename;
%             %
%             stackIdx = stackIdx + 1;
%         end
%     end
    

%% find transitions to movement

    if isempty(movInitBlob.goTrigSpeedStack)
        stackIdx = 1;
    else
        stackIdx = length(movInitBlob.goTrigSpeedStack)+1;
    end

    calmToMoveIdxs = [];
    jj=92;
    while jj<length(speed)-92
        if ( sum(inBucket(jj-90:jj+90)) == 0 )
            if  sum( speed(jj-90:jj) > 10 ) < 5
                if median ( speed(jj:jj+90) ) > 10
                    %calmToMoveIdxs = [ calmToMoveIdxs jj ];            
                    %
                    movInitBlob.goTrigTime(stackIdx) = xytimestampSeconds(jj);
                    movInitBlob.goTrigSpeedStack(stackIdx,:) = speed(jj-90:jj+90);
                    movInitBlob.goTrigRatLabel{stackIdx} = ratName;
                    movInitBlob.goTrigSession{stackIdx} = dateStr;
                    tidx = (( swrPeakTimes > (xytimestampSeconds(jj)-3) ) .* ( swrPeakTimes < (xytimestampSeconds(jj)+3) ))>0;
                    %xytimestampSeconds(jj)
                    %swrPeakTimes(tidx)'
                    snipIdxs=((floor((swrPeakTimes(tidx)-xytimestampSeconds(jj)+3)*29.97)+1))';
                    tempVector = zeros(1,181);
                    tempVector(snipIdxs) = 1;
                    movInitBlob.goTrigSwrTimes(stackIdx,:) = tempVector;
                    tempVector(snipIdxs) = swrPeakValues(tidx);
                    movInitBlob.goTrigSwrMag(stackIdx,:) = tempVector';
                    movInitBlob.goTrigSwrCh{stackIdx} = swrFilename;
                    %
                    stackIdx = stackIdx + 1;
                    %
                    jj=jj+180;
                end
            end
        end
        jj=jj+1;
    end
   
%% move to slow
    if isempty(movInitBlob.stopTrigSpeedStack)
        stackIdx = 1;
    else
        stackIdx = length(movInitBlob.stopTrigSpeedStack)+1;
    end
    jj=92;
    while jj<length(speed)-92
        if ( sum(inBucket(jj-90:jj+90)) == 0 )
            if  sum( speed(jj:jj+90) > 10 ) < 5
                if median ( speed(jj-90:jj) ) > 10
                    %calmToMoveIdxs = [ calmToMoveIdxs jj ];            
                    %
                    movInitBlob.stopTrigTime(stackIdx) = xytimestampSeconds(jj);
                    movInitBlob.stopTrigSpeedStack(stackIdx,:) = speed(jj-90:jj+90);
                    movInitBlob.stopTrigRatLabel{stackIdx} = ratName;
                    movInitBlob.stopTrigSession{stackIdx} = dateStr;
                    tidx = (( swrPeakTimes > (xytimestampSeconds(jj)-3) ) .* ( swrPeakTimes < (xytimestampSeconds(jj)+3) ))>0;
                    %xytimestampSeconds(jj)
                    %swrPeakTimes(tidx)'
                    snipIdxs=((floor((swrPeakTimes(tidx)-xytimestampSeconds(jj)+3)*29.97)+1))';
                    tempVector = zeros(1,181);
                    tempVector(snipIdxs) = 1;
                    movInitBlob.stopTrigSwrTimes(stackIdx,:) = tempVector;
                    tempVector(snipIdxs) = swrPeakValues(tidx);
                    movInitBlob.stopTrigSwrMag(stackIdx,:) = tempVector';
                    movInitBlob.stopTrigSwrCh{stackIdx} = swrFilename;
                    %
                    stackIdx = stackIdx + 1;
                    %
                    jj=jj+180;
                end
            end
        end
        jj=jj+1;
    end
    
    
    return;
end