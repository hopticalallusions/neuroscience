%breakable probe
%1 or 4; 2 or 3; 5 or 8; 6 or 7.
%e.g. a probe with shaft 1, 3, 8, 7 would be called 128E_1387

exceldata=[];

exceldata=[
    

   
          26       -1494         150           5
          27       -1494         200           5
          28       -1494         250           5
          29       -1494         300           5
          30       -1494         350           5
          31       -1494         400           5
          32       -1494         450           5
          25       -1494         500           5
          24       -1494         550           5
          23       -1494         600           5
          22       -1494         650           5
          21       -1494         700           5
          20       -1494         750           5
          19       -1494         100           5
          18       -1494          50           5
          17       -1504           0           5
          16       -1510          25           5
          15       -1514          75           5
          14       -1514         125           5
          13       -1514         775           5
          12       -1514         725           5
          11       -1514         675           5
          10       -1514         625           5
           9       -1514         575           5
           8       -1514         525           5
           7       -1514         475           5
           6       -1514         425           5
           5       -1514         375           5
           4       -1514         325           5
           3       -1514         275           5
           2       -1514         225           5
           1       -1514         175           5
          64       -1744         150           6
          63       -1744         200           6
          62       -1744         250           6
          61       -1744         300           6
          60       -1744         350           6
          59       -1744         400           6
          58       -1744         450           6
          57       -1744         500           6
          56       -1744         550           6
          55       -1744         600           6
          54       -1744         650           6
          53       -1744         700           6
          52       -1744         750           6
          51       -1744         100           6
          50       -1744          50           6
          49       -1754           0           6
          48       -1760          25           6
          47       -1764          75           6
          46       -1764         125           6
          45       -1764         775           6
          44       -1764         725           6
          43       -1764         675           6
          42       -1764         625           6
          41       -1764         575           6
          40       -1764         525           6
          33       -1764         475           6
          34       -1764         425           6
          35       -1764         375           6
          36       -1764         325           6
          37       -1764         275           6
          38       -1764         225           6
          39       -1764         175           6
         103        -764        1775           4
         102        -764        1825           4
         101        -764        1875           4
         100        -764        1925           4
          99        -764        1975           4
          98        -764        2025           4
          97        -764        2075           4
         104        -764        2125           4
         105        -764        2175           4
         106        -764        2225           4
         107        -764        2275           4
         108        -764        2325           4
         109        -764        2375           4
         110        -764        1725           4
         111        -764        1675           4
         112        -760        1625           4
         113        -754        1600           4
         114        -744        1650           4
         115        -744        1700           4
         116        -744        2350           4
         117        -744        2300           4
         118        -744        2250           4
         119        -744        2200           4
         120        -744        2150           4
         121        -744        2100           4
         122        -744        2050           4
         123        -744        2000           4
         124        -744        1950           4
         125        -744        1900           4
         126        -744        1850           4
         127        -744        1800           4
         128        -744        1750           4
          65        -514        1775           3
          66        -514        1825           3
          67        -514        1875           3
          68        -514        1925           3
          69        -514        1975           3
          70        -514        2025           3
          71        -514        2075           3
          72        -514        2125           3
          73        -514        2175           3
          74        -514        2225           3
          75        -514        2275           3
          76        -514        2325           3
          77        -514        2375           3
          78        -514        1725           3
          79        -514        1675           3
          80        -510        1625           3
          81        -504        1600           3
          82        -494        1650           3
          83        -494        1700           3
          84        -494        2350           3
          85        -494        2300           3
          86        -494        2250           3
          87        -494        2200           3
          88        -494        2150           3
          89        -494        2100           3
          96        -494        2050           3
          95        -494        2000           3
          94        -494        1950           3
          93        -494        1900           3
          92        -494        1850           3
          91        -494        1800           3
          90        -494        1750           3
          
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



%To plot the labeled channels:
figure(1)
close 1
figure(1)
plot(s.x,s.z,'.y')
for i=1:length(s.channels)
text(s.x(i),s.z(i),num2str(s.channels(i)),'FontSize',6)
end
axis equal