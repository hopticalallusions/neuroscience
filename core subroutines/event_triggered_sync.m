disp(['Finding event-triggered synchronous firing signals.'])

set_plot_parameters

plotunitclass='1';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

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
                                                       
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

timebinsize=0.05;         %default=0.05;
preeventtime=2;               %time in sec to use before event onset.
posteventtime=8;              %time in sec to use after event onset.

smoothingwindow='n';       %default='n'. used in event_trigrates.
spontangap=15;          %default=15 s. minimum time a start and end of a lick episode can be from a cue to be considered spontaneous.

lickbinsize=0.1;
%************************************************
onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1). used in trigged_spiketimes.
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  
baseline_start=-5;          %default=-5. start time of baseline period relative to event onset.
baseline_end=0;             %default=0. end time of baseline period relative to event onset.

dorasters=[];
dorasters=input('do you want to make new raster plots and overwrite any old ones (y/n)? [n]: ', 's');
if isempty(dorasters)
    dorasters='n';
end  

close all
load_results

mkdir(stimephysdir); 

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

load([syncdir 'sync.mat'])
slidingwindow_halfwidth=sync.slidingwindow_halfwidth;
synctimebins=sync.timebincenters; 
slidingwindow_stepsize=sync.slidingwindow_stepsize;
disp(['time window halfwidth used in get_network_sync was ' num2str(slidingwindow_halfwidth) ' s.'])

timebins=-preeventtime:timebinsize:posteventtime;
grouptimebins=-preeventtime:grouptimebinsize:posteventtime;
licktimebins=-preeventtime:lickbinsize:posteventtime;
runtimebins=licktimebins;

if strcmp(plotunitclass, 'all')
    classnumber=5;     %class number of 5 means use all units (defined in get_network_sync)
    plotlabel=['Using all unit classes (or unclassified) for the sync times.'];
    cellname='all';
else classnumber=str2num(plotunitclass);
    unitclassinds=find(unitclassnumbers==str2num(plotunitclass));
    dounits=dounits(unitclassinds);
    cellname=unitclassnames{dounits(1)};
    plotlabel=['Only using putative ' unitclassnames{dounits(1)} ' units for the sync times.'];
end
disp(plotlabel)

syncthresh=sync.randomsyncfiring{classnumber};
summedtimes=sync.summedtimes{classnumber};

figind=1;
scrsz=get(0,'ScreenSize');

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

if length(licktimes)>0
get_lickproperties
end

trigged_running     %finds event-triggered running & acceleration.
      
plot_behavior

trigged_spiketimes

trigged_summedtimes

event1_firingstack=[]; event2_firingstack=[];   %compare sync method with averaging of normalized firing rates
for unitind=1:length(dounits)
    unitj=dounits(unitind);
    event1_firingstack=[event1_firingstack; zscore_event1{unitj}];
    if length(doevent2trials)>0 
    event2_firingstack=[event2_firingstack; zscore_event2{unitj}];
    end
end
event1_firingrate=mean(event1_firingstack);
event1_firingsem=std(event1_firingstack)/sqrt(length(doevent1trials));
event2_firingrate=mean(event2_firingstack);
event2_firingsem=std(event2_firingstack)/sqrt(length(doevent2trials));


figind=1;
figure(figind)

subplot(2,1,1)
hold off
boundedline(timebins(1:(length(timebins)-1)),event1_syncrate, event1_syncsem, 'k')  %do not use 'alpha' (transparent shading) because this will mess up eps export.
if length(doevent2trials)>0 
hold on
boundedline(timebins(1:(length(timebins)-1)),event2_syncrate, event2_syncsem, 'r')  %do not use 'alpha' (transparent shading) because this will mess up eps export.
end
xlabel('time (s)','FontSize', 8)
ylabel(['fraction of syncd cells'],'FontSize', 8)
title([subject '; ' cellname ' cells; Mean+/-SEM event-triggered network synchrony; ' num2str(1000*timebinsize) ' ms time bins; (bk=' triggerevent1 ', r=' triggerevent2 ')'],'FontSize', 8)
set(gca,'FontSize', 8,'TickDir','out')

subplot(2,1,2)  %compare sync method with averaging of normalized firing rates
hold off
boundedline(timebins(1:(length(timebins)-1)),event1_firingrate, event1_firingsem, 'k')   %do not use 'alpha' (transparent shading) because this will mess up eps export.
if length(doevent2trials)>0 
hold on
boundedline(timebins(1:(length(timebins)-1)),event2_firingrate, event2_firingsem, 'r')   %do not use 'alpha' (transparent shading) because this will mess up eps export.
end
xlabel('time (s)','FontSize', 8)
ylabel(['firing rate'],'FontSize', 8)
title(['Mean population z-score (for comparison to sync method)'],'FontSize', 8)
set(gca,'FontSize', 8,'TickDir','out')

set(gcf,'Position',[-1.6*scrsz(1)+900 0.6*scrsz(2)+100 0.4*scrsz(3) 0.8*scrsz(4)])   


saveas(figure(figind),[stimephysjpgdir 'trigd_sync_spikes' '.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'trigd_sync_spikes' '.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'trigd_sync_spikes' '.fig' ]  ,'fig')
 
if dorasters=='y'
sync_rasterplot   %in progress.
end
