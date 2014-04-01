%extracts waveforms and spike parameters (variables 'waveforms' and 'spikeamps')

wavejitter=[];
parfor i=1:numberofspikes;
       
        ampsperspike=ampsallchans(:,i);
        bestchani=find(abs(ampsperspike)==max(abs(ampsperspike)));
        bestchannel=dochannels(bestchani);
        
        fromind=stimes(i)-leftpoints;   
        toind=stimes(i)+rightpoints;
        datach=datadochannels{bestchannel};
        waveformi=datach(fromind:toind);  
        
        waveformi=interp(waveformi,upsamplingfactor);
        
        t0=(leftpoints-extraleft)*upsamplingfactor;   %default:  t0=(leftpoints-1)*upsamplingfactor;
        tf=(leftpoints+extraright)*upsamplingfactor;   %default:  tf=(leftpoints+1)*upsamplingfactor; 
        wavetest=waveformi(t0:tf);   %aligned waveform.  
            
%       peakpos=find(waveformi==min(wavetest));  %default (only looks at negative peak)

        if min(wavetest)<-detectthreshold        %first tries to align on negative peak, if that fails aligns on positive peak.   
            peakpos=find(waveformi==min(wavetest));
        else peakpos=find(waveformi==max(wavetest));
        end
                                            
        wavejitter(i)=leftpoints*upsamplingfactor-peakpos;   %note: wavejitter remains upsampled, so to get time in correct units must divide by upsamplingfactor & samplingrate.
                  
end       