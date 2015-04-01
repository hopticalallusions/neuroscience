%***Removes small time differences arising from detecting same unit on multiple channels in the set.***
%***Selects only the time corresponding to the highest amplitude event.***

%Overhauled on 2/11/13 to detect negative AND positive peaks.

stimesdochannels=sort(stimesdochannels);
stimesdochannels=unique(stimesdochannels);   %remove identical spike times occuring on dochannels.

%first round
difftimes=diff(stimesdochannels);
overlaps=find(difftimes<rejecttime);          %indices of spike which has isi<rejecttime with another spike.
stimesdochannels(overlaps)=[];  %removes duplicate events found on multiple channels.
stimesdochannels=sort(stimesdochannels); 

addtimes=[]; 
    for j=1:length(stimesdochannels);    %checks amplitude of dochannels at each time; selects only the time corresponding to the highest amplitude event.
        timej=stimesdochannels(j);
         bestamp=0;
         for chanind=1:length(dochannels);
         channeli=dochannels(chanind);
         datachani=datadochannels{channeli};
         ampchanitimej=datachani(timej);
         
         minampchanitimej=min(datachani((timej-1):(timej+rejecttime)));  %changed from rightpoints/leftpoints to +/-6 on 22/11/11.
         maxampchanitimej=max(datachani((timej-1):(timej+rejecttime)));  %changed from rightpoints/leftpoints to +/-6 on 22/11/11.

                timejoffset=find(datachani((timej-1):(timej+rejecttime))==minampchanitimej);  %timejoffset=find(datachani((timej-leftpoints):(timej+rightpoints))==minampchanitimej);
%                     if abs(ampchanitimej)>abs(bestamp);      %edited 11/11/11 to align times on negative peak, even if +ve peak is higher.
                    if -1*ampchanitimej>abs(bestamp);      %first try to align on negative peak; if that fails try to align on positive peak. edited 11/11/11 to align times on negative peak, even if +ve peak is higher.
                    bestamp=ampchanitimej;
                    besttime=timej+timejoffset-1-1;    %besttime=timej+timejoffset-leftpoints-1;
%                     end                  
                    else 
                    timejoffset=find(datachani((timej-1):(timej+rejecttime))==maxampchanitimej);  %timejoffset=find(datachani((timej-leftpoints):(timej+rightpoints))==maxampchanitimej);
                        if ampchanitimej>abs(bestamp);      %edited 11/11/11 to always align times on negative peak, even if +ve peak is higher.
                        bestamp=ampchanitimej;
                        besttime=timej+timejoffset-1-1; %besttime=timej+timejoffset-leftpoints-1;
                        end                           
                    end
         end
         
         addtimes=[addtimes besttime];
         
    end
     
    
clear datachani
stimesdochannels=unique(addtimes);

a=find(stimesdochannels>=currenttrialduration-(rejecttime+rightpoints+extraright+upsamplingfactor));
b=find(stimesdochannels<=(rejecttime+leftpoints+extraleft+upsamplingfactor));
stimesdochannels=setdiff(stimesdochannels,stimesdochannels(a));
stimesdochannels=setdiff(stimesdochannels,stimesdochannels(b));

stimesdochannels=sort(stimesdochannels);
stimes=stimesdochannels;   %relative spike times.  (t=0 at beginning of each trial).
% %********************
