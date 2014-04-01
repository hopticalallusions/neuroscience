%Can be adapted to specific time windows or spikes (e.g. could potentially analyze only correlations during bursts).
%Calculates cross-correlation for the observed firing and jittered samples.

set_plot_parameters

ntwrksync1='sync_s';  %for the first group of network events in pair. 'sync_s' will use network synchronous spikes, 'sync_p' will use sync bursts, 'sync_b' will use sync bursts
spk_burst_ntwrksync2='s';       %for second set of times in pair. 's' will use spikes, 'b' will use burst episodes, 'sync_s' will use network synchronous spikes, 'sync_p' will use sync bursts, 'sync_b' will use sync bursts

unitclass1='2';        %first type of unit used in pairwise comparison. can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj
unitclass2='1';        %second type of unit used in pairwise comparison. can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

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

preeventtime=0;               %time in sec to use before event onset.  
posteventtime=8;              %time in sec to use after event onset.   
maxcorrtime=10000;          %if triggerevent='none', this is the maximum time that can be retained. if maxcorrtime>recordingduration, will use recordingduration.

max_jittertime=0.005;       %default=0.005 s. should be >=timebinsize used in get_network_sync
jitter_iterations=200;      %default=1000. number of iterations to run for calculating x-corr with jittered spike times. note with 100 iterations the lowest p-value claim is ~0.05; with 1000 the lowest p-value claim is ~0.01.

maxlag=25;                 %default=25 samples. maximum number of +/- lag samples to use in xcorr function.
%************************************************
triggerevent2='none';  %options: 'none'.  (currently not in use in correlations)
triggerevent3='none';  %options: 'none'.  (currently not in use in correlations.)    
trialselection2='all';  %select which event2 trials to display. same options as trialselection1. (currently not in use in correlations.)  
trialgroupsize=10;  %(currently not in use in correlations.)    

currentxcorrdir=[networkxcorrdir date '\'];
networkxcorrdatadir=[currentxcorrdir 'unit data\'];
mkdir(networkxcorrdatadir)
delete([networkxcorrdatadir '*.*'])

ntwrk_crosscorr_params=[];

format short;

load_results

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

load([savedir 'sync.mat'])
timebinsize=sync.synctimebinsize;
disp(['time bin size used in get_network_sync was ' num2str(timebinsize) '.'])


if strcmp(unitclass1, 'all')
    class1number=5;     %class number of 5 means use all units (defined in get_network_sync)
    plotlabel1=['Using all unit classes (or unclassified) for the first cell in the pair.'];
else class1number=str2num(unitclass1);
    unitclassinds=find(unitclassnumbers==str2num(unitclass1));
    dounits1=dounits(unitclassinds);
    plotlabel1=['Only using putative ' unitclassnames{dounits1(1)} ' units for the first cell in the pair'];
end
disp(plotlabel1)

if strcmp(unitclass2, 'all')
    class2number=5;     %class number of 5 means use all units (defined in get_network_sync)
    plotlabel2=['Using all unit classes (or unclassified) for the second cell in the pair.'];
else class2number=str2num(unitclass2);
    unitclassinds=find(unitclassnumbers==str2num(unitclass2));
    dounits2=dounits(unitclassinds);
    plotlabel2=['Only using putative ' unitclassnames{dounits2(1)} ' units for the second cell in the pair'];
end
disp(plotlabel2)


if strcmp(ntwrksync1,'sync_b') 
slow_or_rapid=sync.slow_or_rapid;
minburstisi=sync.minburstisi;
minspikesperburst=sync.minspikesperburst;    
ntwrk_crosscorr_params.slow_or_rapid1=slow_or_rapid;   %additional parameters for bursting.
ntwrk_crosscorr_params.minburstisi1=minburstisi;
ntwrk_crosscorr_params.minspikesperburst1=minspikesperburst;
burstlabel1=['synced burst 1 criteria: minimum ISI = ' num2str(minburstisi) ' s; minimum spikes/burst = ' num2str(minspikesperburst)];
disp(burstlabel1)
end

save([currentxcorrdir 'ntwrk_crosscorr_params.mat'], 'ntwrk_crosscorr_params', '-MAT')

if strcmp(spk_burst_ntwrksync2,'b') | strcmp(spk_burst_ntwrksync2,'sync_b') 
get_bursts    
slow_or_rapid_bursts

ntwrk_crosscorr_params.slow_or_rapid2=slow_or_rapid;   %additional parameters for bursting.
ntwrk_crosscorr_params.minburstisi2=minburstisi;
ntwrk_crosscorr_params.minspikesperburst2=minspikesperburst;
burstlabel2=['burst cell 2 criteria: minimum ISI = ' num2str(minburstisi) ' s; minimum spikes/burst = ' num2str(minspikesperburst)];
disp(burstlabel2)
end


ntwrk_crosscorr_times_cell1

if length(strfind(spk_burst_ntwrksync2,'sync'))>0 
dounits2=2;
ntwrk_crosscorr_times_cell2
else spikes_or_bursts2=spk_burst_ntwrksync2;
    crosscorr_times_cell2
end
   

%save parameters.
ntwrk_crosscorr_params.subject=subject;
ntwrk_crosscorr_params.ntwrksync1=ntwrksync1;
ntwrk_crosscorr_params.spk_burst_ntwrksync2=spk_burst_ntwrksync2;
ntwrk_crosscorr_params.unitclass1=unitclass1;
ntwrk_crosscorr_params.unitclass2=unitclass2;
ntwrk_crosscorr_params.dounits1=dounits1;
ntwrk_crosscorr_params.dounits2=dounits2;

ntwrk_crosscorr_params.triggerevent1=triggerevent1;
ntwrk_crosscorr_params.trialselection1=trialselection1;
ntwrk_crosscorr_params.LFPthreshold=LFPthreshold;
ntwrk_crosscorr_params.laserfreqselect=laserfreqselect;
ntwrk_crosscorr_params.preeventtime=preeventtime;
ntwrk_crosscorr_params.posteventtime=posteventtime;
ntwrk_crosscorr_params.maxcorrtime=maxcorrtime;
ntwrk_crosscorr_params.max_jittertime=max_jittertime;
ntwrk_crosscorr_params.jitter_iterations=jitter_iterations;
ntwrk_crosscorr_params.timebinsize=timebinsize;
ntwrk_crosscorr_params.maxlag=maxlag;

save([currentxcorrdir '\ntwrk_crosscorr_params.mat'], 'ntwrk_crosscorr_params', '-MAT')


%calculating cross-correlation for the observed firing distribution as well as the jittered samples.
%note: in future try to do parallel computing at this step.
disp(['Calculating cross-correlation for the observed firing and jittered samples (' num2str(jitter_iterations) ' iterations with jitter of +/- ' num2str(1000*max_jittertime) ' ms).'])
tic
spikecountsi=histc(stimes1,longtimebins);  %binned spike counts.
xcorr_observed=[]; xcorr_jittered=[];
for unitindj=1:length(dounits2);
    unitj=dounits2(unitindj);                    
    
    spikecountsj=histc(stimes2{unitj},longtimebins);  %binned spike counts.
    xcorr_observed{unitj}=xcorr(spikecountsi, spikecountsj, maxlag);
        
    xcorr_jittered{unitj}=[]; timecounter=0; tstart=tic;
    for jittertrial=1:jitter_iterations 
        jittertimesi=stimes1+(2*max_jittertime*rand(1,length(stimes1))-max_jittertime);            
        jittertimesj=stimes2{unitj}+(2*max_jittertime*rand(1,length(stimes2{unitj}))-max_jittertime);            
        jittered_spikecountsi=histc(jittertimesi,longtimebins);  %binned spike counts.
        jittered_spikecountsj=histc(jittertimesj,longtimebins);  %binned spike counts.           
        xcorr_jittered{unitj}=[xcorr_jittered{unitj}; xcorr(jittered_spikecountsi, jittered_spikecountsj, maxlag)];
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
    
ntwrk_crosscorr=[];
ntwrk_crosscorr.xcorr_observed=xcorr_observed;
ntwrk_crosscorr.xcorr_jittered=xcorr_jittered;
save([networkxcorrdatadir 'ntwrk_crosscorr.mat'], 'ntwrk_crosscorr', '-MAT')  %saves new file for each uniti to avoid file overloading and minimize disruption from unexpected computer crash.
    
disp(['Done.'])
