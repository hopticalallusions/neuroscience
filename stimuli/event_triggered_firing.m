disp(['Finding event-triggered firing signals.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1..4, 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', 'start', 'stop', 'room1..4 entries'
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

subselect1='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1.  '[a b c]' will use the designated trials.          
subselect2='all';           %optional subselection of trials.  'all' will use all trials from trialselection 2.  '[a b c]' will use the designated trials.          
                                                       
laserfreqselect='none';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='all';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

timebinsize=0.05;           %default=0.05 s. bin size for psth and average lick rate & cue-evoked response. 
preeventtime=1;             %time in sec to plot before event onset (must be 0 or positive).
posteventtime=8;            %time in sec to plot after event onset.

baseline_start=-5;          %default=-5. start time of baseline period relative to event onset.
baseline_end=0;             %default=0. end time of baseline period relative to event onset.

onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1 or 2). Note: need to have run get_response_pvalue
query_start=0;             %default=0. start time of rate query period relative to event onset. used if onlysigmod='y'. used in get_sigfiring_units.
query_end=8;               %default=. end time of rate query period relative to event onset. used if onlysigmod='y'. used in get_sigfiring_units.
max_pvalue=0.05;           %default=0.05. threshold for accepting event-triggered firing rate changes as significant. used in get_sigfiring_units.
use_sig_event='either';      %if '1' will determine firing significance from event1; if '2' will use event 2.  If 'either' will require significance on either event 1 or 2.  Used in get_sigfiring_units.

stackordermethod='event1';   %used in plot_unitstack. %'DV' plots units along DV axis; 'ML' plots along ML axis, 'event1' plots units in order of latency to event1; 'event2' plots units in order of latency to event2
zscorediv=20;                %used in plot_unitstack. sets scale on y axis of population average z-score plot.
zbinsize=0.1;           %default=0.5 mm. bin size in mm for averaging responses of units within each bin along depth of probe. used in plot_unitstack.
spontangap=15;          %default=15 s. minimum time a start and end of a lick episode can be from a cue to be considered spontaneous.
xdiv1=0.2; %default=0.4. units in seconds. used only in plotting.
xdiv2=1;  %units in seconds. used only in plot_unitstack
ydiv=0.1;  %default=0.2. units in mm.
lickbinsize=0.1;
%************************************************
smoothingwindow='y';       %default='y'. used in event_trigrates.
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  
domultisubject='n';

dorasters=[];
dorasters=input('do you want to make new raster plots and overwrite any old ones (y/n)? [n]: ', 's');
if isempty(dorasters)
    dorasters='n';
end  

close all
load_results

mkdir(stimephysdir); mkdir(stimephysjpgdir); mkdir(stimephysepsdir); mkdir(stimephysmfigdir);

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

timebins=-preeventtime:timebinsize:posteventtime;
licktimebins=-preeventtime:lickbinsize:posteventtime;
runtimebins=licktimebins;

if length(strmatch(plotunitclass,'all'))==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(plotunitclass));
    dounits=dounits(unitclassinds);
    plotlabel=['Only using putative ' unitclassnames{dounits(1)} ' units'];
    disp(plotlabel)
else
    plotlabel=['Using all unit classes (or unclassified)'];
    disp(plotlabel)
end


figind=1;
scrsz=get(0,'ScreenSize');

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

if length(licktimes)>0
get_lickproperties
end

trigged_running     %finds event-triggered running & acceleration.

plot_behavior
 
if exist('spiketimes','var')~=0
    
trigged_spiketimes   %event-triggered spike times. 

plot_unitstack      %plots stack of normalized event-triggered unit firing responses for selected trials.


if dorasters=='y' 
    mkdir(rasterjpgdir); mkdir(rasterepsdir); mkdir(rastermfigdir)
    delete([rasterjpgdir '*.*']);  delete([rasterepsdir '*.*']); delete([rastermfigdir '*.*']); 
    trigged_rasterplots 
else disp('not making raster plots')
end

end