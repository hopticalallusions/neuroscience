
event1_groupstack=[];
for groupk=1:event1_trialgroups
event1_groupstack=[event1_groupstack; event1_grouprate{unitj}{groupk}];
end

h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
event1_groupstack=filter2(h, event1_groupstack);

if strmatch(groupplotstyle,'waterfall')==1
h=waterfall(event1_groupstack);
set(h,'LineWidth',0.5)
elseif strmatch(groupplotstyle,'surf')==1
surf(event1_groupstack)
shading interp
end
view(-20,75)

% xlabel(['time (s)'], 'FontSize',8)
% h=get(gca,'xlabel');
% set(h,'rotation',15)
% ylabel(['trial group # (bins of ' num2str(trialgroupsize) ')'], 'FontSize',8)
% h=get(gca,'ylabel');
% set(h,'rotation',-65)
% zlabel(['spikes/s'], 'FontSize', 8)   

title([triggerevent1 ' triggered firing in groups of ' num2str(trialgroupsize) ' trials'],'FontSize', 8)
    
set(gca,'XTick',0:1/timebinsize:length(timebins))
set(gca,'XTickLabel',min(timebins):1:max(timebins), 'FontSize', 8)

set(gca,'YTick',[0:2:event1_trialgroups])
set(gca,'YTickLabel',[0:2:event1_trialgroups], 'FontSize', 8)

if length(event2times)>0
maxrate=max([max(cell2mat(event1_grouprate{unitj})) max(cell2mat(event2_grouprate{unitj}))]);
else
maxrate=max(cell2mat(event1_grouprate{unitj}));
end
maxploty=round(maxrate*100)/100;

if maxploty==0
    maxploty=0.01;
end
 
axis([0 length(timebins) 0 event1_trialgroups 0 maxploty])

% caxis([0 maxploty])
% colorbar;
set(gca,'FontSize',8,'TickDir','out')
