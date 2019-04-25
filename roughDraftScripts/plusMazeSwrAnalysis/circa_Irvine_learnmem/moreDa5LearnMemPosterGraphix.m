metadata.rat = 'da5';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
metadata.swrLfpFile = 'CSC4.ncs'; % TT2,TT7,TT8 ;; ch4, ch24, ch28, ch36?, 


dir = '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/'


disp('loading SWR file');
[ smoothSpeedswrLfp, smoothSpeedlfpTimestamps ] = csc2mat( '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-28_training4/CSC30.ncs' );
smoothSpeedlfpTimestampSeconds=(smoothSpeedlfpTimestamps-smoothSpeedlfpTimestamps(1))/1e6;



[ smoothSpeedxpos, smoothSpeedypos, smoothSpeedxytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(smoothSpeedxytimestamps-smoothSpeedlfpTimestamps(1)));
smoothSpeedxpos=nlxPositionFixer(smoothSpeedxpos(xyStartIdx:end)); 
smoothSpeedypos=nlxPositionFixer(smoothSpeedypos(xyStartIdx:end)); 
smoothSpeedxytimestamps=smoothSpeedxytimestamps(xyStartIdx:end);
xysmoothSpeedxytimestampSeconds = ( smoothSpeedxytimestamps - smoothSpeedxytimestamps(1) )/1e6;

makeFilters;

swrsmoothSpeedswrLfp = filtfilt( filters.so.swr, smoothSpeedswrLfp );
swrsmoothSpeedswrLfpEnv = abs( hilbert(swrsmoothSpeedswrLfp) );

swrEnvMedian = median(swrsmoothSpeedswrLfpEnv);
swrEnvMadam  = median(abs(swrsmoothSpeedswrLfpEnv-swrEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
swrThreshold = swrEnvMedian + ( 7  * swrEnvMadam );

[ swrPeakValues,      ...
  swrPeakTimes,       ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks( swrsmoothSpeedswrLfpEnv(nlxidxs),                        ... % data
                             smoothSpeedlfpTimestampSeconds(nlxidxs),                     ... % sampling frequency
                             'MinPeakHeight',  swrThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


spikesmoothSpeedswrLfp = filtfilt( filters.so.spike, smoothSpeedswrLfp );
spikeswrsmoothSpeedswrLfpEnv = abs( hilbert(spikesmoothSpeedswrLfp) );

spikeEnvMedian = median(spikeswrsmoothSpeedswrLfpEnv);
spikeEnvMadam  = median(abs(spikeswrsmoothSpeedswrLfpEnv-spikeEnvMedian));
% empirically tested Feb 16, 2018; The 7 should be replaced by an 8 to make
% it equivalent to the std(xx)*6 previously used; this change was made
% because some SWR channels had no events due to 1 large noise artifact
% wrecking the threshold; the threshold was slightly relaxed on the premise
% that extra SWR could be removed at later processing stages.
spikeThreshold = spikeEnvMedian + ( 7  * spikeEnvMadam );

[ spikePeakValues,      ...
  spikePeakTimes,       ...
  spikePeakProminances, ...
  spikePeakWidths ] = findpeaks( spikeswrsmoothSpeedswrLfpEnv(nlxidxs),                        ... % data
                             smoothSpeedlfpTimestampSeconds(nlxidxs),                     ... % sampling frequency
                             'MinPeakHeight',  spikeThreshold, ...  %std(swrsmoothSpeedswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.002  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak



                         

pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(smoothSpeedxpos, smoothSpeedypos, lagTime, pxPerCm);



% 2016-08-28 video 12 minutes for the SWR example.
startTime = 673  % 721 for SWR ; 
endTime =  735 % 722 for SWR ; 
nlxidxs=round(startTime*32000):round(endTime*32000);
xyidxs=round(startTime*29.97):round(endTime*29.97);
figure;
subplot(4,1,1);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),smoothSpeedswrLfp(nlxidxs), 'k');
subplot(4,1,2);
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfp(nlxidxs), 'Color', [ .1 .1 .8 ]);hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),swrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .7 .1 .1 ]);
scatter( swrPeakTimes, swrPeakValues, 'v', 'filled' );
subplot(4,1,3); hold off;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikeswrsmoothSpeedswrLfpEnv(nlxidxs), 'Color', [ .1 .7 .1 ]); hold on;
plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
scatter( spikePeakTimes, (-.3*ones(1,length(spikePeakTimes))), '+', 'MarkerEdgeColor', [ .3 .3 .8 ] ); 
ylim([-.4 .4])
subplot(4,1,4);
%plot(smoothSpeedlfpTimestampSeconds(nlxidxs),spikesmoothSpeedswrLfp(nlxidxs), 'Color', [ .2 .2 .2 ]); hold on;
%xlim([ 721.37 721.42 ]);
plot( xysmoothSpeedxytimestampSeconds(xyidxs), speed(xyidxs)); hold on;
plot( xysmoothSpeedxytimestampSeconds(xyidxs), 2+((speed(xyidxs)>7)*5), 'Color', [ .1 .8 .1 ]);
print( '~/Desktop/swrexample.png','-dpng','-r500');




xlims=[ 721 722 ]; subplot(4,1,1); xlim(xlims);  subplot(4,1,2); xlim(xlims);  subplot(4,1,3); xlim(xlims); subplot(4,1,4); xlim(xlims);


%trial 1, episode X
xlims=[ 71.5 77.5 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);

%trial 2 episode X
xlims=[ 387 393 ]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims);



xlims=[ 50 128]; subplot(3,1,1); xlim(xlims);  subplot(3,1,2); xlim(xlims);  subplot(3,1,3); xlim(xlims); 