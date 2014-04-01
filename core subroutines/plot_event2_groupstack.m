if length(doevent2trials)>0

event2_groupstack=[];
for groupk=1:event2_trialgroups
event2_groupstack=[event2_groupstack; event2_grouprate{unitj}{groupk}];
end

h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
event2_groupstack=filter2(h, event2_groupstack);

if strmatch(groupplotstyle,'waterfall')==1
h=waterfall(event2_groupstack);
set(h,'LineWidth',0.5)
elseif strmatch(groupplotstyle,'surf')==1
surf(event2_groupstack)
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

title([triggerevent2 ' triggered firing in groups of ' num2str(trialgroupsize) ' trials'],'FontSize', 8)

set(gca,'XTick',0:1/timebinsize:length(timebins))
set(gca,'XTickLabel',min(timebins):1:max(timebins), 'FontSize', 8)

set(gca,'YTick',[0:2:event2_trialgroups])
set(gca,'YTickLabel',[0:2:event2_trialgroups], 'FontSize', 8)

axis([0 length(timebins) 0 event2_trialgroups 0 maxploty])

% caxis([0 maxploty])
% colorbar;
set(gca,'FontSize',8,'TickDir','out')

end

