%****Latency and firing duration analysis***
latencybins=0:latencybinsize:posteventtime;
durationbins=[0:durationbinsize:posteventtime];
pos_deltaratebins=[0:ratebinsize:max_plotdeltarate];
neg_deltaratebins=[-1:ratebinsize:0];
baselinebins=[0:ratebinsize:max_plotbaseline];
fluctuationbins=[0:fluctbinsize:max_plotfluct];

histmaxlatency_e1=histc(event1_peaklatency,latencybins)/length(event1_peaklatency);           
histmaxlatency_e2=histc(event2_peaklatency,latencybins)/length(event2_peaklatency);           
histminlatency_e1=histc(event1_minlatency,latencybins)/length(event1_minlatency);           
histminlatency_e2=histc(event2_minlatency,latencybins)/length(event2_minlatency);           

figind=150;
figure(figind)

subplot(3,5,1)
hold on
plot(latencybins,histmaxlatency_e1, 'Color', set_CS1color, 'LineWidth',1);
xlabel(['Latency to peak (s)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
title([plotlabel '. ' triggerevent1 ', ' trialselection1 '.'], 'FontSize', 8)
axis([0 posteventtime 0 0.5])
set(gca,'XTick',[0:1:posteventtime])
set(gca,'XTickLabel',[0:1:posteventtime])
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,6)
hold on
plot(latencybins,histmaxlatency_e2, 'Color', set_CS2color, 'LineWidth',1);
xlabel(['Latency to peak (s)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
title([triggerevent2 ', ' trialselection2 '.'], 'FontSize', 8)
axis([0 posteventtime 0 0.5])
set(gca,'XTick',[0:1:posteventtime])
set(gca,'XTickLabel',[0:1:posteventtime])
set(gca,'FontSize',8,'TickDir','out')
hold off

% subplot(4,4,3)
% hold on
% plot(latencybins,histminlatency_e1, 'Color', set_CS1color, 'LineWidth',1);
% xlabel(['Latency to minimum (s)'], 'FontSize', 8)
% ylabel(['prob'] ,'FontSize', 8)
% axis([0 posteventtime 0 0.5])
% set(gca,'XTick',[0:1:posteventtime])
% set(gca,'XTickLabel',[0:1:posteventtime])
% set(gca,'FontSize',8,'TickDir','out')
% hold off
% 
% subplot(4,4,4)
% hold on
% plot(latencybins,histminlatency_e2, 'Color', set_CS2color, 'LineWidth',1);
% xlabel(['Latency to minimum (s)'], 'FontSize', 8)
% ylabel(['prob'] ,'FontSize', 8)
% axis([0 posteventtime 0 0.5])
% set(gca,'XTick',[0:1:posteventtime])
% set(gca,'XTickLabel',[0:1:posteventtime])
% set(gca,'FontSize',8,'TickDir','out')
% hold off


if onlysigmod=='y'

histexcited_e1=histc(sigexcited_e1,durationbins)/length(sigexcited_e1);
histinhibited_e1=histc(siginhibited_e1,durationbins)/length(siginhibited_e1);

histexcited_e2=histc(sigexcited_e2,durationbins)/length(sigexcited_e2);
histinhibited_e2=histc(siginhibited_e2,durationbins)/length(siginhibited_e2);


subplot(3,5,2)
hold on
plot(durationbins,histexcited_e1, 'Color', set_CS1color, 'LineWidth',1);
xlabel(['duration (s)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
title(['duration of excitation after CS1'], 'FontSize', 8)
axis([0 posteventtime 0 0.5])
set(gca,'XTick',[0:1:posteventtime])
set(gca,'XTickLabel',[0:1:(posteventtime)])
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,7)
hold on
plot(durationbins,histexcited_e2,'Color', set_CS2color, 'LineWidth',1);
xlabel(['duration (s)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
title(['duration of excitation after CS2'], 'FontSize', 8)
axis([0 posteventtime 0 0.5])
set(gca,'XTick',[0:1:posteventtime])
set(gca,'XTickLabel',[0:1:(posteventtime)])
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,3)
hold on
plot(durationbins,histinhibited_e1,'Color', set_CS1color, 'LineWidth',1);
xlabel(['duration (s)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
title(['duration of inhibition after CS1'], 'FontSize', 8)
axis([0 posteventtime 0 0.5])
set(gca,'XTick',[0:1:posteventtime])
set(gca,'XTickLabel',[0:1:(posteventtime)])
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,8)
hold on
plot(durationbins,histinhibited_e2,'Color', set_CS2color, 'LineWidth',1);
xlabel(['duration (s)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
title(['duration of inhibition after CS2'], 'FontSize', 8)
axis([0 posteventtime 0 0.5])
set(gca,'XTick',[0:1:posteventtime])
set(gca,'XTickLabel',[0:1:(posteventtime)])
set(gca,'FontSize',8,'TickDir','out')
hold off

end

set(gcf,'Position',[scrsz(1)+620 0.6*scrsz(2)+100 0.3*scrsz(3) 0.8*scrsz(4)])   



hist_posdeltarate_e1=histc(deltarate_excit_e1, pos_deltaratebins)/length(deltarate_excit_e1);
hist_negdeltarate_e1=histc(deltarate_inhib_e1, neg_deltaratebins)/length(deltarate_inhib_e1);
hist_posdeltarate_e2=histc(deltarate_excit_e2, pos_deltaratebins)/length(deltarate_excit_e2);
hist_negdeltarate_e2=histc(deltarate_inhib_e2, neg_deltaratebins)/length(deltarate_inhib_e2);

hist_baseline=histc(baseline, baselinebins)/length(baseline);
hist_baselinefluct=histc(baselinefluct, fluctuationbins)/length(baselinefluct);

subplot(3,5,4)
hold on
plot(pos_deltaratebins, hist_posdeltarate_e1, 'Color', set_CS1color);
axis([0 max_plotdeltarate 0 0.5])
title(['positive rate modulation to CS1'], 'FontSize', 8)
xlabel(['rate change (Hz)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,5)
hold on
plot(neg_deltaratebins, hist_negdeltarate_e1, 'Color', set_CS1color);
axis([-1 0 0 0.5])
title(['negative rate modulation to CS1'], 'FontSize', 8)
xlabel(['rate change (Hz)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,9)
hold on
plot(pos_deltaratebins, hist_posdeltarate_e2, 'Color', set_CS2color);
axis([0 max_plotdeltarate 0 0.5])
title(['positive rate modulation to CS2'], 'FontSize', 8)
xlabel(['rate change (Hz)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,10)
hold on
plot(neg_deltaratebins, hist_negdeltarate_e2, 'Color', set_CS2color);
axis([-1 0 0 0.5])
title(['negative rate modulation to CS2'], 'FontSize', 8)
xlabel(['rate change (Hz)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off


subplot(3,5,11)
hold on
plot(baselinebins, hist_baseline, 'Color', set_CS1color);
axis([0 max(baselinebins) 0 0.5])
xlabel(['baseline rate (Hz)'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off

subplot(3,5,12)
hold on
plot(fluctuationbins, hist_baselinefluct, 'Color', set_CS1color);
axis([0 max(fluctuationbins) 0 0.5])
xlabel(['baseline SD/mean'], 'FontSize', 8)
ylabel(['prob'] ,'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off

set(gcf,'Position',[scrsz(1)+50 0.6*scrsz(2)+100 0.8*scrsz(3) 0.8*scrsz(4)])   
