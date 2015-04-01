eventtimek=event2times(trialk);

event1_near_event2=find(abs(event1times(doevent1trials)-eventtimek)<meancuesoldelay);
if strcmp(triggerevent2,'startlicking') & length(event1_near_event2)>0    %added on 26/9/13 to align licking to cues. for each trial shift lick rate by the licking onset time.
eventtimek=eventtimek-meanlickonset;
elseif strcmp(triggerevent2,'startlicking') & length(event1_near_event2)==0
% disp(['skipping trial ' num2str(trialk) ' in event 2'])
continue
end