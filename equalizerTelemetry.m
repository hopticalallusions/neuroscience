%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This script 'normalizes' the position data. This means that both the
% perspective and fish eye distortion are adjusted as much as possible and
% the position is rotated to a standard orientation that will allow data to
% be compared across the different recording configurations that were
% employed. This corrected data is stored in a standard file. Further
% manual corrections to data problems are recorded at the end.



%%

% training days were handled by placing trial times during the period where
% the rat was on the maze.

%== Data That Needs Fixin'==
% telemetry build
%
% 2018-08-01a/b/c -- these are one recording day, and should be glued back
% together, but it's going to be a PITA
% 2018-08-03a/b -- these are one recording day, and should be glued back
% together, but it's going to be a PITA
%
% 2018-08-06 -- **see position.mat    has bad NVT data. much too small; req. vid extraction
% 2018-08-08 -- **see position.mat, position2.mat   has bad NVT data. much too small; req. vid extraction
% 2018-08-14 -- unknown; index exceeds matrix dimensions
% 2018-08-27 -- ignored; behavior is bad; tracking is bad
% 2018-08-31 -- unknown; index exceeds matrix dimensions
% 
% 2018-08-22 and beyond; performed in the new room, so a new linearization
% map and a new undistortion parameter set are required.






%% Load a linearization mask to assist make the data cleaner
maskDir='~/Desktop/';
mazeMask=imread( [ maskDir 'mazeLinearizedMask2.png' ] );
mazeMask=mean( mazeMask, 3 );
mazeMask = mazeMask < 200; %figure; imshow(mazeMask);
[ mazeMaskX, mazeMaskY ] = find(mazeMask);
[ mazeMaskX, mazeMaskY ] = rotateXYPositions( mazeMaskX, mazeMaskY, 500, 500, -90, 500, 500 );

rotationalParameters.centerX = 412;
rotationalParameters.centerY = 245;
rotationalParameters.degToRotate = -43;
rotationalParameters.xoffset = 440;
rotationalParameters.yoffset = 490;

%% Read in behavioral data
table=readtable('~/Downloads/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);

%% SET UP FIGURE FOR PLOTTING
whatFig = 10;
figure(whatFig);% subplot( 1, 2, 1 ); hold off; subplot( 1, 2, 2 ); hold off; 
clf;

%% undistort the diamond plus maze where the cameras are fixed to the
 % cage that holds the commutator in the big behavior room


%% SET UP INDIVIDUAL RAT RUNS


%% Rat H5
rat='h5';

folders={ '2018-04-25'  '2018-05-26' '2018-04-27'  '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08'  '2018-05-09' '2018-05-10' '2018-05-11' '2018-05-14'  '2018-05-15'  '2018-05-16'  '2018-05-18' '2018-06-08'  '2018-06-11' '2018-06-12' '2018-06-13'  '2018-06-14' '2018-06-15' };

for ii=1:length(folders)

    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];

    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    
    % undistort the diamond plus maze where the cameras are fixed to the
    % cage that holds the commutator in the big behavior room
    [xpos,ypos]=defishy(xpos,ypos,.000002);
    ypos=ypos+1/2000.*(ypos).^2;
    xpos=xpos-1/3000.*(720-xpos);
    
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    figure(whatFig);

    % Hard limit in case some sort of weirdness happens
    tidx=xrpos>1000; xrpos(tidx)=1000;
    tidx=xrpos<1; xrpos(tidx)=1;
    tidx=yrpos>1000; yrpos(tidx)=1000;
    tidx=yrpos<1; yrpos(tidx)=1;
    
    
    % perform various calculations which we will desire later
    movDir = zeros(1,length(xrpos));
    movDir(5:end-5) = (atan2( xrpos(10:end)-xrpos(1:end-9), yrpos(10:end)-yrpos(1:end-9) ) +pi)*180/pi ;
    for kk=5:length(xrpos)-5; movDir(kk) = median(movDir(kk-3:kk+3)); end;
    telemetry.movDir = movDir;
    telemetry.speed = calculateSpeed(xpos, ypos, 1, 3.5);
    % telemetry.headDir =   % I don't know where this data is.
    % now we can select via string comparison a particular set of dates
    startTimes = ds( (strcmp( ds.Date,folders{ii}).*strcmp( ds.Rat,rat))>0 , 4);
    startTimes = startTimes.TimeMazeSec(:);
    bucketTimes = ds( (strcmp( ds.Date,folders{ii}).*strcmp( ds.Rat,rat))>0 , 9);
    bucketTimes = bucketTimes.TimeBucketSec(:);
    contRestartTimes = ds( (strcmp( ds.Date,folders{ii}).*strcmp( ds.Rat,rat))>0 , 10);
    contRestartTimes = contRestartTimes.toContSec(:);
    endTimes = max([ bucketTimes contRestartTimes ]');
    onMaze = ones(1,length(xrpos));
    if endTimes(1)>startTimes(1)
        onMaze(1:round(startTimes(1)*29.97))=-1;
        for kk=2:length(startTimes)
            onMaze(round(endTimes(kk-1)*29.97):round(startTimes(kk)*29.97))=-1;
        end
        onMaze(round(endTimes(end)*29.97):end) = -1;
    else
        for kk=2:length(startTimes)
            onMaze(round(endTimes(kk-1)*29.97):round(startTimes(kk)*29.97))=-1;
        end
        onMaze(round(endTimes(end)*29.97):end) = -1;
    end
    telemetry.onMaze = onMaze;
    
    xlpos=zeros(size(xrpos));
    ylpos=zeros(size(yrpos));
    distLpos = zeros(size(yrpos));
    for kk=1:length(xrpos);
        distances = sqrt( (mazeMaskX-xrpos(kk)).^2 + (mazeMaskY-yrpos(kk)).^2 );
        [ dist, idx ] = min(distances);
        idx=idx(1);
        xlpos(kk) = mazeMaskX(idx);
        ylpos(kk) = mazeMaskY(idx);
        distLpos(kk) = dist;
    end
    
    % store standard data
    telemetry.x = xrpos;
    telemetry.y = yrpos;
    telemetry.xlpos = xlpos;
    telemetry.ylpos = ylpos;
    telemetry.distLpos = distLpos;
    telemetry.headDir = headDir;
    save([ filepath '/telemetry.dat'],'telemetry');
    
end



%% H7


folders = {  '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22' '2018-08-27' '2018-08-28' '2018-08-31' '2018-09-04' '2018-09-05' };
rat='h7';
for ii=1:length(folders)

    try
        filepath = [ '/Volumes/AGHTHESIS2/rats/h7/' folders{ii} ];

        [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);

       [xpos,ypos]=defishy(xpos,ypos,.000002);  %0.0000028; 4e-4; 2e-4
        ypos=ypos+1/2000.*(ypos).^2;
        xpos=xpos-1/3000.*(720-xpos);

        xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
        figure(whatFig);
    %    subplot( 1, 2, 1 ); hold on; plot( xpos, ypos,'Color', [ 0 0 0 .025 ], 'LineWidth', 1 ); %drawnow;
    %    subplot( 1, 2, 1 ); hold on; plot( xpos, ypos ); %drawnow;
    %    title(folders{ii});
    %    pause(.1)

         [ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
         %subplot(1,2,2); 
    %     hold on; plot(xrpos,yrpos,'Color', [ 0 0 0 .025 ], 'LineWidth', 1);
         %subplot(1,2,2); hold on; scatter(xrpos,yrpos,2,'k'); alpha(.05);

    %    tidx=xrpos>700; xrpos(tidx)=700;
    %    tidx=xrpos<1; xrpos(tidx)=1;
    %    tidx=yrpos>700; yrpos(tidx)=700;
    %    tidx=yrpos<1; yrpos(tidx)=1;

    %    txyHist = twoDHistogram( xrpos, yrpos, binResolution , 700, 700 );
    %    xyHist = xyHist+txyHist ;


        disp('telemetry build');
        telemetry.x = xrpos;
        telemetry.y = yrpos;
        movDir = zeros(1,length(xrpos));
        movDir(5:end-5) = (atan2( xrpos(10:end)-xrpos(1:end-9), yrpos(10:end)-yrpos(1:end-9) ) +pi)*180/pi ;
        for kk=5:length(xrpos)-5; movDir(kk) = median(movDir(kk-3:kk+3)); end;
        telemetry.movDir = movDir;
        telemetry.speed = calculateSpeed(xpos, ypos, 1, 3.5);
        %telemetry.headDir = 
        % now we can select via string comparison a particular set of dates
        startTimes = ds( (strcmp( ds.Date,folders{ii}).*strcmp( ds.Rat,rat))>0 , 4);
        startTimes = startTimes.TimeMazeSec(:);
        bucketTimes = ds( (strcmp( ds.Date,folders{ii}).*strcmp( ds.Rat,rat))>0 , 9);
        bucketTimes = bucketTimes.TimeBucketSec(:);
        contRestartTimes = ds( (strcmp( ds.Date,folders{ii}).*strcmp( ds.Rat,rat))>0 , 10);
        contRestartTimes = contRestartTimes.toContSec(:);
        endTimes = max([ bucketTimes contRestartTimes ]');
        % when the rat jumps backwards, things get weird, so this is a hack to
        % fix it
        if isnan(startTimes(1)); startTimes(1) = 1; end;
        for pp=2:length(startTimes)
            if isnan(startTimes(pp))
                startTimes(pp) = startTimes(pp-1);
            end
        end
        for pp=1:length(endTimes)
            if isnan(endTimes(pp))
                endTimes(pp) = startTimes(pp+1);
            end
        end
        %
        if ~isempty(endTimes)
            onMaze = ones(1,length(xrpos));
            if endTimes(1)>startTimes(1)
                onMaze(1:round(startTimes(1)*29.97))=-1;
                for kk=2:length(startTimes)
                    onMaze(round(endTimes(kk-1)*29.97):round(startTimes(kk)*29.97))=-1;
                end
                onMaze(round(endTimes(end)*29.97):end) = -1;
            else
                for kk=2:length(startTimes)
                    onMaze(round(endTimes(kk-1)*29.97):round(startTimes(kk)*29.97))=-1;
                end
                onMaze(round(endTimes(end)*29.97):end) = -1;
            end
        else
           warning([ 'COULD NOT CORRECT TELEMETRY; MISSING TRIAL DATA FOR ' folders{ii} ]);
        end
        telemetry.onMaze = onMaze;

        disp('linearizing');
        xlpos=zeros(size(xrpos));
        ylpos=zeros(size(yrpos));
        distLpos = zeros(size(yrpos));
        for kk=1:length(xrpos);
            distances = sqrt( (mazeMaskX-xrpos(kk)).^2 + (mazeMaskY-yrpos(kk)).^2 );
            [ dist, idx ] = min(distances);
            idx=idx(1);
            xlpos(kk) = mazeMaskX(idx);
            ylpos(kk) = mazeMaskY(idx);
            distLpos(kk) = dist;
        end
        telemetry.xlpos=xlpos;
        telemetry.ylpos=ylpos;
        telemetry.distLpos=distLpos;

        if ~isempty(endTimes)
            hold on; plot( xrpos(onMaze<0.9), yrpos(onMaze<0.9), 'Color', [ 1 0 0 .05 ], 'LineWidth', 1);
            hold on; plot( xrpos(onMaze>0), yrpos(onMaze>0), 'Color', [ 0 1 0 .05 ], 'LineWidth', 1);
        else
            hold on; plot( xrpos, yrpos, 'Color', [ 0 0 0 .025 ], 'LineWidth', 1);
        end

        save([ filepath '/telemetry.dat'],'telemetry');
        disp('saved');
    catch err
        warning('LOOP FAILED');
        disp( [ folders{ii} ]);
        err
    end


end
%axis([0 700 0 700])
axis square
%subplot(1,2,1); axis([-100 800 -100 800]); axis square; subplot(1,2,2); 
axis([0 1000 0 1000])
%%
axis([0 1000 0 1000])
return


%% H1

folders = { '2018-08-09' '2018-08-10_11-47-58' '2018-08-13' '2018-08-14' '2018-08-15' };

for ii=1:length(folders)

    filepath = [ '/Volumes/AGHTHESIS2/rats/h1/' folders{ii} ];

    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    figure(whatFig);
    subplot( 1, 2, 1 ); hold on; plot( xpos, ypos ); %drawnow;
%    title(folders{ii});
%    pause(.1)

     [ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
     %subplot(1,2,2); hold on; scatter(xrpos,yrpos,2,'k'); alpha(.05);
     subplot(1,2,2); hold on; plot(xrpos,yrpos,'Color', [ 0 0 0.7 .025 ], 'LineWidth', 1);
    
    tidx=xrpos>700; xrpos(tidx)=700;
    tidx=xrpos<1; xrpos(tidx)=1;
    tidx=yrpos>700; yrpos(tidx)=700;
    tidx=yrpos<1; yrpos(tidx)=1;
    
    
    txyHist = twoDHistogram( xrpos, yrpos, binResolution , 700, 700 );
    xyHist = xyHist+txyHist ;
end
axis([0 700 0 700])


hold on;
subplot(1,2,2)
for ii=binResolution:binResolution:1000
    line( [ii ii], [0 1000], 'Color', 'r' )
    line( [0 1000], [ii ii], 'Color', 'r' )
end



subplot(1,2,1); 
pcolor(log10((xyHist./29.97))); 
colormap([ 1 1 1; 0 0 0; colormap('jet')]); 
colorbar; title('xyTimeOccHist')

colormap(build_NOAA_colorgradient(255)); 


return;





filepath='/Volumes/AGHTHESIS2/rats/h7/2018-09-04/';
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
% rotate 
rotationalParameters.centerX = 412;
rotationalParameters.centerY = 245;
rotationalParameters.degToRotate = 45;
rotationalParameters.xoffset = 340;
rotationalParameters.yoffset = 390;
[ xpos, ypos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
% fix extreme values
tidx=xpos>700; xpos(tidx)=700;
tidx=xpos<1; xpos(tidx)=1;
tidx=ypos>700; ypos(tidx)=700;
tidx=ypos<1; ypos(tidx)=1;
figure; plot(xpos,ypos)
% transform space
linxy=zeros(1,4^10);
for ii=1:length(xpos)
    tidx=hilbertCurve_xy2d(10,xpos(ii),ypos(ii));
    linxy(tidx)=linxy(tidx)+1;
end
figure; plot(linxy(1:max(find(linxy))))
% transform space
compxpos=floor(xpos/15);
compypos=floor(ypos/15);
linxy=zeros(1,4^10);
for ii=1:length(xpos)
    tidx=hilbertCurve_xy2d(10,compxpos(ii),compypos(ii));
    linxy(tidx)=linxy(tidx)+1;
end
figure; plot(linxy(1:max(find(linxy))))
% visualize over time
linPos=zeros(1,length(xpos));
for ii=1:length(xpos)
    linPos(ii)=hilbertCurve_xy2d(10,compxpos(ii),compypos(ii));
end
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;

figure; 
subplot(3,1,1); plot(xytimestampSeconds,linPos);
subplot(3,1,2); plot(xytimestampSeconds,compxpos);
subplot(3,1,3); plot(xytimestampSeconds,compypos);

figure; 
scatter(compxpos+rand(length(xpos),1), compypos+rand(length(xpos),1),2, ...
'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.05,'MarkerEdgeAlpha',.05);


figure; plot(xpos,ypos,'Color',[ 0 0 0 .05])
hold on; scatter(fakePlaceCellX, fakePlaceCellY,2, ...
'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);


%+/- 15   y axis
%  x axis

%  182,388
  
fakePlaceCellX=normrnd(182,15,[1 1000]);
fakePlaceCellY=normrnd(388,5,[1 1000]);
compfakePlaceCellX=floor(fakePlaceCellX/15);
compfakePlaceCellY=floor(fakePlaceCellY/15);
linxypc=zeros(1,4^10);
for ii=1:length(compfakePlaceCellX)
    tidx=hilbertCurve_xy2d(10,compfakePlaceCellX(ii),compfakePlaceCellY(ii));
    linxypc(tidx)=linxypc(tidx)+1;
end
hold off; plot(linxy(1:max(find(linxy)))/max(linxy));
hold on; plot(linxypc(1:max(find(linxypc)))/max(linxypc))



xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;



figure(2);
subplot(1,1,1); plot(xpos,ypos)



rotationalParameters.centerX = 390;
rotationalParameters.centerY = 247;
rotationalParameters.degToRotate = 45;
rotationalParameters.xoffset = 350;
rotationalParameters.yoffset = 400;








filepath = '/Volumes/AGHTHESIS2/rats/h5/2018-06-14_training19_bananas/';
vidObj = VideoReader([ filepath 'VT1.mpg' ]);
figure;
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
frameIdx=1;  plotFrames = 0;
vidObj.CurrentTime = 777; plotFrames = 1;
frame = readFrame(vidObj);
imshow(frame);
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
hold on; plot(xpos,ypos,'r') ;
[xx,yy]=defishy(xpos,ypos,.0000028);
hold on; plot(xx,yy,'g') ;
yy=yy+1/2000.*(720-xx).*-1.*(240-yy);




% -10=40+(720-150).*(240-40)
% -10=40+(570).*(200)
% -50=

binResolution = 25; %round(15*2.9); % px/bin
xyHist = twoDHistogram( xrpos, yrpos, binResolution , 700, 700 );
pcolor(log10((xyHist./29.97))); colormap([ 1 1 1; 0 0 0; colormap('jet')]); colorbar; title('xyTimeOccHist')
title('log10(xy 2d hist)')
axis([0 700 0 700])

[xx,yy]=defishy(xpos,ypos,.0000028);

hold on
for ii=25:25:700
    line( [ii ii], [0 700] )
    line( [0 700], [ii ii] )
end



385

     
     tempFrame=frame(:,:,1);
     tempFrame=tempFrame - uint8(round(mean(frame(:,:,[2 3]),3)));
     tred=tempFrame;
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
%     just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxR(frameIdx)=median(xx);
     yyMedianMaxR(frameIdx)=median(yy);
     
     tempFrame=frame(:,:,2);
     tempFrame=tempFrame- uint8(round(mean(frame(:,:,[1 3]),3)));
     [maxVal, maxIdx ] = max(tempFrame(:)>20);
 %    just use the first thing returned
     [yy,xx] = ind2sub(size(tempFrame), maxIdx(1));
     xxMedianMaxG(frameIdx)=median(xx);
     yyMedianMaxG(frameIdx)=median(yy);
     
     if plotFrames
         subplot(3,3,1); imagesc(frame(:,:,1)); title('red')
         subplot(3,3,2); imagesc(frame(:,:,2)); title('green')
         subplot(3,3,3); imagesc(frame(:,:,3)); title('blue')
         subplot(3,3,4); imagesc(tred);
         subplot(3,3,5); imagesc(tempFrame);
         subplot(3,3,6); imagesc(mean(frame(:,:,:),3)); title('luminance')
         subplot(3,3,7); scatter( [ xxMedianMaxR(frameIdx)  ], [ yyMedianMaxR(frameIdx) ] ); xlim([ 0 720 ]); ylim([0 480]);
         subplot(3,3,8); scatter( [ xxMedianMaxG(frameIdx) ], [ yyMedianMaxG(frameIdx) ] ); xlim([ 0 720 ]); ylim([0 480]);
         subplot(3,3,9); plot( [ xxMedianMaxG ], [ yyMedianMaxG ] )
         drawnow
     end


filepath = '/Volumes/AHOWETHESIS/cameraCalibrationData/2018-05-09_calibrate4/';
vidObj = VideoReader([ filepath 'VT1.mpg' ]);
figure;
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
frameIdx=1;  plotFrames = 0;

%24.5 27 29 33 43 52 



timeList = [ 19.5 21 37 44 50 54 56 61 70 71 73 77 82 83 84 87 87.7 90 ];
for ii=length(timeList)
    vidObj.CurrentTime = timeList(ii); plotFrames = 1;
    frame = readFrame(vidObj);
    imshow(frame);
    %print([filepath 'img' num2str(ii) '.tif'], '-dtif')
    imwrite(frame,[filepath 'img' num2str(ii) '.tif'])
end



% from calib_gui

% Calibration results after optimization (with uncertainties):
% 
% Focal Length:          fc = [ 558.61557   508.69123 ] +/- [ 8.31042   7.05671 ]
% Principal point:       cc = [ 344.96070   230.79137 ] +/- [ 12.05004   11.57386 ]
% Skew:             alpha_c = [ 0.00000 ] +/- [ 0.00000  ]   => angle of pixel axes = 90.00000 +/- 0.00000 degrees
% Distortion:            kc = [ -0.42547   0.19281   -0.00445   0.01355  0.00000 ] +/- [ 0.02692   0.05126   0.00331   0.00291  0.00000 ]
% Pixel error:          err = [ 1.29143   1.44893 ]




% Extrinsic parameters:
% 
% Translation vector: Tc_ext = [ 209.729706 	 422.757292 	 1662.960321 ]
% Rotation vector:   omc_ext = [ -2.523157 	 1.232485 	 0.490164 ]
% Rotation matrix:    Rc_ext = [ 0.576084 	 -0.798669 	 -0.173938
%                                -0.699982 	 -0.591921 	 0.399568
%                                -0.422081 	 -0.108431 	 -0.900050 ]
% Pixel error:           err = [ 0.41803 	 0.56334 ]




% build mapping set
segment = [595 519 873 551];
tx=segment(1):segment(3);
mm = (segment(4)-segment(2)) / (segment(3)-segment(1));
ty = round(mm*tx) + min(segment([2 4]));
xx=tx; yy=ty;
segment = [ 459 375 484 49 ];
ty=segment(4):segment(2);
mm = (segment(3)-segment(1)) / (segment(2)-segment(4));
tx = round(mm*ty) + min(segment([1 3]));
xx=[xx tx]; yy=[yy ty];
segment = [ 92 493 346 509 ];
tx=segment(1):segment(3);
mm = (segment(4)-segment(2)) / (segment(3)-segment(1));
ty = round(mm*tx) + min(segment([2 4]));
xx=[xx tx]; yy=[yy ty];
segment = [ 505 933 478 637 ];
ty=segment(4):segment(2);
mm = (segment(1)-segment(3)) / (segment(2)-segment(4));
tx = round(mm*ty) + min(segment([1 3]));
xx=[xx tx]; yy=[yy ty];
figure; scatter(xx,yy,'filled')












folders = {  '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22' '2018-08-27' '2018-08-28' '2018-08-31' '2018-09-04' '2018-09-05' };
rat='h7';
figure;
for ii=1:length(folders)-5

        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} ];

        [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
        hold on; plot( xpos, ypos, 'k' );
end

figure;
for ii=length(folders)-5:length(folders)
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} ];
        [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
        
        % correction for NEW MAZE ROOM
        ypos=ypos+1/3000.*(ypos).^2;
        xpos=xpos+1/2000.*(720-xpos);
        [ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, 370, 253, -45, 400, 400 );
        
        hold on; plot( xrpos, yrpos );
end
axis square









% correction for NEW MAZE ROOM
        ypos=ypos+1/3000.*(ypos).^2;
        xpos=xpos+1/2000.*(720-xpos);
        [ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, 370, 253, -45, 400, 400 );
