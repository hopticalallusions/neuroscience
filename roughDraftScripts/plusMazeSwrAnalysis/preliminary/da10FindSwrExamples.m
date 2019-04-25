%% da 10 first day of training

    % 
    % filters.delta    = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.1, 'HalfPowerFrequency2',    4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
    % filters.lia      = designfilt( 'bandpassiir', 'FilterOrder',  2, 'HalfPowerFrequency1',    1, 'HalfPowerFrequency2',   50, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
    % filters.theta    = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
    % filters.alpha    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    8, 'HalfPowerFrequency2',   14, 'SampleRate', 32000);
    % filters.beta     = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   14, 'HalfPowerFrequency2',   31, 'SampleRate', 32000);
    % filters.lowGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   30, 'HalfPowerFrequency2',   80, 'SampleRate', 32000); % verified 8 is good
    % filters.midGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   60, 'HalfPowerFrequency2',  120, 'SampleRate', 32000);
    % filters.swr      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   99, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
    % filters.highLfp  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  250, 'HalfPowerFrequency2',  600, 'SampleRate', 32000);
    % filters.spike    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  600, 'HalfPowerFrequency2', 6000, 'SampleRate', 32000);
    % filters.nrem     = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   40, 'SampleRate', 32000);
    % filters.chew     = designfilt( 'bandpassiir', 'FilterOrder', 20, 'HalfPowerFrequency1',  100, 'HalfPowerFrequency2', 1000, 'SampleRate', 32000); % verified order, settings by testing
    % filters.electric = designfilt( 'bandpassiir', 'FilterOrder', 12, 'HalfPowerFrequency1',    59, 'HalfPowerFrequency2',  61, 'SampleRate', 32000); % verified order, settings by testing
    % filters.spindle  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    12, 'HalfPowerFrequency2',  14, 'SampleRate', 32000); % sleep spindles occur before k-complexes, and must be ~500+microscends

    
    
    

    
    
    
    
videoSampleRate=29.97;
lfpSampleRate=32000;
    % 
    % dir='/Volumes/BlueMiniSeagateData/ratData/da10/da10_2017-09-19/';
    % 
    % [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
    % xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    % pxPerCm = 2.0;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
    % lagTime = 1.5; % seconds
    % speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
    % xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
    % 
    % 
    % [ lfp88, lfpTimestamps ] = csc2mat([ dir 'CSC88.ncs']); % inverted SWR; below layer
    % [ lfp61 ] = csc2mat([ dir 'CSC61.ncs']); % above layer (non inverted SWR)
    % [ lfp6 ] = csc2mat([ dir 'CSC6.ncs']); % NAc, to eliminate noise from bucket slam vs SWR
    % [ lfp76 ] = csc2mat([ dir 'CSC76.ncs']); % 
    % [ lfp64 ] = csc2mat([ dir 'CSC64.ncs']); % 
    % timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

%% manually marked up ~600 candidate events using "dataScroller.m"

% manually marked SWRs are saved in
% "~/data/ratData/ephys.../da10/da10-day1-plusMaze-manualSwr.mat" or
% something like that for da10_2017-09-19
% this matrix is in seconds


%% try to characterize the marked events

    % load('/Users/andrewhowe/data/ratData/ephysAndTelemetry/da10/manual-swr-marking-da10-day1-plusMaze.mat')
    % figure; hist( SWRs, 100 ); % there's periodicity, as one would expect
    % figure; hist( log(abs(diff(SWRs))), 100 ); % many are clustered, so non-log concentrates into first binSWRs=SWRs(find(SWRs>.03)); % eliminate negative SWR events
    % SWRs=SWRs(find(abs(diff(SWRs))>.06)); % eliminate SWR events that are too close together
    % swrIdx = round(SWRs*32000); % convert to index


% these were chosen across 'c6', 'c61', 'c88', 'c64', 'c76', so a separate
% index should be made for each to find the peak.
% furthermore, the SWRs don't appear on every channel every time, and
% sometimes are inverted


%   I. find corrected idx from peak value of event
windowSize = .03; % ms
sampleRate = 32000; % Hz
windowSizeIdx = round(windowSize*sampleRate);
% these were chosen across 'c6', 'c61', 'c88', 'c64', 'c76', so a separate
thisLfp=lfp61;   % SET THIS TO BE THE LFP YOU WANT TO ANALYZE
%thisLfp=lfp6;   % SET THIS TO BE THE LFP YOU WANT TO ANALYZE
%thisLfp=lfp88;   % SET THIS TO BE THE LFP YOU WANT TO ANALYZE
%thisLfp=lfp64;   % SET THIS TO BE THE LFP YOU WANT TO ANALYZE
%thisLfp=lfp76;   % SET THIS TO BE THE LFP YOU WANT TO ANALYZE

%% clean up manually marked events
    % eventTimes=swrBandBumps;
    % eventTimes=eventTimes(find(abs(diff(eventTimes))>.06)); % eliminate SWR events that are too close together
    % %SWRs=SWRs(find(abs(diff(SWRs))>.06)); % eliminate SWR events that are too close together
    % eventIdxs = round(eventTimes*32000); % convert to index
    %         if ( skewness(thisLfp) < 0 ); thisLfp = -thisLfp; end;
    %         eventPeakIdx=[];
    %         for ii = 1:length(eventIdxs)
    %             startIdx = eventIdxs(ii)-windowSizeIdx;
    %             if (startIdx < 1 ); startIdx = 1; end;
    %             endIdx =  eventIdxs(ii)+windowSizeIdx;
    %             if (endIdx > length(thisLfp) ); endIdx = length(thisLfp); end;
    %             % find idx of max value of absolute value of window
    %             [maxVal,maxIdx] = max(lfp61(startIdx:endIdx));
    %             % matlab should return maxIdx, but relative to the snippet
    %             % so, add the snippet idx to the current index, while adjusting for the
    %             % start index
    %             eventPeakIdx = [eventPeakIdx  eventIdxs(ii) - windowSizeIdx + maxIdx];
    %        end



% figure; plot(thisLfp); hold on; scatter(swrPeakIdx, thisLfp(swrPeakIdx), '*' )



% swrFilter = designfilt( 'bandpassiir',                 ...
%                         'FilterOrder',              8, ...
%                         'HalfPowerFrequency1',    110, ...
%                         'HalfPowerFrequency2',    240, ...
%                         'SampleRate',           sampleRate);

                    
filterBandLfp = filtfilt( filters.swr, thisLfp );
% find the envelope (to limit the peak detection)
filterBandLfpHilbert = hilbert( filterBandLfp );
filterLfpEnvelope = abs( filterBandLfpHilbert );
[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  filterLfpEnvelope,                              ... % data
                             sampleRate,                                  ... % sampling frequency
                             'MinPeakHeight',   std(filterLfpEnvelope)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                             'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

 figure(1); subplot(2,1,1); hist(filterLfpEnvelope,100); title('envelope input to findpeaks')
 subplot(2,1,2); hist(peakWidths,100); title('peakwidths (s)');

disp(['SWR rate @ minHeight std*6 ' num2str(std(swrLfpEnvelope)*6) ' is '  num2str(length(peakTimes)/(length(swrLfpEnvelope)/32000)) ' Hz'])

eventPeakIdx = 1+floor(peakTimes*sampleRate);



%%  II. event-trigered ...
%      A. average LFP
windowSize = .1; % ms
windowSizeIdx = round(windowSize*sampleRate);
lfpWindows = zeros(length(eventPeakIdx),round(1+(2*windowSizeIdx))); % where the windows go
for ii=1:length(eventPeakIdx)
    startIdx = eventPeakIdx(ii)-windowSizeIdx;
    endIdx =  eventPeakIdx(ii)+windowSizeIdx;
    if (startIdx > 1 ) && (endIdx < length(thisLfp) ) % skip events that violate ends
        lfpWindows(ii,:) = thisLfp(startIdx:endIdx);
    end
end
figure(3);
subplot(4,4,1); hold off; plot((-windowSizeIdx:windowSizeIdx)/sampleRate, lfpWindows, 'Color', [ 0 0 0 .01]); %hold on; for ii=1:length(swrPeakIdx); plot((-windowSizeIdx:windowSizeIdx)/sampleRate, lfpWindows(ii), 'Color', [rand(1,3) .1]); end; % avgLfpHandle.Color(:,4)=0.1; % http://undocumentedmatlab.com/blog/plot-line-transparency-and-color-gradient
hold on; plot((-windowSizeIdx:windowSizeIdx)/sampleRate, mean(lfpWindows), 'g', 'LineWidth', 1.5);  hold on; plot((-windowSizeIdx:windowSizeIdx)/sampleRate, median(lfpWindows), 'm', 'LineWidth', 1.5);
%subplot(3,1,2); hold on; for ii=1:length(swrPeakIdx); scatter((-windowSizeIdx:windowSizeIdx)/sampleRate, lfpWindows(ii,:), 'filled', 'MarkerFaceAlpha', .1); end;
title('all+avg+md LFP win');
%      B. velocity
subplot(4,4,2);  hold off;
[yy,xx]=hist(speed,100); plot(xx,yy/sum(yy),'o'); hold on;
[yy,xx]=hist((speed(1+floor(videoSampleRate*eventPeakIdx/lfpSampleRate))),xx);
plot(xx,yy/sum(yy),'*'); axis tight;
title('speed');
% % % *** reset the windowSize
windowSize = .05; % ms
windowSizeIdx = round(windowSize*sampleRate);
%      C. envelope full range
lfpEnv=abs(hilbert(thisLfp));
subplot(4,4,3);  hold off;
[yy,xx]=hist(lfpEnv(1+floor(length(lfpEnv)*rand(1,round(length(lfpEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(lfpEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(lfpEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(lfpEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(lfpEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(lfp)');
%      D. envelope SWR band
swrLfp=filtfilt(filters.swr, thisLfp);
swrEnv=abs(hilbert(swrLfp));
subplot(4,4,4);  hold off;
[yy,xx]=hist(swrEnv(1+floor(length(swrEnv)*rand(1,round(length(swrEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(swrEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(swrEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(swrEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(swrEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'*'); axis tight;
title('env(swr)');
%      E. envelope low gamma
loGamLfp=filtfilt(filters.lowGamma, thisLfp);
loGamEnv=abs(hilbert(loGamLfp));
subplot(4,4,5);  hold off;
[yy,xx]=hist(loGamEnv(1+floor(length(loGamEnv)*rand(1,round(length(loGamEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(loGamLfp)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(loGamLfp(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(loGamEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(loGamEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(loGam)');
%      F. envelope mid gamma
midGamLfp=filtfilt(filters.midGamma, thisLfp);
midGamEnv=abs(hilbert(midGamLfp));
subplot(4,4,6);  hold off;
[yy,xx]=hist(midGamEnv(1+floor(length(midGamEnv)*rand(1,round(length(midGamEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(midGamLfp)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(midGamLfp(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(midGamEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(midGamEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(midGam)');
%      G. envelope LIA
liaLfp=filtfilt(filters.lia, thisLfp);
liaEnv=abs(hilbert(liaLfp));
subplot(4,4,7);  hold off;
[yy,xx]=hist(liaEnv(1+floor(length(liaEnv)*rand(1,round(length(liaEnv)*.05)))),100); 
plot(xx,yy/sum(yy),'o'); hold on;
% slow filters screw up the edges of signals...
%temp=liaEnv(eventPeakIdx);
%temp=temp(find(temp<max(abs(thisLfp))));
%[yy,xx]=hist(temp,0:.05:1.2);
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(liaEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(liaEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(liaEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(liaEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;title('env(lia)');
%      H. area value
        % area=zeros(size(thisLfp));
        % windowSize=.04; % ms
        % windowSizeIdx = round(windowSize*sampleRate);
        % for idx=64000:length(liaLfp)  % SEEMS TO TAKE THE LIA a while to settle down.
        %     %energy(idx)=sqrt(sum(temp(idx:idx+windowSize).^2)); % actual energy calculation
        %     area(idx)=sum(abs(liaLfp(idx-windowSizeIdx:idx))); % cheaper calculation
        % end
        % % slow filters screw up the edges of signals...
        % temp=area(swrPeakIdx);
        % temp=area(find(temp<max(abs(area(end-1e6:end)))));
        % subplot(4,4,10);
        % [yy,xx]=hist(area(round(length(area)*rand(1,round(length(area)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
        % [yy,xx]=hist(temp,20);
        % plot(xx,yy/sum(yy),'*'); axis tight;
        % title('env(area)');

%      I. envelope theta
thetaLfp=filtfilt(filters.theta, thisLfp);
thetaEnv=abs(hilbert(thetaLfp));
subplot(4,4,8); hold off;
[yy,xx]=hist(thetaEnv(1+floor(length(thetaEnv)*rand(1,round(length(thetaEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(thetaEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(thetaEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(thetaEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(thetaEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(theta)');


%      x. envelope delta
deltaLfp=filtfilt(filters.delta, thisLfp);
deltaEnv=abs(hilbert(deltaLfp));
subplot(4,4,9); hold off;
[yy,xx]=hist(deltaEnv(1+floor(length(deltaEnv)*rand(1,round(length(deltaEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(deltaEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(deltaEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(deltaEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(deltaEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(delta)');
%      y. envelope high LFP
highLfp=filtfilt(filters.highLfp, thisLfp);
highEnv=abs(hilbert(highLfp));
subplot(4,4,10); hold off;
[yy,xx]=hist(highEnv(1+floor(length(highEnv)*rand(1,1+round(length(highEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(highEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(highEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(highEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(highEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(highLFP)');

% yy. envelope high LFP
alphaLfp=filtfilt(filters.alpha, thisLfp);
alphaEnv=abs(hilbert(alphaLfp));
subplot(4,4,11); hold off;
[yy,xx]=hist(alphaEnv(1+floor(length(alphaEnv)*rand(1,1+round(length(alphaEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(alphaEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(alphaEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(alphaEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(alphaEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(alphaLFP)');
% yy. envelope high LFP
betaLfp=filtfilt(filters.beta, thisLfp);
betaEnv=abs(hilbert(betaLfp));
subplot(4,4,12); hold off;
[yy,xx]=hist(betaEnv(1+floor(length(betaEnv)*rand(1,1+round(length(betaEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(betaEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(betaEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(betaEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(betaEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(betaLFP)');

% yy. envelope spike LFP
spikeLfp=filtfilt(filters.spike, thisLfp);
spikeEnv=abs(hilbert(spikeLfp));
subplot(4,4,13); hold off;
[yy,xx]=hist(spikeEnv(1+floor(length(spikeEnv)*rand(1,1+round(length(spikeEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(spikeEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(spikeEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(spikeEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(spikeEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(spikeLFP)');

% yy. envelope high LFP
nremLfp=filtfilt(filters.nrem, thisLfp);
nremEnv=abs(hilbert(nremLfp));
subplot(4,4,14); hold off;
[yy,xx]=hist(nremEnv(1+floor(length(nremEnv)*rand(1,1+round(length(nremEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(nremEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(nremEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(nremEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(nremEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(nremLFP)');

% yy. envelope high LFP
chewLfp=filtfilt(filters.chew, thisLfp);
chewEnv=abs(hilbert(chewLfp));
subplot(4,4,15); hold off;
[yy,xx]=hist(chewEnv(1+floor(length(chewEnv)*rand(1,1+round(length(chewEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(chewEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(chewEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); 
    jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(chewEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(chewEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;

title('env(chewLFP)');

% yy. envelope high LFP
electricLfp=filtfilt(filters.electric, thisLfp);
electricEnv=abs(hilbert(electricLfp));
subplot(4,4,16); hold off;
[yy,xx]=hist(electricEnv(1+floor(length(electricEnv)*rand(1,1+round(length(electricEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
windowMaxes = zeros(1,length(eventPeakIdx)); randPeakIdx=(1+floor(length(electricEnv)*rand(1,round(length(eventPeakIdx)))));
for ii=1:length(randPeakIdx); jj=randPeakIdx(ii)-windowSizeIdx:randPeakIdx(ii)+windowSizeIdx; if ((min(jj)>0) && (max(jj)<length(thisLfp))); windowMaxes(ii)=max(electricEnv(jj)); else; disp('violation'); end; end;
[yy,xx]=hist(windowMaxes,xx);
plot(xx,yy/sum(yy),'o'); axis tight;
windowMaxes = zeros(1,length(eventPeakIdx));
for ii=1:length(eventPeakIdx); jj=eventPeakIdx(ii)-windowSizeIdx:eventPeakIdx(ii)+windowSizeIdx; 
    if ((min(jj)>0) && (max(jj)<length(thisLfp))); 
        windowMaxes(ii)=max(electricEnv(jj)); 
    else; 
        disp('violation'); 
    end; 
end;
[yy,xx]=hist(windowMaxes,xx); hold on;
plot(xx,yy/sum(yy),'*'); axis tight;
[yy,xx]=hist(electricEnv(eventPeakIdx),xx);
plot(xx,yy/sum(yy),'+'); axis tight;
title('env(electricLFP)');

return;


% % yy. envelope high LFP
% spindleLfp=filtfilt(filters.spindle, thisLfp);
% spindleEnv=abs(hilbert(spindleLfp));
% subplot(4,4,10); hold off;
% [yy,xx]=hist(spindleEnv(1+floor(length(spindleEnv)*rand(1,1+round(length(spindleEnv)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
% [yy,xx]=hist(spindleEnv(swrPeakIdx),xx);
% plot(xx,yy/sum(yy),'*'); axis tight;
% title('env(spindleLFP)');



% figure;
% subplot(2,1,1); plot(thisLfp(1:1e6)); hold on; plot(lfpEnv(1:1e6));  axis tight;
% subplot(2,1,2); plot(kernLfp(1:1e6)); hold on; plot(kernEnv(1:1e6));  axis tight;



%      J. area value
        % areaL=zeros(size(thisLfp));
        % windowSize=.04; % ms
        % windowSizeIdx = round(windowSize*sampleRate);
        % for idx=1+windowSizeIdx:length(thisLfp)  % SEEMS TO TAKE THE LIA a while to settle down.
        %     %energy(idx)=sqrt(sum(temp(idx:idx+windowSize).^2)); % actual energy calculation
        %     areaL(idx)=sum(abs(thisLfp(idx-windowSizeIdx:idx))); % cheaper calculation
        % end
        % % slow filters screw up the edges of signals...
        % temp=areaL(swrPeakIdx);
        % temp=areaL(find(temp<max(abs(areaL(end-1e6:end)))));
        % subplot(4,4,12); hold off;
        % [yy,xx]=hist(areaL(round(length(areaL)*rand(1,round(length(areaL)*.05)))),100); plot(xx,yy/sum(yy),'o'); hold on;
        % [yy,xx]=hist(temp,20);
        % plot(xx,yy/sum(yy),'*'); axis tight;
        % title('env(areaL)');

return;




filters.midGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   60, 'HalfPowerFrequency2',  120, 'SampleRate', 32000);

filters.test      = designfilt( 'bandpassiir', 'FilterOrder',  12, 'HalfPowerFrequency1',   30, 'HalfPowerFrequency2',   80, 'SampleRate', 32000);
testLfp=filtfilt(filters.test, thisLfp);
testEnv=abs(hilbert(testLfp));
figure;
subplot(3,1,1);  plot(testLfp(1:1e6)); hold on; plot(testEnv(1:1e6));  axis tight;
subplot(3,1,2);  plot(thisLfp(1:1e6)); axis tight;
subplot(3,1,3);  plot(thisLfp(1:1e6)-testLfp(1:1e6)); axis tight;




return;



hold on; plot( timestampSeconds(ii), lfp76(ii) ); ylabel('c76');   axis tight;


subplot(6,1,5); plot( timestampSeconds(ii), lfp88(ii) ); hold on; plot(timestampSeconds(ii), slowLfp(ii)); plot(timestampSeconds(ii), slowLfp(ii)-slowLfp(ii-3200)); ylabel('c88'); hold off;  axis tight;
subplot(6,1,6); plot( xytimestampSeconds(1+round(29.97*ii/32000)), speed(1+round(29.97*ii/32000))); axis tight; ylabel('cm/s')



% 
% deltaFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',   0.1, 'HalfPowerFrequency2',      4, 'SampleRate',           32000);
% slowSwrFilter   = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',     1, 'HalfPowerFrequency2',     50, 'SampleRate',           32000);
% thetaFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',     4, 'HalfPowerFrequency2',     12, 'SampleRate',           32000);
% alphaFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',     8, 'HalfPowerFrequency2',     14, 'SampleRate',           32000);
% betaFilter      = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    14, 'HalfPowerFrequency2',     31, 'SampleRate',           32000);
% lowGammaFilter  = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    30, 'HalfPowerFrequency2',     80, 'SampleRate',           32000);
% midGammaFilter  = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    60, 'HalfPowerFrequency2',    120, 'SampleRate',           32000);
% swrFilter       = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',    99, 'HalfPowerFrequency2',    260, 'SampleRate',           32000);
% highLfpFilter   = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',   250, 'HalfPowerFrequency2',    600, 'SampleRate',           32000);
% spikeFilter     = designfilt( 'bandpassiir', 'FilterOrder',              8, 'HalfPowerFrequency1',   600, 'HalfPowerFrequency2',   6000, 'SampleRate',           32000);
% 
% deltaLfp     = filtfilt( deltaFilter, lfp88);
% slowSwrLfp   = filtfilt( slowSwrFilter, lfp88);
% thetaLfp     = filtfilt( thetaFilter, lfp88);
% alphaSwrLfp  = filtfilt( alphaFilter, lfp88);
% betaLfp      = filtfilt( betaFilter, lfp88);
% lowGammaLfp  = filtfilt( lowGammaFilter, lfp88);
% midGammaLfp  = filtfilt( midGammaFilter, lfp88);
% swrLfp       = filtfilt( swrFilter, lfp88);
% highLfp      = filtfilt( highLfpFilter, lfp88);
% spikeLfp     = filtfilt( spikeFilter, lfp88);
% 
% 
% deltaLfpEnv     = abs(hilbert(deltaLfp));
% slowSwrLfpEnv   = abs(hilbert(slowSwrLfp));
% thetaLfpEnv     = abs(hilbert(thetaLfp));
% alphaSwrLfpEnv  = abs(hilbert(alphaSwrLfp));
% betaLfpEnv      = abs(hilbert(betaLfp));
% lowGammaLfpEnv  = abs(hilbert(lowGammaLfp));
% midGammaLfpEnv  = abs(hilbert(midGammaLfp));
% swrLfpEnv       = abs(hilbert(swrLfp));
% highLfpEnv      = abs(hilbert(highLfp));
% spikeLfpEnv     = abs(hilbert(spikeLfp));
% 
% 
% deltaLfpNorm     = (deltaLfpEnv-min(deltaLfpEnv))/max(deltaLfpEnv-min(deltaLfpEnv));
% slowSwrLfpNorm   = (slowSwrLfpEnv-min(slowSwrLfpEnv))/max(slowSwrLfpEnv-min(slowSwrLfpEnv));
% thetaLfpNorm     = (thetaLfpEnv-min(thetaLfpEnv))/max(thetaLfpEnv-min(thetaLfpEnv));
% alphaSwrLfpNorm  = (alphaSwrLfpEnv-min(alphaSwrLfpEnv))/max(alphaSwrLfpEnv-min(alphaSwrLfpEnv));
% betaLfpNorm      = (betaLfpEnv-min(betaLfpEnv))/max(betaLfpEnv-min(betaLfpEnv));
% lowGammaLfpNorm  = (lowGammaLfpEnv-min(lowGammaLfpEnv))/max(lowGammaLfpEnv-min(lowGammaLfpEnv));
% midGammaLfpNorm  = (midGammaLfpEnv-min(midGammaLfpEnv))/max(midGammaLfpEnv-min(midGammaLfpEnv));
% swrLfpNorm       = (swrLfpEnv-min(swrLfpEnv))/max(swrLfpEnv-min(swrLfpEnv));
% highLfpNorm      = (highLfpEnv-min(highLfpEnv))/max(highLfpEnv-min(highLfpEnv));
% spikeLfpNorm     = (spikeLfpEnv-min(spikeLfpEnv))/max(spikeLfpEnv-min(spikeLfpEnv));
% 
% figure; imagesc([deltaLfpNorm     ,...
% slowSwrLfpNorm   ,...
% thetaLfpNorm     ,...
% alphaSwrLfpNorm  ,...
% betaLfpNorm      ,...
% lowGammaLfpNorm  ,...
% midGammaLfpNorm  ,...
% swrLfpNorm       ,...
% highLfpNorm      ,...
% spikeLfpNorm     ]); colormap(build_NOAA_colorgradient); colorbar;



% figure; plot(slowLfp(ii)-slowLfp(ii-3200)); hold on; plot(abs(hilbert(slowLfp(ii)-slowLfp(ii-3200)))); 
% plot(cumsum(slowLfp(ii)-slowLfp(ii-3200)));




startIdx = 1+round( 110 * 32000); endIdx = startIdx + 5*32000; ii=(startIdx:endIdx); % 110 to +5 has a good couple examples?

startIdx = 1+round( 80 * 32000); endIdx = startIdx + 35*32000; ii=(startIdx:endIdx);

figure(2); 
subplot(6,1,1); hold off; plot( timestampSeconds(ii), lfp61(ii) ); ylabel('c61');  axis tight;
hold on; plot( timestampSeconds(ii), lfp76(ii) ); ylabel('c76');   axis tight;
subplot(6,1,2); plot( timestampSeconds(ii), swrLfp(ii), 'Color', [ .9 .1 .2 ] );  ylabel('swr');  axis tight;
subplot(6,1,3); plot( timestampSeconds(ii), midGamLfp(ii), 'Color', [ .2 .9 .3 ] ); ylabel('{\gamma}_{mid}');   axis tight;
subplot(6,1,4); plot( timestampSeconds(ii), gamLfp(ii), 'Color', [ .3 .3 .3 ] ); ylabel('{\gamma}_{slow}');   axis tight;
subplot(6,1,5); plot( timestampSeconds(ii), lfp88(ii) ); hold on; plot(timestampSeconds(ii), slowLfp(ii)); plot(timestampSeconds(ii), slowLfp(ii)-slowLfp(ii-3200)); ylabel('c88'); hold off;  axis tight;
subplot(6,1,6); plot( xytimestampSeconds(1+round(29.97*ii/32000)), speed(1+round(29.97*ii/32000))); axis tight; ylabel('cm/s')

peakLag=slowLfp(ii)-slowLfp(ii-3200);

startIdx = 1691.5; for ii=1:6; subplot(6,1,ii); xlim([ startIdx startIdx+3 ]); end;


