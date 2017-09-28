%plot behavior data

figure; hold on;
%v1
day =    [ 0 1 2  5 6 7 8  9  12 13  14  15  16 20 26 36 ];
rewards =[ 6 6 1 11 1 3 1 40 171 78 124 142 136 99 66 21 ];
plot(day,rewards);
%v2
day =    [  0 1  2  5  6 8 9 12 13 ];
rewards =[ 11 6 12 16 11 9 9 11  5 ];
plot(day,rewards);
%v3
day =    [  0 1 2 5 6 7  8  9 12 13  14 15 16 20 ];
rewards =[ 10 3 3 2 4 6 22 34 27 60 169 75 25 17 ];
plot(day,rewards);
%v4
day =    [  12  13  14  15  16 20 ];
rewards =[ 130 158 200 213 149 85 ];
plot(day,rewards);
%v4 post surgery
day =    [  0  4 7  8  28  29  31  32  36  37 ];
rewards =[ 19 13 0 17 226 297 168 392 204 191 ];
plot(day,rewards);
%collapsed days into one day where rewards obtained multiple times per day