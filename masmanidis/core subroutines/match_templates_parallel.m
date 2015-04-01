spikeinds=zeros(1,numberofspikes);

sumdist=[];

noiselevel=0;
for k=1:length(dochannels)
    chank=dochannels(k);
    if noisedochannels{chank}>noiselevel
        noiselevel=noisedochannels{chank};   %noise level is set as the noise of the channel with the highest noise level.
    end
end

parfor i=1:numberofspikes;
    foundmatch=0;   
    distance=zeros(1,numberofclusters); 
    index=zeros(1,numberofclusters);
    
    wavei=waveforms(i,:);
            
    for j=1:numberofclusters;  
        
    clustj=doclusters(j);
        
    meanwavei=meanspikes{clustj};
    
    if length(meanwavei)~=length(wavei)   %added Sep 12 2012 to fix an occasional glitch.
        continue
    end
    
    diffwaves=abs(wavei-meanwavei);     %THIS IS THE SLOWEST LINE IN LOOP. use only min points, implemented on 7/12/12 to deal with Dec6b data.

%   distance(j)=sqrt(sum((wavei-meanwavei).^2));  %default: %Euclidean distance of spike i, channel k, to cluster j.         
    distance(j)=sum(diffwaves);
  
%     minchoice=min([range(wavei) range(meanwavei)]);
    
    mindis=(clusterstdev)*(noiselevel);  
         
    nomatches=length(find(diffwaves>mindis));

    mindis=mindis'; 
       
    distcheck=distance(:,j)<mindis;         
    if sum(nomatches)<=0 
    foundmatch=1;
    index(j)=1;
    else distance(j)=2*max(distance);
    end   
                     
    end
    
% sumdist{i}=sqrt(sum(distance.^2));   %Euclidean distance for all points of a template (includes all channels that were used in usechannels).

    if foundmatch==1;  %if match is found, assign it to the closest matching template.
        spikeinds(i)=find(distance==min(distance(find(index==1))),1);  %picks the first element in case multiple combinations meet criterion.
        spikeinds(i)=doclusters(spikeinds(i));
    end   
    
end

disp([num2str(length(find(spikeinds==0))) ' unassigned spike(s).'])

unassignedcounter{currentset}=[unassignedcounter{currentset} round(100*length(find(spikeinds==0))/numberofspikes)];  %keeps track of percentage of unassigned spikes per trial for each channel set. added Sept 13 2012.

figure(100)
hold on
plot(unassignedcounter{currentset},'o','MarkerFaceColor','b','MarkerEdgeColor','b','MarkerSize',3)
axis([0.75 maxtrial 0 100])
title(['unassigned spikes in all channel sets'])
xlabel('trial index')
ylabel('% unassigned spikes')
hold off
figure(100)

if plotduringsorting=='y'  %& length(find(spikeinds==1))>0
figure(1)
hold off
plottime=0:1/samplingrate:((trialduration-1)/samplingrate);
    for chanind=1:length(dochannels);                      
        channelj=dochannels(chanind);  
        datach=datadochannels{channelj}; 
        plot(plottime, datach+100*(chanind-1),'k')
        hold on 
        for i=1:numberofspikes;
        t0=stimes(i)-leftpoints;
        tf=stimes(i)+rightpoints;
            if max(abs(datach(t0:tf)))>minamplitude
            text(stimes(i)/samplingrate,datach(stimes(i))+100*(chanind-1),[' \leftarrow' num2str(spikeinds(i))],'FontSize',7,'Color','r')
            end
        end   
    end
    clear datach
        
    plotduringsorting=input('do you want to continue viewing plots (y/n)? [n] ', 's'); 
end
