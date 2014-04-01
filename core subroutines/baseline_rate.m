
baselinerate=[]; stdbaselinerate=[];    %baseline firing and standard deviation. interval specified by baseline_start and baseline_endttime
for unitind=1:length(dounits)
   unitj=dounits(unitind);
   baselinetimesj=[];
   stimesj=spiketimes{unitj};
 
   if exist([stimulidir 'stimuli.mat']) & length(event1times)>0       
       for trialind=1:length(event1times);
            trialk=trialind;   
            t0=event1times(trialk);
            spikeinds=find(stimesj<(t0+baseline_end) & stimesj>(t0+baseline_start));
            rel_spiketimes=stimesj(spikeinds)-t0;      
            baselinetimesj=[baselinetimesj rel_spiketimes];   %create a 1-D vector containing all pre-cue spike times from all trials.  
       end
   
   baselinetimesj=sort(baselinetimesj);
   baselineratej=histc(baselinetimesj, baseline_start:timebinsize:baseline_end)/length(event1times)/timebinsize;
   baselineratej(end)=[];
   
   meanratej=mean(baselineratej);
   stdevratej=std(baselineratej);
   baselinerate{unitj}=meanratej; %round(100*meanratej)/100;
   stdbaselinerate{unitj}=stdevratej; %round(100*stdevratej)/100;    
   
   else
       baselinerate{unitj}=length(stimesj)/recordingduration;
       stdbaselinerate{unitj}=sqrt(length(stimesj))/recordingduration;
    
   end
            
end
