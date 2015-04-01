set_plot_parameters;     %CONTAINS IMPORTANT PARAMETERS THAT AFFECT PLOTTING!

disp(['getting penultimate unit spiketimes to waves; maxcluststdev = ' num2str(maxcluststdev) ', f=' num2str(f_low) '-' num2str(f_high) ' Hz. '])

load([timesdir 'penultimate_params.mat']);  %loads parameters file.
load([timesdir 'penult_spiketimes.mat'])
load([timesdir 'penult_baretimes.mat'])
load([timesdir 'penult_jittertimes.mat'])

if exist([stimulidir 'laserartifacts.mat'],'file')>0 & laser_artifact_removal=='y'
disp(['doing laser artifact removal'])    
load([stimulidir 'laserartifacts.mat'])
end

numberoftrials=maxtrial-1;  
numberof_wavetrials=numberoftrials;

% if dounits=='all';
dounits=1:length(spiketimes);
% end

mkdir(penultwavedir);
delete([penultwavedir '*.mat']);

muxifiles=unique(ceil(plotchannels/32));  %specifies which dot muxi files to open for plotting

wavefilecounter=[]; waveforms=[]; appendmorespikes=[]; %initialize waveform array.
for i=1:length(dounits);
    uniti=dounits(i);
    wavefilecounter(uniti)=1;
    appendmorespikes{uniti}='y';
    for j=1:length(plotchannels);
        chanjx=plotchannels(j);
        waveforms{chanjx}=[];
    end
    save([penultwavedir 'waveforms_i' num2str(wavefilecounter(uniti)) '_cl' num2str(uniti) '.mat'],'waveforms', '-mat');  %saves empty file.   
end
   
for iterations=1:numberof_wavetrials;
tic
trial=dotrials(iterations);
disp(['trial ' num2str(trial) ' of ' num2str(numberof_wavetrials)])

    if trial<10
    datafilename=[rawpath filename '_t0' num2str(trial)];
    else
    datafilename=[rawpath filename '_t' num2str(trial)];
    end
      
    alldata=[]; nofilecounter=0;                    
    for i=1:length(muxifiles);
    
        muxi=muxifiles(i);     
        datafile=[datafilename '.mux' num2str(muxi)];   
        if exist(datafile,'file')==0   %introduced this if...then clause on June 21 2012 to handle situation where we don't save all muxi files corresponding to a specific probe type.
            nofilecounter=nofilecounter+1;
            continue
        end

        if nofilecounter==length(muxifiles)
            break
        end
        
        fid = fopen(datafile,'r','b');
        data = fread(fid,[1,inf],'int16');    
        fclose(fid);
        data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

        muxichans=plotchannels(find(plotchannels<(32*muxi+1) & plotchannels>32*(muxi-1)))-32*(muxi-1);
        previousbackgroundchans=[];
        for chanind=1:length(muxichans);
            channel=muxichans(chanind);
            origchannel=channel;
            absolutechan=muxichans(chanind)+(muxi-1)*32;
                                    
            currentshaft=s.shaft(absolutechan);
            chansonshaft=s.channels(find(s.shaft==currentshaft));
            backgroundchans=intersect(chansonshaft,plotbackgroundchans);
            muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.
            
            if length(setdiff(backgroundchans,previousbackgroundchans))>0  %only loads new backgroundchannels if the channel is on a different shaft.
                if length(plotbackgroundchans)>0;
                backgndsignal_muxi
                else
                backgnddata=0;
                end   
            end
            
            previousbackgroundchans=backgroundchans;
            
            channel=origchannel;
            muxi_numbering
 
            datach=datach-backgnddata-mean(datach);  %subtracts the background channel if backgroundchans were specified.
            remove_laserartifacts  %optional: removes mean laser artifact found in get_laserartifacts.
            
            dofilter_muxi

            datach=1e6*datach;  %converts data to microvolts.
            alldata{absolutechan}=datach; 
            clear datach 
            
        end       
        
        if nofilecounter==length(muxifiles)
            maxtrial=trial-1;
            load([savedir 'runparameters.mat']);  %loads parameters file.  
            parameters.maxtrial=maxtrial;
            save([savedir 'runparameters.mat'],'parameters')
            load([timesdir 'penultimate_params.mat']);  %loads parameters file.
            parameters.maxtrial=maxtrial;
            save([timesdir 'penultimate_params.mat'],'parameters')
            disp(['last trial is ' num2str(maxtrial) '.'])
            break
        end
        
    end
    
                  
    for unitind=1:length(dounits);
        unit=dounits(unitind);
            
        if appendmorespikes{unit}=='y'    %added if clause on November 7 2011 to place an upper bound on number of collected waves, which takes a long time.
                        
        bestchaninunit=parameters.bestchannel{unit};
            
        shaftinuse=s.shaft(bestchaninunit);   %finds the shaft containing these channels; should only be single shaft.
        channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.
                                    
        stimes=baretimes{unit};
        wavejitters=jittertimes{unit};
            
        pointsintrial=find(stimes<(trial*trialduration) & stimes>=((trial-1)*trialduration));
        timesintrial=stimes(pointsintrial)-(trial-1)*trialduration;      
        jittersintrial=wavejitters(pointsintrial);
                     
        if length(pointsintrial)>plotmax_penult
            pointsintrial=pointsintrial(1:plotmax_penult);
            timesintrial=timesintrial(1:plotmax_penult);
            jittersintrial=jittersintrial(1:plotmax_penult);      
        elseif length(pointsintrial)==0   
            continue   %skip to next unit
        end
         
        wavefile=dir([penultwavedir 'waveforms_i' num2str(wavefilecounter(unit)) '_cl' num2str(unit) '.mat']);   %load & initialize waveform file.   
        if wavefile.bytes<maxwavesize;                    
        load([penultwavedir 'waveforms_i' num2str(wavefilecounter(unit)) '_cl' num2str(unit) '.mat']);          
        else                       
        wavefilecounter(unit)=wavefilecounter(unit)+1;        
        clear waveforms; waveforms=[];  %initialize waveform array.            
        	for j=1:length(plotchannels);
                chanjx=plotchannels(j);
                waveforms{chanjx}=[];                   
            end                     
        end 
                        
        for chanind=1:length(plotchannels)
            absolutechan=plotchannels(chanind);
            
            if length(find(channelsonshaft==absolutechan))==0   %only plots channels on the same shaft.
            continue
            end
                                                  
            wavesunitichanj=[]; 
            for timeind=1:length(timesintrial);
                fromind=timesintrial(timeind)-(leftpoints+extraleft-1);  %added 12 on 2/12/11 because of jitter compensation; this number must match t0 & tf constant
                toind=timesintrial(timeind)+(rightpoints+extraright-1);
                      
                if fromind<1 | toind>length(alldata{absolutechan})
                    continue
                end
            
                waveformi=alldata{absolutechan}(fromind:toind);
              
                waveformi=interp(waveformi,upsamplingfactor);
            
                t0=-jittersintrial(timeind)+(2+extraleft)*upsamplingfactor;                    % t0=-wavejitter(i)+3*upsamplingfactor;
                tf=length(waveformi)-jittersintrial(timeind)-(extraright)*upsamplingfactor;    % tf=length(waveformi)-wavejitter(i)-upsamplingfactor;
              
                waveformi=waveformi(t0:tf);   %aligned waveform.         
                
                waveformi=decimate(waveformi,upsamplingfactor); 
                           
                waveformi=waveformi; %-min(abs(waveformi));  %dc offset removal added Nov 7 2011.
                wavesunitichanj=[wavesunitichanj; waveformi];
                                
             end
                
             waveforms{absolutechan}=[waveforms{absolutechan}; wavesunitichanj];  
                              
        end
                  
        save([penultwavedir 'waveforms_i' num2str(wavefilecounter(unit)) '_cl' num2str(unit) '.mat'],'waveforms', '-mat')
            
        end 
           
        if length(find(stimes<(trial*trialduration)))>=plotmax_penult   %added November 7 2011; if 'n' then in the next trial won't append any more waves for this uniter.
%         disp(['stopped appending waves for unit ' num2str(unit) ', because already appended at least ' num2str(plotmax_penult) ' spikes.'])
        appendmorespikes{unit}='n';       %note: plotmax_penult is specified in set_plot_parameters
        end

    end
     
clear waveforms alldata
toc        
end
        
