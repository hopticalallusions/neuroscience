   if length(licktimes)>0      
    boundedline(licktimebins(1:(length(licktimebins)-1)),event1_lickrate,event1_licksem,'-k')  %do not use 'alpha' (transparent shading) because this will mess up eps export.
    hold on
    if length(event2times)>0        
        boundedline(licktimebins(1:(length(licktimebins)-1)),event2_lickrate,event2_licksem,'-r')     %do not use 'alpha' (transparent shading) because this will mess up eps export.    
        axis([-preeventtime posteventtime 0 ceil(max([event1_lickrate; event2_lickrate])+0.5)])
        else
        axis([-preeventtime posteventtime 0 ceil(max([event1_lickrate])+0.5)])
    end 
        
   
    xlabel('time (s)','FontSize', 8)
    ylabel('lick rate (Hz)','FontSize', 8)
    title(['Lick rate'],'FontSize', 8)
    set(gca,'FontSize', 8, 'TickDir','out')
    hold off
    
    else
    subplot(4,3,[12])    %Mean cue-triggered running speed
    meanevent1_vy=100*mean(event1trig_vy); %mean run speed in cm/sec.
    meanevent1_vy=meanevent1_vy(1:(length(licktimebins)-1));
    
    hold off
    plot(licktimebins(1:(length(licktimebins)-1)),meanevent1_vy,'-k')
    hold on
    
    if length(event2times)>0     
        meanevent2_vy=100*mean(event2trig_vy);  %mean run speed in cm/sec.
        meanevent2_vy=meanevent2_vy(1:(length(licktimebins)-1));      
        plot(licktimebins(1:(length(licktimebins)-1)),meanevent2_vy,'-r')       
        axis([-preeventtime posteventtime floor(min([meanevent2_vy meanevent1_vy 0])-0.1) ceil(max([meanevent2_vy meanevent1_vy])+0.1)])
        title(['Run speed (bk=' triggerevent1 ', r=' triggerevent2 ')'],'FontSize', 8)
    else 
        axis([-preeventtime posteventtime floor(min([meanevent1_vy 0])-0.1) ceil(max([meanevent1_vy])+0.1)])
        title(['Run speed (bk=' triggerevent1 ')'],'FontSize', 8)
    end   
    
    xlabel('time (s)','FontSize', 8)
    ylabel('run speed (cm/s)','FontSize', 8)
    set(gca,'FontSize', 8, 'TickDir','out')
    hold off
    end