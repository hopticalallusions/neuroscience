 for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        stimesjk=event1_spiketimes{unitj}{trialk};
        if length(stimesjk)==0
        stimesjk=-2*preeventtime;
        end
        
        if length(licktimes)>0 & strmatch(triggerevent1,'CS1')==1
%             correctlick=(cue1_lickyesno(trialk)==1 & solenoid_aftercue1(trialk)==1);
%             correctwithhold=(cue1_lickyesno(trialk)==0 & solenoid_aftercue1(trialk)==0);        
%             if correctlick==1 | correctwithhold==1
            plot([stimesjk;stimesjk],[0.8*ones(size(stimesjk))+(trialind-0.4); zeros(size(stimesjk))+(trialind-0.4)],'Color', 'k')
%             else plot([stimesjk;stimesjk],[0.8*ones(size(stimesjk))+(trialind-0.4); zeros(size(stimesjk))+(trialind-0.4)],'Color', 'r')
%             end
            hold on
            if solenoid_aftercue1(trialk)==1
            plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'Color', 'b')
            end
        else plot([stimesjk;stimesjk],[0.8*ones(size(stimesjk))+(trialind-0.4); zeros(size(stimesjk))+(trialind-0.4)],'Color', 'k')
            hold on
        end
end
title([triggerevent1 ' triggered spiking. Trials: ' trialselection1],'FontSize', 8)
ylabel('trial','FontSize', 8)
axis([-preeventtime posteventtime 0 length(doevent1trials)+1])
set(gca,'FontSize', 8,'TickDir','out')
hold off