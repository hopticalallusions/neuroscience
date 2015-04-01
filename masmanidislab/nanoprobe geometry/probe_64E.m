           
exceldata=[];

exceldata=[
           1           0        3100           1
           2           0        3000           1
           3           0        2900           1
           4           0        2800           1
           5           0        2700           1
           6           0        2600           1
           7           0        2500           1
           8           0        2400           1
           9           0        2300           1
          10           0        2200           1
          11           0        2100           1
          12           0        2000           1
          13           0        1900           1
          14           0        1800           1
          15           0        1700           1
          16           0        1600           1
          17           0        1500           1
          18           0        1400           1
          19           0        1300           1
          20           0        1200           1
          21           0        1100           1
          22           0        1000           1
          23           0         900           1
          24           0         800           1
          25           0         700           1
          32           0         600           1
          31           0         500           1
          30           0         400           1
          29           0         300           1
          28           0         200           1
          27           0         100           1
          26           0           0           1
          64           0        3150           1
          63           0        3050           1
          62           0        2950           1
          61           0        2850           1
          60           0        2750           1
          59           0        2650           1
          58           0        2550           1
          57           0        2450           1
          56           0        2350           1
          55           0        2250           1
          54           0        2150           1
          53           0        2050           1
          52           0        1950           1
          51           0        1850           1
          50           0        1750           1
          49           0        1650           1
          48           0        1550           1
          47           0        1450           1
          46           0        1350           1
          45           0        1250           1
          44           0        1150           1
          43           0        1050           1
          42           0         950           1
          41           0         850           1
          40           0         750           1
          33           0         650           1
          34           0         550           1
          35           0         450           1
          36           0         350           1
          37           0         250           1
          38           0         150           1
          39           0          50           1   
          
          ];
      
s=[];
s.channels=exceldata(:,1);
s.x=-1*exceldata(:,2);   %the reference electrode is always the top right channel when the probes are pointing up.
s.z=exceldata(:,3);
s.shaft=exceldata(:,4);
s.tipelectrode=30;

[a,sortorder]=sort(s.channels);
s.channels=s.channels(sortorder);
s.x=s.x(sortorder);
s.z=s.z(sortorder);

%%To plot the labeled channels:
% figure(1)
% close 1
% figure(1)
% plot(s.x,s.z,'.y')
% for i=1:length(s.channels)
% text(s.x(i),s.z(i),num2str(s.channels(i)),'FontSize',6)
% end
% axis equal