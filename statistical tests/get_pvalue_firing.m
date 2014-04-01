disp(['Finding probability of randomly observing the observed change ("delta") in firing rate between a baseline period and a query bin.'])
%Note: KB significantly improved speed of this program on October 2013.

set_plot_parameters

triggerevent1='CS2';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', 'start', 'stop'
triggerevent2='CS4';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', start', 'stop', 'none'.    

trialselection1='all';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            
                            %***Compatible with 'CS' triggerevents:***
                            %'rewarded' only uses CS trials with a US. 
                            %'unrewarded' only uses CS trials with no solenoid. 
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            
                            %***Compatible with 'solenoid' triggerevent:***
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). note that sol1times have time offset in load_results to align with cue times in plots.
                            
                            %***Compatible with 'startlicking' & 'endlicking' triggerevents:***
                            %'CS1 licking'. licking episodes beginning between CS and CS-US delay time (they don't have to end there).
                            %'CS2 licking'
                            %'spontaneous licking'. excludes cues & solenoids.
                            
                            %***Compatible with +/- 'acceleration', 'start', or 'stop' triggerevents:***
                            %'CS1 running'. event times occuring between CS and CS-US delay time. 
                            %'CS2 running'
                            %'spontaneous running'. excludes cues and licking episodes.
                                                                                                                
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.
 
subselect1='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1 (default).  '[a b c]' will use the designated trials.          
subselect2='all';           %optional subselection of trials.  'all' will use all trials from trialselection 2 (default).  '[a b c]' will use the designated trials.          

laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

baseline_start=-5;          %default=-5. start time of baseline period relative to event onset.
baseline_end=0;             %default=0. end time of baseline period relative to event onset.

query_start=-1;             %default=-1. start time of rate query period relative to event onset. used if onlysigmod='y'. used in find_sigfiring.
query_end=15;               %default=10. end time of rate query period relative to event onset. used if onlysigmod='y'. used in find_sigfiring.
sigtest_binsize=0.05;       %default=0.05 s. bin size to use for finding maximum change in firing rate relative to local baseline in find_sigfiring.
permute_iterations=1000;     %default=1000. number of iterations to run for permutation test (randomly shuffle binned firing rates without replacement). 
%************************************************
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  
timebinsize=sigtest_binsize;

close all
load_results

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

baselinebins = baseline_start:sigtest_binsize:(baseline_end+sigtest_binsize);
querybins = query_start:sigtest_binsize:(query_end+sigtest_binsize);

if strcmp(subselect1,'all') & strcmp(subselect2,'all')
filespec=[triggerevent1 ' vs ' triggerevent2];
else filespec=[triggerevent1 '_' num2str(min(str2num(subselect1))) '-' num2str(max(str2num(subselect1))) ' vs ' triggerevent2 '_' num2str(min(str2num(subselect2))) '-' num2str(max(str2num(subselect2)))];
end

% filespec=input('specify firing_pvalue file name suffix: ', 's');

disp(['will save results as ' savedir 'firing_pvalue_' filespec '.mat'])


observed_deltas = cell(1,length(dounits));
pvalues1 = cell(1,size(dounits,2));
pvalues2 = cell(1,size(dounits,2));
different_bins = zeros(length(dounits),length(querybins)-1);
difference_mat = zeros(length(dounits),length(querybins)-1);

tic

event1_deltarate=[]; event1_pvalue_excitation=[]; event1_pvalue_inhibition=[];
event2_deltarate=[]; event2_pvalue_excitation=[]; event2_pvalue_inhibition=[];
for unitind = 1:length(dounits)
    uniti = dounits(unitind);
    stimesi = spiketimes{uniti};
    
    disp(['Running permutation tests for unit ' num2str(uniti) ' (' num2str(unitind) '/' num2str(length(dounits)) ').'])
    
    e1_spike_counts = zeros(length(doevent1trials),length(querybins));
    e1_baselines = zeros(length(doevent1trials),length(baselinebins));
    for trialind = 1:length(doevent1trials)                                        %Fill up the spike count matrix and the baseline matrix
        trialk=doevent1trials(trialind);
        t0 = event1times(trialk);
        
        baseline_spike_times = (stimesi(stimesi >= (t0 + baseline_start) & stimesi < (t0 + baseline_end + sigtest_binsize)) - t0);
        rel_spike_times = (stimesi(stimesi >= (t0+query_start) & stimesi <= t0+query_end+sigtest_binsize))-t0;
        e1_spike_counts(trialind,:) = histc(rel_spike_times,querybins);
        e1_baselines(trialind,:) = histc(baseline_spike_times,baselinebins);
    end
    
    e2_spike_counts = zeros(length(doevent2trials),length(querybins));
    e2_baselines = zeros(length(doevent2trials),length(baselinebins));
    for trialind = 1:length(doevent2trials)
        trialk=doevent2trials(trialind);
        t0 = event2times(trialk);
       
        eventtimek=t0;
        lick_to_cue_alignment  %only applies if event2 is startlicking. subtracts meanlickonset calculated in select_triggers_trials 
        t0=eventtimek;
        
        baseline_spike_times = (stimesi(stimesi >= (t0 + baseline_start) & stimesi < (t0 + baseline_end + sigtest_binsize)) - t0);
        rel_spike_times = (stimesi(stimesi >= (t0+query_start) & stimesi <= t0+query_end+sigtest_binsize))-(t0);
        e2_spike_counts(trialind,:) = histc(rel_spike_times,querybins);
        e2_baselines(trialind,:) = histc(baseline_spike_times,baselinebins);
    end
    
    var1_base = e1_baselines(:,1:end-1);         %all event1 baselines,trial by trial, with last empty bin removed.
    var1_post = e1_spike_counts(:,1:end-1);      %all event1 observed spike numbers, divided into query bins,trial by trial, with last empty bin removed
    var2_base = e2_baselines(:,1:end-1);         
    var2_post = e2_spike_counts(:,1:end-1);
    
    [pvalue1,pvalue2,obs_deltas] = spikerate_permutation(var1_base,var1_post,var2_base,var2_post,baseline_start,baseline_end,sigtest_binsize,permute_iterations);
   
    event1_deltarate{uniti}=obs_deltas.event1;    %observed deltas for each query bin, event 1.
    event2_deltarate{uniti}=obs_deltas.event2;
    
    event1_pvalue_excitation{uniti}=pvalue1.excite;  %pvalue value for excitation/inhibition of each query bin, event 1.
    event1_pvalue_inhibition{uniti}=pvalue1.inhib;
    
    event2_pvalue_excitation{uniti}=pvalue2.excite;
    event2_pvalue_inhibition{uniti}=pvalue2.inhib;
        
end
toc

firing_pvalue=[];
firing_pvalue.triggerevent1=triggerevent1;
firing_pvalue.triggerevent2=triggerevent2;
firing_pvalue.trialselection1=trialselection1;
firing_pvalue.trialselection2=trialselection2;
firing_pvalue.subselect1=subselect1;
firing_pvalue.subselect2=subselect2;
firing_pvalue.baseline_start=baseline_start;
firing_pvalue.baseline_end=baseline_end;
firing_pvalue.query_start=query_start;
firing_pvalue.query_end=query_end;
firing_pvalue.sigtest_binsize=sigtest_binsize;
firing_pvalue.querybins=querybins;
firing_pvalue.permute_iterations=permute_iterations;
firing_pvalue.event1_deltarate=event1_deltarate;
firing_pvalue.event2_deltarate=event2_deltarate;
firing_pvalue.event1_pvalue_excitation=event1_pvalue_excitation;
firing_pvalue.event1_pvalue_inhibition=event1_pvalue_inhibition;
firing_pvalue.event2_pvalue_excitation=event2_pvalue_excitation;
firing_pvalue.event2_pvalue_inhibition=event2_pvalue_inhibition;

if strcmp(triggerevent2,'startlicking')
firing_pvalue.meanlickonset=meanlickonset;
end

save([savedir 'firing_pvalue_' filespec '.mat'], 'firing_pvalue', '-mat')

disp('done calculating p-value of unit responses to specific events')
