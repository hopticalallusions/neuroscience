% %**********Eliminate spurious & empty clusters************
%eliminates sparsely populated clusters (population<minspikesperunit) 
%assigns to spikeinds=0 and keeps only templates that meet minspike criterion.

% spikecounts=histc(tempspikeinds,1:max(tempspikeinds));
% % goodclustinds=find(spikecounts>=minspikesperunit);  %too stringent.
% goodclustinds=find(spikecounts>=1);

goodclustinds=[];
for j=1:size(meanspikes,1);
    meanspikej=meanspikes(j,:);
    foundminamp=find(abs(meanspikej)>minamplitude);
    if length(foundminamp)>0
        goodclustinds=[goodclustinds j];
    end
end

goodclustinds=unique(goodclustinds);

badclustinds=setdiff(unique(spikeinds), goodclustinds);

numberofgoodclusters=length(goodclustinds);
numberofbadclusters=length(badclustinds);

if numberofgoodclusters==0;
    ['no good clusters in set ' num2str(channelsetindex)]
    return
end

newmeanspikes=meanspikes(goodclustinds,:);
newmeanspikes2=meanspikes;
newspikeinds=spikeinds;

if iterations==1
    
    for i=1:numberofgoodclusters
    if goodclustinds(i)~=i
    newspikeinds(find(newspikeinds==i))=-1;
    newspikeinds(find(newspikeinds==goodclustinds(i)))=i;
    newspikeinds(find(newspikeinds==-1))=goodclustinds(i);
    goodclustinds(i)=i;
    end
    end
    spikecounts=histc(newspikeinds,1:numberofgoodclusters);

    for i=1:max(newspikeinds)
    if max(newspikeinds(find(newspikeinds==i)))>max(goodclustinds)
    newspikeinds(find(newspikeinds==i))=0;
    end
    end

    spikeinds=newspikeinds;
    meanspikes=newmeanspikes;
    
    
elseif iterations>1
    
    for i=1:numberofbadclusters;
    badclusti=badclustinds(i);
    newspikeinds(find(newspikeinds==badclusti))=0;    
    end

    newspikeinds2=newspikeinds;
    uniquenewinds=setdiff(unique(newspikeinds),0);
    uniqueoldinds=setdiff(unique(allspikeinds),0);  %lists the unique spike indices collected from all previous trial groups.   
    
    renamednewindi=max(uniqueoldinds);    
    for i=1:length(uniquenewinds);
        newindi=uniquenewinds(i);         
        a=find(uniqueoldinds==newindi);
        if length(a)==0  %if the new spike index didn't exist....
            renamednewindi=renamednewindi+1;  %names a new spike index that didn't exist in previous trial groups.
            newspikeinds2(find(newspikeinds==newindi))=renamednewindi;  %rearranges spike indices so the numbers are continuous.
            newmeanspikes2(renamednewindi,:)=meanspikes(newindi,:);    %rearranges mean spike templates.
        end     
    end
       
   
    throwoutinds=[];
    for i=1:length(badclustinds);
        badclusti=badclustinds(i);
        a=find(uniqueoldinds==badclusti);
        if length(a)==0   %if the bad clusters didn't previously exist, can throw them out.
            throwoutinds=[throwoutinds,badclusti];  %if the bad cluster did previously exist, do not throw it out.
        end
    end
   
   if sum(throwoutinds)~=0   %added 6/12/11
   newmeanspikes2(throwoutinds,:)=[];
   spikeinds=newspikeinds2;  %final updated spike indices.
   meanspikes=newmeanspikes2(1:renamednewindi,:);  
   end
    
end
%***********************************************************
