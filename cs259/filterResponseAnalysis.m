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

[wa,za]=freqz(thetaFilter,1024);
[pa,oa]=phasez(thetaFilter,1024);

Fstop1 = 2.7-1;         % First Stopband Frequency
Fpass1 = 6.7-1;         % First Passband Frequency
Fpass2 = 7.7-1;         % Second Passband Frequency
Fstop2 = 14.7-1;        % Second Stopband Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
thetaFilter = design(h, 'butter', 'MatchExactly', match);

[wb,zb]=freqz(thetaFilter,1024);
[pb,ob]=phasez(thetaFilter,1024);

% see especially http://dsp.stackexchange.com/questions/16885/how-do-i-manually-plot-the-frequency-response-of-a-bandpass-butterworth-filter-i
% maybe 
% 

figure;
subplot(4,1,1);
plot(za*(Fs/2)/pi,20*log10(abs(wa)/1))
hold on;
plot(zb*(Fs/2)/pi,20*log10(abs(wb)/1))
axis([ 2 14 -5 1 ])
title('Frequency Response Plot');
ylabel('attenuation (db, logrithmic)');
subplot(4,1,2:4);
plot(za*(Fs/2)/pi,20*log10(abs(wa)/1))
hold on;
plot(zb*(Fs/2)/pi,20*log10(abs(wb)/1))
xlabel('frequency (hz)');
ylabel('attenuation (db, logrithmic)');
axis([ 0 (Fs/2) -100 1 ])



figure;
hold on;
plot(oa*(Fs/2)/pi,(pa)*180/pi);
plot(ob*(Fs/2)/pi,(pb)*180/pi);
title('filter phase shift ')
xlabel('frequency (hz)');
ylabel('shift (radians)');
axis([ 2 14 -pi*180/pi pi*180/pi ])
line([0 Fs/2],[ 0 0 ],'color','k','LineStyle', '--')

% find the minimum phase offset frequency
((Fs/2)/pi)*oa(min(find((min(abs(pa))==abs(pa)))))
% find the phase offset for that minimum offset frequency
pa(min(find((min(abs(pa))==abs(pa)))))

