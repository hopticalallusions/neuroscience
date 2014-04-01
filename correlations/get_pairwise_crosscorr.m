%Can be adapted to specific time windows or spikes (e.g. could potentially analyze only correlations during bursts).
%Calculates cross-correlation for the observed firing and jittered samples.
disp(['**Warning: this program is very slow because of the multiple iterations of the jitter test. It is recommended to run job on multiple processors.**'])

set_plot_parameters

spikes_or_bursts1='s';       %for first set of times in pair. 's' will use spikes, 'b' will use burst episodes,
spikes_or_bursts2='s';       %for second set of times in pair. 's' will use spikes, 'b' will use burst episodes

unitclass1='all';        %first type of unit used in pairwise comparison. can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj
unitclass2='all';        %second type of unit used in pairwise comparison. can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

triggerevent1='allspikes';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'positive acceleration', 'negative acceleration','allspikes', 'LFP'
%'allspikes' will use spikes from t=0 to t=maxcorrtime.

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

LFPthreshold=5;             %default=5. threshold number of SDs for identifying high-amplitude oscillations. used if triggerevent1='LFP'

laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

preeventtime=-1.5;               %time in sec to use before event onset.
posteventtime=2;              %time in sec to use after event onset.
maxcorrtime=10000;          %if triggerevent='none', this is the maximum time that can be retained. if maxcorrtime>recordingduration, will use recordingduration.

max_jittertime=0.005;       %default=0.005 s.
jitter_iterations=500;      %default=1000. number of iterations to run for calculating x-corr with jittered spike times. note with 100 iterations the lowest p-value claim is ~0.05; with 1000 the lowest p-value claim is ~0.01.

timebinsize=0.001;          %default=0.001 s. bin size to use for calculating firing rates entered in cross-correlation.
maxlag=25;                 %default=25 samples. maximum number of +/- lag samples to use in xcorr function.
%************************************************
triggerevent2='none';  %options: 'none'.  (currently not in use in correlations)
triggerevent3='none';  %options: 'none'.  (currently not in use in correlations.)
trialselection2='all';  %select which event2 trials to display. same options as trialselection1. (currently not in use in correlations.)
trialgroupsize=10;  %(currently not in use in correlations.)

format short;

load_results

select_triggers_trials       %determines which event triggers and trials to use in plotting.

if strcmp(unitclass1,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass1));
    dounits1=dounits(unitclassinds);
    plotlabel1=['Only using putative ' unitclassnames{dounits1(1)} ' units for the first cell in the pair'];
else
    dounits1=dounits;
    plotlabel1=['Using all unit classes (or unclassified) for the first cell in the pair.'];
end
disp(plotlabel1)

if strcmp(unitclass2,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass2));
    dounits2=dounits(unitclassinds);
    plotlabel2=['Only using putative ' unitclassnames{dounits2(1)} ' units for the second cell in the pair'];
else
    dounits2=dounits;
    plotlabel2=['Using all unit classes (or unclassified) for the second cell in the pair.'];
end
disp(plotlabel2)

if strcmp(triggerevent1, 'allspikes')
    currentxcorrdir=[xcorrdir triggerevent1 '\'];
else
    currentxcorrdir=[xcorrdir triggerevent1 ' ' num2str(-1*preeventtime) '-' num2str(posteventtime) 's' '\'];
end

xcorrdatadir=[currentxcorrdir 'unit data\'];
mkdir(xcorrdatadir)
% delete([xcorrdatadir '*.*'])

%save parameters.
crosscorr_params=[];
crosscorr_params.subject=subject;
crosscorr_params.spikes_or_bursts1=spikes_or_bursts1;
crosscorr_params.spikes_or_bursts2=spikes_or_bursts2;
crosscorr_params.unitclass1=unitclass1;
crosscorr_params.unitclass2=unitclass2;
crosscorr_params.dounits1=dounits1;
crosscorr_params.dounits2=dounits2;

crosscorr_params.triggerevent1=triggerevent1;
crosscorr_params.trialselection1=trialselection1;
crosscorr_params.LFPthreshold=LFPthreshold;
crosscorr_params.laserfreqselect=laserfreqselect;
crosscorr_params.preeventtime=preeventtime;
crosscorr_params.posteventtime=posteventtime;
crosscorr_params.maxcorrtime=maxcorrtime;
crosscorr_params.max_jittertime=max_jittertime;
crosscorr_params.jitter_iterations=jitter_iterations;
crosscorr_params.timebinsize=timebinsize;
crosscorr_params.maxlag=maxlag;

save([currentxcorrdir 'crosscorr_params.mat'], 'crosscorr_params', '-MAT')


numberof_computers=[];
numberof_computers=input('specify number of Matlab instances (N) that will be carrying out this job (can either be on same or different computers) [1]: ');
if isempty(numberof_computers)==1
    numberof_computers=1;
end

if numberof_computers==1
    computer_order=1;
elseif numberof_computers>1
    computer_order=input('specify the order of this Matlab instance (1...N): ');
    disp(['Make sure the parameters in all instances match.'])
end

newunitinds=[computer_order:numberof_computers:length(dounits1)];
dounits1_thiscomputer=dounits1(newunitinds);
disp(['doing ' num2str(length(dounits1_thiscomputer)) ' of ' num2str(length(dounits1)) ' units on this Matlab instance.'])
disp(['Note: it is OK to run multiple Matlab instances on the same computer and still have gains in performance, but the time per process will increase with ~sqrt(N).'])


if strcmp(spikes_or_bursts1,'b') | strcmp(spikes_or_bursts2,'b')
    slow_or_rapid_bursts
    
    crosscorr_params.slow_or_rapid=slow_or_rapid;   %additional parameters for bursting.
    corsscorr_params.minburstisi=minburstisi;
    crosscorr_params.minspikesperburst=minspikesperburst;
    burstlabel=['burst criteria: minimum ISI = ' num2str(minburstisi) ' s; minimum spikes/burst = ' num2str(minspikesperburst)];
    disp(burstlabel)
    save([currentxcorrdir 'crosscorr_params.mat'], 'crosscorr_params', '-MAT')
end

crosscorr_times_cell1
crosscorr_times_cell2

%calculating cross-correlation for the observed firing distribution as well as the jittered samples.
%note: in future try to do parallel computing at this step.
disp(['Calculating cross-correlation for the observed firing and jittered samples (' num2str(jitter_iterations) ' iterations with jitter of +/- ' num2str(1000*max_jittertime) ' ms).'])
for unitindi=1:length(dounits1_thiscomputer);
    uniti=dounits1_thiscomputer(unitindi);
    if exist([xcorrdatadir 'crosscorr_' num2str(uniti) '.mat'], 'file')
        disp(['unit ' num2str(uniti) ' already done; skipping this unit.'])
        continue
    end
    xcorr_observed=[]; 
    xcorr_jittered=[];
    disp(['cross-correlating unit ' num2str(uniti) ' with all other unique units...this can take several hrs per unit.'])
    tic
    for unitindj=1:length(dounits2);
        unitj=dounits2(unitindj);
        if strcmp(spikes_or_bursts1, spikes_or_bursts2) & unitclass1==unitclass2 & uniti>=unitj
            continue
        elseif uniti==unitj | length(stimes1{uniti})==0 | length(stimes2{unitj})==0
            continue
        end
        spikecountsi=histc(stimes1{uniti},longtimebins);  %binned spike counts.
        spikecountsj=histc(stimes2{unitj},longtimebins);  %binned spike counts.
        xcorr_observed{unitj}=xcorr(spikecountsi, spikecountsj, maxlag);
        
        xcorr_jittered{unitj}=zeros(jitter_iterations,(2*maxlag+1)); timecounter=0; tstart=tic;
        for jittertrial=1:jitter_iterations
            jittertimesi=stimes1{uniti}+(2*max_jittertime*rand(1,length(stimes1{uniti}))-max_jittertime);
            jittertimesj=stimes2{unitj}+(2*max_jittertime*rand(1,length(stimes2{unitj}))-max_jittertime);
            jittered_spikecountsi=histc(jittertimesi,longtimebins);  %binned spike counts.
            jittered_spikecountsj=histc(jittertimesj,longtimebins);  %binned spike counts.
            xcorr_jittered{unitj}(jittertrial,:)=xcorr(jittered_spikecountsi, jittered_spikecountsj, maxlag);
            timecounter=timecounter+1;
            if timecounter==jitter_iterations
                telapsed=toc(tstart);
                disp([num2str(jitter_iterations) ' time-jittered iterations of xcorr with unit ' num2str(unitj) ' completed in ' num2str(telapsed/60) ' min.'])
                timecounter=0;
                tstart=tic;
            end
        end
    end
    toc
    
    crosscorr=[];
    crosscorr.unit=uniti;
    crosscorr.xcorr_observed=xcorr_observed;
    crosscorr.xcorr_jittered=xcorr_jittered;
    save([xcorrdatadir 'crosscorr_' num2str(uniti) '.mat'], 'crosscorr', '-MAT')  %saves new file for each uniti to avoid file overloading and minimize disruption from unexpected computer crash.
    
end

disp(['Done. If this job was run on multiple computers, need to manually copy contents of the cross-correlation data folder.'])
