disp(['Multiunit analysis for ' filename])
%updated Mar 2 2012.

%***run spikesort_muxi first.***

%Simple spike detection, no classification.  Spike detection is based on
%percentile method, which is less sensitive to high firing rate than stdev method.

%The file timesperchan.mat contains spike times (in units of samples)
%arranged per channel, with duplicate events not discarded.  

%Waveforms and amplitudes do not discard duplicate events.

%Consider running get_LFP_power to see mean LFP power as a function of site
%depth; this can be used to help localize the probe position.

%*********************Set parameters for multiunit and LFP analysis********************************
multiminamplitude=50;       %used in multiunit spike detection.  could also set same as minamplitude.
doneplotting='y';           %default='y';  %if 'n', will plot which spikes are found.  'n' is good for diagnostics but otherwise slows things down.
% *******************Finished setting parameters***********************

plotsummedchannels=[];                         
dochannels=[1:length(s.x)];
dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.
plotsummedchannels=setdiff(plotsummedchannels,badchannels);

disp(['multiunit spike detection threshold = ' num2str(multiminamplitude) ' microvolts.'])

if exist([stimulidir 'laserartifacts.mat'],'file')>0 & laser_artifact_removal=='y'
disp(['doing laser artifact removal'])    
load([stimulidir 'laserartifacts.mat'])
end

clearoldresults='y';
if isdir(multisavedir)==1;
clearoldresults=[];
    if length(dir([multisavedir 'multitimes.mat']))>0
    clearoldresults=input('do you want to clear old spikeset files (y/n)? [y] ', 's');
    if isempty(clearoldresults)==1
        clearoldresults='y';
    end
    if clearoldresults=='y'
        rmdir(multisavedir,'s');     
    end   
    end
end

if clearoldresults=='y'
mkdir(multisavedir); 

alltimes=[]; amprange=[]; multibestchannels=[];   %initializes variables.
for chani=1:length(dochannels);
    chan=dochannels(chani);
    amprange{chan}=[]; 
end

for iterations=1:length(dotrials);
trial=dotrials(iterations);  
  
if trial<10;
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end

maxtrial=trial;
testdatafile=[datadir filename '_t' trialstring '.mux1'  ];
if exist(testdatafile,'file')==0
testdatafile=[datadir filename '_t' trialstring '.mux2'  ];
end  

if exist(testdatafile,'file')==0
    if trial==1
        disp(['error loading data files. check file name and directory.'])
         break
    else
    disp(['finished analyzing last trial in data set (' num2str(trial-1) ').'])
    maxtrial=dotrials(iterations-1);    %determines maximum trial if dotrials exceed actual trials.
    break
    end
end
    
datafilename=[datadir filename '_t' trialstring];

stimes=[];

backgroundchans=setdiff(backgroundchans1,badchannels);
muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting
muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.

if length(backgroundchans)>0;
    backgndsignal_muxi
else
    backgnddata=0;
end

rawwaves=[];
stdsignalarray=[];

alloldmeanamps=[]; alloldmeanwaves=[]; totaltime=0; allspiketimes=[]; allindices=[];

% **************load data & filter data***********
datadochannels=[]; timesperchan=[]; 
shaftperspike=[];

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
    
    datach=datach-backgnddata;
    datach=datach-mean(datach);  %subtracts the background channel if backgroundchans were specified, also removes dc offset.;  
    datach=1e6*datach;  %convert to microvolts.
    remove_laserartifacts  %optional: removes mean laser artifact found in get_laserartifacts.
    dofilter_muxi

    if iterations==1;
    trialduration=length(datach);
    end

    stdsignal=prctile(datach, noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes
    if spikedetectionmethod==1
    detectthreshold=minamplitude;  %round(detectstdev*stdsignal)  %detection threshold voltage.
    elseif spikedetectionmethod==2
    detectthreshold=round(detectstdev*stdsignal);  %detection threshold voltage.
    end
    
    findpeaktimes_muxi   %finds peak times on one channel.
    
    timesperchan=[timesperchan spiketimes];
    shaftperspike=[shaftperspike s.shaft(absolutechan)*ones(1,length(spiketimes))];
    
    datadochannels{absolutechan}=datach;
    clear datach;

    numberofspikes=length(spiketimes);
%     if numberofspikes==0
%     disp(['channel ' num2str(absolutechan) ', trial ' num2str(trial) '; threshold = ' num2str(detectthreshold) ': found 0 spikes.'])
%     continue;
%     end
%     disp(['channel ' num2str(absolutechan) ', trial ' num2str(trial)  '; threshold = ' num2str(detectthreshold) ': found '  num2str(length(spiketimes))  ' spikes.'])

    if doneplotting=='n'
    figure(1)
    hold off
    plot(datadochannels{absolutechan},'k')
    hold on
    plot(spiketimes,datadochannels{absolutechan}(spiketimes),'o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',4)
    doneplotting=input('are you done viewing plots (y/n)? [y] ', 's'); 
    end

    end

end

    align_multiunit   %organizes times according to channel; selects only the spike on the channel corresponding to the highest amplitude event.***
    alltimes=[alltimes stimes+(trial-1)*trialduration];    %all times in trials.   

end

lasttrial=maxtrial; lasttrialduration=length(datadochannels{dochannels(1)}); 

multitimes=alltimes/samplingrate;
multiparameters=[];
multiparameters.multiminamplitude=multiminamplitude;

save([multisavedir 'multitimes.mat'], 'multitimes', '-MAT')   %all the spike times from all channels in one long vector.
save([multisavedir 'multibestchannels.mat'], 'multibestchannels', '-MAT')   %the best channel for each spike.
save([multisavedir 'amprange.mat'], 'amprange', '-MAT')   %mean spike amplitude per trial and per channel.  useful if need to identify cell body layers.
save([multisavedir 'multiparameters.mat'], 'multiparameters', '-MAT')   %multiunit generation parameters.

clear datadochannels
disp(['done getting multiunit activity.'])
else disp(['multiunit spike times already exist.'])
end

