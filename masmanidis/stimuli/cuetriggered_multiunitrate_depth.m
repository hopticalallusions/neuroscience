load([multisavedir 'multitimes.mat'])
load([multisavedir 'multibestchannels.mat'])

cue1_multitimes=[]; cue2_multitimes=[];  allcue1_multitimes=[]; allcue2_multitimes=[]; %initialize cue-triggered spike times
uniquechans=unique(multibestchannels);
for chanind=1:length(uniquechans)
    chani=uniquechans(chanind); 
    cue1_multitimes{chani}=[]; allcue1_multitimes{chani}=[]; 
    for trialk=1:length(cue1times);
        cue1_multitimes{chani}{trialk}=[];
    end
    cue2_multitimes{chani}=[]; allcue2_multitimes{chani}=[];
    for trialk=1:length(cue2times);
        cue2_multitimes{chani}{trialk}=[];
    end
end


['multiunit analysis: cue 1 trials']   
for chanind=1:length(uniquechans)         
   chani=uniquechans(chanind);
   stimeschani=multitimes(find(multibestchannels==chani));
   for trialk=1:length(cue1times);
        t0=cue1times(trialk); 
        spikeinds=find(stimeschani<(t0+postcuetime) & stimeschani>(t0-precuetime));
        rel_spiketimes=stimeschani(spikeinds)-t0;
        cue1_multitimes{chani}{trialk}=rel_spiketimes;
        allcue1_multitimes{chani}=[allcue1_multitimes{chani} rel_spiketimes];
   end
end
    
['multiunit analysis: cue 2 trials']
for chanind=1:length(uniquechans)
    chani=uniquechans(chanind);
    stimeschani=multitimes(find(multibestchannels==chani));
    for trialk=1:length(cue2times);
        t0=cue2times(trialk);
        spikeinds=find(stimeschani<(t0+postcuetime) & stimeschani>(t0-precuetime));
        rel_spiketimes=stimeschani(spikeinds)-t0;
        cue2_multitimes{chani}{trialk}=rel_spiketimes;
        allcue2_multitimes{chani}=[allcue2_multitimes{chani} rel_spiketimes];
   end
end




for shaftind=1:numberofshafts;
    currentshaft=uniqueshafts(shaftind);
    ['current shaft: ' num2str(currentshaft) '.']
 
cue1trig_zscore_depth=[]; cue1trig_psth_depth=[]; cue2trig_zscore_depth=[]; cue2trig_psth_depth=[];
for i=1:length(uniquedepths);
    chansonshaft=find(s.shaft==currentshaft);
    depthi=uniquedepths(i);
    chansi=find(s.y==depthi);
    chansi=intersect(chansi,chansonshaft);
    chansi=setdiff(chansi,badchannels);
    
    cue1_zscore=[]; cue1_timesdepthi=[]; cue2_zscore=[]; cue2_timesdepthi=[];
    for j=1:length(chansi);
        chanj=chansi(j);
        cue1_times_chanj=allcue1_multitimes{chanj};
        cue2_times_chanj=allcue2_multitimes{chanj};
                  
        cue1_timesdepthi=[cue1_timesdepthi cue1_times_chanj];
        cue2_timesdepthi=[cue2_timesdepthi cue2_times_chanj];
   
    end
    
    cue1_psth=histc(cue1_timesdepthi,timebins)/length(cue1times)/timebinsize;                %removes last point, which because of binning has zero  value in psth.
    cue1_psth=cue1_psth(1:(length(cue1_psth)-1));
     
    cue2_psth=histc(cue2_timesdepthi,timebins)/length(cue2times)/timebinsize;                %removes last point, which because of binning has zero  value in psth.
    cue2_psth=cue2_psth(1:(length(cue2_psth)-1));
    
    if length(chansi)==0
    cue1_zscore=zeros(1,length(timebins)-1);
    cue1_psth=zeros(1,length(timebins)-1);
    
    cue2_zscore=cue1_zscore;
    cue2_psth=cue1_psth;
    
    else
    
        if length(cue1_psth)>0
        cue1_meanpsth=mean(cue1_psth(1:round(precuetime/timebinsize)));   %average baseline firing pre-cue
        cue1_stdpsth=std(cue1_psth(1:round(precuetime/timebinsize)));     %S.D. baseline firing pre-cue
        cue1_zscore=(cue1_psth-cue1_meanpsth)/cue1_stdpsth;
        else 
        cue1_zscore=zeros(1,length(timebins)-1);
        cue1_psth=zeros(1,length(timebins)-1);  
        end
        
        if length(cue2_psth)>0
        cue2_meanpsth=mean(cue2_psth(1:round(precuetime/timebinsize)));   %average baseline firing pre-cue
        cue2_stdpsth=std(cue2_psth(1:round(precuetime/timebinsize)));     %S.D. baseline firing pre-cue
        cue2_zscore=(cue2_psth-cue2_meanpsth)/cue2_stdpsth;
        else 
        cue2_zscore=zeros(1,length(timebins)-1);
        cue2_psth=zeros(1,length(timebins)-1);  
        end
    
    end
    
    cue1trig_zscore_depth=[cue1trig_zscore_depth; cue1_zscore]; 
    cue1trig_psth_depth=[cue1trig_psth_depth; cue1_psth];
    
    cue2trig_zscore_depth=[cue2trig_zscore_depth; cue2_zscore]; 
    cue2trig_psth_depth=[cue2trig_psth_depth; cue2_psth];
     
end

cue1trig_zscore_depth=flipud(cue1trig_zscore_depth);    %flip to put tip electrodes at bottom
cue2trig_zscore_depth=flipud(cue2trig_zscore_depth);    %flip to put tip electrodes at bottom

h=fspecial('gaussian',3 ,0.75);  %gaussian filter. only applied along horizontal direction (i.e., time).
smoothcue1trig_zscore_depth=filter2(h, cue1trig_zscore_depth);
smoothcue2trig_zscore_depth=filter2(h, cue2trig_zscore_depth);


figure(figind)
subplot(2,1,1)
hold off
imageplotrange=[mean(min(smoothcue1trig_zscore_depth))-2*std(min(smoothcue1trig_zscore_depth)) mean(max(smoothcue1trig_zscore_depth))+2*std(max(smoothcue1trig_zscore_depth))];
imagesc(smoothcue1trig_zscore_depth,[imageplotrange])
colormap('jet')
colorbar

set(gca,'XTick',[0:(size(cue2trig_zscore_depth,2)*xdiv/(precuetime+postcuetime)):size(cue2trig_zscore_depth,2)])
set(gca,'XTickLabel',[-precuetime:xdiv:postcuetime])
xlabel('time (s)','FontSize',10)

lines_permm=length(chansonshaft)/max(probedepths);
set(gca,'YTick',[0:lines_permm*ydiv:length(chansonshaft)])
set(gca,'YTickLabel',[ceil(length(chansonshaft)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)
title([filename '; Shaft ' num2str(currentshaft) ', Cue-1-triggered average multiunit z-score vs depth.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')
% line([round(precuetime/timebinsize) round(precuetime/timebinsize)], [0+1 size(cue1_LFP,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes

subplot(2,1,2)
hold off
imagesc(smoothcue2trig_zscore_depth,[imageplotrange])
colormap('jet')
colorbar

set(gca,'XTick',[0:(size(cue2trig_zscore_depth,2)*xdiv/(precuetime+postcuetime)):size(cue2trig_zscore_depth,2)])
set(gca,'XTickLabel',[-precuetime:xdiv:postcuetime])
xlabel('time (s)','FontSize',10)

lines_permm=length(chansonshaft)/max(probedepths);
set(gca,'YTick',[0:lines_permm*ydiv:length(chansonshaft)])
set(gca,'YTickLabel',[ceil(length(chansonshaft)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)
title(['Cue-1-triggered average multiunit z-score vs depth.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')
% line([round(precuetime/timebinsize) round(precuetime/timebinsize)], [0+1 size(cue1_LFP,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes

scrsz=get(0,'ScreenSize');
set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   

saveas(figure(figind),[stimephysjpgdir 'multiunit_ratedepth_sh' num2str(currentshaft) '.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'multiunit_ratedepth_sh' num2str(currentshaft) '.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'multiunit_ratedepth_sh' num2str(currentshaft) '.fig' ]  ,'fig')
figind=figind+1;

end
