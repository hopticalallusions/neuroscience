%function sharpWaveDetector

%
%% load the CSC file
%
[ theta12swr16, nlxCscTimestampstheta12, cscHeadertheta12, channelx, sampFreqx, nValSampx ] = csc2mat(['/Users/andrewhowe/blairLab/blairlab_data/Theta12/day4ish/' '/CSC' num2str(16) '.ncs']);
%
%% build a SWR band filter (see below for parameter choices. the Fc#
% aren't fixed
%
Fs = 32000;  % Sampling Frequency
N   = 20;   % Order
Fc1 = 110;  % First Cutoff Frequency
Fc2 = 240;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hdswr = design(h, 'butter');
%
%% let's see what happens if we filter an example signal.
%
exampleSwrSignal=filter(Hdswr, theta12swr16(19910133-50000:19910133+200000)); % this magic number came from finding the max of the whole trace.
exampleSwrSignalTime=(1:length(exampleSwrSignal))/32000;
figure;
subplot(2,1,1);
plot(exampleSwrSignalTime , theta12swr16(19910133-50000:19910133+200000), 'Color', [ .7 .7 .7 ]);
subplot(2,1,2);
plot(exampleSwrSignalTime, exampleSwrSignal, 'b')
%% Envelope
% absolute value of the hilbert transform of the signal will provide the
% envelope see 
% http://www.mathworks.com/help/signal/ug/envelope-extraction-using-the-analytic-signal.html?refresh=true
% real time : http://www.mathworks.com/help/dsp/examples/envelope-detection.html
% 
figure;
plot(exampleSwrSignalTime, exampleSwrSignal, 'Color', [ .2 .2 .8 ])
hold on;
plot(exampleSwrSignalTime, abs(hilbert(exampleSwrSignal)),'r');
legend('filterd LFP','Envelope')
%
%% 
%
figure;
plot(exampleSwrSignalTime, abs(exampleSwrSignal), 'Color', [ .1 .8 1 ])
hold on;
plot(exampleSwrSignalTime, exampleSwrSignal, 'Color', [ 0 0 .9 ])
plot(exampleSwrSignalTime, abs(hilbert(exampleSwrSignal)),'k');
legend('filterd LFP','abs(LFP)','Envelope')
%
% the hilbert is useful because it's more powerful than taking the absolute
% value alone on the signal and trying to use that as an aproximation for
% power
%
%
%% Statistics on the Envelope
%
% so now, we want some kind of envelope or power envelope-based method to
% trigger events : this is probably best done by deviation from the MEDIAN
% but lets check out some stuff
%
% this will be performed on the WHOLE time series with 1000 bins. Notice
% that this is NOT a gaussian, so following the mean is meaningless (haha).
% Instead, we'll translate the "x deviations from the mean" way of looking
% at things into probabilities above which a point would need to be.
%
wholeEnvelope=abs(hilbert(filter(Hdswr, theta12swr16)));
[yyy,xxx]=hist(wholeEnvelope,1000);
figure;
plot(xxx(find(yyy)),yyy(find(yyy))/sum(yyy),'o');
hold on;
plot(xxx,cumsum(yyy/sum(yyy)),'k');
oneDev=min(xxx(find(cumsum(yyy)/sum(yyy)>=0.68)));
twoDev=min(xxx(find(cumsum(yyy)/sum(yyy)>=0.95)));
threeDev=min(xxx(find(cumsum(yyy)/sum(yyy)>=0.997)));
fourDev=min(xxx(find(cumsum(yyy)/sum(yyy)>=0.999936657516334)));
lineYs=[ 0 1.1 ];
line([ oneDev oneDev ], lineYs, 'Color', [ .6 .6 .6 ]);
line([ twoDev twoDev ], lineYs, 'Color', [ .6 .6 .6 ]);
line([ threeDev threeDev ], lineYs, 'Color', [ .6 .6 .6 ]);
line([ fourDev fourDev ], lineYs, 'Color', [ .6 .6 .6 ]);
mnenv=mean(wholeEnvelope)
median(wholeEnvelope)
stdenv=std(wholeEnvelope)
mad(wholeEnvelope,1) % this function is stupid. it only calculates MAD with a 1!!!
line([ mnenv+1*stdenv mnenv+1*stdenv ], lineYs, 'Color', [ .9 .6 .6 ]);
line([ mnenv+2*stdenv mnenv+2*stdenv ], lineYs, 'Color', [ .9 .6 .6 ]);
line([ mnenv+3*stdenv mnenv+3*stdenv ], lineYs, 'Color', [ .9 .6 .6 ]);
line([ mnenv+4*stdenv mnenv+4*stdenv ], lineYs, 'Color', [ .9 .6 .6 ]);
line([ mnenv+5*stdenv mnenv+5*stdenv ], lineYs, 'Color', [ .9 .6 .6 ]);
line([ mnenv+7*stdenv mnenv+7*stdenv ], lineYs, 'Color', [ .9 .6 .6 ]);
% well, that pretty clearly shows that standard deviations and means are
% useless for this data! Here's why : Buzsaki uses mean+5*std or 7*std,
% which is equivalent to a ~ 1:1,744,278 or a whopping 1 in 390,682,215,445
% That is not too useful. A more sensible way to think about this is that
% 390,682,215,445 datapoints would be collected in 141.3058 days, and only
% one of these would pass the threshold. This is clearly a ridiculous
% measure. I think a better way to define this is percent of observed
% powers, which is where the histogram and the cummulative sum come in
% handy; they give us a way to define rare events for something which is
% empirically observed.
%
% Now, the problem with this is that there needs to be some kind of online
% distribution tracking performed all the time to do this in real time.
% That is a bit tricky, but fortunately, we might be able to cheat in
% several ways to accomplish this. Namely, the space is defined in bits so
% we already have a limited, discrete range. Furthermore, with some
% observations /in vivo/ we might be able to approximate bin centers prior
% to starting the online recording. Furthermore, data could be stored
% online in RAM using some of the algorithmic online insert sort routines,
% or as suggested by another person online, if RAM is a constraint,
% randomly sample the incoming data stream. It also might be possible to
% bend the percentile up and down depending on how the data is falling
% around the value, but that would need development and testing.

%%
% http://www.sciencedirect.com/science/article/pii/S0896627307010306
%
% == Detection of HFEs and Ripples ==
%
% LFP signals were recorded from one arbitrarily selected channel of each tetrode. 
% A dedicated reference electrode was placed in the corpus callosum within <1 mm 
% from the CA1 tetrodes. All neural signals were recorded relative to that reference 
% tetrode to eliminate muscle artifacts from the recordings. On a given day, the 
% tetrode with the largest number of isolated neurons was chosen for ripple analysis. 
% The LFP envelope was determined by Hilbert transforming the LFP signal from that 
% tetrode after band pass filtering between 150 and 250 Hz. Events were detected if 
% the envelope exceeded threshold for at least 15 ms. Events included times around 
% the triggering event during which the envelope exceeded the mean. Overlapping 
% events were combined. A high threshold of mean + 6 SD of the envelope was used 
% for detecting events that would meet most common definitions of ripples. HFEs 
% were detected with a lower threshold of mean + 3 SD.
%
% Sen Cheng, Loren M. Frank
% "New Experiences Enhance Coordinated Neural Activity in the Hippocampus."
% Neuron Volume 57, Issue 2, 24 January 2008, Pages 303?313.
% 
% SWRs were identified on the basis of peaks in the LFP recorded from one channel 
% from each tetrode in the CA3 and CA1 cell layers. The raw LFP data were 
% bandpass-filtered between 150?250 Hz, and the SWR envelope was determined using 
% a Hilbert transform. The envelope was smoothed with a Gaussian (4-ms s.d.). We 
% initially identified SWR events as sets of times when the smoothed envelope stayed 
% above 3 s.d. of the mean for at least 15 ms on at least one tetrode. We defined the 
% entire SWR as including times immediately before and after that threshold crossing 
% event during which the envelope exceeded the mean. Overlapping SWRs were combined 
% across tetrodes, so many events extended beyond the SWR seen on a single tetrode.
% 
% "Awake replay of remote experiences in the hippocampus."
% Mattias P Karlsson & Loren M Frank
% Nature Neuroscience 12, 913 - 918 (2009); doi:10.1038/nn.2344
% 
% 
% Data processing and analysis. Unit activity and field potentials were filtered 
% digitally (120 dB/octave: unit, band pass 0.5?5.0 kHz; high-frequency ripples, 
% band pass 100?400 Hz) and analyzed off-line on a 486/33 or an IBM RS 6000 computer 
% or both. Putative single units were verified by the absence of spikes ?1 msec 
% (typically >3?5× baseline amplitude) in autocorrelograms, reflecting the refractory 
% period. Remaining unit activity (units >2× baseline, with interspike intervals 
% <1 msec) were considered multiunit. Ripple peaks were detected after off-line 
% filtering (100?400 Hz), using a peak-detection algorithm.
% 
% Single and multiunit activity were cross-correlated with local ripple peaks and local 
% ripple peaks with CA1 ripples, using the ripple peaks as the zero reference point. 
% Local field averages were obtained by averaging wide-band and filtered signals, using 
% ripple peaks or unit pulses as the zero reference.
% 
% "High-Frequency Oscillations in the Output Networks of the Hippocampal?Entorhinal Axis of the Freely Behaving Rat"
% James J. Chrobak and Gyorgy Buzsáki
% The Journal of Neuroscience, 1 May 1996, 16(9): 3056-3066;

%enveloping resource :http://www.mathworks.com/help/dsp/examples/envelope-detection.html


%% ENVELOPE BUILDERS
%
% this method doesn't work well.
%
% the goal was to gaussian filter the signal, which is fine. However,
% Gaussian filtering one side, as required for online analysis doens't work
% at all.
%
%halfGaussWindow=normpdf(1:3200,3200,round(1000)*2);
%figure;
%plot(exampleSwrSignal)
%hold on;
%plot(filter(halfGaussWindow,1,abs(exampleSwrSignal)),'r')
%plot(sqrt(filter(halfGaussWindow,1,(2*exampleSwrSignal.*exampleSwrSignal))),'g')
%
%
% this is a different suggestion for lowpass filtering the energy signal,
% which is the signal squared or something like that. The cool kids use
% hilbert.
%
hlp=fdesign.lowpass('Fp,Fst,Ap,Ast',0.1,0.12,0.1,1e-4,'linear');
hlowpass1= design(hlp, 'equiripple');
plot(sqrt(filter(hlowpass1,(2*exampleSwrSignal.*exampleSwrSignal))),'k')
