
'/Users/andrewhowe/blairLab/blairlab_data/v4/march20_giantsharpwaves/nlx/maze/*ncs'

%%various power spectrum density/ frequency-power plots
%http://www.mathworks.com/matlabcentral/newsreader/view_thread/312373
Fs = 1e3;
t = 0:.001:1-0.001;
x = cos(2*pi*100*t)+randn(size(t));
hwelch = spectrum.welch; % smoothest
hwelch.SegmentLength = 100;
% compare
figure; plot(psd(spectrum.periodogram,x,'NFFT',length(x),'Fs',1e3));
%with
figure; plot(psd(hwelch,x,'NFFT',length(x),'Fs',1e3));
% or
figure; plot(psd(spectrum.mtm,x,'NFFT',length(x),'Fs',1e3));


% If you do not have the Signal Processing Toolbox, the PSD is proportional to the absolute value squared of the DFT (calculated by fft())
% http://www.mathworks.com/matlabcentral/answers/114942-how-to-calculate-and-plot-power-spectral-density-of-a-given-signal
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*100*t)+randn(size(t));
[Pxx,F] = periodogram(x,[],length(x),Fs);
plot(F,10*log10(Pxx))


% http://www.mathworks.com/help/matlab/examples/fft-for-spectral-analysis.html
Y = fft(y,251);
% Compute the power spectral density, a measurement of the energy at various frequencies, using the complex conjugate (CONJ). Form a frequency axis for the first 127 points and use it to plot the result. (The remainder of the points are symmetric.)
Pyy = Y.*conj(Y)/251;
f = 1000/251*(0:127);
plot(f,Pyy(1:128))
title('Power spectral density')
xlabel('Frequency (Hz)')



%http://www.mathworks.com/help/signal/ref/periodogram.html



dataDir='/Users/andrewhowe/blairLab/blairlab_data/v4/march20_giantsharpwaves/nlx/maze/';
fileList=dir([ dataDir '/*.ncs']);
figure;
for ii=1:4;
    lfp=decimate( csc2mat( [dataDir '/' fileList(1).name], 1, 32000*60*10), 640);
    subplot(8,4,ii);
    [pwr,f] = plotFft( lfp , 50, false );
    plot(f,pwr)
    axis([ 0 12 0 10 ])
end

figure; 
FF=[ 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 2048 1024 512 256 128 64 32 16 8 4 2 1 ];
FF=FF./sum(FF);
hold on; plot(f,pwr);
plot(f,conv(pwr,FF,'same')); 
pp=decimate(pwr,round(length(pwr)/(.01*length(pwr))));
fff=decimate(f,round(length(f)/(.01*length(f))));
plot(fff,pp)

size(pwr)

