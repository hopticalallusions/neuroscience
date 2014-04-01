mean_multievent1=sum(multi_zstack_e1)/size(multi_zstack_e1,1);    %mean multi-subject z-score
sem_multievent1=std(multi_zstack_e1)/sqrt(size(multi_zstack_e1,1));
mean_multievent2=sum(multi_zstack_e2)/size(multi_zstack_e2,1);
sem_multievent2=std(multi_zstack_e2)/sqrt(size(multi_zstack_e2,1));

mean_multilick_event1=sum(multilickrate_event1)/size(multilickrate_event1,1);
sem_multilick_event1=std(multilickrate_event1)/sqrt(size(multilickrate_event1,1));
mean_multilick_event2=sum(multilickrate_event2)/size(multilickrate_event2,1);
sem_multilick_event2=std(multilickrate_event2)/sqrt(size(multilickrate_event2,1));

mean_multirunspeed_event1=sum(multirunspeed_event1)/size(multirunspeed_event1,1);
sem_multirunspeed_event1=std(multirunspeed_event1)/sqrt(size(multirunspeed_event1,1));
mean_multirunspeed_event2=sum(multirunspeed_event2)/size(multirunspeed_event2,1);
sem_multirunspeed_event2=std(multirunspeed_event2)/sqrt(size(multirunspeed_event2,1));

if strmatch(stackordermethod,'DV')==1
    [neworder, sortindices]=sort(unit_DV, 'descend');   
    orderlabel='ventral <---> dorsal';
elseif strmatch(stackordermethod,'ML')==1
    [neworder, sortindices]=sort(unit_ML);
    orderlabel='lateral <---> medial';
elseif strcmp(stackordermethod,'event1')==1  
    [sortedlatency,sortindices]=sort(plot_latency_e1);   %sort in order of increasing latency to peak firing rate after event 1 presentation.
    orderlabel='ordered by event 1 latency';
elseif strcmp(stackordermethod,'event2')==1  
    [sortedlatency,sortindices]=sort(plot_latency_e2);   %sort in order of increasing latency to peak firing rate after event 2 presentation.
    orderlabel='ordered by event 2 latency';
end

multistack_event1=multistack_event1(sortindices,:);
multistack_event2=multistack_event2(sortindices,:);    

if onlysigmod=='y'
sigbinstack_event1=sigbinstack_event1(sortindices,:);
sigbinstack_event2=sigbinstack_event2(sortindices,:);
end

allsync_e1=[]; allsync_e2=[];
for subjectind = 1:length(subjects); 
    allsync_e1=[allsync_e1, multisubject.event1_syncrate{subjectind}];
    allsync_e2=[allsync_e2, multisubject.event2_syncrate{subjectind}]; 
end
meansync_e1=mean(allsync_e1');
meansync_e2=mean(allsync_e2');
semsync_e1=std(allsync_e1')/sqrt(length(subjects));
semsync_e2=std(allsync_e2')/sqrt(length(subjects));



% x = unique(floor(timebins));
% xticks = [];
% for i = 1:length(timebins)
%     if abs(intersect(timebins(i),x)) >= 0 
%         xticks = [xticks i];
%     end
% end

figind=1;
scrsz=get(0,'ScreenSize');

figure(figind)

subplot(10,1,[1:3])   
imagesc(multistack_event1,[-1 1])
    
set(gca,'Xlim',[0 length(timebins)-0.5])
set(gca,'XTick',[0:(size(multistack_event1,2)*xdiv2/(preeventtime+posteventtime)):size(multistack_event1,2)])  %note: plot limits are different from plot_unitstack. 
set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
ylabel(orderlabel,'FontSize', 8)
title([num2str(totalmodunits) ' ' plotlabel ', n=' num2str(length(subjects)) ' subjects. ' triggerevent1 ', ' trialselection1 '.'], 'FontSize', 8)
% xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
%         set(gca,'PlotBoxAspectRatio',[1.62*length(unitorder) 1 1])
% colorbar('FontSize', 8)
colormap('jet')
 

subplot(10,1,[4:6])   
imagesc(multistack_event2,[-1 1])
    
set(gca,'Xlim',[0 length(timebins)-0.5])
set(gca,'XTick',[0:(size(multistack_event2,2)*xdiv2/(preeventtime+posteventtime)):size(multistack_event2,2)])
set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
ylabel(orderlabel,'FontSize', 8)
% title([triggerevent2 ', ' trialselection2 '.'], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
% colorbar('FontSize', 8)
colormap('jet')


subplot(10,1,[7]) 

hold off
boundedline(timebins(1:(length(timebins)-1)),mean_multievent2, sem_multievent2, set_CS2color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
hold on
boundedline(timebins(1:(length(timebins)-1)),mean_multievent1, sem_multievent1, set_CS1color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
ylabel(['z-score'] ,'FontSize', 8)
axis([-preeventtime posteventtime min_ploty max_ploty])
set(gca,'XTick',[-preeventtime:xdiv2:posteventtime])
set(gca,'XTickLabel',[])
set(gca,'YTick',[0:2:max_ploty])
set(gca,'FontSize',8,'TickDir','out')


subplot(10,1,[8]) 

hold off
boundedline(timebins(1:end-1),meansync_e1, semsync_e1, set_CS1color)  %do not use 'alpha' (transparent shading) because this will mess up eps export.
hold on
boundedline(timebins(1:end-1),meansync_e2, semsync_e2, set_CS2color)  %do not use 'alpha' (transparent shading) because this will mess up eps export.
ylabel(['sync'] ,'FontSize', 8)
axis([-preeventtime posteventtime 0 max_plotsync])
set(gca,'XTick',[-preeventtime:xdiv2:posteventtime])
set(gca,'XTickLabel',[])
set(gca,'YTick',[0:0.01:max_plotsync])
set(gca,'FontSize',8,'TickDir','out')


subplot(10,1,9)  

if length(licktimes)>0
hold off
boundedline(licktimebins(1:end-1),mean_multilick_event2, sem_multilick_event2, set_CS2color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
hold on
boundedline(licktimebins(1:end-1),mean_multilick_event1, sem_multilick_event1, set_CS1color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
ylabel(['Lick rate (Hz)'] ,'FontSize', 8)
axis([-preeventtime posteventtime 0 8])
set(gca,'XTick',[-1:xdiv2:posteventtime])
set(gca,'XTickLabel',[])
set(gca,'YTick',[0:2:8])
set(gca,'FontSize',8,'TickDir','out')
end


subplot(10,1,10)   

hold off
boundedline(runtimebins(1:end-1),mean_multirunspeed_event2, sem_multirunspeed_event2, set_CS2color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
hold on
boundedline(runtimebins(1:end-1),mean_multirunspeed_event1, sem_multirunspeed_event1, set_CS1color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
xlabel(['Time (s)'], 'FontSize', 8)
ylabel(['Speed (cm/s)'] ,'FontSize', 8)
axis([-preeventtime posteventtime 0 20])
set(gca,'XTick',[-1:xdiv2:posteventtime])
set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
set(gca,'YTick',[0:5:20])
set(gca,'FontSize',8,'TickDir','out')


set(gcf,'Position',[-1.6*scrsz(1)+80 0.6*scrsz(2)+100 0.2*scrsz(3) 0.85*scrsz(4)])   
colormap('jet')
    
% saveas(figure(figind),[combinedir 'multisubject_stack.jpg' ]  ,'jpg')
% saveas(figure(figind),[combinedir 'multisubject_stack.eps' ]  ,'psc2')
% saveas(figure(figind),[combinedir 'multisubject_stack.fig' ]  ,'fig')
%*******End of plot 3******


if onlysigmod=='y'  

figind=figind+1;
figure(figind)


sigplot_start=firing_pvalue.query_start;
sigplot_end=firing_pvalue.query_end;
sigtest_binsize=firing_pvalue.sigtest_binsize;
sigplot_timebins=sigplot_start:sigtest_binsize:sigplot_end;

subplot(10,1,[1:3])   
imagesc(sigbinstack_event1)
c=[0 0 1; 1 1 1; 1 0 0];  %three-point color map matrix  
set(gca,'Xlim',[0 length(sigplot_timebins)-0.5])

set(gca,'XTick',[0:(size(sigbinstack_event1,2)*xdiv2/(-sigplot_start+sigplot_end)):size(sigbinstack_event1,2)])  %note: plot limits are different from plot_unitstack. 
set(gca,'XTickLabel',[sigplot_start:xdiv2:sigplot_end])
ylabel(orderlabel,'FontSize', 8)
title([num2str(totalmodunits) ' ' plotlabel ', n=' num2str(length(subjects)) ' subjects. ' triggerevent1 ', ' trialselection1 '.'], 'FontSize', 8)
% xlabel([plotlabel '.    Time (s)'], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
% colorbar('FontSize', 8)
colormap(c)  %red white blue color map
 
subplot(10,1,[4:6])   
imagesc(sigbinstack_event2)
c=[0 0 1; 1 1 1; 1 0 0];  %three-point color map matrix  
set(gca,'Xlim',[0 length(sigplot_timebins)-0.5])
set(gca,'XTick',[0:(size(sigbinstack_event2,2)*xdiv2/(-sigplot_start+sigplot_end)):size(sigbinstack_event2,2)])  %note: plot limits are different from plot_unitstack. 
set(gca,'XTickLabel',[sigplot_start:xdiv2:sigplot_end])
xlabel(['Time (s)'], 'FontSize', 8)
ylabel(orderlabel,'FontSize', 8)
title([triggerevent2 ', ' trialselection2 '.'], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
% colorbar('FontSize', 8)
colormap(c)  %red white blue color map

set(gcf,'Position',[scrsz(1)+500 0.6*scrsz(2)+100 0.2*scrsz(3) 0.85*scrsz(4)])   

end
