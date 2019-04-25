%% DA5
recDays = { 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
% over days, how does sharp wave ripple production vary while the rat is on the maze?
% construct the needed data structure
rat='da5';
clear perTrial;
trialIdx=0;
for ii=1:length(recDays)
    for jj=1:length(aggda5.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat = rat;
        perTrial(trialIdx).day      = ii-1;
        try
            perTrial(trialIdx).trial    = aggda5.(recDays{ii}).trial(jj);
        catch
            perTrial(trialIdx).trial    = -1;
        end
%         if jj>1
%             startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).trialStartAction(jj) ) , 1 );
                % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).firstArmEndReached(jj) ) , 1 ); 
        %endIdx = find( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = find( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveMazeToBucket(jj), 1 );
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;  % added 1 s extra to prevent problems later
        perTrial(trialIdx).xpos     = aggda5.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = aggda5.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = aggda5.(recDays{ii}).xyspeed(xyIdxs);
        %perTrial(trialIdx).smoothSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).smoothSpeed(xyIdxs);

        dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
        dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
        tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
        ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
        for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        boxcarSize = 45;
        dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
        dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
        perTrial(trialIdx).smoothSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;

        
        dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
        dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
        tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
        ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
        for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        perTrial(trialIdx).instantSpeed = sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97;
        
        
        
        perTrial(trialIdx).lagSpeed    = aggda5.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = aggda5.(recDays{ii}).xylinearized(xyIdxs);  
        %
        %perTrial(trialIdx).proxToReward     = aggda5.(recDays{ii}).proxToReward(xyIdxs);
        %
        perTrial(trialIdx).xytimestampSeconds = aggda5.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( aggda5.(recDays{ii}).swrTimes > aggda5.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( aggda5.(recDays{ii}).swrTimes < aggda5.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes         = aggda5.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos          = aggda5.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos          = aggda5.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized    = aggda5.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed         = aggda5.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = aggda5.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrsmoothSpeed   = aggda5.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).error            = aggda5.(recDays{ii}).error(jj);
        perTrial(trialIdx).probe            = aggda5.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline          = aggda5.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed    = aggda5.(recDays{ii}).sugarConsumed(jj);
        %
        %tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
        %perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
        %tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
        %perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
    end
end

%% identify stillness

for ii=1:length(perTrial)
    perTrial(ii).instantStillness = perTrial(ii).smoothSpeed < 7;
    perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
    perTrial(ii).stillness = perTrial(ii).speed < 7;
    % median smoothing
    smoothFactor = 15;
    for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
        perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
        perTrial(ii).instantStillness(jj) = median(perTrial(ii).instantStillness(jj-smoothFactor:jj+smoothFactor));
    end
end

%figure; plot(perTrial(10).stillness); hold on; plot(diff(perTrial(10).stillness)); ylim([-2 2])


%% find start and ends of episodes

transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
    % now find 3+s periods
% pick which stillness metric you want
    %    movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
    % movementTransitionIdx=find(abs(diff(perTrial(ii).stillness)));
    tstill = perTrial(ii).instantStillness;
    %tstill = perTrial(ii).stillness;
    motionToStillTransitionIdx=find((diff(tstill)>0));
    stillToMotionTransitionIdx=find((diff(tstill)<0));
    movementTransitionIdx=find(abs(diff(tstill)));
    movementTransitionIdx=find((diff(tstill)<0));
    % track how many 
    transitionsFound(ii) = length(movementTransitionIdx);
    perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end




%% pull together the data

goodEpisodesFound = transitionsFound;

swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
smoothSpeedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));

motionStillSpeed=zeros( 180 , sum(goodEpisodesFound));
motionSwrEvents=zeros( 180 , sum(goodEpisodesFound));

%proxToReward=zeros( 180 , sum(goodEpisodesFound));
%proxToRewardPre=zeros( 90 , sum(goodEpisodesFound));
%proxToRewardPost=zeros( 90 , sum(goodEpisodesFound));
xpos = zeros( 180 , sum(goodEpisodesFound));
ypos = zeros( 180 , sum(goodEpisodesFound));
%
% swrEnvPre=zeros( 3*2000 , sum(goodEpisodesFound));
% swrEnvPost=zeros( 3*2000 , sum(goodEpisodesFound));
% thetaEnvPre=zeros( 3*250 , sum(goodEpisodesFound));
% thetaEnvPost=zeros( 3*250 , sum(goodEpisodesFound));
%
timeToBucket = zeros(  1 , sum(goodEpisodesFound));
timeSinceBucket = zeros(  1 , sum(goodEpisodesFound));
err=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
motionCurrentEpisode=1;
episodeStartTime=zeros(  1 , sum(goodEpisodesFound));
for currentTrial = 1:length(perTrial)
    %disp(' start of trial ')
    speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
    smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(1:180)';
    endTime = perTrial(currentTrial).xytimestampSeconds(180);
    startTime = endTime-6;
    swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
    tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
    swrEvents( tempIdxs, currentEpisode ) = 1;
    episodeStartTime(currentEpisode) = startTime;
    currentEpisode = currentEpisode + 1;
    % add all the incidental stuff
    %disp( 'where is the rat' )
    xpos( :, currentEpisode ) = perTrial(currentTrial).xpos(1:180);
    ypos( :, currentEpisode ) = perTrial(currentTrial).ypos(1:180);
    %
    ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
    day(currentEpisode)    = perTrial(currentTrial).day;
    trial(currentEpisode)  = perTrial(currentTrial).trial;
    %
    % report how much time remains until the trial ends
    % this will measure from the end of the stillness/start of the motion
    timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(1);
    timeSinceBucket(currentEpisode)= 0;
    %
    err(currentEpisode)= perTrial(currentTrial).error;
    prb(currentEpisode)= perTrial(currentTrial).probe;
    code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
    %
    lastTime = perTrial(currentTrial).xytimestampSeconds(1);
    %
    %disp('for loop')
    for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
        % eliminate overlaps with the start and end of the trial
        if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+180 < length(perTrial(currentTrial).speed) ) ...
                && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-180 > 0) ...
                && ( 3 < perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode)) - lastTime)
               % && ( stillEpisode > 1) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-perTrial(currentTrial).movementTransitionIdx(stillEpisode-1) > 45)
            %disp( 'loop start' )
            speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
            smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
            %disp( 'speeds' );
            endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
            startTime = endTime-3;
            episodeStartTime(currentEpisode) = startTime;
            swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
            tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
            tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
            swrEvents( tempIdxs, currentEpisode ) = 1;
            %
            %disp( 'where is the rat' )
            xpos( :, currentEpisode ) = perTrial(currentTrial).xpos( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
            ypos( :, currentEpisode ) = perTrial(currentTrial).ypos( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
            %
            ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
            day(currentEpisode)    = perTrial(currentTrial).day;
            trial(currentEpisode)  = perTrial(currentTrial).trial;
            %
            % report how much time remains until the trial ends
            % this will measure from the end of the stillness/start of the motion
            timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode));
            timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
            %
            err(currentEpisode)= perTrial(currentTrial).error;
            prb(currentEpisode)= perTrial(currentTrial).probe;
            code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
            %
            currentEpisode = currentEpisode + 1;
            lastTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode));
        else
            disp('skipping because exceeds end of trial')
        end        
    end
    %disp( 'end of trial' )
    speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
    smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(end-179:end)';
    endTime = perTrial(currentTrial).xytimestampSeconds(end);
    startTime = endTime-6;
    swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
    tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
    swrEvents( tempIdxs, currentEpisode ) = 1;
    currentEpisode = currentEpisode + 1;
    episodeStartTime(currentEpisode) = startTime;
    %
    % disp( 'where is the rat' )
    xpos( :, currentEpisode ) = perTrial(currentTrial).xpos(end-179:end);
    ypos( :, currentEpisode ) = perTrial(currentTrial).ypos(end-179:end);
    %
    ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
    day(currentEpisode)    = perTrial(currentTrial).day;
    trial(currentEpisode)  = perTrial(currentTrial).trial;
    %
    % report how much time remains until the trial ends
    % this will measure from the end of the stillness/start of the motion
    timeToBucket(currentEpisode)= 0;
    timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(1);
    %
    err(currentEpisode)= perTrial(currentTrial).error;
    prb(currentEpisode)= perTrial(currentTrial).probe;
    code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
    %
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( :, 1:currentEpisode-1 )';
speedDist=speedDist( :, 1:currentEpisode-1 )';
smoothSpeedDist=smoothSpeedDist(  :, 1:currentEpisode-1 )';
xpos=xpos( :, 1:currentEpisode-1 )';
ypos=ypos( :, 1:currentEpisode-1 )';
%
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
episodeStartTime=episodeStartTime(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
%motionStillSpeed=motionStillSpeed( : , 1:motionCurrentEpisode-1 )';
%motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1)';



%% plot all the speed/stillness/SWR events
figure%(1);
for ii= 28 %1:length(perTrial)
    %subplot(2,3,[ 1 2 4 5 ]);
    subplot(2,2,1:2);
    hold off;
    %plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
    hold on;
    %plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
    %scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
    scatter( perTrial(ii).swrTimes, -1*ones(size(perTrial(ii).swrTimes)), 'b+' );
    plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
    plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
    %
    offset = rand(1);
    line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
    scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
    %
    lastTime = perTrial(ii).xytimestampSeconds(1);
    %%
    for jj=1:length(perTrial(ii).movementTransitionIdx)
        if ( perTrial(ii).movementTransitionIdx(jj)+180 < length(perTrial(ii).speed) ) ...
            && ( perTrial(ii).movementTransitionIdx(jj)-180 > 0) ...
            && ( 3 < perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)) - lastTime)    
        %&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
        % % %
            offset = rand(1)*2;
            line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
            scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
            %
            lastTime = perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj));
        end
    end
    %
    offset = rand(1);
    line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
    scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
    %
    axis tight;
    ylim([ -2 60 ]); % ylim([ -20 180 ]);
    xlabel('time (s)');
    ylabel('speed (cm/s)');
    title(['trial ' num2str(ii) ])
    % time by position
    subplot(2,2,3);
    hold off;
    x = perTrial(ii).xpos;
    y = perTrial(ii).ypos;
    z = zeros(size(x));
    h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
                 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
    colormap('hsv');
    colorbar;
    title('position by time')
    % speed by position
    subplot(2,2,4);
    hold off;
    x = perTrial(ii).xpos;
    y = perTrial(ii).ypos;
    z = zeros(size(x));
    h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
                 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
    colormap('jet');
    colorbar;
    title('position by speed');end
%    print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
    clf(1);
%    drawnow;
 %   pause(.2);
end



%% sort the data
selectedRuns = (mean(speedDist(:,1:70)')<10)' .* (mean(speedDist(:,91:180),2)>10);

stillMotionSpeeds=speedDist(find(selectedRuns),:);
stillMotionSmootherSpeeds=smoothSpeedDist(find(selectedRuns),:);
stillMotionSwrEvents=swrEvents(find(selectedRuns),:);

[B,I]=sort(mean(stillMotionSmootherSpeeds(:,91:180),2));

stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=stillMotionSmootherSpeeds(I,:);
stillMotionSwrEvents=swrEvents(I,:);

% stillIdxs=mean(stillMotionSpeeds(:,1:60),2); %
% priorStillness = (stillMotionSpeeds(:,stillIdxs<7));
% priorStillnessSWR = stillMotionSwrEvents(:,stillIdxs<7);

aa=sum(stillMotionSwrEvents(:,1:90),2)+mean(stillMotionSpeeds(:,120:170),2)/max(mean(stillMotionSpeeds(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:)); 
subplot(1,5,5); 
plot(sum(stillMotionSwrEvents(I,1:90),2), 1:140); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);


hold on; scatter(sum(priorStillnessSWR(I,91:180),2), fliplr( 1:length(priorStillnessSWR)),'o');





figure; surf(speedDist(:,1:90));


%figure; imagesc(stillMotionSmootherSpeeds); colormap;
%figure; hold on; spy(stillMotionSwrEvents)

aa=mean(smoothSpeedDist(:,130:160),2)./mean(smoothSpeedDist(:,21:60),2);
aa=(sum(swrEvents(:,1:90),2));



% [B,I]=sort(mean(motionStillSpeed(:,1:90),2));
% motionStillSpeed=motionStillSpeed(I,:);
% motionSwrEvents=motionSwrEvents(I,:);



saturdayData.swrEvents=swrEvents;
saturdayData.speedDist=smoothSpeedDist;
saturdayData.err=err;
saturdayData.prb=prb;
saturdayData.ratNum=5;
saturdayData.day=day;
saturdayData.trial=trial;
saturdayData.xpos=xpos;
saturdayData.ypos=ypos;
saturdayData.episodeStartTime=episodeStartTime;










%% 



sum(sum(stillMotionSwrEvents(1:280,1:90),2)>0)/280
sum(sum(stillMotionSwrEvents(281:390,1:90),2)>0)/110

sum(sum(stillMotionSwrEvents(1:280,91:180),2)>0)/280
sum(sum(stillMotionSwrEvents(281:390,91:180),2)>0)/110



figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
figure; imagesc(motionStillSpeed); colormap;
figure; hold on; spy(motionSwrEvents)




%speedDist=speedDist';
speedPre=speedDistPre';

diffDist=diff(speedDist,1,1);
%swrEvents=saturdayData.swrEvents;

figure; hold on;
for ii=1:length(speedDist);
    swrnum(ii)=sum(swrEvents(1:90,ii));
    meanspd(ii)=mean(speedDist(:,ii));
    meanspd3190(ii)=mean(speedDist(121:180,ii));
    maxspd(ii)=max(speedDist(91:180,ii));
%                                         maxpre(ii)=max(speedPre(:,ii));
    maxpre(ii)=max(speedDist(1:90,ii));
    maxdiff(ii)=max(abs(diffDist(:,ii)));
    scatter(sum(swrEvents(:,ii))+((rand(1)-.5)/1.5), mean((speedDist(:,ii))),'k'); 
end





















% 
% roll through the trials serially
% 
% still:still
% still:motion
% motion:still
% motion:motion
% 
% 
% stillStillSpeeds = zeros(1,89*2);
% stillMotionSpeeds = zeros(1,89*2);
% motionStillSpeeds = zeros(1,89*2);
% motionMotionSpeeds = zeros(1,89*2);
% 
% stillStillSwrs = zeros(1,89*2);
% stillMotionSwrs = zeros(1,89*2);
% motionStillSwrs = zeros(1,89*2);
% motionMotionSwrs = zeros(1,89*2);
% 
% 
% epIdx=1;
% for thisTrial = 1:length(perTrial)
%     for thisEp = 1:length(perTrial(thisTrial).startIdxList)
%         if perTrial(thisTrial).startIdxList(thisEp) ~= 1
%             % we are in motion to start, so how long is this motion?
%             if perTrial(thisTrial).startIdxList(thisEp) > 89
%                 % this movement episode is at least 3 seconds long, so we
%                 % should put it in the dataset
%                 if perTrial(thisTrial).startIdxList(thisEp) > 178
%                     % this is at least a 6s stillness episode, so it goes
%                     % in stillStill
%                     stillStillSpeeds(epIdx,:) = perTrial(thisTrial).smoothSpeed(1:178);
%                 else
%                     % this is a 3s episode followed by some motion
%                     stillMotionSpeeds(epIdx,:) = perTrial(thisTrial).smoothSpeed(1:178);
%                 end
%             else
%                 % we ignore it
%             end
%         else
%             % we are still, so how long is this stillness
%             if perTrial(thisTrial).startIdxList(thisEp) > 89
%                 % this movement episode is at least 3 seconds long, so we
%                 % should put it in the dataset
%                 if perTrial(thisTrial).startIdxList(thisEp) > 178
%                     % this is at least a 6s stillness episode, so it goes
%                     % in stillStill
%                     stillStillSpeeds(epIdx,:) = perTrial(thisTrial).smoothSpeed(1:178);
%                 else
%                     % this is a 3s episode followed by some motion
%                     stillMotionSpeeds(epIdx,:) = perTrial(thisTrial).smoothSpeed(1:178);
%                 end
%             else
%                 % we ignore it
%             end
%             
%         end
%         
%         % check to see if the episode is 
%         if ( perTrial(thisTrial).endIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp) ) > 89
% 
%         
% 
% 
% 
% 
% 
% for thisTrial = 1:length(perTrial)
%     if length(perTrial(thisTrial).startIdxList) == 1
%         preDuration  = ( perTrial(thisTrial).startIdxList(1) ) / 29.97;
%         postDuration = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
%         disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
%         preDuration  = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
%         postDuration = ( length(perTrial(thisTrial).xpos)  - perTrial(thisTrial).endIdxList(1) ) / 29.97;
%         disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
%     else
%         for thisEp = 1:length(perTrial(thisTrial).startIdxList)-1
%             if thisEp == 1
%                 preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
%                 postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
%             elseif thisEp == length(perTrial(thisTrial).startIdxList)
%                 preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
%                 postDuration = ( length(perTrial(thisTrial).xpos) - perTrial(thisTrial).endIdxList(thisEp) ) / 29.97;
%             else
%                 preDuration  = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
%                 postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp+1) ) / 29.97;
%             end
%             disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
%         end
%     end
% end
% 
% 
% 
% 
% disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
%         preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
%         postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
%         disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
% 
%         
%         
%         
%         
%         
% end
%         
%         
%         
%                 stillnessDuration = ( perTrial(thisTrial).endIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
%             














% %% 
% swrEvents=zeros( 90 , sum(goodEpisodesFound));
% speedDist=zeros( 180 , sum(goodEpisodesFound));
% smoothSpeedDist=zeros( 180 , sum(goodEpisodesFound));
% swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
% speedDistPre=zeros( 180 , sum(goodEpisodesFound));
% 
% 
% motionStillSpeed=zeros( 180 , sum(goodEpisodesFound));
% motionSwrEvents=zeros( 180 , sum(goodEpisodesFound));
% 
% %proxToReward=zeros( 180 , sum(goodEpisodesFound));
% %proxToRewardPre=zeros( 90 , sum(goodEpisodesFound));
% %proxToRewardPost=zeros( 90 , sum(goodEpisodesFound));
% xpos = zeros( 180 , sum(goodEpisodesFound));
% ypos = zeros( 180 , sum(goodEpisodesFound));
% %
% % swrEnvPre=zeros( 3*2000 , sum(goodEpisodesFound));
% % swrEnvPost=zeros( 3*2000 , sum(goodEpisodesFound));
% % thetaEnvPre=zeros( 3*250 , sum(goodEpisodesFound));
% % thetaEnvPost=zeros( 3*250 , sum(goodEpisodesFound));
% %
% timeToBucket = zeros(  1 , sum(goodEpisodesFound));
% timeSinceBucket = zeros(  1 , sum(goodEpisodesFound));
% err=zeros(  1 , sum(goodEpisodesFound));
% prb=zeros(  1 , sum(goodEpisodesFound));
% code=zeros(  1 , sum(goodEpisodesFound));
% ratNum=zeros(  1 , sum(goodEpisodesFound));
% day=zeros(  1 , sum(goodEpisodesFound));
% trial=zeros(  1 , sum(goodEpisodesFound));
% currentEpisode = 1;
% motionCurrentEpisode=1;
% for currentTrial = 1:length(perTrial)
%     % start of trial
%     speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:perTrial(currentTrial).endIdxList(stillEpisode)+180);
%     smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(1:perTrial(currentTrial).endIdxList(stillEpisode)+180)';
%     endTime = perTrial(currentTrial).xytimestampSeconds(180);
%     startTime = endTime-3;
%     swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
%     tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
%     swrEvents( tempIdxs, currentEpisode ) = 1;
%     %
%     for stillEpisode = 1:goodEpisodesFound(currentTrial)    
%         if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%             %disp('loop start')
%             speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%             smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%             %disp('after lfps');
%             endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
%             startTime = endTime-3;
%             swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
%             tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
%             swrEvents( tempIdxs, currentEpisode ) = 1;
%             %
%             % where is the rat
%             xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%             ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%             %
%             %disp('after swrEvents')
%             startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
%             endTime = startTime+3;
%             swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
%             tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
%             swrEventsPost( tempIdxs, currentEpisode ) = 1;
%             %disp('after swrEventsPost')
%             %
%             ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
%             day(currentEpisode)    = perTrial(currentTrial).day;
%             trial(currentEpisode)  = perTrial(currentTrial).trial;
%             %
%             % report how much time remains until the trial ends
%             % this will measure from the end of the stillness/start of the motion
%             timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
%             timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%             %
%             err(currentEpisode)= perTrial(currentTrial).error;
%             prb(currentEpisode)= perTrial(currentTrial).probe;
%             code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%             %
%             currentEpisode = currentEpisode + 1;
%         else
%             disp('skipping because exceeds end of trial')
%         end
%         
%         if ( perTrial(currentTrial).startIdxList(stillEpisode)-90 > 1 ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%             %disp('2nd loop start')
%             motionStillSpeed(:,motionCurrentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
%             %disp('2nd after speeds');
%             endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
%             startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
%             swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
%             tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
%             tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
%             motionSwrEvents( tempIdxs, motionCurrentEpisode ) = 1;
%             %
%             motionCurrentEpisode=motionCurrentEpisode+1;
%         else
%             disp('skipping because exceeds START of trial')
%         end
%         
%     end
% end
% % this will end up skipping episodes at the very end, so just save the
% % non-zero episode
% swrEvents=swrEvents( : , 1:currentEpisode-1 );
% speedDist=speedDist( : , 1:currentEpisode-1 )';
% smoothSpeedDist=smoothSpeedDist( : , 1:currentEpisode-1 )';
% swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
% speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
% err=err(1:currentEpisode-1);
% prb=prb(1:currentEpisode-1);
% code=code(1:currentEpisode-1);
% ratNum=ratNum(1:currentEpisode-1);
% day=day(1:currentEpisode-1);
% trial=trial(1:currentEpisode-1);
% xpos=xpos( : , 1:currentEpisode-1 );
% ypos=ypos( : , 1:currentEpisode-1 );
% timeToBucket=timeToBucket(1:currentEpisode-1);
% timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
% %proxToReward=proxToReward(:, 1:currentEpisode-1);
% motionStillSpeed=motionStillSpeed( : , 1:motionCurrentEpisode-1 )';
% motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1)';





% 
% 
% figure;
% for ii=1:length(perTrial)
%     hold off;
%     plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
%     hold on;
%     plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
%     scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
%     plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
%     plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%     for jj=1:length(perTrial(ii).endIdxList)
%             line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -2 -2 ], 'Color','red');
%             scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -2, 'xk' )
%     end
%      for jj=1:length(perTrial(ii).startIdxList)
%          if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1) 
%             line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -4 -4 ], 'Color','green');
%             scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -4, 'xk' )
%          end
%     end
%     axis tight;
%     ylim([ -20 180 ]);
%     xlabel('time (s)');
%     ylabel('speed (cm/s)');
%     title(['trial ' num2str(ii) ])
%     print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
% %    drawnow;
%  %   pause(.2);
% end






% % everything is in trials, so we know we are ignoring bucket and rest
% % periods
% goodEpisodesFound = zeros(1, length(perTrial) );
% for ii=1:length(perTrial)
% %     stillness = zeros(size(perTrial(ii).speed));
% %     % built a moving boxcar that handles edge cases
% %     if length(perTrial(ii).speed)>46
% %         for jj=1:45
% %             if median(perTrial(ii).speed(1:jj)) < 6
% %                 stillness(jj) = 1;
% %             end
% %         end
% %         for jj=46:length(perTrial(ii).speed)-46
% %             if median(perTrial(ii).speed(jj-45:jj+45)) < 6
% %                 stillness(jj) = 1;
% %             end
% %         end
% %         for jj=length(perTrial(ii).speed)-46:length(perTrial(ii).speed)
% %             if median(perTrial(ii).speed(jj:end)) < 6
% %                 stillness(jj) = 1;
% %             end
% %         end
% %     else
% %         disp('skipped a short trial');
% %     end
% %     perTrial(ii).stillness = stillness;
%     % now find 3+s periods
%     startIdx = 1; % when did the period start
%     endIdx = 1;   % when did the period end
%     inAnEpisode = 0; % are we currently tracking an episode of stillness
%     startIdxList = []; % list of >3s stillness period *ends*
%     endIdxList = []; % list of >3s stillness period *ends*
%     stillness = perTrial(ii).instantStillness;
%     for jj = 1:length(stillness)
%         if ( inAnEpisode == 0 ) && ( stillness(jj) == 1 )
%             inAnEpisode = 1;
%             startIdx = jj;
%         elseif ( inAnEpisode == 1 ) && ( stillness(jj) == 0 )
%             inAnEpisode = 0;
%             endIdx = jj-1;
%             if (endIdx-startIdx) > 89
%                 endIdxList = [ endIdxList endIdx ];
%                 startIdxList = [ startIdxList startIdx ];
%             end
%         end
%     end
%     % track how many 
%     goodEpisodesFound(ii) = length(endIdxList);
%     perTrial(ii).startIdxList = startIdxList;
%     perTrial(ii).endIdxList = endIdxList;
%     
% end


figure; ii=31; hold on;
        dx = zeros(size(perTrial(ii).xpos));
        dy = zeros(size(perTrial(ii).ypos));
        tx =  perTrial(ii).xpos;
        ty =  perTrial(ii).ypos;
        for kk=2:length(perTrial(ii).xpos)-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);

        dx = zeros(size(perTrial(ii).xpos));
        dy = zeros(size(perTrial(ii).ypos));
        tx =  perTrial(ii).xpos;
        ty =  perTrial(ii).ypos;
        boxcarSize = 45;
        tx=conv(tx,ones(1,boxcarSize)/boxcarSize, 'same');
        ty=conv(ty,ones(1,boxcarSize)/boxcarSize, 'same');
        for kk=2:length(perTrial(ii).xpos)-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);
        

        dx = zeros(size(perTrial(ii).xpos));
        dy = zeros(size(perTrial(ii).ypos));
        tx =  perTrial(ii).xpos;
        ty =  perTrial(ii).ypos;
%         boxcarSize = 45;
%         tx=conv(tx,ones(1,boxcarSize)/boxcarSize, 'same');
%         ty=conv(ty,ones(1,boxcarSize)/boxcarSize, 'same');
        for kk=2:length(perTrial(ii).xpos)-10
            dy(kk)=( ty(kk-1) - ty(kk+10) );
            dx(kk)=( tx(kk-1) - tx(kk+10) );
        end
        plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);
        ylim([0 150])


figure;
for ii= 31 % 1:length(perTrial)
    hold off;
    plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
    hold on;
    plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
    scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
    plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
    plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
    axis tight;
    ylim([ -20 180 ]);
    xlabel('time (s)');
    ylabel('speed (cm/s)');
    title(['trial ' num2str(ii) ])
    print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
























%% da10


recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };

rat='da10';
clear perTrialDa10;
trialIdx=0;
for ii=1:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrialDa10(trialIdx).rat = rat;
        perTrialDa10(trialIdx).day      = ii-1;
        try
            perTrialDa10(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
        catch
            perTrialDa10(trialIdx).trial    = -1;
        end
%         if jj>1
%             startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialStartAction(jj) ) , 1 );
                % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).firstArmEndReached(jj) ) , 1 ); 
        %endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj), 1 );
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;  % added 1 s extra to prevent problems later
        perTrialDa10(trialIdx).xpos     = agg.(recDays{ii}).xpos(xyIdxs);
        perTrialDa10(trialIdx).ypos     = agg.(recDays{ii}).ypos(xyIdxs);
        %
        perTrialDa10(trialIdx).speed    = agg.(recDays{ii}).xyspeed(xyIdxs);
        %perTrialDa10(trialIdx).smoothSpeed    =  calculateSpeed( agg.(recDays{ii}).xpos(xyIdxs), agg.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % agg.(recDays{ii}).smoothSpeed(xyIdxs);

        dx = zeros(size(agg.(recDays{ii}).xpos(xyIdxs)));
        dy = zeros(size(agg.(recDays{ii}).ypos(xyIdxs)));
        tx =  agg.(recDays{ii}).xpos(xyIdxs);
        ty =  agg.(recDays{ii}).ypos(xyIdxs);
        for kk=2:length(agg.(recDays{ii}).xpos(xyIdxs))-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        boxcarSize = 45;
        dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
        dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
        perTrialDa10(trialIdx).smoothSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;

        
        dx = zeros(size(agg.(recDays{ii}).xpos(xyIdxs)));
        dy = zeros(size(agg.(recDays{ii}).ypos(xyIdxs)));
        tx =  agg.(recDays{ii}).xpos(xyIdxs);
        ty =  agg.(recDays{ii}).ypos(xyIdxs);
        for kk=2:length(agg.(recDays{ii}).xpos(xyIdxs))-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        perTrialDa10(trialIdx).instantSpeed = sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97;
        
        
        
        perTrialDa10(trialIdx).lagSpeed    = agg.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrialDa10(trialIdx).xylinearized = agg.(recDays{ii}).xylinearized(xyIdxs);  
        %
        %perTrialDa10(trialIdx).proxToReward     = agg.(recDays{ii}).proxToReward(xyIdxs);
        %
        perTrialDa10(trialIdx).xytimestampSeconds = agg.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( agg.(recDays{ii}).swrTimes > agg.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( agg.(recDays{ii}).swrTimes < agg.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrialDa10(trialIdx).swrTimes         = agg.(recDays{ii}).swrTimes(swrIdxs);
        perTrialDa10(trialIdx).swrXpos          = agg.(recDays{ii}).swrXpos(swrIdxs);
        perTrialDa10(trialIdx).swrYpos          = agg.(recDays{ii}).swrYpos(swrIdxs);
        perTrialDa10(trialIdx).swrLinearized    = agg.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrialDa10(trialIdx).swrSpeed         = agg.(recDays{ii}).swrSpeed(swrIdxs);
        perTrialDa10(trialIdx).swrLagSpeed      = agg.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrialDa10(trialIdx).swrsmoothSpeed   = agg.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrialDa10(trialIdx).error            = agg.(recDays{ii}).error(jj);
        perTrialDa10(trialIdx).probe            = agg.(recDays{ii}).probe(jj);
        perTrialDa10(trialIdx).beeline          = agg.(recDays{ii}).beeline(jj);
        perTrialDa10(trialIdx).sugarConsumed    = agg.(recDays{ii}).sugarConsumed(jj);
        %
        %tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
        %perTrialDa10(trialIdx).swrEnv = agg.(recDays{ii}).swrEnv(tempIdxs);
        %tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
        %perTrialDa10(trialIdx).thetaEnv = agg.(recDays{ii}).thetaEnv(tempIdxs);
    end
end

figure;
for ii=1:length(perTrialDa10)
    hold off;
    plot( perTrialDa10(ii).xytimestampSeconds, perTrialDa10(ii).speed );
    hold on;
%    plot( perTrialDa10(ii).xytimestampSeconds, (perTrialDa10(ii).stillness*8-10) );
%    scatter( perTrialDa10(ii).swrTimes, perTrialDa10(ii).swrSpeed, 'r*' );
%    plot( perTrialDa10(ii).xytimestampSeconds, perTrialDa10(ii).smoothSpeed );
%    plot( perTrialDa10(ii).xytimestampSeconds, (perTrialDa10(ii).instantStillness*8-20) );
    axis tight;
    ylim([ -20 180 ]);
    xlabel('time (s)');
    ylabel('speed (cm/s)');
    title(['trial ' num2str(ii) ])
    print( [ '~/data/da10_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end





recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  };

rat='da12';
clear perTrialDa12;
trialIdx=0;
for ii=1:length(recDays)
    for jj=1:length(aggda12.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrialDa12(trialIdx).rat = rat;
        perTrialDa12(trialIdx).day      = ii-1;
        try
            perTrialDa12(trialIdx).trial    = aggda12.(recDays{ii}).trial(jj);
        catch
            perTrialDa12(trialIdx).trial    = -1;
        end
%         if jj>1
%             startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).trialStartAction(jj) ) , 1 );
                % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).firstArmEndReached(jj) ) , 1 ); 
        %endIdx = find( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = find( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveMazeToBucket(jj), 1 );
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;  % added 1 s extra to prevent problems later
        perTrialDa12(trialIdx).xpos     = aggda12.(recDays{ii}).xpos(xyIdxs);
        perTrialDa12(trialIdx).ypos     = aggda12.(recDays{ii}).ypos(xyIdxs);
        %
        perTrialDa12(trialIdx).speed    = aggda12.(recDays{ii}).xyspeed(xyIdxs);
        %perTrialDa12(trialIdx).smoothSpeed    =  calculateSpeed( aggda12.(recDays{ii}).xpos(xyIdxs), aggda12.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda12.(recDays{ii}).smoothSpeed(xyIdxs);

        dx = zeros(size(aggda12.(recDays{ii}).xpos(xyIdxs)));
        dy = zeros(size(aggda12.(recDays{ii}).ypos(xyIdxs)));
        tx =  aggda12.(recDays{ii}).xpos(xyIdxs);
        ty =  aggda12.(recDays{ii}).ypos(xyIdxs);
        for kk=2:length(aggda12.(recDays{ii}).xpos(xyIdxs))-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        boxcarSize = 45;
        dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
        dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
        perTrialDa12(trialIdx).smoothSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;

        
        dx = zeros(size(aggda12.(recDays{ii}).xpos(xyIdxs)));
        dy = zeros(size(aggda12.(recDays{ii}).ypos(xyIdxs)));
        tx =  aggda12.(recDays{ii}).xpos(xyIdxs);
        ty =  aggda12.(recDays{ii}).ypos(xyIdxs);
        for kk=2:length(aggda12.(recDays{ii}).xpos(xyIdxs))-1
            dy(kk)=( ty(kk-1) - ty(kk+1) );
            dx(kk)=( tx(kk-1) - tx(kk+1) );
        end
        perTrialDa12(trialIdx).instantSpeed = sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97;
        
        perTrialDa12(trialIdx).lagSpeed    = aggda12.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrialDa12(trialIdx).xylinearized = aggda12.(recDays{ii}).xylinearized(xyIdxs);  
        %
        %perTrialDa12(trialIdx).proxToReward     = aggda12.(recDays{ii}).proxToReward(xyIdxs);
        %
        perTrialDa12(trialIdx).xytimestampSeconds = aggda12.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( aggda12.(recDays{ii}).swrTimes > aggda12.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( aggda12.(recDays{ii}).swrTimes < aggda12.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrialDa12(trialIdx).swrTimes         = aggda12.(recDays{ii}).swrTimes(swrIdxs);
        perTrialDa12(trialIdx).swrXpos          = aggda12.(recDays{ii}).swrXpos(swrIdxs);
        perTrialDa12(trialIdx).swrYpos          = aggda12.(recDays{ii}).swrYpos(swrIdxs);
        perTrialDa12(trialIdx).swrLinearized    = aggda12.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrialDa12(trialIdx).swrSpeed         = aggda12.(recDays{ii}).swrSpeed(swrIdxs);
        perTrialDa12(trialIdx).swrLagSpeed      = aggda12.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrialDa12(trialIdx).swrsmoothSpeed   = aggda12.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrialDa12(trialIdx).error            = aggda12.(recDays{ii}).error(jj);
        perTrialDa12(trialIdx).probe            = aggda12.(recDays{ii}).probe(jj);
        perTrialDa12(trialIdx).beeline          = aggda12.(recDays{ii}).beeline(jj);
        perTrialDa12(trialIdx).sugarConsumed    = aggda12.(recDays{ii}).sugarConsumed(jj);
        %
        %tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
        %perTrialDa12(trialIdx).swrEnv = aggda12.(recDays{ii}).swrEnv(tempIdxs);
        %tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
        %perTrialDa12(trialIdx).thetaEnv = aggda12.(recDays{ii}).thetaEnv(tempIdxs);
    end
end

figure;
for ii=1:length(perTrialDa12)
    hold off;
    plot( perTrialDa12(ii).xytimestampSeconds, perTrialDa12(ii).speed );
    hold on;
%    plot( perTrialDa10(ii).xytimestampSeconds, (perTrialDa10(ii).stillness*8-10) );
%    scatter( perTrialDa10(ii).swrTimes, perTrialDa10(ii).swrSpeed, 'r*' );
%    plot( perTrialDa10(ii).xytimestampSeconds, perTrialDa10(ii).smoothSpeed );
%    plot( perTrialDa10(ii).xytimestampSeconds, (perTrialDa10(ii).instantStillness*8-20) );
    axis tight;
    ylim([ -20 180 ]);
    xlabel('time (s)');
    ylabel('speed (cm/s)');
    title(['trial ' num2str(ii) ])
    print( [ '~/data/da12_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end



print( '~/Desktop/swrplacepreference.png','-dpng','-r500');