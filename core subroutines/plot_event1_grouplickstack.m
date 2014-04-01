if length(event1times)>0

event1_grouplickstack=[];
for groupk=1:event1_trialgroups
event1_grouplickstack=[event1_grouplickstack; event1_grouplickrate{groupk}];
end

h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
event1_grouplickstack=filter2(h, event1_grouplickstack);

if strmatch(groupplotstyle,'waterfall')==1
h=waterfall(event1_grouplickstack);
set(h,'LineWidth',0.5)
elseif strmatch(groupplotstyle,'surf')==1
surf(event1_grouplickstack)
shading interp
end
view(-20,75)

% xlabel(['time (s)'], 'FontSize',8)
% h=get(gca,'xlabel');
% set(h,'rotation',15)
% ylabel(['trial group # (bins of ' num2str(trialgroupsize) ')'], 'FontSize',8)
% h=get(gca,'ylabel');
% set(h,'rotation',-65)
% zlabel(['licks/s'], 'FontSize', 8)   

title([triggerevent1 ' triggered licking in groups of ' num2str(trialgroupsize) ' trials'],'FontSize', 8)

set(gca,'XTick',0:1/timebinsize:length(timebins))
set(gca,'XTickLabel',min(timebins):1:max(timebins), 'FontSize', 8)

set(gca,'YTick',[0:2:event1_trialgroups])
set(gca,'YTickLabel',[0:2:event1_trialgroups], 'FontSize', 8)

if length(event2times)>0
maxlickrate=max([cell2mat(event1_grouplickrate) cell2mat(event2_grouplickrate)]);
else
maxlickrate=max(cell2mat(event1_grouplickrate));
end
maxlickploty=round(maxlickrate*100)/100;

axis([0 length(timebins) 0 event1_trialgroups 0 maxlickploty])

% caxis([0 maxploty])
% colorbar;
set(gca,'FontSize',8,'TickDir','out')

end
