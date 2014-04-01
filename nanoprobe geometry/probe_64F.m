           
exceldata=[];

exceldata=[
     1   -10   175     1
     2   -10   225     1
     3   -10   275     1
     4   -10   325     1
     5   -10   375     1
     6   -10   425     1
     7   -10   475     1
     8   -10   525     1
     9   -10   575     1
    10   -10   625     1
    11   -10   675     1
    12   -10   725     1
    13   -10   775     1
    14   -10   125     1
    15   -10    75     1
    16    -6    25     1
    17     0     0     1
    18    10    50     1
    19    10   100     1
    20    10   750     1
    21    10   700     1
    22    10   650     1
    23    10   600     1
    24    10   550     1
    25    10   500     1
    32    10   450     1
    31    10   400     1
    30    10   350     1
    29    10   300     1
    28    10   250     1
    27    10   200     1
    26    10   150     1
    64  -290   150     2
    63  -290   200     2
    62  -290   250     2
    61  -290   300     2
    60  -290   350     2
    59  -290   400     2
    58  -290   450     2
    57  -290   500     2
    56  -290   550     2
    55  -290   600     2
    54  -290   650     2
    53  -290   700     2
    52  -290   750     2
    51  -290   100     2
    50  -290    50     2
    49  -300     0     2
    48  -306    25     2
    47  -310    75     2
    46  -310   125     2
    45  -310   775     2
    44  -310   725     2
    43  -310   675     2
    42  -310   625     2
    41  -310   575     2
    40  -310   525     2
    33  -310   475     2
    34  -310   425     2
    35  -310   375     2
    36  -310   325     2
    37  -310   275     2
    38  -310   225     2
    39  -310   175     2
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