%collecting spike (or burst) times for each unit.
if strcmp(spk_burst_ntwrksync2,'sync_s')
allstimes=sync.spiking{class2number};    
elseif strcmp(spk_burst_ntwrksync2,'sync_b')
allstimes=sync.bursting{class2number};    
end

stimes2=[];
if strcmp(triggerevent1, 'allspikes')
    doevent2trials=1;
    t0=0;
    if recordingduration<maxcorrtime
    tf=recordingduration;
    else tf=maxcorrtime;
    end
    longtimebins=0:timebinsize:tf;  %time bins used for converting firing rate from all trials into a 1D column vector.
    stimes2{2}=allstimes;
    stimes2{2}(find(allstimes>tf))=[];
    disp(['calculating cross-correlations for the continuous data set from t=0 to ' num2str(tf) ' s.'])    
else   
    longtimebins=0:timebinsize:(length(doevent2trials)*(posteventtime-preeventtime));  %time bins used for converting firing rate from all trials into a 1D column vector.
           
        combinedtimes=[];
        if strcmp(triggerevent1, 'LFP')
            chan=bestchannels{unitj};      %finds LFP peak times on the best channel for unit i.
            get_LFPpeaktimes; 
            event2times=LFPpktimes/LFPsamplingrate;  %in units of seconds.
            doevent2trials=1:length(event2times);
        end

        for trialind=1:length(doevent2trials)
            trialk=doevent2trials(trialind);        
            ti=event2times(trialk);
            t0=ti-preeventtime;
            tf=ti+posteventtime;       
            spikeinds=find(allstimes>t0 & allstimes<=tf);  %only keeps spikes within -preeventtime:posteventime from the current event time.
            rel_spiketimes=allstimes(spikeinds)-t0;
            combinedtimes=[combinedtimes, rel_spiketimes+(trialind-1)*(posteventtime-preeventtime)];         
        end   
        stimes2{2}=combinedtimes;      
end