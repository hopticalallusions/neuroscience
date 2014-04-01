disp(['finding event-triggered LFP stack vs electrode depth. Note: it is recommended to only plot one trial at a time.'])

set_plot_parameters

triggerevent1='laser';  %options: 'CS1', 'CS2', 'laser'. 
                      %note: if there is no stimulus file then select_triggers_trials will ask to manually enter eventtimes.

trialselection1='4';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            
                            %***Compatible with 'CS' triggerevents:***
                            %'rewarded' only uses CS trials with a US. 
                            %'unrewarded' only uses CS trials with no solenoid. 
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            
                            %***Compatible with 'solenoid' triggerevent:***
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). note that sol1times have time offset in load_results to align with cue times in plots.
                            
                            %***Compatible with 'startlicking' & 'endlicking' triggerevents:***
                            %'CS1 licking'. licking episodes beginning between CS and CS-US delay time (they don't have to end there).
                            %'CS2 licking'
                            %'spontaneous licking'. excludes cues & solenoids.
                            
                            %***Compatible with +/- 'acceleration', 'start', or 'stop' triggerevents:***
                            %'CS1 running'. event times occuring between CS and CS-US delay time. 
                            %'CS2 running'
                            %'spontaneous running'. excludes cues and licking episodes.
                                                                                    
                            
laserfreqselect='none';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
 
f_low_LFP=0.5;              
f_high_LFP=100;    

preeventtime=2;               %time in sec to use before event onset. (must be 0 or positive).
posteventtime=20;              %time in sec to use after event onset.

xdiv=1; %units in seconds. used only in plotting.
ydiv=0.2;  %units in mm.

selectstim='n'; %if 'y', will only select the specified stimulus value (e.g., moving bar angle=90 degrees) for triggered averaging.
%************************************************
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'none'.     
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'none'.   

trialselection2='none';     %select which event2 trials to display. same options as trialselection1.


trialgroupsize=10;  %not used here.
grouptimebinsize=0.1;  %not used here.

load_results

disp(['this probe had ' num2str(length(badchannels)) ' bad channels.'])

shafts=s.shaft;
uniqueshafts=unique(shafts);
numberofshafts=length(unique(shafts));

clear positions

select_triggers_trials 

figind=1;

if filterLFP=='n'
disp(['**note: no LFP filtering is applied.**'])
else disp(['filtering LFP from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])
end

event1_LFPstack=[]; 
for shaftind=1:numberofshafts;
    currentshaft=uniqueshafts(shaftind);
    event1_LFPstack{currentshaft}=[];
    chansonshaft=find(s.shaft==currentshaft);
    goodchansonshaft=setdiff(chansonshaft,badchannels);

    disp(['current shaft: ' num2str(currentshaft) '/' num2str(numberofshafts) '.'])
    
    uniquedepths_shafti=unique(s.z(chansonshaft));
    probedepths_shafti=-(uniquedepths_shafti-max(uniquedepths_shafti)-tipelectrode)/1000;
   
for i=1:length(uniquedepths_shafti);
    depthi=uniquedepths_shafti(i);
    chansi=find(s.z==depthi);
    chansi=intersect(chansi,chansonshaft);   %all channels on current shaft and depthi (includes bad channels)
    
    if length(chansi)>0
    for j=1:length(chansi);   %if there are multiple channels in chansi, take the average LFP voltage of all good chansi.
        chanj=chansi(j);
        
        if length(intersect(chanj,badchannels))==1   %if current channel is bad, use the nearest good channel in its place.
        	zchanj=s.z(chanj);
            zgoodchansonshaft=s.z(setdiff(goodchansonshaft,chanj));
            diffz=abs(zgoodchansonshaft-zchanj);
            minind=find(diffz==min(diffz));
            newchanj=min(goodchansonshaft(minind));
            chanj=newchanj;
        end
        
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
    event1_LFPstack{currentshaft}=[event1_LFPstack{currentshaft}; mean(voltagedepthi)];
    else
    event1_LFPstack{currentshaft}=[event1_LFPstack{currentshaft}; voltagedepthi];
    end
    clear LFPdepthi
    end
    
end

event1_LFPstack{currentshaft}=flipud(event1_LFPstack{currentshaft});
% h=fspecial('gaussian',[1 3],0.75);  %gaussian filter only in time direction.
% event1_LFPstack{currentshaft} = filter2(h, event1_LFPstack{currentshaft});

%plotting.
disp(['plotting cue-triggered LFP depth profiles.'])
figure(figind)
subplot(length(uniqueshafts),1,shaftind)
hold off
imagesc(event1_LFPstack{currentshaft},[min(min(event1_LFPstack{currentshaft})) max(max(event1_LFPstack{currentshaft}))])   %plot command. remove ranges if want to show entire range

colorbar
colormap jet

set(gca,'XTick',[0:(LFPsamplingrate*xdiv):size(event1_LFPstack{currentshaft},2)])
set(gca,'XTickLabel',[-preeventtime:xdiv:posteventtime])

if exist('positions','var')
xlabel(['shaft ' num2str(currentshaft) ', AP=' num2str(positions.AP{currentshaft}) ', ML=' num2str(positions.ML{currentshaft}) ' mm'] ,'FontSize',8)

yticks=0:5:length(uniquedepths_shafti);
remticks=rem(length(uniquedepths_shafti),max(yticks));
set(gca,'YTick',yticks)
lines_permm=length(uniquedepths_shafti)/max(probedepths_shafti);  %lines per millimeter.
yticklabels=fliplr(yticks/lines_permm+shaftz{currentshaft}+remticks/lines_permm)+tipelectrode/1000; 
yticklabels=round(yticklabels*100)/100;
set(gca,'YTickLabel',yticklabels)
ylabel('electrode depth (mm)','FontSize', 8)
end

% yticks=0:5:length(uniquedepths);
% remticks=rem(length(uniquedepths),max(yticks));
% set(gca,'YTick',yticks)
% lines_permm=length(uniquedepths)/max(probedepths);  %lines per millimeter.
% yticklabels=fliplr(yticks/lines_permm+shaftz{currentshaft}+remticks/lines_permm); 
% yticklabels=round(yticklabels*100)/100;
% set(gca,'YTickLabel',yticklabels)
% ylabel('electrode depth (mm)','FontSize', 8)

title([filename ', ' triggerevent1 ' triggered average LFP vs depth. f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection1 '.'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')
% line([LFPsamplingrate*preeventtime LFPsamplingrate*preeventtime], [0+1 size(event1_LFPstack{currentshaft},1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes

end

mkdir(stimephysjpgdir)
mkdir(stimephysepsdir)
mkdir(stimephysmfigdir)

saveas(figure(figind),[stimephysjpgdir 'LFPstack_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.jpg' ]  ,'jpg')
saveas(figure(figind),[stimephysepsdir 'LFPstack_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.eps' ]  ,'psc2')
saveas(figure(figind),[stimephysmfigdir 'LFPstack_' num2str(f_low_LFP) '-' num2str(f_high_LFP) 'Hz.fig' ]  ,'fig')
% close(figind)
% figind=figind+1;
