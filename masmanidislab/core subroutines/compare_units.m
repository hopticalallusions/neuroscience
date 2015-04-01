disp(['looking for similarities in firing characteristics of recorded units'])

set_plot_parameters

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
                                
laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

plotunitclass='all';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1).  used in trigged_spiketimes.
min_zscore=3;              %default=3. threshold for determine whether a unit is significantly modulated by event 1, and in one method of calculating unit response latencies.

smoothingwindow='y';       %default='y'. used in event_trigrates.

timebinsize=0.05;           %default=0.02 s. bin size for psth and average lick rate & cue-evoked response. used in cue_lick_ephys and get_unitparameters.                         
preeventtime=0;               %time in sec to use for detecting LFP peaks before event onset.  not used if triggerevent='LFP'
posteventtime=8;              %time in sec to use for detecting LFP peaks after event onset.   not used if triggerevent='LFP'
                             
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

trigged_spiketimes   %event-triggered spike times. Also generates some latency plots if event1 & event2 are CS1, CS2 respectively.


[neworder, sortindices]=sort(unit_depths);
units_depthordered=dounits(sortindices);   %orders the units according to depth (low to high # = shallow-to-deep);
% units_depthordered=fliplr(units_depthordered);  %flips from deep-to-shallow ordering to shallow-to-deep ordering
origunitorder=units_depthordered;    

unitorder=[];
for shaftind=1:length(uniqueshafts);
    currentshaft=uniqueshafts(shaftind);
    unitsonshaft=find(parameters.shafts==currentshaft);
    unitorder=[unitorder intersect(origunitorder,unitsonshaft,'stable')];   %'stable' keeps the original order of unitorder;  
end

pairwise_dist=[]; 
for unitindi=1:length(dounits);
    uniti=dounits(unitindi);    
    xi=unitx{uniti};
    yi=unity{uniti};
    zi=unitz{uniti};
    
    for unitindj=1:length(dounits);
        unitj=dounits(unitindj);        
        xj=unitx{unitj};
        yj=unity{unitj};
        zj=unitz{unitj};
        distij=sqrt((xj-xi)^2+(yj-yi)^2+(zj-zi)^2);            
        pairwise_dist{uniti}{unitj}=distij;  
    end
end


%****center of mass of square of z-score (cf Harvey & Tank 2012)**** 
%this doesn't appear very informative or useful; most t_com is near 4 seconds after CS, although the peak firing is not usually there.
t_com=[];   
tbins=timebins(1:(length(timebins)-1));
for unitind=1:length(dounits);
    uniti=dounits(unitind);    
    zscorei=zscore_event1{uniti};      
    t_com=[t_com dot(zscorei.^2,tbins)/sum(zscorei.^2)];  
end
[numberper_combin,bins]=histc(t_com,timebins);

figindi=figindi+1;
figure(figindi)
plot(timebins,numberper_combin,'k')
xlabel('time of center of mass (s)','FontSize',8)
ylabel('number of cells','FontSize',8)
title('center of mass','FontSize',8)
set(gca,'FontSize',8,'TickDir','out')
%***************************************


%****Similarity indices between two units****
%only applied if use both event1 & event2.
%similarity index is based on the cosine of the rate vector between two
%units (cf. Humphries, J Neurosci (2011): "Spike-train communities: finding groups of similar spike trains, Journal of Neuroscience")
%cosine of zero implies orthogonality, i.e. dissimilarity
%This measures whether two units discriminate between event1 & event2 synchronously.
simindex=[];
for unitindi=1:length(dounits);
    uniti=dounits(unitindi);
    trigrate1i=event1_spikerate{uniti};  %mean peri-event1 rate for uniti
%     trigrate2i=event2_spikerate{uniti};  %mean peri-event2 rate for uniti    
    diffratei=trigrate1i; %-trigrate2i;   %is a measure of cue selectivity.
   
    for unitindj=1:length(dounits);
        unitj=dounits(unitindj);                       
        trigrate1j=event1_spikerate{unitj};  %mean peri-event rate for unitj
%         trigrate2j=event2_spikerate{unitj};  %mean peri-event2 rate for uniti
        diffratej=trigrate1j; %-trigrate2j;
        simindex{uniti}{unitj}=sum(diffratei.*diffratej)/(norm(diffratei)*norm(diffratej)); 
        
    end
end

similarity_matrix=[];
for i=1:length(unitorder);
    uniti=unitorder(i);
    for j=1:length(unitorder);
        unitj=unitorder(j);
        similarity_matrix(i,j)=simindex{uniti}{unitj};
    end
end
 
figindi=figindi+1;
figure(figindi)
imagesc(similarity_matrix, [0 1])
axis square
colorbar
colormap('jet')
title('similarity index','FontSize',8)
xlabel('units ordered by depth & shaft', 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')
%***************************************


%****Normalized Euclidean distance****
rate_euclidean=[];
for unitindi=1:length(dounits);
    uniti=dounits(unitindi);
    trigrate1i=event1_spikerate{uniti};  %mean peri-event1 rate for uniti
     
    for unitindj=1:length(dounits);
        unitj=dounits(unitindj);                       
        trigrate1j=event1_spikerate{unitj};  %mean peri-event rate for unitj
        
        euclideanij=norm(trigrate1i-trigrate1j)/norm(trigrate1i)/norm(trigrate1j);
        rate_euclidean{uniti}{unitj}=euclideanij;
    end
end

inverse_euclidean_matrix=[];  %take inverse so that value of zero means high separation.
for i=1:length(unitorder);
    uniti=unitorder(i);
    for j=1:length(unitorder);
        unitj=unitorder(j);
        if uniti==unitj
        inverse_euclidean_matrix(i,j)=0;  %set to zero so it doesn't saturate image
        else
        inverse_euclidean_matrix(i,j)=1/rate_euclidean{uniti}{unitj};  
        end
    end
end
 
figindi=figindi+1;
figure(figindi)
imagesc(inverse_euclidean_matrix)
axis square
colorbar
colormap('jet')
title('Inverse Normalized Euclidean distance','FontSize',8)
xlabel('units ordered by depth & shaft', 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')
%****************************************
