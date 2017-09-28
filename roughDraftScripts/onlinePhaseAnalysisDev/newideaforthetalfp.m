% things to try for new analysis
% ideal forward backward filter for zero phase shifted theta
% new style filtered theta
% phase on both types -- maybe perform a single direction filter with the
% ideal filter?
% diff(unwrap(hilbert( of the angle and take a distribution
% it should be gaussian
% mean is thus valid-ish, median, mean, sd, etc
% take power spectrum of filtered and unfiltered data, estimate theta
% center

% dataDir='/Users/andrewhowe/blairLab/blairlab_data/v4/march20_giantsharpwaves/nlx/maze/';
% fileList=dir([ dataDir '/*.ncs']);
% lfp=decimate( csc2mat( [dataDir '/' fileList(1).name], 1, 32000*60*10), 640);

%[lfp, fulltimestamps, header, channel, sampFreq, nValSamp ]=csc2mat('/Users/andrewhowe/data/da5-day0-sample-closed-loop/CSC63.ncs');
%[lfp, fulltimestamps, header, channel, sampFreq, nValSamp ]=csc2mat('/Volumes/SILVRSURFER/da5/day1_plusmaze_habituation_2016-08-22//CSC24.ncs');
%load('/Users/andrewhowe/src/cs259demodata.mat')


%% offline version
% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency
Fpass = 12; %12         % Passband Frequency
Fstop = 20; %100        % Stopband Frequency
Apass = 1;           % Passband Ripple (dB)
Astop = 5;          % Stopband Attenuation (dB)  going from 5 to 25 dramatically phase shifts signal.
match = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
lowpassFilter = design(h, 'butter', 'MatchExactly', match);


% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency
Fstop1 = 3; %2.7;         % First Stopband Frequency
Fpass1 = 4; %6.7;         % First Passband Frequency
Fpass2 = 12; %7.7;         % Second Passband Frequency
Fstop2 = 13; %14.7;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
wideThetaFilter = design(h, 'butter', 'MatchExactly', match);
dfh = designfilt('bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1', 4, 'PassbandFrequency2', 12, 'StopbandFrequency2', 13, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
newidea.betterTheta=filtfilt(dfh,lfp);
%note : can't run hilbert or angles and so forth on a forward and reverse
%filterd signal.
% NOTE : downsampling a bidirectionally filtered signal hacks around this

% All frequency values are in Hz.
Fs = 250;  % Sampling Frequency
Fstop = 3; %2          % Stopband Frequency
Fpass = 4; %4          % Passband Frequency
Astop = 5; %5         % Stopband Attenuation (dB)
Apass = 1;           % Passband Ripple (dB)
match = 'stopband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass(Fstop, Fpass, Astop, Apass, Fs);
highpassFilter = design(h, 'butter', 'MatchExactly', match);

newidea.lowpassLFP = filter(lowpassFilter,lfp);
newidea.decimatedLFP = downsample(newidea.lowpassLFP,128);
newidea.thetaLFP = filter(highpassFilter,newidea.decimatedLFP);
newidea.hilbertLFP = hilbert(newidea.thetaLFP);
newidea.thetaPhaseRadians = angle(newidea.hilbertLFP); %angle
newidea.thetaPhaseDegrees = newidea.thetaPhaseRadians*180/pi;
newidea.envelopeThetaLFP = abs(newidea.hilbertLFP);

secStart=6.1;
secEnd=9;
figure;
tta=secStart*32000:secEnd*32000;
subplot(4,1,1:3);hold on; plot((1:length(lfp(tta)))/32000,lfp(tta),'Color',[ .6 .6 .6 .5 ]); %gray
subplot(4,1,1:3); plot((1:length(newidea.betterTheta(tta)))/32000,newidea.betterTheta(tta),'Color',[ 0 .5 0 ]); %orange
%subplot(8,1,1:3); plot((1:length(newidea.lowpassLFP(tta)))/32000,newidea.lowpassLFP(tta),'Color',[ 0 .5 1 ]); % blue
ttb=secStart*250:secEnd*250;
%subplot(8,1,1:3); plot((1:length(newidea.decimatedLFP(ttb)))/250,newidea.decimatedLFP(ttb),'Color',[ 0 .5 0 ]); %green
subplot(4,1,1:3); plot((1:length(newidea.thetaLFP(ttb)))/250,newidea.thetaLFP(ttb),'Color',[ 1 .6 0 ]); %orange
subplot(4,1,1:3); plot((1:length(newidea.envelopeThetaLFP(ttb)))/250,newidea.envelopeThetaLFP(ttb),'Color',[ 1 0 1 ]); %pink
%subplot(4,1,1:3); plot((1:length(newidea.envelopeThetaLFP(ttb)))/250,sqrt(newidea.thetaLFP(ttb).^2.+newidea.thetaLFP(ttb).^2));
%legend('raw','lowp','decim','\Theta','env');
legend('raw','\Theta','rt_\Theta','env');
subplot(4,1,4); plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); 
subplot(4,1,4); hold on;  plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + 11))); legend('hilb','delay')
%
hold on; plot((1:length(newidea.thetaPhaseDegrees(ttb(2:end))))/250,diff(newidea.thetaPhaseDegrees(ttb)));


figure;
subplot(6,1,1); hold on;
plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); 
subplot(6,1,2); hold on;
ii=5; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
ii=6; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
legend('5','6');
subplot(6,1,3); hold on;
plot((1:length(newidea.thetaLFP(ttb)))/250,newidea.thetaLFP(ttb),'Color',[ 1 .6 0 ]); %orange
subplot(6,1,4); hold on;
ii=7; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
ii=8; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
legend('7','8');
subplot(6,1,5); hold on;
ii=9; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
ii=10; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
legend('9','10');
subplot(6,1,6); hold on;
ii=11; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
ii=12; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii)));
legend('11','12');


figure;
[pwr,f]=plotFft(newidea.thetaLFP,250);
plot(f,pwr)

rr=2*250:round((9+60)*250); figure;
subplot(3,3,1); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+1), 'Color', [ 0 .6 .1 .1]);
subplot(3,3,2); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+6), 'Color', [ 0 .6 .1 .1]); hold on; %scatter(newidea.thetaLFP(rr),newidea.thetaLFP(rr+6),'Marker', 'o', 'MarkerFaceAlpha',0.01,'MarkerFaceColor',[ 0.6 .1 .1]);
subplot(3,3,3); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+7), 'Color', [ 0 .6 .1 .1]);
subplot(3,3,4); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+8), 'Color', [ 0 .6 .1 .1]);
subplot(3,3,5); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+9), 'Color', [ 0 .6 .1 .1]);
subplot(3,3,6); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+10), 'Color', [ 0 .6 .1 .1])
subplot(3,3,7); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+11), 'Color', [ 0 .6 .1 .1]);
subplot(3,3,8); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+12), 'Color', [ 0 .6 .1 .1]);
subplot(3,3,9); plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+13), 'Color', [ 0 .6 .1 .1]);

return;

figure;
subplot(8,1,3); hold on;
ii=-16; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); 
ii=-12; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii))); legend('hilb','delay')
subplot(8,1,4); hold on;
ii=-16; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); 
ii=-12; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii))); legend('hilb','delay')
subplot(8,1,5); hold on;
ii=-16; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); 
ii=-12; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii))); legend('hilb','delay')




subplot(8,1,1); hold on;
ii=-16; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); 
ii=-12; plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,180/pi*atan2(newidea.thetaLFP(ttb),newidea.thetaLFP(ttb + ii))); legend('hilb','delay')
ii=-10; 
ii=-8;

% 
% figure;hist((diff(unwrap(newidea.thetaPhaseRadians)),100))

250/(360/(180*mean(diff(unwrap(newidea.thetaPhaseRadians))/pi)))
return;


figure;




figure; hold on; plot(newidea.thetaLFP(rr)); 
ii=11; plot(sqrt(newidea.thetaLFP(rr).^2.+newidea.thetaLFP(rr + ii).^2));

legend('lfp','10', '15');

for ii=1:5:40; plot(sqrt(newidea.thetaLFP(rr).^2.+newidea.thetaLFP(rr + ii).^2)); end





ang=atan2(newidea.thetaLFP(rr),newidea.thetaLFP(rr + 11)); figure; plot(ang)


plot(newidea.thetaLFP(rr),newidea.thetaLFP(rr+11), 'Color', [ 0 .6 .1 .5]);






subplot(8,1,1:3); plot((1:length(newidea.envelopeThetaLFP(ttb)))/250,newidea.envelopeThetaLFP(tt),'Color',[ 1 0 1 ]); %pink
legend('raw','lowp','decim','\Theta','env');
subplot(8,1,4); plot((1:length(newidea.thetaPhaseDegrees(ttb)))/250,newidea.thetaPhaseDegrees(ttb)); legend('deg.')
%



[data, fulltimestamps, header, channel, sampFreq, nValSamp ]=csc2mat('/Volumes/SILVRSURFER/da5/aug16-2016_rodeo-day1/CSC2.ncs');

% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency
Fstop1 = 90; %2.7;         % First Stopband Frequency
Fpass1 = 110; %6.7;         % First Passband Frequency
Fpass2 = 240; %7.7;         % Second Passband Frequency
Fstop2 = 300; %14.7;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
swrh  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
swrFilter = design(swrh, 'butter', 'MatchExactly', match);
swrdfh = designfilt('bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1', 4, 'PassbandFrequency2', 12, 'StopbandFrequency2', 13, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
swrlfp=filtfilt(swrdfh,data);
%note : can't run hilbert or angles and so forth on a forward and reverse
%filterd signal.



Fs = 32000;  % Sampling Frequency
N   = 20;   % Order
Fc1 = 110;  % First Cutoff Frequency
Fc2 = 240;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
swrh  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hdswr = design(swrh, 'butter');
swrlfp=filter(Hdswr,data);
figure;hold on; plot((1:length(swrlfp))/32000,data); plot((1:length(swrlfp))/32000,swrlfp); line([ 1 1000],[ 5*151 5*151], 'Color', 'r');



downsampleRate=200;
windowSize=3;
improvedDownsampleLfp=zeros(1,ceil(length(lfp)/downsampleRate));
jj=1;
for ii=windowSize+1:downsampleRate:length(lfp)-windowSize
    improvedDownsampleLfp(jj)=median(lfp(ii-windowSize:ii+windowSize));
    jj=jj+1;
end
downsampleLfp=downsample(lfp,downsampleRate);
decimatedLfp = decimate(lfp, downsampleRate);

figure; plot((1:length(lfp))/32000,lfp); hold on; plot((1:downsampleRate:length(lfp))/(32000),downsampleLfp); plot((1:downsampleRate:length(lfp))/(32000),improvedDownsampleLfp); plot((1:downsampleRate:length(lfp))/(32000),decimatedLfp); legend('lfp','downsamp','imprv', 'decimate')
[acor,lags]=xcorr(decimatedLfp,downsampleLfp,15);
figure; plot(lags,acor); hold on;[acor,lags]=xcorr(decimatedLfp,improvedDownsampleLfp,15); plot(lags,acor); 



figure; plot(lfp(1:32000*10),lfp((1:32000*10)+4000), 'LineWidth', 2, 'Color', [ 0 0 0 .02]);
