function [ training_input, training_target, input_scalefact, timestamps ] = MB_bandpassHPP( HPPfile, baserate, Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, tshift, plotflag, blocksize, outreal_mean, input_scalefact )
                                                                
%%%ADD TRUNCATION WARNINGS IF VALUES <0 OR >1 ARE OBTAINED

% This function filters an EEG time series, u(t), from an HPP data file using an acausal IIR bandpass
% filter, to produce a filtered output signal F[u(t)]. It returns two vectors called 'training_input' and 
% 'training_target' which can be used as input and target vectors, respectively, for training a MockingBird 
% FEM to mimic the specified bandpass filter. The function also returns 'input_scalefact' which is the 
% appropriate scaling factor for converting raw 24-bit input data from the HPP file to floating point values
% between 0 and 1, as required by the trainer and by the MockingBird inference engine on the FPGA (the 
% target range for conversion is specified by the arguments 'input_mean' and 'input_std').

% Resonance artifacts typically appear at the beginning and end of the bandpass filtered signal, so both u(t) and 
% F[u(t)] are truncated to remove these artifacts. The lengths of the input & target vectors must be 
% equal, and their length be an integer multiple of the training block size, passed as 'blocksize.' Consequently, the 
% results returned in 'training_input' and 'training_target' will be equal in size, and will typically have fewer 
% elements than the original file data.

% It is possible to shift the input and target vectors relative to one another, by a number of timesteps specified 
% in 'tshift.' This allows a tradeoff between how accurately the trained LSTM mimics the filter (accuracy improves
% with longer filter delays) versus the latency at which filter output is generated (shorter filter delays give faster
% output latencies, and it is possible to predict future output--at a cost of accuracy--by using negative filter delays).

%%% ARGUMENTS:
% HPPfile = HPP format data file contains one 24-bit fixed point value (signed integer) per line:
%            First data value is the channel number the data came from (not used here)
%            Second value is the factor by which the data was previously downsampled from baserate
%            Third through last values are the EEG time series data to be filtered
% baserate = input sample rate from which EEG data was downsampled
% Fstop1 = First Stopband Frequency (Hz)
% Fpass1 = First Passband Frequency (Hz)
% Fpass2 = Second Passband Frequency (Hz)
% Fstop2 = Second Stopband Frequency (Hz)
% Astop1 = First Stopband Attenuation (dB)
% Apass  = Passband Ripple (dB)
% Astop2 = Second Stopband Attenuation (dB)
% tshift = number of time steps to shift target from input
%          zero shift yields zero filter delay (a causal filter that predicts target based only on data from the present and prior time steps)
%          positive shifts delay the target from the input (resulting in better accuracy, but output predicts past rather than present value of the target, so a filter delay is introduced)
%          negative shifts delay the input from the target (resulting in worse accuracy, but output predict future rather than present value of the target)
% plotflag = 0 - don't graph results; 1 - graph results
% blocksize = number of samples per LSTM training block (default = 100)
% outreal_mean = rescale the output data to have this mean envelope amplitude (default = .12)
% input_scalefact = exponent for input scaling factor (if omitted, it will be computed automatically)
 
%%% RETURN VALUES:
% training_input = input data set for training the LSTM ( u(t) data from 'HPPfile' truncated and rescaled to floating point values between 0 and 1)
% training_target = target data set for training the LSTM ( F[u(t)] data truncated and rescaled to floating point values between -1 and 1)
%                    this is a complex vector containing the real and imaginary components of the Hilbert transform of F[u(t)]
% input_scalefact = factor by which to scale raw 24 bit Neuralynx values u(t) to the floating point range of 0 through 1 using the formula:
%                    [ u(t) + 2^(input_scalefact-1) ] / [ 2^input_scalefact ]

if nargin<10
    tshift=0; %default is do not plot graphs
end

if nargin<11
    plotflag=0; %default is do not plot graphs
end

if nargin<12
    blocksize=100; %default blocksize is 100
end

if nargin<13
    outreal_mean=.12; %default envelope amplitude for target signal is .12
end

%if nargin<11
%    plotflag=0; %default is do not plot graphs
%end

input_mean=.5; %mean value for training input signal must be .5 (center of 0-1 range)

%extract data from the HPP file
lfp = dlmread(HPPfile);
srate=round(baserate/lfp(2)); %compute sampling rate for the data file
lfp=lfp(4:end); %truncate channel and downsampling rate to obtain u(t)
timestamps=[(1/srate):(1/srate):length(lfp)/srate]-1/srate;

%create the bandpass filter using 'designfilt' from the MATLAB signal processing toolbox
dfh = designfilt('bandpassiir', 'StopbandFrequency1', Fstop1, 'PassbandFrequency1', Fpass1, 'PassbandFrequency2', Fpass2, 'StopbandFrequency2', Fstop2, 'StopbandAttenuation1', Astop1, 'PassbandRipple', Apass, 'StopbandAttenuation2', Astop2, 'SampleRate', srate);

%apply the filter to compute F[u(t)]
training_target=filtfilt(dfh,lfp);

if tshift<0
    training_target=training_target((1-tshift):end);
    lfp=lfp(1:(end+tshift));
elseif tshift>0
    training_target=training_target(1:(end-tshift));
    lfp=lfp((1+tshift):end);
end


%truncate the damping resonance from the beginning of u(t) and F[u(t)] 
temp=diff(abs(training_target));
peakdex=find(temp(2:end)<0 & temp(1:end-1)>0);
temp=abs(training_target);
peakval=temp(peakdex);
uptick=find(peakval(2:end)>peakval(1:end-1));
startpoint=peakdex(uptick(2)); %start second time a peak is bigger then the previous one
endpoint=length(lfp)-startpoint;%2*find(abs(training_target(end:-1:1))<abs(hilbert(lfp(end:-1:1))),1,'first');
training_input=lfp(startpoint:endpoint);
training_target=training_target(startpoint:endpoint);
timestamps=timestamps(startpoint:endpoint);

%take hilbert transform of F[u(t)]
training_target=hilbert(training_target);

%go back, jack, and do it again (wheels turnin' round and round)
temp=diff(abs(imag(training_target)));
peakdex=find(temp(2:end)<0 & temp(1:end-1)>0);
temp=abs(imag(training_target));
peakval=temp(peakdex);
uptick=find(peakval(2:end)>peakval(1:end-1));
startpoint=peakdex(uptick(1)); %start first time a peak is bigger then the previous one
endpoint=length(training_target)-startpoint;%2*find(abs(training_target(end:-1:1))<abs(hilbert(lfp(end:-1:1))),1,'first');

%make vector lengths in integer multiple of blocksize for the LSTM trainer
excesslen=mod(endpoint-startpoint,blocksize)+1;
startpoint=startpoint+round(excesslen/2);
 if round(excesslen/2)==excesslen/2
     endpoint=endpoint-excesslen/2;
 else
     endpoint=endpoint-round(excesslen/2)+1;
 end
training_input=training_input(startpoint:endpoint);
training_target=training_target(startpoint:endpoint);
timestamps=timestamps(startpoint:endpoint);

% scale input vector between 0 and 1 for use as a training sample
% the scaling factor is increased by factors of 2 to find the largest amplification that does not yield a truncation error
if nargin<14
    input_scalefact=20; %start with small amplification
    temp=(training_input+2^(input_scalefact-1))/(2^input_scalefact);
    while isempty(find(temp<0)) & isempty(find(temp>1)) %if the current scaling factor yields no truncation errors
        input_scalefact=input_scalefact-1; %then double the amplification
        temp=(training_input+2^(input_scalefact-1))/(2^input_scalefact); %and recompute the scaled input
    end
    input_scalefact=input_scalefact+1; %go back to the last scaling factor that did not produce a truncation error
    training_input=(training_input+2^(input_scalefact-1))/(2^input_scalefact); %apply the scaling factor
end

% scale target vector between -1 and 1 for use as an LSTM teaching signal
meanabs=mean(abs(real(training_target)));
output_scalefact=(outreal_mean/meanabs);
training_target=training_target*output_scalefact; %scale training signal so that mean absolute value of real component equals outreal_mean
uptruncs=find(real(training_target)>1);
if ~isempty(uptruncs)
    ['WARNING!!!! ' num2str(length(uptruncs)) ' values in the real output vector are >1']
end
downtruncs=find(real(training_target)<-1);
if ~isempty(downtruncs)
    ['WARNING!!!! ' num2str(length(downtruncs)) ' values in the real output vector are <-1']
end
uptruncs=find(imag(training_target)>1);
if ~isempty(uptruncs)
    ['WARNING!!!! ' num2str(length(uptruncs)) ' values in the imaginary output vector are >1']
end
downtruncs=find(imag(training_target)<-1);
if ~isempty(downtruncs)
    ['WARNING!!!! ' num2str(length(downtruncs)) ' values in the imaginary output vector are <-1']
end


if plotflag %plot u(t) and F[u(t)] if requested
    figure(1); clf;
    plot(timestamps,training_input,'k');
    hold on; plot(timestamps,real(training_target),'r');
    hold on; plot(timestamps,imag(training_target),'b');
%     hold on; 
%     plot((1/srate):(1/srate):(length(training_target)/srate),abs(training_target));
%     hold on; 
%     plot((1/srate):(1/srate):(length(training_target)/srate),abs(hilbert(training_input)));
end
