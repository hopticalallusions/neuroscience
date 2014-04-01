%obtains the approximate positive and negative envelope function of the LFP

%************************************************

envelopedetectvoltage=5;     %default=5.

suprathreshtimes=find(LFPvoltage>envelopedetectvoltage);  %positive envelope
diffinds=diff(suprathreshtimes);
bigdiffinds=find(diffinds>LFPsamplingrate/100);
     
approxpeakinds=[];
for i=1:(length(bigdiffinds)-1)
    approxpeakinds(i)=round((bigdiffinds(i)+bigdiffinds(i+1))/2);
end
    
posLFPenvelopetimes=suprathreshtimes(approxpeakinds);
posLFPenvelopevoltage=LFPvoltage(posLFPenvelopetimes);
    
suprathreshtimes=find((-1)*LFPvoltage>envelopedetectvoltage);   %negative envelope
diffinds=diff(suprathreshtimes);
bigdiffinds=find(diffinds>LFPsamplingrate/100);
     
approxpeakinds=[];
for i=1:(length(bigdiffinds)-1)
    approxpeakinds(i)=round((bigdiffinds(i)+bigdiffinds(i+1))/2);
end
    
negLFPenvelopetimes=suprathreshtimes(approxpeakinds);
negLFPenvelopevoltage=LFPvoltage(negLFPenvelopetimes);
    
stdLFPvoltage=std(LFPvoltage);     
% minLFPdetectthreshold=minLFPthreshold*stdLFPvoltage;     %detect LFP peaks on lower bound on of threshold. note: the lower the threshold, the more the number of detected peaks.  
minLFPdetectthreshold=minLFPamp;
[pks,inds_lowerbound]=findpeaks(posLFPenvelopevoltage,'minpeakheight',minLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));           
% maxLFPdetectthreshold=maxLFPthreshold*stdLFPvoltage;  %detect LFP peaks on upper bound on of threshold. %upperbound peaks are fewer than lowerbound peaks.
maxLFPdetectthreshold=maxLFPamp;
[pks, inds_upperbound]=findpeaks(posLFPenvelopevoltage,'minpeakheight',maxLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));  

peakenvelopeinds=setdiff(inds_lowerbound,inds_upperbound);  %get the envelope peak indices that have amplitude >minLFPthreshold and <maxLFPthreshold.  
peakenvelopetimes=posLFPenvelopetimes(peakenvelopeinds);
   
% plot to look at envelope function.
% hold off
% plot(LFPvoltage,'b')
% hold on
% plot(posLFPenvelopetimes,posLFPenvelopevoltage,'r')
% hold on
% plot(peakenvelopetimes,LFPvoltage(peakenvelopetimes),'o')

