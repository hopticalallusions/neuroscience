  if length(doevent2trials)>0
    for trialind=1:length(doevent2trials);
        trialk=doevent2trials(trialind);
        burststimesjk=event2_bursttimes{unitj}{trialk};
        if length(burststimesjk)==0
        burststimesjk=-2*preeventtime;
        end
        
        if length(licktimes)>0 & strmatch(triggerevent2,'CS2')==1
%             correctlick=(cue2_lickyesno(trialk)==1 & solenoid_aftercue2(trialk)==1);
%             correctwithhold=(cue2_lickyesno(trialk)==0 & solenoid_aftercue2(trialk)==0);       
%             if correctlick==1 | correctwithhold==1
            plot([burststimesjk;burststimesjk],[0.8*ones(size(burststimesjk))+(trialind-0.4); zeros(size(burststimesjk))+(trialind-0.4)],'Color', 'k')
%             else plot([burststimesjk;burststimesjk],[0.8*ones(size(burststimesjk))+(trialind-0.4); zeros(size(burststimesjk))+(trialind-0.4)],'Color', 'r')
%             end
            hold on
            if solenoid_aftercue2(trialk)==1
            plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'b')  
            end
        else plot([burststimesjk;burststimesjk],[0.8*ones(size(burststimesjk))+(trialind-0.4); zeros(size(burststimesjk))+(trialind-0.4)],'Color', 'k')
            hold on
        end
end
title(['baseline firing: ' num2str(baselinerate{unitj}) ' Hz'], 'FontSize',8)
ylabel('trial','FontSize', 8)
xlabel([triggerevent2 ' triggered bursts'],'FontSize', 8)
axis([-preeventtime posteventtime 0 length(doevent2trials)+1])
set(gca,'FontSize', 8,'TickDir','out')
hold off
else axis off    
end