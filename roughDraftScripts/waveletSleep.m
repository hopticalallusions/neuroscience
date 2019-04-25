%WAVETEST Example Matlab script for WAVELET, using NINO3 SST dataset
%
% See "http://paos.colorado.edu/research/wavelets/"
% Written January 1998 by C. Torrence
%
% Modified Oct 1999, changed Global Wavelet Spectrum (GWS) to be sideways,
%   changed all "log" to "log2", changed logarithmic axis on GWS to
%   a normal axis.

%load 'sst_nino3.dat'   % input SST time series
%sst = eg;
%sst = filter(Hdswr, theta12swr16(19910133-50000:19910133+200000));
tic;
waveletTime.start = toc();

sst=downsample(lfpSwr,32);
%sst=sst(end-(5*60*1000):end);  % can clealy see sleep waves pop out
sst=sst((31*60*1000):(36*60*1000));  % during a run
waveletTime.load = toc();

%------------------------------------------------------ Computation

% normalize by standard deviation (not necessary, but makes it easier
% to compare with plot on Interactive Wavelet page, at
% "http://paos.colorado.edu/research/wavelets/plot/"
variance = std(sst)^2;
sst = (sst - mean(sst))/sqrt(variance) ;



n = length(sst);
dt = 1/1000 ; % sampling resolution
time = [0:length(sst)-1]*dt ;  % construct time array
xlim = [0,length(sst)*dt];  % plotting range
pad = 1;      % pad the time series with zeroes (recommended)
dj = 1/8;    % specify sub octaves; 1/4 will do 4 sub-octaves per octave
% this is the "high pass" cut off; that is, 32* 1/32000Hz will give a
% smallest period (highest Hz) of 1/1000 ; 
% "spacing between discrete scales. Default is 0.25.
%         A smaller # will give better scale resolution, but be slower to
%         plot."
s0 = 1/2^9; % 64*dt; "smallest scale of the wavelet."
% this determines the last frequency analyzed, relative to the above
% basically this works out to a cutoff of 2^(log2(1/s0) - theValueOverdjBelow )
j1 = 9/dj;    % this says do <n>/dj powers-of-two with 1/dj sub-octaves each
%        the # of scales minus one. Scales range from S0 up to S0*2^(J1*DJ),
%        to give a total of (J1+1) scales. Default is J1 = (LOG2(N DT/S0))/DJ.
lag1 = 0.72;  % lag-1 autocorrelation for red noise background
mother = 'MORLET'; % The choices are 'MORLET', 'PAUL', or 'DOG'; Morlet is standard; Paul has better frequency transition separation at a cost of less precise frequency in the window (basically,Paul gives higher time precision vs Morlet with higher frequency precision) ("Wavelet Analysis: the effect of varying basic wavelet parameters."?Solar Physics 222(2):203-228 · January 2004; DOI: 10.1023/B:SOLA.0000043578.01201.2d)

waveletTime.prewavelet = toc()-waveletTime.load;

% Wavelet transform:
[wave,period,scale,coi] = wavelet(sst,dt,pad,dj,s0,j1,mother);
waveletTime.wavelet = toc()-waveletTime.load-waveletTime.prewavelet;
power = (abs(wave)).^2 ;        % compute wavelet power spectrum
waveletTime.powerwavelet = toc()-waveletTime.load-waveletTime.prewavelet-waveletTime.wavelet;

% OUTPUTS:
%
%    WAVE is the WAVELET transform of Y. This is a complex array
%    of dimensions (N,J1+1). FLOAT(WAVE) gives the WAVELET amplitude,
%    ATAN(IMAGINARY(WAVE),FLOAT(WAVE) gives the WAVELET phase.
%    The WAVELET power spectrum is ABS(WAVE)^2.
%    Its units are sigma^2 (the time series variance).

% Significance levels: (variance=1 for the normalized SST)
[signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,-1,-1,mother);
waveletTime.sigwavelet = toc()-waveletTime.load-waveletTime.prewavelet-waveletTime.wavelet-waveletTime.powerwavelet;
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;         % where ratio > 1, power is significant

% Global wavelet spectrum & significance levels:
global_ws = variance*(sum(power')/n);   % time-average over all times
dof = n - scale;  % the -scale corrects for padding at edges
global_signif = wave_signif(variance,dt,scale,1,lag1,-1,dof,mother);
waveletTime.sigglobwavelet = toc()-waveletTime.load-waveletTime.prewavelet-waveletTime.wavelet-waveletTime.powerwavelet-waveletTime.sigwavelet;

% % Scale-average between El Nino periods of 2--8 years
% avg = find((scale >= 2) & (scale < 8));
% Cdelta = 0.776;   % this is for the MORLET wavelet
% scale_avg = (scale')*(ones(1,n));  % expand scale --> (J+1)x(N) array
% scale_avg = power ./ scale_avg;   % [Eqn(24)]
% scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
% scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,-1,[.01,1000],mother);
% waveletTime.finish = toc();

waveletTime

%whos

%------------------------------------------------------ Plotting

figure;

%--- Plot time series
subplot('position',[0.03 0.75 0.82 0.2])
plot(time,sst)
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
imagesc( time,log2(period), power );  %*** uncomment for 'image' plot
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
hold on
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

%--- Plot 2--8 yr scale-average time series
% subplot('position',[0.1 0.07 0.65 0.2])
% plot(time,scale_avg)
% set(gca,'XLim',xlim(:))
% xlabel('Time (s)')
% ylabel('Avg variance (?)')
% title('d) 2-8 yr Scale-average Time Series')
% hold on
% plot(xlim,scaleavg_signif+[0,0],'--')
% hold off

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