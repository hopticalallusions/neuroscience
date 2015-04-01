set_plot_parameters

['manually determine single-unit quality.']
['1=high-quality unit;  2=medium-quality unit;  3=low-quality non-single unit.']

load([timesdir 'finalspiketimes.mat'])
load([savedir 'final_params.mat']);  %loads parameters file.
bestchannel=parameters.bestchannels;
halfwidth=parameters.wavespecs.halfwidth;

scrsz=get(0,'ScreenSize');

unitquality=[];

figure(1)
close 1
figure(1)
set(gcf,'Position',[0.5*scrsz(1)+400 0.5*scrsz(2)+400 0.5*scrsz(3) 0.5*scrsz(4)])
for clust=1:length(spiketimes);
    timesclusti=spiketimes{clust};
    
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(clust) '.mat'])
    
    bestchan=bestchannel{clust};
    
    if length(bestchan)==0
    ['unit ' num2str(clust) ' has no bestchannel; skipping this unit.']
    unitquality=[unitquality, 3];   
    continue
    end
    
    lengthperchan=size(waveforms{bestchan},2);
   
    wavesinbestchan=waveforms{bestchan};
    maxtime=size(wavesinbestchan,2)/samplingrate-1/samplingrate;
    plott=1000*(0:1/samplingrate:maxtime);
    
    if length(wavesinbestchan)==0
        unitquality=[unitquality, 3];
        continue
    end
    
    subplot(1,3,[1 2])  %plot waveform on best channel
    hold off
    plot(plott,wavesinbestchan','r')
    hold on
    plot(plott,mean(wavesinbestchan)','k','LineWidth',2)
    axis([0 1000*maxtime min(min(wavesinbestchan))-10 max(max(wavesinbestchan))+10])
    title(['Unit ' num2str(clust) ', ' num2str(length(timesclusti)) ' spikes, V_p_p = ' num2str(round(range(mean(wavesinbestchan)))) ' \muV; half width = ' num2str(round(halfwidth{clust})) ' \mus.'],'FontSize',10)
    set(gca,'FontSize',10)
    xlabel(['time (ms)'],'FontSize',10) 
    ylabel(['amplitude (\muV)'],'FontSize',10)
    
    
    isii=[];
    for j=2:length(timesclusti); 
        isij=timesclusti(j)-timesclusti(j-1);
        isii=[isii; isij];  
    end
    isi{clust}=isii;
    fractionISIviolations=length(find(isi{clust}<minisi))/length(isi{clust});
    isiplottime=0:isibinsize:isirange;
    histisi=100*histc(isi{clust},isiplottime)/length(isi{clust});   %percentage of ISI per cluster in each bin
    
    isiplottime=isiplottime(1:(length(isiplottime)-1));
    histisi=histisi(1:(length(histisi)-1));

    subplot(1,3,3)  %plot ISI
    hold off
    plot(isiplottime*1000,histisi,'.-','Color','k')
    xlabel(['interspike interval (ms)'],'FontSize',10) 
    ylabel(['% spikes'],'FontSize',10)
    if max(histisi)>0       
    axis([0 isirange*1000 0 ceil(1.1*max(histisi))])
    else   axis([0 isirange*1000 0 1])    
    end
    set(gca,'FontSize',10)
    title(['% spikes with ISI<' num2str(1000*minisi) ' ms: ' num2str(100*fractionISIviolations)] ,'FontSize',10)

    figure(1)
    qual=[];
    qual=input(['Specify quality of unit ' num2str(clust) ' [3]: '],'s'); 
    figure(1)
    while isempty(qual)==1
        qual=input(['You did not specify quality of unit ' num2str(clust) '[3]: '],'s');
        
    end
    
    unitquality=[unitquality, str2num(qual)];

end

save([savedir 'unitquality.mat'],'unitquality','-mat')

['done assigning unit quality to ' filename '.']
close 1
