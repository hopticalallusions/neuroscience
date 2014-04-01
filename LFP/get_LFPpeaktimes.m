currentvoltagefile=['LFPvoltage_ch' num2str(chan) '.mat'];
load([LFPvoltagedir currentvoltagefile]); 
dofilter_LFP

stdLFPvoltage=std(LFPvoltage);     
LFPdetectthreshold=LFPthreshold*stdLFPvoltage;    
    
[pks,LFPpktimes]=findpeaks(LFPvoltage,'minpeakheight',LFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));  %note the voltage is essentially converted into z-score because mean(LFP)~0.