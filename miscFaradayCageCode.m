oo=csc2mat('~/toSort/uclaDoctoralProgram/experiments/data/faradayCage/CSC1.ncs');
Fs=32000;
[pwrOO,fOO]=plotFft(oo(1:length(pp)),Fs);
figure; 
decimateFactor = 64;
subplot(2,1,1);
plot( fOO, pwrOO, 'Color', [ 0 0 0 ] );
hold on;
subplot(2,1,2);
plot( fOO, pwrOO, 'Color', [ 0 0 0 ] );
hold on;
%plot(decimate(fOO,decimateFactor),decimate(pwrOO,decimateFactor), 'LineWidth', 2)
xlim([0 1000 ])
pp=csc2mat('~/toSort/uclaDoctoralProgram/experiments/data/faradayCage/CSC1caged.ncs');
[pwrPP,fPP]=plotFft(pp,Fs);
subplot(2,1,1);
plot( fPP, pwrPP, 'Color', [ 0.4 0.4 0.9 ] );
hold on;
plot(decimate(fOO,decimateFactor),decimate(pwrOO,decimateFactor), 'LineWidth', 2)
plot(decimate(fPP,decimateFactor),decimate(pwrPP,decimateFactor), 'LineWidth', 2, 'Color', [ .3 .9 .4 ])
subplot(2,1,2);
plot( f, pwrPP, 'Color', [ 0.4 0.4 0.9 ] );
hold on;
plot(decimate(fOO,decimateFactor),decimate(pwrOO,decimateFactor), 'LineWidth', 2)
plot(decimate(fPP,decimateFactor),decimate(pwrPP,decimateFactor), 'LineWidth', 2, 'Color', [ .3 .9 .4 ])
xlim([0 500 ])




figure; 
decimateFactor = 64;
subplot(2,1,1);
hold on;
plot(decimate(fOO,decimateFactor),decimate(pwrOO,decimateFactor), 'LineWidth', 1, 'Color', [ .9 .6 .4 ])
plot(decimate(fPP,decimateFactor),decimate(pwrPP,decimateFactor), 'LineWidth', 1, 'Color', [ .3 .4 .9 ])
legend('out of cage','inside cage')
subplot(2,1,2);
hold on;
plot(decimate(fOO,decimateFactor),decimate(pwrOO,decimateFactor), 'LineWidth', 1, 'Color', [ .9 .6 .4 ])
plot(decimate(fPP,decimateFactor),decimate(pwrPP,decimateFactor), 'LineWidth', 1, 'Color', [ .3 .4 .9 ])
legend('out of cage','inside cage')
xlim([0 1000 ])










spectrogram(oo)
figure; plot(oo)
plotFft(oo(1:32000*29),32000)
plotFft(oo(1+32000*31:32000*59),32000);
plotFft(oo(1+32000*60:32000*90),32000);
90*32000
plotFft(oo(1+32000*90:32000*120),32000);
length(oo)/32000
figure;
hold on;
title('Single-Sided Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
[pwr,f]=plotFft(oo(1+32000*0:32000*30),32000);
plot(f,pwr)
[pwr,f]=plotFft(oo(1+32000*30:32000*60),32000);
plot(f,pwr)
[pwr,f]=plotFft(oo(1+32000*60:32000*90),32000);
plot(f,pwr)
[pwr,f]=plotFft(oo(1+32000*90:32000*120),32000);
plot(f,pwr)
[pwr,f]=plotFft(oo(1+32000*120:32000*150),32000);
plot(f,pwr)
[pwr,f]=plotFft(oo(1+32000*150:32000*180),32000);
plot(f,pwr)
[pwr,f]=plotFft(oo(1+32000*180:32000*223),32000);
plot(f,pwr)
legend('0-30','30-60','60-90','90-120','120-150','150-180','180-223')