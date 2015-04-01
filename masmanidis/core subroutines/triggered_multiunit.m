%plots event-triggered multiunit activity & LFP power spectra

%The file multispiketimes.mat contains all spike times (in units of sec) merged
%across all selected channels, with rejecttime being used to eliminate double-counted events.

set_plot_parameters

triggerevent1='laser';  %options: 'CS1', 'CS2', 'laser' 
triggerevent2='none';  %options: 'CS1', 'CS2', 'laser', 'none'.     
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  

trialselection=['all'];    %select which event trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.                                                   

xdiv=0.5; %default=0.4. units in seconds. used only in plotting.
ydiv=0.5;  %default=0.2. units in mm.

% multibinsize=20;             %default=20. bin size for spike rate and amplitude vs depth for entire recording (sec).
% totaltime=((lasttrial-1)*trialduration+lasttrialduration)/samplingrate;    %removes last point, which because of binning has zero  value in psth.
% plottime=multibinsize:multibinsize:totaltime;
%**************************************************

close all
figind=1;

get_probegeometry  %get the distance from the tip to the nearest electrode. need to know the probe geometry.
dochannels=[1:length(s.x)];
dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.

uniquedepths=unique(s.z);
probedepths=-(uniquedepths-max(uniquedepths)-tipelectrode)/1000;
scrsz=get(0,'ScreenSize');

load([multisavedir 'multitimes.mat'])   %multitimes is a 1-D vector containing all the spike times from all channels.  The vector multibestchannels specifies which channel the spike is located on.
load([multisavedir 'multibestchannels.mat'])
load([multisavedir 'amprange.mat'])
load([multisavedir 'multiparameters.mat'])
load([stimulidir 'stimuli.mat'])

licktimes=stimuli.licktimes;
cue1times=stimuli.cue1times;  
cue2times=stimuli.cue2times;  
sol1times=stimuli.sol1times;
pulsetrainstart=stimuli.lasertimes.pulsetrainstart;
pulseduration=stimuli.lasertimes.pulseduration;
pulsetimes=stimuli.lasertimes.pulsetimes; 
cue1_lickyesno=stimuli.cue1_lickyesno;
cue2_lickyesno=stimuli.cue2_lickyesno;
solenoid_aftercue1=stimuli.solenoid_aftercue1;
solenoid_aftercue2=stimuli.solenoid_aftercue2;
meancuesoldelay=stimuli.meancuesoldelay;
uniqueshafts=unique(s.shaft);
numberofshafts=length(uniqueshafts);

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

timebins=-preeventtime:timebinsize:posteventtime;


%***2D color plot of cue-triggered normalized firing rate***
allevent1_times=[]; allevent2_times=[]; %initialize cue-triggered spike times
for chanind=1:length(dochannels)
    chanj=dochannels(chanind);
    allevent1_times{chanj}=[]; 
    allevent2_times{chanj}=[]; 
end

for chanind=1:length(dochannels)
   chanj=dochannels(chanind);
   multitimeschanj=multitimes(find(multibestchannels==chanj));
   for trialk=1:length(event1times);
        t0=event1times(trialk); 
        spikeinds=find(multitimeschanj<(t0+posteventtime) & multitimeschanj>(t0-preeventtime));
        rel_spiketimes=multitimeschanj(spikeinds)-t0;    
        allevent1_times{chanj}=[allevent1_times{chanj} rel_spiketimes];
   end
end

if length(event2times)>0
for chanind=1:length(dochannels)
   chanj=dochannels(chanind);
   multitimeschanj=multitimes(find(multibestchannels==chanj));
   for trialk=1:length(event2times);
        t0=event2times(trialk); 
        spikeinds=find(multitimeschanj<(t0+posteventtime) & multitimeschanj>(t0-preeventtime));
        rel_spiketimes=multitimeschanj(spikeinds)-t0;    
        allevent2_times{chanj}=[allevent2_times{chanj} rel_spiketimes];
   end
end
end


for shaftind=1:numberofshafts;
    currentshaft=uniqueshafts(shaftind);

event1trig_multi_depth=[]; event2trig_multi_depth=[]; 
for i=1:length(uniquedepths);
    chansonshaft=find(s.shaft==currentshaft);
    depthi=uniquedepths(i);
    chansi=find(s.z==depthi);
    chansi=intersect(chansi,chansonshaft);
    chansi=setdiff(chansi,badchannels);
    
    
    event1_psth=[]; event1_timesdepthi=[]; event2_psth=[]; event2_timesdepthi=[];
    for j=1:length(chansi);
        chanj=chansi(j);
      
        event1_times_chanj=allevent1_times{chanj};
        event2_times_chanj=allevent2_times{chanj};
               
        if length(event1_times_chanj)>0
        event1_timesdepthi=[event1_timesdepthi event1_times_chanj];
        end  
        
        if length(event2_times_chanj)>0
        event2_timesdepthi=[event2_timesdepthi event2_times_chanj];
        end   
    end
    
    event1_psth=histc(event1_timesdepthi,timebins)/length(event1times)/timebinsize;                %removes last point, which because of binning has zero  value in psth.
    event1_psth=event1_psth(1:(length(event1_psth)-1));
    
    if length(event2times)>0
    event2_psth=histc(event2_timesdepthi,timebins)/length(event2times)/timebinsize;                %removes last point, which because of binning has zero  value in psth.
    event2_psth=event2_psth(1:(length(event2_psth)-1));
    end
    
    if length(chansi)==0
    event1_psth=zeros(1,length(timebins)-1);
    event2_psth=event1_psth;  
    end
    
    norm_event1_rate=smooth(event1_psth/max(event1_psth),3);   %mean normalized firing rate = rate/(peak rate).  range = 0 to 1.
    norm_event2_rate=smooth(event2_psth/max(event1_psth),3);   %note: use the same normalization factor as for normrate_event1.
    
    if norm_event1_rate==0
        norm_event1_rate=zeros(1,length(timebins)-1)';
    end
    
    event1trig_multi_depth=[event1trig_multi_depth; norm_event1_rate'];
    event2trig_multi_depth=[event2trig_multi_depth; norm_event2_rate'];     
end

event1trig_multi_depth=flipud(event1trig_multi_depth);    %flip to put tip electrodes at bottom
event2trig_multi_depth=flipud(event2trig_multi_depth);    %flip to put tip electrodes at bottom

% h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% smoothevent1trig_multi_depth=event1trig_multi_depth; %filter2(h, event1trig_multi_depth);
% smoothevent2trig_multi_depth=event2trig_multi_depth; %filter2(h, event2trig_multi_depth);


figure(figind)
subplot(2,1,1)
hold off
imageplotrange=[0 1];
imagesc(event1trig_multi_depth,imageplotrange)
colormap('jet')
colorbar

set(gca,'XTick',[0:(size(event1trig_multi_depth,2)*xdiv/(preeventtime+posteventtime)):size(event1trig_multi_depth,2)])
set(gca,'XTickLabel',[-preeventtime:xdiv:posteventtime])
xlabel('time (s)','FontSize',10)

lines_permm=length(chansonshaft)/max(probedepths);
set(gca,'YTick',[0:lines_permm*ydiv:length(chansonshaft)])
set(gca,'YTickLabel',[ceil(length(chansonshaft)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)
title([filename '; Shaft ' num2str(currentshaft) ',' triggerevent1 ' triggered normalized MULTI-UNIT firing rate vs depth.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')

subplot(2,1,2)
if length(event2times)>0
hold off
imagesc(event2trig_multi_depth,imageplotrange)
colormap('jet')
colorbar

set(gca,'XTick',[0:(size(event2trig_zscore_depth,2)*xdiv/(preeventtime+posteventtime)):size(event2trig_zscore_depth,2)])
set(gca,'XTickLabel',[-preeventtime:xdiv:posteventtime])
xlabel('time (s)','FontSize',10)

lines_permm=length(chansonshaft)/max(probedepths);
set(gca,'YTick',[0:lines_permm*ydiv:length(chansonshaft)])
set(gca,'YTickLabel',[ceil(length(chansonshaft)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)
title([triggerevent2 ' triggered normalized MULTI-UNIT firing rate vs depth.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')
% line([round(preeventtime/timebinsize) round(preeventtime/timebinsize)], [0+1 size(event1_LFP,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes
else axis off
end

set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   

saveas(figure(figind),[multisavedir 'multiunitstack_sh' num2str(currentshaft) '.jpg' ]  ,'jpg')
saveas(figure(figind),[multisavedir 'multiunitstack_sh' num2str(currentshaft) '.eps' ]  ,'psc2')
saveas(figure(figind),[multisavedir 'multiunitstack_sh' num2str(currentshaft) '.fig' ]  ,'fig')
figind=figind+1;

end

if exist(LFPdir,'dir')>0    
plot_triggedspectra   %plots event-triggered LFP spectra for selected trials & channel. contains additional plot settings inside subroutine script.
plot_triggedLFPpower  %plots event-triggered LFP power for selected trials & channel. contains additional plot settings inside subroutine script.
end


% %***2D color plot of mean amplitude ranges***
% amprange2D=[]; newprobedepths=[]; oldprobedepths=probedepths;
% for i=1:length(uniquedepths);
%     depthi=uniquedepths(i);
%     chansi=find(s.z==depthi);
%     chansi=setdiff(chansi,badchannels);
% 
%     if length(chansi)>0
%     j=1; %use only one channels per depth for amplitude
% %     for j=1:length(chansi);
%         chanj=chansi(j);
%         amprange2D=[amprange2D; amprange{chanj}];
% %     end
%     newprobedepths=[newprobedepths probedepths(i)];
%     end
%     
% end
% amprange2D=flipud(amprange2D);    %flip to put tip electrodes at bottom
% 
% probedepths=newprobedepths;
% 
% figind=figind+1
% figure(figind)
% subplot(1,2,1)
% imagesc(amprange2D,[min(min(amprange2D)) max(max(amprange2D))])
% 
% set(gca,'XTick',[0:30:totaltime/multibinsize])
% set(gca,'XTickLabel',[0:(30*multibinsize/60):totaltime/60])
% xlabel('time (minutes)','FontSize',8)
% 
% ydiv=0.1;  %units in mm.
% lines_permm=size(amprange2D,1)/(max(probedepths));
% set(gca,'YTick',[0:lines_permm*ydiv:size(amprange2D,1)])
% set(gca,'YTickLabel',[ceil(size(amprange2D,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
% ylabel('distance from probe tip (mm)','FontSize',8)
% 
% title([filename '; mean Vpp'],'FontSize',8)
% set(gca,'FontSize',8,'TickDir','out')
% 
% subplot(1,2,2)
% ampsperdepth=mean(amprange2D');
% ampsperdepth=ampsperdepth;    %flip to put tip electrodes at bottom
% plot(probedepths,ampsperdepth,'.-','Color','k')
% xlabel('distance to tip (mm)','FontSize', 8)
% ylabel('mean Vpp over all trials','FontSize', 8)
% title('mean Vpp over all trials','FontSize', 8)
% axis([0 max(probedepths) min(ampsperdepth) max(ampsperdepth)])
% set(gca,'FontSize', 8,'TickDir','out')
% 
% saveas(figure(figind),[multisavedir filename '_amprange2D.fig' ]  ,'fig')
% saveas(figure(figind),[multisavedir filename '_amprange2D.jpg' ]  ,'jpg')
% saveas(figure(figind),[multisavedir filename '_amprange2D.eps' ]  ,'psc2')
% %***End of 2D color plot of mean amplitude ranges***





% %***2D color plot of absolute and z-score firing rate***
% zscore2D=[]; psth2D=[]; 
% for i=1:length(uniquedepths);
%     depthi=uniquedepths(i);
%     chansi=find(s.z==depthi);
%     chansi=setdiff(chansi,badchannels);
%     
%     spiketimes=[]; 
%     for j=1:length(chansi);
%         chanj=chansi(j);
%         timesi=multitimes(find(multibestchannels==chanj));
%         spiketimes=[spiketimes timesi];
%     end
%   
% 
%     if length(spiketimes)>0
%     psth=[];
%     psth=histc(spiketimes,0:multibinsize:totaltime)/multibinsize;                %removes last point, which because of binning has zero  value in psth.
%     psth=psth(1:(length(psth)-1));
%     zscore=(psth-mean(psth))/std(psth);
%     
%     else
%     zscore=zeros(1,length(multibinsize:multibinsize:totaltime));
%     psth=zeros(1,length(multibinsize:multibinsize:totaltime));
%     end
%     
% zscore2D=[zscore2D; zscore]; 
% psth2D=[psth2D; psth];
% 
% end
% 
% h=fspecial('gaussian',3,0.75);  %gaussian filter.
% zscore2D = filter2(h, zscore2D);
% zscore2D=flipud(zscore2D);    %flip to put tip electrodes at bottom
% 
% psth2D=flipud(psth2D);        %flip to put tip electrodes at bottom
% 
% probedepths=oldprobedepths;
% 
% figind=figind+1;
% figure(figind)
% imagesc(zscore2D,[-2, 2])
% 
% colorbar 
% set(gca,'XTick',[0:15:totaltime/multibinsize])
% set(gca,'XTickLabel',[0:(15*multibinsize/60):totaltime/60])
% xlabel('time (minutes)','FontSize', 8)
% 
% ydiv=0.1;  %units in mm.
% lines_permm=size(zscore2D,1)/(max(probedepths));
% set(gca,'YTick',[0:lines_permm*ydiv:size(zscore2D,1)])
% set(gca,'YTickLabel',[ceil(size(zscore2D,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
% ylabel('distance from probe tip (mm)','FontSize', 8)
% 
% title([filename '; z-score of multi-unit activity'],'FontSize', 8)
% set(gca,'FontSize', 8,'TickDir','out')
% 
% saveas(figure(figind),[multisavedir filename '_zscore2D.jpg' ]  ,'jpg')
% saveas(figure(figind),[multisavedir filename '_zscore2D.eps' ]  ,'psc2')
% %***End of 2D color plot of absolute and z-score firing rate***
