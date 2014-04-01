%created May 18 2011
['run_template_matching']
load([seedtempdir 'origtemplates.mat'])

%***Set parameters***
maxwavesize=1e6;      %default=10e6   %larger files slow down program.
maxtimefilesize=2e6;  %default=5e6
refreshnumber=10;  %default=50; number of spikes per cluster per trial required to refresh the template.
run_detectstdev=detectstdev; 
%********************************

if exist([savedir 'final_params.mat'],'file')>0   %fixes a bug in get_penultimate_units because it calls set_plot_parameters (Sept. 10 2012)
    delete([savedir 'final_params.mat'])
end

if exist([stimulidir 'laserartifacts.mat'],'file')>0 & laser_artifact_removal=='y'
disp(['doing laser artifact removal'])    
load([stimulidir 'laserartifacts.mat'])
end

initialize_run      %loads some important parameters and initializes variables.

for iterations=1:length(dotrials);
trial=dotrials(iterations); 
lasttrial=[]; noisedochannels=[]; 

if trial>maxtrial   %added Sept. 18 2012.
    break
end
    
    tic
    for setind=1:length(uniquesets);   %set normally refers to all channels per shaft.
    currentset=dosets(setind); %uniquesets(setind);

    get_data_muxi   %loads and filters raw data on the channels in the set, finds all spike times in this trial and set, and produces variable datadochannels
 
    align_peaks_muxi  %also used in make_seed_templates

    clear stimesdochannels;
    numberofspikes=length(stimes);
    if numberofspikes>0
    disp(['matching ' num2str(numberofspikes) ' spikes in set ' num2str(currentset) ' of ' num2str(length(dosets)) ' to ' num2str(numberofclusters) ' templates; trial ' num2str(trial) ' of ' num2str(maxtrial) '.'])
    else disp(['no spikes in set ' num2str(currentset) ', trial ' num2str(trial)])
        continue
    end
        
    ampsallchans=[];
    for chanind=1:length(dochannels);
    channelj=dochannels(chanind);
    datach=datadochannels{channelj};
    spikeamps=[];      
    extract_amps_muxi;  
    ampsallchans=[ampsallchans; spikeamps];    %amplitudes from multiple channels are stringed together.
    end
   
    doupsampling='y';
    extract_wave_jitters   %gives time offset (a.k.a. jitter) to highest amplitude peak from nominal peak position 
     
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
    clear wavesallchans; %clear datadochannels;  %no longer need these variables.   
    
        for clusteriteration=1:numberiterations;
                    
        clusterstdev=allcluststdev(clusteriteration);
     
        if do_parallel=='y' 
        match_templates_parallel
        else match_templates
        end
                                     
        save_allwaves_alltimes;
   
%       save_unsorted_and_distance;
                           
        end       
        clear wavesinclust waveforms datadochannels
    end
    toc
   
end

save_sortparameters;


   %NEXT; 
        %1. Realign peaks according to peakposition in extractspikeamps.
        %--> done.  Now peak is at (leftpoints-1)*upsamplingfactor+1
        %2. MATCH trimmedwavesallchans to templates.  make new file:
        %match_templates.  Done.        
        %3.  Modify program so that larger spikes and spikes with more chanswithspikes are done first. Done.
        %4.  Add option to subtract templates from datach after matching.  Done.
        %5.  Remove superpositions.

