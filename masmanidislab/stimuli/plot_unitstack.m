disp(['Making a stack of event-triggered average firing rate ordered by ' stackordermethod])

% if strmatch(stackordermethod,'DV')==1
%     [neworder, sortindices]=sort(unit_DV);
%     units_depthordered=dounits(sortindices);   %orders the units according to depth (low to high # = shallow-to-deep);
%     units_depthordered=fliplr(units_depthordered);  %flips from deep-to-shallow ordering to shallow-to-deep ordering
%     origunitorder=units_depthordered;   
% elseif strmatch(stackordermethod,'ML')==1
%     [neworder, sortindices]=sort(unit_ML);
%     units_MLordered=dounits(sortindices);   %orders the units according to ML axis (medial at bottom, lateral at top of combined stack plot).
%     units_MLordered=fliplr(units_MLordered);  %flips from deep-to-shallow ordering to shallow-to-deep ordering
%     origunitorder=units_MLordered;    
% elseif strmatch(stackordermethod,'event1')==1
%     [sortedlatency,sortindices]=sort(cell2mat(event1_peaklatency));   %sort in order of increasing latency to peak firing rate after event 1 presentation.
%     origunitorder=dounits(sortindices);               %list of units in order of increasing latency after event 1 presentation.
% end


if strmatch(stackordermethod,'DV')==1
    [neworder, sortindices]=sort(unit_DV, 'descend');
    units_depthordered=dounits(sortindices);   %orders the units according to depth (low to high # = shallow-to-deep);
    origunitorder=units_depthordered;   
    orderlabel='ventral <---> dorsal';
elseif strmatch(stackordermethod,'ML')==1
    [neworder, sortindices]=sort(unit_ML);
    units_MLordered=dounits(sortindices);   %orders the units according to ML axis (medial at bottom, lateral at top of combined stack plot).
    origunitorder=units_MLordered;    
    orderlabel='lateral <---> medial';
elseif strmatch(stackordermethod,'event1')==1
    [sortedlatency,sortindices]=sort(cell2mat(event1_peaklatency));   %sort in order of increasing latency to peak firing rate after event 1 presentation.
    origunitorder=dounits(sortindices);               %list of units in order of increasing latency after event 1 presentation.
    orderlabel='ordered by latency';
elseif strmatch(stackordermethod,'event2')==1
    [sortedlatency,sortindices]=sort(cell2mat(event2_peaklatency));   %sort in order of increasing latency to peak firing rate after event 1 presentation.
    origunitorder=dounits(sortindices);               %list of units in order of increasing latency after event 1 presentation.
    orderlabel='ordered by latency';
end


%**********1. Plot normalized firing of all units grouped by shaft.**********
figind=1;
figure(figind)
scrsz=get(0,'ScreenSize');
% set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
set(gcf,'Position',[-1 0 scrsz(3) scrsz(4)])

for shaftind=1:length(uniqueshafts);
    currentshaft=uniqueshafts(shaftind);
    unitsonshaft=find(parameters.shafts==currentshaft);
    unitorder=intersect(origunitorder,unitsonshaft,'stable');   %'stable' keeps the original order of unitorder;  

        firingstack_event1=[];
        firingstack_event2=[];

        depthtextlabel=[]; textxpos=[]; textypos=[];
        for unitind=1:length(unitorder);
            unitj=unitorder(unitind);    %proceed in the sorted order of units.
    
            if length(normrate_event1{unitj})>1
            firingstack_event1=[firingstack_event1; normrate_event1{unitj}'];
            firingstack_event2=[firingstack_event2; normrate_event2{unitj}'];
            end
    
            if mod(unitind,3)==0
            textxpos=[textxpos 10];
            textypos=[textypos unitind];
            depthunitj=num2str(unitz{unitj});
            depthtextlabel=[depthtextlabel; depthunitj(1:4)];
            end
    
        end
        hold off
        
        subplot(2,length(uniqueshafts),shaftind)
        imagesc(firingstack_event1,[-1 1])
        text(textxpos,textypos,depthtextlabel,'FontSize',8,'Color','b')
%         axis square
        set(gca,'XTick',[-1:(size(firingstack_event1,2)*xdiv2/(preeventtime+posteventtime)):size(firingstack_event1,2)])
        set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
%       xlabel('Time (s)','FontSize', 8)
        ylabel(orderlabel,'FontSize', 8)
        title(['Event 1; Shaft ' num2str(currentshaft) ', AP=' num2str(positions.AP{currentshaft}) ', ML=' num2str(positions.ML{currentshaft}) ' mm'], 'FontSize', 8)
        xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
        set(gca,'FontSize',8,'TickDir','out')
%         set(gca,'PlotBoxAspectRatio',[1.62*length(unitorder) 1 1])
        colorbar
        colormap('jet')

        subplot(2,length(uniqueshafts),length(uniqueshafts)+shaftind)
        if length(event2times)>0
        imagesc(firingstack_event2,[-1 1])
        text(textxpos,textypos,depthtextlabel,'FontSize',8, 'Color','b')
%         axis square
        set(gca,'XTick',[-1:(size(firingstack_event1,2)*xdiv2/(preeventtime+posteventtime)):size(firingstack_event1,2)])
        set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
        % xlabel('Time (s)','FontSize', 8)
        ylabel(orderlabel,'FontSize', 8)
        title(['Event 2; Shaft ' num2str(currentshaft) ', AP=' num2str(positions.AP{currentshaft}) ', ML=' num2str(positions.ML{currentshaft}) ' mm'], 'FontSize', 8)
        xlabel(['Time (s).    ' plotlabel], 'FontSize', 8)
        set(gca,'FontSize',8,'TickDir','out')
%         set(gca,'PlotBoxAspectRatio',[1.62*length(unitorder) 0.5 1])
        colorbar
        colormap('jet')
        else axis off

        end

        
end

saveas(figure(figind),[stimephysjpgdir 'unitstack.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'unitstack.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'unitstack.fig' ]  ,'fig')

%*********End of plotting unit stack****************



%********2. Plot population average in specified depth bins, separated by shaft********
figind=figind+1;
figure(figind)
set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
hold off

zbins=min(elecz):zbinsize:(max(elecz)+zbinsize);
roundedzbins=round(zbins*10)/10;
[n,binindex]=histc(unit_DV,zbins);   %specifies a depth bin for each unit in steps of zbinsize.
for shaftind=1:length(uniqueshafts);
    currentshaft=uniqueshafts(shaftind);
    unitsonshaft=find(parameters.shafts==currentshaft);
    
    avgstack_event1=[]; errorstack_event1=[];
    avgstack_event2=[]; errorstack_event2=[];
    for binind=1:(length(zbins)-1)
        unitsinbin=dounits(find(binindex==binind));
        unitsinbin=intersect(unitsinbin,unitsonshaft);      

        if length(unitsinbin)>1
            ratesbin_event1=[]; ratesbin_event2=[];
            for unitind=1:length(unitsinbin)
                unitj=unitsinbin(unitind);
                ratesbin_event1=[ratesbin_event1; zscore_event1{unitj}];
                ratesbin_event2=[ratesbin_event2; zscore_event2{unitj}];
            end           
            avgstack_event1{binind}=mean(ratesbin_event1);
            errorstack_event1{binind}=std(ratesbin_event1);
            avgstack_event2{binind}=mean(ratesbin_event2);
            errorstack_event2{binind}=std(ratesbin_event2);          
        elseif length(unitsinbin)==1
            avgstack_event1{binind}=zscore_event1{unitsinbin};
            errorstack_event1{binind}=zeros(1,(length(timebins)-1));  
            avgstack_event2{binind}=zscore_event2{unitsinbin};
            errorstack_event2{binind}=zeros(1,(length(timebins)-1)); 
        elseif length(unitsinbin)==0
            avgstack_event1{binind}=zeros(1,(length(timebins)-1));
            errorstack_event1{binind}=zeros(1,(length(timebins)-1));
            avgstack_event2{binind}=zeros(1,(length(timebins)-1));
            errorstack_event2{binind}=zeros(1,(length(timebins)-1));
        end
         
        subplot(1,length(uniqueshafts), shaftind)
        plot(timebins(1:(length(timebins)-1)), avgstack_event1{binind}+zscorediv*(binind-1),'k')
        hold on  
    
        if length(event2times)>0
        plot(timebins(1:(length(timebins)-1)), avgstack_event2{binind}+zscorediv*(binind-1),'r')
        end
     
        
    end
    hold off
    
    axis([min(timebins) max(timebins) -zscorediv zscorediv*binind])
    set(gca,'YTick',0:zscorediv:zscorediv*(length(zbins)-2))
    set(gca,'YTickLabel',[roundedzbins])
    ylabel(['Population depth (mm).    Z-score scale: ' num2str(zscorediv) ' / division'],'FontSize', 8)
    title(['Mean popln z-score. Shaft ' num2str(currentshaft) ', AP=' num2str(positions.AP{currentshaft}) ', ML=' num2str(positions.ML{currentshaft}) ' mm'], 'FontSize', 8)
    xlabel(['Time (s).    ' plotlabel], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
  
end

saveas(figure(figind),[stimephysjpgdir 'population_zscore.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'population_zscore.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'population_zscore.fig' ]  ,'fig')
%*******End of plot 2******

%********3. Plot population average in specified depth bins, & unit stack, units from all shafts combined********
figind=figind+1;
figure(figind)
set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
hold off

    avgstack_event1=[]; errorstack_event1=[];
    avgstack_event2=[]; errorstack_event2=[];
    for binind=1:(length(zbins)-1)
        unitsinbin=dounits(find(binindex==binind));

        if length(unitsinbin)>1
            ratesbin_event1=[]; ratesbin_event2=[];
            for unitind=1:length(unitsinbin)
                unitj=unitsinbin(unitind);
                ratesbin_event1=[ratesbin_event1; zscore_event1{unitj}];
                ratesbin_event2=[ratesbin_event2; zscore_event2{unitj}];
            end           
            avgstack_event1{binind}=mean(ratesbin_event1);
            errorstack_event1{binind}=std(ratesbin_event1);
            avgstack_event2{binind}=mean(ratesbin_event2);
            errorstack_event2{binind}=std(ratesbin_event2);          
        elseif length(unitsinbin)==1
            avgstack_event1{binind}=zscore_event1{unitsinbin};
            errorstack_event1{binind}=zeros(1,(length(timebins)-1));  
            avgstack_event2{binind}=zscore_event2{unitsinbin};
            errorstack_event2{binind}=zeros(1,(length(timebins)-1)); 
        elseif length(unitsinbin)==0
            avgstack_event1{binind}=zeros(1,(length(timebins)-1));
            errorstack_event1{binind}=zeros(1,(length(timebins)-1));
            avgstack_event2{binind}=zeros(1,(length(timebins)-1));
            errorstack_event2{binind}=zeros(1,(length(timebins)-1));
        end
        
        subplot(2,2,[1 3])   %same plot size as plot # 2, for clarity.
        plot(timebins(1:(length(timebins)-1)), avgstack_event1{binind}+zscorediv*(binind-1),'k')
        hold on  
    
        if length(event2times)>0
        plot(timebins(1:(length(timebins)-1)), avgstack_event2{binind}+zscorediv*(binind-1),'r')
        end
     
        
    end
    hold off
    
    axis([min(timebins) max(timebins) -zscorediv zscorediv*binind])
    set(gca,'YTick',0:zscorediv:zscorediv*(length(zbins)-2))
    set(gca,'YTickLabel',[roundedzbins])
    ylabel(['Population depth (mm).    Z-score scale: ' num2str(zscorediv) ' / division'],'FontSize', 8)
    title([subject '; Population z-score; all shafts combined.'], 'FontSize', 8)
    xlabel(['Time (s).    ' plotlabel], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    
    
    unitorder=origunitorder;    
    firingstack_event1=[];
    firingstack_event2=[];

%     depthtextlabel=[]; textxpos=[]; textypos=[];
    for unitind=1:length(unitorder);
        unitj=unitorder(unitind);    %proceed in the sorted order of units.
    
        if length(normrate_event1{unitj})>1
        firingstack_event1=[firingstack_event1; normrate_event1{unitj}'];
        firingstack_event2=[firingstack_event2; normrate_event2{unitj}'];
        end
    
%         if mod(unitind,3)==0
%         textxpos=[textxpos 10];
%         textypos=[textypos unitind];
%         depthunitj=num2str(unitz{unitj});
%         depthtextlabel=[depthtextlabel; depthunitj(1:5)];
%         end
    
    end
    hold off
    
    subplot(2,2,2)   %same plot size as plot # 2, for clarity.
    imagesc(firingstack_event1,[-1 1])
%     text(textxpos,textypos,depthtextlabel,'FontSize',8,'Color','b')
    set(gca,'XTick',[-1:(size(firingstack_event1,2)*xdiv2/(preeventtime+posteventtime)):size(firingstack_event1,2)])
    set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
    ylabel(orderlabel,'FontSize', 8)
    title([triggerevent1 ' triggered stack. Trials: ' trialselection1 '.'], 'FontSize', 8)
    xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    colorbar
    colormap('jet')
    
    if length(event2times)>0
    subplot(2,2,4)   %same plot size as plot # 2, for clarity.
    imagesc(firingstack_event2,[-1 1])
%     text(textxpos,textypos,depthtextlabel,'FontSize',8,'Color','b')
    set(gca,'XTick',[-1:(size(firingstack_event2,2)*xdiv2/(preeventtime+posteventtime)):size(firingstack_event2,2)])
    set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
    ylabel(orderlabel,'FontSize', 8)
    title([triggerevent2 ' triggered stack. Trials: ' trialselection2 '.'], 'FontSize', 8)
    xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    colorbar
    colormap('jet')
    end
    
saveas(figure(figind),[stimephysjpgdir 'combine_popln.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'combine_popln.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'combine_popln.fig' ]  ,'fig')
%*******End of plot 3******


if onlysigmod=='y' 
%********4. Plot stack only showing query bins of significant excitation or inhibition relative to baseline********
figind=figind+1;
figure(figind)
set(gcf,'Position',[-1.6*scrsz(1)+40 0.6*scrsz(2)+100 0.25*scrsz(3) 0.75*scrsz(4)])   
hold off

sigplot_start=query_start;
sigplot_end=query_end;
sigtest_binsize=firing_pvalue.sigtest_binsize;
sigplot_timebins=sigplot_start:sigtest_binsize:sigplot_end;

unitorder=origunitorder;    
firingstack_event1=[];
firingstack_event2=[];

for unitind=1:length(unitorder);
    unitj=unitorder(unitind);    %proceed in the sorted order of units.   
    firingstack_event1=[firingstack_event1; event1_sigbins{unitj}];   
    
    if strcmp(firing_pvalue.triggerevent2,'none')~=1 & length(doevent2trials)~=0 
    firingstack_event2=[firingstack_event2; event2_sigbins{unitj}];
    end
    
end

subplot(2,1,1)
imagesc(firingstack_event1)
c=[0 0 1; 1 1 1; 1 0 0];  %three-point color map matrix
colormap(c)  %red white blue color map
ylabel(orderlabel,'FontSize', 8)
title([triggerevent1 ' triggered stack. Trials: ' trialselection1 '.'], 'FontSize', 8)
xlabel(['Time (s)'], 'FontSize', 8)
set(gca,'XTick',[0:(size(firingstack_event1,2)*xdiv2/(-sigplot_start+sigplot_end)):size(firingstack_event1,2)])
set(gca,'XTickLabel',[sigplot_start:xdiv2:sigplot_end])
set(gca,'FontSize',8,'TickDir','out')

if strcmp(firing_pvalue.triggerevent2,'none')~=1 & length(doevent2trials)~=0 
subplot(2,1,2)
imagesc(firingstack_event2)
ylabel(orderlabel,'FontSize', 8)
title([firing_pvalue.triggerevent2 ' triggered stack. Trials: ' firing_pvalue.trialselection2 '.'], 'FontSize', 8)
xlabel(['Time (s)'], 'FontSize', 8)
set(gca,'XTick',[0:(size(firingstack_event1,2)*xdiv2/(sigplot_start+sigplot_end)):size(firingstack_event1,2)])
set(gca,'XTickLabel',[sigplot_start:xdiv2:sigplot_end])
set(gca,'FontSize',8,'TickDir','out')
end

saveas(figure(figind),[stimephysjpgdir 'sigfiring_times.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'sigfiring_times.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'sigfiring_times.fig' ]  ,'fig')
%*******End of plot 4******
end
