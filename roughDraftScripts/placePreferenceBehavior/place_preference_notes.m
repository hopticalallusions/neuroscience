basedir='/Users/andrewhowe/data/placePreference/'
% subdir='da1-2-7_lpp-trident_day1_Jul22/'
% subdir='da1-2-7_lpp-trident_day2_Jul25/'
% subdir='da1-2_lpp-trident_day3_Jul26/'
% subdir='da1-2_lpp-unknown_dayx_Jul28/'
% subdir='da1-2_lpp-unknown_dayx_Jul29/'
% subdir='da1_lpp-trident_day4-2016-07-27/'
% subdir='da1_lpp-trident_day_Aug29/'
% subdir='da1_lpp-trident_dayx_Jul29/' 
% subdir='da2_lpp-square-reverse_day1_2016-08-08/'
% subdir='da2_lpp-square-tray_day1_Aug2/'
% subdir='da2_lpp-square-tray_day2_Aug3/'
% subdir='da2_lpp-square-tray_day3_Aug4/'
% subdir='da2_lpp-trident_day4_2016-07-27/'
% subdir='da2_lpp-trident_day6-2016-08-01/'
% subdir='da2_lpp-trident_day6_2016-08-01/'
% subdir='da2_lpp-trident_day_Aug29/'
% subdir='da5_lpp-square-tray_day1_Aug4/'

basedir='/Volumes/SAMSUNG/andrew/da5/laser-place-pref_2016-09-08/'
basedir='/Volumes/SILVRSURFER/da5/laser-place-pref_2016-09-08/'

%[basedir subdir 'Events.nev']
[ day3Events, eventTimestamps]=nev2mat([basedir  'Events.nev']);
[xpos, ypos, vidTimestamps] = nvt2mat([basedir 'VT0.nvt']);
xposCorrected=nlxPositionFixer(xpos);
yposCorrected=nlxPositionFixer(ypos);
figure;
plot(xposCorrected,yposCorrected);

return;


ttlRewardCSevenIdx=find(not(cellfun('isempty', strfind(day3Events, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x0007).') )));
figure;
subplot(2,2,2); plot(xposCorrected(101210+25000:101210+50000),yposCorrected(101210+25000:101210+50000));subplot(2,2,3); plot(xposCorrected(101210+50000:101210+75000),yposCorrected(101210+50000:101210+75000));subplot(2,2,4); plot(xposCorrected(101210+75000:end),yposCorrected(101210+75000:end));

%2:20 to 1:08:00 should have valid data for da2
min(find(vidTimestamps > vidTimestamps(101210) + 1e6*(0*60*60+2*60+20) ) )
min(find(vidTimestamps > vidTimestamps(101210) + 1e6*(1*60*60+8*60+0) ) )

figure; plot(xposCorrected(105406:223488),yposCorrected(105406:223488));

xx=xposCorrected(105406:223488);
yy=yposCorrected(105406:223488);
occupationHeat=zeros(500,700);
for idx=1:length(xx)
    occupationHeat(round(yy(idx)+1),round(xx(idx)+1))=occupationHeat(round(yy(idx)+1),round(xx(idx)+1))+1;
end

figure;
plot(xx,yy,'.k'); 
hold on;
markersize=4;
[rr,cc,vv]=find(occupationHeat>4);
plot(cc,rr,'.b','MarkerSize', markersize);
[rr,cc,vv]=find(occupationHeat>16);
plot(cc,rr,'.c','MarkerSize', markersize);
[rr,cc,vv]=find(occupationHeat>32);
plot(cc,rr,'.g','MarkerSize', markersize);
[rr,cc,vv]=find(occupationHeat>64);
plot(cc,rr,'.y','MarkerSize', markersize);
[rr,cc,vv]=find(occupationHeat>128);
plot(cc,rr,'.m','MarkerSize', markersize);
[rr,cc,vv]=find(occupationHeat>256);
plot(cc,rr,'.r','MarkerSize', markersize);
title('DA2 Place Pref. W Maze : Pixel Occupancy','FontWeight','bold','FontName','Arial');
xlabel('x video coordinate','FontName','Arial');
ylabel('y video coordinate','FontName','Arial');



