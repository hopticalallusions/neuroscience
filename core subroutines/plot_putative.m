numberofclusters=length(maybetemplates.meanspikes);

if plottemplates=='y'   %plots individual templates

templatejpgdir=([savedir 'templates_jpeg\']);
mkdir(templatejpgdir)
delete([templatejpgdir '*.jpg'])

cols=colormap;
figure(1)
hold off
meanspikes=maybetemplates.meanspikes;

for clust=1:numberofclusters; 
    lengthperchan=maybetemplates.lengthperchan{clust};
    bestchannel=maybetemplates.bestchannel{clust};
    dochannels=maybetemplates.channels{clust};
    meanclust=meanspikes{clust};
   
      
    colorind=mod(clust,32)+1;
    col=cols(2*colorind,:);
    
    t0=find(dochannels==bestchannel);
    t0=lengthperchan*(t0-1)+1;
    tf=t0+lengthperchan-1;
    meaninrange=meanclust(t0:tf);
    peaktime=find(abs(meaninrange)==max(abs(meaninrange)));
    plot(1000*(t0:tf)/(samplingrate*upsamplingfactor),meaninrange,'Color',col)
    xlabel(['time (ms)']) 
    ylabel(['voltage (\muV)'])       
    text(1000*(peaktime+t0)/(samplingrate*upsamplingfactor),meaninrange(peaktime),[' \leftarrow' num2str(clust)],'FontSize',7)
    title(['largest spike waveform of all putative clusters. minamplitude = ' num2str(minamplitude) ' \muV'])

    hold on
        
end
saveas(figure(1),[templatejpgdir 'putative_units.fig' ]  ,'fig')   
saveas(figure(1),[templatejpgdir 'putative_units.jpg' ]  ,'jpeg')   
close 1


for clust=1:numberofclusters; 
    figure(2)
    hold off
    lengthperchan=maybetemplates.lengthperchan{clust};
    chanswithspikes=maybetemplates.chanswithspikes{clust};
    dochannels=maybetemplates.channels{clust};
    meanclust=meanspikes{clust};
   
    meanwave=[];  
    for chanind=1:length(chanswithspikes);
    t0=find(dochannels==chanswithspikes(chanind));
    t0=lengthperchan*(t0-1)+1;
    tf=t0+lengthperchan-1;
    meaninrange=meanclust(t0:tf);
    meanwave=[meanwave, meaninrange];
    end
    
    plottime=0:1/(samplingrate*upsamplingfactor):(length(meanwave)-1)/(samplingrate*upsamplingfactor);
    
    plot(1000*plottime,meanwave,'Color','b','LineWidth',2)
    if max(meanwave)<80 & min(meanwave)>-120
    axis([0 max(1000*plottime), -120 80])
    else axis([0 max(1000*plottime), min(meanwave)-10 max(meanwave)+10])
    end
    xlabel(['time (ms)']) 
    ylabel(['voltage (\muV)'])
    title(['putative template ' num2str(clust) ', channels ' num2str(chanswithspikes) '.'])
    saveas(figure(2),[templatejpgdir 'waveforms' num2str(clust)  '.jpg' ]  ,'jpg')
    close 2
     
end

disp([num2str(numberofclusters) ' putative templates. inspect templates and manually delete any suspicious looking spikes.'])
end
    
