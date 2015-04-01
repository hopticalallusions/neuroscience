           
exceldata=[];

exceldata=[
           1           0        1025           1
           2           0         925           1
           3           0         825           1
           4           0         725           1
           5           0         625           1
           6           0         525           1
           7           0         425           1
           8           0         325           1
           9           0         225           1
          10           0         125           1
          11           0          25           1
          12          16          50           1
          13          20         100           1
          14          20         150           1
          15          20         200           1
          16          20         250           1
          17          20        1050           1
          18          20        1000           1
          19          20         950           1
          20          20         900           1
          21          20         850           1
          22          20         800           1
          23          20         750           1
          24          20         700           1
          25          20         650           1
          32          20         600           1
          31          20         550           1
          30          20         500           1
          29          20         450           1
          28          20         400           1
          27          20         350           1
          26          20         300           1
          64           0         975           1
          63           0         875           1
          62           0         775           1
          61           0         675           1
          60           0         575           1
          59           0         475           1
          58           0         375           1
          57           0         275           1
          56           0         175           1
          55           0          75           1
          54           0           0           1
          53         -16          50           1
          52         -20         100           1
          51         -20         150           1
          50         -20         200           1
          49         -20         250           1
          48         -20         300           1
          47         -20        1050           1
          46         -20        1000           1
          45         -20         950           1
          44         -20         900           1
          43         -20         850           1
          42         -20         800           1
          41         -20         750           1
          40         -20         700           1
          33         -20         650           1
          34         -20         600           1
          35         -20         550           1
          36         -20         500           1
          37         -20         450           1
          38         -20         400           1
          39         -20         350           1
          
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

