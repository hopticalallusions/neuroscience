% zoneCoords=nzv2mat('/Users/andrewhowe/data/da11/da11_day3_cpp.nzv');
% [ events, eventTimestamps ] = nev2mat( '/Users/andrewhowe/data/da11/june-20-2017/Events.nev' );
% [ xpos, ypos, timestamps ]=nvt2mat('/Users/andrewhowe/data/da11/june-20-2017/VT0.nvt');




%% da10 day0 place preference bias test
dir='/Volumes/BlueMiniSeagateData/place-preference/da12_2017-08-14/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da12_2017-08-14_placePrefLeft ';
zoneCoords1=nzv2mat([ dir '/' 'linearized-8maze-alternation-laser_day0.nzv']);
sessionStartTime=1.5; % minutes
sessionEndTime=31.4; % minutes
epochTime = 5; % minutes



dir='/Volumes/BlueMiniSeagateData/place-preference/da12_2017-08-15/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da12_2017-08-15_placePrefLeft ';
zoneCoords1=nzv2mat([ dir '/' 'da12_2017-08-15_linearized-8maze-laser-place-pref.nzv']);
sessionStartTime=1.5; % minutes
sessionEndTime=61.4; % minutes
epochTime = 5; % minutes


[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposCorrected(LaserPosIdx));
laserCenterY=median(yposCorrected(LaserPosIdx));
laserCenterDistance=sqrt( (xposCorrected-laserCenterX).^2 + (yposCorrected-laserCenterY).^2 );


sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            plotNlxZone(zoneCoords1); 
            %hold on; scatter(xposCorrected(LaserPosIdx), yposCorrected(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient); 
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');

vel = sqrt( diff(xposCorrected).^2 + diff(yposCorrected).^2 ); figure; subplot(3,1,1); plot((1:length(xposCorrected))/30,xposCorrected); subplot(3,1,2); plot((1:length(yposCorrected))/30, yposCorrected); subplot(3,1,3); plot((1:length(vel))/30, vel);


return;



%zoneCoords=nzv2mat('/Users/andrewhowe/data/da11_day4_laser-at-250_cpp.nzv');
%[ events, eventTimestamps ] = nev2mat( '/Volumes/BlueMiniSeagateData/da11/2017-06-23_17-59-05/Events.nev' );
%[ xpos, ypos, xyPositionTimestamps ]=nvt2mat('/Volumes/BlueMiniSeagateData/da11/2017-06-23_17-59-05/VT0.nvt');



% dir = '/Volumes/BlueMiniSeagateData/place-preference/da11_2017-07-24_14-08-26/';
% zoneCoords1=nzv2mat([ dir 'da11_day6_7-24-2017_laser-at-300-46minutes_cpp.nzv']);
% zoneCoords2=nzv2mat([ dir 'da11_day6_7-24-2017_laser-at-300-46minutes_cpp-55minutes.nzv']);
% zoneCoords3=nzv2mat([ dir 'da11_day6_7-24-2017_laser-at-300-46minutes_cpp-55minutes-lighton.nzv']);
% zoneCoords4=nzv2mat([ dir 'da11_day6_7-24-2017_laser-at-300-46minutes_cpp-55minutes-lighton-last.nzv']);
% [ events, eventTimestamps ] = nev2mat( [ dir 'Events.nev'] );
% [ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );


% dir = '/Volumes/BlueMiniSeagateData/place-preference/da12_2017-07-24_10-52-25/';
% zoneCoords1=nzv2mat([ dir 'da12-july-24-2017-day1-cpp_31-ish-minutes-flip-to-door-corner_lights-off.nzv']);
% [ events, eventTimestamps ] = nev2mat( [ dir 'Events.nev'] );
% [ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
% 
% 
% 
% % laser deactivated this day
% dir = '/Volumes/BlueMiniSeagateData/place-preference/da12_2017-7-28/';
% zoneCoords1=nzv2mat([ dir 'da12_7-28-2017.nzv']);
% [ events, eventTimestamps ] = nev2mat( [ dir 'Events.nev'] );
% [ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );

% laser on correctly
% dir = '/Volumes/BlueMiniSeagateData/place-preference/da12_2017-07-27_16-07-43/';
% zoneCoords1=nzv2mat([ dir 'da12-july-27-2017_fullf.nzv']);
% [ events, eventTimestamps ] = nev2mat( [ dir 'Events.nev'] );
% [ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
% sessionEndTime=35; % minutes


%% da10 day0 place preference bias test
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-01_habituation/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da10_2017-08-01_habituation';


%% da10 day0 place preference bias test
dir='/Volumes/BlueMiniSeagateData/place-preference/da12_2017-08-14/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da12_2017-08-14_placePrefLeft ';



%%
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

sessionStartTime=0; % minutes
sessionEndTime=22; % minutes
epochTime = 5; % minutes
 
sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            % plotNlxZone(zoneCoords1); 
            % hold on; scatter(xposFilt(LaserPosIdx), yposFilt(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient);
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');


%% da10 day0 place preference test A
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-01_placepref/vta-head-mid_b15-b22/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da10_2017-08-01_vta-head-mid_b15-b22_';

zoneCoords1=nzv2mat([ dir '/' 'da10_2017-08-01.nzv']);
[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposCorrected(LaserPosIdx));
laserCenterY=median(yposCorrected(LaserPosIdx));
laserCenterDistance=sqrt( (xposCorrected-laserCenterX).^2 + (yposCorrected-laserCenterY).^2 );


sessionStartTime=0; % minutes
sessionEndTime=33; % minutes
epochTime = 5; % minutes
 
sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            plotNlxZone(zoneCoords1); 
            %hold on; scatter(xposCorrected(LaserPosIdx), yposCorrected(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient); 
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');








%% da10 day0 place preference test
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-01_placepref/vta-mid-tail_b17-b19/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da10_2017-08-01_vta-mid-tail_b17-b19_';

zoneCoords1=nzv2mat([ dir '/' 'da10_2017-08-01.nzv']);
[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposCorrected(LaserPosIdx));
laserCenterY=median(yposCorrected(LaserPosIdx));
laserCenterDistance=sqrt( (xposCorrected-laserCenterX).^2 + (yposCorrected-laserCenterY).^2 );


sessionStartTime=0; % minutes
sessionEndTime=22.5; % minutes
epochTime = 5; % minutes
 
sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            plotNlxZone(zoneCoords1); 
            %hold on; scatter(xposCorrected(LaserPosIdx), yposCorrected(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient); 
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');






%% da10 day1 place preference test A
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-02/laser-mid-vta_b17-b22/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da10_2017-08-02_mid-vta_b17-b22_';

zoneCoords1=nzv2mat([ dir '/' 'da10_2017-08-01.nzv']);
[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposCorrected(LaserPosIdx));
laserCenterY=median(yposCorrected(LaserPosIdx));
laserCenterDistance=sqrt( (xposCorrected-laserCenterX).^2 + (yposCorrected-laserCenterY).^2 );


sessionStartTime=0; % minutes
sessionEndTime=29.5; % minutes
epochTime = 5; % minutes
 
sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            plotNlxZone(zoneCoords1); 
            %hold on; scatter(xposCorrected(LaserPosIdx), yposCorrected(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient); 
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');






%% da10 day1 place preference test B
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-02/laser-vta-tips_b15-b19/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da10_2017-08-02_laser-vta-tips_b15-b19_';

zoneCoords1=nzv2mat([ dir '/' 'da10_2017-08-01.nzv']);
[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposCorrected(LaserPosIdx));
laserCenterY=median(yposCorrected(LaserPosIdx));
laserCenterDistance=sqrt( (xposCorrected-laserCenterX).^2 + (yposCorrected-laserCenterY).^2 );


sessionStartTime=0.5; % minutes
sessionEndTime=44.3; % minutes
epochTime = 5; % minutes
 
sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            plotNlxZone(zoneCoords1); 
            %hold on; scatter(xposCorrected(LaserPosIdx), yposCorrected(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient); 
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');






%% da10 day3 place preference test 
% bolts 17 and 22
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-03/';
printdir = '/Volumes/BlueFatVol/placepreffigures/';
printfilename = 'da10_2017-08-03_laser-vta-tips_b17-b22_';

zoneCoords1=nzv2mat([ dir '/' 'da10_2017-08-03.nzv']);
[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir 'VT0.nvt'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );

LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposCorrected(LaserPosIdx));
laserCenterY=median(yposCorrected(LaserPosIdx));
laserCenterDistance=sqrt( (xposCorrected-laserCenterX).^2 + (yposCorrected-laserCenterY).^2 );


sessionStartTime=0; % minutes
sessionEndTime=19.9; % minutes
epochTime = 5; % minutes
 
sessionStartIdx=floor(sessionStartTime*60*30)+1; % floor fixes fractional indexing.
sessionEndIdx=floor(sessionEndTime*60*30);
epochIdxSize=floor(epochTime*60*30);

subplotsToMake=2*ceil((sessionEndTime-sessionStartTime)/epochTime);
subplotCols=ceil(subplotsToMake/3);
subplotRows=ceil(subplotsToMake/subplotCols);

figure;            epochIdx=1; subplotIdx=1;
for ii=1:subplotRows
    for jj=1:2:subplotCols
        % caluclate position indices
        tmpEndIdx=(sessionStartIdx+epochIdxSize*(epochIdx));
        if tmpEndIdx > sessionEndIdx
            tmpEndIdx = sessionEndIdx;
        end
        tmpIdxs=((sessionStartIdx+epochIdxSize*(epochIdx-1)):tmpEndIdx);
        % don't bother plotting anything if  we've exceeded the maximum time
        % or if there's only a minute of time left to the plot
        if ~(isempty(tmpIdxs)) && (length(tmpIdxs)>60*30)
            %
            subplot(subplotRows,subplotCols,subplotIdx); plot( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); axis([ 0 720 0 480 ]);
            plotNlxZone(zoneCoords1); 
            %hold on; scatter(xposCorrected(LaserPosIdx), yposCorrected(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
            subplotIdx = subplotIdx+1;
            subplot(subplotRows,subplotCols,subplotIdx); qq=twoDHistogram( xposCorrected(tmpIdxs), yposCorrected(tmpIdxs), 20, 720, 480); imagesc(flipud(100*qq/epochIdxSize)); colormap(build_NOAA_colorgradient); 
            caxis([0 10]); %colorbar;
            %
            epochIdx=epochIdx+1;
            subplotIdx = subplotIdx+1;
        end
    end
end
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 14 7];
print( [ printdir printfilename '_heatmaps.png' ], '-dpng');
%
figure;
subplot(1,2,1); [yy,xx]=hist(xposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 720]);
title('x position preference histogram'); xlabel('x-position bins (px)'); ylabel('percent time in bin');
subplot(1,2,2); [yy,xx]=hist(yposCorrected(sessionStartIdx:sessionEndIdx),0:20:720); bar(xx,yy/sum(yy)); xlim([0 480]);
title('y position preference histogram'); xlabel('y-position bins (px)'); ylabel('percent time in bin'); view(-270,-90)
fig = gcf; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 8 3];
print( [ printdir printfilename '_x-pos-histogram.png' ], '-dpng');




%%

return

 









% da10 day 2 after turning.
dir='/Volumes/BlueMiniSeagateData/place-preference/da10_2017-08-02'
[ xpos, ypos, xyPositionTimestamps ]=nvt2mat( [dir '/' 'VT0.nvt'] );
zoneCoords1=nzv2mat([ dir '/' 'da10_2017-08-01.nzv']);
[ events, eventTimestamps ] = nev2mat( [ dir '/' 'Events.nev'] );
xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );
% laser @ 400 -> ~12-14 mW provided to bolts 17 and 22 (targeting central VTA)
sessionStartTime=0;
sessionEndTime=22;
epochTime=5;

sessionStartTime=0;  %53281 is the proper index
sessionEndTime=22;
epochTime=5;

%% do some analysis.

sessionStartIdx= 53281; %floor(sessionStartTime*30)+1; % floor fixes fractional indexing.
sessionEndIdx=100000; %floor(sessionEndTime*30);
epochIdx=floor(epochTime*30);

ZoneIdx=find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone0 Entered') )));
ZoneIdx=[ZoneIdx find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone0 Exited') )))];
ZonePosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    ZonePosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
zoneCenterX=median(xposFilt(ZonePosIdx));
zoneCenterY=median(yposFilt(ZonePosIdx));
%
LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposFilt(LaserPosIdx));
laserCenterY=median(yposFilt(LaserPosIdx));
laserCenterDistance=sqrt( (xposFilt-laserCenterX).^2 + (yposFilt-laserCenterY).^2 );

ciel(xyTiime);



figure; hist(xposCorrected(53281:end),50)





%4:27 

xposCorrected = nlxPositionFixer( xpos );
yposCorrected = nlxPositionFixer( ypos );


% ~0.2625 cm per pixel
% square environment is 105 cm square

%LaserIdx=find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone0 Entered') )));
LaserIdx=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
%
LaserPosIdx=zeros(length(LaserIdx),1);
for idx=1:length((LaserIdx))
    %LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
    LaserPosIdx(idx) = min(find((eventTimestamps(LaserIdx(idx))<xyPositionTimestamps)));
end
laserCenterX=median(xposFilt(LaserPosIdx));
laserCenterY=median(yposFilt(LaserPosIdx));
laserCenterDistance=sqrt( (xposFilt-laserCenterX).^2 + (yposFilt-laserCenterY).^2 );
    
    

qtrIdx= 30*60*sessionEndTime/4; %floor(length(xposFilt)/4);
%qtrIdx=floor(length(xposFilt)/4);
figure;
subplot(2,4,1); plot( xposFilt(1:qtrIdx), yposFilt(1:qtrIdx), 'Color', [.1 .1 .1 .1] ); plotNlxZone(zoneCoords1); axis([ 0 720 0 480 ]);
%hold on; scatter(xposFilt(LaserPosIdx), yposFilt(LaserPosIdx), 'o', 'filled'); alpha(.3); scatter( laserCenterX, laserCenterY, 'o', 'filled' );
subplot(2,4,2); qq=twoDHistogram( xposFilt(1:qtrIdx), yposFilt(1:qtrIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;

subplot(2,4,3); plot( xposFilt(qtrIdx:2*qtrIdx), yposFilt(qtrIdx:2*qtrIdx), 'Color', [.1 .1 .1 .1]  ); plotNlxZone(zoneCoords1); axis([ 0 720 0 480 ]);
subplot(2,4,4); qq=twoDHistogram( xposFilt(qtrIdx:2*qtrIdx), yposFilt(qtrIdx:2*qtrIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;

subplot(2,4,5); plot( xposFilt(2*qtrIdx:3*qtrIdx), yposFilt(2*qtrIdx:3*qtrIdx), 'Color', [.1 .1 .1 .1]  ); plotNlxZone(zoneCoords1); axis([ 0 720 0 480 ]);
subplot(2,4,6); qq=twoDHistogram( xposFilt(2*qtrIdx:3*qtrIdx), yposFilt(2*qtrIdx:3*qtrIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;

subplot(2,4,7); plot( xposFilt(3*qtrIdx:4*qtrIdx), yposFilt(3*qtrIdx:4*qtrIdx), 'Color', [.1 .1 .1 .1]  ); plotNlxZone(zoneCoords1); axis([ 0 720 0 480 ]);
subplot(2,4,8); qq=twoDHistogram( xposFilt(3*qtrIdx:4*qtrIdx), yposFilt(3*qtrIdx:4*qtrIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;

figure; subplot(2,1,1); stairs((xyPositionTimestamps(LaserPosIdx)-xyPositionTimestamps(1))/60e6,cumsum(ones(1,length(LaserPosIdx))) ); title('cumm. laser stims'); xlabel('time elapsed (s)'); ylabel('total laser trains');
subplot(2,1,2); plot( (xyPositionTimestamps-xyPositionTimestamps(1))/60e6, laserCenterDistance );  title('dist. to laser center'); xlabel('time elapsed (s)'); ylabel('dist (px)');

return;

%subplot(2,4,7);hold on; plot(xposFilt(LaserPosIdx), yposCorrected(LaserPosIdx), '*');

figure;
startIdx=1; endIdx=round(30*60*46.6);
subplot(2,4,1); 
plot( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 'Color', [.1 .1 .1 .1] ); 
plotNlxZone(zoneCoords1); axis([ 0 720 0 480 ]);
tempLPI = LaserPosIdx(find((LaserPosIdx>startIdx) .* (LaserPosIdx<endIdx)));
hold on; scatter(xposFilt(tempLPI), yposFilt(tempLPI), 'o', 'filled'); alpha(.3);

subplot(2,4,2); qq=twoDHistogram( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;
startIdx=round(30*60*46.6+1); endIdx=round(30*60*54.72);
subplot(2,4,3); plot( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 'Color', [.1 .1 .1 .1] ); 
plotNlxZone(zoneCoords2); axis([ 0 720 0 480 ]);
tempLPI = LaserPosIdx(find((LaserPosIdx>startIdx) .* (LaserPosIdx<endIdx)));
hold on; scatter(xposFilt(tempLPI), yposFilt(tempLPI), 'o', 'filled'); alpha(.3);

subplot(2,4,4); qq=twoDHistogram( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;
startIdx=round(30*60*54.72+1); endIdx=round(30*60*65.6);
subplot(2,4,5); plot( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 'Color', [.1 .1 .1 .1] ); 
plotNlxZone(zoneCoords3); axis([ 0 720 0 480 ]);
tempLPI = LaserPosIdx(find((LaserPosIdx>startIdx) .* (LaserPosIdx<endIdx)));
hold on; scatter(xposFilt(tempLPI), yposFilt(tempLPI), 'o', 'filled'); alpha(.3);

subplot(2,4,6); qq=twoDHistogram( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;
startIdx=round(30*60*65.6+1); endIdx=round(30*60*112.1);
subplot(2,4,7); plot( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 'Color', [.1 .1 .1 .1] ); 
plotNlxZone(zoneCoords4); axis([ 0 720 0 480 ]);
tempLPI = LaserPosIdx(find((LaserPosIdx>startIdx) .* (LaserPosIdx<endIdx)));
hold on; scatter(xposFilt(tempLPI), yposFilt(tempLPI), 'o', 'filled'); alpha(.3);

subplot(2,4,8); qq=twoDHistogram( xposFilt(startIdx:endIdx), yposFilt(startIdx:endIdx), 20, 720, 480); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); colorbar;
