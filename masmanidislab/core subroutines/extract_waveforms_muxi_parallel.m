%extracts waveforms and spike parameters (variables 'waveforms')
%extraleft & extraright specified in spikesort_muxi.

parfor i=1:numberofspikes;     
            
   fromind=stimes(i)-(leftpoints+extraleft-1);       % fromind=stimes(i)-leftpoints;  
   toind=stimes(i)+(rightpoints+extraright-1);       % toind=stimes(i)+rightpoints;
   waveformi=datach(fromind:toind);          
   waveformi=interp(waveformi,upsamplingfactor);
            
   t0=-wavejitter(i)+(2+extraleft)*upsamplingfactor;                    % t0=-wavejitter(i)+3*upsamplingfactor;
   tf=length(waveformi)-wavejitter(i)-(extraright)*upsamplingfactor;    % tf=length(waveformi)-wavejitter(i)-upsamplingfactor;
        
   waveformi=waveformi(t0:tf);   %aligned waveform.  
        
   if doupsampling=='n'  %used in make_seed_templates
   waveformi=decimate(waveformi,upsamplingfactor);  %re-decimates waves.
   end

   waveforms=[waveforms; waveformi];
              
end    
          