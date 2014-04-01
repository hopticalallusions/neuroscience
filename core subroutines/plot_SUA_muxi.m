if psthbinsize>totaltime
    psthbinsize=10;
end
plottime=psthbinsize:psthbinsize:totaltime;

psthclusti=psth{clust}(1:(length(psth{clust})-1));
if length(psthclusti)==0
    psthclusti=0;
end
subplot(2,1,1)   %plot psth.
plot(plottime/60,psthclusti,'.-','Color','k')

xlabel(['time (min)'],'FontSize',9) 
ylabel(['single-unit firing rate (Hz)'],'FontSize',9)
axis([0 totaltime/60 0 ceil(1.1*max(psthclusti))+0.01])
title(['unit ' num2str(clust) ', ' num2str(length(spiketimes{clust})) ' spikes, bin size: ' num2str(psthbinsize) ' s. ' 'mean: ' num2str(mean(psthclusti)) '+/-' num2str(std(psthclusti)) ' Hz'] ,'FontSize',9)
set(gca,'XTick',0:5:max(totaltime/60),'FontSize',9)
    for events=startevent:(length(timeannotations)-1);
    etime=timeannotations{events};
    line([etime/60 etime/60], [0 ceil(1.1*max(psthclusti))],'Color','r','LineStyle','-')  %convert times to minutes
    text(etime/60,1.05*max(psthclusti),[' \leftarrow' eventannotations{events}],'FontSize',9)
    end
    


isiplottime=0:isibinsize:isirange;  
histisi=100*histc(isi{clust},isiplottime)/length(isi{clust});   %percentage of ISI per cluster in each bin  
if length(histisi)>0   
subplot(2,1,2)     %plot isi.
 
plot(isiplottime*1000,histisi,'.-','Color','k')
xlabel(['interspike interval (ms)'],'FontSize',9) 
ylabel(['percentage of spikes'],'FontSize',9)
    if max(histisi)>0       
    axis([0 isirange*1000 0 ceil(1.1*max(histisi))])
    else   axis([0 isirange*1000 0 1])    
    end
    
 if fractionISIviolations>maxfractionbadISI
    title(['POTENTIALLY BAD UNIT because of excessive refractory violations. % ISI<' num2str(1000*minisi) ' ms: ' num2str(100*fractionISIviolations)] ,'FontSize',9)
 else
    title(['% ISI<' num2str(1000*minisi) ' ms: ' num2str(100*fractionISIviolations)] ,'FontSize',9)
 end

end

%***************
timesclusti=spiketimes{clust}';
save([textdir 'spiketimes_unit' num2str(clust) '.txt'], 'timesclusti','-ASCII')   %saves spiketimes
saveas(figure(1),[psthisijpgdir 'psth_isi' num2str(clust) '.jpg' ]  ,'jpg')
% saveas(figure(1),[psthisijpgdir 'psth' num2str(clust) '.eps' ]  ,'psc2')