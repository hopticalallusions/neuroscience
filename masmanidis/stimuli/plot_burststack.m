disp(['Making a stack of event-triggered binned burst rate ordered by ' stackordermethod])

if strmatch(stackordermethod,'depth')==1
    [neworder, sortindices]=sort(unit_depths);
    units_depthordered=dounits(sortindices);   %orders the units according to depth (low to high # = shallow-to-deep);
    units_depthordered=fliplr(units_depthordered);  %flips from deep-to-shallow ordering to shallow-to-deep ordering
    origunitorder=units_depthordered;    
elseif strmatch(stackordermethod,'event1')==1
    [sortedlatency,sortindices]=sort(cell2mat(event1_peaklatency));   %sort in order of increasing latency to peak firing rate after event 1 presentation.
    origunitorder=dounits(sortindices);               %list of units in order of increasing latency after event 1 presentation.
end



%********1. Unit stack of burst firing, units from all shafts combined********

figind=figind+1;
figure(figind)
set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.4*scrsz(3) 0.8*scrsz(4)])   
hold off

    unitorder=origunitorder;    
    burststack_event1=[];
    burststack_event2=[];

    depthtextlabel=[]; textxpos=[]; textypos=[];
    for unitind=1:length(unitorder);
        unitj=unitorder(unitind);    %proceed in the sorted order of units.
    
        if length(event1_burstrate{unitj})>0
        burststack_event1=[burststack_event1; (event1_burstrate{unitj}')/max(event1_burstrate{unitj})];
        else burststack_event1=[burststack_event1; zeros(size(timebins)-[0 1])];
        end
        
        if length(event2_burstrate{unitj})>0
        burststack_event2=[burststack_event2; (event2_burstrate{unitj}')/max(event2_burstrate{unitj})];
        else burststack_event2=[burststack_event2; zeros(size(timebins)-[0 1])];
        end
    
        if mod(unitind,3)==0
        textxpos=[textxpos 10];
        textypos=[textypos unitind];
        depthunitj=num2str(unitz{unitj});
        depthtextlabel=[depthtextlabel; depthunitj(1:5)];
        end
    
    end

    subplot(2,1,1)   
    imagesc(burststack_event1)
    text(textxpos,textypos,depthtextlabel,'FontSize',8,'Color','w')
    set(gca,'XTick',[-1:(size(burststack_event1,2)*xdiv2/(preeventtime+posteventtime)):size(burststack_event1,2)])
    set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
    ylabel('Ordered cell number','FontSize', 8)
    title([subject ', Normalized bursting. Trials: ' trialselection1 ', All Shafts Combined.'], 'FontSize', 8)
    xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    colorbar
    colormap('spring')
    
    if length(doevent2trials)>0
    subplot(2,1,2)  
    imagesc(burststack_event2)
    text(textxpos,textypos,depthtextlabel,'FontSize',8,'Color','w')
    set(gca,'XTick',[-1:(size(burststack_event2,2)*xdiv2/(preeventtime+posteventtime)):size(burststack_event2,2)])
    set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
    ylabel('Ordered cell number','FontSize', 8)
    title(['Trials: ' trialselection2 '.'], 'FontSize', 8)
    xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    colorbar
    colormap('spring')
    end
    
saveas(figure(figind),[stimephysjpgdir 'burst_stack.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'burst_stack.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'burst_stack.fig' ]  ,'fig')
%*******End of plot 1******
