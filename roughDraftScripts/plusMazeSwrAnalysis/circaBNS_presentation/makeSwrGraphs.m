% a new space to ask questions
newDA10ScriptAggregator;

% bucketTime
% leaveMazeToBucket  leaveBucketToMaze    
% leaveBucketToMaze  trialStartAction     preRunSwrs
% leaveBucketToMaze  trialCompleted       swrsPreAndRun
% leaveBucketToMaze  leaveMazeToBucket    wholeMazeTimeSwrCounts allMazeTimes
% trialStartAction   trialCompleted       mazeRunSwrCounts
% trialStartAction   leaveMazeToBucket    runToRewardSwrCounts
% trialCompleted     leaveMazeToBucket    


recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
%% over days, how does sharp wave ripple production vary while the rat is on the maze?
% view unrotated
figure; hold on;
for ii=1:round(length(recDays))
  hold on; scatter( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 'filled' ); alpha(.01);
end; axis square;

% % test adjustments to  the xy positions
% figure; hold on;
% for ii=1:length(recDays)  % the camera moves.
%     [ xx, yy]=rotateXYPositions( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 327, 239, 45, 395, 400 ); 
%      plot( xx, yy );
% end

%adjust the xy positions
for ii=1:length(recDays)  % the camera moves.
    [agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos]=rotateXYPositions( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos,  327, 239, 45, 395, 400 ); 
    [agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos]=rotateXYPositions( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos,  327, 239, 45, 395, 400 ); 
end

figure; hold on;
for ii=1:round(length(recDays))
    hold on; plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos );
end
for ii=1:round(length(recDays))
    hold on; scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos );
end









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






% construct the needed data structure
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


% 600 px / 218 cm  => 2.75
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






figure;
subplot(3,1,1); 
yy=trialSwr;%  mean(swrRateAll,2); 
xx=1:78; plot(xx,yy); axis tight; %set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ) ; scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
title('total SWR')
line([ 1.5 1.5 ], [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 8.5 8.5 ], [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 17.5 17.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 25.5 25.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 34.5 34.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 43.5 43.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 51.5 51.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 59.5 59.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 68.5 68.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
subplot(3,1,2);
yy=trialOcc;%  mean(swrRateAll,2); 
xx=1:78; plot(xx,yy); axis tight; %set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ) ; scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
title('total time')
line([ 1.5 1.5 ], [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 8.5 8.5 ], [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 17.5 17.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 25.5 25.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 34.5 34.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 43.5 43.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 51.5 51.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 59.5 59.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 68.5 68.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
subplot(3,1,3);
yy=trialSwr./trialOcc;%  mean(swrRateAll,2); 
xx=1:78; plot(xx,yy); axis tight; % set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ) ; scatter( xx(oob>0),yy(oob>0), 'o' ) ;  scatter( xx(bee>0),yy(bee>0), '>' ) ;
title('SWR rate')
line([ 1.5 1.5 ], [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 8.5 8.5 ], [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 17.5 17.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 25.5 25.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 34.5 34.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 43.5 43.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 51.5 51.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 59.5 59.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);
line([ 68.5 68.5 ],  [ 0 max(yy) ], 'Color', [ .5 .5 .5 ]);






dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   trialSwr./trialOcc, dd, 'notch','on'); xlabel('training session'); title('swr rate per training session'); ylabel('swr rate (events/s)')

dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   trialSwr, dd, 'notch','on'); xlabel('training session'); title('swr events per training session'); ylabel('swr events (n)')

dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   trialOcc, dd, 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')

dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
figure; boxplot(   avgVel, dd, 'notch','on'); xlabel('training session'); title('avg vel. per training session'); ylabel('avg vel. (cm/s)')

temp=grpstats(err==0, dd);
figure; plot( 1:9, temp(2:10)); ylim([0 1]); xlabel('training session'); title('proportion error trials per training session'); ylabel('fraction')


figure; boxplot(trialSwr,err, 'notch' , 'on')


err=[]; for ii=1:length(perTrial); err=[err perTrial(ii).error];end;
figure; boxplot(   trialSwr./trialOcc, err, 'notch','on'); xlabel('training session'); title('swr rate X error'); ylabel('swr rate (events/s)')
[ h, p ] = ttest2( xx(err>0), xx(err==0) )

oob=[]; for ii=1:length(perTrial); oob=[oob perTrial(ii).outOfBounds ];end;
figure; boxplot(   trialSwr./trialOcc, oob, 'notch','on'); xlabel('training session'); title('swr rate X error'); ylabel('swr rate (events/s)')
[ h, p ] = ttest2( xx(oob>0), xx(oob==0) )


dd=[]; for ii=1:length(perTrial); dd=[dd perTrial(ii).day];end;
elapsedDays = dd;
elapsedDays(dd==9)=13;
elapsedDays(dd==8)=11;
elapsedDays(dd==7)=9;
elapsedDays(dd==6)=8;
elapsedDays(dd==5)=7;
figure; boxplot(   trialSwr./trialOcc, elapsedDays, 'notch','on'); xlabel('training session'); title('swr rate per training session'); ylabel('swr rate (events/s)')

figure; scatter3( dd, trialSwr, avgVel )


oo=[0.0755953173	0.7525117559	0.1080561077	0.1056959335	1.0458694078	0.7657590247	0.2190504327	0.0819567937	0.1411497708;...
0.05920556	0.0412849563	0.2906910102	0.1263795786	0.4197799059	0.1789979215	0.0407347347	0.1173110457	0.0228512585;...
0.0215809559	0.3910040557	0.1759869778	0.0304241343	0.7038002135	0.9448457771	0.1090449963	0.1399182743	0.1141111821;...
0.0207419955	0.0484668444	0.0234776552	0.3979911076	0.7658229962	0.7541022121	0.483193891	0.0185731063	0.1385297309;...
0.0240213868	0.3943781671	0.0412052469	0.1562805318	0.645000291	1.4973945925	0.2933405698	0.0323511044	0.2715005787;...
0.0080954204	0.1341915883	0.2290080482	0.0735777466	0.0554310266	0.1351285696	0.0631484272	0.010615773	0.0342563272;...
0.0885521913	0.3177669743	0.0413078435	0.0566099972	1.8078891922	0.0887117111	0.3053540195	0.0136992009	0.3741284784;...
0.0111581059	0.2244848099	0.1447200689	0.0802588217	0.1300435446	1.0180114037	0.25	0.0901728407	0.3035982407];



[p,tbl,stats] = anova1(oo)

return;





%% over days, how does sharp wave ripple production vary while the rat is on the maze?
% construct the needed data structure
trialIdx=0;
for ii=1:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
        
        startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %
        endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj), 1 );
        disp(num2str(endIdx-startIdx))
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


%% visualize rat paths
gcf(1)=figure;
for ii=1:length(perTrial);
    plot( perTrial(ii).xpos, perTrial(ii).ypos);
    axis([ 0 750 0 750])
%    print( gcf(1), [ '~/Desktop/' 'trajectory_auto_' num2str(ii)  '.png'],'-dpng','-r200');
pause(.5);
end



figure; subplot(1,5,2); hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.1);
end; xlim([0 1500]);
 subplot(1,5,3); hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
end;xlim([0 1500]);



% 600 px / 218 cm  => 2.75
binSize = 45; % 55 px
bins = 0:binSize:1500;
occupancyAll=[];
swrAll=[];
swrRateAll=[];
bee=[]; err=[]; oob=[];
for ii=1:length(perTrial)
    freqOcc=histcounts( perTrial(ii).xylinearized, bins );
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
end


figure; colormap(build_NOAA_colorgradient);%  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);  colormap(newColorMap);
subplot(7,4,1:4:6*4); %imagesc(occupancyAll); 
hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).xylinearized./binSize,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.1);
end; xlim([0 1500/binSize]); set(gca, 'Ydir', 'reverse')
title('occupancy')
subplot(7,4,2:4:6*4); imagesc(swrAll);  
hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).swrLinearized./binSize,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
end;xlim([0 1500/binSize]); set(gca, 'Ydir', 'reverse')
title('swr freq. X space')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
subplot(7,4,25); plot(mean(occupancyAll)); axis tight;
subplot(7,4,26); plot(mean(swrAll));  axis tight;
subplot(7,4,27); plot(mean(swrRateAll)); axis tight;
subplot(7,4,4:4:6*4); xx=mean(swrRateAll,2); yy=1:78; plot(xx,yy); axis tight; set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0),yy(err>0), 'o' ) ; scatter( xx(oob>0),yy(oob>0), '*' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;

