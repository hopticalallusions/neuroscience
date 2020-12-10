dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-20_/train/';
disp(dir);
outputDir='/Users/andrewhowe/data/plusMazeEphys/da10/';

%% I. SETUP THE ANALYSIS RUN
% 

if ~exist( [ outputDir 'cache/filters.mat' ], 'file' )
    disp('building filters');
    makeFilters;
    save( [ outputDir 'cache/filters.mat' ], 'filters');
else
    disp('loading filters');
    load([outputDir 'cache/filters.mat'], 'filters');
end

rat = 'da10';
day = '2017-09-20_/train/'

% LOAD AVERAGE LFPs

load( '/Users/andrewhowe/data/plusMazeEphys/da10/cache/da10_2017-09-20_train_avgLfp.mat' , 'avgLfp' );

% LOAD SWR CANDIDATE
% 
% 88, 61, 32 suspected SWR channel
disp('loading SWR file');
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir 'CSC88.ncs' ] );
lfpTimestampseconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

% load telemetry data
[ xpos, ypos, blob.xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ ~, xyStartIdx ] = min(abs(blob.xytimestamps-lfpTimestamps(1)));
[ xpos, ypos ] = nlxPositionFixer( xpos(xyStartIdx:end), ypos(xyStartIdx:end) ); 
blob.xytimestamps=blob.xytimestamps(xyStartIdx:end);
xylfpTimestampseconds = ( blob.xytimestamps - blob.xytimestamps(1) )/1e6;

disp('DETECT CHEWING')
%% == DETECT CHEWING ==
%
% detect chewing events -- refered to as "crunch" because that's what they
% sound like. First, filter a fairly wide band to see the crunches
%
avgChew = filtfilt( filters.so.chew, avgLfp );
%
% These crunches occur at about 3-6 Hz, so I build a wide envelope-like
% signal in which to seek these groups; regular envelope at this sample
% rate is too wobbly to detect the dead-obvious to the eye crunch groups.
%
[ chewCrunchEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate ] = boxcarMaxFilter( avgChew, lfpTimestampseconds );
% these filters depend on the ouput above.
filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
filters.ao.brux   = designfilt( 'bandpassiir', 'StopbandFrequency1', 8, 'PassbandFrequency1',  9, 'PassbandFrequency2',    15, 'StopbandFrequency2',    18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 
%
% Next, find groups of crunches, refered to as "chewing episodes"/"reward"
%
chewEpisodeLFP = filtfilt( filters.ao.nomnom, chewCrunchEnv );
chewEpisodeEnv = abs( hilbert( chewEpisodeLFP ));
chewDetectorOutput = detectPeaksEdges( chewEpisodeEnv, chewCrunchEnvTimes, chewCrunchEnvSampleRate );


chewTimes = [ 240  451  1127  1756 ];
fadeOut = ((32000:-1:1)/32000)';
fadeIn = ((1:32000)/32000)';
mbInput= fadeIn.*avgLfp( (chewTimes(1)-14)*32000:(chewTimes(1)-13)*32000-1);
mbInput=[ mbInput;  avgLfp( (chewTimes(1)-13)*32000:(chewTimes(1)+5)*32000 )];
fade = (fadeOut.*avgLfp( (chewTimes(1)+5)*32000:(chewTimes(1)+6)*32000-1)) + ( fadeIn.*avgLfp( (chewTimes(2)-14)*32000:(chewTimes(2)-13)*32000-1) );
mbInput=[ mbInput; fade ];
mbInput=[ mbInput; avgLfp( (chewTimes(2)-13)*32000:(chewTimes(2)+5)*32000 )];
fade = (fadeOut.*avgLfp( (chewTimes(2)+5)*32000:(chewTimes(2)+6)*32000-1)) + ( fadeIn.*avgLfp( (chewTimes(3)-14)*32000:(chewTimes(3)-13)*32000-1) );
mbInput=[ mbInput; fade ];
mbInput=[ mbInput; avgLfp( (chewTimes(3)-13)*32000:(chewTimes(3)+5)*32000 )];
fade = (fadeOut.*avgLfp( (chewTimes(3)+5)*32000:(chewTimes(3)+6)*32000-1)) + ( fadeIn.*avgLfp( (chewTimes(4)-14)*32000:(chewTimes(4)-13)*32000-1) );
mbInput=[ mbInput; fade ];
mbInput=[ mbInput; avgLfp( (chewTimes(4)-13)*32000:(chewTimes(4)+5)*32000 )];
fade = (fadeOut.*avgLfp( (chewTimes(4)+5)*32000:(chewTimes(4)+6)*32000-1));
mbInput=[ mbInput; fade ];
save('~/Desktop/mbInput','mbInput');


mbChew=filtfilt(filters.so.chew,mbInput);
windowSize = 1000;
convChewEnv=conv( abs(mbChew) , ones(windowSize,1)/windowSize, 'same' );
filters.ao.nomnom = designfilt( 'bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1',  4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
convChewEpisode = filtfilt(filters.ao.nomnom, convChewEnv );
tt=(1:length(mbChew))/32000;
figure; 
plot(tt,mbInput, 'Color', [ .8 .8 .8 ]);hold on; 
plot(tt,mbChew, 'Color', [ .2 .2 .2 ] ); 
plot(tt,convChewEnv); 
plot(tt,convChewEpisode);


chewTimes = [ 240  451  1127  1756 ];
fadeOut = ((chewCrunchEnvSampleRate:-1:1)/chewCrunchEnvSampleRate)';
fadeIn = ((1:chewCrunchEnvSampleRate)/chewCrunchEnvSampleRate)';
mbTrain= fadeIn .* chewEpisodeLFP(round( (chewTimes(1)-14)*chewCrunchEnvSampleRate:(chewTimes(1)-13)*chewCrunchEnvSampleRate-1));
mbTrain=[ mbTrain; chewEpisodeLFP(round( (chewTimes(1)-13)*chewCrunchEnvSampleRate:(chewTimes(1)+5)*chewCrunchEnvSampleRate ))];
fade = (fadeOut .* chewEpisodeLFP(round( (chewTimes(1)+5)*chewCrunchEnvSampleRate:(chewTimes(1)+6)*chewCrunchEnvSampleRate-1))) + ( fadeIn.*chewEpisodeLFP(round( (chewTimes(2)-14)*chewCrunchEnvSampleRate:(chewTimes(2)-13)*chewCrunchEnvSampleRate-1) ));
mbTrain=[ mbTrain; fade ];
mbTrain=[ mbTrain; chewEpisodeLFP(round( (chewTimes(2)-13)*chewCrunchEnvSampleRate:(chewTimes(2)+5)*chewCrunchEnvSampleRate ))];
fade = (fadeOut .* chewEpisodeLFP(round( (chewTimes(2)+5)*chewCrunchEnvSampleRate:(chewTimes(2)+6)*chewCrunchEnvSampleRate-1))) + ( fadeIn.*chewEpisodeLFP(round( (chewTimes(3)-14)*chewCrunchEnvSampleRate:(chewTimes(3)-13)*chewCrunchEnvSampleRate-1) ));
mbTrain=[ mbTrain; fade ];
mbTrain=[ mbTrain; chewEpisodeLFP(round( (chewTimes(3)-13)*chewCrunchEnvSampleRate:(chewTimes(3)+5)*chewCrunchEnvSampleRate ))];
fade = (fadeOut .* chewEpisodeLFP(round( (chewTimes(3)+5)*chewCrunchEnvSampleRate:(chewTimes(3)+6)*chewCrunchEnvSampleRate-1))) + ( fadeIn.*chewEpisodeLFP(round( (chewTimes(4)-14)*chewCrunchEnvSampleRate:(chewTimes(4)-13)*chewCrunchEnvSampleRate-1) ));
mbTrain=[ mbTrain; fade ];
mbTrain=[ mbTrain; chewEpisodeLFP(round( (chewTimes(4)-13)*chewCrunchEnvSampleRate:(chewTimes(4)+5)*chewCrunchEnvSampleRate ))];
fade = (fadeOut .* chewEpisodeLFP(round( (chewTimes(4)+5)*chewCrunchEnvSampleRate:(chewTimes(4)+6)*chewCrunchEnvSampleRate-1)));
mbTrain=[ mbTrain; fade ];



figure; plot(mbInput)


end


% %% visualize the process (one time)
% visStartIdx = round(416*sampleRate.lfp); %451
% visEndIdx = round(485*sampleRate.lfp);
% figure(10);
% subplot(7,1,1);
% plot((visStartIdx:visEndIdx)/32000, avgLfp(visStartIdx:visEndIdx), 'Color', [ .1 .1 .1] );
% axis tight;
% xlim([ 480 650  ]);
% grid on;
% set(gca, 'XTickLabel', [])
% ylabel('avgLfp');
% subplot(7,1,2);
% plot((visStartIdx:visEndIdx)/32000, avgChew(visStartIdx:visEndIdx), 'Color', [ .4 .4 .9] );
% axis tight;
% grid on;
% set(gca, 'XTickLabel', [])
% xlim([ 480 650  ]);
% ylabel('avgChew');
% subplot(7,1,3);
% plot(chewCrunchEnvTimes, chewCrunchEnv, 'Color', [ .5 .5 .1] );
% axis tight;
% grid on;
% set(gca, 'XTickLabel', [])
% xlim([ 480 650  ]);
% ylabel('chewCrunchEnv');
% subplot(7,1,4);
% plot(chewCrunchEnvTimes, chewEpisodeLFP, 'Color', [ .9 .4 .4] );
% ylabel('chewEpisode');
% axis tight;
% grid on;
% set(gca, 'XTickLabel', [])
% xlim([ 480 650  ]);
% subplot(7,1,5);
% plot(chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .8 .2 .8] );
% hold on;
% scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
% load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
% for jj=1:length(chewDetectorOutput.EpisodeEndIdxs);
%    if  chewDetectorOutput.EpisodeStartIdxs(jj) > 0
%        scatter( chewCrunchEnvTimes( chewDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%    else
%        scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%    end
%    if  chewDetectorOutput.EpisodeEndIdxs(jj) < length(chewCrunchEnvTimes)
%        scatter( chewCrunchEnvTimes(  chewDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%    else
%        scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%    end
% end
% axis tight;
% grid on;
% set(gca, 'XTickLabel', [])
% ylabel('chewEpisodeEnv');
% xlim([ 480 650  ]);
% subplot(7,1,6);
% swrswrLfp = filtfilt( filters.so.swr, swrLfp );
% swrswrLfpEnv = abs( hilbert(swrswrLfp) );
% plot((visStartIdx:visEndIdx)/32000, swrswrLfp(visStartIdx:visEndIdx), 'Color', [ .2 .2 .2] );
% hold on;
% plot((visStartIdx:visEndIdx)/32000, swrswrLfpEnv(visStartIdx:visEndIdx), 'Color', [ .8 .6 .2] );
% axis tight;
% ylabel('SWR');
% xlim([ 480 650  ]);
% subplot(7,1,7);
% proxToRewardSite=proxToPoint( xpos, ypos, 119, 45 );
% plot(xylfpTimestampseconds, proxToRewardSite, 'Color', [ .1 .6 .2] );
% ylabel('rewardProx');
% xlim([ 480 650  ]);
% ylim([0 1]);
%
% return;







% if visualizeAll
%    figure(1);
%    subplot(4,1,2);
%    hold off;
%    plot( chewCrunchEnvTimes, chewEpisodeEnv ); hold on;
%    scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
%    load('/Users/andrewhowe/src/neuroscience/miscFx/colorOptions');
%    for jj=1:length(chewDetectorOutput.EpisodeEndIdxs);
%        if  chewDetectorOutput.EpisodeStartIdxs(jj) > 0
%            scatter( chewCrunchEnvTimes( chewDetectorOutput.EpisodeStartIdxs(jj) ), 0, '>',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%        else
%            scatter( chewCrunchEnvTimes( 1 ), 0, '>', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%        end
%        if  chewDetectorOutput.EpisodeEndIdxs(jj) < length(chewCrunchEnvTimes)
%            scatter( chewCrunchEnvTimes(  chewDetectorOutput.EpisodeEndIdxs(jj) ), 0, '<',  'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:));
%        else
%            scatter( chewCrunchEnvTimes( end ), 0, '<', 'MarkerEdgeColor', colorOptions(mod(jj,length(colorOptions))+1,:), 'MarkerFaceColor', colorOptions(mod(jj,length(colorOptions))+1,:) );
%        end
%    end
%    ylabel('reward');
%    xlim([0 lfpTimestampseconds(end)]);
%    ylim([-0.001 max([ chewDetectorOutput.EpisodePeakValues electricSignal.PeakValues' ])]);
% end



% ==================================================
% ==  RECALCULATE TELEMETRY BASED ON CORRECTIONS  ==
% ==================================================
proxToCenter=proxToPoint( xpos, ypos, 317, 229 );
proxToStart=proxToPoint( xpos, ypos, 81, 412 );
proxToRewardSite=proxToPoint( xpos, ypos, 119, 45 );
proxToIncorrectSite=proxToPoint( xpos, ypos, 525, 429 );


%
%% ; make a list of times for trial events
%
if autobins
    swrAnalysisBins = sort([ 0 output.ontoMazeTimes output.runStartTimes output.rewardTimes output.intoBucketTimes xylfpTimestampseconds(end) ]);
else
    swrAnalysisBins = sort([ 0 touchdownTimes brickTimes sugarTimes liftoffTimes xylfpTimestampseconds(end) ]);
end


toc
disp('PROCESS SWR FILE')
% =====================
% ==  SWR -- LFP 88  ==
% =====================
swrswrLfp = filtfilt( filters.so.swr, swrLfp );
swrswrLfpEnv = abs( hilbert(swrswrLfp) );
[ swrPeakValues,      ...
  swrPeakTimes,       ...
  swrPeakProminances, ...
  swrPeakWidths ] = findpeaks( swrswrLfpEnv,                        ... % data
                             lfpTimestampseconds,                     ... % sampling frequency
                             'MinPeakHeight',  std(swrswrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak





%% display trial auto-partitioning summary data
gcf(4)=figure(4); 
subplot(4,1,1); 
plot( lfpTimestampseconds, blob.electricEnv, 'k' );    
hold on;
plot( mazeEntries.mvgMedianTimes, mazeEntries.mvgMedian, 'r' );
%plot( mazeEntries.mvgMedianTimes(2:end), mazeEntries.elecBaseline );
scatter( electricSignal.PeakTimes, electricSignal.PeakValues, 'v', 'filled');
axis tight;  
ylim([ min(mazeEntries.elecBaseline) max(electricSignal.PeakValues) ]);
ylabel('Avg; 60 Hz');
subplot(4,1,2); 
plot( chewCrunchEnvTimes, chewEpisodeEnv, 'Color', [ .2 .7 .2 ] ); 
hold on;
scatter( chewDetectorOutput.EpisodePeakTimes, chewDetectorOutput.EpisodePeakValues, 'v', 'filled');
axis tight;
ylim([0 max(chewDetectorOutput.EpisodePeakValues)]);
ylabel('reward/chew');
subplot(4,1,3); 
plot( chewCrunchEnvTimes, bruxEpisodeEnv, 'Color', [ .7 .2 .2 ] ); 
hold on;
scatter( bruxDetectorOutput.EpisodePeakTimes, bruxDetectorOutput.EpisodePeakValues, 'v', 'filled');
axis tight;
ylim([0 max(bruxDetectorOutput.EpisodePeakValues)]);
ylabel('brux');
subplot(4,1,4); 
hold off; 
plot( mvgMedianTimes, mvgMedian ); 
hold on; %plot( mvgMedianTimes(2:end), -diff(mvgMedian) ); 
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel( 'start prox./trials' ); axis tight; ylim([ 0 1 ]);
print( gcf(4), [outputDir rat '_' day '_' strrep(swrLfpFile, '.ncs', '')  '_finalAutoTrialMarking.png'],'-dpng','-r200');



output.autopartition.ontoMazeTimes = output.ontoMazeTimes;
output.autopartition.runStartTimes = output.runStartTimes;
output.autopartition.rewardTimes = output.rewardTimes;
output.autopartition.intoBucketTimes = output.intoBucketTimes;


% for manual intervention, use the provided markers for the subsequent
% analysis
if ~autobins

    swrAnalysisBins = sort([ 0 touchdownTimes brickTimes sugarTimes liftoffTimes xylfpTimestampseconds(end) ]);
    
    output.ontoMazeTimes = touchdownTimes; 
    output.runStartTimes = brickTimes; 
    output.rewardTimes = sugarTimes;
    output.intoBucketTimes = liftoffTimes;
    
end


%% display SWR rate summary data 
gcf(5)=figure(5); 
subplot(4,1,1); 
output.swrRate = 1./diff(output.swrPeakTimesDenoise);
plot( output.swrPeakTimesDenoise(1:end-1)+(diff(output.swrPeakTimesDenoise)/2), output.swrRate )
hold on;
scatter( output.ontoMazeTimes, zeros(1,length(output.ontoMazeTimes)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, zeros(1,length(output.runStartTimes)), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, zeros(1,length(output.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .7 .95 ]);
scatter( output.intoBucketTimes, zeros(1,length(output.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
ylabel('SWR_{rate}'); 
xlim([0 lfpTimestampseconds(end)]); 
ylim([-0.1 max(output.swrRate)]);
subplot(4,1,2); 
plot( mvgMedianTimes, mvgMedian ); 
hold on;
scatter( output.ontoMazeTimes, ones(1,length(output.ontoMazeTimes)).*0.1, 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );
scatter( output.runStartTimes, ones(1,length(output.runStartTimes)).*0.1, '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
scatter( output.rewardTimes, ones(1,length(output.rewardTimes)).*0.1, 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
scatter( output.intoBucketTimes, ones(1,length(output.intoBucketTimes)).*0.1, '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
%
scatter( output.autopartition.ontoMazeTimes, zeros(1,length(output.autopartition.ontoMazeTimes)), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ .7 .5 0 ] );
scatter( output.autopartition.runStartTimes, zeros(1,length(output.autopartition.runStartTimes)), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .1 .3 0 ]);
scatter( output.autopartition.rewardTimes, zeros(1,length(output.autopartition.rewardTimes)), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .2 .2 .7 ]);
scatter( output.autopartition.intoBucketTimes, zeros(1,length(output.autopartition.intoBucketTimes)), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .6 .1 .1 ]);
%
ylabel( 'start prox./trial ev.' ); 
axis tight; 
ylim([ 0 1 ]);
subplot(4,1,3); 
histogram( output.swrPeakTimesDenoise, swrAnalysisBins ); 
title('SWR Frequency'); 
xlabel('time (s)'); ylabel('counts'); axis tight;
subplot(4,1,4); hold off;
xx=swrAnalysisBins(1:end-1)+diff(swrAnalysisBins)/2;
yy=histcounts( output.swrPeakTimesDenoise, swrAnalysisBins )./diff(swrAnalysisBins);
plot( xx, yy ); 
hold on;
title('SWR rate'); xlabel('time (s)'); ylabel('Hz'); axis tight;
[vals,idxs]=intersect(swrAnalysisBins,output.ontoMazeTimes);
scatter( xx(idxs), yy(idxs), 'v', 'MarkerEdgeColor', [ .5 .4 0 ], 'MarkerFaceColor', [ 1 .8 0 ] );;
output.swrAnalysisBinLabels(idxs) = 1;
[vals,idxs]=intersect(swrAnalysisBins,output.runStartTimes);
scatter( xx(idxs), yy(idxs), '>',  'MarkerEdgeColor', [ .2 .6 0 ], 'MarkerFaceColor', [ .2 .6 0 ]);
output.swrAnalysisBinLabels(idxs) = 2;
[vals,idxs]=intersect(swrAnalysisBins,output.rewardTimes);
scatter( xx(idxs), yy(idxs), 'o', 'filled', 'MarkerEdgeColor', [ .4 .4 .9 ], 'MarkerFaceColor', [ .4 .4 .9 ]);
output.swrAnalysisBinLabels(idxs) = 3;
[vals,idxs]=intersect(swrAnalysisBins,output.intoBucketTimes);
scatter( xx(idxs), yy(idxs), '^', 'filled', 'MarkerEdgeColor', [ .9 .1 .1 ], 'MarkerFaceColor', [ .9 .1 .1 ]);
output.swrAnalysisBinLabels(idxs) = 4;
xlim([-0.05 lfpTimestampseconds(end)]);
print( gcf(5), [outputDir rat '_' day '_' strrep(swrLfpFile, '.ncs', '')  '_SWRrateSummary.png'],'-dpng','-r200');

save([outputDir rat '_' day '_' strrep(swrLfpFile, '.ncs', '') '_output'], 'output' );


%%
output.blob.electricEnv = blob.electricEnv;
output.lfpTimestampseconds = lfpTimestampseconds;
output.xpos = old.xpos;
output.ypos = old.ypos;
output.proxToStart = proxToStart;
ouput.chewCrunchEnv = chewCrunchEnv;
ouput.chewCrunchEnvTimes = chewCrunchEnvTimes;
ouput.chewCrunchEnvSampleRate = chewCrunchEnvSampleRate;
output.elecBaselineJumpValues = elecBaselineJumpValues;
output.elecBaselineJumpTimes = elecBaselineJumpTimes;
output.elecBaselineDropValues = elecBaselineDropValues;
output.elecBaselineDropTimes = elecBaselineDropTimes;

disp('COMPLETE')

%% terminate the script
toc

return;
