%clear all; 
%close all;

clear agg metadata

% first, load the XY and set the waypoints

metadata.rat = 'da12';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'rawChannel_32.dat'  'rawChannel_37.dat' 'rawChannel_44.dat' 'rawChannel_46.dat' 'rawChannel_48.dat' 'rawChannel_52.dat' 'rawChannel_56.dat'  'rawChannel_61.dat'  }; 
metadata.fileListDisconnectedLfp={ 'rawChannel_34.dat'  'rawChannel_62.dat' };
metadata.swrLfpFile =  'rawChannel_56.dat'; 
metadata.lfpStartIdx = 1;   
metadata.outputDir = [ '/Users/andrewhowe/data/plusMazeEphys/' metadata.rat '/' ];
metadata.sampleRate.lfp=32000;
metadata.sampleRate.telemetry=29.97;
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
metadata.waypoints.center.x     =  326;
metadata.waypoints.center.y     =  239;
metadata.waypoints.start.x      =  529;
metadata.waypoints.start.y      =   62;
metadata.waypoints.reward.x     =  120;
metadata.waypoints.reward.y     =   46;
metadata.waypoints.antireward.x =  538;
metadata.waypoints.antireward.y =  444;
metadata.waypoints.rotation.x   =  120;
metadata.waypoints.rotation.y   =  424;
metadata.pxPerCm = sqrt( (metadata.waypoints.reward.x-metadata.waypoints.antireward.x)^2  + (metadata.waypoints.reward.y-metadata.waypoints.antireward.y)^2   )/215;


agg.sampleRate.telemetry=29.97;

agg.sampleRate.lfp=metadata.sampleRate.lfp;
agg.sampleRate.telemetry=metadata.sampleRate.telemetry;
agg.waypoints.center.x     =  metadata.waypoints.center.x;
agg.waypoints.center.y     =  metadata.waypoints.center.y;
agg.waypoints.start.x      =  metadata.waypoints.start.x;
agg.waypoints.start.y      =  metadata.waypoints.start.y;
agg.waypoints.reward.x     =  metadata.waypoints.reward.x;
agg.waypoints.reward.y     =  metadata.waypoints.reward.y;
agg.waypoints.antireward.x =  metadata.waypoints.antireward.x;
agg.waypoints.antireward.y =  metadata.waypoints.antireward.y;
agg.pxPerCm = sqrt( (metadata.waypoints.reward.x-metadata.waypoints.antireward.x)^2  + (metadata.waypoints.reward.y-metadata.waypoints.antireward.y)^2   )/210;








% metadata.day = '2017-10-23_orientation1';
% dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
% metadata.autobins = false;
% metadata.trial              = [    1 ];
% metadata.isSubTrial         = [    0 ];
% metadata.leaveBucketToMaze  = [  336 ];
% metadata.sugarConsumeTimes  = [  382 ];
% metadata.leaveMazeToBucket  = [  400 ];
% metadata.waitTimeSec        = [   36 ]; 
% metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
% metadata.probe              = [    0 ]; 
% metadata.error              = [    0 ];
% metadata.outOfBounds        = [    0 ];
% metadata.sugarConsumed      = [    0 ];
% metadata.returnsToStart     = [    0 ];
% metadata.BrickJumps         = [    0 ];
% metadata.wasTeleported      = [    0 ];
% metadata.elapsedDays        = [    1 ];
% metadata.session            = [    1 ];
% metadata.trialsCompleted    = [    1 ];
% metadata.serial             = [    0 ];
% metadata.chewRemovalEnabled = false;
% %
% outp=analyzeSWRda12(metadata);
% %
% [ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
% [ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
% xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
% swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% % 
% agg.oct23.swrTimes=outp.swrPeakTimesDenoise;
% agg.oct23.swrXpos = swrXpos;
% agg.oct23.swrYpos = swrYpos;
% agg.oct23.xpos = xpos;
% agg.oct23.ypos = ypos;
% agg.oct23.xytimestampSeconds = xytimestampSeconds;
% %
% agg.oct23.trial = metadata.trial;
% agg.oct23.isSubTrial = metadata.isSubTrial;
% agg.oct23.error = metadata.error;
% agg.oct23.outOfBounds = metadata.outOfBounds;
% agg.oct23.probe = metadata.probe;
% agg.oct23.beeline = metadata.beeline;
% agg.oct23.sugarConsumed = metadata.sugarConsumed ;
% agg.oct23.leaveBucketToMaze = metadata.leaveBucketToMaze;
% agg.oct23.trialStartAction = metadata.trialStartAction;
% agg.oct23.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.oct23.restartmaze = metadata.restartmaze;
% agg.oct23.restartTrial = metadata.restartTrial;
% agg.oct23.sugarConsumeTimes = metadata.sugarConsumeTimes;
% agg.oct23.leaveMazeToBucket = metadata.leaveMazeToBucket;








metadata.day = '2017-10-24_orientation2';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/' ];
metadata.autobins = false;
metadata.trial              = [    1 ];
metadata.isSubTrial         = [    0 ];
metadata.leaveBucketToMaze  = [    5 ];
metadata.sugarConsumeTimes  = [ 1007 ];
metadata.leaveMazeToBucket  = [ 1008 ];
metadata.waitTimeSec        = [    1 ]; 
metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              = [    0 ]; 
metadata.error              = [    0 ];
metadata.outOfBounds        = [    0 ];
metadata.sugarConsumed      = [    0 ];
metadata.returnsToStart     = [    0 ];
metadata.BrickJumps         = [    0 ];
metadata.wasTeleported      = [    0 ];
metadata.elapsedDays        = [    1 ];
metadata.session            = [    1 ];
metadata.trialsCompleted    = [    1 ];
metadata.serial             = [    0 ];
metadata.beeline            = [    0 ];
metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
% tt=loadCExtractedNrdTimestampData([ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/' 'timestamps.dat' ]);
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.oct24.swrTimes=outp.swrPeakTimesDenoise;
agg.oct24.swrXpos = swrXpos;
agg.oct24.swrYpos = swrYpos;
agg.oct24.xpos = xpos;
agg.oct24.ypos = ypos;
agg.oct24.xytimestampSeconds = xytimestampSeconds;
%
agg.oct24.trial = metadata.trial;
agg.oct24.isSubTrial = metadata.isSubTrial;
agg.oct24.error = metadata.error;
agg.oct24.outOfBounds = metadata.outOfBounds;
agg.oct24.probe = metadata.probe;
agg.oct24.beeline = metadata.beeline;
agg.oct24.sugarConsumed = metadata.sugarConsumed ;
agg.oct24.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.oct24.trialStartAction = metadata.trialStartAction;
%agg.oct24.ratPickupTeleport = metadata.ratPickupTeleport;
%agg.oct24.restartmaze = metadata.restartmaze;
%agg.oct24.restartTrial = metadata.restartTrial;
agg.oct24.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.oct24.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.oct24.swrEnvMedian = outp.swrEnvMedian;
agg.oct24.swrEnvMadam = outp.swrEnvMadam;
agg.oct24.swrThreshold = outp.swrThreshold;

agg.oct24.antiProx = outp.antiRadius;
agg.oct24.rewardProx = outp.rewardRadius;
agg.oct24.antiProxTimes = outp.antiProxTimes;
agg.oct24.rewardProxTimes = outp.rewardProxTimes;






metadata.day = '2017-10-27_training1';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/' ];
metadata.autobins = false;
metadata.trial              = [    1     2     3      4      5      6      7      8     9 ];
metadata.isSubTrial         = [    0     0     0      0      0      0      0      0     0 ];
metadata.leaveBucketToMaze  = [  301   608   813   1099   1298   1536   1800   2039  2245 ];
metadata.trialStartAction   = [  335   638   848   1140   1316   1570   1835   2078  2278 ];  %%%%% 
metadata.sugarConsumeTimes  = [  383   662   899   1155   1356   1600   1914   2094  2299 ];
metadata.leaveMazeToBucket  = [  395   664   908   1167   1379   1627   1944   2120  2320 ];
metadata.waitTimeSec        = [   36    29    23     26     20     23     24     24    18 ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              = [    0     0     0      0      0      0      0      0     0 ]; 
metadata.error              = [    1     0     1      0      0      0      1      0     0 ];
metadata.outOfBounds        = [    0     0     0      0      0      0      0      0     0 ];
metadata.sugarConsumed      = [    1     1     1      1      1      1      1      1     1 ];
metadata.returnsToStart     = [    0     0     0      0      0      0      1      0     0 ];
metadata.BrickJumps         = [    0     0     0      0      0      0      0      0     0 ];
metadata.wasTeleported      = [    0     0     0      0      0      0      0      0     0 ];
metadata.beeline            = [    0     0     0      0      0      0      0      0     0 ];
metadata.elapsedDays        = [    1     1     1      1      1      1      1      1     1 ];
metadata.session            = [    1     1     1      1      1      1      1      1     1 ];
metadata.trialsCompleted    = [    1     2     3      4      5      6      7      8     9 ];
metadata.serial             = [ 1.05   1.1  1.15    1.2   1.25    1.3   1.35    1.4   1.5 ];
metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.oct27.swrTimes=outp.swrPeakTimesDenoise;
agg.oct27.swrXpos = swrXpos;
agg.oct27.swrYpos = swrYpos;
agg.oct27.xpos = xpos;
agg.oct27.ypos = ypos;
agg.oct27.xytimestampSeconds = xytimestampSeconds;
%
agg.oct27.trial = metadata.trial;
agg.oct27.isSubTrial = metadata.isSubTrial;
agg.oct27.error = metadata.error;
agg.oct27.outOfBounds = metadata.outOfBounds;
agg.oct27.probe = metadata.probe;
agg.oct27.beeline = metadata.beeline;
agg.oct27.sugarConsumed = metadata.sugarConsumed ;
agg.oct27.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.oct27.trialStartAction = metadata.trialStartAction;
%agg.oct27.ratPickupTeleport = metadata.ratPickupTeleport;
%agg.oct27.restartmaze = metadata.restartmaze;
%agg.oct27.restartTrial = metadata.restartTrial;
agg.oct27.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.oct27.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.oct27.swrEnvMedian = outp.swrEnvMedian;
agg.oct27.swrEnvMadam = outp.swrEnvMadam;
agg.oct27.swrThreshold = outp.swrThreshold;

agg.oct27.antiProx = outp.antiRadius;
agg.oct27.rewardProx = outp.rewardRadius;
agg.oct27.antiProxTimes = outp.antiProxTimes;
agg.oct27.rewardProxTimes = outp.rewardProxTimes;

 
metadata.day = '2017-10-30_training2';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/'  ];
metadata.autobins = false;
metadata.trial              = [      1      2      3      4       5       6       7       8  ];
metadata.leaveBucketToMaze  = [    260    455    712    923    1100    1403    1667    1928  ]; 
metadata.trialStartAction   = [    277    480    732    943    1170    1430    1718    1952  ];
metadata.sugarConsumeTimes  = [    294    520    755    957    1185    1446    1736    1975  ];
metadata.leaveMazeToBucket  = [    309    535    772    983    1205    1468    1751    2005  ];
metadata.waitTimeSec        = [     26     21     23     21      28      26      38      24  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              = [      0      0      0      0       0       0       0       0  ];
metadata.beeline            = [      0      0      0      0       0       0       0       0  ];
metadata.error              = [      0      1      0      0       0       0       0       0  ];
metadata.outOfBounds        = [      0      0      0      0       0       0       0       0  ];
metadata.sugarConsumed      = [      1      1      1      1       1       1       1       1  ];
metadata.returnsToStart     = [      0      0      0      0       0       0       0       0  ];
metadata.BrickJumps         = [      0      0      0      0       0       0       0       0  ];
metadata.wasTeleported      = [      0      0      0      0       0       0       0       0  ];
metadata.elapsedDays        = [      4      4      4      4       4       4       4       4  ];
metadata.session            = [      2      2      2      2       2       2       2       2  ];
metadata.trialsCompleted    = [      9     10     11     12      13      14      15      16  ];
metadata.serial             = [   4.05    4.1   4.15    4.2    4.25     4.3    4.35     4.4  ];
metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.oct30.swrTimes=outp.swrPeakTimesDenoise;
agg.oct30.swrXpos = swrXpos;
agg.oct30.swrYpos = swrYpos;
agg.oct30.xpos = xpos;
agg.oct30.ypos = ypos;
agg.oct30.xytimestampSeconds = xytimestampSeconds;
%
agg.oct30.trial = metadata.trial;
agg.oct30.isSubTrial = metadata.isSubTrial;
agg.oct30.error = metadata.error;
agg.oct30.outOfBounds = metadata.outOfBounds;
agg.oct30.probe = metadata.probe;
agg.oct30.beeline = metadata.beeline;
agg.oct30.sugarConsumed = metadata.sugarConsumed ;
agg.oct30.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.oct30.trialStartAction = metadata.trialStartAction;
% agg.oct30.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.oct30.restartmaze = metadata.restartmaze;
% agg.oct30.restartTrial = metadata.restartTrial;
agg.oct30.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.oct30.leaveMazeToBucket = metadata.leaveMazeToBucket;
 
agg.oct30.swrEnvMedian = outp.swrEnvMedian;
agg.oct30.swrEnvMadam = outp.swrEnvMadam;
agg.oct30.swrThreshold = outp.swrThreshold;

agg.oct30.antiProx = outp.antiRadius;
agg.oct30.rewardProx = outp.rewardRadius;
agg.oct30.antiProxTimes = outp.antiProxTimes;
agg.oct30.rewardProxTimes = outp.rewardProxTimes;





 
metadata.day = '2017-10-31_training3_probe1';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2      3      4      5       6       7       8       9      10  ];
metadata.leaveBucketToMaze  =  [   138    340    511    709    901    1207    1389    1665    1851    2116  ];
metadata.trialStartAction   =  [   144    359    538    728    922    1224    1408    1674    1870    2159  ];
metadata.sugarConsumeTimes  =  [   164    378    553    746    965    1236    1477    1687    1880    2195  ];
metadata.leaveMazeToBucket  =  [   165    396    572    767    989    1255    1498    1713    1907    2196  ];
metadata.waitTimeSec        =  [    26     20     17     19     22      12      22       9      16      15  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              =  [     1      0      0      0      0       0       0       0       0       1  ];
metadata.beeline            = [    0     0     0      0      0      0      0      0 ];
metadata.error              =  [     1      0      0      0      0       0       1       0       0       1  ];
metadata.outOfBounds        =  [     0      0      0      0      1       0       1       0       0       0  ];
metadata.sugarConsumed      =  [     0      1      1      1      1       1       1       1       1       0  ];
metadata.returnsToStart     =  [     0      0      0      0      0       0       0       0       0       0  ];
metadata.BrickJumps         =  [     0      0      0      0      0       1       1       1       1       0  ];
metadata.wasTeleported      =  [     0      0      0      0      0       0       0       0       0       0  ];
metadata.elapsedDays        =  [     5      5      5      5      5       5       5       5       5       5  ];
metadata.session            =  [     3      3      3      3      3       3       3       3       3       3  ];
metadata.trialsCompleted    =  [    17     18     19     20     21      22      23      24      25      26  ];
metadata.serial             =  [  5.05    5.1   5.15    5.2   5.25     5.3    5.35     5.4    5.45     5.5  ];
metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.oct31.swrTimes=outp.swrPeakTimesDenoise;
agg.oct31.swrXpos = swrXpos;
agg.oct31.swrYpos = swrYpos;
agg.oct31.xpos = xpos;
agg.oct31.ypos = ypos;
agg.oct31.xytimestampSeconds = xytimestampSeconds;
%
agg.oct31.trial = metadata.trial;
agg.oct31.isSubTrial = metadata.isSubTrial;
agg.oct31.error = metadata.error;
agg.oct31.outOfBounds = metadata.outOfBounds;
agg.oct31.probe = metadata.probe;
agg.oct31.beeline = metadata.beeline;
agg.oct31.sugarConsumed = metadata.sugarConsumed ;
agg.oct31.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.oct31.trialStartAction = metadata.trialStartAction;
% agg.oct31.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.oct31.restartmaze = metadata.restartmaze;
% agg.oct31.restartTrial = metadata.restartTrial;
agg.oct31.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.oct31.leaveMazeToBucket = metadata.leaveMazeToBucket;
 
agg.oct31.swrEnvMedian = outp.swrEnvMedian;
agg.oct31.swrEnvMadam = outp.swrEnvMadam;
agg.oct31.swrThreshold = outp.swrThreshold;

agg.oct31.antiProx = outp.antiRadius;
agg.oct31.rewardProx = outp.rewardRadius;
agg.oct31.antiProxTimes = outp.antiProxTimes;
agg.oct31.rewardProxTimes = outp.rewardProxTimes;




 
metadata.day = '2017-11-01_training4';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2      3      4       5       6       7       8  ];
metadata.leaveBucketToMaze  =  [   156    364    683    874    1038    1267    1441    1692  ];
metadata.trialStartAction   =  [   195    375    694    885    1076    1288    1504    1706  ];
metadata.sugarConsumeTimes  =  [   221    483    705    896    1090    1298    1514    1716  ];
metadata.leaveMazeToBucket  =  [   247    506    727    918    1112    1326    1536    1741  ];
metadata.waitTimeSec        =  [    13      7     14     15      42       4      67       6  ];
metadata.probe              =  [     0      0      0      0       0       0       0       0  ];
metadata.beeline            =  [     0      0      0      0       0       0       0       0  ];
metadata.error              =  [     0      0      0      0       0       0       0       0  ];
metadata.outOfBounds        =  [     0      1      1      0       1       0       1       0  ];
metadata.sugarConsumed      =  [     1      1      1      1       1       1       1       1  ];
metadata.returnsToStart     =  [     0      1      0      0       1       0       1       0  ];
metadata.BrickJumps         =  [     0      2      0      1       0       1       0       0  ];
metadata.wasTeleported      =  [     0      0      0      0       0       0       0       0  ];
metadata.elapsedDays        =  [     6      6      6      6       6       6       6       6  ];
metadata.session            =  [     4      4      4      4       4       4       4       4  ];
metadata.trialsCompleted    =  [    27     28     29     30      31      32      33      34  ];
metadata.serial             =  [  6.05    6.1   6.15    6.2    6.25     6.3    6.35     6.4  ];
metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.nov1.swrTimes=outp.swrPeakTimesDenoise;
agg.nov1.swrXpos = swrXpos;
agg.nov1.swrYpos = swrYpos;
agg.nov1.xpos = xpos;
agg.nov1.ypos = ypos;
agg.nov1.xytimestampSeconds = xytimestampSeconds;
%
agg.nov1.trial = metadata.trial;
agg.nov1.isSubTrial = metadata.isSubTrial;
agg.nov1.error = metadata.error;
agg.nov1.outOfBounds = metadata.outOfBounds;
agg.nov1.probe = metadata.probe;
agg.nov1.beeline = metadata.beeline;
agg.nov1.sugarConsumed = metadata.sugarConsumed ;
agg.nov1.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.nov1.trialStartAction = metadata.trialStartAction;
% agg.nov1.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.nov1.restartmaze = metadata.restartmaze;
% agg.nov1.restartTrial = metadata.restartTrial;
agg.nov1.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.nov1.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.nov1.swrEnvMedian = outp.swrEnvMedian;
agg.nov1.swrEnvMadam = outp.swrEnvMadam;
agg.nov1.swrThreshold = outp.swrThreshold;

agg.nov1.antiProx = outp.antiRadius;
agg.nov1.rewardProx = outp.rewardRadius;
agg.nov1.antiProxTimes = outp.antiProxTimes;
agg.nov1.rewardProxTimes = outp.rewardProxTimes;





 
metadata.day = '2017-11-02_training5';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2       3       4       5       6       7       8  ];
metadata.leaveBucketToMaze  =  [   514    812    1030    1282    1542    1713    2056    2468  ];
metadata.trialStartAction   =  [   519    823    1040    1302    1549    1813    2181    2493  ];
metadata.sugarConsumeTimes  =  [   649    868    1048    1313    1557    1826    2203    2513  ];
metadata.leaveMazeToBucket  =  [   683    891    1071    1394    1578    1854    2243    2537  ];
metadata.waitTimeSec        =  [     7      4      13       6       9      23      31      26  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              =  [     0      0       0       0       0       0       0       0  ];
metadata.beeline            =  [     0      0       0       0       0       0       0       0  ];
metadata.error              =  [     1      1       0       1       0       0       0       0  ];
metadata.outOfBounds        =  [     1      0       0       1       0       0       0       0  ];
metadata.sugarConsumed      =  [     1      1       1       1       1       1       1       1  ];
metadata.returnsToStart     =  [     1      0       0       1       0       0       0       0  ];
metadata.BrickJumps         =  [     0      1       0       2       0       0       0       0  ];
metadata.wasTeleported      =  [     0      0       0       0       0       0       0       0  ];
metadata.elapsedDays        =  [     7      7       7       7       7       7       7       7  ];
metadata.session            =  [     5      5       5       5       5       5       5       5  ];
metadata.trialsCompleted    =  [    35     36      37      38      39      40      41      42  ];
metadata.serial             =  [  7.05    7.1    7.15     7.2    7.25     7.3    7.35     7.4  ];
 metadata.chewRemovalEnabled = true;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.nov2.swrTimes=outp.swrPeakTimesDenoise;
agg.nov2.swrXpos = swrXpos;
agg.nov2.swrYpos = swrYpos;
agg.nov2.xpos = xpos;
agg.nov2.ypos = ypos;
agg.nov2.xytimestampSeconds = xytimestampSeconds;
%
agg.nov2.trial = metadata.trial;
agg.nov2.isSubTrial = metadata.isSubTrial;
agg.nov2.error = metadata.error;
agg.nov2.outOfBounds = metadata.outOfBounds;
agg.nov2.probe = metadata.probe;
agg.nov2.beeline = metadata.beeline;
agg.nov2.sugarConsumed = metadata.sugarConsumed ;
agg.nov2.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.nov2.trialStartAction = metadata.trialStartAction;
% agg.nov2.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.nov2.restartmaze = metadata.restartmaze;
% agg.nov2.restartTrial = metadata.restartTrial;
agg.nov2.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.nov2.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.nov2.swrEnvMedian = outp.swrEnvMedian;
agg.nov2.swrEnvMadam = outp.swrEnvMadam;
agg.nov2.swrThreshold = outp.swrThreshold;

agg.nov2.antiProx = outp.antiRadius;
agg.nov2.rewardProx = outp.rewardRadius;
agg.nov2.antiProxTimes = outp.antiProxTimes;
agg.nov2.rewardProxTimes = outp.rewardProxTimes;






 
metadata.day = '2017-11-03_training6';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2      3       4       5       6       7       8  ];
metadata.leaveBucketToMaze  =  [   496    652    826    1044    1271    1444    1621    1899  ];
metadata.trialStartAction   =  [   516    667    835    1081    1285    1474    1633    1913  ];
metadata.sugarConsumeTimes  =  [   531    678    871    1096    1304    1486    1735    1921  ];
metadata.leaveMazeToBucket  =  [   550    708    895    1118    1318    1506    1751    1942  ];
metadata.waitTimeSec        =  [    28     18     12      27       6      30      14      10  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              =  [     0      0      0       0       0       0       0       0  ];
metadata.beeline            =  [     0      0      0       0       0       0       0       0  ];
metadata.error              =  [     0      0      1       0       0       0       1       0  ];
metadata.outOfBounds        =  [     0      0      0       0       0       0       1       0  ];
metadata.sugarConsumed      =  [     1      1      1       1       1       1       1       1  ];
metadata.returnsToStart     =  [     0      0      0       0       0       0       1       0  ];
metadata.BrickJumps         =  [     0      1      0       0       1       0       1       0  ];
metadata.wasTeleported      =  [     0      0      0       0       0       0       0       0  ];
metadata.elapsedDays        =  [     8      8      8       8       8       8       8       8  ];
metadata.session            =  [     6      6      6       6       6       6       6       6  ];
metadata.trialsCompleted    =  [    43     44     45      46       47     48      49      50  ];
metadata.serial             =  [  8.05    8.1   8.15     8.2     8.25    8.3    8.35     8.4  ];
 metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.nov3.swrTimes=outp.swrPeakTimesDenoise;
agg.nov3.swrXpos = swrXpos;
agg.nov3.swrYpos = swrYpos;
agg.nov3.xpos = xpos;
agg.nov3.ypos = ypos;
agg.nov3.xytimestampSeconds = xytimestampSeconds;
%
agg.nov3.trial = metadata.trial;
agg.nov3.isSubTrial = metadata.isSubTrial;
agg.nov3.error = metadata.error;
agg.nov3.outOfBounds = metadata.outOfBounds;
agg.nov3.probe = metadata.probe;
agg.nov3.beeline = metadata.beeline;
agg.nov3.sugarConsumed = metadata.sugarConsumed ;
agg.nov3.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.nov3.trialStartAction = metadata.trialStartAction;
% agg.nov3.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.nov3.restartmaze = metadata.restartmaze;
% agg.nov3.restartTrial = metadata.restartTrial;
agg.nov3.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.nov3.leaveMazeToBucket = metadata.leaveMazeToBucket;
 
agg.nov3.swrEnvMedian = outp.swrEnvMedian;
agg.nov3.swrEnvMadam = outp.swrEnvMadam;
agg.nov3.swrThreshold = outp.swrThreshold;

agg.nov3.antiProx = outp.antiRadius;
agg.nov3.rewardProx = outp.rewardRadius;
agg.nov3.antiProxTimes = outp.antiProxTimes;
agg.nov3.rewardProxTimes = outp.rewardProxTimes;



metadata.day = '2017-11-06_training7';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2       3       4       5       6       7       8  ];
metadata.leaveBucketToMaze  =  [   465    660     850    1115    1292    1485    1863    2114  ];
metadata.trialStartAction   =  [   489    672     955    1134    1314    1527    1876    2139  ];
metadata.sugarConsumeTimes  =  [   519    684     965    1145    1323    1680    1886    2147  ];
metadata.leaveMazeToBucket  =  [   540    696     985    1170    1355    1711    1935    2176  ];
metadata.waitTimeSec        =  [    24      3     103      27      24      28      16      29  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              =  [     0      0       0       0       0       0       0       0  ];
metadata.beeline            =  [     0      0       0       0       0       0       0       0  ];
metadata.error              =  [     0      0       0       0       0       1       0       0  ];
metadata.outOfBounds        =  [     0      1       0       0       0       1       0       0  ];
metadata.sugarConsumed      =  [     1      1       1       1       1       1       1       1  ];
metadata.returnsToStart     =  [     0      0       0       0       0       1       0       0  ];
metadata.BrickJumps         =  [     0      0       0       0       0       0       0       0  ];
metadata.wasTeleported      =  [     0      0       0       0       0       0       1       0  ];
metadata.elapsedDays        =  [    11     11      11      11      11      11      11      11  ];
metadata.session            =  [     7      7       7       7       7       7       7       7  ];
metadata.trialsCompleted    =  [    51     52      53      54      55      56      57      58  ];
metadata.serial             =  [ 11.05   11.1   11.15    11.2   11.25    11.3   11.35    11.4  ];
 metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.nov6.swrTimes=outp.swrPeakTimesDenoise;
agg.nov6.swrXpos = swrXpos;
agg.nov6.swrYpos = swrYpos;
agg.nov6.xpos = xpos;
agg.nov6.ypos = ypos;
agg.nov6.xytimestampSeconds = xytimestampSeconds;
%
agg.nov6.trial = metadata.trial;
agg.nov6.isSubTrial = metadata.isSubTrial;
agg.nov6.error = metadata.error;
agg.nov6.outOfBounds = metadata.outOfBounds;
agg.nov6.probe = metadata.probe;
agg.nov6.beeline = metadata.beeline;
agg.nov6.sugarConsumed = metadata.sugarConsumed ;
agg.nov6.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.nov6.trialStartAction = metadata.trialStartAction;
% agg.nov6.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.nov6.restartmaze = metadata.restartmaze;
% agg.nov6.restartTrial = metadata.restartTrial;
agg.nov6.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.nov6.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.nov6.swrEnvMedian = outp.swrEnvMedian;
agg.nov6.swrEnvMadam = outp.swrEnvMadam;
agg.nov6.swrThreshold = outp.swrThreshold;

agg.nov6.antiProx = outp.antiRadius;
agg.nov6.rewardProx = outp.rewardRadius;
agg.nov6.antiProxTimes = outp.antiProxTimes;
agg.nov6.rewardProxTimes = outp.rewardProxTimes;




 
metadata.day = '2017-11-07_training8';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2      3       4       5       6       7       8  ];
metadata.leaveBucketToMaze  =  [   408    634    805     997    1218    1367    1519    1680  ];
metadata.trialStartAction   =  [   450    654    836    1051    1229    1382    1543    1689  ];
metadata.sugarConsumeTimes  =  [   473    670    845    1062    1247    1395    1551    1705  ];
metadata.leaveMazeToBucket  =  [   498    690    867    1082    1278    1422    1571    1728  ];
metadata.waitTimeSec        =  [     8     22     20      20      13      14      17      13  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              =  [     0      0      0       0       0       0       0       0  ];
metadata.beeline            =  [     0      0      0       0       0       0       0       0  ];
metadata.error              =  [     0      0      0       0       0       0       0       0  ];
metadata.outOfBounds        =  [     0      0      0       0       0       0       0       0  ];
metadata.sugarConsumed      =  [     1      1      1       1       1       1       1       1  ];
metadata.returnsToStart     =  [     0      0      0       0       0       0       0       0  ];
metadata.BrickJumps         =  [     0      1      0       0       1       1       0       1  ];
metadata.wasTeleported      =  [     0      0      0       0       0       0       0       0  ];
metadata.elapsedDays        =  [    12     12     12      12      12      12      12      12  ];
metadata.session            =  [     8      8      8       8       8       8       8       8  ];
metadata.trialsCompleted    =  [    59     60     61      62      63      64      65      66  ];
metadata.serial             =  [ 12.05   12.1  12.15    12.2   12.25    12.3    12.35   12.4  ];
  metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.nov7.swrTimes=outp.swrPeakTimesDenoise;
agg.nov7.swrXpos = swrXpos;
agg.nov7.swrYpos = swrYpos;
agg.nov7.xpos = xpos;
agg.nov7.ypos = ypos;
agg.nov7.xytimestampSeconds = xytimestampSeconds;
%
agg.nov7.trial = metadata.trial;
agg.nov7.isSubTrial = metadata.isSubTrial;
agg.nov7.error = metadata.error;
agg.nov7.outOfBounds = metadata.outOfBounds;
agg.nov7.probe = metadata.probe;
agg.nov7.beeline = metadata.beeline;
agg.nov7.sugarConsumed = metadata.sugarConsumed ;
agg.nov7.leaveBucketToMaze = metadata.leaveBucketToMaze;
 agg.nov7.trialStartAction = metadata.trialStartAction;
% agg.nov7.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.nov7.restartmaze = metadata.restartmaze;
%agg.nov7.restartTrial = metadata.restartTrial;
agg.nov7.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.nov7.leaveMazeToBucket = metadata.leaveMazeToBucket;
 
agg.nov7.swrEnvMedian = outp.swrEnvMedian;
agg.nov7.swrEnvMadam = outp.swrEnvMadam;
agg.nov7.swrThreshold = outp.swrThreshold;

agg.nov7.antiProx = outp.antiRadius;
agg.nov7.rewardProx = outp.rewardRadius;
agg.nov7.antiProxTimes = outp.antiProxTimes;
agg.nov7.rewardProxTimes = outp.rewardProxTimes;







metadata.day = '2017-11-08_training9_probe2';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
metadata.autobins = false;
metadata.trial              =  [     1      2      3      4       5       6       7      8       9     10  ];
metadata.leaveBucketToMaze  =  [   345    567    768    992    1224    1432    1592   1846    2026   2402  ];
metadata.trialStartAction   =  [   372    595    795   1047    1238    1448    1602   1859    2054   2452  ];
metadata.sugarConsumeTimes  =  [   393    605    823   1071    1262    1462    1709   1871    2169   2495  ];
metadata.leaveMazeToBucket  =  [   394    629    851   1091    1278    1487    1724   1893    2171   2516  ];
metadata.waitTimeSec        =  [    30     29     30     33      28      18      12     17      30     43  ];
%metadata.trialStartAction   = metadata.leaveBucketToMaze + metadata.waitTimeSec ;
metadata.probe              =  [     1      0      0      0       0       0       0      0       0      1  ];
metadata.beeline            =  [     0      0      0      0       0       0       0      0       0      0  ];
metadata.error              =  [     0      0      0      0       0       0       1      0       0      0  ];
metadata.outOfBounds        =  [     0      0      0      0       0       0       0      0       0      0  ];
metadata.sugarConsumed      =  [     0      1      1      1       1       1       1      1       1      0  ];
metadata.returnsToStart     =  [     0      0      0      0       0       0       1      0       0      0  ];
metadata.BrickJumps         =  [     0      0      0      0       1       1       1      1       0      0  ];
metadata.wasTeleported      =  [     0      0      0      0       0       0       0      0       0      0  ];
metadata.elapsedDays        =  [    13     13     13     13      13      13      13     13      13     13  ];
metadata.session            =  [     9      9      9      9       9       9       9      9       9      9  ];
metadata.trialsCompleted    =  [    67     68     69     70      71      72      73     74      75     76  ];
metadata.serial             =  [ 13.05   13.1  13.15   13.2   13.25    13.3   13.35   13.4   13.45   13.5  ];
  metadata.chewRemovalEnabled = false;
%
outp=analyzeSWRda12(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.nov8.swrTimes=outp.swrPeakTimesDenoise;
agg.nov8.swrXpos = swrXpos;
agg.nov8.swrYpos = swrYpos;
agg.nov8.xpos = xpos;
agg.nov8.ypos = ypos;
agg.nov8.xytimestampSeconds = xytimestampSeconds;
%
agg.nov8.trial = metadata.trial;
agg.nov8.isSubTrial = metadata.isSubTrial;
agg.nov8.error = metadata.error;
agg.nov8.outOfBounds = metadata.outOfBounds;
agg.nov8.probe = metadata.probe;
agg.nov8.beeline = metadata.beeline;
agg.nov8.sugarConsumed = metadata.sugarConsumed ;
agg.nov8.leaveBucketToMaze = metadata.leaveBucketToMaze;
 agg.nov8.trialStartAction = metadata.trialStartAction;
% agg.nov8.ratPickupTeleport = metadata.ratPickupTeleport;
% agg.nov8.restartmaze = metadata.restartmaze;
%agg.nov8.restartTrial = metadata.restartTrial;
agg.nov8.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.nov8.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.nov8.swrEnvMedian = outp.swrEnvMedian;
agg.nov8.swrEnvMadam = outp.swrEnvMadam;
agg.nov8.swrThreshold = outp.swrThreshold;

agg.nov8.antiProx = outp.antiRadius;
agg.nov8.rewardProx = outp.rewardRadius;
agg.nov8.antiProxTimes = outp.antiProxTimes;
agg.nov8.rewardProxTimes = outp.rewardProxTimes;


return;


% = ORDER OF POSSIBLE EVENTS DURING TRAINING =
% LeaveBucketToMaze
% StartTrial
% (ratPickupTeleport)    -- () indicates possible event(s), not gauranteed
% (restartMaze)
% (restartTrial)
% consumeSugar
% LeaveMazeToBucket





