disp('Finding event1-event2 unit discrimination properties (comparing trial-averaged firing rates).')

set_plot_parameters

baseline_start=-5;          %default=-5. start time of baseline period relative to event onset.
baseline_end=0;             %default=0. end time of baseline period relative to event onset.

query_start=0;             %default=0. start time of rate query period relative to event onset. used if onlysigmod='y'. used to determine event 1 or 2 firing significance in get_sigfiring_units, and as discrim query.
query_end=2.5;             %default=2.5. end time of rate query period relative to event onset. used if onlysigmod='y'. used to determine event 1 or 2 firing significance in get_sigfiring_units, and as discrim query.

max_pvalue=0.05;           %default=0.05. threshold for accepting event-triggered firing rate changes as significant. used in get_sigfiring_units.
permute_iterations=1000;     %default=1000. number of iterations to run for permutation test (randomly shuffle binned firing rates without replacement). 

do_quickplots='n';          %shows the significant cross-correlation plots with the 99th percent confidence intervals. user can reject any outlier pairs that show spuriuosly high cross-correlation.
do_differenceplots = 'n';
%************************************************
onlysigmod='y';            %required='y'. Note: need to have run get_response_pvalue probably using the SAME triggerevents & trials.
triggerevent3='none';      %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
smoothingwindow='n';       %default='y'. used in event_trigrates.

close all
load_results

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

grouptimebins=-preeventtime:grouptimebinsize:posteventtime;

filespec=uigetfile([savedir 'firing_pvalue*'], 'select the firing_pvalue file for use in signifance test');
load([savedir filespec])
triggerevent1=firing_pvalue.triggerevent1;
triggerevent2=firing_pvalue.triggerevent2;
trialselection1=firing_pvalue.trialselection1;
trialselection2=firing_pvalue.trialselection2;
timebinsize=firing_pvalue.sigtest_binsize;
event1_pvalue.excitation = firing_pvalue.event1_pvalue_excitation;
event1_pvalue.inhibition = firing_pvalue.event1_pvalue_inhibition;
event2_pvalue.excitation = firing_pvalue.event2_pvalue_excitation;
event2_pvalue.inhibition = firing_pvalue.event2_pvalue_inhibition;

discrimfilespec=[triggerevent1 '_' trialselection1 '_&_' triggerevent2 '_' trialselection2];
disp(['will save results as ' savedir 'event_discrim_' discrimfilespec '.mat'])
disp('a prerequisite for a discriminating unit is that it must be significantly modulated by at least one of the events.')

disp(['using the pre-specified time bin size of ' num2str(timebinsize) ' s.'])

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

if onlysigmod=='y' %finds significantly modulated (by event 1) units.    Note: need to run get_response_pvalue
get_sigfiring_units 
end

if query_start == 0
bltimebins=baseline_start:timebinsize:(baseline_end-timebinsize);
else bltimebins = baseline_start:timebinsize:baseline_end;
end
querytimebins=query_start:timebinsize:(query_end+timebinsize);

timebins=[bltimebins querytimebins];
plottimebins=timebins;
% plottimebins(end)=[];
baselinelength=length(bltimebins);   %number of bins occupied by the pre-event period, which is defined here as the baseline.

event1_spikerate=cell(size(dounits)); event2_spikerate=cell(size(dounits)); discriminating_bins = cell(size(dounits)); observed_difference = cell(size(dounits));
upperbound = cell(size(dounits)); lowerbound = cell(size(dounits));
for unitind=1:length(dounits)
   unitj=dounits(unitind);
   stimesj=spiketimes{unitj};
       
        ratetrialk = zeros(length(doevent1trials),length(timebins));
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);
            t0=event1times(trialk);
            
            queryspikeinds=find(stimesj<=(t0+(query_end+timebinsize)) & stimesj>(t0-query_start));
            rel_spiketimes=stimesj(queryspikeinds)-t0;         
            queryratek=histc(rel_spiketimes, querytimebins)/timebinsize;
            
            baseline_spikeinds=find(stimesj<=(t0+baseline_end) & stimesj>(t0+baseline_start));
            rel_bltimes=stimesj(baseline_spikeinds)-t0;             
            blratek=histc(rel_bltimes, bltimebins)/timebinsize;            
            ratetrialk(trialind,:) = [blratek queryratek];   %string together rates from baseline and query periods.
        end 
        event1_spikerate{unitj} = ratetrialk;
        event1_spikerate{unitj}(:,end) = [];
         
        ratetrialk = zeros(length(doevent2trials),length(timebins));
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            t0=event2times(trialk);
            
            eventtimek=t0;
            lick_to_cue_alignment  %only applies if event2 is startlicking.
            t0=eventtimek;

            queryspikeinds=find(stimesj<=(t0+(query_end+timebinsize)) & stimesj>(t0-query_start));
            rel_spiketimes=stimesj(queryspikeinds)-t0;
            queryratek=histc(rel_spiketimes, querytimebins)/timebinsize;
            
            baseline_spikeinds=find(stimesj<=(t0+baseline_end) & stimesj>(t0+baseline_start));
            rel_bltimes=stimesj(baseline_spikeinds)-t0;     
            blratek=histc(rel_bltimes, bltimebins)/timebinsize;            
            ratetrialk(trialind,:) = [blratek queryratek];

        end
        event2_spikerate{unitj} = ratetrialk;
        event2_spikerate{unitj}(:,end)=[];

        var1_base = event1_spikerate{unitj}(:,1:baselinelength);
        var1_post = event1_spikerate{unitj}(:,baselinelength:end);
        var2_base = event2_spikerate{unitj}(:,1:baselinelength);
        var2_post = event2_spikerate{unitj}(:,baselinelength:end);
      
        [discriminating_bins{unitj},observed_difference{unitj},upperbound{unitj},lowerbound{unitj}] = difference_permutation(var1_base,var2_base,var1_post,var2_post,timebinsize,permute_iterations,max_pvalue);
        
            if do_quickplots=='y'
            hold off
            plot(plottimebins, [mean(event1_spikerate{unitj}(:,1:baselinelength)) - mean(event2_spikerate{unitj}(:,1:baselinelength)) observed_difference{unitj}],'r')
            hold on
            plot(plottimebins, upperbound{unitj}*ones(size(plottimebins)),'--k')
            plot(plottimebins, lowerbound{unitj}*ones(size(plottimebins)),'--k')
            xlabel('time (s)')
            ylabel('event1-event2 rate (Hz)')
            title(['unit ' num2str(unitj)])
            plot(querybins(discriminating_bins{unitj}==1),observed_difference{unitj}(discriminating_bins{unitj}==1),'*m')
            plot(querybins(discriminating_bins{unitj}==-1),observed_difference{unitj}(discriminating_bins{unitj}==-1),'*g')
            input('press any key to continue')
            end
            
            if do_differenceplots == 'y'
            plot_differenceplots
            end
            
            close all       
end

[delta,unit_firstdiscrimination,unit_maxdiscrimination,significant_cell] = discrim_cells(discriminating_bins,observed_difference,querytimebins,dounits,max_pvalue);
preferred_event = cell2mat(unit_maxdiscrimination);

event1_preferring = zeros(1,dounits(end));
event2_preferring = zeros(1,dounits(end));
for unitind = 1:length(dounits)
    unitj = dounits(unitind);
    if isempty(unit_maxdiscrimination{unitj})==0 & unit_maxdiscrimination{unitj} == 1
       event1_preferring(unitj) = unitj;
    elseif isempty(unit_maxdiscrimination{unitj}) == 0 & unit_maxdiscrimination{unitj} == -1
       event2_preferring(unitj) = unitj;
    end
end
event1_preferring(event1_preferring == 0) = [];
event2_preferring(event2_preferring == 0) = [];
discriminating_units = sort([event1_preferring event2_preferring]);

disp(['Found ' num2str(length(discriminating_units)) ' out of ' num2str(length(dounits)) ' total task-responsive units that significantly discriminate between ' triggerevent1 ' and ' triggerevent2 '.'])

disp([num2str(length(find(preferred_event==1))) ' cells prefer ' triggerevent1 ', ' trialselection1 ' and ' num2str(length(find(preferred_event==-1))) ' cells prefer ' triggerevent2 ', ' trialselection2 '.'])
disp([triggerevent1 ' preferring cells: ' num2str(event1_preferring)])
disp([triggerevent2 ' preferring cells: ' num2str(event2_preferring)])

event_discrim=[];
event_discrim.triggerevent1=triggerevent1;
event_discrim.triggerevent2=triggerevent2;
event_discrim.trialselection1=trialselection1;
event_discrim.trialselection2=trialselection2;
event_discrim.querystart=query_start;
event_discrim.queryend=query_end;
event_discrim.onlysigmod=onlysigmod;
event_discrim.max_pvalue=max_pvalue;
event_discrim.permute_iterations=permute_iterations;
event_discrim.observed_difference=observed_difference;
event_discrim.discriminating_bins=discriminating_bins;
event_discrim.upperbound=upperbound;
event_discrim.lowerbound=lowerbound;
event_discrim.discriminating_units=discriminating_units;
event_discrim.event1_preferring=event1_preferring;
event_discrim.event2_preferring=event2_preferring;

save([savedir 'event_discrim_' discrimfilespec '.mat'], 'event_discrim', '-mat')