disp('making event-triggered raster plots')
close all
figure(figind)
isiplottime=0:isibinsize:isirange;
for unitind=1:length(dounits)
  
    figure(figind)
    unitj=dounits(unitind);
    timesunitj=spiketimes{unitj};
    disp(['*unit ' num2str(unitj) ' (' num2str(unitind) '/' num2str(length(dounits)) ')'])   
    
    subplot(4,3,[1 4])   %plot all waveforms across the entire shaft.   
    hold off 
    plot_wave_array 
   
    subplot(4,3,7)  %plot ISI
    hold off 
    plot_isi
       
    subplot(4,3,[2])   %Cue-triggered Spike raster for event 1
    hold off   
    plot_event1raster
     
    subplot(4,3,[3])   %Cue-triggered Spike raster for event 2
    hold off
    plot_event2raster
         
%     subplot(4,3,[5])   %Cue-triggered Burst raster for event 1
%     hold off
%     plot_event1_groupstack
%    
%     subplot(4,3,[6])   %Cue-triggered Burst raster for event 2
%     hold off
%     plot_event2_groupstack
%     
%     if length(licktimes)>0
%     subplot(4,3,[8])    %Cue-triggered Licking raster plots for CS1
%     hold off
%     plot_event1lickraster
%     plot_event1_grouplickstack
%     
%     subplot(4,3,[9])    %Cue-triggered Licking raster plots for CS2
%     hold off
%     plot_event2lickraster
%     plot_event2_grouplickstack
%     end
    
    subplot(4,3,[10 11])    %Mean cue & lick-triggered firing rate
    hold off
    plot_meanfiringrate
        
    subplot(4,3,[12])    %Mean cue-triggered lick rate    
    hold off
    plot_meanlickingrate
    
    set(gcf,'Position',[0 0 scrsz(3) scrsz(4)])
   
%     set(gcf,'Position',[0.8*scrsz(1)+40 0.8*scrsz(2)+100 0.8*scrsz(3) 0.8*scrsz(4)])   

    saveas(figure(figind),[rasterjpgdir 'spikeraster_u' num2str(unitj) '.jpg' ]  ,'jpg')
    saveas(figure(figind),[rasterepsdir 'spikeraster_u' num2str(unitj) '.eps' ]  ,'psc2')
    saveas(figure(figind),[rastermfigdir 'spikeraster_u' num2str(unitj) '.fig' ]  ,'fig')
    
    close(figind)
    figind=figind+1;
    
end

disp('done making raster plots.')