clear;

%read in the cv data
load('-ascii', 'C:\andrewhowe_blairlab\V4\3-10-2015\run\platterSimple\Stacked_DIOs');
Stacked_DIOs = Stacked_DIOs(:,1:3);

TTLdex = find(Stacked_DIOs(:,3)==0,1,'first'); %index of first detected TTL
Stacked_DIOs(:,3)=Stacked_DIOs(:,3)-1; %invert TTL values

%get first timestamp
datadir = 'C:\CheetahData\V4_twotasks_greatsharpwaves\'
[FirstStamp, HeaderVariable] = Nlx2MatCSC_v4( [datadir, 'CSC1.ncs'], [1 0 0 0 0], 1, 3, 0); %get first time stamp
[EventStamps, EventTTLs] = Nlx2MatEV_v3( [datadir, 'Events.Nev'], [1 0 1 0 0], 0, 1); %get TTL data
EV = [EventTTLs' (EventStamps - FirstStamp)'/1000000];
EventStamps = EventStamps(find(EventTTLs==1)); %find TTLS timestamps
EventStamps = (EventStamps - FirstStamp)'/1000000;

%EventStamps = EventStamps + (Stacked_DIOs(169,1) - EventStamps(1));
first_matchingstamp = 30.85;
EventStamps = EventStamps + (Stacked_DIOs(TTLdex,1) - first_matchingstamp);
EventStamps = EventStamps(find(EventStamps>=Stacked_DIOs(TTLdex,1)));
EventStamps = [EventStamps EventStamps+.15];

[TTLup, upbins] = histc(EventStamps(:,1),Stacked_DIOs(:,1));
TTLup(find(TTLup>1))=1;
%TTLup(upbins(find((upbins>0) & (upbins<length(upbins))))+1)=1;

%[TTLdown,downbins] = histc(EventStamps(:,1)+.14999,Stacked_DIOs(:,1));
%TTLup(downbins(find((downbins>0))))=1;

[TTLlate, latebins] = histc(EventStamps(:,1),Stacked_DIOs(:,1)-.005);
%TTLup(latebins(find((latebins>0) & (latebins<length(latebins)))))=1;
TTLup(latebins(find((latebins>0) & (latebins<length(latebins))))+1)=1;
%TTLup(find(TTLup>1))=1;

%TTLdown = histc(EventStamps(:,2),Stacked_DIOs(:,1));
%TTLdown(find(TTLdown>1))=1;

figure(1); clf; bsec=2000;
bar(Stacked_DIOs(bsec+[1:901],1),Stacked_DIOs(bsec+[1:901],3),1); axis tight;
hold on; 
bar(Stacked_DIOs(bsec+[1:901],1),TTLup(bsec+[1:901]),1); axis tight;

%reconstruct TTL

for i=1:40
    err(i)=sum(abs(Stacked_DIOs((i-1)*100+[1:100],3)+TTLup((i-1)*100+[1:100])))/(sum(abs(Stacked_DIOs((i-1)*100+[1:100],3)))+sum(abs(TTLup((i-1)*100+[1:100]))));
end

err



