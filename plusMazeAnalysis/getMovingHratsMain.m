movInitBlob.stopTrigTime = [];
movInitBlob.stopTrigSpeedStack = [];
movInitBlob.stopTrigRatLabel = {};
movInitBlob.stopTrigSession = {};
movInitBlob.stopTrigSwrTimes = [];
movInitBlob.stopTrigSwrMag = [];
movInitBlob.stopTrigSwrCh = [];

movInitBlob.goTrigTime = [];
movInitBlob.goTrigSpeedStack = [];
movInitBlob.goTrigRatLabel = {};
movInitBlob.goTrigSession = {};
movInitBlob.goTrigSwrTimes = [];
movInitBlob.goTrigSwrMag = [];
movInitBlob.goTrigSwrCh = [];
movInitBlob.swrTrigSpeedStack = [];
movInitBlob.swrTrigRatLabel = {};
movInitBlob.swrTrigSession = {};
movInitBlob.swrTrigTime = [];
movInitBlob.swrTrigMag = [];
movInitBlob.swrTrigCh = {};




rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
swrFiles={ 'SWR84.ncs', 'CSC76.ncs', 'CSC56.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
swrLookup = containers.Map(rats,swrFiles);

rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
thetaFiles={ 'SWR20.ncs', 'CSC68.ncs', 'CSC56.ncs', 'CSC46.ncs', 'CSC88.ncs', 'CSC6.ncs' };
thetaLookup = containers.Map(rats,swrFiles);



disk = '/Volumes/bigExFatDat/compactPlusmaze/';

%% THIS DAY FAILS BECAUSE IT HASN"T BEEN CUT

ratName='h5'; %    h5    
dateStr='2018-04-27';    
path=[ disk '/' ratName '/' dateStr '/' ];
ttFilenames=[];
rotationalParameters.centerX = 370;
rotationalParameters.centerY = 255;
rotationalParameters.degToRotate = 48;
rotationalParameters.xoffset = 300;
rotationalParameters.yoffset = 300;
swrFilename=swrLookup(ratName);
thetaFilename = thetaLookup(ratName);
%%%    h5    h5    h5    h5    h5    h5
%    2018-04-27    2018-04-27    2018-04-27    2018-04-27    2018-04-27    2018-04-27
behaviorData.trial            = [     1   2    3    4    5    6    ];
behaviorData.timeToMazeSec    = [    105    784    1243    2650    2893    3115 ];
behaviorData.timeToOpen       = [    126    801    1286    2677    2913    3141    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    625    1045    2270    2721    2971    -1    ];
behaviorData.timeToBucketSec  = [    639    1065    2285    2731    2988    3603];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    1    0    0    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1
%    squares    squares    squares    squares    squares    squares
%    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



%%



dateStr='2018-05-01';    % 2018-05-01    
path=[ disk '/' ratName '/' dateStr '/' ];
% h5   2018-05-01    
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    ];
behaviorData.timeToMazeSec    = [    36    325    511    787    1185    1381    1585    1770    2009    2316    2738    3026    3237    3450    ];
behaviorData.timeToOpen       = [    53    341    538    829    1210    1391    1623    106860    2027    2464    2852    3070    3247    3467    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    -1    375    586    962    1233    1438    1632    1842    2090    2474    2878    3084    3257    3474    ];
behaviorData.timeToBucketSec  = [    165    390    617    980    1254    1464    1658    1889    2124    2499    2902    3106    3283    3496    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    0    0    0    0    0    1    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    15    15    15    15    15    15    15    15    15    15    15    15    15    ];
%    start    start    start    start    start    start    start    start    start    start    start    start    start    start
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado

try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-05-02';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-02    2018-05-02    2018-05-02    2018-05-02    2018-05-02    2018-05-02    2018-05-02    2018-05-02    2018-05-02    2018-05-02
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    ];
behaviorData.timeToMazeSec    = [    67    392    572    782    949    1185    1367    1577    1781    2013    ];
behaviorData.timeToOpen       = [    165    422    582    787    965    1203    1395    1600    1831    2042    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    210    428    588    793    1014    1236    1403    1608    1837    2048    ];
behaviorData.timeToBucketSec  = [    243    458    626    819    1074    1252    1440    1644    1890    2080    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    0    0    1    1    0    0    0    0    ];
behaviorData.barrierHeight    = [    15    25    25    25    25    25    25    25    25    25    ];
%    start    start    start    start    start    start    start    start    start    start
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end





dateStr='2018-05-03';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5
%    2018-05-03    2018-05-03    2018-05-03    2018-05-03    2018-05-03
behaviorData.trial            = [    1    2    3    4    5    ];
behaviorData.timeToMazeSec    = [    28    344    618    1078    1318    ];
behaviorData.timeToOpen       = [    195    400    681    1168    1416    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    203    428    907    1177    1425    ];
behaviorData.timeToBucketSec  = [    221    485    927    1188    1436    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    1    1    0    0    ];
behaviorData.barrierHeight    = [    25    25    25    25    25    ];
%    start    start    start    start    start
%    squares    squares    squares    squares    squares
%    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end





dateStr='2018-05-07';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07    2018-05-07
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    ];
behaviorData.timeToMazeSec    = [    429    891    1045    1200    1401    1400    1628    1864    2094    2274    2419    2604    2814    3191    3433    ];
behaviorData.timeToOpen       = [    656    923    1051    1207    1418    1418    1676    1908    2107    2280    2438    2624    2999    3230    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    683    933    1058    1214    1424    1425    1683    1915    2114    2305    2447    2634    3010    3244    3471    ];
behaviorData.timeToBucketSec  = [    705    965    1099    1279    1463    1462    1762    1962    2145    2340    2505    2649    3045    3260    3516    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    0    0    0    0    0    0    1    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    5    15    20    20    25    30    30    30    30    30    30    30    30    30    30    ];
%    start    start    start    start    start    start    start    start    start    start    start    start    start    start    start
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    circles    circles    circles
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end
% 




dateStr='2018-05-08';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08    2018-05-08
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    ];
behaviorData.timeToMazeSec    = [    75    277    419    643    821    1011    1282    1439    1738    2060    2420    2690    2880    3286    ];
behaviorData.timeToOpen       = [    139    301    433    646    -1    1045    -1    1546    -1    2272    -1    -1    185700    3391    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    158    309    439    654    855    1053    1294    1552    1752    2279    2461    2728    3102    3398];
behaviorData.timeToBucketSec  = [    184    329    485    691    876    1083    1302    1580    1761    2293    2480    2739    3113    3411    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    0    1    0    0    0    0    0    1    0    0    0    ];
behaviorData.barrierHeight    = [    25    25    25    25    0    25    0    25    0    25    0    0    25    25    ];
%    start    start    start    start    -1    start    -1    start    -1    start    -1    -1    start    start
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    circles    circles    circles    circles
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end





dateStr='2018-05-09';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09    2018-05-09
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    ];
behaviorData.timeToMazeSec    = [    85    267    438    638    825    1020    1259    1533    1789    2535    2806    3022    3256    3480    3693    3973    4358    4512    4707    4883    5040    5207    ];
behaviorData.timeToOpen       = [    115    295    462    664    860    1065    1289    1563    1810    2558    2827    3044    3281    3509    3721    3993    4379    4536    4731    4902    5061    5228    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    124    301    475    684    868    1071    1295    1591    1829    2562    2852    3070    3302    3528    3755    4026    4390    4575    4744    4911    5068    5246    ];
behaviorData.timeToBucketSec  = [    142    323    507    703    889    1095    1310    1625    1843    2673    2872    3094    3330    3558    3791    4042    4410    4589    4761    4932    5084    5291    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    0    0    0    0    1    0    1    1    1    1    1    1    1    0    1    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    squares    squares    squares    squares    squares    squares    squares    squares    circles    squares    squares    squares    squares    squares    squares    squares    squares    squares
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-05-11';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11    2018-05-11
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    ];
behaviorData.timeToMazeSec    = [    36    186    318    451    596    849    1031    1373    1532    1671    1853    1993    2488    2640    2795    3051    3205    3349    3498    3627    3767    3932    4267    ];
behaviorData.timeToOpen       = [    57    204    337    468    616    872    1050    1389    1552    1689    1870    2015    2512    2659    2816    3071    3220    3367    3516    3647    3793    3956    4278    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    4346  ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    72    214    344    475    754    911    1070    1420    1576    1761    1888    2029    2530    2671    2830    3090    3231    3391    3521    3658    3806    3973    4350    ];
behaviorData.timeToBucketSec  = [    90    242    364    505    769    930    1083    1433    1582    1775    1917    2045    2564    2700    2865    3122    3239    3410    3535    3682    3826    4024    4391    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];    
behaviorData.madeError        = [    0    0    0    0    1    1    0    1    1    1    1    1    1    1    1    1    1    1    0    1    1    1    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    0    0    0    0    0    0    0    1
%    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    avocado
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam
%    AGH
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end





dateStr='2018-05-14';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14    2018-05-14
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    ];
behaviorData.timeToMazeSec    = [    0    138    284    418    539    653    773    929    1049    1244    1375    1508    1863    2050    2204    2409    2595    2749    2883    2995    3176    3402    3602    3767    ];
behaviorData.timeToOpen       = [    10    155    301    437    560    672    789    949    1065    1264    1391    1523    1882    2074    2217    2425    2610    2770    2900    3007    3189    3417    3617    3779    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    955    1130    1267    1396    1534    1932    2105    2295    2466    2625    2775    2908    3015    3254    3495    3656    3792    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    37    162    318    448    564    675    793    959    1135    1271    1400    1540    1937    2110    2300    2471    2629    2780    2912    3022    3259    3501    3662    3796    ];
behaviorData.timeToBucketSec  = [    52    206    331    470    592    692    822    985    1144    1283    1427    1563    1950    2119    2313    2494    2645    2794    2921    3088    3283    3528    3678    3817    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    1    1    1    0    0    0    0    1    0    0    0    1    1    1    1    1    0    0    0    1    1    1    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    20    20    20    20    25    25    25    25    25    25    25    25    25    30    30    30    30    ];
%    -1    -1    -1    -1    -1    -1    -1    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm    rewarded arm
%    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
%    Pam    Pam    Pam    Pam    avocado    avocado    avocado    avocado    Pam    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    avocado    avocado    avocado    Pam    Pam    Pam    Pam
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end


dateStr='2018-05-15';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15    2018-05-15
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    ];
behaviorData.timeToMazeSec    = [    129    464    655    831    1015    1195    1292    1369    1451    1535    1648    2089    2182    2272    2402    2559    2709    2799    2951    3028    3138    3208    3275    3386    3441    3567    3627    3727    3783    3906    3990    4049    4165    4292    4369    4451    ];
behaviorData.timeToOpen       = [    161    490    678    846    1032    1215    1309    1385    1470    1551    1672    2105    2189    2282    2414    2567    2716    2807    2962    3047    3146    3217    3288    3396    3452    3576    3640    3735    3795    3913    4003    4061    4174    4299    4377    4458    ];
behaviorData.timeToJump1Sec   = [    313    511    686    869    1038    1220    1317    1406    1478    1592    -1    -1    -1    -1    -1    -1    -1    -1    -1    3052    -1    -1    3296    -1    -1    -1    3659    -1    3811    -1    -1    4071    4180    -1    4380    4462    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    319    515    690    875    1042    1224    1320    1412    1485    1597    1711    2118    2196    2293    2420    2576    2722    2814    2973    3058    3056    3226    3299    3401    3473    3581    3663    3747    3815    3930    4010    4076    4183    4307    4384    4466    ];
behaviorData.timeToBucketSec  = [    351    544    718    900    1085    1239    1345    1425    1490    1602    1736    2134    2210    2304    2435    2590    2732    2829    2977    3075    3158    3229    3324    3410    3479    3591    3671    3749    3833    3940    4013    4096    4196    4312    4398    4474    ];
behaviorData.timeToContRetSec = [    -1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
behaviorData.madeError        = [    0    1    0    1    0    1    1    1    1    1    0    0    0    0    0    0    0    0    1    0    1    1    0    1    1    1    0    1    0    1    1    0    0    1    0    0    ];
behaviorData.barrierHeight    = [    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    ];
%    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    avovado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
%    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures
%    avocado    avocado    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end


dateStr='2018-05-16';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16    2018-05-16
behaviorData.trial            = [      1      2      3      4      5      6       7       8       9      10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31      32      33      34      35      36      37      38    ]; % trial
behaviorData.timeToMazeSec    = [    303    441    539    596    745    841     951    1007    1054    1138    1193    1253    1327    1388    1444    1504    1557    1600    1657    1712    1824    1864    1900    1968    2075    2153    2219    2269    2338    2621    2718    2777    2833    2873    2929    3056    3121    3187    ]; % to maze
behaviorData.timeToOpen       = [    314    452    559    607    759    860     989    1036    1093    1163    1215    1279    1346    1409    1457    1519    1575    1629    1676    1730    1828    1865    1928    2001      -1    2166      -1    2298      -1    2645    2737    2796    2850    2894    2991    3082      -1    3219    ]; % gate opened
behaviorData.timeToJump1Sec   = [     -1     -1     -1    614     -1    870     993      -1    1102      -1    1219    1284    1352      -1    1496    1529    1585    1634    1679    1737      -1    1869    1933    2010    2087    2173    2228    2302      -1    2675    2749    2801    2853    2905    2995      -1    3156    3247    ]; % jump 1
behaviorData.timeToJump2Sec   = [     -1     -1     -1     -1     -1     -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1    1761      -1    1876    1936      -1    2109      -1    2233    2307      -1    2691    2754    2809    2857    2909    3001      -1    3164    3251    ]; % jump 2
behaviorData.timeToSugarSec   = [    334    457    565    619    763    874     998    1042    1105    1170    1223    1288    1354    1413    1476    1533    1590    1639    1683    1750    1833    1879    1941    2039    2114    2178    2237    2310      -1    2695    2759    2813    2862    2913    3004      -1    3167    3255    ]; % reward
behaviorData.timeToBucketSec  = [    344    470    571    654     -1     -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1    2344      -1      -1      -1      -1      -1      -1      -1      -1    3285    ]; % to bucket
behaviorData.timeToContRetSec = [     -1     -1     -1     -1    820    948    1004    1050    1133    1189    1250    1319    1366    1440    1498    1554    1596    1655    1711    1805    1863    1897    1965    2073    2151    2217    2267    2336      -1    2716    2771    2832    2870    2927    3019    3120    3185      -1    ]; % cont. return
behaviorData.madeError        = [      1      1      1      0      1      0       0       1       0       1       0       0       0       1       1       0       0       0       0       1       1       0       0       1       0       1       0       0      -1       0       0       0       0       0       0       1       0       0    ]; % error
behaviorData.barrierHeight    = [     15     15     15     15     15     15      15      15      15      15      15      15      15      15      22      15      15      15      15      15      15      15      15      15      20      20      20      20      20      20      20      20      20      20      20      20      20      20    ]; % barrier height
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    Pam    Pam    Pam    Pam    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start    Pam; start
%    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-05-18';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18    2018-05-18
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    ];
behaviorData.timeToMazeSec    = [    0    84    191    252    308    399    462    560    646    774    899    1006    1110    1339    1443    1539    1658    1763    1848    1935    2070    2192    2381    2465    ];
behaviorData.timeToOpen       = [    0    97    202    262    320    413    475    569    659    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    840    907    1011    1113    1356    1450    1569    1666    1780    1852    1939    2088    2222    2400    2493    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    1368    1457    1576    1674    1786    1860    1984    2131    2243    2407    2500    ];
behaviorData.timeToSugarSec   = [    9    110    207    267    327    419    488    574    665    848    914    1017    1120    1372    1460    1579    1680    1789    1863    1988    2135    2247    2411    2503    ];
behaviorData.timeToBucketSec  = [    19    128    213    271    355    423    500    582    679    857    940    1033    1134    1387    1481    1589    1693    1797    1874    2001    2149    2278    2442    2519    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    1    1    0    1    0    0    0    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    25    30    30    30    25    25    25    25    25    25    25    25    25    25    25    ];
%behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    25    30    30    30    25;15    25;15    25;15    25;25    25;25    25;25    25;30    25;30    25;30    25;30    25;30    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    start    start    start    start    start; reward    start; reward    start; reward    start; reward    start; reward    start; reward    start; reward    start; reward    start; reward    start; reward    start; reward
%    squares    start
%    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-06-08';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08    2018-06-08
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    ];
behaviorData.timeToMazeSec    = [    102    180    231    344    401    504    587    701    778    858    925    1013    1109    1198    1285    1373    1449    1534    1603    1698    1796    1890    2031    2135    2197    2304    2396    2475    ];
behaviorData.timeToOpen       = [    128    192    243    358    415    521    603    712    789    866    936    1032    1131    1208    1297    1384    1461    1546    1617    1712    1822    1907    2061    2148    2216    2319    2414    2485    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    1220    197    261    363    422    525    607    716    793    871    941    1036    1135    1214    1301    1388    1464    1550    1622    1718    1831    1912    2065    2152    2222    2326    2421    2489    ];
behaviorData.timeToBucketSec  = [    144    200    297    365    443    530    643    735    804    889    946    1060    1140    1222    1308    1392    1467    1552    1625    1731    1846    1917    2069    2164    2224    2334    2428    2500    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    1    0    1    0    1    0    0    0    0    1    0    0    0    0    1    1    1    1    0    0    1    0    0    1    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1

%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-06-11';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11    2018-06-11
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47    48    49    ];
behaviorData.timeToMazeSec    = [    322    409    527    623    682    762    846    935    1017    1117    1233    1333    1436    1512    1583    1667    1746    1817    1875    1931    2046    2093    2152    2245    2315    2408    2494    2564    2609    2678    2759    2847    2896    2971    3058    3120    3211    3287    3386    3474    3554    3625    3696    3747    3897    3946    4111    4190    4239    ];
behaviorData.timeToOpen       = [    345    432    537    635    693    772    857    946    1033    1134    1250    1348    1446    1520    1595    1686    1759    1828    1885    1942    2053    2103    2160    2251    2324    2417    2505    2573    2618    2688    2769    2856    2906    2923    3067    3152    3228    3302    3397    3487    3567    3635    3705    3761    3902    3956    4121    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2450    2508    2577    2622    2691    2772    2859    2914    2999    3073    3156    3231    3323    3402    3492    3570    3642    3708    3767    3906    3963    4125    4196    4247    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    4202    4266    ];
behaviorData.timeToSugarSec   = [    360    436    545    639    697    776    861    954    1037    1143    1260    1359    1451    1524    1605    1693    1763    1832    1889    1946    2058    2107    2165    2255    2328    2457    2511    2579    2625    2694    2777    2862    2918    3001    3076    3159    3234    3326    3404    3495    3572    3645    3712    3770    3909    3967    4128    4205    4268    ];
behaviorData.timeToBucketSec  = [    370    468    574    656    712    792    870    958    1040    1146    1288    1406    1464    1527    1609    1711    1778    1840    1902    1951    2068    2117    2174    2277    2344    2472    2525    2587    2642    2732    2791    2868    2926    3006    3080    3163    3216    3352    3413    3533    3579    3680    3722    3791    3924    3973    4141    4214    4284    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    0    0    0    0    1    1    1    0    0    0    1    1    0    0    0    0    1    0    0    1    0    0    0    0    0    0    0    0    0    0    1    1    1    1    0    1    0    1    0    0    0    0    1    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms; start arm    both arms; start arm
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-06-12';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12    2018-06-12
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    ];
behaviorData.timeToMazeSec    = [    53    152    230    504    590    674    743    816    912    1038    1134    1247    1342    1426    1532    1606    1683    1792    1881    1949    2029    2125    2194    2284    2369    2493    2576    2648    2733    2817    2886    2955    3050    3157    3264    3340    3404    3504    3581    ];
behaviorData.timeToOpen       = [    70    163    241    514    600    684    750    829    924    1050    1143    1261    1351    1455    1543    1622    1697    1809    1891    1961    2040    2136    2205    2295    2387    2505    2587    2657    2743    2831    2896    2964    3057    3165    3272    3349    3414    3517    3591];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    3172    3277    3356    3436    3522    3598    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    82    169    249    518    605    689    758    834    929    1054    1147    1266    1355    1463    1549    1627    1703    1813    1898    1966    2044    2140    2209    2299    2392    2509    2591    2663    2748    2834    2899    2968    3061    3177    3282    3361    3438    3466    3604    ];
behaviorData.timeToBucketSec  = [    90    184    262    543    633    704    774    869    953    1064    1153    1272    1368    1470    1552    1634    1729    1825    1913    1970    2057    2164    2216    2331    2399    2523    2599    2672    2755    2845    2923    2984    3073    3199    3308    3372    3448    3536    3618    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    1    0    0    0    0    0    0    1    1    1    1    1    1    1    0    1    0    1    0    0    1    0    1    0    0    0    1    0    0    0    0    0    0    0    1    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    30    30    30    30    30    30    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    both arms    both arms    both arms    both arms    both arms    both arms
%    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-06-13';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13    2018-06-13
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    ];
behaviorData.timeToMazeSec    = [    161    253    322    429    506    603    683    756    880    986    1086    1207    1287    1390    1462    1537    1603    1681    1755    1934    2026    2099    2175    2245    2328    2407    2478    2557    2642    2729    2827    ];
behaviorData.timeToOpen       = [    175    267    332    438    519    611    692    765    895    997    1095    1217    1300    1400    1471    1546    1611    1690    1765    1945    2037    2108    2183    2255    2335    2416    2489    2565    2655    2736    2833    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    182    272    336    443    524    616    696    768    899    1000    1101    1222    1304    1404    1474    1550    1615    1694    1769    1948    2043    2111    2187    2259    2340    2419    2492    2569    2659    2740    2838];
behaviorData.timeToBucketSec  = [    200    295    350    455    543    631    704    790    905    1009    1120    1227    1313    1415    1483    1558    1632    1702    1776    1952    2055    2116    2208    2262    2355    2440    2502    2578    2675    2756    2843];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    1    0    0    0    0    1    1    0    1    0    0    0    0    0    0    0    1    0    1    0    1    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles
%    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end






dateStr='2018-06-14';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14    2018-06-14
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    45    ];
behaviorData.timeToMazeSec    = [    122    227    320    388    481    554    633    748    825    928    1013    1101    1218    1292    1380    1462    1532    1608    1678    1746    1825    1895    1970    2044    2119    2198    2276    2398    2526    2686    2813    2916    3002    3089    3158    3262    3390    3465    3558    3643    3723    3785    3846    3928    3995    ];
behaviorData.timeToOpen       = [    134    236    329    397    490    561    649    756    840    937    1025    1108    1225    1300    1388    1469    1546    1620    1694    1759    1834    1903    1981    2053    2130    2208    2285    2414    2542    2697    2834    2935    3018    3106    3173    3281    3403    3481    3578    3657    3737    3799    3865    3938    4014    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2454    2624    2721    2840    2938    3025    3111    3178    3289    3412    3495    3582    3662    3741    3805    3870    3945    4018    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    143    240    333    402    493    565    653    759    844    941    1030    1111    1228    1304    1392    1474    1549    1624    1698    1767    1839    1906    1985    2056    2136    2211    2289    2458    2627    2724    2844    2943    3028    3114    3181    3292    3416    3498    3585    3664    3743    3808    3873    3948    4021    ];
behaviorData.timeToBucketSec  = [    171    254    344    413    511    568    662    771    864    954    1045    1126    1233    1321    1398    1482    1553    1626    1701    1777    1850    1916    2003    2065    2142    2218    2299    2463    2646    2730    2847    2962    3040    3125    3183    3297    3425    3503    3605    3675    3754    3813    3882    3957    4032    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    1    0    1    0    0    0    0    0    0    1    0    1    0    1    1    1    0    0    0    0    0    0    0    0    1    0    1    1    0    1    0    1    1    0    1    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms
%    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures    sqaures
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado?    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
%    Pam    avocado    Pam    avocado    avocado    Pam    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam

try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end





dateStr='2018-06-15';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5    h5
%    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15    2018-06-15
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    ];
behaviorData.timeToMazeSec    = [    233    372    534    603    685    795    871    960    1026    1124    1185    1259    1362    1468    1583    1705    1780    1867    1970    2045    2130    2212    2486    2672    2811    2941    3085    3183    3256    3352    3439    3523    3605    3673    3749    3850    3998    4076    4146    4226    4284    4355    4438    4530    4614    4690    ];
behaviorData.timeToOpen       = [    250    383    544    614    705    809    881    971    1038    1136    1196    1275    1378    1480    1604    1720    1789    1886    1980    2057    2142    2222    2544    2696    2828    2962    3103    3192    3267    3366    3450    3531    3615    3686    3760    3864    4008    4085    4156    4235    4293    4368    4449    4548    4627    4702    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2547    2702    2845    2975    3108    3199    3271    3370    3457    3536    3619    3690    3764    3867    4013    4089    4162    4239    4299    4376    4456    4553    4641    4708    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    253    387    547    618    709    813    889    975    1041    1140    1201    1280    1383    1485    1609    1725    1793    1891    1984    2061    2145    2226    2569    2705    2848    2977    3111    3202    3274    3373    3461    3540    3621    3693    3767    3870    4015    4092    4166    4241    4302    4380    -1    4557    4645    4711    ];
behaviorData.timeToBucketSec  = [    264    414    566    620    722    834    904    984    1053    1144    1205    1291    1386    1490    1615    1734    1808    1901    1998    2074    2163    2241    2577    2715    2853    3003    3115    3232    3280    3393    3487    3563    3636    3702    3774    3875    4039    4118    4179    4248    4305    4402    4464    4566    4658    4841    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    0    1    0    0    0    0    0    1    1    0    1    1    1    0    0    0    0    0    0    0    1    1    1    0    1    0    1    0    0    0    0    0    0    1    1    0    0    1    1    0    1    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    30    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado
%    avocado    Pam    Pam    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    Pam    Pam    Pam    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    avocado    Pam    avocado    Pam    avocado    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    avocado    avocado    Pam    Pam    avocado    Pam    avocado    avocado    avocado
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end


%===============================
%===============================
%%
ratName='h7';
rotationalParameters.centerX = 370;
rotationalParameters.centerY = 255;
rotationalParameters.degToRotate = 48;
rotationalParameters.xoffset = 300;
rotationalParameters.yoffset = 300;
swrFilename=swrLookup(ratName);
thetaFilename = thetaLookup(ratName);



dateStr='2018-09-05';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    ];
behaviorData.timeToMazeSec    = [    348    475    568    643    742    814    912    996    1096    1180    1296    1461    1584    1648    1699    1754    1813    1890    1978    2092    2153    2222    2323    2394    2500    2569    2666    2732    2859    2938    3046    3154    3282    3375    3435    3536    3604    3706    3813    3934    4040    4156    4295    4419    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    416    481    573    650    748    819    918    1001    1100    1185    1300    1468    1589    1651    1705    1760    1834    1923    1992    2100    2173    2241    2344    2401    2515    2577    2678    2772    2881    2945    3063    3171    3287    3380    3440    3543    3612    3738    3820    3950    4058    4161    4861    4423    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    418    483    575    652    750    821    919    1002    1102    1187    1302    1470    1591    1653    1708    1762    1836    1925    1994    2101    2175    2243    2345    2402    2517    2578    2680    2775    2883    2947    3065    3174    3289    3383    3442    3545    3614    3741    3823    3951    4060    4163    4322    4424    ];
behaviorData.timeToBucketSec  = [    428    497    593    665    767    839    930    1021    1109    1220    1317    1516    1600    1657    1712    1767    1843    1931    2020    2104    2177    2257    2349    2412    2522    2598    2684    2783    2889    2963    3077    3211    3303    3416    3458    3549    3629    3746    3850    3966    4079    4172    4344    4450    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    1    0    1    0    0    0    0    0    0    0    1    1    1    1    1    1    0    1    1    0    1    0    1    0    1    0    1    0    0    0    0    1    0    1    0    1    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    ];
%    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms
%    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column
%    Tammy alone
%    door    antidoor    door    antidoor    door    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    door    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    door    antidoor    door    antidoor    door    antidoor    door    antidoor    door    door    door    door    antidoor    door    antidoor    door    antidoor    door    door    door    door    door    door
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end


ratName = 'h7';
dateStr='2018-09-04';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    ];
behaviorData.timeToMazeSec    = [    501    638    696    740    811    907    926    955    1032    1075    1111    1135    1172    1226    1263    1365    1467    1512    1552    1581    1651    1680    1743    1817    2094    2122    2154    2186    2217    2260    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    601    679    723    781    833    915    938    980    1040    1081    1119    1148    1179    1234    1267    1414    1497    1541    1567    1592    1666    1730    1754    1862    2101    2144    2175    2201    2246    2326    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    604    681    725    783    835    917    940    982    1041    1082    1120    1150    1181    1236    1269    1415    1499    1543    1569    1595    1669    1732    1756    1865    2104    2146    2177    2203    2250    2329    ];
behaviorData.timeToBucketSec  = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2339    ];
behaviorData.timeToContRetSec = [    635    694    739    809    892    922    953    1031    1074    1109    1134    1170    1224    1261    1363    1465    1511    1550    1580    1650    1679    1742    1792    2092    2121    2153    2184    2216    2258    -1    ];
behaviorData.madeError        = [    0    1    0    1    1    1    0    1    1    1    1    0    1    1    1    1    0    0    0    1    0    0    1    1    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    ];
%    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms    both arms
%    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner
%    corner    column    corner    column    column    column    corner    column    column    column    column    corner    column    column    column    column    corner    corner    corner    column    corner    corner    column    column    corner    corner    corner    corner    corner    corner
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-31';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31    2018-08-31
behaviorData.trial            = [    0    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    ];
behaviorData.timeToMazeSec    = [    414    1177    1266    1607    1692    1743    1799    1822    1860    1884    2001    2105    2161    2184    2237    2439    2928    3315    3573    3759    3861    3966    4458    4900    4996    -1    5783    5924    6113    6196    6352    6512    6592    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    1228    1562    1668    1730    1773    1811    1848    1866    1906    2003    2134    2171    2222    2247    2880    3296    -1    3707    -1    -1    4172    -1    4910    5607    -1    -1    6073    6169    6297    6472    6556    6669    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2158    2182    2236    2437    2926    3313    -1    3757    -1    -1    4456    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    -1    1231    1564    1670    1552    1775    1812    1849    1868    1923    2002    2136    2174    2224    2249    2882    3299    -1    3741    3843    3920    -1    -1    4912    -1    5727    5872    6076    6171    6300    6475    6558    6671    ];
behaviorData.timeToBucketSec  = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2013    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    6692    ];
behaviorData.timeToContRetSec = [    1163    1264    1604    1691    1741    1797    1821    1859    1883    1924    -1    -1    -1    -1    -1    -1    -1    3566    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    -1    0    0    0    0    0    0    0    0    0    0    1    1    1    1    1    1    -1    1    1    0    1    1    1    1    0    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    ];
%    reward arms incorrect reward arm    he gets back up on the maze here    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm    reward arms incorrect reward arm
%    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column
%    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none    none
%    blue
%    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    x    corner    corner    column    corner    corner    corner    corner    column    column    column    column    column    column    column    column
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-22';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22    2018-08-22
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    ];
behaviorData.timeToMazeSec    = [    320    451    722    982    1108    1219    1329    1445    1538    1639    1803    2115    2183    2253    2331    2475    2609    2738    2865    2945    3050    3154    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    -1    471    736    1016    1122    1231    1338    1452    1543    1646    1813    2126    2200    2264    2342    2483    2613    2744    2883    2949    3054    3158    ];
behaviorData.timeToBucketSec  = [    360    476    740    1023    1166    1250    1353    1463    1556    1665    1839    2130    2203    2266    2369    2508    2636    2768    2896    2966    3073    3183    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    1    1    0    1    0    0    0    0    0    0    1    1    1    0    0    0    0    1    0    0    0   ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    far door    far door    far door    far door    far door    far door    far door    far door    far door    far door    far door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door
%    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    antidoor; squares    door    door    door    door    door    door    door    door    door    door    door
%    door    door    door    antidoor    door    door    door    door    door    door    door    antidoor    antidoor    antidoor    door    door    door    door    antidoor    door    door    door
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-15';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15    2018-08-15
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    ];
behaviorData.timeToMazeSec    = [    464    732    852    979    1105    1215    1360    1495    1710    1787    1870    1958    2058    2170    2285    2360    2440    2562    2653    2762    2847    2927    2994    3066    3148    3225    3353    3437    3520    3601    3690    3802    3911    4015    4117    4217    4328    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    649    763    868    1000    1120    1234    1382    1632    1726    1812    1889    2000    2106    2222    2308    2378    2471    2593    2684    2779    2868    2937    3013    3092    3163    3254    3380    3458    3540    3629    3707    3822    3933    4034    4134    4235    4343    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    654    767    870    1002    1122    1237    1384    1634    1729    1814    1893    2002    2108    2223    2310    2379    2473    2595    2686    2781    2871    2939    3015    3094    3165    3256    3382    3460    3542    3631    3709    3824    3935    4035    4137    4237    4345    ];
behaviorData.timeToBucketSec  = [    661    777    893    1025    958    1250    1394    1636    1733    1818    1895    2004    2111    2226    2312    2385    2477    2599    2689    2785    2875    2942    3018    3098    3168    3276    3386    3463    3545    3637    3728    3835    3945    4046    4145    4254    4362    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    0    1    1    1    1    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    ];
%    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms
%    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    column    column    column    column    column    column    column    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner
%    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    corner    column    column    column    column    corner    corner    corner    corner    corner    corner    corner
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-14';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14    2018-08-14
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    ];
behaviorData.timeToMazeSec    = [    422    585    655    766    848    993    1054    1101    1137    1194    1283    1474    1567    1634    1707    1805    2122    2318    2345    2411    2458    2552    2641    2730    2809    2883    2955    3039    3130    3293    3376    3464    3591    3654    3731    3815    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    510    613    670    798    939    1021    1070    1119    1152    1224    1373    1495    1584    1684    1727    1915    2177    2327    2369    2424    2486    2580    2666    2743    2826    2894    2975    3066    3143    3315    3389    3485    3600    3670    3749    3829    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    514    615    673    801    942    1023    1072    1121    1154    1227    1378    1498    1586    1687    1731    1918    2179    2330    2372    2427    2489    2582    2668    2745    2828    2896    2977    3068    3146    3317    3392    3487    3602    3673    3751    3830    ];
behaviorData.timeToBucketSec  = [    521    623    727    806    948    1039    1085    1129    1184    1262    1391    1537    1602    1692    1755    1936    2186    2334    2400    2450    2505    2598    2681    2762    2838    2909    2986    3074    3217    3346    3428    3557    3613    3695    3782    3850    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    1    1    1    1    1    1    1    1    1    0    1    1    1    1    1    1    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    1    0    0    0    ];
behaviorData.barrierHeight    = [    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    ];
%    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms    both reward arms
%    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam    Pam
%    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    circles    squares    squares    squares    squares    squares    squares    squares    squares
%    squares    squares    squares    squares    squares    squares    squares    squares    squares    squares    circles    squares    squares    squares    squares    squares    squares    squares    squares    squares    circles    circles    circles    circles    circles    circles    circles    circles    squares    squares    squares    squares    circles    squares    squares    squares
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-13';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13    2018-08-13
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    ];
behaviorData.timeToMazeSec    = [    249    461    549    687    746    1033    1327    1608    2098    2393    2462    2765    2871    3027    3247    3395    3508    3659    3766    3902    4000    4077    4318    4458    4544    4607    4777    4895    4975    5164    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    422    522    577    722    988    1287    1483    2016    2327    2408    2695    2847    2955    3177    3340    3453    3590    3704    3799    3937    4029    4160    4335    4484    4578    4640    4803    4923    5003    5183    ];
behaviorData.timeToJump2Sec   = [    -1    -1    684    -1    -1    -1    1605    -1    2390    -1    -1    2859    -1    3244    3393    -1    -1    3763    -1    3997    4074    -1    4451    -1    -1    -1    -1    -1    5161    -1    ];
behaviorData.timeToSugarSec   = [    424    524    580    724    990    1289    1486    2025    2330    2410    2698    2850    2958    3180    3342    3455    3592    3706    3802    3940    4031    4162    4337    4486    4581    4643    4806    4926    5005    5186    ];
behaviorData.timeToBucketSec  = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    5238    ];
behaviorData.timeToContRetSec = [    453    547    -1    744    1032    1326    -1    2096    -1    2458    2761    -1    3025    -1    -1    3501    3612    -1    3889    -1    -1    4317    -1    4529    4606    4771    4894    4974    -1    -1    ];
behaviorData.madeError        = [    0    0    1    0    0    0    1    0    1    0    0    1    0    1    1    0    0    1    0    1    1    0    1    0    0    0    0    0    1    0    ];
behaviorData.barrierHeight    = [    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    ];
%    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded    both reward arms; return arm on unrewarded
%    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se
%    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw
%    ne    ne    ne    sw    ne    ne    sw    ne    sw    ne    ne    sw    ne    ne    ne    sw    sw    ne    sw    ne    ne    sw    ne    sw    sw    sw    sw    sw    ne    sw

try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-28';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28    2018-08-28
behaviorData.trial            = [      1      2       3       4       5       6       7       8       9      10      11      12      13      14      15      16      17      18      19 ];
behaviorData.timeToMazeSec    = [    514    819     949    1072    1220    1398    1568    1715    1988    2130    2282    2448    2531    2885    3007    3143    3342    3632    3922 ];
behaviorData.timeToOpen       = [     -1     -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1 ];
behaviorData.timeToJump1Sec   = [    739    864    1003    1132    1252    3123    1644    1782    2037    2171    2382    2472    2556    2929    3034    3217    3508    3828    4370 ];
behaviorData.timeToJump2Sec   = [     -1     -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1 ];
behaviorData.timeToSugarSec   = [    743    866    1006     894    1254    1506    1646    1786    2040    2173    2384    2475    2558    2932    3037    3219    3521    3833    4374 ];
behaviorData.timeToBucketSec  = [    758    891    1033    1173    1316    1520    1661    1861    2055    2222    2417    2500    2633    2945    3086    3258    3567    3895    3373 ];
behaviorData.timeToContRetSec = [     -1     -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1      -1    ];
behaviorData.madeError        = [      0      0       0       1       1       0       0       1       0       1       0       0       1       0       1      -1       0       1       1    ];
behaviorData.barrierHeight    = [     25     25      25      25      25      25      25      25      25      25      25      25      25      25      25      25      25      30      30    ];

behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    1    1    0    0    1    0    1    0    0    1    0    1    -1    0    1    1    1    ];
behaviorData.barrierHeight    = [    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    30    30    ];
%    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms    reward arms
%    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door    right of door
%    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor    antidoor

%    blue
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end




dateStr='2018-08-10';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10    2018-08-10
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47    48    49    50    51    52    53    ];
behaviorData.timeToMazeSec    = [    351    434    499    550    609    644    692    731    765    801    907    955    1024    1079    1116    1160    1189    1349    1412    1461    1530    1556    1663    1730    1775    1799    1833    1859    1885    2009    2050    2079    2124    2224    2282    2315    2344    2394    2437    2488    2546    2605    2650    2690    2799    2848    3030    3095    3171    3254    3321    3493    309    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    3554    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    363    438    505    561    613    650    700    735    771    809    914    958    1031    1085    1122    1165    1200    1369    1420    1476    1537    1562    1698    1742    1781    1806    1841    1862    1889    2020    2057    2091    2148    2240    2290    2325    2351    2403    2444    2496    2556    2609    2655    2694    2804    2852    3034    3104    3180    3259    3327    3556    314    ];
behaviorData.timeToBucketSec  = [    376    467    526    589    618    665    709    739    775    824    927    969    1062    1093    1128    1173    1217    1380    1427    1486    1539    1569    1710    1757    1786    1813    1847    1866    1899    2023    2060    2100    2210    2265    2294    2327    2366    2423    2474    2511    2577    2620    2676    2697    2824    2879    3052    3132    3212    3279    3374    3779    396    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    1    0    0    0    0    1    1    0    0    0    0    0    1    0    1    0    0    1    1    0    0    0    0    1    0    0    0    1    1    1    0    0    1    1    0    0    0    0    0    1    0    1    0    0    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    barriers return arm and reward arms; either 25 or 30    barriers return arm and reward arms; either 25 or 30
%    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw
%    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne
%    sw    sw    ne    sw    sw    sw    sw    ne    ne    sw    sw    sw    sw    sw    ne    sw    ne    sw    sw    ne    ne    sw    sw    sw    sw    ne    sw    sw    sw    sw    sw    sw    ne    ne    sw    sw    ne    ne    ne    ne    ne    sw    ne    sw    ne    ne    ne    ne    ne    ne    ne    ne    ne
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-09';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09    2018-08-09
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    ];
behaviorData.timeToMazeSec    = [    485    572    631    718    793    900    985    1076    1146    1258    1341    1403    1480    1540    1631    1691    1746    1820    1896    1972    2019    2104    2173    2254    2313    2364    2449    2521    2701    2841    2950    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2777    2910    3091    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2836    -1    -1    ];
behaviorData.timeToSugarSec   = [    503    587    641    726    800    908    1016    1085    1154    1264    1347    1417    1492    1572    1639    1699    1753    1837    1903    1982    2026    2113    2180    2261    2318    2371    2465    2546    2779    2913    3093    ];
behaviorData.timeToBucketSec  = [    531    589    658    757    843    947    1020    1103    1165    1274    1350    1429    1498    1586    1644    1704    1793    1849    1924    1986    2042    2129    2205    2265    2335    2393    2480    2557    -1    -1    3115    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2947    -1    ];
behaviorData.madeError        = [    0    1    0    0    0    0    0    0    1    1    1    1    0    1    1    1    1    0    1    0    0    0    1    0    0    0    0    0    1    0    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    25    25    25    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    reward arms return arm
%    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw
%    ne    ne    ne    ne    ne    ne    ne    ne    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw
%    ne    sw    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    sw    ne    ne    ne    ne    sw    ne    sw    sw    sw    ne    sw    sw    sw    sw    ne    sw    ne
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end


dateStr='2018-08-08';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08    2018-08-08
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    43    44    ];
behaviorData.timeToMazeSec    = [    407    475    98    229    332    441    582    701    910    993    1112    1198    1347    1413    1533    1601    1796    1920    2068    2137    2299    2409    2520    2958    3168    3293    -1    3518    3577    3621    3780    3845    3896    4042    4304    4611    4651    4809    4970    5256    5430    5613    5673    -1    -1    5949    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    3143    3241    3316    3363    3520    3598    3623    3805    3856    3990    4136    4369    4625    4733    4827    4980    5296    5451    5636    5687    -1    5843    5957    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    3290    -1    -1    3574    -1    -1    -1    3893    -1    -1    4609    -1    -1    -1    5254    -1    -1    -1    -1    5838    -1    -1    ];
behaviorData.timeToSugarSec   = [    433    518    119    239    345    451    587    705    913    1003    1122    1210    1354    1418    1540    1606    1806    1928    2077    2140    2309    2415    2533    3146    3243    3318    -1    3520    3600    3726    3807    3859    3993    4138    4371    4628    4735    4829    4982    5298    5453    5638    5689    -1    5845    5960    ];
behaviorData.timeToBucketSec  = [    441    522    125    245    348    477    613    728    916    1025    1126    1250    1357    1449    1541    1643    1831    1958    2041    2171    2329    2436    2547    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    5994    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    3167    -1    3340    -1    -1    3620    3771    3834    -1    4041    4303    -1    4648    4805    4969    -1    5429    5613    5671    -1    -1    4329    -1    ];
behaviorData.madeError        = [    1    0    0    0    0    0    0    0    1    0    1    0    1    0    1    0    0    0    1    0    0    0    0    0    1    0    1    1    0    0    0    1    0    0    1    0    0    0    1    0    0    0    1    1    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style    fig8 style
%    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se
%    sw    sw    sw    sw    sw    sw    sw    sw    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne
%    ne    sw    sw    sw    sw    sw    sw    sw    sw    ne    sw    ne    sw    ne    sw    ne    ne    ne    sw    ne    ne    ne    ne    sw    ne    sw    x    ne    sw    sw    sw    ne    sw    sw    ne    sw    ne    ne    sw    ne    ne    ne    sw    x    ne    ne
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end




dateStr='2018-08-07';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07    2018-08-07
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47    48    49    50    51    52    53    54    55    56    57    58    ];
behaviorData.timeToMazeSec    = [    484    518    695    722    767    927    1038    1131    1217    1366    1475    1603    1698    1806    1850    1907    1992    2086    2233    2265    2354    2497    2574    2680    2756    2880    3003    3138    3263    3401    3471    3594    3698    3771    3846    3935    4079    4215    4302    4485    4580    4677    4775    4861    4955    5014    5098    5183    5258    5372    5469    5599    5676    5752    5844    5911    6005    6098    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    5965    6021    6117    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    494    578    702    754    803    940    1052    1139    1223    1373    1480    1610    1733    1832    1897    1980    2041    2141    2238    2313    2405    2501    2605    2684    2799    2890    3039    3205    3284    3409    358    3599    3702    3778    3856    3941    4093    4227    4320    4505    4587    4699    4785    4893    4958    5023    5108    5188    5263    5386    5478    5615    5682    5767    5848    5972    6030    6123    ];
behaviorData.timeToBucketSec  = [    502    597    707    757    832    961    1065    1157    1294    1399    1519    1635    1742    1839    1901    1983    2060    2156    2256    2316    2417    2537    2615    2702    2809    2930    3056    3212    3295    3418    3513    3609    3713    3800    3868    4003    4099    4232    4343    4516    4595    4711    4790    4904    4976    5053    5127    5198    5288    5395    5492    5622    5699    5786    5860    5978    -1    6129    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    6096    -1    ];
behaviorData.madeError        = [    1    1    1    1    0    0    0    0    0    0    0    1    1    1    1    1    0    1    1    0    1    0    0    1    0    1    1    1    0    0    1    0    0    1    0    1    0    0    1    1    0    0    0    1    0    1    1    0    0    0    0    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    25    25    25    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    start arm    start arm    start arm
%    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se
%    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    ne    ne    sw
%    sw    ne    sw    sw    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    ne    sw    ne    ne    sw    ne    sw    ne    sw    ne    sw    ne    sw    sw    sw    sw    sw    ne    sw    ne    sw    sw    ne    ne    sw    sw    sw    ne    sw    ne    ne    sw    sw    sw    sw    sw    sw    sw    sw    sw    ne    sw
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-08-06';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7    h7
%    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06    2018-08-06
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    ];
behaviorData.timeToMazeSec    = [    438    559    634    703    785    867    977    1062    1203    1294    1380    1474    1516    1648    1702    1750    1851    1938    2008    2059    2189    2266    2357    2410    2477    2660    2850    2972    2996    3087    -1    3283    3450    3549    3646    3982    4050    4121    4188    4225    4333    4400    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2754    2915    2979    3005    3118    3207    3415    3478    3592    3851    4009    4103    4142    4187    4289    4367    4505    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2847    -1    -1    -1    3175    -1    -1    3546    -1    -1    4047    -1    4171    -1    4331    -1    -1    ];
behaviorData.timeToSugarSec   = [    457    566    642    707    795    890    983    1066    1208    1328    1419    1480    1552    1652    1737    1796    1863    1951    2020    2123    2202    2285    2362    2425    2488    2757    2918    2981    3007    3121    3209    3418    3481    3595    3854    4011    4105    4144    4190    4292    4370    4509    ];
behaviorData.timeToBucketSec  = [    464    574    652    713    803    927    1002    1077    1219    1342    1430    1485    1577    1663    1740    1813    1878    1964    2027    2147    2217    2304    2380    2442    2504    -1    -1    -1    -1    -1    -1    -1    -1    -1    3863    -1    -1    -1    -1    -1    -1    4585    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    2966    2989    3085    -1    3281    3448    -1    3644    -1    -1    4119    -1    4222    -1    4396    -1    ];
behaviorData.madeError        = [    0    0    0    1    0    0    0    0    1    1    0    1    0    1    1    0    0    0    1    0    0    0    0    0    0    1    0    0    0    1    0    0    1    0    0    1    0    1    0    1    0    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    25    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw
%    nw    nw    nw    nw    nw    nw    nw    nw    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    se    se    se    se    se    se    se
%    nw    nw    nw    se    nw    nw    nw    nw    nw    nw    se    nw    se    nw    nw    se    se    se    nw    se    se    se    se    se    se    se    nw    nw    nw    se    nw    nw    se    nw    nw    nw    se    nw    se    nw    se
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end









%%
ratName='h1';
rotationalParameters.centerX = 370;
rotationalParameters.centerY = 255;
rotationalParameters.degToRotate = 48;
rotationalParameters.xoffset = 300;
rotationalParameters.yoffset = 300;
swrFilename=swrLookup(ratName);
thetaFilename = thetaLookup(ratName);


dateStr='2018-09-09';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1
%    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09    2018-09-09
behaviorData.trial            = [      1      2      3       4       5       6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    ];
behaviorData.timeToMazeSec    = [    780    908    966    1013    1131    1207    1306    1378    1464    1556    1671    1747    1883    1991    2100    2135    2282    2361    2429    2530    2627    2691    2798    2879    2959    3046    3121    3274    3517    3584    3634    3695    3760    3812    3873    3934    4072    4123    4190    4270    4329    4378    4432    4483    ];
behaviorData.timeToOpen       = [     -1     -1     -1      -1      -1      -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [     -1     -1     -1      -1      -1      -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    3433    3527    3599    3652    3713    3769    3834    3890    3965    4088    4154    4215    4287    4339    4388    4441    4495    ];
behaviorData.timeToJump2Sec   = [     -1     -1     -1      -1      -1      -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    856    917    975    1028    1139    1226    1324    1397    1476    1580    1687    1786    1908    2015    2121    2159    2304    2381    2443    2574    2640    2707    2830    2910    2998    3068    3142    3464    3544    3603    3656    3717    3772    3838    3895    3975    4092    4158    4220    4291    4344    4391    4444    4498    ];
behaviorData.timeToBucketSec  = [    868    929    989    1075    1173    1255    1346    1410    1525    1589    1695    1793    1931    2043    2156    2232    2328    2392    2450    2592    2659    2714    2846    2920    3007    3078    3165    3475    3557    3611    3662    3746    3779    3846    3907    4039    4103    4173    4247    4309    4363    4405    4457    4518    ];
behaviorData.timeToContRetSec = [     -1     -1     -1      -1      -1      -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [      0      0      1       0       0       0    0    0    1    1    1    1    0    0    0    1    0    0    1    0    0    1    0    0    0    0    0    0    0    0    1    0    1    1    1    0    1    0    0    0    0    0    0    0    ];
behaviorData.barrierHeight    = [      0      0      0       0       0       0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm    start arm
%    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw
%    se    se    se    se    se    se    se    se    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se
%    se    se    nw    se    se    se    se    se    se    se    se    se    nw    nw    nw    se    nw    nw    se    nw    nw    se    nw    nw    nw    nw    nw    se    se    se    nw    se    nw    nw    nw    se    nw    se    se    se    se    se    se    se
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end




dateStr='2018-09-08';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1
%    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08    2018-09-08
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    ];
behaviorData.timeToMazeSec    = [    563    697    774    837    908    976    1073    1149    1245    1327    1385    1509    1615    1785    1862    1953    2053    2148    2252    2387    2447    2548    2687    2796    2869    2979    3063    3134    3187    3247    3313    3390    3467    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    633    723    786    856    918    1009    1092    1175    1272    1337    1407    1564    1634    1814    1898    1986    2075    2205    2292    2401    2472    2561    2739    2823    2896    3014    3087    3148    3204    3276    3327    3404    3485    ];
behaviorData.timeToBucketSec  = [    660    743    791    881    939    1036    1099    1190    1299    1350    1418    1579    1645    1817    1902    2001    2085    2209    2357    2410    2494    2575    2765    2837    2907    3025    3103    3163    3208    3286    3338    3428    3496    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    1    0    0    0    0    1    0    0    0    1    1    1    1    0    1    1    0    1    0    1    0    0    1    0    0    0    1    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw
%    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se
%    nw    nw    se    nw    nw    nw    nw    se    nw    nw    nw    se    nw    nw    nw    se    nw    nw    se    nw    se    nw    se    se    nw    se    se    se    nw    se    se    se    se
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-09-07';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1
%    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07    2018-09-07
behaviorData.trial            = [    0    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47    48    49    ];
behaviorData.timeToMazeSec    = [    267 400    541    646    1065    1156    1220    1414    1504    1658    1739    1857    1944    2055    2530    2626    2736    2903    2970    3043    3131    3257    3326    3364    3445    3514    3577    3644    3711    3793    3873    3959    4035    4112    4165    4299    4404    4528    4652    4757    4858    4965    5060    5167    5278    5363    5427    5501    5564    5645    5744    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    -1    573    679    1091    1172    1232    1460    1526    1687    1764    1889    1990    2083    2562    2676    2812    2921    2993    3074    3205    3280    3345    3404    3478    3533    3615    3668    3742    3839    3919    3989    4069    4134    4186    4344    4439    4580    4682    4788    4905    4994    5088    5197    5302    5391    5448    5526    5586    5674    5765    ];
behaviorData.timeToBucketSec  = [    -1    619    712    1120    1182    1242    1474    1540    1708    1789    1906    2018    2246    2582    2697    2822    2936    3016    3097    3219    3303    3348    3415    3488    3538    3619    3682    3752    3844    3935    4009    4084    4138    4200    4365    4449    4594    4696    4802    4911    5027    5098    5236    5319    5402    5460    5540    5598    5685    5773    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    -1    0    1    0    0    1    0    1    0    1    0    0    1    0    0    0    0    0    0    1    1    1    0    1    1    1    0    1    1    0    1    0    1    1    0    1    0    1    0    1    0    1    0    0    0    1    0    0    0    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw    sw
%    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    se    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw
%    se    nw    se    se    nw    se    nw    se    nw    se    se    nw    se    se    se    se    se    se    nw    se    se    nw    se    se    se    nw    se    se    nw    se    nw    se    se    nw    se    nw    se    nw    se    nw    se    nw    nw    nw    se    nw    nw    nw    nw
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end




dateStr='2018-09-06';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1
%    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06    2018-09-06
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    ];
behaviorData.timeToMazeSec    = [    484    644    736    854    1758    1824    1904    2611    2672    2851    2915    3167    3261    3399    3471    3564    3948    4190    4287    4364    5105    5283    5397    5465    6065    6264    6831    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    569    680    764    1683    1778    2036    2556    2641    2805    2865    3057    3214    3293    3422    3505    3901    4102    4221    4310    5052    5220    5308    5420    5968    6217    6777    7221    ];
behaviorData.timeToBucketSec  = [    606    705    786    1708    1792    1867    2582    2653    2824    2887    3087    3234    3300    3439    3523    3917    4136    4244    4336    5075    5242    5332    5438    5979    6234    6803    7235    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    1    0    1    0    1    0    0    1    0    0    1    0    1    0    0    0    0    0    0    1    0    1    1    1    1    0    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    column
%    nw    se    nw    se    nw    se    se    nw    se    se    nw    se    nw    se    se    se    se    se    se    se    nw    se    se    se    se    nw    se
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end




dateStr='2018-09-05';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1
%    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05    2018-09-05
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    ];
behaviorData.timeToMazeSec    = [    367    557    705    834    937    1323    1433    1597    1823    1964    2050    2128    2236    2456    2754    3031    3171    3280    3393    3807    3942    4087    4244    4468    4666    4794    4879    5025    5214    5310    5377    5476    5693    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    438    582    713    848    1245    1331    1488    1612    1854    1980    2073    2175    2390    2697    2848    3073    3203    3334    3683    3880    3991    4144    4401    4568    4693    4824    4936    5130    5224    5317    5385    5485    5725    ];
behaviorData.timeToBucketSec  = [    465    611    753    857    1261    1354    1516    1623    1880    1995    2078    2181    2396    2701    2854    3084    3208    3337    3691    3884    4000    4153    4408    4576    4713    4828    4944    5144    5237    5321    5402    5531    5730    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    0    0    0    1    0    0    0    0    1    1    1    1    1    1    0    1    1    0    1    0    0    1    0    0    1    0    0    0    1    0    0    1    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    corner    corner    corner    corner    corner    corner    corner    corner    corner    corner    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column    column
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket    blueBucket
%    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy    Tammy
%    nw    nw    nw    nw    se    nw    nw    nw    se    nw    nw    nw    nw    nw    nw    se    nw    nw    se    nw    se    se    nw    se    se    nw    se    se    se    nw    se    se    nw
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end



dateStr='2018-09-04';
path=[ disk '/' ratName '/' dateStr '/' ];
%    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1    h1
%    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04    2018-09-04
behaviorData.trial            = [    1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37    38    39    40    41    ];
behaviorData.timeToMazeSec    = [    304    408    467    520    589    674    900    957    1032    1116    1193    1320    1463    1557    1795    1914    2061    2173    2315    2526    2620    2694    2783    2867    2999    3110    3191    3214    3363    3407    3561    3684    3790    3846    3924    4006    4073    4229    4316    4386    4442    ];
behaviorData.timeToOpen       = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToJump1Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    4956    ];
behaviorData.timeToJump2Sec   = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.timeToSugarSec   = [    342    420    483    535    604    703    916    977    1044    1150    1204    1369    1507    1670    1845    1956    2088    2196    2337    2562    2652    2725    2814    2906    3057    3126    3221    3301    3373    3483    3601    3743    3801    3882    3951    4030    4091    4275    4351    4405    4973    ];
behaviorData.timeToBucketSec  = [    367    440    495    553    640    731    932    1007    1076    1170    1214    1375    1524    1677    1875    1970    2144    2215    2343    2589    2669    2752    2841    2965    3081    3157    3233    3321    3392    3493    3655    3763    3813    3890    3964    4047    4102    4291    4366    4423    4988    ];
behaviorData.timeToContRetSec = [    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    ];
behaviorData.madeError        = [    0    1    1    0    0    1    0    0    1    0    1    1    0    1    0    1    0    1    0    0    1    0    1    0    0    1    0    0    1    0    0    0    1    0    0    0    1    0    0    1    0    ];
behaviorData.barrierHeight    = [    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    ];
%    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1
%    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door    door
%    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw    nw
    %%%%%%
try
    movInitBlob = getMovingHRats( path, ratName, dateStr, swrFilename, behaviorData, movInitBlob );
catch
    warning([ ratName ' ' dateStr ' failed' ]);
end