%Can be adapted to specific time windows or spikes (e.g. could potentially analyze only correlations during bursts).

set_plot_parameters

triggerevent1='LFP';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'none'. 
                      %'LFP' will use spikes near high amplitude LFP peaks. 'none' will use spikes from the entire recording duration to calculate correlations.

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
                             
LFPthreshold=5;             %default=5. threshold number of SDs for identifying high-amplitude oscillations. used if triggerevent1='LFP'
                            
laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
                            
preeventtime=0.1;               %time in sec to use before event onset. will use any spikes found within -preeventtime:posteventtime. larger range will keep more spikes.
posteventtime=0.1;              %time in sec to use after event onset.                            
%************************************************
triggerevent2='none';  %options: 'none'.  (currently not in use in correlations)
triggerevent3='none';  %options: 'none'.  (currently not in use in correlations.)    
trialselection2='all';  %select which event2 trials to display. same options as trialselection1. (currently not in use in correlations.)  
trialgroupsize=10;  %(currently not in use in correlations.)    

format short;

load_results

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

mkdir(xcorr_reltimesdir)
delete([xcorr_reltimesdir '\*.*'])

%***Calculating dt for each spike pair.   This doesn't depend on specified plot parameters.***    
for i=1:length(dounits);
    uniti=dounits(i);   
    disp(['getting relative spike times between unit ' num2str(uniti) ' (' num2str(i) '/' num2str(length(dounits)) ') and other units.'])
    relspiketimes=[];     %initialize array for the ith unit.
    for q=1:length(dounits);
        unitq=dounits(q);
        relspiketimes{unitq}=[];    %initialize array for the jth unit.
    end
    
    origstimesuniti=spiketimes{uniti};
    
    if strmatch(triggerevent1, 'none')==1
    doevent1trials=1;
    elseif strmatch(triggerevent1, 'LFP')==1
    chan=bestchannels{uniti};      %finds LFP peak times on the best channel for unit i.
    get_LFPpeaktimes; 
    event1times=LFPpktimes/LFPsamplingrate;  %in units of seconds.
    doevent1trials=1:length(event1times);
    end

    for trialind=1:length(doevent1trials)
        trial=doevent1trials(trialind);
       
        if strmatch(triggerevent1, 'none')==1
        t0=0;
        tf=recordingduration;
        disp(['calculating correlations for the entire ' num2str(tf) ' s recording duration.'])
        else
        ti=event1times(trial);
        t0=ti-preeventtime;
        tf=ti+posteventtime;
        end
            
        stimesuniti=origstimesuniti(find(origstimesuniti>t0 & origstimesuniti<=tf));  %only keeps spikes within -preeventtime:posteventime from the current event time.
  
        for spikei=1:length(stimesuniti);
            
            if length(stimesuniti)==0 
                continue
            end
            
            timei=stimesuniti(spikei);     
        
            for j=1:length(dounits);
                unitj=dounits(j);
 
                if i>j   
                continue
                end
             
                stimesunitj=spiketimes{unitj};             
%                 stimesunitj=stimesunitj(find(stimesunitj>(ti-0.5) & stimesunitj<=(ti+0.5)));    %default=0.5       
                reltimesunitj=timei-stimesunitj;
                reltimesunitj=reltimesunitj(find(abs(reltimesunitj)<=0.5));   %default=0.5  %remove any time differences > 0.5 s to save memory.

                if uniti==unitj;   %removes zeros from autocorrelation; makes curve symmetric.
                a=find(reltimesunitj==0);
                b=1:length(reltimesunitj);
                c=setdiff(b,a);
                reltimesunitj=reltimesunitj(c); 
                end           
            relspiketimes{unitj}=[relspiketimes{unitj} reltimesunitj];
            end
        end   
    end
    save([xcorr_reltimesdir 'relspiketimes_u' num2str(uniti) '.mat'], 'relspiketimes', '-MAT')
    clear relspiketimes
   
end

reltime_params=[];
reltime_params.triggerevent1=triggerevent1;
reltime_params.triggerevent2=triggerevent2;
reltime_params.trialselection1=trialselection1;
reltime_params.laserfreqselect=laserfreqselect;
reltime_params.preeventtime=preeventtime;
reltime_params.posteventtime=posteventtime;
save([xcorrdir 'relativetime_params.mat'], 'reltime_params', '-MAT')

disp(['done obtaining relative spike times.'])
