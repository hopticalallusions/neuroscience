%Created May 10 2011, edited Nov 18 2011.  This program is for template-based sorting of 
%dot muxi data.  Templates are updated every trial.
disp(['make_seed_templates'])

do_parallel='y';
disp(['Using parallel computing to try to speed up sorting.'])
if do_parallel=='y'
    if matlabpool('size')==0
    matlabpool open
    end
else
    if matlabpool('size')>0
    matlabpool close
    end
end

if exist([stimulidir 'laserartifacts.mat'],'file')>0 & laser_artifact_removal=='y'
disp(['doing laser artifact removal'])    
load([stimulidir 'laserartifacts.mat'])
end

load([savedir 'dosets.mat'])
disp(['Doing channel sets ' num2str(dosets)])

% make_parameters;                    %either saves or loads all parameters in spikesort_muxi to parameters.txt file.
                                    %can directly edit the text file to avoid losing track of parameters across 
                                    %multiple expts.

seedtempdir=[savedir 'seed templates\'];
mkdir(seedtempdir); %mkdir(wavesavedir);

if isdir(seedtempdir)==1;
clearoldresults=[];
if length(dir([seedtempdir '*.mat']))>0
    clearoldresults=input('do you want to clear old spikeset files (y/n)? [y] ', 's');
    if isempty(clearoldresults)==1
        clearoldresults='y';
    end
    if clearoldresults=='y'
     delete([seedtempdir '*.mat']);
    end   
end

end

if length(backgroundchans1)>0
    disp('using background subtraction')
end

for channelsetindices=1:length(dosets);
    channelsetindex=dosets(channelsetindices);

tic
    
dochannels=channelsets{channelsetindex};
dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.  
dochannels=(sort(dochannels));
disp(['set ' num2str(channelsetindex) ', channels ' num2str(dochannels) '.']) 

backgroundchans=origbackgroundchans;
shaftinuse=unique(s.shaft(dochannels));   %finds the shaft containing these channels; should only be single shaft.
channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.
backgroundchans=intersect(backgroundchans,channelsonshaft);  
backgroundchans=setdiff(backgroundchans,dochannels);  %background channels will only include other channels on the same shaft, because I found that's the best way of eliminating background.
backgroundchans=setdiff(backgroundchans,badchannels); 
muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.      

    allnoiselevels=[]; alltimes=[]; bestchan=[];
    trialcounter=1; trialduration=0; sortingcounter=0;
          
    for iterations=1:length(trainingtrials);
    trial=trainingtrials(iterations); 
    lasttrial=[];
        
            if trial<10;   %adds '0' to file name is trial<10.
            trialstring=['0' num2str(trial)];
            else trialstring=num2str(trial);
            end

            maxtrial=trial;
            testdatafile=[rawpath filename '_t' trialstring '.mux1'  ];
            if exist(testdatafile,'file')==0
            testdatafile=[rawpath filename '_t' trialstring '.mux2'  ];
            end  
            if exist(testdatafile,'file')==0   %if this trial doesn't exist...
            if trial==1   %...if this is the first trial, something's wrong.
            disp(['error loading data files. check file name and directory.'])
            break
            else   %...othersise it just ran out of trials to analyze.
            disp(['finished analyzing last trial in data set (' num2str(trial-1) ').'])
            maxtrial=trainingtrials(iterations-1);    %determines maximum trial if trainingtrials exceed actual trials.
            break
            end
            end
         
        datafilename=[rawpath filename '_t' trialstring];  

    %***Calculate average signal for background removal*** 
  
    if length(backgroundchans)>0;
    backgndsignal_muxi    %calculated only once per channel set per trial.
    clear data
    else
    backgnddata=0;
    end
    %***************************************************

    muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting, e.g. mux1 and mux2 for chs 1-64.
    datadochannels=[]; stimesdochannels=[]; stimes=[]; noisechani=[];   
    for muxind=1:length(muxifiles);      
    muxi=muxifiles(muxind);     
    datafile=[datafilename '.mux' num2str(muxi)];   

    fid = fopen(datafile,'r','b');
    data = fread(fid,[1,inf],'int16');    
    fclose(fid);
    data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

    muxichans=dochannels(find(dochannels<(32*muxi+1) & dochannels>32*(muxi-1)))-32*(muxi-1);  %selects only channels in the active muxi file.

        for chanind=1:length(muxichans);
        channel=muxichans(chanind);
        absolutechan=muxichans(chanind)+(muxi-1)*32;

        muxi_numbering
        
        datach=datach-backgnddata-mean(datach);  %subtracts the background channel if backgroundchans were specified.
        remove_laserartifacts  %optional: removes mean laser artifact found in get_laserartifacts.
        
        dofilter_muxi

        datach=1e6*datach;  %convert to microvolts.
        
            if iterations>=1 & length(datach)>trialduration;
            trialduration=length(datach);
            end
        
            if iterations>1 & length(datach)<trialduration;
            lasttrial=trial;
            lasttrialduration=length(datach);
            end
        
            if trial==trainingtrials(length(trainingtrials));
            lasttrial=trial;
            lasttrialduration=length(datach);
            end
        
        % stdsignal=std(datach);
        stdsignal=prctile(datach, noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes
        if spikedetectionmethod==1
        detectthreshold=minamplitude;  %round(detectstdev*stdsignal)  %detection threshold voltage.
        elseif spikedetectionmethod==2
        detectthreshold=round(detectstdev*stdsignal);  %detection threshold voltage.
        end

        noisechani=[noisechani; stdsignal];  %strings together noise levels for all channels.
   
        findpeaktimes_muxi   %finds peak times on one channel.       
        stimesdochannels=[stimesdochannels spiketimes];   %adds all spiketimes from dochannels into one vector; the same unit may be counted multiple times.

        datadochannels{absolutechan}=datach;
        currenttrialduration=length(datach);
        clear datach;

        end

    end
        clear data;

    align_peaks_muxi    %Removes extra spike times that are from same putative unit observed on multiple channels.
                          %picks only the time corresponding to the most prominent peak out of all channels.

    alltimes=[alltimes stimes+(trial-1)*trialduration];    %all trials.
       
    allnoiselevels=[noisechani];
    
    if length(minamplitude)==0        %added 30/11/11
    minamplitude=ceil(detectstdev*mean(allnoiselevels))
    end

    clear stimesdochannels;
    numberofspikes=length(stimes);      
    
    if numberofspikes==0 & trial~=trainingtrials(length(trainingtrials)) 
    trialcounter=trialcounter+1;
    continue;
    elseif numberofspikes==0 & trial==trainingtrials(length(trainingtrials))   
        sortspikes_params   %creates variable sortspikes for storage.
        save([seedtempdir 'sortspikes_set' num2str(channelsetindex) '.mat'], 'sortspikes', '-MAT')
        disp(['done with channel set ' num2str(channelsetindex) '.'])
        continue
    end  
  
    sortingcounter=sortingcounter+1;
    ampsallchans=[];
    for chanind=1:length(dochannels);
    channelj=dochannels(chanind);
    datach=datadochannels{channelj};
    spikeamps=[];   
    if do_parallel=='y'
    extract_amps_muxi_parallel;
    else extract_amps_muxi
    end
    ampsallchans=[ampsallchans; spikeamps];    %amplitudes from multiple channels are stringed together.
    end
   
    doupsampling='n';
    if do_parallel=='y'
    extract_wave_jitters_parallel   %gives time offset (a.k.a. jitter) to highest amplitude peak from nominal peak position 
    else extract_wave_jitters
    end
    
    wavesallchans=[];  
    for chanind=1:length(dochannels);
    channelj=dochannels(chanind);
    datach=datadochannels{channelj};
    waveforms=[];  
    
    if do_parallel=='y' 
    extract_waveforms_muxi_parallel   %upsamples, realigns waveforms to the largest peak per spike.
    else extract_waveforms_muxi
    end
    
    waveforms=waveforms';         
    wavesallchans=[wavesallchans; waveforms];   %waveforms from multiple channels are stringed together, just for current trial.
    end
    
    clear waveforms 

    waveforms=wavesallchans'; 
    clear wavesallchans; clear datadochannels;  %no longer need these variables.     
     
  	create_templates  %creates templates;  
    
      
        if trial==trainingtrials(length(trainingtrials))   
        sortspikes_params   %creates variable sortspikes for storage.
        save([seedtempdir 'sortspikes_set' num2str(channelsetindex) '.mat'], 'sortspikes', '-MAT')
        disp(['done with channel set ' num2str(channelsetindex) '.'])
        end
 
    end

toc

end

parameters=[];
parameters.minamplitude=minamplitude;
mkdir([timesdir])
save([timesdir 'runparameters.mat'],'parameters')
copyfile([rawpath 'notes_' filename '.txt'],[savedir 'notes_' filename '.txt'])
            
disp(['done creating seed templates.'])