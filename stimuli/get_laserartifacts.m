%updated Jan 20 2013
if laser_artifact_removal=='y';

disp('collecting photoinduced voltage artifacts to attenuate artifacts & improve spike detection.')
disp('note this only works if all laser pulse trains are identical.')

%***run spikesort_muxi & get_stimuli first.***

%*********************Set parameters for multiunit and LFP analysis********************************
dochannels=s.channels;
extratime=3;  %extra time for optoelectrical artifact to settle down.
% *******************Finished setting parameters***********************

load([stimulidir 'stimuli.mat'])
pulsetrainstart=stimuli.lasertimes.pulsetrainstart;

if length(pulsetrainstart)>0 
        
pulseduration=stimuli.lasertimes.pulseduration;
pulsetimes=stimuli.lasertimes.pulsetimes; 

startscratch=[];
if exist([stimulidir 'laserartifacts.mat'],'file')>0
    startscratch=input('Re-do get_laserartifacts (y/n) [n]? ','s');  
    if isempty(startscratch)==1
    startscratch='n';
    end
else startscratch='y';
end
    
if startscratch=='y'

pulselength=round((max(pulsetimes{1})-min(pulsetimes{1})+pulseduration(1))*samplingrate+extratime*samplingrate);

laserartifacts=[];

dochannels=setdiff(dochannels,badchannels);  %removes badchannels from the list of background-removal channels.
muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting
for muxind=1:length(muxifiles);     

muxi=muxifiles(muxind);     
muxichans=dochannels(find(dochannels<(32*muxi+1) & dochannels>32*(muxi-1)))-32*(muxi-1);  %selects only channels in the active muxi file.

for chanind=1:length(muxichans);
    
channel=muxichans(chanind);
absolutechan=muxichans(chanind)+(muxi-1)*32;
disp(['*current channel: ' num2str(absolutechan)])
rawvoltage=[];

for iterations=1:length(dotrials);
trial=dotrials(iterations);  
  
if trial<10;
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end

maxtrial=trial;
testdatafile=[rawpath filename '_t' trialstring '.mux1'  ];
if exist(testdatafile,'file')==0
testdatafile=[rawpath filename '_t' trialstring '.mux2'  ];
end  
if exist(testdatafile,'file')==0
    if trial==1
        disp(['error loading data files. check file name and directory.'])
         break
    else
    maxtrial=dotrials(iterations-1);    %determines maximum trial if dotrials exceed actual trials.
    break
    end
end
    
datafilename=[rawpath filename '_t' trialstring];
datafile=[datafilename '.mux' num2str(muxi)];   

maxtrial=length(dotrials);


% **************load data***********
fid = fopen(datafile,'r','b');
data = fread(fid,[1,inf],'int16');    
fclose(fid);
data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

    if mod(muxi,2)==1  %muxi==1
    datach=data(channel:32:length(data));  %demultiplexing. 
    elseif mod(muxi,2)==0  %muxi>1
    channel=channel-1;
            if channel==0;
                channel=32;
            end
    datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
    end
    datach=datach;
    datach=datach-mean(datach);  %subtracts the background channel if backgroundchans were specified, also removes dc offset.;  
%     datach=1e6*datach;  %convert to microvolts.
    
    if iterations==1;
    trialduration=length(datach);
    end
    
rawvoltage=[rawvoltage datach];
clear datach

end

    artifactchani=[];
    for pulseind=1:length(pulsetrainstart);
        t0=floor(pulsetrainstart(pulseind)*samplingrate);
        tf=t0+pulselength;         
        artifactchani=[artifactchani; rawvoltage(t0:tf)];
         
    end
  
    meanartifact=mean(artifactchani);
    laserartifacts.channel{absolutechan}=meanartifact;
    laserartifacts.trialduration=trialduration;
    laserartifacts.pulsetrainstart=pulsetrainstart;
    laserartifacts.pulselength=pulselength;
     
%     cleanvoltage=rawvoltage; clear rawvoltage;
%     for pulseind=1:length(pulsetrainstart);
%         t0=floor(pulsetrainstart(pulseind)*samplingrate);
%         tf=t0+pulselength;
%         cleanvoltage(t0:tf)=cleanvoltage(t0:tf)-meanartifact;                
%     end

    clear rawvoltage

end

end

save([stimulidir 'laserartifacts.mat'],'laserartifacts','-mat')

disp('done getting photoinduced voltage artifacts for all channels.')

end

else disp(['NOTE: no laser pulses were detected in get_stimuli.'])
    
end
    
end
