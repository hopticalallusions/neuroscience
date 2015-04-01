%***Combine unit stacks from mulitiple animals***

triggerevent1='CS1';  %options: 'CS1..4', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', 'start', 'stop', 'room1..4 entries'
triggerevent2='CS2';   %options: 'CS1..4', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', start', 'stop', 'room1..4 entries', 'none'.    

trialselection1='correct licking';     %select which event1 trials to display. 
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
                                                                                                                
trialselection2='correct withholding';     %select which event2 trials to display. same options as trialselection1.

subselect1='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1 (default).  '[a b c]' will use the designated trials.          
subselect2='all';           %optional subselection of trials.  'all' will use all trials from trialselection 2 (default).  '[a b c]' will use the designated trials.          
                                                       
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='1';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

timebinsize=0.05;           %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.
preeventtime=1;             %time in sec to plot before event onset.
posteventtime=8;            %time in sec to plot after event onset.

baseline_start=-5;          %default=-5. start time of baseline period relative to event onset.
baseline_end=0;             %default=0. end time of baseline period relative to event onset.

plotlist=[]; %xcorr_stats.connectedcells;    %default=[]; If specify list of cells grouped by subject, then will only plot those cells and will override the onlysigmod setting. e.g., xcorr_stats.connectedcells.

onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1).
query_start=0;             %start time of rate query period relative to event onset. used if onlysigmod='y'. used in find_sigfiring.
query_end=8;               %end time of rate query period relative to event onset. used if onlysigmod='y'. used in find_sigfiring.
max_pvalue=0.01;           %default=0.05. threshold for accepting event-triggered firing rate changes as significant. used in find_sigfiring.
use_sig_event='either';      %if '1' will determine firing significance from event1; if '2' will use event 2.  If 'either' will require significance on either event 1 or 2.  Used in get_sigfiring_units.

stackordermethod='event1';   %used in plot_unitstack. %'DV' plots units along DV axis; 'ML' plots along ML axis, 'event1' plots units in order of latency to event1; 'event2' plots units in order of latency to event2

spontangap=15;          %default=15 s. minimum time a start and end of a lick episode can be from a cue to be considered spontaneous.
lickbinsize=0.1;

latencybinsize=0.2;         %used in latency analysis.
durationbinsize=0.2;         %used in firing duration analysis.
ratebinsize=0.1;
fluctbinsize=0.05;
max_plotdeltarate=20;
max_plotbaseline=50;
max_plotfluct=2;

plotDVzones=4;           %number of subdivisions for plotting stacks along DVaxes.  Note: subdivides according to the min and max of the ML and DV unit positions, not by any arbitrarily defined anatomical subregion.
plotMLzones=3;           %number of subdivisions for plotting stacks along ML axes.  Note: subdivides according to the min and max of the ML and DV unit positions, not by any arbitrarily defined anatomical subregion.

minML=0.58;              %used in plot_subregions. if leave empty ([]) will pick a range based on the currently selected subjects.
maxML=2.28; 
minDV=-5.67; 
maxDV=-2.495;

ydiv=20;
min_ploty=-2;
max_ploty=8;
max_plotsync=0.04;

trialgroupsize=10;         %used in select_triggers_trials

zscore_or_norm='zscore';  %specify whether to use 'zscore' or 'norm' (normalized) rates in plot_subregions.
%************************************************
xdiv2=1;  %units in seconds. used only in plot_unitstack
smoothingwindow='y';       %default='y'. used in event_trigrates.
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  

timebins=-preeventtime:timebinsize:posteventtime;
licktimebins=-preeventtime:lickbinsize:posteventtime;
runtimebins=licktimebins;

domultisubject='y';
backgroundchans1=['all'];            %default=['all']. can leave empty or write numeric list. The channels in the current set are not used in backgroundchans.  badchannels are removed from this list.
samplingrate=25000;
qualitycutoff=1;           %default=1. unit qualities: 1, 2, 3. 1=best, 2=medium quality, 3=not single-unit. used in select_douniters.

close_figures=[];
close_figures=input('Do you want to close the figures and plot on fresh graph (y/n) [y]: ', 's');
if isempty(close_figures)==1
    close_figures='y';
end
    
if close_figures=='y'
    close all
end

set_CS1color=[];
set_CS1color=input('Select a color for the CS1 stats plots [blac(k)]: ', 's');
    if isempty(set_CS1color)==1
        set_CS1color='k';
    end 

set_CS2color=[];
set_CS2color=input('Select a color for the CS2 stats plots [(r)ed]: ', 's');
    if isempty(set_CS2color)==1
        set_CS2color='r';
    end 
   
selectedpaths=uipickfiles('FilterSpec','C:\data analysis\');  %prompts to pick subjects.

get_subject_dir

analysisdrivename=subjects{1}(1);
combinedir = [analysisdrivename ':\data analysis\figures\'];
if isdir(combinedir) == 0
   mkdir(combinedir)
end

multisubject=[];    
    
multilickrate_event1=[]; multilickrate_event2=[]; multi_licklatency=[]; multirunspeed_event1=[]; multirunspeed_event2=[];
totalunits=0; totalmodunits=0; total_excited=0; total_inhibited=0; total_exc_and_inhib=0;
list_excit_e1=[]; list_excit_e2=[]; list_inhib_e1=[]; list_inhib_e1=[]; list_mod_e1=[]; list_mod_e2=[];

total_only_e1_excit=0; total_only_e2_excit=0; total_bothevents_excit=0; 
total_only_e1_inhib=0; total_only_e2_inhib=0; total_bothevents_inhib=0;
total_only_e1_mod=0; total_only_e2_mod=0; total_bothevents_mod=0;

cellstats=[];
for subjectind = 1:length(subjects)
    rawpath = [subjects{subjectind} ''];
    savedir = [rawpath 'single-unit\'];
    timesdir = [savedir 'sortedtimes\'];
    unitclassdir = [savedir 'properties\'];
    stimulidir = [rawpath '\stimuli\'];
    stimephysdir = [rawpath 'stim-ephys\'];
    syncdir=[savedir 'network synchrony\'];

    get_file_subject_name   
    
    load_results  
    
    sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.
       
    select_triggers_trials       %determines which event triggers and trials to use in plotting.  
      
    if length(strmatch(plotunitclass,'all'))==0 
    unitclassinds=find(unitclassnumbers==str2num(plotunitclass));
    dounits=dounits(unitclassinds);
    plotlabel=['putative ' unitclassnames{dounits(1)} 's'];
    classnumber=str2num(plotunitclass);  %used in plotting network sync.
    elseif length(strmatch(plotunitclass,'all'))>0 
    plotlabel=['all cell types'];
    classnumber=5;     %used in plotting network sync.
    end
       
    orig_dounits=dounits;
    totalunits=totalunits+length(orig_dounits);
        
    trigged_spiketimes
    
    annotate_brainregion

    multisubject.plotunits{subjectind} = dounits;
    multisubject.unit_count(subjectind) = numel(dounits);  %number of selected units per subject.
    multisubject.normrates_e1{subjectind} = normrate_event1;
    multisubject.zscores_e1{subjectind} = zscore_event1;
    multisubject.normrates_e2{subjectind} = normrate_event2;
    multisubject.zscores_e2{subjectind} = zscore_event2;
    multisubject.groupedz_e1{subjectind}=event1_groupzscore;  %zscore grouped by trials of trialgroupsize.
    multisubject.groupedz_e2{subjectind}=event2_groupzscore;
    multisubject.DVpositions{subjectind} = unitz;
    multisubject.MLpositions{subjectind} = unitx;
    multisubject.unitregions{subjectind} = suggest_brainregion;
    multisubject.unitshafts{subjectind} = unitproperties.shaft;
    multisubject.unitmaxlatencies_e1{subjectind} = event1_peaklatency;
    multisubject.unitmaxlatencies_e2{subjectind} = event2_peaklatency;
    multisubject.unitminlatencies_e1{subjectind} = event1_minlatency;
    multisubject.unitminlatencies_e2{subjectind} = event2_minlatency;   
    
    multisubject.baselinerate{subjectind}=baselinerate;
    multisubject.sdbaseline{subjectind}=stdbaselinerate;
    multisubject.event1spikerate{subjectind}=event1_spikerate;
    multisubject.event2spikerate{subjectind}=event2_spikerate;
    multisubject.nrmse_event1{subjectind}=nrmse_event1;  %normalized root mean square error (NRMSE); measures how similar firing rate is over all selected trials. calculated in event_trigrates.
 
    totalmodunits=totalmodunits+length(dounits);  %total number of excited OR inhibited units, or if onlysigmod=='n' it's just the total number of plotted units.

    if onlysigmod=='y'
    multisubject.sigbins_e1{subjectind}=event1_sigbins;
    multisubject.sigbins_e2{subjectind}=event2_sigbins;
    
    total_excited=total_excited+number_only_excited;     %total number of units that are only excited.
    total_inhibited=total_inhibited+number_only_inhibited;  %total number of units that are only inhibited.
    total_exc_and_inhib=total_exc_and_inhib+number_both_excite_inhib; %total number of units that are both excited AND inhibited.
    
    total_only_e1_excit=total_only_e1_excit+length(only_e1_excit);
    total_only_e2_excit=total_only_e2_excit+length(only_e2_excit);    
    total_bothevents_excit=total_bothevents_excit+length(bothevents_excit);
    
    total_only_e1_inhib=total_only_e1_inhib+length(only_e1_inhib);
    total_only_e2_inhib=total_only_e2_inhib+length(only_e2_inhib); 
    total_bothevents_inhib=total_bothevents_inhib+length(bothevents_inhib);
    
    total_only_e1_mod=total_only_e1_mod+length(only_e1_mod); 
    total_only_e2_mod=total_only_e2_mod+length(only_e2_mod); 
    total_bothevents_mod=total_bothevents_mod+length(bothevents_mod); 
    
    list_excit_e1{subjectind}=sig_excit_units_e1; %list of units that are significantly excited by event 1.
    list_excit_e2{subjectind}=sig_excit_units_e2; %list of units that are significantly excited by event 2.
    list_inhib_e1{subjectind}=sig_inhib_units_e1; %list of units that are significantly excited by event 1.
    list_inhib_e2{subjectind}=sig_inhib_units_e2; %list of units that are significantly excited by event 2.
    list_mod_e1{subjectind}=unique([sig_excit_units_e1 sig_inhib_units_e1]);
    list_mod_e2{subjectind}=unique([sig_excit_units_e2 sig_inhib_units_e2]);

    cellstats.subjects{subjectind}=subject;
    cellstats.modunits{subjectind}=dounits;   %list of the significantly modulated units;
    cellstats.fractionmod(subjectind)=length(dounits)/length(orig_dounits);
    cellstats.fraction_only_e1_mod(subjectind)=length(only_e1_mod)/length(orig_dounits);
    cellstats.fraction_only_e2_mod(subjectind)=length(only_e2_mod)/length(orig_dounits);
    cellstats.fraction_bothevents_mod(subjectind)=length(bothevents_mod)/length(orig_dounits);
    
    cellstats.fraction_only_e1_excit(subjectind)=length(only_e1_excit)/length(orig_dounits);
    cellstats.fraction_only_e2_excit(subjectind)=length(only_e2_excit)/length(orig_dounits);
    cellstats.fraction_bothevents_excit(subjectind)=length(bothevents_excit)/length(orig_dounits);
        
    cellstats.fraction_e1_mod(subjectind)=length(list_mod_e1{subjectind})/length(orig_dounits);
    cellstats.fraction_e2_mod(subjectind)=length(list_mod_e2{subjectind})/length(orig_dounits);
 
    cellstats.fraction_e1_excit(subjectind)=length(sig_excit_units_e1)/length(orig_dounits);
    cellstats.fraction_e2_excit(subjectind)=length(sig_excit_units_e2)/length(orig_dounits);    

    end
            
    if length(licktimes)>0
    get_lickproperties
    end
    
    multilickrate_event1=[multilickrate_event1; event1_lickrate'];
    multilickrate_event2=[multilickrate_event2; event2_lickrate'];
    groupedlickrate_e1{subjectind}=event1_grouplickrate;   %lick rate grouped by trialgroupsize
    groupedlickrate_e2{subjectind}=event2_grouplickrate;
    multi_licklatency{subjectind}=event1_licklatency;  %latency to first lick for each selected event 1 trial.

    trigged_running
    
    multirunspeed_event1=[multirunspeed_event1; meanevent1_vy];
    multirunspeed_event2=[multirunspeed_event2; meanevent2_vy];
    
    
    load([syncdir 'sync.mat'])
    
    slidingwindow_halfwidth=sync.slidingwindow_halfwidth;
    synctimebins=sync.timebincenters; 
    slidingwindow_stepsize=sync.slidingwindow_stepsize;
    summedtimes=sync.summedtimes{classnumber};

    trigged_summedtimes
    
    multisubject.event1_syncrate{subjectind}=event1_syncrate;
    multisubject.event1_syncsem{subjectind}=event1_syncsem;
    multisubject.event2_syncrate{subjectind}=event2_syncrate;
    multisubject.event2_syncsem{subjectind}=event2_syncsem;
    
end

if onlysigmod=='y';            %if 'y' uses only significantly modulated units (triggered on event 1).
disp(['***SUMMARY: Across ' num2str(length(subjects)) ' subjects, ' num2str(totalmodunits) '/' num2str(totalunits) ' (' num2str(totalmodunits/totalunits*100) '%) units (' plotlabel ') are modulated by event ' use_sig_event '***'])

cellstats.celltype=unitclassnames{dounits(1)};
cellstats.use_sig_event=use_sig_event;     
cellstats.max_pvalue=max_pvalue;
cellstats.triggerevent1=triggerevent1;
cellstats.triggerevent2=triggerevent2;
cellstats.trialselection1=trialselection1;
cellstats.trialselection2=trialselection2;

cellstats.totalmod=totalmodunits;           %total number of cells that are either excited OR inhibited by use_sig_event
cellstats.total_onlyexcited=total_excited;  %total number of cells that are only excited by use_sig_event
cellstats.total_onlyinhibited=total_inhibited; %total number of cells that are only inhibited by use_sig_event
cellstats.total_exc_and_inhib=total_exc_and_inhib; %total number cells that are both excited and inhibited by use_sig_event
cellstats.numberofcells=totalunits;
% cellstats.fractionmod=totalmodunits/totalunits;  %fraction of cells that are either excited or inhibted by use_sig_event.
% cellstats.fraction_only_e1_excit=total_only_e1_excit/totalunits;   %fraction of cells that are only excited by event 1.
% cellstats.fraction_only_e2_excit=total_only_e2_excit/totalunits;   %fraction of cells that are only excited by event 2.
% cellstats.fraction_bothevents_excit=total_bothevents_excit/totalunits;  %fraction of cells that are excited by both event 1 and event 2.
% cellstats.fraction_only_e1_inhib=total_only_e1_inhib/totalunits;  %fraction of cells that are only inhibited by event 1.
% cellstats.fraction_only_e2_inhib=total_only_e2_inhib/totalunits;  %fraction of cells that are only inhibited by event 2.
% cellstats.fraction_bothevents_inhib=total_bothevents_inhib/totalunits;  %fraction of cells that are inhibuted by both event 1 and event 2.
% cellstats.fraction_only_e1_mod=total_only_e1_mod/totalunits;  %fraction of cells that are modulated (either excit or inhib) by event 1.
% cellstats.fraction_only_e2_mod=total_only_e2_mod/totalunits;  %fraction of cells that are modulated (either excit or inhib) by event 2.
% cellstats.fraction_bothevents_mod=total_bothevents_mod/totalunits;  %fraction of cells that are modulated (either excit or inhib) by both event 1 and event 2.

end

multistack_event1=[]; multistack_event2=[]; multi_zstack_e1=[]; multi_zstack_e2=[];
event1_peaklatency=[]; event2_peaklatency=[]; event1_minlatency=[]; event2_minlatency=[]; plot_latency_e1=[]; plot_latency_e2=[]; unit_DV=[]; unit_ML=[];
sigbinstack_event1=[]; sigbinstack_event2=[];
sigexcited_e1=[]; siginhibited_e1=[]; sigexcited_e2=[]; siginhibited_e2=[];
deltarate_excit_e1=[]; deltarate_inhib_e1=[]; deltarate_excit_e2=[]; deltarate_inhib_e2=[];   %fractional rate change
baseline=[]; baselinefluct=[]; nrmse_e1=[]; %fractional rate baselinefluct (SD/mean)
licklatencySD=[];   %standard deviation of first lick latency, grouped by subjects. 
mapunits_ML=[]; mapunits_DV=[];
for subjectind = 1:length(subjects);   %all units. added Jan 2 2014 by SCM.
    
    if length(licktimes)>0
    licklatencySD(subjectind)=std(multi_licklatency{subjectind});   %SD of latency to first lick on correct CS+ trials, by subject. provides measure of behavioral variability.
    end
    
      %1. groups the following parameters by subject.
%     baseline(subjectind)=mean(cell2mat(multisubject.baselinerate{subjectind}));
%     baselinefluct(subjectind)=sqrt(mean(cell2mat(multisubject.sdbaseline{subjectind}).^2));
%     nrmse_e1(subjectind)=sqrt(mean(cell2mat(multisubject.nrmse_event1{subjectind}).^2));

      %*********
         
    for unitind = 1:length(multisubject.plotunits{subjectind})   %NOTE: this will select only the plotunits, which are determine by onlysigmod and use_sig_event
        unitj = multisubject.plotunits{subjectind}(unitind);
                    
        multistack_event1=[multistack_event1; multisubject.normrates_e1{subjectind}{unitj}'];  %normalized stacks.
        multistack_event2=[multistack_event2; multisubject.normrates_e2{subjectind}{unitj}'];

        multi_zstack_e1=[multi_zstack_e1; smooth(multisubject.zscores_e1{subjectind}{unitj},3)'];       %smoothed z-score stacks.
        multi_zstack_e2=[multi_zstack_e2; smooth(multisubject.zscores_e2{subjectind}{unitj},3)']; 
     
        unit_DV=[unit_DV multisubject.DVpositions{subjectind}{unitj}];
        unit_ML=[unit_ML multisubject.MLpositions{subjectind}{unitj}];
        
        %1. groups the following parameters by individual cell.

        baseline=[baseline multisubject.baselinerate{subjectind}{unitj}];  
        baselinefluct=[baselinefluct multisubject.sdbaseline{subjectind}{unitj}/multisubject.baselinerate{subjectind}{unitj}];
        nrmse_e1=[nrmse_e1 multisubject.nrmse_event1{subjectind}{unitj}];  
        
        %*********
        
        plot_latency_e1=[plot_latency_e1, multisubject.unitmaxlatencies_e1{subjectind}{unitj}'];  %used for stack plots only. latency to maximum firing.
        plot_latency_e2=[plot_latency_e2, multisubject.unitmaxlatencies_e1{subjectind}{unitj}'];  %used for stack plots only. latency to maximum firing.
           
        if onlysigmod=='y'
        sigbinstack_event1=[sigbinstack_event1; multisubject.sigbins_e1{subjectind}{unitj}];
        sigbinstack_event2=[sigbinstack_event2; multisubject.sigbins_e2{subjectind}{unitj}];
        
        allbins_e1=multisubject.sigbins_e1{subjectind}{unitj};
        sigexcited_e1=[sigexcited_e1 length(find(allbins_e1==1))*timebinsize];
        siginhibited_e1=[siginhibited_e1 length(find(allbins_e1==-1))*timebinsize];
        
        allbins_e2=multisubject.sigbins_e2{subjectind}{unitj};
        sigexcited_e2=[sigexcited_e2 length(find(allbins_e2==1))*timebinsize];
        siginhibited_e2=[siginhibited_e2 length(find(allbins_e2==-1))*timebinsize];
        
                if length(find(list_excit_e1{subjectind}==unitj))==1 %this ensures that we only count units that have significant positive or negative modulation to event 1 or 2.
                orderedrates=sort(multisubject.event1spikerate{subjectind}{unitj},'descend');
                meanpeakrate=mean(orderedrates(1:3));   %defines the peak rate as the mean of the highest 3 rate bins.                  
                deltarate_excit_e1=[deltarate_excit_e1 (meanpeakrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];  %fractional rate change.
                event1_peaklatency=[event1_peaklatency, multisubject.unitmaxlatencies_e1{subjectind}{unitj}'];  %latency to maximum firing.
                mapunits_ML=[mapunits_ML multisubject.MLpositions{subjectind}{unitj}];
                mapunits_DV=[mapunits_DV multisubject.DVpositions{subjectind}{unitj}];
                end
                          
                if length(find(list_inhib_e1{subjectind}==unitj))==1 
                orderedrates=sort(multisubject.event1spikerate{subjectind}{unitj},'ascend');
                meanminrate=mean(orderedrates(1:3));   %defines the min rate as the mean of the lowest 3 rate bins.
                deltarate_inhib_e1=[deltarate_inhib_e1 (meanminrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];
                event1_minlatency=[event1_minlatency, multisubject.unitminlatencies_e1{subjectind}{unitj}'];   %latency to minimum firing.
                end
                
                if length(find(list_excit_e2{subjectind}==unitj))==1  
                orderedrates=sort(multisubject.event2spikerate{subjectind}{unitj},'descend');
                meanpeakrate=mean(orderedrates(1:3));   %defines the peak rate as the mean of the highest 3 rate bins.                  
                deltarate_excit_e2=[deltarate_excit_e2 (meanpeakrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];  %fractional rate change.
                event2_peaklatency=[event2_peaklatency, multisubject.unitmaxlatencies_e2{subjectind}{unitj}'];
                end
                
                if length(find(list_inhib_e2{subjectind}==unitj))==1 
                orderedrates=sort(multisubject.event2spikerate{subjectind}{unitj},'ascend');
                meanminrate=mean(orderedrates(1:3));   %defines the min rate as the mean of the lowest 3 rate bins.
                deltarate_inhib_e2=[deltarate_inhib_e2 (meanminrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];
                event2_minlatency=[event2_minlatency,  multisubject.unitminlatencies_e2{subjectind}{unitj}'];           
                end
        
        elseif onlysigmod=='n'
                            
                orderedrates=sort(multisubject.event1spikerate{subjectind}{unitj},'descend');
                meanpeakrate=mean(orderedrates(1:3));   %defines the peak rate as the mean of the highest 3 rate bins.                  
                deltarate_excit_e1=[deltarate_excit_e1 (meanpeakrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];  %fractional rate change.
                event1_peaklatency=[event1_peaklatency, multisubject.unitmaxlatencies_e1{subjectind}{unitj}'];  %latency to maximum firing.
                
                mapunits_ML=[mapunits_ML multisubject.MLpositions{subjectind}{unitj}];
                mapunits_DV=[mapunits_DV multisubject.DVpositions{subjectind}{unitj}];
               
                orderedrates=sort(multisubject.event1spikerate{subjectind}{unitj},'ascend');
                meanminrate=mean(orderedrates(1:3));   %defines the min rate as the mean of the lowest 3 rate bins.
                deltarate_inhib_e1=[deltarate_inhib_e1 (meanminrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];
                event1_minlatency=[event1_minlatency, multisubject.unitminlatencies_e1{subjectind}{unitj}'];   %latency to minimum firing.
  
                orderedrates=sort(multisubject.event2spikerate{subjectind}{unitj},'descend');
                meanpeakrate=mean(orderedrates(1:3));   %defines the peak rate as the mean of the highest 3 rate bins.                  
                deltarate_excit_e2=[deltarate_excit_e2 (meanpeakrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];  %fractional rate change.
                event2_peaklatency=[event2_peaklatency, multisubject.unitmaxlatencies_e2{subjectind}{unitj}'];
                
                orderedrates=sort(multisubject.event2spikerate{subjectind}{unitj},'ascend');
                meanminrate=mean(orderedrates(1:3));   %defines the min rate as the mean of the lowest 3 rate bins.
                deltarate_inhib_e2=[deltarate_inhib_e2 (meanminrate-multisubject.baselinerate{subjectind}{unitj})]; %/multisubject.baselinerate{subjectind}{unitj}];
                event2_minlatency=[event2_minlatency,  multisubject.unitminlatencies_e2{subjectind}{unitj}'];                
        end       
    end  
    
end

plot_multistack

plot_subregions   %plots by M-L, D-V and in 2D space.

plot_latency_map  

plot_firing_stats  %plots statistics of latencies, duration of significance, fractional rate change, baseline rate, and SD/mean.
    
cellstats           
           


if length(licktimes)>0

groupedlicking_e1=[];
for subjectind = 1:length(subjects);   %all units. added Jan 2 2014 by SCM.
    
    grouplicking_subj=groupedlickrate_e1{subjectind};
    numberofgroups_subj=length(grouplicking_subj);
    
    for groupind=1:numberofgroups_subj
    
    if length(groupedlicking_e1)>=groupind
    subjectcounter=size(groupedlicking_e1{groupind},1); 
    groupedlicking_e1{groupind}(subjectcounter+1,:)=smooth(grouplicking_subj{groupind},3); 
    else
    groupedlicking_e1{groupind}(subjectind,:)=grouplicking_subj{groupind}; 
    end
    end
    
end

meangroupedlicking_e1=[];
for groupind=1:length(groupedlicking_e1)
    if size(groupedlicking_e1{groupind},1)>1
    meangroupedlicking_e1(groupind,:)=mean(groupedlicking_e1{groupind});
    else  meangroupedlicking_e1(groupind,:)=groupedlicking_e1{groupind};
     end
end

figure(200)
waterfall(meangroupedlicking_e1)
title(['grouped lick rate'], 'FontSize', 8)
end


% map_units_multisubject
           
% make_a_movie           

          