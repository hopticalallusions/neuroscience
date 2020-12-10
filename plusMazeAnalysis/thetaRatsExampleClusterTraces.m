

dir = '/Volumes/Seagate Expansion Drive/theta12/day12/';
ttFilenames={ 'TT14_recut_tt4_part1.ntt' 'TT16_recut_tt10_part1.ntt' 'TT29_recut.ntt' };
ttIdx=2;
[ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ dir ttFilenames{ttIdx} ]);

% plot waveforms
whichCell=1;
cellIndexes = find(cellNumber==whichCell);

figure;
for ii=1:5000
    whichEvent = cellIndexes( 1+floor(length(cellIndexes)*rand(1)) );
    if spikeWaveforms(whichEvent,4,8) > threshold
        subplot(2,2,1); hold on; temp=(spikeWaveforms(whichEvent,1,:)); plot(-7:24,temp(:), 'Color', [ 0 0 0 .05 ]); xlim([-7 24]);  % plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
        subplot(2,2,2); hold on; temp=(spikeWaveforms(whichEvent,2,:)); plot(-7:24,temp(:), 'Color', [ 0 0 0 .05 ]); xlim([-7 24]);  % plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
        subplot(2,2,3); hold on; temp=(spikeWaveforms(whichEvent,3,:)); plot(-7:24,temp(:), 'Color', [ 0 0 0 .05 ]); xlim([-7 24]);  % plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
        subplot(2,2,4); hold on; temp=(spikeWaveforms(whichEvent,4,:)); plot(-7:24,temp(:), 'Color', [ 0 0 0 .05 ]); xlim([-7 24]);  % plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
    end
end

threshold=95;
isPeakAligned = cellNumber<0;

for ii=1:length(cellIndexes)
    whichEvent = cellIndexes( ii );
    if spikeWaveforms(whichEvent,2,8) >  threshold
        isPeakAligned(whichEvent)=true;
    end
end

cellIndexes = find( ((cellNumber==whichCell).*isPeakAligned)>0 );


figure;
temp=spikeWaveforms(cellIndexes,:,:);
ttYLims=[ min(temp(:)) max(temp(:)) ];
ttYLims=[ -200 200 ];
subplot(2,2,1); hold off;
temp=mean(spikeWaveforms(cellIndexes,1,:));
tempStd=std(spikeWaveforms(cellIndexes,1,:));
fill_between_lines( [-7:24],[temp(:)-tempStd(:)]',[temp(:)+tempStd(:)]',[ .8 .8 .8 ]);
hold on;
plot(-7:24,temp(:),'k', 'LineWidth', 2); xlim([-7 24]);
ylim(ttYLims);
title('channel 0')
xlabel('time relative to peak (samples; 1 ms window)');
ylabel('\muV');
subplot(2,2,2); hold off;
temp=mean(spikeWaveforms(cellIndexes,2,:));
tempStd=std(spikeWaveforms(cellIndexes,2,:));
fill_between_lines( [-7:24],[temp(:)-tempStd(:)]',[temp(:)+tempStd(:)]',[ .8 .8 .8 ]);
hold on;
plot(-7:24,temp(:),'k', 'LineWidth', 2); xlim([-7 24]);
ylim(ttYLims);
title('channel 1')
xlabel('time relative to peak (samples; 1 ms window)');
ylabel('\muV');
subplot(2,2,3); hold off;
temp=mean(spikeWaveforms(cellIndexes,3,:));
tempStd=std(spikeWaveforms(cellIndexes,3,:));
fill_between_lines( [-7:24],[temp(:)-tempStd(:)]',[temp(:)+tempStd(:)]',[ .8 .8 .8 ]);
hold on;
plot(-7:24,temp(:),'k', 'LineWidth', 2); xlim([-7 24]);
ylim(ttYLims);
title('channel 2')
xlabel('time relative to peak (samples; 1 ms window)');
ylabel('\muV');
subplot(2,2,4); hold off;
temp=mean(spikeWaveforms(cellIndexes,4,:));
tempStd=std(spikeWaveforms(cellIndexes,4,:));
fill_between_lines( [-7:24],[temp(:)-tempStd(:)]',[temp(:)+tempStd(:)]',[ .8 .8 .8 ]);
hold on;
plot(-7:24,temp(:),'k', 'LineWidth', 2); xlim([-7 24]);
ylim(ttYLims);
title('channel 3')
xlabel('time relative to peak (samples; 1 ms window)');
ylabel('\muV');