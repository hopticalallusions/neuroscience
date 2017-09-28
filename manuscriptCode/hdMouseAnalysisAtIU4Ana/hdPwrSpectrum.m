function [ freqs, pwr, pwrFilt, pwrMvAvg ] = hdPwrSpectrum( eeg, sampHz )

    L=length(eeg);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(eeg,NFFT)/L;
    freqs = sampHz/2*linspace(0,1,NFFT/2+1);
    pwr=log2(2*abs(Y(1:NFFT/2+1)));

    fftFilter = designfilt( 'lowpassiir',                     ...
                        'FilterOrder',              8  , ...
                        'PassbandFrequency',        length(pwr)/1000  , ...
                        'PassbandRipple',           0.2, ...
                        'SampleRate',              length(pwr));
    pwrFilt = filtfilt( fftFilter, pwr);
    
    pwrMvAvg=zeros(size(pwr));
    boxcar=30;
    idxRelative=-boxcar:boxcar;
    for ii=1:length(pwr);
        if ii > length(pwr)-boxcar-1
            temp = ii-boxcar:ii+boxcar;
            idxs= temp(find(temp<length(pwr)));
        else
            idxs=abs(ii-boxcar:ii+boxcar)+1;
        end
        pwrMvAvg(ii)=mean(pwr(idxs));
    end
    
    pwrMvAvg=pwrMvAvg';
    
%     figure;
%     hold on;
%     plot(freqs,pwr);
%     plot( freqs, pwrFilt, 'LineWidth', 2 );
%     plot( freqs, pwrMvAvg, 'LineWidth', 2 );
%     title('Single-Sided Amplitude Spectrum of data(t)')
%     xlabel('Frequency (Hz)')
%     ylabel('|Y(f)|')
    %axis([0 sampHz/2 0 max(pwr)])

end