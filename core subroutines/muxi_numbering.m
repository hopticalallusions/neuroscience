datach=data(channel:32:length(data));  %demultiplexing. 

%old numbering scheme:
%  if mod(muxi,2)==1  %muxi==1
%     datach=data(channel:32:length(data));  %demultiplexing. 
%     elseif mod(muxi,2)==0  %muxi>1
%     channel=channel-1;
%             if channel==0;
%                 channel=32;
%             end
%     datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
% end

% % %option for data collected between Mar 5 2014 and Mar 15 2014.
% if channel==32;
%     newchan=1;
% else newchan=channel+1;
% end
% % 
% datach=data(newchan:32:length(data));  %demultiplexing. 
% % 
