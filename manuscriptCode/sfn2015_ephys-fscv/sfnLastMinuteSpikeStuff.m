% [ cscLFPthirtythree, nlxCscTimestampsthirtythree, cscHeaderthirtythree ] = csc2mat([basedir '/nlx/platter/CSC33.ncs']);
% [ correctedCscthirtythree, idxsthirtythree, mxValuesthirtythree, meanCscWindowthirtythree ] = cscCorrection( cscLFPthirtythree(60*32000*10:end), nlxCscTimestampsthirtythree(60*32000*10:end) );
% [ cscLFPfortynine, nlxCscTimestampsfortynine, cscHeaderfortynine ] = csc2mat([basedir '/nlx/platter/CSC49.ncs']);
% [ correctedCscfortynine, idxsfortynine, mxValuesfortynine, meanCscWindowfortynine ] = cscCorrection( cscLFPfortynine(60*32000*10:end), nlxCscTimestampsfortynine(60*32000*10:end) );
% basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
% [ cscLFPthirtythree, nlxCscTimestampsthirtythree, cscHeaderthirtythree ] = csc2mat([basedir '/nlx/platter/CSC33.ncs']);
% [ correctedCscthirtythree, idxsthirtythree, mxValuesthirtythree, meanCscWindowthirtythree ] = cscCorrection( cscLFPthirtythree(60*32000*10:end), nlxCscTimestampsthirtythree(60*32000*10:end) );
% [ cscLFPfortynine, nlxCscTimestampsfortynine, cscHeaderfortynine ] = csc2mat([basedir '/nlx/platter/CSC49.ncs']);
% [ correctedCscfortynine, idxsfortynine, mxValuesfortynine, meanCscWindowfortynine ] = cscCorrection( cscLFPfortynine(60*32000*10:end), nlxCscTimestampsfortynine(60*32000*10:end) );
% adjIdx=27544046-60*32000*10;
% [ cscLFPSeven, nlxCscTimestampsSeven, cscHeaderSeven ] = csc2mat([basedir '/nlx/platter/CSC7.ncs']);
% %min(find((nlxCscTimestamps-nlxCscTimestamps(1))>860.751377*1e6))
% %idx 27544046-60*32000*10
% [ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( cscLFP(60*32000*10:end), nlxCscTimestamps(60*32000*10:end) );
% [ cscLFPeighteen, nlxCscTimestampseighteen, cscHeadereighteen ] = csc2mat([basedir '/nlx/platter/CSC18.ncs']);
% cscHeadereighteen
% [ cscLFPeighteen, nlxCscTimestampseighteen, cscHeadereighteen ] = csc2mat([basedir '/nlx/platter/CSC23.ncs']);
% cscHeadereighteen
% [ cscLFPeighteen, nlxCscTimestampseighteen, cscHeadereighteen ] = csc2mat([basedir '/nlx/platter/CSC41.ncs']);
% cscHeadereighteen
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC7.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC18.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC23.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC44.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC41.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC7.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC18.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC23.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC33.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC41.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC44.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC48.ncs'], 1, 3200)
% [ ~, ~, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC49.ncs'], 1, 3200)
% [ cscLFPeighteen, nlxCscTimestampseighteen, cscHeadereighteen ] = csc2mat([basedir '/nlx/platter/CSC18.ncs']);
% [ cscLFPfortyone, nlxCscTimestampsfortyone, cscHeaderfortyone ] = csc2mat([basedir '/nlx/platter/CSC41.ncs']);
% [ correctedCscfortyone, idxsfortyone, mxValuesfortyone, meanCscWindowfortyone ] = cscCorrection( cscLFPfortyone(60*32000*10:end), nlxCscTimestampsfortyone(60*32000*10:end) );
% [ cscLFPfortyfour, nlxCscTimestampsfortyfour, cscHeaderfortyfour ] = csc2mat([basedir '/nlx/platter/CSC44.ncs']);
% [ correctedCscfortyfour, idxsfortyfour, mxValuesfortyfour, meanCscWindowfortyfour ] = cscCorrection( cscLFPfortyfour(60*32000*10:end), nlxCscTimestampsfortyfour(60*32000*10:end) );
% seven=(decimate(conv(abs(hilbert(correctedCsc(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% thirtythree=(decimate(conv(abs(hilbert(correctedCscthirtythree(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortyone=(decimate(conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortyfour=(decimate(conv(abs(hilbert(correctedCscfortyfour(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortynine=(decimate(conv(abs(hilbert(correctedCscfortynine(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% sigma = 1100;
% filterWindowLength = 6770;
% x = linspace(-filterWindowLength / 2, filterWindowLength / 2, filterWindowLength);
% gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
% gaussFilter = gaussFilter / sum (gaussFilter); % normalize
% seven=(decimate(conv(abs(hilbert(correctedCsc(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% thirtythree=(decimate(conv(abs(hilbert(correctedCscthirtythree(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortyone=(decimate(conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortyfour=(decimate(conv(abs(hilbert(correctedCscfortyfour(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortynine=(decimate(conv(abs(hilbert(correctedCscfortynine(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% figure;
% subplot(5,1,1); plot(correctedCsc(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,2); plot(correctedCscthirtythree(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,3); plot(correctedCscfortyone(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,4); plot(correctedCscfortyfour(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,5); plot(correctedCscfortynine(adjIdx:adjIdx+(32000*40)));
% figure;
% subplot(5,1,1); plot(seven(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,2); plot(thirtythree(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,3); plot(fortyone(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,4); plot(fortyfour(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,5); plot(fortynine(adjIdx:adjIdx+(32000*40)));
% plot(seven)
% figure;
% subplot(5,1,1); plot(seven);
% subplot(5,1,2); plot(thirtythree);
% subplot(5,1,3); plot(fortyone);
% subplot(5,1,4); plot(fortyfour);
% subplot(5,1,5); plot(fortynine);
% figure;
% subplot(5,1,1); plot(seven); axis tight;
% subplot(5,1,2); plot(thirtythree);  axis tight;
% subplot(5,1,3); plot(fortyone);  axis tight;
% subplot(5,1,4); plot(fortyfour);  axis tight;
% subplot(5,1,5); plot(fortynine);  axis tight;
% mean(thirtythree)
% std(thirtythree)
% subplot(5,1,2); hold on; plot([0 4000], [mean(thirtythree)+3*std(thirtythree) mean(thirtythree)+3*std(thirtythree)])
% figure; plot(xcorr(thirtythree(250:500),seven))
% [corrVal,lag]=(xcorr(thirtythree(250:500),seven));
% figure; plot(lag, corrVal)
% [corrVal,lag]=(xcorr(fortynine(250:500),seven));
% figure; plot(lag, corrVal)
% (nlxCscTimestamps(27544046)-nlxCscTimestamps(1))/60e6
% .3459*60
% min(find((nlxCscTimestamps-nlxCscTimestamps(1))>857513837))
% adjIdx=27440444-60*32000*10;
% seven=(decimate(conv(abs(hilbert(correctedCsc(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% thirtythree=(decimate(conv(abs(hilbert(correctedCscthirtythree(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortyone=(decimate(conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortyfour=(decimate(conv(abs(hilbert(correctedCscfortyfour(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% fortynine=(decimate(conv(abs(hilbert(correctedCscfortynine(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% figure;
% subplot(5,1,1); plot(correctesdCsc(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,2); plot(correctedCscthirtythree(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,3); plot(correctedCscfortyone(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,4); plot(correctedCscfortyfour(adjIdx:adjIdx+(32000*40)));
% subplot(5,1,5); plot(correctedCscfortynine(adjIdx:adjIdx+(32000*40)));
% figure;
% subplot(5,1,1); plot(seven); axis tight;
% subplot(5,1,2); plot(thirtythree);  axis tight;
% subplot(5,1,3); plot(fortyone);  axis tight;
% subplot(5,1,4); plot(fortyfour);  axis tight;
% subplot(5,1,5); plot(fortynine);  axis tight;
% 18.0+23.20
% 18.0+40.60
% figure; decimate(conv(abs(hilbert(correctedCscfortynine)), gaussFilter, 'same'),320);
% length(correctedCscfortynine)
% figure; plot(decimate(conv(abs(hilbert(correctedCscfortynine)), gaussFilter, 'same'),320));
% myenv=decimate(conv(abs(hilbert(correctedCscfortynine)), gaussFilter, 'same'),320);
% tt=((60*320*10):(60*320*10)+length(myenv))/100;
% tt=((60*320*10):(60*320*10)+length(myenv)-1)/100;
% figure; plot(tt,myenv);
% axis tight
% figure;
% subplot(3,1,1); plot(tt,myenv);axis tight;
% subplot(3,1,2); plot(tt,diff(myenv)); axis tight;
% subplot(3,1,2); plot(tt,[ 0 diff(myenv)]); axis tight;
% subplot(3,1,2); plot(tt,[ 0; diff(myenv)]); axis tight;
% superThresholdIdxs = find( myenv > 300 );
% putativeApPeakIdxs = [];
% idx = 1;
% while idx < length(superThresholdIdxs)
% startIdx = idx;
% %disp([num2str(superThresholdIdxs(idx+1)) ' == '  num2str(superThresholdIdxs(idx)+1) 'is ' num2str(superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)] )
% while (idx+1 < length(superThresholdIdxs) ) && (superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)
% idx = idx + 1;
% end
% endIdx = idx;
% %disp([num2str(startIdx) '   ' num2str(endIdx)]);
% offset = find(myenv(superThresholdIdxs(startIdx:endIdx))==max(correctedCsc(superThresholdIdxs(startIdx:endIdx))));
% offset = offset(1)-1;
% putativeApPeakIdxs = [ putativeApPeakIdxs startIdx+offset];
% idx=endIdx+1;
% end
% % look, it works!
% offset
% superThresholdIdxs = find( myenv > 300 );
% putativeApPeakIdxs = [];
% idx = 1;
% while idx < length(superThresholdIdxs)
% startIdx = idx;
% %disp([num2str(superThresholdIdxs(idx+1)) ' == '  num2str(superThresholdIdxs(idx)+1) 'is ' num2str(superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)] )
% while (idx+1 < length(superThresholdIdxs) ) && (superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)
% idx = idx + 1;
% end
% endIdx = idx;
% %disp([num2str(startIdx) '   ' num2str(endIdx)]);
% offset = find(myenv(superThresholdIdxs(startIdx:endIdx))==max(myenv(superThresholdIdxs(startIdx:endIdx))));
% offset = offset(1)-1;
% putativeApPeakIdxs = [ putativeApPeakIdxs startIdx+offset];
% idx=endIdx+1;
% end
% figure;
% plot( myenv(1:2000), 'b')
% hold on;
% plot( superThresholdIdxs(putativeApPeakIdxs(1:24)), myenv(superThresholdIdxs(putativeApPeakIdxs(1:24))),'ro')
% figure; hist(myenv(superThresholdIdxs(putativeApPeakIdxs)),250);
% figure;
% plot( myenv, 'b')
% hold on;
% plot( superThresholdIdxs(putativeApPeakIdxs), myenv(superThresholdIdxs(putativeApPeakIdxs)),'ro')
% tt(end)/60
% tt=((60*320*10):(60*320*10)+length(myenv)-1)/(100*60);
% tt(end)
% 32000/320
% tt(end)-tt(1)
% tt=((60*100*10):(60*100*10)+length(myenv)-1)/(100*60);
% tt(end)
% tt(1)
% tt(putativeApPeakIdxs)
% tt(putativeApPeakIdxs)'
% tt=((60*100*10):(60*100*10)+length(myenv)-1)/(60);
% tt(end)
% tt=((60*100*10):(60*100*10)+length(myenv)-1)/(60*100);
% tt(end)
% max(putativeApPeakIdxs)
% length(tt)
% tt(superThresholdIdxs(putativeApPeakIdxs))'
% superThresholdIdxs = find( myenv > 300 );
% putativeApPeakIdxs = [];
% idx = 1;
% while idx < length(superThresholdIdxs)
% startIdx = idx;
% %disp([num2str(superThresholdIdxs(idx+1)) ' == '  num2str(superThresholdIdxs(idx)+1) 'is ' num2str(superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)] )
% while (idx+1 < length(superThresholdIdxs) ) && (superThresholdIdxs(idx+1) < superThresholdIdxs(idx)+100)
% idx = idx + 1;
% end
% endIdx = idx;
% %disp([num2str(startIdx) '   ' num2str(endIdx)]);
% offset = find(myenv(superThresholdIdxs(startIdx:endIdx))==max(myenv(superThresholdIdxs(startIdx:endIdx))));
% offset = offset(1)-1;
% putativeApPeakIdxs = [ putativeApPeakIdxs startIdx+offset];
% idx=endIdx+1;
% end
% length(putativeApPeakIdxs)
% figure;
% plot( myenv, 'b')
% hold on;
% plot( superThresholdIdxs(putativeApPeakIdxs), myenv(superThresholdIdxs(putativeApPeakIdxs)),'ro')
% tt(superThresholdIdxs(putativeApPeakIdxs))'
% tt(superThresholdIdxs(putativeApPeakIdxs))'*60
% sfnFigs
% 18/60
% startMinute=14+(18/60); endMinute=14+(46/60);
% inDelta=endMinute-startMinute;
% figure; plot(xpos,ypos,'Color', [.2 .2 .2 .2 ]);hold on;
% for ii=0:0.1:.9*inDelta
% txidx=round(alignmentLag*3+((startMinute+ii)*30*60:(endMinute+ii+.1)*30*60));
% tyidx=round(alignmentLag*3+((startMinute+ii)*30*60:(endMinute+ii+.1)*30*60));
% plot(xpos(txidx), ypos(tyidx));
% plot(xpos(txidx(1)), ypos(tyidx(1)), '^');
% end
% plot(xpos(alignmentLag*3+(startMinute*30*60)), ypos(alignmentLag*3+(startMinute*30*60)),'g.', 'MarkerSize', 16);
% plot(xpos(alignmentLag*3+(endMinute*30*60)), ypos(alignmentLag*3+(endMinute*30*60)),'mx', 'MarkerSize', 5);
% legend('all','seg. 1', 'brk. 1','seg. 2', 'brk. 2','seg. 3', 'brk. 3','seg. 4', 'brk. 4','seg. 5', 'brk. 5', 'start', 'end')
% title('Rat Position @ Minute 14 Seconds 18-46');
% xlabel('xpos');
% ylabel('ypos');
% startMinute=14+(15/60); endMinute=14+(46/60);
% inDelta=endMinute-startMinute;
% figure; plot(xpos,ypos,'Color', [.2 .2 .2 .2 ]);hold on;
% plot(xpos(alignmentLag*3+(startMinute*30*60)), ypos(alignmentLag*3+(startMinute*30*60)),'g.', 'MarkerSize', 18);
% plot(xpos(alignmentLag*3+(endMinute*30*60)), ypos(alignmentLag*3+(endMinute*30*60)),'mx', 'MarkerSize', 8);
% for ii=0:0.1:.9*inDelta
% txidx=round(alignmentLag*3+((startMinute+ii)*30*60:(endMinute+ii+.1)*30*60));
% tyidx=round(alignmentLag*3+((startMinute+ii)*30*60:(endMinute+ii+.1)*30*60));
% plot(xpos(txidx), ypos(tyidx));
% plot(xpos(txidx(1)), ypos(tyidx(1)), '^');
% end
% legend('all', 'start', 'end','seg. 1', 'brk. 1','seg. 2', 'brk. 2','seg. 3', 'brk. 3','seg. 4', 'brk. 4','seg. 5', 'brk. 5')
% legend('all', 'start', 'end','seg. 1', 'brk. 1','seg. 2', 'brk. 2','seg. 3', 'brk. 3','seg. 4', 'brk. 4','seg. 5', 'brk. 5', 'seg. 6')
% title('Rat Position @ Minute 14 Seconds 15-46');
% xlabel('xpos');
% ylabel('ypos');
% figure; plot(correctedCscfortyfour)
% 
% length(find(correctedCscfortyfour>2000))
% peakIdxsFortyFour=peakDetector(correctedCscfortyfour,2000,1,1);
% peakIdxsFortyFour=peakDetector(correctedCscfortyfour,2000,32,1);
% length(peakIdxsFortyFour)
% threshold = 2000; % currently arbitrary
% absoluteRefractorySamples = 32; % how many sample will we wait before accepting another super threshold crossing?
% thresholdExceededIdxs = find(correctedCsc(1:20000) > threshold);
% thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
% putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
% spikes=zeros(48,length(putativeSpikeIdxs));
% for spikesIdx = 1:length(putativeSpikeIdxs)
% spikes(:,spikesIdx) = correctedCsc(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
% end
% figure; plot(spikes); %debugging
% thresholdExceededIdxs = find(correctedCsc > threshold);
% thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
% putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
% spikes=zeros(48,length(putativeSpikeIdxs));
% for spikesIdx = 1:length(putativeSpikeIdxs)
% spikes(:,spikesIdx) = correctedCsc(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
% end
% length(spikes)
% figure; plot(spikes);
% putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
% spikesSeven=zeros(48,length(putativeSpikeIdxs));
% for spikesIdx = 1:length(putativeSpikeIdxs)
% spikesSeven(:,spikesIdx) = correctedCsc(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
% end
% thresholdExceededIdxs = find(correctedCscfortyfour > threshold);
% thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
% putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
% spikesFortyfour=zeros(48,length(putativeSpikeIdxs));
% for spikesIdx = 1:length(putativeSpikeIdxs)
% spikesFortyfour(:,spikesIdx) = correctedCscfortyfour(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
% end
% figure; plot(spikesFortyfour); %debugging
% size(spikesFortyfour)
% size(spikesSeven)
% size(mean(spikesSeven))
% size(mean(spikesSeven'))
% figure; plot(mean(spikesSeven'))
% figure; plot(diff(spikesSeven(1)))
% figure; plot(diff(spikesSeven(1,:)))
% figure; plot(diff(spikesSeven(:,1)))
% size(max(spikesSeven))
% size((spikesSeven))
% size((spikesSeven'))



if 0

%% start here maze
close all; clear all;
basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/maze/'],[basedir '/nlx/maze/'],7)
% load the fscv data
daConc=loadTarheelCsvData([basedir '/fscv/maze/'],.993);
close all;

[ cscLFPSeven, nlxCscTimestampsSeven, cscHeaderSeven ] = csc2mat([basedir '/nlx/maze/CSC7.ncs']);
[ correctedCscSeven, idxsSeven, mxValuesSeven, meanCscWindowSeven ] = cscCorrection( cscLFPSeven(8*60*32000:end), nlxCscTimestampsSeven(8*60*32000:end) );


length(find(correctedCscSeven>2000))
peakIdxsSeven=peakDetector(correctedCscSeven,2000,1,1);
peakIdxsSeven=peakDetector(correctedCscSeven,2000,32,1);
length(peakIdxsSeven)

threshold = 2000; % currently arbitrary
absoluteRefractorySamples = 32; % how many sample will we wait before accepting another super threshold crossing?
thresholdExceededIdxs = find(correctedCscSeven > threshold);
thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
spikes=zeros(48,length(putativeSpikeIdxs));
for spikesIdx = 1:length(putativeSpikeIdxs)
    spikes(:,spikesIdx) = correctedCscSeven(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
end
%figure; plot(spikes); %debugging; this figure makes matlab angry.

% make metrics
metrics.max=max(spikes);
metrics.max=max(spikes);
metrics.maxLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.maxLocation(idx)=find(spikes(:,idx)==max(spikes(:,idx)));
end
metrics.min=min(spikes);
metrics.minLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
    metrics.minLocation(idx)=min(find(spikes(:,idx)==min(spikes(:,idx))));
end

metrics.width=abs(metrics.maxLocation-metrics.minLocation);
%amplitude
metrics.amplitude=metrics.max-metrics.min;
% average of signal
metrics.mean=mean(spikes);
% standard deviation of signal
metrics.std=std(spikes);
% median of signal
metrics.median=median(spikes);
for idx = 1:length(spikes)
metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end
metrics.median=median(spikes);
metrics.madam=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end

metrics.rmsSignal=sqrt(mean(spikes.^2));
metrics.rmsFreq=sqrt(sum(abs(fft(spikes)./length(spikes)).^2))
metrics.avgAbsVakue=mean(abs(spikes));
metrics.avgAbsValue=mean(abs(spikes));
metrics.medianAbsValue=median(abs(spikes));
metrics.madamMedianAbsValue=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.madamMedianAbsValue(idx)=median(abs(spikes(:,idx)-metrics.medianAbsValue(idx)));
end
metrics.sqrtEnergy=sqrt(sum(spikes.^2));
metrics.peakCurvyness=zeros(1,length(spikes));
for idx=1:length(spikes)
    % the min and the max here are in case there are more than one index
    tempIdx=min(metrics.maxLocation(idx))-2:max(metrics.maxLocation(idx))+2;
    if ( tempIdx(1) > 1 ) && ( tempIdx(end) <= length(spikes(:,idx) ) )
        secondDerivPeak=diff(diff(spikes(tempIdx,idx)));
        % is it negative? (i.e. convex pointing up, concave pointing down?)
        metrics.peakPointyness(idx)=mean(secondDerivPeak<0); % this should be 1
        % how curvy is it? maybe this tells us that?
        metrics.peakCurvyness(idx)=mean(secondDerivPeak);
    end
end
%figure;plot(spikes(:,21))
%plot(.5:46.5,diff(spikes(:,21)))
%plot(.5:45.5,diff(diff(spikes(:,21))))
% figure;plot(spikes(:,21));hold on;plot(1.5:47.5,diff(spikes(:,21)));plot(1.75:46.75,diff(diff(spikes(:,21))))
% figure; hist(metrics.max,100)
% figure; hist(metrics.rmsSignal,100)
% figure; hist(metrics.maxLocation,100)
% figure; hist(metrics.width,100)
% psuedo QA
metrics.group=zeros(1,length(metrics.max));
metrics.group(find(metrics.maxLocation>14))=1;
metrics.group(find((metrics.group>0).*(metrics.min<-500)))=1;
metrics.group(find((metrics.group>0).*(metrics.rmsFreq<1.5)))=1;
sum(metrics.group)/length(metrics.group)

goodSpikeIdxs=thresholdExceededIdxs(thresholdExceededIdxStarts);

sevenSpikeTimes=( (nlxCscTimestampsSeven(goodSpikeIdxs)-nlxCscTimestampsSeven(1)))/1e5; %ms
% 60 s/min * 32000 samples/s * 10 minutes
daConcPostPop=daConc(8*60*10+alignmentLag:end);
%figure; hist(daConcPostPop(round(sevenSpikeTimes)+1),100);
%7 seconds
% spike triggered average ...
before=10; after=50; % 100's of ms
daSpikeStack=zeros(length(sevenSpikeTimes), before+after+1 );
daConcPostPop=daConc(8*600:end);
for i=1:length(sevenSpikeTimes)
    daSpikeStack(i,:)=interp1(1:length(daConcPostPop),daConcPostPop,(sevenSpikeTimes(i)-before):(sevenSpikeTimes(i)+after) );
end
figure; hold on;
shift=min(nanmean(daSpikeStack));
timeAxis=(-before:after)/10;
meanofdata=nanmean(daSpikeStack);
stder=nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes));
fill_between_lines(timeAxis,meanofdata-stder-shift,meanofdata+stder-shift,[.6 .7 .9])
plot(timeAxis,meanofdata-shift);
%plot(timeAxis,nanmean(daSpikeStack)-(nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes)))-shift,'b');
%plot(timeAxis,nanmean(daSpikeStack)+(nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes)))-shift,'b');
title(['Spike Triggered Avg \Delta DA n=' num2str(length(sevenSpikeTimes)) ' spikes'])
xlabel('relative time (s)');
ylabel('\Delta DA (nM)');
legend('std err','mean');

end




%% start here platter
close all; clear all;
basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
alignmentLag=getFscvNlxAlignmentLag([basedir '/fscv/platter/'],[basedir '/nlx/platter/'],7)
% load the fscv data
daConc=loadTarheelCsvData([basedir '/fscv/platter/'],.993);
close all;

[ cscLFPSeven, nlxCscTimestampsSeven, cscHeaderSeven ] = csc2mat([basedir '/nlx/platter/CSC7.ncs']);
[ correctedCscSeven, idxsSeven, mxValuesSeven, meanCscWindowSeven ] = cscCorrection( cscLFPSeven(60*32000*10:end), nlxCscTimestampsSeven(60*32000*10:end) );


length(find(correctedCscSeven>2000))
peakIdxsSeven=peakDetector(correctedCscSeven,2000,1,1);
peakIdxsSeven=peakDetector(correctedCscSeven,2000,32,1);
length(peakIdxsSeven)

threshold = 2000; % currently arbitrary
absoluteRefractorySamples = 32; % how many sample will we wait before accepting another super threshold crossing?
thresholdExceededIdxs = find(correctedCscSeven > threshold);
thresholdExceededIdxStarts = find(diff(thresholdExceededIdxs) > absoluteRefractorySamples);
putativeSpikeIdxs = thresholdExceededIdxs(thresholdExceededIdxStarts);
spikes=zeros(48,length(putativeSpikeIdxs));
for spikesIdx = 1:length(putativeSpikeIdxs)
spikes(:,spikesIdx) = correctedCscSeven(putativeSpikeIdxs(spikesIdx)-16:putativeSpikeIdxs(spikesIdx)+31);
end
%figure; plot(spikes); %debugging; this figure makes matlab angry.

% make metrics
metrics.max=max(spikes);
metrics.max=max(spikes);
metrics.maxLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.maxLocation(idx)=find(spikes(:,idx)==max(spikes(:,idx)));
end
metrics.min=min(spikes);
metrics.minLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.minLocation(idx)=find(spikes(:,idx)==min(spikes(:,idx)));
end

metrics.width=abs(metrics.maxLocation-metrics.minLocation);
%amplitude
metrics.amplitude=metrics.max-metrics.min;
% average of signal
metrics.mean=mean(spikes);
% standard deviation of signal
metrics.std=std(spikes);
% median of signal
metrics.median=median(spikes);
for idx = 1:length(spikes)
metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end
metrics.median=median(spikes);
metrics.madam=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end

metrics.rmsSignal=sqrt(mean(spikes.^2));
metrics.rmsFreq=sqrt(sum(abs(fft(spikes)./length(spikes)).^2))
metrics.avgAbsVakue=mean(abs(spikes));
metrics.avgAbsValue=mean(abs(spikes));
metrics.medianAbsValue=median(abs(spikes));
metrics.madamMedianAbsValue=zeros(1,length(spikes));
for idx = 1:length(spikes)
metrics.madamMedianAbsValue(idx)=median(abs(spikes(:,idx)-metrics.medianAbsValue(idx)));
end
metrics.sqrtEnergy=sqrt(sum(spikes.^2));
metrics.peakCurvyness=zeros(1,length(spikes));
for idx=1:length(spikes)
    % the min and the max here are in case there are more than one index
    tempIdx=min(metrics.maxLocation(idx))-2:max(metrics.maxLocation(idx))+2;
    if ( tempIdx(1) > 1 ) && ( tempIdx(end) <= length(spikes(:,idx) ) )
        secondDerivPeak=diff(diff(spikes(tempIdx,idx)));
        % is it negative? (i.e. convex pointing up, concave pointing down?)
        metrics.peakPointyness(idx)=mean(secondDerivPeak<0); % this should be 1
        % how curvy is it? maybe this tells us that?
        metrics.peakCurvyness(idx)=mean(secondDerivPeak);
    end
end
figure;plot(spikes(:,21))
plot(.5:46.5,diff(spikes(:,21)))
plot(.5:45.5,diff(diff(spikes(:,21))))
figure;plot(spikes(:,21));hold on;plot(1.5:47.5,diff(spikes(:,21)));plot(1.75:46.75,diff(diff(spikes(:,21))))
figure; hist(metrics.max,100)
figure; hist(metrics.rmsSignal,100)
figure; hist(metrics.maxLocation,100)
figure; hist(metrics.width,100)
% psuedo QA
metrics.group=zeros(1,length(metrics.max));
metrics.group(find(metrics.maxLocation>14))=1;
metrics.group(find((metrics.group>0).*(metrics.min<-500)))=1;
metrics.group(find((metrics.group>0).*(metrics.rmsFreq<1.5)))=1;
sum(metrics.group)/length(metrics.group)

goodSpikeIdxs=thresholdExceededIdxs(thresholdExceededIdxStarts(find(metrics.group)));

sevenSpikeTimes=( (nlxCscTimestampsSeven(goodSpikeIdxs)-nlxCscTimestampsSeven(1)))/1e5; %ms
% 60 s/min * 32000 samples/s * 10 minutes
daConcPostPop=daConc(60*10*10+alignmentLag:end);
figure; hist(daConcPostPop(round(sevenSpikeTimes)+1),100);
%7 seconds
% spike triggered average ...
before=50; after=50; % 100's of ms
daSpikeStack=zeros(length(sevenSpikeTimes), before+after+1 );
for i=1:length(sevenSpikeTimes)
    daSpikeStack(i,:)=interp1(1:length(daConcPostPop),daConcPostPop,(sevenSpikeTimes(i)-before):(sevenSpikeTimes(i)+after) );
end
figure; hold on;
shift=min(nanmean(daSpikeStack));
timeAxis=(-before:after)/10;
meanofdata=nanmean(daSpikeStack);
stder=nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes));
fill_between_lines(timeAxis,meanofdata-stder-shift,meanofdata+stder-shift,[.6 .7 .9])
plot(timeAxis,meanofdata-shift);
%plot(timeAxis,nanmean(daSpikeStack)-(nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes)))-shift,'b');
%plot(timeAxis,nanmean(daSpikeStack)+(nanstd(daSpikeStack)/sqrt(length(sevenSpikeTimes)))-shift,'b');
title(['Spike Triggered Avg \Delta DA n=' num2str(length(sevenSpikeTimes)) ' spikes'])
xlabel('relative time (s)');
ylabel('\Delta DA (nM)');
legend('std err','mean');
