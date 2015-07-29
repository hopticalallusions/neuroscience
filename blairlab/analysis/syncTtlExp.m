%get first timestamp
datadir = 'C:\CheetahData\eventTestSync\'
%[EventStamps, EventTTLs] = Nlx2MatEV_v3( [datadir, 'Events.Nev'], [1 0 1 0 0], 0, 1); %get TTL data
%EV = [EventTTLs' (EventStamps-EventStamps(1))'/1000]; % millisecond universe; event 1 is "Start of recording" and last is "Stop recording"
%EventStamps = EventStamps(find(EventTTLs==1)); %find TTLS timestamps
%EventStamps = (EventStamps - FirstStamp)'/1000000;

datadir = '/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/01. File Beginning To 5564929835/'
[nlxEvents, nlxEvTimestamps, evHeader]=nev2mat('/Users/andrewhowe/toSort/blairlab_data/giantsharpwaves/01. File Beginning To 5564929835/Events.Nev');


EV(:,1) = EV(:,1);

- 7820-2900;


upsdownstimes = [0 upsdownstimes(1:2000) ];
upsdowns = [0 upsdowns(1:2000) ];
upsdowns = upsdowns > 0;


upsdowns=zeros(1,2*length(EventTTLs)-1);
upsdownstimes=zeros(1,2*length(EventTTLs)-1);
udIdx = 1;
for idx = 2:length(EV)-1
    state = EV(idx,1);
    time = EV(idx,2);
    if state == 0
        upsdowns(udIdx) = 1;
        upsdownstimes(udIdx) = time-1;
        upsdowns(udIdx+1) = 0;
        upsdownstimes(udIdx+1) = time;
    else
        upsdowns(udIdx) = 0;
        upsdownstimes(udIdx) = time-1;
        upsdowns(udIdx+1) = 1;
        upsdownstimes(udIdx+1) = time;
    end
   udIdx = udIdx + 2 ;
end
figure;
plot(upsdownstimes, upsdowns)
hold on;
upsdowns=[];
upsdownstimes=[];
evtemp=EV(find(EV(:,1)==1),2);
upsdowns=[ upsdowns zeros(1,length(evtemp)) ];
upsdownstimes=[ upsdownstimes (EV(find(EV(:,1)==1),2)-1) ];
upsdowns=[ upsdowns ones(1,length(evtemp)) ];
upsdownstimes=[ upsdownstimes EV(find(EV(:,1)==1),2) ];
%plot(evtemp,zeros(1,length(evtemp)), 'ob');
plot(evtemp,ones(1,length(evtemp)), '*g');
evtemp=EV(find(EV(:,1)==0),2);
plot(evtemp,ones(1,length(evtemp)), 'or');
%plot(evtemp,ones(1,length(evtemp)), 'or');

figure;
hold on;
evtemp=EV(find(EV(:,1)==1),2);
plot(evtemp,ones(1,length(evtemp)), '*g');
plot(cvttl(find(cvttl(:,2),1)), cvttl(find(cvttl(:,2),2)), 'r+');

upsdowns=[];
upsdownstimes=[];
evtemp=EV(find(EV(:,1)==1),2);
upsdowns=[ upsdowns zeros(1,length(evtemp)) ];
upsdownstimes=[ upsdownstimes; (EV(find(EV(:,1)==1),2)-1) ];
upsdowns=[ upsdowns ones(1,length(evtemp)) ];
upsdownstimes=[ upsdownstimes; EV(find(EV(:,1)==1),2) ];
evtemp=EV(find(EV(:,1)==0),2);
upsdowns=[ upsdowns ones(1,length(evtemp)) ];
upsdownstimes=[ upsdownstimes; EV(find(EV(:,1)==0),2) ];
upsdowns=[ upsdowns zeros(1,length(evtemp)) ];
upsdownstimes=[ upsdownstimes; (EV(find(EV(:,1)==0),2)+1) ];


upsdowns=zeros(1,2*length(EventTTLs)-1);
upsdownstimes=zeros(1,2*length(EventTTLs)-1);
eventIdx = 1;
for idx = 2:length(EventTTLs)-1
    state = EventTTLs(idx);
    time = EventTimeStamps(idx);
    if state == 0
        upsdowns(eventIdx) = 1;
        upsdownstimes(eventIdx) = EventTimeStamps(idx)-1;
        upsdowns(eventIdx+1) = 0;
        upsdownstimes(eventIdx+1) = EventTimeStamps(idx);
    else
        upsdowns(eventIdx) = 0;
        upsdownstimes(eventIdx) = EventTimeStamps(idx)-1;
        upsdowns(eventIdx+1) = 1;
        upsdownstimes(eventIdx+1) = EventTimeStamps(idx);
    end
    eventIdx = eventIdx + 2;
end
upsdownstimes = upsdownstimes - EventTimeStamps(1)
hold on; plot(upsdownstimes/1000,upsdowns)


%figure; plot(EV(:,2),EV(:,1), 'o')


% datadir = 'C:\CheetahData\eventTestSync\'
% [EventTimeStamps, EventIDs, EventTTLs, EventExtras, EventStrings] = Nlx2MatEV_v3( [datadir, 'Events.Nev'], [1 1 1 1 1], 0, 1); %get TTL data
% 
% csvwrite('H:\syncanalysis\EventTimeStamps.csv', EventTimeStamps)
% csvwrite('H:\syncanalysis\EventIDs.csv', EventIDs)
% csvwrite('H:\syncanalysis\EventTTLs.csv', EventTTLs)
% csvwrite('H:\syncanalysis\EventExtras.csv', EventExtras)
% csvwrite('H:\syncanalysis\EventStrings.csv', EventStrings)






cvttl(:,2)=abs(Stacked_DIOs(:,3)-1)*1.001;


evtemp=EV(find(EV(:,1)==1),2);
figure; hold on;
plot(evtemp-10000+2995,ones(1,length(evtemp))*1.08, '*g');
cvx = cvttl(find(cvttl(:,2)),1);
cvy = cvttl(find(cvttl(:,2)),2);
plot( cvx, cvy, 'r+');


figure; 
hold on; 
plot(upsdownstimes-41, upsdowns, 'k'); 
plot(dio(:,1),dio(:,2),'b'); 
axis([0 6e4 -1.05 1.05 ]); 
plot(dio(:,1),zeros(1,length(dio(:,1))),'+g'); 
plot(dio(:,1)+8.5,zeros(1,length(dio(:,1))),'+m'); 
legend('nlx','fscv','\Delta-on','\Delta-off')

dio=[Stacked_DIOs(:,1) ; Stacked_DIOs(:,3)];

figure; hold on; plot(upsdownstimes-91+145+7.5, upsdowns, 'k'); plot(dio(:,1),dio(:,2),'b'); axis([0 6e4 -1.05 1.05 ]); plot(dio(:,1),zeros(1,length(dio(:,1))),'+g'); plot(dio(:,1)+8.5,zeros(1,length(dio(:,1))),'+m'); legend('nlx','fscv','\Delta-on','\Delta-off')



dio=[Stacked_DIOs(:,1) ; Stacked_DIOs(:,3)];

upsdowns=zeros(1,2*length(EventTTLs)-1);
upsdownstimes=zeros(1,2*length(EventTTLs)-1);
udIdx = 1;
for idx = 2:length(EV)-1
    state = EV(idx,1);
    time = EV(idx,2);
    if state == 1
        upsdowns(udIdx) = 1;
        upsdownstimes(udIdx) = time-1;
        upsdowns(udIdx+1) = 0;
        upsdownstimes(udIdx+1) = time;
%     else
%         upsdowns(udIdx) = 0;
%         upsdownstimes(udIdx) = time-1;
%         upsdowns(udIdx+1) = 1;
%         upsdownstimes(udIdx+1) = time;
    end
    udIdx = udIdx + 2 ;
end
upsdowns=upsdowns(1:end-3);
upsdownstimes=upsdownstimes(1:end-3);
figure; hold on; plot(upsdownstimes, upsdowns, 'k'); plot(dios(:,1)+2424000,dios(:,2),'b'); plot(dios(:,1),zeros(1,length(dios(:,1))),'+g'); plot(dios(:,1)+8.5,zeros(1,length(dios(:,1))),'+m'); legend('nlx','fscv','\Delta-on','\Delta-off')
axis([ 8e5 1e6 -1.05 1.05 ])

axis([ 0 1e4 -1.05 1.05 ])

axis([ 2.4e6 3e6 -1.05 1.05 ])


2.7e6 - (2.964e6 - 2.688e6)



















% open data file for neuralynx and load into structure
datadir = 'B:\neuralynx\v4_platform_fig8_1sTTL\01. File Beginning To 15420344398\'
[EventStamps, EventTTLs, EventStrings] = Nlx2MatEV_v3( [datadir, 'Events.Nev'], [1 0 1 0 1], 0, 1); %get TTL data
% map to the space of milliseconds
EV = [ (EventStamps-EventStamps(1))'/1000 EventTTLs' ];
% load data file for FSCV and format to millisecond space
load('B:\fscv\andrewhowe_blairlab\V4\3-23-2015\run\platter\BATCH_PC\STACKED_PC\Stacked_DIOs');
dio = [ Stacked_DIOs(:,1)*1000  Stacked_DIOs(:,3)-1 ];
% graphics prep
figure;
plot( dio(:,1), dio(:,2) );
hold on;
% find all the sync impulse onsets
ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
ups = EV( ttlOnsetIdx, 1 );
% find an offset based on where the dios start and where the Nlx sync
% starts
offset = dio(min(find(dio(:,2)==-1)), 1) - min(ups);
plot(ups + offset, zeros(length(ups), 1), 'ko');
axis([ 1.2e5 1.4e5 -1.05 0.05 ]);
title('March 23rd, fixed duration sync length')
plot(dio(:,1),zeros(1,length(dio(:,1))),'.g');
plot(dio(:,1)+8.5,zeros(1,length(dio(:,1))),'.m');

axis([ 1.2e6 1.21e6 -1.05 0.05 ]);




% open data file for neuralynx and load into structure
datadir = 'B:\neuralynx\v4-giant-sharp-waves\02. PLATTER 5567871295 To 7600619636\'
[EventStamps, EventTTLs, EventStrings] = Nlx2MatEV_v3( [datadir, 'Events.Nev'], [1 0 1 0 1], 0, 1); %get TTL data
% map to the space of milliseconds
EV = [ (EventStamps-EventStamps(1))'/1000 EventTTLs' ];
% load data file for FSCV and format to millisecond space
load('B:\fscv\andrewhowe_blairlab\V4\3-20-2015\run\platterSync\BATCH_PC\STACKED_PC\Stacked_DIOs');
dio = [ Stacked_DIOs(:,1)*1000  Stacked_DIOs(:,3)-1 ];
% graphics prep
figure;
plot( dio(:,1), dio(:,2) );
hold on;
% find all the sync impulse onsets
ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
ups = EV( ttlOnsetIdx, 1 );
% find an offset based on where the dios start and where the Nlx sync
% starts
offset = dio(min(find(dio(:,2)==-1)), 1) - min(ups);
plot(ups + offset, zeros(length(ups), 1), 'ro');
axis([ 0 5e5 -1.05 1.05 ]);
title('March 20 variable sync pulse length and delay');



ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));







dioOnsets=[];
ison=0;
for idx=1:length(dio(:,2));
    if abs(dio(idx,2)) == 1 && ison == 0
        dioOnsets = [ dioOnsets idx ];
        ison = 1;
    elseif abs(dio(idx,2)) == 0 && ison == 1
        ison = 0;
    end
end
figure; hold on;
plot(dio(dioOnsets,1), zeros(length(dio(dioOnsets,1)),1), 'or')
plot(ups + offset, zeros(length(ups), 1), 'b.');
legend('dio','nlx');
dioOnsetTimes = dio(dioOnsets,1);



timeAlignmentError = ( (ups + offset) ) - dioOnsetTimes(1:length(ups));
figure;
subplot(3,2,1); hist(timeAlignmentError,55); title('time error histogram');
subplot(3,2,2); plot(timeAlignmentError); title('time error trend');
hold on;
xx = 1:length( timeAlignmentError );
p = polyfit( xx, timeAlignmentError', 1 )
yfit = polyval( p, xx );
plot( xx, yfit, 'r');
adjustmentFactor = 1 - (max(timeAlignmentError)/max(ups));
adjustedUps = ups
timeAlignmentError = ( (ups * adjustmentFactor + offset) ) - dioOnsetTimes(1:length(ups));
adjustedUps = ups * adjustmentFactor - mean(timeAlignmentError) + offset;
timeAlignmentError = adjustedUps - dioOnsetTimes(1:length(adjustedUps));
subplot(3,2,3); hist(timeAlignmentError,55); title('time error histogram');
subplot(3,2,4); plot(timeAlignmentError); title('time error trend');
hold on;
xx = 1:length(timeAlignmentError);
p = polyfit( xx, timeAlignmentError', 1 )
yfit = polyval( p, xx );
plot( xx, yfit, 'r');
%
subplot(3,2,5);
hold off;
plot(dio(dioOnsets(1:50),1), zeros(length(dio(dioOnsets(1:50),1)),1), 'or')
hold on;
plot( adjustedUps(1:50), zeros(length(adjustedUps(1:50)), 1), 'b.');
legend('dio','nlx');
subplot(3,2,6);
hold on;
plot( dio(dioOnsets(end-50:end),1), zeros(length(dio(dioOnsets(end-50:end),1)),1), 'or')
plot( adjustedUps(end-50:end), zeros(length(adjustedUps(end-50:end)), 1), 'b.');
legend('dio','nlx');
















% open data file for neuralynx and load into structure
datadir = 'B:\neuralynx\v4-giant-sharp-waves\02. PLATTER 5567871295 To 7600619636\'
[EventStamps, EventTTLs, EventStrings] = Nlx2MatEV_v3( [datadir, 'Events.Nev'], [1 0 1 0 1], 0, 1); %get TTL data
% map to the space of milliseconds
EV = [ (EventStamps-EventStamps(1))'/1000 EventTTLs' ];
% load data file for FSCV and format to millisecond space
load('B:\fscv\andrewhowe_blairlab\V4\3-20-2015\run\platterSync\BATCH_PC\STACKED_PC\Stacked_DIOs');
dio = [ Stacked_DIOs(:,1)*1000  Stacked_DIOs(:,3)-1 ];
% graphics prep
figure;
plot( dio(:,1), dio(:,2) );
hold on;
% find all the sync impulse onsets
ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
ups = EV( ttlOnsetIdx, 1 );
% find an offset based on where the dios start and where the Nlx sync
% starts
offset = dio(min(find(dio(:,2)==-1)), 1) - min(ups);
plot(ups + offset, zeros(length(ups), 1), 'ro');
axis([ 0 5e5 -1.05 1.05 ]);
title('March 20 variable sync pulse length and delay');
dioOnsetTimes=[];
ison=0;
for idx=1:length(dio(:,2));
    if abs(dio(idx,2)) == 1 && ison == 0
        dioOnsetTimes = [ dioOnsetTimes idx ];
        ison = 1;
    elseif abs(dio(idx,2)) == 0 && ison == 1
        ison = 0;
    end
end
timeAlignmentError = ( (ups + offset) ) - dioOnsetTimes(1:length(ups))';
figure;
subplot(3,2,1); hist(timeAlignmentError,55); title('time error histogram');
subplot(3,2,2); plot(timeAlignmentError); title('time error trend');
hold on;
xx = 1:length( timeAlignmentError );
p = polyfit( xx, timeAlignmentError', 1 );
yfit = polyval( p, xx );
plot( xx, yfit, 'r');
adjustmentFactor = 1 - (max(timeAlignmentError)/(max(ups)-min(ups)));
adjustedUps = ups
timeAlignmentError = ( (ups * adjustmentFactor + offset) ) - dioOnsetTimes(1:length(ups));
adjustedUps = ups * adjustmentFactor - mean(timeAlignmentError) + offset;
timeAlignmentError = adjustedUps - dioOnsetTimes(1:length(adjustedUps));
subplot(3,2,3); hist(timeAlignmentError,55); title('time error histogram');
subplot(3,2,4); plot(timeAlignmentError); title('time error trend');
hold on;
xx = 1:length(timeAlignmentError);
p = polyfit( xx, timeAlignmentError', 1 );
yfit = polyval( p, xx );
plot( xx, yfit, 'r');
%
subplot(3,2,5);
hold off;
plot(dio(dioOnsets(1:50),1), zeros(length(dio(dioOnsets(1:50),1)),1), 'or')
hold on;
plot( adjustedUps(1:50), zeros(length(adjustedUps(1:50)), 1), 'b.');
legend('dio','nlx');
subplot(3,2,6);
hold on;
plot( dio(dioOnsets(end-50:end),1), zeros(length(dio(dioOnsets(end-50:end),1)),1), 'or')
plot( adjustedUps(end-50:end), zeros(length(adjustedUps(end-50:end)), 1), 'b.');
legend('dio','nlx');