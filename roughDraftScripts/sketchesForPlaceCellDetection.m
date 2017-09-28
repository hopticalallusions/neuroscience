%% load data
dir='/Volumes/BlueMiniSeagateData/DA5/day1/Day1_plusmaze_habituation/';
[ ~, spiketimes, spikeheader, ~, cellNumber ]=ntt2mat([ dir 'TT2cut.NTT' ]);
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);

[ lfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC1.ncs']); % has good strong theta
% these CSC files weren't split, so the data file is too long. the
% following corrects this problem :
lfp=lfp(lfpTimestamps<=max(xytimestamps)); lfpTimestamps=lfpTimestamps(lfpTimestamps<=max(xytimestamps)); 

% figure; plot( (lfpTimestamps-lfpTimestamps(1))/60e6, lfp );

% [ lfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC4.ncs']); % has some theta
% figure; plot( (lfpTimestamps-lfpTimestamps(1))/60e6, lfp );
% [ lfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC24.ncs']); % has some theta
% figure; plot( (lfpTimestamps-lfpTimestamps(1))/60e6, lfp );
% [ lfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC28.ncs']); % has theta
% figure; plot( (lfpTimestamps-lfpTimestamps(1))/60e6, lfp );
% [ lfp, lfpTimestamps, lfpHeader ] = csc2mat([ dir 'CSC47.ncs']); % has nice clean theta
% figure; plot( (lfpTimestamps-lfpTimestamps(1))/60e6, lfp );


%% evaluate cell characteristics



%% set parameter values
xyFramesPerSecond = 29.97;
xyTimesForPlots = (xytimestamps-xytimestamps(1))/1e6; % seconds

% at 12.7 minutes, we throw him in the bucket until 24.25 minutes
mazeStartIdx = 1;
bucketStartIdx = 26289;
% on this first day, we just let him run around for 12 minutes, then put him in the bucket.

%% plot the location preferences of the rat at various epochs
plotTwoDHistogramByEpoch( xpos, ypos, 5)

%% plot a 3D version of the rat's trajectory in time 
figure; plot3((xytimestamps-xytimestamps(1))/60e6,xpos,ypos);

%% smooth the speed out
% estimating from the graph of the locations
% sqrt((512-137).^2+(365-53).^2) = ~488 px per long arm of the plus maze;
% 218cm
pxPerCm = 2.385;
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);

figure; subplot( 1, 8, 1:7 ); plot( xyTimesForPlots, speed ); title('speed plot'); xlabel('time (s)'); ylabel('speed (cm/s)'); axis tight;
subplot( 1, 8, 8); [yy,xx]=hist(speed, 0:3:90 ); plot(yy/sum(yy),xx); title('speed PDF'); xlabel('prob.');

%% build index from spike times to video data

%sizeColor = 1./(1+exp(4-(smoothedSpeedEstimate(idxs)))); % sigmoid around the firings such that ~7 is 95th percentile
%figure; scatter(xpos(idxs),ypos(idxs), 20*sizeColor, sizeColor, 'o', 'Filled', 'MarkerEdgeColor', 'k' ); %'MarkerFaceAlpha', 0.2, 'MarkerEdgeAlpha', 0.2,

% fastEnoughIdxs=smoothedSpeedEstimate(idxs)>5;
% figure; hold on; scatter(xpos,ypos,'k','filled','MarkerFaceAlpha',0.01,'MarkerEdgeAlpha', 0); 
% plot(xpos(idxs(fastEnoughIdxs)), ypos(idxs(fastEnoughIdxs)), 'g+' ); 
% fastEnoughIdxs=spikeTriggeredSpeedEstimate>5; plot(xpos(idxs(fastEnoughIdxs)), ypos(idxs(fastEnoughIdxs)), 'ro' );



% Muller & Kubie 1989; each pixel (spatial bin) contained 3.4 (x) x 2.8 (Y) cm space
% for an equivalent size, this would be approximately 8 px by 6.8 px
% interestingly, this is approximately equal to the maximum
% information value in the binResolution X spee exclusion parameter sweep


% TODO -- what happens when these parameters are varied?
% this is probably a good metric to run for all of these... it is
% relatively fast and informative; cell # 4 suggests that low bin size
% always increases the metric, information is sensitive to bin size,
% sparsity less so; around 5 cm/s there is an inflection, so 7 cm/s should
% be good; the optimal parameters appeared to be speed = 8 cm/s was best,
% bin = 11 px per bin


% Muller & Kubie 1989 worry a lot about their camera position recording
% equipment; it has delays and other weirdness; we don't worry about this
% so much because our camers are much better than theirs
%
% however, their metrics have some good qualities
%
% coherence -- a measure of how well a spike in one location predicts
% spikes in neighboring locations
%
% firing area -- a measure of "spread"
%
% patchiness -- roughly, coherence or smoothness of firing within place
% field. this is dependent on the number of spikes counted, as more spikes
% should produce a smoother looking field, but the general idea of
% measuring place field smoothness is attractive; it would be troubling
% to see a place field --  which is assumed by many to be idealized as a 2D
% gaussian -- 



infoSurface=zeros(12,20); sparistySurface = infoSurface;
for minSpeed = 1:12;
    for binResolution = 1:20;
        % minSpeed = 8; % cm/s
        % binResolution = 11; % px/bin
for cellId=4; %1:max(cellNumber);
    %figure(101); subplot(3,5,cellId); 
    spikeXyIdxs = mapSpikeTimeToVideoIdx( spiketimes, cellNumber, cellId, xyFramesPerSecond );
    speedFilteredSpikeXyIdxs = spikeXyIdxs( speed(spikeXyIdxs) > minSpeed );
    %
    cellXHist = twoDHistogram( xpos(speedFilteredSpikeXyIdxs), ypos(speedFilteredSpikeXyIdxs), binResolution, 720, 420 ); 
    xyHist = twoDHistogram( xpos, ypos, binResolution , 720, 480 );
    %
     output = twoDSpikeTrain( xpos, ypos, xyTimesForPlots, speedFilteredSpikeXyIdxs, binResolution, 720, 480 );
     figure; temp=output(13,3,:); temp=find(temp(:)); plot(temp, ones(size(temp)),'*'); hold on; temp=output(3,7,:); temp=find(temp(:)); plot(temp, ones(size(temp)),'o');
     figure; temp=output(3,13,:); temp=smoothWithGaussian(temp(:),60); plot(temp);
     hold on; temp=output(4,13,:); temp=smoothWithGaussian(temp(:),60); plot(temp);
    %
    ppxy = xyHist/sum(xyHist(:)); % probability of being in place
    ppspike = cellXHist./(xyHist./30); % spike rate
    spikePlaceInfoVector = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
    spikePlaceInfo = nansum(spikePlaceInfoVector(:));
    %
    spikePlaceSparsityVector = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
    spikePlaceSparsity = nansum(spikePlaceSparsityVector(:));
    %
    %disp(['cell ' num2str(cellId) ' spike_info = ' num2str(spikePlaceInfo) ' ; n_spikes = ' num2str(length(spikeXyIdxs)) ' ; n_filt_spikes = ' num2str(length(speedFilteredSpikeXyIdxs)) ' ; ' num2str(round(100*length(speedFilteredSpikeXyIdxs)/length(spikeXyIdxs))) '% incl.  ;' 'spike sparsitty = ' num2str( spikePlaceSparsity ) ]);
    %
    infoSurface(minSpeed, binResolution) = spikePlaceInfo;
    sparistySurface(minSpeed, binResolution) = spikePlaceSparsity;
    %
    %sizeColor = 1./(1+exp(4-(smoothedSpeedEstimate(idxs)))); % sigmoid around the firings such that ~7 is 95th percentile
    %
    %figure;
    %subplot(1,3,1); imagesc(flipud(cellXHist)); colormap(build_NOAA_colorgradient); title('speed filtered firing map'); xlabel('x position'); ylabel('y position');
    %subplot(1,3,2); plot( xpos, ypos, 'Color', [.1 .1 .1 .1], 'LineWidth', 1.5 ); xlim([ 0 720 ]); ylim([ 0 480 ]); scatter( xpos( speedFilteredSpikeXyIdxs ), ypos( speedFilteredSpikeXyIdxs ), 10*speed( speedFilteredSpikeXyIdxs ), 'o', 'Filled', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1 ); legend(['cell ' num2str( cellId )] ); title('firing locations'); xlabel('x position'); ylabel('y position');
    %subplot(1,3,3); imagesc(flipud(cellXHist./xyHist)); colormap(build_NOAA_colorgradient); title('firing locations'); xlabel('x position'); ylabel('y position');
end;

    end
end
figure; surface(infoSurface)
figure; surface(sparistySurface)

%% interspike intervals and bursts

% interspike intervals 

% NOTE -- this is not speed filtered.
ttt=spiketimes(cellNumber==cellId);
figure; plot( (ttt(2:end)-ttt(1))/60e6, 1./diff(ttt/1e6) ); title('firing rate over time');
figure; hist(1./diff(ttt/1e6),0:400); title('instant spike rate histogram');

% let's define a burst as any set of spikes where the cells occur within 
% 90 ms of eachother (this is the length of a theta cycle)

% alternative : actually use the theta cycle in the LFP to segment time and
% group bursts.
% this is done on a cell by cell by cell basis
disp(['max bursts = ' num2str( sum(diff(ttt/1e3)<90) ) ' , or '  num2str(round(100*sum(diff(ttt/1e3)<90)/(length(ttt)-1))) ' % of ISIs']);



%tests...
% thisCellSpikeTimes = [0 100   101   102   202   302   402   403   503   504   505   605   606   607   608   708   808 ];
% thisCellIsisInMsOne = [ 100 1 1 100 100 100 1 100 1 1 100 1 1 1 100 100 ];
% answerOne =          [ 0   1 1 1   0   0   2 2   3 3 3   4 4 4 4   0   0 ];
% thisCellIsisInMs = [ 1 1 1 100 100 100 1 100 1 1 100 1 100 1 1 1 ];
% answer =          [ 1 1 1 1   0   0   2 2   3 3 3   4 4   5 5 5 5 ];
thisCellSpikeTimes = spiketimes(cellNumber==cellId);
thisCellIsisInMs=diff(thisCellSpikeTimes/1e3); % this cell's ISIS in ms
burstId=1; % zero is reserved for non-bursts; a burst is >1 spike within < 90 ms
thisCellSpikeBurstId=zeros(size(thisCellSpikeTimes));
spikesPerBurst = [ 1 ];
newBurst = true;
startIdx = 0;
endIdx = 0;
spikeOrBurstCenterTime=[];
spikeOrBurstId = 1;
for ii=2:length(thisCellSpikeTimes)
    if thisCellIsisInMs(ii-1) < 90
        thisCellSpikeBurstId(ii) = burstId;
        thisCellSpikeBurstId(ii-1) = burstId;
        spikesPerBurst(burstId)=spikesPerBurst(burstId)+1;
        if newBurst
            newBurst = false;
            startIdx = ii;
        end
    else
        if (ii>1) && (thisCellSpikeBurstId(ii-1)>0)
            burstId = burstId + 1;
            spikesPerBurst(burstId)=1;
            newBurst = true;
            spikeOrBurstCenterTime(spikeOrBurstId)=median(thisCellSpikeTimes(startIdx:ii));
            spikeOrBurstId = spikeOrBurstId + 1;
        end
    end
end
% end is not strictly correct here...
spikeOrBurstCenterTime(spikeOrBurstId)=median(thisCellSpikeTimes(startIdx:end));
spikesPerBurst = spikesPerBurst(1:end-1); % cut out the last entry


cscTimeIdxsAllSpikes=zeros(size(thisCellSpikeTimes));
for ii=1:length(cscTimeIdxsAllSpikes)
    cscTimeIdxsAllSpikes(ii) = find(lfpTimestamps<thisCellSpikeTimes(ii), 1, 'last' );
end


cscTimeIdxsBursts=zeros(size(spikeOrBurstCenterTime));
for ii=1:length(spikeOrBurstCenterTime)
    cscTimeIdxsBursts(ii) = find(lfpTimestamps<spikeOrBurstCenterTime(ii), 1, 'last' );
end

cscTimeIdxsIsolatedSpikes=[];
tempIdxs=find(thisCellSpikeBurstId==0);
for ii=1:length(tempIdxs)
    cscTimeIdxsIsolatedSpikes(ii) = find(lfpTimestamps<thisCellSpikeTimes(tempIdxs(ii)), 1, 'last' );
end


figure; plot(lfpTimestamps(2022606-31999:2022606+32000), thetaBandLfp(2022606-31999:2022606+32000));
hold on; plot(thisCellSpikeTimes(thisCellSpikeBurstId==16),zeros(1,26),'*')


figure; 
subplot(2,2,1); rose(thetaPhaseRads(cscTimeIdxsAllSpikes),72); title('all spikes');
subplot(2,2,2); rose(thetaPhaseRads(cscTimeIdxsBursts),72); title('non-burst');
subplot(2,2,3); rose(thetaPhaseRads(cscTimeIdxsIsolatedSpikes),72); title('burst');
subplot(2,2,4); rose(thetaPhaseRads([cscTimeIdxsIsolatedSpikes cscTimeIdxsBursts]),72); title('both');

figure; 
subplot(1,2,1); [yy,xx]=hist(log(thetaEnvelope), 100); hist(log(thetaEnvelope), 100); title('env. distro'); ylabel('log(\Theta envelope)');
subplot(1,2,2); hist(log(thetaEnvelope(find(cellNumber==cellId))),xx); title(['spike env. distro']);



% this is really annoying. 
% length(thisCellSpikeTimes)
% 955
% length(intersect(lfpTimestamps,thisCellSpikeTimes))
% 238
% so basically, there are only 238 spike times that match, which means I'll
% have to manually find these fricken things.
% We want to extract the times when this cell fired to see its relationship
% to theta, but we don't want to overweight the prefered firing phase,
% which will occur during a burst.
timeCentroidOfSpikeOrBurst = [];
burstId = 1;

    




%% instead of coherence, what about distance traveled between speed filtered
% spikes? If the spatial location of the spike predicts more spikes, most
% spikes should occur within a small spatial displacement
% value of this metric 
%
% median of this, or some ratio as below should be nice to interpret
for ii=1:length(speedFilteredSpikeXyIdxs)-1
    displacements(ii)=sqrt( (xpos(speedFilteredSpikeXyIdxs(ii+1))-xpos(speedFilteredSpikeXyIdxs(ii)))^2 + (ypos(speedFilteredSpikeXyIdxs(ii+1)) - ypos(speedFilteredSpikeXyIdxs(ii)))^2 );
end
figure; hist(displacements,1:500);
sum(displacements<3)/length(displacements)

%% instead of patchiness, bumpiness
temp=size(cellXHist);
rows=temp(1);
cols=temp(2);
bumpiness=zeros(size(cellXHist));
itr=1;
% being lazy about the indexing; discount the edge cases
aaa=bbb; %cellXHist; %aaa=rand(size(cellXHist)).*rand(size(cellXHist)); aaa=aaa.*(aaa>0.2);
for ii=2:rows-1
    for jj=2:cols-1
        if aaa(ii,jj)>0
            surround=median( [ aaa(ii-1,jj-1) aaa(ii-1,jj) aaa(ii-1,jj+1) aaa(ii,jj-1) aaa(ii,jj+1) aaa(ii+1,jj-1) aaa(ii+1,jj) aaa(ii+1,jj+1) ] );
            bumpiness(ii,jj)=aaa(ii,jj)-surround;
            itr=itr+1;
        end
    end
end
figure; temp=find(bumpiness(:)); hist(bumpiness(temp),50)
figure; imagesc(aaa); figure; imagesc(bumpiness);     
% capable to detect & rank local outliers -- these would be extreme cases
%
% median perhaps tells us something about how extreme the expected change
% across pixels will be
%
% can detect edges


%% how many fields are there? How big are they?

[labeledMatrix,regionLabels,regionSizes]=findBoundaries(cellXHist,1,2);


%% how much area does firing cover?
% normalized for what the rat visited, of course

round(sum(sum(cellXHist>0))/sum(sum(xyHist>0))*100)

    
    
    
%% demo
%# colors  make a multicolor line where velocity controls color
speedColorPlot(xpos, ypos, pxPerCm);

%%

figure; plot(spiketimes,cellNumber, 'o');
cellXpos = zeros(size(spiketimes));
cellYpos = cellXpos;
for ii=1:length(spiketimes)
    tempIdx=find(spiketimes(ii)<xytimestamps, 1 );
    if ~isempty(tempIdx)
        cellXpos(ii)=xpos(tempIdx);
        cellYpos(ii)=ypos(tempIdx);
    end
end

figure; subplot(2,3,1);  plot( x, y, 'Color', [.1 .1 .1 .1] ); subplot(2,3,2); plot( x, y, 'Color', [.1 .1 .1 .1] ); hold on; plot(cellXpos(cellNumber==4),cellYpos(cellNumber==4),'*');
subplot(2,3,4); xyHist=twoDHistogram(x,y,20,720,420); imagesc(flipud(xyHist)); colormap(build_NOAA_colorgradient);
subplot(2,3,5); cellFourHist=twoDHistogram(cellXpos(cellNumber==4),cellYpos(cellNumber==4),20,720,420); imagesc(flipud(cellFourHist)); colormap(build_NOAA_colorgradient);


%% measure spike information content
%
ppxy = xyHist/sum(xyHist(:)); % probability of being in place
ppspike = cellFourHist./(xyHist./30); % spike rate
spikePlaceInfo = ppxy .* ( ppspike./nanmean(ppspike(:)) ) .* log2( ppspike./nanmean(ppspike(:)) );
disp(['spike information = ' num2str(nansum(spikePlaceInfo(:))) ]);
subplot(2,3,3); imagesc(flipud(ppspike)); colormap(build_NOAA_colorgradient);
% Markus, Barnes, McNaughton, Gladden, Skaggs 1994 
% Markus et al 1994 suggest that randomly shuffling the location and spike
% train can be used to determine significance levels and produce a z score
% for information metrics.

figure; for cellId=1:max(cellNumber); subplot(3,5,cellId); qq=twoDHistogram(cellXpos(cellNumber==cellId),cellYpos(cellNumber==cellId),20); imagesc(flipud(qq)); colormap(build_NOAA_colorgradient); end;


%% sparsity metric
%
%    this metric tells us how selective the cell's firing was on the maze.
%    thus a cell which fires everywhere will not be sparse, whereas one
%    with a very small and precise place field will be sparse

spikePlaceSparsity = (ppxy .* ppspike.^2 )./(nanmean(ppspike(:))^2 );
disp(['spike sparsitty = ' num2str(nansum(spikePlaceSparsity(:))) ]);

% POSSIBLY SIMILAR TO KUBIE AND MULLER'S FIRING AREA METRIC


cross correlation :

defined as  cc(n) = SUM_{m=x:y}( f[m] * g[m+n] )

%% SPIKE POSITION SHIFTING

 % this is nother Muller and Kubie thing. I don't properly understand it.


%% theta phase

thetaFilter = designfilt( 'bandpassiir', ...
                    'StopbandFrequency1', 3, 'PassbandFrequency1', 4, ...
                   'PassbandFrequency2', 12, 'StopbandFrequency2', 13, ...
                   'StopbandAttenuation1', 30, 'PassbandRipple', 1, ...
                   'StopbandAttenuation2', 30, 'SampleRate', 32000);
thetaBandLfp = filtfilt( thetaFilter, lfp );
thetaHilbert = hilbert(thetaBandLfp);
thetaPhaseRads = angle(thetaHilbert);
thetaEnvelope = abs(thetaHilbert);
% for some example cell, what is the preferred firing phase?
figure; rose(thetaPhaseRads(find(cellNumber==cellId)),72)
% for all phases, what is the distribution? it happens to not be uniform
% because the theta signal is not strictly sinusoidal; instead the
% frequency reflects the current speed of the motion; because the phase is
% a time integral of the frequency, and because we know the time integral
% is not a constant, but rather variable and dependent on the behavior, the
% distribution cannot be uniform.
figure; rose(thetaPhaseRads(:),72)

%% coherence
%
% "1st order spatial autocorrelation"
%
% ztransform (  correlation ( list[](average firing rate -- this is a timeseries?), list[](average(firing rate nearest 8 neighbor bins)) )  )
%
% the point is to determine to what degree neighboring bins predict each
% other -- this should work because place fields are approximately gaussian
%
% from :
% RU Muller & JL Kubie. "The Firing of Hippocampal Place Cells Predicts the
%     Future Position of Freely Moving Rats." J. Neurosci. 1989; 9(12):
%     4101-1410.
%
%
% a z transform is probably a normalization in this case :
%
% Z(n) = ( x(n) - mean(x) ) / std(x)
%





%% FIELD CENTROIDS


% field centroids were calculated according to the formula Xc    xiri/ ri and Yc    yiri/ ri, in which xi and yi are the positions of the ith pixel in the field, and ri is its firing rate (Fenton et al., 2000)
% Alvernhe et al. ? Place Cells and Shortcut Behavior. 7326 ? J. Neurosci., July 16, 2008 ? 28(29):7324 ?7333
% To estimate firing field similarity between two successive sessions, we computed a similarity score equal to the pixel-by-pixel correlation [Pear- son product-moment correlation coefficient (rs)] between the positional rate distribution in the field sector for the first (standard) session and the superimposed positional rate distribution in the same sector for the sec- ond (shortcut) session. Because correlation coefficients are not normally distributed, similarity scores were converted into z-scores using the Fish- er?s z transformation. All statistical analyses were performed on the z-scores.
% I don't really believe this similarity score thing due to the session to session variations in activity, but I'd have to read this more carefully....

return;
% naaaaaah
% % to ID place cells
% load place data
% clean up place data
% identify excursion trips
%     calculate lagged total displacements -- times when the rat is just hanging out are not for place
%         maybe can ID these as episodes qualifying as >1 second; displacement low, etc
%         invert displacement chart and detect peaks?
%         median filtering
%         nab some code from nlxPositionFixer to find/mark start and ends?
% load spike data



%halfSecDisp=sqrt( ((xpos(16:end)-xpos(1:end-15)).^2) + ((ypos(16:end)-ypos(1:end-15)).^2));
%fullSecDisp=sqrt( ((xpos(31:end)-xpos(1:end-30)).^2) + ((ypos(31:end)-ypos(1:end-30)).^2));

%smoothFactor=15;
%smoothFull=0;
%    for ii = (smoothFactor+1):length(fullSecDisp)-(smoothFactor+1)
%        smoothFull(ii) = median(fullSecDisp(ii-smoothFactor:ii+smoothFactor));
%    end
