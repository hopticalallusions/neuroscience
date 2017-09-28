load('~/src/cs259demodata.mat')

%% offline version
% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency
Fpass = 250;         % Passband Frequency
Fstop = 500;         % Stopband Frequency
Apass = 1;           % Passband Ripple (dB)
Astop = 30;          % Stopband Attenuation (dB)
match = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
lowpassFilter = design(h, 'butter', 'MatchExactly', match);

% All frequency values are in Hz.
Fs = 250;  % Sampling Frequency
Fstop1 = 3; %2.7;         % First Stopband Frequency
Fpass1 = 5; %6.7;         % First Passband Frequency
Fpass2 = 12; %7.7;         % Second Passband Frequency
Fstop2 = 14; %14.7;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
wideThetaFilter = design(h, 'butter', 'MatchExactly', match);
% "offline version"
ideal.lowpassLFP = filter(lowpassFilter,lfp);
ideal.decimatedLFP = downsample(ideal.lowpassLFP,128);
ideal.thetaLFP = filter(wideThetaFilter,ideal.decimatedLFP);
ideal.hilbertLFP = hilbert(ideal.thetaLFP);
ideal.thetaPhaseRadians = angle(ideal.hilbertLFP); %angle
ideal.thetaPhaseDegrees = ideal.thetaPhaseRadians*180/pi;
ideal.envelopeThetaLFP = abs(ideal.hilbertLFP);

%% online version
%% obtain data
%clear all;
%load('~/Desktop/cs259demodata.mat')
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
bandpassNumeratorCache=zeros(numberOfBbandsToPass,bandpassNCoeff);
bandpassDenominatorCache=zeros(numberOfBbandsToPass,bandpassNCoeff);
hilbertCache=zeros( numberOfBbandsToPass, max(delay_samples) );
envelopeCache=zeros( numberOfBbandsToPass, 2);
envelopeSmoothTemp=zeros( numberOfBbandsToPass, 1);
tic();
%% simulate the arrival of data samples
for idx=1:length(lfp)
    %% lowpass
    lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    lowPassOut = 0;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
    for k=1:lowpassNCoeff
        lowPassOut = lowPassOut - lowpassDenominatorCache(k)*lowpassDenominatorCoeffs(k) + lowpassNumeratorCache(k)*lowpassNumeratorCoeffs(k);
    end
    lowpassDenominatorCache(1) = lowPassOut;
    lowpassed(idx) = lowPassOut; % accounting
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


online.lowpassed = lowpassed;
online.downsampled = downsampled;
online.hilberted = hilberted;
online.angled = angled;
online.enveloped = enveloped;
online.envelopeSmoothed = envelopeSmoothed;
online.thresholded = thresholded;
online.instantFrequency = instantFrequency;
online.digitized = digitized;
online.bandpassed = bandpassed;

secStart=6.1;
secEnd=9;
figure;
tta=secStart*32000:secEnd*32000;
subplot(8,1,1:3);hold on; plot((1:length(lfp(tta)))/32000,lfp(tta),'Color',[ .6 .6 .6 ]); %gray
subplot(8,1,1:3); plot((1:length(ideal.lowpassLFP(tta)))/32000,ideal.lowpassLFP(tta),'Color',[ 0 .5 1 ]); % blue
ttb=secStart*250:secEnd*250;
subplot(8,1,1:3); plot((1:length(ideal.decimatedLFP(ttb)))/250,ideal.decimatedLFP(ttb),'Color',[ 0 .5 0 ]); %green
subplot(8,1,1:3); plot((1:length(ideal.thetaLFP(ttb)))/250,ideal.thetaLFP(ttb),'Color',[ 1 .6 1 ]); %orange
subplot(8,1,1:3); plot((1:length(ideal.envelopeThetaLFP(ttb)))/250,ideal.envelopeThetaLFP(tt),'Color',[ 1 0 1 ]); %pink
legend('raw','lowp','decim','\Theta','env');
subplot(8,1,4); plot((1:length(ideal.thetaPhaseDegrees(ttb)))/250,ideal.thetaPhaseDegrees(ttb)); legend('deg.')
%
subplot(8,1,5:7); plot((1:length(lfp(tta)))/32000,lfp(tta),'Color',[ .6 .6 .6 ]); hold on;
subplot(8,1,5:7); plot((1:length(online.lowpassed(tta)))/32000,online.lowpassed(tta),'Color',[ 0 .5 1 ]);
subplot(8,1,5:7); plot((1:length(online.downsampled(ttb)))/250,online.downsampled(ttb),'Color',[ 0 .5 0 ]);
tempbp=length(ttb); tempenv=length(ttb); for ii=1:length(ttb); tempbp(ii)=bandpassed(maxBandpassIdx(ttb(ii)),ttb(ii));  tempenv(ii)=enveloped(maxBandpassIdx(ttb(ii)),ttb(ii)); end;
subplot(8,1,5:7); plot((1:length(tempbp))/250,tempbp, 'Color', [ 1 .6 1 ]);hold on;
subplot(8,1,5:7); plot((1:length(tempenv))/250,tempenv,'Color',[ 1 0 1 ]);
legend('raw','lowp','decim','\Theta','env');
subplot(8,1,8); plot((1:length(online.digitized(ttb)))/250,online.digitized(ttb)); hold on;
subplot(8,1,8); plot((1:length(online.instantFrequency(ttb)))/250,online.instantFrequency(ttb),'r');
legend('deg.','freq');




return;

figure;



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




figure;
subplot(3,1,1);
plot(zc(15,:)*(Fs/2)/pi,20*log10(abs(wc(15,:))/1))
axis([ 2 14 -10 1 ])
title('Frequency Response Plot');
ylabel('attenuation (db, logrithmic)');
subplot(3,1,2);
plot(oc(15,:)*(Fs/2)/pi,(pc(15,:))*180/pi);
title('filter phase shift ')
xlabel('frequency (hz)');
ylabel('shift (deg)');
axis([ 2 14 -pi*180/pi pi*180/pi ])
line([0 Fs/2],[ 0 0 ],'color','k','LineStyle', '--')
subplot(3,1,3);
plot(zc(15,:)*(Fs/2)/pi,20*log10(abs(wc(15,:))/1))
hold on;
plot(oc(15,:)*(Fs/2)/pi,pc(15,:));
axis([ 2 14 -pi pi ])
line([0 Fs/2],[ 0 0 ],'color','k','LineStyle', '--')
legend('Z','\phi','?')










% All frequency values are in Hz.
Fs = 250;  % Sampling Frequency
Fstop1 = 3;         % First Stopband Frequency
Fpass1 = 5;         % First Passband Frequency
Fpass2 = 12;         % Second Passband Frequency
Fstop2 = 14;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
thetaFilter = design(h, 'butter', 'MatchExactly', match);

[wlp,zlp]=freqz(thetaFilter,responsePoints);
[plp,olp]=phasez(thetaFilter,responsePoints);

figure; Fs=250; subplot(3,1,1);
plot(zlp*(Fs/2)/pi,20*log10(abs(wlp)/1));
axis([ 2 14 -20 1 ]);
title('Frequency Response Plot');
ylabel('attenuation (db, logrithmic)');
subplot(3,1,2);
plot(olp*(Fs/2)/pi,(plp)*180/pi);
title('filter phase shift ')
xlabel('frequency (hz)');
ylabel('shift (deg)');
axis([ 2 14 2*-pi*180/pi 2*pi*180/pi ])
line([0 Fs/2],[ 0 0 ],'color','k','LineStyle', '--')
subplot(3,1,3);
plot(zlp(15,:)*(Fs/2)/pi,20*log10(abs(wlp(15,:))/1))
hold on;
plot(olp(15,:)*(Fs/2)/pi,plp(15,:));
%axis([ 2 14 -pi pi ])
line([0 Fs/2],[ 0 0 ],'color','k','LineStyle', '--')
legend('Z','\phi','?')

Fs = 250;
Nf = 7;
Fp = 30;
Ap = 1;
As = 30;
d = designfilt('lowpassiir','FilterOrder',Nf,'PassbandFrequency',Fp, ...
    'PassbandRipple',Ap,'StopbandAttenuation',As,'SampleRate',Fs);
grpdelay(d,500,Fs)


rr=9*250:9.5*250; figure;
subplot(3,3,1); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+1), 'Color', [ 0 .6 .1 .5]);
subplot(3,3,2); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+10), 'Marker', '.', 'LineWidth', 0.1, 'Color', [ 0 .6 .1 .5]);
subplot(3,3,3); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+20), 'Color', [ 0 .6 .1 .5]);
subplot(3,3,4); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+40), 'Color', [ 0 .6 .1 .5]);
subplot(3,3,5); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+60), 'Color', [ 0 .6 .1 .5]);
subplot(3,3,6); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+90), 'Color', [ 0 .6 .1 .5])
subplot(3,3,7); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+140), 'Color', [ 0 .6 .1 .5]);
subplot(3,3,8); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+180), 'Color', [ 0 .6 .1 .5]);
subplot(3,3,9); plot(ideal.thetaLFP(rr),ideal.thetaLFP(rr+210), 'Color', [ 0 .6 .1 .5]);
figure; plot(ideal.thetaLFP(rr))