disp(['Getting spike-LFP modulation indices as a function of both frequency band and amplitude threshold'])

set_plot_parameters

triggerevent1='LFP';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP'.  Selecting 'LFP' will use the entire LFP trace.

trialselection1='all';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
                            
laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
                            
min_LFP_freq=2;
max_LFP_freq=90;
df=4;

LFPthreshold_values=[50:25:200]; %peak detection threshold expressed in microvolts.

% LFPthreshold_values=[2:1:7];  %peak detection threshold expressed as number of SDs.

peripktime=0.5;              %collects spikes +/-peripktime from LFP peak.
timebinsize=0.002;

preeventtime=3;               %time in sec to use for detecting LFP peaks before event onset.  not used if triggerevent='LFP'
posteventtime=4;              %time in sec to use for detecting LFP peaks after event onset.   not used if triggerevent='LFP'
                             
%************************************************
triggerevent2='none';  %currently not in use here.
triggerevent3='none';  %currently not in use here.  
trialselection2='all';  %currently not in use here.
trialgroupsize=10;  %currently not in use here.   

load_results

LFPfreqs=min_LFP_freq:df:max_LFP_freq;
timebins=-peripktime:timebinsize:peripktime;

select_triggers_trials 

modulationdatadir=[modulationdir 'data\'];
mkdir(modulationdatadir);
% delete([modulationdatadir '*.*'])

chanswithunits=cell2mat(bestchannels);
chanswithunits=unique(chanswithunits(dounits));    

spikeLFPmod=[];
for freqind=1:(length(LFPfreqs)-1);
    f_low_LFP=LFPfreqs(freqind);
    f_high_LFP=LFPfreqs(freqind+1);
    meanfrequency=round(mean([f_low_LFP f_high_LFP]));
    disp(['filtering from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])
      
    FTA_spiketimes=[]; FTA_spikerate=[]; modulationindex=[]; peakmodphaseoffset=[];   
    for chanind=1:length(chanswithunits);    %collecting LFP peak times for all specified electrode channels.
        chan=chanswithunits(chanind);
        
        currentvoltagefile=['LFPvoltage_ch' num2str(chan) '.mat'];
        load([LFPvoltagedir currentvoltagefile]); 
        dofilter_LFP
        
        meanpower=mean(LFPvoltage.^2);
        spikeLFPmod.meanpower{freqind}{chan}=meanpower;
        stdLFPvoltage=std(LFPvoltage);      
        
        for threshind=1:length(LFPthreshold_values)
            minLFPthreshold=LFPthreshold_values(threshind);
%             maxLFPthreshold=LFPthreshold_values(threshind+1);
            
            minLFPdetectthreshold=minLFPthreshold %*stdLFPvoltage;     %detect LFP peaks on lower bound on of threshold. note: the lower the threshold, the more the number of detected peaks.   
            [pks,LFPpktimes_lowerbound]=findpeaks(LFPvoltage,'minpeakheight',minLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));              
%             maxLFPdetectthreshold=maxLFPthreshold %*stdLFPvoltage;  %detect LFP peaks on upper bound on of threshold. %upperbound peaks are fewer than lowerbound peaks.
%             [pks, LFPpktimes_upperbound]=findpeaks(LFPvoltage,'minpeakheight',maxLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));      
%             LFPpktimes=setdiff(LFPpktimes_lowerbound,LFPpktimes_upperbound);  %get the LFP peaks that have amplitude >minLFPthreshold and <maxLFPthreshold.
            LFPpktimes=LFPpktimes_lowerbound;

            if strmatch(triggerevent1,'LFP','exact')==0
            allevent1_LFPpktimes=[];
            for trialind=1:length(doevent1trials)
                trial=doevent1trials(trialind);       
                ti=event1times(trial);
                t0=ti-preeventtime;
                tf=ti+posteventtime;
                if t0<1 | tf>length(LFPvoltage) 
                continue
                end
                perieventLFPpeaksi=LFPpktimes(find((LFPpktimes/LFPsamplingrate)<=tf & (LFPpktimes/LFPsamplingrate)>t0));
                allevent1_LFPpktimes=[allevent1_LFPpktimes perieventLFPpeaksi];                 %collects LFP peak times across all event trials. units in LFP samples.
            end
            LFPpktimes=allevent1_LFPpktimes;
            end
%           spikeLFPmod.LFPpktimes{chan}{freqind}=LFPpktimes;  %if triggerevent='LFP' then use all the LFP peak times.
            disp(['channel ' num2str(chan) ', detected ' num2str(length(LFPpktimes)) ' peaks with threshold > ' num2str(minLFPthreshold) ' SD.'])
         
            for unitind=1:length(dounits);
                unitj=dounits(unitind);
                FTA_spiketimes{unitj}=[]; 
                if bestchannels{unitj}==chan;   %only calculate modulation for the best channel of each unit
                stimesunitj=spiketimes{unitj};
                for i=1:length(LFPpktimes);
                    ti=LFPpktimes(i)/LFPsamplingrate;
                    t0=ti-peripktime;
                    tf=ti+peripktime;
                    trigtimesj=stimesunitj(find(stimesunitj<=tf & stimesunitj>t0));
                    if length(trigtimesj)>0
                    reltimesj=trigtimesj-ti;  %realign times to local LFP peak.
                    FTA_spiketimes{unitj}=[FTA_spiketimes{unitj} reltimesj];     
                    end
                end
            
                if length(FTA_spiketimes{unitj})>1
                    FTA_spikerate{threshind}{unitj}=histc(FTA_spiketimes{unitj},timebins)/length(LFPpktimes)/timebinsize;  %binned histogram in units of Hz (average firing rate)
                    FTA_spikerate{threshind}{unitj}=FTA_spikerate{threshind}{unitj}(1:(length(FTA_spikerate{threshind}{unitj})-1)); 
                    FTA_spikerate{threshind}{unitj}=smooth(FTA_spikerate{threshind}{unitj},5);  %note smoothing kernel size.
                    if mean([FTA_spikerate{threshind}{unitj}(1:25)])>0
                        modulationindex{threshind}{unitj}=(max(abs(FTA_spikerate{threshind}{unitj}))-mean(FTA_spikerate{threshind}{unitj}(1:25)))/std([FTA_spikerate{threshind}{unitj}(1:25)]);   %modulation index defined as a z-score.
                        peakmodind=find(FTA_spikerate{threshind}{unitj}==max(FTA_spikerate{threshind}{unitj}));
                        peakmodtimeoffset=peakmodind(1)-round(peripktime/timebinsize); 
                        peakmodphaseoffset{threshind}{unitj}=360*(peakmodtimeoffset/LFPsamplingrate*meanfrequency);   %phase offset in degrees.    
                    else modulationindex{threshind}{unitj}=0; peakmodphaseoffset{threshind}{unitj}=0;
                    end
                else modulationindex{threshind}{unitj}=0; peakmodphaseoffset{threshind}{unitj}=0;
                end
                                       
                end                  
            end        
            
            spikeLFPmod.LFPthresh{threshind}=minLFPthreshold;   
            
        end
    end

    spikeLFPmod.f_low_LFP{freqind}=f_low_LFP;
    spikeLFPmod.f_high_LFP{freqind}=f_high_LFP;
    spikeLFPmod.meanfrequency{freqind}=meanfrequency;
    spikeLFPmod.FTA_spikerate{freqind}=FTA_spikerate;  %can use this to recalculate the modulation indices if don't like the above definition.
    spikeLFPmod.modulationindex{freqind}=modulationindex;
    spikeLFPmod.peakmodphaseoffset{freqind}=peakmodphaseoffset;
end

spikeLFPmod.min_LFP_freq=min_LFP_freq;
spikeLFPmod.max_LFP_freq=max_LFP_freq;
spikeLFPmod.df=df;
spikeLFPmod.LFPthreshold_values=LFPthreshold_values;
spikeLFPmod.triggerevent1=triggerevent1;
spikeLFPmod.trialselection1=trialselection1;
spikeLFPmod.trialselection2=trialselection2;
spikeLFPmod.preeventtime=preeventtime;
spikeLFPmod.posteventtime=posteventtime;
spikeLFPmod.peripktime=peripktime;
spikeLFPmod.timebinsize=timebinsize;
spikeLFPmod.timebins=timebins;

save([modulationdatadir 'spikeLFPmod.mat'],'spikeLFPmod','-mat')


%plotting....
plot_thresh=3; %used in modulation_vsfreq
plot_freq=40;  %used in modulation_vsamp

modulation_vsfreq=[]; modulation_vsamp=[];
for unitind=1:length(dounits);
    unitj=dounits(unitind);     
    modulation_vsfreq{unitj}=[];
    modulation_vsamp{unitj}=[];
end

meanfreqs=cell2mat(spikeLFPmod.meanfrequency);
LFPthresh=cell2mat(spikeLFPmod.LFPthresh);

plot_threshind=find(LFPthresh==plot_thresh);
for freqind=1:length(meanfreqs)
    for unitind=1:length(dounits);
        unitj=dounits(unitind); 
        bestchan=bestchannels{unitj};
        modulation_vsfreq{unitj}=[modulation_vsfreq{unitj}  spikeLFPmod.modulationindex{freqind}{plot_threshind}{unitj}/spikeLFPmod.meanpower{freqind}{bestchan}];   %normalize by the mean power (uV^2) at that channel.
    end
end

modulation_vsfreq_stack=[]; 
for unitind=1:length(dounits);
    unitj=dounits(unitind);   
    modulation_vsfreq_stack=[modulation_vsfreq_stack; modulation_vsfreq{unitj}];
end

plot_freqind=find(meanfreqs==plot_freq);
for threshind=1:length(LFPthresh)
    for unitind=1:length(dounits)
        unitj=dounits(unitind);
        bestchan=bestchannels{unitj};
        modulation_vsamp{unitj}=[modulation_vsamp{unitj}  spikeLFPmod.modulationindex{plot_freqind}{threshind}{unitj}/spikeLFPmod.meanpower{freqind}{bestchan}];   %normalize by the mean power (uV^2) at that channel.
    end
end
    
modulation_vsamp_stack=[]; 
for unitind=1:length(dounits);
    unitj=dounits(unitind);   
    modulation_vsamp_stack=[modulation_vsamp_stack; modulation_vsamp{unitj}];
end
    

figure(1)
close 1
figure(1)
subplot(2,1,1)
plot(meanfreqs, modulation_vsfreq_stack,'r')
hold on
plot(meanfreqs, mean(modulation_vsfreq_stack),'k','LineWidth',2)
xlabel('mean frequency (Hz)')
ylabel('rate modulation index ')
title('norm rate modulation vs frequency')

subplot(2,1,2)
plot(LFPthresh, modulation_vsamp_stack,'r')
hold on
plot(LFPthresh, mean(modulation_vsamp_stack),'k','LineWidth',2)
xlabel('mean frequency (Hz)')
ylabel('rate modulation index')
title('norm rate modulation vs detection threshold (# SDs)')

saveas(figure(1),[modulationdir 'spikeLFP_modulation.jpg' ]  ,'jpg')
saveas(figure(1),[modulationdir 'spikeLFP_modulation.eps' ]  ,'psc2')
saveas(figure(1),[modulationdir 'spikeLFP_modulation.fig' ]  ,'fig')

disp(['done with spike-LFP modulation'])

 