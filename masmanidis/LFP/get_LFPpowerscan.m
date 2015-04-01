n_LFP=3;
dochannels=[s.channels]; 

dochannels=setdiff(dochannels,badchannels);   %removes any channels from set that are not considered good channels.

LFPpowerscan=[];
for chani=1:length(dochannels);
    chan=dochannels(chani);
    load([LFPvoltagedir 'LFPvoltage_ch' num2str(chan) '.mat']); 
    
    f_low_LFP=1;
    f_high_LFP=4;
    
    Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
    [b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
    LFPvoltagej = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering
    meanLFPvoltagej=mean(LFPvoltagej.^2);
    stdLFPvoltagej=std(LFPvoltagej.^2);
    
    LFPpowerscan.delta.mean{chan}=meanLFPvoltagej;
    LFPpowerscan.delta.std{chan}=stdLFPvoltagej;
    
    f_low_LFP=6;
    f_high_LFP=10;
    
    Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
    [b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
    LFPvoltagej = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering
    meanLFPvoltagej=mean(LFPvoltagej.^2);
    stdLFPvoltagej=std(LFPvoltagej.^2);
    
    LFPpowerscan.theta.mean{chan}=meanLFPvoltagej;
    LFPpowerscan.theta.std{chan}=stdLFPvoltagej;
    
    f_low_LFP=12;
    f_high_LFP=25;
    
    Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
    [b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
    LFPvoltagej = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering
    meanLFPvoltagej=mean(LFPvoltagej.^2);
    stdLFPvoltagej=std(LFPvoltagej.^2);
    
    LFPpowerscan.beta.mean{chan}=meanLFPvoltagej;
    LFPpowerscan.beta.std{chan}=stdLFPvoltagej;
    
    f_low_LFP=35;
    f_high_LFP=45;
    
    Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
    [b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
    LFPvoltagej = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering
    meanLFPvoltagej=mean(LFPvoltagej.^2);
    stdLFPvoltagej=std(LFPvoltagej.^2);
    
    LFPpowerscan.gamma40.mean{chan}=meanLFPvoltagej;
    LFPpowerscan.gamma40.std{chan}=stdLFPvoltagej;
    
    f_low_LFP=55;
    f_high_LFP=65;
    
    Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
    [b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
    LFPvoltagej = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering
    meanLFPvoltagej=mean(LFPvoltagej.^2);
    stdLFPvoltagej=std(LFPvoltagej.^2);
    
    LFPpowerscan.gamma60.mean{chan}=meanLFPvoltagej;
    LFPpowerscan.gamma60.std{chan}=stdLFPvoltagej;
    
    f_low_LFP=80;
    f_high_LFP=100;
    
    Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
    [b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
    LFPvoltagej = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering
    meanLFPvoltagej=mean(LFPvoltagej.^2);
    stdLFPvoltagej=std(LFPvoltagej.^2);
    
    LFPpowerscan.gamma90.mean{chan}=meanLFPvoltagej;
    LFPpowerscan.gamma90.std{chan}=stdLFPvoltagej;
     
end

LFPpowerscan.probetype=probetype;
LFPpowerscan.dochannels=dochannels;
LFPpowerscan.badchannels=badchannels;
LFPpowerscan.x=s.x;
LFPpowerscan.z=s.z;
LFPpowerscan.tipelectrode=tipelectrode;


save([LFPdir 'LFPpowerscan.mat'],'LFPpowerscan', '-mat');  %saves file.
