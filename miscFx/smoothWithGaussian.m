function yy=smoothWithGaussian( signal, windowLength )

% this phase shifts...

% autoparameterize
sigma=round(windowLength/3);
mu=round(windowLength/2);

% build a kernel
tt=1:windowLength;
kernel=1/(sigma*sqrt(2*pi))*exp(-0.5*((tt-mu)/sigma).^2); 
kernel=kernel/sum(kernel); % normalize

% smooth the signal
yy=conv(signal, kernel);

%figure; plot(signal,'k'); hold on; plot(yy);

return;

%figure; plot(tt,yy);
