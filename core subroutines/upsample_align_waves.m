if doneupsampling=='n'
    
upmeanspikes=[];
upwavesize=size(meanspikes,2)*upsamplingfactor/length(dochannels);
for waveind=1:size(meanspikes,1);
    templatei=meanspikes(waveind,:);
    upsampledwavei=interp(templatei,upsamplingfactor);  %upsample

%     peakloc=find(abs(upsampledwavei)==max(abs(upsampledwavei)));    
%     bestchani=ceil(peakloc/upwavesize);    
%     expectedpeakloc=(leftpoints+rightpoints+1)*(bestchani-1)*upsamplingfactor+leftpoints*upsamplingfactor+1;
%     peakoffset=peakloc-expectedpeakloc;   

       peakoffset=0;  %3/12/11
              
        upwavei=[];
        if abs(peakoffset)<upsamplingfactor
        
            for segmenti=1:length(dochannels);
            t0=(segmenti-1)*upwavesize+1+peakoffset;                     % t0=(segmenti-1)*upwavesize+1+upsamplingfactor+peakoffset;
            tf=segmenti*upwavesize+1-upsamplingfactor+peakoffset;        % tf=segmenti*upwavesize+1+peakoffset;
            wavesegmenti=upsampledwavei(t0:tf);
            upwavei=[upwavei wavesegmenti];
            end
            
            upsampledwavei=upwavei;
            
        else 
            
             for segmenti=1:length(dochannels);
             t0=(segmenti-1)*upwavesize+1+0;                             % t0=(segmenti-1)*upwavesize+1+upsamplingfactor+0;
             tf=segmenti*upwavesize+1-upsamplingfactor+0;                % tf=segmenti*upwavesize+1-upsamplingfactor+0;
             wavesegmenti=upsampledwavei(t0:tf);
             upwavei=[upwavei wavesegmenti];
             end
             
             upsampledwavei=upwavei;
             
        end
        
upmeanspikes=[upmeanspikes; upsampledwavei];
end

meanspikes=upmeanspikes;
clear upmeanspikes;

doneupsampling='y';

end
