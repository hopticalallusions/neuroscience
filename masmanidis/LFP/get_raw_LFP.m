['Getting raw downsampled LFP voltages.']
%updated Dec 29 2012

%***run spikesort_muxi first.***

%*********************Set parameters for multiunit and LFP analysis********************************
do_fileselection='n';       %setting this to 'n' will use whatever savedir and raw data path are already loaded; setting to 'y' will prompt user.
% *******************Finished setting parameters***********************

disp(['downsampling LFP to ' num2str(LFPsamplingrate) ' Hz.'])
backgroundchans=[];  %backgroundchans1;  %do not do background substraction on LFP!  June 17 2012.
dochannels=[s.channels]; close all; warning off

if do_fileselection=='y'
select_datafile;
end

LFPdir
LFPEPSdir=[LFPdir 'eps\'];
LFPMfiledir=[LFPdir 'fig\'];
mkdir(LFPdir)
mkdir(LFPvoltagedir)

dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.

if length(backgroundchans)>0
    disp(['using background subtraction'])
end

LFPvoltage=[];
for chani=1:length(dochannels);
    chan=dochannels(chani);
    save([LFPvoltagedir 'LFPvoltage_ch' num2str(chan) '.mat'],'LFPvoltage', '-mat');  %saves empty file.   
end

backgroundchans=setdiff(backgroundchans,badchannels);
muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting
muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.

for muxind=1:length(muxifiles);     

muxi=muxifiles(muxind);     
muxichans=dochannels(find(dochannels<(32*muxi+1) & dochannels>32*(muxi-1)))-32*(muxi-1);  %selects only channels in the active muxi file.

for chanind=1:length(muxichans);
    
channel=muxichans(chanind);
absolutechan=muxichans(chanind)+(muxi-1)*32;
disp(['current channel: ' num2str(absolutechan)])
LFPvoltage=[];

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
%     disp(['finished analyzing last trial in data set (' num2str(trial-1) ').'])
    maxtrial=dotrials(iterations-1);    %determines maximum trial if dotrials exceed actual trials.
    break
    end
end
    
datafilename=[datadir filename '_t' trialstring];
datafile=[datafilename '.mux' num2str(muxi)];   


if length(backgroundchans)>0;
    backgndsignal_muxi
else
    backgnddata=0;
end

maxtrial=length(dotrials);


% **************load data & filter data***********
fid = fopen(datafile,'r','b');
data = fread(fid,[1,inf],'int16');    
fclose(fid);
data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

    muxi_numbering
    
    datach=datach-backgnddata;
    datach=datach-mean(datach);  %subtracts the background channel if backgroundchans were specified, also removes dc offset.;  
    datach=1e6*datach;  %convert to microvolts.
    
    if iterations==1;
    trialduration=length(datach);
    end
    
LFPdatatriali=decimate(datach,decimationfactor);   %convert to uV and decimate.
LFPdatatriali=LFPdatatriali-mean(LFPdatatriali);  %remove purely DC offset.
LFPvoltage=[LFPvoltage LFPdatatriali];
clear LFPdatatriali datach

end

save([LFPvoltagedir 'LFPvoltage_ch' num2str(absolutechan) '.mat'],'LFPvoltage', '-mat');  %save raw LFP voltage.
clear LFPvoltage
end

end

LFPparameters=[];
LFPparameters.samplingrate=LFPsamplingrate;
LFPparameters.decimationfactor=decimationfactor;

save([LFPdir 'LFPparams.mat'],'LFPparameters','-mat')   

disp(['done getting raw LFP voltages for every channel.'])

