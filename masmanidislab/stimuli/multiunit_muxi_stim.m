%updated October 30 2011
%Simple spike detection, no classification.  Spike detection is based on
%percentile method, which is less sensitive to high firing rate than stdev method.

%The file timesperchan.mat contains spike times (in units of samples)
%arranged per channel, with duplicate events not discarded.  

%Waveforms and amplitudes do not discard duplicate events.

%If want to do artifact subtraction, need to run get_stim_artifact to find the mean stimulus artifact.
%Note that artifact removal is imperfect, but it removes some of the transients.

%To view signals centered on individual stimuli, use load_stimulus.

%*********************Set parameters********************************
dochannels=[1:64];          %default=[1:64]; channels used in detecting spikes and plotting individual spike times.
plotsummedchannels=[30]; %channels used to construct the summed multiunit activity plot.
badchannels=[1:21 23:64];          %default=[] (no bad channels).  

multfactor=ones(1,64);      %multiplication factor for spike detection. +1=negative spikes; -1=positive spikes. default=ones(1,64).                                 
backgroundchans=[];         %ok to leave empty. The channels in the current set are not used.

% dotrials=[1:1000];        %dotrials set by stimartifact file   %setting the upper limit to more trials than exist is ok. %skipping trials is ok for training, e.g. [1:5:50];

detectstdev=12;             %default=12 (times above noise percentile range).  spike detection threshold.
noiseprctile=68;            %default=68

doartifactremoval='n';      %decides whether to use stimulus artifact removal;
discardstimonofftimes='y';  %decides whether to discard the stimulus onset & offset times in spiketimes to avoid spurious spike-like events.

f_low = 500;                %default=500.  bandpass filter, low frequency
f_high = 6000;              %default=6000. bandpass filter, high frequency
n = 3;                      %number of poles butterworth filter
dofilter='y';               %default='y';
donotchfilter='n';          %default='n';

psthbinsize=60;             %bin size for PSTH (sec).

minoverlap=2;               %default=1 (msec).  used in findpeaks minimum time, in which two spikes are considered separable. 
rejecttime=0.5;             %default=0.5 (msec).  if two spikes on two different channels occur within this time, keep only one time.
leftpoints=15;              %for waveform extraction. left distance for waveforms.  default=5;
rightpoints=22;             %for waveform extraction. right time for waveforms.   default=19;
amplitudemethod=2;          %for amplitude extraction. 0=min, 1=peak-to-peak amplitude, 2=exact value at spiketime, 3=use combination of min & max amplitude, 
                   
findpeakmethod=1;           %default=1. 1=only +ve or -ve specified by multfactor.  2=both +ve and -ve.
removedoubles=1;            %default=0;  1=yes.
upsamplewaves='n';          %default='n';
doneplotting='n';           %default='n';

close all; warning off
% *******************Finished setting parameters***********************

tic
if length(multfactor)~=length(dochannels)
    'multfactor and channelsets lengths do not match, fix and rerun.'
end

recall_rawpath
rawpath=lastopeneddir
[fname, rawpath]=uigetfile({[rawpath '*.mux1']},'Select a file to open in the correct RAW DATA directory');

a=strfind(rawpath,'\');
b=strfind(rawpath,'data');
datei=rawpath(((a(3)+1):(a(4)-1)));
c=strfind(rawpath,datei);
d=strfind(fname,'_t');
filename=fname(1:(d-1));
subject=rawpath((b+5):(c-2));
remember_rawpath

savedir=['c:\data analysis\' subject '\' datei '\' filename '\multiunit\'];
stimsavedir=['c:\data analysis\' subject '\' datei '\' filename '\'];
textdir=[savedir 'text files\'];
psthJPGdir=[savedir 'jpeg\'];
psthEPSdir=[savedir 'eps\'];
% wavesavedir=[savedir 'waves\'];               %disabled on October 30 2011 to speed up program.

[stimfname, stimsavedir]=uigetfile({[stimsavedir '*.mat']},'Select the stimartifact MAT file you want to use.');


load([stimsavedir stimfname])   %load stimulus artifact file.
samplingrate=stim.samplingrate;
dotrials=stim.trials;
setduration=stim.setduration;
t_on=stim.t_on;
t_off=stim.t_off;


dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.

onlyplot=[];
onlyplot=input('do you want to go straight to psth plots (y/n)? [y] ', 's');   %if onlyplot is true, then will skip spike detection and go straight to plotting via the plot_multiunit_muxi.mat subroutine.
    if isempty(onlyplot)==1
       onlyplot='y';
    end
        
    if onlyplot=='n'
    plotindividual='y';   %if plotindividual='y' will plot psth for each individual channel.
    else plotindividual=[];
    plotindividual=input('do you want to replot individual channels (y/n)? [n] ', 's');
        if isempty(plotindividual)==1
        onlyplot='n';
        end
    end
      
if onlyplot=='n'  
    
    
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
    mkdir(textdir);
    mkdir(psthJPGdir);
    mkdir(psthEPSdir);

    % mkdir(wavesavedir);
    else mkdir(savedir); % mkdir(wavesavedir);
    end

    if length(backgroundchans)>0
    'using background subtraction'
    end

t0plot=10000;  tfplot=40000;
tplot=(t0plot/samplingrate):1/samplingrate:(tfplot/samplingrate);
xplot=[t0plot/samplingrate tfplot/samplingrate];

alltimes=[]; rawamps=[];
for chani=1:length(dochannels);
    chan=dochannels(chani);
    alltimes{chan}=[];
    rawamps{chan}=[];   
end


doneduration='n'; doneperiod='n'; totalstims=0;
stimtimes=[];

for iterations=1:length(dotrials);
trial=dotrials(iterations);  
  
if trial<10;
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end

maxtrial=trial;
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

get_stim_times    %extracts stim times, duration and period from data.


stimes=[];

backgroundchans=setdiff(backgroundchans,badchannels);
muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting
muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.

if length(backgroundchans)>0;
    backgndsignal_muxi
else
    backgnddata=0;
end


rawwaves=[];
stdsignalarray=[];

clusterinds=[]; alloldmeanamps=[]; alloldmeanwaves=[]; totaltime=0; allspiketimes=[]; allwaves=[];
allspamps=[]; allindices=[];
maxtrial=length(dotrials);
for i=1:max(dochannels);
    allwaves{i}=[];
    allspamps{i}=[];
end


% **************load data & filter data***********
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
absolutechan=muxichans(chanind)+(muxi-1)*32;

    if muxi==1
    datach=data(channel:32:length(data));  %demultiplexing. 
    elseif muxi>1
    channel=channel-1;
            if channel==0;
                channel=32;
            end
    datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
    end
    datach=datach-backgnddata;
    datach=datach-mean(datach);  %subtracts the background channel if backgroundchans were specified, also removes dc offset.
    
if doartifactremoval=='y'    
remove_artifact
end    
       
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

    hold off
    plot(time,datach,'b')
    hold on
    plot(time,stimsignal*10,'r')

 input('break point')  %break point for tests

    if iterations==1;
    trialduration=length(datach);
    end

%***Find noise from nth percentile***
%default=68th percentile.
stdsignal=prctile(datach,noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes
detectthreshold=round(detectstdev*stdsignal);  %detection threshold voltage.    

% %***Find noise from standard deviation***
% stdsignal=std(datach);  
% detectthreshold=ceil(detectstdev*stdsignal);  %detection threshold based on number of standard deviations above noise.

minpkdist=round(minoverlap/1000*samplingrate);
negspiketimes=[]; posspiketimes=[];

%***Added on October 22 2011 to avoid crashing with findpeaks if not enough***
if  max(find(-1*multfactor(absolutechan)*datach>detectthreshold))<round(minoverlap/1000*samplingrate)
    ['channel ' num2str(absolutechan) ', trial ' num2str(trial) '; threshold = ' num2str(detectthreshold) ': found 0 spikes.']
    continue
elseif  min(find(-1*multfactor(absolutechan)*datach>detectthreshold))>(length(datach)-round(minoverlap/1000*samplingrate))
    ['channel ' num2str(absolutechan) ', trial ' num2str(trial) '; threshold = ' num2str(detectthreshold) ': found 0 spikes.']
    continue
end
%**************************************************************************

if findpeakmethod==1
    [pks,spiketimes]=findpeaks(-1*multfactor(absolutechan)*datach,'minpeakheight',detectthreshold,'minpeakdistance',round(minoverlap/1000*samplingrate));   %default peak detection.
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
a=find(spiketimes>=length(datach)-(rightpoints+10));
b=find(spiketimes<=(leftpoints+10));
spiketimes=setdiff(spiketimes,spiketimes(a));
spiketimes=setdiff(spiketimes,spiketimes(b));


if discardstimonofftimes=='y'
ontimes=floor(stimontimes*samplingrate);
offtimes=floor(stimofftimes*samplingrate);
offtimes2=ontimes+floor(stimduration*samplingrate);
a=[ontimes-7, ontimes-6, ontimes-5, ontimes-4, ontimes-3, ontimes-2, ontimes-1, ontimes-0, ontimes+1, ontimes+2, ontimes+3, ontimes+4,  ontimes+5, ontimes+6, ontimes+7];   
b=[offtimes-7, offtimes-6, offtimes-5, offtimes-4, offtimes-3, offtimes-2, offtimes-1, offtimes-0, offtimes+1, offtimes+2, offtimes+3, offtimes+4, offtimes+5, offtimes+6, offtimes+7];   

spiketimes=setdiff(spiketimes,a);
spiketimes=setdiff(spiketimes,b);
end


% difftimes=diff(spiketimes);
% overlaps=find(difftimes<rejecttime);  %removes +ve/-ve spikes that occur within rejecctime.
% spiketimes(overlaps)=[];

stimes=spiketimes;   %relative spike times.
numberofspikes=length(stimes);

if numberofspikes==0
    ['channel ' num2str(absolutechan) ', trial ' num2str(trial) '; threshold = ' num2str(detectthreshold) ': found 0 spikes.']
    continue;
end

['channel ' num2str(absolutechan) ', trial ' num2str(trial)  '; threshold = ' num2str(detectthreshold) ': found '  num2str(length(stimes))  ' spikes.']

if doneplotting=='n'
figure(1)
hold off
plot(datach,'k')
hold on
plot(stimes,datach(stimes),'o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',4)
doneplotting=input('are you done viewing plots (y/n)? [y] ', 's'); 
end


alltimes{absolutechan}=[alltimes{absolutechan} stimes+(trial-1)*trialduration];  %absolute time in samples.

 
% %*******Merge all Spike Waveforms in one array********                        %disabled on October 30 2011 to speed up program.
% waveforms=[];
% spikeamps=[];    
% extractspikeamps   %extract parameters and waveforms
% 
% waveforms=waveforms';
% rawwaves{absolutechan}=waveforms;
% rawamps{absolutechan}=[rawamps{absolutechan} spikeamps];

end

end

% save([wavesavedir 'rawwaves_t' num2str(trial) '.mat'], 'rawwaves', '-MAT')    %disabled on October 30 2011 to speed up program.

end

parameters=[];  lasttrial=maxtrial; lasttrialduration=length(datach); 
parameters.f_low=f_low;  parameters.f_high=f_high; parameters.n=n; parameters.dochannels=dochannels; parameters.backgroundchans=backgroundchans;
parameters.badchannels=badchannels; parameters.badclusters=badchannels; parameters.dotrials=dotrials; parameters.detectstdev=detectstdev; parameters.samplingrate=samplingrate; parameters.leftpoints=leftpoints; parameters.rightpoints=rightpoints;
parameters.minoverlap=minoverlap; parameters.rejecttime=rejecttime; parameters.trialduration=trialduration; parameters.maxtrial=maxtrial; parameters.lasttrialduration=lasttrialduration; 

timesperchan=alltimes;
clear alltimes;
% spikeamps=rawamps;
% clear rawamps;



for chanind=1:length(dochannels);   %save individual spike times per channel.
chani=dochannels(chanind);
timesi=timesperchan{chani};
savetimes=(timesi/samplingrate)';
save([textdir 'spiketimes_ch' num2str(chani) '.txt'], 'savetimes','-ASCII')
end

getannotations_muxi
if isempty(timeannotations{1})
    startevent=1;
    timeannotations=timeannotations(2:length(timeannotations));
    eventannotations=eventannotations(2:length(eventannotations));
else startevent=1;
end

if length(eventannotations)>1
delete([savedir 'annotations.txt'])   %create annotations file to store events.
for i=1:(length(eventannotations)-1);
    linei=['time of ' eventannotations{i} ' (s):  ' num2str(timeannotations{i})];
    dlmwrite([savedir 'annotations.txt'],linei,'-append','delimiter','','newline','pc')
end
end


save([savedir 'timesperchan.mat'], 'timesperchan', '-MAT')
% save([savedir 'spikeamps.mat'], 'spikeamps', '-MAT')
save([savedir 'runparameters.mat'], 'parameters', '-MAT')

end

if plotindividual=='y'    %plots individual channels.

totaltime=((lasttrial-1)*trialduration+lasttrialduration)/samplingrate;    %removes last point, which because of binning has zero  value in psth.
plottime=psthbinsize:psthbinsize:totaltime;
%psth for individual channels
for chanind=1:length(dochannels);   %Can select which channels to include in the multiunit analysis.  Need to change dochannels or badchannels in multiunit_muxi.m
chani=dochannels(chanind);
timesi=timesperchan{chani}/samplingrate;

    if length(timesi)>0
    psthchani=histc(timesi,0:psthbinsize:totaltime)/psthbinsize;                %removes last point, which because of binning has zero  value in psth.
    psthchani=psthchani(1:(length(psthchani)-1));

    figure(1)
    hold off
    plot(plottime/60,psthchani,'.-','Color','k')

    xlabel(['time (min)'],'FontSize',9) 
    ylabel(['multi-unit firing rate (Hz)'],'FontSize',9)
    axis([0 totaltime/60 0 ceil(1.1*max(psthchani))])
    title(['Channel ' num2str(chani) ', bin size: ' num2str(psthbinsize) ' s. ' 'mean: ' num2str(mean(psthchani)) '+/-' num2str(std(psthchani)) ' Hz'] ,'FontSize',9)
    set(gca,'XTick',0:5:max(totaltime/60),'FontSize',9)
        for events=startevent:(length(timeannotations)-1);
        etime=timeannotations{events};
        line([etime/60 etime/60], [0 ceil(1.1*max(psthchani))],'Color','r','LineStyle','-')  %convert times to minutes
        text(etime/60,1.05*max(psthchani),[' \leftarrow' eventannotations{events}],'FontSize',9)
        end
    
    saveas(figure(1),[psthJPGdir 'rate_ch' num2str(chani) '.jpg' ]  ,'jpg')   
    saveas(figure(1),[psthEPSdir 'rate_ch' num2str(chani) '.eps' ]  ,'psc2')   
    
    else ['no spikes detected on ch ' num2str(chani) '.']   
    end
end

end


plot_MUA_muxi

toc
['Done.']