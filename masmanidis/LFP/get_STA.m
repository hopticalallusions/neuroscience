disp(['Getting spike triggered average.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'licking'.
triggerevent2='CS2';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'.     
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.

trialselection1='rewarded';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
                            
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.

preeventtime=0;              %time in sec to use for getting spikes before event onset.
posteventtime=8;             %time in sec to use for getting spikes after event onset.
                             
periSTAwidth=1;           %time around spike to collect LFP. units in seconds.

%***********************************************************

load_results

select_triggers_trials

currentSTAdir=[STAdir 'trials' num2str(min(doevent1trials)) '-' num2str(max(doevent1trials)) ' t' num2str(preeventtime) '-' num2str(posteventtime) 's\'];
STAdatadir=[currentSTAdir 'data\'];
mkdir(STAdatadir);
delete([STAdatadir '*.*'])

disp(['Collecting STA on ' num2str(length(dounits)) ' units and ' num2str(length(dochannels)) ' channels.'])
if length(doevent2trials)>0
    disp(['There are ' num2str(length(doevent1trials)) ' event 1 times and ' num2str(length(doevent2trials)) ' event 2 times.'])
else disp(['There are ' num2str(length(event1times)) ' event 1 times.'])
end

maxtime=round(max(event1times)*LFPsamplingrate);
numberofrandomspikes=1e5;
randomspiketimes=randi(maxtime,1,numberofrandomspikes);  %generates a random spike train to use as background STA.

randomSTA=[];
for unitind=1:length(dounits)
    unitj=dounits(unitind);
    stimesunitj=spiketimes{unitj}; %spike times expressed in LFP samples.
    disp(['unit ' num2str(unitj) ', ' num2str(length(stimesunitj)) ' total spikes.'])    

    perievent1spikes=[];
    for trialind=1:length(doevent1trials)
        trial=doevent1trials(trialind);
        eventtimei=event1times(trial);
        leftofevent=eventtimei-preeventtime;
        rightofevent=eventtimei+posteventtime;
        perieventspikesi=stimesunitj(find(stimesunitj<=rightofevent & stimesunitj>leftofevent));
        perievent1spikes=[perievent1spikes perieventspikesi];
    end
    disp(['  *found ' num2str(length(perievent1spikes)) ' peri-event 1 spikes.'])   
    perievent1spikes=round(unique(perievent1spikes)*LFPsamplingrate);
    
    if length(doevent2trials)>0
    perievent2spikes=[];
    for trialind=1:length(doevent2trials)
        trial=doevent2trials(trialind);
        eventtimei=event2times(trial);
        leftofevent=eventtimei-preeventtime;
        rightofevent=eventtimei+posteventtime;
        perieventspikesi=stimesunitj(find(stimesunitj<=rightofevent & stimesunitj>leftofevent));
        perievent2spikes=[perievent2spikes perieventspikesi];
    end
    disp(['  *found ' num2str(length(perievent2spikes)) ' peri-event 2 spikes.']) 
    perievent2spikes=round(unique(perievent2spikes)*LFPsamplingrate);
    end
   
    STA=[]; STA.event1=[]; STA.event2=[];
%     for chanind=1:length(dochannels)   %gets STA LFP signal from all channels on probe (this is slow).
%         chan=dochannels(chanind);  
        chan=bestchannels{unitj};   %only gets STA LFP signal from the best channel of current unit.
        currentvoltagefile=['LFPvoltage_ch' num2str(chan) '.mat'];
        load([LFPvoltagedir currentvoltagefile]);
        STAunitj=0;
        for timeind=1:length(perievent1spikes);    %event 1
            ti=perievent1spikes(timeind)-round(periSTAwidth*LFPsamplingrate);
            tf=perievent1spikes(timeind)+round(periSTAwidth*LFPsamplingrate);
            if ti<1 | tf>length(LFPvoltage)
                continue
            end
            STAunitj=[STAunitj+LFPvoltage(ti:tf)];   %unfiltered LFP.
        end
        STA.event1{chan}=STAunitj/length(perievent1spikes);
        
        if length(event2times)>0
        STAunitj=0;
        for timeind=1:length(perievent2spikes);    %event 2
            ti=perievent2spikes(timeind)-round(periSTAwidth*LFPsamplingrate);
            tf=perievent2spikes(timeind)+round(periSTAwidth*LFPsamplingrate);
            if ti<1 | tf>length(LFPvoltage)
                continue
            end
            STAunitj=[STAunitj+LFPvoltage(ti:tf)];   %unfiltered LFP.
        end
        STA.event2{chan}=STAunitj/length(perievent2spikes);
        end
          
        if unitind==1
        disp(['generating random spike train STA'])
        for chanind=1:length(dochannels)   %gets STA LFP signal from all channels on probe (this is slow).
            randomchans=dochannels(chanind);  
          
            randomSTAchan=0;
            for timeind=1:length(randomspiketimes)
                ti=randomspiketimes(timeind)-round(periSTAwidth*LFPsamplingrate);
                tf=randomspiketimes(timeind)+round(periSTAwidth*LFPsamplingrate);
                if ti<1 | tf>length(LFPvoltage)
                continue
                end
                randomSTAchan=[randomSTAchan+LFPvoltage(ti:tf)];   %unfiltered LFP.
            end
            randomSTA{randomchans}=randomSTAchan/length(randomspiketimes);  %STA for randomly selected spike train; use this as background STA.
        end
        
        end
    
    save([STAdatadir 'STA_unit' num2str(unitj) '.mat'], 'STA','-mat')
           
end

STAparameters=[];
STAparameters.randomSTA=randomSTA;
STAparameters.triggerevent1=triggerevent1;
STAparameters.triggerevent2=triggerevent2;
STAparameters.trialselection1=trialselection1;
STAparameters.trialselection2=trialselection2;
STAparameters.periSTAwidth=periSTAwidth;
STAparameters.preeventtime=preeventtime;
STAparameters.posteventtime=posteventtime;

save([STAdatadir 'STAparameters.mat'],'STAparameters','-mat')

disp(['done with get_STA'])



