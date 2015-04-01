posvars [ 1       2    3    4   5  6  7  8  9 ]
posvars=[ pstamps xpos ypos spd hd rx ry gx gy];



platterpos = load('B:\neuralynx\v4\3-11_V4_twotasks_figure8_day3\01. File Beginning To 7853397054\Positions.mat');
mazepos = load('B:\neuralynx\v4\3-11_V4_twotasks_figure8_day3\02. 7853397054 To 10870567054\Positions.mat');

platterda = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\daConcData.mat');
mazeda = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\maze\BATCH_PC\STACKED_PC\daConcData.mat');

platterdio = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\Stacked_DIOs');
mazedio = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\maze\BATCH_PC\STACKED_PC\Stacked_DIOs');




% open data file for neuralynx and load into structure
datadir = 'B:\neuralynx\v4\3-11_V4_twotasks_figure8_day3\01. File Beginning To 7853397054\\';
[EventStamps, EventTTLs, EventStrings] = Nlx2MatEV( [datadir, 'Events.Nev'], [1 0 1 0 1], 0, 1); %get TTL data
% map to the space of milliseconds
EV = [ (EventStamps-EventStamps(1))'/1000 EventTTLs' ];
% load data file for FSCV and format to millisecond space
load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\Stacked_DIOs');
dio = [ Stacked_DIOs(:,1)*1000  Stacked_DIOs(:,3)-1 ];
% graphics prep

% find all the sync impulse onsets
ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
ups = EV( ttlOnsetIdx, 1 );
ttlOffsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0000).') )));
downs = EV( ttlOffsetIdx, 1 );
onsetoffset = zeros(1,length(ups) + length(downs));
onsetoffset(1:2:length(onsetoffset)) = ups;
onsetoffset(2:2:length(onsetoffset)) = downs;



dioOnsetTimes=[];
ison=0;
for idx=1:length(dio(:,2));
    if abs(dio(idx,2)) == 1 && ison == 0
        dioOnsetTimes = [ dioOnsetTimes dio(idx,1) ];
        ison = 1;
    elseif abs(dio(idx,2)) == 0 && ison == 1
        ison = 0;
    end
end



figure;
subplot(2,1,1);
plot([0:.1:((length(platterda.daConcData)-1)/10)]/60, platterda.daConcData)
subplot(2,1,2);
plot((platterpos.posvars(:,1)-100)/60,platterpos.posvars(:,3));




figure;
plot(dioOnsetTimes, zeros(length(dioOnsetTimes),1), 'or')
hold on;
plot( adjustedUps, zeros(length(adjustedUps), 1), 'b.');



figure; hold on;  for ii = 0:10:150; plot(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset)+ii, zeros(1, length(ups)), 'k.'); end; plot(aa-min(aa)+50, zeros(1, length(aa)), 'ro');
for ii = 0:10:150; plot(0.9986*(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset))+ii, zeros(1, length(ups))+.3e-5, 'k.'); end; plot(aa-min(aa)+90, zeros(1, length(aa))+.3e-5, 'ro');




divider=30000; signalOn = min(dio(find(abs(dio(:,2))),1)); figure; subplot(3,1,1); [ny,nx]=hist(([ ups; ups+100]+signalOn)/divider, 0:divider/60000:60); plot(nx,ny); legend('neuralynx'); subplot(3,1,2); [cy,cx]=hist((dio(find(abs(dio(:,2))),1))/divider, 0:divider/60000:60); plot(cx,cy, 'r'); legend('fscv'); subplot(3,1,3); hold on; plot(nx, ny, 'b+-'); plot(cx,cy,'ro-'); legend('nlx','fscv');


nlxTtlIpi=onsetoffset(3:2:length(onsetoffset))-onsetoffset(1:2:length(onsetoffset)-2);
dioTtlIpi= dioOnsetTimes(2:2:length(dioOnsetTimes))-dioOnsetTimes(1:2:length(dioOnsetTimes));

figure; hold on; plot(cumsum(nlxTtlIpi)); cumsum(dioTtlIpi, 'r')


figure; plot( zeroadjonsetoffset, 1:length(zeroadjonsetoffset), 'r' );

zeroadjonsetoffset = [0.9986*(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset))];
hold on; plot(aa-min(aa),(0:length(aa)-1)*length(zeroadjonsetoffset)/length(aa), 'b')
aa-min(aa)





zeroadjonsetoffset = [0.9991*(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset))];
figure; plot( zeroadjonsetoffset, 1:length(zeroadjonsetoffset), 'r' );
hold on; plot(aa-min(aa),(0:length(aa)-1)*length(zeroadjonsetoffset)/length(aa), 'b')


%idx of first dopamine sync signal is 2355


min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )))))



hist(platterda.daConcData(round(2355+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/100000))),100)

rewardDeliveriesNlxTime = EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') ))));
rewardDeliveriesNlxTime = [ rewardDeliveriesNlxTime EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C6).') )))) ];
zone2EntriesNlxTime = EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone2 Entered') ))));
platterda = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\daConcData.mat');
round(0.9991*((nlxTime/1000)-3.1061e3))/100)+2355



ts=(23.54+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/1000000));


%tso=(23.54+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings,  'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C6).') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/1000000));

tso=(23.54+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings,  'TTL Output on PCI-DIO24_2 board 0 port 2') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/1000000));


pellet drops vs dopamine
maze location vs dopamine
zone entries vs dopamine
