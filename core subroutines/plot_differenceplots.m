%plot_fancyplots
sigdir = [stimephysdir 'significance tests\'];
sigratedir = [sigdir triggerevent1 ' ' trialselection1 ' & ' triggerevent2 ' ' trialselection2 '\'];
mkdir(sigratedir)

plot_max = max([max(mean(var1_post)) max(mean(var2_post))]);    %for a good y-axis plot scale.

subplot(2,1,1)
plot(querytimebins,mean(var1_post),'LineWidth',2)
hold on
plot(querytimebins,mean(var2_post),'r','LineWidth',2)
set(subplot(2,1,1),'XLim',[query_start (query_end+timebinsize)],'YLim',[-0.5 ceil(plot_max)])

if sum(discriminating_bins{unitj} == 1) > 0
   plot(querytimebins(discriminating_bins{unitj} == 1),plot_max*0.8,'*m','MarkerSize',9)
end

if sum(discriminating_bins{unitj} == -1 ) > 0
   plot(querytimebins(discriminating_bins{unitj} == -1),plot_max*0.7,'*g','MarkerSize',9)    
end
title(['Unit ' num2str(unitj) '. Blue: ' triggerevent1 ' Red: ' triggerevent2])
set(subplot(2,1,1),'XLim',[query_start querytimebins(end)])

subplot(2,1,2)

plot(plottimebins, [mean(event1_spikerate{unitj}(:,1:baselinelength)) - mean(event2_spikerate{unitj}(:,1:baselinelength)) observed_difference{unitj}],'r')
hold on
plot(plottimebins, upperbound{unitj}*ones(size(plottimebins)),'--k')
plot(plottimebins, lowerbound{unitj}*ones(size(plottimebins)),'--k')
xlabel('time (s)')
ylabel('event1-event2 rate (Hz)')
title(['unit ' num2str(unitj)])
plot(querytimebins(discriminating_bins{unitj}==1),observed_difference{unitj}(discriminating_bins{unitj}==1),'*m')
plot(querytimebins(discriminating_bins{unitj}==-1),observed_difference{unitj}(discriminating_bins{unitj}==-1),'*g')

set(figure(1),'Position',get(0,'ScreenSize'))
saveas(figure(1),[sigratedir 'unit ' num2str(unitj) '.jpg'],'jpg')
