% 
% Delta wave ? (0.1 ? 4 Hz)
% Theta wave ? (4 ? 8 Hz)
% Alpha wave ? (8 ? 14 Hz)
%       Mu wave ? (7 ? 13 Hz) (sensirimotor)
%       SMR wave ? (12.5 ? 15.5 Hz)
% Beta wave ? (14 ? 31 Hz)
% Gamma wave ? (32 ? 90 Hz)
% fast Gamma wave ? (90 ? 130 Hz)
% sharp wave ? (130 ? 250 Hz)


% Buzsaki SWR review 2015 says gamma is :
%     slow  30-80  Hz
%     mid   60-120 Hz
%     fast  >100Hz

% from https://en.wikipedia.org/wiki/Gamma_wave
% see also the Table here :
% https://en.wikipedia.org/wiki/Electroencephalography 
% these frequencies seem a bit squishy



% Delta wave ? (0.1 ? 4 Hz)
% Theta wave ? (4 ? 8 Hz)
% Alpha wave ? (8 ? 14 Hz)
% Beta wave ? (14 ? 31 Hz)
% Gamma wave ? (32 ? 90 Hz)
% fast Gamma wave ? (90 ? 130 Hz)
% sharp wave ? (130 ? 250 Hz)



Fs = 32000;  % Sampling Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'stopband';  % Band to match exactly

% % delta
% % Construct an FDESIGN object and call its BUTTER method.
% Fstop1 = 0.01;           % First Stopband Frequency
% Fpass1 = .1;           % First Passband Frequency
% Fpass2 = 4;          % Second Passband Frequency
% Fstop2 = 10;          % Second Stopband Frequency
% deltaDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
% deltaFilter = design(deltaDesign, 'butter', 'MatchExactly', match);

% theta
Fstop1 = 1;           % First Stopband Frequency
Fpass1 = 4;           % First Passband Frequency
Fpass2 = 12;          % Second Passband Frequency
Fstop2 = 16;          % Second Stopband Frequency
% Construct an FDESIGN object and call its BUTTER method.
thetaDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
thetaFilter = design(thetaDesign, 'butter', 'MatchExactly', match);

% % alpha
% Fstop1 = 2;           % First Stopband Frequency
% Fpass1 = 8;           % First Passband Frequency
% Fpass2 = 14;          % Second Passband Frequency
% Fstop2 = 20;          % Second Stopband Frequency
% % Construct an FDESIGN object and call its BUTTER method.
% alphaDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
% alphaFilter = design(alphaDesign, 'butter', 'MatchExactly', match);
% % after wikipedia. I have no idea what this is in mice/rats



Fstop1 = 10;           % First Stopband Frequency
Fpass1 = 16;           % First Passband Frequency
Fpass2 = 31;          % Second Passband Frequency
Fstop2 = 40;          % Second Stopband Frequency
% Construct an FDESIGN object and call its BUTTER method.
betaDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
betaFilter = design(betaDesign, 'butter', 'MatchExactly', match);
% after wikipedia. I have no idea what this is in mice/rats


Fstop1 = 20;           % First Stopband Frequency
Fpass1 = 30;           % First Passband Frequency
Fpass2 = 90;          % Second Passband Frequency
Fstop2 = 110;          % Second Stopband Frequency
% Construct an FDESIGN object and call its BUTTER method.
gammaDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
gammaFilter = design(gammaDesign, 'butter', 'MatchExactly', match);
% after Sullivan et al ? Hippocampal Ripples and Fast Gamma Oscillations ? J. Neurosci., June 8, 2011 ? 31(23):8605? 8616 


Fstop1 = 70;           % First Stopband Frequency
Fpass1 = 90;           % First Passband Frequency
Fpass2 = 140;          % Second Passband Frequency
Fstop2 = 160;          % Second Stopband Frequency
% Construct an FDESIGN object and call its BUTTER method.
fastgammaDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
fastgammaFilter = design(fastgammaDesign, 'butter', 'MatchExactly', match);
% after Sullivan et al ? Hippocampal Ripples and Fast Gamma Oscillations ? J. Neurosci., June 8, 2011 ? 31(23):8605? 8616 

Fstop1 = 120;           % First Stopband Frequency
Fpass1 = 135;           % First Passband Frequency
Fpass2 = 250;          % Second Passband Frequency
Fstop2 = 280;          % Second Stopband Frequency
% Construct an FDESIGN object and call its BUTTER method.
swrDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
swrFilter = design(swrDesign, 'butter', 'MatchExactly', match);
% after Sullivan et al ? Hippocampal Ripples and Fast Gamma Oscillations ? J. Neurosci., June 8, 2011 ? 31(23):8605? 8616 
% 
% % preSpikes
% Fstop1 = 210;           % First Stopband Frequency
% Fpass1 = 250;           % First Passband Frequency
% Fpass2 = 700;          % Second Passband Frequency
% Fstop2 = 850;          % Second Stopband Frequency
% % Construct an FDESIGN object and call its BUTTER method.
% preSpikesDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
% preSpikesFilter = design(preSpikesDesign, 'butter', 'MatchExactly', match);

% spikes
Fstop1 = 250;           % First Stopband Frequency
Fpass1 = 300;           % First Passband Frequency
Fpass2 = 6000;          % Second Passband Frequency
Fstop2 = 7000;          % Second Stopband Frequency
% Construct an FDESIGN object and call its BUTTER method.
spikesDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
spikesFilter = design(spikesDesign, 'butter', 'MatchExactly', match);
% see What is the real shape of extracellular spikes?, R. Quian Quiroga, Journal of Neuroscience Methods 177 (2009) 194?198
% and
% Unsupervised Spike Detection and Sorting with Wavelets and
% Superparamagnetic Clustering, R. Quian Quiroga, Z. Nadasdy, Y. Ben-Shaul,
% Neural Computation 16, 1661?1687 (2004)
[B,A] = butter(2,[300 6000]/(Fs/2));
[Bh,Ah] = butter(2,300/(Fs/2),'high');
% view magnitude response
fvtool(B,A,'Fs',Fs)
figure;
% view pole-zero plot
zplane(B,A)
%spikesDesign  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
%spikesFilter = design(h, 'butter', 'MatchExactly', match);
hpFilt = designfilt('highpassiir','FilterOrder',8, ...
         'PassbandFrequency',300,'PassbandRipple',1, ...
         'SampleRate',32e3);
fvtool(hpFilt)
dataOut = filter(hpFilt,sst);
dataOut = filter(B,A,sst);
dataOut = filter(Bh,Ah,sst);
dataOut = filtfilt(Bh,Ah,sst);
figure; hold on; plot(sst); plot(dataOut);



% % postSpike
% Fstop1 = 1700;           % First Stopband Frequency
% Fpass1 = 2000;           % First Passband Frequency
% Fpass2 = 4000;          % Second Passband Frequency
% Fstop2 = 5000;          % Second Stopband Frequency
% % Construct an FDESIGN object and call its BUTTER method.
% postSpikesDesign  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
% postSpikesFilter = design(postSpikesDesign, 'butter', 'MatchExactly', match);



%[data]=csc2mat('/Users/andrewhowe/Downloads/da5/aug16-2016_rodeo-day1/CSC16.ncs');
%secStart = 500.1;
%secEnd = 505;
%sst=data(secStart*32000:secEnd*32000);

%10 bands

[B,A] = butter(2,[4 12]/(Fs/2));
eeg.theta = filtfilt(B,A, sst);
[B,A] = butter(2,[12 32]/(Fs/2));
eeg.beta = filtfilt(B,A, sst);
[B,A] = butter(2,[32 90]/(Fs/2));
eeg.gamma = filtfilt(B,A, sst);
[B,A] = butter(2,[90 130]/(Fs/2));
eeg.fastgamma = filtfilt(B,A, sst);
[B,A] = butter(2,[130 250]/(Fs/2));
eeg.swr = filtfilt(B,A, sst);
[B,A] = butter(2,[300 6000]/(Fs/2));
eeg.spikes = filtfilt(B,A, sst);



%eegs.delta = filter(deltaFilter, sst);
eegs.theta = filter(thetaFilter, sst);
%eegs.alpha = filter(alphaFilter, sst);
eegs.beta = filter(betaFilter, sst);
eegs.gamma = filter(gammaFilter, sst);
eegs.fastgamma = filter(fastgammaFilter, sst);
eegs.swr = filter(swrFilter, sst);
%eegs.preSpikes = filter(preSpikesFilter, sst);
eegs.spikes = filter(spikesFilter, sst);
%eegs.postSpikes = filter(postSpikesFilter, sst);


% to compare with wavelet power will need to (abs(envelope)).^2 ;
% then graph log2 of power
% wavelets are sort of backwards in that higher row index => lower freq.

figure;
tt=(1:length(sst))/32000;
subplot(7,1,1);  hold on; plot(tt,sst); plot( tt, abs(hilbert(sst)) ); legend('raw');
%subplot(11,1,2);  hold on; plot(tt,eegs.delta); plot( tt, (abs(hilbert(eegs.delta)) )); legend('\Delta');
subplot(7,1,2);  hold on; plot(tt,eegs.theta); plot( tt, (abs(hilbert(eegs.theta)) )); legend('\Theta');
%subplot(11,1,4);  hold on; plot(tt,eegs.alpha); plot( tt, (abs(hilbert(eegs.alpha)) )); legend('\alpha');
subplot(7,1,3);  hold on; plot(tt,eegs.beta); plot( tt, (abs(hilbert(eegs.beta)) )); legend('\beta');
subplot(7,1,4);  hold on; plot(tt,eegs.gamma); plot( tt, (abs(hilbert(eegs.gamma)) )); legend('\gamma');
subplot(7,1,5);  hold on; plot(tt,eegs.fastgamma); plot( tt, (abs(hilbert(eegs.fastgamma)) ));  legend('f\gamma');
subplot(7,1,6);  hold on; plot(tt,eegs.swr); plot( tt, (abs(hilbert(eegs.swr)) ));  legend('swr');
%subplot(11,1,9);  hold on; plot(tt,eegs.preSpikes); plot( tt, (abs(hilbert(eegs.preSpikes)) ));  legend('preSpk');
subplot(7,1,7); hold on; plot(tt,eegs.spikes); plot( tt, (abs(hilbert(eegs.spikes)) )); legend('spk');
%subplot(11,1,11); hold on; plot(tt,eegs.postSpikes); plot( tt, (abs(hilbert(eegs.postSpikes)).^2 )); legend('postspk');


return;
pwrChart = [ ...
    %log2(abs(hilbert(eegs.delta)).^2) ...
    log2(abs(hilbert(eegs.theta)).^2) ...
    %log2(abs(hilbert(eegs.alpha)).^2) ...
    log2(abs(hilbert(eegs.beta)).^2) ...
    log2(abs(hilbert(eegs.gamma)).^2) ...
    log2(abs(hilbert(eegs.fastgamma)).^2) ...
    log2(abs(hilbert(eegs.swr)).^2) ...
    %log2(abs(hilbert(eegs.preSpikes)).^2) ...
    log2(abs(hilbert(eegs.spikes)).^2) ...
    %log2(abs(hilbert(eegs.postSpikes)).^2) ...
    ];
figure; contourf(pwrChart')
%contourf(pwrChart'); colorbar;
%contourf(tt,log2(period),log2(power), levels); %,log2(levels));  %*** or use 'contourf' (fill)
%contourf


responsePoints = 16000;
wc = zeros(10, responsePoints);
zc = zeros(10, responsePoints);
pc = zeros(10, responsePoints);
oc = zeros(10, responsePoints);

ii=1;
[wc(ii,:),zc(ii,:)]=freqz(deltaFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(deltaFilter,responsePoints);
ii=2;
[wc(ii,:),zc(ii,:)]=freqz(thetaFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(thetaFilter,responsePoints);
ii=3;
[wc(ii,:),zc(ii,:)]=freqz(alphaFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(alphaFilter,responsePoints);
ii=4;
[wc(ii,:),zc(ii,:)]=freqz(betaFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(betaFilter,responsePoints);
ii=5;
[wc(ii,:),zc(ii,:)]=freqz(gammaFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(gammaFilter,responsePoints);
ii=6;
[wc(ii,:),zc(ii,:)]=freqz(fastgammaFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(fastgammaFilter,responsePoints);
ii=7;
[wc(ii,:),zc(ii,:)]=freqz(swrFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(swrFilter,responsePoints);
ii=8;
[wc(ii,:),zc(ii,:)]=freqz(preSpikesFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(preSpikesFilter,responsePoints);
ii=9;
[wc(ii,:),zc(ii,:)]=freqz(spikesFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(spikesFilter,responsePoints);
ii=10;
[wc(ii,:),zc(ii,:)]=freqz(postSpikesFilter,responsePoints);
[pc(ii,:),oc(ii,:)]=phasez(postSpikesFilter,responsePoints);



figure;
for ii=1:10
%     subplot(4,1,1);
%     hold on;
%     plot(zc(ii,:)*(Fs/2)/pi,20*log10(abs(wc(ii,:))/1))
%     axis([ 2 14 -5 1 ])
%     title('Frequency Response Plot');
%     ylabel('attenuation (db, logrithmic)');
%     subplot(4,1,2:4);
    hold on;
    plot(zc(ii,:)*(Fs/2)/pi,20*log10(abs(wc(ii,:))/1))
    xlabel('frequency (hz)');
    ylabel('attenuation (db, logrithmic)');
    %axis([ 0 (Fs/2) -100 1 ])
end