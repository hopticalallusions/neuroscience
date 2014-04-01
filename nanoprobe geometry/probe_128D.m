           
exceldata=[];

exceldata=[
    
  103        -340         175           1
         102        -340         225           1
         101        -340         275           1
         100        -340         325           1
          99        -340         375           1
          98        -340         425           1
          97        -340         475           1
         104        -340         525           1
         105        -340         575           1
         106        -340         625           1
         107        -340         675           1
         108        -340         725           1
         109        -340         775           1
         110        -340         125           1
         111        -340          75           1
         112        -336          25           1
         113        -330           0           1
         114        -320          50           1
         115        -320         100           1
         116        -320         750           1
         117        -320         700           1
         118        -320         650           1
         119        -320         600           1
         120        -320         550           1
         121        -320         500           1
         122        -320         450           1
         123        -320         400           1
         124        -320         350           1
         125        -320         300           1
         126        -320         250           1
         127        -320         200           1
         128        -320         150           1
          65         -10         175           2
          66         -10         225           2
          67         -10         275           2
          68         -10         325           2
          69         -10         375           2
          70         -10         425           2
          71         -10         475           2
          72         -10         525           2
          73         -10         575           2
          74         -10         625           2
          75         -10         675           2
          76         -10         725           2
          77         -10         775           2
          78         -10         125           2
          79         -10          75           2
          80          -6          25           2
          81           0           0           2
          82          10          50           2
          83          10         100           2
          84          10         750           2
          85          10         700           2
          86          10         650           2
          87          10         600           2
          88          10         550           2
          89          10         500           2
          96          10         450           2
          95          10         400           2
          94          10         350           2
          93          10         300           2
          92          10         250           2
          91          10         200           2
          90          10         150           2
          26        -650         150           3
          27        -650         200           3
          28        -650         250           3
          29        -650         300           3
          30        -650         350           3
          31        -650         400           3
          32        -650         450           3
          25        -650         500           3
          24        -650         550           3
          23        -650         600           3
          22        -650         650           3
          21        -650         700           3
          20        -650         750           3
          19        -650         100           3
          18        -650          50           3
          17        -660           0           3
          16        -666          25           3
          15        -670          75           3
          14        -670         125           3
          13        -670         775           3
          12        -670         725           3
          11        -670         675           3
          10        -670         625           3
           9        -670         575           3
           8        -670         525           3
           7        -670         475           3
           6        -670         425           3
           5        -670         375           3
           4        -670         325           3
           3        -670         275           3
           2        -670         225           3
           1        -670         175           3
          64        -980         150           4
          63        -980         200           4
          62        -980         250           4
          61        -980         300           4
          60        -980         350           4
          59        -980         400           4
          58        -980         450           4
          57        -980         500           4
          56        -980         550           4
          55        -980         600           4
          54        -980         650           4
          53        -980         700           4
          52        -980         750           4
          51        -980         100           4
          50        -980          50           4
          49        -990           0           4
          48        -996          25           4
          47       -1000          75           4
          46       -1000         125           4
          45       -1000         775           4
          44       -1000         725           4
          43       -1000         675           4
          42       -1000         625           4
          41       -1000         575           4
          40       -1000         525           4
          33       -1000         475           4
          34       -1000         425           4
          35       -1000         375           4
          36       -1000         325           4
          37       -1000         275           4
          38       -1000         225           4
          39       -1000         175           4     
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
