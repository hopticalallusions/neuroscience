if length(licktimes)>0
    for trialind=1:length(doevent2trials);
    trialk=doevent2trials(trialind);
    licktimesi=event2_licktimes{trialk};
    
    correctlick=0; correctwithhold=0;   
    if strmatch(triggerevent2,'CS2')==1
    correctlick=(cue2_lickyesno(trialk)==1 & solenoid_aftercue2(trialk)==1);
    correctwithhold=(cue2_lickyesno(trialk)==0 & solenoid_aftercue2(trialk)==0);
        if solenoid_aftercue2(trialk)==1 
        plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'b')
        end 
    end
    if correctlick==1 | correctwithhold==1 & strmatch(triggerevent2,'CS2')==1
    plot([licktimesi;licktimesi],[0.8*ones(size(licktimesi))+(trialind-0.4); zeros(size(licktimesi))+(trialind-0.4)],'Color', 'k')
    else plot([licktimesi;licktimesi],[0.8*ones(size(licktimesi))+(trialind-0.4); zeros(size(licktimesi))+(trialind-0.4)],'Color', 'r')
    end
    
    hold on
             
    end
    ylabel('trial','FontSize', 8)
    axis([-preeventtime posteventtime 0 length(doevent2trials)+1])
    xlabel('time (s)','FontSize', 8)
    set(gca,'FontSize', 8,'TickDir','out')
    title([triggerevent2 ' triggered licking'],'FontSize', 8)
    hold off
end