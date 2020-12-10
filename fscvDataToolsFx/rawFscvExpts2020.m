%%
%
% There is an email from Kate dated Oct 9, 2015 at 8:03 pm
% 
% It contains some example FSCV data that we used for SfN 2015
%
% In the example data, there are "snakes" indicating noise, which is not
% surpsing given that the recording took place in a behaving rat not in a
% faraday cage in a room with dominant 60.02 Hz wall noise and several of 
% its harmonics.
%
% The following code simulates the "snake" phenomenon and some qualitative
% characteristics of the FSCV colorplot trace with a pretty simple model
% that involves 3 different sine wave frequencies, some modification of
% their phase relationships, linear noise to create a "rise" and Gaussian
% noise to simulate noisen inherent in recording.
%
% We believed the snakes to be a beat of the 60.02 Hz noise in the system.
% The FSCV system collects 1000 samples for 8.5 ms every 100 ms (10 Hz).
% Due to the imperfect alignment of the frequencies, a regular pattern can
% be observed in the data as the FSCV sample moves slightly against the
% lower frequency.
%
% The 10 Hz sampling across one particular part of the FSCV signal is well
% below the Nyquist rate to sense a 60 Hz signal. However, I suspect that
% maybe I could rebuild the frequencies with compressed sensing (see
% below). I haven't put the effort in to do this yet.
%
% I am wondering if it would be possible to remove or at least mitigate
% this noise if I know exactly what it was with a notch filter or something
% like that.
%
%
% There are a few parts to this file
%
% 1) the sinusoidal noise model
% 2) Experiments with the raw data
% 3) some compressed sensing stuff that needs work
%

fs = 117650; % Sampling frequency of FSCV traces (samples per second) = 1000 / 8.5e-3 seconds
dt = 1/fs; % seconds per sample 
StopTime = 60; % seconds 
t = (0:dt:StopTime)'; % seconds 
F = 60.02; % Sine wave frequency (hertz) 

%  the simple model

data = 12 * sin( 2*pi *  3    * F*(t+1.1*pi)) + ...
        5 * sin( 2*pi * 30    * F*(t+pi/2.2)) + ...
        2 * sin( 2*pi * 20    * F*(t+pi/1.2)) + ...
       (.5 * t) + 12*(rand(length(t),1).*rand(length(t),1)) ;
colorplotdata=zeros(1000,10*StopTime);
fscvSample = 1;
for ii=1:round(fs/10):length(data)
    if ii+999 > length(data)
        break;
    end
    colorplotdata(:,fscvSample) = data(ii:ii+999);
    fscvSample = fscvSample+1;
end
figure(1); hh=pcolor(colorplotdata); 
set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; 
caxis([ -90 200 ]); % this color scheme is specific to  12 * sin( 2*pi *  3    * F*(t+1.1*pi)) + 5 * sin( 2*pi * 30    * F*(t+pi/2.2)) + 2 * sin( 2*pi * 20    * F*(t+pi/1.2)) + (.5 * t) + 12*(rand(length(t),1).*rand(length(t),1));
figure(2); plot(colorplotdata(333,:)); 




% a more elaborate model ::: 

% data = sin(2*pi*.5*F*t);
% data = 20*(rand(length(t),1).*rand(length(t),1)) + (2*t) +  2*sin(2*pi*.25*F*t) + 25*sin(2*pi*.5*F*t) + 1*sin(2*pi*F*t) + 1*sin(2*pi*2*F*t) + 1*sin(2*pi*3*F*t) + 8*sin(2*pi*4*F*t) + 1*sin(2*pi*5*F*(t+pi/6.7)) + 3*sin(2*pi*6*F*(t+pi/5.3)) + 3*sin(2*pi*7*F*(t+pi/4.1)) + 2*sin(2*pi*8*F*(t+pi/3.5)) + 2*sin(2*pi*9*F*(t+pi/2.2)) + 2*sin(2*pi*10*F*(t+pi/2.2)) + sin(2*pi*11*F*(t+pi/2.2)) + sin(2*pi*12*F*(t+pi/2.1));
data = 0 * sin( 2*pi *  0.25 * F*t) + ...
       0 * sin( 2*pi *  0.50 * F*t) + ...
       0 * sin( 2*pi *  1    * F*t) + ...
       0 * sin( 2*pi *  2    * F*t) + ...
      12 * sin( 2*pi *  3    * F*(t+1.1*pi)) + ...
       0 * sin( 2*pi *  4    * F*t) + ...
       0 * sin( 2*pi *  5    * F*(t+pi/6.7)) + ...
       0 * sin( 2*pi *  6    * F*(t+pi/5.3)) + ...
       0 * sin( 2*pi *  7    * F*(t+pi/4.1)) + ...
       0 * sin( 2*pi *  8    * F*(t+pi/3.5)) + ...
       0 * sin( 2*pi *  9    * F*(t+pi/2.2)) + ...
       5 * sin( 2*pi * 30    * F*(t+pi/2.2)) + ...
       0 * sin( 2*pi * 11    * F*(t+pi/2.2)) + ...
       0 * sin( 2*pi * 12    * F*(t+pi/2.1)) + ...
       (.5 * t); % + 20*(rand(length(t),1).*rand(length(t),1)) ;
colorplotdata=zeros(1000,10*StopTime);
fscvSample = 1;
for ii=1:round(fs/10):length(data)
    if ii+999 > length(data)
        break;
    end
    colorplotdata(:,fscvSample) = data(ii:ii+999);
    fscvSample = fscvSample+1;
end
figure(1); hh=pcolor(colorplotdata); set(hh, 'EdgeColor', 'none'); colormap(buildFscvColormap)
figure(2); plot(colorplotdata(333,:)); 

%%For one cycle get time period
T = 1/F ;
% time step for one time period 
tt = 0:dt:T+dt ;
d = sin(2*pi*F*tt);
figure;
plot(tt,d);



%% RAW DATA USED IN THE SFN POSTER
%
% It's pretty evident that TarheelCV filters out high frequency noise
% across each sample.
%
% This code shows the extracted RAW data file, which sort of matches the
% image under certain conditions, but the high frequency noise is evident
%
% Then it shows the effect of a filter on the each sample,
%
% and then a filter across samples at a given section of the waveform.
%
% I unfortunaetly do not know the details of the filters used to remove
% this noise
%

% assemble all the data together
filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
fscvRaw=readFscvRaw([filename '00']);
for ii = 1:46
    if ii < 10
        fscvRaw=[ fscvRaw readFscvRaw([filename '0' num2str(ii) ]) ];
    else
        fscvRaw=[ fscvRaw readFscvRaw([filename num2str(ii) ]) ];
    end
end
% Analyze
background=median(fscvRaw')';
%signal=calibda5day2ch1b35100umcbg;
for idx=1:size(fscvRaw,2)
    signal(:,idx)=fscvRaw(:,idx)-background;
end
cvtime=(1:size(fscvRaw,2))/10;
wrappedVolts=[1:500 500:-1:1];
%figure; surf(signal); colormap(build_NOAA_colorgradient); colorbar;
figure(100); 
subplot(1,3,1);
imagesc(flipud(signal)); 
colormap(flipud(buildFscvColormap)); 
colorbar; xlabel('sweep'); ylabel('sample'); title('colormap');
% this session has a dropout, the reconnect and drop blow up the min & max
% this bit below tries to overcome this problem
caxis([ prctile(signal(:), 5) prctile( signal(:), 95 ) ]); 
subplot(1,3,2);
plot(cvtime,signal(302,:)); ylabel('current (nA)'); xlabel('time (s)');  title('DA trace');
subplot(1,3,3);
plot(wrappedVolts,signal(:,100)); xlabel('point'); ylabel('current (nA)'); title('peak DA CV');

% plot the median background for the entire session
bg=median(fscvRaw')';
figure; plot(10*bg./(max(bg)-min(bg)));
title('Median Background of FSCV Probe in vivo');
xlabel('sample number');
ylabel('current (arb. units)');
ylim([-5 5]);
filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/calibration/011215/b34ch1/prototype-bore34-ch1-1_0-um-da-c';
fscvRaw=readFscvRaw([filename]);
bg=mean(fscvRaw(:,1:20)')';
hold on; plot(10*bg./(max(bg)-min(bg)), ':');
legend('in vivo (NAcc)','in vitro (PBS)')





%
% filters for FSCV data
%

withinSampleFilter = designfilt( 'lowpassiir',                     ...
                        'FilterOrder',              6  , ...
                        'PassbandFrequency',        2000  , ...
                        'PassbandRipple',           0.2, ...
                        'SampleRate',              1000/8.5e-3);

                    
sampling_freq = 1000/8.5e-3;
[ bb, aa ] = besself(   4, 2000, 'low' );
[ bz, az ] = impinvar( bb, aa, sampling_freq );
                    
                    
                    
% 
acrossSampleFilter = designfilt( 'lowpassiir'      ,         ...
                                'FilterOrder'      ,   8   , ...
                                'PassbandFrequency',   0.01, ...
                                'PassbandRipple'   ,   0.2 , ...
                                'SampleRate'       ,  10   );
                    
% after DeWaile ... Lee, Jang 2017
acrossSampleFilter = designfilt( 'highpassiir'      ,         ...
                                'FilterOrder'      ,   2   , ...
                                'PassbandFrequency',   0.01, ...
                                'PassbandRipple'   ,   0.2 , ...
                                'SampleRate'       ,  10   );

%
% no smoothing -- demnstrates that there is hella noie in the acquisition
%
filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
% Analyze
exBackground=mean(exFscvRaw(:,5:14)')';
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end

% note the crazy striations in the colorplot
figure(3);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))

% note the smooth background -- this isn't some sort of post-processing
% issue. (if the file was read wrong, the noise would be regular.)
figure(4);
plot([ 0:499 499:-1:0 ], exBackground)

% scrolls through voltammagrams
figure(5); plot([ 0:499 499:-1:0 ],exSignal(:,180));
for ii=370:400
    hold off;
    plot([ 0:499 499:-1:0 ],exSignal(:,ii));
    hold on; 
    plot([ 0:499 499:-1:0 ],filtfilt( withinSampleFilter, exSignal(:,ii)));
    ylim([-40 40])
    title(num2str(ii));
    pause(1)
end

%
% kinda sorta dopamine?
%
% BUT GOOD LORD THE NOISE
%
figure; ii= 198;
    plot([ 0:499 499:-1:0 ],exSignal(:,ii));
    hold on; 
    plot([ 0:499 499:-1:0 ],filtfilt( withinSampleFilter, exSignal(:,ii)));

figure; ii= 315;
    plot([ 0:499 499:-1:0 ],exSignal(:,ii));
    hold on; 
    plot([ 0:499 499:-1:0 ],filtfilt( withinSampleFilter, exSignal(:,ii)));

%
% There is a lot of high frequency noise in this
%
% 7812 is a prominent one
% 10800
% 4136
% 1953
% 1264
% 14020
% 53420
% 36190
% 39870
% 32050
plotFft( exSignal(:,315), 1000/8.5e-3, 1 ); ylim([-5 3])

    
%
% this section searches for an "optimal" DA trace.
%
% the idea is that the initial part should be flat-ish near zero, the DA oxidation
% should be high, the part near the voltage pulse turnaround should be flat
% near zero, the next part should be flat near zero and the last part
% should be a minimum peak.
%
% This would probably work better on filtered data.
%    <see below>

% not smooth
signalMin = min(min(min(exSignal( 875:950, : ))));
signalMax = max(max(max(exSignal( 259-25:259+25, : ))));
figure;
subplot(3,1,1)
plot( 1 ./ ( 1 + signalMax - mean( exSignal(  259-25:259+25, : ) ))); hold on;
plot( 1 ./ ( 1 - signalMin + mean( exSignal( 875:950, : ) )));
legend('DA peak','DA valley');
subplot(3,1,2)
plot( 1 ./ ( 1 + abs(mean( exSignal(  25:225, : ) )))); hold on;
plot( 1 ./ ( 1 + abs(mean( exSignal( 425:575, : ) ))));
legend('start','turn around');
subplot(3,1,3)
plot( 1 ./ ( 1 + abs(std( exSignal( 374:499, : ) )))); hold on;
plot( 1 ./ ( 1 + abs(std( exSignal( 600:850, : ) ))));
legend('before turn','after turn');



% smooth
signalMin = min(min(min(exFscvRawSmoothedSamples( 875:950, : ))));
signalMax = max(max(max(exFscvRawSmoothedSamples( 259-25:259+25, : ))));
figure;
subplot(6,1,1); plot( 1 ./ ( 1 + signalMax - mean( exFscvRawSmoothedSamples(  259-25:259+25, : ) )));
legend('DA peak (ox)')
subplot(6,1,2); plot( 1 ./ ( 1 - signalMin + mean( exFscvRawSmoothedSamples( 875:950, : ) )));
legend('DA valley (red)')
subplot(6,1,3); plot( 1 ./ ( 1 + abs(mean( exFscvRawSmoothedSamples(  25:225, : ) ))));
legend('zeroness peak V')
subplot(6,1,4); plot( 1 ./ ( 1 + abs(mean( exFscvRawSmoothedSamples( 425:575, : ) ))));
legend('zeroness return')
subplot(6,1,5); plot( 1 ./ ( 1 + abs(std( exFscvRawSmoothedSamples( 374:499, : ) ))));
legend('flatness peak V')
subplot(6,1,6); plot( 1 ./ ( 1 + abs(std( exFscvRawSmoothedSamples( 600:850, : ) ))));
legend('flatness return')

% the intention here is to maximize the chance of finding a nice looking
% dopamine trace by "measuring" some characteristics in a crude way and
% max-optimizing

daPeak = 1 ./ ( 1 + signalMax - mean( exFscvRawSmoothedSamples(  259-25:259+25, : )));
daValley = 1 ./ ( 1 - signalMin + mean( exFscvRawSmoothedSamples( 875:950, : ) ));
zeronessPeakV = 1 ./ ( 1 + abs(mean( exFscvRawSmoothedSamples(  25:225, : ) )));
zeronessReturn =  1 ./ ( 1 + abs(mean( exFscvRawSmoothedSamples( 425:575, : ) )));
flatnessPeakV = 1 ./ ( 1 + abs(std( exFscvRawSmoothedSamples( 374:499, : ) )));
flatnessReturn = 1 ./ ( 1 + abs(std( exFscvRawSmoothedSamples( 600:850, : ) )));

daPeak = ( daPeak - min(daPeak)) / ( max(daPeak)-min(daPeak) ) ;
daValley = ( daValley - min(daValley)) / ( max(daValley)-min(daValley) ) ;
zeronessPeakV = ( zeronessPeakV - min(zeronessPeakV)) / ( max(zeronessPeakV)-min(zeronessPeakV) ) ;
zeronessReturn = ( zeronessReturn - min(zeronessReturn)) / ( max(zeronessReturn)-min(zeronessReturn) );
flatnessPeakV = ( flatnessPeakV - min(flatnessPeakV)) / ( max(flatnessPeakV)-min(flatnessPeakV) );
flatnessReturn = ( flatnessReturn - min(flatnessReturn)) / ( max(flatnessReturn)-min(flatnessReturn) );

% kinda sorta works; find the peaks
figure; plot( daPeak +daValley + zeronessPeakV + zeronessReturn + flatnessPeakV + flatnessReturn )



% NO SMOOTHING

filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
% Analyze
exBackground=mean(exFscvRaw(:,5:14)')';
exSignal=zeros(size(exFscvRaw));
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end
figure;
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))


% WITHIN SAMPLE SMOOTHING

filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
for idx=1:size(exFscvRaw,2)
    %exFscvRaw(:,idx)=filtfilt( withinSampleFilter, exFscvRaw(:,idx));
    aa=filtfilt( withinSampleFilter, [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 exFscvRaw(:,idx)' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]);
    %aa=filtfilt( bz, az, [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 exFscvRaw(:,idx)' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]);
    exFscvRaw(:,idx)= aa(16:length(aa)-16);
end
% for idx=1:size(exFscvRaw,1)
%     exFscvRaw(idx,:)=filtfilt( acrossSampleFilter, exFscvRaw(idx,:));
% end
% Analyze
exBackground=mean(exFscvRaw(:,5:14)')';
exSignal=zeros(size(exFscvRaw));
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end
figure(5);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))


%%%%open('/Volumes/Seagate Expansion Drive/v4/V4_twotasks/


filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
Y = fft2(exFscvRaw);
Fs = 10; NFFT = 2^nextpow2(size(exFscvRaw,2)); xx=Fs/2*linspace(-1,1,NFFT/2+1);
Fs = 1000/8.5e-3; NFFT = 2^nextpow2(size(exFscvRaw,2)); yy=Fs/2*linspace(-1,1,NFFT/2+1);
figure; imagesc(xx,yy,abs(fftshift(Y))); caxis([0 abs(prctile(Y(:),99))])
% 1.35 Hz,  2 khz cutoff frequencies    -3 dB limits
% 2.7  Hz,  4 khz cutoff frequencies   -50 dB limits
%


 x1 = 0
 a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
 b = a*sqrt(1-e^2);
 
 t = linspace(0,2*pi);
 X = 1.35*cos(t);
 Y = 2000*sin(t);
 w = atan2(0,0);
 x = X*cos(w) - Y*sin(w);
 y = X*sin(w) + Y*cos(w);
figure
 plot(x,y)
axis([ -5 5 -60e3 60e3 ] )
 t = linspace(0,2*pi);
 X = 1.8*1.35*cos(t);
 Y = 1.8*2000*sin(t);
 w = atan2(0,0);
 x = X*cos(w) - Y*sin(w);
 y = X*sin(w) + Y*cos(w);
hold on
 plot(x,y)
 
 
normpdf( -5:.01667:5, 0, )
normpdf( -0.5*1000/8.5e-3:117.7:0.5*1000/8.5e-3, 0, )


ff=-2*1.35:.01667:-1.3;
figure; plot(ff,1./(1+exp(-((ff+2)*8)))); hold on; plot(-ff,1./(1+exp(-((ff+2)*8))));



ff=-0.5*1000/8.5e-3:117.7:0.5*1000/8.5e-3;
figure; plot(ff,1./(1+exp(-((ff+2)*8))))


figure; imagesc(log10(abs(fftshift(Y)))); caxis([0 prctile(log10(abs(Y(:))),99)])


lpf = zeros(size(exFscvRaw));
lpf(500,200:400) = 1;
for ii=1:50; lpf(500+ii,round(150+ii^1.2):round(450-ii^1.2)) = 1; end;
for ii=1:50; lpf(500-ii,round(150+ii^1.2):round(450-ii^1.2)) = 1; end;
figure; imagesc(lpf);

log10(abs(fftshift(lpf)))); caxis([0 prctile(log10(abs(lpf(:))),99)])


%Sampling intervals 
dx = 1; 
dy = 1; 
% N -- height
% M -- width
M = size(exFscvRaw,2);
N = size(exFscvRaw,1);
%Characteristic wavelengths 
KX0 = (mod(1/2 + (0:(M-1))/M, 1) - 1/2); 
KX1 = KX0 * (2*pi/dx); 
KY0 = (mod(1/2 + (0:(N-1))/N, 1) - 1/2); 
KY1 = KY0 * (2*pi/dx); 
[KX,KY] = meshgrid(KX1,KY1); 
K0 = 50;
%Filter formulation 
lpf = (KX.*KX + KY.*KY < K0^2); 
%Filter Application 
rec = ifft2(lpf.*fft2(exFscvRaw));
figure; imagesc(rec)
exBackground=mean(rec(:,5:14)')';
exSignal=zeros(size(rec));
for idx=1:size(rec,2)
    exSignal(:,idx)=rec(:,idx)-exBackground;
end
figure;
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))









% WITHIN SAMPLE SMOOTHING

filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
for idx=1:size(exFscvRaw,2)
    %exFscvRaw(:,idx)=filtfilt( withinSampleFilter, exFscvRaw(:,idx));
    aa=filtfilt( withinSampleFilter, [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 exFscvRaw(:,idx)' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]);
    %aa=filtfilt( bz, az, [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 exFscvRaw(:,idx)' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]);
    exFscvRaw(:,idx)= aa(16:length(aa)-16);
end
for idx=1:size(exFscvRaw,1)
    exFscvRaw(idx,:)=filtfilt( acrossSampleFilter, exFscvRaw(idx,:));
end
% Analyze
exBackground=median(exFscvRaw(:,5:14)')';
exBackground=median(exFscvRaw(:,:)')';
exSignal=zeros(size(exFscvRaw));
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end
figure(5);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4]); caxis(10.67.*[-2.7 4])
subplot(3,1,1); hold off; plot(exSignal(259,:)); hold on; plot(mean(exSignal(220:260,:)));

figure; surf(exSignal)

figure; plot([0:499 499:-1:0 ], exSignal(:,452))





%
% no smoothing -- demnstrates that there is hella noie in the acquisition
%
filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
for idx=1:size(exFscvRaw,2)
    exFscvRawSmoothedSamples(:,idx)=filtfilt( withinSampleFilter, exFscvRaw(:,idx));
end
% Analyze
exBackground=mean(exFscvRawSmoothedSamples(:,5:14)')';
for idx=1:size(exFscvRawSmoothedSamples,2)
    exSignal(:,idx)=exFscvRawSmoothedSamples(:,idx)-exBackground;
end
figure(3);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))

















%
% no smoothing.
%
filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
%Kernel = 0.045*ones(5);

% windowSize=3;
% sd=2;
% x = [-windowSize:windowSize]; 
% norm = normpdf(x,0,sd);
% Kernel=(norm'*norm);
% %figure; pcolor(kernel)

%exFscvRaw= conv2( exFscvRaw, Kernel, 'same');
% Analyze
exBackground=median(exFscvRaw')';
exBackground=mean(exFscvRaw(:,5:14)')';
%signal=calibda5day2ch1b35100umcbg;
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end
figure(3);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))

figure; plot(exSignal(:,400)); 
alpha(.1);

figure; plot(exFscvRaw(259,:))

figure; surf(exFscvRaw)





filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_1001';
exFscvRaw=readFscvRaw([filename '14']);
for idx=1:size(exFscvRaw,2)
    exFscvRaw(:,idx)=filtfilt( withinSampleFilter, exFscvRaw(:,idx));
end
for idx=1:size(exFscvRaw,1)
    exFscvRaw(idx,:)=filtfilt( acrossSampleFilter, exFscvRaw(idx,:));
end
% Analyze
exBackground=median(exFscvRaw')';
exBackground=mean(exFscvRaw(:,5:14)')';
exSignal=zeros(size(exFscvRaw));
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end
figure(5);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; caxis(16.67.*[-2.7 4])
subplot(3,1,1); plot(exSignal(259,:))


figure; plot(exFscvRaw(259,:))

figure; plot( [0:499 499:-1:0], exSignal(:,[ 40 88 137] )); hold on;









filename = '/Volumes/BlueMiniSeagateData/ratData/fscv/andrewhowe_blairlab/da5/da1-maybe-calibration-da5/day2_newprobes/b35-ch1/ch1-b35-1_00-um-c';
exFscvRaw=readFscvRaw([filename]);
for idx=1:size(exFscvRaw,2)
    exFscvRaw(:,idx)=filtfilt( withinSampleFilter, exFscvRaw(:,idx));
end
for idx=1:size(exFscvRaw,1)
    exFscvRaw(idx,:)=filtfilt( acrossSampleFilter, exFscvRaw(idx,:));
end
% Kernel = 0.045*ones(5);
% % windowSize=3;
% % sd=2;
% % x = [-windowSize:windowSize]; 
% % norm = normpdf(x,0,sd);
% % Kernel=(norm'*norm);
% % %figure; pcolor(kernel)
% exFscvRaw= conv2( exFscvRaw, Kernel, 'same');
% Analyze
exBackground=median(exFscvRaw')';
exBackground=mean(exFscvRaw(:,5:14)')';
exSignal=zeros(size(exFscvRaw));
for idx=1:size(exFscvRaw,2)
    exSignal(:,idx)=exFscvRaw(:,idx)-exBackground;
end
figure(5);
subplot(3,1,2:3); hh=pcolor(exSignal); set(hh, 'EdgeColor', 'none'); colormap(flipud(buildFscvColormap)); colorbar; 
subplot(3,1,1); plot(exSignal(259,:))



figure; plot( [0:499 499:-1:0], exSignal(:,100)); hold on;
pwrFilt = filtfilt( fftFilter, exSignal(:,100));
plot( [0:499 499:-1:0], pwrFilt);









%%
%
% COMPRESSED SENSING EXAMPLE
%
% DOESN'T SEEM TO WORK
%

%dimension
n = 512;
% sparsity
s = 17;
% location of the diracs
set_rand_seeds(123456,123456);
sel = randperm(n); sel = sel(1:s);
x = zeros(n,1); x(sel)=1;
% % randomization of the signs and values
x = x.*sign(randn(n,1)).*(1-.5*rand(n,1));
% save for future use
x0 = x;
%We create a random Gaussian matrix and normalize its columns. This defines the acquisition operator U. The columns are thus random point on the unit sphere of R^p.
% number of measures
p = 100;
% Gaussian matrix
U = randn(p,n);
% normalization
U = U ./ repmat( sqrt(sum(U.^2)), [p 1] );
%We perform random measurements without noise.
y = U*x;
%Compressed sensing recovery corresponds to solving the inverse problem y=U*x, which is ill posed because x is higher dimensional than x. The reconstruction can be perform with L1 minimization, which regularizes the problems by using the sparsity of the solution.
%min_{x1} norm(x1,1) subject to U*x1=y.
%Using the homotopy algorithm, we compute the solution path for a large number of different regularization parameter lambda values, and retrieve the last step, which corresponds to the minimum L1 norm solution.
options.niter = Inf;
[X1,lambda_list,sparsity_list] = perform_homotopy(U,y,options);
xbp = X1(:,end);
%We display the solution. You can see that the location of the Dirac is perfectly recovered.
clf;
subplot(2,1,1);
plot_sparse_diracs(x);
set_graphic_sizes([], 20);
title('Original Signal');
subplot(2,1,2);
plot_sparse_diracs(xbp);
set_graphic_sizes([], 20);
title('Recovered by L1 minimization');


%%
%
% COMPRESSED SENSING EXAMPLE
%
% https://www.codeproject.com/Articles/852910/Compressed-Sensing-Intro-Tutorial-w-Matlab
%
% depends on package https://statweb.stanford.edu/~candes/software/l1magic/ 
%
% requires change to line 141 of l1eq_pd.m
%

% Initialize constants and variables
rng(0);                 % set RNG seed
N = 256;                % length of signal
P = 2;                  % number of sinusoids
K = 64;                 % number of measurements to take (N < L)

% Generate signal with P randomly spread sinosoids
% Note that a real-valued sinusoid has two peaks in the frequency domain
freq = randperm(N/2)-1;
freq = freq(1:P).';
n = 0:N-1;
x = sum(sin(2*pi*freq/N*n).', 2);

% Orthonormal basis matrix
Psi = dftmtx(N);
Psi_inv = conj(Psi)/N;
X = Psi*x;              % FFT of x(t)

% Plot signals
amp = 1.2*max(abs(x));
figure; subplot(5,1,1); plot(x); xlim([1 N]); ylim([-amp amp]);
title('$\mathbf{x(t)}$', 'Interpreter', 'latex')
subplot(5,1,2); plot(abs(X)); xlim([1 N]);
title('$|\mathbf{X(f)}|$', 'Interpreter', 'latex');

% Obtain K measurements
x_m = zeros(N,1);
q = randperm(N);
q = q(1:K);
x_m(q) = x(q);
subplot(5,1,3); plot(real(x_m)); xlim([1 N]);
title('Measured samples of $\mathbf{x(t)}$', 'Interpreter', 'latex');

A = Psi_inv(q, :);      % sensing matrix
y = A*X;                % measured values

% Perform Compressed Sensing recovery
x0 = A.'*y;
X_hat = l1eq_pd(x0, A, [], y, 1e-5);

subplot(5,1,4); plot(abs(X_hat)); xlim([1 N]);
title('$|\mathbf{\hat{X}(f)}|$', 'Interpreter', 'latex');

x_hat = real(Psi_inv*X_hat);    % IFFT of X_hat(f)

subplot(5,1,5); plot(x_hat); xlim([1 N]);  ylim([-amp amp]);
title('$\mathbf{\hat{x}(t)}$', 'Interpreter', 'latex');


%%
%
% COMPRESSED SENSING FOR FSCV
%
% https://www.codeproject.com/Articles/852910/Compressed-Sensing-Intro-Tutorial-w-Matlab
%
%
% 60.02 Hz wall frequency
% 10 Hz pulse rate
% 117650 Hz sample rate
%

% Initialize constants and variables
rng(0);                 % set RNG seed
N = 256;                % length of signal
P = 2;                  % number of sinusoids
K = 64;                 % number of measurements to take (N < L)

% Generate signal with P randomly spread sinosoids
% Note that a real-valued sinusoid has two peaks in the frequency domain
freq = randperm(N/2)-1;
freq = freq(1:P).';
n = 0:N-1;
x = sum(sin(2*pi*freq/N*n).', 2);





% Orthonormal basis matrix
Psi = dftmtx(N);
Psi_inv = conj(Psi)/N;
X = Psi*x;              % FFT of x(t)

% Plot signals
amp = 1.2*max(abs(x));
figure; subplot(5,1,1); plot(x); xlim([1 N]); ylim([-amp amp]);
title('$\mathbf{x(t)}$', 'Interpreter', 'latex')
subplot(5,1,2); plot(abs(X)); xlim([1 N]);
title('$|\mathbf{X(f)}|$', 'Interpreter', 'latex');

% Obtain K measurements
x_m = zeros(N,1);
q = randperm(N);
q = q(1:K);
x_m(q) = x(q);
subplot(5,1,3); plot(real(x_m)); xlim([1 N]);
title('Measured samples of $\mathbf{x(t)}$', 'Interpreter', 'latex');

A = Psi_inv(q, :);      % sensing matrix
y = A*X;                % measured values

% Perform Compressed Sensing recovery
x0 = A.'*y;
X_hat = l1eq_pd(x0, A, [], y, 1e-5);

subplot(5,1,4); plot(abs(X_hat)); xlim([1 N]);
title('$|\mathbf{\hat{X}(f)}|$', 'Interpreter', 'latex');

x_hat = real(Psi_inv*X_hat);    % IFFT of X_hat(f)

subplot(5,1,5); plot(x_hat); xlim([1 N]);  ylim([-amp amp]);
title('$\mathbf{\hat{x}(t)}$', 'Interpreter', 'latex');








[xpos, ypos, xyPositionTimestamps ] = nvt2mat('/Volumes/Seagate Expansion Drive/v4/V4_twotasks/VT0.nvt');
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);
figure; plot( xpos, ypos ); axis square;

%% load the events during recording
[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat([ '/Volumes/Seagate Expansion Drive/v4//V4_twotasks/Events.nev']);
%[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat([basedir '/nlx/maze/Events.nev']);

%% make pretty graphs and find events
% TODO make this more robust; nlx tells you the up and the down of all
% output ttls every time one changes. woooo.
ttlRewardCSevenIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x0007).') )));
%
vidIdxSevens=zeros(length(ttlRewardCSevenIdx),1);
for idx=1:length((ttlRewardCSevenIdx))
    vidIdxSevens(idx) = min(find((EventStamps(ttlRewardCSevenIdx(idx))<xyPositionTimestamps)));
end
figure; plot(xpos,ypos,'Color', [ .5 .5 .5]);
hold on; plot(xpos(vidIdxSevens), ypos(vidIdxSevens), '*');
%plot(xpos(vidIdxSevens(end-10:end)), ypos(vidIdxSevens(end-10:end)), 'o');
%
zoneZeroIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
zoneZeroIdxs=[zoneZeroIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Exited') )))];
vidIdxZoneZero=zeros(length(zoneZeroIdxs),1);
for idx=1:length((zoneZeroIdxs))
    vidIdxZoneZero(idx) = min(find((EventStamps(zoneZeroIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneZero), ypos(vidIdxZoneZero), '.', 'MarkerSize',16);
zoneOneIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Entered') )));
zoneOneIdxs=[zoneOneIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Exited') )))];
vidIdxZoneOne=zeros(length(zoneOneIdxs),1);
for idx=1:length((zoneOneIdxs))
    vidIdxZoneOne(idx) = min(find((EventStamps(zoneOneIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneOne), ypos(vidIdxZoneOne), '.', 'MarkerSize',16);
zoneTwoIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone2 Entered') )));
zoneTwoIdxs=[zoneTwoIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone2 Exited') )))];
vidIdxZoneTwo=zeros(length(zoneTwoIdxs),1);
for idx=1:length((zoneTwoIdxs))
    vidIdxZoneTwo(idx) = min(find((EventStamps(zoneTwoIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneTwo), ypos(vidIdxZoneTwo), '.', 'MarkerSize',16);
zoneThreeIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone3 Entered') )));
zoneThreeIdxs=[zoneThreeIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone3 Exited') )))];
vidIdxZoneThree=zeros(length(zoneThreeIdxs),1);
for idx=1:length((zoneThreeIdxs))
    vidIdxZoneThree(idx) = min(find((EventStamps(zoneThreeIdxs(idx))<xyPositionTimestamps)));
end
hold on; plot(xpos(vidIdxZoneThree), ypos(vidIdxZoneThree), '.', 'MarkerSize',16);
legend('position','rewarded','zone 0','zone 1','zone 2','zone 3');
text(200,460,'wall w/ light')
text(200,35,'wall w/ dark')
text(580,140,'connection chair')


xyTimeSeconds = (xyPositionTimestamps-xyPositionTimestamps(1))./29.97;

4100
2800

platterMask = xyTimeSeconds<2800;
eightMask   = xyTimeSeconds>4100;
plot(xpos(eightMask), ypos(eightMask))
plot(xpos(platterMask), ypos(platterMask))

