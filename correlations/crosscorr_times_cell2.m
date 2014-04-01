%collecting spike (or burst) times for each unit.


stimes2=[];
if strcmp(triggerevent1, 'allspikes')==1
    doevent1trials=1;
    t0=0;
    if recordingduration<maxcorrtime
    tf=recordingduration;
    else tf=maxcorrtime;
    end
    longtimebins=0:timebinsize:tf;  %time bins used for converting firing rate from all trials into a 1D column vector.
    
    if strcmp(spikes_or_bursts2,'s')
    for unitind=1:length(dounits2);
        unitj=dounits2(unitind);
        stimes2{unitj}=spiketimes{unitj}; 
        outsiderange=find(stimes2{unitj}>tf);
        stimes2{unitj}(outsiderange)=[];      
    end
    
    elseif strcmp(spikes_or_bursts2,'b')
        
    for unitind=1:length(dounits2)
        unitj=dounits2(unitind);
        bursttimesj=bursts{unitj};   
        countsj=counts{unitj};    
        bursttimesj=bursttimesj(find(countsj>=minspikesperburst));        
        stimes2{unitj}=bursttimesj;
    end
    
    end
        
else   
    for unitind=1:length(dounits2);
        unitj=dounits2(unitind);
        
        if strcmp(spikes_or_bursts2,'s')
        stimesj=spiketimes{unitj};   
        elseif strcmp(spikes_or_bursts2,'b')
        bursttimesj=bursts{unitj};   
        countsj=counts{unitj};    
        stimesj=bursttimesj(find(countsj>=minspikesperburst));        
        end
            
        combinedtimes=[];
        if strcmp(triggerevent1, 'LFP')==1
            chan=bestchannels{unitj};      %finds LFP peak times on the best channel for unit i.
            get_LFPpeaktimes; 
            event1times=LFPpktimes/LFPsamplingrate;  %in units of seconds.
            doevent1trials=1:length(event1times);
        end

        for trialind=1:length(doevent1trials)
            trialk=doevent1trials(trialind);        
            ti=event1times(trialk);
            t0=ti-preeventtime;
            tf=ti+posteventtime;       
            spikeinds=find(stimesj>t0 & stimesj<=tf);  %only keeps spikes within -preeventtime:posteventime from the current event time.
            rel_spiketimes=stimesj(spikeinds)-t0;
            combinedtimes=[combinedtimes, rel_spiketimes+(trialind-1)*(2*posteventtime+preeventtime)];       
        end   
        stimes2{unitj}=combinedtimes;  
    end       
end


notimes=[];
for unitind=1:length(dounits2);
unitj=dounits2(unitind);
if length(stimes2{unitj})==0
    notimes=[notimes unitj];
    disp(['unit ' num2str(unitj) ' has zero times in specified range; not using in this in dounits2.'])
end
end
dounits2=setdiff(dounits2, notimes);
  
