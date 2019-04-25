clear agg metadata; 
%close all;

metadata.rat = 'da10';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
metadata.swrLfpFile = 'CSC88.ncs'; % 61 & 88 by summary stats;; 63, 88, HF; best visual guess unfiltered.   also try 44-47, 52-55 from vta  44 is vta
% theta on 61  best
% lia 61, then 88 consistent, although others are high
% nrem 61 & 88
metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.outputDir = [ '/Users/andrewhowe/data/plusMazeEphys/' metadata.rat '/' ];
metadata.sampleRate.lfp=32000;
metadata.sampleRate.telemetry=29.97;
metadata.autobins = true;
metadata.chewRemovalEnabled = false;
metadata.waypoints.center.x     =  317;
metadata.waypoints.center.y     =  236;
metadata.waypoints.start.x      =  117;
metadata.waypoints.start.y      =  415;
metadata.waypoints.reward.x     =  138;
metadata.waypoints.reward.y     =   57;
metadata.waypoints.antireward.x =  550;
metadata.waypoints.antireward.y =  450;
metadata.pxPerCm = sqrt( (metadata.waypoints.reward.x-metadata.waypoints.antireward.x)^2  + (metadata.waypoints.reward.y-metadata.waypoints.antireward.y)^2   )/210;





% metadata.day = 'da10_2017-09-11/bucket/';
% metadata.chewRemovalEnabled = false;
% metadata.autobins = false;
% metadata.touchdownTimes = [ 0 ];
% metadata.brickTimes =     [   ];
% metadata.sugarTimes =     [   ];
% metadata.liftoffTimes =   [   ];
% outp=analyzeSWR(metadata);



% probably should get rid of chews elimination
% metadata.day = 'da10_2017-09-11/explore/';
% metadata.chewRemovalEnabled = false;
% metadata.autobins = false;
% metadata.leaveBucketToMaze = [ 0 322 698 ];
% metadata.trialStartAction  = [ 346 776   ];
% metadata.sugarConsumeTimes = [           ];
% metadata.leaveMazeToBucket = [           ];
% outp=analyzeSWR(metadata);


% = ORDER OF POSSIBLE EVENTS DURING TRAINING =
% LeaveBucketToMaze
% StartTrial
% (ratPickupTeleport)    -- () indicates possible event(s), not gauranteed
% (restartMaze)
% (restartTrial)
% consumeSugar
% LeaveMazeToBucket




agg.sampleRate.lfp=32000;
agg.sampleRate.telemetry=29.97;
agg.waypoints.center.x     =  317;
agg.waypoints.center.y     =  236;
agg.waypoints.start.x      =  117;
agg.waypoints.start.y      =  415;
agg.waypoints.reward.x     =  138;
agg.waypoints.reward.y     =   57;
agg.waypoints.antireward.x =  550;
agg.waypoints.antireward.y =  450;
agg.pxPerCm = sqrt( (metadata.waypoints.reward.x-metadata.waypoints.antireward.x)^2  + (metadata.waypoints.reward.y-metadata.waypoints.antireward.y)^2   )/210;





load('/Users/andrewhowe//data/plusMazeEphys/da10/cache/da10_2017-09-11explore_output.mat');
metadata.day = 'da10_2017-09-11/explore/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xposOg, yposOg, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
yposOg(find(yposOg==119))=0; % this is cheating... but it works...
[ xpos, ypos ] = nlxPositionFixer( xposOg, yposOg );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
agg.sept11.swrTimes=output.swrPeakTimesDenoise;
agg.sept11.swrXpos = swrXpos;
agg.sept11.swrYpos = swrYpos;
agg.sept11.xpos = xpos;
agg.sept11.ypos = ypos;
agg.sept11.xytimestampSeconds = xytimestampSeconds;









result.swrCounts=[];
result.day=0;
result.dist=[];
result.trial=[];
result.trialTime=[];
result.error=[];
result.probe=[];
result.outOfBounds=[];
result.beeline=[];
result.absement=[];


% metadata.day = '2017-09-12_/training/';
% metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
% metadata.autobins = false;
% metadata.chewRemovalEnabled = true;
% % VT1_02.pmg
% % manually confirmed. times shifted 1 s back
% % TRIAL                          I  II  III            IV    V   VI  VII VIII    
% metadata.trial             = [   1   2    3             4    5    6    7    8      ];
% metadata.error             = [   1   0    1             1    1    1    1    1      ];
% metadata.outOfBounds       = [   1   0    1             1    0    1    1    1      ];
% metadata.probe             = [   0   0    0             0    0    0    0    0      ];
% metadata.beeline           = [   0   1    0             0    0    0    0    0      ]; 
% metadata.sugarConsumed     = [   1   1    1             1    1    1    1    0      ];
% metadata.leaveBucketToMaze = [  79 501  781          1416 2036 2518 3523 3995      ];
% metadata.trialStartAction  = [ 132 537  824          1464 2103 2570 3595 4033      ];
% metadata.ratPickupTeleport = [ 149      876 917 1019 1504           3624 4788      ];
% metadata.restartmaze       = [ 151      881 920 1024 1506           3626 4791 4842 ];
% metadata.restartTrial      = [ 157      901 945 1058 1529           3627 4793 4929 ];
% metadata.sugarConsumeTimes = [ 196 562 1080          1691 2174 3183 3665 4950          ];% 8 is false 4950  
% metadata.leaveMazeToBucket = [ 240 590 1116          1740 2206 3217 3697 4966      ];
% outp=analyzeSWR(metadata);
% load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-12_training_output.mat', 'output');
% swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
% yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
% xx = diff( swrAnalysisBins );
% dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
% [ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
% [ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
% xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end



load('/Users/andrewhowe//data/plusMazeEphys/da10/cache/da10_2017-09-12_training_output.mat');

metadata.day = '2017-09-12_/training/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xposOg, yposOg, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
yposOg(find(yposOg==119))=0; % this is cheating... but it works...
[ xpos, ypos ] = nlxPositionFixer( xposOg, yposOg );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
%figure; plot(xpos,ypos); hold on; scatter(swrXpos,swrYpos,'*');

% TRIAL                          I           II  III                     IV               V   VI  VII  VIII    
metadata.trial             = [   1 1.1 1.2    2    3  3.1 3.2  3.3  3.4   4   4.1  4.2    5    6    7     8  8.1  8.2  8.3 ];
metadata.isSubTrial        = [   0   1   1    0    0    1   1    1    1   0     1    1    0    0    0     0    1    1    1 ];
metadata.error             = [   1   0   1    0    1    0   0    0    0   1     0    1    1    1    0     1    1    0    0 ];
metadata.outOfBounds       = [   1   1   0    0    1    1   1    1    0   1     1    0    0    0    0     1    1    1  0.5 ];
metadata.probe             = [   0   0   0    0    0    0   0    0    0   0     0    0    0    0    0     0    0    0    0 ];
metadata.beeline           = [   0   0   0    1    0    0   0    0    1   0     0    0    0    0    0     0    0    0    0 ]; 
metadata.sugarConsumed     = [   1   0   1    1    1    0   0    0    1   1     0    1    1    1    1     0    0    0    0 ];
metadata.atTrialStart      = [  79  79 151  501  781  781 881  920 1024 1416 1416 1506 2036 2518 3523  3995 3995 4109 4792 ];
metadata.trialRunInitiated = [ 132 132 157  537  824  824 901  945 1058 1464 1416 1529 2103 2570 3595  4033 4033 4111 4795 ];
metadata.trialCompleted    = [ 196 151 196  562 1080  876 917 1019 1080 1691 1504 1691 2174 3183 3665  4950 4788 4789 4966 ];
metadata.leaveMazeToBucket = [ 240          590 1116                    1740           2206 3217 3697  4966                ];


agg.sept12.swrTimes=output.swrPeakTimesDenoise;
agg.sept12.swrXpos = swrXpos;
agg.sept12.swrYpos = swrYpos;
agg.sept12.xpos = xpos;
agg.sept12.ypos = ypos;
agg.sept12.xytimestampSeconds = xytimestampSeconds;




metadata.day = '2017-09-13_/training/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
% automation result confirmed to be good
% TRIAL                         I   II  III    IV     V    VI   VII  VIII    IX  
metadata.trial             = [  1    2    3     4     5     6     7     8     9 ];
metadata.isSubTrial        = [  0    0    0     0     0     0     0     0     0 ];
metadata.error             = [  0    1    0     0     0     1     0     0     0 ];
metadata.outOfBounds       = [  0    1    0     1     0     0     0     1     1 ];
metadata.probe             = [  0    0    0     0     0     0     0     0     0 ];
metadata.beeline           = [  1    0    1     0     1     0     1     0     1 ];
metadata.sugarConsumed     = [  1    1    1     1     1     1     1     1     1 ];
metadata.leaveBucketToMaze = [ 48  323  809  1134  1613  1923  2350  2650  3035 ];
metadata.trialStartAction  = [ 77  410  848  1221  1676  2008  2389  2697  3073 ];
metadata.ratPickupTeleport = [     423       1290                    2743       ];
metadata.restartmaze       = [     425       1295                    2746       ];
metadata.restartTrial      = [     437       1306                    2773       ];
metadata.sugarConsumeTimes = [ 92  525  863  1334  1692  2058  2406  2783  3108 ];
metadata.leaveMazeToBucket = [ 114 554  893  1364  1723  2084  2433  2810  3133 ];
% FOR da10 2017-09-13, SKIP THE INTRODUCTION
outp=analyzeSWR(metadata); 
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-13_training_CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end

agg.sept13.swrTimes=output.swrPeakTimesDenoise;
agg.sept13.swrXpos = swrXpos;
agg.sept13.swrYpos = swrYpos;
agg.sept13.xpos = xpos;
agg.sept13.ypos = ypos;
agg.sept13.xytimestampSeconds = xytimestampSeconds;



metadata.day = '2017-09-14_/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% TRIAL                          I   II  III    IV    V    VI   VII               VIII                
metadata.trial             = [  1    2    3     4     5     6     7                  8       ];
metadata.error             = [  1    0    1     0     0     0     0                  0       ];            
metadata.probe             = [  0    0    0     0     0     0     0                  0       ];            
metadata.outOfBounds       = [  1    1    0     0     1     0     0                  1       ];            
metadata.beeline           = [  0    0    0     0     0     1     0                  0       ];          
metadata.leaveBucketToMaze = [  45  395  666   968  1282  1636  1894              2489       ];
metadata.trialStartAction  = [  77  410  707  1005  1302  1689  1939              2556       ];
metadata.ratPickupTeleport = [ 134  435                               2171  2199  2587  2624 ];
metadata.restartmaze       = [ 136  438       1043              2044  2176  2203  2592  2628 ]; 
metadata.restartTrial      = [ 163  449       1067              2075        2212  2604  2638 ];
metadata.sugarConsumeTimes = [ 177  462  750  1083  1392  1702  2223              2648       ];
metadata.leaveMazeToBucket = [ 205  493  779  1110  1417  1727  2251              2674       ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-14__CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% 
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end

agg.sept14.swrTimes=output.swrPeakTimesDenoise;
agg.sept14.swrXpos = swrXpos;
agg.sept14.swrYpos = swrYpos;
agg.sept14.xpos = xpos;
agg.sept14.ypos = ypos;
agg.sept14.xytimestampSeconds = xytimestampSeconds;



metadata.day = '2017-09-15_/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% TRIAL                          I   II  III   IV     V    VI   VII  VIII    IX
metadata.trial             = [  1    2    3     4     5     6     7     8     9 ];
metadata.error             = [  0    0    0     0     0     0     1     0     0 ];
metadata.outOfBounds       = [  0    0    0     0     0     0     1     0     0 ];
metadata.probe             = [  0    0    0     0     0     0     0     0     0 ];
metadata.beeline           = [  1    1    1     1     1     1     0     1     1 ];
metadata.leaveBucketToMaze = [  17  338  620  875  1146  1418  1712  2120  2378 ];
metadata.trialStartAction  = [  64  377  645  916  1184  1464  1780  2161  2459 ];
metadata.ratPickupTeleport = [                                 1799             ];
metadata.restartmaze       = [                                 1802             ];
metadata.restartTrial      = [                                 1813             ];
metadata.sugarConsumeTimes = [  80  393  664  934  1195  1473  1865  2177  2469 ];
metadata.leaveMazeToBucket = [ 108  420  688  957  1218  1499  1885  2199  2493 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-15__CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day  ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);

% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end

agg.sept15.swrTimes=output.swrPeakTimesDenoise;
agg.sept15.swrXpos = swrXpos;
agg.sept15.swrYpos = swrYpos;
agg.sept15.xpos = xpos;
agg.sept15.ypos = ypos;
agg.sept15.xytimestampSeconds = xytimestampSeconds;


% some wierd stuff happens
metadata.day = '2017-09-18_/training1/';
metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
% TRIAL                          I   II  III    IV 
metadata.trial             = [   1    2    3     4 ];
metadata.error             = [   0    0    0     0 ];
metadata.outOfBounds       = [   0    0    0     0 ];
metadata.probe             = [   0    0    0     0 ];
metadata.beeline           = [   1    1    1     1 ];
metadata.leaveBucketToMaze = [ 251  517  752  1027 ];
metadata.trialStartAction  = [ 271  547  783  1060 ];
metadata.ratPickupTeleport = [                     ];
metadata.restartmaze       = [                     ];
metadata.restartTrial      = [                     ];
metadata.sugarConsumeTimes = [ 283  558  794  1072 ];
metadata.leaveMazeToBucket = [ 309  580  817  1106 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-18_training1_CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day  ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end


agg.sept18.swrTimes=output.swrPeakTimesDenoise;
agg.sept18.swrXpos = swrXpos;
agg.sept18.swrYpos = swrYpos;
agg.sept18.xpos = xpos;
agg.sept18.ypos = ypos;
agg.sept18.xytimestampSeconds = xytimestampSeconds;


metadata.day = '2017-09-18_/training2/';
metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
% TRIAL                          V   VI  
metadata.trial             = [   5    6 ];
metadata.error             = [   0    1 ];
metadata.outOfBounds       = [   0    1 ];
metadata.probe             = [   0    0 ];
metadata.beeline           = [   1    0 ];
metadata.leaveBucketToMaze = [ 249  499 ];
metadata.trialStartAction  = [ 291  530 ];
metadata.ratPickupTeleport = [          ];
metadata.restartmaze       = [      587 ];
metadata.restartTrial      = [      613 ];
metadata.sugarConsumeTimes = [ 299  623 ];
metadata.leaveMazeToBucket = [ 325  644 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-18_training2_CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));


agg.sept18.swrTimes = [ agg.sept18.swrTimes; output.swrPeakTimesDenoise+agg.sept18.xytimestampSeconds(end) ];
agg.sept18.swrXpos  = [ agg.sept18.swrXpos; swrXpos ];
agg.sept18.swrYpos  = [ agg.sept18.swrYpos; swrYpos ];
agg.sept18.xpos     = [ agg.sept18.xpos; xpos ];
agg.sept18.ypos     = [ agg.sept18.ypos; ypos ];
agg.sept18.xytimestampSeconds = [ agg.sept18.xytimestampSeconds; xytimestampSeconds+agg.sept18.xytimestampSeconds(end) ];



% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end





metadata.day = '2017-09-18_/training3/';
metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
% TRIAL                        VII VIII        IX     
metadata.trial             = [   7    8         9 ];
metadata.error             = [   0    1       0.5 ];
metadata.outOfBounds       = [   1    0         0 ];
metadata.probe             = [   0    0         0 ];
metadata.beeline           = [   1    0         0 ];
metadata.leaveBucketToMaze = [ 110  388       841 ];
metadata.trialStartAction  = [ 164  413       874 ];
metadata.ratPickupTeleport = [                    ];
metadata.restartmaze       = [      435  529  895 ];
metadata.restartTrial      = [      483  547  933 ];
metadata.sugarConsumeTimes = [ 172  555       941 ];
metadata.leaveMazeToBucket = [ 196  582       962 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-18_training3_CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));
swrYpos = ypos(round(output.swrPeakTimesDenoise*agg.sampleRate.telemetry));

agg.sept18.swrTimes = [ agg.sept18.swrTimes; output.swrPeakTimesDenoise+agg.sept18.xytimestampSeconds(end) ];
agg.sept18.swrXpos  = [ agg.sept18.swrXpos; swrXpos ];
agg.sept18.swrYpos  = [ agg.sept18.swrYpos; swrYpos ];
agg.sept18.xpos     = [ agg.sept18.xpos; xpos ];
agg.sept18.ypos     = [ agg.sept18.ypos; ypos ];
agg.sept18.xytimestampSeconds = [ agg.sept18.xytimestampSeconds; xytimestampSeconds+agg.sept18.xytimestampSeconds(end) ];


% 
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end


metadata.day = '2017-09-19_/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% TRIAL                          I   II  III   IV     V    VI   VII       VIII   
metadata.trial             = [   1    2    3    4     5     6     7          8 ];
metadata.error             = [   0    1    0    0     0     1     1          0 ];
metadata.outOfBounds       = [   0    0    0    0     0     1     1          0 ];
metadata.probe             = [   0    0    0    0     0     0     0          0 ];
metadata.beeline           = [   1    0    1    1     1     0     0          1 ];
metadata.leaveBucketToMaze = [  50  113  510  723   967  1218  1584       1995 ];
metadata.trialStartAction  = [  76  278  543  764  1001  1254  1615       2039 ];
metadata.ratPickupTeleport = [                                 1684  1748      ];
metadata.restartmaze       = [                           1267  1688  1754      ];
metadata.restartTrial      = [                           1732  1728  1771      ];
metadata.sugarConsumeTimes = [  84  323  549  770  1008  1367  1779       2044 ];
metadata.leaveMazeToBucket = [ 104  354  571  799  1034  1395  1801       2068 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-19__CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);

agg.sept19.swrTimes=output.swrPeakTimesDenoise;
agg.sept19.swrXpos = swrXpos;
agg.sept19.swrYpos = swrYpos;
agg.sept19.xpos = xpos;
agg.sept19.ypos = ypos;
agg.sept19.xytimestampSeconds = xytimestampSeconds;



% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end

% % ***this gets all screwed up because there's no actual reward given in the
% % probe.
% metadata.day = '2017-09-20_/probe/';
% metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
% metadata.autobins = false;
% metadata.chewRemovalEnabled = true;
% metadata.leaveBucketToMaze = [ 148 ];
% metadata.trialStartAction  = [ 177 ];
% metadata.sugarConsumeTimes = [     ];
% metadata.leaveMazeToBucket = [ 199 ];
% outp=analyzeSWR(metadata);
% load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-20_probe_CSC88_output.mat');
% swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
% yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
% xx = diff( swrAnalysisBins );
% dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
% [ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
% [ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
% xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
% end


metadata.day = '2017-09-20_/train/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;  % mostly autogenerated, with manual double check
metadata.chewRemovalEnabled = true;
% TRIAL                           II  III   IV     V    VI   VII  VIII    % I 
metadata.trial             = [     2    3    4     5     6     7     8 ]; % 1 
metadata.error             = [     0    1    0     0     0     0     1 ]; % 0 
metadata.outOfBounds       = [     0    1    0     0     0     0     0 ]; % 0 
metadata.probe             = [     0    0    0     0     0     0     0 ]; % 0 
metadata.beeline           = [     1    0    0     1     1     1     0 ]; % 0 
metadata.leaveBucketToMaze = [   193  416  668  1084  1359  1722  2149 ]; % 
metadata.trialStartAction  = [   229  436  697  1116  1403  1740  2196 ]; % 
metadata.ratPickupTeleport = [                                         ]; % 
metadata.restartmaze       = [                                         ]; % 
metadata.restartTrial      = [                                         ]; % 
metadata.sugarConsumeTimes = [   240  451  833  1127  1418  1756  2213 ]; % 
metadata.leaveMazeToBucket = [   263  472  857  1150  1442  1779  2232 ]; % 50 
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-20_train_CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);

agg.sept20.swrTimes=output.swrPeakTimesDenoise;
agg.sept20.swrXpos = swrXpos;
agg.sept20.swrYpos = swrYpos;
agg.sept20.xpos = xpos;
agg.sept20.ypos = ypos;
agg.sept20.xytimestampSeconds = xytimestampSeconds;

% 
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end


metadata.day = '2017-09-22_/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false; % mostly autogenerated, but the sandwhich of probe trials messed up the detector start and finish
metadata.chewRemovalEnabled = true;
% TRIAL                          I  II III  IV    V   VI  VII VIII   IX  
metadata.trial             = [   1   2   3   4    5    6    7    8    9 ];
metadata.error             = [   0   0   1   0    0    0    0    1    1 ];
metadata.outOfBounds       = [   0   0   0   0    1    1    1    1    0 ];
metadata.probe             = [   1   0   0   0    0    0    0    0    1 ];
metadata.beeline           = [   0   1   0   1    0    0    0    0    0 ];
metadata.leaveBucketToMaze = [ 139 356 570 855 1113 1427 1908 2046 2753 ];
metadata.trialStartAction  = [ 180 389 615 887 1143 1563 1982 2115 2787 ];
metadata.ratPickupTeleport = [                      1593                ];
metadata.restartmaze       = [                      1597 2046           ];
metadata.restartTrial      = [                      1633 2115           ];
metadata.sugarConsumeTimes = [ 190    405 671 901 1207 1693 2128 2477  2815    ];   % false I & IX 
metadata.leaveMazeToBucket = [ 194 424 694 916 1240 1719 2150 2499 2821 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-22__CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
%
agg.sept22.swrTimes=output.swrPeakTimesDenoise;
agg.sept22.swrXpos = swrXpos;
agg.sept22.swrYpos = swrYpos;
agg.sept22.xpos = xpos;
agg.sept22.ypos = ypos;
agg.sept22.xytimestampSeconds = xytimestampSeconds;



% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end


metadata.day = '2017-09-25_/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% TRIAL                        I  II III   IV    V   VI  VII VIII   IX    X  
metadata.trial             = [ 1   2   3    4    5    6    7    8    9   10   ];
metadata.error             = [ 0   0   0    0    0    0    0    0    0    0   ];
metadata.outOfBounds       = [ 0   0   0    1    1    0    0    0    0    0   ];
metadata.probe             = [ 1   0   0    0    0    0    0    0    0    1   ];
metadata.beeline           = [ 0   1   1    0    1    1    1    1    1    0   ];
metadata.leaveBucketToMaze = [ 392 558 853 1064 1340 1551 1789 1993 2231 2608 ];
metadata.trialStartAction  = [ 416 605 891 1092 1367 1585 1818 2019 2258 2631 ];
metadata.ratPickupTeleport = [                                                ];
metadata.restartmaze       = [                                                ];
metadata.restartTrial      = [                                                ];
metadata.sugarConsumeTimes = [ 422    615 909 1131 1384 1598 1827 2032 2269  2650    ]; % false I & X 
metadata.leaveMazeToBucket = [ 427 643 933 1157 1412 1618 1854 2057 2291 2655 ];
outp=analyzeSWR(metadata);
load('/Users/andrewhowe/data/plusMazeEphys/da10/da10_2017-09-25__CSC88_output.mat');
swrAnalysisBins = sort([ 0 metadata.leaveBucketToMaze metadata.trialStartAction metadata.sugarConsumeTimes metadata.leaveMazeToBucket 4e3 ]);
yy = histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );  %./diff(swrAnalysisBins);
xx = diff( swrAnalysisBins );
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
swrXpos = xpos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);
swrYpos = ypos(floor(output.swrPeakTimesDenoise*agg.sampleRate.telemetry)+1);




agg.sept25.swrTimes=output.swrPeakTimesDenoise;
agg.sept25.swrXpos = swrXpos;
agg.sept25.swrYpos = swrYpos;
agg.sept25.xpos = xpos;
agg.sept25.ypos = ypos;
agg.sept25.xytimestampSeconds = xytimestampSeconds;
















% TRIAL                            I   
agg.sept11.trial             = [   1  ];
agg.sept11.isSubTrial        = [   0  ];
agg.sept11.error             = [   0  ];
agg.sept11.outOfBounds       = [   1  ];
agg.sept11.probe             = [   0  ];
agg.sept11.beeline           = [   0  ];
agg.sept11.sugarConsumed     = [   0  ];
agg.sept11.wasTeleported     = [   0  ];
agg.sept11.leaveBucketToMaze = [   1 ];
agg.sept11.trialStartAction  = [   2 ];
agg.sept11.trialCompleted    = [ 16*60+40  ];
agg.sept11.leaveMazeToBucket = [ 16*60+42  ];


metadata.day = '2017-09-12_/training/';
% TRIAL                            I   II  III    IV     V    VI    VII  VIII    
agg.sept12.trial             = [   1    2    3     4     5     6      7     8 ];
agg.sept12.isSubTrial        = [   0    0    0     0     0     0      0     0 ];
agg.sept12.error             = [   1    0    1     1     1     1      0     1 ];
agg.sept12.outOfBounds       = [   1    0    1     1     0     0      0     1 ];
agg.sept12.probe             = [   0    0    0     0     0     0      0     0 ];
agg.sept12.beeline           = [   0    1    0     0     0     0      0     0 ]; 
agg.sept12.sugarConsumed     = [   1    1    1     1     1     1      1     0 ];
agg.sept12.wasTeleported     = [   1    0    1     1     0     0      0     1 ];
agg.sept12.leaveBucketToMaze = [  79  501  781  1416  2036  2518   3523  3995 ];  % atTrialStart 
agg.sept12.trialStartAction  = [ 156  539  826  1500  2063  2574   3596  4020 ];  % trialRunInitiated   535 starts moving for trial 2      %   132         535         824        1464        2103        2570        3595        4033
agg.sept12.trialCompleted    = [ 196  562 1080  1691  2174  3183   3665  4950 ];  % trialCompleted 
agg.sept12.leaveMazeToBucket = [ 240  590 1116  1740  2206  3217   3697  4966 ];  % leaveMazeToBucket 


metadata.day = '2017-09-13_/training/';
% TRIAL                            I   II  III    IV     V    VI   VII  VIII    IX  
agg.sept13.trial             = [   1    2    3     4     5     6     7     8     9 ];
agg.sept13.isSubTrial        = [   0    0    0     0     0     0     0     0     0 ];
agg.sept13.error             = [   0    1    0     0     0     1     0     0     0 ];
agg.sept13.outOfBounds       = [   0    1    0     1     0     0     0     1     1 ];
agg.sept13.probe             = [   0    0    0     0     0     0     0     0     0 ];
agg.sept13.beeline           = [   1    0    1     0     1     0     1     0     1 ];
agg.sept13.sugarConsumed     = [   1    1    1     1     1     1     1     1     1 ];
agg.sept13.wasTeleported     = [   0    1    0     1     0     0     0     1     0 ];
agg.sept13.leaveBucketToMaze = [  48  323  809  1134  1613  1923  2350  2650  3035 ];
agg.sept13.trialStartAction  = [  73  375  829  1193  1670  1955  2381  2722  3068 ]; % (for the last trial, was 3071
agg.sept13.trialCompleted    = [  92  525  863  1334  1692  2058  2406  2783  3108 ];
agg.sept13.leaveMazeToBucket = [ 114  554  893  1364  1723  2084  2433  2810  3133 ];


metadata.day = '2017-09-14_/';
% TRIAL                            I   II  III    IV     V    VI   VII  VIII                
agg.sept14.trial             = [   1    2    3     4     5     6     7     8  ];
agg.sept14.isSubTrial        = [   0    0    0     0     0     0     0     0  ];            
agg.sept14.error             = [   1    0    1     0     0     0     1     0  ];            
agg.sept14.probe             = [   0    0    0     0     0     0     0     0  ];            
agg.sept14.outOfBounds       = [   1    1    0     0     0     0     1     1  ];            
agg.sept14.beeline           = [   0    0    0     0     0     1     0     0  ];          
agg.sept14.sugarConsumed     = [   1    1    1     1     1     1     1     1  ];          
agg.sept14.wasTeleported     = [   1    1    0     0     0     0     1     1  ];          
agg.sept14.leaveBucketToMaze = [  45  392  666   968  1282  1636  1894  2489  ];
agg.sept14.trialStartAction  = [  74  433  698   993  1300  1664  1929  2550  ];
agg.sept14.trialCompleted    = [ 177  462  750  1083  1392  1702  2223  2648  ];
agg.sept14.leaveMazeToBucket = [ 205  493  779  1110  1417  1727  2251  2674  ];


metadata.day = '2017-09-15_/';
% TRIAL                            I   II  III   IV     V    VI   VII  VIII    IX
agg.sept15.trial             = [   1    2    3    4     5     6     7     8     9 ];

agg.sept15.error             = [   0    0    0    0     0     0     1     0     0 ];
agg.sept15.outOfBounds       = [   0    0    0    0     0     0     1     0     0 ];
agg.sept15.wasTeleported     = [   0    0    0    0     0     0     1     0     0 ];

agg.sept15.isSubTrial        = [   0    0    0    0     0     0     0     0     0 ];
agg.sept15.probe             = [   0    0    0    0     0     0     0     0     0 ];
agg.sept15.beeline           = [   1    1    1    1     1     1     0     1     1 ];
agg.sept15.sugarConsumed     = [   1    1    1    1     1     1     1     1     1 ];
agg.sept15.leaveBucketToMaze = [  17  338  620  875  1146  1418  1712  2120  2378 ];
agg.sept15.trialStartAction  = [  42  369  639  898  1168  1439  1774  2155  2443 ];
agg.sept15.trialCompleted    = [  80  393  664  934  1195  1473  1865  2177  2469 ];
agg.sept15.leaveMazeToBucket = [ 108  420  688  957  1218  1499  1885  2199  2493 ];


% some wierd stuff happens
metadata.day = '2017-09-18_/';
adjA = 1124.629369;
adjB = 1124.629369 + 705.808058;
% TRIAL                            I   II  III    IV         V        VI       VII      VIII        IX   % TRIAL 
agg.sept18.trial             = [   1    2    3     4         5         6         7         8         9 ]; % isSubTrial 
agg.sept18.isSubTrial        = [   0    0    0     0         0         0         0         0         0 ]; % error 
agg.sept18.error             = [   0    0    0     0         0         1         0         1         0 ]; % outOfBound 
agg.sept18.probe             = [   0    0    0     0         0         0         0         0         0 ]; % probe
agg.sept18.outOfBounds       = [   0    0    0     0         0         1         1         1         1 ]; % probe 
agg.sept18.beeline           = [   1    1    1     1         1         0         1         0         0 ]; % beeline
agg.sept18.sugarConsumed     = [   1    1    1     1         1         1         1         1         1 ]; % sugarConsumed
agg.sept18.wasTeleported     = [   0    0    0     0         0         0         0         1         1 ]; % wasTeleported
agg.sept18.leaveBucketToMaze = [ 251  517  752  1027  249+adjA  499+adjA  110+adjB  388+adjB  841+adjB ];
agg.sept18.trialStartAction  = [ 260  543  779  1055      1406     1650      1991      2239      2698 ]; % 289+adjA  530+adjA  162+adjB  413+adjB  874+adjB ];
agg.sept18.trialCompleted    = [ 283  558  794  1072  299+adjA  623+adjA  172+adjB  555+adjB  941+adjB ];
agg.sept18.leaveMazeToBucket = [ 309  580  817  1106  325+adjA  644+adjA  196+adjB  582+adjB  962+adjB ];


metadata.day = '2017-09-19_/';
% TRIAL                            I   II  III   IV     V    VI   VII  VIII   
agg.sept19.trial             = [   1    2    3    4     5     6     7     8 ];
agg.sept19.isSubTrial        = [   0    0    0    0     0     0     0     0 ];
agg.sept19.error             = [   0    1    0    0     0     1     1     0 ];
agg.sept19.probe             = [   0    0    0    0     0     0     0     0 ];
agg.sept19.outOfBounds       = [   0    0    0    0     0     1     1     0 ];
agg.sept19.beeline           = [   1    0    1    1     1     0     0     1 ];
agg.sept19.sugarConsumed     = [   1    1    1    1     1     1     1     1 ];
agg.sept19.wasTeleported     = [   0    0    0    0     0     1     1     0 ];
agg.sept19.leaveBucketToMaze = [  50  113  510  723   967  1218  1584  1995 ];
agg.sept19.trialStartAction  = [  71  268  538  757   997  1249  1611  2032 ];
agg.sept19.trialCompleted    = [  84  323  549  770  1008  1367  1779  2044 ];
agg.sept19.leaveMazeToBucket = [ 104  354  571  799  1034  1395  1801  2068 ];


metadata.day = '2017-09-20_';
% TRIAL                             II  III   IV     V    VI   VII  VIII    % I 
agg.sept20.trial             = [     2    3    4     5     6     7     8 ]; % 1 
agg.sept20.isSubTrial        = [     0    0    0     0     0     0     0 ]; % 0 
agg.sept20.error             = [     0    0    1     0     0     0     0 ]; % 0 
agg.sept20.probe             = [     0    0    0     0     0     0     0 ]; % 0 
agg.sept20.outOfBounds       = [     0    0    0     0     0     0     0 ]; % 0 
agg.sept20.beeline           = [     1    1    0     1     1     1     1 ]; % 0 
agg.sept20.sugarConsumed     = [     1    1    1     1     1     1     1 ]; % 0 
agg.sept20.wasTeleported     = [     0    0    0     0     0     0     0 ]; % 0 
agg.sept20.leaveBucketToMaze = [   193  416  668  1084  1359  1722  2149 ]; % 
agg.sept20.trialStartAction  = [   225  430  691  1112  1396  1735  2188 ]; % 
agg.sept20.trialCompleted    = [   240  451  833  1127  1418  1756  2213 ]; % 
agg.sept20.leaveMazeToBucket = [   263  472  857  1150  1442  1779  2232 ]; % 50 


metadata.day = '2017-09-22_/';
% TRIAL                            I  II III  IV    V   VI  VII VIII   IX  
agg.sept22.trial             = [   1   2   3   4    5    6    7    8    9 ];
agg.sept22.isSubTrial        = [   0   0   0   0    0    0    0    0    0 ];
agg.sept22.error             = [   0   0   1   0    0    0    0    1    1 ];
agg.sept22.probe             = [   1   0   0   0    0    0    0    0    1 ];
agg.sept22.outOfBounds       = [   0   0   0   0    0    1    0    0    0 ];
agg.sept22.beeline           = [   0   1   0   1    0    0    0    0    0 ];
agg.sept22.sugarConsumed     = [   0   1   1   1    1    1    1    1    0 ];
agg.sept22.wasTeleported     = [   0   0   0   0    0    1    0    0    0 ];
agg.sept22.leaveBucketToMaze = [ 139 356 570 855 1113 1427 1908 2046 2753 ];
agg.sept22.trialStartAction  = [ 158 379 608 878 1133 1550 1973 2111 2770 ];
agg.sept22.trialCompleted    = [ 190 405 671 901 1207 1693 2128 2477 2815 ];
agg.sept22.leaveMazeToBucket = [ 194 424 694 916 1240 1719 2150 2499 2821 ];


metadata.day = '2017-09-25_/';
% TRIAL                            I  II III   IV    V   VI  VII VIII   IX    X  
agg.sept25.trial             = [   1   2   3    4    5    6    7    8    9   10  ];
agg.sept25.isSubTrial        = [   0   0   0    0    0    0    0    0    0    0  ];
agg.sept25.error             = [   0   0   0    1    0    0    0    0    0    0  ];
agg.sept25.probe             = [   1   0   0    0    0    0    0    0    0    1  ];
agg.sept25.outOfBounds       = [   0   0   0    0    0    0    0    0    0    0  ];
agg.sept25.beeline           = [   0   1   1    0    1    1    1    1    1    0  ];
agg.sept25.sugarConsumed     = [   0   1   1    1    1    1    1    1    1    0  ];
agg.sept25.wasTeleported     = [   0   0   0    0    0    0    0    0    0    0  ];
agg.sept25.leaveBucketToMaze = [ 392 558 853 1064 1340 1551 1789 1993 2231 2608  ];
agg.sept25.trialStartAction  = [ 411 599 874 1086 1362 1577 1808 2017 2254 2626  ];
agg.sept25.trialCompleted    = [ 422 615 909 1131 1384 1598 1827 2032 2269 2650  ];  
agg.sept25.leaveMazeToBucket = [ 427 643 933 1157 1412 1618 1854 2057 2291 2655  ];


% 
% recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
% 
% for ii=1:length(recDays)
%     for jj=1:length(agg.(recDays{ii}).trial)
% 
% for ii = 1:length(recDays
%     agg.(recDays{}).trialStartAction





% 
% result.day=result.day+1;
% result.error=[ result.error metadata.error ];
% result.probe=[ result.probe metadata.probe ];
% result.outOfBounds=[ result.outOfBounds metadata.outOfBounds ];
% result.beeline=[ result.beeline metadata.beeline ];
% for ii=1:length(metadata.trial)
%     result.dist=[ result.dist distanceTraveled( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) )];
%     [vv,ww]=find( swrAnalysisBins == metadata.trialStartAction(ii));
%     result.swrCounts = [ result.swrCounts yy(ww) ];
%     result.trial = [ result.trial result.day+(metadata.trial/10) ];
%     result.trialTime = [ result.trialTime xx(ww) ];
%     result.absement = [ result.absement absement( xpos, ypos, metadata.trialStartAction(ii), metadata.sugarConsumeTimes(ii) , metadata.waypoints.reward.x, metadata.waypoints.reward.y, metadata.pxPerCm) ];
% end


% 
% result.dist = result.dist./metadata.pxPerCm;
% 
% 
% 
% figure; 
% subplot(2,2,1); hold on;
% scatter( result.swrCounts(find(result.outOfBounds)), result.dist(find(result.outOfBounds)), '^', 'filled' ); 
% scatter( result.swrCounts, result.dist, 'o'  );
% scatter( result.swrCounts(find(result.beeline)), result.dist(find(result.beeline)), '*' ); 
% subplot(2,2,2); hold on;
% scatter( result.trialTime(find(result.outOfBounds)), result.dist(find(result.outOfBounds)), '^', 'filled' ); 
% scatter( result.trialTime, result.dist, 'o'  );
% scatter( result.trialTime(find(result.beeline)), result.dist(find(result.beeline)), '*' ); 
% subplot(2,2,3); hold on;
% scatter( result.trialTime(find(result.outOfBounds)), result.swrCounts(find(result.outOfBounds)), '^', 'filled' ); 
% scatter( result.trialTime, result.swrCounts, 'o'  );
% scatter( result.trialTime(find(result.beeline)), result.swrCounts(find(result.beeline)), '*' ); 
% subplot(2,2,4); hold on;
% scatter( result.trialTime(find(result.outOfBounds)), result.swrCounts(find(result.outOfBounds)), '^', 'filled' ); 
% scatter( result.trialTime, result.swrCounts, 'o' ); 
% scatter( result.trialTime(find(result.error)), result.swrCounts(find(result.error)), '*' ); 
% 
% 
% figure;
% subplot(2,2,1); scatter( result.absement, result.swrCounts, 'o', 'filled', 'k' ); hold on; xlabel('absement (m*s)'); ylabel('swr during run (events)');title('all');
% subplot(2,2,2); scatter( result.absement(find(result.outOfBounds)), result.swrCounts(find(result.outOfBounds)), '^', 'filled', 'b' ); xlabel('absement (m*s)'); ylabel('swr during run (events)');title('out of bounds');
% subplot(2,2,3); scatter( result.absement(find(result.error)), result.swrCounts(find(result.error)), '*', 'r' ); xlabel('absement (m*s)'); ylabel('swr during run (events)');title('error');
% subplot(2,2,4); scatter( result.absement(find(result.beeline)), result.swrCounts(find(result.beeline)), 'filled', 'v', 'g' ); xlabel('absement (m*s)'); ylabel('swr during run (events)');title('beeline'); 
% 
% 
% 
% 
% legend('all','out of bounds', 'error', 'beeline'); 

