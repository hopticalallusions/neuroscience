%Caltech nanoprobe type 'C'
%Note: for probes with multiple shafts, shaft 1 should be centered near x=0
%and other shafts should be at x>0 when probes are pointing downward.

exceldata=[];

exceldata=[
          
     1     0     0     1
     2     0    80     1
     3     0   160     1
     4     0   240     1
     5     0   320     1
     6     0   400     1
     7     0   480     1
     8     0   560     1
     9     0   600     1
    10     0   520     1
    11     0   440     1
    12     0   360     1
    13     0   280     1
    14     0   200     1
    15     0   120     1
    16     0    40     1
    17  -250     0     2
    18  -250    80     2
    19  -250   160     2
    20  -250   240     2
    21  -250   320     2
    22  -250   400     2
    23  -250   480     2
    24  -250   560     2
    25  -250   600     2
    26  -250   520     2
    27  -250   440     2
    28  -250   360     2
    29  -250   280     2
    30  -250   200     2
    31  -250   120     2
    32  -250    40     2
    33  -500     0     3
    34  -500    80     3
    35  -500   160     3
    36  -500   240     3
    37  -500   320     3
    38  -500   400     3
    39  -500   480     3
    40  -500   560     3
    41  -500   600     3
    42  -500   520     3
    43  -500   440     3
    44  -500   360     3
    45  -500   280     3
    46  -500   200     3
    47  -500   120     3
    48  -500    40     3
    49  -750     0     4
    50  -750    80     4
    51  -750   160     4
    52  -750   240     4
    53  -750   320     4
    54  -750   400     4
    55  -750   480     4
    56  -750   560     4
    57  -750   600     4
    58  -750   520     4
    59  -750   440     4
    60  -750   360     4
    61  -750   280     4
    62  -750   200     4
    63  -750   120     4
    64  -750    40     4
          
          ];
      
s=[];
s.channels=exceldata(:,1);
s.x=-1*exceldata(:,2);   %the reference electrode is always the top right channel when the probes are pointing up.
s.z=exceldata(:,3);
s.shaft=exceldata(:,4);
s.tipelectrode=90;

%%To plot the labeled channels:
% figure(1)
% close 1
% figure(1)
% plot(s.x,s.z,'.y')
% for i=1:length(s.channels)
% text(s.x(i),s.z(i),num2str(s.channels(i)),'FontSize',6)
% end
% axis equal
