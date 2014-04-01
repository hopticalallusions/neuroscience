%updated November 2 2011.
%plots raw data (filtered or unfiltered) around a stimulus events.
%specify the duration of the stimulus you want to observe in setduration(in case a file contains more than one stimulus duration.
%data are stored in stimartifact and there is an option to plot as you go along.

%Note: this routine does not store data.  To store data, use get_stim_artifact

%*********************Set parameters********************************
dochannels=[22];          %can process multiple channels.
badchannels=[];          %default=[] (no bad channels).  

dotrials=[30];           %setting the upper limit to more trials than exist is ok. 
                   
samplingrate=1/(41.6e-6);   %exact sampling time = 44.8 microseconds.
f_low = 500;                %default=500.  bandpass filter, low frequency
f_high = 6000;              %default=6000. bandpass filter, high frequency
n = 3;                      %number of poles butterworth filter
dofilter='n';               %default='n';
donotchfilter='n';          %default='n';

t_on=0.001;                 %best works with even number, e.g. 0.0004 seconds.  time to plot before stimulus onset.
setduration=0.004;              %units of seconds. set the duration of the stim pulses you would like to focus on.

doneplotting='n';           %if 'n' will plot stimartifact for every stimulus and prompt user whether to continue updating plot.
close all; warning off
% *******************Finished setting parameters***********************


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

savedir=['c:\data analysis\' subject '\' datei '\' filename '\multiunit\']

dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.

figure(1)
hold off
          
stimartifact=[]; 
for chani=1:length(dochannels);
    chan=dochannels(chani);
    stimartifact{chan}=[];
end

doneduration='n'; doneperiod='n'; totalstims=0;

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

muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting

% **************load data & filter data***********
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
    datach=datach-mean(datach);    %removes dc offset
     
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

if iterations==1;
trialduration=length(datach);
end
 
    for stimind=1:numberofstims;
    
        if abs((stimofftimes(stimind)-stimontimes(stimind)-setduration))/setduration<0.05;
    
        toff=stimperiod/2;
            if toff>10
            toff=10;
            end
    
        t0=floor((stimontimes(stimind)-t_on)*samplingrate);
        tf=floor((stimontimes(stimind)+stimduration+toff)*samplingrate);
    
        addtf=floor((t_on+stimduration+toff)*samplingrate)-(tf-t0+1);
        tf=tf+addtf;
 
        sniptime=-t_on:1/samplingrate:((stimduration+toff)-1/samplingrate);   
    
            if t0>0 & tf<length(stimsignal)
       
                stimartifact{absolutechan}=[stimartifact{absolutechan}; datach(t0:tf)];
              
                if absolutechan==dochannels(1);
                totalstims=totalstims+1;
                end
            
                if doneplotting=='n'      
                plot(sniptime,stimartifact{absolutechan}')
                doneplotting=input(['trial ' num2str(trial), ', ch ' num2str(absolutechan) ', stim # ' num2str(stimind) '; are you done viewing plots (y/n)? [y] '], 's');    
                else  ['trial ' num2str(trial), ', ch ' num2str(absolutechan) ', stim # ' num2str(stimind) '.']
                end     
            end
   
        else ['no stim durations near ' num2str(setduration) ' s in trial ' num2str(trial) '.']
        end     
    end   
end
end

end


['Done creating mean stimulus artifacts.']