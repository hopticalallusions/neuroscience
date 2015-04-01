%created Aug 6 2013
set_plot_parameters

finalmatchSD=2;

plotwaves='n';

%******************************
close all
timestarting=datenum(clock)*60*24;   %starting time in minutes.

load([savedir 'runparameters.mat']);  %loads parameters file.
f_low=parameters.f_low;
f_high=parameters.f_high;

load([savedir 'final_params.mat']);  %loads parameters file.
maxtrial=parameters.maxtrial-1;
bestchannels=parameters.bestchannels;
badchannels=parameters.badchannels;
trialduration=parameters.trialduration;
load([timesdir 'finalspiketimes.mat'])
qualitycutoff=1;
select_dounits

t0=upsamplingfactor+3;
tf=t0+leftpoints+upsamplingfactor;
wavepoints=11;
dojitter=[-2:2]; 

list_bestchans=cell2mat(bestchannels);
list_bestchans=list_bestchans(dounits);
[neworder, orderinds]=sort(list_bestchans);
dounits=dounits(orderinds);   %reorder such that units with same best channel are accessed sequentially.

baretimes=[]; jittertimes=[]; finalspiketimes=[];
templates=[]; alldochannels=[]; shaft=[];
for unitind=1:length(dounits);
    unitj=dounits(unitind);
    bestchan=bestchannels{unitj};
    currentshaft=s.shaft(bestchan);    %added Mar 10 2012.
    channelsonshaft=s.channels(find(s.shaft==currentshaft));

    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unitj) '.mat'])      
      
    shaft{unitj}=currentshaft;
    baretimes{unitj}=[];
    jittertimes{unitj}=[];
    finalspiketimes{unitj}=[];
       
    wavesallchans=[]; dochannels_unitj=[];
    for chan=1:length(waveforms);   %for each channel.  
        disttobestchan=abs(s.z(bestchan)-s.z(chan));            
        if length(waveforms{chan})~=0 & s.shaft(chan)==currentshaft & disttobestchan<maxmergedistance     %modified July 23 2013, so only collect waveforms from channels near the best channel (on the same shaft).
        waveschanj=waveforms{chan}(:,t0:tf);     
        waveschanj=mean(waveschanj);
        waveschanj=interp(waveschanj,upsamplingfactor);
        waveschanj=waveschanj(1:(length(waveschanj)-1));
        wavesallchans=[wavesallchans, waveschanj];
        dochannels_unitj=[dochannels_unitj chan];
        end
     end
     templatej=wavesallchans;
     templates{unitj}=templatej;
     alldochannels{unitj}=dochannels_unitj;
end

figure(1)
close 1
figure(1)

previoustrial=0;  
for trial=1:maxtrial
           
    if trial<10;   %adds '0' to file name is trial<10.
    trialstring=['0' num2str(trial)];
    else trialstring=num2str(trial);
    end      
    datafilename=[rawpath filename '_t' trialstring];  
   
    tic
    previousbestchan=1; previousshaft=1;
    for unitind=1:length(dounits);
        unitj=dounits(unitind);
        bestchan=bestchannels{unitj};
        currentshaft=s.shaft(bestchan);    %added Mar 10 2012.
        channelsonshaft=s.channels(find(s.shaft==currentshaft));

        dochannels=alldochannels{unitj};
        templatej=templates{unitj};
        
        if previoustrial~=trial | currentshaft~=previousshaft
        backgroundchans=origbackgroundchans; 
        backgroundchans=intersect(backgroundchans,channelsonshaft);  
        backgroundchans=setdiff(backgroundchans,badchannels);  
        muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.       
        
        if length(backgroundchans)>0;  %Calculate average signal for background removal.
        backgndsignal_muxi    %calculated only once per channel set per trial.
        clear data     
        else
        backgnddata=0;
        end
        end
      
        if previoustrial~=trial | bestchan~=previousbestchan
        muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting, e.g. mux1 and mux2 for chs 1-64.   
        datadochannels=[]; 
        for muxind=1:length(muxifiles);      
            muxi=muxifiles(muxind);     
            datafile=[datafilename '.mux' num2str(muxi)];   

            fid = fopen(datafile,'r','b');
            data = fread(fid,[1,inf],'int16');    
            fclose(fid);
            data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

            muxichans=dochannels(find(dochannels<(32*muxi+1) & dochannels>32*(muxi-1)))-32*(muxi-1);  %selects only channels in the active muxi file.

                for chanind=1:length(muxichans);
                    channel=muxichans(chanind);
                    absolutechan=muxichans(chanind)+(muxi-1)*32;
                    
                    if mod(muxi,2)==1  %muxi==1
                    datach=data(channel:32:length(data));  %demultiplexing. 
                    elseif mod(muxi,2)==0  %muxi>1
                    channel=channel-1;
                    if channel==0;
                    channel=32;
                    end
                    datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
                    end
              
                    datach=datach-backgnddata-mean(datach);  %subtracts the background channel if backgroundchans were specified.
                    remove_laserartifacts  %optional: removes mean laser artifact found in get_laserartifacts.
     
                    dofilter_muxi

                    datach=1e6*datach;  %convert to microvolts.
                                      
                    if spikedetectionmethod==1
                    detectthreshold=minamplitude;  %round(detectstdev*stdsignal)  %detection threshold voltage.
                    elseif spikedetectionmethod==2
                    stdsignal=prctile(datach,noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes               
                    detectthreshold=round(run_detectstdev*stdsignal);  %detection threshold voltage.
                    end
                
                    if absolutechan==bestchan
                    findpeaktimes_muxi   %finds peak times on one channel.       
                    stimes=spiketimes;   %adds all spiketimes from dochannels into one vector; the same unit may be counted multiple times.
                    end
      
                    datadochannels{absolutechan}=datach; 

                    clear datach;            
                end               
        end
        signalnoise=prctile(datadochannels{bestchan},95);     
    end
    previousbestchan=bestchan;
    previousshaft=currentshaft;
    previoustrial=trial;
               
    numberofspikes=length(stimes);
    if numberofspikes==0  
    continue
    end
   
    matchSDfact=finalmatchSD;
    
    waveforms=[]; unmatchedwaves=[];         
    matches=zeros(1,numberofspikes);
    jittertimes_trialk=[];        
    for i=1:numberofspikes;  
        fromind=stimes(i)-wavepoints;   
        toind=stimes(i)+wavepoints;
        mindist=1e7; firstmatch='y';
        for jitterind=dojitter
            spikeshape=[];
            for chanind=1:length(dochannels);
                channelj=dochannels(chanind);
                datach=datadochannels{channelj};
                   
                waveform=datach(fromind:toind);          
                waveform=interp(waveform,upsamplingfactor);  
                t0_jitt=-jitterind+upsamplingfactor;
                tf_jitt=length(waveform)-jitterind-(upsamplingfactor-1);
                waveformi=waveform(t0_jitt:tf_jitt);          
                spikeshape=[spikeshape, waveformi]; 
            end
            diffwaves=abs(spikeshape-templatej);
            numberviolations=length(find(diffwaves>matchSDfact*signalnoise));
            
            if numberviolations==0 & sum(diffwaves)<mindist
                mindist=sum(diffwaves);
                matches(i)=1;
                
                if firstmatch=='y'
                jittertimes_trialk=[jittertimes_trialk jitterind];
                else jittertimes_trialk(length(jittertimes_trialk))=jitterind;
                end

                if plotwaves=='y' & firstmatch=='y'
                waveforms=[waveforms; spikeshape];
                elseif plotwaves=='y' & firstmatch=='n';
                waveforms(size(waveforms,1),:)=spikeshape;
                end
                
                firstmatch='n';
                
             elseif jitterind==max(dojitter) & numberviolations>0 & plotwaves=='y'
                unmatchedwaves=[unmatchedwaves; spikeshape];    
            end 
        end              
    end  
    foundmatches=find(matches==1);
    baretimes{unitj}=[baretimes{unitj} stimes(foundmatches)+trialduration*(trial-1)];
    jittertimes{unitj}=[jittertimes{unitj} jittertimes_trialk];
    if length(stimes(foundmatches))>0
    timesinseconds=(stimes(foundmatches)+trialduration*(trial-1)+jittertimes_trialk)/samplingrate;
    finalspiketimes{unitj}=[finalspiketimes{unitj} timesinseconds];
    end
    
    if length(foundmatches)>4
        templates{unitj}=max_tempupdatefraction*mean(waveforms)+(1-max_tempupdatefraction)*templates{unitj};
    end
    stimes(foundmatches)=[];
    disp(['unit ' num2str(unitj) ' (' num2str(unitind) ' of ' num2str(length(dounits)) '): ' num2str(length(foundmatches)) '/' num2str(numberofspikes) ' spikes matched in trial ' num2str(trial) '/' num2str(maxtrial) '.'])
    fractionunmatched=1-length(foundmatches)/numberofspikes;
    figure(1)
    hold on
    plot(trial,fractionunmatched, 'o', 'MarkerSize', 2, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
    axis([0.5 maxtrial+0.5 -0.05 1.05])
    xlabel('trial')
    title('fraction of unmatched spikes vs trial number')
    figure(1)
    hold off
    
    if plotwaves=='y'
    figure(2)
    subplot(1,2,1)
    hold off
    plot(waveforms', 'r')
    hold on
    plot(templatej,'k')
    plot(templates{unitj}, 'b')
    subplot(1,2,2)
    hold off
    plot(unmatchedwaves','m')
    hold on
    plot(templatej,'k')
    figure(2)
    input('press enter to continue')
    end
        
    end
    
    clear waveforms datadochannels
    toc        
end        


saveas(figure(1),[savedir 'rerun_unmatched.jpg' ]  ,'jpg')

parameters.shaft=shaft;
save([savedir 'final_params.mat'],'parameters')

spiketimes=finalspiketimes;
save([timesdir 'finalspiketimes.mat'],'spiketimes', '-mat')
save([timesdir 'finalbaretimes.mat'],'baretimes','-mat')
save([timesdir 'finaljittertimes.mat'],'jittertimes','-mat')

f_low=final_f_low;
f_high=final_f_high;    

leftpoints=final_leftpoints-upsamplingfactor;
rightpoints=final_rightpoints+upsamplingfactor;

final_times_to_waves

bestchannel=[]; 
for unitind=1:length(dounits);
    unit=dounits(unitind);     
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])    
    maxamp=0; bestchaninunit=[];
    shaftinuse=parameters.shaft{unit};   %finds the shaft containing these channels; should only be single shaft.
    channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.    
    for j=1:length(channelsonshaft);
        chj=channelsonshaft(j);
        troughamp=abs(min(mean(waveforms{chj})));
        if troughamp>maxamp
            maxamp=troughamp;
            bestchaninunit=chj;
        end
    end
    bestchannel{unit}=bestchaninunit;
end
save([finalwavedir 'bestchannel.mat'],'bestchannel','-mat')

plot_summary_muxi

timeending=datenum(clock)*60*24; %final time in minutes
telapsed=timeending-timestarting;
disp([num2str(telapsed) ' minutes elapsed during rerun_matching.'])