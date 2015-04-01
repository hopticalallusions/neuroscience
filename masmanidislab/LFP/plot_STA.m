
plotfreq=1:90;  %frequency range to plot (make sure df=1). if leave empty [], then use plotfreq==specfreq;
plotfreqdiv=5;  %default=5. frequency division to use in plots.
removespectralbackground='n';   %option to remove mean background PSD.

plotmaxdB=20;
plotmindB=-60;

%***********************************************************

currentSTAdir=uigetdir([STAdir],'Select an STA folder');
STAdatadir=[currentSTAdir '\data\'];
% load([STAdatadir 'STA.mat'])

STAjpgdir=[currentSTAdir '\jpeg\'];
STAepsdir=[currentSTAdir '\eps\'];
STAmfigdir=[currentSTAdir '\matlab figures\'];
mkdir([STAjpgdir]); mkdir([STAepsdir]); mkdir([STAmfigdir])
delete([STAjpgdir '*.*']); delete([STAepsdir '*.*']); delete([STAmfigdir '*.*'])

load([STAdatadir 'STAparameters.mat'])
randomSTA=STAparameters.randomSTA;
periSTAwidth=STAparameters.periSTAwidth;

STAtimebins=-periSTAwidth:(1/LFPsamplingrate):periSTAwidth;

load_results

specfreqs=0:1:120;  %frequency bins for LFP power spectrogram setting lower cutoff speeds up program. max range is 0:1:LFPsamplingrate/2;
if length(plotfreq)==0
    plotfreq=specfreq;
    freqpoints=1:length(specfreq);
else freqpoints=plotfreq;
end

figind=1;
figure(figind)
close
figure(figind)

for unitind=1:length(dounits)
    unitj=dounits(unitind);
    load([STAdatadir 'STA_unit' num2str(unitj) '.mat'])
    
    bestchan=bestchannels{unitj};
    currentvoltagefile=['LFPvoltage_ch' num2str(bestchan) '.mat'];
    load([LFPvoltagedir currentvoltagefile]); 
    f_low_LFP=1.5;
    f_high_LFP=100;
    dofilter_LFP
    std_LFP=std(LFPvoltage);
    
    disp(['unit ' num2str(unitj)])
    
    if isnan(STA.event1{bestchan})~=1
    [S,specfreqs,spectimes, STA_PSDevent1]=spectrogram(STA.event1{bestchan},512, 474,specfreqs,LFPsamplingrate);    %512,464 gives dt=0.05 s; 512, 417 gives dt=0.1 s; 512, 474 gives dt=0.01 s assuming periSTAwidth=1;
    [S,specfreqs,spectimes, randomSTA_PSD]=spectrogram(randomSTA{bestchan},512,474,specfreqs,LFPsamplingrate);    %512,464 gives dt=0.05 s; 512, 417 gives dt=0.1 s; 512, 474 gives dt=0.01 s assuming periSTAwidth=1;
    STA_PSDevent1=STA_PSDevent1(freqpoints,:);
    randomSTA_PSD=randomSTA_PSD(freqpoints,:);
    
    if length(STA.event2)>0
    [S,specfreqs,spectimes, STA_PSDevent2]=spectrogram(STA.event2{bestchan},512, 474,specfreqs,LFPsamplingrate);    %512,464 gives dt=0.05 s; 512, 417 gives dt=0.1 s; 512, 474 gives dt=0.01 s assuming periSTAwidth=1;   
    STA_PSDevent2=STA_PSDevent2(freqpoints,:);
    end
    
    
	if removespectralbackground=='y'
    backgroundspectrum=mean(randomSTA_PSD');  %use this to subtract mean background spectrum
    for timepoint=1:size(STA_PSDevent1,2);
        STA_PSDevent1(:,timepoint)=STA_PSDevent1(:,timepoint)-backgroundspectrum';  %substracts background spectrum.
    end
    
    if length(STA.event2)>0
    for timepoint=1:size(STA_PSDevent2,2);
        STA_PSDevent2(:,timepoint)=STA_PSDevent2(:,timepoint)-backgroundspectrum';  %substracts background spectrum.
    end
    end
    end
    
    
    STA_PSDevent1=flipud(STA_PSDevent1);  
    randomSTA_PSD=flipud(randomSTA_PSD);
    
    if length(STA.event2)>0
        STA_PSDevent2=flipud(STA_PSDevent2);
    end
    
    % h=fspecial('gaussian',3,0.75);  %gaussian filter. 
    % STA_PSD=filter2(h,STA_PSD);
    
    rawSTA=STA.event1{bestchan};
    LFPvoltage=rawSTA;
    dofilter_LFP
    
    subplot(2,2,[1])
    hold off
%     plot(STAtimebins, rawSTA,'k')
%     hold on
    plot(STAtimebins, LFPvoltage,'k')
    minsubplot=min(LFPvoltage);  maxsubplot=max(LFPvoltage); 
    if length(STA.event2)>0
    rawSTA=STA.event2{bestchan};
    LFPvoltage=rawSTA;
    dofilter_LFP
    hold on
%     plot(STAtimebins, rawSTA,'r')
    plot(STAtimebins, LFPvoltage,'r')
    minsubplot=min([minsubplot LFPvoltage]);  maxsubplot=max([maxsubplot LFPvoltage]);
    end
    hold on
    plot(STAtimebins, smooth(STAparameters.randomSTA{bestchan},10),'g')
    minsubplot=min([minsubplot STAparameters.randomSTA{bestchan}]);  maxsubplot=max([maxsubplot STAparameters.randomSTA{bestchan}]);
    hold off
    xlabel('time (s)','FontSize',8)
    ylabel('LFP voltage','FontSize',8);
    axis([-periSTAwidth periSTAwidth round(minsubplot-10) round(maxsubplot+10)])
    title(['Mean STA on best chan for Unit ' num2str(unitj) '; Bk=Event 1, R=Event 2, G=Random STA, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz, SD of LFP=' num2str(round(std_LFP)) ' uV'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    hold off
   
    subplot(2,2,[2])
    imagesc(10*log10(abs(STA_PSDevent1)), [plotmindB plotmaxdB])

    xfactor=length(spectimes)/(periSTAwidth+periSTAwidth)*0.25;
    set(gca,'XTick',[0:xfactor:length(spectimes)])
    set(gca,'XTickLabel',[-periSTAwidth:0.25:periSTAwidth])
    set(gca,'YTick',[0:plotfreqdiv:(max(plotfreq)-1)])
    set(gca,'YTickLabel',[max(plotfreq):-plotfreqdiv:1])
    xlabel('time (s)','FontSize',8)
    ylabel('frequency (Hz)','FontSize',8);
    if removespectralbackground=='y'
    title(['Event 1 backgrnd-removed STA PSD for unit ' num2str(unitj) ', best ch=' num2str(bestchan) '. Trials: ' STAparameters.trialselection1 '.'], 'FontSize', 8)
    else title(['Event 1 STA PSD for unit ' num2str(unitj) ', best ch=' num2str(bestchan) '. Trials: ' STAparameters.trialselection1 '.'], 'FontSize', 8)
    end
    colorbar
    colormap('jet')
    set(gca,'FontSize',8,'TickDir','out')
 
    if length(STA.event2)>0

    subplot(2,2,[4])
    imagesc(10*log10(abs(STA_PSDevent2)), [plotmindB plotmaxdB])
    
    set(gca,'XTick',[0:xfactor:length(spectimes)])
    set(gca,'XTickLabel',[-periSTAwidth:0.25:periSTAwidth])
    set(gca,'YTick',[0:plotfreqdiv:(max(plotfreq)-1)])
    set(gca,'YTickLabel',[max(plotfreq):-plotfreqdiv:1])
    xlabel('time (s)','FontSize',8)
    ylabel('frequency (Hz)','FontSize',8);
    if removespectralbackground=='y'
    title(['Event 2 backgrnd-removed STA PSD for unit ' num2str(unitj) ', best ch=' num2str(bestchan) '. Trials: ' STAparameters.trialselection2 '.'], 'FontSize', 8)
    else title(['Event 2 STA PSD for unit ' num2str(unitj) ', best ch=' num2str(bestchan) '. Trials: ' STAparameters.trialselection2 '.'], 'FontSize', 8)
    end
    colorbar
    colormap('jet')
    set(gca,'FontSize',8,'TickDir','out')
    end
    
    subplot(2,2,[3])
    hold off
    plot(plotfreq,fliplr(10*log10(abs(mean(STA_PSDevent1')))),'k');
    if length(STA.event2)>0
        hold on
        plot(plotfreq,fliplr(10*log10(abs(mean(STA_PSDevent2')))),'r');
    end
    xlabel('frequency (Hz)','FontSize',8)
    ylabel('Power (dB)','FontSize',8);
    axis([min(plotfreq) max(plotfreq) plotmindB+20 plotmaxdB+20])
    title(['mean STA PSD; Bk=Event 1, R=Event 2'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    
    
    
   
    scrsz=get(0,'ScreenSize');
    % set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
    set(gcf,'Position',[0 0 scrsz(3) scrsz(4)])

    saveas(figure(figind),[STAjpgdir 'STA_PSD_unit' num2str(unitj) '.jpg' ]  ,'jpg')
    saveas(figure(figind),[STAepsdir 'STA_PSD_unit' num2str(unitj) '.eps' ]  ,'psc2')
    saveas(figure(figind),[STAmfigdir 'STA_PSD_unit' num2str(unitj) '.fig' ]  ,'fig')
    end
    
end

disp(['done plotting STA'])

% unitj=7;
% bestchan=bestchannels{unitj};
% load([STAdatadir 'STA_unit' num2str(unitj) '.mat'])
% a=[];
% for i=1:length(s.channels)
% chan=s.channels(find(s.z==uniquedepths(i)));
% if length(STA.event1{chan})>0
% a=[a; STA.event1{chan}];
% end
% end