%loads frequently used post-sorting parameters.

if exist([savedir 'final_params.mat']);  %loads parameters file.
    
    load([savedir 'final_params.mat']);  %loads parameters file.
    probetype=parameters.probetype;
    get_probegeometry
    shafts=s.shaft;
    badchannels=parameters.badchannels;
    
end


if exist([stimulidir 'stimuli.mat'])
    load([stimulidir 'stimuli.mat'])
    
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
    else
        lickepisodetimes=[]; 
        endlickepisodetimes=[];
    end
    
    if length(licktimes)>0
        unexpectedUStrials=[];  %solenoid trials corresponding to unexpected rewards (i.e. not preceded by CS).
        for triali=1:length(sol1times);
            soltimei=sol1times(triali);
            diffcuesoltimes=[abs(cue1times-soltimei) abs(cue2times-soltimei)];
            istherecue=find(diffcuesoltimes<6);
            if length(istherecue)==0
                unexpectedUStrials=[unexpectedUStrials triali];
            end
        end
    end
    
    get_runproperties
    
end

clear spiketimes
if exist([timesdir 'finalspiketimes.mat'])
    load([timesdir 'finalspiketimes.mat'])
    load([unitclassdir 'positions' '.mat'])
    
    if exist([unitclassdir 'unitproperties.mat'],'file')>0
        load([unitclassdir 'unitproperties.mat'])
    end
    
    select_dounits
    orig_dounits=dounits;
    
    if exist([unitclassdir 'unitproperties.mat'],'file')>0 & length(unitproperties.unitclassnumbers)>0
        unitclassnumbers=unitproperties.unitclassnumbers;
        unitclassnames=unitproperties.unitclassnames;
        uniqueunitclasses=setdiff(unique(unitclassnumbers),0);
    else unitclassnames='unclassified';
        unitclassnumbers=0;
        uniqueunitclasses=0;
    end
    
    recordingduration=parameters.maxtrial*parameters.trialduration/samplingrate;
    
    elecx=positions.elecx;
    elecy=positions.elecy;
    elecz=positions.elecz;
    unitx=positions.unitx;
    unity=positions.unity;
    unitz=positions.unitz;
    shaftz=positions.z;
    allshafts=parameters.shafts;
    shafts=allshafts(dounits);
    bestchannels=parameters.bestchannels;
    
    dochannels=s.channels;
    dochannels=setdiff(dochannels, badchannels);
    
    uniqueshafts=unique(shafts);
    numberofshafts=length(unique(shafts));
    
    uniquedepths=unique(s.z);
    probedepths=-(uniquedepths-max(uniquedepths)-tipelectrode)/1000;
    
end


