           
exceldata=[];

exceldata=[
      1   -20   450     1
     2   -20   500     1
     3   -20   400     1
     4   -20   350     1
     5   -20   300     1
     6   -20   250     1
     7   -20   200     1
     8   -20   150     1
     9   -20   100     1
    10   -16    50     1
    11     0    25     1
    12     0   125     1
    13     0   225     1
    14     0   325     1
    15     0   425     1
    16     0   525     1
    17     0   475     1
    18     0   375     1
    19     0   275     1
    20     0   175     1
    21     0    75     1
    22     0     0     1
    23    16    50     1
    24    20   100     1
    25    20   150     1
    32    20   200     1
    31    20   250     1
    30    20   300     1
    29    20   350     1
    28    20   500     1
    27    20   450     1
    26    20   400     1
    64  -280   400     2
    63  -280   450     2
    62  -280   500     2
    61  -280   350     2
    60  -280   300     2
    59  -280   250     2
    58  -280   200     2
    57  -280   150     2
    56  -280   100     2
    55  -284    50     2
    54  -300     0     2
    53  -300    75     2
    52  -300   175     2
    51  -300   275     2
    50  -300   375     2
    49  -300   475     2
    48  -300   525     2
    47  -300   425     2
    46  -300   325     2
    45  -300   225     2
    44  -300   125     2
    43  -300    25     2
    42  -316    50     2
    41  -320   100     2
    40  -320   150     2
    33  -320   200     2
    34  -320   250     2
    35  -320   300     2
    36  -320   350     2
    37  -320   400     2
    38  -320   500     2
    39  -320   450     2

          
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