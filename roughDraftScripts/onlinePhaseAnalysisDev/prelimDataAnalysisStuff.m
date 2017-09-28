[ phase, envelope, frequency, signal, timestamp, thetaLFP, envelopeThetaLFP, thetaPhaseDegrees ] = lfpThetaPhaseFilterBank( '/Users/andrewhowe/Downloads/da5-day0-sample-closed-loop/CSC63.ncs' );

figure;
subplot(4,1,1); plot(timestamp, signal);

[lfp, fulltimestamps, header, channel, sampFreq, nValSamp ]=csc2mat('/Users/andrewhowe/Downloads/da5-day0-sample-closed-loop/CSC63.ncs');


range=120*250+1:130*250;
figure;
subplot(5,1,1); plot(fulltimestamps(120*32000+1:130*32000),lfp(120*32000+1:130*32000));
subplot(5,1,2); plot(timestamp(range),signal(range));
subplot(5,1,3); plot(timestamp(range),frequency(range));
subplot(5,1,4); plot(timestamp(range),envelope(range));
subplot(5,1,5); plot(timestamp(range),phase(range));


figure;
colormap(build_NOAA_colorgradient); 
imagesc(  timestamp(20001:30000), bandpassCenterFrequencies, (envelopeThetaLFP(:,20001:30000))); colorbar;
set(gca,'YDir','normal')
xlabel('Time (s)');
title('Envelope of High Resolution Theta Filter Bank (\muV)');
ylabel('Freq (Hz)');