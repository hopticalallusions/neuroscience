%We use the window method (Bartlett Window). If you have the signal processing 
%toolbox you can use the Filter Design Tool, fdatool, to generate the coefficients 
%or filter object. Then you can use the filter command and compare.  Let us know 
%if you need more information.

vel = 400 % V/s
valley = -0.4 % V
peak = 1.3 % V
dt = 1e-6 % s
sweepV = zeros(1,20000);
idx=5000;
sweepV(idx) = valley;
while ( sweepV(idx) < peak )
	idx = idx + 1;
	sweepV(idx) = sweepV(idx-1) + (vel*dt);
end
while ( sweepV(idx) > valley )
	idx = idx + 1;
	sweepV(idx) = sweepV(idx-1) - (vel*dt);
end
figure;
%subplot(,1,1);
plot(sweepV);
%legend('sweep')
%subplot(3,1,2);
hold on;
filteredSweep=filter(Hdl,sweepV');
plot(filteredSweep, 'r');
plot(filter(Hdh,sweepV'), 'k');
plot(filter(Hdh,filteredSweep),'g');
plot(filter(Hdh,filter(Hdl,filteredSweep)),'m')
legend('filtered')




Fs = 32000;  % Sampling Frequency
N    = 31;       % Order
Fc   = 6000;     % Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = bartlett(N+1);
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
Hdl = dfilt.dffir(b);
N    = 63;       % Order
Fc   = 600;      % Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = bartlett(N+1);
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'high', win, flag, 'h');
Hdh = dfilt.dffir(b);




Fs = 32000;  % Sampling Frequency
N    = 63;       % Order
Fc1  = 600;      % First Cutoff Frequency
Fc2  = 6000;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = bartlett(N+1);
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dsp.FIRFilter( ...
    'Numerator', b);



 
hSR = dsp.SignalSource;
hSR.Signal = sweepV';
hLog = dsp.SignalSink;

Fs = 32000;  % Sampling Frequency
N    = 63;       % Order
Fc1  = 600;      % First Cutoff Frequency
Fc2  = 6000;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = bartlett(N+1);
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dsp.FIRFilter( ...
    'Numerator', b);
 
 %hFIR = dsp.FIRFilter;
 %hFIR.Numerator = fir1(10,0.5);

h = dsp.SpectrumAnalyzer('SampleRate',32e3,...
    'PlotAsTwoSidedSpectrum',false,...
    'OverlapPercent', 80, 'PowerUnits','dBW');
    
%,...'YLimits', [-150 -10]);

 while ~isDone(hSR)
      input = step(hSR);
      filteredOutput = step(hFIR,input);
      step(hLog,filteredOutput);
      step(h,filteredOutput)
 end

 filteredResult = hLog.Buffer;
 fvtool(hFIR,'Fs',32000)








%example

t = (0:1000)'/8e3;
 xin = sin(2*pi*0.3e3*t)+sin(2*pi*3e3*t);
 
 hSR = dsp.SignalSource;
 hSR.Signal = xin;
 hLog = dsp.SignalSink;

 hFIR = dsp.FIRFilter;
 hFIR.Numerator = fir1(10,0.5);

h = dsp.SpectrumAnalyzer('SampleRate',8e3,...
    'PlotAsTwoSidedSpectrum',false,...
    'OverlapPercent', 80, 'PowerUnits','dBW',...
    'YLimits', [-150 -10]);

 while ~isDone(hSR)
      input = step(hSR);
      filteredOutput = step(hFIR,input);
      step(hLog,filteredOutput);
      step(h,filteredOutput)
 end

 filteredResult = hLog.Buffer;
 fvtool(hFIR,'Fs',8000)





% doesn't work quite right. need to look up more stuff.

Fs = 1/dt;
BW = Fs/2;
% get the recommended order and cutoff for high pass
[n,Wc] = buttord(6000/BW,600/BW,3,10);
% get the butterworth filter
[b,a] = butter(n,Wc);
% get the frequency response
[H,W] = freqz(b,a);
% plot the low end of the response
figure;
plot( BW*W(1:10)/pi, 20*log10(abs(H(1:10))) )
