basedir='/Users/andrewhowe/data/da5_laser-place-pref_2016-09-08/';
basedir='/Users/andrewhowe/data/placePreference/da5_lpp-square-tray_day1_Aug4/';

[ events, eventTimestamps   ] = nev2mat([ basedir 'Events.nev']);
[ xpos, ypos, vidTimestamps ] = nvt2mat([ basedir 'VT0.nvt']);
xposCorrected = nlxPositionFixer(xpos);
yposCorrected = nlxPositionFixer(ypos);
% 
zoneZeroIdxs=find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone0 Entered') )));
zoneZeroIdxs=[zoneZeroIdxs; find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone0 Exited') )))];
vidIdxZoneZero=zeros(length(zoneZeroIdxs),1);
for idx=1:length((zoneZeroIdxs))
    vidIdxZoneZero(idx) = min(find((eventTimestamps(zoneZeroIdxs(idx))<vidTimestamps)));
end
% find 
zoneOneIdxs=find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone6 Entered') )));
zoneOneIdxs=[zoneOneIdxs; find(not(cellfun('isempty', strfind(events, 'Zoned Video: Zone6 Exited') )))];
vidIdxZoneOne=zeros(length(zoneOneIdxs),1);
for idx=1:length((zoneOneIdxs))
    vidIdxZoneOne(idx) = min(find((eventTimestamps(zoneOneIdxs(idx))<vidTimestamps)));
end
% plot the empirical dividing line estimate
midline=median([xpos(vidIdxZoneZero); xpos(vidIdxZoneOne)]);
% find lasers
laserIdxs=find(not(cellfun('isempty', strfind(events, 'laser awarded') )));
vidIdxLaser=zeros(length(laserIdxs),1);
for idx=1:length((laserIdxs))
    vidIdxLaser(idx) = min(find((eventTimestamps(laserIdxs(idx))<vidTimestamps)));
end


figure;
subplot( 5, 5, [ 6 7 8 9   11 12 13 14   16 17 18 19   21 22 23 24 ] );
hold on;
line([ midline midline ],[50 480], 'Color', [ 0 .6 .9 ], 'LineWidth', 2 );
plot( xposCorrected, yposCorrected, 'Color', [ .5 .5 .5] );
plot( xposCorrected(vidIdxZoneZero), yposCorrected(vidIdxZoneZero), '.', 'MarkerSize', 2 );
plot( xposCorrected(vidIdxZoneOne), yposCorrected(vidIdxZoneOne), '.', 'MarkerSize', 2 );
axis( [ 100 600 0 500 ] );
plot( xposCorrected(vidIdxLaser), yposCorrected(vidIdxLaser), '*', 'Color', [ 0 .7 .3 ], 'MarkerSize', 4 );
set(gca,'XtickLabel',[],'YtickLabel',[]);
%legend('boundry','position','','','laser')
subplot( 5, 5, [ 1 2 3 4 ] );
[ yy, xx ] = hist( xposCorrected, 100:5:600 );
plot( xx, yy./sum(yy), 'k' );
%legend('P(x_{pos})')
%set(gca,'XtickLabel',[],'YtickLabel',[]);
subplot( 5, 5, [ 10 15 20 25 ] );
[ yy, xx ] = hist( yposCorrected, 0:5:500 );
plot( yy./sum(yy), xx, 'k' );
%legend('P(y_{pos})');
%set(gca,'XtickLabel',[],'YtickLabel',[]);

figure;
subplot( 5, 5, [ 1 2 3 4 ] );
hist( xposCorrected, 100:5:600 );
subplot( 5, 5, [ 6 7 8 9 ] );
hist( yposCorrected, 0:5:500 );



%set(gca,'visible','off')
%If you just want to remove tick marks use
%>> set(gca,'XtickLabel',[],'YtickLabel',[]);


% laser reward over time
ets=(vidTimestamps-vidTimestamps(1))/60e6;
figure;
subplot(4,1,1);
plot( ets, xposCorrected,'k'); hold on;
plot(ets(vidIdxLaser), xposCorrected(vidIdxLaser), '.');
axis([ -.5 20.5 100 600 ]);
legend('x position','laser');
ylabel('pxl');
subplot(4,1,2);
plot( ets, yposCorrected, 'k'); hold on;
plot( ets(vidIdxLaser), yposCorrected(vidIdxLaser), '.');
axis([ -.5 20.5 0 500 ]);
legend('y position','laser');
xlabel('time (min)');
ylabel('pxl');


% cyclic time map, x now vs x 1s in the future
%figure; plot(xposCorrected(1:end-30),xposCorrected(31:end))


% lasers per minute
%figure;
subplot(4,1,3);
eventTimestampsRescaled = ( eventTimestamps(laserIdxs) - eventTimestamps(1) ) /60e6;
hist(eventTimestampsRescaled, 0:.5:ceil(max(eventTimestampsRescaled)));
title('Laser Delivery Rate');
xlabel('time (min)');
ylabel('laser/min');
axis([ -.5 20.5 0 30 ]);


figure;subplot(2,1,1);
xposRecentered=(100*((xposCorrected-min(xposCorrected))/(max(xposCorrected)-min(xposCorrected))))-50;
plot( ets, xposRecentered,'k'); hold on;
plot(ets(vidIdxLaser), xposRecentered(vidIdxLaser), '+');
line([ -.5 20.5 ],[0 0], 'Color', [ 0 .6 .9 ], 'LineWidth', 2 );
axis([ -.5 20.5 -55 55 ]);
subplot(2,1,2);
inLaserZone=xposRecentered>=0; %inLaserZone=(2*(xposRecentered>=0))-1;
%plot( ets, cumsum(inLaserZone)/sum(inLaserZone),'k'); hold on;
sidePreference=zeros(1,21);
for idx=1:20
    sideIdxs = (((idx-1)*(30*60))+1):(((idx)*(30*60)));
    sidePreference(idx)=sum(inLaserZone(sideIdxs))/length(sideIdxs);
end
idx=21;
sidePreference(20)=sum(inLaserZone((((idx-1)*(30*60))+1):length(inLaserZone)))/length(((((idx-1)*(30*60))+1):length(inLaserZone)));
plot( ets(1:(30*60):end), (2*sidePreference)-1,'k');
line([ -.5 20.5 ],[0 0], 'Color', [ 0 .6 .9 ], 'LineWidth', 2 );
axis([ -.5 20.5 -1.05 1.05 ]);



yposRecentered=(100*((yposCorrected-min(yposCorrected))/(max(yposCorrected)-min(yposCorrected))))-50;
plot( ets, yposRecentered, 'k'); hold on;
plot( ets(vidIdxLaser), yposRecentered(vidIdxLaser), '+');
axis([ -.5 20.5 -55 55 ]); legend('y position','laser');xlabel('time (min)');ylabel('pxl');
subplot(4,1,3);