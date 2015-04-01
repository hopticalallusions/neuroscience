%plots event-triggered mean LFP power vs depth
timedivision=1;  %specify time tick mark separation units in sec.
depthdivision=0.1; %default=0.2. units in mm.

minpwr=10;
maxpwr=40;
%**********************************

load([currentLFPpwrdir 'trigged_power_ch' num2str(plotchannel) '.mat'])
f_low_LFP=trigged_LFPpower.f_low_LFP;
f_high_LFP=trigged_LFPpower.f_high_LFP;
triggeredLFPtimebins=trigged_LFPpower.timebins;
LFPpower_precuetime=-min(trigged_LFPpower.timebins);
LFPpower_postcuetime=max(trigged_LFPpower.timebins);

LFPpowertimebins=-LFPpower_precuetime:timedivision:LFPpower_postcuetime;

scrsz=get(0,'ScreenSize');

dochannels=setdiff(s.channels,badchannels);
shafts=s.shaft(dochannels);
uniqueshafts=unique(shafts);
numberofshafts=length(unique(shafts));

% plot_trigLFPpower_trials     %plots event-triggered LFP power vs trial for selected trials & channel

figure(figind)
hold off

LFPpowerstack_depth_event1=[];  LFPpowerstack_depth_event2=[]; 

disp(['*plotting event-triggered mean LFP power vs depth.'])
for shaftind=1:numberofshafts;
    currentshaft=uniqueshafts(shaftind);
    LFPpowerstack_depth_event1{currentshaft}=[]; LFPpowerstack_depth_event2{currentshaft}=[];
    chansonshaft=find(s.shaft==currentshaft);
    goodchansonshaft=setdiff(chansonshaft,badchannels);
    
    uniquedepths_shafti=unique(s.z(chansonshaft));
    probedepths_shafti=-(uniquedepths_shafti-max(uniquedepths_shafti)-tipelectrode)/1000;
    
    for i=1:length(uniquedepths_shafti);
        
        depthi=uniquedepths_shafti(i);
        chansi=find(s.z==depthi);
        chansi=intersect(chansi,chansonshaft);  %all channels on current shaft and depthi (includes bad channels)

        if length(chansi)>0
        LFPpower_event1=[]; LFPpower_event2=[];
        for j=1:length(chansi);   %if there are multiple channels in chansi, take the average power of all good chansi.
            chanj=chansi(j);
            
            if length(intersect(chanj,badchannels))==1   %if current channel is bad, use the nearest good channel in its place.
                zchanj=s.z(chanj);
                zgoodchansonshaft=s.z(setdiff(goodchansonshaft,chanj));
                diffz=abs(zgoodchansonshaft-zchanj);
                minind=find(diffz==min(diffz));
                newchanj=min(goodchansonshaft(minind));
                chanj=newchanj;
            end
            
            if exist([currentLFPpwrdir 'trigged_power_ch' num2str(chanj) '.mat'])
            load([currentLFPpwrdir 'trigged_power_ch' num2str(chanj) '.mat'])
            else disp(['WARNING: channel ' num2str(chanj) ' not found in event-triggered LFP power directory.'])
            end
                   
            if  strcmp(triggerevent1,'CS1')
            event1_LFPpower=trigged_LFPpower.cue1_LFPpower;
            elseif strcmp(triggerevent1,'CS2')
            event1_LFPpower=trigged_LFPpower.cue2_LFPpower;
            elseif strcmp(triggerevent1,'CS3')
            event1_LFPpower=trigged_LFPpower.cue3_LFPpower;
            elseif strcmp(triggerevent1,'CS4')
            event1_LFPpower=trigged_LFPpower.cue4_LFPpower;
            elseif strcmp(triggerevent1,'laser')
            event1_LFPpower=trigged_LFPpower.laser_LFPpower;
            elseif strcmp(triggerevent1,'startlicking')
            event1_LFPpower=trigged_LFPpower.lickepisode_LFPpower;
            elseif strcmp(triggerevent1,'endlicking')
            event1_LFPpower=trigged_LFPpower.endlickepisode_LFPpower;
            elseif strcmp(triggerevent1,'solenoid')
            event1_LFPpower=trigged_LFPpower.solenoid_LFPpower;
            elseif strcmp(triggerevent1,'room1 entries')
            event1_LFPpower=trigged_LFPpower.room1entries;
            elseif strcmp(triggerevent1,'room2 entries')
            event1_LFPpower=trigged_LFPpower.room2entries;
            elseif strcmp(triggerevent1,'room3 entries')
            event1_LFPpower=trigged_LFPpower.room3entries;
            elseif strcmp(triggerevent1,'room4 entries')
            event1_LFPpower=trigged_LFPpower.room4entries;
            end

            if  strcmp(triggerevent2,'CS1')
            event2_LFPpower=trigged_LFPpower.cue1_LFPpower;
            elseif strcmp(triggerevent2,'CS2')
            event2_LFPpower=trigged_LFPpower.cue2_LFPpower;
            elseif strcmp(triggerevent2,'CS3')
            event2_LFPpower=trigged_LFPpower.cue3_LFPpower;
            elseif strcmp(triggerevent2,'CS4')
            event2_LFPpower=trigged_LFPpower.cue4_LFPpower;
            elseif strcmp(triggerevent2,'laser')
            event2_LFPpower=trigged_LFPpower.laser_LFPpower;
            elseif strcmp(triggerevent2,'startlicking')
            event2_LFPpower=trigged_LFPpower.lickepisode_LFPpower;
            elseif strcmp(triggerevent2,'endlicking')
            event2_LFPpower=trigged_LFPpower.endlickepisode_LFPpower;
            elseif strcmp(triggerevent2,'solenoid')
            event2_LFPpower=trigged_LFPpower.solenoid_LFPpower;
            elseif strcmp(triggerevent2,'room1 entries')
            event2_LFPpower=trigged_LFPpower.room1entries;
            elseif strcmp(triggerevent2,'room2 entries')
            event2_LFPpower=trigged_LFPpower.room2entries;
            elseif strcmp(triggerevent2,'room3 entries')
            event2_LFPpower=trigged_LFPpower.room3entries;
            elseif strcmp(triggerevent2,'room4 entries')
            event2_LFPpower=trigged_LFPpower.room4entries;
            elseif strcmp(triggerevent2,'none')
            event2_LFPpower=[];
            end
        
            for trialind=1:length(doevent1trials);
                trialk=doevent1trials(trialind);       
                LFPpower_event1=[LFPpower_event1; event1_LFPpower{trialk}];   
            end
            
            if length(event2_LFPpower)>0
            for trialind=1:length(doevent2trials);
                trialk=doevent2trials(trialind);       
                LFPpower_event2=[LFPpower_event2; event2_LFPpower{trialk}];   
            end
            end
        end
            meanLFPpower_event1=mean(LFPpower_event1);
            LFPpowerstack_depth_event1{currentshaft}=[LFPpowerstack_depth_event1{currentshaft}; meanLFPpower_event1];
          
            if length(event2_LFPpower)>0 
            meanLFPpower_event2=mean(LFPpower_event2);
            LFPpowerstack_depth_event2{currentshaft}=[ LFPpowerstack_depth_event2{currentshaft}; meanLFPpower_event2];
            end
            
        end
    end
 

LFPpowerstack_depth_event1{currentshaft}=flipud(LFPpowerstack_depth_event1{currentshaft});           
h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
%h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% LFPpowerstack_depth_event1{currentshaft}=filter2(h, LFPpowerstack_depth_event1{currentshaft});

LFPpowerstack_depth_event2{currentshaft}=flipud(LFPpowerstack_depth_event2{currentshaft});           
h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
%h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% LFPpowerstack_depth_event2{currentshaft}=filter2(h, LFPpowerstack_depth_event2{currentshaft});

xfactor=length(triggeredLFPtimebins)/(LFPpower_postcuetime+LFPpower_precuetime)*timedivision;
ymax1=length(doevent1trials)-rem(length(doevent1trials),10);
ymax2=length(doevent2trials)-rem(length(doevent2trials),10);

% if shaftind==1
% maxpwr=ceil(max([max(max(10*log10(abs(LFPpowerstack_depth_event1{currentshaft})))) max(max(10*log10(abs(LFPpowerstack_depth_event2{currentshaft}))))]));
% minpwr=floor(min([min(min(10*log10(abs(LFPpowerstack_depth_event1{currentshaft})))) min(min(10*log10(abs(LFPpowerstack_depth_event2{currentshaft}))))]));
% end

subplot(3,length(uniqueshafts),shaftind)
hold off
imagesc(10*log10(abs(LFPpowerstack_depth_event1{currentshaft})),[minpwr maxpwr])
colorbar
colormap('jet')


set(gca,'XTick',[0:xfactor:length(triggeredLFPtimebins)])
set(gca,'XTickLabel',[LFPpowertimebins])
xlabel(['shaft ' num2str(currentshaft) ', ML=' num2str(positions.ML{currentshaft}) ' mm'] ,'FontSize',8)

yticks=0:5:length(uniquedepths_shafti);
remticks=rem(length(uniquedepths_shafti),max(yticks));
set(gca,'YTick',yticks)
lines_permm=length(uniquedepths_shafti)/max(probedepths_shafti);  %lines per millimeter.
yticklabels=fliplr(yticks/lines_permm+shaftz{currentshaft}+remticks/lines_permm)+tipelectrode/1000; 
yticklabels=round(yticklabels*100)/100;
set(gca,'YTickLabel',yticklabels)
ylabel('electrode depth (mm)','FontSize', 8)

if length(strcmp(triggerevent1,'laser'))==0
title([subject ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection1  '.'], 'FontSize', 8)
else 
    if length(strcmp(laserfreqselect,'none'))==0
       title([subject ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection1  '.'], 'FontSize', 8)
    else title([subject ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'], 'FontSize', 8)
    end
end
set(gca,'FontSize',8,'TickDir','out')

subplot(3,length(uniqueshafts),length(uniqueshafts)+shaftind)
if length(event2times)>0
hold off
imagesc(10*log10(abs(LFPpowerstack_depth_event2{currentshaft})),[minpwr maxpwr])
colorbar

colormap('jet')
set(gca,'XTick',[0:xfactor:length(triggeredLFPtimebins)])
set(gca,'XTickLabel',[LFPpowertimebins])
xlabel(['shaft ' num2str(currentshaft) ', ML=' num2str(positions.ML{currentshaft}) ' mm'] ,'FontSize',8)

yticks=0:5:length(uniquedepths_shafti);
remticks=rem(length(uniquedepths_shafti),max(yticks));
set(gca,'YTick',yticks)
lines_permm=length(uniquedepths_shafti)/max(probedepths_shafti);  %lines per millimeter.
yticklabels=fliplr(yticks/lines_permm+shaftz{currentshaft}+remticks/lines_permm)+tipelectrode/1000; 
yticklabels=round(yticklabels*100)/100;
set(gca,'YTickLabel',yticklabels)
ylabel('electrode depth (mm)','FontSize', 8)

if length(strcmp(triggerevent2,'laser'))==0
title(['f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection2  '.'], 'FontSize', 8)
else 
    if length(strcmp(laserfreqselect,'none'))==0
       title([subject ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection2  '.'], 'FontSize', 8)
    else title([subject ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'], 'FontSize', 8)
    end
end
set(gca,'FontSize',8,'TickDir','out')

else axis off
end

subplot(3,length(uniqueshafts),2*length(uniqueshafts)+shaftind)
meanLFP_event1=smooth(mean(LFPpowerstack_depth_event1{currentshaft}),3);
hold off
plot(10*log10(abs(meanLFP_event1)),'k')

if length(event2times)>0
hold on
meanLFP_event2=smooth(mean(LFPpowerstack_depth_event2{currentshaft}),3);
plot(10*log10(abs(meanLFP_event2)),'r')
end
set(gca,'XTick',[0:xfactor:length(triggeredLFPtimebins)])
set(gca,'XTickLabel',[LFPpowertimebins])
axis([0 length(triggeredLFPtimebins) minpwr maxpwr])
xlabel('Time (s)','FontSize', 8)
ylabel('Mean LFP power (dB)', 'FontSize', 8)
title(['event 1: ' triggerevent1 '; event 2: ' triggerevent2], 'FontSize', 8)
set(gca,'FontSize',8,'TickDir','out')
hold off
set(gca,'PlotBoxAspectRatio',[2.1 1 1])

end

set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   
saveas(figure(figind),[stimephysjpgdir 'LFPpwr_depth_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.jpg']  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'LFPpwr_depth_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.eps']  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'LFPpwr_depth_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.fig']  ,'fig')



