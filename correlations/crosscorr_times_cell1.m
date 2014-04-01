%collecting spike (or burst) times for each unit.


stimes1=[];
if strcmp(triggerevent1, 'allspikes')
    doevent1trials=1;
    t0=0;
    if recordingduration<maxcorrtime
    tf=recordingduration;
    else tf=maxcorrtime;
    end
    longtimebins=0:timebinsize:tf;  %time bins used for converting firing rate from all trials into a 1D column vector.
    
    if strcmp(spikes_or_bursts1,'s')
    for unitind=1:length(dounits1);
        unitj=dounits1(unitind);
        stimes1{unitj}=spiketimes{unitj}; 
        outsiderange=find(stimes1{unitj}>tf);
        stimes1{unitj}(outsiderange)=[];      
    end
    
    elseif strcmp(spikes_or_bursts1,'b')
        
    for unitind=1:length(dounits1)
        unitj=dounits1(unitind);
        bursttimesj=bursts{unitj};   
        countsj=counts{unitj};    
        bursttimesj=bursttimesj(find(countsj>=minspikesperburst));        
        stimes1{unitj}=bursttimesj;
    end
    
    end
    
    disp(['calculating cross-correlations for the continuous data set from t=0 to t=' num2str(tf) ' s.'])
    
else   
    longtimebins=0:timebinsize:((length(doevent1trials)+1)*(2*posteventtime+preeventtime));  %time bins used for converting firing rate from all trials into a 1D column vector.
    for unitind=1:length(dounits1);
        unitj=dounits1(unitind);
        
        if strcmp(spikes_or_bursts1,'s')
        stimesj=spiketimes{unitj};   
        elseif strcmp(spikes_or_bursts1,'b')
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
        stimes1{unitj}=combinedtimes;  
    end       
end


notimes=[];
for unitind=1:length(dounits1);
unitj=dounits1(unitind);
if length(stimes1{unitj})==0
    notimes=[notimes unitj];
    disp(['unit ' num2str(unitj) ' has zero times in specified range; not using in this in dounits1.'])
end
end
dounits1=setdiff(dounits1, notimes);
  