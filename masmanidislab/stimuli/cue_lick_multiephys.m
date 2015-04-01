['calculating stimulus-triggered field and psth profile.']

set_plot_parameters

xdiv=0.4; %units in seconds.
ydiv=0.2;  %units in mm.

selectstim='n'; %if 'y', will only select the specified stimulus value (e.g., moving bar angle=90 degrees) for triggered averaging.
timebinsize=0.05;  %default=0.05 s. bin size for psth and average lick rate.
%************************************************

load([LFPdir 'LFPparams.mat'])
load([timesdir 'finalspiketimes.mat'])
load([savedir 'final_params.mat']);  %loads parameters file.
load([savedir 'units\wave specs\' 'spikeposition' '.mat'])
load([stimulidir 'stimuli.mat'])

mkdir(stimephysdir); mkdir(rasterjpgdir); mkdir(rasterepsdir); mkdir(rastermfigdir)
scrsz=get(0,'ScreenSize');
select_dounits

LFPsamplingrate=LFPparameters.samplingrate;
roughyposition=spikeposition.y;
halfwidth=parameters.wavespecs.halfwidth;
troughamp=parameters.wavespecs.troughamp;
peakamp=parameters.wavespecs.postpeakamp;
allshafts=parameters.shafts;
shafts=allshafts(dounits);  
bestchannels=parameters.bestchannels;
uniqueshafts=unique(shafts);
numberofshafts=length(unique(shafts));

cue1times=stimuli.cue1times;
cue2times=stimuli.cue2times;
sol1times=stimuli.sol1times;
precuetime=stimuli.precuetime;
postcuetime=stimuli.postcuetime;
cue1_alllicktimes=stimuli.cue1_alllicktimes;
cue2_alllicktimes=stimuli.cue2_alllicktimes;

timebins=-precuetime:timebinsize:postcuetime;
uniquedepths=unique(s.y);
probedepths=-(uniquedepths-max(uniquedepths)-tipelectrode)/1000;
figind=1;
['unit selection quality cutoff = ' num2str(qualitycutoff) '.']
      
%1.
if exist([multisavedir 'multitimes.mat'],'file')>0   %only runs this if had previously run get_multiunit
['finding cue-triggered multiunit depth profiles.']
figind=figind+1;
cuetriggered_multiunitrate_depth
else ['Did not find multiunit spiketime files.  Need to run get_multiunit.']
end

['done']