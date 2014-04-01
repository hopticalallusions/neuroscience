samemeans=[];

noiselevel=max(allnoiselevels);    %default

for i=1:size(meanspikes,1);
    
    foundmatch=0;
    distance=zeros(1,size(meanspikes,1));
    index=zeros(1,size(meanspikes,1));
    
    if max(abs(meanspikes(i,:)))<minamplitude    %added condition that spikes must be > minamplitude; 30/11/11
        continue
    end
    
    meanwavei=meanspikes(i,:);
    
    for j=2:size(meanspikes,1);
        
        if i>=j 
            continue
        end
        
        if max(abs(meanspikes(j,:)))<minamplitude
            continue
        end

        meanwavej=meanspikes(j,:);            
        diffwaves=abs(meanwavei-meanwavej);     %THIS IS THE SLOWEST LINE IN LOOP. use only ~1 to 3 points instead of entire waveform; implemented on 7/12/11 to deal with Dec6b data.       
        distance(j)=sum(diffwaves);      
        mindis=(mergeclusterstdev)*(noiselevel);                
        nomatches=length(find(diffwaves>mindis));             
        mindis=mindis'; 
        distcheck=distance(j)<mindis;         
        if sum(nomatches)<=0 %& sum(distcheck)==length(dochannels) 
        foundmatch=1;
        index(j)=1;
        samemeans=[samemeans; i j];   %the left and right columns specify indices to be merged.
        end   
       
    end             
end

if length(samemeans)>0

mergeclusts=unique(samemeans(:,1));
newallspikeinds=allspikeinds;
newmeanspikes=meanspikes;
for leftcind=1:length(mergeclusts);  
   mergeclusts=sort(mergeclusts,'descend');
   leftclust=mergeclusts(leftcind);    
   a=find(samemeans(:,1)==leftclust);  %all the left rows with index leftclust;
   b=samemeans(a,2); %all the corresponding right rows.
   
   allinds=unique([leftclust b']);  %all indices to merge.
   newmeanspikes(leftclust,:)=mean(meanspikes(allinds,:));  %average of the templates to be merged.
%    newmeanspikes(leftclust,:)=mean(meanspikes(1,:));  %just the first of the templates to be merged.
    
   for i=1:length(b);
       newallspikeinds(find(newallspikeinds==b(i)))=leftclust;     %modify the spike indices.
   end
    
end   


uniqueinds=setdiff(unique(newallspikeinds),0);
meanspikes2=[]; allspikeinds2=newallspikeinds;
for i=1:length(uniqueinds);
    ind=uniqueinds(i);
    allspikeinds2(find(newallspikeinds==ind))=i;
    meanspikes2=[meanspikes2; newmeanspikes(ind,:)];
end
    
condensed=[length(unique(allspikeinds)) length(unique(allspikeinds2))];

meanspikes=meanspikes2;
allspikeinds=allspikeinds2;

clear newmeanspikes newspikeinds

end

%added 20/11/11
spikesperclust=[];
for i=1:max(allspikeinds);
    spikesperclust{i}=find(allspikeinds==i);  %finds the number of spikes per template.  will be used to discard any templates containing <minspikesperunit
end
