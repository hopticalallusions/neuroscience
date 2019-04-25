clear all; 
close all;

metadata.rat = 'da5';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC10.ncs'  'CSC14.ncs'  'CSC18.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  };  % theta 'CSC46.ncs'  lots of cells 'CSC6.ncs'  'CSC26.ncs'
metadata.fileListDisconnectedLfp={ 'CSC16.ncs' 'CSC21.ncs' };
metadata.swrLfpFile =  'CSC30.ncs' ; % 'CSC6.ncs'; %  'CSC26.ncs'   ch6 is maybe wrong?  ;; my notes say ch28 a lot, which is on the tetrode with ch30
metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.outputDir = [ '/Users/andrewhowe/data/plusMazeEphys/' metadata.rat '/' ];
metadata.sampleRate.lfp=32000;
metadata.sampleRate.telemetry=29.97;
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
metadata.waypoints.center.x     =  310;
metadata.waypoints.center.y     =  234;
metadata.waypoints.start.x      =  137;
metadata.waypoints.start.y      =   52;
metadata.waypoints.reward.x     =  140;
metadata.waypoints.reward.y     =  390;
metadata.waypoints.antireward.x =  538;
metadata.waypoints.antireward.y =   54;
metadata.waypoints.rotation.x   =  325;
metadata.waypoints.rotation.y   =  252;
metadata.pxPerCm = sqrt( (metadata.waypoints.reward.x-metadata.waypoints.antireward.x)^2  + (metadata.waypoints.reward.y-metadata.waypoints.antireward.y)^2   )/215;


agg.sampleRate.telemetry=29.97;

agg.sampleRate.lfp=32000;
agg.sampleRate.telemetry=29.97;
agg.waypoints.center.x     =  metadata.waypoints.center.x;
agg.waypoints.center.y     =  metadata.waypoints.center.y;
agg.waypoints.start.x      =  metadata.waypoints.start.x;
agg.waypoints.start.y      =  metadata.waypoints.start.y;
agg.waypoints.reward.x     =  metadata.waypoints.reward.x;
agg.waypoints.reward.y     =  metadata.waypoints.reward.y;
agg.waypoints.antireward.x =  metadata.waypoints.antireward.x;
agg.waypoints.antireward.y =  metadata.waypoints.antireward.y;
agg.pxPerCm = sqrt( (metadata.waypoints.reward.x-metadata.waypoints.antireward.x)^2  + (metadata.waypoints.reward.y-metadata.waypoints.antireward.y)^2   )/210;



% '/2016-08-22_orientation1/'
% '/2016-08-23_orientation2/'
% '/2016-08-24_training1/'
% '/2016-08-25_training2/'
% '/2016-08-26_probe1/'
% '/2016-08-27_training3/'
% '/2016-08-28_training4/'
% '/2016-08-29_training5/'
% '/2016-08-30_training6/'
% '/2016-08-31_training7/'
% '/2016-09-01_training8/'
% '/2016-09-02_probe2/'
% '/2016-09-06_training9_x2/'
% '/2016-09-07_training10_x2/'
% '/2016-09-08_probe3_training11/'








'/2016-08-22_orientation1/'

metadata.day = '2016-08-22_orientation1/1.maze-habituation/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                         I  
metadata.trial             = [  1 ];
metadata.isSubTrial        = [  0 ];
metadata.error             = [  0 ];
metadata.outOfBounds       = [  0 ];
metadata.probe             = [  0 ];
metadata.beeline           = [  1 ];
metadata.sugarConsumed     = [  1 ];
metadata.leaveBucketToMaze = [ 48 ];
metadata.trialStartAction  = [ 77 ];
metadata.ratPickupTeleport = [    ];
metadata.restartmaze       = [    ];
metadata.restartTrial      = [    ];
metadata.sugarConsumeTimes = [ 755 ];
metadata.leaveMazeToBucket = [ 760 ];
metadata.chewRemovalEnabled = false;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug22.swrTimes=outp.swrPeakTimesDenoise;
agg.aug22.swrXpos = swrXpos;
agg.aug22.swrYpos = swrYpos;
agg.aug22.xpos = xpos;
agg.aug22.ypos = ypos;
agg.aug22.xytimestampSeconds = xytimestampSeconds;


agg.aug22.trial = metadata.trial;
agg.aug22.isSubTrial = metadata.isSubTrial;
agg.aug22.error = metadata.error;
agg.aug22.outOfBounds = metadata.outOfBounds;
agg.aug22.probe = metadata.probe;
agg.aug22.beeline = metadata.beeline;
agg.aug22.sugarConsumed = metadata.sugarConsumed ;
agg.aug22.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug22.trialStartAction = metadata.trialStartAction;
agg.aug22.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug22.restartmaze = metadata.restartmaze;
agg.aug22.restartTrial = metadata.restartTrial;
agg.aug22.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug22.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug22.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug22.swrEnvMedian = outp.swrEnvMedian;
agg.aug22.swrEnvMadam = outp.swrEnvMadam;
agg.aug22.swrThreshold = outp.swrThreshold;
agg.aug22.antiRadius = outp.antiRadius;
agg.aug22.rewardRadius = outp.rewardRadius;
agg.aug22.antiProxTimes = outp.antiProxTimes;
agg.aug22.rewardProxTimes = outp.rewardProxTimes;





'/2016-08-23_orientation2/'

metadata.day = '2016-08-23_orientation2/1.maze-habituation/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                         I  
metadata.trial             = [  1 ];
metadata.isSubTrial        = [  0 ];
metadata.error             = [  0 ];
metadata.outOfBounds       = [  0 ];
metadata.probe             = [  0 ];
metadata.beeline           = [  1 ];
metadata.sugarConsumed     = [  1 ];
metadata.leaveBucketToMaze = [ 48 ];
metadata.trialStartAction  = [ 77 ];
metadata.ratPickupTeleport = [    ];
metadata.restartmaze       = [    ];
metadata.restartTrial      = [    ];
metadata.sugarConsumeTimes = [ 735 ];
metadata.leaveMazeToBucket = [ 738 ];
metadata.chewRemovalEnabled = false;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug23.swrTimes=outp.swrPeakTimesDenoise;
agg.aug23.swrXpos = swrXpos;
agg.aug23.swrYpos = swrYpos;
agg.aug23.xpos = xpos;
agg.aug23.ypos = ypos;
agg.aug23.xytimestampSeconds = xytimestampSeconds;

agg.aug23.trial = metadata.trial;
agg.aug23.isSubTrial = metadata.isSubTrial;
agg.aug23.error = metadata.error;
agg.aug23.outOfBounds = metadata.outOfBounds;
agg.aug23.probe = metadata.probe;
agg.aug23.beeline = metadata.beeline;
agg.aug23.sugarConsumed = metadata.sugarConsumed ;
agg.aug23.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug23.trialStartAction = metadata.trialStartAction;
agg.aug23.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug23.restartmaze = metadata.restartmaze;
agg.aug23.restartTrial = metadata.restartTrial;
agg.aug23.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug23.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug23.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug23.swrEnvMedian = outp.swrEnvMedian;
agg.aug23.swrEnvMadam = outp.swrEnvMadam;
agg.aug23.swrThreshold = outp.swrThreshold;
agg.aug23.antiRadius = outp.antiRadius;
agg.aug23.rewardRadius = outp.rewardRadius;
agg.aug23.antiProxTimes = outp.antiProxTimes;
agg.aug23.rewardProxTimes = outp.rewardProxTimes;




'/2016-08-24_training1/'

metadata.day = '2016-08-24_training1/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1    2    3     4     5     6     7     8  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0  ];
metadata.error             = [   1    1    1     1     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  31  368  665   937  1231  1480  1734  2014  ];
metadata.trialStartAction  = [  65  412  695   973  1268  1519  1777  2052  ];  % funkiness
metadata.sugarConsumeTimes = [  138 432  713   982  1282  1532  1792  2080  ];
metadata.leaveMazeToBucket = [  142 452  733  1002  1284  1536  1794  2082  ];
metadata.ratPickupTeleport = [                                              ];
metadata.restartmaze       = [                                              ];
metadata.restartTrial      = [                                              ];
metadata.chewRemovalEnabled = false;
outp=analyzeSWRda5(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug24.swrTimes=outp.swrPeakTimesDenoise;
agg.aug24.swrXpos = swrXpos;
agg.aug24.swrYpos = swrYpos;
agg.aug24.xpos = xpos;
agg.aug24.ypos = ypos;
agg.aug24.xytimestampSeconds = xytimestampSeconds;

agg.aug24.trial = metadata.trial;
agg.aug24.isSubTrial = metadata.isSubTrial;
agg.aug24.error = metadata.error;
agg.aug24.outOfBounds = metadata.outOfBounds;
agg.aug24.probe = metadata.probe;
agg.aug24.beeline = metadata.beeline;
agg.aug24.sugarConsumed = metadata.sugarConsumed ;
agg.aug24.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug24.trialStartAction = metadata.trialStartAction;
agg.aug24.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug24.restartmaze = metadata.restartmaze;
agg.aug24.restartTrial = metadata.restartTrial;
agg.aug24.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug24.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug24.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug24.swrEnvMedian = outp.swrEnvMedian;
agg.aug24.swrEnvMadam = outp.swrEnvMadam;
agg.aug24.swrThreshold = outp.swrThreshold;
agg.aug24.antiRadius = outp.antiRadius;
agg.aug24.rewardRadius = outp.rewardRadius;
agg.aug24.antiProxTimes = outp.antiProxTimes;
agg.aug24.rewardProxTimes = outp.rewardProxTimes;



'/2016-08-25_training2/'

metadata.day = '2016-08-25_training2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1    2    3     4     5     6     7     8  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0  ];
metadata.error             = [   0    0    1     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  54  318  581   870  1120  1369  1619  1859  ];
metadata.trialStartAction  = [  94  368  618   903  1148  1408  1640  1880  ];
metadata.ratPickupTeleport = [                                              ];
metadata.restartmaze       = [                                              ];
metadata.restartTrial      = [                                              ];
metadata.sugarConsumeTimes = [  115 380  654   923  1164  1419  1655  1892  ];
metadata.leaveMazeToBucket = [  123 386  663   930  1169  1424  1665  1899  ];
metadata.chewRemovalEnabled = false;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug25.swrTimes=outp.swrPeakTimesDenoise;
agg.aug25.swrXpos = swrXpos;
agg.aug25.swrYpos = swrYpos;
agg.aug25.xpos = xpos;
agg.aug25.ypos = ypos;
agg.aug25.xytimestampSeconds = xytimestampSeconds;

agg.aug25.trial = metadata.trial;
agg.aug25.isSubTrial = metadata.isSubTrial;
agg.aug25.error = metadata.error;
agg.aug25.outOfBounds = metadata.outOfBounds;
agg.aug25.probe = metadata.probe;
agg.aug25.beeline = metadata.beeline;
agg.aug25.sugarConsumed = metadata.sugarConsumed ;
agg.aug25.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug25.trialStartAction = metadata.trialStartAction;
agg.aug25.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug25.restartmaze = metadata.restartmaze;
agg.aug25.restartTrial = metadata.restartTrial;
agg.aug25.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug25.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug25.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug25.swrEnvMedian = outp.swrEnvMedian;
agg.aug25.swrEnvMadam = outp.swrEnvMadam;
agg.aug25.swrThreshold = outp.swrThreshold;
agg.aug25.antiRadius = outp.antiRadius;
agg.aug25.rewardRadius = outp.rewardRadius;
agg.aug25.antiProxTimes = outp.antiProxTimes;
agg.aug25.rewardProxTimes = outp.rewardProxTimes;



'/2016-08-26_probe1/'
metadata.day = '2016-08-26_probe1/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1 ];
metadata.isSubTrial        = [   0 ];
metadata.error             = [   0 ];
metadata.outOfBounds       = [   0 ];
metadata.probe             = [   0 ];
metadata.beeline           = [   0 ];
metadata.sugarConsumed     = [   0 ];
metadata.leaveBucketToMaze = [  35 ];
metadata.trialStartAction  = [  42 ];
metadata.ratPickupTeleport = [     ];
metadata.restartmaze       = [     ];
metadata.restartTrial      = [     ];
metadata.sugarConsumeTimes = [  69 ];
metadata.leaveMazeToBucket = [  71 ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug26.swrTimes=outp.swrPeakTimesDenoise;
agg.aug26.swrXpos = swrXpos;
agg.aug26.swrYpos = swrYpos;
agg.aug26.xpos = xpos;
agg.aug26.ypos = ypos;
agg.aug26.xytimestampSeconds = xytimestampSeconds;

agg.aug26.trial = metadata.trial;
agg.aug26.isSubTrial = metadata.isSubTrial;
agg.aug26.error = metadata.error;
agg.aug26.outOfBounds = metadata.outOfBounds;
agg.aug26.probe = metadata.probe;
agg.aug26.beeline = metadata.beeline;
agg.aug26.sugarConsumed = metadata.sugarConsumed ;
agg.aug26.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug26.trialStartAction = metadata.trialStartAction;
agg.aug26.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug26.restartmaze = metadata.restartmaze;
agg.aug26.restartTrial = metadata.restartTrial;
agg.aug26.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug26.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug26.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug26.swrEnvMedian = outp.swrEnvMedian;
agg.aug26.swrEnvMadam = outp.swrEnvMadam;
agg.aug26.swrThreshold = outp.swrThreshold;
agg.aug26.antiRadius = outp.antiRadius;
agg.aug26.rewardRadius = outp.rewardRadius;
agg.aug26.antiProxTimes = outp.antiProxTimes;
agg.aug26.rewardProxTimes = outp.rewardProxTimes;


'/2016-08-27_training3/'

metadata.day = '2016-08-27_training3/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1    2    3     4     5     6     7     8  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0  ];
metadata.error             = [   1    0    0     0     1     0     1     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  13  271  525   756  1030  1284  1510  1749  ];
metadata.trialStartAction  = [  33  297  547   815  1081  1316  1533  1777  ];
metadata.sugarConsumeTimes = [  60  307  559   827  1108  1329  1559  1787  ];
metadata.leaveMazeToBucket = [  67  312  562   824  1112  1332  1564  1790  ];
metadata.ratPickupTeleport = [                                              ];
metadata.restartmaze       = [                                              ];
metadata.restartTrial      = [                                              ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug27.swrTimes=outp.swrPeakTimesDenoise;
agg.aug27.swrXpos = swrXpos;
agg.aug27.swrYpos = swrYpos;
agg.aug27.xpos = xpos;
agg.aug27.ypos = ypos;
agg.aug27.xytimestampSeconds = xytimestampSeconds;

agg.aug27.trial = metadata.trial;
agg.aug27.isSubTrial = metadata.isSubTrial;
agg.aug27.error = metadata.error;
agg.aug27.outOfBounds = metadata.outOfBounds;
agg.aug27.probe = metadata.probe;
agg.aug27.beeline = metadata.beeline;
agg.aug27.sugarConsumed = metadata.sugarConsumed ;
agg.aug27.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug27.trialStartAction = metadata.trialStartAction;
agg.aug27.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug27.restartmaze = metadata.restartmaze;
agg.aug27.restartTrial = metadata.restartTrial;
agg.aug27.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug27.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug27.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug27.swrEnvMedian = outp.swrEnvMedian;
agg.aug27.swrEnvMadam = outp.swrEnvMadam;
agg.aug27.swrThreshold = outp.swrThreshold;
agg.aug27.antiRadius = outp.antiRadius;
agg.aug27.rewardRadius = outp.rewardRadius;
agg.aug27.antiProxTimes = outp.antiProxTimes;
agg.aug27.rewardProxTimes = outp.rewardProxTimes;




'/2016-08-28_training4/'

metadata.day = '2016-08-28_training4/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1    2    3     4     5     6     7     8  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0  ];
metadata.error             = [   1    1    1     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  50  337  626   939  1205  1483  1766  2029  ];
metadata.trialStartAction  = [  72  375  666   966  1236  1520  1798  2056  ];
metadata.sugarConsumeTimes = [ 106  401  700   976  1246  1529  1807  2065  ];
metadata.leaveMazeToBucket = [ 128  425  735   998  1271  1554  1830  2085  ];
metadata.ratPickupTeleport = [                                              ];
metadata.restartmaze       = [                                              ];
metadata.restartTrial      = [                                              ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
% 
agg.aug28.swrTimes=outp.swrPeakTimesDenoise;
agg.aug28.swrXpos = swrXpos;
agg.aug28.swrYpos = swrYpos;
agg.aug28.xpos = xpos;
agg.aug28.ypos = ypos;
agg.aug28.xytimestampSeconds = xytimestampSeconds;

agg.aug28.trial = metadata.trial;
agg.aug28.isSubTrial = metadata.isSubTrial;
agg.aug28.error = metadata.error;
agg.aug28.outOfBounds = metadata.outOfBounds;
agg.aug28.probe = metadata.probe;
agg.aug28.beeline = metadata.beeline;
agg.aug28.sugarConsumed = metadata.sugarConsumed ;
agg.aug28.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug28.trialStartAction = metadata.trialStartAction;
agg.aug28.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug28.restartmaze = metadata.restartmaze;
agg.aug28.restartTrial = metadata.restartTrial;
agg.aug28.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug28.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug28.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug28.swrEnvMedian = outp.swrEnvMedian;
agg.aug28.swrEnvMadam = outp.swrEnvMadam;
agg.aug28.swrThreshold = outp.swrThreshold;
agg.aug28.antiRadius = outp.antiRadius;
agg.aug28.rewardRadius = outp.rewardRadius;
agg.aug28.antiProxTimes = outp.antiProxTimes;
agg.aug28.rewardProxTimes = outp.rewardProxTimes;



'/2016-08-29_training5/'

metadata.day = '2016-08-29_training5/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1    2    3     4     5     6     7     8  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0  ];
metadata.error             = [   0    0    0     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  18  265  510   763  1029  1294  1538  1798  ];
metadata.trialStartAction  = [  35  285  545   785  1062  1315  1575  1833  ];
metadata.sugarConsumeTimes = [  52  300  559   813  1073  1328  1592  1847  ];
metadata.leaveMazeToBucket = [  75  320  579   837  1095  1347  1612  1867  ];
metadata.ratPickupTeleport = [                                              ];
metadata.restartmaze       = [                                              ];
metadata.restartTrial      = [                                              ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
% 
agg.aug29.swrTimes=outp.swrPeakTimesDenoise;
agg.aug29.swrXpos = swrXpos;
agg.aug29.swrYpos = swrYpos;
agg.aug29.xpos = xpos;
agg.aug29.ypos = ypos;
agg.aug29.xytimestampSeconds = xytimestampSeconds;


agg.aug29.trial = metadata.trial;
agg.aug29.isSubTrial = metadata.isSubTrial;
agg.aug29.error = metadata.error;
agg.aug29.outOfBounds = metadata.outOfBounds;
agg.aug29.probe = metadata.probe;
agg.aug29.beeline = metadata.beeline;
agg.aug29.sugarConsumed = metadata.sugarConsumed ;
agg.aug29.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug29.trialStartAction = metadata.trialStartAction;
agg.aug29.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug29.restartmaze = metadata.restartmaze;
agg.aug29.restartTrial = metadata.restartTrial;
agg.aug29.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug29.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug29.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug29.swrEnvMedian = outp.swrEnvMedian;
agg.aug29.swrEnvMadam = outp.swrEnvMadam;
agg.aug29.swrThreshold = outp.swrThreshold;
agg.aug29.antiRadius = outp.antiRadius;
agg.aug29.rewardRadius = outp.rewardRadius;
agg.aug29.antiProxTimes = outp.antiProxTimes;
agg.aug29.rewardProxTimes = outp.rewardProxTimes;



%% ABOVE HERE CHECKED OUT

metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC10.ncs'  'CSC19.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  };  % theta 'CSC46.ncs'  lots of cells 'CSC6.ncs'  'CSC26.ncs'
metadata.fileListDisconnectedLfp={  'CSC21.ncs' }; %'CSC16.ncs'
metadata.swrLfpFile =  'CSC30.ncs' ; % 'CSC6.ncs'; %  'CSC26.ncs'   ch6 is maybe wrong?  ;; my notes say ch28 a lot, which is on the tetrode with ch30

%% this one is messed up
'/2016-08-30_training6/'
metadata.day = '2016-08-30_training6/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII  
metadata.trial             = [   1    2    3     4     5     6     7     8  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0  ];
metadata.error             = [   1    1    0     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  13  289  548   821  1096  1390  1666  1920  ];
metadata.trialStartAction  = [  30  300  555   840  1105  1410  1680  1940  ];
metadata.ratPickupTeleport = [                                              ];
metadata.restartmaze       = [                                              ];
metadata.restartTrial      = [                                              ];
metadata.sugarConsumeTimes = [  69  349  613   872  1157  1440  1712  1959  ];
metadata.leaveMazeToBucket = [  89  371  631   893  1179  1461  1731  1978  ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5badDay(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.aug30.swrTimes=outp.swrPeakTimesDenoise;
agg.aug30.swrXpos = swrXpos;
agg.aug30.swrYpos = swrYpos;
agg.aug30.xpos = xpos;
agg.aug30.ypos = ypos;
agg.aug30.xytimestampSeconds = xytimestampSeconds;

agg.aug30.trial = metadata.trial;
agg.aug30.isSubTrial = metadata.isSubTrial;
agg.aug30.error = metadata.error;
agg.aug30.outOfBounds = metadata.outOfBounds;
agg.aug30.probe = metadata.probe;
agg.aug30.beeline = metadata.beeline;
agg.aug30.sugarConsumed = metadata.sugarConsumed ;
agg.aug30.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug30.trialStartAction = metadata.trialStartAction;
agg.aug30.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug30.restartmaze = metadata.restartmaze;
agg.aug30.restartTrial = metadata.restartTrial;
agg.aug30.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug30.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug30.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug30.swrEnvMedian = outp.swrEnvMedian;
agg.aug30.swrEnvMadam = outp.swrEnvMadam;
agg.aug30.swrThreshold = outp.swrThreshold;
agg.aug30.antiRadius = outp.antiRadius;
agg.aug30.rewardRadius = outp.rewardRadius;
agg.aug30.antiProxTimes = outp.antiProxTimes;
agg.aug30.rewardProxTimes = outp.rewardProxTimes;



metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC10.ncs'  'CSC14.ncs'  'CSC18.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  };  % theta 'CSC46.ncs'  lots of cells 'CSC6.ncs'  'CSC26.ncs'
metadata.fileListDisconnectedLfp={ 'CSC16.ncs' 'CSC21.ncs' };
metadata.swrLfpFile =  'CSC30.ncs' ; % 'CSC6.ncs'; %  'CSC26.ncs'   ch6 is maybe wrong?  ;; my notes say ch28 a lot, which is on the tetrode with ch30


%% checked
'/2016-08-31_training7/'
metadata.day = '2016-08-31_training7/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII    IX     X    XI   XII  XIII   XIV      
metadata.trial             = [   1    2    3     4     5     6     7     8     9    10    11    12    13    14  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.error             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     1  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1     1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [ 199  430  687   942  1105  1356  1569  1812  2049  2290  2544  2804  3032  3252  ];
metadata.trialStartAction  = [ 225  460  715   970  1142  1381  1598  1851  2075  2333  2597  2825  3052  3283  ];
metadata.sugarConsumeTimes = [ 235  472  728   978  1152  1391  1610  1863  2086  2344  2606  2835  3062  3311  ];
metadata.leaveMazeToBucket = [ 256  490  747   985  1157  1399  1620  1868  2096  2352  2616  2841  3068  3316  ];
metadata.ratPickupTeleport = [                                                                                  ];
metadata.restartmaze       = [                                                                                  ];
metadata.restartTrial      = [                                                                                  ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
idx=[]; for ii=1:length(outp.swrPeakTimesDenoise); idx=[ idx find( (outp.swrPeakTimesDenoise(ii) < xytimestampSeconds) , 1 )]; end;
swrXpos = xpos(idx);
swrYpos = ypos(idx);
% 
agg.aug31.swrTimes=outp.swrPeakTimesDenoise;
agg.aug31.swrXpos = swrXpos;
agg.aug31.swrYpos = swrYpos;
agg.aug31.xpos = xpos;
agg.aug31.ypos = ypos;
agg.aug31.xytimestampSeconds = xytimestampSeconds;

agg.aug31.trial = metadata.trial;
agg.aug31.isSubTrial = metadata.isSubTrial;
agg.aug31.error = metadata.error;
agg.aug31.outOfBounds = metadata.outOfBounds;
agg.aug31.probe = metadata.probe;
agg.aug31.beeline = metadata.beeline;
agg.aug31.sugarConsumed = metadata.sugarConsumed ;
agg.aug31.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.aug31.trialStartAction = metadata.trialStartAction;
agg.aug31.ratPickupTeleport = metadata.ratPickupTeleport;
agg.aug31.restartmaze = metadata.restartmaze;
agg.aug31.restartTrial = metadata.restartTrial;
agg.aug31.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.aug31.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.aug31.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.aug31.swrEnvMedian = outp.swrEnvMedian;
agg.aug31.swrEnvMadam = outp.swrEnvMadam;
agg.aug31.swrThreshold = outp.swrThreshold;
agg.aug31.antiRadius = outp.antiRadius;
agg.aug31.rewardRadius = outp.rewardRadius;
agg.aug31.antiProxTimes = outp.antiProxTimes;
agg.aug31.rewardProxTimes = outp.rewardProxTimes;



%% checked

'/2016-09-01_training8/'
metadata.day = '2016-09-01_training8/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII    IX     X    XI   XII  XIII   XIV    XV   
metadata.trial             = [   1    2    3     4     5     6     7     8     9    10    11    12    13    14    15  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.error             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1     1     1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  15  257  517   753   990  1234  1468  1704  1932  2174  2413  2660  2892  3134  3311  ];
metadata.trialStartAction  = [  44  299  549   786  1030  1262  1499  1726  1967  2207  2453  2692  2925  3156  3347  ];
metadata.sugarConsumeTimes = [  53  308  556   794  1039  1271  1506  1731  1974  2213  2459  2699  2932  3164  3353  ];
metadata.leaveMazeToBucket = [  60  310  558   800  1041  1274  1510  1736  1977  2215  2463  2702  2935  3169  3356  ];
metadata.ratPickupTeleport = [                                                                                        ];
metadata.restartmaze       = [                                                                                        ];
metadata.restartTrial      = [                                                                                        ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
% 
agg.sep1.swrTimes=outp.swrPeakTimesDenoise;
agg.sep1.swrXpos = swrXpos;
agg.sep1.swrYpos = swrYpos;
agg.sep1.xpos = xpos;
agg.sep1.ypos = ypos;
agg.sep1.xytimestampSeconds = xytimestampSeconds;

agg.sep1.trial = metadata.trial;
agg.sep1.isSubTrial = metadata.isSubTrial;
agg.sep1.error = metadata.error;
agg.sep1.outOfBounds = metadata.outOfBounds;
agg.sep1.probe = metadata.probe;
agg.sep1.beeline = metadata.beeline;
agg.sep1.sugarConsumed = metadata.sugarConsumed ;
agg.sep1.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.sep1.trialStartAction = metadata.trialStartAction;
agg.sep1.ratPickupTeleport = metadata.ratPickupTeleport;
agg.sep1.restartmaze = metadata.restartmaze;
agg.sep1.restartTrial = metadata.restartTrial;
agg.sep1.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.sep1.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.sep1.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.sep1.swrEnvMedian = outp.swrEnvMedian;
agg.sep1.swrEnvMadam = outp.swrEnvMadam;
agg.sep1.swrThreshold = outp.swrThreshold;
agg.sep1.antiRadius = outp.antiRadius;
agg.sep1.rewardRadius = outp.rewardRadius;
agg.sep1.antiProxTimes = outp.antiProxTimes;
agg.sep1.rewardProxTimes = outp.rewardProxTimes;



'/2016-09-02_probe2/'
metadata.day = '2016-09-02_probe2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I    
metadata.trial             = [   1  ];
metadata.isSubTrial        = [   0  ];
metadata.error             = [   0  ];
metadata.outOfBounds       = [   0  ];
metadata.probe             = [   1  ];
metadata.beeline           = [   0  ];
metadata.sugarConsumed     = [   0  ];
metadata.leaveBucketToMaze = [  58  ];
metadata.trialStartAction  = [  89  ];
metadata.sugarConsumeTimes = [  90  ];
metadata.leaveMazeToBucket = [  92  ];
metadata.ratPickupTeleport = [      ];
metadata.restartmaze       = [      ];
metadata.restartTrial      = [      ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
% 
agg.sep2.swrTimes=outp.swrPeakTimesDenoise;
agg.sep2.swrXpos = swrXpos;
agg.sep2.swrYpos = swrYpos;
agg.sep2.xpos = xpos;
agg.sep2.ypos = ypos;
agg.sep2.xytimestampSeconds = xytimestampSeconds;

agg.sep2.trial = metadata.trial;
agg.sep2.isSubTrial = metadata.isSubTrial;
agg.sep2.error = metadata.error;
agg.sep2.outOfBounds = metadata.outOfBounds;
agg.sep2.probe = metadata.probe;
agg.sep2.beeline = metadata.beeline;
agg.sep2.sugarConsumed = metadata.sugarConsumed ;
agg.sep2.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.sep2.trialStartAction = metadata.trialStartAction;
agg.sep2.ratPickupTeleport = metadata.ratPickupTeleport;
agg.sep2.restartmaze = metadata.restartmaze;
agg.sep2.restartTrial = metadata.restartTrial;
agg.sep2.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.sep2.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.sep2.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.sep2.swrEnvMedian = outp.swrEnvMedian;
agg.sep2.swrEnvMadam = outp.swrEnvMadam;
agg.sep2.swrThreshold = outp.swrThreshold;
agg.sep2.antiRadius = outp.antiRadius;
agg.sep2.rewardRadius = outp.rewardRadius;
agg.sep2.antiProxTimes = outp.antiProxTimes;
agg.sep2.rewardProxTimes = outp.rewardProxTimes;



%% checked
'/2016-09-06_training9_x2/'
metadata.day = '2016-09-06_training9_x2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII    IX     X    XI   XII  XIII   XIV    XV   
metadata.trial             = [   1    2    3     4     5     6     7     8     9    10    11    12    13    14    15  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.error             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1     1     1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  10  285  520   757   991  1231  1471  1690  1924  2154  2394  2637  2863  3112  3343  ];
metadata.trialStartAction  = [  47  312  551   786  1024  1262  1494  1719  1950  2179  2424  2657  2899  3135  3370  ];
metadata.sugarConsumeTimes = [  69  321  577   794  1032  1271  1510  1726  1959  2190  2434  2668  2906  3144  3383  ];
metadata.leaveMazeToBucket = [  71  323  580   798  1036  1274  1514  1732  1962  2195  2438  2669  2911  3149  3384  ];
metadata.ratPickupTeleport = [                                                                                        ];
metadata.restartmaze       = [                                                                                        ];
metadata.restartTrial      = [                                                                                        ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);
%
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
% 
agg.sep6.swrTimes=outp.swrPeakTimesDenoise;
agg.sep6.swrXpos = swrXpos;
agg.sep6.swrYpos = swrYpos;
agg.sep6.xpos = xpos;
agg.sep6.ypos = ypos;
agg.sep6.xytimestampSeconds = xytimestampSeconds;

agg.sep6.trial = metadata.trial;
agg.sep6.isSubTrial = metadata.isSubTrial;
agg.sep6.error = metadata.error;
agg.sep6.outOfBounds = metadata.outOfBounds;
agg.sep6.probe = metadata.probe;
agg.sep6.beeline = metadata.beeline;
agg.sep6.sugarConsumed = metadata.sugarConsumed ;
agg.sep6.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.sep6.trialStartAction = metadata.trialStartAction;
agg.sep6.ratPickupTeleport = metadata.ratPickupTeleport;
agg.sep6.restartmaze = metadata.restartmaze;
agg.sep6.restartTrial = metadata.restartTrial;
agg.sep6.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.sep6.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.sep6.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.sep6.swrEnvMedian = outp.swrEnvMedian;
agg.sep6.swrEnvMadam = outp.swrEnvMadam;
agg.sep6.swrThreshold = outp.swrThreshold;
agg.sep6.antiRadius = outp.antiRadius;
agg.sep6.rewardRadius = outp.rewardRadius;
agg.sep6.antiProxTimes = outp.antiProxTimes;
agg.sep6.rewardProxTimes = outp.rewardProxTimes;




'/2016-09-07_training10_x2/'
metadata.day = '2016-09-07_training10_x2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII    IX     X    XI   XII  XIII   XIV    XV   
metadata.trial             = [   1    2    3     4     5     6     7     8     9    10    11    12    13    14    15  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.error             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.probe             = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0     0     0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1     1     1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  20  253  492   743   989  1240  1476  1696  1942  2177  2419  2653  2893  3142  3370  ];
metadata.trialStartAction  = [  40  271  538   781  1016  1270  1501  1721  1970  2206  2445  2682  2929  3191  3402  ];
metadata.sugarConsumeTimes = [  51  279  545   793  1023  1285  1510  1730  1978  2214  2454  2689  2939  3199  3410  ];
metadata.leaveMazeToBucket = [  52  283  550   795  1027  1288  1512  1733  1981  2216  2458  2693  2941  3205  3413  ];
metadata.ratPickupTeleport = [                                                                                        ];
metadata.restartmaze       = [                                                                                        ];
metadata.restartTrial      = [                                                                                        ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
agg.sep7.swrTimes=outp.swrPeakTimesDenoise;
agg.sep7.swrXpos = swrXpos;
agg.sep7.swrYpos = swrYpos;
agg.sep7.xpos = xpos;
agg.sep7.ypos = ypos;
agg.sep7.xytimestampSeconds = xytimestampSeconds;

agg.sep7.trial = metadata.trial;
agg.sep7.isSubTrial = metadata.isSubTrial;
agg.sep7.error = metadata.error;
agg.sep7.outOfBounds = metadata.outOfBounds;
agg.sep7.probe = metadata.probe;
agg.sep7.beeline = metadata.beeline;
agg.sep7.sugarConsumed = metadata.sugarConsumed ;
agg.sep7.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.sep7.trialStartAction = metadata.trialStartAction;
agg.sep7.ratPickupTeleport = metadata.ratPickupTeleport;
agg.sep7.restartmaze = metadata.restartmaze;
agg.sep7.restartTrial = metadata.restartTrial;
agg.sep7.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.sep7.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.sep7.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.sep7.swrEnvMedian = outp.swrEnvMedian;
agg.sep7.swrEnvMadam = outp.swrEnvMadam;
agg.sep7.swrThreshold = outp.swrThreshold;
agg.sep7.antiRadius = outp.antiRadius;
agg.sep7.rewardRadius = outp.rewardRadius;
agg.sep7.antiProxTimes = outp.antiProxTimes;
agg.sep7.rewardProxTimes = outp.rewardProxTimes;




'/2016-09-08_probe3_training11/'
metadata.day = '2016-09-08_probe3_training11/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
metadata.autobins = false;
% TRIAL                          I   II  III    IV     V    VI   VII  VIII    IX     X    XI   XII     
metadata.trial             = [   1    2    3     4     5     6     7     8     9    10    11    12  ];
metadata.isSubTrial        = [   0    0    0     0     0     0     0     0     0     0     0     0  ];
metadata.error             = [   0    1    0     0     0     0     0     1     0     0     0     0  ];
metadata.outOfBounds       = [   0    0    0     0     0     0     0     0     0     0     0     1  ];
metadata.probe             = [   1    0    0     0     0     0     0     0     0     0     0     0  ];
metadata.beeline           = [   0    0    0     0     0     0     0     0     0     0     0     0  ];
metadata.sugarConsumed     = [   1    1    1     1     1     1     1     1     1     1     1     1  ];
metadata.leaveBucketToMaze = [  27  466  669   798   939  1092  1262  1385  1500  1571  1627  1681  ];
metadata.trialStartAction  = [  30  474  670   811   951  1112  1277  1392  1513  1578  1631  1687  ];
metadata.sugarConsumeTimes = [  48  536  678   821   958  1127  1287  1432  1523  1587  1640  1712  ];
metadata.leaveMazeToBucket = [  51  539  682   825   961  1130  1291  1435  1525  1591  1644  1736  ];
metadata.ratPickupTeleport = [                                                                      ];
metadata.restartmaze       = [                                                                      ];
metadata.restartTrial      = [                                                                      ];
metadata.chewRemovalEnabled = true;
outp=analyzeSWRda5(metadata);

[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(outp.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
% 
agg.sep8.swrTimes=outp.swrPeakTimesDenoise;
agg.sep8.swrXpos = swrXpos;
agg.sep8.swrYpos = swrYpos;
agg.sep8.xpos = xpos;
agg.sep8.ypos = ypos;
agg.sep8.xytimestampSeconds = xytimestampSeconds;

agg.sep8.trial = metadata.trial;
agg.sep8.isSubTrial = metadata.isSubTrial;
agg.sep8.error = metadata.error;
agg.sep8.outOfBounds = metadata.outOfBounds;
agg.sep8.probe = metadata.probe;
agg.sep8.beeline = metadata.beeline;
agg.sep8.sugarConsumed = metadata.sugarConsumed ;
agg.sep8.leaveBucketToMaze = metadata.leaveBucketToMaze;
agg.sep8.trialStartAction = metadata.trialStartAction;
agg.sep8.ratPickupTeleport = metadata.ratPickupTeleport;
agg.sep8.restartmaze = metadata.restartmaze;
agg.sep8.restartTrial = metadata.restartTrial;
agg.sep8.sugarConsumeTimes = metadata.sugarConsumeTimes;
agg.sep8.leaveMazeToBucket = metadata.leaveMazeToBucket;

agg.sep8.swrPeakValuesDenoise = outp.swrPeakValuesDenoise;
agg.sep8.swrEnvMedian = outp.swrEnvMedian;
agg.sep8.swrEnvMadam = outp.swrEnvMadam;
agg.sep8.swrThreshold = outp.swrThreshold;
agg.sep8.antiRadius = outp.antiRadius;
agg.sep8.rewardRadius = outp.rewardRadius;
agg.sep8.antiProxTimes = outp.antiProxTimes;
agg.sep8.rewardProxTimes = outp.rewardProxTimes;



return;





% 
% tt1  - CA  ; 0-1 units; low amp signal lfp
% tt2  - CA  ; >10 units; great lfp; swr due to layer
% tt3  - VTA ; 0 units?; low amp signal lfp, little events
% tt4  - VTA ; 0 units?; low amp signal lfp, little events
% tt5  - Nacc; 0 units?; broken?; flat LFP
% tt6  - Nacc; flat LFP
% tt7  - CA  ; units; strong LFP; SWR?
% tt8  - CA  ; units; medium LFP
% tt9  - VTA ; 0 units?; broken?
% tt10 - CA  ; 
% tt11 - CA  ; 
% tt12 - CA  ; very good Theta LFP
% tt13 - CA  ; 2-3 units; medium LFP action
% tt14 - Nacc; 2 units; uneventful LFP 
% tt15 - Nacc; 2 units; uneventful LFP
% tt16 - VTA ; x-connected; noisy, mainly uninteresting LFP
%
% [ 'CSC2.ncs'  'CSC6.ncs'  'CSC10.ncs'  'CSC14.ncs'  'CSC18.ncs'  'CSC26.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC46.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  ]
% SWR    'CSC26.ncs'   'CSC6.ncs'
% Theta  'CSC46.ncs'




% = ORDER OF POSSIBLE EVENTS DURING TRAINING =
% LeaveBucketToMaze
% StartTrial
% (ratPickupTeleport)    -- () indicates possible event(s), not gauranteed
% (restartMaze)
% (restartTrial)
% consumeSugar
% LeaveMazeToBucket





