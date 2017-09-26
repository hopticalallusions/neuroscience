function [pwr,f] = plotFft( input, sampHz, plotFigs )

    if ( nargin < 3 )
        plotFigs = false;
    end

    L=length(input);
    y=input;
    Fs=sampHz;
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    pwr=log2(2*abs(Y(1:NFFT/2+1)));

    % Plot single-sided amplitude spectrum.
    if ( plotFigs )
        figure;
        %plot(f,(pwr));
        hold on;
        decimateFactor = floor(length(pwr)/(Fs*1));
        plot(f,pwr);
        plot(decimate(f,decimateFactor),decimate(pwr,decimateFactor), 'LineWidth', 2)
        fftFilter = designfilt( 'lowpassiir',                     ...
                        'FilterOrder',              8  , ...
                        'PassbandFrequency',        1  , ...
                        'PassbandRipple',           0.2, ...
                        'SampleRate',              1000);
        pwrFilt = filtfilt( fftFilter, pwr);
        plot( f, pwrFilt, 'LineWidth', 2 );
        title('Single-Sided Amplitude Spectrum of data(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        axis([0 sampHz/2 0 max(pwr)])
    end

end