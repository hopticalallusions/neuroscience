function telemetry = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folder )

    dateStr = folder(1:10);

    %% Load a linearization mask to assist make the data cleaner
%     maskDir='~/Desktop/';
%     mazeMask=imread( [ maskDir 'mazeLinearizedMask3.png' ] );
%     mazeMask=mean( mazeMask, 3 );
%     mazeMask = mazeMask < 200; %figure; imshow(mazeMask);
%     [ mazeMaskX, mazeMaskY ] = find(mazeMask);
%     [ mazeMaskX, mazeMaskY ] = rotateXYPositions( mazeMaskX, mazeMaskY, 500, 500, -90, 500, 500 );

    %% Read in behavioral data
    table=readtable('~/data/dissertation/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
    % to access the table in a useful way, it works better to convert it to a dataset
    ds = table2dataset(table);

%%
    
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;


    % Hard limit in case some sort of weirdness happens
    tidx=xrpos> 140; xrpos(tidx)= 140;
    tidx=xrpos<-140; xrpos(tidx)=-140;
    tidx=yrpos> 140; yrpos(tidx)= 140;
    tidx=yrpos<-140; yrpos(tidx)=-140;
    
    
    % perform various calculations which we will desire later
    movDir = zeros(1,length(xrpos));
    displacement =   zeros(1,length(xrpos));
    % calculate displacement
    displacement(5:end-5) = sqrt(  (xrpos(10:end)-xrpos(1:end-9)).^2  +  (yrpos(10:end)-yrpos(1:end-9)).^2 );
    % for a 300 ms window, where is the rat heading?
    movDir(5:end-5) = (atan2( xrpos(10:end)-xrpos(1:end-9), yrpos(10:end)-yrpos(1:end-9) ) +pi)*180/pi ;
    % anywhere where displacement is zero, the atan will snap back to 180
    % degrees, which is wrong. when zero threshold is detected, just use
    % the last good direction
    for kk=5:length(xrpos)-5; if (displacement(kk) < 3 ); movDir(kk) = movDir(kk-1); end; end;
    % smooth over this calculation
    for kk=5:length(xrpos)-5; movDir(kk) = median(movDir(kk-3:kk+3)); end;
    telemetry.movDir = movDir;
    telemetry.speed = calculateSpeed(xrpos, yrpos, 1, 1   );
    telemetry.speedBumpy = calculateSpeed( xrpos, yrpos, .1, 1 )';
    % TODO insert smoothing for movement direction
    
    % TODO insert smoothing for head direction
    
    telemetry.headDir =  headDir; 
    
    % now we can select via string comparison a particular set of dates
    dbTrials = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 3);
    dbTrials = dbTrials.Trial(:);
    startTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 4);
    startTimes = startTimes.TimeMazeSec(:);
    bucketTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 9);
    bucketTimes = bucketTimes.TimeBucketSec(:);
    contRestartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 10);
    contRestartTimes = contRestartTimes.toContSec(:);
    endTimes = max([ bucketTimes contRestartTimes ]');
    onMaze = ones(1,length(xrpos))-2;
    trial  = zeros(1,length(xrpos))-1;
    if endTimes(1)>startTimes(1)
        for kk=1:length(startTimes)
            startIdx = find(xytimestampSeconds>startTimes(kk),1);
            endIdx =  find(xytimestampSeconds>endTimes(kk),1);
            onMaze(startIdx:endIdx)=1;
            trial(startIdx:endIdx) = dbTrials(kk);
        end
    else
        startIdx = 1;
    	endIdx =  find(xytimestampSeconds>endTimes(kk),1);
        onMaze(startIdx:endIdx)=1;
        for kk=2:length(startTimes)
            startIdx = find(xytimestampSeconds>startTimes(kk),1);
            endIdx =  find(xytimestampSeconds>endTimes(kk),1);
            onMaze(startIdx:endIdx)=1;
            trial(startIdx:endIdx) = dbTrials(kk);
        end
    end
    telemetry.onMaze = onMaze;
    
%     xlpos=zeros(size(xrpos));
%     ylpos=zeros(size(yrpos));
%     distLpos = zeros(size(yrpos));
%     for kk=1:length(xrpos);
%         distances = sqrt( (mazeMaskX-xrpos(kk)).^2 + (mazeMaskY-yrpos(kk)).^2 );
%         [ dist, idx ] = min(distances);
%         idx=idx(1);
%         xlpos(kk) = mazeMaskX(idx);
%         ylpos(kk) = mazeMaskY(idx);
%         distLpos(kk) = dist;
%     end
%     telemetry.xlpos = xlpos;
%     telemetry.ylpos = ylpos;
%     telemetry.distLpos = distLpos;

    % store standard data
    telemetry.x = xrpos;
    telemetry.y = yrpos;
    telemetry.xytimestamps = xytimestamps;
    telemetry.xytimestampSeconds = xytimestampSeconds;
    telemetry.trial = trial;
    
    save([ '~/Desktop/' '/' rat '_' folder '_telemetry.mat'],'telemetry');

return


