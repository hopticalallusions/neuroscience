    
set_plot_parameters

LFPpercentile=68;
LFPthreshold=5;             %default=3. used in spike_LFP or other programs that rely on finding high amplitude LFP states.

preLFPpeaktime=0;          %used in getting peri-event LFP peak times
postLFPpeaktime=5;         %used in getting peri-event LFP peak times

phaseincrement=15;         %default=15 degrees. used in spike-LFP anLFPleftpoints=0.5;         %must be positive. default=0.5 s. duration to plot around LFP peaks in spike_LFP.
LFPleftpoints=5;
LFPrightpoints=5;        %must be positive. default=0.5 s.

xdiv=0.5; %units in seconds.
ydiv=0.1;  %units in mm.
timebinsize=0.01;
trigbinsize=0.02;          %default=0.005; bin size for counting spikes triggered to LFP peaks.
%************************************************

load([LFPdir 'LFPparams.mat'])
load([timesdir 'finalspiketimes.mat'])
load([savedir 'final_params.mat']);  %loads parameters file.
load([savedir 'units\wave specs\' 'spikeposition' '.mat'])
load([stimulidir 'stimuli.mat'])

dochannels=setdiff(s.channels,badchannels);
select_dounits

LFPsamplingrate=LFPparameters.samplingrate;
roughyposition=spikeposition.y;
halfwidth=parameters.wavespecs.halfwidth;

phasebins=[0:phaseincrement:(360-phaseincrement)];  

trigtimebins=-LFPleftpoints:trigbinsize:LFPrightpoints;

fi=(0:1:360)*pi/180;
cosineref=cos(fi);

uniquedepths=unique(s.y);
probedepths=-(uniquedepths-max(uniquedepths)-tipelectrode)/1000;
timebins=-LFPleftpoints:timebinsize:LFPrightpoints;

% [refvoltagefile, LFPvoltagedir]=uigetfile({[LFPvoltagedir '*.mat']},'Select a channel to use as a reference for LFP analysis');
% prechtxt=findstr(refvoltagefile,'_ch');
% postchtxt=findstr(refvoltagefile,'.mat');
% refchan=str2num(refvoltagefile((prechtxt+3):(postchtxt-1)));
%
% LFPpktimes=[];
% for chanind=1:length(dochannels);
% chanj=dochannels(chanind);
% 
% currentvoltagefile=[refvoltagefile(1:(prechtxt+2)) num2str(chanj) '.mat'];
% load([LFPvoltagedir currentvoltagefile]); 
% dofilter_LFP
% LFPdetectthreshold=LFPthreshold*prctile(LFPvoltage,LFPpercentile); %2nd detection method: percentile (should be less sensitive to real fluctuations).
% [pks,LFPpktimes{chanj}]=findpeaks(LFPvoltage,'minpeakheight',LFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/10));  %default division factor=10. note the voltage is essentially converted into z-score because mean(LFP)~0.
% disp(['channel ' num2str(chanj) ', ' num2str(length(LFPpktimes{chanj})) ' peaks.'])
% end
% 
maxtimediff=1/25;
globalLFPpktimes=[];

refchan1=60;
ref1pktimes=LFPpktimes{refchan1}/LFPsamplingrate;
refchan2=33;
ref2pktimes=LFPpktimes{refchan2}/LFPsamplingrate;

for i=1:length(ref1pktimes);
    timei=ref1pktimes(i);
    numbermatches=0;
    foundmatch=find(abs(ref2pktimes-timei)<=maxtimediff); 
    if length(foundmatch)>0
     globalLFPpktimes=[globalLFPpktimes round(timei*LFPsamplingrate)];   
    end
end
            
ref1voltagefile=[refvoltagefile(1:(prechtxt+2)) num2str(refchan1) '.mat'];
load([LFPvoltagedir ref1voltagefile]); 
dofilter_LFP
LFPvoltage1=LFPvoltage;

ref2voltagefile=[refvoltagefile(1:(prechtxt+2)) num2str(refchan2) '.mat'];
load([LFPvoltagedir ref2voltagefile]); 
dofilter_LFP
LFPvoltage2=LFPvoltage;


LFPpeaktimeoffset1=[]; LFPpeaktimeoffset2=[];
for i=1:length(globalLFPpktimes)
     timei=globalLFPpktimes(i);
     t0=timei-round(maxtimediff*LFPsamplingrate);
     tf=timei+round(maxtimediff*LFPsamplingrate);
     
     LFPvoltage1i=LFPvoltage1(t0:tf);
     peaktimei=find(LFPvoltage1i==max(LFPvoltage1i));
     LFPpeaktimeoffset1=[LFPpeaktimeoffset1 peaktimei-round(maxtimediff*LFPsamplingrate)];
     
     LFPvoltage2i=LFPvoltage2(t0:tf);
     peaktimei=find(LFPvoltage2i==max(LFPvoltage2i));
     LFPpeaktimeoffset2=[LFPpeaktimeoffset2 peaktimei-round(maxtimediff*LFPsamplingrate)];
end
            
            


