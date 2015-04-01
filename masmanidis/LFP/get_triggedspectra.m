%This will generate LFP spectrograms and plot them vs time, or aligned to stimuli.
disp(['Making event-triggered LFP power spectrograms.'])

set_plot_parameters

preeventtime=1;               %time in sec to use before event onset.
posteventtime=8;              %default=8. time in sec to use after event onset.

specfreqs=0:1:90;  %frequency bins for LFP power spectrogram setting lower cutoff speeds up program. max range is 0:1:LFPsamplingrate/2;
%************************************************

load([LFPdir 'LFPparams.mat'])
LFPsamplingrate=LFPparameters.samplingrate;

load_results

sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.

timebins=-preeventtime:timebinsize:posteventtime;

dochannels=s.channels;
mkdir(LFPspectrumdir)


for chanind=1:length(dochannels)
    chanj=dochannels(chanind);   
    LFPfile=[LFPvoltagedir 'LFPvoltage_ch' num2str(chanj) '.mat'];
    if exist(LFPfile)
    load(LFPfile);
    else continue
    end
    disp(['*channel ' num2str(chanj)])
    trigged_spectra=[];
    
    background_PSD=[];
    if length(cue1times)==0
        backgrndtimes=[10:20:200];  
         for trialind=1:length(backgrndtimes);     
            trialk=trialind;
            ti=round(backgrndtimes(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end      
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, background_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);    %512,464 gives dt=0.05 s, 512, 417 gives dt=0.1 s.
         end
    end
        
    cue1_PSD=[];   
    if length(cue1times)>0
        for trialind=1:length(cue1times);     
            trialk=trialind;
            ti=round(cue1times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end      
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, cue1_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);    %512,464 gives dt=0.05 s, 512, 417 gives dt=0.1 s.
        end
    end
    
    cue2_PSD=[];
    if length(cue2times)>0
        for trialind=1:length(cue2times);   
            trialk=trialind;
            ti=round(cue2times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end  
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, cue2_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
        end
    end
    
    cue3_PSD=[];
    if length(cue3times)>0
        for trialind=1:length(cue3times);   
            trialk=trialind;
            ti=round(cue3times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end  
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, cue3_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
        end
    end
    
    cue4_PSD=[];
    if length(cue4times)>0
        for trialind=1:length(cue4times);   
            trialk=trialind;
            ti=round(cue4times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end  
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, cue4_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
        end
    end
    
    laser_PSD=[]; 
    if length(pulsetrainstart)>0    
         for trialind=1:length(pulsetrainstart);   
            trialk=trialind;
            ti=round(pulsetrainstart(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end  
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, laser_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
         end
    end
    
    lickepisode_PSD=[];
%     if length(lickepisodetimes)>0
%         for trialind=1:length(lickepisodetimes);   
%             trialk=trialind;
%             ti=round(lickepisodetimes(trialk)*LFPsamplingrate);
%             t0=ti-round(preeventtime*LFPsamplingrate);
%             tf=ti+round(posteventtime*LFPsamplingrate);
%             if t0<1 | tf>length(LFPvoltage) 
%                 continue
%             end  
%             LFPtrialk=LFPvoltage(t0:tf);
%             [S,specfreqs,spectimes, lickepisode_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
%         end
%     end

    endlickepisode_PSD=[];
%     if length(endlickepisodetimes)>0
%         for trialind=1:length(endlickepisodetimes);   
%             trialk=trialind;
%             ti=round(endlickepisodetimes(trialk)*LFPsamplingrate);
%             t0=ti-round(preeventtime*LFPsamplingrate);
%             tf=ti+round(posteventtime*LFPsamplingrate);
%             if t0<1 | tf>length(LFPvoltage) 
%                 continue
%             end  
%             LFPtrialk=LFPvoltage(t0:tf);
%             [S,specfreqs,spectimes, endlickepisode_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
%         end
%     end
    
    solenoid_PSD=[];
    if length(sol1times)>0
        for trialind=1:length(sol1times);   
            trialk=trialind;
            ti=round(sol1times(trialk)*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
                continue
            end  
            LFPtrialk=LFPvoltage(t0:tf);
            [S,specfreqs,spectimes, solenoid_PSD{trialk}]=spectrogram(LFPtrialk,512,417,specfreqs,LFPsamplingrate);  
        end
    end
    
    trigged_spectra.background_PSD=background_PSD;
    trigged_spectra.cue1_PSD=cue1_PSD;
    trigged_spectra.cue2_PSD=cue2_PSD;
    trigged_spectra.cue3_PSD=cue3_PSD;
    trigged_spectra.cue4_PSD=cue4_PSD;
    trigged_spectra.laser_PSD=laser_PSD;
    trigged_spectra.lickepisode_PSD=lickepisode_PSD;
    trigged_spectra.endlickepisode_PSD=endlickepisode_PSD;
    trigged_spectra.solenoid_PSD=solenoid_PSD;
    trigged_spectra.specfreq=specfreqs;
    trigged_spectra.spectimes=spectimes;
    trigged_spectra.preeventtime=preeventtime;
    trigged_spectra.posteventtime=posteventtime;
   
    save([LFPspectrumdir 'trigged_spectra_ch' num2str(chanj) '.mat'], 'trigged_spectra', '-MAT')
    clear cue1_PSD cue2_PSD LFPvoltage trigged_spectra laser_PSD solenoid_PSD lickepisode_PSD solenoid_PSD
    
end

disp(['done getting event-triggered LFP spectra'])