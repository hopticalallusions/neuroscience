% disp(['finding event-triggered spike time and firing rate properties'])
if onlysigmod=='y' & domultisubject=='n'; %finds significantly modulated (by event 1) units.    Note: need to run get_response_pvalue
    filespec=uigetfile([savedir 'firing_pvalue*'], 'select the firing_pvalue file for use in signifance test');
    load([savedir filespec])
    firing_pvalue
    get_sigfiring_units 
elseif onlysigmod=='y' & domultisubject=='y' & length(plotlist)==0 %finds significantly modulated (by event 1) units.    Note: need to run get_response_pvalue

    if strcmp(subselect1,'all') & strcmp(subselect2,'all')
    filespec=[triggerevent1 ' vs ' triggerevent2];
    else filespec=[triggerevent1 '_' num2str(min(str2num(subselect1))) '-' num2str(max(str2num(subselect1))) ' vs ' triggerevent2 '_' num2str(min(str2num(subselect2))) '-' num2str(max(str2num(subselect2)))];
    end
  
    pvaluefile = [savedir 'firing_pvalue_' filespec '.mat'];    
    if exist(pvaluefile,'file')>0
    load(pvaluefile)
    else filespec=uigetfile([savedir 'firing_pvalue*'], 'select the firing_pvalue file for use in signifance test');
    pvaluefile = [savedir filespec];    
    load(pvaluefile)
    end  
       
    get_sigfiring_units 
    
elseif onlysigmod=='y' & domultisubject=='y' & length(plotlist)>0 %finds significantly modulated (by event 1) units.    Note: need to run get_response_pvalue       
    disp(['NOTE: only using units in plotlist. Not doing any significance testing.'])
    onlysigmod='n';    
end

if onlysigmod=='n' & domultisubject=='y' & length(plotlist)>0
    dounits=unique(xcorr_stats.connectedcells{subjectind});
    dounits=intersect(dounits,orig_dounits);
end

clear baseline_rate
baseline_rate

event_trigtimes             %event triggered spike times & event-triggered baseline rate, and mean & SD of baseline preceding triggered events.

event_trigrates             %event-triggered firing rates & z-scores & baseline-subtracted rates. calculated both as an average over all trials, and for every trial group. note: moving window smoothing is applied to rates.

normrate_event1=[]; normrate_event2=[]; 
event1_groupzscore=[]; event2_groupzscore=[];  % z-score calculated for every trial group. 
for unitind=1:length(dounits);
    unitj=dounits(unitind);

    maxrate_event1=max(blsubrate_event1{unitj});     %maximum trial averaged peri-event firing rate for selected unit. event 1.   
    if length(event2times)>0                                %maximum trial averaged peri-event firing rate for selected unit. event 2.
    maxrate_event2=max(blsubrate_event2{unitj});
    else
    maxrate_event2=0;
    end   
    
    normfactor=max(maxrate_event1);  %use this normfactor to normalize the peri-event 1 and 2 firing rates by the same factor.
       
    normrate_event1{unitj}=(blsubrate_event1{unitj}/normfactor)';   %mean normalized firing rate = (rate-baseline)/(peak rate-baseline).  range = ~-1 to 1. have also used (rate-baseline)/(peak) with range ~-1 to 1 to allow better visualization of reduced firing in plot_unitstack
              
    for groupk=1:event1_trialgroups
        event1_groupzscore{unitj}{groupk}=(event1_grouprate{unitj}{groupk}-baselinerate{unitj})/stdbaselinerate{unitj};
    end
       
    if length(event2times)>0
    normrate_event2{unitj}=(blsubrate_event2{unitj}/normfactor)'; 
    for groupk=1:event2_trialgroups
        event2_groupzscore{unitj}{groupk}=(event2_grouprate{unitj}{groupk}-baselinerate{unitj})/stdbaselinerate{unitj};
    end        
    end
end


unit_DV=[];    %list DV positions of units.
for unitind=1:length(dounits);
    unitj=dounits(unitind);
    unit_DV=[unit_DV unitz{unitj}];
end

unit_ML=[];    %list ML positions of units.
for unitind=1:length(dounits);
    unitj=dounits(unitind);
    unit_ML=[unit_ML unitx{unitj}];
end


event1_peaklatency=[];    %latency to peak excitatory average firing following event 1.
precuesamples=floor(preeventtime/timebinsize)+1;
for unitind=1:length(dounits);
    unitj=dounits(unitind);      
    rate_event1j=event1_spikerate{unitj}((precuesamples+1):length(event1_spikerate{unitj}));  %exclude the pre-event spike times because latency is only AFTER event onset.        
    maxratetime=find(rate_event1j==max(rate_event1j));  %method 2: calculate latency according to time of max firing rate. note: the latency does not necessarily reflect a statistically significant firing rate.
    latency_event1j=maxratetime(1)*timebinsize;
    event1_peaklatency{unitj}=latency_event1j;  %note: time resolution of latency is set by timebinsize.  
end

event2_peaklatency=[];     %latency to peak excitatory average firing following event 2.
if length(event2times)>0
for unitind=1:length(dounits);
    unitj=dounits(unitind);      
    rate_event2j=event2_spikerate{unitj}((precuesamples+1):length(event2_spikerate{unitj}));  %exclude the pre-event spike times because latency is only AFTER event onset.        
    maxratetime=find(rate_event2j==max(rate_event2j));  %method 2: calculate latency according to time of max firing rate. note: the latency does not necessarily reflect a statistically significant firing rate.
    latency_event2j=maxratetime(1)*timebinsize;
    event2_peaklatency{unitj}=latency_event2j;  %note: time resolution of latency is set by timebinsize.  
end
end

event1_minlatency=[];    %latency to minimum average firing following event 1.
precuesamples=floor(preeventtime/timebinsize)+1;
for unitind=1:length(dounits);
    unitj=dounits(unitind);      
    rate_event1j=event1_spikerate{unitj}((precuesamples+1):length(event1_spikerate{unitj}));  %exclude the pre-event spike times because latency is only AFTER event onset.        
    minratetime=find(rate_event1j==min(rate_event1j));  %method 2: calculate latency according to time of min firing rate. note: the latency does not necessarily reflect a statistically significant firing rate.
    latency_event1j=minratetime(1)*timebinsize;
    event1_minlatency{unitj}=latency_event1j;  %note: time resolution of latency is set by timebinsize.  
end

event2_minlatency=[];     %latency to minimum average firing following event 2.
if length(event2times)>0
for unitind=1:length(dounits);
    unitj=dounits(unitind);      
    rate_event2j=event2_spikerate{unitj}((precuesamples+1):length(event2_spikerate{unitj}));  %exclude the pre-event spike times because latency is only AFTER event onset.        
    minratetime=find(rate_event2j==min(rate_event2j));  %method 2: calculate latency according to time of min firing rate. note: the latency does not necessarily reflect a statistically significant firing rate.
    latency_event2j=minratetime(1)*timebinsize;
    event2_minlatency{unitj}=latency_event2j;  %note: time resolution of latency is set by timebinsize.  
end
end
