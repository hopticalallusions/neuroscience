function [ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( cscLFP, nlxCscTimestamps )
%pathToFile, fileName, saveFile)
%function [ correctedCsc, idxs, mxValues, meanCscWindow ]=cscCorrection( pathToFile, fileNum, saveFile)

% TODO things that could be returned, if desired.
%mxRelIdxs
%nlxFscvTimes

% *** note : this needs to be made piecewise, or not. who knows. maybe it
% should be an option. sigh.

% load the data file
% csc 7 is VTA
% csc 25 is a sharp wave
%pathToFile = '/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/02. 5564929835 To 7591955835/'
%fileNum = 7;
%[ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([pathToFile '/CSC' num2str(fileNum) '.ncs']);
%[ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([pathToFile '/CSC' num2str(fileNum) '.ncs']);
%[ cscLFP, nlxCscTimestamps, cscHeader, channel, sampFreq, nValSamp ] = csc2mat( fullfile( pathToFile, '/', fileName ) );

% check polarity
% this step is important for being able to find the peaks of the signal
if max(cscLFP) < abs(min(cscLFP))
    cscLFP = -cscLFP;
end


%write an alternate version of this function that is capable of taking the
% timestamps or IDXs (idx is probably better) to automate this later. thus
% a system can look for artifacts on a clean signal and then help out later


% in a perfect world, the FSCV is the biggest noise in the signal for any 100 ms window
%, so we just find a max and average that and then subtract those.
% in the real world, there are problems :
% 1) FSCV board falls off, so no big noise signal (clean with max value 
% standard deviation threshold)
% 2) sharp waves can be bigger than FSCV noise (clean by time estimation)


% modify this to pull out the indexes and times of the points; these can be
% aligned with the FSCV data later

maxThreshold=mean(cscLFP)+3*std(cscLFP);
windowSize=3200; % set window size; this is effectively neuralynx_sampling_hertz / fscv_sampling_hertz
idealPeakCenter=round(windowSize/2); % the goal is to speed up the finding of the artifact on each subsequent run
idx = 1; % start at the beginning
meanCscWindow=(zeros(windowSize,1)); % storage for the running average of the artifact shape
iterations = 0; % how many times have we averaged the artifact
idxs = []; % list of artifact window start indexes; artifact peak will be +1600
nlxFscvTimes=[]; % list of artifact center FSCV times in neuralynx time base
mxRelIdxs=[]; % list of relative indexes where idx is relative to window start; large deviations mean something is wrong; distribution center contains info about drift
mxValues=[];
% figure; hold on; %debug noise overlay
while idx + windowSize < length(cscLFP)
    skip=false;
    % I. set up the window of data
    snip=cscLFP(idx:idx+windowSize-1); % cut out a window of the data
    mx=max(snip); % find the max value
    % if the max value is dramatically smaller than expected, something is
    % wrong
    if (mx < maxThreshold)
        %the point of this is to detect and ignore instances when the FSCV
        %connector popped off the headcap; we don't want mistakenly average
        %these into the signal, because the max finder would mistake ANY
        %max as the noise signal.
         disp([ 'max is low!  ' num2str(mx) '  ' num2str(idx)])
         skip = true;
    end
    mxRelativeIdx=find(mx==snip); % find the location of the max value
    mxRelativeIdx=mxRelativeIdx(1); % in case there are more than 1
    % WARNING -- this assumes that after 10 samples, things will be OK. if
    % there's a big sharp wave ripple in the first second, this assumption
    % is broken.
    % noted during testing -- this method is robust to extra large noise
    % spikes; it tries to recenter, so if the spike is large and there is
    % no SWR present, it will just re-find the same large noise max as
    % before. ***** note that weird things may happen with this code if the
    % FSCV board pops off and then is re-inserted, because the center basis
    % will be off for all subsequent noise signatures in the file. solve
    % this problem later.
    if (iterations > 10)
        if ( mxRelativeIdx>(mean(mxRelIdxs)+std(mxRelIdxs)) || mxRelativeIdx < (mean(mxRelIdxs)-std(mxRelIdxs)) )
            disp('warning : deviation found in index position. attempting to fix.')
            tidx=mxRelIdxs(length(mxRelIdxs));
            if (tidx-120 > 0) && (tidx+120 < 3200)  % keep maxes detected within bounds
                tmx=max(snip(tidx-120:tidx+120));
            end
            % this is not really how one wants to solve special cases...
            if (mx==tmx)
                % in the event that a sharp wave lands right next to/inside/etc an
                % FSCV pulse, this conditional should figure that out. It's
                % just going to assume that adding 3200 is correct, because
                % there's basically no easy way to figure it out that I can
                % see.
                disp('max problem; assuming a location.' )
                 mxRelativeIdx=0;
                 mx=max(snip(1600-round(std(mxRelIdxs)):1600+round(std(mxRelIdxs)))); % beacuase we're not moving it.
            else
                disp('trying to fix the location.')
%                 if (tidx-120 > 0)
%                     tmxRelativeIdx=find(tmx==snip(tidx-120:tidx+120))-120; % find the location of the max value
%                     tmxRelativeIdx=tmxRelativeIdx(1); % in case there are more than 1
%                 end
%                 mxRelativeIdx=tidx+tmxRelativeIdx;
%                 mx=tmx;
            end
        end
        % in case we have a sharp wave during a period when the FSCV board
        % fell out.
        if (mx < maxThreshold)
            % THIS MAY BE REDUNDANT WITH THE ABOVE -- could move out of
            % loop below? think about this later.
            %the point of this is to detect and ignore instances when the FSCV
            %connector popped off the headcap; we don't want mistakenly average
            %these into the signal, because the max finder would mistake ANY
            %max as the noise signal.
             disp([ 'max is low!  ' num2str(mx) ' ' num2str(idx) ])
             skip = true;
        end
    end
    if ( ~skip ) 
        newOffset = idealPeakCenter - mxRelativeIdx;
        idx = idx - newOffset;
        if ( idx < 1 )
            paddingSize = abs(idx)+1;
            idx = idx+paddingSize; % which should be 1...
            pad = zeros( paddingSize, 1);
            snip= [pad; cscLFP(idx:idx+windowSize-1-paddingSize)]; % re-window after finding the center
            disp(['front padding required : ' num2str(paddingSize) ])
        elseif (idx+windowSize-1 > length(cscLFP) )
            paddingSize = ( idx+windowSize-1 ) - length(cscLFP);
            pad = zeros( paddingSize, 1);
            snip=[cscLFP(idx:length(cscLFP)); pad] ; % re-window after finding the center
        else
            snip=cscLFP(idx:idx+windowSize-1); % re-window after finding the center
        end
        meanCscWindow = (iterations*meanCscWindow + snip)/(iterations+1);
        iterations = iterations + 1; % accounting
        % the 136 shifts from the peak back to somewhere pretty close to the
        % start of the FSCV pulse; 144/32 = 4.5 ms before peak
        % in fact, this should be 4.25 ms or 136 because the up and back happens
        % in 2*(1.3 V- -0.4V)/400V/s = 8.5ms
       % plot(snip); plot(mxRelativeIdx,mx,'o'); % debug noise alignment
       % TODO -- write a smart resizer datatype that exponentially
       % increases the size of the data structure
        nlxFscvTimes = [ nlxFscvTimes nlxCscTimestamps(idx+idealPeakCenter-136) ];
        mxRelIdxs = [mxRelIdxs mxRelativeIdx]; % create list of relative index values (see above)
        mxValues=[mxValues mx];
        idxs=[idxs idx]; % list of indexes where centers were found
    end
    % close the loop
    idx = idx + windowSize;
end


% do a sanity check
% the number of elements in nlxTimes for the locations of the FSCV noise
% should be somewhat close to the number of microseconds in the record,
% divided by 1000 (us -> ms) * 100 (ms interval of FSCV)

%estimatedFscvEvents = (max(nlxCscTimestamps)-nlxCscTimestamps(1))/100000;
estimatedFscvEvents = length(cscLFP)/3200; 
if ( 1.01 < length(idxs)/estimatedFscvEvents )
    warning(['The number of detected FSCV events is > 101% of the expected level! ' num2str(100*length(idxs)/estimatedFscvEvents) '% detected!'])
elseif ( 0.99 > length(idxs)/estimatedFscvEvents ) % matlab corrected max(find(var))) to this find(var, 1, 'last') thing
    warning(['The number of detected FSCV events is < 99% of the expected level! ' num2str(100*length(idxs)/estimatedFscvEvents) '% detected!'])
end

% % recenter the mean artifact because the 
% firstDerivMeanCsc=diff(meanCscWindow);
% artifactIdxStart=find(firstDerivMeanCsc>10,1, 'first')-100; % cushioning
% artifactIdxEnd=find(firstDerivMeanCsc>10,1, 'last')+200;   % cushioning
% dcBiasStart=meanCscWindow(artifactIdxStart+1)
% dcBiasEnd=meanCscWindow(artifactIdxEnd-1)
% meanCscWindow(1:artifactIdxStart)=0;
% meanCscWindow(artifactIdxEnd:end)=0;
% artifactIdxs=artifactIdxStart+1:artifactIdxEnd-1;
% dcBiasFunction=linspace(dcBiasStart,dcBiasEnd,length(artifactIdxs));
% size(meanCscWindow(artifactIdxs))
% size(dcBiasFunction)
% figure; plot(dcBiasFunction)
% meanCscWindow(artifactIdxs)=meanCscWindow(artifactIdxs)-dcBiasFunction';
% NOTES : This foolishness is an imperfect attempt to fit the artifact to
% the background signal it is riding on. This is much easier on a highpass
% for spikes filtered signal because all the low frequency components are
% gone, and the artifact signal pops out of the average with no DC biases.
% In the wide filtered data, there are slow frequency components that
% introduce a slope on a per-artifact basis, which do weird things to the
% shape of the artifact itself. For example, let's assume the artifact is
% on the maximum downward sloping component of a theta cycle -- the FSCV 
% artifact onset will occur at a higher DC offset due to the theta signal
% than the FSCV artifact offset. Some sort of model of the signal would
% help compensate for this situation, but I don't have time to build it
% immediately. 
% TODO (see above)

% this corrector seems to be pushing the curve a little too far to the
% right
correctedCsc=cscLFP;
idealIdxs=[]; %837  565  700    137; 135
%while idx + windowSize < length(cscLFP)
for iandi=1:length(idxs)
    idx = idxs(iandi);
    % copy a window of the data
    snip=correctedCsc(idx:idx+windowSize-1);
    doMain = true;
    % special edge case handling...
    % if the artifact occurs before the middle of the first 100ms period of
    % recording, just subtract the part that fits of the mean window
    % otherwise, if 
    if iandi == 1
        if  min(find(max(snip)==snip)) < 1600
            % unsafe scaling factor with sharp waves
            scalingFactor=(max(meanCscWindow)-min(meanCscWindow))/(max(snip)-min(snip));
            correctedCsc(idx:idx+windowSize-1-(1600-min(find(max(snip)==snip)))) = correctedCsc(idx:idx+windowSize-1-(1600-min(find(max(snip)==snip)))) - (meanCscWindow(1600-min(find(max(snip)==snip)-1):length(meanCscWindow))/scalingFactor);
            doMain = false;
        end
    elseif iandi == length(idxs)
        %handle cut-off recordings and also pop-outs and subthreshold things.
        if  ( min(find(max(snip)==snip)) > 1600 ) && ~(mxRelativeIdx < (mean(mxRelIdxs)-std(mxRelIdxs)))
            % unsafe scaling factor with sharp waves
            scalingFactor=(max(meanCscWindow)-min(meanCscWindow))/(max(snip)-min(snip));
            correctedCsc(idx:idx+windowSize-1-(1600-min(find(max(snip)==snip)))) = correctedCsc(idx:idx+windowSize-1-(1600-min(find(max(snip)==snip)))) - (meanCscWindow(1600-min(find(max(snip)==snip)-1):length(meanCscWindow))/scalingFactor);
            doMain = false;
        elseif mxRelativeIdx < (mean(mxRelIdxs)-std(mxRelIdxs))
            doMain = false;
        end
    end
    if doMain
        % TODO weird things will happen if a sharp wave or other large noise
        % event occurs in this window...
        scalingFactor=(max(meanCscWindow)-min(meanCscWindow))/(max(snip(idealPeakCenter-140:idealPeakCenter+140))-min(snip(idealPeakCenter-140:idealPeakCenter+140)));
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
    end
end

return;

end



% if (saveFile == true)
%     %save( [pathToFile '/CSC' num2str(fileNum) '.mat'], 'correctedCsc')
%     mat2csc(fileList{fileIdx}, pathToFile, cscHeader, cscLFP, nlxCscTimestamps, channel, nValSamp, sampFreq );
% end

%spectrogram(data, windowSize, windowOverlap, numberOfDfftPoints, sampleRate)
%spectrogram(swrCSC,128,100,128,32*1e3)


%figure;plot(cscLFP(1:96000),'k'); hold on; plot(correctedCsc(1:96000))
%hold off;  plot(cscLFP(11657709-5000:11657709+5000),'r'); hold on;plot(cscLFP(11657709-5000:11657709+5000)-correctedCsc(11657709-5000:11657709+5000),'k'); plot(correctedCsc(11657709-5000:11657709+5000));

%hold off;  plot(cscLFP(11657709-5000:11657709+5000),'r'); hold on;plot(cscLFP(11657709-5000:11657709+5000)-correctedCsc(11657709-5000:11657709+5000),'k'); plot(correctedCsc(11657709-5000:11657709+5000));
%plot(cscLFP(11657709-48000:11657709+10000))

%cscLFP=bkup(11657709-48000:11657709+48000);

%hold off;
%plot(cscLFP)
%hold on; plot(idxs,cscLFP(idxs),'ro')
%hold on; plot(idxs+mxRelIdxs,cscLFP(idxs+mxRelIdxs),'r*')

% 
% 
% gf=gausswin(3200);
% gf=gf/sum(gf);
% %y=conv(cumsum(correctedCsc(ix)),gf);
% y=conv(abs(correctedCsc(ix)),gf);
% figure; hold off; plot((ix-min(ix))/32000, abs(correctedCsc(ix)),'r'); hold on; plot((ix-min(ix))/32000,y(1:length(ix)));
% plot(conv(correctedCsc(ix),gf),'g')
% plot(4000+correctedCsc(ix)/5,'g')
% figure; specgram(y)
% figure; specgram(y,128,100,128,32000)
