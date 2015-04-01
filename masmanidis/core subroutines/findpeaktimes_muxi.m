% if max(find(abs(datach)>detectthreshold))>minoverlap & length(find(abs(datach)>detectthreshold))>1  %ensures there are enough points (at least two) to use findpeaks.
if max(find(abs(datach)>detectthreshold))>minoverlap & length(find(datach((leftpoints+extraleft):(length(datach)-rightpoints-extraright))<-1*detectthreshold))>1  %ensures there are enough points (at least two) to use findpeaks.
     
%     [pks,spiketimes]=findpeaks(multfactor(absolutechan)*datach,'minpeakheight',detectthreshold,'minpeakdistance',minoverlap);   %default peak detection.
%October 23 2011 note: there is a problem with template matching of positive peaks, because the
%templates are always aligned to the waveform minimum.  Until this is
%fixed, I'm always detecting on the negative peak.

% [pks,posspiketimes]=findpeaks(datach,'minpeakheight',detectthreshold,'minpeakdistance',minoverlap);   %always detects on negative peak, regardless of multfactor.
[pks,negspiketimes]=findpeaks(-1*datach,'minpeakheight',detectthreshold,'minpeakdistance',minoverlap);   %always detects on negative peak, regardless of multfactor.
% spiketimes=[posspiketimes negspiketimes];
spiketimes=negspiketimes;

% [pks,spiketimes]=findpeaks(-1*datach,'minpeakheight',detectthreshold,'minpeakdistance',minoverlap);   %always detects on negative peak, regardless of multfactor.

                    

%***removes spikes that occur too close to start or end, because this causes problem in waveform extraction***
a=find(spiketimes>=length(datach)-(rejecttime+rightpoints+extraright+upsamplingfactor));
b=find(spiketimes<=(rejecttime+leftpoints+extraleft+upsamplingfactor));
spiketimes=setdiff(spiketimes,spiketimes(a));
spiketimes=setdiff(spiketimes,spiketimes(b));

else spiketimes=[];
end