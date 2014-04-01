%reads and plots multiplexed files acquired from nanoprobe using Intan RHA2164.
%Uses new file format ('dot muxi')
%.mux1 files contain multiplexed data from channels 1 through 32
%.mux2 files contain multiplexed data from channels 33 through 64, etc...
%The basic format for loading data is:
%1% datafile=[datafilename '.mux' num2str(muxi)];   %an example of datafilename is 'c:\nanoprobe data\Feb23n1_t01'
%%t01 or t02 refers to the trial number.  In order to avoid huge file
%%sizes, I create a new trial every 440,000 samples, which corresponds to
%%~19.7 seconds.  But you can assume that t02 was recorded without any time
%%laps after t01. See note above on 'dot muxi' file formats.
%2% fid = fopen(datafile,'r','b');
%3% data = fread(fid,[1,inf],'int16');    
%4% fclose(fid);
%5% data=data/2^20;  %2^20 is multiplication factor introduced during data acquisition
%%After step 5 you will have a vector 'data' containing signals from 32
%%interleaved channels.  To select the signal from a single channel (e.g.,
%%channel n) use the following command:
%6% datach=data(channel:32:length(data)); 
%%Now you will have data (in units of volts) from a single channel and you can filter it and
%%process it as usual.  I definitely recommend filtering it because there
%%is a ~1.5 volt dc offset on all signals.

%Below you will find a program for loading and plotting the data that you may find useful.

%***Set plot parameters**********
probetype='probe_64E';    %probe type.  open <<get_probegeometry>> for list of probe names.  %Specifing a probe name plots them approximately in order from deep to shallow with channels on the same shaft grouped together.  
numberofchannels=64;      %number of channels on the probe.

stimtype='laser';         %options: 'none', 'cue1', 'cue2', 'cue3', 'cue4', 'solenoid', 'lick', 'laser', 'motiony'.
                                                          
badchannels=[];          %ok to leave empty. specifies the faulty channels on the probe.
backgroundchans1=['all'];     %any channels added here will be subtracted from the data to remove noise artifacts. ok to leave empty. 
offset=100;                 %plot voltage offset in microvolts.

tmin=0; tmax=20;             %specify time range to plot in the specified trial (min & max time, in seconds note max time per trial is 20 seconds). 

dofilter='y';               %'y' or 'n' to either do or not do bandpass filtering.  You must do at least highpass filtering to make sense of the data.
f_low=600;                  %hiphpass filter frequency.  default=600.
f_high=6500;                %lowpass filter frequency.  default=6500.
n=3;                        %number of poles of Butterworth filter.  default=3.
samplingrate=25000;     %default=25000 (i.e. 1/(40e-6 seconds);

laser_artifact_removal='n';

stim_multfactor=4096;  %4096 starting May 22. previously 16384.
stimsamplingrate=10000;
%***end setting parameters****


%***Specify channel order for plotting (recommend not altering this section).
backgnddata=0;
if probetype=='n'  %no probe style; channels are numbered 1:64.
channels=[1:numberofchannels];
uniqueshafts=1;
else get_probegeometry
    [sorted,sortorder]=sort(s.z);
    channels=sortorder;
    uniqueshafts=unique(s.shaft);
end
%***end specifying channel order.

recall_rawpath

remember_rawpath

stimulidir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\stimuli\'];

if exist([stimulidir 'laserartifacts.mat'],'file')>0 & laser_artifact_removal=='y'
disp(['doing laser artifact removal'])    
load([stimulidir 'laserartifacts.mat'])
end

if length(findstr(rawpath,'analysis'))>0  %use data analysis folder 
b=strfind(rawpath,'\');
subject=rawpath((b(2)+1):b(3)-1);
datei=rawpath((b(3)+1):b(4)-1);
filename=rawpath((b(4)+1):b(5)-1);
else    
a=strfind(rawpath,'\');
b=strfind(rawpath,'data');
if length(a)==5
datei=rawpath(((a(3)+1):(a(4)-1)));
elseif length(a)==3
datei=rawpath(((a(2)+1):(a(3)-1))); 
end
c=strfind(rawpath,datei);
d=strfind(fname,'_t');
filename=fname(1:(d-1));
subject=rawpath((b+5):(c-2));
date=rawpath(((a(4)+1):((a(5)-1))));
end
a=strfind(fname,'_t');
b=strfind(fname,'.');
trial=str2num(fname((a+2):(b-1)));
%***end file selection.

if trial<10
datafilename=[rawpath filename '_t0' num2str(trial)];
else
datafilename=[rawpath filename '_t' num2str(trial)];
end

disp(['loading ' datafilename])

newchannels=[];   %removes bad channels.
for i=1:length(channels);
   chani=channels(i);
    foundmatch=0;
    for j=1:length(badchannels);
        badchanj=badchannels(j);
        if chani==badchanj
        foundmatch=foundmatch+1;
        end
    end
    if foundmatch==0
        newchannels=[newchannels chani];
    end
end
channels=newchannels;

backgroundchans1=setdiff(backgroundchans1,badchannels);  %removes badchannels from the list of background-removal channels.
origbackgroundchans=backgroundchans1;
muxifiles=unique(ceil(channels/32));  %specifies which dot muxi files to open for plotting
        
Data=[]; noise=[];
for i=1:length(muxifiles);
    
muxi=muxifiles(i);     
datafile=[datafilename '.mux' num2str(muxi)]; 
if exist(datafile,'file')==0
continue
end  

fid = fopen(datafile,'r','b');
data = fread(fid,[1,inf],'int16');    
fclose(fid);
data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

muxichans=channels(find(channels<(32*muxi+1) & channels>32*(muxi-1)))-32*(muxi-1);
time=0:1/samplingrate:(length(data)-1)/samplingrate/32;
previousbackgroundchans=[];
for chanind=1:length(muxichans);
channel=muxichans(chanind);
origchannel=channel;
absolutechan=muxichans(chanind)+(muxi-1)*32;

            if length(uniqueshafts)>1
            currentshaft=s.shaft(absolutechan);
            chansonshaft=s.channels(find(s.shaft==currentshaft));
            else chansonshaft=channels;
            end
            backgroundchans=intersect(chansonshaft,origbackgroundchans);
            muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.
            
            if length(setdiff(backgroundchans,previousbackgroundchans))>0  %only loads new backgroundchannels if the channel is on a different shaft.
                if length(backgroundchans)>0;
                backgndsignal_muxi
                else
                backgnddata=0;
                end   
            end
            
            previousbackgroundchans=backgroundchans;
            channel=origchannel;

    muxi_numbering
     
    datach=datach-backgnddata;  %subtracts the background channel if backgroundchans were specified.
    datach=datach-mean(datach); 
    remove_laserartifacts  %optional: removes mean laser artifact found in get_laserartifacts. introduced Jan 20 2013.
    
%****Apply bandpass filters******
if dofilter=='y'
Wn = [f_low f_high]/(samplingrate/2); 
[b,a] = butter(n,Wn); %finds the coefficients for the butter filter
datach = filtfilt(b, a, datach); %zero-phase digital filtering
end
%*************end filters*********

datach=1e6*datach;  %converts data to microvolts.
noise(absolutechan)=std(datach);
Data{absolutechan}=datach;    %Data with capital 'D' is a matrix with indices corresponding to the demultiplexed channel elements; e.g. Data{32} accesses the signal for channel 32.

clear datach
end
end
clear data


%***Plots data***
screenres=[1024 768];   %frame pixel resolution
close all; warning off;

time=tmin:1/samplingrate:(tmax-1/samplingrate);
t0=tmin*samplingrate+1;
tf=tmax*samplingrate;

fig1=figure(1); 
hold on
for shaftind=1:length(uniqueshafts);
    currentshaft=uniqueshafts(shaftind);
    if length(uniqueshafts)>1
    allchansonshaft=s.channels(find(s.shaft==currentshaft));
    [sortedz, sortinds]=sort(s.z(allchansonshaft));
    allchansonshaft=allchansonshaft(sortinds);
    else allchansonshaft=channels;
    end
    chansonshaft=setdiff(allchansonshaft,badchannels, 'stable');
    subplot(1,length(uniqueshafts),shaftind)
    for chi=1:length(chansonshaft);
        channel=chansonshaft(chi);
        plot(time, Data{channel}(t0:tf)-mean(Data{channel})+offset*chi,'Color', 'k')      
        hold on
    end
    
    if strcmp(stimtype,'none')==0
    stimfile=[datafilename '.' stimtype]; 
    
        if exist([stimfile],'file')>0
        fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
        stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
        fclose(fid);
        stim=offset*stim/stim_multfactor;
    
        stim_t0=(tmin)*stimsamplingrate+1;
        stim_tf=(tmax-1)*stimsamplingrate;  %have to shift stimulus forward by 1 sec to align to ephys data.
        stim=stim(stim_t0:stim_tf);
    
        stimtimebins=(tmin+1):1/stimsamplingrate:(tmax-1/stimsamplingrate);
        plot(stimtimebins,stim+offset*(length(chansonshaft)+1),'r')
    
        end
    end

    if strcmp(stimtype,'none')==0 & exist([stimfile],'file')>0
    axis([tmin tmax -200 length(allchansonshaft)*(offset+1)+200])
    else
    axis([tmin tmax -200 length(allchansonshaft)*offset+200])
    end
    axis tight
    xlabel(['time (sec)'],'FontSize',10) 
    ylabel(['Voltage ' '(' '\mu' 'V)'],'FontSize',10)
    title(['Shaft ' num2str(currentshaft) ', chs ' num2str(min(allchansonshaft)) '-' num2str(max(allchansonshaft))])
    set(gca,'FontSize',10,'TickDir','out')

end



%***end plotting.


disp(['done.'])
