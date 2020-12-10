dir='/Volumes/AHOWETHESIS/h1/2018-09-07_16-02-21/';
ttFilenames={ 'TT1a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT13a.NTT' 'TT15a.NTT' 'TT17a.NTT' 'TT21a.NTT' 'TT22a.NTT'  };
dateStr='2018-09-07';
ratName = 'h1';
clusterEvaluator( dir, ttFilenames, dateStr, ratName ) 




ratName = 'h7';
path='/Volumes/AHOWETHESIS/h7/2018-08-27_15-28-03/';
dateStr='2018-08-27';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-28_14-05-30/';
dateStr='2018-08-28';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-31_16-54-02/';
dateStr='2018-08-31';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-09-04_18-27-56/';
dateStr='2018-09-04';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-09-05_17-04-14/';
dateStr='2018-09-05';
clusterEvaluator( path, {}, dateStr, ratName ) 











path='/Volumes/AHOWETHESIS/h7/2018-09-06_16-05-49/';
ttFilenames={  'TT9a.NTT' 'TT10A.NTT' 'TT11a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT14a.NTT' 'TT15a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT20a.NTT'  'TT24a.NTT'  'TT25a.NTT'  };
dateStr='2018-09-06';




path='/Volumes/AHOWETHESIS/h7/2018-09-05_17-04-14/';
ratName = 'h7';
ttFilenames=[];
dateStr='2018-09-05';
thetaFilename='CSC84.ncs';
swrFilename='CSC56.ncs';  % 36 56  
rotationalParameters.centerX = 370;
rotationalParameters.centerY = 255;
rotationalParameters.degToRotate = 48;
rotationalParameters.xoffset = 300;
rotationalParameters.yoffset = 300;
behaviorData.trial           = [	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44 ];

behaviorData.timeToMazeSec   = [	348	475	568	643	742	814	912	996 	1096	1180	1296	1461	1584	1648	1699	1754	1813	1890	1978	2092	2153	2222	2323	2394	2500	2569	2666	2732	2859	2938	3046	3154	3282	3375	3435	3536	3604	3706	3813	3934	4040	4156	4295	4419 ];
behaviorData.timeToJump1Sec  = [	416	481	573	650	748	819	918	1001	1100	1185	1300	1468	1589	1651	1705	1760	1834	1923	1992	2100	2173	2241	2344	2401	2515	2577	2678	2772	2881	2945	3063	3171	3287	3380	3440	3543	3612	3738	3820	3950	4058	4161	4861	4423 ];
behaviorData.timeToSugarSec  = [	418	483	575	652	750	821	919	1002	1102	1187	1302	1470	1591	1653	1708	1762	1836	1925	1994	2101	2175	2243	2345	2402	2517	2578	2680	2775	2883	2947	3065	3174	3289	3383	3442	3545	3614	3741	3823	3951	4060	4163	4322	4424 ];
behaviorData.timeToBucketSec = [	428	497	593	665	767	839	930	1021	1109	1220	1317	1516	1600	1657	1712	1767	1843	1931	2020	2104	2177	2257	2349	2412	2522	2598	2684	2783	2889	2963	3077	3211	3303	3416	3458	3549	3629	3746	3850	3966	4079	4172	4344	4450 ];

behaviorData.madeError       = [	1	0	1	0	1	0	0	0	0	0	0	0	1	1	1	1	1	1	0	1	1	0	1	0	1	0	1	0	1	0	0	0	0	1	0	1	0	1	0	0	0	0	0	0 ];
behaviorData.barrierHeight   = [	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15	15 ];
%behaviorData.barrierLocation = [	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms	both arms ];
%behaviorData.startLocation   = [	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door	door ];
%behaviorData.rewardLocation  = [	corner	corner	corner	corner	corner	corner	corner	corner	corner	corner	corner	corner	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column	column ];



placeCellVisualizer( path, ratName, ttFilenames, dateStr, thetaFilename, swrFilename, rotationalParameters, behaviorData )








path='/Volumes/AHOWETHESIS/h7/2018-09-05_17-04-14/';
makeFilters;

[ lfpTheta, lfpTimestamps ]=csc2mat( [ path thetaFilename ] );
lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
figure; hold off; plot(lfpTimestampSeconds, lfpTheta); hold on; plot(lfpTimestampSeconds, thetaLfp);

[ lfpSwr ]=csc2mat( [ path swrFilename ] );
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrLfp = filtfilt( swrFilter, lfpSwr );
swrLfpEnv = abs(hilbert(swrLfp));
swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
[swrPeakValues,      ...
 swrPeakTimes,       ... 
 swrPeakProminances, ...
 swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
speed=speedAll;

subplot(3,1,1); hold off; plot( lfpTimestampSeconds, lfpSwr); hold on; scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(3,1,2); plot( lfpTimestampSeconds,   swrLfp); hold on;  scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(3,1,3); hold off;
plot(xytimestampSeconds, xpos/5, 'Color', [ .7 .2 .2 ]); hold on;  
plot(xytimestampSeconds, ypos/5, 'Color', [ .1 .2 .7 ]);  
plot(xytimestampSeconds, speed, 'Color', [ .1 .7 .2 ]);
subplot(3,1,1); xlim([ 3300 3700 ]); title('LFP')
subplot(3,1,2); xlim([ 3300 3700 ]); title('SWR')
subplot(3,1,3);  xlim([ 3300 3700 ]); title('x,y,speed')


                          

hiGammaFilter    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   85, 'HalfPowerFrequency2',  160, 'SampleRate', 32000); % Sullivan, Csicsvari ... Buzsaki, J Neuro 2011; Fig 1D
hiGammaLfp = filtfilt( hiGammaFilter, lfpSwr );
hiGammaLfpEnv = abs(hilbert(hiGammaLfp));
hiGammaThreshold = mean(hiGammaLfpEnv) + ( 3  * std(hiGammaLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
[hiGammaPeakValues,      ...
 hiGammaPeakTimes,       ... 
 hiGammaPeakProminances, ...
 hiGammaPeakWidths ] = findpeaks( hiGammaLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  hiGammaThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

subplot(3,1,1); hold off; plot( lfpTimestampSeconds, lfpSwr); hold on; scatter( hiGammaPeakTimes, hiGammaPeakValues, 'v', 'filled' );
subplot(3,1,2); hold off; plot( lfpTimestampSeconds, hiGammaLfp); hold on;  scatter( hiGammaPeakTimes, hiGammaPeakValues, 'v', 'filled' );
subplot(3,1,3); hold off;
plot(xytimestampSeconds, xpos/5, 'Color', [ .7 .2 .2 ]); hold on;  
plot(xytimestampSeconds, ypos/5, 'Color', [ .1 .2 .7 ]);  
plot(xytimestampSeconds, speed, 'Color', [ .1 .7 .2 ]);
subplot(3,1,1); xlim([ 3300 3700 ]); title('LFP')
subplot(3,1,2); xlim([ 3300 3700 ]); title('hi \gamma')
subplot(3,1,3);  xlim([ 3300 3700 ]); title('x,y,speed')










output
eventSequence = [   10   20   30   40   50   60 70 80 90 100  ];
dataTimes = [ 7 8  18 19  24  30 31  37 38 39  57 57.5   59  69 78  88  99    ];
windowSize = 5;
divisionSize = .5;
oo=periEventtimeHistogram( eventSequence, dataTimes, windowSize, divisionSize )


