function [pwr,f] = plotFft( input, sampHz )
    L=length(input);
    y=input;
    Fs=sampHz;
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    figure;
    plot(f,log2(2*abs(Y(1:NFFT/2+1))) )
    pwr=2*abs(Y(1:NFFT/2+1));
    plot(f,pwr)
    title('Single-Sided Amplitude Spectrum of data(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    axis([0 sampHz/2 0 max(pwr)])
end