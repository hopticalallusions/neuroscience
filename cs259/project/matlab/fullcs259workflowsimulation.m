%% obtain data
clear all;
load('/Users/andrewhowe/data/cs259demodata.mat')
%% create data structures
% constants
bitvolts = 0.015624999960550667; % microvolts per bit
powerThreshold = round(60/bitvolts); % A-to-D Values  ( 60 microvolts / bitvolts )
phaseSegmentsDesired = 10; % divisions of the phase of theta
nativeSampleRate = 32000; % Hz
downsampleRate = 250; % Hz
everyNthSample = round(nativeSampleRate/downsampleRate); % 128 samples of each 32,000 (Hz) is 250 Hz
lowpassNumeratorCoeffs =   [ 0.000000000006564694180131090961704897522  0.000000000039388165080786542539055117347  0.000000000098470412701966356347637793367  0.000000000131293883602621825696446486011  0.000000000098470412701966356347637793367  0.000000000039388165080786542539055117347  0.000000000006564694180131090961704897522  ];
lowpassDenominatorCoeffs = [ 1 -5.893323981110579090625378739787265658379 14.472294910655531197107848129235208034515  -18.955749009589681008947081863880157470703  13.966721637745113326900536776520311832428  -5.488755923739796926952294597867876291275  0.898812366459551981279219035059213638306  ];
lowpassDenominatorCoeffs(1) = 0; % compensate for loop design.
lowpassNCoeff = min(length(lowpassDenominatorCoeffs),length(lowpassNumeratorCoeffs));
cordicItr=13;
cordicGainCorrection = 1/prod(sqrt(1+(2.^(-2.*(0:cordicItr)))));
%cordicArctanLookup = 45.*(2.^-(0:cordicItr));
cordicArctanLookup = 180/pi*atan(2.^-(0:cordicItr));

%
% be carfeul about changing this. pay attention to the automated filter
% band coefficient genetator loop below and the size of the coefficients.
% the matrices are currently fixed for 5 coefficients per bank
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
lowpassedRB = zeros(size(lfp));
downsampled = zeros(size(lfp));
bandpassed = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
hilberted = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
angled = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
enveloped = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
envelopeSmoothed = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
thresholded = zeros(numberOfBbandsToPass,ceil(length(lfp)/everyNthSample));
maxBandpassIdx = zeros(1,ceil(length(lfp)/everyNthSample));
instantFrequency = zeros(1,ceil(length(lfp)/everyNthSample)); % what's the center frequency?
digitized = zeros(1,ceil(length(lfp)/everyNthSample)); % what port is active? -1 == NULL
% for averaging the envelopes 
deltaEnvTemporal=.01;
% shift buffers
lowpassNumeratorCache=zeros(1,lowpassNCoeff);
lowpassDenominatorCache=zeros(1,lowpassNCoeff);
lowpassNumeratorCacheRB=zeros(1,lowpassNCoeff);
lowpassDenominatorCacheRB=zeros(1,lowpassNCoeff);
bandpassNumeratorCache=zeros(numberOfBbandsToPass,bandpassNCoeff);
bandpassDenominatorCache=zeros(numberOfBbandsToPass,bandpassNCoeff);
hilbertCache=zeros( numberOfBbandsToPass, max(delay_samples) );
envelopeCache=zeros( numberOfBbandsToPass, 2);
envelopeSmoothTemp=zeros( numberOfBbandsToPass, 1);
lpBuffPtr=10;
tic();
close all;
%% simulate the arrival of data samples
for idx=1: 1280 %320000 %length(lfp)
    %% lowpass
    lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    lowPassOut = 0;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
    for k=1:lowpassNCoeff
        %lowPassOut = lowPassOut - ...
        %    lowpassDenominatorCache(k)*lowpassDenominatorCoeffs(k) + ...
        %    lowpassNumeratorCache(k)*lowpassNumeratorCoeffs(k);
        lowpassDenominatorCache(1) = lowpassDenominatorCache(1) - ...
            lowpassDenominatorCache(k)*lowpassDenominatorCoeffs(k) + ...
            lowpassNumeratorCache(k)*lowpassNumeratorCoeffs(k);
    end
    % ring buffer version
    rbNCoeff = length(lowpassDenominatorCoeffs);
    rbN=mod(lpBuffPtr,rbNCoeff)+1;
    rbRaw = 0;
    rbFilt= 0;
    lowpassDenominatorCacheRB(rbN) = 0;
    lowpassNumeratorCacheRB(rbN ) = lfp(idx);
    rbIdx=zeros(2,rbNCoeff);
    % signal progresses left (oldest) to right (newest)  // could flip this by subtracting from max value
    % coeff progress left (newest) to right (oldest)
    % this works, but only when the first coefficient is set to zero, and ;
    % I suspect there's some sort of off by 1 error at work here
    % it is lagged, which is a bit strange
    for k=0:rbNCoeff-1;
        lowpassDenominatorCacheRB(rbN) = lowpassDenominatorCacheRB(rbN) - lowpassDenominatorCacheRB(1+mod(lpBuffPtr-k,rbNCoeff))*lowpassDenominatorCoeffs(k+1) + lowpassNumeratorCacheRB(1+mod(lpBuffPtr-k,rbNCoeff))*lowpassNumeratorCoeffs(k+1);
    end
    lpBuffPtr=lpBuffPtr+1;
    % end RB part
    %lowpassDenominatorCache(1) = lowPassOut;
    lowpassed(idx) = lowpassDenominatorCache(1);%lowPassOut; % accounting
    lowpassedRB(idx) = lowpassDenominatorCacheRB(1+mod(lpBuffPtr,length(lowpassDenominatorCacheRB)));
    %% downsample
    if ( 0 == mod(idx, everyNthSample) )
        dsIdx = idx/everyNthSample;
        downsampled(dsIdx) = lowPassOut;  % accounting
        %% bandpass  
        for bp=1:numberOfBbandsToPass
            % shift register version of bandpass filtering
            bandpassNumeratorCache(bp,:) = [ lowPassOut bandpassNumeratorCache(bp,1:bandpassNCoeff-1) ]; % shift register  
            bandPassOut = 0;
            bandpassDenominatorCache(bp,:) = [ bandPassOut bandpassDenominatorCache(bp,1:bandpassNCoeff-1)  ];
            for k=1:bandpassNCoeff
                bandPassOut = bandPassOut - bandpassDenominatorCache(bp,k)*bandpassDenominatorCoeffs(bp,k) + bandpassNumeratorCache(bp,k)*bandpassNumeratorCoeffs(bp,k);
            end
            bandpassDenominatorCache(bp,1) = bandPassOut;
            bandpassed(bp,dsIdx) = bandPassOut; % accounting
            %% CORDIC
            %[ angled(bp,dsIdx) , enveloped(bp,dsIdx)] = cordicVector(bandpassed(bp,dsIdx),hilberted(bp,dsIdx),20);
            xo = bandPassOut;
            yo = hilbertCache(bp,delay_samples(bp)); %hilberted(bp,dsIdx);
            if ( xo > 0 ) %&& ( yo > 0 )
                xx = xo;
                yy = yo;
                zz = 180;  %180 offset pi
            else 
                if ( yo < 0 )
                    xx = -yo;
                    yy = xo;
                    zz = 90; %90 offset pi/2
                else
                    xx = yo;
                    yy = -xo;
                    zz = 270; % offset  3*pi/2
                end
            end
            for ii = 0:cordicItr-1
                ih = ii+2;
                yLast = yy;
                xLast = xx;
                if ( yy < 0 )
                    xx = xx - ( yLast / bitshift(1,ii) );
                    yy = yy + ( xLast / bitshift(1,ii) );
                    zz = zz - ( cordicArctanLookup(ii+1) );
                else
                    xx = xx + ( yLast / bitshift(1,ii) );
                    yy = yy - ( xLast / bitshift(1,ii) );
                    zz = zz + ( cordicArctanLookup(ii+1)  );
                end
            end
            enveloped(bp,dsIdx) = xx*cordicGainCorrection;  % accounting
            angled(bp,dsIdx) = zz;  % accounting
            envelopeCache(bp,2) = xx*cordicGainCorrection;
            %% hilbert -- delay approximation
            hilberted(bp,dsIdx) =  hilbertCache(bp,delay_samples(bp));  % accounting
            hilbertCache(bp,2:max(delay_samples)) = hilbertCache(bp,1:max(delay_samples)-1);
            hilbertCache(bp,1) = bandPassOut;
        end
        %% envelope smoothing
        if dsIdx > 1
            envelopeSmoothTemp(1) = ( .9*envelopeCache(1,1)) + (.05* envelopeCache(1,2)) + (.05* envelopeCache(2,2));
            for ii = 2:numberOfBbandsToPass-1
                envelopeSmoothTemp(ii) = ( 0.8*envelopeCache(ii,1)) + (0.1* envelopeCache(ii,2)) + (0.05* envelopeCache(ii-1,1)) + (0.05* envelopeCache(ii+1,1));
            end
            envelopeSmoothTemp(numberOfBbandsToPass) = ( .9*envelopeCache(ii,1)) + (.05* envelopeCache(ii,2)) + (.05* envelopeCache(ii-1,2));
        else
            envelopeSmoothTemp = envelopeCache(:,2);
        end
        envelopeSmoothed(:,dsIdx) = envelopeSmoothTemp; % accounting
        envelopeCache(:,1) = envelopeSmoothTemp;
        %% threshold check
        [mag,pos] = max(envelopeSmoothTemp);
        maxBandpassIdx(dsIdx) = pos; % accounting
        if ( mag < powerThreshold )
            % the output is NULL
            digitized(dsIdx) = -1;
        else
            %% map to digital out
            % i.e. what TTL is currently on
            instantFrequency(dsIdx)= bandpassCenterFrequencies(pos);
            digitized(dsIdx) = ceil(angled(pos,dsIdx)/(360/phaseSegmentsDesired));
        end
    end
end
toc()
return; %ringbuffer
%% plot things
figure; hold on; plot(enveloped(16,1:2048));plot(envelopeSmoothed(16,1:2048)); plot(abs(hilbert(bandpassed(16,1:2048))));
pp=hilbert(bandpassed(16,1:2048)); oo=zeros(1,2048); for ii = 1:2048; [aa, hh]=cordicVector(imag(pp(ii)),real(pp(ii)),25); oo(ii)=hh; end; plot(oo); 
legend('env','env smooth','tru hilb env','CORDIC on tru hilbert');

%for ii=1:numberOfBbandsToPass
%e.g.
ii=8;
    figure;
    trueHilbert = hilbert(bandpassed(ii,:));
    subplot(4,1,1); plot(bandpassed(ii,1:2*downsampleRate)); hold on;  plot(enveloped(ii,1:2*downsampleRate)); legend('bandpassed','envelope'); title([  num2str(bandpassCenterFrequencies(ii)) ' Hz' ]);
    subplot(4,1,2); plot(angled(ii,1:2*downsampleRate)); hold on;  plot(360/(2*pi)*(pi+angle(trueHilbert(1:2*downsampleRate)))); legend('CORDIC','mtlb angl'); plot(180/pi*(pi+atan2(hilberted(ii,1:2*downsampleRate),bandpassed(ii,1:2*downsampleRate))));
    subplot(4,1,3); hold off; plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(hilberted(ii,1:2*downsampleRate)); legend('bandpassed','hilberted');
    subplot(4,1,4); plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(imag(trueHilbert(1:2*downsampleRate))); legend('bandpassed','true hilbert');
%end

% example visualization of algorithm behavior
secondsToPlot=5; figure; tt=(0:1/downsampleRate:secondsToPlot);
subplot(4,1,1); plot(tt,envelopeSmoothed(:,1:secondsToPlot*downsampleRate+1)'); legend('envelopes'); %legend('4','5','6','7','8','9','10','11','12');
subplot(4,1,2); plot(tt,instantFrequency(1:secondsToPlot*downsampleRate+1)); legend('instant freq');
subplot(4,1,3); plot(tt,digitized(1:secondsToPlot*downsampleRate+1)); legend('ttl');
subplot(4,1,4); plot(tt,bandpassed(15,1:secondsToPlot*downsampleRate+1)); legend([num2str(bandpassCenterFrequencies(15)) ' Hz']);

% example data at various stages of processing
secondsToPlot=5;
figure; hold on;
plot((0:1/nativeSampleRate:secondsToPlot),lfp(1:secondsToPlot*nativeSampleRate+1)*bitvolts);
plot((0:1/nativeSampleRate:secondsToPlot),lowpassed(1:secondsToPlot*nativeSampleRate+1)*bitvolts);
plot((0:1/downsampleRate:secondsToPlot),downsampled(1:secondsToPlot*downsampleRate+1)*bitvolts);
plot((0:1/downsampleRate:secondsToPlot),bandpassed(4,1:secondsToPlot*downsampleRate+1)*bitvolts);
legend('raw lfp','lowpass','downsample','bandpass'); title('Example Data After Different Stages'); xlabel('time (s)'); ylabel('potential (\muV)')

% compare the envelope before and after smoothing
figure; colormap(build_NOAA_colorgradient); 
subplot(2,1,1); imagesc(flipud(enveloped(:,1:9*downsampleRate))); colorbar; title('Matlab Envelopes'); ylabel('~4 <--> ~12 Hz');
subplot(2,1,2); imagesc(flipud(envelopeSmoothed(:,1:9*downsampleRate))); colorbar; title('Env. Smooth');  ylabel('~4 <--> ~12 Hz'); xlabel('time (9 s)');

% compare the delay approximation hilbert to the actual hilbert
figure; subplot(4,1,1:2); tt=(1:2048)/250; hold on; plot(tt,bitvolts*enveloped(16,1:2048), 'r', 'LineWidth', 2); plot(tt,bitvolts*abs(hilbert(bandpassed(16,1:2048))),'Color', [.4 .4 .4] ,'LineWidth', 4); plot(tt,bitvolts*oo, 'Color', [ .1 .9 .2 ],'LineWidth', 1); 
title('C/FPGA Algorithm Approximations vs True');ylabel('\muV'); axis([ 0 8 0 120]); legend('alg env','true env','CORDIC env(true hilbert)')
subplot(4,1,3); plot(tt,bitvolts*(abs(hilbert(bandpassed(16,1:2048)))-oo));ylabel('\muV'); axis([ 0 8 -0.01 0 ]); legend('env. error true-CORDIC'); % true hilbert xform, error of env vs. CORDIC
subplot(4,1,4); plot(tt,bitvolts*(abs(hilbert(bandpassed(16,1:2048)))-enveloped(16,1:2048)));ylabel('\muV'); legend('env. true-est '); % error of true hilbert vs alg. est.
xlabel('time (s)'); ylabel('\muV'); axis([ 0 8 -7 7 ]); 

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
