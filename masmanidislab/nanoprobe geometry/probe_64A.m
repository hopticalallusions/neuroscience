%Caltech nanoprobe type 'A'
%Note: for probes with multiple shafts, shaft 1 should be centered near x=0
%and other shafts should be at x>0 when probes are pointing downward.

exceldata=[];

exceldata=[
          
           1          32        1293           1
           2          31        1227           1
           3          31        1163           1
           4          31        1100           1
           5          29        1040           1
           6          29         980           1
           7          29         920           1
           8          27         860           1
           9          26         800           1
          10          25         740           1
          11          25         680           1
          12          25         620           1
          13          25         560           1
          14          25         500           1
          15          25         440           1
          16          25         380           1
          17          25         320           1
          18          25         260           1
          19          25         200           1
          20          25         140           1
          21          20          80           1
          22           0           0           1
          23           0         110           1
          24           0         230           1
          25           0         350           1
          26           0         470           1
          27           0         590           1
          28           0         710           1
          29           0         830           1
          30           0         950           1
          31           0        1070           1
          32           0        1195           1
          33           0        1261           1
          34           0        1133           1
          35           0        1010           1
          36           0         890           1
          37           0         770           1
          38           0         650           1
          39           0         530           1
          40           0         410           1
          41           0         290           1
          42           0         170           1
          43           0          45           1
          44         -20          80           1
          45         -25         140           1
          46         -25         200           1
          47         -25         260           1
          48         -25         320           1
          49         -25         380           1
          50         -25         440           1
          51         -25         500           1
          52         -25         560           1
          53         -25         620           1
          54         -25         680           1
          55         -25         740           1
          56         -26         800           1
          57         -27         860           1
          58         -29         920           1
          59         -29         980           1
          60         -29        1040           1
          61         -31        1100           1
          62         -31        1163           1
          63         -31        1227           1
          64         -32        1293           1
          
          ];
      
s=[];
s.channels=exceldata(:,1);
s.x=-1*exceldata(:,2);   %note the reference electrode is the top right channel when the probes are pointing up.
s.z=exceldata(:,3);
s.shaft=exceldata(:,4);
s.tipelectrode=45;

%%To plot the labeled channels:
% figure(1)
% close 1
% figure(1)
% plot(s.x,s.z,'.y')
% for i=1:length(s.channels)
% text(s.x(i),s.z(i),num2str(s.channels(i)),'FontSize',6)
% end
% axis equal