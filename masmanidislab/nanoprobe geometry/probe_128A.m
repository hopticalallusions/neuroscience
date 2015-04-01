           
exceldata=[];

exceldata=[
    
    103         -20         350           1
         102         -20         400           1
         101         -20         450           1
         100         -20         500           1
          99         -20         550           1
          98         -20         600           1
          97         -20         650           1
         104         -20         700           1
         105         -20         750           1
         106         -20         800           1
         107         -20         850           1
         108         -20         900           1
         109         -20         950           1
         110         -20        1000           1
         111         -20        1050           1
         112         -20         300           1
         113         -20         250           1
         114         -20         200           1
         115         -20         150           1
         116         -20         100           1
         117         -16          50           1
         118           0           0           1
         119           0          75           1
         120           0         175           1
         121           0         275           1
         122           0         375           1
         123           0         475           1
         124           0         575           1
         125           0         675           1
         126           0         775           1
         127           0         875           1
         128           0         975           1
          65           0        1025           1
          66           0         925           1
          67           0         825           1
          68           0         725           1
          69           0         625           1
          70           0         525           1
          71           0         425           1
          72           0         325           1
          73           0         225           1
          74           0         125           1
          75           0          25           1
          76          16          50           1
          77          20         100           1
          78          20         150           1
          79          20         200           1
          80          20         250           1
          81          20        1050           1
          82          20        1000           1
          83          20         950           1
          84          20         900           1
          85          20         850           1
          86          20         800           1
          87          20         750           1
          88          20         700           1
          89          20         650           1
          96          20         600           1
          95          20         550           1
          94          20         500           1
          93          20         450           1
          92          20         400           1
          91          20         350           1
          90          20         300           1
          26        -380         300           2
          27        -380         350           2
          28        -380         400           2
          29        -380         450           2
          30        -380         500           2
          31        -380         550           2
          32        -380         600           2
          25        -380         650           2
          24        -380         700           2
          23        -380         750           2
          22        -380         800           2
          21        -380         850           2
          20        -380         900           2
          19        -380         950           2
          18        -380        1000           2
          17        -380        1050           2
          16        -380         250           2
          15        -380         200           2
          14        -380         150           2
          13        -380         100           2
          12        -384          50           2
          11        -400          25           2
          10        -400         125           2
           9        -400         225           2
           8        -400         325           2
           7        -400         425           2
           6        -400         525           2
           5        -400         625           2
           4        -400         725           2
           3        -400         825           2
           2        -400         925           2
           1        -400        1025           2
          64        -400         975           2
          63        -400         875           2
          62        -400         775           2
          61        -400         675           2
          60        -400         575           2
          59        -400         475           2
          58        -400         375           2
          57        -400         275           2
          56        -400         175           2
          55        -400          75           2
          54        -400           0           2
          53        -416          50           2
          52        -420         100           2
          51        -420         150           2
          50        -420         200           2
          49        -420         250           2
          48        -420         300           2
          47        -420        1050           2
          46        -420        1000           2
          45        -420         950           2
          44        -420         900           2
          43        -420         850           2
          42        -420         800           2
          41        -420         750           2
          40        -420         700           2
          33        -420         650           2
          34        -420         600           2
          35        -420         550           2
          36        -420         500           2
          37        -420         450           2
          38        -420         400           2
          39        -420         350           2

          
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