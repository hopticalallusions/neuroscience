close all

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

%% decimation
decimatedLFP = downsample(lowpassLFP,128);

%% Custom Bandpass IIR Butterworth Filter
[row, N_samples] = size(decimatedLFP);

y = zeros(1,N_samples);

y_n_1 = 0;
y_n_2 = 0;
y_n_3 = 0;
y_n_4 = 0;
y_n_5 = 0;

x_n_1 = 0;
x_n_2 = 0;
x_n_3 = 0;
x_n_4 = 0;
x_n_5 = 0;

% filter coefficients (from fdatool)
b = [0.00030273242143969693 0 -0.00060546484287919386 ...
    0 0.00030273242149959693];
a = [1 -3.8859946027161221 5.7259969125611708 -3.7903678233180158 ...
    0.95139679910959221];

% scale value
% gain = 0.000302732

for i=1:N_samples
   
    if (i >= 5) 
        x_n_1 = decimatedLFP(i-1);
        x_n_2 = decimatedLFP(i-2);
        x_n_3 = decimatedLFP(i-3);
        x_n_4 = decimatedLFP(i-4);
        
        y_n_1 = y(i-1);
        y_n_2 = y(i-2);
        y_n_3 = y(i-3);
        y_n_4 = y(i-4);
     
    elseif (i == 4)
        x_n_1 = decimatedLFP(i-1);
        x_n_2 = decimatedLFP(i-2);
        x_n_3 = decimatedLFP(i-3);
        
        y_n_1 = y(i-1);
        y_n_2 = y(i-2);
        y_n_3 = y(i-3);
    
    elseif (i == 3)
        x_n_1 = decimatedLFP(i-1);
        x_n_2 = decimatedLFP(i-2);
        
        y_n_1 = y(i-1);
        y_n_2 = y(i-2);
        
    elseif (i == 2)
        x_n_1 = decimatedLFP(i-1);
        
        y_n_1 = y(i-1);
    
    end
    
    y(i) = (-a(2)*y_n_1 - a(3)*y_n_2 - a(4)*y_n_3 ... 
        - a(5)*y_n_4 + b(1)*decimatedLFP(i) + b(2)*x_n_1 ...
        + b(3)*x_n_2 + b(4)*x_n_3 + b(5)*x_n_4)/a(1);
end

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

t = linspace(1, decimatedLFPsize, N_samples);

f = Fs*[-N_samples/2:N_samples/2-1]/N_samples;

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
