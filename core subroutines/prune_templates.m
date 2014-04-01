disp(['prune_templates (very light to none merging and discarding bad units).'])
seedtempdir=[savedir 'seed templates\'];  
uniquesets=dir([seedtempdir 'sortspikes_set*']);

    datesets=[]; maybetemplates=[]; unitcounter=1; newsetlist=[];
    for setind=1:length(uniquesets);  %for each set of channels, e.g. for each shaft or group of channels.
    
    setname=uniquesets(setind).name;
       
    load([seedtempdir setname])
    
    allspikeinds=sortspikes.spikeinds;
    meanspikes=sortspikes.meanspikes;
    allnoiselevels=sortspikes.allnoiselevels;
    dochannels=sortspikes.channels;
    channelsetindex=sortspikes.channelset;    
    minamplitude=sortspikes.minamplitude;
    
    orignumberunits=size(meanspikes,1);
    
    doneupsampling='n';    
    upsample_align_waves    %upsample & realign mean spikes.
  
    remove_merged_muxi    %very light merging step: combines similar templates after all trials have been sorted.
    
%     remove_merged_muxi    
     
    finalnumberunits=size(meanspikes,1);
    if finalnumberunits~=orignumberunits;
        disp(['channel set ' num2str(setind) ', merged ' num2str(orignumberunits) ' into ' num2str(finalnumberunits) ' putative units.'])
    else disp(['no clusters were merged in set ' num2str(setind) '; ' num2str(finalnumberunits) ' total units.'])
    end
     
    lengthperchan=size(meanspikes,2)/length(dochannels);  %meanspikes are already upsampled.
    newspikesperclust=[]; 
    for unitind=1:max(allspikeinds);  %for all templates
        
        currentmean=meanspikes(unitind,:);
        maxpos=find(abs(currentmean)==max(abs(currentmean)));
        bestchan=dochannels(ceil(maxpos/lengthperchan));   %finds channel with highest amplitude spike on each unit.
        
        overminamp=find(abs(currentmean)>minamplitude);   
        chanswithspikes=unique(dochannels(ceil(overminamp/lengthperchan)));   %finds all channels exhibiting spikes>minamplitude
        
        if length(chanswithspikes)==0 | length(chanswithspikes)>maxchansperclust | length(spikesperclust{unitind})<minspikesperunit  %discards if there are either no channels or too many channels exceeding minamplitude,                                                                                                                                     %or insufficient number of spikes in this unit.
              disp(['discarded cluster ' num2str(unitind) ' because not enough spikes or < minamplitude.'])
            continue
        end
        
        newsetlist=[newsetlist channelsetindex]; 
        
        newspikesperclust{unitcounter}=spikesperclust{unitind};
        maybetemplates.meanspikes{unitcounter}=meanspikes(unitind,:);  
        maybetemplates.channelsetindex{unitcounter}=channelsetindex;
        maybetemplates.channels{unitcounter}=dochannels;
        maybetemplates.allnoiselevels{unitcounter}=allnoiselevels; 
        maybetemplates.lengthperchan{unitcounter}=lengthperchan;
            
        maybetemplates.chanswithspikes{unitcounter}=chanswithspikes;
        maybetemplates.bestchannel{unitcounter}=bestchan;
        maybetemplates.minamplitude=minamplitude;
             
        unitcounter=unitcounter+1;      
    end
    
    end
   
    newsetlist=unique(newsetlist);
    maybetemplates.dosets=newsetlist;
    
    save([seedtempdir 'maybetemplates.mat'],'maybetemplates', '-mat')

    