triggerevent1='CS1';  %options: 'CS1..4', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', 'start', 'stop', 'room1..4 entries'
triggerevent2='CS2';   %options: 'CS1..4', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration', start', 'stop', 'room1..4 entries', 'none'.    

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
                            %'spontaneous licking'. excludes cues & solenoids.
                            
                            %***Compatible with +/- 'acceleration', 'start', or 'stop' triggerevents:***
                            %'CS1 running'. event times occuring between CS and CS-US delay time. 
                            %'CS2 running'
                            %'spontaneous running'. excludes cues and licking episodes.
 
trialselection2='correct withholding';     %select which event2 trials to display. same options as trialselection1.
                            
%**************************************************
domultisubject='y';
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.                                  
subselect1='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1 (default).  '[a b c]' will use the designated trials.          
subselect2='all';           %optional subselection of trials.  'all' will use all trials from trialselection 2 (default).  '[a b c]' will use the designated trials.          
trialgroupsize=10;         %used in select_triggers_trials

selectedpaths=uipickfiles('FilterSpec','C:\data analysis\');  %prompts to pick subjects.

get_subject_dir

analysisdrivename=subjects{1}(1);
combinedir = [analysisdrivename ':\data analysis\figures\'];
if isdir(combinedir) == 0
   mkdir(combinedir)
end


correct_e1=[]; correct_e2=[]; subjectstr=[];
for subjectind = 1:length(subjects)
    rawpath = [subjects{subjectind} '\'];
  
    stimulidir=[rawpath 'stimuli\'];
    
    load([stimulidir 'stimuli.mat'])   

    get_file_subject_name   
    
    subjectstr{subjectind}=subject(7:end);
    
    cue1times=stimuli.cue1times;  
    cue2times=stimuli.cue2times;  
    cue3times=stimuli.cue3times;
    cue4times=stimuli.cue4times;
    licktimes=stimuli.licktimes;
    sol1times=stimuli.sol1times;
    pulsetrainstart=stimuli.lasertimes.pulsetrainstart;
    pulseduration=stimuli.lasertimes.pulseduration;
    pulsetimes=stimuli.lasertimes.pulsetimes; 
    cue1_lickyesno=stimuli.cue1_lickyesno;
    cue2_lickyesno=stimuli.cue2_lickyesno;
    solenoid_aftercue1=stimuli.solenoid_aftercue1;
    solenoid_aftercue2=stimuli.solenoid_aftercue2;
    meancuesoldelay=stimuli.meancuesoldelay;
    stimsamplingrate=stimuli.stimsamplingrate;
    velocitysamplingrate=stimuli.velocitysamplingrate;
    vy=stimuli.vy;

    if length(licktimes)>0
    lickepisodetimes=stimuli.lickepisodetimes;
    endlickepisodetimes=stimuli.endlickepisodetimes;
    else lickepisodetimes=[]; endlickepisodetimes=[];
    end
    
    sol1times=stimuli.sol1times-meancuesoldelay;  %July 19 2013. add time offset so 'solenoid' triggered events are aligned with the CS-triggered events.
       
    select_triggers_trials       %determines which event triggers and trials to use in plotting.  
    
    correct_e1=[correct_e1 length(doevent1trials)/length(event1times)];
    correct_e2=[correct_e2 length(doevent2trials)/length(event2times)];
end

performancebins=0:0.1:1;

binned_e1=histc(correct_e1,performancebins)/length(correct_e1);
binned_e2=histc(correct_e2,performancebins)/length(correct_e2);

ratio_e1e2=correct_e1./correct_e2;
ratiobins=0:0.2:ceil(ratio_e1e2);
binned_ratio=histc(ratio_e1e2,ratiobins)/length(ratio_e1e2);

figure(1)
close 1
figure(1)
subplot(1,3,1)
plot(performancebins, binned_e1,'b')
hold on
plot(performancebins, binned_e2,'r')
hold off
axis square
xlabel(['performance'], 'FontSize',8)
ylabel(['fraction of animals'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

subplot(1,3,2)
plot(correct_e1,correct_e2,'ok','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',2)
text(correct_e1-0.03,correct_e2-0.04,subjectstr,'FontSize',8)
axis square
xlabel([trialselection1 ', ' triggerevent1], 'FontSize',8)
ylabel([trialselection2 ', ' triggerevent2], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

subplot(1,3,3)
plot(ratiobins,binned_ratio,'k')
axis square
xlabel([trialselection1 ', ' triggerevent1 '/' trialselection2 ', ' triggerevent2], 'FontSize',8)
ylabel(['fraction of animals'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

