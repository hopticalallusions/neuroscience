%***Removes small time differences arising from detecting same unit on multiple channels in the set.***
%***Selects only the spike on the channel corresponding to the highest amplitude event.***

%Massive overhaul 7/12/12 to avoid memory overload on Dec6b dataset. Note: now only detect negative peak.
nspikesbeforeprune=length(timesperchan);
uniqueshafts=unique(shaftperspike);
timesperchan=sort(timesperchan);
timesperchan=unique(timesperchan);   %remove identical spike times occuring on dochannels.

%first round
difftimes=diff(timesperchan);
overlaps=find(difftimes<rejecttime);          %indices of spike which has isi<rejecttime with another spike.
timesperchan(overlaps)=[];  %removes duplicate events found on multiple channels.
timesperchan=sort(timesperchan); 
nspikesafterprune=length(timesperchan);

disp(['*assigning unique electrode channel to ' num2str(nspikesafterprune) ' spikes in trial ' num2str(trial) '.'])
rangesinchani=[];
for chanind=1:length(dochannels);
channeli=dochannels(chanind);
rangesinchani{channeli}=[];
end

addtimes=[]; 
    for j=1:length(timesperchan);    %checks amplitude of dochannels at each time; selects only the time corresponding to the highest amplitude event.
        timej=timesperchan(j);
         bestamp=0; 
         for chanind=1:length(dochannels);
         channeli=dochannels(chanind);
         datachani=datadochannels{channeli};
         ampchanitimej=datachani(timej);
         
         rangechanitimej=range(datachani((timej-leftpoints):(timej+rightpoints)));
         rangesinchani{channeli}=[rangesinchani{channeli} rangechanitimej];
                    if rangechanitimej>bestamp;      %edited 11/11/11 to align times on negative peak, even if +ve peak is higher.
                    bestamp=rangechanitimej;
                    bestchan=channeli;
                    besttime=timej;    
                    end                  
         end
         
         addtimes=[addtimes besttime];
         multibestchannels=[multibestchannels bestchan];

    end
     
    for chanind=1:length(dochannels);
    channeli=dochannels(chanind);
    amprange{channeli}=[amprange{channeli} mean(rangesinchani{channeli})];     %mean amplitude range on each channel per trial; if did for each spike would generate very large files.
    end    
       
clear datachani
timesperchan=addtimes;
stimes=timesperchan;   %relative spike times.  (t=0 at beginning of each trial).
% %********************
