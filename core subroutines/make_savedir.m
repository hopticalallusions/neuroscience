disp(['make_savedir'])
recall_rawpath

remember_rawpath

%***Some obvious parameters***
dofilter='y'; donotchfilter='n';
backgroundchans1=['all'];            %default=['all']. can leave empty or write numeric list. The channels in the current set are not used in backgroundchans.  badchannels are removed from this list.
laser_artifact_removal='n';

samplingrate=25000;                 %default=25000 Hz. Used to use 1/44.8e-6 (~22 kHz) pre-2012.  

get_probegeometry      %gives variable 's' and the tipelectrode distance

make_channelsets

clusterstdev=template_clusterstdev;      %used in make_seed_templates.  Higher values produce fewer clusters.  Note that spikes larger/smaller than minamplitude are assigned bigger/smaller value of clusterstdev.
allcluststdev=run_cluststdev;            %used in run_template_matching. can use multiple values e.g. [6 8 10]. can be combined with subtract_templates='y'. note: values don't proportionally alter number of 'good' units.


mergeclusterstdev=1;                %default=3. used in prune_templates
spikedetectionmethod=1;             %1=use fixed amplitude threshold set by minamplitude.  2=use threshold based on detectstdev*noise level.                                        
detectstdev=12.5;                   %default=12.5 (time above noise percentile range).  spike detection threshold, if use spikedetectionmethod=2.
noiseprctile=68;                    %default=68th percentile. Used in making templates.
run_noiseprctile=80;                %default=75th percentile.  Used in run_template_matching.  Created on Sept. 13 2012 because was getting a lot of unassigned spikes, and needed to increase noise level. used to be same as noiseprctile.
upsamplingfactor=3;                 %default=3.
decimationfactor=25;                %default=25;  downsamples LFP signal by this factor. used in get_LFP_muxi.
LFPsamplingrate=samplingrate/decimationfactor;

dotrials=[1:1000];                  %default==[1:1000]. used by run_template_matching.  setting the upper limit to more trials than exist is ok.

origclusterstdev=clusterstdev;     

plottemplates='n';                  %default='n'. sed in make_orig_templates.

minoverlap=12;                      %default=12. used in findpeaks minimum time, in which two spikes are considered separable. determines spike wave alignment parameters
rejecttime=minoverlap;              %if two spikes on two different channels occur within this time, keep only one time.
leftpoints=minoverlap+1;            %left distance for waveforms in seed templates (but not in run_template_matching).
rightpoints=minoverlap+1;           %right time for waveforms in seed templates (but not in run_template_matching).
extraleft=minoverlap;               %used in extract_wave_jitters and aligning waveforms. must be <leftpoints
extraright=minoverlap;              %used in extract_wave_jitters and aligning waveforms. must be <rightpoints

origleftpoints=leftpoints;
origrightpoints=rightpoints;

savewaves='n';                      %default='n'.  saves all waves that are matched to a template in \sortedwaves_mat\.  slows down run_template_matching
plotduringsorting='n';              %'y' shows user plots during run_template_matching; can disable these by setting to 'n'.
subtract_templates='n';             %used in run_template_matching; setting to 'y' will remove templates from data between iterations if length(allcluststdev)>1.
                                    %if 'n', then will only use the value specified in maxcluststdev (from set_plot_parameters) to derive spike times.
                                    %note: subtracting doesn't work well for high-amplitude spikes, because any slight temporal misalignment will create a spurious new spike.
minspikesperunit=1;                 %default=1: round(0.1*length(trainingtrials));  %used in prune_templates
maxchansperclust=30;                %default=15. used in prune_templates.  maximum number of "good" channels in a unit.  prevents artifacts from appearing as units.
minmax_peakratio=1.5;               %default=3. used in align_peaks_muxi and extract_wave_jitters to determine whether to align to +ve or -ve peak.  values >1 prefer -ve, <0 prefer +ve.  must be >0.
                                     
amplitudemethod=3;                  %spike amplitude extraction method. 1=peak-to-peak amplitude, 2=exact value at spiketime

runAutoUnitQuality='s';             %default is 's' (semi-automatic). 'a'=automatic. 'n'=no. 'd'=demo mode that shows results for each unit.

domultisubject='n';
%*****************************************************
  

%****Set directory names*****

disp([analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\'])

savedir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\single-unit\'];

stimulidir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\stimuli\'];

animationdir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\animation\'];

multisavedir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\multiunit\'];

LFPdir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\LFP\']; %LFP analysis.

stimephysdir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\stim-ephys\'];

datadir=[datadrivedir ':\muxi data\' experiment '\' subject '\' datei '\'];

seedtempdir=[savedir 'seed templates\'];
timesdir=[savedir 'sortedtimes\'];
penultwavedir=[savedir 'amps & waves\penultimate\'];
penultunitsJPGdir=[savedir 'units\penultimate\'];
finalwavedir=[savedir 'amps & waves\'];
finalunitsJPGdir=[savedir 'units\'];
finalunitsEPSdir=[savedir 'units\eps\'];
unittimestxtdir=[savedir 'units\text files\'];
LFPvoltagedir=[LFPdir 'raw LFP\'];
LFPspectrumdir=[LFPdir 'spectra\'];
LFPtriggedpowerdir=[LFPdir 'event triggered power\'];

unitclassdir=[savedir 'properties\'];

stimephysjpgdir=[stimephysdir 'jpeg\'];
stimephysepsdir=[stimephysdir 'eps\'];
stimephysmfigdir=[stimephysdir 'matlab figures\'];

rasterjpgdir=[stimephysdir 'raster plots\jpeg\'];
rasterepsdir=[stimephysdir 'raster plots\eps\'];
rastermfigdir=[stimephysdir 'raster plots\matlab figures\'];

burstrasterjpgdir=[stimephysdir 'burst raster plots\jpeg\'];
burstrasterepsdir=[stimephysdir 'burst raster plots\eps\'];
burstrastermfigdir=[stimephysdir 'burst raster plots\matlab figures\'];

tuningcurvejpgdir=[stimephysdir 'tuning curves\jpeg\'];
tuningcurveepsdir=[stimephysdir 'tuning curves\eps\'];
tuningcurvefigdir=[stimephysdir 'tuning curves\matlab figures\'];

FTAdir=[stimephysdir 'FTA\'];

STAdir=[stimephysdir 'STA\'];

modulationdir=[stimephysdir 'modulation\'];

xcovdir=[stimephysdir 'cross-covariance\'];

xcorrdir=[savedir 'cross-correlations\'];
xcorr_reltimesdir=[xcorrdir 'relative times\'];  %used in get_relativespiketimes (old version does not include jitter test).
xcorrjpgdir=[xcorrdir 'corr_jpeg\'];
xcorrepsdir=[xcorrdir 'corr_eps\'];

syncdir=[savedir 'network synchrony\'];

networkxcorrdir=[savedir 'network cross-correlations\'];

wavedir=[savedir 'sortedwaves_mat\'];   
timesdir=[savedir 'sortedtimes\'];

mkdir(savedir);

%*****************************************************
    
close all; warning off

ask_startscratch

%******************************************************