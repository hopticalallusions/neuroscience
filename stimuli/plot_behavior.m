

if length(licktimes)>0
    figind=10;
    figure(figind)
    subplot(3,1,1)    
    hold off 
    boundedline(licktimebins(1:(length(licktimebins)-1)), event1_lickrate, event1_licksem,'-k')   %do not use 'alpha' (transparent shading) because this will mess up eps export.
    hold on 
    if length(event2times)>0
    boundedline(licktimebins(1:(length(licktimebins)-1)),event2_lickrate, event2_licksem,'-r')   %do not use 'alpha' (transparent shading) because this will mess up eps export.
    title(['Event-triggered lick rate. Trials: ' trialselection1 ' and ' trialselection2 ' (bk=' triggerevent1 ', r=' triggerevent2 '). Error=SEM.'],'FontSize', 8)
    axis([-preeventtime posteventtime 0 round(max([event1_lickrate; event2_lickrate])+1)])
    else
%     axis off
    title(['Event-triggered lick rate. Trials: ' trialselection1 ' (bk=' triggerevent1 ')'],'FontSize', 8)
    axis([-preeventtime posteventtime 0 round(max([event1_lickrate])+1)])
    end
    ylabel('lick rate (Hz)','FontSize', 8) 
    xlabel('time (s)','FontSize', 8)
    set(gca,'TickDir','out')
    hold off
end


    figind=10;
    figure(figind)
    subplot(3,1,2)
    hold off    
    boundedline(runtimebins(1:(length(runtimebins)-1)),meanevent1_vy, semevent1_vy, '-k')     %do not use 'alpha' (transparent shading) because this will mess up eps export.
    hold on 
    if length(event2times)>0     
    boundedline(runtimebins(1:(length(runtimebins)-1)),meanevent2_vy, semevent2_vy, '-r')     %do not use 'alpha' (transparent shading) because this will mess up eps export.
    
    title(['Event-triggered run speed'],'FontSize', 8)
    axis([-preeventtime posteventtime round(min(min([meanevent1_vy; meanevent2_vy]))-0.5) round(max(max([meanevent1_vy; meanevent2_vy]))+0.5)])
    else
%     axis off
    title(['Event-triggered run speed'],'FontSize', 8)
    axis([-preeventtime posteventtime round(min(min([meanevent1_vy]))-0.5) round(max(max([meanevent1_vy]))+0.5)])
    end   
    ylabel('run speed (cm/s)','FontSize', 8) 
    xlabel('time (s)','FontSize', 8)
    title(['Event-triggered lick rate. Trials: ' trialselection1 ' and ' trialselection2 ' (bk=' triggerevent1 ', r=' triggerevent2 '). Error=SEM.'],'FontSize', 8)

    hold off
    set(gca,'TickDir','out')
      
    figind=10;
    figure(figind)
    subplot(3,1,3)
    hold off    
    boundedline(runtimebins(1:(length(runtimebins)-1)),meanevent1_accel, semevent1_accel, '-k')    %do not use 'alpha' (transparent shading) because this will mess up eps export.
    hold on 
    if length(event2times)>0     
    meanevent2_accel=100*mean(event2trig_accel);  %mean run speed in cm/sec.
    meanevent2_accel=meanevent2_accel(1:(length(runtimebins)-1));   
    boundedline(runtimebins(1:(length(runtimebins)-1)),meanevent2_accel, semevent2_accel, '-r')   %do not use 'alpha' (transparent shading) because this will mess up eps export.
    title(['Event-triggered acceleration'],'FontSize', 8)
    axis([-preeventtime posteventtime round(min(min([meanevent1_accel; meanevent2_accel]))-0.5) round(max(max([meanevent1_accel; meanevent2_accel]))+0.5)])
    else
%     axis off
    title(['Event-triggered acceleration'],'FontSize', 8)
    axis([-preeventtime posteventtime round(min(min([meanevent1_accel]))-0.5) round(max(max([meanevent1_accel]))+0.5)])
    end   
    ylabel('acceleration (cm/s^2)','FontSize', 8) 
    xlabel('time (s)','FontSize', 8)
    hold off
    set(gca,'TickDir','out')
    
set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.4*scrsz(3) 0.8*scrsz(4)])   


saveas(figure(figind),[stimephysjpgdir 'behavior.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'behavior.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'behavior.fig' ]  ,'fig')
