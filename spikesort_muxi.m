%Created May 10 2011, updated July 2013.  This program is for analysis of electrophysiological, behavioral, and stimulus data.  

probetype='probe_256A';             %probe type.  open <<get_probegeometry>> for list of probe names.  
badchannels=[35 36 42 48 114 129 221 256];                    %ok to leave empty. specifies the faulty channels on the probe.

trainingtrials=[15:-1:1];           %default=[10:-1:1]. can go backwards. used by make_seed_templates. setting the upper limit to more trials than exist is ok.

minamplitude=45;                    %default=45; can also leave empty and will calculate in make_seed_templates, but tends to be overestimate in high-spiking areas.   spike detection threshold, if use spikedetectionmethod=1.                                                                                                      

f_low=600;                          %default=600.  bandpass filter, low frequency. 
f_high=6500;                        %default=6500. bandpass filter, high frequency.
n=3;                                %default=3.    number of poles of butterworth filter

template_clusterstdev=11;                    %default=8. used in make_seed_templates.  Higher values produce fewer clusters.  Note that spikes larger/smaller than minamplitude are assigned bigger/smaller value of clusterstdev.
run_cluststdev=[11];                 %default=[10]. used in run_template_matching. can use multiple values e.g. [6 8 10]. can be combined with subtract_templates='y'. note: values don't proportionally alter number of 'good' units.
max_tempupdatefraction=0.1;        %default=0.1. used in run_template_matching. maximum fraction to update template for next trial by the mean of matched spikes in the current trial.

finalCVtestfactor=4;                  %default=3. used in get_final_units and its subroutine unitmerge_CVtest. minimum value of 1/CV needed to keep a unit. higher values keep fewer units, and permit fewer mergers.
finalmergeSDfactor=4;                %default=3. used in get_final_units. higher values merge more units.
maxmergedistance=40;                %default=40. used in get_final_units. maximum vertical separation in microns that a channel can be from the best channel and still be be included in waveform comparison during merging step. 

final_minspikesperunit=50;         %default=100; used in get_final_units & auto_unit_quality. minimum number of spikes required for a unit to be scored >3.
minVtrough=50;                     %default=50 uV; used in auto_unit_quality.  minimum trough voltage required for a unit to be scored >3.

% *******************Finished setting parameters***********************

make_savedir;                       %asks user for raw data directory & makes savedir in corresponding \data analysis\ directory.

% get_stimuli                       %extracts stimulus event (cue, solenoid & lick,..) times and saves in stimuli folder in data analysis. note: this program may be run separately from spikesort_muxi.

% get_raw_LFP                       %extracts the unfiltered, downsampled signal for every channel. Required for any analysis involving LFP.

if startfromscratch=='y'

split_channelsets                   %asks whether to split template making and matching tasks on multiple network drives. each drive will get a group of channel sets to work with.

get_laserartifacts                  %optional: collects mean laser-induced artifact for every good channel, and subtracts this from raw data before doing any spike collection. note: artifact removal is not perfect.

make_seed_templates                 %creates templates from 'seed' sets of channels (usually nearest neighbors). stores as sortspikes_seti.mat
                                                                                                                        
make_orig_templates                 %final selection of unique templates. 
                                                                                          
run_template_matching               %matches data to templates on each set of channels. can use multiple values for allcluststdev and can do template subtraction from data.
                                                                     
get_penultimate_units               %does some light merging of units in their sets, and collects waveforms across all channels on a shaft.

combine_channelsets                 %if template making and matching tasks were split, will upload penultimate results to master drive, rename files and continue with get_final_units on the master drive.

get_final_units                     %discards units if they fail SD test, and merges similar units based on SD of waveforms across all channels. bad units are called 'badunits', and merged units are in 'mergeclusts'
  
plot_summary_muxi                   %plots waveforms, isi, psth for each unit and stores figures in \units\. 

get_unitquality                     %assigns score of 1, 2, or 3 to each unit. 

get_positions                       %assigns the position of the probe tips and determines unit coordinates relative to bregma.

annotate_brainregion                %annotates each unit into a pre-defined brain region, and saves to positions.mat Can adjust get_positions to match histologically reconstructed track locations with the defined boundaries.

get_unitproperties                  %calculates waveform properties of units and gives option to classify them. see classify_unitj for classification criteria and naming convention.

%***Spike Time Analysis***

get_pvalue_firing                   %finds probability of randomly obtaining the observed change in firing rate btwn baseline period and a query bin. required to find significantly modulated units. slow (~12 min per unit).

event_triggered_firing              %aligns unit activity to selected events & makes plots (firing rate stacks, raster plots).

get_bursts                          %finds slow and rapid burst episode times and counts number of spikes per burst. required to do burst time analysis. ~5 minutes.

event_triggered_bursting            %plots stack of event-triggered normalized bursting. can select slow or rapid burst and minimum number of spikes per burst episode.

get_event_discrimination            %finds units that significantly discriminate between two specified events during the specified postevent time (using trial-averaged firing rates).

get_motion_correlations             %KB working on this. 

get_pearson                         %calculates Pearson correlation coefficients and p-value from shuffled trials. slow (~3-4 hrs on one computer).
 
plot_pearson                        %plots: Pearson correlation coefficients vs. distance; prob. of finding significant corr coef vs distance; corr coef matrix. allows plotting of multiple subjects.

get_pairwise_crosscorr              %calculates pairwise cross correlation of observed and time-jittered data. very slow (~10 min avg per pair, allspikes, 1.5 hr duration, 500 iterations). run 3 Matlab instances per computer.

plot_pairwise_crosscorr             %plots: probability of finding significant cross-correlation pair vs distance; connectivity matrix

plot_dynamic_crosscorr              %calculates and plots cross-correlations without any jitter tests. fast way of checking for connectivity.

get_network_sync                    %finds synchronous firing. grouped by putative cell classes and for all units. uses permutation test to find significance threshold. very slow (~24 hrs).

event_triggered_sync                %plots trial by trial raster and average of event-triggered synchronous firing. requires get_network_sync

%***Statistical test functions***

test_timeseries                     %function that does bin by bin permutation test between two time series (e.g., zscore, rate vs time, etc...)

test_groups                         %function that does permutation test on a list of scalar quantities belonging to two subject groups (e.g. peak firing latency, fractional rate change, correlation coefficient, etc...). 

test_chisquare                      %function that performs the Pearson's chi square test for equality of distributions (e.g., proportion of all functionally connected cell pairs between two groups).

%***LFP Analysis***

get_triggedspectra                  %gets event-triggered power spectral density for each trial and channel. 

get_triggedLFPpower                 %gets event-triggered LFP power in the specified LFP frequency band.

event_triggered_LFP                 %aligns LFP activity to selected events & makes plots (spectrograms, stacks of power vs time).

plot_LFPstack                       %plots depth stack of event-triggered LFP for selected trials. contains additional plot settings inside subroutine script.

get_laserLFPsweep                   %plots average LFP power vs laser modulation frequency. used in optogenetics experiments to find resonances etc. requires doing a sinusoidal frequency sweep (detected in get_stimuli).

get_LFP_crosscovariance             %obtains cross covariance of LFP in specified frequency band and time points, and plots cross covariance matrix. slow (overnight)

%***Spike-LFP Interaction Analysis***

spike_LFP                           %obtains average LFP signal triggered on peaks, and plots the triggered LFP and PSTH vs depth. triggered on a reference channel. 

get_FTA                             %gets field-triggered average on all electrodes in specified frequency range.

plot_FTA                            %plots FTA data (raster of LFP peaks, FTA spike rate).

get_STA                             %gets spike-triggered average of LFP on all electrodes for each unit.

plot_STA                            %plots STA data (average STA signal, Fourier transform, power spectrum). 

% get_spikeLFPmodulation              %determines the field-triggered firing rate modulation indices as a function of both LFP frequency and amplitude threshold. very slow (multi-day)

%***Misc. Analysis***

multisubject_firing                  %combines results across multiple subjects.

multisubject_celltypes               %plots scatter plots of classified units from multiple subjects.

multisubject_behavior                %plots behavioral performance parameters of each subject.

get_placecells                       %used to plot firing rate vs position in VR arena recordings.

set_plotsize                         %sets plot size, aspect ratio and other useful parameters for exporting.

plot_signalwithunits                 %plots selected time range of data, and marks location of each good unit. Convenient for checking spike sorting & unitquality results.  

% rename_crashfiles                  %renames files if ephys program crashed during data acquisition.
% share_data                         %asks user whether to share all files containing filename between specified network drives.
% response_latency                   %needs removal of t-test and replacement with permutation test. calculates latency of event-triggered firing in a variety of ways (peak rate, time to first burst, statistically significant deviation from baseline)
% pca_firing                         %not very informative as of now. also need to check PCA dimensions (there might be an extra or missing matrix transpose function). calculates principal components of event-triggered firing.
% compare_units                      %not very informative as of now. compares event-triggered firing properties of units in a variety of ways (Euclidean distance, similarity index, center of mass. 
% rerun_matching                     %work in progress.  requires running get_final_units without the new filter settings.
% get_relativespiketimes             %alternative to get_crosscorr for calculating cross correlations by directly counting spikes rather than using xcorr function. Does not do jitter test, thus is >>faster than get_crosscorr.
% plot_relativespiketimes            %pairwise cross-correlograms, plotted separately for each unique pair. requires get_relativespiketimes. 
% get_network_correlations           %finds cross-correlation using at least one network-level sync spike train as one of the "cell" pairs. ~5 min per 1000 iterations per pair. requires get_network_sync
% plot_network_correlations          %in progress...need to save significant results.
% get_multiunit                      %multiunit spike detection.
% triggered_multiunit                %event-triggered multiunit depth stacks. need stimuli file.
% cue_lick_multiephys                %cues (olfactory, visual, etc), lickometer & multiunit ephys analysis.
% get_bar_parameters                 %visual stimulus analysis: obtains start and end times and angle of moving bar stimulus.
% bar_visual_response                %visual stimulus analysis: plots the psth for each unique moving bar angle.
% stimtrig_spike_LFP                 %visual stimulus analysis: visual grating stimuli. stimulus-triggered LFP & PSTH profiles. 
% movie_muxi                         %creates movie of raw data with spike audio. need to use virtualdub to compress and combine audio with video. does not require spike sorting.                                                                       

end