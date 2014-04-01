disp(['get penultimate units'])
set_plot_parameters

%******************
load([timesdir 'spiketimes_n1.mat'])   %load alltimes{unit}{uniteriteration} 
load([savedir 'runparameters.mat']);  %loads parameters file.  

dounits=1:length(alltimes);
    
dounits=setdiff(dounits,dontdounits);
 
filename=parameters.filename;
probetype=parameters.probetype;
samplingrate=parameters.samplingrate;
trialduration=parameters.trialduration;
allcluststdev=parameters.allcluststdev;
samplingrate=parameters.samplingrate;
dotrials=parameters.dotrials;
maxtrial=parameters.maxtrial;
trialduration=parameters.trialduration;
minamplitude=parameters.minamplitude;
numberiterations=length(allcluststdev);
spiketimes=[]; baretimes=[]; jitters=[];
numberoftrials=maxtrial-1;   %omit last trial because it's often not a full trial.
       
timefiles=dir([timesdir 'spiketimes_n*']);
psthisijpgdir=[timesdir 'psth_ISI_jpg\'];
textdir=[timesdir 'text time files\'];
mkdir(psthisijpgdir)
delete([psthisijpgdir, '*.jpg'])
mkdir(textdir)
delete([textdir, '*.txt'])
scrsz=get(0,'ScreenSize');

compare_cluststdev   %plots number of spikes per unit for different allcluststdev values.

for unitind=1:length(dounits);
    uniti=dounits(unitind);
    spiketimes{uniti}=[];  %initialize array;
    baretimes{uniti}=[];
    jittertimes{uniti}=[];
end

for timefileind=1:length(timefiles);
    timefilex=timefiles(timefileind).name;
    jitterfilex=['timejitter_n' num2str(timefileind) '.mat'];
    
    load([timesdir timefilex])   %load alltimes{unit}{uniteriteration}
    load([timesdir jitterfilex]) %load alljitters{unit}{uniteriteration}
    
        
        for unitind=1:length(dounits);
            uniti=dounits(unitind);
            
            for iterj=1:numberiterations;             
            
            if subtract_templates=='y'  %added if statement on October 24 2011.
                if allcluststdev(iterj)>maxcluststdev
                continue
                end 
            elseif subtract_templates=='n'
                if allcluststdev(iterj)~=maxcluststdev
                continue
                end 
            end
            
            timesunitiiterj=(alltimes{uniti}{iterj}); 
            jittersunitiiterj=alljitters{uniti}{iterj};
            if length(jittersunitiiterj)==length(timesunitiiterj)   %modified Feb 26 2013 to fix a rare bug encountered with active data sets.
                  overtimeinds=find(timesunitiiterj/samplingrate>numberoftrials*trialduration/samplingrate);  %removes any times in the very last trial.
                  timesunitiiterj(overtimeinds)=[]; 
                  jittersunitiiterj(overtimeinds)=[]; 
            else  jittersunitiiterj=zeros(size(timesunitiiterj));
            end
           
            
            spiketimes{uniti}=[spiketimes{uniti} (timesunitiiterj+jittersunitiiterj/upsamplingfactor)/samplingrate];
            baretimes{uniti}=[ baretimes{uniti} timesunitiiterj];
            jittertimes{uniti}=[jittertimes{uniti} jittersunitiiterj];
            
            end           
        end       
end
      
for unitind=1:length(dounits);
uniti=dounits(unitind);
[spiketimes{uniti}, sortorder]=sort(spiketimes{uniti});  %sort in proper order.
baretimes{uniti}=baretimes{uniti}(sortorder);
jittertimes{uniti}=jittertimes{uniti}(sortorder);
end


prune_penult_times;   %discards units with insufficient spikes.  note that final_minspikesperunit 
                      %determines lower bound on number of sufficient spikes for unit to survive.

save([timesdir 'penult_spiketimes.mat'],'spiketimes', '-mat')
save([timesdir 'penult_baretimes.mat'],'baretimes','-mat')
save([timesdir 'penult_jittertimes.mat'],'jittertimes','-mat')
  
badunits=[]; %maybebadunits;
save_penultparameters

penult_times_to_waves                 %finds waveforms and amplitudes on all channels on shaft; useful for plotting.
                                    %note: set_plot_parameters contains important settings which affect waveform extraction.
                                    %this subroutine is slow as it must rerun through all raw data.

disp(['finding best channel per unit.'])
bestchannel=[]; 
for unitind=1:length(dounits);
    unit=dounits(unitind); 
    
    load([penultwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    
    maxamp=0; bestchaninunit=[];
    shaftinuse=parameters.shaft{unit};   %finds the shaft containing these channels; should only be single shaft.
    channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.    
    for j=1:length(channelsonshaft);
        chj=channelsonshaft(j);
        troughamp=abs(min(mean(waveforms{chj})));   %use peak trough voltage as the comparison value for best channel identification.
        if troughamp>maxamp
            maxamp=troughamp;
            bestchaninunit=chj;
        end
    end
    bestchannel{unit}=bestchaninunit;
end
save([penultwavedir 'bestchannel.mat'],'bestchannel','-mat')

%plot_penultimate   %removed this step in November 2012 because too time-intensive.    

disp(['done with get_penultimate_units.'])