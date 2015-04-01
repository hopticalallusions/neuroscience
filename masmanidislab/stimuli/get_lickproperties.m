%********************
% disp('finding event-triggered lick times and event-to-lick latency')
event1_licktimes=[]; event1_lickspertrial=[]; 
event1_grouplicktimes=[]; groupk=1; groupedtimes=[];
event1_licklatency=[];  %trial-by-trial latency to licking.  added Jan 31 2014.
for trialind=1:length(doevent1trials);
    trialk=doevent1trials(trialind);
    eventtimek=event1times(trialk);
    lickinds=find(licktimes<(eventtimek+posteventtime) & licktimes>(eventtimek-preeventtime));
    licktimesk=licktimes(lickinds);
    event1_licktimes{trialk}=licktimesk-eventtimek;    
    event1_lickspertrial=[event1_lickspertrial; histc(event1_licktimes{trialk},licktimebins)/lickbinsize];  %lick rate per trial.
    
    lickinds=find(licktimes<(eventtimek+posteventtime) & licktimes>(eventtimek));
    licktimesk=licktimes(lickinds);
    if length(licktimesk)>0
    event1_licklatency(trialind)=min(licktimesk-eventtimek);    
    end
          
    if mod(trialind,trialgroupsize)==0
        groupedtimes=[groupedtimes event1_licktimes{trialk}];
        event1_grouplicktimes{groupk}=groupedtimes;
        groupedtimes=[];
        groupk=groupk+1;
    else
        groupedtimes=[groupedtimes event1_licktimes{trialk}];            
    end     
        
end

event1_lickrate=mean(event1_lickspertrial);  %mean lick rate over all selected CS1 trials.
event1_lickrate=event1_lickrate(1:(length(event1_lickrate)-1));
event1_lickrate=smooth(event1_lickrate,3);

event1_licksem=std(event1_lickspertrial)/sqrt(length(doevent1trials));
event1_licksem=event1_licksem(1:end-1);

event1_grouplickrate=[];
for groupk=1:event1_trialgroups
    event1_grouplickrate{groupk}=histc(event1_grouplicktimes{groupk},licktimebins)/trialgroupsize/lickbinsize;
    event1_grouplickrate{groupk}=event1_grouplickrate{groupk}(1:end-1);
end


event2_licktimes=[]; event2_lickspertrial=[];
event2_grouplicktimes=[]; groupk=1; groupedtimes=[];
for trialind=1:length(doevent2trials);
    trialk=doevent2trials(trialind);
    eventtimek=event2times(trialk);
    
    lick_to_cue_alignment  %only applies if event2 is startlicking.
       
    lickinds=find(licktimes<(eventtimek+posteventtime) & licktimes>(eventtimek-preeventtime));
    licktimesk=licktimes(lickinds);
    event2_licktimes{trialk}=licktimesk-eventtimek;   
    event2_lickspertrial=[event2_lickspertrial; histc(event2_licktimes{trialk},licktimebins)/lickbinsize];
        
    if mod(trialind,trialgroupsize)==0
        groupedtimes=[groupedtimes event2_licktimes{trialk}];
        event2_grouplicktimes{groupk}=groupedtimes;
        groupedtimes=[];
        groupk=groupk+1;
    else
        groupedtimes=[groupedtimes event2_licktimes{trialk}];            
    end     
    
end
 
event2_lickrate=mean(event2_lickspertrial);  %mean lick rate over all selected CS1 trials.
event2_lickrate=event2_lickrate(1:(length(event2_lickrate)-1));
event2_lickrate=smooth(event2_lickrate,3);

event2_licksem=std(event2_lickspertrial)/sqrt(length(doevent2trials));
event2_licksem=event2_licksem(1:end-1);

event2_grouplickrate=[];
for groupk=1:event2_trialgroups
    if length(event2_grouplicktimes)<groupk
        continue
    end
    event2_grouplickrate{groupk}=histc(event2_grouplicktimes{groupk},licktimebins)/trialgroupsize/lickbinsize;
    event2_grouplickrate{groupk}=event2_grouplickrate{groupk}(1:end-1);
end
