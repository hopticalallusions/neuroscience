event1_spiketimes=[]; event2_spiketimes=[];  %initialize cue-triggered & lick-triggered spike times
event1_grouptimes=[]; event2_grouptimes=[];   %event-triggered spike times grouped in trials.
event1_baseline=[]; event2_baseline=[];
baseline_mean=[]; baseline_sd=[]; 

for unitind=1:length(dounits)
    unitj=dounits(unitind); event1_spiketimes{unitj}=[];
    
    if length(event1times)>0
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);
            event1_spiketimes{unitj}{trialk}=[];
        end
        
        event1_grouptimes{unitj}=[];
        for groupk=1:event1_trialgroups
            event1_grouptimes{unitj}{groupk}=[];
        end
    end
    
    if length(event2times)>0
        event2_spiketimes{unitj}=[]; 
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            event2_spiketimes{unitj}{trialk}=[];
        end
        
        event2_grouptimes{unitj}=[];
        for groupk=1:event2_trialgroups
            event2_grouptimes{unitj}{groupk}=[];
        end
    end
           
end


for unitind=1:length(dounits)
   unitj=dounits(unitind);
   stimesj=spiketimes{unitj};
   
   if length(event1times)>0
       
        baselineratej=[];
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);
            t0=event1times(trialk); 
            spikeinds=find(stimesj<(t0+posteventtime) & stimesj>(t0-preeventtime));
            rel_spiketimes=stimesj(spikeinds)-t0;
            event1_spiketimes{unitj}{trialk}=rel_spiketimes;       
            
            baseline_spikeinds=find(stimesj<(t0+baseline_end) & stimesj>(t0+baseline_start));
            rel_bltimes=stimesj(baseline_spikeinds)-t0;     
            baselineratejk=histc(rel_bltimes, baseline_start:timebinsize:baseline_end)/timebinsize;
            event1_baseline{unitj}{trialk}=mean(baselineratejk);
            baselineratej=[baselineratej baselineratejk];           
        end            
        
        groupk=1; groupedtimes=[];
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind); 
            if mod(trialind,trialgroupsize)==0
                groupedtimes=[groupedtimes event1_spiketimes{unitj}{trialk}];
                event1_grouptimes{unitj}{groupk}=groupedtimes;
                groupedtimes=[];
                groupk=groupk+1;
            else
                groupedtimes=[groupedtimes event1_spiketimes{unitj}{trialk}];            
            end     
        end
            
   end
   
   if length(event2times)>0
       
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            t0=event2times(trialk);
            
            eventtimek=t0;
            lick_to_cue_alignment  %only applies if event2 is startlicking.
            t0=eventtimek;

            spikeinds=find(stimesj<(t0+posteventtime) & stimesj>(t0-preeventtime));
            rel_spiketimes=stimesj(spikeinds)-t0;
            event2_spiketimes{unitj}{trialk}=rel_spiketimes;      
            
            baseline_spikeinds=find(stimesj<(t0+baseline_end) & stimesj>(t0+baseline_start));
            rel_bltimes=stimesj(baseline_spikeinds)-t0;     
            baselineratejk=histc(rel_bltimes, baseline_start:timebinsize:baseline_end)/timebinsize;
            event2_baseline{unitj}{trialk}=mean(baselineratejk);
            baselineratej=[baselineratej baselineratejk];           
        end
        
        groupk=1; groupedtimes=[];
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);     
            
            lick_to_cue_alignment  %only applies if event2 is startlicking.
            
            if mod(trialind,trialgroupsize)==0
                groupedtimes=[groupedtimes event2_spiketimes{unitj}{trialk}];
                event2_grouptimes{unitj}{groupk}=groupedtimes;
                groupedtimes=[];
                groupk=groupk+1;
            else
                groupedtimes=[groupedtimes event2_spiketimes{unitj}{trialk}];            
            end     
        end
   end
   
   baseline_mean{unitj}=mean(baselineratej);    
   baseline_sd{unitj}=std(baselineratej);  
 
    
end
