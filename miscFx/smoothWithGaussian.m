function filterSignal=smoothWithGaussian( signal, windowLength )

% one directionally, this phase shifts...
% below, it tries to perform the convolution bidirectionally, to avoid the
% phase shift

% autoparameterize
sigma=round(windowLength/3);
mu=round(windowLength/2);


if size(signal,1) > size(signal,2)
    signal = signal';
end


% build a kernel
tt=1:windowLength;
kernel=1/(sigma*sqrt(2*pi))*exp(-0.5*((tt-mu)/sigma).^2); 
kernel=kernel/sum(kernel); % normalize

% smooth the signal
yy=conv(signal, kernel, 'same');

% smooth it in the opposite direction
yyprime = fliplr(conv(fliplr(signal), kernel, 'same'));

%plot(yy); plot(yyprime);
%figure; plot(signal,'k'); hold on; plot(mean([ yy; yyprime]))

%size(yy)

filterSignal = mean([ yy; yyprime]);

return;

%figure; plot(tt,yy);
