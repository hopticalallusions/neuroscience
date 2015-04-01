samemeans=[];

for i=1:size(meanspikes,1);
    
    foundmatch=0;
    distance=zeros(length(dochannels),size(meanspikes,1));
    index=zeros(1,size(meanspikes,1));
    
    if max(abs(meanspikes(i,:)))<minamplitude    %added condition that spikes must be > minamplitude; 30/11/11
        continue
    end
    
    for j=2:size(meanspikes,1);
        
        if i>=j 
            continue
        end
        
        if max(abs(meanspikes(j,:)))<minamplitude
            continue
        end
            
%       for jitterind=[-jittersamples:2:jittersamples];  %added 4/12/11.
         
        mindis=[];
        nomatches=[];
        tempratios=[];
        for k=1:length(dochannels);  %channel k.
         
         noiselevel=allnoiselevels(k);    %default
         
         range0a=(k-1)*size(meanspikes,2)/length(dochannels)+1; %+jittersamples;
         rangefa=k*size(meanspikes,2)/length(dochannels); %-jittersamples;   
         
         range0b=(k-1)*size(meanspikes,2)/length(dochannels)+1; %+(jitterind+jittersamples);
         rangefb=k*size(meanspikes,2)/length(dochannels); %+jitterind-jittersamples;       

         a=meanspikes(i,range0a:rangefa);
         b=meanspikes(j,range0b:rangefb);            
%        distance(k,j)=sqrt(sum((a-b).^2));  %default: %Euclidean distance of spike i, channel k, to cluster j.
         distance(k,j)=sum(abs(a-b));        %linear distance.
                      
         if max(abs(a))<3*minamplitude | max(abs(b))<3*minamplitude   %added 30/11/11
         fudgefactor=-0.5;   %default=-1;
            if max(abs(a))<2*minamplitude | max(abs(b))<2*minamplitude   %added 30/11/11
            fudgefactor=fudgefactor-0.5;   %default=-1;
                if max(abs(a))<1.5*minamplitude | max(abs(b))<1.5*minamplitude   %added 30/11/11
                fudgefactor=fudgefactor-0.5;   %default=-1;
                end
            end  
         else fudgefactor=0;
         end
         
         diffwaves=abs(a-b);
         mindiff=(mergeclusterstdev+fudgefactor)*(noiselevel); 
         nomatch=length(find(diffwaves>mindiff));
         nomatches=[nomatches nomatch];
                                   
         mindisk=mergeclusterstdev*noiselevel*sqrt((size(meanspikes,2)/length(dochannels)));         
         mindis=[mindis mindisk]; %added May 15 2011.
         
        end 
               
        mindis=mindis';    %mindis is slightly larger for larger amplitude templates.  %added May 15 2011.
               
        distcheck=distance(:,j)<mindis;    
        if sum(nomatches)<=0 
        foundmatch=1;
        index(j)=1;
        samemeans=[samemeans; i j];   %the left and right columns specify indices to be merged.
%         continue                      %used with jitterind. if found match, stop attempting to jitter match and move to next cluster.
        end   
        
%       end
        
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
