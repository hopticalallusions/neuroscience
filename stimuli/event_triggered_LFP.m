disp(['Finding event-triggered LFP signals.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1..4', 'laser', 'startlicking', 'endlicking', 'solenoid', 'room1..4 entries', 'LFP', 'background' (available if not cue times are found).
triggerevent2='CS2';   %options: 'CS1..4', 'laser', 'startlicking', 'endlicking', 'solenoid', 'room1..4 entries', 'LFP', 'none'.    

trialselection1='correct licking';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
                            
trialselection2='correct withholding';     %select which event2 trials to display. same options as trialselection1.
                                                       
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

smoothingwindow='y';       %default='y' for event_triggered. used in event_trigrates.

timebinsize=0.02;             %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.
preeventtime=1;               %time in sec to use before event onset.
posteventtime=8;              %time in sec to use after event onset.

xdiv1=0.4; %default=0.4. units in seconds. used only in plotting.
ydiv=0.2;  %default=0.2. units in mm.
lickbinsize=0.1;
%************************************************
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  

close all

load_results

mkdir(stimephysdir); mkdir(stimephysjpgdir); mkdir(stimephysepsdir); mkdir(stimephysmfigdir);
 
grouptimebinsize=10;
timebins=-preeventtime:timebinsize:posteventtime;
licktimebins=-preeventtime:lickbinsize:posteventtime;
runtimebins=licktimebins;
grouptimebins=-preeventtime:grouptimebinsize:posteventtime;


figind=1;
scrsz=get(0,'ScreenSize');

if strcmp(triggerevent1,'background')==0
    
currentLFPpwrdir=uigetdir([LFPtriggedpowerdir],'Select a "frequency band in the LFP power folder" folder');
currentLFPpwrdir=[currentLFPpwrdir '\'];

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

if length(licktimes)>0
get_lickproperties
end

trigged_running

plot_behavior

end

plot_triggedspectra   %plots event-triggered LFP spectra for selected trials & channel. contains additional plot settings inside subroutine script.

plot_triggedLFPpower  %plots event-triggered LFP power for selected trials & channel. contains additional plot settings inside subroutine script.
