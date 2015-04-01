disp(['using PCA to look for patterns in event-triggered neuronal dynamics'])

set_plot_parameters

spikes_or_bursts='s';       %'s' will use spikes, 'b' will use burst episodes.

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration'
                  
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
                            
                            %***Compatible with +/- 'acceleration' triggerevents:***
                            %'CS1 running'. peaks in acceleration occuring between CS and CS-US delay time. 
                            %'CS2 running'
                            %'spontaneous running'. excludes cues and licking episodes.
                                                                                                                                                                          
laserfreqselect='20 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='1';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

timebinsize=0.02;             %default=0.02 s.
preeventtime=0;               %default=2. time in sec to use before event onset.  
posteventtime=8;            %default=10. time in sec to use after event onset.
baselineduration=2;           %default=(same as preeventtime). amount of time to use spikes from preeventtime in calculating baseline spikes for firing_latency.

spontangap=15;          %default=15 s. minimum time a start and end of a lick episode can be from a cue to be considered spontaneous.
                           
onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1). Note: need to have run get_response_pvalue
max_pvalue=0.05;           %default=0.05. threshold for accepting event-triggered firing rate changes as significant.

smoothingwindow='y';       %default='y'. used in event_trigrates.
                             
%************************************************
close all
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'none'.                              
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.    

load_results

select_triggers_trials 

timebins=-preeventtime:timebinsize:posteventtime;
grouptimebins=-preeventtime:grouptimebinsize:posteventtime;

lickbinsize=timebinsize;  
licktimebins=-preeventtime:lickbinsize:posteventtime;

if length(licktimes)>0
get_lickproperties
end

if length(strmatch(plotunitclass,'all'))==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(plotunitclass));
    dounits=dounits(unitclassinds);
    plotlabel=['Only using putative ' unitclassnames{dounits(1)} ' units'];
else
    plotlabel=['Using all unit classes (or unclassified)'];
end
disp(plotlabel)

figindi=1;
scrsz=get(0,'ScreenSize');

trigged_spiketimes   

if spikes_or_bursts=='b'
trigged_bursttimes
end


%****Principal Component Analysis****
%set up a normalized firing rate stack, where size(rates)=[M timebins, N
%units].  Note that scaling of rates will influence PC values.
%Use [coeff, score, latent, tsquared, explained] = pca(rates).
%cumsum(explained) will show the total % variation explained by successive PC's.

%cf help doc on "Feature Transformation"

baseline_tf=floor(baselineduration/timebinsize);
t0=floor(preeventtime/timebinsize)+1;

firingrate_stack=[];
for unitind=1:length(dounits);
    unitj=dounits(unitind);  
    
    if spikes_or_bursts=='s'
    baselineratej=mean(event1_spikerate{unitj}(1:baseline_tf));       
    ratej=event1_spikerate{unitj}(t0:length(event1_spikerate{unitj})); %excludes the pre-event spike times because latency is only after event onset.       
    normratej=(ratej-baselineratej)/(max(ratej)-baselineratej);
    firingrate_stack=[firingrate_stack, normratej];
    
    elseif spikes_or_bursts=='b' & length(event1_burstrate{unitj})>0
    baselineratej=mean(event1_burstrate{unitj}(1:baseline_tf));       
    ratej=event1_burstrate{unitj}(t0:length(event1_burstrate{unitj})); %excludes the pre-event spike times because latency is only after event onset.       
    normratej=(ratej-baselineratej)/(max(ratej)-baselineratej);
    firingrate_stack=[firingrate_stack, normratej];  
    end
end
firingrate_stack=firingrate_stack';

%note: firingrate_stack should be an MxN matrix, where M (rows) are the
%number of observation (i.e., number of units) and N (columns) are the
%number of variables (i.e., number of time bins).

[coeff, score, latent, tsquared, explained] = pca(firingrate_stack); 
totalexplained=cumsum(explained);

figindi=figindi+1;
figure(figindi)
set(gcf,'Position',[0.35*scrsz(1)+500 0.35*scrsz(2)+100 0.25*scrsz(3) 0.75*scrsz(4)])
subplot(2,1,1)
plot(score(:,1),score(:,2),'o','MarkerSize', 3,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
xlabel('PC1','FontSize',8)
ylabel('PC2','FontSize',8)
title(['first 2 PCs of event triggered average rate (explain ' num2str(round(totalexplained(2))) '% of variation)'],'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')
axis square

subplot(2,1,2)
plot3(score(:,1),score(:,2),score(:,3),'o','MarkerSize', 3,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
xlabel('PC1','FontSize',8)
ylabel('PC2','FontSize',8)
zlabel('PC3','FontSize',8)
title(['first 3 PCs of event triggered average rate (explain ' num2str(round(totalexplained(3))) '% of variation)'],'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')
axis square
%************************************
