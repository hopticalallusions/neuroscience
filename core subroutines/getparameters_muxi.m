%version 2.0 created November 29, 2009
%This is first program in spike sorting sequence.  The full sequence is:
% 1. getparameters  ......  detects spikes and extracts parameters for sorting
% 2. Klustawin  ......  spike clustering.  Run in parallel with plotklustakwik.
% 3. plotklustakwik  ......  shows the clusters and allows user to merge or discard
% 4. analyzespiketimes  ...... displays spike time properties

%********************Set parameters here******************************
%NOTE: old channelsets stored in file 'channelsets.m'
% channelsets={[11 12 13 14 15] [23 24 25 26]};
% channelsets={[21 22 23 24 25] [1 2 3 4 33 32 34 31 64 63 62 61] [5 6 7 8 35 30 36 29 60 59 58 57] [9 10 11 12 37 28 38 27 56 55 54 53] [13 14 15 16 39 26 40 25 52 51 50 49] [17 18 19 20 41 24 42 23 48 47 46 45] [20 21 23 43 22 45 44]}
% channelsets={[39 40 48 49 50] [3 4 31 32 33 34 3 61 62] [5 6 31 35 30 59 60] [7 8 30 36 29 57 58] [9 10 29 37 28 55 56] [11 12 28 38 27 54 53] [12 13 38 27 39 53 52] [14 15 39 26 40 51 50] [16 17 40 25 41 49 48] [18 19 41 24 42 47 46] [20 21 23 43 22 45 44]};
 
% channelsets=[];
% multfactor=[];
% for i=1:length(goodchans);
%     ch=goodchans(i);
%     channelsets{i}=ch;
%     multfactor=[multfactor 1];
% end

channelsets={[1 2 33 64 63] [2 3 32 63 62] [3 4 34 62 61] [4 5 31 61 60] [5 6 35 60 59] [6 7 30 59 58] [7 8 36 58 57] [8 9 29 57 56] [9 10 37 56 55] [10 11 28 55 54] [11 12 38 54 53] [12 13 27 53 52] [13 14 39 52 51] [14 15 26 51 50] [15 16 40 50 49] [16 17 25 49 48] [17 18 41 48 47] [18 19 24 47 46] [19 20 42 46 45] [20 21 23 45 44] [21 22 43 44]} ;  %21 five-on-dice patterns for nano-A probe.
channelsets={ [6 7 30 59 58] [7 8 36 58 57] [8 9 29 57 56] [9 10 37 56 55] [10 11 28 55 54] [11 12 38 54 53] [12 13 27 53 52] [13 14 39 52 51] [14 15 26 51 50] [15 16 40 50 49] [16 17 25 49 48] [17 18 41 48 47] [18 19 24 47 46] [19 20 42 46 45] [20 21 23 45 44] [21 22 43 44]} ;  %21 five-on-dice patterns for nano-A probe.

 channelsets={[1 16 2 15] [3 14 4 13] [5 12 6 11] [7 10 8 9] [17 32 18 31] [19 30 20 29] [21 28 22 27] [23 26 24 25] [33 48 34 47] [35 46 36 45] [37 44 38 43] [39 42 40 41] [49 64 50 63] [51 62 52 61] [53 60 54 59] [55 58 56 57]}

multfactor=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];  %multiplication factor for spike detection. +1=negative spikes; -1=positive spikes.                                 
backgroundchans=[1:64];   %ok to leave empty. The channels in the current set are not used.
badchannels=[];

dosets=[1:16];         %choose which channelsets to do.
dotrials=[1:5];       %setting the upper limit to more trials than exist is ok.
                   
detectstdev=4.5;  %default=5 (standard deviations).  spike detection threshold.

amplitudemethod=1;  %0=min, 1=peak-to-peak amplitude, 2=exact value at spiketime, 3=use combination of min & max amplitude, 
                    %4=amplitude ratio, 5=slope of peak, 6=slope of peak & min value, 10=PCA.  

samplingrate=1/(44.8e-6);   %exact sampling time = 44.8 microseconds.
f_low = 300;       %default=10.  bandpass filter, low frequency
f_high = 5000;  %default=5000. bandpass filter, high frequency
n = 3;          %number of poles butterworth filter
dofilter='y'; donotchfilter='n';

minoverlap=1;   %default=1 (msec).  used in findpeaks minimum time, in which two spikes are considered separable. 
rejecttime=11;       %if two spikes on two different channels occur within this time, keep only one time. default=14
leftpoints=9;    %left distance for waveforms.  default=5;
rightpoints=12;  %right time for waveforms.   default=19;

findpeakmethod=1;  %default=1. 1=only +ve or -ve specified by multfactor.  2=both +ve and -ve.
findspikemethod=0;  %0=get spikes from all channels in set; 1=get spikes from only first channel in set.
removedoubles=1;  %default=0;  1=yes.

close all; warning off
% *******************Finished setting parameters***********************

parameters=[];
parameters{1}.name='f_low';  parameters{2}.name='f_high'; parameters{3}.name='n'; parameters{4}.name='channelsets'; parameters{5}.name='backgroundchans';
parameters{6}.name='goodchans'; parameters{7}.name='dotrials'; parameters{8}.name='detectstdev'; parameters{9}.name='samplingrate'; parameters{10}.name='leftpoints'; parameters{11}.name='rightpoints';
parameters{12}.name='minoverlap'; parameters{13}.name='rejecttime'; parameters{14}.name='amplitudemethod'; parameters{15}.name='findpeakmethod'; parameters{16}.name='findspikemethod';

parameters{1}.value=f_low;  parameters{2}.value=f_high; parameters{3}.value=n; parameters{4}.value=channelsets; parameters{5}.value=backgroundchans;
parameters{6}.value=goodchans; parameters{7}.value=dotrials; parameters{8}.value=detectstdev; parameters{9}.value=samplingrate; parameters{10}.value=leftpoints; parameters{11}.value=rightpoints;
parameters{12}.value=minoverlap; parameters{13}.value=rejecttime; parameters{14}.value=amplitudemethod; parameters{15}.value=findpeakmethod; parameters{16}.value=findspikemethod;

tic
if length(multfactor)~=length(channelsets)
    'multfactor and channelsets lengths do not match, fix and rerun.'
end

if exist('rawpath')==0
   rawpath='c:\';
end
[fname, rawpath]=uigetfile({[rawpath '*.mux1']},'Select a file to open in the correct RAW DATA directory');

a=strfind(rawpath,'\');
b=strfind(rawpath,'data');
datei=rawpath(((a(3)+1):(a(4)-1)));
c=strfind(rawpath,datei);
d=strfind(fname,'_t');
filename=fname(1:(d-1));
subject=rawpath((b+5):(c-2));

savedir=['c:\data analysis\' subject '\' datei '\' filename '\spikesets\']

if isdir(savedir)==1;
clearoldresults=[];
if exist('savedir')>0
    clearoldresults=input('do you want to clear old spikeset files (y/n)? [y] ', 's');
    if isempty(clearoldresults)==1
        clearoldresults='y';
    end
    if clearoldresults=='y'
     rmdir(savedir,'s');
    end   
end
mkdir(savedir);
else mkdir(savedir)
end

if length(backgroundchans)>0
    'using background subtraction'
end

t0plot=10000;  tfplot=40000;
tplot=(t0plot/samplingrate):1/samplingrate:(tfplot/samplingrate);
xplot=[t0plot/samplingrate tfplot/samplingrate];


alltimes=[];
for channelsetindices=1:length(dosets);
    channelsetindex=dosets(channelsetindices);
    if channelsetindex>length(channelsets)
        break
    end
dochannels=channelsets{channelsetindex};
dochannels=intersect(dochannels,goodchans);   %removes any channels from set that are not considered good channels.

rawwaves=[];
rawamps=[];
stdsignalarray=[];

clusterinds=[]; alloldmeanamps=[]; alloldmeanwaves=[]; totaltime=0; allspiketimes=[]; allwaves=[];
allspamps=[]; allindices=[]; trialduration=0; discardclusters=0;
maxtrial=length(dotrials);
for i=1:max(dochannels);
    allwaves{i}=[];
    allspamps{i}=[];
end


% **************load data & filter data***********
for iterations=1:length(dotrials);
trial=dotrials(iterations);  
    
if trial<10;
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end

testdatafile=[rawpath filename '_t' trialstring '.mux1'  ];
if exist(testdatafile,'file')==0
    if trial==1
        ['error loading data files. check file name and directory.']
         break
    else
    ['finished analyzing last trial in data set (' num2str(trial-1) ').']
    maxtrial=dotrials(iterations-1);    %determines maximum trial if dotrials exceed actual trials.
    break
    end
end
    
datafilename=[rawpath filename '_t' trialstring];

stimes=[];

backgroundchans=setdiff(backgroundchans,badchannels);
backgroundchans=setdiff(backgroundchans,dochannels);  %exclude the channels in the current set from background subtraction.

muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting
muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.

if length(backgroundchans)>0;
    backgndsignal_muxi
else
    backgnddata=0;
end

stdsignaltriali=[];

% ['finding peaks in trial ' num2str(trial) '...'] 
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

    if muxi==1
    datach=data(channel:32:length(data));  %demultiplexing. 
    elseif muxi>1
    channel=channel-1;
            if channel==0;
                channel=32;
            end
    datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
    end
    datach=datach-backgnddata;  %subtracts the background channel if backgroundchans were specified.
     
%****Apply bandpass & notch filters******
if dofilter=='y'
Wn = [f_low f_high]/(samplingrate/2); 
[b,a] = butter(n,Wn); %finds the coefficients for the butter filter
datach = filtfilt(b, a, datach); %zero-phase digital filtering
end

if donotchfilter=='y'
notchfilter_mux
end
%*************end filters*********

datach=1e6*datach;  %convert to microvolts.
stdsignal=std(datach);

detectthreshold=round(detectstdev*stdsignal);  %detection threshold based on number of standard deviations above noise.
stdsignaltriali=[stdsignaltriali; stdsignal];  

figure(1)
plot(tplot,datach(t0plot:tfplot))
y1=[detectthreshold detectthreshold];
y2=-y1;
hold on
plot(xplot,y1,'r')
plot(xplot,y2,'r')
hold off

minpkdist=round(minoverlap/1000*samplingrate);
negspiketimes=[]; posspiketimes=[];
if findpeakmethod==1
    [pks,spiketimes]=findpeaks(-1*multfactor(channelsetindex)*datach,'minpeakheight',detectthreshold,'minpeakdistance',round(minoverlap/1000*samplingrate));   %default peak detection.
elseif findpeakmethod==2  
    if length(find(datach<-detectthreshold))>3  max(find(datach<-detectthreshold)>minpkdist)==1;  %findpeaks gives error unless >3 points meet threshhold criterion.
    [negpks,negspiketimes]=findpeaks(-1*datach,'minpeakheight',detectthreshold,'minpeakdistance',minpkdist);   %default peak detection.
    else negspiketimes=[];
    end
    if length(find(datach>detectthreshold))>3  &  max(find(datach>detectthreshold)>minpkdist)==1 ;
    [pospks,posspiketimes]=findpeaks(datach,'minpeakheight',detectthreshold,'minpeakdistance',minpkdist);   %default peak detection.
    else posspiketimes=[];
    end
spiketimes=sort([negspiketimes posspiketimes]);
end
    
%***removes spikes that occur too close to start or end, because this causes problem in waveform extraction***
a=find(spiketimes>=length(datach)-(rejecttime+10));
b=find(spiketimes<=(rejecttime+10));
spiketimes=setdiff(spiketimes,spiketimes(a));
spiketimes=setdiff(spiketimes,spiketimes(b));

if findspikemethod==0
    stimes=[stimes spiketimes];
elseif findspikemethod==1   
    if muxind==1  & chanind==1
    stimes=[stimes spiketimes];
    break
    end
end

end

end

if removedoubles==1 & findspikemethod==0;
        
        if length(stimes)==0;
        ['no spikes in trial  ' num2str(trial) '.']
        continue
        end

    stimes=unique(stimes);
    %***removes spikes occuring within time 'rejecttime' of each other***
    rej=[];
    for i=1:length(stimes);
    for j=2:length(stimes);
    if i>=j
    continue
    end
    b=abs(stimes(j)-stimes(i));
    if b<=rejecttime;
     rej=[rej,j];          %new setting April 5 2010
    end
    end
    end

    rej=unique(rej);
    a=1:length(stimes);
    acc=setdiff(a,rej);
    stimes=stimes(:,acc);
    %*****
end

allspiketimes{trial}=stimes;
['channel set ' num2str(channelsetindex) ', trial ' num2str(trial) ': found '  num2str(length(stimes))  ' spikes.']
if length(stimes)==0
    clusterinds{trial}=[];
    continue;
end

stdsignalarray=[stdsignalarray, stdsignaltriali];

%*******Merge all Spike Waveforms in one array********
numberofspikes=length(stimes);
spamps=[];
waves=[];

for muxind=1:length(muxifiles);  
    
muxi=muxifiles(muxind);     
datafile=[datafilename '.mux' num2str(muxi)];   

fid = fopen(datafile,'r','b');
data = fread(fid,[1,inf],'int16');    
fclose(fid);
data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

muxichans=dochannels(find(dochannels<(32*muxi+1) & dochannels>32*(muxi-1)));  %selects only channels in the active muxi file.

for chanind=1:length(muxichans);
channel=muxichans(chanind);
chan=channel-32*(muxi-1);   %converts channel to a number from 1 to 32.
datach=data(chan:32:length(data));  %demultiplexing.
datach=datach-backgnddata;  %subtracts the background channel if backgroundchans were specified.

%****Apply bandpass & notch filters******
if dofilter=='y'
Wn = [f_low f_high]/(samplingrate/2); 
[b,a] = butter(n,Wn); %finds the coefficients for the butter filter
datach = filtfilt(b, a, datach); %zero-phase digital filtering
end

if donotchfilter=='y'
notchfilter_mux
end
%*************end filters*********

datach=1e6*datach;  %convert to microvolts.

waveforms=[];
spikeamps=[];  

  
    extractspikeamps   %extract parameters and waveforms

     waveforms=waveforms';
     rawwaves{channel}{trial}=waveforms;
     rawamps{channel}{trial}=spikeamps;   
   
     
end
end
%      alltimes=[alltimes, stimes];
    alltimes{trial}=stimes;
end

    klustamps=[];
    for k=1:length(dochannels);
    channel=dochannels(k);
    ampstr=[];
    for trli=1:length(dotrials);
       trl=dotrials(trli);
        ampstr=[ampstr, rawamps{channel}{trl}];
    end
    klustamps=[klustamps; ampstr];
    end
    klustamps=klustamps';    
    save([savedir 'klustamps_set' num2str(channelsetindex) '.txt'], 'klustamps', '-ASCII')
    save([savedir 'stdsignal_set' num2str(channelsetindex) '.mat'], 'stdsignalarray', '-MAT')
    save([savedir 'rawwaves_set' num2str(channelsetindex) '.mat'], 'rawwaves', '-MAT')
    save([savedir 'rawamps_set' num2str(channelsetindex) '.mat'], 'rawamps', '-MAT')
    save([savedir 'alltimes_set' num2str(channelsetindex) '.mat'], 'alltimes', '-MAT')
    save([savedir 'channels_set' num2str(channelsetindex) '.mat'], 'dochannels', '-MAT')
    
%     save([savedir 'subtractclusters_set' num2str(channelsetindex) '.mat'], 'subtractclusters', '-MAT')
end
    save([savedir 'parameters.mat'], 'parameters', '-MAT')
toc
    
['Saved files and done. Now run either KlustaKwik or train_muxi.']