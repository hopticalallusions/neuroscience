%***Set plot parameters**********
tmin=200; 
tmax=220;             %specify time range to plot relative to beginning of recording (will automatically calculate correct trial). note: tmax-tmin must be > 1 sec.

stimtype='laser';     %options: 'none', 'cue1', 'cue2', 'cue3', 'cue4', 'solenoid', 'lick', 'laser', 'motiony'.

offset=100;                 %plot voltage offset in microvolts.

dofilter='y';               %'y' or 'n' to either do or not do bandpass filtering.  You must do at least highpass filtering to make sense of the data.
f_low=600;                  %hiphpass filter frequency.  default=600.
f_high=6500;                %lowpass filter frequency.  default=6500.
n=3;                        %number of poles of Butterworth filter.  default=3.

%***end setting parameters****

samplingrate=25000;     %default=25000 (i.e. 1/(40e-6 seconds);
backgroundchans1=['all'];            %default=['all']. can leave empty or write numeric list. The channels in the current set are not used in backgroundchans.  badchannels are removed from this list.
laser_artifact_removal='n';
scrsz=get(0,'ScreenSize');

recall_rawpath

remember_rawpath

datadir=[datadrivedir ':\muxi data\' experiment '\' subject '\' datei '\'];
savedir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\single-unit\'];
timesdir=[savedir 'sortedtimes\'];
unitclassdir=[savedir 'properties\'];
stimulidir=[analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\stimuli\'];

qualitycutoff=1;           %default=1. unit qualities: 1, 2, 3. 1=best, 2=medium quality, 3=not single-unit. used in select_douniters.
load_results

disp(['probe type: ' probetype])

if exist([stimulidir 'laserartifacts.mat'],'file')>0 & laser_artifact_removal=='y'
disp(['doing laser artifact removal'])    
load([stimulidir 'laserartifacts.mat'])
end

%***end file selection.
trialduration=parameters.trialduration/samplingrate;
trial=floor(tmin/trialduration)+1;
disp(['plotting trial ' num2str(trial) '.'])

if trial<10
datafilename=[datadir filename '_t0' num2str(trial)];
else
datafilename=[datadir filename '_t' num2str(trial)];
end

channels=setdiff(s.channels,badchannels);
backgroundchans1=setdiff(backgroundchans,badchannels);  %removes badchannels from the list of background-removal channels.
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


screenres=[1024 768];   %frame pixel resolution
close all; warning off;

time=tmin:1/samplingrate:(tmax-1/samplingrate);
t0=tmin*samplingrate+1-(trial-1)*trialduration*samplingrate;
tf=tmax*samplingrate-(trial-1)*trialduration*samplingrate;

reltimesinplot=[]; 
for unitind=1:length(dounits);
    unitj=dounits(unitind);    
    stimesj=spiketimes{unitj};
    reltimesinplot{unitj}=stimesj(find(stimesj<tmax & stimesj>tmin));    
end   
bestchanlist=cell2mat(bestchannels);

fig1=figure(1); 
hold on

unitsplotted=[];  %list of all unique units that were plotted.
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
              
        allunitsonchan=find(bestchanlist==channel);
        goodunitsonchan=intersect(allunitsonchan,dounits);
        if length(goodunitsonchan)>0
            
            for unitind=1:length(goodunitsonchan)
                unitj=goodunitsonchan(unitind);
                reltimesunitj=reltimesinplot{unitj};
                if length(reltimesunitj)>0
                unitsplotted=[unitsplotted unitj];
                end
                relsamplesunitj=round(reltimesunitj*samplingrate-(trial-1)*trialduration*samplingrate);
                text(reltimesinplot{unitj}, Data{channel}(relsamplesunitj)+offset*chi, num2str(unitj),'Color','r','FontSize',8)
                hold on
            end     
            
        end
              
    end
                
    if strcmp(stimtype,'none')==0
        stimfile=[datafilename '.' stimtype]; 
    
        if exist([stimfile],'file')>0
        fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
        stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
        fclose(fid);
        stim=offset*stim/stim_multfactor;
    
        stim_t0=mod(tmin,trialduration)*stimsamplingrate+1;
        stim_tf=stim_t0+(tmax-tmin-1)*stimsamplingrate-1;    %have to shift stimulus forward by 1 sec to align to ephys data.
        
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
      
%     axis off
    xlabel(['time (sec)'],'FontSize',8) 
    
    if shaftind==1
    title([subject ', shaft ' num2str(currentshaft) ', ' num2str(offset) ' uV offset, ' num2str(tmax-tmin) ' s'],'FontSize',8) 
    else title(['shaft ' num2str(currentshaft)],'FontSize',9) 
    end
%     set(gca,'FontSize',8,'TickDir','out')
end

set(gcf,'Position',[-1 0 scrsz(3) scrsz(4)])

unitsplotted=unique(unitsplotted);
disp(['plot contains ' num2str(length(unitsplotted)) '/' num2str(length(dounits)) ' units.'])


