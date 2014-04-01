figind=figind+1;

for unitind=1:length(unitorder);
	unitj=unitorder(unitind);    %proceed in the sorted order of units.
    
    figure(figind)
    set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.4*scrsz(3) 0.8*scrsz(4)])   
    hold off

    subplot(4,1,1)   %event-triggered Burst raster for event 1
    hold off
    plot_event1burstraster
   
    subplot(4,1,2)   %event-triggered Burst raster for event 2
    hold off
    plot_event2burstraster
    
    
    subplot(4,1,3)
    hold off
    if length(event1_burstrate{unitj})>0
    plot(timebins(1:(length(timebins)-1)), event1_burstrate{unitj}','k');
    end 
    hold on
    if length(event2_burstrate{unitj})>0
    plot(timebins(1:(length(timebins)-1)), event2_burstrate{unitj}','r');
    end
    ylabel('mean burst #', 'FontSize',8)
    title('mean burst number vs time', 'FontSize',8)
    set(gca,'FontSize', 8,'TickDir','out')
 
    
    subplot(4,1,4)
    hold off
    if length(event1_spikerate{unitj})>0
    plot(timebins(1:(length(timebins)-1)), event1_spikerate{unitj}','k');
    end 
    hold on
    if length(event2_spikerate{unitj})>0
    plot(timebins(1:(length(timebins)-1)), event2_spikerate{unitj}','r');
    end
    xlabel('time (s)', 'FontSize',8)
    ylabel('mean rate (Hz)', 'FontSize',8)
    title('mean spike rate vs time', 'FontSize',8)
    set(gca,'FontSize', 8,'TickDir','out')
          
    saveas(figure(figind),[burstrasterjpgdir 'burstraster_u' num2str(unitj) '.jpg' ]  ,'jpg')
    saveas(figure(figind),[burstrasterepsdir 'burstraster_u' num2str(unitj) '.eps' ]  ,'psc2')
    saveas(figure(figind),[burstrastermfigdir 'burstraster_u' num2str(unitj) '.fig' ]  ,'fig')
    
    close(figind)
    figind=figind+1;
    
end
