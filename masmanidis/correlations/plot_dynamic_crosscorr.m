
set_plot_parameters

spikes_or_bursts1='s';       %for first set of times in pair. 's' will use spikes, 'b' will use burst episodes, 
spikes_or_bursts2='s';       %for second set of times in pair. 's' will use spikes, 'b' will use burst episodes

unitclass1='all';        %first type of unit used in pairwise comparison. can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj
unitclass2='all';        %second type of unit used in pairwise comparison. can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration','allspikes', 'LFP'
                      %'allspikes' will use spikes from t=0 to t=maxcorrtime. 
                  
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
                            %'spontaneous licking'. excludes cues.
                            
                            %***Compatible with +/- 'acceleration' triggerevents:***
                            %'CS1 running'. peaks in acceleration occuring between CS and CS-US delay time. 
                            %'CS2 running'
                            %'spontaneous running'. excludes cues and licking episodes.
                             
LFPthreshold=5;             %default=5. threshold number of SDs for identifying high-amplitude oscillations. used if triggerevent1='LFP'
                            
laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

preeventtime=-1.5;               %time in sec to use before event onset.  
posteventtime=2.5;              %time in sec to use after event onset.   
maxcorrtime=10000;          %if triggerevent='none', this is the maximum time that can be retained. if maxcorrtime>recordingduration, will use recordingduration.

min_unitseparation=0.05;    %minimum pairwise separation of units (in mm) to be added to correlation plots. setting minimum separation helps compensate for any possible spike sorting errors.
max_unitseparation=0.5;     %maximum pairwise separation of units (in mm) to be added to correlation plots. setting minimum separation helps compensate for any possible spike sorting errors.

timebinsize=0.001;          %default=0.001 s. bin size to use for calculating firing rates entered in cross-correlation.
plot_maxlag=100;                 %default=25 samples. maximum number of +/- lag samples to use in xcorr function.
%************************************************
triggerevent2='none';  %options: 'none'.  (currently not in use in correlations)
triggerevent3='none';  %options: 'none'.  (currently not in use in correlations.)    
trialselection2='all';  %select which event2 trials to display. same options as trialselection1. (currently not in use in correlations.)  
trialgroupsize=10;  %(currently not in use in correlations.)    

format short;

load_results

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

plot_corrtime=(-plot_maxlag:1:plot_maxlag)*1000*timebinsize;

if strcmp(unitclass1,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass1));
    dounits1=dounits(unitclassinds);
    plotlabel1=unitclassnames{dounits1(1)};

else
    dounits1=dounits;
    plotlabel1=['1'];
end
disp(plotlabel1)

if strcmp(unitclass2,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass2));
    dounits2=dounits(unitclassinds);
    plotlabel2=unitclassnames{dounits2(1)};
else
    dounits2=dounits;
    plotlabel2=['2'];
end
disp(plotlabel2)

crosscorr_times_cell1
crosscorr_times_cell2

pairwise_dist=[]; did_pairs=[]; 
for unitindi=1:length(dounits);
    uniti=dounits(unitindi);    
    xi=unitx{uniti};
    yi=unity{uniti};
    zi=unitz{uniti};
    
    for unitindj=1:length(dounits);
        unitj=dounits(unitindj);        
        xj=unitx{unitj};
        yj=unity{unitj};
        zj=unitz{unitj};
        distij=sqrt((xj-xi)^2+(yj-yi)^2+(zj-zi)^2);            
        pairwise_dist{uniti}{unitj}=distij;  
        
        did_pairs{uniti}{unitj}='n';   %initialize values.
    end
end

disp('finding all specified cross-correlations...')

xcorr_observed=[]; combined_xcorr=[]; totalpairs=0;
for unitindi=1:length(dounits1);
    uniti=dounits1(unitindi); 
    spikecountsi=histc(stimes1{uniti},longtimebins);  %binned spike counts.
        
    for unitindj=1:length(dounits2);
        unitj=dounits2(unitindj);   
        
        if uniti==unitj | did_pairs{uniti}{unitj}=='y' | pairwise_dist{uniti}{unitj}<min_unitseparation | pairwise_dist{uniti}{unitj}>max_unitseparation    
            continue
        end 
        
        spikecountsj=histc(stimes2{unitj},longtimebins);  %binned spike counts.
        xcorr_observed{uniti}{unitj}=xcorr(spikecountsi, spikecountsj, maxlag);
        
        combined_xcorr=[combined_xcorr;  xcorr_observed{uniti}{unitj}];
        
        did_pairs{uniti}{unitj}='y';
        did_pairs{unitj}{uniti}='y';
        totalpairs=totalpairs+1;
             
    end
    
end
   
close all
boundedline(plot_corrtime, mean(combined_xcorr), std(combined_xcorr)/sqrt(totalpairs),'-k')
hold on
plot([0 0], [min(mean(combined_xcorr)) max(mean(combined_xcorr))])
hold off
xlabel([plotlabel1 '-' plotlabel2 ' lag (ms)'],'FontSize',8)
ylabel(['normalized firing probability'],'FontSize',8)

disp('done.')
