function [Pww f0] = findpower(y,Fs)
%Pww: Power spectra
% f0: frequency points
% y: row vector containing time series;
% Fs: sampling rate
L=length(y);
NFFT = 2^nextpow2(L);
[Pww f0]=periodogram(yp',[],'onesided',NFFT,Fs);

end

