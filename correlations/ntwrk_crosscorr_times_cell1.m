%collecting spike (or burst) times for each unit.
    
if strcmp(ntwrksync1,'sync_s')
allstimes=sync.spiking{class1number};    
elseif strcmp(ntwrksync1,'sync_b')
allstimes=sync.bursting{class1number};    
end

stimes1=[];
if strcmp(triggerevent1, 'allspikes')
    doevent1trials=1;
    t0=0;
    if recordingduration<maxcorrtime
    tf=recordingduration;
    else tf=maxcorrtime;
    end
    longtimebins=0:timebinsize:tf;  %time bins used for converting firing rate from all trials into a 1D column vector.
    stimes1=allstimes;
    stimes1(find(allstimes>tf))=[];
    disp(['calculating cross-correlations for the continuous data set from t=0 to ' num2str(tf) ' s.'])    
else   
    longtimebins=0:timebinsize:(length(doevent1trials)*(posteventtime-preeventtime));  %time bins used for converting firing rate from all trials into a 1D column vector.
           
        combinedtimes=[];
        if strcmp(triggerevent1, 'LFP')
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
            spikeinds=find(allstimes>t0 & allstimes<=tf);  %only keeps spikes within -preeventtime:posteventime from the current event time.
            rel_spiketimes=allstimes(spikeinds)-t0;
            combinedtimes=[combinedtimes, rel_spiketimes+(trialind-1)*(posteventtime-preeventtime)];         
        end   
        stimes1=combinedtimes;      
end
