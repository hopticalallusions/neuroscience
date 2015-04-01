if length(allcluststdev)>=3;

spikesperclust=[];    
for unitind=1:length(dounits);
    uniti=dounits(unitind);
    spikesperclust{uniti}=[];  %initialize array.
end


for j=1:length(allcluststdev);

    iterj=allcluststdev(j);
           
    for timefileind=1:length(timefiles);
    timefilex=timefiles(timefileind).name;
      
    load([timesdir timefilex])   %load alltimes{clust}{clusteriteration}
          
        for unitind=1:length(dounits);
            uniti=dounits(unitind);                     
            timesunitiiterj=(alltimes{uniti}{j})/samplingrate;                    
            overtimeinds=find(timesunitiiterj>numberoftrials*trialduration/samplingrate);  %removes any times in the very last trial.
            timesunitiiterj(overtimeinds)=[];           
            spikesperclust{uniti}=[spikesperclust{uniti}; length(timesunitiiterj)];               
        end      
    end
     
end

oldspikesperclust=spikesperclust;
spikesperclust=[];    
for unitind=1:length(dounits);
    uniti=dounits(unitind);
    spikesperclust{uniti}=0;  %initialize array.
end

for timefileind=1:length(timefiles);
    
    for unitind=1:length(dounits);
    uniti=dounits(unitind);     
    spikesperclust{uniti}=[spikesperclust{uniti}+oldspikesperclust{uniti}(timefileind:length(timefiles):length(oldspikesperclust{uniti}))];
    end
  
end
    

plotcounter=1; figurecounter=1;
figure(1); hold off;
for i=1:length(dounits);
uniti=dounits(i);

    if plotcounter>16
    plotcounter=1;
    saveas(figure(1),[timesdir 'spikes_per_cluststdev' num2str(figurecounter) '.jpg' ]  ,'jpg')
    close 1
    figure(1)
    figurecounter=figurecounter+1;
    end

subplot(4,4,plotcounter)

plot(allcluststdev,100*spikesperclust{uniti}/spikesperclust{uniti}(find(allcluststdev==5)),'o-k','MarkerSize',3,'MarkerFaceColor','k');
title(['% spikes vs \sigma=5, unit ' num2str(uniti)],'FontSize', 8)
set(gca,'XTick',[1:(max(allcluststdev)/8):max(allcluststdev)],'FontSize',8)

plotcounter=plotcounter+1;
end

saveas(figure(1),[timesdir 'spikes_per_cluststdev' num2str(figurecounter) '.jpg' ]  ,'jpg')
close 1
end