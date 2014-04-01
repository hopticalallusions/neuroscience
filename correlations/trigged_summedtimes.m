event1_synctimes=[]; event2_synctimes=[]; 
event1_inds=[]; event2_inds=[];
for trialind=1:length(doevent1trials);
    trialk=doevent1trials(trialind);
    t0=event1times(trialk);      
    spikeinds=find(synctimebins<(t0+posteventtime) & synctimebins>(t0-preeventtime));
    event1_inds{trialk}=spikeinds;
end    
             
if length(doevent2trials)>0
for trialind=1:length(doevent2trials);
    trialk=doevent2trials(trialind);
    t0=event2times(trialk);    
    spikeinds=find(synctimebins<(t0+posteventtime) & synctimebins>(t0-preeventtime)); 
    event2_inds{trialk}=spikeinds;
end     
end

event1_syncpertrial=[];
for trialind=1:length(doevent1trials);
    trialk=doevent1trials(trialind);
    summedtimestrialk=summedtimes(event1_inds{trialk});
    if trialind>1 & length(summedtimestrialk)<length(summedtimes(event1_inds{doevent1trials(1)}))
    summedtimestrialk=summedtimes([event1_inds{trialk} max(event1_inds{trialk})+1]);   
    elseif trialind>1 & length(summedtimestrialk)>length(summedtimes(event1_inds{doevent1trials(1)}))
    summedtimestrialk=summedtimes([event1_inds{trialk}(1:(length(event1_inds{trialk})-1))]);  
    end
    event1_syncpertrial=[event1_syncpertrial; summedtimestrialk];   %number of coincident cells per time bin.
end
        
event1_syncrate=mean(event1_syncpertrial);  %gives avg. # of cofiring cells per unit time. 
event1_syncrate=(event1_syncrate(1:(length(event1_syncrate)-1)))';  
event1_syncrate=decimate(event1_syncrate, round(timebinsize/slidingwindow_stepsize));  %downsample to the new timebinsize. 
event1_syncrate=event1_syncrate/length(dounits);  %convert # of sync units to fraction.

event1_syncsem=std(event1_syncpertrial)/sqrt(length(doevent1trials));  %gives SEM of number of cofiring cells per unit time. 
event1_syncsem=(event1_syncsem(1:(length(event1_syncsem)-1)))';  
event1_syncsem=decimate(event1_syncsem, round(timebinsize/slidingwindow_stepsize));  %downsample to the new timebinsize. 
event1_syncsem=event1_syncsem/length(dounits);  %convert # of sync units to fraction.
           
if length(strmatch(smoothingwindow,'y'))==1
event1_syncrate=smooth(event1_syncrate,3);
end  

if length(doevent2trials)>0 
event2_syncpertrial=[];
for trialind=1:length(doevent2trials);
    trialk=doevent2trials(trialind);    
    summedtimestrialk=summedtimes(event2_inds{trialk});
    if trialind>1 & length(summedtimestrialk)<length(summedtimes(event2_inds{doevent2trials(1)}))
    summedtimestrialk=summedtimes([event2_inds{trialk} max(event2_inds{trialk})+1]);   
    elseif trialind>1 & length(summedtimestrialk)>length(summedtimes(event2_inds{doevent2trials(1)}))
    summedtimestrialk=summedtimes([event2_inds{trialk}(1:(length(event2_inds{trialk})-1))]);  
    end
    event2_syncpertrial=[event2_syncpertrial; summedtimestrialk];   %number of coincident cells per time bin.
end
        
event2_syncrate=mean(event2_syncpertrial);   %gives avg. # of cofiring cells per unit time. 
event2_syncrate=(event2_syncrate(1:(length(event2_syncrate)-1)))';    
event2_syncrate=decimate(event2_syncrate, round(timebinsize/slidingwindow_stepsize));  %downsample to the new timebinsize. 
event2_syncrate=event2_syncrate/length(dounits);  %convert # of sync units to fraction.

event2_syncsem=std(event2_syncpertrial)/sqrt(length(doevent2trials));  %gives SEM of number of cofiring cells per unit time. 
event2_syncsem=(event2_syncsem(1:(length(event2_syncsem)-1)))';  
event2_syncsem=decimate(event2_syncsem, round(timebinsize/slidingwindow_stepsize));  %downsample to the new timebinsize. 
event2_syncsem=event2_syncsem/length(dounits);  %convert # of sync units to fraction.
           
if length(strmatch(smoothingwindow,'y'))==1
event2_syncrate=smooth(event2_syncrate,3);
end  
end
