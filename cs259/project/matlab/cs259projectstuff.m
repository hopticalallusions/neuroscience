
load('~/src/cs259demodata.mat')
%lfp=data(2,:);
tic();
% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency

Fpass = 250;         % Passband Frequency
Fstop = 500;         % Stopband Frequency
Apass = 1;           % Passband Ripple (dB)
Astop = 30;          % Stopband Attenuation (dB)
match = 'passband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
lowpassFilter = design(h, 'butter', 'MatchExactly', match);

% All frequency values are in Hz.
Fs = 250;  % Sampling Frequency

Fstop1 = 2.7;         % First Stopband Frequency
Fpass1 = 6.7;         % First Passband Frequency
Fpass2 = 7.7;         % Second Passband Frequency
Fstop2 = 14.7;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
thetaFilter = design(h, 'butter', 'MatchExactly', match);


lowpassLFP = filter(lowpassFilter,lfp);
decimatedLFP = downsample(lowpassLFP,128);
thetaLFP = filter(thetaFilter,decimatedLFP);
hilbertLFP = hilbert(thetaLFP);
thetaPhaseRadians = angle(hilbertLFP); %angle
thetaPhaseDegrees = thetaPhaseRadians*180/pi;
envelopeThetaLFP = abs(hilbertLFP);




tic();
lowpassLFP = filter(lowpassFilter,lfp);
decimatedLFP = downsample(lowpassLFP,128);
thetaLFP = filter(thetaFilter,decimatedLFP);
hilbertLFP = hilbert(thetaLFP);
thetaPhaseRadians = angle(hilbertLFP); %angle
thetaPhaseDegrees = thetaPhaseRadians*180/pi;
envelopeThetaLFP = abs(hilbertLFP);
toc()

figure; 
plot(lfp(33*32000:34*32000));
hold on;
plot(lowpassLFP(33*32000:34*32000))

tt=(33*32000:34*32000);
ttt=(33*32000:128:34*32000);

figure; 
plot( (1:32000)/128, lfp(1:32000) );
hold on;
plot( (1:32000)/128, lowpassLFP(1:32000) );
plot( 1:250, decimatedLFP(1:250) );
plot( 1:250, thetaLFP(1:250) );
plot( 1:250, envelopeThetaLFP(1:250) );
figure;
plot( 1:250, thetaPhaseDegrees(1:250));




figure; 
plot( (1:320000)/128, lfp(1:320000) );
hold on;
plot( (1:320000)/128, lowpassLFP(1:320000) );
plot( 1:2500, decimatedLFP(1:2500) );
plot( 1:2500, thetaLFP(1:2500) );
plot( 1:2500, envelopeThetaLFP(1:2500) );
figure;
plot( 1:2500, thetaPhaseDegrees(1:2500));



fh1=figure;
axes1 = axes('Parent',fh1,'FontSize',20,'FontName','Arial');
hold on;
plot(log10(xx),log10(yy1./sum(yy1)),'*r');
plot(log10(xx),log10(yy2),'k-');
axis([ -0.05 1.05*log10(max(xx))  0  log10(1/(2*sum(yy1))) ]);
title([label1, ' empirical data vs ', label2,' distribution'], 'FontSize', 28, 'FontName', 'Arial');
xlabel('log_{10}( episode duration )', 'FontSize', 22, 'FontName', 'Arial');
ylabel('log_{10}( P ( episode duration ) )', 'FontSize', 22, 'FontName', 'Arial');
legend('data', 'label2');


ADBitVolts = 0.000000015624999960550667;


startTime= 312.4; % seconds
endTime= 315.6; % seconds
figure; 
plot( startTime:1/32000:endTime, lfp(startTime*32000:32000*endTime)*(ADBitVolts*1e6) );
title('24-bit EEG Signal','FontSize',20,'FontName','Arial');
xlabel('time (s)','FontSize',20,'FontName','Arial');
ylabel('potential (\muV)','FontSize',20,'FontName','Arial');
axis tight;
print('~/Desktop/cs259raw.png','-dpng');

hold on;
plot( (1:320000)/128, lowpassLFP(1:320000) );

plot( startTime:1/32000:endTime, lowpassLFP(startTime*32000:32000*endTime)*(ADBitVolts*1e6) );
title('24-bit Lowpass','FontSize',20,'FontName','Arial');
xlabel('time (s)','FontSize',20,'FontName','Arial');
ylabel('potential (\muV)','FontSize',20,'FontName','Arial');
axis tight;
print('~/Desktop/cs259low.png','-dpng');

plot( 1:2500, decimatedLFP(1:2500) );



plot( startTime:1/250:endTime, decimatedLFP(startTime*250:250*endTime)*(ADBitVolts*1e6) );
title('24-bit Decimated','FontSize',20,'FontName','Arial');
xlabel('time (s)','FontSize',20,'FontName','Arial');
ylabel('potential (\muV)','FontSize',20,'FontName','Arial');
axis tight;
print('~/Desktop/cs259decimated.png','-dpng');


plot( 1:2500, thetaLFP(1:2500) );

hold on
plot( startTime:1/250:endTime, thetaLFP(startTime*250:250*endTime)*(ADBitVolts*1e6) );
title('24-bit Theta','FontSize',20,'FontName','Arial');
xlabel('time (s)','FontSize',20,'FontName','Arial');
ylabel('potential (\muV)','FontSize',20,'FontName','Arial');
axis tight;
print('~/Desktop/cs259theta.png','-dpng');



plot( 1:2500, envelopeThetaLFP(1:2500) );


plot( startTime:1/250:endTime, envelopeThetaLFP(startTime*250:250*endTime)*(ADBitVolts*1e6) );
title('24-bit Envelope','FontSize',20,'FontName','Arial');
xlabel('time (s)','FontSize',20,'FontName','Arial');
ylabel('potential (\muV)','FontSize',20,'FontName','Arial');
axis tight;
print('~/Desktop/cs259envelope.png','-dpng');



figure;
plot( 1:2500, thetaPhaseDegrees(1:2500));



plot( startTime:1/250:endTime, thetaPhaseDegrees(startTime*250:250*endTime)*(ADBitVolts*1e6) );
title('24-bit Theta Phase','FontSize',20,'FontName','Arial');
xlabel('time (s)','FontSize',20,'FontName','Arial');
ylabel('potential (\muV)','FontSize',20,'FontName','Arial');
axis tight;
print('~/Desktop/cs259thetadeg.png','-dpng');
