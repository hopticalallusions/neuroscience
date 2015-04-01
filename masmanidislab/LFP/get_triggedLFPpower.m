disp(['Finding event-triggered LFP power.'])

set_plot_parameters

filterLFP='y';              %filter LFP signals using f_low_LFP and f_high_LFP
n_LFP=3;
f_low_LFP=35;              
f_high_LFP=45;             
                           %Theta:6-10 Hz  (definition: 4-7 Hz)
                           %Beta: 15-28 Hz.  (definition: 12-30 Hz).
                           %Low Gamma: 45-55 Hz.  

timebinsize=0.1;           %default=0.1 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.
preeventtime=1;               %time in sec to use before event onset.
posteventtime=8;              %time in sec to use after event onset.

%************************************************

load([LFPdir 'LFPparams.mat'])
LFPsamplingrate=LFPparameters.samplingrate;

load_results

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

timebins=-preeventtime:timebinsize:posteventtime;

dochannels=s.channels;
currentLFPpwrdir=[LFPtriggedpowerdir num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz\'];
mkdir(currentLFPpwrdir)

alleventtimes=[cue1times cue2times sol1times pulsetrainstart lickepisodetimes];
maxtime=(parameters.maxtrial-1)*trialduration/samplingrate;

if filterLFP=='n'
disp(['**note: no LFP filtering is applied.**'])
else disp(['filtering LFP from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])
end


for chanind=1:length(dochannels)
    chanj=dochannels(chanind);   
    LFPfile=[LFPvoltagedir 'LFPvoltage_ch' num2str(chanj) '.mat'];
    if exist(LFPfile)
    load(LFPfile);
    else continue
    end
    disp(['*channel ' num2str(chanj)])
    
    dofilter_LFP
    trigged_LFPpower=[];
    LFPpowerchanj=LFPvoltage.^2;
    cue1_LFPpower=[]; 
    if length(cue1times)>0
        for trialind=1:length(cue1times);     
            trialk=trialind;  
            ti=round(cue1times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            cue1_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
     
    cue2_LFPpower=[]; 
    if length(cue2times)>0
        for trialind=1:length(cue2times);   
            trialk=trialind;  
            ti=round(cue2times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            cue2_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
    
    cue3_LFPpower=[]; 
    if length(cue3times)>0
        for trialind=1:length(cue3times);   
            trialk=trialind;  
            ti=round(cue3times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            cue3_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
    
    cue4_LFPpower=[]; 
    if length(cue4times)>0
        for trialind=1:length(cue4times);   
            trialk=trialind;  
            ti=round(cue4times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            cue4_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
    
    laser_LFPpower=[]; 
    if length(pulsetrainstart)>0
        for trialind=1:length(pulsetrainstart);   
            trialk=trialind;  
            ti=round(pulsetrainstart(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            laser_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
    
    lickepisode_LFPpower=[]; 
    if length(lickepisodetimes)>0
        for trialind=1:length(lickepisodetimes);   
            trialk=trialind;  
            ti=round(lickepisodetimes(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            lickepisode_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end

    endlickepisode_LFPpower=[]; 
%     if length(endlickepisodetimes)>0
%         for trialind=1:length(endlickepisodetimes);   
%             trialk=trialind;  
%             ti=round(endlickepisodetimes(trialk)*LFPsamplingrate);
%             t0=ti-round(preeventtime*LFPsamplingrate);
%             tf=ti+round(posteventtime*LFPsamplingrate);
%             if t0<1 | tf>length(LFPvoltage) 
%                 continue
%             end
%             smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
%             endlickepisode_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
%         end
%     end
    
    solenoid_LFPpower=[]; 
    if length(sol1times)>0
        for trialind=1:length(sol1times);   
            trialk=trialind;  
            ti=round(sol1times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            solenoid_LFPpower{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
    
    background_LFPpower=[];
    time0=0;
    for timei=10:10:maxtime
        if length(find(abs(timei-alleventtimes)<10))==0
            noneventtimesi=round(time0*LFPsamplingrate+1):round(timei*LFPsamplingrate+1);
            noneventtimesi=noneventtimesi(find(noneventtimesi<length(LFPpowerchanj)));
            background_LFPpower=[background_LFPpower LFPpowerchanj(noneventtimesi)];
        end
        time0=timei;
    end
    
    if isthis_VR=='y' 
    trigged_LFPpower.room1entries=[];
        for trialind=1:length(roomentries{1});   
            trialk=trialind;  
            ti=round(roomentries{1}(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            trigged_LFPpower.room1entries{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
        
    trigged_LFPpower.room2entries=[];
        for trialind=1:length(roomentries{2});   
            trialk=trialind;  
            ti=round(roomentries{2}(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            trigged_LFPpower.room2entries{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
        
    trigged_LFPpower.room3entries=[];
        for trialind=1:length(roomentries{3});   
            trialk=trialind;  
            ti=round(roomentries{3}(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            trigged_LFPpower.room3entries{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end 
        
    trigged_LFPpower.room4entries=[];
        for trialind=1:length(roomentries{4});   
            trialk=trialind;  
            ti=round(roomentries{4}(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end
            smoothsize=round(length(LFPpowerchanj(t0:tf))/length(timebins));
            trigged_LFPpower.room4entries{trialk}=decimate(LFPpowerchanj(t0:tf),smoothsize);
        end
    end
    
    trigged_LFPpower.cue1_LFPpower=cue1_LFPpower;
    trigged_LFPpower.cue2_LFPpower=cue2_LFPpower;
    trigged_LFPpower.cue3_LFPpower=cue3_LFPpower;
    trigged_LFPpower.cue4_LFPpower=cue4_LFPpower;
    trigged_LFPpower.laser_LFPpower=laser_LFPpower;
    trigged_LFPpower.lickepisode_LFPpower=lickepisode_LFPpower;
    trigged_LFPpower.endlickepisode_LFPpower=endlickepisode_LFPpower;
    trigged_LFPpower.solenoid_LFPpower=solenoid_LFPpower;
    trigged_LFPpower.f_low_LFP=f_low_LFP;
    trigged_LFPpower.f_high_LFP=f_high_LFP;
    trigged_LFPpower.timebins=timebins;
    trigged_LFPpower.background_LFPpower=background_LFPpower;
   
    save([currentLFPpwrdir 'trigged_power_ch' num2str(chanj) '.mat'], 'trigged_LFPpower', '-MAT')
     
end

disp('done')