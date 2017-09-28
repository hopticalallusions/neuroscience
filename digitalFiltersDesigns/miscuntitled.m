% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency
Fstop1 =80; %2.7;         % First Stopband Frequency
Fpass1 = 100; %6.7;         % First Passband Frequency
Fpass2 = 250; %7.7;         % Second Passband Frequency
Fstop2 = 275; %14.7;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
wideSwrFilter = design(h, 'butter', 'MatchExactly', match);
dfh = designfilt('bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1', 4, 'PassbandFrequency2', 12, 'StopbandFrequency2', 13, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
bands.wideswr=filtfilt(dfh,data);
ds=downsample(bands.wideswr,8);
env = abs(hilbert(ds));

secStart = 60*30+8+0.1;
secEnd = secStart+15;

tta=(secStart*32000:secEnd*32000);
ttb=(secStart*4000:secEnd*4000);
figure; plot(tta/32e3, bands.wideswr(tta)); hold on ; plot(ttb/4e3,ds(ttb)); plot(ttb/4e3,env(ttb));

figure; hist(env,100)



