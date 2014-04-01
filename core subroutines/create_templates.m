close all
%******************Find distance******************
if size(waveforms,1)==0;
    disp(['no good clusters in set ' num2str(channelsetindex)])
    numberofgoodclusters=0;
    return
end
numberofspikes=size(waveforms,1);

if sortingcounter==1   %initializes mean spike templates for first group of trials.
allspikeinds=[];
meanspikes=[waveforms(1,:)];
spikeinds=[1,zeros(1,numberofspikes-1)];  %initially start counting spikeinds from zero.
spikesperind{1}=1;
else spikeinds=[1:size(meanspikes,1)];   %then start with pre-existing spike indices and meanspike templates.
end

noiselevel=max(allnoiselevels);

%Step 1: Find distance to all available clusters
 
for i=2:numberofspikes;
    foundmatch=0;
    distance=zeros(1,size(meanspikes,1));
    index=zeros(1,size(meanspikes,1));
    
    wavei=waveforms(i,:);
    
    for j=1:size(meanspikes,1)    %contents of this loop are the slowest part of template creating & matching!
    
    meanwavei=meanspikes(j,:);
    
    diffwaves=abs(wavei-meanwavei);     %THIS IS THE SLOWEST LINE IN LOOP. use only ~1 to 3 points instead of entire waveform; implemented on 7/12/11 to deal with Dec6b data.
                                        %this is the Chebyshev distance of each sample.

%   distance(j)=norm(wavei-meanwavei);  %old method: Euclidean distance of spike i, channel k, to cluster j.     
%     distance(j)=sum(diffwaves);             %new method (default): sum of Chebyshev distances ("taxicab", "Manhattan", or "city block" distance)
    
    distance(j)=sum(abs(wavei-meanwavei));    %this is equivalent to the City Block distance above, but hopefully a little faster.
  
%     minchoice=min([range(wavei) range(meanwavei)]);
        
    mindis=(clusterstdev)*(noiselevel);  
         
    nomatches=length(find(diffwaves>mindis));

    mindis=mindis'; 
    distcheck=distance(j)<mindis;         
    if sum(nomatches)<=0 %& sum(distcheck)==length(dochannels) 
    foundmatch=1;
    index(j)=1;
    else distance(j)=2*max(distance);
    end   
            
    end
     
    if  foundmatch==0  %if no match is found, create a new template.
         if abs(min(waveforms(i,:)))>minamplitude   %added 6/12/11
        spikeinds(i)=max(spikeinds)+1;
        meanspikes=[meanspikes; waveforms(i,:)]; 
        spikesperind{spikeinds(i)}=1;
         else spikeinds(i)=0;
         end
    end 
    
    if foundmatch==1;  %if match is found, assign it to the closest matching template.
        spikeinds(i)=find(distance==min(distance(find(index==1))),1);  %picks the first element in case multiple combinations meet criterion.
        events=find(spikeinds==spikeinds(i));  %all events with this spike index.
        
        if max(events)>size(waveforms,1)
            event=min(events);
        else event=max(events);  %just the last event (i.e. the current spike)
        end
        
        if length(spikesperind)>=max(spikeinds(i)) & length(spikesperind{spikeinds(i)})>0         
        spikesperind{spikeinds(i)}=spikesperind{spikeinds(i)}+1; 
        else spikesperind{spikeinds(i)}=1;
        end
            
        meanspikes(spikeinds(i),:)=((spikesperind{spikeinds(i)}-1)/spikesperind{spikeinds(i)})*meanspikes(spikeinds(i),:)+(1/spikesperind{spikeinds(i)})*waveforms(event,:);  %slow update of templates.
    end

end
%***********************END FINDING DISTANCE*****************************

% if trial==trainingtrials(length(trainingtrials));
% tempspikeinds=[allspikeinds spikeinds];
% remove_sparse_muxi;   %removes clusters<minamplitude, edited 11/11/11 (there is an option to remove sparsely firing units but this is done in prune_templates).
% end

allspikeinds=[allspikeinds spikeinds];   %all spike indices so far.

disp(['creating templates on set ' num2str(channelsetindex) ' (' num2str(channelsetindices) ' of ' num2str(length(dosets)) '), trial ' num2str(trial) '; ' num2str(numberofspikes) ' spikes; ' num2str(length(unique(allspikeinds))-1) ' total templates so far.'])
