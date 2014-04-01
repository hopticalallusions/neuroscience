for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        burststimesjk=event1_bursttimes{unitj}{trialk};
        if length(burststimesjk)==0
        burststimesjk=-2*preeventtime;
        end
        
        if length(licktimes)>0 & strmatch(triggerevent1,'CS1')==1
            plot([burststimesjk;burststimesjk],[0.8*ones(size(burststimesjk))+(trialind-0.4); zeros(size(burststimesjk))+(trialind-0.4)],'Color', 'k')
            hold on
            if solenoid_aftercue1(trialk)==1
            plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'Color', 'b')
            end
        else plot([burststimesjk;burststimesjk],[0.8*ones(size(burststimesjk))+(trialind-0.4); zeros(size(burststimesjk))+(trialind-0.4)],'Color', 'k')
            hold on
        end
end
title(['Unit ' num2str(unitj) '; min. burst ISI=' num2str(minburstisi) ' s; using at least ' num2str(minspikesperburst) ' spikes/burst'],'FontSize', 8)
ylabel('trial','FontSize', 8)
xlabel([triggerevent1 ' triggered bursts'],'FontSize', 8)
axis([-preeventtime posteventtime 0 length(doevent1trials)+1])
set(gca,'FontSize', 8,'TickDir','out')
hold off