%extracts spike parameters (variables 'waveforms' and 'spikeamps')

for i=1:numberofspikes;  
%            if amplitudemethod==1;  %take amplitude range within -rightpoints / +leftpoints
%                minampi=datach(stimes(i));
%                if minampi<0;  %finds max value if spike is negative, and min value if spike is positive.
%                maxampi=max(datach((stimes(i)-leftpoints):(stimes(i)+rightpoints)));  
%                else maxampi=min(datach((stimes(i)-leftpoints)):(stimes(i)+rightpoints));
%                end
%                spikeampsi=maxampi-minampi;               
%            elseif amplitudemethod==2;
%                spikeampsi=datach(stimes(i));  %take exact value at peak.   
%                
%            elseif amplitudemethod==3;   %3/12/11
           t0=stimes(i)-extraleft;   
           tf=stimes(i)+extraright;    
           wavetest=datach(t0:tf);   %aligned waveform.           
%            spikeampsi=abs(min(wavetest));   %default  
%            end

           if min(wavetest)<-detectthreshold        %first tries to align on negative peak, if that fails aligns on positive peak.   
           spikeampsi=abs(min(wavetest));
           else spikeampsi=abs(max(wavetest));
           end
           
           spikeamps=[spikeamps, spikeampsi];
          
end    
