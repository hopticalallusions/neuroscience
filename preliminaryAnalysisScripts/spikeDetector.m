

% spike detection
% I think Tad said that spikes are usually detected at 50 uV and above, but
% that would be a lot of points?
% line([0 9600],[((50e-6)/0.000000061037020770982053) ((50e-6)/0.000000061037020770982053)],'color','k','linestyle','--')
%
% there must be a faster way to do this.
%
superThresholdIdxs = find( correctedCsc > ((50e-6)/0.000000061037020770982053) );
negSuperThresholdIdxs = find( correctedCsc < -((50e-6)/0.000000061037020770982053) );
putativeApPeakIdxs = [];
putativeSpikeWaveforms = [];
putativeApValleyIdxs = [];
putativeSpikeHeights = [];
idx = 1;
while idx < length(superThresholdIdxs)
    % build a window of continuous indicies that are the peak of the AP in
    % the CSC
    startIdx = idx;
    while (idx+1 < length(superThresholdIdxs) ) && (superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)
        idx = idx + 1;
    end
    endIdx = idx;
    % find the max value inside that window and claim it is the peak of the spike.
    offset = find(correctedCsc(superThresholdIdxs(startIdx:endIdx))==max(correctedCsc(superThresholdIdxs(startIdx:endIdx))));
    offset = offset(1)-1;
    putativeApPeakIdxs = [ putativeApPeakIdxs startIdx+offset];
    % excise the spike window and (1) store it (2) find the valley (3)
    % record spike height
    cscidx = superThresholdIdxs(startIdx+offset);
    if ( cscidx-12 > 1 ) && ( length(correctedCsc) >= cscidx+19 )
        putativeSpikeWaveforms = [ putativeSpikeWaveforms , correctedCsc([cscidx-12 : cscidx+19 ]) ];
        spikeWaveform = correctedCsc([cscidx-12 : cscidx+19 ]);
        valleyVolts = min(spikeWaveform);
        putativeApValleyIdxs = [ putativeApValleyIdxs startIdx+offset+find(valleyVolts == spikeWaveform)-1 ];
        putativeSpikeHeights = [ putativeSpikeHeights max(spikeWaveform)-min(spikeWaveform) ];
    end
    % keep going
    idx=endIdx+1;
end
% the code above has bad data for valley indices

valleyOffset = zeros(1,length(putativeSpikeWaveforms));
for id=1:length(putativeSpikeWaveforms)
    peakIdx = find(max(putativeSpikeWaveforms(:,id))==putativeSpikeWaveforms(:,id));
    valleyOffset(id) = find(min(putativeSpikeWaveforms(peakIdx:end,id))==putativeSpikeWaveforms(:,id)) - peakIdx ;
end

%13 is the peak in putativeSpikeWaveforms
size(min(putativeSpikeWaveforms(:,15:25)))


clusterOneIdxs=find((max(putativeSpikeWaveforms(15:25,:))>0).*(min(putativeSpikeWaveforms(15:25,:))<-2530).*(min(putativeSpikeWaveforms(15:25,:))>-7150).*(putativeSpikeWaveforms(13,:)>1700).*(putativeSpikeWaveforms(13,:)<5700))

clusterOneIdxs=find((min(putativeSpikeWaveforms(15:25,:))<-2530).*(min(putativeSpikeWaveforms(15:25,:))>-7150).*(putativeSpikeWaveforms(13,:)>1700).*(putativeSpikeWaveforms(13,:)<5700))

vv=hist3([putativeSpikeWaveforms(13,find(min(putativeSpikeWaveforms(15:25,:))<-2530))' min(putativeSpikeWaveforms(15:25,find(min(putativeSpikeWaveforms(15:25,:))<-2530)))'], [71 71]); 
figure; 
colormap('jet'); 
imagesc(flipud(vv')); 
colorbar;



% look, it works!
figure;
plot( correctedCsc(1:3200), 'b')
hold on;
plot( superThresholdIdxs(putativeApPeakIdxs(1:34)), correctedCsc(superThresholdIdxs(putativeApPeakIdxs(1:34))),'ro')


% trying to figure out a less silly way to do the above, plus valley
% detection
figure;
subplot(4,1,1);
plot( cumsum(correctedCsc(1:1000)), 'Color', [ .7 .1 .9 ]);
legend('integ.Csc');
subplot(4,1,2);
plot( correctedCsc(1:1000), 'Color', [ .1 .6 .7 ]);
legend('corctd Csc');
subplot(4,1,3);
plot( [0; diff(correctedCsc(1:1000))], 'Color', [ .9 .2 0 ]);
legend('1stDer Csc');
subplot(4,1,4);
plot( [ 0; 0; diff(diff(correctedCsc(1:1000)))], 'Color', [ .1 .9 .1 ] );
legend('2ndDer Csc');
