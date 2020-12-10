plot( perTrial(ii).xytimestampSeconds, perTrial(ii).lagSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).lagStillness*8-20) );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-30) );
axis tight;
ylim([ -30 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
recDays = {  'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
%perTrial(trialIdx).instantSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).instantSpeed(xyIdxs);
dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
boxcarSize = 16;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
perTrial(trialIdx).instantSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
end
end
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
end
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
recDays = {  'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
%perTrial(trialIdx).instantSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).instantSpeed(xyIdxs);
dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
for kk=11:length(aggda5.(recDays{ii}).xpos(xyIdxs))-10
dy(kk)=( ty(kk-10) - ty(kk+10) );
dx(kk)=( tx(kk-10) - tx(kk+10) );
end
boxcarSize = 16;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
perTrial(trialIdx).instantSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
end
end
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
end
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
recDays = {  'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
%perTrial(trialIdx).instantSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).instantSpeed(xyIdxs);
dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
for kk=1:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
boxcarSize = 4;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
perTrial(trialIdx).instantSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
end
end
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
end
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
recDays = {  'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
%perTrial(trialIdx).instantSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).instantSpeed(xyIdxs);
dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
boxcarSize = 4;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
perTrial(trialIdx).instantSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
end
end
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
end
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
recDays = {  'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
%perTrial(trialIdx).instantSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).instantSpeed(xyIdxs);
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
perTrial(trialIdx).instantSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
end
end
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
end
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
% everything is in trials, so we know we are ignoring bucket and rest
% periods
goodEpisodesFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
%     stillness = zeros(size(perTrial(ii).speed));
%     % built a moving boxcar that handles edge cases
%     if length(perTrial(ii).speed)>46
%         for jj=1:45
%             if median(perTrial(ii).speed(1:jj)) < 6
%                 stillness(jj) = 1;
%             end
%         end
%         for jj=46:length(perTrial(ii).speed)-46
%             if median(perTrial(ii).speed(jj-45:jj+45)) < 6
%                 stillness(jj) = 1;
%             end
%         end
%         for jj=length(perTrial(ii).speed)-46:length(perTrial(ii).speed)
%             if median(perTrial(ii).speed(jj:end)) < 6
%                 stillness(jj) = 1;
%             end
%         end
%     else
%         disp('skipped a short trial');
%     end
%     perTrial(ii).stillness = stillness;
% now find 3+s periods
startIdx = 1; % when did the period start
endIdx = 1;   % when did the period end
inAnEpisode = 0; % are we currently tracking an episode of stillness
endIdxList = []; % list of >3s stillness period *ends*
stillness = perTrial(ii).instantStillness;
for jj = 1:length(stillness)
if ( inAnEpisode == 0 ) && ( stillness(jj) == 1 )
inAnEpisode = 1;
startIdx = jj;
elseif ( inAnEpisode == 1 ) && ( stillness(jj) == 0 )
inAnEpisode = 0;
endIdx = jj-1;
if (endIdx-startIdx) > 89
endIdxList = [ endIdxList endIdx ];
end
end
end
% track how many
goodEpisodesFound(ii) = length(endIdxList);
perTrial(ii).endIdxList = endIdxList;
end
recDays = {  'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
%perTrial(trialIdx).instantSpeed    =  calculateSpeed( aggda5.(recDays{ii}).xpos(xyIdxs), aggda5.(recDays{ii}).ypos(xyIdxs), .5, 2.7, 29.97 );    % aggda5.(recDays{ii}).instantSpeed(xyIdxs);
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
perTrial(trialIdx).instantSpeed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
perTrial(trialIdx).swrInstantSpeed  = aggda5.(recDays{ii}).swrInstantSpeed(swrIdxs);
%perTrial(trialIdx).isSubTrial       = aggda5.(recDays{ii}).isSubTrial(jj);
perTrial(trialIdx).error            = aggda5.(recDays{ii}).error(jj);
%perTrial(trialIdx).outOfBounds      = aggda5.(recDays{ii}).outOfBounds(jj);
perTrial(trialIdx).probe            = aggda5.(recDays{ii}).probe(jj);
perTrial(trialIdx).beeline          = aggda5.(recDays{ii}).beeline(jj);
perTrial(trialIdx).sugarConsumed    = aggda5.(recDays{ii}).sugarConsumed(jj);
%perTrial(trialIdx).wasTeleported   = aggda5.(recDays{ii}).wasTeleported(jj);
%perTrial(trialIdx).explore          = aggda5.(recDays{ii}).explore(jj);
%perTrial(trialIdx).centerExplore    = aggda5.(recDays{ii}).centerExplore(jj);
%
%tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
%perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
%tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
%perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
end
end
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
end
end
% everything is in trials, so we know we are ignoring bucket and rest
% periods
goodEpisodesFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
%     stillness = zeros(size(perTrial(ii).speed));
%     % built a moving boxcar that handles edge cases
%     if length(perTrial(ii).speed)>46
%         for jj=1:45
%             if median(perTrial(ii).speed(1:jj)) < 6
%                 stillness(jj) = 1;
%             end
%         end
%         for jj=46:length(perTrial(ii).speed)-46
%             if median(perTrial(ii).speed(jj-45:jj+45)) < 6
%                 stillness(jj) = 1;
%             end
%         end
%         for jj=length(perTrial(ii).speed)-46:length(perTrial(ii).speed)
%             if median(perTrial(ii).speed(jj:end)) < 6
%                 stillness(jj) = 1;
%             end
%         end
%     else
%         disp('skipped a short trial');
%     end
%     perTrial(ii).stillness = stillness;
% now find 3+s periods
startIdx = 1; % when did the period start
endIdx = 1;   % when did the period end
inAnEpisode = 0; % are we currently tracking an episode of stillness
startIdxList = []; % list of >3s stillness period *ends*
endIdxList = []; % list of >3s stillness period *ends*
stillness = perTrial(ii).instantStillness;
for jj = 1:length(stillness)
if ( inAnEpisode == 0 ) && ( stillness(jj) == 1 )
inAnEpisode = 1;
startIdx = jj;
elseif ( inAnEpisode == 1 ) && ( stillness(jj) == 0 )
inAnEpisode = 0;
endIdx = jj-1;
if (endIdx-startIdx) > 89
endIdxList = [ endIdxList endIdx ];
startIdxList = [ startIdxList startIdx ];
end
end
end
% track how many
goodEpisodesFound(ii) = length(endIdxList);
perTrial(ii).startIdxList = startIdxList;
perTrial(ii).endIdxList = endIdxList;
end
for thisTrial = 1:length(perTrial)
for thisEp = 1:length(perTrial(thisTrial).startIdxList)-1
if thisEp = 1
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
end
preDuration  = ( perTrial(thisTrial).endIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp+1) ) / 29.97;
if thisEp = length(perTrial(thisTrial).startIdxList)
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(end) ) / 29.97;
end
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
for thisTrial = 1:length(perTrial)
for thisEp = 1:length(perTrial(thisTrial).startIdxList)-1
if thisEp == 1
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
end
preDuration  = ( perTrial(thisTrial).endIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp+1) ) / 29.97;
if thisEp == length(perTrial(thisTrial).startIdxList)
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(end) ) / 29.97;
end
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
thisEp
thisTrial
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97
preDuration  = ( perTrial(thisTrial).endIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97
for thisTrial = 1:length(perTrial)
for thisEp = 1:length(perTrial(thisTrial).startIdxList)-1
if thisEp == 1
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
elseif thisEp == length(perTrial(thisTrial).startIdxList)
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(end) ) / 29.97;
else
preDuration  = ( perTrial(thisTrial).endIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp+1) ) / 29.97;
end
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
for thisTrial = 1:length(perTrial)
if length(perTrial(thisTrial).startIdxList) == 1
preDuration  = ( perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
preDuration  = ( perTrial(thisTrial).startIdxList(1) - perTrial(thisTrial).endIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(1)   - length(perTrial(thisTrial).xpos) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
for thisTrial = 1:length(perTrial)
if length(perTrial(thisTrial).startIdxList) == 1
preDuration  = ( perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
preDuration  = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(1)   - length(perTrial(thisTrial).xpos) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
for thisTrial = 1:length(perTrial)
if length(perTrial(thisTrial).startIdxList) == 1
preDuration  = ( perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
preDuration  = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( length(perTrial(thisTrial).xpos)  - perTrial(thisTrial).endIdxList(1) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
for thisTrial = 1:length(perTrial)
if length(perTrial(thisTrial).startIdxList) == 1
preDuration  = ( perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
preDuration  = ( perTrial(thisTrial).endIdxList(1) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( length(perTrial(thisTrial).xpos)  - perTrial(thisTrial).endIdxList(1) ) / 29.97;
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
else
for thisEp = 1:length(perTrial(thisTrial).startIdxList)-1
if thisEp == 1
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp) ) / 29.97;
elseif thisEp == length(perTrial(thisTrial).startIdxList)
preDuration  = ( perTrial(thisTrial).startIdxList(thisEp) - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( length(perTrial(thisTrial).xpos) - perTrial(thisTrial).endIdxList(thisEp) ) / 29.97;
else
preDuration  = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp-1) ) / 29.97;
postDuration = ( perTrial(thisTrial).endIdxList(thisEp)   - perTrial(thisTrial).startIdxList(thisEp+1) ) / 29.97;
end
disp( [ 'trial ' num2str(thisTrial) ' : episode ' num2str(thisEp) ' : pre ' num2str(preDuration) ' : post ' num2str(postDuration) ] );
end
end
end
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
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
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
%
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
oob(currentEpisode)= perTrial(currentTrial).outOfBounds;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*perTrial(currentTrial).outOfBounds + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
oob=oob(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
proxToReward=proxToReward(:, 1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
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
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
%
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*perTrial(currentTrial).outOfBounds + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
proxToReward=proxToReward(:, 1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
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
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
%
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
proxToReward=proxToReward(:, 1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
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
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
%
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
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
speedPre=speedDistPre';
diffDist=diff(speedDist,1,1);
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
figure; imagesc(speedDist)
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
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
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
%
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
figure; imagesc(instantSpeedDist)
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
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
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
%
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
%
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
figure; imagesc(instantSpeedDist)
figure; imagesc(instantSpeedDist')
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
figure; imagesc(instantSpeedDist)
size(mean(instantSpeedDist))
size(mean(instantSpeedDist,2))
[B,I]=sort(mean(instantSpeedDist,2));
figure; imagesc(speedDist(:,I))
figure; imagesc(instantSpeedDist(:,I))
figure; imagesc(speedDist(I,:))
figure; imagesc(instantSpeedDist(I,:))
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
if ( perTrial(currentTrial).startIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
motionStillSpeed(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
motionSwrEvents( tempIdxs, currentEpisode ) = 1;
else
disp('skipping because exceeds START of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
if ( perTrial(currentTrial).startIdxList(stillEpisode)-90 < 1 ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
motionStillSpeed(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
motionSwrEvents( tempIdxs, currentEpisode ) = 1;
else
disp('skipping because exceeds START of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
if ( perTrial(currentTrial).startIdxList(stillEpisode)-90 < 1 ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
disp('2nd loop start')
motionStillSpeed(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
disp('2nd after speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
motionSwrEvents( tempIdxs, currentEpisode ) = 1;
else
disp('skipping because exceeds START of trial')
end
end
end
perTrial(currentTrial).startIdxList(stillEpisode)-90
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
if ( perTrial(currentTrial).startIdxList(stillEpisode)-90 > 1 ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('2nd loop start')
motionStillSpeed(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
%disp('2nd after speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
motionSwrEvents( tempIdxs, currentEpisode ) = 1;
else
disp('skipping because exceeds START of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
if ( perTrial(currentTrial).startIdxList(stillEpisode)-90 > 1 ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('2nd loop start')
motionStillSpeed(:,motionCurrentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
%disp('2nd after speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
motionSwrEvents( tempIdxs, motionCurrentEpisode ) = 1;
%
motionCurrentEpisode=motionCurrentEpisode+1;
else
disp('skipping because exceeds START of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
motionStillSpeed=motionStillSpeed( : , 1:currentEpisode-1 )';
motionSwrEvents=motionSwrEvents(:, 1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89)';
%disp('after lfps');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
%
%disp('after swrEvents')
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
endTime = startTime+3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEventsPost( tempIdxs, currentEpisode ) = 1;
%disp('after swrEventsPost')
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
if ( perTrial(currentTrial).startIdxList(stillEpisode)-90 > 1 ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
%disp('2nd loop start')
motionStillSpeed(:,motionCurrentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).startIdxList(stillEpisode)-90:perTrial(currentTrial).startIdxList(stillEpisode)+89)';
%disp('2nd after speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3;
startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3;
swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % this is crappy. but it will work; (reason is that the span from above will be 181 timepoints; could cause 33ms misalignment?
motionSwrEvents( tempIdxs, motionCurrentEpisode ) = 1;
%
motionCurrentEpisode=motionCurrentEpisode+1;
else
disp('skipping because exceeds START of trial')
end
end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
motionStillSpeed=motionStillSpeed( : , 1:motionCurrentEpisode-1 )';
motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1);
[B,I]=sort(mean(instantSpeedDist,2));
figure; imagesc(speedDist(I,:))
figure; imagesc(instantSpeedDist(I,:)
[B,I]=sort(mean(instantSpeedDist,2));
figure; imagesc(speedDist(I,:))
figure; imagesc(instantSpeedDist(I,:))
[B,I]=sort(mean(motionStillSpeed,2));
figure; imagesc(motionStillSpeed(I,:))
size([swrEvents;swrEventsPost])
[B,I]=sort(mean(instantSpeedDist,2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=[swrEvents;swrEventsPost];
stillMotionSwrEvents=stillMotionSwrEvents(I,:);
[B,I]=sort(mean(motionStillSpeed,2));
motionStillSpeed=motionStillSpeed(I,:);
motionSwrEvents=motionSwrEvents(I,:);
[B,I]=sort(mean(instantSpeedDist,2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=[swrEvents;swrEventsPost];
[B,I]=sort(mean(instantSpeedDist,2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=[swrEvents;swrEventsPost]';
stillMotionSwrEvents=stillMotionSwrEvents(I,:);
[B,I]=sort(mean(motionStillSpeed,2));
motionStillSpeed=motionStillSpeed(I,:);
motionSwrEvents=motionSwrEvents(I,:);
motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1)';
motionSwrEvents=motionSwrEvents(I,:);
figure; imagesc(instantSpeedDist(I,:))
figure; imagesc(motionStillSpeed(I,:))
figure; imagesc(stillMotionSmootherSpeeds)
figure; imagesc(motionStillSpeed)
colormap;
colormap
colorbar
size(sum(stillMotionSwrEvents(1:280,1:90)))
size(sum(stillMotionSwrEvents(1:280,1:90),2))
sum(sum(stillMotionSwrEvents(1:280,1:90),2)>0)/280
sum(sum(stillMotionSwrEvents(281:390,1:90),2)>0)/110
sum(sum(stillMotionSwrEvents(1:280,91:180),2)>0)/280
sum(sum(stillMotionSwrEvents(281:390,91:180),2)>0)/110
figure; spy(stillMotionSwrEvents)
hold on; spy(stillMotionSwrEvents)
figure; hold on; spy(motionSwrEvents)
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).endIdxList(jj)-3 perTrial(ii).endIdxList+3  ],[ 0.5 0.5 ])
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
axis tight;
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))-3 perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode))+3  ],[ 0.5 0.5 ])
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(jj))-3 perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(jj))+3  ],[ 0.5 0.5 ])
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ 0.5 0.5 ])
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed*5-14 );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-14) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=15 %1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-14) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -1, 'xk' )
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-14) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -1, 'xk' )
end
for jj=1:length(perTrial(ii).startIdxList)
if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1) )
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -1 -1 ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -1, 'xk' )
end
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-14) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -1, 'xk' )
end
for jj=1:length(perTrial(ii).startIdxList)
if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -1 -1 ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -1, 'xk' )
end
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-14) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -1, 'xk' )
end
for jj=1:length(perTrial(ii).startIdxList)
if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -1 -1 ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -1, 'xk' )
end
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
drawnow;
pause(.1);
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-14) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-20) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -1 -1 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -1, 'xk' )
end
for jj=1:length(perTrial(ii).startIdxList)
if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -2 -2 ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -2, 'xk' )
end
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
drawnow;
pause(.2);
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -3 -3 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -3, 'xk' )
end
for jj=1:length(perTrial(ii).startIdxList)
if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -6 -6 ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -6, 'xk' )
end
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
%print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
drawnow;
pause(.2);
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
for jj=1:length(perTrial(ii).endIdxList)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj))+3  ],[ -2 -2 ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).endIdxList(jj)), -2, 'xk' )
end
for jj=1:length(perTrial(ii).startIdxList)
if (perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3) >= perTrial(ii).xytimestampSeconds(1)
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj))+3  ],[ -4 -4 ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).startIdxList(jj)), -4, 'xk' )
end
end
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
figure; imagesc(motionStillSpeed); colormap;
figure; hold on; spy(motionSwrEvents)
figure; plot(stillness)
figure; plot(diff(stillness))
figure; plot(stillness); hold on; plot(diff(stillness))
ylim([-2 2])
transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
% now find 3+s periods
movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
% track how many
transitionsFound(ii) = length(endIdxList);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
length(perTrial(currentTrial).speed(end-180:end))
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
% start of trial
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp('speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
% end of trial
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
%
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
%motionStillSpeed=motionStillSpeed( : , 1:motionCurrentEpisode-1 )';
%motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1)';
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
% start of trial
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp('speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
% end of trial
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
%proxToReward=proxToReward(:, 1:currentEpisode-1);
%motionStillSpeed=motionStillSpeed( : , 1:motionCurrentEpisode-1 )';
%motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1)';
[B,I]=sort(mean(instantSpeedDist(:,1:90),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=[swrEvents;swrEventsPost]';
stillMotionSwrEvents=stillMotionSwrEvents(I,:);
[B,I]=sort(mean(instantSpeedDist(:,1:90),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
swrEvents=swrEvents( : , 1:currentEpisode-1 )';
[B,I]=sort(mean(instantSpeedDist(:,1:90),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
[B,I]=sort(mean(instantSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).endIdxList)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure;
for ii=1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
subplot(1,2,1);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
subplot(1,2,2);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
%figure;
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
figure(1);
subplot(1,3,1:2);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
subplot(1,2,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
%figure;
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colorbar;
subplot(1,3,1:2);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
subplot(1,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
%figure;
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colorbar;
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colorbar;
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).instantSpeed(:), perTrial(ii).instantSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colorbar;
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -4+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','red');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).instantSpeed(:), perTrial(ii).instantSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed')
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).instantSpeed(:), perTrial(ii).instantSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed')
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).instantSpeed(:), perTrial(ii).instantSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
saturdayData.swrEvents=swrEvents;
saturdayData.speedDist=stillMotionSmootherSpeeds;
saturdayData.err=err;
saturdayData.prb=prb;
saturdayData.ratNum=5;
saturdayData.day=day;
saturdayData.trial=trial;
saturdayData.xpos=xpos;
saturdayData.ypos=ypos;
for ii=1:length(perTrial)
perTrial(ii).instantStillness = perTrial(ii).instantSpeed < 7;
perTrial(ii).lagStillness = perTrial(ii).lagSpeed < 7;
perTrial(ii).stillness = perTrial(ii).speed < 7;
% median smoothing
smoothFactor = 15;
for jj = (smoothFactor+1):length(perTrial(ii).speed)-(smoothFactor+1)
perTrial(ii).stillness(jj) = median(perTrial(ii).stillness(jj-smoothFactor:jj+smoothFactor));
perTrial(ii).instantStillness(jj) = median(perTrial(ii).instantStillness(jj-smoothFactor:jj+smoothFactor));
end
end
transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
% now find 3+s periods
movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
% track how many
transitionsFound(ii) = length(endIdxList);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
% start of trial
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
%disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp('speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
swrEvents( tempIdxs, currentEpisode ) = 1;
%
% where is the rat
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
% end of trial
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 )';
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
disp('for loop')
for stillEpisode = 1:goodEpisodesFound(currentTrial)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
disp('loop start')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
disp('speeds');
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
swrEvents( tempIdxs, currentEpisode ) = 1;
%
disp( ' where is the rat ' )
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
disp( 'end of trial' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
end
xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
swrEvents( tempIdxs, currentEpisode ) = 1;
%
disp( 'where is the rat' )
xpos( :, currentEpisode ) = perTrial(currentTrial).xpos( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ypos( :, currentEpisode ) = perTrial(currentTrial).ypos( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
%
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
%
% report how much time remains until the trial ends
% this will measure from the end of the stillness/start of the motion
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
%
err(currentEpisode)= perTrial(currentTrial).error;
prb(currentEpisode)= perTrial(currentTrial).probe;
code(currentEpisode)= perTrial(currentTrial).error + 2*0 + 4*perTrial(currentTrial).probe;
%
currentEpisode = currentEpisode + 1;
else
disp('skipping because exceeds end of trial')
end
end
disp( 'end of trial' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
end
xpos( :, currentEpisode ) = perTrial(currentTrial).xpos( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ypos( :, currentEpisode ) = perTrial(currentTrial).ypos( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
day(currentEpisode)    = perTrial(currentTrial).day;
trial(currentEpisode)  = perTrial(currentTrial).trial;
timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
tempIdxs = tempIdxs(tempIdxs<181); % crappy solution.
swrEvents( tempIdxs, currentEpisode ) = 1;
%
disp( 'where is the rat' )
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
else
disp('skipping because exceeds end of trial')
end
end
disp( 'end of trial' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
%
end
swrEvents=swrEvents( : , 1:currentEpisode-1 )';
speedDist=speedDist( : , 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
swrEvents=swrEvents( : , 1:currentEpisode-1 )';
swrEvents=swrEvents(  1:currentEpisode-1, : )';
speedDist=speedDist( : , 1:currentEpisode-1 )';
speedDist=speedDist(  1:currentEpisode-1, : )';
instantSpeedDist=instantSpeedDist(  1:currentEpisode-1, : )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
err=err(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
trial=trial(1:currentEpisode-1);
currentEpisode
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
%disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
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
%disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
%disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
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
else
disp('skipping because exceeds end of trial')
end
end
%disp( 'end of trial' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
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
swrEvents=swrEvents(  1:currentEpisode-1, : )';
speedDist=speedDist(  1:currentEpisode-1, : )';
instantSpeedDist=instantSpeedDist(  1:currentEpisode-1, : )';
xpos=xpos( 1:currentEpisode-1, : );
ypos=ypos( 1:currentEpisode-1, : );
%
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
xpos=xpos( 1:currentEpisode-1, : );
err=err(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
xpos=xpos( :, 1:currentEpisode-1 )';
ypos=ypos( :, 1:currentEpisode-1 )';
swrEvents=swrEvents( :, 1:currentEpisode-1 )';
speedDist=speedDist( :, 1:currentEpisode-1 )';
instantSpeedDist=instantSpeedDist(  :, 1:currentEpisode-1 )';
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).instantSpeed(:), perTrial(ii).instantSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
[B,I]=sort(mean(instantSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=mean(instantSpeedDist(:,91:180)/mean(instantSpeedDist(:,1:90);
aa=mean(instantSpeedDist(:,91:180)./mean(instantSpeedDist(:,1:90));
aa=mean(instantSpeedDist(:,91:180),2)./mean(instantSpeedDist(:,1:90),2);
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
saturdayData.swrEvents=swrEvents;
saturdayData.speedDist=instantSpeedDist;
saturdayData.err=err;
saturdayData.prb=prb;
saturdayData.ratNum=5;
saturdayData.day=day;
saturdayData.trial=trial;
saturdayData.xpos=xpos;
saturdayData.ypos=ypos;
transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
% now find 3+s periods
%    movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
movementTransitionIdx=find(abs(diff(perTrial(ii).stillness)));
% track how many
transitionsFound(ii) = length(endIdxList);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
%% pull together the data
swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
instantSpeedDist=zeros( 180 , sum(goodEpisodesFound));
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
for currentTrial = 1:length(perTrial)
%disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
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
%disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90 > 0)
%disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
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
else
disp('skipping because exceeds end of trial')
end
end
%disp( 'end of trial' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(end-179:end);
instantSpeedDist(:,currentEpisode) = perTrial(currentTrial).instantSpeed(end-179:end)';
endTime = perTrial(currentTrial).xytimestampSeconds(end);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
currentEpisode = currentEpisode + 1;
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
instantSpeedDist=instantSpeedDist(  :, 1:currentEpisode-1 )';
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
aa=mean(instantSpeedDist(:,91:180),2)./mean(instantSpeedDist(:,1:90),2);
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=instantSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
saturdayData.swrEvents=swrEvents;
saturdayData.speedDist=instantSpeedDist;
saturdayData.err=err;
saturdayData.prb=prb;
saturdayData.ratNum=5;
saturdayData.day=day;
saturdayData.trial=trial;
saturdayData.xpos=xpos;
saturdayData.ypos=ypos;
figure;
for ii= 31 % 1:length(perTrial)
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*8-10) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).instantSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*8-20) );
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
end
1522/60
.367*60
figure; ii=31;
dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97);
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
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
dx = zeros(size(aggda5.(recDays{ii}).xpos(xyIdxs)));
dy = zeros(size(aggda5.(recDays{ii}).ypos(xyIdxs)));
tx =  aggda5.(recDays{ii}).xpos(xyIdxs);
ty =  aggda5.(recDays{ii}).ypos(xyIdxs);
boxcarSize = 45;
tx=conv(tx,ones(1,boxcarSize)/boxcarSize, 'same');
ty=conv(ty,ones(1,boxcarSize)/boxcarSize, 'same');
for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
figure; ii=31;
dx = zeros(size(perTrial(ii).xpos));
dy = zeros(size(perTrial(ii).ypos));
tx =  perTrial(ii).xpos;
ty =  perTrial(ii).ypos;
for kk=2:length(aggda5.(recDays{ii}).xpos(xyIdxs))-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97);
figure; ii=31;
dx = zeros(size(perTrial(ii).xpos));
dy = zeros(size(perTrial(ii).ypos));
tx =  perTrial(ii).xpos;
ty =  perTrial(ii).ypos;
for kk=2:length(perTrial(ii).xpos)-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97);
length(perTrial(ii).xytimestampSeconds)
length(perTrial(ii).xpos)
length(sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97)
length(perTrial(ii).xpos)
size(perTrial(ii).xpos)
size(dy)
size(dx)
figure; ii=31;
dx = zeros(size(perTrial(ii).xpos));
dy = zeros(size(perTrial(ii).ypos));
tx =  perTrial(ii).xpos;
ty =  perTrial(ii).ypos;
for kk=2:length(perTrial(ii).xpos)-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);
figure; ii=31;
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
for kk=2:length(perTrial(ii).xpos)-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
boxcarSize = 45;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
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
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97;
figure; ii=31;
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
for kk=2:length(perTrial(ii).xpos)-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
boxcarSize = 45;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97);
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
for kk=2:length(perTrial(ii).xpos)-1
dy(kk)=( ty(kk-1) - ty(kk+1) );
dx(kk)=( tx(kk-1) - tx(kk+1) );
end
boxcarSize = 45;
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97);
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
boxcarSize = 10;
tx=conv(tx,ones(1,boxcarSize)/boxcarSize, 'same');
ty=conv(ty,ones(1,boxcarSize)/boxcarSize, 'same');
for kk=2:length(perTrial(ii).xpos)-5
dy(kk)=( ty(kk-1) - ty(kk+5) );
dx(kk)=( tx(kk-1) - tx(kk+5) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);
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
boxcarSize = 45;
tx=conv(tx,ones(1,boxcarSize)/boxcarSize, 'same');
ty=conv(ty,ones(1,boxcarSize)/boxcarSize, 'same');
for kk=6:length(perTrial(ii).xpos)-1
dy(kk)=( ty(kk-5) - ty(kk+1) );
dx(kk)=( tx(kk-5) - tx(kk+1) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);
ylim([0 150])
dx = zeros(size(perTrial(ii).xpos));
dy = zeros(size(perTrial(ii).ypos));
tx =  perTrial(ii).xpos;
ty =  perTrial(ii).ypos;
boxcarSize = 45;
tx=conv(tx,ones(1,boxcarSize)/boxcarSize, 'same');
ty=conv(ty,ones(1,boxcarSize)/boxcarSize, 'same');
for kk=2:length(perTrial(ii).xpos)-10
dy(kk)=( ty(kk-1) - ty(kk+10) );
dx(kk)=( tx(kk-1) - tx(kk+10) );
end
plot( perTrial(ii).xytimestampSeconds, sqrt( ( dx ).^2 + ( dy ).^2 ) * (1/2) * 1/2.75 * 29.97);
ylim([0 150])
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
for currentTrial = 1:length(perTrial)
%disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
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
%disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
% eliminate overlaps with the start and end of the trial
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+180 < length(perTrial(currentTrial).speed) ) ...
&& ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-180 > 0) ...
&& ( stillEpisode > 1) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-perTrial(currentTrial).movementTransitionIdx(stillEpisode-1) > 45)
%disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
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
recDays = {  'aug22' 'aug23'    'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
perTrial(trialIdx).swrsmoothSpeed   = aggda5.(recDays{ii}).swrsmoothSpeed(swrIdxs);
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
transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
% now find 3+s periods
% pick which stillness metric you want
%    movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
% movementTransitionIdx=find(abs(diff(perTrial(ii).stillness)));
tstill = perTrial(ii).stillness
motionToStillTransitionIdx=find((diff(tstill)<0));
stillToMotionTransitionIdx=find((diff(tstill)>0));
movementTransitionIdx=find(abs(diff(tstill)));
% track how many
transitionsFound(ii) = length(movementTransitionIdx);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
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
for currentTrial = 1:length(perTrial)
%disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
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
%disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
% eliminate overlaps with the start and end of the trial
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+180 < length(perTrial(currentTrial).speed) ) ...
&& ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-180 > 0) ...
&& ( stillEpisode > 1) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-perTrial(currentTrial).movementTransitionIdx(stillEpisode-1) > 45)
%disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
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
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0) ...
&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0) ...
&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
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
for currentTrial = 1:length(perTrial)
%disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
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
%disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
% eliminate overlaps with the start and end of the trial
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+180 < length(perTrial(currentTrial).speed) ) ...
&& ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-180 > 0) ...
% && ( stillEpisode > 1) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-perTrial(currentTrial).movementTransitionIdx(stillEpisode-1) > 45)
%disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
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
for currentTrial = 1:length(perTrial)
%disp(' start of trial ')
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(1:180);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(1:180)';
endTime = perTrial(currentTrial).xytimestampSeconds(180);
startTime = endTime-6;
swrTimeList = perTrial(currentTrial).swrTimes( find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
swrEvents( tempIdxs, currentEpisode ) = 1;
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
%disp('for loop')
for stillEpisode = 1:length(perTrial(currentTrial).movementTransitionIdx)
% eliminate overlaps with the start and end of the trial
if ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)+180 < length(perTrial(currentTrial).speed) ) ...
&& ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-180 > 0)% ...
% && ( stillEpisode > 1) && ( perTrial(currentTrial).movementTransitionIdx(stillEpisode)-perTrial(currentTrial).movementTransitionIdx(stillEpisode-1) > 45)
%disp( 'loop start' )
speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89);
smoothSpeedDist(:,currentEpisode) = perTrial(currentTrial).smoothSpeed(perTrial(currentTrial).movementTransitionIdx(stillEpisode)-90:perTrial(currentTrial).movementTransitionIdx(stillEpisode)+89)';
%disp( 'speeds' );
endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode))+3;
startTime = endTime-3;
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
%proxToReward=proxToReward(:, 1:currentEpisode-1);
%motionStillSpeed=motionStillSpeed( : , 1:motionCurrentEpisode-1 )';
%motionSwrEvents=motionSwrEvents(:, 1:motionCurrentEpisode-1)';
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0)% ...
%&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).xytimestampSeconds(:), perTrial(ii).xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,3,6);
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0)% ...
%&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
close all
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0)% ...
%&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
%-- 4/16/18, 7:17 PM --%
load('aggDa10Env.mat')
recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
rat='da5';
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
load('aggDa12Env.mat')
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
behaviorData = csvread('~/Desktop/matlabPlusMazeTrainingTrials.csv');
figure; boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
behaviorData = csvread('~/data/matlabPlusMazeTrainingTrials.csv');
figure; boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
behaviorData = matlabPlusMazeTrainingTrials;
figure; boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
aa=splitapply(@mean, behaviorData(:,5)>0, findgroups(behaviorData(:,12)));
figure; plot(1-aa); xlabel('training sessions (n)'); ylabel('proportion'); title('Proportion of Correct Trials');
figure; histogram(behaviorData(:,12),1:24)
title('trials per training session')
ylabel('trial count (n)')
xlabel('session (days)')
aa=splitapply(@mean, behaviorData(:,5)>0, findgroups(behaviorData(:,12)));
figure; plot(1-aa); xlabel('training sessions (n)'); ylabel('proportion'); title('Proportion of Correct Trials');
figure; boxplot(   behaviorData(:,5), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
ylim([ 0 1 ])
line([0 25],[.5 .5],'color','red')
recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
%% over days, how does sharp wave ripple production vary while the rat is on the maze?
% view unrotated
figure; hold on;
for ii=1:round(length(recDays))
hold on; scatter( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 'filled' ); alpha(.01);
end; axis square;
for ii=1:length(recDays)
[angle, radius] = cart2pol( agg.(recDays{ii}).xpos-400, agg.(recDays{ii}).ypos-405 ); angle=angle*180/pi+180;
rad=radius;
agg.(recDays{ii}).xylinearized=rad;
% * each arm is 109 cm. Let's assume the rat sticks his head at most 6 cm
% off the end of the start arm, so that is 115 cm.
% * let's place the center point at 115, and anything within a 25 px
% radius is just considered "center"
% * to orient the start arm, subtract whatever the radius is in cm
% (custom to each rat) from 110
% * on each subsequent
agg.(recDays{ii}).xylinearized(find((rad <= 25))) =  120; % Center Point
agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 25) .* ( angle >  45 ) .* ( angle <= 135 )))/(276/100) + 125; % South
agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 25) .* ( angle > 135 ) .* ( angle <= 225 )))/(269/100) + 330; % East
agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 25) .* ( angle > 225 ) .* ( angle <= 315 )))/(306/106) + 225; % North  ; invert this so the rat starts at x=0
agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 25) .* ( angle > 315 )  + ( angle <=  45 )))/(335/106)) ; % West
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
agg.(recDays{ii}).instantSpeed(jj) = sqrt( ( agg.(recDays{ii}).ypos(jj-60) - agg.(recDays{ii}).ypos(jj) ).^2 + ( agg.(recDays{ii}).xpos(jj-60) - agg.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
end
agg.(recDays{ii}).swrLagSpeed = agg.(recDays{ii}).lagSpeed(idxs);
end
pxPerCm = 2.9;
clear perTrial;
trialIdx=0;
for ii=1:length(recDays)
for jj=1:length(agg.(recDays{ii}).trial)
%disp( [ num2str(ii) ' . ' num2str(jj) ]);
trialIdx=trialIdx+1;
perTrial(trialIdx).day      = ii-1;
perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
%         if jj>1
%             startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialStartAction(jj) ) , 1 );
% leaveBucketToMaze trialStartAction trialCompleted leaveMazeToBucket
endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialCompleted(jj), 1 );
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
end
end
binSize = 10; % 55 px
bins = 0:binSize:440;
occupancyAll=[];
swrAll=[];
swrRateAll=[];
bee=[]; err=[]; oob=[];
trialSwr=[];
trialOcc=[];
avgVel = [];
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
trialSwr = [ trialSwr sum(freqSwr) ];
trialOcc = [ trialOcc sum(freqOcc) ];
avgVel= [ avgVel median(perTrial(ii).speed) / (length(perTrial(ii).speed)./29.97)];
end
probe=[]; for ii=1:length(perTrial); probe=[probe perTrial(ii).probe];end;
figure; colormap(build_NOAA_colorgradient);%  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);  colormap(newColorMap);
subplot(7,4,1:4:6*4); %imagesc(occupancyAll);
hold on;
for ii=1:length(perTrial)
scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.01);
end; xlim([0 500]); set(gca, 'Ydir', 'reverse'); axis tight;
title('occupancy')
subplot(7,4,2:4:6*4); %imagesc(swrAll);
hold on;
for ii=1:length(perTrial)
scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
end;xlim([0 500]); set(gca, 'Ydir', 'reverse'); axis tight;
title('swr freq. X space')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
subplot(7,4,25); hold on; plot(mean(occupancyAll(err==0,:)),'g'); plot(mean(occupancyAll(err==1,:)),'r'); plot(mean(occupancyAll(oob==0,:)),'b'); axis tight; % plot(mean(occupancyAll), 'k');  % plot(mean(occupancyAll(err==0,:)),'g'); plot(mean(occupancyAll(err==1,:)),'r'); plot(mean(occupancyAll(oob==0,:)),'b'); plot(mean(occupancyAll(bee==1,:)),'m');
subplot(7,4,26); hold on; plot(mean(swrAll(err==0,:)),'g'); plot(mean(swrAll(err==1,:)),'r'); plot(mean(swrAll(oob==0,:)),'b'); axis tight; % plot(mean(swrAll), 'k'); plot(mean(swrAll(err==0,:)),'g'); plot(mean(swrAll(err==1,:)),'r'); plot(mean(swrAll(oob==0,:)),'b'); plot(mean(swrAll(bee==1,:)),'m');
subplot(7,4,27); hold on; plot(mean(swrRateAll(err==0,:)),'g'); plot(mean(swrRateAll(err==1,:)),'r'); plot(mean(swrRateAll(oob==0,:)),'b'); axis tight; % plot(mean(swrRateAll), 'k'); plot(mean(swrRateAll(err==0,:)),'g'); plot(mean(swrRateAll(err==1,:)),'r'); plot(mean(swrRateAll(oob==0,:)),'b'); plot(mean(swrRateAll(bee==1,:)),'m');
subplot(7,4,4:4:6*4); hold off;
xx=trialSwr./trialOcc;%  mean(swrRateAll,2);
yy=1:78; plot(xx,yy); axis tight; set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ); scatter( xx(oob>0),yy(oob>0), 'o' ); scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
title('SWR Rate')
plotAllSwrStuffTogether
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
figure; colormap(build_NOAA_colorgradient);%  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);  colormap(newColorMap);
subplot(7,4,1:4:6*4); %imagesc(occupancyAll);
hold on;
for ii=1:length(perTrial)
scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.01);
end; set(gca, 'Ydir', 'reverse'); axis tight; xlim([0 580]);
title('occupancy')
subplot(7,4,2:4:6*4); %imagesc(swrAll);
hold on;
for ii=1:length(perTrial)
scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
end; set(gca, 'Ydir', 'reverse'); axis tight; xlim([0 580]);
title('swr freq. X space')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
subplot(7,4,25); hold on;
plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,26); hold on;
plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,27); hold on;
plot(binCenters,median(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
plot(binCenters,median(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,4:4:6*4); hold off;
xx=trialSwr./trialOcc; %mean(swrRateAll,2);
yy=1:length(perTrial); plot(xx,yy); axis tight; set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ); scatter( xx(oob>0),yy(oob>0), 'o' ); scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
title('SWR Rate')
colorplot('jet')
colormap('jet')
colormap([ colormap('jet') ; 0 0 0])
colormap([ 0 0 0 ; colormap('jet') ])
colormap([ 1 1 1 ; colormap('jet') ])
colormap(build_NOAA_colorgradient);
subplot(7,4,25); hold on;
plot(binCenters,mean(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
plot(binCenters,mean(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,26); hold on;
plot(binCenters,mean(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
plot(binCenters,mean(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,27); hold on;
plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,25);
hold off;
plot(binCenters,mean(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters,mean(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,26);
hold offn;
plot(binCenters,mean(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters,mean(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,27);
hold off;
plot(binCenters+14,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters+14,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
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
plot(binCenters+14,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters+14,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,27);
hold off;
plot(binCenters+25,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters+25,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,27);
hold off;
plot(binCenters+20,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters+20,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([0 580]);
subplot(7,4,27);
hold off;
plot(binCenters+20,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters+20,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight; xlim([-100 1000]);
xlim([-100 580]);
xlim([-100 700]);
xlim([-10 800]);
xlim([-30 700]);
xlim([-50 600]);
xlim([-50 700]);
xlim([-50 580]);
subplot(7,4,27);
hold off;
plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g');
hold on;
plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r');
%plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b');
axis tight;
xlim([-50 580]);
recDays = {     'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
figure; plot(perTrial(10).stillness); hold on; plot(diff(perTrial(10).stillness))
ylim([-2 2])
transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
% now find 3+s periods
% pick which stillness metric you want
%    movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
% movementTransitionIdx=find(abs(diff(perTrial(ii).stillness)));
tstill = perTrial(ii).stillness;
motionToStillTransitionIdx=find((diff(tstill)>0));
stillToMotionTransitionIdx=find((diff(tstill)<0));
movementTransitionIdx=find(abs(diff(tstill)));
% track how many
transitionsFound(ii) = length(movementTransitionIdx);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
transitionsFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
% now find 3+s periods
% pick which stillness metric you want
%    movementTransitionIdx=find(abs(diff(perTrial(ii).instantStillness)));
% movementTransitionIdx=find(abs(diff(perTrial(ii).stillness)));
tstill = perTrial(ii).stillness;
motionToStillTransitionIdx=find((diff(tstill)>0));
stillToMotionTransitionIdx=find((diff(tstill)<0));
movementTransitionIdx=find(abs(diff(tstill)));
movementTransitionIdx=find((diff(tstill)<0));
% track how many
transitionsFound(ii) = length(movementTransitionIdx);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
lastTime = perTrial(currentTrial).xytimestampSeconds(1);
%%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0)% ...
&& ( 6 < perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode)) - lastTime)
%&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
%
lastTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode));
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
lastTime = perTrial(currentTrial).xytimestampSeconds(1);
%%
for jj=1:length(perTrial(ii).movementTransitionIdx)
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0) ...
&& ( 6 < perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode)) - lastTime)
%&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
%
lastTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode));
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
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
if ( perTrial(ii).movementTransitionIdx(stillEpisode)+180 < length(perTrial(ii).speed) ) ...
&& ( perTrial(ii).movementTransitionIdx(stillEpisode)-180 > 0) ...
&& ( 6 < perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(stillEpisode)) - lastTime)
%&& ( stillEpisode > 1) && ( perTrial(ii).movementTransitionIdx(stillEpisode)-perTrial(ii).movementTransitionIdx(stillEpisode-1) > 45)
% % %
offset = rand(1)*2;
line([ perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))-3 perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
scatter( perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)), -5+offset, 'xk' )
%
lastTime = perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(stillEpisode));
end
end
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(end-179) perTrial(ii).xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
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
&& ( 6 < perTrial(ii).xytimestampSeconds(perTrial(ii).movementTransitionIdx(jj)) - lastTime)
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
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
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
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
%    drawnow;
%   pause(.2);
end
figure(1);
for ii=1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
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
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
clf(1);
%    drawnow;
%   pause(.2);
end
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-22_orientation1/1.maze-habituation/';
ttFilenames={'TT2CUTaftermerge.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
dateStr='2016-08-22';
placeCellScreenerFxn(dir,ttFilenames,dateStr)
ttFilenames(1)
strrep(ttFilenames(1), '.NTT', '')
placeCellScreenerFxn(dir,ttFilenames,dateStr)
'~/data/da5_place_'  dateStr '_' strrep( ttFilenames(ttIdx), '.NTT', '')  '_.png'
[ '~/data/da5_place_'  dateStr '_' strrep( ttFilenames(ttIdx), '.NTT', '')  '_.png']
[ '~/data/da5_place_'  dateStr '_' strrep( ttFilenames(tIdxs), '.NTT', '')  '_.png']
[ '~/data/da5_place_'  dateStr '_' strrep( ttFilenames(1), '.NTT', '')  '_.png']
strcat([ '~/data/da5_place_'  dateStr '_' strrep( ttFilenames(1), '.NTT', '')  '_.png'])
strcat([ '~/data/da5_place_'  dateStr '_'  '_.png'])
strcat([ '~/data/da5_place_'  dateStr '_' (strrep( ttFilenames(1), '.NTT', ''))  '_.png'])
strcat([ '~/data/da5_place_'  dateStr '_' {strrep( ttFilenames(1), '.NTT', '')}  '_.png'])
strcat([ '~/data/da5_place_'  dateStr '_' str(strrep( ttFilenames(1), '.NTT', ''))  '_.png'])
strcat([ '~/data/da5_place_'  dateStr '_' std(strrep( ttFilenames(1), '.NTT', ''))  '_.png'])
placeCellScreenerFxn(dir,ttFilenames,dateStr)
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-23_orientation2/1.maze-habituation/';
ttFilenames={ 'TT1cut.NTT' 'TT2cut.NTT' 'TT5cut.NTT' 'TT7tadcut.NTT' 'TT8tadcut.NTT' 'TT10cut.NTT' 'TT11cut.NTT' 'TT14cut.NTT' 'TT15cut.ntt' }
dateStr='2016-08-23';
placeCellScreenerFxn(dir,ttFilenames,dateStr)
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-24_training1/';
ttFilenames={'TT1cut.NTT' 'TT2cut.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT'  'TT15cut.NTT'};
dateStr='2016-08-24';
placeCellScreenerFxn(dir,ttFilenames,dateStr)
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-25_training2/';
ttFilenames={'TT1cut.NTT' 'TT2cut.NTT' 'TT7cut.NTT'};
dateStr='2016-08-25';
placeCellScreenerFxn(dir,ttFilenames,dateStr)
load('saturdayDataMon_lessSmoothTransitions.mat')
load('saturdayDataMon.mat')
recDays = {     'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; % 'aug22' 'aug23'
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
[ smoothSpeedswrLfp, smoothSpeedlfpTimestamps ] = csc2mat( '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/CSC4.ncs' );
smoothSpeedlfpTimestampSeconds=(smoothSpeedlfpTimestamps-smoothSpeedlfpTimestamps(1))/1e6;
dir = '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/'
[ smoothSpeedxpos, smoothSpeedypos, smoothSpeedxytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(smoothSpeedxytimestamps-smoothSpeedlfpTimestamps(1)));
smoothSpeedxpos=nlxPositionFixer(smoothSpeedxpos(xyStartIdx:end));
smoothSpeedypos=nlxPositionFixer(smoothSpeedypos(xyStartIdx:end));
smoothSpeedxytimestamps=smoothSpeedxytimestamps(xyStartIdx:end);
xysmoothSpeedxytimestampSeconds = ( smoothSpeedxytimestamps - smoothSpeedxytimestamps(1) )/1e6;
swrsmoothSpeedswrLfp = filtfilt( filters.so.swr, smoothSpeedswrLfp );
swrsmoothSpeedswrLfpEnv = abs( hilbert(swrsmoothSpeedswrLfp) );
makeFilters;
swrsmoothSpeedswrLfp = filtfilt( filters.so.swr, smoothSpeedswrLfp );
swrsmoothSpeedswrLfpEnv = abs( hilbert(swrsmoothSpeedswrLfp) );
swrEnvMedian = median(swrsmoothSpeedswrLfpEnv);
swrEnvMadam  = median(abs(swrsmoothSpeedswrLfpEnv-swrEnvMedian));
swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrsmoothSpeedswrLfpEnv,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(smoothSpeedxpos, smoothSpeedypos, lagTime, pxPerCm);
figure;
subplot(3,1,1);
plot(smoothSpeedlfpTimestampSeconds,smoothSpeedswrLfp, 'k');
subplot(3,1,2);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfp, 'Color', [ .1 .1 .8 ]);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfpEnv, 'Color', [ .7 0.1 .1 ]);
subplot(3,1,3);
plot( xysmoothSpeedxytimestampSeconds,speed, 'Color', [ .7 0 .7 ])
xlims=[ 0 135]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 50 140]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
subplot(3,1,2);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfp, 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfpEnv, 'Color', [ .7 0.1 .1 ]);
xlims=[ 0 135]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 0 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 50 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
subplot(3,1,3);
plot( xysmoothSpeedxytimestampSeconds, 2+((speed>7)*5), 'Color', [ .1 .8 .1 ]);
xlims=[ 50 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
subplot(3,1,3);
plot( xysmoothSpeedxytimestampSeconds,speed, 'Color', [ .7 0 .7 ]); hold on;
plot( xysmoothSpeedxytimestampSeconds, 2+((speed>7)*5), 'Color', [ .1 .8 .1 ]);
xlims=[ 50 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 70 78]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 71.5 77.5 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 100 300 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 340 500 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 387 393 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
subplot(3,1,2);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
xlims=[ 300 500 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
[ smoothSpeedswrLfp, smoothSpeedlfpTimestamps ] = csc2mat( '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/CSC30.ncs' );
smoothSpeedlfpTimestampSeconds=(smoothSpeedlfpTimestamps-smoothSpeedlfpTimestamps(1))/1e6;
swrsmoothSpeedswrLfp = filtfilt( filters.so.swr, smoothSpeedswrLfp );
swrsmoothSpeedswrLfpEnv = abs( hilbert(swrsmoothSpeedswrLfp) );
swrEnvMedian = median(swrsmoothSpeedswrLfpEnv);
swrEnvMadam  = median(abs(swrsmoothSpeedswrLfpEnv-swrEnvMedian));
swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrsmoothSpeedswrLfpEnv,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
figure;
subplot(3,1,1);
plot(smoothSpeedlfpTimestampSeconds,smoothSpeedswrLfp, 'k');
subplot(3,1,2);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfp, 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfpEnv, 'Color', [ .7 0.1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(3,1,3);
plot( xysmoothSpeedxytimestampSeconds,speed, 'Color', [ .7 0 .7 ]); hold on;
plot( xysmoothSpeedxytimestampSeconds, 2+((speed>7)*5), 'Color', [ .1 .8 .1 ]);
%trial 1, episode X
xlims=[ 71.5 77.5 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 387 393 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 372 380 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
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
%movementTransitionIdx=find((diff(tstill)<0));
% track how many
transitionsFound(ii) = length(movementTransitionIdx);
perTrial(ii).movementTransitionIdx = movementTransitionIdx;
end
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
&& ( 6 < perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode)) - lastTime)
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
&& ( 6 < perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).movementTransitionIdx(stillEpisode)) - lastTime)
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
aa=mean(smoothSpeedDist(:,91:180),2)./mean(smoothSpeedDist(:,1:90),2);
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=mean(smoothSpeedDist(:,61:150),2)./mean(smoothSpeedDist(:,31:60),2);
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=mean(smoothSpeedDist(:,130:160),2)./mean(smoothSpeedDist(:,21:60),2);
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
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
aa=mean(smoothSpeedDist(:,130:160),2)./mean(smoothSpeedDist(:,21:60),2);
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=mean(smoothSpeedDist(:,130:160),2) %
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=mean(smoothSpeedDist(:,20:70),2) %
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=mean(smoothSpeedDist(:,1:60),2) %
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
size(sum(stillMotionSwrEvents(:,1:90)))
size(sum(stillMotionSwrEvents(:,1:90)),2)
size(sum(stillMotionSwrEvents(:,1:90),2))
aa=(sum(stillMotionSwrEvents(:,1:90),2))
aa=(sum(stillMotionSwrEvents(:,1:90),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=(sum(stillMotionSwrEvents(:,91:160),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=(sum(swrEvents(:,91:160),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=(sum(swrEvents(:,1:90),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
colormap(build_NOAA_colorgradient)
aa=mean(smoothSpeedDist(:,1:60),2) %
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
colormap(build_NOAA_colorgradient)
colorbar
priorStillness = (smoothSpeedDist(:,aa<7));
priorStillness = (smoothSpeedDist(aa<7,:));
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=mean(priorStillness(:,120:170),2); %
[B,I]=sort(aa);
figure; imagesc(priorStillness(I,:)); colormap;
figure; subplot(1,4,1:3); spy(priorStillnessSWR(I,:)); subplot(1,4,4); plot(sum(priorStillnessSWR(I,:),2), 1:length(priorStillnessSWR));
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5); plot(sum(priorStillnessSWR(I,1:90),2), 1:length(priorStillnessSWR));
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(I,1:90),2)+mean(priorStillness(:,120:170),2); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5); plot(sum(priorStillnessSWR(I,1:90),2), 1:length(priorStillnessSWR));
aa=sum(priorStillnessSWR(I,1:90),2)%+mean(priorStillness(:,120:170),2); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5); plot(sum(priorStillnessSWR(I,1:90),2), 1:length(priorStillnessSWR));
aa=sum(priorStillnessSWR(:,1:90),2);%+mean(priorStillness(:,120:170),2); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5); plot(sum(priorStillnessSWR(I,1:90),2), 1:length(priorStillnessSWR));
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5); plot(sum(priorStillnessSWR(I,1:90),2), flipud( 1:length(priorStillnessSWR)));
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5); plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR)));
ylim([ 0 length(priorStillnessSWR)]);
hold on; plot(sum(priorStillnessSWR(I,91:180),2), fliplr( 1:length(priorStillnessSWR)));
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]);
hold on; scatter(sum(priorStillnessSWR(I,91:180),2), fliplr( 1:length(priorStillnessSWR)),'o');
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colormap;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]);
xlim([ -1 8 ]);
subplot(1,5,1:3);
colorbar;
max(swrPeakValues)
find(swrPeakValues==max(swrPeakValues))
swrPeakTimes(56)
xlims=[ 50 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 125 130]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 50 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 70 80]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 350 400]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 395 420]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 415 416]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 0 1000 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
xlims=[ 720 722 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);
spikesmoothSpeedswrLfp = filtfilt( filters.so.spike, smoothSpeedswrLfp );
%spikeswrsmoothSpeedswrLfpEnv = abs( hilbert(spikesmoothSpeedswrLfp) );
spikeEnvMedian = median(spikesmoothSpeedswrLfp);
spikeEnvMadam  = median(abs(spikesmoothSpeedswrLfp-spikeEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
spikeThreshold = spikeEnvMedian + ( 7  * spikeEnvMadam );
[ spikePeakValues,      ...
spikePeakTimes,       ...
spikePeakProminances, ...
spikePeakWidths ] = findpeaks( spikesmoothSpeedswrLfpEnv,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
[ spikePeakValues,      ...
spikePeakTimes,       ...
spikePeakProminances, ...
spikePeakWidths ] = findpeaks( spikesmoothSpeedswrLfp,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds,smoothSpeedswrLfp, 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfp, 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfpEnv, 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3);
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .1 .7 .1 ]); hold on;
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,4);
plot( xysmoothSpeedxytimestampSeconds,speed, 'Color', [ .7 0 .7 ]); hold on;
ylim([ 0 50]);
%plot( xysmoothSpeedxytimestampSeconds, 2+((speed>7)*5), 'Color', [ .1 .8 .1 ]);
xlims=[ 720 722 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims); subplot(3,1,4); xlim(xlims);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds,smoothSpeedswrLfp, 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfp, 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfpEnv, 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3);
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .1 .7 .1 ]); hold on;
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,4);
plot( xysmoothSpeedxytimestampSeconds,speed, 'Color', [ .7 0 .7 ]); hold on;
ylim([ 0 50]);
%plot( xysmoothSpeedxytimestampSeconds, 2+((speed>7)*5), 'Color', [ .1 .8 .1 ]);
xlims=[ 720 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .1 .7 .1 ]); hold on;
scatter( spikePeakTimes, spikePeakValues, 'v', 'filled' );
xlims=[ 720 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
[ spikePeakValues,      ...
spikePeakTimes,       ...
spikePeakProminances, ...
spikePeakWidths ] = findpeaks( spikesmoothSpeedswrLfp,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.002  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
spikeswrsmoothSpeedswrLfpEnv = abs( hilbert(spikesmoothSpeedswrLfp) );
spikeEnvMedian = median(spikeswrsmoothSpeedswrLfpEnv);
spikeEnvMadam  = median(abs(spikeswrsmoothSpeedswrLfpEnv-spikeEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
spikeThreshold = spikeEnvMedian + ( 7  * spikeEnvMadam );
[ spikePeakValues,      ...
spikePeakTimes,       ...
spikePeakProminances, ...
spikePeakWidths ] = findpeaks( spikeswrsmoothSpeedswrLfpEnv,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.002  );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds,spikeswrsmoothSpeedswrLfpEnv, 'Color', [ .2 .2 .2 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .1 .7 .1 ]); hold on;
scatter( spikePeakTimes, spikePeakValues, 'v', 'filled' );
xlims=[ 720 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
subplot(4,1,3); hold off;
scatter( spikePeakTimes, -.3*ones(1,length(spikePeakTimes)), '|' );
scatter( spikePeakTimes, -.3*ones(1,length(spikePeakTimes)), '+' );
xlims=[ 720 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
subplot(4,1,3); hold off;
ylim([-.4 .4])
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds,spikeswrsmoothSpeedswrLfpEnv, 'Color', [ .2 .2 .2 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .1 .7 .1 ]); hold on;
scatter( spikePeakTimes, -.3*ones(1,length(spikePeakTimes)), '+' );
ylim([-.4 .4])
xlims=[ 720 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds,spikeswrsmoothSpeedswrLfpEnv, 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes)))+(rand(1,length(spikePeakTimes))/50), '+', 'Color', [ .2 .2 .8 ] );
ylim([-.4 .4])
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes)))+(rand(1,length(spikePeakTimes))/50), '+', 'MarkerEdgeColor', [ .2 .2 .8 ] );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds,spikeswrsmoothSpeedswrLfpEnv, 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes)))+(rand(1,length(spikePeakTimes))/50), '+', 'MarkerEdgeColor', [ .2 .2 .8 ] );
xlims=[ 721 723 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds,smoothSpeedswrLfp, 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfp, 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds,swrsmoothSpeedswrLfpEnv, 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds,spikeswrsmoothSpeedswrLfpEnv, 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds,spikesmoothSpeedswrLfp, 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
plot( xysmoothSpeedxytimestampSeconds,speed, 'Color', [ .7 0 .7 ]); hold on;
ylim([ 0 50]);
%plot( xysmoothSpeedxytimestampSeconds, 2+((speed>7)*5), 'Color', [ .1 .8 .1 ]);
xlims=[ 721 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);
plotAllSwrStuffTogether
print( '~/Desktop/swrplacepreference.png','-dpng','-r500');
subplot(7,4,3:4:6*4);
caxis([0 9])
figure;
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate'); caxis([0 8])
figure; histogram(swrRateAll(:),25)
subplot(7,4,3:4:6*4); imagesc(swrRateAll); colormap('parula'); title('swr Rate'); caxis([0 7])
colormap([ 1 1 1; colormap('parula')])
colormap([ 1 1 1; colormap('jet')]);
colormap([ 1 1 1; colormap('jet')]); caxis([0 6]);
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
title('swr freq. X space')
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
dir = '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/'
disp('loading SWR file');
[ smoothSpeedswrLfp, smoothSpeedlfpTimestamps ] = csc2mat( '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/CSC30.ncs' );
smoothSpeedlfpTimestampSeconds=(smoothSpeedlfpTimestamps-smoothSpeedlfpTimestamps(1))/1e6;
[ smoothSpeedxpos, smoothSpeedypos, smoothSpeedxytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(smoothSpeedxytimestamps-smoothSpeedlfpTimestamps(1)));
smoothSpeedxpos=nlxPositionFixer(smoothSpeedxpos(xyStartIdx:end));
smoothSpeedypos=nlxPositionFixer(smoothSpeedypos(xyStartIdx:end));
smoothSpeedxytimestamps=smoothSpeedxytimestamps(xyStartIdx:end);
xysmoothSpeedxytimestampSeconds = ( smoothSpeedxytimestamps - smoothSpeedxytimestamps(1) )/1e6;
makeFilters;
swrsmoothSpeedswrLfp = filtfilt( filters.so.swr, smoothSpeedswrLfp );
swrsmoothSpeedswrLfpEnv = abs( hilbert(swrsmoothSpeedswrLfp) );
swrEnvMedian = median(swrsmoothSpeedswrLfpEnv);
swrEnvMadam  = median(abs(swrsmoothSpeedswrLfpEnv-swrEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrsmoothSpeedswrLfpEnv,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
spikesmoothSpeedswrLfp = filtfilt( filters.so.spike, smoothSpeedswrLfp );
spikeswrsmoothSpeedswrLfpEnv = abs( hilbert(spikesmoothSpeedswrLfp) );
spikeEnvMedian = median(spikeswrsmoothSpeedswrLfpEnv);
spikeEnvMadam  = median(abs(spikeswrsmoothSpeedswrLfpEnv-spikeEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
spikeThreshold = spikeEnvMedian + ( 7  * spikeEnvMadam );
[ spikePeakValues,      ...
spikePeakTimes,       ...
spikePeakProminances, ...
spikePeakWidths ] = findpeaks( spikeswrsmoothSpeedswrLfpEnv,                        ... % data
smoothSpeedlfpTimestampSeconds,                     ... % sampling frequency
'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.002  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(smoothSpeedxpos, smoothSpeedypos, lagTime, pxPerCm);
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrsmoothSpeedswrLfpEnv(nlxidxs),                        ... % data
smoothSpeedlfpTimestampSeconds(nlxidxs),                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
nlxidxs=round(721*32000):round(722*32000);
xyidxs=round(721*29.97):round(722*29.97);
[ swrPeakValues,      ...
swrPeakTimes,       ...
swrPeakProminances, ...
swrPeakWidths ] = findpeaks( swrsmoothSpeedswrLfpEnv(nlxidxs),                        ... % data
smoothSpeedlfpTimestampSeconds(nlxidxs),                     ... % sampling frequency
'MinPeakHeight',  swrThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
[ spikePeakValues,      ...
spikePeakTimes,       ...
spikePeakProminances, ...
spikePeakWidths ] = findpeaks( spikeswrsmoothSpeedswrLfpEnv(nlxidxs),                        ... % data
smoothSpeedlfpTimestampSeconds(nlxidxs),                     ... % sampling frequency
'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
'MinPeakDistance', 0.002  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
plot( xysmoothSpeedxytimestampSeconds(xyidxs),speed(xyidxs), 'Color', [ .7 0 .7 ]); hold on;
ylim([ 0 50]);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
xlim([ 721.5 721.6 ]);
xlim([ 721.35 721.45 ]);
xlim([ 721.37 721.42 ]);
print( '~/Desktop/swrexample.png','-dpng','-r500');
startTime = 650  % 721 for SWR ;
endTime =  750 % 722 for SWR ;
nlxidxs=round(721*32000):round(722*32000);
xyidxs=round(721*29.97):round(722*29.97);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
xlim([ 721.37 721.42 ]);
startTime = 650  % 721 for SWR ;
endTime =  750 % 722 for SWR ;
nlxidxs=round(startTime*32000):round(endTime*32000);
xyidxs=round(startTime*29.97):round(endTime*29.97);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
%plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
%xlim([ 721.37 721.42 ]);
plot( xysmoothSpeedxytimestampSeconds(xyidxs), 2+((speed(xyidxs)>7)*5), 'Color', [ .1 .8 .1 ]);
hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]);
plot( xysmoothSpeedxytimestampSeconds(xyidxs), speed(xyidxs));
startTime = 673  % 721 for SWR ;
endTime =  735 % 722 for SWR ;
nlxidxs=round(startTime*32000):round(endTime*32000);
xyidxs=round(startTime*29.97):round(endTime*29.97);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
%plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
%xlim([ 721.37 721.42 ]);
plot( xysmoothSpeedxytimestampSeconds(xyidxs), speed(xyidxs));
plot( xysmoothSpeedxytimestampSeconds(xyidxs), 2+((speed(xyidxs)>7)*5), 'Color', [ .1 .8 .1 ]);
startTime = 673  % 721 for SWR ;
endTime =  735 % 722 for SWR ;
nlxidxs=round(startTime*32000):round(endTime*32000);
xyidxs=round(startTime*29.97):round(endTime*29.97);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] );
ylim([-.4 .4])
subplot(4,1,4);
%plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
%xlim([ 721.37 721.42 ]);
plot( xysmoothSpeedxytimestampSeconds(xyidxs), speed(xyidxs)); hold on;
plot( xysmoothSpeedxytimestampSeconds(xyidxs), 2+((speed(xyidxs)>7)*5), 'Color', [ .1 .8 .1 ]);
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
figure
for ii= 4 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
lastTime = perTrial(ii).xytimestampSeconds(1);
%%
for jj=3%1:length(perTrial(ii).movementTransitionIdx)
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
ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
figure%(1);
for ii= 4 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
%plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
%plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
%scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
scatter( perTrial(ii).swrTimes, -1*ones(size(perTrial(ii).swrTimes)), 'b*' );
plot( perTrial(ii).xytimestampSeconds, perTrial(ii).smoothSpeed );
plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).instantStillness*5-19) );
%
offset = rand(1);
line([ perTrial(ii).xytimestampSeconds(1) perTrial(ii).xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
scatter( perTrial(ii).xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
lastTime = perTrial(ii).xytimestampSeconds(1);
%%
for jj=2%1:length(perTrial(ii).movementTransitionIdx)
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
ylim([ -2 150 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
figure%(1);
for ii= 27 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
%plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
%plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
%scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
scatter( perTrial(ii).swrTimes, -1*ones(size(perTrial(ii).swrTimes)), 'b*' );
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
ylim([ -2 150 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
figure%(1);
for ii= 28 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
hold off;
%plot( perTrial(ii).xytimestampSeconds, perTrial(ii).speed );
hold on;
%plot( perTrial(ii).xytimestampSeconds, (perTrial(ii).stillness*5-11) );
%scatter( perTrial(ii).swrTimes, perTrial(ii).swrSpeed, 'r*' );
scatter( perTrial(ii).swrTimes, -1*ones(size(perTrial(ii).swrTimes)), 'b*' );
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
ylim([ -2 150 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
figure; plot(xysmoothSpeedxytimestampSeconds, speed);
figure%(1);
for ii= 28 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
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
subplot(2,3,3);
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
subplot(2,3,6);
hold off;
x = perTrial(ii).xpos;
y = perTrial(ii).ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [perTrial(ii).smoothSpeed(:), perTrial(ii).smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
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
print( [ '~/data/da5_exampleRun_trial-28_aug28_learnmem.png'],'-dpng','-r500')
figure; boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
behaviorData = matlabPlusMazeTrainingTrials;
figure; boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
ylim([0 230]);
print( [ '~/Desktop/allrats_latencyToReward_learnmem.png'],'-dpng','-r500')
ylim([0 1500]);
ylim([0 1600]);
print( [ '~/Desktop/allrats_latencyToReward_outliers_learnmem.png'],'-dpng','-r500')
ylim([0 230]);
ylim([0 170]);
print( [ '~/Desktop/allrats_latencyToReward_learnmem.png'],'-dpng','-r500')
ylim([0 400]);
ylim([0 1600]);
boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
ylim([0 400]);
print( [ '~/Desktop/allrats_latencyToReward_outliers_learnmem.png'],'-dpng','-r500')
aa=splitapply(@mean, behaviorData(:,5)>0, findgroups(behaviorData(:,12)));
figure; plot(1-aa); xlabel('training sessions (n)'); ylabel('proportion'); title('Proportion of Correct Trials'); ylim([ 0 1 ]); line([0 25],[.5 .5],'color','red')
aa=splitapply(@mean, behaviorData(:,5)>0, findgroups(behaviorData(:,12)));
figure; plot(1-aa);
ylim([ 0 1 ]); line([0 25],[.5 .5],'color','red')
print( [ '~/Desktop/allrats_proportionCorrectFirstChoice_learnmem.png'],'-dpng','-r500')
load('saturdayDataMon.mat')
dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   trialSwr./trialOcc, dd, 'notch','on'); xlabel('training session'); title('swr rate per training session'); ylabel('swr rate (events/s)')
binSize = 20; %cm    % 55 px
bins = 0:binSize:450;
occupancyAll=[];
swrAll=[];
swrRateAll=[];
bee=[]; err=[]; oob=[];
trialSwr=[];
trialOcc=[];
avgVel = [];
probe = [];
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
end
binSize = 20; %cm    % 55 px
bins = 0:binSize:450;
occupancyAll=[];
swrAll=[];
swrRateAll=[];
bee=[]; err=[]; oob=[];
trialSwr=[];
trialOcc=[];
avgVel = [];
probe = [];
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
%oob = [ oob perTrial(ii).outOfBounds ];
err = [ err perTrial(ii).error ];
probe = [ probe perTrial(ii).probe ];
trialSwr = [ trialSwr sum(freqSwr) ];
trialOcc = [ trialOcc sum(freqOcc) ];
avgVel= [ avgVel median(perTrial(ii).speed) / (length(perTrial(ii).speed)./29.97)];
end
dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   trialOcc, dd, 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   avgVel, dd, 'notch','on'); xlabel('training session'); title('avg vel. per training session'); ylabel('avg vel. (cm/s)')
dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   trialSwr./trialOcc, dd, 'notch','on'); xlabel('training session'); title('swr rate per training session'); ylabel('swr rate (events/s)')
%-- 4/21/18, 4:16 PM --%
aa=loadCExtractedNrdChannelData('~/demo/rawChannel_1.dat');
tt=loadCExtractedNrdTimestampData('~/demo/timestamps.dat');
ttSeconds=(tt-tt(1))/1e6;
figure; plot(ttSeconds, aa)
clear all
close all
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
aa=mean(smoothSpeedDist(:,130:160),2)./mean(smoothSpeedDist(:,21:60),2);
aa=(sum(swrEvents(:,1:90),2));
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
%[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
figure; imagesc(stillMotionSmootherSpeeds); colormap;
figure; hold on; spy(stillMotionSwrEvents)
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
hold on; scatter(sum(priorStillnessSWR(I,91:180),2), fliplr( 1:length(priorStillnessSWR)),'o');
[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
size(mean(stillMotionSpeeds(91:180),2))
size(mean(stillMotionSpeeds(91:180,:),2))
size(mean(stillMotionSpeeds(91:180,:)))
size(mean(speedDist(:,91:180)))
size(mean(speedDist(:,91:180),2))
selectedRuns = (max(speedDist(:,1:90),2)<10) && (mean(speedDist(:,91:180),2)>10);
max(speedDist(:,1:90),2)<10
size(max(speedDist(:,1:90),2))
size(max(speedDist(:,1:90)))
size(max(speedDist(:,1:90),2))
size(max(speedDist(:,1:90)'))
selectedRuns = (max(speedDist(:,1:90)')<10) && (mean(speedDist(:,91:180),2)>10);
size(mean(speedDist(:,91:180),2))
(mean(speedDist(:,91:180),2)>10)
(max(speedDist(:,1:90)')<10)
max(speedDist(:,1:90)')
sum((mean(speedDist(:,91:180),2)>10))
sum(max(speedDist(:,1:90)')<10)
sum(max(speedDist(:,1:70)')<10)
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
sum((max(speedDist(:,1:70)')<10))
size(speedDist(:,1:70))
size(max(speedDist(:,20:60)))
size(max(speedDist(:,20:60),2))
size(max(speedDist(:,20:60)'))
max(speedDist(:,20:60)')
sum((mean(speedDist(:,1:70)')<10))
selectedRuns = (mean(speedDist(:,1:70)')<10) && (mean(speedDist(:,91:180),2)>10);
selectedRuns = (mean(speedDist(:,1:70)')<10) .* (mean(speedDist(:,91:180),2)>10);
selectedRuns = (mean(speedDist(:,1:70)')<10)' .* (mean(speedDist(:,91:180),2)>10);
selectedRuns = (mean(speedDist(:,1:70)')<10)' .* (mean(speedDist(:,91:180),2)>10);
stillMotionSpeeds=speedDist(selectedRuns,:);
stillMotionSmootherSpeeds=smoothSpeedDist(selectedRuns,:);
stillMotionSwrEvents=swrEvents(selectedRuns,:);
[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
selectedRuns = (mean(speedDist(:,1:70)')<10)' .* (mean(speedDist(:,91:180),2)>10);
stillMotionSpeeds=speedDist(find(selectedRuns),:);
stillMotionSmootherSpeeds=smoothSpeedDist(find(selectedRuns),:);
stillMotionSwrEvents=swrEvents(find(selectedRuns),:);
[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
stillIdxs=mean(smoothSpeedDist(:,1:60),2); %
priorStillness = (smoothSpeedDist(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
hold on; scatter(sum(priorStillnessSWR(I,91:180),2), fliplr( 1:length(priorStillnessSWR)),'o');
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
stillMotionSpeeds=speedDist(find(selectedRuns),:);
stillMotionSmootherSpeeds=smoothSpeedDist(find(selectedRuns),:);
stillMotionSwrEvents=swrEvents(find(selectedRuns),:);
[B,I]=sort(mean(smoothSpeedDist(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=smoothSpeedDist(I,:);
stillMotionSwrEvents=swrEvents(I,:);
stillIdxs=mean(stillMotionSpeeds(:,1:60),2); %
priorStillness = (stillMotionSpeeds(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
sum(selectedRuns)
stillMotionSpeeds=speedDist(find(selectedRuns),:);
stillMotionSmootherSpeeds=smoothSpeedDist(find(selectedRuns),:);
stillMotionSwrEvents=swrEvents(find(selectedRuns),:);
selectedRuns = (mean(speedDist(:,1:70)')<10)' .* (mean(speedDist(:,91:180),2)>10);
stillMotionSpeeds=speedDist(find(selectedRuns),:);
stillMotionSmootherSpeeds=smoothSpeedDist(find(selectedRuns),:);
stillMotionSwrEvents=swrEvents(find(selectedRuns),:);
[B,I]=sort(mean(stillMotionSmootherSpeeds(:,91:180),2));
stillMotionSpeeds=speedDist(I,:);
stillMotionSmootherSpeeds=stillMotionSmootherSpeeds(I,:);
stillMotionSwrEvents=swrEvents(I,:);
stillIdxs=mean(stillMotionSpeeds(:,1:60),2); %
priorStillness = (stillMotionSpeeds(stillIdxs<7,:));
priorStillnessSWR = stillMotionSwrEvents(stillIdxs<7,:);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
size(sum(priorStillnessSWR(:,1:90),2))
stillIdxs=mean(stillMotionSpeeds(:,1:60),2); %
priorStillness = (stillMotionSpeeds(:,stillIdxs<7));
priorStillnessSWR = stillMotionSwrEvents(:,stillIdxs<7);
aa=sum(priorStillnessSWR(:,1:90),2)+mean(priorStillness(:,120:170),2)/max(mean(priorStillness(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(priorStillness(I,:)); colorbar;
subplot(1,5,4); spy(priorStillnessSWR(I,:));
subplot(1,5,5);
plot(sum(priorStillnessSWR(I,1:90),2), fliplr( 1:length(priorStillnessSWR))); ylim([ 0 length(priorStillnessSWR)]); xlim([ -1 8 ]);
aa=sum(stillMotionSwrEvents(:,1:90),2)+mean(stillMotionSpeeds(:,120:170),2)/max(mean(stillMotionSpeeds(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:));
subplot(1,5,5);
plot(sum(stillMotionSwrEvents(I,1:90),2), fliplr( 1:length(stillMotionSwrEvents))); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
size(sum(stillMotionSwrEvents(I,1:90),2))
size(fliplr( 1:length(stillMotionSwrEvents)))
aa=sum(stillMotionSwrEvents(:,1:90),2)+mean(stillMotionSpeeds(:,120:170),2)/max(mean(stillMotionSpeeds(:,120:170),2)); %
[B,I]=sort(aa);
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:));
subplot(1,5,5);
plot(sum(stillMotionSwrEvents(I,1:90),2), 1:180; ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
plot(sum(stillMotionSwrEvents(I,1:90),2), 1:180); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
size(sum(stillMotionSwrEvents(I,1:90),2))
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:));
subplot(1,5,5);
plot(sum(stillMotionSwrEvents(I,1:90)), 1:180; ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
plot(sum(stillMotionSwrEvents(I,1:90)), 1:180); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:));
subplot(1,5,5);
plot(sum(stillMotionSwrEvents(I,1:90)), 1:180); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:));
subplot(1,5,5);
plot(sum(stillMotionSwrEvents(I,1:90)), 1:140); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
size((sum(stillMotionSwrEvents(I,1:90)))
size((sum(stillMotionSwrEvents(I,1:90))))
size(sum(stillMotionSwrEvents(I,1:90),2))
figure; subplot(1,5,1:3); imagesc(stillMotionSpeeds(I,:)); colorbar;
subplot(1,5,4); spy(stillMotionSwrEvents(I,:));
subplot(1,5,5);
plot(sum(stillMotionSwrEvents(I,1:90),2), 1:140); ylim([ 0 length(stillMotionSwrEvents)]); xlim([ -1 8 ]);
figure; surf(speedDist(:,1:90));
%-- 4/25/18, 5:09 PM --%
dir='/Volumes/Seagate Expansion Drive/h5/2018-04-25_orientation1/';
[ ~, spiketimes, spikeheader, ~, cellNumber ]=ntt2mat([ dir 'TT5_recut.NTT' ]);
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
figure; plot(xpos,ypos)
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, -42, 0, 0 );
hold on; plot(xrpos,yrpos);
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, 47, 0, 0 );
hold on; plot(xrpos,yrpos);
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, 42, 0, 0 );
hold on; plot(xrpos,yrpos);
figure; plot(xpos,ypos);
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, 42, 0, 0 );
hold on; plot(xrpos,yrpos);
figure; plot(xpos,ypos);
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, 42, 350, 280 );
hold on; plot(xrpos,yrpos);
figure; plot(xpos,ypos);
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, 42, 360, 290 );
hold on; plot(xrpos,yrpos);
figure; plot(xpos,ypos);
[xrpos,yrpos]=rotateXYPositions( xpos, ypos, 325, 209, 42, 360, 300 );
hold on; plot(xrpos,yrpos);
speed = calculateSpeed( xpos, ypos, 1.5, 2.6, 29.97);
figure%(1);
%for ii= 28 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
subplot(2,2,1:2);
hold off;
plot( xytimestampSeconds, speed );
hold on;
%plot( xytimestampSeconds, (stillness*5-11) );
%scatter( swrTimes, swrSpeed, 'r*' );
%scatter( swrTimes, -1*ones(size(swrTimes)), 'b+' );
%plot( xytimestampSeconds, smoothSpeed );
%plot( xytimestampSeconds, (instantStillness*5-19) );
%
%offset = rand(1);
%line([ xytimestampSeconds(1) xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
%scatter( xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
%lastTime = xytimestampSeconds(1);
%%
%     %for jj=1:length(movementTransitionIdx)
%         if ( movementTransitionIdx(jj)+180 < length(speed) ) ...
%             && ( movementTransitionIdx(jj)-180 > 0) ...
%             && ( 3 < xytimestampSeconds(movementTransitionIdx(jj)) - lastTime)
%         %&& ( stillEpisode > 1) && ( movementTransitionIdx(stillEpisode)-movementTransitionIdx(stillEpisode-1) > 45)
%         % % %
%             offset = rand(1)*2;
%             line([ xytimestampSeconds(movementTransitionIdx(jj))-3 xytimestampSeconds(movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
%             scatter( xytimestampSeconds(movementTransitionIdx(jj)), -5+offset, 'xk' )
%             %
%             lastTime = xytimestampSeconds(movementTransitionIdx(jj));
%         end
%     end
%     %
%     offset = rand(1);
%     line([ xytimestampSeconds(end-179) xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
%     scatter( xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -2 60 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,2,3);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,2,4);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [smoothSpeed(:), smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
%    print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
clf(1);
xytimestampSeconds=(xytimestamp-xytimestamp(1))/1e6;
spiketimesSeconds = (spiketimes-xytimestamp(1))/1e6;
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
spiketimesSeconds = (spiketimes-xytimestamps(1))/1e6;
figure%(1);
%for ii= 28 %1:length(perTrial)
subplot(2,3,[ 1 2 4 5 ]);
subplot(2,2,1:2);
hold off;
plot( xytimestampSeconds, speed );
hold on;
%plot( xytimestampSeconds, (stillness*5-11) );
%scatter( swrTimes, swrSpeed, 'r*' );
%scatter( swrTimes, -1*ones(size(swrTimes)), 'b+' );
%plot( xytimestampSeconds, smoothSpeed );
%plot( xytimestampSeconds, (instantStillness*5-19) );
%
%offset = rand(1);
%line([ xytimestampSeconds(1) xytimestampSeconds(180)  ],[ -4+offset -4+offset ], 'Color','magenta');
%scatter( xytimestampSeconds(1)+3, -4+offset, 'xk' );
%
%lastTime = xytimestampSeconds(1);
%%
%     %for jj=1:length(movementTransitionIdx)
%         if ( movementTransitionIdx(jj)+180 < length(speed) ) ...
%             && ( movementTransitionIdx(jj)-180 > 0) ...
%             && ( 3 < xytimestampSeconds(movementTransitionIdx(jj)) - lastTime)
%         %&& ( stillEpisode > 1) && ( movementTransitionIdx(stillEpisode)-movementTransitionIdx(stillEpisode-1) > 45)
%         % % %
%             offset = rand(1)*2;
%             line([ xytimestampSeconds(movementTransitionIdx(jj))-3 xytimestampSeconds(movementTransitionIdx(jj))+3  ],[ -5+offset -5+offset ], 'Color','green');
%             scatter( xytimestampSeconds(movementTransitionIdx(jj)), -5+offset, 'xk' )
%             %
%             lastTime = xytimestampSeconds(movementTransitionIdx(jj));
%         end
%     end
%     %
%     offset = rand(1);
%     line([ xytimestampSeconds(end-179) xytimestampSeconds(end)  ],[ -4+offset -4+offset ], 'Color','magenta');
%     scatter( xytimestampSeconds(end)-3, -4+offset, 'xk' );
%
axis tight;
ylim([ -2 60 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
title(['trial ' num2str(ii) ])
% time by position
subplot(2,2,3);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
% speed by position
subplot(2,2,4);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [smoothSpeed(:), smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');end
%    print( [ '~/data/da5_speeds_trial-' num2str(ii) '_.png'],'-dpng','-r200');
clf(1);
%    drawnow;
subplot(2,2,3);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('hsv');
colorbar;
title('position by time')
subplot(2,2,4);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [smoothSpeed(:), smoothSpeed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(2,2,4);
hold off;
x = xpos;
y = ypos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed')
speed = calculateSpeed( xrpos, yrpos, 1.5, 2.6, 29.97);
xpos=xrpos;
ypos=yrpos;
figure%(1);
subplot(2,2,1:2);
hold off;
plot( xytimestampSeconds, speed );
hold on;
axis tight;
ylim([ -5 80 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
subplot(2,2,3);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
figure%(1);
subplot(2,2,1:2);
hold off;
plot( xytimestampSeconds, speed );
hold on;
axis tight;
ylim([ -5 80 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
%title(['trial ' num2str(ii) ])
% time by position
subplot(2,2,3);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(2,2,4);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
figure%(1);
subplot(2,3,1:3);
hold off;
plot( xytimestampSeconds, speed );
hold on;
axis tight;
ylim([ -5 80 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
%title(['trial ' num2str(ii) ])
% time by position
subplot(2,2,4);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(2,2,5);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(2,3,6);
histogram(speed,50);
title('speed distribution');
xlabel('speed (cm/s)');
ylabel('count');
figure%(1);
subplot(2,3,1:3);
hold off;
plot( xytimestampSeconds, speed );
hold on;
axis tight;
ylim([ -5 80 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
%title(['trial ' num2str(ii) ])
% time by position
subplot(2,2,4);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(2,3,5);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(2,3,6);
histogram(speed,50);
title('speed distribution');
xlabel('speed (cm/s)');
ylabel('count');
figure%(1);
subplot(2,3,1:3);
hold off;
plot( xytimestampSeconds, speed );
hold on;
axis tight;
ylim([ -5 80 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
%title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,4);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(2,3,5);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(2,3,6);
histogram(speed,50);
title('speed distribution');
xlabel('speed (cm/s)');
ylabel('count');
figure%(1);
subplot(2,3,1:3);
hold off;
plot( xytimestampSeconds, speed );
hold on;
axis tight;
ylim([ -5 80 ]); % ylim([ -20 180 ]);
xlabel('time (s)');
ylabel('speed (cm/s)');
%title(['trial ' num2str(ii) ])
% time by position
subplot(2,3,4);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [xytimestampSeconds(:), xytimestampSeconds(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by time')
% speed by position
subplot(2,3,5);
hold off;
x = xrpos;
y = yrpos;
z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap('jet');
colorbar;
title('position by speed');
subplot(2,3,6);
histogram(speed,1:100);
title('speed distribution');
xlabel('speed (cm/s)');
ylabel('count');
cellPosAll = zeros(size(spiketimes));
cellSpeedAll = cellPosAll;
for ii=1:length(spiketimes)
tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
if ~isempty(tempIdx)
cellPosAll(ii)=xylinearized(tempIdx);
cellSpeedAll(ii) = speed(tempIdx);
end
end
cellPosX = zeros(size(spiketimes));
cellPosY = zeros(size(spiketimes));
cellSpeedAll = cellPosAll;
for ii=1:length(spiketimes)
tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
if ~isempty(tempIdx)
cellPosX(ii)=xrpos(tempIdx);
cellPosY(ii)=yrpos(tempIdx);
cellSpeedAll(ii) = speed(tempIdx);
end
end
speedThreshold = 9; %9; % cm/s
speedMask = cellSpeed>speedThreshold;
cellSpeed = cellPosX;
cellPosX = zeros(size(spiketimes));
cellPosY = cellPosX
cellSpeed = cellPosX;
for ii=1:length(spiketimes)
tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
if ~isempty(tempIdx)
cellPosX(ii)=xrpos(tempIdx);
cellPosY(ii)=yrpos(tempIdx);
cellSpeed(ii) = speed(tempIdx);
end
end
speedThreshold = 9; %9; % cm/s
speedMask = cellSpeed>speedThreshold;
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMask), cellPosY(plotMask) )
plotMask = speedMask && (cellNumber==1);
plotMask = speedMask' && (cellNumber==1);
plotMask = (cellSpeed>speedThreshold) && (cellNumber==1);
plotMask = (cellSpeed>speedThreshold) && (cellNumber==1)';
plotMask = (cellSpeed>speedThreshold) .* (cellNumber==1);
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMask), cellPosY(plotMask) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==1));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==2));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==3));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==4));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
max(cellNumber)
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==5));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==6));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
speedThreshold = 15; %9; % cm/s
speedMask = cellSpeed>speedThreshold;
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==6));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==1));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==2));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==3));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==4));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==5));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==6));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
[ ~, spiketimes, spikeheader, ~, cellNumber ]=ntt2mat([ dir 'TT6recut.NTT' ]);
spiketimesSeconds = (spiketimes-xytimestamps(1))/1e6;
cellPosX = zeros(size(spiketimes));
cellPosY = cellPosX;
cellSpeed = cellPosX;
for ii=1:length(spiketimes)
tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
if ~isempty(tempIdx)
cellPosX(ii)=xrpos(tempIdx);
cellPosY(ii)=yrpos(tempIdx);
cellSpeed(ii) = speed(tempIdx);
end
end
% simple speed filter hack
speedThreshold = 15; %9; % cm/s
speedMask = cellSpeed>speedThreshold;
max(cellNumber)
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==1));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==2));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==3));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==4));
figure; plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
max(cellNumber)
figure;
for nn=1:4
plotMaskIdxs = find((cellSpeed>speedThreshold) .* (cellNumber==nn));
subplot(2,2,nn);
plot(xrpos,yrpos); hold on; scatter( cellPosX(plotMaskIdxs), cellPosY(plotMaskIdxs) )
end
makeFilters;
swrThreshold = mean(swrLfp) + ( 3  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
