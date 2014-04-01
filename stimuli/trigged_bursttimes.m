slow_or_rapid_bursts
    
event1_bursttimes=[]; event2_bursttimes=[];  
for unitind=1:length(dounits)
    unitj=dounits(unitind);
    bursttimesj=bursts{unitj};   
    countsj=counts{unitj};    
    bursttimesj=bursttimesj(find(countsj>=minspikesperburst));
    
   
    for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        t0=event1times(trialk); 
        spikeinds=find(bursttimesj<(t0+posteventtime) & bursttimesj>(t0-preeventtime));
        rel_spiketimes=bursttimesj(spikeinds)-t0;
        event1_bursttimes{unitj}{trialk}=rel_spiketimes;       
    end    
             
    if length(event2times)>0
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            t0=event2times(trialk);
            spikeinds=find(bursttimesj<(t0+posteventtime) & bursttimesj>(t0-preeventtime));
            rel_spiketimes=bursttimesj(spikeinds)-t0;
            event2_bursttimes{unitj}{trialk}=rel_spiketimes;      
        end     
    end  
end

event1_burstrate=[]; event2_burstrate=[];
for unitind=1:length(dounits)   %mean event-triggered burst rate over selected trials.
    unitj=dounits(unitind);
       
    event1_ratepertrial=[];
    for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        event1_ratepertrial=[event1_ratepertrial; histc(event1_bursttimes{unitj}{trialk},timebins)/timebinsize];
    end
        
    event1_burstrate{unitj}=mean(event1_ratepertrial);
    event1_burstrate{unitj}=(event1_burstrate{unitj}(1:(length(event1_burstrate{unitj})-1)))';    
                 
    if length(strmatch(smoothingwindow,'y'))==1
    event1_burstrate{unitj}=smooth(event1_burstrate{unitj},3); 
    end              
    
    if length(event2times)>0     
        
        event2_ratepertrial=[];
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            event2_ratepertrial=[event2_ratepertrial; histc(event2_bursttimes{unitj}{trialk},timebins)/timebinsize];
        end
        
        event2_burstrate{unitj}=mean(event2_ratepertrial);
        event2_burstrate{unitj}=(event2_burstrate{unitj}(1:(length(event2_burstrate{unitj})-1)))';
        
        if length(strmatch(smoothingwindow,'y'))==1
        event2_burstrate{unitj}=smooth(event2_burstrate{unitj},3);
        end
    end
    
end

