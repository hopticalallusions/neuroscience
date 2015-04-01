disp(['finding event-triggered LFP stack vs electrode depth. Note: it is recommended to only plot one trial at a time.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'none'.     
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'none'.   

trialselection1='29';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials                                        
                            %'rewarded' only trials with a solenoid. triggerevent should be a CS.
                            %'unrewarded' only uses trials with no solenoid. triggerevent should be a CS.
                            %'expectedUS' only uses trials with expected reward presentation (i.e. preceded by predictive cue). triggerevent should be 'solenoid.
                            %'unexpectedUS' only uses trials with unexpected reward presentation (i.e. not preceded by cue). triggerevent should be 'solenoid.
                                %'onlylicks' only uses CS1 & CS2 trials where licking occurs after the CS (does not distinguish btwn correct/incorrect).
                                %'onlyright' only uses CS1 &  CS2 trials with Correct licking or withholding of licking based on presence of solenoid.
                                %'onlywrong' only uses CS1 & CS2 trials with Incorrect licking or withholding of licking based on presence of solenoid.
                            
trialselection2='none';     %select which event2 trials to display. same options as trialselection1.

laserfreqselect='none';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
                            
xdiv=0.5; %units in seconds. used only in plotting.
ydiv=0.2;  %units in mm.

selectstim='n'; %if 'y', will only select the specified stimulus value (e.g., moving bar angle=90 degrees) for triggered averaging.
%************************************************
trialgroupsize=10;  %not used here.
grouptimebinsize=0.1;  %not used here.

load_results

select_triggers_trials 

figind=1;

if filterLFP=='n'
disp(['**note: no LFP filtering is applied.**'])
else disp(['filtering LFP from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])
end

for shaftind=1:numberofshafts;
    currentshaft=uniqueshafts(shaftind);
    disp(['current shaft: ' num2str(currentshaft) '.'])

event1_LFPstack=[]; 
for i=1:length(uniquedepths);
    chansonshaft=find(s.shaft==currentshaft);
    depthi=uniquedepths(i);
    chansi=find(s.z==depthi);
    chansi=intersect(chansi,chansonshaft);
    chansi=setdiff(chansi,badchannels);
    
    if length(chansi)>0
    for j=1:length(chansi);
        chanj=chansi(j);
        currentvoltagefile=['LFPvoltage_ch' num2str(chanj) '.mat'];
        load([LFPvoltagedir currentvoltagefile]); 
        if filterLFP=='y'
        dofilter_LFP
        end
        
        LFPdepthi=[]; voltagedepthi=[];
        for trialind=1:length(doevent1trials);
            trialk=doevent1trials(trialind);
            if trialk>length(event1times)
                continue
            end
            ti=event1times(trialk);
            ti=round(ti*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
            continue
            end
            
            if selectstim=='y' % & state condition     %select specific angle for stimulus-triggered LFP averaging.            
            continue
            end
                   
            voltagedepthi=[voltagedepthi; LFPvoltage(t0:tf)];            %take LFP voltage.
        end        
    end
      
  
    if  size(voltagedepthi,1)>1
    event1_LFPstack=[event1_LFPstack; mean(voltagedepthi)];
    else
    event1_LFPstack=[event1_LFPstack; voltagedepthi];
    end
    clear LFPdepthi
    end
    
end

input('d')
event1_LFPstack=flipud(event1_LFPstack);
h=fspecial('gaussian',[1 3],0.75);  %gaussian filter only in time direction.
% h=fspecial('gaussian',3,0.75);  %gaussian filter.
smoothevent1_LFPstack = filter2(h, event1_LFPstack);

event2_LFPstack=[]; 
smoothevent2_LFPstack=0;
if length(event2times)>0
for i=1:length(uniquedepths);
    chansonshaft=find(s.shaft==currentshaft);
    depthi=uniquedepths(i);
    chansi=find(s.z==depthi);
    chansi=intersect(chansi,chansonshaft);
    chansi=setdiff(chansi,badchannels);
   
    for j=1:length(chansi);
        chanj=chansi(j);
        currentvoltagefile=['LFPvoltage_ch' num2str(chanj) '.mat'];
        load([LFPvoltagedir currentvoltagefile]); 
        if filterLFP=='y'
        dofilter_LFP
        end
        
        LFPdepthi=[]; voltagedepthi=[];
        for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            if trialk>length(event2times)
                continue
            end
            ti=event2times(trialk);
            ti=round(ti*LFPsamplingrate);
            t0=ti-round(preeventtime*LFPsamplingrate);
            tf=ti+round(posteventtime*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
            continue
            end
            
            if selectstim=='y' % & state condition     %select specific angle for stimulus-triggered LFP averaging.            
            continue
            end
       
            voltagedepthi=[voltagedepthi; LFPvoltage(t0:tf)];            %take LFP voltage.
        end        
    end
        
    if  size(voltagedepthi,1)>1
    event2_LFPstack=[event2_LFPstack; mean(voltagedepthi)];
    else
    event2_LFPstack=[event2_LFPstack; voltagedepthi];
    end
    clear LFPdepthi
    
end

event2_LFPstack=flipud(event2_LFPstack);
h=fspecial('gaussian',[1 3],0.75);  %gaussian filter only in time direction.
% h=fspecial('gaussian',3,0.75);  %gaussian filter.
smoothevent2_LFPstack = filter2(h, event2_LFPstack);

end

%plotting.
disp(['plotting cue-triggered LFP depth profiles.'])
figure(figind)
subplot(2,length(uniqueshafts),shaftind)
hold off
imagesc(smoothevent1_LFPstack,[min([mean(smoothevent1_LFPstack) mean(smoothevent2_LFPstack)]) max([mean(smoothevent1_LFPstack) mean(smoothevent2_LFPstack)])])   %plot command. remove ranges if want to show entire range

colorbar
colormap jet

set(gca,'XTick',[0:(LFPsamplingrate*xdiv):size(event1_LFPstack,2)])
set(gca,'XTickLabel',[-preeventtime:xdiv:posteventtime])
xlabel('time (s)','FontSize',10)

lines_permm=length(chansonshaft)/max(probedepths);
set(gca,'YTick',[0:lines_permm*ydiv:length(chansonshaft)])
set(gca,'YTickLabel',[ceil(length(chansonshaft)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)

title([filename '; Shaft ' num2str(currentshaft) ', ' triggerevent1 ' triggered average LFP vs depth. f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection1 '.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')
% line([LFPsamplingrate*preeventtime LFPsamplingrate*preeventtime], [0+1 size(event1_LFPstack,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes

subplot(2,length(uniqueshafts),length(uniqueshafts)+shaftind)
hold off
if length(event2times)>0
imagesc(smoothevent2_LFPstack,[min([mean(smoothevent1_LFPstack) mean(smoothevent2_LFPstack)]) max([mean(smoothevent1_LFPstack) mean(smoothevent2_LFPstack)])])   %plot command. remove ranges if want to show entire range

colorbar
colormap jet

set(gca,'XTick',[0:(LFPsamplingrate*xdiv):size(event2_LFPstack,2)])
set(gca,'XTickLabel',[-preeventtime:xdiv:posteventtime])
xlabel('time (s)','FontSize',10)

lines_permm=length(chansonshaft)/max(probedepths);
set(gca,'YTick',[0:lines_permm*ydiv:length(chansonshaft)])
set(gca,'YTickLabel',[ceil(length(chansonshaft)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)

title([filename '; Shaft ' num2str(currentshaft) ', ' triggerevent2 ' triggered average LFP vs depth. f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection2 '.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')
% line([LFPsamplingrate*preeventtime LFPsamplingrate*preeventtime], [0+1 size(event1_LFPstack,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes
end


end

saveas(figure(figind),[stimephysjpgdir 'LFPstack_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'LFPstack_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'LFPstack_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.fig' ]  ,'fig')
% close(figind)
% figind=figind+1;
