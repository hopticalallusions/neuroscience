    isi=diff(timesunitj);
    isi=isi(find(isi<=isirange));
    histisi=100*histc(isi,isiplottime)/length(isi);   %percentage of ISI per uniter in each bin  
    histisi=histisi(1:(length(histisi)-1));
    plot(isiplottime(1:length(histisi))*1000,histisi,'.-','Color','k')
    xlabel(['interspike interval (ms)'],'FontSize', 8) 
    ylabel(['% spikes'],'FontSize', 8)
    title(['AP=' num2str(unity{unitj}) ', ML=' num2str(unitx{unitj}) ', z=' num2str(unitz{unitj}) ' mm'],'FontSize', 8)
    if max(histisi)>0       
    axis([0 isirange*1000 0 ceil(1.1*max(histisi))])
    else   axis([0 isirange*1000 0 1])    
    end
    set(gca,'FontSize', 8,'TickDir','out')