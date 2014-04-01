['plots the psth for each unique grating angle.']

set_plot_parameters

select_dounits

vis_stim_psthbinsize=0.02;
vis_stim_lefttime=1;
vis_stim_righttime=3;

load([LFPdir 'LFPparams.mat'])
load([timesdir 'finalspiketimes.mat'])
load([timesdir 'final_params.mat']);  %loads parameters file.
load([stimuli 'stimuli.mat'])

LFPsamplingrate=LFPparameters.samplingrate;
trialstarttimes=stimuli.trialstarttimes;
anglepertrial=stimuli.anglepertrial;
uniqueangles=unique(anglepertrial);

close all

allpsth=[];
for unitind=1:length(dounits);
    unit=dounits(unitind);
    stimes=spiketimes{unit};
    
    figure(1)

    for i=1:length(uniqueangles)
        anglei=uniqueangles(i);
        trialswithangle=find(anglepertrial==anglei);
    
        alltimes=[];
        for trialind=1:length(trialswithangle);
            trialj=trialswithangle(trialind);
            t0=trialstarttimes(trialj);
            stimestrialj=stimes(find(stimes>(t0-vis_stim_lefttime) & stimes<(t0+vis_stim_righttime)))-t0;
            alltimes=[alltimes stimestrialj];
        end
    
        psth=histc(alltimes,[-vis_stim_lefttime:vis_stim_psthbinsize:vis_stim_righttime])/vis_stim_psthbinsize;
        psth=smooth(psth,3);
        time=[-vis_stim_lefttime:vis_stim_psthbinsize:vis_stim_righttime];
        subplot(length(uniqueangles),1,i)
        plot(time,psth)
        
        allpsth=[allpsth, psth];

    end
    
    saveas(figure(1),[spikeLFPjpgdir 'vis_stim_psth_c' num2str(unit) '.jpg' ]  ,'jpg')
    saveas(figure(1),[spikeLFPepsdir 'vis_stim_psth_c' num2str(unit) '.eps' ]  ,'psc2')
    saveas(figure(1),[spikeLFPmfigdir 'vis_stim_psth_c' num2str(unit) '.fig' ]  ,'fig')
 
end

close 1
    