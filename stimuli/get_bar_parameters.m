['getting visual grating stimulus parameters.']
set_plot_parameters

stim_multfactor=16384;
stim_decimatefactor=10;
convertangleconst=300; %0 for Mar9, 300 for Mar19

stim_samplingrate=samplingrate/stim_decimatefactor;
angledivision=30;  %default=30.
min_peakdist=floor(stim_samplingrate/360);
stim_pctile=90;
maxtrial=parameters.maxtrial;

vis_stim=[];
for iterations=1:maxtrial;
trial=dotrials(iterations);
  
if trial<10;
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end
  
datafilename=[rawpath filename '_t' trialstring];

stimfile=[datafilename '.stim'];   
if exist([stimfile],'file')>0
   
fid = fopen(stimfile,'r','b');
stim = fread(fid,[1,inf],'int16');    
fclose(fid);

stim=decimate(stim,stim_decimatefactor);

vis_stim=[vis_stim stim/stim_multfactor];

end

end

detectthreshold=prctile(vis_stim,stim_pctile);

[pks,pktimes]=findpeaks(vis_stim,'minpeakheight',detectthreshold,'minpeakdistance',min_peakdist);   %always detects on negative peak, regardless of multfactor.
                           
difftimes=diff(pktimes);
bigdiffs=find(difftimes>stim_samplingrate);

trialstarttimes=[pktimes(1) pktimes(bigdiffs+1)];   %start time of new visual stimulus presentation.

freqpertrial=[]; trialendtimes=[];
for stimtrial=1:length(trialstarttimes);
    
    starttriali=trialstarttimes(stimtrial);

    if stimtrial<length(trialstarttimes)
    timestriali=pktimes(find(pktimes>=starttriali & pktimes<trialstarttimes(stimtrial+1)));
    else 
    timestriali=pktimes(find(pktimes>=starttriali));
    end

    trialendtimes=[trialendtimes max(timestriali)];
    stimsegment=vis_stim(min(timestriali):(max(timestriali)));
    L=length(stimsegment);
    NFFT=2^nextpow2(L); % Next power of 2 from length of y
    Y=fft(stimsegment,NFFT)/L;
    f=stim_samplingrate/2*linspace(0,1,NFFT/2+1);
    Y(1)=0; %remove peak at zero.
    b=find(abs(Y)==max(abs(Y)));
    meanfreq=f(b(1));
%     meanfreq=round(meanfreq/angledivision)*angledivision;
    freqpertrial=[freqpertrial meanfreq];
    
end

trialstarttimes=trialstarttimes/stim_samplingrate;
trialendtimes=trialendtimes/stim_samplingrate;

anglepertrial=round(freqpertrial); 

newanglepertrial=anglepertrial;
uniqueangles=unique(anglepertrial);
realangles=[0:angledivision:330];   
for ind=1:length(uniqueangles);     %correctly converting sine wave frequency to angle in degrees.
    anglei=uniqueangles(ind);
    realanglei=realangles(ind);
    subinds=find(anglepertrial==anglei);
    newanglepertrial(subinds)=realanglei;
end
anglepertrial=newanglepertrial;
    
stimuli=[];
stimuli.vis_stim=vis_stim;
stimuli.detectthreshold=detectthreshold;
stimuli.peaktimes=pktimes;
stimuli.trialstarttimes=trialstarttimes;
stimuli.trialendtimes=trialendtimes;
stimuli.anglepertrial=anglepertrial;
stimuli.stim_multfactor=stim_multfactor;
stimuli.stim_decimatefactor=stim_decimatefactor;
stimuli.stim_samplingrate=stim_samplingrate;

mkdir(stimulidir)
save([stimulidir 'stimuli.mat'],'stimuli','-mat')

['done getting visual stimuli.']
    