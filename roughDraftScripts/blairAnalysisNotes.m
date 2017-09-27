%'/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/01. File Beginning To 5564929835/

%  You might be a grad student if ... noticing that Matlab now displays what files are tracked in Git excites you a little bit on Saturday night near midnight. (apologies to Jeff Foxworthy)
    
datadir = '/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/02. 5564929835 To 7591955835/'
[nlxEvents, nlxEvTimestamps, evHeader]=nev2mat('/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/02. 5564929835 To 7591955835/Events.Nev');
ttlOnsetIdx=find(not(cellfun('isempty', strfind(nlxEvents, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
firstSyncPulseNlxTimestamp = nlxEvTimestamps(ttlOnsetIdx(1));


load('/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/02. 5564929835 To 7591955835/Positions.mat')
firstVideoNlxTimestemp=(posvars(1,1)-100)*1e6;

nlxFscvTimes(1) - ( nlxCscTimestamps(1) + firstVideoNlxTimestemp )

% .1e6 microseconds is 100 ms

firstSyncPulseNlxTimestamp - nlxFscvTimes(1)

% missing the step of knitting and normalizing the data.
load('/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/3-20-2015/run/platterSync/BATCH_PC/STACKED_PC/daConcData.mat')

load('/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/3-20-2015/run/platterSync/BATCH_PC/STACKED_PC/Stacked_DIOs')
%Stacked_DIOs;
fscvTimestampDIOState=Stacked_DIOs(:,[1 3]);

 min(find(fscvTimestampDIOState(:,2)==0))

% nlxFscvTimes -- estimated Nlx Timestamps of FSCV samples (smaller than
% FSCV samples taken
% 
% 
%
% fscvTimestampDIOState(:,[1 3])
%
%


%spectrogram(data, windowSize, windowOverlap, numberOfDfftPoints, sampleRate)
spectrogram(swrCSC,128,100,128,32*1e3)




% this corrector seems to be pushing the curve a little too far to the
% right
idx = 1;
iterations = 0;
correctedCsc=csc;
idealIdxs=[];
while idx + windowSize < length(csc)
    % cut out a window of the data
    snip=correctedCsc(idx:idx+windowSize-1);
    % center on the max value
    mx=max(snip);
    mxRelativeIdx=find(mx==snip);
    mxRelativeIdx=mxRelativeIdx(1);
    newOffset = idealPeakCenter - mxRelativeIdx;
    idx = idx - newOffset;
    scalingFactor=(max(meanCscWindow)-min(meanCscWindow))/(max(snip)-min(snip));
    %
    signalNoise=1e6;
    idealIdx=0;
    for minFindingIdx = -5:5
        snip = correctedCsc(idx+minFindingIdx:idx+windowSize-1+minFindingIdx);
        tempCorrected = snip - (meanCscWindow/scalingFactor);
        if signalNoise > std(tempCorrected)
            signalNoise = std(tempCorrected);
            idealIdx = minFindingIdx;
        end
    end
    %
    correctedCsc(idx+idealIdx:idx+windowSize-1+idealIdx) = correctedCsc(idx+idealIdx:idx+windowSize-1+idealIdx) - (meanCscWindow/scalingFactor);
    idealIdxs=[idealIdxs idealIdx];
    % close the loop
    idx = idx + windowSize;
end


windowSize=3200;
idealPeakCenter=round(windowSize/2);
idx = 1;
meanCscWindow=(zeros(windowSize,1));
iterations = 0;
idxs = [];
nlxFscvTimes=[];
mxRelIdxs=[];
while idx + windowSize < length(csc)
    % cut out a window of the data
    snip=csc(idx:idx+windowSize-1);
    % center on the max value
    mx=max(snip);
    mxRelativeIdx=find(mx==snip);
    mxRelativeIdx=mxRelativeIdx(1);
    newOffset = idealPeakCenter - mxRelativeIdx;
    idx = idx - newOffset;
    snip=csc(idx:idx+windowSize-1);
    meanCscWindow = (iterations*meanCscWindow + snip)/(iterations+1);
    iterations = iterations + 1;
    % close the loop
    idx = idx + windowSize;
    idxs=[idxs idx];
    mxRelIdxs = [mxRelIdxs mxRelativeIdx];
    % the 144 shifts from the peak back to somewhere pretty close to the
    % start of the FSCV pulse
    nlxFscvTimes=[nlxFscvTimes timestamps(idx+idealPeakCenter-144)];
end


fscvTimestampDIOState(min(find(fscvTimestampDIOState(:,2)==0)), 1)
ans = 77.4000

fscvTimestampDIOState(min(find(fscvTimestampDIOState(:,2)==0))-80+1, 1)
ans = 69.5000


% determine index shift
% 30 entries per second
% multiply
videoIdxOffsetLFP = round(10*(posvars(1,1)-100))

% find all the sync pulses
ttlOnsetIdx=find(not(cellfun('isempty', strfind(nlxEvents, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
% find number of FSCV pulses before the first sync
numFscvPulsesBeforeSync=sum(nlxFscvTimes<=nlxEvTimestamps(min(ttlOnsetIdx))) % 80 -- this is the number of FSCV pulses before the first sync point
% find the starting index of the nlx recording in the FSCV recording
fscvTimestampDIOState=Stacked_DIOs(:,[1 3]);
min(find(fscvTimestampDIOState(:,2)==0))-80+1


baseIndexNlx = videoIdxOffsetLFP;
baseIndexFscv = videoIdxOffsetLFP + min(find(fscvTimestampDIOState(:,2)==0))-80+1;
baseIndexVideo = 0;

% avg_x avg_y daConc nlxTimeish FSCV_time
daSpace = zeros(length(daConcData),5);

for idx = 1:length(nlxFscvTimes)-baseIndexNlx
    vidx = ((idx-1)*3)+1;
    x  = mean(posvars(vidx:vidx+2,2));
    y  = mean(posvars(vidx:vidx+2,3));
    da = daConcData( idx + baseIndexFscv );
    nt = nlxFscvTimes( idx + baseIndexNlx );
    ft = fscvTimestampDIOState( idx + baseIndexFscv, 1 );
    daSpace(idx,:) = [ x y da nt ft ];
end

boxSide = 10;
 % assume there are uh... 800x800 pixels
samplesPerBox = zeros(ceil(800/boxSide), ceil(800/boxSide));
totalDaConc = samplesPerBox + min(daSpace(:,3)*1.1;

for idx = 1:length(daSpace)
   boxXidx = round(daSpace(idx,1)/boxSide);
   boxYidx = round(daSpace(idx,2)/boxSide);
   if ~( isnan(boxXidx) || isnan(boxYidx) || boxXidx == 0 || boxYidx == 0 ) 
       samplesPerBox(boxXidx, boxYidx) = 1 + samplesPerBox(boxXidx, boxYidx);
       totalDaConc(boxXidx, boxYidx) = daSpace(idx,3) + totalDaConc(boxXidx, boxYidx);
   end
end


% look, the da concentration is really Gaussian.
figure;
subplot(2,1,1);
hist(daConcData, 50);
title('Freq. of Detrended DA conc.');
ylabel('freq.');
xlabel('da conc. bins');
subplot(2,1,2);
qqplot(daConcData)

% this code makes a dopamine level by location plot
% in particular, dopamine concentration has a nice Gaussian shape, so this graph uses
% mean and standard deviation to cut the data into 5 ranges (center,
% between one and 2 standard deviations and more than 2 standard deviations
% away)
mu = mean(daConcData);
sigma = std(daConcData);
figure; 
plot(daSpace(:,2),-daSpace(:,1), 'Color', [.7 .7 .7]); 
hold on; 
for idx=1:length(daSpace); 
    midcol = .5 + ( (daSpace(idx,3)) / (2*(max(daSpace(:,3))-min(daSpace(:,3))))  );
    if (abs(daSpace(:,3)) > 2*sigma+mu)
        colin = [ 0 midcol 0 ];
    elseif (abs(daSpace(:,3)) > sigma+mu)
        colin = [ 0 0 midcol ];
    else
        colin = [ midcol 0 0 ];
    end;
    plot( daSpace(idx,2), -daSpace(idx,1), 'o', 'MarkerEdgeColor',[1 1 1], 'MarkerFaceColor',colin, 'MarkerSize',10 ); 
    pause(.01); 
end;



figure;
subplot(2,3,4);
% all values
plot(daSpace(:,2), -daSpace(:,1), '.', 'Color', [ .9 .9 .9 ], 'MarkerSize', 1)
legend('all'); axis([ 20 430 -535 -215 ]);
% middling values; the 68%
subplot(2,3,1);
didxs=find( (daSpace(:,3)> mu-sigma).*(daSpace(:,3)< mu+sigma));
plot(daSpace(didxs,2), -daSpace(didxs,1), '.', 'Color',[.5 .5 .5], 'MarkerSize', 2)
legend('mid'); axis([ 20 430 -535 -215 ]);
% the 32% on the extremes
subplot(2,3,5);
didxs=find((daSpace(:,3) < mu-sigma).*(daSpace(:,3) >= mu-2*sigma));
plot(daSpace(didxs,2), -daSpace(didxs,1), '.', 'Color', [ 1 .6 0 ], 'MarkerSize', 4  )
legend('low'); axis([ 20 430 -535 -215 ]);
subplot(2,3,2);
didxs=find((daSpace(:,3) > mu+sigma).*(daSpace(:,3) <= mu+2*sigma));
plot(daSpace(didxs,2), -daSpace(didxs,1), '.', 'Color', [ 0 .8 .2 ], 'MarkerSize', 4  )
legend('hi'); axis([ 20 430 -535 -215 ]);
% the 5% on the extremes
subplot(2,3,6);
didxs=find(daSpace(:,3)< mu-2*sigma);
plot(daSpace(didxs,2), -daSpace(didxs,1), '*', 'Color', [ .9 .1 .1 ] )
legend('exLo'); axis([ 20 430 -535 -215 ]);
subplot(2,3,3);
didxs=find(daSpace(:,3)> mu+2*sigma);
plot(daSpace(didxs,2), -daSpace(didxs,1), '*', 'Color', [ 0 .7 1 ] )
legend('exHi'); axis([ 20 430 -535 -215 ]);



% here, we want to look at ways to separate the neuron spikes from the LFPs

% this plot shows the distribution of all super threshold events
figure;
subplot(3,1,1);
hist(correctedCsc(superThresholdIdxs), 50);
title('super threshold');
ylabel('peak value (binned)');
xlabel('frequency');
subplot(3,1,2);
hist(correctedCsc(superThresholdIdxs(putativeApPeakIdxs)), 50);
title('AP peak heights');
ylabel('peak value (binned)');
xlabel('frequency');
subplot(3,1,3);
hist(correctedCsc(superThresholdIdxs(putativeApPeakIdxs)), 50);
title('AP peak heights');
ylabel('peak value (binned)');
xlabel('frequency');
