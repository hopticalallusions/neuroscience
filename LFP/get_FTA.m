disp(['Getting field triggered average data'])

set_plot_parameters

triggerevent1='LFP';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'LFPenvelope_peaks'. 
                      %Selecting 'LFP' will use the entire LFP trace. 'LFPenvelope_peaks' will use the peaks from the LFP envelope over entire trace.

trialselection1='all';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
 
laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
                            
f_low_LFP=35;               %used in LFP analyses
f_high_LFP=45;              %used in LFP analyses
 
minLFPamp=100;               %use fixed LFP amplitude threshold instead of S.D. in peak detection; this keeps thresholds constant across all channels.
maxLFPamp=1000;

% minLFPthreshold=3;           %default=5. threshold number of SDs for identifying high-amplitude oscillations.
% maxLFPthreshold=10;           %default=1000.  This will ensure that all peaks >minLFPthreshold will be detected.  

preeventtime=3;               %time in sec to use for detecting LFP peaks before event onset.  not used if triggerevent='LFP'
posteventtime=4;              %time in sec to use for detecting LFP peaks after event onset.   not used if triggerevent='LFP'
                             
periFTAwidth=0.1;             %+/- time around which to collect spike times (centered on LFP peak time). units in seconds. used in plot_FTA.
FTAtimebinsize=0.002;          %bin size for FTA spike rate histogram. used in plot_FTA.

%************************************************
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'none'.    
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.    
                            
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.

load_results

FTAtimebins=-periFTAwidth:FTAtimebinsize:periFTAwidth;

select_triggers_trials 

disp(['filtering from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])

currentFTAdir=[FTAdir 'f' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz LFPamp' num2str(minLFPamp) '-' num2str(maxLFPamp) '\'];
FTAdatadir=[currentFTAdir 'data\'];
mkdir(FTAdatadir);
delete([FTAdatadir '*.*'])
   
chanswithunits=cell2mat(bestchannels);
chanswithunits=unique(chanswithunits(dounits));    

FTA=[]; event1_LFPpktimes=[]; event2_LFPpktimes=[];
event1_FTAspiketimes=[]; event1_FTAspikerate=[]; event1_FTAnormrate=[];  event2_FTAspiketimes=[]; event2_FTAspikerate=[]; event2_FTAnormrate=[];
for chanind=1:length(chanswithunits);    %collecting LFP peak times for all specified electrode channels.
    chan=chanswithunits(chanind);
 
    currentvoltagefile=['LFPvoltage_ch' num2str(chan) '.mat'];
    load([LFPvoltagedir currentvoltagefile]); 
    dofilter_LFP
    stdLFPvoltage=std(LFPvoltage);     
   
%     minLFPdetectthreshold=minLFPthreshold*stdLFPvoltage;     %detect LFP peaks on lower bound on of threshold. note: the lower the threshold, the more the number of detected peaks.   
     minLFPdetectthreshold=minLFPamp;
    [pks,LFPpktimes_lowerbound]=findpeaks(LFPvoltage,'minpeakheight',minLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));           
%     maxLFPdetectthreshold=maxLFPthreshold*stdLFPvoltage;  %detect LFP peaks on upper bound on of threshold. %upperbound peaks are fewer than lowerbound peaks.
     maxLFPdetectthreshold=maxLFPamp;
    [pks, LFPpktimes_upperbound]=findpeaks(LFPvoltage,'minpeakheight',maxLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));  
    
    LFPpktimes=setdiff(LFPpktimes_lowerbound,LFPpktimes_upperbound);  %get the LFP peaks that have amplitude >minLFPthreshold and <maxLFPthreshold.
  
    FTA.LFPdetectthreshold{chan}=minLFPdetectthreshold;
       
    if strmatch(triggerevent1,'LFP','exact')==0
    allevent1_LFPpktimes=[];
    for trialind=1:length(doevent1trials)
        trial=doevent1trials(trialind);       
        ti=event1times(trial);
        t0=ti-preeventtime;
        tf=ti+posteventtime;
        if t0<1 | tf>length(LFPvoltage) 
            continue
        end
        perieventLFPpeaksi=LFPpktimes(find((LFPpktimes/LFPsamplingrate)<=tf & (LFPpktimes/LFPsamplingrate)>t0));
        event1_LFPpktimes{chan}{trial}=perieventLFPpeaksi/LFPsamplingrate-ti;   %LFP peak times relative to event time. units in seconds.
        allevent1_LFPpktimes=[allevent1_LFPpktimes perieventLFPpeaksi];                 %collects LFP peak times across all event trials. units in LFP samples.
    end
    FTA.allevent1_LFPpktimes{chan}=allevent1_LFPpktimes;
    else allevent1_LFPpktimes=LFPpktimes; FTA.allevent1_LFPpktimes{chan}=LFPpktimes;  %if triggerevent='LFP' then use all the LFP peak times.
    end  
    
    if strmatch(triggerevent1,'LFPenvelope_peaks','exact')==1   
%     disp(['using LFP envelope function to select the peak times of each high amplitude episode.'])
    get_LFPenvelope;
    LFPpktimes=peakenvelopetimes;
    end

    disp(['channel ' num2str(chan) ' (' num2str(chanind) ' of ' num2str(length(chanswithunits)) '), found ' num2str(length(LFPpktimes)) ' total peaks in LFP (threshold = ' num2str(round(minLFPdetectthreshold)) '-' num2str(round(maxLFPdetectthreshold)) ' uV).']) 
             
    for unitind=1:length(dounits);
        unitj=dounits(unitind);
        if bestchannels{unitj}~=chan
            continue
        end
        stimesunitj=spiketimes{unitj};
        event1_FTAspiketimes{unitj}{chan}=[]; event1_FTAspikerate{unitj}{chan}=[]; event1_FTAnormrate{unitj}{chan}=[];
        for i=1:length(allevent1_LFPpktimes);
            ti=allevent1_LFPpktimes(i)/LFPsamplingrate;
            t0=ti-periFTAwidth;
            tf=ti+periFTAwidth;
            trigtimesj=stimesunitj(find(stimesunitj<=tf & stimesunitj>t0));
            if length(trigtimesj)>0
            reltimesj=trigtimesj-ti;  %realign times to local LFP peak.
            event1_FTAspiketimes{unitj}{chan}=[event1_FTAspiketimes{unitj}{chan} reltimesj];     
            end
        end  
    
        event1_FTAspikerate{unitj}{chan}=histc(event1_FTAspiketimes{unitj}{chan},FTAtimebins)/length(allevent1_LFPpktimes)/FTAtimebinsize;  %binned histogram in units of Hz (average firing rate)
        event1_FTAspikerate{unitj}{chan}=event1_FTAspikerate{unitj}{chan}(1:(length(event1_FTAspikerate{unitj}{chan})-1)); 
        event1_FTAnormrate{unitj}{chan}=event1_FTAspikerate{unitj}{chan}/max(event1_FTAspikerate{unitj}{chan});
                   
    end
        
end

FTA.f_low_LFP=f_low_LFP;
FTA.f_high_LFP=f_high_LFP;
% FTA.LFPthreshold=LFPthreshold;
FTA.minLFPamp=minLFPamp;
FTA.maxLFPamp=maxLFPamp;
FTA.triggerevent1=triggerevent1;
FTA.triggerevent2=triggerevent2;
FTA.trialselection1=trialselection1;
FTA.trialselection2=trialselection2;
FTA.preeventtime=preeventtime;
FTA.posteventtime=posteventtime;
FTA.periFTAwidth=periFTAwidth;
FTA.FTAtimebinsize=FTAtimebinsize;
FTA.event1_LFPpktimes=event1_LFPpktimes;
FTA.event1_FTAspiketimes=event1_FTAspiketimes;
FTA.event1_FTAspikerate=event1_FTAspikerate;
FTA.event1_FTAnormrate=event1_FTAnormrate;
% FTA.event2_LFPpktimes=event2_LFPpktimes;
% FTA.event2_FTAspiketimes=event2_FTAspiketimes;
% FTA.event2_FTAspikerate=event2_FTAspikerate;
% FTA.event2_FTAnormrate=event2_FTAnormrate;


save([FTAdatadir 'FTA.mat'],'FTA','-mat')

disp(['done with get_FTA'])
 