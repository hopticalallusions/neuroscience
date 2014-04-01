disp(['get_final_units'])   %last major update on July 24 2013.

if  matlabpool('size')>0
    matlabpool close 
end

set_plot_parameters
maxtrial=parameters.maxtrial;
trialduration=parameters.trialduration;
load([timesdir 'penultimate_params.mat']);  %loads parameters file.
numberoftrials=maxtrial-1;
maxtime=(numberoftrials*trialduration)/samplingrate;   %added 1/3/13 for new merge correction factor
minamplitude=parameters.minamplitude;
lengthperchan=parameters.lengthperchan{1};   %this variable should be same for all units.
load([timesdir 'penult_spiketimes.mat'])   %loads spiketimes created in collect_spiketimes;
load([timesdir 'penult_baretimes.mat'])   %loads spiketimes created in collect_spiketimes;
load([timesdir 'penult_jittertimes.mat'])   %loads spiketimes created in collect_spiketimes; 
load([penultwavedir 'bestchannel.mat']);  %loads parameters file.
parameters.bestchannel=bestchannel;

close all
scrsz=get(0,'ScreenSize');
timestarting=datenum(clock)*60*24;   %starting time in minutes.

dounits=1:length(spiketimes);
origdounits=dounits;

maxjitter=min([(leftpoints-origleftpoints) (rightpoints-origrightpoints)]);
if maxjitter>=upsamplingfactor;
jittersamples=-upsamplingfactor:2:upsamplingfactor;
jittersamples=setdiff(jittersamples,0);
jittersamples=[0 jittersamples];
a=find(abs(jittersamples)>rejecttime);
jittersamples(a)=[];
else jittersamples=0;
end

disp(['final merging step: checking ' num2str(length(dounits)) ' candidate units.'])
disp(['1. Checking coefficient of variation (1/CV must be >' num2str(finalCVtestfactor) ' to keep unit).'])
badunits=[]; 
for unitind=1:length(dounits);
    unit=dounits(unitind);   
    bestchan=bestchannel{unit};
    
    if length(bestchan)==0    %fixes very rare bug
        badunits=[badunits unit];
        continue
    end
        
    currentshaft=s.shaft(bestchan);    %added Mar 10 2012.
    parameters.shaft{unit}=currentshaft;
    timesuniti=spiketimes{unit};
    if length(timesuniti)<2
        continue
    end
    
    load([penultwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    if length(waveforms{bestchan})==0
        badunits=[badunits unit];
        continue
    end
    
    t0=leftpoints-origleftpoints+6;  %reduced t0:tf by 12 samples on July 29 2013.
    tf=t0+origleftpoints+origrightpoints-6;     
        
    wavesallchans=[];
    for chan=1:length(waveforms);   %for each channel.  
        disttobestchan=abs(s.z(bestchan)-s.z(chan));             
        if length(waveforms{chan})==0 | s.shaft(chan)~=currentshaft | disttobestchan>maxmergedistance     %modified July 23 2013, so only collect waveforms from channels near the best channel (on the same shaft).
        continue
        end         
        waveschanj=waveforms{chan}(:,t0:tf);           
        wavesallchans=[wavesallchans, waveschanj];
    end
                     
    CV=abs(std(wavesallchans)./min(mean(wavesallchans)));   %more rigorous CV test. introduced July 24 2013. Absolute value of coefficient of variation (aka relative standard deviation).  CV is small for high quality units.
    inverseCV=1./CV;                      %requires the worst inverse CV value around the trough to be > finalCVtestfactor.
 
%     plot(wavesallchans')
%     title(['5th 1/CV percentile=' num2str(prctile(inverseCV,5))])
%     figure(1)
%     input('press enter to continue')

    if  prctile(inverseCV,5)<finalCVtestfactor
    badunits=[badunits unit];   
    continue
    end     
 
end

badunits=unique(badunits);
dounits=setdiff(dounits,badunits);
disp(['discarded ' num2str(length(badunits)) ' units which failed the 1/CV test, ' num2str(length(dounits)) ' units remaining.'])

disp(['2. Checking for pairs of remaining candidate units to merge.'])
samemeans=[];
for i=1:length(dounits);
    uniti=dounits(i);  
    bestchani=bestchannel{uniti};
    currentshaft=s.shaft(bestchani);    %added Mar 10 2012.
    
    for j=2:length(dounits);
        unitj=dounits(j);
        bestchanj=bestchannel{unitj};

        distij=abs(s.z(bestchani)-s.z(bestchanj));   %distance between best channels of unit i and j.
        
        if i>=j | s.shaft(bestchanj)~=currentshaft | distij>maxmergedistance   
        continue
        end
        
        unitmerge_CVtest   %if the mean waveforms are similar, then do another CV test, and if that test passes, accept the merger.
        if mergeunitsij=='y'
        samemeans=[samemeans; uniti unitj];   %the left and right columns specify indices to be merged. 
        continue   %continue is for the jittersamples loop   
        end
    end   
end
  

newtimes=[]; newbaretimes=[]; newjittertimes=[]; newshaft=[];
unitcounter=1;  mergeunits=[]; usedunits=[];
if length(samemeans)>0  %i.e., if any mergers have been found...
    disp(['3. Combining times of merged units & discarding duplicate spikes.'])
    a=unique(samemeans);
    for i=1:length(a);
        uniti=a(i);
        if length(intersect(usedunits,uniti))>0
            continue
        end       
        tempmerge=uniti;
        for j=1:1000;
            b=ismember(samemeans, tempmerge);
            [c,d]=find(b==1);         
            tempmerge=unique([samemeans(c,1) samemeans(c,2)]);
        end                     
       mergeunits{i}=tempmerge;         
       usedunits=[usedunits mergeunits{i}'];
    end
     
    newmergeunits=[]; mergecounter=1;
    for j=1:length(mergeunits)
        if length(mergeunits{j})>0
            newmergeunits{mergecounter}=mergeunits{j};
            mergecounter=mergecounter+1;
        end
    end
    mergeunits=newmergeunits;
   
    for ind=1:length(mergeunits);            
        allinds=unique(mergeunits{ind});  %all indices to merge.
        firstind=allinds(1); 
        mergetimes=[]; mergebaretimes=[]; mergejittertimes=[];        
        for i=1:length(allinds);
            indi=allinds(i);                 
            mergetimes=[mergetimes spiketimes{indi}];   
            mergebaretimes=[mergebaretimes baretimes{indi}];
            mergejittertimes=[mergejittertimes jittertimes{indi}];
        end            
        [mergetimes, sortindex]=sort(mergetimes);   
        mergebaretimes=mergebaretimes(sortindex);
        mergejittertimes=mergejittertimes(sortindex);
        
        difftimes=diff(mergetimes);
        overlaps=find(difftimes<(rejecttime+minoverlap)/samplingrate);          %default=rejecttime (modified Jan 13 2012 to reduce double-counting of spikes that have been merged from multiple sets.). 
        mergetimes(overlaps)=[];  %removes duplicate events found on multiple channels.
        mergebaretimes(overlaps)=[];
        mergejittertimes(overlaps)=[];

        newtimes{unitcounter}=mergetimes;
        newbaretimes{unitcounter}=mergebaretimes;
        newjittertimes{unitcounter}=mergejittertimes; 
        newshaft{unitcounter}=parameters.shaft{firstind};
        
        unitcounter=unitcounter+1; 
    end    
end


disp(['4. Adding times of any unmerged units & discarding units with < ' num2str(final_minspikesperunit) ' spikes.'])
allinds=setdiff(dounits,usedunits);  %now check the unmerged units for any bad apples (contain <final_minspikesperunit)
for ind=1:length(allinds);    
    unit=allinds(ind);        
    stimesi=spiketimes{unit};
    baretimesi=baretimes{unit};
    jittertimesi=jittertimes{unit};     
    [stimesi, sortindex]=sort(stimesi);   
    baretimesi=baretimesi(sortindex);
    jittertimesi=jittertimesi(sortindex);        
    difftimes=diff(stimesi);
    overlaps=find(difftimes<(rejecttime+minoverlap)/samplingrate);           %default=rejecttime (modified Jan 13 2012 to reduce double-counting of spikes that have been merged from multiple sets.). 
    stimesi(overlaps)=[];  %removes duplicate events found on multiple channels.
    baretimesi(overlaps)=[];
    jittertimesi(overlaps)=[]; 
    
    if length(stimesi)<final_minspikesperunit
        badunits=sort([badunits unit]);
        continue
    end  
    
    newtimes{unitcounter}=stimesi;
    newbaretimes{unitcounter}=baretimesi;
    newjittertimes{unitcounter}=jittertimesi;
    newshaft{unitcounter}=parameters.shaft{unit};     
    unitcounter=unitcounter+1; 
end

spiketimes=newtimes;
baretimes=newbaretimes;
jittertimes=newjittertimes;

disp(['discarded another ' num2str(length(intersect(allinds,badunits))) ' units because they contain < ' num2str(final_minspikesperunit) ' spikes.'])

disp(['Final results: pruned final number of units from ' num2str(length(origdounits)) ' to ' num2str(length(spiketimes)) '.'])

save([timesdir 'finalspiketimes.mat'],'spiketimes', '-mat')
save([timesdir 'finalbaretimes.mat'],'baretimes','-mat')
save([timesdir 'finaljittertimes.mat'],'jittertimes','-mat')

save_finalparameters

disp('5. Collecting waveforms of final units.')
final_times_to_waves

disp(['6. Finding final spike amps & best channel per unit.'])
bestchannel=[]; spikeamps=[];
for unitind=1:length(dounits);
    unit=dounits(unitind); 
    
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    
    maxamp=0; bestchaninunit=[];
    shaftinuse=parameters.shaft{unit};   %finds the shaft containing these channels; should only be single shaft.
    channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.    
    for j=1:length(channelsonshaft);
        chj=channelsonshaft(j);
        spikeamps{unit}{chj}=range(waveforms{chj}');
        troughamp=abs(min(mean(waveforms{chj})));    %use trough voltage for best channel identification.
        if troughamp>maxamp
            maxamp=troughamp;
            bestchaninunit=chj;
        end
    end
    bestchannel{unit}=bestchaninunit;
end
save([finalwavedir 'spikeamps.mat'],'spikeamps','-mat')
save([finalwavedir 'bestchannel.mat'],'bestchannel','-mat')
clear spikeamps
timeending=datenum(clock)*60*24; %final time in minutes
telapsed=timeending-timestarting;
disp([num2str(telapsed) ' minutes elapsed during get_final_units.'])
