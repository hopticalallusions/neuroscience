%% all of this code is terrible cut-n-paste spaghetti. don't judge.

clear all; close all;

%% DA5


load('/Users/andrewhowe/src/MATLAB/defaultFolder/aggda5_correctedTrialEndTimes.mat');

recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %

% figure; hold on;
% for ii=1:round(length(recDays))
%     hold on; plot( aggda5.(recDays{ii}).swrXpos, aggda5.(recDays{ii}).swrYpos );
% end
% for ii=1:round(length(recDays))
%     hold on; scatter( aggda5.(recDays{ii}).swrXpos, aggda5.(recDays{ii}).swrYpos );
% end

% figure; hold on;
% for ii=1:round(length(recDays))
%     hold on; plot( aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos );
% end
% for ii=1:round(length(recDays))
%     hold on; scatter( aggda5.(recDays{ii}).swrXpos, aggda5.(recDays{ii}).swrYpos );
% end


for ii=1:length(recDays)

    [angle, radius] = cart2pol( aggda5.(recDays{ii}).xpos-390, aggda5.(recDays{ii}).ypos-260 ); angle=angle*180/pi+180;
    rad=radius;
    aggda5.(recDays{ii}).xylinearized(find((rad <= 35))) =  130; % Center Point                                                                                     px / cm  + offset
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 )))/(288/106) + 225 + 3*20; % South
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 )))/(225/100) + 330 + 5*20; % East
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 )))/(255/106) + 125 + 1*20; % North  ; invert this so the rat starts at x=0
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 )))/(255/106)); % West
    aggda5.(recDays{ii}).radiusFromCenter=rad;    
    
    aggda5.(recDays{ii}).xyspeed=[ 0 calculateSpeed(aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos, 0.2, 2.75, 29.97 ) ];
    
    idxs = floor(aggda5.(recDays{ii}).swrTimes*29.97)+1; if max(idxs)>length(aggda5.(recDays{ii}).xylinearized); idxs(idxs==max(idxs))=length(aggda5.(recDays{ii}).xylinearized); end;
    idxs(idxs>length(aggda5.(recDays{ii}).xylinearized))=[];
    aggda5.(recDays{ii}).swrxylinearized = aggda5.(recDays{ii}).xylinearized(idxs);
    
    aggda5.(recDays{ii}).swrSpeed = aggda5.(recDays{ii}).xyspeed(idxs);
    
    aggda5.(recDays{ii}).instantSpeed = zeros(size(aggda5.(recDays{ii}).xpos));
    dx = zeros(size(aggda5.(recDays{ii}).xpos));
    dy = zeros(size(aggda5.(recDays{ii}).xpos));
    for jj=2:length(aggda5.(recDays{ii}).xpos)-1
    	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda5.(recDays{ii}).instantSpeed(jj) = sqrt( ( aggda5.(recDays{ii}).ypos(jj-1) - aggda5.(recDays{ii}).ypos(jj+1) ).^2 + ( aggda5.(recDays{ii}).xpos(jj-1) - aggda5.(recDays{ii}).xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
    end
    
    aggda5.(recDays{ii}).swrInstantSpeed = aggda5.(recDays{ii}).instantSpeed(idxs);
    
    aggda5.(recDays{ii}).lagSpeed = zeros(size(aggda5.(recDays{ii}).xpos));
    for jj=61:length(aggda5.(recDays{ii}).xpos)
   	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda5.(recDays{ii}).lagSpeed(jj) = sqrt( ( aggda5.(recDays{ii}).ypos(jj-60) - aggda5.(recDays{ii}).ypos(jj) ).^2 + ( aggda5.(recDays{ii}).xpos(jj-60) - aggda5.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
    end
    
    aggda5.(recDays{ii}).swrLagSpeed = aggda5.(recDays{ii}).lagSpeed(idxs);
end     

    

%% over days, how does sharp wave ripple production vary while the rat is on the maze?
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
        %startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).trialStartAction(jj) ) , 1 );
                % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).firstArmEndReached(jj) ) , 1 ); 
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;
        perTrial(trialIdx).xpos     = aggda5.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = aggda5.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = aggda5.(recDays{ii}).xyspeed(xyIdxs);
        perTrial(trialIdx).instantSpeed    = aggda5.(recDays{ii}).instantSpeed(xyIdxs);
        perTrial(trialIdx).lagSpeed    = aggda5.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = aggda5.(recDays{ii}).xylinearized(xyIdxs);  
        %
        perTrial(trialIdx).xytimestampSeconds = aggda5.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( aggda5.(recDays{ii}).swrTimes > aggda5.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( aggda5.(recDays{ii}).swrTimes < aggda5.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes         = aggda5.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos          = aggda5.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos          = aggda5.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized    = aggda5.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed         = aggda5.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = aggda5.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed  = aggda5.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial       = aggda5.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error            = aggda5.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds      = aggda5.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe            = aggda5.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline          = aggda5.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed    = aggda5.(recDays{ii}).sugarConsumed(jj);
        %perTrial(trialIdx).wasTeleported   = aggda5.(recDays{ii}).wasTeleported(jj);
        perTrial(trialIdx).explore          = aggda5.(recDays{ii}).explore(jj);
        perTrial(trialIdx).centerExplore    = aggda5.(recDays{ii}).centerExplore(jj);
    end
end


%% DA10

load('~/src/MATLAB/defaultFolder/aggDa10New.mat');

recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };

% figure; hold on;
% for ii=1:round(length(recDays))
%     hold on; plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos );
% end
% for ii=1:round(length(recDays))
%     hold on; scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos );
% end

for ii=1:length(recDays)

    [angle, radius] = cart2pol( agg.(recDays{ii}).xpos-395, agg.(recDays{ii}).ypos-403 ); angle=angle*180/pi+180;
    rad=radius;
    agg.(recDays{ii}).xylinearized=rad;
    % * each arm is 109 cm. Let's assume the rat sticks his head at most 6 cm
    % off the end of the start arm, so that is 115 cm.
    % * let's place the center point at 115, and anything within a 25 px
    % radius is just considered "center"
    % * to orient the start arm, subtract whatever the radius is in cm 
    % (custom to each rat) from 110
    % * on each subsequent 
    agg.(recDays{ii}).xylinearized(find((rad <= 35))) =  130; % Center Point
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 )))/(276/100) + 125 + 1*20; % South
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 )))/(269/100) + 330 + 5*20; % East
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 )))/(306/106) + 225 + 3*20; % North  ; invert this so the rat starts at x=0
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 )))/(335/106)) ; % West
    agg.(recDays{ii}).radiusFromCenter=rad;
    
    agg.(recDays{ii}).xyspeed=[ 0 calculateSpeed(agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 0.2, 2.75, 29.97 ) ];
    
    idxs = floor(agg.(recDays{ii}).swrTimes*29.97)+1; if max(idxs)>length(agg.(recDays{ii}).xylinearized); idxs(idxs==max(idxs))=length(agg.(recDays{ii}).xylinearized); end;
    agg.(recDays{ii}).swrxylinearized = agg.(recDays{ii}).xylinearized(idxs);
    
    agg.(recDays{ii}).swrSpeed = agg.(recDays{ii}).xyspeed(idxs);
    
    agg.(recDays{ii}).instantSpeed = zeros(size(agg.(recDays{ii}).xpos));
    dx = zeros(size(agg.(recDays{ii}).xpos));
    dy = zeros(size(agg.(recDays{ii}).xpos));
    for jj=2:length(agg.(recDays{ii}).xpos)-1
    	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        agg.(recDays{ii}).instantSpeed(jj) = sqrt( ( agg.(recDays{ii}).ypos(jj-1) - agg.(recDays{ii}).ypos(jj+1) ).^2 + ( agg.(recDays{ii}).xpos(jj-1) - agg.(recDays{ii}).xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
    end
    agg.(recDays{ii}).swrInstantSpeed = agg.(recDays{ii}).instantSpeed(idxs);
    agg.(recDays{ii}).lagSpeed = zeros(size(agg.(recDays{ii}).xpos));
    for jj=61:length(agg.(recDays{ii}).xpos)
   	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        agg.(recDays{ii}).lagSpeed(jj) = sqrt( ( agg.(recDays{ii}).ypos(jj-60) - agg.(recDays{ii}).ypos(jj) ).^2 + ( agg.(recDays{ii}).xpos(jj-60) - agg.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
    end
    agg.(recDays{ii}).swrLagSpeed = agg.(recDays{ii}).lagSpeed(idxs); 
end



rat='da10';
for ii=1:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat      = rat;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
%         if jj>1
%             %startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        %startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialStartAction(jj) ) , 1 );
        % leaveBucketToMaze trialStartAction trialCompleted leaveMazeToBucket
        %endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialCompleted(jj), 1 );
        endIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).firstEndArmReached(jj) ) , 1 );
        %
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;
        perTrial(trialIdx).xpos     = agg.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = agg.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = agg.(recDays{ii}).xyspeed(xyIdxs);
        perTrial(trialIdx).instantSpeed    = agg.(recDays{ii}).instantSpeed(xyIdxs);
        perTrial(trialIdx).lagSpeed    = agg.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = agg.(recDays{ii}).xylinearized(xyIdxs);  
        %
        perTrial(trialIdx).xytimestampSeconds = agg.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( agg.(recDays{ii}).swrTimes > agg.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( agg.(recDays{ii}).swrTimes < agg.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes      = agg.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos       = agg.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos       = agg.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized = agg.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed      = agg.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = agg.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed      = agg.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial    = agg.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error         = agg.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds   = agg.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe         = agg.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline       = agg.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed = agg.(recDays{ii}).sugarConsumed(jj);
        perTrial(trialIdx).wasTeleported = agg.(recDays{ii}).wasTeleported(jj);
        perTrial(trialIdx).explore       = agg.(recDays{ii}).explore(jj);
        perTrial(trialIdx).centerExplore = agg.(recDays{ii}).centerExplore(jj);
    end
end


%% DA 12

load('~/src/MATLAB/defaultFolder/aggDa12Env.mat');

recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  };

% figure; hold on;
% for ii=1:length(recDays)
%     hold on; plot( aggda12.(recDays{ii}).xpos, aggda12.(recDays{ii}).ypos );
%     hold on; scatter( aggda12.(recDays{ii}).swrXpos, aggda12.(recDays{ii}).swrYpos );
% end

for ii=1:length(recDays)

    [angle, radius] = cart2pol( aggda12.(recDays{ii}).xpos-310, aggda12.(recDays{ii}).ypos-533 ); angle=angle*180/pi+180;
    rad=radius;
    aggda12.(recDays{ii}).xylinearized(find((rad <= 35))) =  130; % Center Point                                                                                     px / cm  + offset
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 )))/(315/100) + 225 + 3*20; % South
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 )))/(300/100) + 330 + 5*20; % East
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 )))/(310/106) + 125 + 1*20; % North  ; invert this so the rat starts at x=0
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 )))/(275/106)) ; % West
    aggda12.(recDays{ii}).radiusFromCenter=rad;    
    
    aggda12.(recDays{ii}).xyspeed=[ 0 calculateSpeed(aggda12.(recDays{ii}).xpos, aggda12.(recDays{ii}).ypos, 0.2, 2.75, 29.97 ) ];
    
    idxs=[]; for jj=1:length(aggda12.(recDays{ii}).swrTimes); idxs=[ idxs find( (aggda12.(recDays{ii}).swrTimes(jj) < aggda12.(recDays{ii}).xytimestampSeconds) , 1 )]; end; 
    aggda12.(recDays{ii}).swrxylinearized = aggda12.(recDays{ii}).xylinearized(idxs);                            
    
    aggda12.(recDays{ii}).swrSpeed = aggda12.(recDays{ii}).xyspeed(idxs);
    
    aggda12.(recDays{ii}).instantSpeed = zeros(size(aggda12.(recDays{ii}).xpos));
    dx = zeros(size(aggda12.(recDays{ii}).xpos));
    dy = zeros(size(aggda12.(recDays{ii}).xpos));
    for jj=2:length(aggda12.(recDays{ii}).xpos)-1
    	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda12.(recDays{ii}).instantSpeed(jj) = sqrt( ( aggda12.(recDays{ii}).ypos(jj-1) - aggda12.(recDays{ii}).ypos(jj+1) ).^2 + ( aggda12.(recDays{ii}).xpos(jj-1) - aggda12.(recDays{ii}).xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
    end
    
%       dx = zeros(size(aggda12.(recDays{ii}).xpos(xyIdxs)));
%         dy = zeros(size(aggda12.(recDays{ii}).ypos(xyIdxs)));
%         tx =  aggda12.(recDays{ii}).xpos(xyIdxs);
%         ty =  aggda12.(recDays{ii}).ypos(xyIdxs);
%         for kk=2:length(aggda12.(recDays{ii}).xpos(xyIdxs))-1
%             dy(kk)=( ty(kk-1) - ty(kk+1) );
%             dx(kk)=( tx(kk-1) - tx(kk+1) );
%         end
%         boxcarSize = 45;
%         dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
%         dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
%         aggda12.(recDays{ii}).smoothSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;

    
    aggda12.(recDays{ii}).swrInstantSpeed = aggda12.(recDays{ii}).instantSpeed(idxs);
    
    aggda12.(recDays{ii}).lagSpeed = zeros(size(aggda12.(recDays{ii}).xpos));
    for jj=61:length(aggda12.(recDays{ii}).xpos)
   	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda12.(recDays{ii}).lagSpeed(jj) = sqrt( ( aggda12.(recDays{ii}).ypos(jj-60) - aggda12.(recDays{ii}).ypos(jj) ).^2 + ( aggda12.(recDays{ii}).xpos(jj-60) - aggda12.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
    end
    
    aggda12.(recDays{ii}).swrLagSpeed = aggda12.(recDays{ii}).lagSpeed(idxs);
    
end



rat='da12';
for ii=1:length(recDays)
    for jj=1:length(aggda12.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat=rat;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = aggda12.(recDays{ii}).trial(jj);
%         if jj>1
%             startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        %startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).trialStartAction(jj) ) , 1 );
        % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).firstEndArmReached(jj) ) , 1 );
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;
        perTrial(trialIdx).xpos     = aggda12.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = aggda12.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = aggda12.(recDays{ii}).xyspeed(xyIdxs);
        perTrial(trialIdx).instantSpeed    = aggda12.(recDays{ii}).instantSpeed(xyIdxs);
        perTrial(trialIdx).lagSpeed    = aggda12.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = aggda12.(recDays{ii}).xylinearized(xyIdxs);  
        %
        perTrial(trialIdx).xytimestampSeconds = aggda12.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( aggda12.(recDays{ii}).swrTimes > aggda12.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( aggda12.(recDays{ii}).swrTimes < aggda12.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes         = aggda12.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos          = aggda12.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos          = aggda12.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized    = aggda12.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed         = aggda12.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = aggda12.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed  = aggda12.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial       = 0;% aggda12.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error            = aggda12.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds      = aggda12.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe            = aggda12.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline          = 0; % aggda12.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed    = aggda12.(recDays{ii}).sugarConsumed(jj);
        perTrial(trialIdx).explore          = aggda12.(recDays{ii}).explore(jj);
        %perTrial(trialIdx).wasTeleported   = aggda12.(recDays{ii}).wasTeleported(jj);
        perTrial(trialIdx).centerExplore    = aggda12.(recDays{ii}).centerExplore(jj);
    end
end





% 600 px / 218 cm  => 2.75
binSize = 20; %cm    % 55 px
%bins = [ -100 6 26 46 66 86 111 129 131 149 170 190 210 230 240 255 270 290 310 330 350 360 375 385 398 420 440 460 480 500 520 1000 ];
%bins = [ -100 -15            115 129 131 155                  289    292                         410 430                 560 580 1000 ];
bins = [ -100 -15 20 40 60 80 100 115 129 131 155 175 195 215 235 255 275 289    292  312 332 352 372 392  410 430  450 470 490 510 530 550   560 580 1000 ];
binCenters = (bins(1:end-1))+diff(bins)/2;
occupancyAll=[];
swrAll=[];
swrRateAll=[];
bee=[]; err=[]; oob=[];
trialSwr=[];
trialOcc=[];
avgVel = [];
probe = [];
explore = [];
centerExplore = [];
rat=[];
for ii=1:length(perTrial)
    freqOcc=histcounts( perTrial(ii).xylinearized, bins );
    freqOcc = freqOcc/29.97; % convert occupany to seconds, instead of accumulated pixels
    occupancyAll = [ occupancyAll ; freqOcc ];
    freqSwr=histcounts( perTrial(ii).swrLinearized, bins );
    swrAll = [ swrAll ; freqSwr ];
    tIdxs = find(freqOcc);
    tResult = freqSwr(tIdxs)./freqOcc(tIdxs);
    freqSwr(tIdxs) = tResult;
    swrRateAll = [ swrRateAll ; freqSwr ];
    bee = [ bee perTrial(ii).beeline ];
    oob = [ oob perTrial(ii).outOfBounds ];
    err = [ err perTrial(ii).error ];
    probe = [ probe perTrial(ii).probe ];
    trialSwr = [ trialSwr sum(freqSwr) ];
    trialOcc = [ trialOcc sum(freqOcc) ];
    avgVel= [ avgVel median(perTrial(ii).speed) / (length(perTrial(ii).speed)./29.97)];
    rat = [ rat str2num(strrep( perTrial(ii).rat, 'da','')) ];
    explore = [ explore perTrial(ii).explore ];
    centerExplore = [ centerExplore perTrial(ii).centerExplore];
end

%pxPerCm=2.535;
figure; % colormap(build_NOAA_colorgradient);%  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);  colormap(newColorMap);
subplot(7,4,1:4:6*4); %imagesc(occupancyAll); 
hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.01);
end; set(gca, 'Ydir', 'reverse'); axis tight; xlim([0 580]);
%title('occupancy')
subplot(7,4,2:4:6*4); %imagesc(swrAll);  
hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
end; set(gca, 'Ydir', 'reverse'); axis tight; xlim([0 580]);
%title('swr freq. X space')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); colormap([ 1 1 1; colormap('jet')]); caxis([0 5]); %title('swr Rate'); 
subplot(7,4,25);
    hold off;
    plot(binCenters,mean(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
     hold on; 
    plot(binCenters,mean(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b'); 
    axis tight; xlim([0 580]);
subplot(7,4,26); 
    hold off; 
    plot(binCenters,mean(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
    hold on;
    plot(binCenters,mean(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b'); 
    axis tight; xlim([0 580]);
subplot(7,4,27); 
    hold off; 
    plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
    hold on;
    plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b'); 
    axis tight; 
    xlim([-30 580]);
subplot(7,4,4:4:6*4); hold off;
xx=trialSwr./trialOcc; %mean(swrRateAll,2); 
yy=1:length(perTrial); plot(xx,yy); axis tight; set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ); scatter( xx(oob>0),yy(oob>0), 'o' ); scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
%title('SWR Rate')

print( '~/Desktop/swrplacepreference.png','-dpng','-r600');


[ 'n_trials = ' num2str(length(perTrial)) ' ; n_correct = ' num2str(sum((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0))) ' ; n_error = '  num2str(sum((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0))) ' ; n_outOfBounds = ' num2str(sum((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1))) ]







figure;
subplot(4,1,1); hold on; ylabel('da5');  
    plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
    plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(oob==1)),:)),'b');  %axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:))+std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+');
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:))-std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+');
    axis tight; xlim([0 580]);
subplot(4,1,2); hold on; ylabel('da10');
    plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
    plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(oob==0)),:)),'b'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    axis tight; xlim([0 580]); 
subplot(4,1,3); hold on; ylabel('da12'); 
    plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
    plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(oob==0)),:)),'b'); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
   % scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
   % scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
   axis tight; xlim([0 580]); 
subplot(4,1,4); hold on; ylabel('all');  
    plot(binCenters,median(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
    plot(binCenters,median(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
    %plot(binCenters,mean(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(oob==0)),:)),'b');            axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+');
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
    axis tight; xlim([0 500]); 
    %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');


 
 
    
    
    
figure;
subplot(4,1,1); hold on; ylabel('da5');  
    plot(binCenters, median(swrRateAll ( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
    
    plot(binCenters, median (swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
    
   axis tight; xlim([0 580]);
subplot(4,1,2); hold on; ylabel('da10');
    plot(binCenters, median(swrRateAll ( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
   
    plot(binCenters, median (swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
     axis tight; xlim([0 580]); 
subplot(4,1,3); hold on; ylabel('da12'); 
    plot(binCenters, median(swrRateAll ( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
    
    plot(binCenters, median (swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
    axis tight; xlim([0 580]); 
subplot(4,1,4); hold on; ylabel('all');  
    plot(binCenters, median(swrRateAll ( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
    
    plot(binCenters, median (swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
    plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
     axis tight; xlim([0 500]); 
 
    
    
   
     
     
     
     
     

     

% figure; hold on; 
% for ii=202:279; plot(perTrial(ii).xpos,perTrial(ii).ypos,'k'); end
% for ii=202:279;   
%     if( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 0); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'g');     
%     elseif (( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 1)); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'r'); 
%     end; 
% end; legend('da12')
% 	
% 
% 
% figure; hold on; 
% for ii=124:201; plot(perTrial(ii).xpos,perTrial(ii).ypos,'k'); end
% for ii=124:201;   
%     if( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 0); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'g');     
%     elseif (( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 1)); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'r'); 
%     end; 
% end; legend('da10')
% 
% 
% 
% figure; hold on; 
% for ii=1:123; plot(perTrial(ii).xpos,perTrial(ii).ypos,'k'); end
% for ii=1:123;   
%     if( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 0); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'g');     
%     elseif (( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 1)); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'r'); 
%     end; 
% end; legend('da5')
% 
% 
% 
% for ii=124:201;
%     % reward arm
%     [angle,radius] = cart2pol( perTrial(ii).xpos-373, perTrial(ii).ypos-120 );
%     minRewardTime  = perTrial(ii).xytimestampSeconds(find(radius<50,1));
%     % wrong arm
%     [angle,radius] = cart2pol( perTrial(ii).xpos-403, perTrial(ii).ypos-728 );
%     minWrongTime   = perTrial(ii).xytimestampSeconds(find(radius<50,1));
%     % wrong arm
%     [angle,radius] = cart2pol( perTrial(ii).xpos-680, perTrial(ii).ypos-400 );
%     minOobTime     = perTrial(ii).xytimestampSeconds(find(radius<50,1));
%     disp([ num2str(perTrial(ii).day) ' ' num2str(perTrial(ii).trial) ' : '  num2str(ceil(min( [ minRewardTime minWrongTime minOobTime ] )))]);
% end
% 
% 
% 
% 
% for ii=202:279;
%     % reward arm
%     [angle,radius] = cart2pol( perTrial(ii).xpos-334, perTrial(ii).ypos-804 );
%     minRewardTime  = perTrial(ii).xytimestampSeconds(find(radius<50,1));
%     % wrong arm
%     [angle,radius] = cart2pol( perTrial(ii).xpos-243, perTrial(ii).ypos-199 );
%     minWrongTime   = perTrial(ii).xytimestampSeconds(find(radius<50,1));
%     % wrong arm
%     [angle,radius] = cart2pol( perTrial(ii).xpos-669, perTrial(ii).ypos-527 );
%     minOobTime     = perTrial(ii).xytimestampSeconds(find(radius<50,1));
%     disp([ num2str(perTrial(ii).day) ' ' num2str(perTrial(ii).trial) ' : '  num2str(ceil(min( [ minRewardTime minWrongTime minOobTime ] )))]);
% end

% 
%     
%     if( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 0); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'g');     
%     elseif (( perTrial(ii).explore == 0 && perTrial(ii).probe == 0 && perTrial(ii).error == 1)); 
%         plot(perTrial(ii).xpos,perTrial(ii).ypos,'r'); 
%     end; 
% end; 
% 
% ii=6; plot(perTrial(ii).xpos,perTrial(ii).ypos); axis square; axis([0 850 0 850]); title([num2str(ii) '      ' num2str(perTrial(ii).xytimestampSeconds(end)-perTrial(ii).xytimestampSeconds(1)) ' s' ]);