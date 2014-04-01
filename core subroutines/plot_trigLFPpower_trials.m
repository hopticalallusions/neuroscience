disp(['*plotting event-triggered LFP power vs trial for one channel (' num2str(plotchannel) ').'])

%plots event-triggered LFP power vs trial for selected trials & channel

plotchannel=80;    %specify which channel to use for stack of LFP power vs trial

%**********************************



LFPpowerstack_event1=[];
for trialind=1:length(doevent1trials);
    trialk=doevent1trials(trialind);       
    LFPpowerstack_event1=[LFPpowerstack_event1; event1_LFPpower{trialk}];   
end
LFPpowerstack_event1=flipud(LFPpowerstack_event1);
% h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
LFPpowerstack_event1=filter2(h, LFPpowerstack_event1);


LFPpowerstack_event2=[];
if length(event2_LFPpower)>0
for trialind=1:length(doevent2trials);
    trialk=doevent2trials(trialind);       
    LFPpowerstack_event2=[LFPpowerstack_event2; event2_LFPpower{trialk}];   
end
LFPpowerstack_event2=flipud(LFPpowerstack_event2);
% h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
LFPpowerstack_event2=filter2(h, LFPpowerstack_event2);
end

maxpwr=ceil(max([max(max(10*log10(abs(LFPpowerstack_event1)))) max(max(10*log10(abs(LFPpowerstack_event2))))]));
minpwr=floor(min([min(min(10*log10(abs(LFPpowerstack_event1)))) min(min(10*log10(abs(LFPpowerstack_event2))))]));

figind=3;
figure(figind)
hold off
xfactor=length(triggeredLFPtimebins)/(LFPpower_postcuetime+LFPpower_precuetime)*0.5;
ymax1=length(doevent1trials)-rem(length(doevent1trials),10);
ymax2=length(doevent2trials)-rem(length(doevent2trials),10);

subplot(2,1,1)
hold off
imagesc(10*log10(abs(LFPpowerstack_event1)),[minpwr maxpwr])

% surf(spectimes,specfreqs,10*log10(abs(spectrumstack_cue1)),'EdgeColor','none');   
% axis xy; axis tight; colormap(jet); view(0,90);
set(gca,'XTick',[0:xfactor:length(triggeredLFPtimebins)])
set(gca,'XTickLabel',[-LFPpower_precuetime:0.5:LFPpower_postcuetime])
set(gca,'YTick',[(rem(length(doevent1trials),10)+1):10:ymax1])
set(gca,'YTickLabel',[ymax1:-10:1])
xlabel('time (s)','FontSize',8)
ylabel('trial','FontSize',8);
title([triggerevent1 ' triggered LFP power vs trial , f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection '. Channel ' num2str(plotchannel) '.'], 'FontSize', 8)
colorbar
colormap('jet')
set(gca,'FontSize',8,'TickDir','out')


subplot(2,1,2)
if length(event2times)>0
hold off
imagesc(10*log10(abs(LFPpowerstack_event2)),[minpwr maxpwr])

% surf(spectimes,specfreqs,10*log10(abs(spectrumstack_cue1)),'EdgeColor','none');   
% axis xy; axis tight; colormap(jet); view(0,90);
set(gca,'XTick',[0:xfactor:length(triggeredLFPtimebins)])
set(gca,'XTickLabel',[-LFPpower_precuetime:0.5:LFPpower_postcuetime])
set(gca,'YTick',[(rem(length(doevent2trials),10)+1):10:ymax2])
set(gca,'YTickLabel',[ymax2:-10:1])
xlabel('time (s)','FontSize',8)
ylabel('trial','FontSize',8);
title([triggerevent2 ' triggered LFP power vs trial, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection '. Channel ' num2str(plotchannel) '.'], 'FontSize', 8)
colorbar
colormap('jet')
set(gca,'FontSize',8,'TickDir','out')

figure(figind)
else axis off
end

set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
figure(figind)

saveas(figure(figind),[stimephysjpgdir 'trigged_LFPpwr_trials.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'trigged_LFPpwr_trials.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'trigged_LFPpwr_trials.fig' ]  ,'fig')

figind=figind+1;
