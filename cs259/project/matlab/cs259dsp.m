close all

%% custom FIR lowpass filter

% filter coeffcients currently read from workspace
% these current coefficients are based on minimum order FIR -- 147 coeffs
b_lowpass_fir = Num;

% x_lowpass should be the input data, y_lowpass filtered output
x_lowpass = lfp; % currently reading data from workspace
y_lowpass_fir = lowpassFIR(x_lowpass, b_lowpass_fir);
        
%% custom IIR lowpass filter

% filter coeffs, b_lowpass_iir & a_lowpass_iir currently read from
% workspace
y_lowpass_iir = lowpassIIR(x_lowpass, b_lowpass_iir, a_lowpass_iir);

%% lowpass filter
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

 
lowpassLFP = filter(lowpassFilter,lfp);

%% custom decimation
decimated_lfp = c_decimator(y_lowpass_iir, 128);

%% decimation w/ Matlab built-in function
decimatedLFP = downsample(lowpassLFP,128);

%% Custom Bandpass IIR Butterworth Filter

% filter coefficients (from fdatool)
b = [0.00030273242143969693 0 -0.00060546484287919386 ...
    0 0.00030273242149959693];
a = [1 -3.8859946027161221 5.7259969125611708 -3.7903678233180158 ...
    0.95139679910959221];

y = bandpassIIR(decimated_lfp, b, a);

%% Butterworth IIR Filter implemented using Matlab filter design tools 
% All frequency values are in Hz.

Fs = 250;  % Sampling Frequency


Fstop1 = 2.7;         % First Stopband Frequency

Fpass1 = 6.7;         % First Passband Frequency

Fpass2 = 7.7;         % Second Passband Frequency

Fstop2 = 14.7;        % Second Stopband Frequency

Astop1 = 30;          % First Stopband Attenuation (dB)

Apass  = 1;           % Passband Ripple (dB)

Astop2 = 30;          % Second Stopband Attenuation (dB)

match  = 'passband';  % Band to match exactly


% Construct an FDESIGN object and call its BUTTER method.

h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);

thetaFilter = design(h, 'butter', 'MatchExactly', match);

thetaLFP = filter(thetaFilter, decimatedLFP);


%% plotting variables
%N_samples = length(y_lowpass_fir); % for lowpass plotting
N_samples = length(y); % for bandpass plotting

t = linspace(1, N_samples, N_samples);

f = Fs*[-N_samples/2:N_samples/2-1]/N_samples;

%% lowpass filter plotting
% subplot(3, 1, 1);
% plot(t, y_lowpass_fir);
% xlabel('samples');
% title('Custom FIR Lowpass filter');
% 
% subplot(3, 1, 2);
% plot(t, y_lowpass_iir);
% xlabel('samples');
% title('Custom IIR Lowpass filter');
% 
% subplot(3, 1, 3);
% plot(t, lowpassLFP);
% xlabel('samples');
% title('IIR Lowpass filter using Matlab filter funcs');

%% bandpass filter plotting
subplot(3, 3, 1);
plot(t, y);
xlabel('samples');
title('Filtered theta w/o Matlab filter functions');

subplot(3, 3, 2);
plot(f, abs(fftshift(fft(y))));
xlabel('frequency (Hz)');
title('Magnitude response');

subplot(3, 3, 3);
plot(f, angle(fftshift(fft(y))));
xlabel('frequency (Hz)');
title('Phase response');

subplot(3, 3, 4);
plot(t, thetaLFP);
xlabel('samples');
title('Filtered theta w/ Matlab filter functions');

subplot(3, 3, 5);
plot(f, abs(fftshift(fft(thetaLFP))));
xlabel('frequency (Hz)');
title('Magnitude response');

subplot(3, 3, 6);
plot(f, angle(fftshift(fft(thetaLFP))));
xlabel('frequency (Hz)');
title('Phase response');

subplot(3, 3, 7);
plot(t, y-thetaLFP);
xlabel('samples');
title('Difference between two filtered thetas');
