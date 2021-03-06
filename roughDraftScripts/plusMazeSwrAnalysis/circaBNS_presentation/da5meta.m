clear all; 
close all;

metadata.rat = 'da5';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
metadata.swrLfpFile = 'CSC4.ncs'; % TT2,TT7,TT8 ;; ch4, ch24, ch28, ch36?, 
% best HF cells : TT2,TT7,TT8
% OK HF cells : TT 10
% Nac cells :  14, 15, 
% excellent Theta : tt12 ch 44
% VTA : TT3, 4, 16  -- none of the VTA LFPs look very interesting, but who knows
% NACC :TT5, 6, 14, 15  
metadata.lfpStartIdx = 1;  
metadata.outputDir = '/Users/andrewhowe/data/plusMazeEphys/';
metadata.sampleRate.lfp=32000;
metadata.sampleRate.telemetry=29.97;
metadata.autobins = true;
metadata.chewRemovalEnabled = false;



% '2016-08-22_orientation1/1.maze-habituation/'
% '2016-08-22_orientation1/2.bucket-rest/'
% '2016-08-23_orientation2/1.maze-habituation/'
% '2016-08-23_orientation2/2.bucket-rest/'
% '2016-08-24_training1/'
% '2016-08-25_training2/'
% '2016-08-26_probe1/'
% '2016-08-27_training3/'
% '2016-08-28_training4/'
% '2016-08-29_training5/'
% '2016-08-30_training6/'
% '2016-08-31_training7/'
% '2016-09-01_training8/'
% '2016-09-02_probe2/'
% '2016-09-06_training9_x2/'
% '2016-09-07_training10_x2/'
% '2016-09-08_probe3_training11/'



metadata.day = 'da10_2017-09-11/bucket/';
metadata.chewRemovalEnabled = false;
metadata.autobins = false;
metadata.touchdownTimes = [ 0 ];
metadata.brickTimes =     [];
metadata.sugarTimes =     [];
metadata.liftoffTimes =   [ ];
outp=analyzeSWR(metadata);



% probably should get rid of chews elimination
metadata.day = 'da10_2017-09-11/explore/';
metadata.chewRemovalEnabled = false;
metadata.autobins = false;
metadata.touchdownTimes = [ 0 322 698 ];
metadata.brickTimes =     [ 346 776 ];
metadata.sugarTimes =     [];
metadata.liftoffTimes =   [  ];
outp=analyzeSWR(metadata);





metadata.day = '2017-09-12_/training/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
% manually confirmed. times shifted 1 s back
metadata.touchdownTimes = [  79 501  781  879  924 1024 1416 1504 2036 2518 3523 3995 4117 4840 ];
metadata.brickTimes =     [ 132 537  824  900  945 1056 1464 1510 2103 2570 3595 4033 4192 4921 ];
metadata.sugarTimes =     [ 196 562                1080 1691 2174      3183 3665 ];
metadata.liftoffTimes =   [ 240 590                1116 1740 2206 2625 3217 3697           4966 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ] ); end;



metadata.day = '2017-09-13_/training/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
% automation result confirmed to be good
metadata.touchdownTimes = [];
metadata.brickTimes =     [];
metadata.sugarTimes =     [];
metadata.liftoffTimes =   [];
% FOR da10 2017-09-13, SKIP THE INTRODUCTION
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;



metadata.day = '2017-09-14_';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [  45  136  392  438  666   968  1040  1282  1636  1894  2040  2133  2173  2201  2489  2590  2626 ];
metadata.brickTimes =     [  77  163  417  449  707  1005  1069  1302  1689  1939  2078  2150  2187  2217  2556  2611  2641 ];
metadata.sugarTimes =     [      177       462  750  1083        1392  1702                    2223              2648 ];
metadata.liftoffTimes =   [      205       493  779  1110        1417  1727                    2251              2674 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;


metadata.day = '2017-09-15_';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [  17  338  620  875  1146  1418  1712  1801  2120  2378 ];
metadata.brickTimes =     [  64  377  645  916  1184  1464  1780  1813  2161  2459 ];
metadata.sugarTimes =     [  80  393  664  934  1195  1473        1865  2177  2469 ];
metadata.liftoffTimes =   [ 108  420  688  957  1218  1499        1885  2199  2493 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day] ); end;




% some wierd stuff happens
metadata.day = '2017-09-18_/training1/';
metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [ 251  517  752  1027 ];
metadata.brickTimes =     [ 271  547  783  1060 ];
metadata.sugarTimes =     [ 283  558  794  1072 ];
metadata.liftoffTimes =   [ 309  580  817  1106 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
metadata.day = '2017-09-18_/training2/';
metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [ 249  499  587 ];
metadata.brickTimes =     [ 291  530  613 ];
metadata.sugarTimes =     [ 299       623 ];
metadata.liftoffTimes =   [ 325       644 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
metadata.day = '2017-09-18_/training3/';
metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = true;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [ 110  388  435  529  841  895 ];
metadata.brickTimes =     [ 164  413  483  547  874  933 ];
metadata.sugarTimes =     [ 172       555            941 ];
metadata.liftoffTimes =   [ 196       582            962 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;




metadata.day = '2017-09-19_';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [  50  113  510  723   967  1218  1267  1584  1686  1751  1995 ];
metadata.brickTimes =     [  76  278  543  764  1001  1254  1288  1615  1732  1773  2039 ];
metadata.sugarTimes =     [  84  323  549  770  1008        1367              1779  2044 ];
metadata.liftoffTimes =   [ 104  354  571  799  1034        1395              1801  2068 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
% some wierd stuff happens


% ***this gets all screwed up because there's no actual reward given in the
% probe.
metadata.day = '2017-09-20_/probe/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [ 148 ];
metadata.brickTimes =     [ 177];
metadata.sugarTimes =     [];
metadata.liftoffTimes =   [ 199 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;

metadata.day = '2017-09-20_/train/';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;  % mostly autogenerated, with manual double check
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [      193  416  668  1084  1359  1722  2149 ];
metadata.brickTimes =     [      229  436  697  1116  1403  1740  2196 ];
metadata.sugarTimes =     [      240  451  833  1127  1418  1756  2213 ];
metadata.liftoffTimes =   [ 213  263  472  857  1150  1442  1779  2232 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
% beginning seems to be cut off?
%has some errors identifying cutoffs; last trial is bad



metadata.day = '2017-09-22_';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false; % mostly autogenerated, but the sandwhich of probe trials messed up the detector start and finish
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes = [ 139 356 570 855 1113 1427 1597 1908 2046 2342 2753 ];
metadata.brickTimes =     [ 180 389 615 887 1143 1563 1633 1982 2115 2385 2787 ];
metadata.sugarTimes =     [     405 671 901 1207      1693      2128 2477 ];
metadata.liftoffTimes =   [ 194 424 694 916 1240      1719      2150 2499 2821 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;




metadata.day = '2017-09-25_';
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.autobins = false;
metadata.chewRemovalEnabled = true;
metadata.touchdownTimes  = [ 392 558 853 1064 1340 1551 1789 1993 2231 2608 ];
metadata.brickTimes =      [ 416 605 891 1092 1367 1585 1818 2019 2258 2631 ];
metadata.sugarTimes =      [     615 909 1131 1384 1598 1827 2032 2269 ];
metadata.liftoffTimes =    [ 427 643 933 1157 1412 1618 1854 2057 2291 2655 ];
outp=analyzeSWR(metadata);
%try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;




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
