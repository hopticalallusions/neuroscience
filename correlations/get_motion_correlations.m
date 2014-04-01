disp(['Finding Pearson correlation coefficients and data bin-shuffled p values for event-triggered spiking (combine all trials into 1D vector).'])

set_plot_parameters

spikes_or_bursts='s';       %'s' will use spikes, 'b' will use burst episodes.

timebinsize=0.05;           %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.                         

permute_iterations=1000;    %default=1000. number of iterations to run for corr. coef. permutation test (randomly shuffle binned firing rates without replacement).
                             
%************************************************
close all
triggerevent2='none';   %options: 'none'.                                
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.
triggerevent3='none';  %options: 'none'.    

load_results

select_triggers_trials 

if spikes_or_bursts=='b'
slow_or_rapid_bursts
end

if strcmp(triggerevent1, 'allspikes')
doevent1trials=1;
longtimebins=0:timebinsize:recordingduration;  %time bins used for converting firing rate from all trials into a 1D column vector.
disp(['calculating correlation coefficients using firing rates over the entire recording session.'])
else longtimebins=0:timebinsize:(length(doevent1trials)*(posteventtime-preeventtime));  %time bins used for converting firing rate from all trials into a 1D column vector.
end

trigrates=[];
for unitind=1:length(dounits)
   unitj=dounits(unitind);
   if spikes_or_bursts=='s'
   stimesj=spiketimes{unitj};  
   elseif spikes_or_bursts=='b'
   stimesj=bursts{unitj};
   end
   if length(stimesj)==0
       continue
   end
   
   trigtimesj=[];
   
   if strcmp(triggerevent1, 'allspikes')
   trigtimesj=stimesj(find(stimesj>0 & stimesj<recordingduration));
   else   
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);
            t0=event1times(trialk); 
            spikeinds=find(stimesj<(t0+posteventtime) & stimesj>(t0-preeventtime));
            rel_spiketimes=stimesj(spikeinds)-t0;
            trigtimesj=[trigtimesj, rel_spiketimes+(trialind-1)*(posteventtime-preeventtime)];                 
        end  
   end
   trigrates{unitj}=histc(trigtimesj,longtimebins)/timebinsize;  %firing rate constructed from serially adding all trials rather than doing average over all trials (i.e. convert rate into a column vector)
end
      
%calculates Pearson correlation coefficient vs pairwise unit distance. Note: property of Pearson corr coeff is scale invariance, i.e. can transform rate x by ax+b and rate y to cx+d without affecting the correlation coefficient.
eventtrig_corrcoef=[]; corrcoef_pvalue=[]; 
tic
for unitindi=1:length(dounits);
    uniti=dounits(unitindi);   
    trigratei=trigrates{uniti};  %column vector of firing rates constructed by serially combining all trials.
    disp(['calculating Pearson correlation coefficients for unit ' num2str(uniti) ' (' num2str(unitindi) ' of ' num2str(length(dounits)) ').'])
    for unitindj=1:length(dounits);
        unitj=dounits(unitindj);                    

        if uniti==unitj
            eventtrig_corrcoef{uniti}{unitj}=1;
            corrcoef_pvalue{uniti}{unitj}=0;
            continue
        elseif uniti>unitj
            eventtrig_corrcoef{uniti}{unitj}=eventtrig_corrcoef{unitj}{uniti};
            corrcoef_pvalue{uniti}{unitj}=corrcoef_pvalue{unitj}{uniti};
            continue
        elseif length(trigrates{uniti})==0 | length(trigrates{unitj})==0
            eventtrig_corrcoef{uniti}{unitj}=[];
            corrcoef_pvalue{uniti}{unitj}=[];
            continue
        end
                 
        trigratej=trigrates{unitj};  %column vector of firing rates constructed by serially combining all trials.
     
        [trig_cindexij,p]=corrcoef(trigratei,trigratej);   %Pearson correlation coefficient. this is equivalent to trig_cindexij above. p-value is calculated using built-in t-test function.
        trig_cindexij=trig_cindexij(1,2);
        eventtrig_corrcoef{uniti}{unitj}=trig_cindexij;   %pairwise correlation coefficient using only the peri-event-triggered rate.
                 
        permute_ccoef=[];  %permutation test for calculating p-values. very slow!
        for i=1:permute_iterations;
            x=randsample(length(trigratej),length(trigratej));
            ccoefi=corrcoef(trigratei,trigratej(x));
            permute_ccoef=[permute_ccoef ccoefi(2)];
        end
        permute_pvalue=length(find(abs(permute_ccoef)>eventtrig_corrcoef{uniti}{unitj}))/length(permute_ccoef);
        corrcoef_pvalue{uniti}{unitj}=permute_pvalue;         
    end
    
end
toc

pearson_cc=[];
pearson_cc.subject=subject;
pearson_cc.triggerevent1=triggerevent1;
pearson_cc.trialselection1=trialselection1;
pearson_cc.timebinsize=timebinsize;
pearson_cc.preeventtime=preeventtime;
pearson_cc.posteventtime=posteventtime;
pearson_cc.permute_iterations=permute_iterations;
pearson_cc.eventtrig_corrcoef=eventtrig_corrcoef;
pearson_cc.corrcoef_pvalue=corrcoef_pvalue;

save([savedir 'pearson_cc.mat'], 'pearson_cc', '-mat')

disp(['Done calculating pairwise event-triggered Pearson correlation coefficients.'])

