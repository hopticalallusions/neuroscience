%plots psth and marks any annotated events, e.g. drug injection.
%This program is normally a subroutine of multi_unit.muxi

%Saves timesperchan.mat and extracted amplitudes & waveforms.

%The subroutine plot_MUA_muxi.m groups all detected spikes (from the channels specified in plotsummedchannels) into a single
%psth, and saves those spiketimes as spiketimes.mat.
%The file spiketimes.mat contains all spike times (in units of sec) merged across all selected
%channels, with rejecttime being used to eliminate double-counted events.

load([multisavedir 'runparameters.mat'])
psthbinsize=parameters.psthbinsize;
lasttrial=parameters.maxtrial;
trialduration=parameters.trialduration;
lasttrialduration=parameters.lasttrialduration;
maxtrial=parameters.maxtrial;
samplingrate=parameters.samplingrate;
depthofsomas=parameters.depthofsomas;
peaklocations=parameters.peaklocations;
timeannotations=parameters.timeannotations;
eventannotations=parameters.eventannotations;
startevent=parameters.startevent;

load([LFPdir 'LFPdata.mat'])
f_low_LFP=LFP.f_low_LFP; 
f_high_LFP=LFP.f_high_LFP;
f_low_ripple=LFP.f_low_ripple;
f_high_ripple=LFP.f_high_ripple;

totaltime=((lasttrial-1)*trialduration+lasttrialduration)/samplingrate;    %removes last point, which because of binning has zero  value in psth.
plottime=psthbinsize:psthbinsize:totaltime;

LFPpertrial=LFP.LFPpertrial;
ripplepertrial=LFP.ripplepertrial;
LFPspectrum=LFP.LFPspectrum;
F=LFP.freq;

%2D color plot.
uniquedepths=unique(s.y);
probedepths=-(uniquedepths-max(uniquedepths)-tipelectrode)/1000;

LFPzscore=[]; LFPrms=[]; ripplerms=[]; 
for i=1:length(uniquedepths);
    depthi=uniquedepths(i);
    chansi=find(s.y==depthi);
    chansi=setdiff(chansi,badchannels);
 
    
    LFPdepthi=[]; rippledepthi=[];
    for j=1:length(chansi);
        chanj=chansi(j);
        LFPdepthi=[LFPdepthi; LFPpertrial{chanj}];
        rippledepthi=[rippledepthi; ripplepertrial{chanj}];
    end
    
    if length(chansi)>1
        LFPdepthi=mean(LFPdepthi);
        rippledepthi=mean(rippledepthi);
    end
    

zscore=(LFPdepthi-mean(LFPdepthi))/std(LFPdepthi);   %take z-score
LFPzscore=[LFPzscore; zscore]; 

LFPrms=[LFPrms; sqrt(LFPdepthi)];    %take average rms value per trial.

ripplerms=[ripplerms; sqrt(rippledepthi)];

end

% h=fspecial('gaussian',3,0.75);  %gaussian filter.
% LFPzscore = filter2(h, LFPzscore);
LFPzscore=flipud(LFPzscore);

LFPrms=flipud(LFPrms);
ripplerms=flipud(ripplerms);

figure(5)
hold off
subplot(3,1,1)
imagesc(LFPzscore, [-4, 4])    %plot command. remove ranges if want to show entire range

 for events=startevent:(length(timeannotations)-1);
    etime=timeannotations{events};
    line([etime/psthbinsize etime/psthbinsize], [1 size(LFPzscore,1)],'Color','k','LineStyle','-','LineWidth',2)  %convert times to minutes
%     text(etime/psthbinsize, size(LFPzscore,1)-5,[' \leftarrow' eventannotations{events}],'FontSize',9)
 end
 
 for layerind=1:length(depthofsomas)
    depthi=peaklocations(layerind);
    line([0 maxtrial/4],[depthi depthi],'Color','k','LineStyle','--','LineWidth',1)  %convert times to minutes
%     text(0, depthi,['\rightarrow'],'FontSize',12)
 end

colorbar
set(gca,'XTick',[0:15:totaltime/psthbinsize])
set(gca,'XTickLabel',[0:(15*psthbinsize/60):totaltime/60])
xlabel('time (minutes)','FontSize',11)

ydiv=0.1;  %units in mm.
lines_permm=size(LFPzscore,1)/(max(probedepths));
set(gca,'YTick',[0:lines_permm*ydiv:size(LFPzscore,1)])
set(gca,'YTickLabel',[ceil(size(LFPzscore,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',11)


title([filename '; z-score of LFP power, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.' ], 'FontSize',11)
set(gca,'FontSize',11,'TickDir','out')



figure(5)
hold off
subplot(3,1,2)
imagesc(LFPrms) %, [0 mean(max(LFPrms))+std(max(LFPrms))])    %plot command. remove ranges if want to show entire range

 for events=startevent:(length(timeannotations)-1);
    etime=timeannotations{events};
    line([etime/psthbinsize etime/psthbinsize], [1 size(LFPzscore,1)],'Color','k','LineStyle','-','LineWidth',2)  %convert times to minutes
%     text(etime/psthbinsize, size(LFPzscore,1)-5,[' \leftarrow' eventannotations{events}],'FontSize',9)
 end
 
 for layerind=1:length(depthofsomas)
    depthi=peaklocations(layerind);
    line([0 maxtrial/4],[depthi depthi],'Color','k','LineStyle','--','LineWidth',1)  %convert times to minutes
%     text(0, depthi,['\rightarrow'],'FontSize',12)
 end

colorbar 
set(gca,'XTick',[0:15:totaltime/psthbinsize])
set(gca,'XTickLabel',[0:(15*psthbinsize/60):totaltime/60])
xlabel('time (minutes)','FontSize',11)

ydiv=0.1;  %units in mm.
lines_permm=size(LFPzscore,1)/(max(probedepths));
set(gca,'YTick',[0:lines_permm*ydiv:size(LFPzscore,1)])
set(gca,'YTickLabel',[ceil(size(LFPzscore,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',11)

title(['RMS LFP, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'], 'FontSize',11)
set(gca,'FontSize',11,'TickDir','out')



figure(5)
hold off
subplot(3,1,3)
imagesc(ripplerms) %,[min(min(ripplerms)) mean(max(ripplerms))+std(max(ripplerms))])    %plot command. remove ranges if want to show entire range

for events=startevent:(length(timeannotations)-1);
    etime=timeannotations{events};
    line([etime/psthbinsize etime/psthbinsize], [1 size(ripplerms,1)],'Color','k','LineStyle','-','LineWidth',2)  %convert times to minutes
%     text(etime/psthbinsize, size(LFPzscore,1)-5,[' \leftarrow' eventannotations{events}],'FontSize',9)
 end
 
 for layerind=1:length(depthofsomas)
    depthi=peaklocations(layerind);
    line([0 maxtrial/4],[depthi depthi],'Color','k','LineStyle','--','LineWidth',1)  %convert times to minutes
%     text(0, depthi,['\rightarrow'],'FontSize',12)
 end

colorbar 
set(gca,'XTick',[0:15:totaltime/psthbinsize])
set(gca,'XTickLabel',[0:(15*psthbinsize/60):totaltime/60])
xlabel('time (minutes)','FontSize',11)

ydiv=0.1;  %units in mm.
lines_permm=size(ripplerms,1)/(max(probedepths));
set(gca,'YTick',[0:lines_permm*ydiv:size(ripplerms,1)])
set(gca,'YTickLabel',[ceil(size(ripplerms,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',11)

title(['RMS Ripple activity, f=' num2str(f_low_ripple) '-' num2str(f_high_ripple) ' Hz.'], 'FontSize',11)
set(gca,'FontSize',11,'TickDir','out')


saveas(figure(5),[LFPMfiledir filename '_2DLFP.fig' ]  ,'fig')
saveas(figure(5),[LFPdir filename '_2DLFP.jpg' ]  ,'jpg')
saveas(figure(5),[LFPEPSdir filename '_2DLFP.eps' ]  ,'psc2')



figure(6)
for i=1:length(uniquedepths);
    depthi=uniquedepths(i);
    chansi=find(s.y==depthi);
    chansi=setdiff(chansi,badchannels);

if length(chansi)>0    
    j=1; %use only one channels per depth for amplitude
%     for j=1:length(chansi);
    chanj=chansi(j);
        
chandepth=-(s.y(chanj)-max(s.y)-tipelectrode)/1000;

LFPspec=LFPspectrum{chanj};
% h=fspecial('gaussian',3,0.75);  %gaussian filter.
% LFPspec = filter2(h, LFPspec);
LFPspec=flipud(LFPspec');

% imagesc(log(flipud(LFPspec')),[log(max(max(LFPspec)))/2 log(max(max(LFPspec)))])
imagesc(LFPspec,[0 max(max(LFPspec))])

plotmaxy=max(F)-rem(max(F),4);
set(gca,'YTick',[0:3.584:size(F,1)])
set(gca,'YTickLabel',[(plotmaxy+4):-4:0])
ylabel('frequency (Hz)','FontSize',11)


set(gca,'XTick',[0:15:totaltime/psthbinsize])
set(gca,'XTickLabel',[0:(15*psthbinsize/60):totaltime/60])
xlabel('time (minutes)','FontSize',11)

axis([0 totaltime/psthbinsize size(F,1)-20 size(F,1)])
colorbar

title([filename '; LFP power spectrum, ' num2str(1000*chandepth) ' um from tip.'], 'FontSize',11)
set(gca,'FontSize',11,'TickDir','out')


    for events=startevent:(length(timeannotations)-1);
    etime=timeannotations{events};
    line([etime/psthbinsize etime/psthbinsize], [size(F,1)-20 size(F,1)],'Color','k','LineStyle','-','LineWidth',2)  %convert times to minutes
%     text(etime/psthbinsize, size(LFPzscore,1)-5,[' \leftarrow' eventannotations{events}],'FontSize',9)
    end

saveas(figure(6),[LFPMfiledir filename '_2Dspect' num2str(i) '.fig' ]  ,'fig')
saveas(figure(6),[LFPspecdir filename '_2Dspect' num2str(i) '.jpg' ]  ,'jpg')
saveas(figure(6),[LFPEPSdir filename '_2Dspect' num2str(i) '.eps' ]  ,'psc2')

end

end