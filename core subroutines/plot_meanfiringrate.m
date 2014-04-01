    boundedline(timebins(1:(length(timebins)-1)), event1_spikerate{unitj}, event1_semrate{unitj},'-k');   %do not use 'alpha' (transparent shading) because this will mess up eps export.
 
    hold on
    if length(event2times)>0
    boundedline(timebins(1:(length(timebins)-1)), event2_spikerate{unitj}, event2_semrate{unitj},'-r');   %do not use 'alpha' (transparent shading) because this will mess up eps export.
    end 
    uppersigrate=baselinerate{unitj}+3*stdbaselinerate{unitj};
    lowersigrate=baselinerate{unitj}-3*stdbaselinerate{unitj};
    plot(timebins(1:(length(timebins)-1)), uppersigrate*ones(1,(length(timebins)-1)),'--g') %plot lines denoting the upper and lower boundaries for significance
    plot(timebins(1:(length(timebins)-1)), lowersigrate*ones(1,(length(timebins)-1)),'--g')
    
    if length(event2times)>0
    maxrate=max([max(event1_spikerate{unitj}) max(event2_spikerate{unitj})]);
    else
        maxrate=max([max(event1_spikerate{unitj}) max(event2_spikerate{unitj})]);
    end
    xlabel('time (s)', 'FontSize',8)
    ylabel('firing rate (Hz)','FontSize', 8)
    title(['baseline rate=' num2str(baselinerate{unitj}) ' Hz. ' num2str(length(spiketimes{unitj})) ' total spikes.'],'FontSize', 8)   

    if maxrate<0.5
        maxploty=0.5;
    elseif maxrate>=0.5 & maxrate<1
        maxploty=1;
    elseif maxrate>=1 & maxrate<2
        maxploty=2;
    elseif maxrate>=2 & maxrate<4
        maxploty=4;
    elseif maxrate>=4 & maxrate<6
        maxploty=6;
    elseif maxrate>=6 & maxrate<8
        maxploty=8;
    elseif maxrate>=8 & maxrate<10
        maxploty=10;
    elseif maxrate>=10 & maxrate<15
        maxploty=15;
    elseif maxrate>=15 & maxrate<20
        maxploty=20;
    elseif maxrate>=20 & maxrate<30
        maxploty=30;
    elseif maxrate>=30 & maxrate<40
        maxploty=40;
    elseif maxrate>=40 & maxrate<50
        maxploty=50;
    elseif maxrate>=50 & maxrate<70
        maxploty=70;
    elseif maxrate>=70 & maxrate<100
        maxploty=100;
    else maxploty=round(maxrate);
    end
    axis([-preeventtime posteventtime 0 maxploty])
    set(gca,'FontSize', 8,'TickDir','out')
    hold off