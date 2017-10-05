function nlxstruct = MB_filtfilt( nlxstruct, dfh, tshift, plotflag, blocksize, outreal_mean, input_scalefact )
                                                                
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
% nlxstruct contains data to filter; fields of the structure are as follows:
%    nlxstruct.gapstart = any gaps in the data are filled with NaNs; this vector contains the start index of each gap
%    nlxstruct.gaplength = this vector contains the length (number of NaNs) of each NaN gap
%    nlxstruct.channel = channel number for this data
%    nlxstruct.dsfactor = downsampling factor (DS) for this data
%    nlxstruct.dt = sample interval for this data
%    nlxstruct.dcowidth = DCO window size for this data
%    nlxstruct.data = 24 bit signed integer data, downsampled and DCO filtered (centered at zero)
%    nlxstruct.filtered = substructure containing filtered versions of the data 
%                        (an additional element will be added to this upon return)
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

if nargin<3
    tshift=0; %default is do not plot graphs
end

if nargin<4
    plotflag=0; %default is do not plot graphs
end

if nargin<5
    blocksize=100; %default blocksize is 100
end

if nargin<6
    outreal_mean=.12; %default envelope amplitude for target signal is .12
end


input_mean=.5; %mean value for training input signal must be .5 (center of 0-1 range)

%extract data from nlxstruct
scalefact=17;
lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
sint=nlxstruct.dt
srate=1/sint;
timestamps=[sint:sint:(length(lfp)*sint)]-sint;
m=max(timestamps); 
lbound=0;
rbound=m;

%%%%%%%%%%%%%%%%%%%%%% MANUALLY SCALE INPUT DATA %%%%%%%%%%%%%%%%%%%%

scrsz = get(groot,'ScreenSize');
figure('Position',[100 scrsz(4)/7 scrsz(3)/1.2 scrsz(4)/2]); clf;
plot(timestamps, lfp, 'k');
line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
set(gca,'YLim',[-1000 2^15+1000]);
xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
title('SELECT SCALING FACTOR FOR INPUT DATA ( +/- = adjust Scale Factor; ENTER = accept )');
set(gca,'XLim',[0 m]);
if any(isnan(lfp))
    xlabel('WARNING!!!! INPUT DATA CONTAINS NaNs THAT WILL BE REPLACED WITH ZEROS');
    ndex=find(isnan(lfp));
    lfp(ndex)=2^14;
end

xbound=[];
button=0;
splice_x=[1 length(timestamps)];
while ~(button==13)
    [x, y, button]=ginput(1);
    if button==43 %|| button==61)
            scalefact=scalefact-1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0; ndex=find(isnan(lfp)); lfp(ndex)=2^14;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            set(gca,'YLim',[-1000 2^15+1000]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('SELECT SCALING FACTOR FOR INPUT DATA ( +/- = adjust Scale Factor; ENTER = accept )');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
    if button==61
            scalefact=scalefact-1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0; ndex=find(isnan(lfp)); lfp(ndex)=2^14;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            set(gca,'YLim',[-1000 2^15+1000]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('SELECT SCALING FACTOR FOR INPUT DATA ( +/- = adjust Scale Factor; ENTER = accept )');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
    if button==45
            scalefact=scalefact+1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0; ndex=find(isnan(lfp)); lfp(ndex)=2^14;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            set(gca,'YLim',[-1000 2^15+1000]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('SELECT SCALING FACTOR FOR INPUT DATA ( +/- = adjust Scale Factor; ENTER = accept )');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
    if button==95
            scalefact=scalefact+1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0; ndex=find(isnan(lfp)); lfp(ndex)=2^14;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            set(gca,'YLim',[-1000 2^15+1000]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('SELECT SCALING FACTOR FOR INPUT DATA ( +/- = adjust Scale Factor; ENTER = accept )');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
end

close(gcf);
scaled_lfp=lfp/(2^15);
std_lfp=std(abs(scaled_lfp));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FILTER THE DATA %%%%%%%%%%%%%%%%%%%%%%%%

%create the bandpass filter using 'designfilt' from the MATLAB signal processing toolbox
%dfh = designfilt('bandpassiir', 'StopbandFrequency1', Fstop1, 'PassbandFrequency1', Fpass1, 'PassbandFrequency2', Fpass2, 'StopbandFrequency2', Fstop2, 'StopbandAttenuation1', Astop1, 'PassbandRipple', Apass, 'StopbandAttenuation2', Astop2, 'SampleRate', srate);

%apply the filter to compute F[u(t)]
training_target=filtfilt(dfh,lfp);
training_target=hilbert(training_target);

if tshift<0
    training_target=training_target((1-tshift):end);
%    lfp=lfp(1:(end+tshift));
elseif tshift>0
    training_target=training_target(1:(end-tshift));
%    lfp=lfp((1+tshift):end);
end

%%%%%%%%%%%%%%%%%%%%%%% POLL TO KEEP DATA %%%%%%%%%%%%%%%

std_target=std(abs(real(training_target)));
outscale=(2*std_lfp)/std_target;
training_target=training_target*outscale;
training_target(find(training_target>1))=1; 
training_target(find(training_target<-1))=-1;

figure('Position',[100 scrsz(4)/7 scrsz(3)/1.2 scrsz(4)/2]); clf;
plot(timestamps, real(training_target), 'k'); hold on;
plot(timestamps, imag(training_target), 'r');
line([0 m],[-1 -1]); line([0 m],[1 1]); line([0 m],[0 0]);
set(gca,'YLim',[-1.05 1.05]);
xlabel('Time (s)'); 
title('KEEP RESULTS? ( s = store result; SPACE = discard )');
set(gca,'XLim',[0 m]);

xbound=[];
button=0;
splice_x=[1 length(timestamps)];
while ~(button==32)
    [x, y, button]=ginput(1);
    if button==115
            numf=length(nlxstruct.filtered)+1;
            nlxstruct.filtered(numf).filter = dfh;
            nlxstruct.filtered(numf).teaching_signal = training_target;
            nlxstruct.filtered(numf).training_output = NaN;
            nlxstruct.filtered(numf).testing_output = NaN;
            nlxstruct.filtered(numf).input_scalefact = scalefact;
            nlxstruct.filtered(numf).training_segment = NaN;
            nlxstruct.filtered(numf).testing_segment = NaN;
            button=32;
    end
end

close(gcf);

