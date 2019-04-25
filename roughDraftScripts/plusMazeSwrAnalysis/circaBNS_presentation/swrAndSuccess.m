

load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-11bucket_output.mat');


load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-11explore_output.mat');

load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-12_training_output.mat');
figure(11); hold off;
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-13_training_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-14__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-15__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-18_training1_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-18_training2_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-18_training3_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-19__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-20_probe_output.mat');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-20_train_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-22__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-25__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');














load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-12_training_output.mat');
figure(12); hold off;
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-13_training_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-14__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-15__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-18_training1_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-18_training2_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-18_training3_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-19__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-20_probe_output.mat');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-20_train_output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-22__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');
load('/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-25__output.mat');
swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes 4e3 ]);
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins );
xx=diff(swrAnalysisBins);
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
figure(11); hold on;
scatter(xx(idxs),yy(idxs), 'o', 'filled');



dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-20_/train/';
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-13_/training/';
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
figure; plot(xpos,ypos); hold on; scatter( [109 325 144 525],[416 240 63 429], 'filled' )
proxToStart=proxToPoint( xpos, ypos, 109, 416 );
proxToCenter=proxToPoint( xpos, ypos, 325,240 );
proxToRewardSite=proxToPoint( xpos, ypos, 144, 63 );
proxToIncorrectSite=proxToPoint( xpos, ypos, 525, 429 );
dd=distanceTraveled(xpos,ypos,1398, 1414 )