% WAVETEST Example Matlab script for WAVELET, using NINO3 SST dataset
% See "http://paos.colorado.edu/research/wavelets/"
% Written January 1998, final Oct 1999 by C. Torrence

function [ power, global_ws, global_signif, period, time, sig95, coi  ]=hdWavelet( sst, toPlotOrNot, figHandle, normalizeGraph, samplingFreq )

if nargin < 3 && toPlotOrNot
    figHandle = figure(199);
end

if nargin < 4
    normalizeGraph = 0;
end

if nargin < 5
    samplingFreq = 1000;
end


%     time series of EEG
%plot(time,sst); 
%     events
%scatter( ctrTs, zeros(1,length(ctrTs)), 'o', 'filled');
%     band X time power colorplot
%imagesc( time,log2(period), power );
%     95% significance contour, levels at -99 (fake) and 1 (95% signif)
%contour(time,log2(period),sig95,[-99,1],'r');
%     cone-of-influence, anything "below" is dubious
%plot(time,log2(coi),'k')
%     window spectrogram
%plot(global_ws,log2(period))
%     window spectrogram significance
%plot(global_signif,log2(period),'--')
%TODO 
% calculate RMS noise or something like that to estimate how bad the signal is?



% secStart = floor(21.5*60)+5;
% secEnd = secStart+(6);
% sst=nexFileData.contvars{1,1}.data(secStart*1000:secEnd*1000); 
% ctrTs=(nexFileData.events{1,1}.timestamps(find( (nexFileData.events{1,1}.timestamps>secStart).*(nexFileData.events{1,1}.timestamps<secEnd) ))-secStart);


%------------------------------------------------------ Computation

% normalize by standard deviation (not necessary, but makes it easier
% to compare with plot on Interactive Wavelet page, at
% "http://paos.colorado.edu/research/wavelets/plot/"

variance = std(sst)^2;
sst = (sst - mean(sst))/sqrt(variance) ;



n = length(sst);
dt = 1/samplingFreq ; % sampling resolution
time = [0:length(sst)-1]*dt ;  % construct time array
xlim = [0,length(sst)*dt];  % plotting range
pad = 1;      % pad the time series with zeroes (recommended)

% settings I liked for high resolution.
% dj = 1/16;
% s0 = 1/2^9;
% j1 = 9/dj;


% dj = 1/16;    % specify sub octaves; 1/4 will do 4 sub-octaves per octave
% % this is the "high pass" cut off; that is, 32* 1/32000Hz will give a
% % smallest period (highest Hz) of 1/1000 ; 
% % "spacing between discrete scales. Default is 0.25.
% %         A smaller # will give better scale resolution, but be slower to
% %         plot."
% s0 = 1/2^9; % 64*dt; "smallest scale of the wavelet."
% % this determines the last frequency analyzed, relative to the above
% % basically this works out to a cutoff of 2^(log2(1/s0) - theValueOverdjBelow )
% j1 = 9/dj;    % this says do <n>/dj powers-of-two with 1/dj sub-octaves each
% %        the # of scales minus one. Scales range from S0 up to S0*2^(J1*DJ),
% %        to give a total of (J1+1) scales. Default is J1 = (LOG2(N DT/S0))/DJ.

dj = 1/4;
s0 = 1/2^6;
j1 = 6/dj;



lag1 = 0.72;  % lag-1 autocorrelation for red noise background
mother = 'MORLET'; % The choices are 'MORLET', 'PAUL', or 'DOG';
   %Morlet is standard; 
   %Paul has better frequency transition separation at a cost of less 
   %     precise frequency in the window 
   % (basically,Paul gives higher time precision vs Morlet with higher frequency precision) 
   % ("Wavelet Analysis: the effect of varying basic wavelet parameters."?Solar Physics 222(2):203-228 · January 2004; DOI: 10.1023/B:SOLA.0000043578.01201.2d)


% Wavelet transform:
[wave,period,scale,coi] = wavelet(sst,dt,pad,dj,s0,j1,mother);
power = (abs(wave)).^2 ;        % compute wavelet power spectrum

% OUTPUTS:
%
%    WAVE is the WAVELET transform of Y. This is a complex array
%    of dimensions (N,J1+1). FLOAT(WAVE) gives the WAVELET amplitude,
%    ATAN(IMAGINARY(WAVE),FLOAT(WAVE) gives the WAVELET phase.
%    The WAVELET power spectrum is ABS(WAVE)^2.
%    Its units are sigma^2 (the time series variance).

% Significance levels: (variance=1 for the normalized SST)
[ signif, fft_theor ] = wave_signif(1.0,dt,scale,0,lag1,-1,-1,mother);
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;         % where ratio > 1, power is significant

% Global wavelet spectrum & significance levels:
global_ws = variance*(sum(power')/n);   % time-average over all times
dof = n - scale;  % the -scale corrects for padding at edges
global_signif = wave_signif(variance,dt,scale,1,lag1,-1,dof,mother);

%------------------------------------------------------ Plotting

if normalizeGraph==1
    tmpPower = power;
    for rr=1:size(power,1)
        tmpPower(rr,:) = power(rr,:)./max(power(rr,:));
    end
elseif normalizeGraph==2
    tmpPower = log2(power+1);
else
    tmpPower = power;
end

if toPlotOrNot

    
    
    figure(figHandle);

    %--- Plot time series
    subplot('position',[0.03 0.75 0.82 0.2])
    plot(time,sst); 
    hold on;
   % scatter( ctrTs, zeros(1,length(ctrTs)), 'o', 'filled');
    set(gca,'XLim',xlim(:))
    xlabel('Time (s)')
    ylabel('Input Signal (uV)')
    title('a) Input Signal')
    hold off

    %--- Contour plot wavelet power spectrum
    subplot('position',[0.03 0.07 0.82 0.62]) %[0.1 0.37 0.65 0.28])
    levels = 0:2:10; % [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
    %contourf(time,log2(period),log2(power), levels); %,log2(levels));  %*** or use 'contourf' (fill)
    colormap(build_NOAA_colorgradient);
    imagesc( time,log2(period), tmpPower );  %*** uncomment for 'image' plot
    xlabel('Time (s)')
    ylabel('Freq (Hz)')
    title('b) Wavelet Power Spectrum')
    set(gca,'XLim',xlim(:))
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',1./Yticks)
    % 95% significance contour, levels at -99 (fake) and 1 (95% signif)
    hold on
    contour(time,log2(period),sig95,[-99,1],'r');
    % cone-of-influence, anything "below" is dubious
    plot(time,log2(coi),'k')
    hold off

    %--- Plot global wavelet spectrum
    subplot('position',[0.87 0.07 0.1 0.62])% [0.77 0.37 0.2 0.28])
    plot(global_ws,log2(period))
    hold on
    plot(global_signif,log2(period),'--')
    hold off
    xlabel('Power (uV^2)')
    title('c) Global Wavelet Spectrum')
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel','')
    set(gca,'XLim',[0,1.25*max(global_ws)])
    
    % end of code
    return;
    
    figure;
    tt=(1:length(sst))/32000;
    subplot(11,1,1);  hold on; plot(tt,sst); plot( tt, abs(hilbert(sst)) );
    subplot(11,1,2);  hold on; plot(tt,eegs.delta); plot( tt, power(2,:) );
    subplot(11,1,3);  hold on; plot(tt,eegs.theta); plot( tt, power(6,:) );
    subplot(11,1,4);  hold on; plot(tt,eegs.alpha); plot( tt, power(8,:) );
    subplot(11,1,5);  hold on; plot(tt,eegs.beta); plot( tt, power(12,:) );
    subplot(11,1,6);  hold on; plot(tt,eegs.gamma); plot( tt, power(14,:) );
    subplot(11,1,7);  hold on; plot(tt,eegs.fastgamma); plot( tt, power(18,:) );
    subplot(11,1,8);  hold on; plot(tt,eegs.swr); plot( tt, power(22,:) );
    subplot(11,1,9);  hold on; plot(tt,eegs.preSpikes); plot( tt, power(26,:) );
    subplot(11,1,10); hold on; plot(tt,eegs.spikes); plot( tt, power(30,:) );
    subplot(11,1,11); hold on; plot(tt,eegs.postSpikes); plot( tt, power(34,:) );

    figure; colormap(build_NOAA_colorgradient); imagesc(time,log2(period), log2(power));
    set(gca,'XLim',xlim(:))
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',1./Yticks)
end