%new channelsets.

finaldepthzones=sort(unique(depthzones));%-tipelectrode;
channelsets=[];
setcounter=1;
for z=1:length(finaldepthzones)-1;
    mindepth=finaldepthzones(z);
    maxdepth=finaldepthzones(z+1);
    channelsinzone=find(s.z<maxdepth+zoneoverlap & s.z>mindepth-zoneoverlap);   
    checkchans=setdiff(channelsinzone,badchannels);
         
        uniqueshafts=unique(s.shaft(channelsinzone));  %list of shafts containing any good channels between mindepth and maxdepth.
        numberofshafts=length(uniqueshafts);   %number of shafts containing any good channels between mindepth and maxdepth.
        for shaftind=1:numberofshafts
            currentshaft=uniqueshafts(shaftind);
            subset_onshaft=intersect(channelsinzone, find(s.shaft==currentshaft));
            
            goodchans=setdiff(subset_onshaft, badchannels);  %July 27 2012
         
            if length(goodchans)>0 & length(checkchans)>0 
            channelsets{setcounter}=goodchans';   
            setcounter=setcounter+1;               
            end   
        end
end

newchannelsets=[];
channelsetcounter=1;
for i=1:length(channelsets)   %removes channel sets that are part of other sets.
    uniqueset=1;
    for j=2:length(channelsets)
        if i<=j   %note this is different in the next section.
            continue
        end
    differentchannels=setdiff(channelsets{i},channelsets{j});
    if length(differentchannels)==0
        uniqueset=0;
    end
          
    end
    
    if uniqueset==1
        newchannelsets{channelsetcounter}=channelsets{i};
        channelsetcounter=channelsetcounter+1;
    end
end
channelsets=newchannelsets;

newchannelsets=[];
channelsetcounter=1;
for i=1:length(channelsets)   %removes channel sets that are part of other sets.
    uniqueset=1;
    for j=2:length(channelsets)
        if i>=j   %note this is different from previous section.
            continue
        end
    differentchannels=setdiff(channelsets{i},channelsets{j});
    if length(differentchannels)==0
        uniqueset=0;
    end
          
    end
    
    if uniqueset==1
        newchannelsets{channelsetcounter}=channelsets{i};
        channelsetcounter=channelsetcounter+1;
    end
end
channelsets=newchannelsets;



clear newchannelsets

disp([num2str(length(channelsets)) ' channel sets.'])
