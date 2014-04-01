disp(['Finding event-triggered slow bursting (& pausing) signals.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', 'start', 'stop'
triggerevent2='startlicking';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', start', 'stop', 'none'.    

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
                                                                                    
trialselection2='spontaneous licking';     %select which event2 trials to display. same options as trialselection1.
                                                       
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='all';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

timebinsize=0.1;             %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.
preeventtime=2;               %time in sec to use before event onset.
posteventtime=8;              %time in sec to use after event onset.

onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1). Note: need to have run get_response_pvalue
max_pvalue=0.01;           %default=0.01. threshold for accepting event-triggered firing rate changes as significant.

smoothingwindow='y';       %default='y'. used in event_trigrates.
stackordermethod='event1';   %used in plot_unitstack. %'depth' plots units in order of depth; %'event1' plots units in order of latency to event1; 'event2' plots units in order of latency to event2
zscorediv=20;                %used in plot_unitstack. sets scale on y axis of population average z-score plot.
zbinsize=0.1;           %default=0.5 mm. bin size in mm for averaging responses of units within each bin along depth of probe. used in plot_unitstack.
spontangap=15;          %default=15 s. minimum time a start and end of a lick episode can be from a cue to be considered spontaneous.
xdiv1=0.2; %default=0.4. units in seconds. used only in plotting.
xdiv2=1;  %units in seconds. used only in plot_unitstack
ydiv=0.1;  %default=0.2. units in mm.
lickbinsize=0.1;
%************************************************

triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  

dorasters=[];
dorasters=input('do you want to make new burst raster plots and overwrite any old ones (y/n)? [n]: ', 's');
if isempty(dorasters)
    dorasters='n';
end  

close all
load_results

mkdir(stimephysdir); 

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

timebins=-preeventtime:timebinsize:posteventtime;
licktimebins=-preeventtime:lickbinsize:posteventtime;

if length(strmatch(plotunitclass,'all'))==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(plotunitclass));
    dounits=dounits(unitclassinds);
    plotlabel=['Only using putative ' unitclassnames{dounits(1)} ' units'];
else
    plotlabel=['Using all unit classes (or unclassified)'];
end
disp(plotlabel)

figind=1;
scrsz=get(0,'ScreenSize');

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

if length(licktimes)>0
get_lickproperties
end

trigged_running     %finds event-triggered running & acceleration.

trigged_spiketimes   

trigged_bursttimes

plot_burststack


if dorasters=='y' 
mkdir(burstrasterjpgdir); mkdir(burstrasterepsdir); mkdir(burstrastermfigdir)
delete([burstrasterjpgdir '*.*']);  delete([burstrasterepsdir '*.*']); delete([burstrastermfigdir '*.*']); 

trigged_burstrasterplots

else disp('not remaking burst raster plots')
end


