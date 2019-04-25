clear all; 
close all;

metadata.rat = 'da10';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
metadata.swrLfpFile = 'CSC88.ncs'; % 63, 88, HF; best visual guess unfiltered.   also try 44-47, 52-55 from vta  44 is vta
metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.outputDir = [ '/Users/andrewhowe/data/plusMazeEphys/' metadata.rat '/' ];
metadata.sampleRate.lfp=32000;
metadata.sampleRate.telemetry=29.97;
metadata.autobins = true;
metadata.chewRemovalEnabled = false;
metadata.waypoints.center.x     =  317;
metadata.waypoints.center.y     =  229;
metadata.waypoints.start.x      =   81;
metadata.waypoints.start.y      =  412;
metadata.waypoints.reward.x     =  119;
metadata.waypoints.reward.y     =   45;
metadata.waypoints.antireward.x =  525;
metadata.waypoints.antireward.y =  429;



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





metadata.day = '2017-09-12_/training/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% VT1_02.pmg
% manually confirmed. times shifted 1 s back
% TRIAL                          I  II  III            IV    V   VI  VII VIII    
metadata.trial             = [   1   2    3             4    5    6    7    8      ];
metadata.error             = [   1   0    1             1    1    1    1    1      ];
metadata.outOfBounds       = [   1   0    1             1    0    1    1    1      ];
metadata.probe             = [   0   0    0             0    0    0    0    0      ];
metadata.beeline           = [   0   1    0             0    0    0    0    0      ]; 
metadata.leaveBucketToMaze = [  79 501  781          1416 2036 2518 3523 3995      ];
metadata.trialStartAction  = [ 132 537  824          1464 2103 2570 3595 4033      ];
metadata.ratPickupTeleport = [ 149      876 917 1019 1504           3624 4788      ];
metadata.restartmaze       = [ 151      881 920 1024 1506           3626 4791 4842 ];
metadata.restartTrial      = [ 157      901 945 1058 1529           3627 4793 4929 ];
metadata.sugarConsumeTimes = [ 196 562 1080          1691 2174 3183 3665           ];
metadata.leaveMazeToBucket = [ 240 590 1116          1740 2206 3217 3697 4966      ];
outp=analyzeSWR(metadata);



metadata.day = '2017-09-13_/training/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
% automation result confirmed to be good
% TRIAL                         I   II  III    IV     V    VI   VII  VIII    IX  
metadata.trial             = [  1    2    3     4     5     6     7     8     9 ];
metadata.error             = [  0    1    0     0     0     1     0     0     0 ];
metadata.outOfBounds       = [  0    1    0     1     0     0     0     1     1 ];
metadata.probe             = [  0    0    0     0     0     0     0     0     0 ];
metadata.beeline           = [  1    0    1     0     1     0     1     0     1 ];
metadata.leaveBucketToMaze = [ 48  323  809  1134  1613  1923  2350  2650  3035 ];
metadata.trialStartAction  = [ 77  410  848  1221  1676  2008  2389  2697  3073 ];
metadata.ratPickupTeleport = [     423       1290                    2743       ];
metadata.restartmaze       = [     425       1295                    2746       ];
metadata.restartTrial      = [     437       1306                    2773       ];
metadata.sugarConsumeTimes = [ 92  525  863  1334  1692  2058  2406  2783  3108 ];
metadata.leaveMazeToBucket = [ 114 554  893  1364  1723  2084  2433  2810  3133 ];
% FOR da10 2017-09-13, SKIP THE INTRODUCTION
outp=analyzeSWR(metadata);



metadata.day = '2017-09-14_';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% TRIAL                          I   II  III    IV    V    VI   VII               VIII                
metadata.trial             = [  1    2    3     4     5     6     7                  8       ];
metadata.error             = [  1    0    1     0     0     0     0                  0       ];            
metadata.probe             = [  0    0    0     0     0     0     0                  0       ];            
metadata.outOfBounds       = [  1    1    0     0     1     0     0                  1       ];            
metadata.beeline           = [  0    0    0     0     0     1     0                  0       ];          
metadata.leaveBucketToMaze = [  45  392  666   968  1282  1636  1894              2489       ];
metadata.trialStartAction  = [  77  417  707  1005  1302  1689  1939              2556       ];
metadata.ratPickupTeleport = [ 134  435                               2171  2199  2587  2624 ];
metadata.restartmaze       = [ 136  438       1043              2044  2176  2203  2592  2628 ]; 
metadata.restartTrial      = [ 163  449       1067              2075        2212  2604  2638 ];
metadata.sugarConsumeTimes = [ 177  462  750  1083  1392  1702  2223              2648       ];
metadata.leaveMazeToBucket = [ 205  493  779  1110  1417  1727  2251              2674       ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;


metadata.day = '2017-09-15_';
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



metadata.day = '2017-09-19_';
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


% ***this gets all screwed up because there's no actual reward given in the
% probe.
metadata.day = '2017-09-20_/probe/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
metadata.leaveBucketToMaze = [ 148 ];
metadata.trialStartAction  = [ 177 ];
metadata.sugarConsumeTimes = [     ];
metadata.leaveMazeToBucket = [ 199 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;

metadata.day = '2017-09-20_/train/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;  % mostly autogenerated, with manual double check
metadata.chewRemovalEnabled = true;
% TRIAL                          I   II  III   IV     V    VI   VII  VIII   
metadata.trial             = [   1    2    3    4     5     6     7     8 ];
metadata.error             = [   0    0    1    0     0     0     0     1 ];
metadata.outOfBounds       = [   0    0    1    0     0     0     0     0 ];
metadata.probe             = [   0    0    0    0     0     0     0     0 ];
metadata.beeline           = [   0    1    0    0     1     1     1     0 ];
metadata.leaveBucketToMaze = [      193  416  668  1084  1359  1722  2149 ];
metadata.trialStartAction  = [      229  436  697  1116  1403  1740  2196 ];
metadata.ratPickupTeleport = [                                            ];
metadata.restartmaze       = [                                            ];
metadata.restartTrial      = [                                            ];
metadata.sugarConsumeTimes = [      240  451  833  1127  1418  1756  2213 ];
metadata.leaveMazeToBucket = [  50  263  472  857  1150  1442  1779  2232 ];
outp=analyzeSWR(metadata);



metadata.day = '2017-09-22_';
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
metadata.sugarConsumeTimes = [     405 671 901 1207 1693 2128 2477      ];
metadata.leaveMazeToBucket = [ 194 424 694 916 1240 1719 2150 2499 2821 ];
outp=analyzeSWR(metadata);



metadata.day = '2017-09-25_';
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
metadata.sugarConsumeTimes = [     615 909 1131 1384 1598 1827 2032 2269      ];
metadata.leaveMazeToBucket = [ 427 643 933 1157 1412 1618 1854 2057 2291 2655 ];
outp=analyzeSWR(metadata);



% 
% disp('ontoMazeTimes')
% for ii=1:length(outp.autopartition.ontoMazeTimes)
%     disp(num2str(round(outp.autopartition.ontoMazeTimes(ii))));
% end
% disp('runStartTimes')
% for ii=1:length(outp.autopartition.runStartTimes)
%     disp(num2str(round(outp.autopartition.runStartTimes(ii))));
% end
% disp('rewardTimes')
% for ii=1:length(outp.autopartition.rewardTimes)
%     disp(num2str(round(outp.autopartition.rewardTimes(ii))));
% end
% disp('intoBucketTimes')
% for ii=1:length(outp.autopartition.intoBucketTimes)
%     disp(num2str(round(outp.autopartition.intoBucketTimes(ii))));
% end
% 
% 
% 
% filters.dc = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.000001, 'HalfPowerFrequency2',    3, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
% filters.ac = designfilt( 'bandpassiir', 'StopbandFrequency1', 2, 'PassbandFrequency1',  3, 'PassbandFrequency2',    800000, 'StopbandFrequency2',    1600000, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 3200000); 
% 
% dcElectricEnv = filtfilt( filters.dc, outp.electricEnv );
% acElectricEnv = filtfilt( filters.ac, outp.electricEnv );
% dcElectricEnv =  outp.electricEnv- acElectricEnv;
% figure; plot(outp.timestampSeconds, outp.electricEnv); hold on; plot( outp.timestampSeconds, dcElectricEnv); axis tight;
% 
% 
% 
% sampleRate.lfp = 32000;
% %
% inputElements = length(outp.electricEnv);
% halfWindowSize = round(30*sampleRate.lfp);  % elements
% overlapSize = round(1.8*halfWindowSize);    % elements -- smoother when one does all the points (so like 499 overlap), but longer
% jumpSize=(2*halfWindowSize+1) - overlapSize ;
% %
% outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) + 2;
% mvgMedian = zeros( 1, outputPoints );
% mvgMedianTimes = zeros( 1, outputPoints );
% mvgMedianSampleRate = sampleRate.lfp/jumpSize;
% % initialize...
% mvgMedian(1)=median(outp.electricEnv(1:sampleRate.lfp));
% mvgMedianTimes(1) = outp.timestampSeconds(1);
% %
% outputIdx = 2;
% mvgMedian(outputIdx)=median(outp.electricEnv(1:round(halfWindowSize/2)));
% mvgMedianTimes(outputIdx) = outp.timestampSeconds(round(halfWindowSize/4));
% %
% outputIdx = 3;
% mvgMedian(outputIdx)=median(outp.electricEnv(1:halfWindowSize));
% mvgMedianTimes(outputIdx) = outp.timestampSeconds(round(halfWindowSize/2));
% %
% outputIdx = 4;
% for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
%     ii=(idx-halfWindowSize:idx+halfWindowSize);
%     mvgMedian(outputIdx)=median(outp.electricEnv(ii));
%     mvgMedianTimes(outputIdx) = outp.timestampSeconds(idx);
%     outputIdx = outputIdx + 1;
% end
% % finalize
% mvgMedian(outputIdx)=median(outp.electricEnv(end-halfWindowSize:end));
% mvgMedianTimes(outputIdx) = outp.timestampSeconds(end-round(halfWindowSize/2));
% outputIdx = outputIdx+1;
% mvgMedian(outputIdx)=median(outp.electricEnv(end-round(halfWindowSize/2):end));
% mvgMedianTimes(outputIdx) = outp.timestampSeconds(end-round(halfWindowSize/4));
% outputIdx = outputIdx+1;
% mvgMedian(outputIdx)=median(outp.electricEnv(end-sampleRate.lfp:end));
% mvgMedianTimes(outputIdx) = outp.timestampSeconds(end);
% %
% mvgMedian = mvgMedian(1:outputIdx);
% mvgMedianTimes = mvgMedianTimes(1:outputIdx);
% figure; plot(outp.timestampSeconds, outp.electricEnv); hold on; 
% plot( mvgMedianTimes, mvgMedian); axis tight;
% plot( mvgMedianTimes(1:end-1)+diff(mvgMedianTimes)/2, diff(mvgMedian))
