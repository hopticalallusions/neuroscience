        %store unassigned spike times.
        unsortedspikes=stimes(find(spikeinds==0));
        jitter=wavejitter(find(spikeinds==0));      

        timesfile=[timesdir 'unsortedtimes_n' num2str(unsortedfilecounter) '.mat'];
        dirtimesfile=dir([timesfile]);
        
        if dirtimesfile.bytes<maxtimefilesize;         
                 
        unsortedtimes{clusteriteration}=[unsortedtimes{clusteriteration} (unsortedspikes+(trial-1)*trialduration)];                             
        unsortedjitters{clusteriteration}=[unsortedjitters{clusteriteration} jitter];
        save([timesdir 'unsortedtimes_n'  num2str(unsortedfilecounter) '.mat'], 'unsortedtimes', '-mat');
        save([timesdir 'unsortedjitter_n'  num2str(unsortedfilecounter) '.mat'], 'unsortedjitters', '-mat');
        
        
        else
           
            unsortedtimes=[];    %initialize cluster spike times.
            unsortedjitters=[];
            for clusterits=1:numberiterations; 
            unsortedtimes{clusterits}=[];
            unsortedjitters{clusterits}=[];
            end

        unsortedtimes{clusteriteration}=[unsortedspikes+(trial-1)*trialduration];
        unsortedjitters{clusteriteration}=[jitter];
        unsortedfilecounter=unsortedfilecounter+1;    
        save([timesdir 'unsortedtimes_n'  num2str(unsortedfilecounter) '.mat'], 'unsortedtimes', '-mat');
        save([timesdir 'unsortedjitter_n'  num2str(unsortedfilecounter) '.mat'], 'unsortedjitters', '-mat');               
        end
        
        
              
        %store Euclidean distances, unassigned spikes go to the last "cluster"
        for j=1:(length(doclusters)+1);    
                if j==(length(doclusters)+1)
                clust=max(allclusters)+1;
                else
                clust=doclusters(j);
                end
                matchinds=find(spikeinds==clust); 
                if length(matchinds)==0
                    continue
                end
                
        
            distancefile=[timesdir 'disttotemplates_n' num2str(distcounter) '.mat'];
            dirdistfile=dir([distancefile]);
        
            if dirdistfile.bytes<maxtimefilesize;         
            
                for matchindi=1:length(matchinds);
                spikei=matchinds(matchindi);
                disttotemplates{clust}{clusteriteration}=[disttotemplates{clust}{clusteriteration}; sumdist{spikei}]; 
                end
            save([timesdir 'disttotemplates_n'  num2str(distcounter) '.mat'], 'disttotemplates', '-mat');
       
        
            else
           
            disttotemplates=[];    %initialize cluster spike times.
            
            for clustind=1:(length(allclusters)+1);  %the last cluster is for unassigned spikes (i.e. spikeind=0).
                for clusterits=1:numberiterations;        
                disttotemplates{clustind}{clusterits}=[];      
                end
            end

                for matchindi=1:length(matchinds);
                spikei=matchinds(matchindi);
                disttotemplates{clust}{clusteriteration}=[disttotemplates{clust}{clusteriteration}; sumdist{spikei}]; 
                end
            distcounter=distcounter+1;    
            save([timesdir 'disttotemplates_n'  num2str(distcounter) '.mat'], 'disttotemplates', '-mat');             
            end
        
        
        end