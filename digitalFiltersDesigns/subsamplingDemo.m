%% Time specifications:
   Fs = 10000;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 60;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %% Sine wave:
   Fc = 60.1;                     % hertz
   x = cos(2*pi*Fc*t);
   % Plot the signal versus time:
   figure;
   plot(t(1:Fs*30),x(1:Fs*30));
   xlabel('time (in seconds)');
   title('Signal versus Time');
   zoom xon;
   
   FsFscv=10;
   subSampleFscv=Fs/FsFscv;
   hold on;
   plot(t(1:subSampleFscv:Fs*30),x(1:subSampleFscv:Fs*30))