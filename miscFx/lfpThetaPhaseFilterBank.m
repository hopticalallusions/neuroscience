function [ phase, envelope, frequency, signal, timestamp, thetaLFP, envelopeThetaLFP, bandpassCenterFrequencies ] = lfpThetaPhaseFilterBank( lfpFilename )
%function [ phase, filters, envelope, frequency, signal, timestamp, thetaLFP, envelopeThetaLFP, thetaPhaseRadians ] = lfpThetaPhaseFilterBank( lfpFilename, positionDataFilename, speedThreshold  )
%% FUNCTION DESCRIPTION
%
% == OUTPUTS ==
%
% phase       - instanteous phase estimate based on winning band (radians)
% envelope    - value of envelope corresponding to the phase (uV)
% frequency   - instant frequency value (Hz)
% signal      - voltage (uV) value of winning signal
% timestamp   - the timestamp of the data point
% bpFiltered  - matrix of filtered signals
% bpEnveloped - matrix of envelopes of filtered signals
% bpPhase     - matrix of phases of filtered signals
%
% == INPUTS  ==
%
% lfpFilename    - the input /file/
% positionTimes  - <optional> timestamps in Tad's timespace (0s elapsed  = 100)
% speed          - <optional> speed data (cm/s)
% speedThreshold - <optional> where to cut off the speed data (cm/s)
% filterBankAnalysis - <optional> boolean, specifies whether to plot
% figures about filterbank coverage
% 

% if (nargin <2) 
%     warning('ERROR! Not enough arguments!');
%     return
% end
% if (nargin <3) 
%     speedThreshold=7;
% end
% if (nargin >4) 
%     warning('WARNING Ignoring extra arguments after 3rd!');
% end

%  lfpFilename='~/Downloads/otheta8_day23_maybe_CSC11.ncs';
%  positionDataFilename='~/Downloads/Otheta8_Day23_BEHDATA.mat';
%  speedThreshold=7;
%  filterBankAnalysis = false;

% positionData=load(positionDataFilename);

%% obtain data
%clear all;
[lfp, fulltimestamps, header, channel, sampFreq, nValSamp ]=csc2mat(lfpFilename);
tmpIdx = strfind(header, 'ADBitVolts');
bitvolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
%% create data structures
% constants
lfp = lfp*(bitvolts*1e6); % convert lfp into microvolts
powerThreshold = 60; %round(1e-6*60/bitvolts); % A-to-D Values  ( 60 microvolts / bitvolts )
nativeSampleRate = 32000; % Hz
downsampleRate = 250; % Hz
everyNthSample = round(nativeSampleRate/downsampleRate); % 128 samples of each 32,000 (Hz) is 250 Hz
 
% All frequency values are in Hz.
Fs = nativeSampleRate;   % Sampling Frequency   (Hz)
Fpass = downsampleRate;  % Passband Frequency   (Hz)
Fstop = downsampleRate*2;% Stopband Frequency   (Hz)
Apass = 1;               % Passband Ripple      (dB)
Astop = 30;              % Stopband Attenuation (dB)
match = 'passband';      % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
lowpassFilter = design(h, 'butter', 'MatchExactly', match);
% be carfeul about changing this. pay attention to the automated filter
% band coefficient genetator loop below and the size of the coefficients.
% the matrices are currently fixed for 5 coefficients per bank
numberOfBbandsToPass = 34;
%numBpFilters=ObjectArray(numberOfBbandsToPass);
responsePoints = 1024;
%% filter analysis variables
wc = zeros(numberOfBbandsToPass,responsePoints);
zc = zeros(numberOfBbandsToPass,responsePoints);
pc = zeros(numberOfBbandsToPass,responsePoints);
oc = zeros(numberOfBbandsToPass,responsePoints);
for ii=1:numberOfBbandsToPass
    Fstop1 = 2;         % First Stopband Frequency
    Fpass1 = 3.4 + ii/4;         % First Passband Frequency
    Fpass2 = 3.8 + ii/4;         % Second Passband Frequency
    Fstop2 = 18;        % Second Stopband Frequency
    Astop1 = 30;          % First Stopband Attenuation (dB)
    Apass  = 1;           % Passband Ripple (dB)
    Astop2 = 30;          % Second Stopband Attenuation (dB)
    match  = 'passband';  % Band to match exactly
    % Construct an FDESIGN object and call its BUTTER method.
    h = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, downsampleRate);
    thetaFilter = design(h, 'butter', 'MatchExactly', match);
    bpFilter{ii} = thetaFilter;
    % analyze the filter
    [wc(ii,:),zc(ii,:)]=freqz(thetaFilter,responsePoints);
    [pc(ii,:),oc(ii,:)]=phasez(thetaFilter,responsePoints);
    bandpassCenterFrequencies(ii) = mean([Fpass1 Fpass2]);
end
bandpassGain = downsampleRate./(bandpassCenterFrequencies.^2);
%%
lowpassLFP = filter(lowpassFilter,lfp);
decimatedLFP = downsample(lowpassLFP,everyNthSample);
thetaLFP = zeros(numberOfBbandsToPass, length(decimatedLFP));
for ii = 1:numberOfBbandsToPass
    thetaLFP(ii,:) = filter(bpFilter{ii},decimatedLFP);
end
hilbertLFP = zeros(numberOfBbandsToPass, length(decimatedLFP));
for ii = 1:numberOfBbandsToPass
    hilbertLFP(ii,:) = hilbert(thetaLFP(ii,:));
end
thetaPhaseRadians = zeros(numberOfBbandsToPass, length(decimatedLFP));
envelopeThetaLFP = zeros(numberOfBbandsToPass, length(decimatedLFP));
for ii = 1:numberOfBbandsToPass
    thetaPhaseRadians(ii,:) = angle(hilbertLFP(ii,:));
    envelopeThetaLFP(ii,:) = abs(hilbertLFP(ii,:));
end

phaseMaster = zeros(1,round(length(envelopeThetaLFP)/everyNthSample)+1);
instantFrequency =  zeros(1,round(length(envelopeThetaLFP)/everyNthSample)+1);
instantEnvelope =  zeros(1,round(length(envelopeThetaLFP)/everyNthSample)+1);
instantSignal =  zeros(1,round(length(envelopeThetaLFP)/everyNthSample)+1);

% there's probably a fast, matrix way to implement this.
for ii = 1:length(envelopeThetaLFP(1,:))
    [mag,pos] = max(envelopeThetaLFP(:,ii));
    phaseMaster(ii) = thetaPhaseRadians(pos,ii);
    instantFrequency(ii) = bandpassCenterFrequencies(pos);
    instantEnvelope(ii) = envelopeThetaLFP(pos,ii);
    instantSignal(ii) = thetaLFP(pos,ii);
end

% for Tad's tools, all the timestamps are shifted into seconds from
% microseconds and then they are 100 relative to the first timestamp in the
% LFP data file.

timestamp = downsample(100+((fulltimestamps-fulltimestamps(1))/1e6), everyNthSample);
frequency =  instantFrequency;
phase = mod(phaseMaster,2*pi);
envelope = instantEnvelope;
signal = instantSignal;

return;

% 
% 
% timestamp = downsample(100+((fulltimestamps-fulltimestamps(1))/1e6), everyNthSample);
% frequency = interp1( timestamp, instantFrequency, positionData.tpos );
% phase = interp1( timestamp, mod(unwrap(phaseMaster),2*pi), positionData.tpos );
% envelope = interp1( timestamp, instantEnvelope, positionData.tpos );
% signal = interp1( timestamp, instantSignal, positionData.tpos );
% velocity = interp1( positionData.tpos, positionData.spd, timestamp );
% 
% 
% figure;
% subplot(4,1,1:2); hold on; plot(positionData.tpos(1:1000), signal(1:1000));
%   plot(positionData.tpos(1:1000), envelope(1:1000));
% subplot(4,1,3); plot(positionData.tpos(1:1000), frequency(1:1000));
% subplot(4,1,4); plot(positionData.tpos(1:1000), phase(1:1000));
% 
% %figure;
% subplot(4,1,1:2); hold on; plot(timestamp(1:10000), instantSignal(1:10000));
%   plot(timestamp(1:10000), instantEnvelope(1:10000));
% subplot(4,1,3); hold on; plot(timestamp(1:10000), instantFrequency(1:10000));
% subplot(4,1,4); hold on; plot(timestamp(1:10000), mod(unwrap(phaseMaster(1:10000)),2*pi));
% 
% 
% 
% 
% 
% [corr,lag]= xcorr(frequency,positionData.spd);
% figure; plot(lag, corr)
% 
% [corr,lag]= xcorr(envelope,positionData.spd);
% figure; plot(lag, corr)
% 
% figure;
% subplot(); plot(spd(1:10000)*88.38); line([ 0 10000 ],[ 7 7 ], 'Color', 'r');
% 
% figure;
% colormap(build_NOAA_colorgradient); 
% imagesc(  1:10000/downsampleRate, bandpassCenterFrequencies, (envelopeThetaLFP(:,1:10000))); colorbar;
% set(gca,'YDir','normal')
% xlabel('Time (s)');
% title('Envelope of High Resolution Theta Filter Bank (\muV)');
% ylabel('Freq (Hz)');
% 
% figure;
% colormap(buildCircularGradient); 
% imagesc(  1:10000/downsampleRate, bandpassCenterFrequencies, (thetaPhaseDegrees(:,1:10000))); colorbar;
% set(gca,'YDir','normal')
% xlabel('Time (s)');
% title('Envelope of High Resolution Theta Filter Bank (\muV)');
% ylabel('Freq (Hz)');
% 
% 
% return;

% 
% %% plot things
% figure; hold on; plot(enveloped(16,1:2048));plot(envelopeSmoothed(16,1:2048)); plot(abs(hilbert(bandpassed(16,1:2048))));
% pp=hilbert(bandpassed(16,1:2048)); oo=zeros(1,2048); for ii = 1:2048; [aa, hh]=cordicVector(imag(pp(ii)),real(pp(ii)),25); oo(ii)=hh; end; plot(oo); 
% legend('env','env smooth','tru hilb env','CORDIC on tru hilbert');
% 
% %for ii=1:numberOfBbandsToPass
% %e.g.
% ii=8;
%     figure;
%     trueHilbert = hilbert(bandpassed(ii,:));
%     subplot(4,1,1); plot(bandpassed(ii,1:2*downsampleRate)); hold on;  plot(enveloped(ii,1:2*downsampleRate)); legend('bandpassed','envelope'); title([  num2str(bandpassCenterFrequencies(ii)) ' Hz' ]);
%     subplot(4,1,2); plot(angled(ii,1:2*downsampleRate)); hold on;  plot(360/(2*pi)*(pi+angle(trueHilbert(1:2*downsampleRate)))); legend('CORDIC','mtlb angl'); plot(180/pi*(pi+atan2(hilberted(ii,1:2*downsampleRate),bandpassed(ii,1:2*downsampleRate))));
%     subplot(4,1,3); hold off; plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(hilberted(ii,1:2*downsampleRate)); legend('bandpassed','hilberted');
%     subplot(4,1,4); plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(imag(trueHilbert(1:2*downsampleRate))); legend('bandpassed','true hilbert');
% %end

% % example visualization of algorithm behavior
% secondsToPlot=5; figure; tt=(0:1/downsampleRate:secondsToPlot);
% subplot(4,1,1); plot(tt,envelopeSmoothed(:,1:secondsToPlot*downsampleRate+1)'); legend('envelopes'); %legend('4','5','6','7','8','9','10','11','12');
% subplot(4,1,2); plot(tt,instantFrequency(1:secondsToPlot*downsampleRate+1)); legend('instant freq');
% subplot(4,1,3); plot(tt,digitized(1:secondsToPlot*downsampleRate+1)); legend('ttl');
% subplot(4,1,4); plot(tt,bandpassed(15,1:secondsToPlot*downsampleRate+1)); legend([num2str(bandpassCenterFrequencies(15)) ' Hz']);
%
% % example data at various stages of processing
% secondsToPlot=5;
% figure; hold on;
% plot((0:1/nativeSampleRate:secondsToPlot),lfp(1:secondsToPlot*nativeSampleRate+1)*bitvolts);
% plot((0:1/nativeSampleRate:secondsToPlot),lowpassed(1:secondsToPlot*nativeSampleRate+1)*bitvolts);
% plot((0:1/downsampleRate:secondsToPlot),downsampled(1:secondsToPlot*downsampleRate+1)*bitvolts);
% plot((0:1/downsampleRate:secondsToPlot),bandpassed(4,1:secondsToPlot*downsampleRate+1)*bitvolts);
% legend('raw lfp','lowpass','downsample','bandpass'); title('Example Data After Different Stages'); xlabel('time (s)'); ylabel('potential (\muV)')
% 
% % compare the envelope before and after smoothing
% figure; colormap(build_NOAA_colorgradient); 
% subplot(2,1,1); imagesc(flipud(enveloped(:,1:9*downsampleRate))); colorbar; title('Matlab Envelopes'); ylabel('~4 <--> ~12 Hz');
% subplot(2,1,2); imagesc(flipud(envelopeSmoothed(:,1:9*downsampleRate))); colorbar; title('Env. Smooth');  ylabel('~4 <--> ~12 Hz'); xlabel('time (9 s)');
%
% % compare the delay approximation hilbert to the actual hilbert
% figure; subplot(4,1,1:2); tt=(1:2048)/250; hold on; plot(tt,bitvolts*enveloped(16,1:2048), 'r', 'LineWidth', 2); plot(tt,bitvolts*abs(hilbert(bandpassed(16,1:2048))),'Color', [.4 .4 .4] ,'LineWidth', 4); plot(tt,bitvolts*oo, 'Color', [ .1 .9 .2 ],'LineWidth', 1); 
% title('C/FPGA Algorithm Approximations vs True');ylabel('\muV'); axis([ 0 8 0 120]); legend('alg env','true env','CORDIC env(true hilbert)')
% subplot(4,1,3); plot(tt,bitvolts*(abs(hilbert(bandpassed(16,1:2048)))-oo));ylabel('\muV'); axis([ 0 8 -0.01 0 ]); legend('env. error true-CORDIC'); % true hilbert xform, error of env vs. CORDIC
% subplot(4,1,4); plot(tt,bitvolts*(abs(hilbert(bandpassed(16,1:2048)))-enveloped(16,1:2048)));ylabel('\muV'); legend('env. true-est '); % error of true hilbert vs alg. est.
% xlabel('time (s)'); ylabel('\muV'); axis([ 0 8 -7 7 ]); 

 if filterBankAnalysis
    % plot the filterbank
    figure;
    for ii=1:numberOfBbandsToPass
        subplot(4,1,1);
        hold on;
        plot(zc(ii,:)*(downsampleRate/2)/pi,20*log10(abs(wc(ii,:))/1))
        axis([ 2 14 -5 1 ])
        title('Frequency Response Plot');
        ylabel('attenuation (db, logrithmic)');
        subplot(4,1,2:4);
        hold on;
        plot(zc(ii,:)*(downsampleRate/2)/pi,20*log10(abs(wc(ii,:))/1))
        xlabel('frequency (hz)');
        ylabel('attenuation (db, logrithmic)');
        axis([ 0 (downsampleRate/2) -100 1 ])
    end
 end