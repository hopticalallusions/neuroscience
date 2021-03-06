function Hd = swrFilterHighpass8thOrder
%SWRFILTERHIGHPASS8THORDER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.0 and the DSP System Toolbox 9.2.
% Generated on: 06-Sep-2016 17:13:32

% Butterworth Highpass filter designed using FDESIGN.HIGHPASS.

% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency

N  = 8;    % Order
Fc = 130;  % Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');

% [EOF]
