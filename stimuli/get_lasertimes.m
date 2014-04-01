lasertimes=[];
lasertimes.pulsetrainstart=[];  %start time of first pulse in a train of pulses
lasertimes.pulseduration=[]; %pulse duration within each pulse train.
lasertimes.pulsetimes=[];  %all pulse onset times in a train; can use this to get number of pulses and frequency per train.
if max(laser_stim)>laserthreshold
difflaser_stim=diff(laser_stim);
laserontimes=find(difflaser_stim>2);
laserofftimes=find(difflaser_stim<-2);
laserontimes=laserontimes/stimsamplingrate;
laserofftimes=laserofftimes/stimsamplingrate;

lasertimes.laserontimes=laserontimes;
% endoflaserpulsetrains=[1 find(diff(laserontimes)>5)];
endoflaserpulsetrains=[find(diff(laserontimes)>5)];
    for i=1:(length(endoflaserpulsetrains));
        if i==1
        lasertimes.pulsetrainstart(i)=laserontimes(1);
        lasertimes.pulseduration(i)=laserofftimes(1)-laserontimes(1);
        lasertimes.pulsetimes{i}=laserontimes(1:endoflaserpulsetrains(i+1));
        elseif i==(length(endoflaserpulsetrains))
        lasertimes.pulsetrainstart(i)=laserontimes(endoflaserpulsetrains(i)+1);
        lasertimes.pulseduration(i)= laserofftimes(endoflaserpulsetrains(i))-laserontimes(endoflaserpulsetrains(i));
        lasertimes.pulsetimes{i}=laserontimes((endoflaserpulsetrains(i)+1):length(laserontimes));   %groups laser on times into laser pulse trains   
        else
        lasertimes.pulsetrainstart(i)=laserontimes(endoflaserpulsetrains(i)+1);
        lasertimes.pulseduration(i)= laserofftimes(endoflaserpulsetrains(i))-laserontimes(endoflaserpulsetrains(i));
        lasertimes.pulsetimes{i}=laserontimes((endoflaserpulsetrains(i)+1):endoflaserpulsetrains(i+1));   %groups laser on times into laser pulse trains
        end
    end 
    
disp(['found ' num2str(length(lasertimes.pulsetrainstart)) ' laser pulses.'])    
end

if length(lasertimes.pulsetrainstart)==0 & length(laser_stim)>0
    disp(['did not detect any TTL laser pulses...looking for frequency sweeps.'])
    get_lasersweep
end