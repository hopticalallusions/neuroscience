%% CLUSTER EVALUATION PLOT
% the point of this script which will hopefully become a function is to
% visually summarize clusters in tetrode files

function clusterEvaluator( path, ttFilenames, dateStr, ratName, behaviorData )

    subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

    
    
    
    %% PLOTTING ROUTINES

    gcf(1)=figure(1);
    gcf(2)=figure(2);

    path
    dateStr
    
    if ~isempty(ttFilenames)
        tetrodeExtension = ttFilenames{1}(end-4:end);
    end
    
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*a.ntt']);
        tetrodeExtension = '.ntt';
    end
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*a.NTT']);
        tetrodeExtension = '.NTT';
    end
     if isempty(ttFilenames)
        ttFilenames = dir( [path '*cut.ntt']);
        tetrodeExtension = '.ntt';
    end
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*cut.NTT']);
        tetrodeExtension = '.NTT';
    end
    if isempty(behaviorData)
        behaviorData = [];
    end

    
    cscFilenames = dir( [path '*ncs']);
    [~,lfpTimestamps]=csc2mat([path cscFilenames(1).name]);
    lfpTimestampsStart = lfpTimestamps(1); 
    lfpTimestampSecondsEnd  = (lfpTimestamps(end)-lfpTimestamps(1))/1e6;
    clear lfpTimestamps;
    
    
    for ttIdx=1:length(ttFilenames)
        try
            [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber, ~, adbitmicrovolts ]=ntt2mat([ path ttFilenames{ttIdx} ]);
        catch
            [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber, ~, adbitmicrovolts ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
        end
        
        spikeTimesSeconds = (spiketimes-lfpTimestampsStart)/1e6;
        %
        for whichCell = 1:max(cellNumber)
                if length(whichCell) > 10000
                    subindex = (1+floor(length(cellNumber)*rand(10000,1)));
                    scaledAlpha = 0.1;
                else
                    subindex = find(whichCell==cellNumber);
                    scaledAlpha = 0.1 ;% * 10000/sum(cellNumber==whichCell);
                end
                % plot waveforms
                temp=(spikeWaveforms((subindex),:,:)); %ttLims =  % ttYLims=[ min(temp(:)) max(temp(:)) ]; 
                %
                subplot(4,8,1); plot(-7:24,squeeze(spikeWaveforms((subindex),1,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch0 '); ylim([ -2^15*adbitmicrovolts(1)  2^15*adbitmicrovolts(1) ]);
                subplot(4,8,2); plot(-7:24,squeeze(spikeWaveforms((subindex),2,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch1 '); ylim([ -2^15*adbitmicrovolts(2)  2^15*adbitmicrovolts(2) ]);
                subplot(4,8,3); plot(-7:24,squeeze(spikeWaveforms((subindex),3,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch2 '); ylim([ -2^15*adbitmicrovolts(3)  2^15*adbitmicrovolts(3) ]);
                subplot(4,8,4); plot(-7:24,squeeze(spikeWaveforms((subindex),4,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch3 '); ylim([ -2^15*adbitmicrovolts(4)  2^15*adbitmicrovolts(4) ]);
                %
                subplot(4,8,9); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim([ -2^15*adbitmicrovolts(1)  2^15*adbitmicrovolts(1) ]);
                subplot(4,8,10); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim([ -2^15*adbitmicrovolts(2)  2^15*adbitmicrovolts(2) ]);
                subplot(4,8,11); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim([ -2^15*adbitmicrovolts(3)  2^15*adbitmicrovolts(3) ]);
                subplot(4,8,12); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim([ -2^15*adbitmicrovolts(4)  2^15*adbitmicrovolts(4) ]);

                % plot cell autocorrelegram
                subplot(4,8,5);
                [ xcorrValues, lagtimes] = acorrEventTimes( spikeTimesSeconds(cellNumber==whichCell) );
                plot( lagtimes, xcorrValues, 'k' ); title('spk autocorrelegram')
                % plot ISI
                subplot(4,8,6); hold off; histogram( real(log10(diff(spikeTimesSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
                % plot features
                % peak vs peak
                subplot(4,8, 7); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-p1'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([ -20 2^15*adbitmicrovolts(2) ]);  %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
                subplot(4,8, 8); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-p2'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([ -20 2^15*adbitmicrovolts(3) ]);   %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
                subplot(4,8,13); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-p3'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([ -20 2^15*adbitmicrovolts(4) ]);   %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
                subplot(4,8,14); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-p2'); xlim([ -20 2^15*adbitmicrovolts(2) ]); ylim([ -20 2^15*adbitmicrovolts(3) ]);   %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
                subplot(4,8,15); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-p3'); xlim([ -20 2^15*adbitmicrovolts(2) ]); ylim([ -20 2^15*adbitmicrovolts(4) ]);   %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
                subplot(4,8,16); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-p3'); xlim([ -20 2^15*adbitmicrovolts(3) ]); ylim([ -20 2^15*adbitmicrovolts(4) ]);   %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
                % peak vs valley
                subplot(4,8,17); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v0'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([  -2^15*adbitmicrovolts(1) 20 ]);   %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,18); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v1'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([  -2^15*adbitmicrovolts(2) 20 ]);  %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,19); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v2'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([  -2^15*adbitmicrovolts(3) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,20); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v3'); xlim([ -20 2^15*adbitmicrovolts(1) ]); ylim([  -2^15*adbitmicrovolts(4) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,21); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v0'); xlim([ -20 2^15*adbitmicrovolts(2) ]); ylim([  -2^15*adbitmicrovolts(1) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,22); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v1'); xlim([ -20 2^15*adbitmicrovolts(2) ]); ylim([  -2^15*adbitmicrovolts(2) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,23); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v2'); xlim([ -20 2^15*adbitmicrovolts(2) ]); ylim([  -2^15*adbitmicrovolts(3) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,24); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v3'); xlim([ -20 2^15*adbitmicrovolts(2) ]); ylim([  -2^15*adbitmicrovolts(4) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,25); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v0'); xlim([ -20 2^15*adbitmicrovolts(3) ]); ylim([  -2^15*adbitmicrovolts(1) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,26); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v1'); xlim([ -20 2^15*adbitmicrovolts(3) ]); ylim([  -2^15*adbitmicrovolts(2) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,27); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v2'); xlim([ -20 2^15*adbitmicrovolts(3) ]); ylim([  -2^15*adbitmicrovolts(3) 20 ]); %alpha(5/spikesInCluster); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,28); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v3'); xlim([ -20 2^15*adbitmicrovolts(3) ]); ylim([  -2^15*adbitmicrovolts(4) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,29); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v0'); xlim([ -20 2^15*adbitmicrovolts(4) ]); ylim([  -2^15*adbitmicrovolts(1) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,30); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v2'); xlim([ -20 2^15*adbitmicrovolts(4) ]); ylim([  -2^15*adbitmicrovolts(2) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,31); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v3'); xlim([ -20 2^15*adbitmicrovolts(4) ]); ylim([  -2^15*adbitmicrovolts(3) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
                subplot(4,8,32); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v4'); xlim([ -20 2^15*adbitmicrovolts(4) ]); ylim([  -2^15*adbitmicrovolts(4) 20 ]); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])

    %             all
    %             figure;
    %             subAllIdx = ( floor(rand(10000,1)*length(cellNumber)))+1;
    %             scatter( max(squeeze(spikeWaveforms( subAllIdx, 1, :))'), max(squeeze(spikeWaveforms( subAllIdx,2,:))'), 1, 'filled', 'k' );
    %             hold on;
    %             scatter( max(squeeze(spikeWaveforms(( cellNumber==whichCell )                   ,1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 1, 'filled', 'r' );
    %             subplot(4,8,31);  xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
%                gcasub=subplot(4,8,32);  hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); colormap([ 1 1 1; colormap('jet')])
%                axis ij
%                set(gcasub,'Ydir','reverse')
                %
                try
                    print(gcf(1), [ '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEvalRevised/' ratName '_featureMap_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                catch
                    print(gcf(1), [ '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEvalRevised/' ratName '_featureMap_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                end
                clf(gcf(1));
                %
                figure(gcf(1)); clf;
%%                %            
%                 % plot feature heatmap
%                 %
%                 % peak vs peak
%                 subplot(4,8, 7); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p0-p1'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8, 8); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p0-p2'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,13); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p0-p3'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,14); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p1-p2'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,15); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p2-p3'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,16); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p2-p3'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 % peak vs valley
%                 subplot(4,8,17); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p0-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,18); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p0-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,19); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p0-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,20); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p0-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,21); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p1-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,22); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p1-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,23); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p1-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,24); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p1-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,25); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p2-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,26); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p2-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,27); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p2-v2'); %alpha(5/spikesInCluster); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,28); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p2-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,29); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p3-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,30); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p3-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,31); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p3-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,32); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p3-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 %
%                 colormap([ 1 1 1; colormap('jet')]);
%                 %
%                 try
%                     print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName  '_featureHeat_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
%                 catch
%                     print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName  '_featureHeat_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
%                 end
%                 clf(gcf(1));
%%                %
                figure(gcf(1)); clf;
                subplot(5,1,1); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p0');
                subplot(5,1,2); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p1');
                subplot(5,1,3); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p2');
                subplot(5,1,4); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p3');
                subplot(5,1,5); histogram( spikeTimesSeconds(cellNumber==whichCell), 0:max(ceil(lfpTimestampSecondsEnd)) ) ; ylabel('spike rate (Hz)');  xlim([0 max(ceil(lfpTimestampSecondsEnd))]);
                hold on;
                
                try scatter(   behaviorData.toMazeTimes,   zeros(size(behaviorData.toMazeTimes)), '>', 'g', 'filled' ); catch; end;
                try scatter(   behaviorData.rewardTimes,   zeros(size(behaviorData.rewardTimes)), 'o', 'b', 'filled' ); catch; end;
                

                try scatter( behaviorData.rewardTimes(behaviorData.decisionError==0), ones(size(behaviorData.decisionError(behaviorData.decisionError==0))), 'x', 'r' ); catch; end;
                try scatter( behaviorData.rewardTimes(behaviorData.decisionError==1), ones(size(behaviorData.decisionError(behaviorData.decisionError==1))), 'd', 'g' ); catch; end;
                
                try scatter(     behaviorData.jumpTimes,     zeros(size(behaviorData.jumpTimes)), '^', 'm', 'filled' ); catch; end;
                try scatter( behaviorData.toBucketTimes, zeros(size(behaviorData.toBucketTimes)), 's', 'r', 'filled' ); catch; end;
                    
                
                
                
                try
                    print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEvalRevised/' ratName  '_peakTimeseries_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                catch
                    print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEvalRevised/' ratName  '_peakTimeseries_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
                end
                clf(gcf(1));
        end
                %%
%             else
%                 warning([ ' not enough spikes w/ ' num2str(sum(cellNumber==whichCell)) ]);
%             end   
        
        
        
%         
%         for whichCell=1:max(cellNumber)
%             spikesInCluster = sum(cellNumber==whichCell);
%             if ( spikesInCluster > 200 ) && ( spikesInCluster < 30000 )
% %%              %
%                 figure(gcf(1)); clf;
%                 % cell subindex
%                 if sum(cellNumber==whichCell) > 5000
%                     subindex = find(cellNumber==whichCell);
%                     subindex = subindex(1+floor(length(subindex)*rand(5000,1)));
%                     scaledAlpha = 0.1;
%                 else
%                     subindex = (cellNumber==whichCell);
%                     scaledAlpha = 0.1 ;% * 10000/sum(cellNumber==whichCell);
%                 end
%                 % plot waveforms
%                 temp=(spikeWaveforms((subindex),:,:)); ttYLims=[ min(temp(:)) max(temp(:)) ]; 
%                 %
%                 subplot(4,8,1); plot(-7:24,squeeze(spikeWaveforms((subindex),1,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch0 '); ylim(ttYLims);
%                 subplot(4,8,2); plot(-7:24,squeeze(spikeWaveforms((subindex),2,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch1 '); ylim(ttYLims);
%                 subplot(4,8,3); plot(-7:24,squeeze(spikeWaveforms((subindex),3,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch2 '); ylim(ttYLims);
%                 subplot(4,8,4); plot(-7:24,squeeze(spikeWaveforms((subindex),4,:)),'Color', [ 0 0 0 scaledAlpha ]); xlim([-7 24]); title('ch3 '); ylim(ttYLims);
%                 %
%                 subplot(4,8,9); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
%                 subplot(4,8,10); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),2,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),2,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch1 '); ylim(ttYLims);
%                 subplot(4,8,11); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),3,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),3,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch2 '); ylim(ttYLims);
%                 subplot(4,8,12); hold off; temp=mean(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)); xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),4,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),4,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end; title('ch3 '); ylim(ttYLims);
% 
%                 % plot cell autocorrelegram
%                 subplot(4,8,5);
%                 [ xcorrValues, lagtimes] = acorrEventTimes( spikeTimesSeconds(cellNumber==whichCell) );
%                 plot( lagtimes, xcorrValues, 'k' ); title('spk autocorrelegram')
%                 % plot ISI
%                 subplot(4,8,6); hold off; histogram( real(log10(diff(spikeTimesSeconds(cellNumber==whichCell).*1000))) ,-0.25:.1:5); xlim([ -0.25 5 ]); title('ISI   log10(ms)')
%                 % plot features
%                 % peak vs peak
%                 subplot(4,8, 7); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-p1'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8, 8); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-p2');  %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,13); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-p3');  %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,14); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-p2');  %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,15); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-p3');  %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 subplot(4,8,16); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-p3');  %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
%                 % peak vs valley
%                 subplot(4,8,17); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v0');  %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,18); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v1');  %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,19); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,20); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p0-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,21); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,22); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,23); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,24); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p1-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,25); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,26); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,27); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v2'); %alpha(5/spikesInCluster); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,28); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p2-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,29); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,30); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,31); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
%                 subplot(4,8,32); hold off; scatter( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, 'filled', 'k' ); alpha(0.05); title('p3-v4'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% 
%     %             all
%     %             figure;
%     %             subAllIdx = ( floor(rand(10000,1)*length(cellNumber)))+1;
%     %             scatter( max(squeeze(spikeWaveforms( subAllIdx, 1, :))'), max(squeeze(spikeWaveforms( subAllIdx,2,:))'), 1, 'filled', 'k' );
%     %             hold on;
%     %             scatter( max(squeeze(spikeWaveforms(( cellNumber==whichCell )                   ,1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 1, 'filled', 'r' );
%     %             subplot(4,8,31);  xlim([-7 24]); hold on; tempStd=std(spikeWaveforms((cellNumber==whichCell),1,:)); plot(-7:24,temp(:)+tempStd(:), '--', 'Color', [ .8 .4 .4]); plot(-7:24,temp(:)-tempStd(:), '--', 'Color', [ .8 .4 .4]);     tempPctl=prctile(spikeWaveforms((cellNumber==whichCell),1,:),[2.5 25 50 75 97.5]); for ll=1:5; temp=tempPctl(ll,1,:); plot(-7:24,temp(:), ':', 'Color', [ .4 .4 .4]); end;  title('ch0 '); ylim(ttYLims);
% %                gcasub=subplot(4,8,32);  hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); colormap([ 1 1 1; colormap('jet')])
% %                axis ij
% %                set(gcasub,'Ydir','reverse')
%                 %
%                 try
%                     print(gcf(1), [ '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName '_featureMap_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
%                 catch
%                    print(gcf(1), [ '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName '_featureMap_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
%                 end
%                 clf(gcf(1));
%                 %
%                 figure(gcf(1)); clf;
% %%                %            
% %                 % plot feature heatmap
% %                 %
% %                 % peak vs peak
% %                 subplot(4,8, 7); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p0-p1'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
% %                 subplot(4,8, 8); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p0-p2'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
% %                 subplot(4,8,13); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p0-p3'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
% %                 subplot(4,8,14); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p1-p2'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
% %                 subplot(4,8,15); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p2-p3'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
% %                 subplot(4,8,16); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p2-p3'); %ylim([ -2000 32000 ]); xlim([ -2000 32000 ])
% %                 % peak vs valley
% %                 subplot(4,8,17); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p0-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,18); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p0-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,19); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p0-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,20); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p0-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,21); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p1-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,22); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p1-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,23); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p1-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,24); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p1-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,25); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p2-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,26); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p2-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,27); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p2-v2'); %alpha(5/spikesInCluster); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,28); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p2-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,29); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3 )); title('p3-v0'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,30); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3 )); title('p3-v1'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,31); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3 )); title('p3-v2'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 subplot(4,8,32); hold off; imagesc(twoDHistogram( max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), min(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3 )); title('p3-v3'); %xlim([ -2000 32000 ]); ylim([ -32000 2000 ])
% %                 %
% %                 colormap([ 1 1 1; colormap('jet')]);
% %                 %
% %                 try
% %                     print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName  '_featureHeat_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
% %                 catch
% %                     print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName  '_featureHeat_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
% %                 end
% %                 clf(gcf(1));
% %%                %
%                 figure(gcf(1)); clf;
%                 subplot(5,1,1); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),1,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p0');
%                 subplot(5,1,2); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),2,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p1');
%                 subplot(5,1,3); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),3,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p2');
%                 subplot(5,1,4); scatter( spikeTimesSeconds(cellNumber==whichCell)', max(squeeze(spikeWaveforms((cellNumber==whichCell),4,:))'), 3, '.', 'k'); alpha(.2); xlim([0 max(ceil(lfpTimestampSecondsEnd))]); ylabel('p3');
%                 subplot(5,1,5); histogram( spikeTimesSeconds(cellNumber==whichCell), 0:max(ceil(lfpTimestampSecondsEnd)) ) ; ylabel('spike rate (Hz)');  xlim([0 max(ceil(lfpTimestampSecondsEnd))]);
%                 hold on;
%                 
%                 scatter(   behaviorData.toMazeTimes,   zeros(size(behaviorData.toMazeTimes)), '>', 'g', 'filled' );
%                 scatter(   behaviorData.rewardTimes,   zeros(size(behaviorData.rewardTimes)), 'o', 'b', 'filled' );
%                 
%                 scatter( behaviorData.rewardTimes(behaviorData.decisionError==0), ones(size(behaviorData.decisionError(behaviorData.decisionError==0))), 'x', 'r' );
%                 scatter( behaviorData.rewardTimes(behaviorData.decisionError==1), ones(size(behaviorData.decisionError(behaviorData.decisionError==1))), 'd', 'g' );
%                 
%                 scatter(     behaviorData.jumpTimes,     zeros(size(behaviorData.jumpTimes)), '^', 'm', 'filled' );
%                 scatter( behaviorData.toBucketTimes, zeros(size(behaviorData.toBucketTimes)), 's', 'r', 'filled' );
%                     
%                 
%                 
%                 
%                 try
%                     print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName  '_peakTimeseries_' dateStr  '_' strrep(ttFilenames{ttIdx},tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
%                 catch
%                     print(gcf(1), [  '/Volumes/AGHTHESIS2/rats/summaryFigures/clusterEval/' ratName  '_peakTimeseries_' dateStr  '_' strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_cluster_' num2str(whichCell) '_.png'],'-dpng','-r200');
%                 end
%                 clf(gcf(1));
% %%
%             else
%                 warning([ ' not enough spikes w/ ' num2str(sum(cellNumber==whichCell)) ]);
%             end


        end
end

    
%end



% figure; surf(twoDHistogram( floor(max(squeeze(spikeWaveforms(:,3,:))'))+1, floor(max(squeeze(spikeWaveforms(:,4,:))'))+1, 2^7));
% colormap( [ 1 1 1; colormap('jet')]);

