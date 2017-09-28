function Hd = impulsifyingFilterAttempt
%IMPULSIFYINGFILTERATTEMPT Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the Signal Processing Toolbox 7.0.
% Generated on: 01-Sep-2015 16:11:50

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 32000;  % Sampling Frequency
Fpass = 64;              % Passband Frequency
Fstop = 128;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor
% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);
% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]

observationTime=1;
Fs=32000; %Sampling Frequency
t=0:1/Fs:observationTime;
Fx=7; %Frequency of the sinusoid
x=sin(2*pi*Fx*t);
Fx=2; %Frequency of the sinusoid
x=x+sin(2*pi*Fx*t);
Fx=20; %Frequency of the sinusoid
x=x+sin(2*pi*Fx*t);
Fx=120; %Frequency of the sinusoid
x=x+sin(2*pi*Fx*(t+((rand(1,length(t))-.5)/2000)));
Fx=294; %Frequency of the sinusoid
x=x+2*sin(2*pi*Fx*(t+((rand(1,length(t))-.5)/4000)));
Fx=804; %Frequency of the sinusoid
x=x+4*sin(2*pi*Fx*(t+((rand(1,length(t))-.5)/1000)));
Fx=1024; %Frequency of the sinusoid
x=x+sin(2*pi*Fx*t);
x=x+(2*(rand(1,length(x))-.5));
x=2^31*x/max(abs(x));
figure;
subplot(2,1,1);
plot(t,x,'k'); title('SineWave - MultiFrequency');xlabel('Times (s)');ylabel('Amplitude');
%xf=filter(Hd,x);
hold on;
%plot(t,xf,'or');
%xc=conv(x,Hd.coefficients{1}*2^31)/2^32;
xc=conv(x,nlxCoefs);
plot(t,xc(1:length(t)),'g');


Fs=32000; %Sampling Frequency
x=x; 
%Perform FFT
NFFX=2.^(ceil(log(length(x))/log(2)));
FFTX=fft(x,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(x);
f1=(0:NumUniquePts-1)*Fs/NFFX;
% MY contains the frequency peaks
subplot(2,1,2);
stem(f1(1:1100),MY(1:1100),'k');
title('FFT of the signal');xlabel('Frequency');ylabel('Amplitude');
%%%%%%%%%%%
xf=xf; 
%Perform FFT
NFFX=2.^(ceil(log(length(xf))/log(2)));
FFTX=fft(xf,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(xf);
f1=(0:NumUniquePts-1)*Fs/NFFX;
hold on;
stem(f1(1:1100),MY(1:1100),'r');
title('FFT of the signal');xlabel('Frequency');ylabel('Amplitude');


%Perform FFT
NFFX=2.^(ceil(log(length(xc))/log(2)));
FFTX=fft(xc,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(xc);
f1=(0:NumUniquePts-1)*Fs/NFFX;
hold on;
stem(f1(1:1100),MY(1:1100),'g');
title('FFT of the signal');xlabel('Frequency');ylabel('Amplitude');




%Perform FFT on coefficients
Fs=16000;
NFFX=2.^(ceil(log(length(nlxCoefs))/log(2)));
FFTX=fft(nlxCoefs,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(nlxCoefs);
f1=(0:NumUniquePts-1)*Fs/NFFX;
figure;
stem(f1,MY);
title('FFT of the signal');xlabel('Frequency');ylabel('Amplitude');


observationTime=1;
Fs=500; %Sampling Frequency
t=0:1/Fs:observationTime;
Fx=80; %Frequency of the sinusoid
x=cos(2*pi*Fx*t);
figure; plot(x);
x=[ nlxCoefs(1) (0.0018*x(1:1601))-mean(nlxCoefs(2:512)) nlxCoefs(513) ];
NFFX=2.^(ceil(log(length(x))/log(2)));
FFTX=fft(x,NFFX);%pad with zeros
NumUniquePts=ceil((NFFX+1)/2);
FFTX=FFTX(1:NumUniquePts);
MY=abs(FFTX);
MY=MY*2;
MY(1)=MY(1)/2;
MY(length(MY))=MY(length(MY))/2;
MY=MY/length(x);
f1=(0:NumUniquePts-1)*Fs/NFFX;
figure;
stem(f1,MY,'k');

