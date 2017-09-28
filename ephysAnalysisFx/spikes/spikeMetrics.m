function [] = spikeMetrics(spikes)

% making an assumption that our spike window is thinner than the number of
% spikes
dims = size(spikes);
if dims(2) < dims(1)
    spikes=spikes';
end


%% %lots of spike metrics
metrics.max=max(spikes);
metrics.maxLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
    metrics.maxLocation(idx)=find(spikes(:,idx)==max(spikes(:,idx)));
end
metrics.min=min(spikes);
metrics.minLocation=zeros(1,length(spikes));
for idx = 1:length(spikes)
    metrics.minLocation(idx)=find(spikes(:,idx)==min(spikes(:,idx)));
end
% peak-valley latency, a form of 'width'
metrics.width=abs(metrics.maxLocation-metrics.minLocation);
%amplitude
metrics.amplitude=metrics.max-metrics.min;
% average of signal
metrics.mean=mean(spikes);
% standard deviation of signal
metrics.std=std(spikes);
% median of signal
metrics.median=median(spikes);
% madam of signal; equiv. std for non-mean/non-Gaussian assumption central tendency https://en.wikipedia.org/wiki/Median_absolute_deviation
metrics.madam=zeros(1,length(spikes));
for idx = 1:length(spikes)
    metrics.madam(idx)=median(abs(spikes(:,idx)-metrics.median(idx)));
end
% http://www.gaussianwaves.com/2015/07/significance-of-rms-root-mean-square-value/
% RMS method 1 (direct) :
metrics.rmsSignal=sqrt(mean(spikes.^2));
% RMS frequency domain :
metrics.rmsFreq=sqrt(sum(abs(fft(spikes)./length(spikes)).^2));
% average absolute value
metrics.avgAbsValue=mean(abs(spikes));
% std absolute value
metrics.stdAvgAbsValue=std(abs(spikes));
% median absolute value
metrics.medianAbsValue=median(abs(spikes));
% madam absolute value https://en.wikipedia.org/wiki/Median_absolute_deviation
metrics.madamMedianAbsValue=zeros(1,length(spikes));
for idx = 1:length(spikes)
    metrics.madamMedianAbsValue(idx)=median(abs(spikes(:,idx)-metrics.medianAbsValue(idx)));
end
% sqrt of energy of signal http://www.gaussianwaves.com/2013/12/power-and-energy-of-a-signal/
metrics.sqrtEnergy=sqrt(sum(spikes.^2)); % this is 

%calculating a power for the signal doesn't make a whole lot of sense
%because it is discrete; any discrete signal has zero power because power =
%energy/time, and if time is infinite, power is zero if energy is a fixed
%amount. However, 
%Integral absolute value
% no sum(abs(spikes))    % maybe? it's actually the integral from 0 to infinity of the absolute value of X
%Maximum or peak absolute value
% no

% some approximation of  "peak roundedness"  http://journal.frontiersin.org/article/10.3389/fncom.2013.00149/full
% 2 signals -- first, it should be negative, that's binary-ish
%xx=find(spikes==max(spikes)); % already calculated this above
% bad things will happen if it's out of bounds
% TODO add bounds checking for index
metrics.peakPointyness=zeros(1,length(spikes));
metrics.peakCurvyness=zeros(1,length(spikes));
for idx=1:length(spikes)
    % the min and the max here are in case there are more than one index
    tempIdx=min(metrics.maxLocation(idx))-2:max(metrics.maxLocation(idx))+2;
    if ( tempIdx(1) > 1 ) && ( tempIdx(end) <= length(spikes(:,idx) ) )
        secondDerivPeak=diff(diff(spikes(tempIdx,idx)));
        % is it negative? (i.e. convex pointing up, concave pointing down?)
        metrics.peakPointyness(idx)=mean(secondDerivPeak<0); % this should be 1
        % how curvy is it? maybe this tells us that?
        metrics.peakCurvyness(idx)=mean(secondDerivPeak);
    end
end

%% references for methods I didn't implement

%pre-peak vs post-peak minima  http://journal.frontiersin.org/article/10.3389/neuro.06.013.2009/full

%half-width
%http://journal.frontiersin.org/article/10.3389/fncel.2014.00460/full
%local maxima

% frequency domain spike feature based classification
% http://iopscience.iop.org/article/10.1088/1741-2560/10/6/066015/meta;jsessionid=3484F41883EEC45BF30F662FBA42BDDB.c1

% principal component analysis
% http://arxiv.org/pdf/1404.1100.pdf

% extracellular recording and analysis without spike sorting
% http://arxiv.org/pdf/q-bio/0502039.pdf

% peak width detection in matlab
% http://www.mathworks.com/help/signal/ug/determine-peak-widths.html

% signals and noise
% http://terpconnect.umd.edu/~toh/spectrum/SignalsAndNoise.html

% neuralynx's feature distribution advice
%http://neuralynx.com/techtips/January_TechTip.html

% Gaussian Waves signal processing blog lessons
% http://www.gaussianwaves.com/index/

% templating
% http://onlinelibrary.wiley.com/store/10.1002/ecj.10066/asset/10066_ftp.pdf;jsessionid=14342AFB678F382562546F488EA7DB5D.f04t04?v=1&t=ie31h3i8&s=d7d2e3c98755409d3cce28cf7b05e98370696f02
% roughly, measure the residual for gaussian-ness after subtracting the
% pure template from the signal; theta^2_n = (sum((g(n)-template(n))^2))/(n-1)
% "sequential similarity detection algorithm (SSDA)"

% spike sorting review
% http://stat.columbia.edu/~liam/teaching/neurostat-fall13/papers/EM/Lewicki-Network-98_1.pdf

% gaussian mixtures and separation with the EM algorithm
% http://mlg.eng.cam.ac.uk/tutorials/06/cb.pdf

% stanford intro signals lecture
% https://web.stanford.edu/~boyd/ee102/signals.pdf

end
