% temp = enveloped(16,1:2500);
% tempSmooth = zeros(1,length(temp));
% alpha = .1;
% tempSmooth(1) = temp(1);
% for ii=2:length(tempSmooth)
%     tempSmooth(ii) = (1-alpha)*tempSmooth(ii-1) + alpha*temp(ii);
% end
% figure; hold on;
% plot(temp); plot(tempSmooth);






ii=16;
    figure;
    trueHilbert = hilbert(bandpassed(ii,:));
    subplot(4,1,1); plot(bandpassed(ii,1:2*downsampleRate)); hold on;  plot(enveloped(ii,1:2*downsampleRate)); legend('bandpassed','envelope'); title([ 'delay ' num2str(bandpassCenterFrequencies(ii)) ' Hz' ],'FontSize',20,'FontName','Arial');
    subplot(4,1,2); plot(angled(ii,1:2*downsampleRate)); hold on;  plot(360/(2*pi)*(pi+angle(trueHilbert(1:2*downsampleRate)))); legend('CORDIC','mtlb_angle');
    subplot(4,1,3); hold off; plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(hilberted(ii,1:2*downsampleRate)); legend('bandpassed','hilberted');
    subplot(4,1,4); plot(bandpassed(ii,1:2*downsampleRate)); hold on; plot(imag(trueHilbert(1:2*downsampleRate))); legend('bandpassed','true hilbert');
%end
print('~/Desktop/hilbertComparison.png','-dpng');


figure; 
subplot(4,1,1); plot(envelopeSmoothed(:,1:5*downsampleRate)'); legend('envelopes'); %legend('4','5','6','7','8','9','10','11','12');
subplot(4,1,2); plot(instantFrequency(1:5*downsampleRate)); legend('instant freq');
subplot(4,1,3); plot(digitized(1:5*downsampleRate)); legend('ttl');
subplot(4,1,4); plot(bandpassed(15,1:5*downsampleRate)); legend([num2str(bandpassCenterFrequencies(15)) ' Hz']);
print('~/Desktop/matlabOutput.png','-dpng');

secondsToPlot=5;
figure; hold on;
plot((0:1/nativeSampleRate:secondsToPlot),lfp(1:secondsToPlot*nativeSampleRate+1))
plot((0:1/nativeSampleRate:secondsToPlot),lowpassed(1:secondsToPlot*nativeSampleRate+1))
plot((0:1/downsampleRate:secondsToPlot),downsampled(1:secondsToPlot*downsampleRate+1))
plot((0:1/downsampleRate:secondsToPlot),bandpassed(4,1:secondsToPlot*downsampleRate+1))



figure; colormap(build_NOAA_colorgradient); 
subplot(2,1,1); imagesc(flipud(enveloped(:,1:9*downsampleRate))); colorbar; title('Matlab Envelopes'); ylabel('~4 <--> ~12 Hz');
subplot(2,1,2); imagesc(flipud(envelopeSmoothed(:,1:9*downsampleRate))); colorbar; title('Matlab Envenlopes Temporal Smoothing');  ylabel('~4 <--> ~12 Hz');


figure; colormap(build_NOAA_colorgradient); imagesc(flipud(envelopeSmoothed(:,1:2048))); colorbar; title('Matlab Env. Temporal & Freq Smoothing');  ylabel('~4 <--> ~12 Hz'); xlabel('sample');
print('~/Desktop/envelopePowerSurface.png','-dpng');

Fs = 32000;  % Sampling Frequency
Fstop1 = 2;           % First Stopband Frequency
Fpass1 = 4;           % First Passband Frequency
Fpass2 = 12;          % Second Passband Frequency
Fstop2 = 16;          % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'stopband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);
allTheta=filter(Hd,lfp);
allThetaPhase = (angle(hilbert(allTheta(1:9*32000+1)))+pi);
trueHilbert = hilbert(bandpassed(ii,:));
truePhase =  angle(trueHilbert) + pi;
figure;
subplot(2,1,1);
hold on;
plot(angled(16,1:9*downsampleRate));
plot(truePhase(1:9*downsampleRate) * 360/(2*pi));
plot((1:9*32000+1)/128, allThetaPhase *360/(2*pi))
title('Full Lowpass Phase')
legend('cordic','matlab','theta');
ylabel('degrees');
xlabel('time (samples)')


% note -- this technique doesn't work because there are multiple
% frequencies embedded in the signal
figure;
plot((1:9*32000)/32000,(32000/(2*pi))*diff(unwrap(allThetaPhase(1:9*32000+1))));
hold on; 
plot((1:9*downsampleRate)/downsampleRate, instantFrequency(1:9*downsampleRate))
axis([ 0 max((1:9*downsampleRate)/downsampleRate)  0 16 ])
title('Instantaneous Frequency Estimation');
legend('d\phi (\theta) / dt','filt. bank');
xlabel('time (s)');
ylabel('frequency (Hz)');
print('~/Desktop/instantFreqEst.png','-dpng');


% to demo that the chosen band is powerful.
plotFft(downsampled(:,1:9*downsampleRate), 250);
print('~/Desktop/powerSpectrum.png','-dpng');

fid=fopen('~/src/neuroscience/cs259/project/c/lowpassed.dat','r');
clowpassed = fread( fid, 2048*128, 'double' ); 
fclose(fid); 
figure;
subplot(3,1,1:2); plot((2:2048*128)/32000, lowpassed(2:2048*128)*bitvolts); hold on; plot((2:2048*128)/32000,clowpassed(2:end)*bitvolts);
legend('matlab','C'); title('Lowpass Filter IIR'); ylabel('\muV'); axis tight;
subplot(3,1,3); plot((2:2048*128)/32000,(clowpassed(2:end)'-lowpassed(2:2048*128))*bitvolts); legend('legend'); axis tight;
xlabel('time (s)'); ylabel('\muV')
print('~/Desktop/clowpass.png','-dpng');

fid=fopen('~/src/neuroscience/cs259/project/c/bandpassed.dat','r');
cbandpassed          = fread( fid,       34*2048, 'double' ); 
fclose(fid);
rcbandpassed = reshape(cbandpassed, 34, 2048);
figure;
subplot(3,1,1:2); plot((1:2047)/250, bandpassed(16,1:2047)*bitvolts); hold on; plot((1:2047)/250,rcbandpassed(16,2:2048)*bitvolts);axis tight;
legend('matlab','C'); title('Example Bandpass Filter IIR'); ylabel('\muV')
subplot(3,1,3); plot((1:2047)/250,(rcbandpassed(16,2:2048)-bandpassed(16,1:2047))*bitvolts); legend('error'); axis tight;
xlabel('time (s)'); ylabel('\muV')
print('~/Desktop/cbandpass.png','-dpng');

fid=fopen( '~/src/neuroscience/cs259/project/c/hilberted.dat', 'r' );
chilberted = fread( fid, 34*2048, 'double' ); 
fclose(fid); rchilberted = reshape( chilberted, 34, 2048 );
figure;
subplot(3,1,1:2); plot((1:2047)/250, hilberted(16,1:2047)*bitvolts); hold on; plot((1:2047)/250,rchilberted(16,2:2048)*bitvolts);axis tight;
legend('matlab','C'); title('Hilbert Transform'); ylabel('\muV')
subplot(3,1,3); plot((1:2047)/250,(rchilberted(16,2:2048)-hilberted(16,1:2047))*bitvolts); legend('error'); axis tight;
xlabel('time (s)'); ylabel('\muV')
print('~/Desktop/chilbert.png','-dpng');



fid=fopen('~/src/neuroscience/cs259/project/c/enveloped.dat','r');
cenveloped          = fread( fid,       34*2048, 'double' ); 
fclose(fid); rcenveloped = reshape(cenveloped, 34, 2048);
figure;
subplot(3,1,1:2); plot((900:1047)/250, enveloped(16,900:1047)*bitvolts); hold on; plot((900:1047)/250,rcenveloped(16,901:1048)*bitvolts);axis tight;
legend('matlab','C'); title('Envelope Determination'); ylabel('\muV')
subplot(3,1,3); plot((900:1047)/250,(rcenveloped(16,901:1048)-enveloped(16,900:1047))*bitvolts); legend('error'); axis tight;
xlabel('time (s)'); ylabel('\muV')
print('~/Desktop/cenv.png','-dpng');

fid=fopen('~/src/neuroscience/cs259/project/c/angled.dat','r');
cangled          = fread( fid,       34*2048, 'double' ); 
fclose(fid); cangled = reshape(cangled, 34, 2048);
figure;
subplot(3,1,1:2); plot((900:1047)/250, angled(16,900:1047)); hold on; plot((900:1047)/250,cangled(16,901:1048));axis tight;
legend('matlab','C'); title('Phase Determination'); ylabel('degrees')
subplot(3,1,3); plot((900:1047)/250,(cangled(16,901:1048)-angled(16,900:1047))); legend('error'); axis tight;
xlabel('time (s)'); ylabel('degrees')
print('~/Desktop/cang.png','-dpng');

fid=fopen('~/src/neuroscience/cs259/project/c/envelopeSmoothed.dat','r');
cenvelopeSmoothed          = fread( fid,       34*2048, 'double' ); 
fclose(fid);
cenvelopeSmoothed = reshape(cenvelopeSmoothed, 34, 2048); 
figure;
subplot(3,1,1:2); plot((1:2047)/250, envelopeSmoothed(16,1:2047)*bitvolts); hold on; plot((1:2047)/250,cenvelopeSmoothed(16,2:2048)*bitvolts);axis tight;
legend('matlab','C'); title('Envelope Temporal Smoothing'); ylabel('\muV');
subplot(3,1,3); plot((1:2047)/250,(cenvelopeSmoothed(16,2:2048)-envelopeSmoothed(16,1:2047))*bitvolts); legend('error'); axis tight;
xlabel('time (s)'); ylabel('\muV');
print('~/Desktop/csmooth.png','-dpng');




figure; colormap(build_NOAA_colorgradient); 
subplot(2,1,1); imagesc(flipud(rcenveloped(:,1:2048))); colorbar; title('envelope'); ylabel('~4 <--> ~12 Hz');
subplot(2,1,2); imagesc(flipud(cenvelopeSmoothed(:,1:2048))); colorbar; title('temporal smoothing');  ylabel('~4 <--> ~12 Hz');


figure; colormap(build_NOAA_colorgradient); imagesc(flipud(cenvelopeSmoothed(:,1:2048))); colorbar; title('temporal & frequency smoothing');  ylabel('~4 <--> ~12 Hz'); xlabel('time (9 s)');
print('~/Desktop/csurf.png','-dpng');


% for some reason, the matlab version is behind the C version, so I shifted
% it one over.
fid=fopen('~/src/neuroscience/cs259/project/c/digitized.dat','r'); cdigitized = fread( fid, 2048, 'double' ); fclose(fid);
fid=fopen('~/Desktop/digitized.dat','r'); serverDigitized = fread( fid, 2048, 'double' ); fclose(fid);
fid=fopen('~/Desktop/digitized_fpga.dat','r'); fpgaServerDigitized = fread( fid, 2048, 'double' ); fclose(fid);
tt=(1:2048)/128;
figure;subplot(5,1,1:3); hold on; 
plot(tt,([0 digitized(1:2047)]),'LineWidth',4);
plot(tt,ceil(cdigitized(1:2048)),'LineWidth',3); 
plot(tt,ceil(serverDigitized(1:2048)),'LineWidth',2); 
plot(tt,ceil(fpgaServerDigitized(1:2048)),'LineWidth',1);
legend('Matlab','C','C Server','FPGA'); title('Digital Out'); ylabel('TTL state');
subplot(5,1,4); hold on;
plot(tt,[0 (digitized(1:2047))]'-round(cdigitized(1:2048)),'LineWidth',3); 
plot(tt,[0 (digitized(1:2047))]'-round(serverDigitized(1:2048)),'LineWidth',2); 
plot(tt,[0 (digitized(1:2047))]'-round(fpgaServerDigitized(1:2048)),'LineWidth',1); 
legend('Matlab-C Laptop','Matlab-C Server','Matlab-FPGA'); ylabel('TTL state');
subplot(5,1,5);  hold on;
plot(tt,round(cdigitized(1:2048))-round(fpgaServerDigitized(1:2048)),'LineWidth',2); 
plot(tt,round(serverDigitized(1:2048))-round(fpgaServerDigitized(1:2048)),'LineWidth',1); 
legend('C Laptop-FPGA','C Server-FPGA'); ylabel('TTL state'); xlabel('time (s)');
print('~/Desktop/cfpgattl.png','-dpng');

% visualize the envelope error
figure; colormap(build_NOAA_colorgradient); 
subplot(3,3,1); imagesc(flipud(enveloped(:,1:2048))); colorbar;
subplot(3,3,2); imagesc(flipud(rcenveloped(:,1:2048))); colorbar;
subplot(3,3,3); imagesc(flipud((enveloped(:,1:2048)-rcenveloped(:,1:2048)))); colorbar;
%subplot(2,3,3); imagesc(flipud((enveloped(:,1:2048)-rcenveloped(:,1:2048)))./((enveloped(:,1:2048)+rcenveloped(:,1:2048))/2)); colorbar;
subplot(3,3,4); imagesc(flipud(envelopeTemporalSmoothed(:,1:2048))); colorbar;
subplot(3,3,5); imagesc(flipud(cenvelopeTemporalSmoothed(:,1:2048))); colorbar;
subplot(3,3,6); imagesc(flipud((envelopeTemporalSmoothed(:,1:2048)-cenvelopeTemporalSmoothed(:,1:2048)))); colorbar;
%
subplot(3,3,7); imagesc(flipud(envelopeTemporalBandSmoothed(:,1:2048))); colorbar;
subplot(3,3,8); imagesc(flipud(cenvelopeTemporalBandSmoothed(:,1:2048))); colorbar;
subplot(3,3,9); imagesc(flipud((envelopeTemporalBandSmoothed(:,1:2048)-cenvelopeTemporalBandSmoothed(:,1:2048)))); colorbar;
%subplot(2,3,6); imagesc(flipud((envelopeTemporalBandSmoothed(:,1:2048)-cenvelopeTemporalBandSmoothed(:,1:2048)))./((envelopeTemporalBandSmoothed(:,1:2048)+cenvelopeTemporalBandSmoothed(:,1:2048))/2)); colorbar;

figure; colormap(build_NOAA_colorgradient); 


