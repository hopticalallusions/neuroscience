%% obtain data
clear all;
load('~/Desktop/cs259demodata.mat')
%% create data structures
% constants
%choose hilbert algorithm
whatHilbert = 'delay'; % 'fir' 'diff' 'delay'
bitvolts = 0.015624999960550667; % microvolts per bit
powerThreshold = 60; % microvolts
phaseSegmentsDesired = 10; % divisions of the phase of theta
nativeSampleRate = 32000; % Hz
downsampleRate = 250; % Hz
everyNthSample = round(nativeSampleRate/downsampleRate); % 128 samples of each 32,000 (Hz) is 250 Hz
lowpassNumeratorCoeffs =   [ 0.000000000006564694180131090961704897522  0.000000000039388165080786542539055117347  0.000000000098470412701966356347637793367  0.000000000131293883602621825696446486011  0.000000000098470412701966356347637793367  0.000000000039388165080786542539055117347  0.000000000006564694180131090961704897522  ];
lowpassDenominatorCoeffs = [ 1 -5.893323981110579090625378739787265658379 14.472294910655531197107848129235208034515  -18.955749009589681008947081863880157470703  13.966721637745113326900536776520311832428  -5.488755923739796926952294597867876291275  0.898812366459551981279219035059213638306  ];
lowpassNCoeff = min(length(lowpassDenominatorCoeffs),length(lowpassNumeratorCoeffs));
%
% be carfeul about changing this, because the matrix sizes are hard coded
numberOfBbandsToPass = 34;
bandpassDenominatorCoeffs = zeros(numberOfBbandsToPass,5);
bandpassNumeratorCoeffs = zeros(numberOfBbandsToPass,5);
bandpassNCoeff = min(length(bandpassDenominatorCoeffs),5);
bandpassCenterFrequencies = zeros(1,numberOfBbandsToPass);
delay_samples = zeros(1,numberOfBbandsToPass);
responsePoints = 1024;
%% filter analysis
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
    h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, downsampleRate);
    thetaFilter = design(h, 'butter', 'MatchExactly', match);
    % analyze the filter
    [wc(ii,:),zc(ii,:)]=freqz(thetaFilter,responsePoints);
    [pc(ii,:),oc(ii,:)]=phasez(thetaFilter,responsePoints);
    % Get the transfer function values.
    [b, a] = tf(thetaFilter);
    % Convert to a singleton filter.
    thetaFilter = dfilt.df2(b, a);
    % extract the coefficients
    bpcoefs = thetaFilter.coefficients; 
    bandpassDenominatorCoeffs(ii,:) = bpcoefs{2};
    bandpassNumeratorCoeffs(ii,:) = bpcoefs{1};
    bandpassCenterFrequencies(ii) = mean([Fpass1 Fpass2]);
    delay_samples(ii) = round(downsampleRate/(bandpassCenterFrequencies(ii) * 4)) ; % the 6.95 is the center frequency of the bandpass filter; need a bank of these values normally
end
bandpassGain = downsampleRate./(bandpassCenterFrequencies.^2);
% for checking the results
lowpassed = zeros(size(lfp));
downsampled = zeros(size(lfp));
bandpassed = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
hilberted = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
angled = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
enveloped = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
envelopeTemporalSmoothed = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
envelopeTemporalBandSmoothed = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
thresholded = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
maxBandpassIdx = zeros(1,ceil(length(lfp)/everyNthSample));
instantFrequency = zeros(1,ceil(length(lfp)/everyNthSample)); % what's the center frequency?
digitized = zeros(1,ceil(length(lfp)/everyNthSample)); % what port is active? -1 == NULL

deltaEnvTemporal=.1;

tic();
%% simulate the arrival of data samples
% cheat a little on the spool up
for idx=1: 320000 %length(lfp)
    
    %% lowpass
    % from http://www.ee.ic.ac.uk/pcheung/teaching/ee3_Study_Project/iir_lab2.pdf
    % iir xfer function : (might have errors...)
    % H(z) = ( b_0 + b_1 * z^-1 ... + b_n * z^-n ) / ( 1 + a_1 * z^-1 ... + a_n * z^-n )
    % becomes :
    % y(n)= b_0*x(n) + b_1*x(n-1) ...  + b_m*x(n-m) - a_1*y(n-1) ...  - a_m*y(n-m)
    % so basically, the result of the last calculation feeds into this one.
    % this means we can convert the calculation into linear algebra,
    % but we need to flip the coefficient order (better above than here,
    % really) because coef 0 should be multiplied by the current data, and
    % that will not happen in the normal orientations in matlab's dot
    % product  
    %lowpassed(idx) = sum(lowpassNumeratorCache.*lowpassNumeratorCoeffs) - sum(lowpassDenominatorCache.*lowpassDenominatorCoeffs);
    %lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    %lowpassDenominatorCache = [ lowpassed(idx) lowpassDenominatorCache(1:end-1) ];
    for k=1:min(idx,lowpassNCoeff) 
        lowpassed(idx) = lowpassed(idx) ...
            - lowpassed(idx-k+1)*lowpassDenominatorCoeffs(k)...
            + lfp(idx-k+1)*lowpassNumeratorCoeffs(k);
    end
   %% downsample
    
     if ( 0 == mod(idx, everyNthSample) )
         dsIdx = idx/everyNthSample;
         downsampled(dsIdx) = lowpassed(idx);
         %% bandpass  
        %bandpassCache = [ bandpassCache(2:end) lowpassed(idx) ]; % shift register
        %bandpassed(dsIdx) = bandpassCache*bandpassNumeratorCoeffs' + bandpassCache*-bandpassDenominatorCoeffs';
        for bp=1:numberOfBbandsToPass
            for k=1:min(dsIdx,bandpassNCoeff) 
                bandpassed(bp,dsIdx) = bandpassed(bp,dsIdx) ...
                    - bandpassed(bp,dsIdx-k+1)*bandpassDenominatorCoeffs(bp,k)...
                    + downsampled(dsIdx-k+1)*bandpassNumeratorCoeffs(bp,k);
            end
            %% hilbert
            %
            if strcmp( whatHilbert, 'fir')
                % Andrew's version
                %hilbertCache = [ bandpassed(idx/everyNthSample) hilbertCache(1:end-1)  ];
                %hilberted(dsIdx)= sum(hilbertCache.*hilbertNumeratorCoeffs);
                %
                % Colin's Version
                for k=1:min(dsIdx,hilbertNCoeffs)
                    hilberted(bp,dsIdx)= hilberted(bp,dsIdx) + bandpassed(bp,dsIdx-k+1)*hilbertNumeratorCoeffs(k);
                end
            elseif strcmp( whatHilbert, 'diff' )
                % differentiation version with empirical gain factor
                %   * this works because hilbert(sin(t)) == -cos(t) 
                %     and sin'(t) = cos(t)
                %     therefore, especially inside a very tight bandpass filter
                %     hilbert(sin(t)) is roughly equivalent to - dv/dt (signal)
                if dsIdx > 1
                    hilberted(bp,dsIdx) =  bandpassGain(bp)*(bandpassed(bp,dsIdx-1) - bandpassed(bp,dsIdx));
                end
            elseif strcmp( whatHilbert, 'delay' )
                % delay approximation
                % given :
                %   a tightly bandpassed signal 
                %   a hilbert is a 90 degree phase shift of a signal
                % then, it follows that
                %   a hilbert transform on the tightly bandpassed signal is
                %   approximately equal to the original signal delayed by 
                %   delay_samples = sample_rate/(center_freq * 4)
                if dsIdx > delay_samples(bp)
                    hilberted(bp,dsIdx) =  bandpassed(bp,dsIdx-delay_samples(bp));
                end
            else
                disp('no such algorithm')
                return;
             end
             %% CORDIC
             [ angled(bp,dsIdx) , enveloped(bp,dsIdx)] = cordicVector(bandpassed(bp,dsIdx),hilberted(bp,dsIdx),20);
        end    
         %% envelope smoothing
         if dsIdx == 1
             envelopeTemporalSmoothed(:,dsIdx) = enveloped(:,dsIdx);
         else
             envelopeTemporalSmoothed(:,dsIdx) = (1-deltaEnvTemporal)*envelopeTemporalSmoothed(:,dsIdx-1) + (deltaEnvTemporal)*enveloped(:,dsIdx);
         end
         tempUp = envelopeTemporalSmoothed(:,dsIdx);
         tempDown = tempUp;
         for ii=2:numberOfBbandsToPass
             tempUp(ii) = (1-deltaEnvTemporal)*envelopeTemporalSmoothed(ii-1,dsIdx) + (deltaEnvTemporal)*envelopeTemporalSmoothed(ii,dsIdx);
             tempDown(numberOfBbandsToPass-ii+1) = (1-deltaEnvTemporal)*envelopeTemporalSmoothed(numberOfBbandsToPass-ii+2,dsIdx) + (deltaEnvTemporal)*envelopeTemporalSmoothed(numberOfBbandsToPass-ii+1,dsIdx);
         end
         envelopeTemporalBandSmoothed(:,dsIdx) = (tempUp+tempDown)/2;
         %% threshold check
         [mag,pos] = max(envelopeTemporalBandSmoothed(:,dsIdx));
         maxBandpassIdx(dsIdx) = pos;
         if ( mag * bitvolts < powerThreshold )
             % the output is NULL
             digitized(dsIdx) = -1;
         else
             %% map to digital out
             % i.e. what TTL is currently on
             instantFrequency(dsIdx)= bandpassCenterFrequencies(pos);
             digitized(dsIdx) = floor(angled(pos,dsIdx)/(359/phaseSegmentsDesired));
         end
    end
end
toc()

%% plot things
%for ii=1:numberOfBbandsToPass
%e.g.
ii=8;
    figure;
    trueHilbert = hilbert(bandpassed(ii,:));
    subplot(4,1,1); plot(bandpassed(ii,1:2*downsampleRate)); hold on;  plot(enveloped(ii,1:2*downsampleRate)); legend('bandpassed','envelope'); title([ whatHilbert ' ' num2str(bandpassCenterFrequencies(ii)) ' Hz' ]);
    subplot(4,1,2); plot(angled(ii,1:2*downsampleRate)); hold on;  plot(360/(2*pi)*(pi+angle(trueHilbert(1:2*downsampleRate)))); legend('CORDIC','mtlb_angle');
    subplot(4,1,3); hold off; plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(hilberted(ii,1:2*downsampleRate)); legend('bandpassed','hilberted');
    subplot(4,1,4); plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(imag(trueHilbert(1:2*downsampleRate))); legend('bandpassed','true hilbert');
%end

figure; 
subplot(4,1,1); plot(envelopeTemporalBandSmoothed(:,1:5*downsampleRate)'); legend('envelopes'); %legend('4','5','6','7','8','9','10','11','12');
subplot(4,1,2); plot(instantFrequency(1:5*downsampleRate)); legend('instant freq');
subplot(4,1,3); plot(digitized(1:5*downsampleRate)); legend('ttl');
subplot(4,1,4); plot(bandpassed(15,1:5*downsampleRate)); legend([num2str(bandpassCenterFrequencies(15)) ' Hz']);

secondsToPlot=5;
figure; hold on;
plot((0:1/nativeSampleRate:secondsToPlot),lfp(1:secondsToPlot*nativeSampleRate+1))
plot((0:1/nativeSampleRate:secondsToPlot),lowpassed(1:secondsToPlot*nativeSampleRate+1))
plot((0:1/downsampleRate:secondsToPlot),downsampled(1:secondsToPlot*downsampleRate+1))
plot((0:1/downsampleRate:secondsToPlot),bandpassed(4,1:secondsToPlot*downsampleRate+1))
% this is annoying.
% bpo=zeros(1,100000);
% for ii=1:secondsToPlot*downsampleRate+1;
%     bpo(ii) = bandpassed(maxBandpassIdx(ii),ii);
% end
% plot((0:1/downsampleRate:secondsToPlot),bandpassed(maxBandpassIdx(1:secondsToPlot*downsampleRate+1),1:secondsToPlot*downsampleRate+1))
% figure; plot(bpo(1:secondsToPlot*downsampleRate+1))

%figure; subplot(2,1,1); hold on; plot(enveloped(16,1:9*downsampleRate)); plot(envelopeTemporalSmoothed(16,1:9*downsampleRate)); plot(envelopeTemporalBandSmoothed(16,1:9*downsampleRate));
%subplot(2,1,2); hold on; plot(enveloped(:,1200)); plot(envelopeTemporalSmoothed(:,1200)); plot(envelopeTemporalBandSmoothed(:,1200));
%
figure; colormap(build_NOAA_colorgradient); 
subplot(3,1,1); imagesc(flipud(enveloped(:,1:9*downsampleRate))); colorbar; title('envelope'); ylabel('~4 <--> ~12 Hz');
subplot(3,1,2); imagesc(flipud(envelopeTemporalSmoothed(:,1:9*downsampleRate))); colorbar; title('temporal smoothing');  ylabel('~4 <--> ~12 Hz');
subplot(3,1,3); imagesc(flipud(envelopeTemporalBandSmoothed(:,1:9*downsampleRate))); colorbar; title('temporal & frequency smoothing');  ylabel('~4 <--> ~12 Hz'); xlabel('time (9 s)');
