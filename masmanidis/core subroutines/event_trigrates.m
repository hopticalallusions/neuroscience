event1_spikespertrial=[]; event2_spikespertrial=[];
event1_spikerate=[];event2_spikerate=[];
event1_semrate=[]; event2_semrate=[];  %standard error of mean
blsubrate_event1=[]; blsubrate_event2=[];

event1_grouprate=[]; event2_grouprate=[];

zscore_event1=[]; zscore_event2=[];

nrmse_event1=[];   %normalized root mean square error (NRMSE); measures how similar firing rate is over all selected trials.

for unitind=1:length(dounits)   %mean event-triggered spike rate over selected trials.
    unitj=dounits(unitind);
    
    if length(event1times)>0       
          
        for groupk=1:event1_trialgroups
            event1_grouprate{unitj}{groupk}=histc(event1_grouptimes{unitj}{groupk},timebins)/trialgroupsize/timebinsize;
            event1_grouprate{unitj}{groupk}=event1_grouprate{unitj}{groupk}(1:(length(event1_grouprate{unitj}{groupk})-1));
        end
        
        event1_ratepertrial=[]; event1_blsubratepertrial=[];
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);
            ratetrialk=histc(event1_spiketimes{unitj}{trialk},timebins)/timebinsize;
            event1_ratepertrial=[event1_ratepertrial; ratetrialk];
%           event1_blsubratepertrial=[event1_blsubratepertrial; ratetrialk-event1_baseline{unitj}{trialk}];
            event1_blsubratepertrial=[event1_blsubratepertrial; ratetrialk-baselinerate{unitj}];        %switched to this on Jan 23 2014
        end
        
        zscore_trials_event1=[]; 
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);       
            ratetrialk=histc(event1_spiketimes{unitj}{trialk},timebins)/timebinsize;
%             zscore_trials_event1=[zscore_trials_event1; (ratetrialk-event1_baseline{unitj}{trialk})/std(cell2mat(event1_baseline{unitj}))];
            zscore_trials_event1=[zscore_trials_event1; (ratetrialk-baselinerate{unitj})/stdbaselinerate{unitj}];   %switched to this on Jan 22 2014
        end
        
        event1_spikespertrial{unitj}=round(event1_ratepertrial*timebinsize);       
        if length(doevent1trials)>1
        event1_spikerate{unitj}=mean(event1_ratepertrial);
        nrmse_event1{unitj}=sqrt(sum(var(event1_ratepertrial)))/baselinerate{unitj};   %introduced Feb 4 2014.  Measures how similar firing rate is over all selected trials. normalized root mean square error (NRMSE)
                                                                                     %sums the variances across all time bins, takes the sqrt to get the SD, normalizes by the baseline.
        else  event1_spikerate{unitj}=event1_ratepertrial;
        end
        event1_spikerate{unitj}(end)=[];  
        
        event1_semrate{unitj}=std(event1_ratepertrial)/sqrt(length(doevent1trials));
        event1_semrate{unitj}=event1_semrate{unitj}';
        event1_semrate{unitj}(end)=[];
        
        blsubrate_event1{unitj}=mean(event1_blsubratepertrial);
        blsubrate_event1{unitj}(end)=[];
        
        zscore_trials_event1(isnan(zscore_trials_event1))=0;
        zscore_trials_event1(isinf(zscore_trials_event1))=0;
        zscore_event1{unitj}=mean(zscore_trials_event1);
        zscore_event1{unitj}(end)=[];
  
        if length(strmatch(smoothingwindow,'y'))==1
            event1_spikerate{unitj}=smooth(event1_spikerate{unitj},3);
            blsubrate_event1{unitj}=(smooth(blsubrate_event1{unitj}, 3))';
        end              
    end
    
    if length(event2times)>0       
        
        for groupk=1:event2_trialgroups
            event2_grouprate{unitj}{groupk}=histc(event2_grouptimes{unitj}{groupk},timebins)/trialgroupsize/timebinsize;
            event2_grouprate{unitj}{groupk}=event2_grouprate{unitj}{groupk}(1:(length(event2_grouprate{unitj}{groupk})-1));
        end
        
        event2_ratepertrial=[]; zscore_trials_event2=[]; event2_blsubratepertrial=[];
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);          
            lick_to_cue_alignment  %only applies if event2 is startlicking.
            
            ratetrialk=histc(event2_spiketimes{unitj}{trialk},timebins)/timebinsize;
            event2_ratepertrial=[event2_ratepertrial; ratetrialk];
%           event2_blsubratepertrial=[event2_blsubratepertrial; ratetrialk-event2_baseline{unitj}{trialk}];
            event2_blsubratepertrial=[event2_blsubratepertrial; ratetrialk-baselinerate{unitj}];   %switched to this on Jan 23 2014
        end
        
        zscore_trials_event2=[]; 
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);    
            lick_to_cue_alignment  %only applies if event2 is startlicking.
            ratetrialk=histc(event2_spiketimes{unitj}{trialk},timebins)/timebinsize;
%           zscore_trials_event2=[zscore_trials_event2; (ratetrialk-event2_baseline{unitj}{trialk})/std(cell2mat(event2_baseline{unitj}))];
            zscore_trials_event2=[zscore_trials_event2; (ratetrialk-baselinerate{unitj})/stdbaselinerate{unitj}];
        end
        
        
        event2_spikespertrial{unitj}=round(event2_ratepertrial*timebinsize);     
        if length(doevent2trials)>1
        event2_spikerate{unitj}=mean(event2_ratepertrial);
        else event2_spikerate{unitj}=event2_ratepertrial;
        end
        event2_spikerate{unitj}(end)=[];   

        event2_semrate{unitj}=std(event2_ratepertrial)/sqrt(length(doevent2trials));
        event2_semrate{unitj}=event2_semrate{unitj}';
        event2_semrate{unitj}(end)=[];  
        
        blsubrate_event2{unitj}=mean(event2_blsubratepertrial);
        blsubrate_event2{unitj}(end)=[];
   
        zscore_trials_event2(isnan(zscore_trials_event2))=0;
        zscore_trials_event2(isinf(zscore_trials_event2))=0;
        zscore_event2{unitj}=mean(zscore_trials_event2);
        zscore_event2{unitj}(end)=[];
       
        if length(strmatch(smoothingwindow,'y'))==1
            event2_spikerate{unitj}=smooth(event2_spikerate{unitj},3);
            blsubrate_event2{unitj}=(smooth(blsubrate_event2{unitj}, 3))';
        end
    end
    
end
