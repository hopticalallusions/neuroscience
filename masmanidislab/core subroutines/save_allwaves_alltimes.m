for j=1:numberofclusters;  
            clust=doclusters(j);
            matchinds=find(spikeinds==clust);       
        
if length(matchinds)>0        
                wavesinclust=waveforms(matchinds,:);
                spiketimes=stimes(matchinds);                   
                contributionratio=min([max_tempupdatefraction length(matchinds)/refreshnumber]);      %default=0.01; contribution ratio of newly found waveforms in the template.     
                newmeans=(1-contributionratio)*meanspikes{clust}+contributionratio*mean(wavesinclust);    %need to modify to allow for jitter.     
                    if  clusterstdev==allcluststdev(1)
%                     ['updating template ' num2str(clust) '.']
                    meanspikes{clust}=newmeans;   %update templates only if current iteration's clusterstdev is a single value, otherwise templates will change too much.
                    end
                jitter=wavejitter(matchinds);     
                         
                    if subtract_templates=='y'
                    disp(['subtracting templates from data between iterations.'])
                    subtract_templates_from_data;
                    else clear datadochannels
                    end





    if savewaves=='y'

        wavefile=dir([wavedir 'waves_i' num2str(clusteriteration) '_n' num2str(wavefilecounter) '.mat']);      

        if wavefile.bytes<maxwavesize;        
            
            load([wavedir 'waves_i' num2str(clusteriteration) '_n' num2str(wavefilecounter) '.mat']);
            
            allwaves{clust}=[allwaves{clust}; wavesinclust];  
            
            if length(spikesinallwaves{clust}{clusteriteration}{wavefilecounter})==0            
            spikesinallwaves{clust}{clusteriteration}{wavefilecounter}=length(matchinds);                
            else spikesinallwaves{clust}{clusteriteration}{wavefilecounter}=spikesinallwaves{clust}{clusteriteration}{wavefilecounter}+length(matchinds);             
            end
                
        else                       
            wavefilecounter=wavefilecounter+1;
            
           
            clear allwaves;                        
            allwaves=[];    %initialize cluster waveforms.    
            for clustind=1:length(allclusters);
            clustx=allclusters(clustind);            
            allwaves{clustx}=[];
                for clusterits=1:numberiterations;        
                spikesinallwaves{clustx}{clusterits}{wavefilecounter}=[];
                save([wavedir 'waves_i' num2str(clusterits) '_n' num2str(wavefilecounter) '.mat'],'allwaves', '-mat');  %saves empty file.
                end
            end            
            allwaves{clust}=[allwaves{clust}; wavesinclust];   
            spikesinallwaves{clust}{clusteriteration}{wavefilecounter}=length(matchinds); 
            
        end 
        
        save([wavedir 'waves_i' num2str(clusteriteration) '_n' num2str(wavefilecounter)  '.mat'],'allwaves', '-mat')
        
        clear allwaves
        
    end
        
      
    
        timesfile=[timesdir 'spiketimes_n' num2str(timefilecounter) '.mat'];
        dirtimesfile=dir([timesfile]);
        
        if dirtimesfile.bytes<maxtimefilesize;         
                 
        alltimes{clust}{clusteriteration}=[alltimes{clust}{clusteriteration} (spiketimes+(trial-1)*trialduration)];                             
        alljitters{clust}{clusteriteration}=[alljitters{clust}{clusteriteration} jitter];
        save([timesdir 'spiketimes_n'  num2str(timefilecounter) '.mat'], 'alltimes', '-mat');
        save([timesdir 'timejitter_n'  num2str(timefilecounter) '.mat'], 'alljitters', '-mat');
        
        
        else
           
            alltimes=[];    %initialize cluster spike times.
            alljitters=[];
            for clustind=1:length(allclusters);
                clustx=allclusters(clustind);
                for clusterits=1:numberiterations;
                alltimes{clustx}{clusterits}=[];   
                alljitters{clustx}{clusterits}=[];
                end
            end

        alltimes{clust}{clusteriteration}=[spiketimes+(trial-1)*trialduration];
        alljitters{clust}{clusteriteration}=[jitter];
        timefilecounter=timefilecounter+1;    
        save([timesdir 'spiketimes_n'  num2str(timefilecounter) '.mat'], 'alltimes', '-mat');
        save([timesdir 'timejitter_n'  num2str(timefilecounter) '.mat'], 'alljitters', '-mat');               
        end
 
        
end                 
    
end      
