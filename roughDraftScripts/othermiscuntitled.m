
figure;
tt=(1:length(sst))/32000;
subplot(7,1,1);  hold on; plot(tt,sst); plot( tt, abs(hilbert(sst)) ); legend('raw');
subplot(7,1,2);  hold on; plot(tt,eeg.theta); plot( tt, (abs(hilbert(eeg.theta)) )); legend('\Theta');
subplot(7,1,3);  hold on; plot(tt,eeg.beta); plot( tt, (abs(hilbert(eeg.beta)) )); legend('\beta');
subplot(7,1,4);  hold on; plot(tt,eeg.gamma); plot( tt, (abs(hilbert(eeg.gamma)) )); legend('\gamma');
subplot(7,1,5);  hold on; plot(tt,eeg.fastgamma); plot( tt, (abs(hilbert(eeg.fastgamma)) ));  legend('f\gamma');
subplot(7,1,6);  hold on; plot(tt,eeg.swr); plot( tt, (abs(hilbert(eeg.swr)) ));  legend('swr');
subplot(7,1,7); hold on; plot(tt,eeg.spikes); plot( tt, (abs(hilbert(eeg.spikes)) )); legend('spk');

figure; plot(tt,eeg.spikes);