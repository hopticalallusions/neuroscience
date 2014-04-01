['collecting spike-triggered averages (STA) of e-phys data.']
%STA can be used to assess spike-LFP coherence (cf Fries & Desimone, Science 2001).

    
set_plot_parameters

dochannels=[1:length(s.y)];
%************************************************

load([LFPdir 'LFPparams.mat'])
load([timesdir 'finalspiketimes.mat'])
load([timesdir 'finalbaretimes.mat'])
load([timesdir 'finaljittertimes.mat'])    
load([timesdir 'final_params.mat']);  %loads parameters file.

trialduration=parameters.trialduration;
maxtrial=parameters.maxtrial;    
numberoftrials=maxtrial-1;  
numberof_wavetrials=numberoftrials;

select_doclusters

dochannels=setdiff(dochannels,badchannels);

mkdir(STAdir);
delete([STAdir '*.mat']);

muxifiles=unique(ceil(plotchannels/32));  %specifies which dot muxi files to open for plotting
muxibackgndfiles=unique(ceil(plotbackgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.

wavefilecounter=[]; STA=[]; appendmorewaves=[];  %initialize spike-triggered average waveform for each unit and channel.
for i=1:length(doclusters);
    clusti=doclusters(i);
    wavefilecounter(clusti)=1;
    appendmorewaves{clusti}='y';
    for j=1:length(plotchannels);
        chanjx=plotchannels(j);
        STA{chanjx}=[];
    end
    save([STAdir 'STA_i' num2str(wavefilecounter(clusti)) '_cl' num2str(clusti) '.mat'],'STA', '-mat');  %saves empty file.   
end


for iterations=1:numberof_wavetrials;
tic
trial=dotrials(iterations);
['trial ' num2str(trial) ' of ' num2str(numberof_wavetrials)]

    if trial<10
    datafilename=[rawpath filename '_t0' num2str(trial)];
    else
    datafilename=[rawpath filename '_t' num2str(trial)];
    end

    backgroundchans=plotbackgroundchans;
    if length(plotbackgroundchans)>0;
    backgndsignal_muxi
    else
    backgnddata=0;
    end   
      
    alldata=[];                        
    for i=1:length(muxifiles);
    
        muxi=muxifiles(i);     
        datafile=[datafilename '.mux' num2str(muxi)];   

        fid = fopen(datafile,'r','b');
        data = fread(fid,[1,inf],'int16');    
        fclose(fid);
        data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

        muxichans=plotchannels(find(plotchannels<(32*muxi+1) & plotchannels>32*(muxi-1)))-32*(muxi-1);
        for chanind=1:length(muxichans);
            channel=muxichans(chanind);
            absolutechan=muxichans(chanind)+(muxi-1)*32;
                         
            if muxi==1
            datach=data(channel:32:length(data));  %demultiplexing. 
            elseif muxi>1   
            channel=channel-1;
            if channel==0;
            channel=32;
            end
            datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
            end
            datach=datach-backgnddata-mean(datach);  %subtracts the background channel if backgroundchans were specified.
   
            old_f_low=f_low;
            old_f_high=f_high;
            f_low=STA_f_low;
            f_high=STA_f_high;
           
            dofilter_muxi  %filtering to remove local dc offsets.
           
            f_low=old_f_low;
            f_high=old_f_high;

            datach=1e6*datach;  %converts data to microvolts.
            alldata{absolutechan}=datach; 
            clear datach 
            
        end       
        
    end
    
                  
    for clustind=1:length(doclusters);
        clust=doclusters(clustind);
            
        if appendmorewaves{clust}=='y'    %added if clause on November 7 2011 to place an upper bound on number of collected waves, which takes a long time.
                         
        shaftinuse=parameters.shaft{clust};   %finds the shaft containing these channels; should only be single shaft.
        channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.
                                    
        stimes=baretimes{clust};
        wavejitters=jittertimes{clust};
            
        pointsintrial=find(stimes<(trial*trialduration) & stimes>=((trial-1)*trialduration));
        timesintrial=stimes(pointsintrial)-(trial-1)*trialduration;      
        jittersintrial=wavejitters(pointsintrial);
      
        if length(pointsintrial)>STAplotmax
            pointsintrial=pointsintrial(1:STAplotmax);
            timesintrial=timesintrial(1:STAplotmax);
            jittersintrial=jittersintrial(1:STAplotmax);      
        elseif length(pointsintrial)==0   
            continue   %skip to next unit
        end
         
        wavefile=dir([STAdir 'STA_i' num2str(wavefilecounter(clust)) '_cl' num2str(clust) '.mat']);   %load & initialize waveform file.   
        if wavefile.bytes<STAmaxwavesize;                    
        load([STAdir 'STA_i' num2str(wavefilecounter(clust)) '_cl' num2str(clust) '.mat']);          
        else                       
        wavefilecounter(clust)=wavefilecounter(clust)+1;        
        clear STA; STA=[];  %initialize waveform array.            
        	for j=1:length(plotchannels);
                chanjx=plotchannels(j);
                STA{chanjx}=[];                   
            end                     
        end 
                         
        for chanind=1:length(plotchannels)
            absolutechan=plotchannels(chanind);
            
            if length(find(channelsonshaft==absolutechan))==0   %only plots channels on the same shaft.
            continue
            end
                                                  
            wavesclustichanj=[]; 
            for timeind=1:length(timesintrial);
                fromind=timesintrial(timeind)-(STAleft-1);  %added 12 on 2/12/11 because of jitter compensation; this number must match t0 & tf constant
                toind=timesintrial(timeind)+(STAright-1);                
                
                if fromind<1 | toind>length(alldata{absolutechan})
                    continue
                end
            
                waveformi=alldata{absolutechan}(fromind:toind);
              
%               waveformi=decimate(waveformi,STAdecimatefactor);
                waveformi=downsample(waveformi,STAdecimatefactor);  %downsample is faster than decimate command, and results are very similar.
                           
                waveformi=waveformi-mean(waveformi);  %dc offset removal added Mar 1 2012.
                wavesclustichanj=[wavesclustichanj; waveformi];
                                
             end
                
             STA{absolutechan}=[STA{absolutechan}; wavesclustichanj];  
                              
        end
                  
        save([STAdir 'STA_i' num2str(wavefilecounter(clust)) '_cl' num2str(clust) '.mat'],'STA', '-mat')
            
        end 
           
        if length(find(stimes<(trial*trialduration)))>=STAplotmax   %added November 7 2011; if 'n' then in the next trial won't append any more waves for this cluster.
        ['stopped appending STA segments for unit ' num2str(clust) ', because already appended at least ' num2str(STAplotmax) ' segments.']
        appendmorewaves{clust}='n';       %note: STAplotmax is specified in set_plot_parameters
        end

    end
       
clear STA alldata
toc        
end

['done.']


