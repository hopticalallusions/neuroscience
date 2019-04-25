
%set up the "agg" variable
da5agg;
% OR
% load( '/Users/andrewhowe/src/MATLAB/defaultFolder/agg_da5_csc6swr.mat' , 'agg')

%set up the record days variable
recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29'  'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %'aug30'

% view unrotated
figure; hold on;
for ii=1:round(length(recDays))
  hold on; plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos );
end
legend('aug22', 'aug23', 'aug24', 'aug25', 'aug26', 'aug27', 'aug28', 'aug29' , 'aug31' ,'sep1' ,'sep2', 'sep6', 'sep7', 'sep8');

ii=10; %  sep1
agg.(recDays{ii}).xpos = agg.(recDays{ii}).xpos-(397-295);
agg.(recDays{ii}).ypos = agg.(recDays{ii}).ypos-(285-266);
agg.(recDays{ii}).swrXpos = agg.(recDays{ii}).swrXpos-(397-295);
agg.(recDays{ii}).swrYpos = agg.(recDays{ii}).swrYpos-(285-266);

ii=11; %  sep2
agg.(recDays{ii}).xpos = agg.(recDays{ii}).xpos-(410-313);
agg.(recDays{ii}).ypos = agg.(recDays{ii}).ypos-(259-238);
agg.(recDays{ii}).swrXpos = agg.(recDays{ii}).swrXpos-(410-313);
agg.(recDays{ii}).swrYpos = agg.(recDays{ii}).swrYpos-(259-238);

ii=12; %  sep6
agg.(recDays{ii}).xpos = agg.(recDays{ii}).xpos-(387-295);
agg.(recDays{ii}).ypos = agg.(recDays{ii}).ypos-(301-266);
agg.(recDays{ii}).swrXpos = agg.(recDays{ii}).swrXpos-(387-295);
agg.(recDays{ii}).swrYpos = agg.(recDays{ii}).swrYpos-(301-266);

ii=13; %  sep7
agg.(recDays{ii}).xpos = agg.(recDays{ii}).xpos-(399-312);
agg.(recDays{ii}).ypos = agg.(recDays{ii}).ypos-(247-241);
agg.(recDays{ii}).swrXpos = agg.(recDays{ii}).swrXpos-(399-312);
agg.(recDays{ii}).swrYpos = agg.(recDays{ii}).swrYpos-(247-241);

ii=14; %  sep8
agg.(recDays{ii}).xpos = agg.(recDays{ii}).xpos-(395-312);
agg.(recDays{ii}).ypos = agg.(recDays{ii}).ypos-(245-241);
agg.(recDays{ii}).swrXpos = agg.(recDays{ii}).swrXpos-(395-312);
agg.(recDays{ii}).swrYpos = agg.(recDays{ii}).swrYpos-(245-241);

% there's this weird situation where the start arm seems to stretch further
% on different days. I don't know what to make of it because the rest of
% the maze seems to be relatively well aligned after applying the above
% translations.

 

 for ii=1:round(length(recDays))
     agg.(recDays{ii}).xpos = agg.(recDays{ii}).xpos-(-294);
     agg.(recDays{ii}).ypos = agg.(recDays{ii}).ypos-(86);
     %agg.(recDays{ii}).swrXpos = agg.(recDays{ii}).swrXpos+(-294);
     %agg.(recDays{ii}).swrYpos = agg.(recDays{ii}).swrYpos+(86);
 end

figure; hold on;
for ii=1:round(length(recDays))
    hold on; plot( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos );
end
legend('aug22', 'aug23', 'aug24', 'aug25', 'aug26', 'aug27', 'aug28', 'aug29' , 'aug31' ,'sep1' ,'sep2', 'sep6', 'sep7', 'sep8');


%adjust the xy positions
for ii=1:length(recDays)  
    [agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos]=rotateXYPositions( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 312, 235, -50, 380, 260 ); 
    [agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos]=rotateXYPositions( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, 312, 235, -50, 380, 260 ); 
end




figure; hold on;
for ii=1:round(length(recDays))
    hold on; plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos );
end
for ii=1:round(length(recDays))
    hold on; scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos );
end
legend('aug22', 'aug23', 'aug24', 'aug25', 'aug26', 'aug27', 'aug28', 'aug29' , 'aug31' ,'sep1' ,'sep2', 'sep6', 'sep7', 'sep8');

figure; hold on;
for ii=1:round(length(recDays))
end

% a new space to ask questions

% bucketTime
% leaveMazeToBucket  leaveBucketToMaze    
% leaveBucketToMaze  trialStartAction     preRunSwrs
% leaveBucketToMaze  trialCompleted       swrsPreAndRun
% leaveBucketToMaze  leaveMazeToBucket    wholeMazeTimeSwrCounts allMazeTimes
% trialStartAction   trialCompleted       mazeRunSwrCounts
% trialStartAction   leaveMazeToBucket    runToRewardSwrCounts
% trialCompleted     leaveMazeToBucket    



for ii=1:length(recDays)

    [angle, radius] = cart2pol( agg.(recDays{ii}).xpos-270, agg.(recDays{ii}).ypos-300 ); angle=angle*180/pi+180;
    rad=radius;
    agg.(recDays{ii}).xylinearized(find((rad <= 25))) =  120; % Center Point                                                                                     px / cm  + offset
    agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 25) .* ( angle >  45 ) .* ( angle <= 135 )))/(300/100) + 225; % South
    agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 25) .* ( angle > 135 ) .* ( angle <= 225 )))/(225/100) + 330; % East
    agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 25) .* ( angle > 225 ) .* ( angle <= 315 )))/(260/106) + 125; % North  ; invert this so the rat starts at x=0
    agg.(recDays{ii}).xylinearized(find((rad > 25) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 25) .* ( angle > 315 )  + ( angle <=  45 )))/(250/106)) ; % West
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





%% over days, how does sharp wave ripple production vary while the rat is on the maze?
% construct the needed data structure
clear perTrial;
trialIdx=0;
rat='da5';
trial = 1;
day = 1;
for ii=3:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat = rat;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
%         if jj>1
%             startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialStartAction(jj) ) , 1 );
        % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).sugarConsumeTimes(jj), 1 );
       % endIdx = startIdx + (20*30);
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
        perTrial(trialIdx).swrTimes         = agg.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos          = agg.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos          = agg.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized    = agg.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed         = agg.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = agg.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed  = agg.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial       = agg.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error            = agg.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds      = agg.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe            = agg.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline          = agg.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed    = agg.(recDays{ii}).sugarConsumed(jj);
        %perTrial(trialIdx).wasTeleported   = agg.(recDays{ii}).wasTeleported(jj);
    end
end

% 600 px / 218 cm  => 2.75
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

%pxPerCm=2.535;
figure; colormap(build_NOAA_colorgradient);%  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);  colormap(newColorMap);
subplot(7,4,1:4:6*4); %imagesc(occupancyAll); 
hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.01);
end; xlim([0 450]); set(gca, 'Ydir', 'reverse'); axis tight;
title('occupancy')
subplot(7,4,2:4:6*4); %imagesc(swrAll);  
hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
end;xlim([0 450]); set(gca, 'Ydir', 'reverse'); axis tight;
title('swr freq. X space')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
subplot(7,4,25); hold on; plot(mean(occupancyAll(err==0,:)),'g'); plot(mean(occupancyAll(err==1,:)),'r'); plot(mean(occupancyAll(oob==0,:)),'b'); axis tight; % plot(mean(occupancyAll(bee==1,:)),'m'); plot(mean(occupancyAll), 'k'); plot(mean(occupancyAll)); axis tight;
subplot(7,4,26); hold on; plot(mean(swrAll(err==0,:)),'g'); plot(mean(swrAll(err==1,:)),'r'); plot(mean(swrAll(oob==0,:)),'b'); axis tight; % plot(mean(swrAll(bee==1,:)),'m'); plot(mean(swrAll), 'k'); plot(mean(swrAll));  axis tight;
subplot(7,4,27); hold on; plot(mean(swrRateAll(err==0,:)),'g'); plot(mean(swrRateAll(err==1,:)),'r'); plot(mean(swrRateAll(oob==0,:)),'b'); axis tight; % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
subplot(7,4,4:4:6*4); hold off;
xx=trialSwr./trialOcc; %mean(swrRateAll,2); 
yy=1:length(perTrial); plot(xx,yy); axis tight; set(gca, 'Ydir', 'reverse')
hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ); scatter( xx(oob>0),yy(oob>0), 'o' ); scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
title('SWR Rate')



probe=[]; for ii=1:length(perTrial); probe=[probe perTrial(ii).probe];end;


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
figure; plot( temp); ylim([0 1]); xlabel('training session'); title('proportion error trials per training session'); ylabel('fraction')


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





































































return;


%% words
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





 


for ii=1:length(recDays)

    [angle, radius] = cart2pol( agg.(recDays{ii}).xpos-354, agg.(recDays{ii}).ypos-327 ); angle=angle*180/pi+180;
    rad=radius;
    offset = 380;
    rad(find(( angle >  45 ).*( angle <= 135 ))) = rad(find(( angle >  45 ).*( angle <= 135 ))) + 3*offset;   % South
    rad(find(( angle > 135 ).*( angle <= 225 ))) = rad(find(( angle > 135 ).*( angle <= 225 ))) + 2*offset; % East
    rad(find(( angle > 225 ).*( angle <= 315 ))) = offset - rad(find(( angle > 225 ).*( angle <= 315 ))); % North  ; invert this so the rat starts at x=0
    rad(find(( angle > 315 )+( angle <=  45 ))) = rad(find(( angle > 315 )+( angle <=  45 ))) + offset; % West
    agg.(recDays{ii}).xylinearized=rad;
    
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



%% construct the needed data structure
trialIdx=0;
for ii=1:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
        
        startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialStartAction(jj) ) , 1 );
        tempOffset = 0;
        %
        distErrEntry = sqrt(( 506 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 323 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        distRewEntry = sqrt(( 194 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 368 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        distEscEntry = sqrt(( 347 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 186 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        %
        distPlatformA = sqrt(( 293 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 429 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        distPlatformB = sqrt(( 422 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 447 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        distPlatformC = sqrt(( 275 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 263 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        distPlatformD = sqrt(( 416 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 255 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
        %
        distFlag = (  9*agg.pxPerCm < distErrEntry ) && (9*agg.pxPerCm < distRewEntry) && (9*agg.pxPerCm < distEscEntry)   && (9*agg.pxPerCm < distPlatformA) && (9*agg.pxPerCm < distPlatformB)&& (9*agg.pxPerCm < distPlatformC)&& (9*agg.pxPerCm < distPlatformD);
        %
        while (  (startIdx+tempOffset <= length(agg.(recDays{ii}).xpos) ) && ( agg.(recDays{ii}).xytimestampSeconds(startIdx+tempOffset) < agg.(recDays{ii}).trialCompleted(jj) )  && distFlag )
            tempOffset = tempOffset + 1;
            distErrEntry = sqrt(( 251 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 323 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            distRewEntry = sqrt(( 194 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 368 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            distEscEntry = sqrt(( 347 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 186 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            %
            distPlatformA = sqrt(( 293 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 429 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            distPlatformB = sqrt(( 422 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 447 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            distPlatformC = sqrt(( 275 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 263 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            distPlatformD = sqrt(( 416 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 255 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
            %
            distFlag = (  9*agg.pxPerCm < distErrEntry ) && (9*agg.pxPerCm < distRewEntry) && (9*agg.pxPerCm < distEscEntry)   && (9*agg.pxPerCm < distPlatformA) && (9*agg.pxPerCm < distPlatformB)&& (9*agg.pxPerCm < distPlatformC)&& (9*agg.pxPerCm < distPlatformD);
%             if ( ( agg.(recDays{ii}).xpos(startIdx+tempOffset) > 300  ) && ( agg.(recDays{ii}).ypos(startIdx+tempOffset) > 400  ) )
%                 disp( [ num2str(ii) ' . ' num2str(jj) ' start  ' num2str(startIdx) '  time  ' num2str(agg.(recDays{ii}).xytimestampSeconds(startIdx)) ]);
%             end
        end
        %
        endIdx = startIdx + tempOffset;   %( agg.(recDays{ii}).xytimestampSeconds < agg.(recDays{ii}).leaveMazeToBucket(jj) )
        %disp(num2str(endIdx-startIdx))
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


%% new fancy linearized plotting code

% figure; hold on;
% for ii=1:length(perTrial)
%     plot( perTrial(ii).xylinearized)
% end
% for ii=1:length(perTrial)
%     plot( perTrial(ii).xylinearized)
% end

% 600 px / 218 cm  => 2.75
binSize = 45; % 55 px
bins = 0:binSize:1500;
occupancyAll=[];
swrAll=[];
swrRateAll=[];
for ii=1:length(perTrial)
    freqOcc=histcounts( perTrial(ii).xylinearized, bins );
    occupancyAll = [ occupancyAll ; freqOcc ];
    freqSwr=histcounts( perTrial(ii).swrLinearized, bins );
    swrAll = [ swrAll ; freqSwr ];
    tIdxs = find(freqOcc);
    tResult = freqSwr(tIdxs)./freqOcc(tIdxs);
    freqSwr(tIdxs) = tResult;
    swrRateAll = [ swrRateAll ; freqSwr ];
end

colormap('default');  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);
figure;  colormap(newColorMap);
subplot(7,4,1:4:6*4); imagesc(occupancyAll); title('occupancy')
subplot(7,4,2:4:6*4); imagesc(swrAll);  title('swr freq. X space')
subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
subplot(7,4,25); plot(mean(occupancyAll)); axis tight;
subplot(7,4,26); plot(mean(swrAll));  axis tight;
subplot(7,4,27); plot(mean(swrRateAll)); axis tight;
subplot(7,4,4:4:6*4); plot(mean(swrRateAll,2), 1:78); axis tight; set(gca, 'Ydir', 'reverse')

    

figure; hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled');
end

figure; hold on;
for ii=1:length(perTrial)
    scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.1);
end





bins=0:7:100;
xyfreq=[];
swrfreq=[];
xyifreq=[];
swrifreq=[];
for ii=1:length(perTrial)
    [ff]=histcounts( perTrial(ii).speed, bins);
    xyfreq = [ xyfreq ; ff ];
    [ff]=histcounts( perTrial(ii).swrSpeed, bins);
    swrfreq = [ swrfreq ; ff ];
    [ff]=histcounts( perTrial(ii).lagSpeed, bins);
    xyifreq = [ xyifreq ; ff ];
    [ff]=histcounts( perTrial(ii).swrLagSpeed, bins);
    swrifreq = [ swrifreq ; ff ];
end
figure;
plot( bins(1:14), (sum(xyfreq))./sum(sum(xyfreq)) );
hold on;
plot( bins(1:14), (sum(swrfreq))./sum(sum(swrfreq)) );

plot( bins(1:20), cumsum(xyifreq)./sum(sum(xyifreq)) );
plot( bins(1:20), cumsum(swrifreq)./sum(sum(swrifreq)) );




xpos = agg.sept25.xpos;
ypos = agg.sept25.ypos;
xytimestampSeconds = agg.sept25.xytimestampSeconds;

instantSpeed = zeros(size(xpos));
for jj=2:length(xpos)-1
	% px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
    instantSpeed(jj) = sqrt( ( ypos(jj-1) - ypos(jj+1) ).^2 + ( xpos(jj-1) - xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
end


lagSpeed = zeros(size(xpos));
for jj=31:length(xpos)-31
	% px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
    lagSpeed(jj) = sqrt( ( ypos(jj-29) - ypos(jj+30) ).^2 + ( xpos(jj-30) - xpos(jj+29) ).^2 ) * (1/60) * 1/2.75 * 29.97;
end


spd = calculateSpeed( xpos, ypos, 0.2, 2.75, 29.97 );

spd = calculateSpeed( xpos, ypos, 1, 2.75, 29.97 );

figure; subplot(3,1,1); plot(xytimestampSeconds, instantSpeed); hold on; plot(xytimestampSeconds,spd); xlim([ 558 634]); ylim([0 90]); plot(xytimestampSeconds,dxy);
xlim([ 563 594]); ylim([0 30]);
plot(xytimestampSeconds, lagSpeed);
[aa,rr]=cart2pol( xpos-354, ypos-327 );  aa=aa*180/pi+180;
subplot(3,1,2); plot(xytimestampSeconds, rr); xlim([ 563 574]);
subplot(3,1,3); plot(xytimestampSeconds, aa); xlim([ 563 574]);

subplot(3,1,1); plot(xytimestampSeconds,spd);
xlim([ 563 630]); subplot(3,1,2); xlim([ 563 630]); subplot(3,1,3); xlim([ 563 630]);


    dx = zeros(size(xpos));
    dy = zeros(size(ypos));
    for jj=2:length(xpos)-1
        dy(jj)=( ypos(jj-1) - ypos(jj+1) );
        dx(jj)=( xpos(jj-1) - xpos(jj+1) );
    end
    dxs=conv(dx,ones(1,8)/8, 'same');
    dys=conv(dy,ones(1,8)/8, 'same');
    dxy = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;
    
    
    lagXy = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97
    
    
    
figure; scatter( dx, dy, 'ko', 'filled'); alpha(.05)



%% old 2d plotting code

figure; 
colormap('default');
newColorMap = [ 1 1 1 ; colormap ];
binResolution = 40;
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).beeline
            subplot(2,4,1);
            plot( perTrial(ii).xpos, perTrial(ii).ypos ); hold on;
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 9, 'o', 'filled', 'MarkerEdgeColor', [ 0 0 0 ], 'MarkerFaceColor', [ .1 .7 .9 ], 'MarkerFaceAlpha', .9 );
            xlim([0 750]); ylim([0 750]);
        else
            subplot(2,4,3);
            plot( perTrial(ii).xpos, perTrial(ii).ypos ); hold on;
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 9, 'o', 'filled', 'MarkerEdgeColor', [ 0 0 0 ], 'MarkerFaceColor', [ .1 .7 .9 ], 'MarkerFaceAlpha', .9 );
            xlim([0 750]); ylim([0 750]);
        end
    end
end
xyHist = twoDHistogram( perTrial(1).xpos, perTrial(1).ypos, binResolution , 750, 750 );
swrXyHist = twoDHistogram( perTrial(1).swrXpos, perTrial(1).swrYpos, binResolution , 750, 750 );
beeXyHist = zeros(size(xyHist));
beeSwrXyHist = zeros(size(swrXyHist));
sloXyHist = zeros(size(xyHist));
sloSwrXyHist = zeros(size(swrXyHist));
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).beeline
            beeXyHist = beeXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 750, 750 );
            beeSwrXyHist = beeSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 750, 750 );
        else
            sloXyHist = sloXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 750, 750 );
            sloSwrXyHist = sloSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 750, 750 );
        end
    end
end
beeXyHist = beeXyHist./29.97;  % convert to seconds
% excludedIdx = find( beeXyHist < 1 );
% beeSwrXyHist(excludedIdx)=-1;
% beeXyHist(excludedIdx)=1;
samplingMask =  beeXyHist > 1 ;
subplot(2,4,2);
imagesc(flipud(beeXyHist));
colormap(newColorMap);
title('xyHeat'); colorbar;
subplot(2,4,5);
imagesc(flipud(beeSwrXyHist));
colormap(newColorMap);
title('swrHeat'); colorbar;
subplot(2,4,6);
imagesc(flipud((beeSwrXyHist./beeXyHist).*samplingMask));
title('swrRate'); colorbar;
%
sloXyHist = sloXyHist./29.97;  % convert to seconds
% excludedIdx = find( sloXyHist < 1 );
% sloSwrXyHist(excludedIdx)=-1;
% sloXyHist(excludedIdx)=1;
samplingMask =  beeXyHist > 1 ;
subplot(2,4,4);
imagesc(flipud(sloXyHist));
colormap(newColorMap);
title('xyHeat'); colorbar;
subplot(2,4,7);
imagesc(flipud(sloSwrXyHist));
colormap(newColorMap);
title('swrHeat'); colorbar;
subplot(2,4,8);
imagesc(flipud((sloSwrXyHist./sloXyHist).*samplingMask));
title('swrRate'); colorbar;





%% figure out how far the rat position data starts from the "start" position.
ds=[];
for ii=2:length(perTrial)
    distStart = sqrt(( 49 - perTrial(ii).xpos(1) )^2 + ( 465 - perTrial(ii).ypos(1) )^2 );
    disp( [ 'day ' num2str(perTrial(ii).day) ' trial ' num2str(perTrial(ii).trial) ' dist ' num2str(distStart)   ] );
    ds=[ ds distStart ];
end
figure; histogram(ds)



figure; plot( perTrial(1).xpos, perTrial(1).ypos,'k'); hold on;
for ii=1:length(perTrial);
    plot( perTrial(ii).xpos, perTrial(ii).ypos, 'k');
end


%% visualize rat paths
gcf(1)=figure;
for ii=1:length(perTrial);
    plot( perTrial(ii).xpos, perTrial(ii).ypos);
    axis([ 0 750 0 750])
    print( gcf(1), [ '~/Desktop/' 'trajectory_auto_' num2str(ii)  '.png'],'-dpng','-r200');
end






hold on; ii=3;plot(perTrial(ii).xpos-360, perTrial(ii).ypos-335)
[angle, radius]=cart2pol( perTrial(ii).xpos-360, perTrial(ii).ypos-335 );









distErrEntry = sqrt(( 506 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 323 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );

ii=10; figure; plot(agg.(recDays{ii}).xpos,agg.(recDays{ii}).ypos);

for ii=2:length(recDays)
    for jj = 1:length(agg.(recDays{ii}).leaveBucketToMaze)
    startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
    offset = 0;
    distErrEntry = sqrt(( 354 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 470 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
    %dd=[];
    while ( distErrEntry > 30 ) &&  ( agg.(recDays{ii}).xytimestampSeconds(startIdx+offset) < agg.(recDays{ii}).leaveMazeToBucket(jj) )
        offset = offset + 1;
        distErrEntry = sqrt(( 354 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 470 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
        %dd(offset) = distErrEntry;
    end
    disp( [ 'day ' recDays{ii} ' trial ' num2str( jj ) ' time ' num2str( agg.(recDays{ii}).xytimestampSeconds(startIdx+offset)-1 )  ] );
    end
end

figure; plot( agg.(recDays{ii}).xytimestampSeconds(startIdx:startIdx+offset-1), dd);




ii=2
plot( agg.(recDays{ii}).xpos(startIdx:startIdx+offset+9000), agg.(recDays{ii}).ypos(startIdx:startIdx+offset+9000) )



figure;


figure; 
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).beeline
            subplot(2,2,1); hold on;
            plot( perTrial(ii).xpos, perTrial(ii).ypos );
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 'ok' );
            xlim([0 600]); ylim([0 500]);
        else
            subplot(2,2,2); hold on;
            plot( perTrial(ii).xpos, perTrial(ii).ypos );
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 'ok');
            xlim([0 600]); ylim([0 500]);
        end
    end
end
xyHist = twoDHistogram( perTrial(1).xpos, perTrial(1).ypos, binResolution , 720, 480 );
swrXyHist = twoDHistogram( perTrial(1).swrXpos, perTrial(1).swrYpos, binResolution , 720, 480 );
beeXyHist = zeros(size(xyHist));
beeSwrXyHist = zeros(size(swrXyHist));
sloXyHist = zeros(size(xyHist));
sloSwrXyHist = zeros(size(swrXyHist));
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).beeline
            beeXyHist = beeXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 720, 480 );
            beeSwrXyHist = beeSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 720, 480 );
        else
            sloXyHist = sloXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 720, 480 );
            sloSwrXyHist = sloSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 720, 480 );
        end
    end
end
beeSwrXyHist(beeSwrXyHist<3)=0;
subplot(2,2,3);
imagesc(flipud(beeSwrXyHist./beeXyHist));
colormap(build_NOAA_colorgradient);
 title('beeline')
subplot(2,2,4);
sloSwrXyHist(sloSwrXyHist<3)=0;
imagesc(flipud(sloSwrXyHist./sloXyHist));
colormap(build_NOAA_colorgradient);
title('slow')















figure; 
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).error
            subplot(2,2,1); hold on;
            plot( perTrial(ii).xpos, perTrial(ii).ypos );
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 'ok' );
            xlim([0 600]); ylim([0 500]);
        else
            subplot(2,2,2); hold on;
            plot( perTrial(ii).xpos, perTrial(ii).ypos );
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 'ok');
            xlim([0 600]); ylim([0 500]);
        end
    end
end
xyHist = twoDHistogram( perTrial(1).xpos, perTrial(1).ypos, binResolution , 720, 480 );
swrXyHist = twoDHistogram( perTrial(1).swrXpos, perTrial(1).swrYpos, binResolution , 720, 480 );
beeXyHist = zeros(size(xyHist));
beeSwrXyHist = zeros(size(swrXyHist));
sloXyHist = zeros(size(xyHist));
sloSwrXyHist = zeros(size(swrXyHist));
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).error
            beeXyHist = beeXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 720, 480 );
            beeSwrXyHist = beeSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 720, 480 );
        else
            sloXyHist = sloXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 720, 480 );
            sloSwrXyHist = sloSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 720, 480 );
        end
    end
end
beeSwrXyHist(beeSwrXyHist<3)=0;
subplot(2,2,3);
imagesc(flipud(beeSwrXyHist./beeXyHist));
colormap(build_NOAA_colorgradient);
 title('error')
subplot(2,2,4);
sloSwrXyHist(sloSwrXyHist<3)=0;
imagesc(flipud(sloSwrXyHist./sloXyHist));
colormap(build_NOAA_colorgradient);
title('no error')








figure; 
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).wasTeleported
            subplot(2,2,1); hold on;
            plot( perTrial(ii).xpos, perTrial(ii).ypos );
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 'ok' );
            xlim([0 600]); ylim([0 500]);
        else
            subplot(2,2,2); hold on;
            plot( perTrial(ii).xpos, perTrial(ii).ypos );
            scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, 'ok');
            xlim([0 600]); ylim([0 500]);
        end
    end
end
xyHist = twoDHistogram( perTrial(1).xpos, perTrial(1).ypos, binResolution , 720, 480 );
swrXyHist = twoDHistogram( perTrial(1).swrXpos, perTrial(1).swrYpos, binResolution , 720, 480 );
beeXyHist = zeros(size(xyHist));
beeSwrXyHist = zeros(size(swrXyHist));
sloXyHist = zeros(size(xyHist));
sloSwrXyHist = zeros(size(swrXyHist));
for ii=2:length(perTrial)
    if ~perTrial(ii).probe
        if perTrial(ii).wasTeleported
            beeXyHist = beeXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 720, 480 );
            beeSwrXyHist = beeSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 720, 480 );
        else
            sloXyHist = sloXyHist+twoDHistogram( perTrial(ii).xpos, perTrial(ii).ypos, binResolution , 720, 480 );
            sloSwrXyHist = sloSwrXyHist+twoDHistogram( perTrial(ii).swrXpos, perTrial(ii).swrYpos, binResolution , 720, 480 );
        end
    end
end
beeSwrXyHist(beeSwrXyHist<3)=0;
subplot(2,2,3);
imagesc(flipud(beeSwrXyHist./beeXyHist));
colormap(build_NOAA_colorgradient);
 title('wasTeleported')
subplot(2,2,4);
sloSwrXyHist(sloSwrXyHist<3)=0;
imagesc(flipud(sloSwrXyHist./sloXyHist));
colormap(build_NOAA_colorgradient);
title('no teleport')







figure; 
binResolution = 30;
for ii=1:length(recDays)
    subPlotIdx = 11*floor(ii/6) + mod(ii,6) ;
    xyHist = twoDHistogram( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, binResolution , 720, 480 );
    swrXyHist = twoDHistogram( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, binResolution , 720, 480 );
    subplot(4,5,subPlotIdx);
%    idxsToCancel = find(xyHist(:)./29.97 < 1 );
%    swrXyHistAdj    = swrXyHist;
%    swrXyHistAdj(idxsToCancel) = 0;
    imagesc(flipud(swrXyHist./xyHist));
    colormap(build_NOAA_colorgradient);
    subPlotIdx = subPlotIdx + 5 ;
    subplot(4,5,subPlotIdx);
    x   = agg.(recDays{ii}).xpos';
    y   = agg.(recDays{ii}).ypos';
    z   = zeros(size(x));
    col = agg.(recDays{ii}).xytimestampSeconds';  % This is the color, vary with x in this case.
    surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    %plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 'Color', [.1 .1 .1 .1], 'LineWidth', 1 ); 
    xlim([ 0 720 ]); ylim([ 0 480 ]); hold on;
    scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, 10, 'ok', 'MarkerEdgeAlpha', 0.5 );
end


for ii=1:length(recDays)
 disp( num2str(  11*floor(ii/6) + mod(ii,6) + 5 ));
end




x =  agg.(recDays{ii}).xpos;
y =  agg.(recDays{ii}).ypos;
z =  zeros(size(x));
col =  agg.(recDays{ii}).xytimestampSeconds;  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);

    
    
figure;
    x   = agg.(recDays{ii}).xpos';
    y   = agg.(recDays{ii}).ypos';
    z   = zeros(size(x));
    col = agg.(recDays{ii}).xytimestampSeconds';  % This is the color, vary with x in this case.
    surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
xlim([ 0 720 ]); ylim([ 0 480 ]); hold on;

    scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, 2.5, 'o', 'MarkerEdgeAlpha', 0.2 );

    
    
    
    
    
    
    
    
    
    


% xyHist = twoDHistogram( xposOg, yposOg, 1 , 720, 480 );
% figure; %xyHist(1,1)=0;
% imagesc(flipud(xyHist));
% colormap(build_NOAA_colorgradient); colorbar;
% caxis([-5 25])
% 
% xyHist = twoDHistogram( xpos, ypos, 1 , 720, 480 );
% figure; %xyHist(1,1)=0;
% imagesc(flipud(xyHist));
% colormap(build_NOAA_colorgradient); colorbar;
% caxis([-5 25])


    %figure;
    %subplot(1,3,1); imagesc(flipud(cellXHist)); colormap(build_NOAA_colorgradient); title('speed filtered firing map'); xlabel('x position'); ylabel('y position');
    %subplot(1,3,2); plot( xpos, ypos, 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); xlim([ 0 720 ]); ylim([ 0 480 ]); scatter( xpos( speedFilteredSpikeXyIdxs ), ypos( speedFilteredSpikeXyIdxs ), 10*speed( speedFilteredSpikeXyIdxs ), 'o', 'Filled', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1 ); legend(['cell ' num2str( cellId )] ); title('firing locations'); xlabel('x position'); ylabel('y position');
    %subplot(1,3,3); imagesc(flipud(cellXHist./xyHist)); colormap(build_NOAA_colorgradient); title('firing locations'); xlabel('x position'); ylabel('y position');

    
    
    
    
    
    
% byTrial.day               = [ ];
% byTrial.trial             = [ ];
% byTrial.isSubTrial        = [ ];
% byTrial.error             = [ ];
% byTrial.outOfBounds       = [ ];
% byTrial.probe             = [ ];
% byTrial.beeline           = [ ];
% byTrial.sugarConsumed     = [ ];
% byTrial.wasTeleported     = [ ];
% for ii=1:length(recDays)
%     byTrial.day               = [ byTrial.day            (ii-1)*ones(size(agg.(recDays{ii}).probe)) ];
%     byTrial.trial             = [ byTrial.trial          agg.(recDays{ii}).trial                    ];
%     byTrial.isSubTrial        = [ byTrial.isSubTrial     agg.(recDays{ii}).isSubTrial               ];
%     byTrial.error             = [ byTrial.error          agg.(recDays{ii}).error                    ];
%     byTrial.outOfBounds       = [ byTrial.outOfBounds    agg.(recDays{ii}).outOfBounds              ];
%     byTrial.probe             = [ byTrial.probe          agg.(recDays{ii}).probe                    ];
%     byTrial.beeline           = [ byTrial.beeline        agg.(recDays{ii}).beeline                  ];
%     byTrial.sugarConsumed     = [ byTrial.sugarConsumed  agg.(recDays{ii}).sugarConsumed            ];
%     byTrial.wasTeleported     = [ byTrial.wasTeleported  agg.(recDays{ii}).wasTeleported            ];
% end


% errorEntry.x = 398 ; 307
% rewardEntry.x = 240 ; 166
% wrongWay.x 397 ; 179





% metadata.rat = 'da10';
% metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
% metadata.visualizeAll = true;
% metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
% metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
% metadata.swrLfpFile = 'CSC88.ncs'; % 63, 88, HF; best visual guess unfiltered.   also try 44-47, 52-55 from vta  44 is vta
% metadata.lfpStartIdx = 1;   % round(61.09316*32000);
% metadata.outputDir = [ '/Users/andrewhowe/data/plusMazeEphys/' metadata.rat '/' ];





% old coordinates for various positions before rotation
% 
%         distErrEntry = sqrt(( 447 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 344 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
%         distRewEntry = sqrt(( 245 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 155 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
%         distEscEntry = sqrt(( 431 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 153 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );
%         distLAbysEntry = sqrt(( 212 - agg.(recDays{ii}).xpos(startIdx+tempOffset) )^2 + ( 446 - agg.(recDays{ii}).ypos(startIdx+tempOffset) )^2 );




%     agg.sept13.swrTimes=output.swrPeakTimesDenoise;
%     [angle, radius] = cart2pol( agg.(recDays{ii}).swrXpos-354,  agg.(recDays{ii}).swrYpos-327 ); angle=angle*180/pi+180;
%     %rad = radius;
%     agg.(recDays{ii}).swrxylinearized(find(( angle >  45 ).*( angle <= 135 ))) = agg.(recDays{ii}).swrxylinearized(find(( angle >  45 ).*( angle <= 135 ))) + 980;
%     agg.(recDays{ii}).swrxylinearized(find(( angle > 135 ).*( angle <= 225 ))) = agg.(recDays{ii}).swrxylinearized(find(( angle > 135 ).*( angle <= 225 ))) + 360;
%     agg.(recDays{ii}).swrxylinearized(find(( angle > 225 ).*( angle <= 315 ))) = agg.(recDays{ii}).swrxylinearized(find(( angle > 225 ).*( angle <= 315 ))) + 0;
%     agg.(recDays{ii}).swrxylinearized(find(( angle > 315 )+( angle <=  45 ))) = agg.(recDays{ii}).swrxylinearized(find(( angle > 315 )+( angle <=  45 ))) + 720;
%     agg.(recDays{ii}).swrxylinearized=rad;
    
% end
% 
% 
% ii=8;
% figure; scatter(agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos);
% figure; scatter(agg.(recDays{ii}).xpos, agg.(recDays{ii}).swrYpos);
% 
% 
% ii=2;
% figure; plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos ); hold on; scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos, 'ko' )
% 
% figure; scatter( agg.(recDays{ii}).xylinearized, rand(size(agg.(recDays{ii}).xylinearized)) )
% 
% 
% 
% 
% 
% 
% ii=12;  figure;
% subplot(1,2,1); plot( perTrial(ii).xpos, perTrial(ii).ypos ); hold on; scatter( perTrial(ii).swrXpos, perTrial(ii).swrYpos, '^', 'filled' );
% subplot(1,2,2); scatter( perTrial(ii).xylinearized , rand(size(perTrial(ii).xylinearized)) ); hold on; scatter( perTrial(ii).swrLinearized , rand(size(perTrial(ii).swrLinearized)), '^', 'filled' );
% 
% [angle, radius] = cart2pol( perTrial(ii).xpos-354, perTrial(ii).ypos-327 ); angle=angle*180/pi+180;
% figure; subplot(2,1,1); plot(radius); subplot(2,1,2); plot(angle)
% 
%     rad=radius;
%     
%     rad(( angle >  45 ).*( angle <= 135 )) = rad(( angle >  45 ).*( angle <= 135 )) + 0;   % South
%     rad(( angle > 135 ).*( angle <= 225 )) = rad(( angle > 135 ).*( angle <= 225 )) + 720; % East
%     rad(( angle > 225 ).*( angle <= 315 )) = rad(( angle > 225 ).*( angle <= 315 )) + 980; % North
%     rad(( angle > 315 ).+( angle <=  45 )) = rad(( angle > 315 ).*( angle <=  45 )) + 360; % West
%     agg.(recDays{ii}).xylinearized=rad;




% for auto building start times.
%
%         startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
%         %
%         offset = 0;
% %        distErrEntry = sqrt(( 354 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 470 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
%         distErrEntry = sqrt(( 348 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 590 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
%         while ( distErrEntry > 15 ) &&  ( agg.(recDays{ii}).xytimestampSeconds(startIdx+offset) < agg.(recDays{ii}).leaveMazeToBucket(jj) )
%             offset = offset + 1;
%             distErrEntry = sqrt(( 348 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 590 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
%         end
%         %disp( [ 'day ' recDays{ii} ' trial ' num2str( jj ) ' time ' num2str( agg.(recDays{ii}).xytimestampSeconds(startIdx+offset)-1 )  ] );
%         startIdx = startIdx + offset;% - 30; 
%         if startIdx < 1; 
%             startIdx = 1; 
%             disp( [ 'day ' recDays{ii} ' trial ' num2str( jj ) ' impossible start' ] ); 
%         end
%         %
%         offset = 0;
% %        distErrEntry = sqrt(( 354 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 470 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
%         distErrEntry = sqrt(( 343 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 641 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
%         while ( distErrEntry < 41 ) &&  ( agg.(recDays{ii}).xytimestampSeconds(startIdx+offset) < agg.(recDays{ii}).leaveMazeToBucket(jj) )
%             offset = offset + 1;
%             distErrEntry = sqrt(( 343 - agg.(recDays{ii}).xpos(startIdx+offset) )^2 + ( 641 - agg.(recDays{ii}).ypos(startIdx+offset) )^2 );
%         end
%         disp( [ 'trialIdx ' num2str(trialIdx) ' day ' recDays{ii} ' trial ' num2str( jj ) ' time ' num2str( agg.(recDays{ii}).xytimestampSeconds(startIdx+offset)-1 )  ] );
%         startIdx = startIdx + offset;% - 30; 
%         if startIdx < 1; 
%             startIdx = 1; 
%             disp( [ 'day ' recDays{ii} ' trial ' num2str( jj ) ' impossible start' ] ); 
%         end
%         %
          %
