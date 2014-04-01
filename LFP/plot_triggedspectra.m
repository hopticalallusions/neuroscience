%plot event-triggered spectrogram for selected channel & frequency span.

plotchannel=30; 

plotfreq=1:90;  %frequency range to plot (make sure df=1). if leave empty [], then use plotfreq==specfreq;
plotfreqdiv=5;  %default=5. frequency division to use in plots.
removespectralbackground='n';   %option to remove mean background PSD.

minpsd=0; 
maxpsd=25; 
%*******************************************

disp(['*plotting event-triggered spectrogram for channel: ' num2str(plotchannel)])

figind=2;
load([LFPspectrumdir 'trigged_spectra_ch' num2str(plotchannel) '.mat'])  %trigged_spectra found in get_triggedspectra
spectimes=trigged_spectra.spectimes;
specfreq=trigged_spectra.specfreq;

if strcmp(triggerevent1,'background')
event1_PSD=trigged_spectra.background_PSD;
doevent1trials=1:length(event1_PSD);
elseif  strcmp(triggerevent1,'CS1')
event1_PSD=trigged_spectra.cue1_PSD;
elseif strcmp(triggerevent1,'CS2')
event1_PSD=trigged_spectra.cue2_PSD;  
elseif strcmp(triggerevent1,'CS3')
event1_PSD=trigged_spectra.cue3_PSD;  
elseif strcmp(triggerevent1,'CS4')
event1_PSD=trigged_spectra.cue4_PSD;  
elseif strcmp(triggerevent1,'laser')
event1_PSD=trigged_spectra.laser_PSD;
elseif strcmp(triggerevent1,'licking')
event1_PSD=trigged_spectra.lickepisode_PSD;
elseif strcmp(triggerevent1,'solenoid')
event1_PSD=trigged_spectra.solenoid_PSD;
elseif strcmp(triggerevent1,'room1 entries')
event1_PSD=trigged_spectra.room1entries;
elseif strcmp(triggerevent1,'room2 entries')
event1_PSD=trigged_spectra.room2entries;
elseif strcmp(triggerevent1,'room3 entries')
event1_PSD=trigged_spectra.room3entries;
elseif strcmp(triggerevent1,'room4 entries')
event1_PSD=trigged_spectra.room4entries;
end

if  strcmp(triggerevent2,'CS1')
event2_PSD=trigged_spectra.cue1_PSD;
elseif strcmp(triggerevent2,'CS2')
event2_PSD=trigged_spectra.cue2_PSD; 
elseif strcmp(triggerevent2,'CS3')
event2_PSD=trigged_spectra.cue3_PSD; 
elseif strcmp(triggerevent2,'CS4')
event2_PSD=trigged_spectra.cue4_PSD;  
elseif strcmp(triggerevent2,'laser')
event2_PSD=trigged_spectra.laser_PSD;
elseif strcmp(triggerevent2,'licking')
event2_PSD=trigged_spectra.lickepisode_PSD;
elseif strcmp(triggerevent2,'solenoid')
event2_PSD=trigged_spectra.solenoid_PSD;
elseif strcmp(triggerevent1,'room1 entries')
event2_PSD=trigged_spectra.room1entries;
elseif strcmp(triggerevent1,'room2 entries')
event2_PSD=trigged_spectra.room2entries;
elseif strcmp(triggerevent1,'room3 entries')
event2_PSD=trigged_spectra.room3entries;
elseif strcmp(triggerevent1,'room4 entries')
event2_PSD=trigged_spectra.room4entries;
elseif strcmp(triggerevent2,'none')
event2_PSD=[]; doevent2trials=[];
end

precuetime=trigged_spectra.preeventtime;
postcuetime=trigged_spectra.posteventtime;
LFPspectimebinsize=diff(spectimes(1:2));

if length(plotfreq)==0
    plotfreq=specfreq;
    freqpoints=1:length(specfreq);
else freqpoints=plotfreq;
end


spectrumstack_event1=zeros(length(plotfreq),length(spectimes));
for trialind=1:length(doevent1trials);   
    trialk=doevent1trials(trialind);
    spectrumstack_event1=[spectrumstack_event1+event1_PSD{trialk}(freqpoints,:)];
end
spectrumstack_event1=spectrumstack_event1/length(doevent1trials);

if removespectralbackground=='y'
    disp(['removing mean background spectrum'])
meanspectrum=mean(spectrumstack_event1(:,1:floor(precuetime/2/LFPspectimebinsize))');  %use this to subtract mean background spectrum
for timepoint=1:size(spectrumstack_event1,2);
    spectrumstack_event1(:,timepoint)=spectrumstack_event1(:,timepoint)-meanspectrum';  %substracts background spectrum.
end
end

spectrumstack_event1=flipud(spectrumstack_event1);
% h=fspecial('gaussian',3,0.75);  %gaussian filter. 
% spectrumstack_event1=filter2(h,spectrumstack_event1);


if length(doevent2trials)>0
spectrumstack_event2=zeros(length(plotfreq),length(spectimes));
for trialind=1:length(doevent2trials);   
    trialk=doevent2trials(trialind);
    spectrumstack_event2=[spectrumstack_event2+event2_PSD{trialk}(freqpoints,:)];
end
spectrumstack_event2=spectrumstack_event2/length(doevent2trials);

if removespectralbackground=='y'
    disp(['removing mean background spectrum'])
meanspectrum=mean(spectrumstack_event2(:,1:floor(precuetime/2/LFPspectimebinsize))');  %use this to subtract mean background spectrum
for timepoint=1:size(spectrumstack_event2,2);
    spectrumstack_event2(:,timepoint)=spectrumstack_event2(:,timepoint)-meanspectrum';  %substracts background spectrum.
end
end

spectrumstack_event2=flipud(spectrumstack_event2);
% h=fspecial('gaussian',3,0.75);  %gaussian filter. 
% spectrumstack_event2=filter2(h,spectrumstack_event2);
end

% maxpsd=max([max(max(10*log10(abs(spectrumstack_event1)))) max(max(10*log10(abs(spectrumstack_event2))))]);
% minpsd=min([min(min(10*log10(abs(spectrumstack_event1)))) min(min(10*log10(abs(spectrumstack_event2))))]);

figure(figind)
xfactor=length(spectimes)/(postcuetime+precuetime)*0.5;

subplot(3,1,1)
hold off
imagesc(10*log10(abs(spectrumstack_event1)),[minpsd maxpsd])
% surf(spectimes,specfreqs,10*log10(abs(spectrumstack_event1)),'EdgeColor','none');   
% axis xy; axis tight; colormap(jet); view(0,90);
set(gca,'XTick',[0:xfactor:length(spectimes)])
set(gca,'XTickLabel',[-precuetime:0.5:postcuetime])
set(gca,'YTick',[1:plotfreqdiv:max(plotfreq)])
set(gca,'YTickLabel',[max(plotfreq):-plotfreqdiv:1])
xlabel('time (s)','FontSize',8)
ylabel('frequency (Hz)','FontSize',8);
title([triggerevent1 ' triggered average PSD, channel ' num2str(plotchannel) '. Trials: ' trialselection1 '.'], 'FontSize', 8)
colorbar
colormap('jet')
set(gca,'FontSize',8,'TickDir','out')


subplot(3,1,2)
if length(doevent2trials)>0
hold off
imagesc(10*log10(abs(spectrumstack_event2)),[minpsd maxpsd])
% surf(spectimes,specfreqs,10*log10(abs(spectrumstack_event2)),'EdgeColor','none');   
% axis xy; axis tight; colormap(jet); view(0,90);
set(gca,'XTick',[0:xfactor:length(spectimes)])
set(gca,'XTickLabel',[-precuetime:0.5:postcuetime])
set(gca,'YTick',[1:plotfreqdiv:max(plotfreq)])
set(gca,'YTickLabel',[max(plotfreq):-plotfreqdiv:1])
xlabel('time (s)','FontSize',8)
ylabel('frequency (Hz)','FontSize',8);
title([triggerevent2 ' triggered average PSD, channel ' num2str(plotchannel) '. Trials: ' trialselection2], 'FontSize', 8)
colorbar
colormap('jet')
set(gca,'FontSize',8,'TickDir','out')
else axis off
end

subplot(3,1,3)
hold off
meanspect_event1=mean(spectrumstack_event1');
plot(plotfreq,10*log10(abs(fliplr(meanspect_event1))),'k')
xlabel('frequency (Hz)','FontSize',8)
ylabel('mean power (dB)','FontSize',8);
title([triggerevent1 ', channel ' num2str(plotchannel) '. Trials: ' trialselection1 '.'], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')

subplot(3,1,3)
if length(doevent2trials)>0
hold on
meanspect_event2=mean(spectrumstack_event2');
plot(plotfreq,10*log10(abs(fliplr(meanspect_event2))),'r')
xlabel('frequency (Hz)','FontSize',8)
ylabel('mean power (dB)','FontSize',8);
title([triggerevent1 ' and ' triggerevent2 ', channel ' num2str(plotchannel) '. Trials: ' trialselection1 '.'], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
end

set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
figure(figind)

saveas(figure(figind),[stimephysjpgdir 'spectra_ch' num2str(plotchannel) '.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'spectra_ch' num2str(plotchannel) '.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'spectra_ch' num2str(plotchannel) '.fig' ]  ,'fig')

figind=figind+1;