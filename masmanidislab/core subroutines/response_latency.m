disp(['Finding event-triggered firing latency.'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', 'start', 'stop'

trialselection1='correct licking';     %select which event1 trials to display. 
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
                            %'spontaneous licking'. excludes cues.
                            
                            %***Compatible with +/- 'acceleration', 'start', or 'stop' triggerevents:***
                            %'CS1 running'. event times occuring between CS and CS-US delay time. 
                            %'CS2 running'
                            %'spontaneous running'. excludes cues and licking episodes.
                                                                                                                                           
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='all';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

timebinsize=0.02;           %default=0.02 s.
preeventtime=5;             %default=2. time in sec to use before event onset to calculate baseline spikes
baselineduration=2;         %default=(same as preeventtime). amount of time to use spikes from preeventtime in calculating baseline spikes for firing_latency.
minlatency=0;              %only consider latency in the range minlatency to maxlatency.           
maxlatency=8;              %maximum latency to be considered. useful if there are multiple peaks during trial, or want to trigger on particular time.

onlysigmod='y';            %if 'y' uses only significantly modulated units (triggered on event 1). used in trigged_spiketimes.
max_pvalue=0.01;           %default=0.01. threshold for accepting event-triggered firing rate changes as significant.
minconsec=3;               %number of consecutive significant bins that need to be significantly different from baseline to satisfy unit significance of firing criterion.

slowburstISI=0.02;          %default=0.02 s. maximum ISI a pair of spikes can have to be counted as a slow burst. the minimum ISI for ending the burst is twice this value.
rapidburstISI=0.005;

spontangap=15;          %default=15 s. minimum time a start and end of a lick episode can be from a cue to be considered spontaneous.
%************************************************
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', start', 'stop', 'none'.    
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013. 
onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1). used in trigged_spiketimes.
min_zscore=3;              %default=3. threshold for determine whether a unit is significantly modulated by event 1, and in one method of calculating unit response latencies.
smoothingwindow='n';       %default='n' in firing_latency. used in event_trigrates.
posteventtime=10;            %default=10. time in sec to use after event onset.

close all
load_results

lickbinsize=timebinsize;  
timebins=-preeventtime:timebinsize:posteventtime;
grouptimebins=-preeventtime:grouptimebinsize:posteventtime;
licktimebins=-preeventtime:lickbinsize:posteventtime;


if length(strmatch(plotunitclass,'all'))==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(plotunitclass));
    dounits=dounits(unitclassinds);
    plotlabel=['Only using putative ' unitclassnames{dounits(1)} ' units'];
else
    plotlabel=['Using all unit classes (or unclassified)'];
end
disp(plotlabel)

figind=1;
scrsz=get(0,'ScreenSize');

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

if length(licktimes)>0
get_lickproperties
end

trigged_running     %finds event-triggered running & acceleration.
      
trigged_spiketimes   %event-triggered spike times. used to determine standard baselines, and which units are significant if onlysigmod=='y'

trigged_bursttimes

t0=floor((preeventtime+minlatency)/timebinsize)+1;
tf=t0+floor((maxlatency/timebinsize));

baseline_tf=floor(baselineduration/timebinsize);

latency=[];   %latency from CS to US.
latency.triggerevent1=triggerevent1;
latency.trialselection1=trialselection1;
for unitind=1:length(dounits);
    unitj=dounits(unitind);  
    
    baselinespikes=event1_spikespertrial{unitj}(:,1:baseline_tf);
    baselinespikes=reshape(baselinespikes,1,size(baselinespikes,1)*size(baselinespikes,2));
       
    ratej=event1_spikerate{unitj}(t0:tf); %excludes the pre-event spike times because latency is only after event onset.      
    
    %1. latency to peak average firing rate.
    maxratetime=find(ratej==max(ratej)); 
    maxratetime=maxratetime(1);
    if ratej(maxratetime)>(min_zscore*stdbaselinerate{unitj}+baselinerate{unitj})
    latency.peakfiring{unitj}=maxratetime*timebinsize;  %note: time resolution of latency is set by timebinsize.    
    end
    
    %2. latency to first (if any) spike burst in each trial. This approach
    %only works well if baseline firing <~0.5 Hz and cell responds to event
    %with a pronounced burst.
    allburst_times=[]; latency.burstfiring{unitj}=[];
    for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        burst_times=event1_bursttimes{unitj}{trialk};
        burst_times(find(burst_times<minlatency | burst_times>maxlatency))=[];  
        if length(burst_times)>0
        allburst_times=[allburst_times burst_times(1)];
        end
    end  
    if length(allburst_times)>0
    latency.burstfiring{unitj}=allburst_times;
    end
    
    %3. latency to significant difference from baseline (t-test). 
    %Note: must reject null hypothesis 3 consecutive times.
    consecsig=0;
    latency.thresholdfiring{unitj}=[];
    for tbin=t0:tf
        spikesinbin=event1_spikespertrial{unitj}(:,tbin);
        [h,p]=ttest2(baselinespikes,spikesinbin, 'alpha', max_pvalue);  
        if h==1 & consecsig==minconsec
        latency.thresholdfiring{unitj}=(tbin-minconsec)*timebinsize-(preeventtime);
        break
        elseif h==1 & consecsig<minconsec
            consecsig=consecsig+1;
        elseif h==0
            consecsig=0;
        end
    end
       
end

%4. latency to mean lick rate for selected triggerevent and trials.
%Note: must licking 5 consecutive bins. This method is better than trial-by-trial method.
lickrate=event1_lickrate(t0:(posteventtime/lickbinsize));
siglickinds=find(lickrate>0);   
if length(siglickinds)>0
consecinds=diff(diff(diff(diff(siglickinds))));
findconsec=find(consecinds==0);
    if length(findconsec)>0        
    latency.licking=siglickinds(findconsec(1))*timebinsize;
    end
end  


scatplot_x=[]; scatplot_z=[]; scatplot_latency=[]; scatplot_burstlatency=[];
for unitind=1:length(dounits);
    unitj=dounits(unitind);
    if length(latency.thresholdfiring{unitj})>0 & length(mean(latency.burstfiring{unitj}))>0
        scatplot_x=[scatplot_x unitx{unitj}];
        scatplot_z=[scatplot_z unitz{unitj}];  
        scatplot_latency=[scatplot_latency latency.thresholdfiring{unitj}];
        scatplot_burstlatency=[scatplot_burstlatency mean(latency.burstfiring{unitj})];   %sometimes this gives 'NaN' values if no bursts were found.
    end
end

percentfiring_preUS=round(100*length(find(scatplot_latency<meancuesoldelay))/length(dounits));   %note: percentage is relative to ALL dounits.
percentbursting_preUS=round(100*length(find(scatplot_burstlatency<meancuesoldelay))/length(dounits));

figure(1)
set(gcf,'Position',[0.35*scrsz(1)+400 0.35*scrsz(2)+300 0.4*scrsz(3) 0.6*scrsz(4)])
subplot(3,2,1)
plot(scatplot_x,scatplot_latency,'o','MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','k')
xlabel('unit ML axis location (mm)', 'FontSize',8)
ylabel('latency (s)', 'FontSize',8)
title('latency to significant spike count change', 'FontSize',8)
axis([min(scatplot_x)-0.1 max(scatplot_x)+0.1 minlatency maxlatency])
set(gca,'FontSize',8,'TickDir','out')

subplot(3,2,3)
plot(scatplot_z,scatplot_latency,'o','MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','k')
xlabel('unit depth (mm)', 'FontSize',8)
ylabel('latency (s)', 'FontSize',8)
title(['mean firing latency: ' num2str(mean(scatplot_latency)) '+/-' num2str(std(scatplot_latency)/sqrt(length(scatplot_latency))) ' s. (error=SEM)'], 'FontSize',8)
axis([min(scatplot_z)-0.1 max(scatplot_z)+0.1 minlatency maxlatency])
set(gca,'FontSize',8,'TickDir','out')

subplot(3,2,5)
hist(scatplot_latency, minlatency:0.1:maxlatency)
xlabel('firing latency (s)', 'FontSize',8)
axis tight
title(['mean licking latency: ' num2str(latency.licking) ' s; ' num2str(percentfiring_preUS) '% units respond before US.'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

subplot(3,2,2)
plot(scatplot_x,scatplot_burstlatency,'o','MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','k')
axis([min(scatplot_x)-0.1 max(scatplot_x)+0.1 minlatency maxlatency])
xlabel('unit ML axis location (mm)', 'FontSize',8)
ylabel('burst latency (s)', 'FontSize',8)
title('latency to first slow burst', 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

subplot(3,2,4)
plot(scatplot_z,scatplot_burstlatency,'o','MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','k')
axis([min(scatplot_z)-0.1 max(scatplot_z)+0.1 minlatency maxlatency])
xlabel('unit depth (mm)', 'FontSize',8)
ylabel('burst latency (s)', 'FontSize',8)
title(['mean burst latency: ' num2str(nanmean(scatplot_burstlatency)) '+/-' num2str(nanstd(scatplot_burstlatency)/sqrt(length(scatplot_burstlatency))) ' s. (error=SEM)'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

subplot(3,2,6)
hist(scatplot_burstlatency, minlatency:0.1:maxlatency)
xlabel('burst latency (s)', 'FontSize',8)
axis tight
title([num2str(percentbursting_preUS) '% units burst before US.'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

