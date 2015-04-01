disp(['Finding event-triggered signals.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 
triggerevent2='CS2';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'none'.    
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  

trialselection1='rewarded';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials                                        
                            %'rewarded' only trials with a solenoid. triggerevent should be a CS.
                            %'unrewarded' only uses trials with no solenoid. triggerevent should be a CS.
                            %'expectedUS' only uses trials with expected reward presentation (i.e. preceded by predictive cue). triggerevent should be 'solenoid.
                            %'unexpectedUS' only uses trials with unexpected reward presentation (i.e. not preceded by cue). triggerevent should be 'solenoid.
                                %'onlylicks' only uses CS1 & CS2 trials where licking occurs after the CS (does not distinguish btwn correct/incorrect).
                                %'onlyright' only uses CS1 &  CS2 trials with Correct licking or withholding of licking based on presence of solenoid.
                                %'onlywrong' only uses CS1 & CS2 trials with Incorrect licking or withholding of licking based on presence of solenoid.
                            
trialselection2='unrewarded';     %select which event2 trials to display. same options as trialselection1.
                                                       
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='all';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

onlysigmod='y';            %if 'y' uses only significantly modulated units (triggered on event 1). used in trigged_spiketimes.
min_zscore=3;              %default=3. threshold for determine whether a unit is significantly modulated by event 1, and in one method of calculating unit response latencies.

smoothingwindow='y';       %default='y' for event_triggered. used in event_trigrates.

stackordermethod='event1';   %used in plot_unitstack. %'depth' plots units in order of depth; %'event1' plots units in order of latency to event1; 'event2' plots units in order of latency to event2
zscorediv=20;                %used in plot_unitstack. sets scale on y axis of population average z-score plot.

timebinsize=0.02;             %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.
preeventtime=2;               %time in sec to use before event onset.
posteventtime=8;              %time in sec to use after event onset.

lickbinsize=0.02;  
zbinsize=0.5;           %default=0.5 mm. bin size in mm for averaging responses of units within each bin along depth of probe. used in plot_unitstack.

xdiv1=0.4; %default=0.4. units in seconds. used only in plotting.
xdiv2=1;  %units in seconds. used only in plot_unitstack
ydiv=0.2;  %default=0.2. units in mm.
%************************************************

close all

load_results

mkdir(stimephysdir); mkdir(rasterjpgdir); mkdir(rasterepsdir); mkdir(rastermfigdir)

timebins=-preeventtime:timebinsize:posteventtime;
grouptimebins=-preeventtime:grouptimebinsize:posteventtime;
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

get_runproperties
      
trigged_spiketimes   %event-triggered spike times. Also generates some latency plots if event1 & event2 are CS1, CS2 respectively.

plot_behavior

plot_unitstack      %plots stack of normalized event-triggered unit firing responses for selected trials.

plot_triggedspectra   %plots event-triggered LFP spectra for selected trials & channel. contains additional plot settings inside subroutine script.

plot_triggedLFPpower  %plots event-triggered LFP power for selected trials & channel. contains additional plot settings inside subroutine script.


if length(dir([rasterjpgdir]))-2~=length(dounits) %raster plots
dorasters='y';
else
    dorasters=[];
    dorasters=input('raster plots already exist; plot new ones? [n] ', 's');
     if isempty(dorasters)
          dorasters='n';
     end  
end

if dorasters=='y' 
    trigged_rasterplots 
else disp('not remaking raster plots')
end


% cuetriggered_rate_depth
