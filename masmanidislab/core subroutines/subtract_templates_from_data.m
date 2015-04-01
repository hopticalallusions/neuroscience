        sot3=[];
        
        for fixind=1:length(spiketimes);
            fixtime=spiketimes(fixind);
            
%             offseti=jitter(fixind);   %peakposition(i)-leftpoints*upsamplingfactor;
%                 if abs(offseti)<=upsamplingfactor;
%                     t0=upsamplingfactor+offseti;
%                     tf=lengthperchan-upsamplingfactor+offseti;   
%                 else                    
%                     t0=upsamplingfactor;
%                     tf=lengthperchan-upsamplingfactor;
%                 end
                     
            for fixchanind=1:length(dochannels);
                fixchan=dochannels(fixchanind);
                
%                 t02=t0+(fixchanind-1)*lengthperchan;       
%                 tf2=tf+(fixchanind-1)*lengthperchan;

            t0=lengthperchan*(fixchanind-1)+1;
            tf=lengthperchan*fixchanind;
%                   
                recuttemp=newmeans(t0:tf);
%                 realignedtemplate=newmeans(t02:tf2);   %aligned waveform.  
%                 decimatedtemplate=decimate(realignedtemplate,upsamplingfactor);
                decimatedtemplate=decimate(recuttemp,upsamplingfactor);
                pktopk_template=range(recuttemp);
                
                absolt0=fixtime-leftpoints+1;  %-1
                absoltf=absolt0+leftpoints+rightpoints-1;
               
%                 absolt0=fixtime-ceil(t0/upsamplingfactor)-leftpoints+upsamplingfactor+1;  %-1
%                 absoltf=absolt0+floor(tf/upsamplingfactor)-1;
                
                datarange=(absolt0:absoltf);
                datarange=datarange(1:length(decimatedtemplate));
                pktopk_data=range(datarange);
                
                amp_normfactor=pktopk_data/pktopk_template;    %added Nov 7 2011, to make template subtraction smoother.
                
%                 if fixchan==35
%                 sot3=[sot3;  datadochannels{fixchan}(datarange)];
%                 end
                
                datadochannels{fixchan}(datarange)=datadochannels{fixchan}(datarange)-amp_normfactor*decimatedtemplate;    %can try amp_normfactor, but this has not been tested. 
                
            end
        end
                clear realignedtemplate decimatedtemplate