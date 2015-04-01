%  % ahowe
if ~exist('origleftpoints')
    minoverlap=12;                      %default=12. used in findpeaks minimum time, in which two spikes are considered separable. determines spike wave alignment parameters
    origleftpoints=minoverlap+1;            %left distance for waveforms in seed templates (but not in run_template_matching).
end
if ~exist('origrightpoints')
    minoverlap=12;                      %default=12. used in findpeaks minimum time, in which two spikes are considered separable. determines spike wave alignment parameters
    origrightpoints=minoverlap+1;           %right time for waveforms in seed templates (but not in run_template_matching).
end
if ~exist('upsamplingfactor')
    upsamplingfactor=3;                 %default=3.
end
% %%%

%****Set parameters*********
dofilter='y';               %'y' or 'n' to either do or not do bandpass filtering.  You must do at least highpass filtering to make sense of the data.
final_f_low=300;             %highpass filter frequency. used in final_times_to_waves. default=500.
final_f_high=6500;          %lowpass filter frequency.  used in final_times_to_waves. default=6500.
n=3;                        %number of poles of Butterworth filter.  default=3.

filterLFP='y';              %filter LFP signals using f_low_LFP and f_high_LFP
n_LFP=3;
f_low_LFP=35;              %used in LFP analyses
f_high_LFP=45;             %used in LFP analyses
                           %Theta:6-10 Hz  (definition: 4-7 Hz)
                           %Beta: 15-28 Hz.  (definition: 12-30 Hz).
                           %Low Gamma: 45-55 Hz.  

timebinsize=0.25;           %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.
preeventtime=2;               %time in sec to use before event onset.
posteventtime=10;              %time in sec to use after event onset.

trialgroupsize=10;         %used in select_triggers_trials
grouptimebinsize=0.1;
groupplotstyle='waterfall';     %options: 'waterfall', 'surf'. used in trigged_rasterplots
                            
isibinsize=0.001;           %bin size for ISI 
isirange=0.2;    

STAplotmax=200;             %default=400; max waveforms to extract in spike_triggered_ave.
STAmaxwavesize=100e6;       %default=100e6.  used in spike_triggered_ave.
STAleft=11000;
STAright=11000;
STAdecimatefactor=44;
STA_f_low=1;
STA_f_high=250;

%***end setting parameters****

qualitycutoff=1;           %default=1. unit qualities: 1, 2, 3. 1=best, 2=medium quality, 3=not single-unit. used in select_douniters.

subselect1='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1.  '[a b c]' will use the designated trials.          
subselect2='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1.  '[a b c]' will use the designated trials.          

xcompression=1.5;             %for visualization only.   higher values spread out waveforms in x. 
ycompression=0.2;           %for visualization only.  higher values expand waveforms in y. 

removebadunits='n';         %'y' means all units in violation of ISI criterion will not be included in spikes_to_waves and plot_summary_muxi.
dontdounits=[];             %units that appear to be duplicates based on ccg or other metrics.

leftpoints=origleftpoints+2*upsamplingfactor-1;   %default=18. used in get_penultimate_units/spiketimes_to_wave. (doesn't affect sorting or template matching).
rightpoints=origrightpoints+2*upsamplingfactor;   %default=19.

final_leftpoints=18;        %default=18. used in get_final_units/final_times_to_waves
final_rightpoints=50-final_leftpoints-1;       %default=31, so that waveform plot span is 2 ms.

plotmax_penult=100;                %default=100; max waveforms or points to plot in get_penultimate_units.
plotmax=100;                       %used in get_final_units and plotting 
maxwavesize=20e6;            %default=10e6.  maximum number of bytes per wave file; used in spiketimes_to_waves & save_final_waves_amps.

col=[];
for i=1:10;
col=[col; colormap(hsv(128)); colormap('Autumn'); colormap('Winter'); colormap('Spring'); colormap('Summer')];
end

%plotchannels=[s.channels];
plotbackgroundchans=setdiff(origbackgroundchans,badchannels);     %ok to leave empty. any channels added here will be subtracted from the data to remove noise artifacts.
badbackgroundchans=[];      %specify any faulty channels on the probe.  
maxcluststdev=10.5;         %default=12.5.  only keeps iterations whose clusterstdev was <= this value if subtract_templates=='y', or == this value if subtract_templates=='n'
if length(find(allcluststdev==maxcluststdev))~=1    
maxcluststdev=allcluststdev(1);
end
 
if exist([savedir 'runparameters.mat'])
load([savedir 'runparameters.mat']);  %loads parameters file.  
trialduration=parameters.trialduration;
minplotamp=parameters.minamplitude; %minimum amplitude on a channel required to include in spike triangulation.          
end
if exist([savedir 'final_params.mat'],'file')
    load([savedir 'final_params.mat']);  %loads final parameters file.  
end
scrsz=get(0,'ScreenSize');

if exist('trialduration','var')
getannotations_muxi
if isempty(timeannotations{1})
   startevent=1;
   timeannotations=timeannotations(2:length(timeannotations));
   eventannotations=eventannotations(2:length(eventannotations));
else startevent=1;
end   

if length(eventannotations)>1
delete([savedir 'annotations.txt'])   %create annotations file to store events.
for i=1:(length(eventannotations)-1);
   linei=['time of ' eventannotations{i} ' (s):  ' num2str(timeannotations{i})];
   dlmwrite([savedir 'annotations.txt'],linei,'-append','delimiter','','newline','pc')
end
end
end