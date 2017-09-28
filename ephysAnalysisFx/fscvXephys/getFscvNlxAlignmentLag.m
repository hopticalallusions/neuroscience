function alignmentLag = getFscvNlxAlignmentLag( fscvDir, nlxDir, nlxCscNumber )
  debug=true;
%%
%%START HERE%%%%
%
% turn this into a function that spits out the number of microseconds? or
% something to align the data; assume that the DIO is sampled at the onset
% of the FSCV pulse, and block the neuralynx data accordingly in the
% alignment. The alignment should be for neuralynx timestamps in
% microseconds relative to the onset of FSCV recording (which starts at
% t= 0 seconds)


% basedir='/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/';
% fscvDir = [basedir '/fscv/maze/'];
% nlxDir = [basedir '/nlx/maze/'];
% nlxCscNumber = 7;

    % load data  
    %
    % load events
    [ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat( [nlxDir, '/', 'Events.nev'] );
    % recenter and scale event times
    EV = [ (EventStamps-EventStamps(1))'/1000 ; EventTTLs' ]';
    % load FSCV data
    load([fscvDir, '/', 'Stacked_DIOs']);
    % extract relevant DIO data, scaling timestamps (column 1)
    dio = [ Stacked_DIOs(:,1)*1000  Stacked_DIOs(:,3)-1 ];
    % find all the neuralynx sync ttl onset data
    ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
    ups = EV( ttlOnsetIdx, 1 );
    % find all the neuralynx sync ttl offset data
    ttlOffsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0000).') )));
    downs = EV( ttlOffsetIdx, 1 );
    % interleave the onset and offset times
    % cases :
    % 1) first TTL goes up after start and last TTL down before end -- num_ups == num_downs
    % 2) first TTL goes up before start and last TTL down before end -- num_ups < num_downs
    % 3) first TTL goes up before start and last TTL down after end -- num_ups == num_downs ( not ideal )
    % 4) first TTL goes up after start and last TTL down after end -- num_ups > num_downs
    if (ups(1) > downs(1))
        if ( downs(2) > ups(1) ) % then we have case 2 from above
            downs = downs(2:end);
            warning('cutting the size of downs');
        else
            %panic  TODO
            warning('weirdness in time ordering of ttl on off events!');
        end
    elseif (ups(end) > downs(end))
        if ( downs(end) > ups(end-1) ) % then we have case 3 from above
            ups = ups(1:end-1);
            warning('cutting the size of ups');
        else
            %panic  TODO
            warning('weirdness in time ordering of ttl on off events!');
        end
    end
    onsetoffset = zeros(1,length(ups) + length(downs));
    onsetoffset(1:2:length(onsetoffset)) = ups;
    onsetoffset(2:2:length(onsetoffset)) = downs;
    % find FSCV dio onset and offset time, NlX style.
    dioOnsetTimes=[];
    dioOffsetTimes=[];
    ison=0;
    for idx=1:length(dio(:,2));
        if abs(dio(idx,2)) == 1 && ison == 0
            dioOnsetTimes = [ dioOnsetTimes dio(idx,1) ];
            ison = 1;
        elseif abs(dio(idx,2)) == 0 && ison == 1
            dioOffsetTimes = [ dioOffsetTimes dio(idx,1) ];
            ison = 0;
        end
    end
    % pay close attention to the names here...
    fscvDioOnsetOffset = zeros(1,length(dioOnsetTimes) + length(dioOffsetTimes));
    fscvDioOnsetOffset(1:2:length(fscvDioOnsetOffset)) = dioOnsetTimes;
    fscvDioOnsetOffset(2:2:length(fscvDioOnsetOffset)) = dioOffsetTimes;
    %figure;plot(diff(fscvDioOnsetOffset)); % check for rationality
    %
    %
    nlxStartRecordingIdx = find(not(cellfun('isempty', strfind(EventStrings, 'Starting Recording')))); % hopefully 1
    if (nlxStartRecordingIdx > 10)
        warning('starting recording is not in the first 10 records; defaulting to Idx = 1')
        nlxStartRecordingIdx = 1;
    end
    nlxEndRecordingIdx = find(not(cellfun('isempty', strfind(EventStrings, 'Stopping Recording')))); % hopefully 'end' / length(data)
    if (nlxEndRecordingIdx < 20 )
        warning('stopping recording is in the first 20 records; defaulting to Idx = end')
        nlxEndRecordingIdx = length(EventString);
    end
    %
    % figure out the first FSCV injection in neuralynx time
    % TODO unsafely assuming FSCV will happen in the first 100 ms of nlx data
    % this will later be used to 'fine tune' the nlx time series to align it
    % with the dio.
    [ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([nlxDir '/CSC' num2str(nlxCscNumber) '.ncs'], 1, 5000); %we don't need all the data.
    if max(cscLFP(1:3600)) < 4000
        warning('the max seems low in the LFP start');
    end
    % TODO this will cause problems if the max is within the first 136 samples
    fscvStartIdx = find(cscLFP(1:3600) == max(cscLFP(1:3600)))-136; % pull back from max because the sensing of the ttl occurs early
    if (fscvStartIdx < 1)
        warning('artifact occurs in the beginning of the file! attempting to fix');
        fscvStartIdx = find(cscLFP(270:3600) == max(cscLFP(270:3600)))-136+269;
    end
    fscvStartTimeoffset = (nlxCscTimestamps(fscvStartIdx)-nlxCscTimestamps(nlxStartRecordingIdx))/1000; % in milliseconds
    % remember that this is fscvStartIdx/samplesPerSecond seconds into the
    % recording, so the numbers may seem whacky.
    %
    % construct an nlx ttl timeseries @ 100ms resolution
    numFscvWindowsNlx = ceil((EventStamps(nlxEndRecordingIdx) - EventStamps(nlxStartRecordingIdx))/100000); % round 
    nlxTtlTimeseries = zeros( numFscvWindowsNlx, 1 );
    fscvStartTimeoffset = fscvStartTimeoffset + fscvStartTimeoffset; % shift nlx
    onsetoffsetIdxed=floor((onsetoffset+fscvStartTimeoffset)/100); % corrected for where the window starts
    for idx = 1:2:length(onsetoffsetIdxed)-1
        start=onsetoffsetIdxed(idx);
        finish=onsetoffsetIdxed(idx+1);
        nlxTtlTimeSeries(start:finish-1) = ones( finish-start , 1);
    end
    %
    [xcev,lag]=xcorr(dio(:,2),nlxTtlTimeSeries);
    [~,I]=max(abs(xcev));
    alignmentLag = lag(I);
    % TODO maybe change this because it's mixing data storage with an
    % analysis function,
    save( [nlxDir,'/','alignmentLag.mat' ], 'alignmentLag');
    if ( debug )
        figure;
        plot( find(abs(dio(:,2))), ones(length(find(abs(dio(:,2)))),1), 'ob')
        hold on;
        plot( find(nlxTtlTimeSeries)+lag(I), ones(length(find(nlxTtlTimeSeries)),1), '.r');
        plot(lag(I),1,'g*')
        plot(round((EventStamps(end)-EventStamps(1))/100000)+lag(I),1,'g*')
        legend('fscv dio','nlx ttl','nlx rec');
    end
    
    %% testing with a pop-out record
    testing=false;
    if testing
        % load data  
        %
        % define data directory
        %datadir = '/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/01. File Beginning To 7853397054';
        datadir = '/Users/andrewhowe/blairLab/blairlab_data/v4/march-6-2015/nlx/part4/';
        % load events
        [ EventStrings, EventStamps, eventHeader, EventTTLs, ] = nev2mat( [datadir, '/', 'Events.nev'] );
        % recenter and scale event times
        EV = [ (EventStamps-EventStamps(1))'/1000 ; EventTTLs' ]';
        % load FSCV data
        %load('/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/3-11-2015/run/platter/BATCH_PC/STACKED_PC/Stacked_DIOs');
        load('/Users/andrewhowe/blairLab/blairlab_data/v4/march-6-2015/fscv/maze/Stacked_DIOs');
        % extract relevant DIO data, scaling timestamps (column 1)
        dio = [ Stacked_DIOs(:,1)*1000  Stacked_DIOs(:,3)-1 ];
        % find all the neuralynx sync ttl onset data
        ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
        ups = EV( ttlOnsetIdx, 1 );
        % find all the neuralynx sync ttl offset data
        ttlOffsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0000).') )));
        downs = EV( ttlOffsetIdx, 1 );
        % interleave the onset and offset times
        % cases :
        % 1) first TTL goes up after start and last TTL down before end -- num_ups == num_downs
        % 2) first TTL goes up before start and last TTL down before end -- num_ups < num_downs
        % 3) first TTL goes up before start and last TTL down after end -- num_ups == num_downs ( not ideal )
        % 4) first TTL goes up after start and last TTL down after end -- num_ups > num_downs
        if (ups(1) > downs(1))
            if ( downs(2) > ups(1) ) % then we have case 2 from above
                downs = downs(2:end);
            else
                %panic
                warning('weirdness in time ordering of ttl on off events!');
            end
        elseif (ups(end) > downs(end))
            if ( downs(end) > ups(end-1) ) % then we have case 3 from above
                downs = downs(2:end);
            else
                %panic
                warning('weirdness in time ordering of ttl on off events!');
            end
        end
        onsetoffset = zeros(1,length(ups) + length(downs));
        onsetoffset(1:2:length(onsetoffset)) = ups;
        onsetoffset(2:2:length(onsetoffset)) = downs;
        % find FSCV dio onset and offset time, NlX style.
        dioOnsetTimes=[];
        dioOffsetTimes=[];
        ison=0;
        for idx=1:length(dio(:,2));
            if abs(dio(idx,2)) == 1 && ison == 0
                dioOnsetTimes = [ dioOnsetTimes dio(idx,1) ];
                ison = 1;
            elseif abs(dio(idx,2)) == 0 && ison == 1
                dioOffsetTimes = [ dioOffsetTimes dio(idx,1) ];
                ison = 0;
            end
        end
        % pay close attention to the names here...
        fscvDioOnsetOffset = zeros(1,length(dioOnsetTimes) + length(dioOffsetTimes));
        fscvDioOnsetOffset(1:2:length(fscvDioOnsetOffset)) = dioOnsetTimes;
        fscvDioOnsetOffset(2:2:length(fscvDioOnsetOffset)) = dioOffsetTimes;
        %figure;plot(diff(fscvDioOnsetOffset)); % check for rationality
        %
        %
        nlxStartRecordingIdx = find(not(cellfun('isempty', strfind(EventStrings, 'Starting Recording')))); % hopefully 1
        nlxEndRecordingIdx = find(not(cellfun('isempty', strfind(EventStrings, 'Stopping Recording')))); % hopefully 'end' / length(data)
        %
        % figure out the first FSCV injection in neuralynx time
        % TODO unsafely assuming FSCV will happen in the first 100 ms of nlx data
        % this will later be used to 'fine tune' the nlx time series to align it
        % with the dio.
        fileNum = 5;
        [ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([datadir '/CSC' num2str(fileNum) '.ncs'], 1, 6400); %we don't need all the data.
        % TODO this will cause problems if the max is within the first 136 samples
        fscvStartIdx = find(cscLFP(1:3600) == max(cscLFP(1:3600)))-136; % pull back from max because the sensing of the ttl occurs early
        fscvStartTimeoffset = (nlxCscTimestamps(fscvStartIdx)-nlxCscTimestamps(nlxStartRecordingIdx))/1000; % in milliseconds
        % remember that this is fscvStartIdx/samplesPerSecond seconds into the
        % recording, so the numbers may seem whacky.
        %
        % construct an nlx ttl timeseries @ 100ms resolution
        numFscvWindowsNlx = ceil((EventStamps(nlxEndRecordingIdx) - EventStamps(nlxStartRecordingIdx))/100000); % round 
        nlxTtlTimeseries = zeros( numFscvWindowsNlx, 1 );
        fscvStartTimeoffset = fscvStartTimeoffset + fscvStartTimeoffset; % shift nlx
        onsetoffsetIdxed=floor((onsetoffset+fscvStartTimeoffset)/100); % corrected for where the window starts
        for idx = 1:2:length(onsetoffsetIdxed)-1
            start=onsetoffsetIdxed(idx);
            finish=onsetoffsetIdxed(idx+1); % I think this means the correction is built in...
            nlxTtlTimeSeries(start:finish-1) = ones( finish-start , 1);
        end
        %
        % 
        [xcev,lag]=xcorr(dio(:,2),nlxTtlTimeSeries);
        [~,I]=max(abs(xcev));
        lag(I)/(60*10) % debugging : turn this into minutes of delay for display; positive means nlx started after FSCV
        figure; plot(lag,abs(xcev)) % debugging : visualize it
         % debugging : visualize the alignment
        figure;
        plot( find(abs(dio(:,2))), ones(length(find(abs(dio(:,2)))),1), 'ob')
        hold on;
        plot( find(nlxTtlTimeSeries)+lag(I), ones(length(find(nlxTtlTimeSeries)),1), '.r');
        plot(lag(I),1,'g*')
        plot(round((EventStamps(end)-EventStamps(1))/100000)+lag(I),1,'g*')
        legend('fscv dio','nlx ttl','nlx rec');


        [ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([datadir '/CSC' num2str(fileNum) '.ncs']);
        xz=zeros(1,ceil(length(cscLFP)/3200));for ii=1:length(xz)-1;    xz(ii) = max(cscLFP(1+((ii-1)*3200):(ii*3200))); end; %figure; plot(xz)
        load('/Users/andrewhowe/blairLab/blairlab_data/v4/march-6-2015/fscv/maze/Stacked_Cal');
        Stacked_Cal = Stacked_Cal(:,2:end); Stacked_Cal = Stacked_Cal(:);
        load('/Users/andrewhowe/blairLab/blairlab_data/v4/march-6-2015/fscv/maze/Stacked_Current');
        Stacked_Current = Stacked_Current(:,2:end); Stacked_Current = Stacked_Current(:);
        % visual alignment
        % truncate maxes to make it easier to view alignments
        tempIdxs = find( Stacked_Current > max(Stacked_Cal) );
        Stacked_Current(tempIdxs) = max(Stacked_Cal);
        tempIdxs = find( Stacked_Current(:) < min(Stacked_Cal) );
        Stacked_Current(tempIdxs) = min(Stacked_Cal);
        tempIdxs = find( cscLFP(:) > max(Stacked_Cal) );
        cscLFP(tempIdxs) = max(Stacked_Cal);
        figure;
        subplot(3,1,1);
        plot(max(Stacked_Cal)*Stacked_Current/max(Stacked_Current), 'Linestyle', '-', 'Linewidth', 2); hold on; plot(Stacked_Cal); plot(-71:length(xz)-72, max(Stacked_Cal)*xz/max(xz)); axis tight;
        title('manual alignment of pop-out event'); xlabel('time (100 ms epochs)'); ylabel('values (units nA,nM,uV)'); legend('FSCV cur.','FSCV Cal','LFP uV');
        % lag(I) alignment
        subplot(3,1,2);
        plot(max(Stacked_Cal)*Stacked_Current/max(Stacked_Current), 'Linestyle', '-', 'Linewidth', 2); hold on; plot(Stacked_Cal); plot(lag(I)+1:length(xz)+lag(I), max(Stacked_Cal)*xz/max(xz)); axis tight;
        title('xcorr alignment of pop-out event'); xlabel('time (100 ms epochs)'); ylabel('values (units nA,nM,uV)'); legend('FSCV cur.','FSCV Cal','LFP uV');
        % -73 is off by one from the DIO alignment method with xcorr. Thus I
        % believe this is correct.
        subplot(3,1,3);
        plot( find(abs(dio(:,2))), ones(length(find(abs(dio(:,2)))),1), 'ob')
        hold on;
        plot( find(nlxTtlTimeSeries)+lag(I), ones(length(find(nlxTtlTimeSeries)),1), '.r');
        plot(lag(I),1,'g*')
        plot(round((EventStamps(end)-EventStamps(1))/100000)+lag(I),1,'g*')
        legend('fscv dio','nlx ttl','nlx rec');
        title('aligned DIO signals'); xlabel('time (100 ms epochs)'); ylabel('n/a');

    end

    return;
end



%% Tad's Spatial Data Matrix Information
% posvars [ 1       2    3    4   5  6  7  8  9 ]
% posvars=[ pstamps xpos ypos spd hd rx ry gx gy];
%% Example Data
% platterpos = load('B:\neuralynx\v4\3-11_V4_twotasks_figure8_day3\01. File Beginning To 7853397054\Positions.mat');
% mazepos = load('B:\neuralynx\v4\3-11_V4_twotasks_figure8_day3\02. 7853397054 To 10870567054\Positions.mat');
% 
% platterda = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\daConcData.mat');
% mazeda = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\maze\BATCH_PC\STACKED_PC\daConcData.mat');
% 
% platterdio = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\Stacked_DIOs');
% mazedio = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\maze\BATCH_PC\STACKED_PC\Stacked_DIOs');


%% previously at the top
% 
% 
% % open data file for neuralynx and load into structure
% %datadir = 'B:\neuralynx\v4\3-11_V4_twotasks_figure8_day3\01. File Beginning To 7853397054\\';
% %[EventStamps, EventTTLs, EventStrings] = Nlx2MatEV( [datadir, 'Events.Nev'], [1 0 1 0 1], 0, 1); %get TTL data
% datadir = '/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/01. File Beginning To 7853397054';
% [ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat( [ datadir, '/', 'Events.nev' ] );
% % map to the space of milliseconds
% EV = [ (EventStamps-EventStamps(1))'/100000 ; EventTTLs' ]';  % now in 100 millisecond units and not micro
% % load data file for FSCV and format to millisecond space
% %load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\Stacked_DIOs');
% load( '/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/3-11-2015/run/platter/BATCH_PC/STACKED_PC/Stacked_DIOs' );
% dio = [ Stacked_DIOs(:,1)*10  Stacked_DIOs(:,3)-1 ]; % now in 100 millisecond units and not seconds
% % graphics prep
% 
% % find all the sync impulse onsets
% ttlOnsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') )));
% ups = EV( ttlOnsetIdx, 1 );
% ttlOffsetIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0000).') )));
% downs = EV( ttlOffsetIdx, 1 );
% onsetoffset = zeros(1,length(ups) + length(downs));
% onsetoffset(1:2:length(onsetoffset)) = ups;
% onsetoffset(2:2:length(onsetoffset)) = downs;
% 
% 
% 
% 
% 
% dioOnsetTimes=[];
% dioOffsetTimes=[];
% ison=0;
% for idx=1:length(dio(:,2));
%     if abs(dio(idx,2)) == 1 && ison == 0
%         dioOnsetTimes = [ dioOnsetTimes dio(idx,1) ];
%         ison = 1;
%     elseif abs(dio(idx,2)) == 0 && ison == 1
%         dioOffsetTimes = [ dioOffsetTimes dio(idx,1) ];
%         ison = 0;
%     end
% end
% dioOnsetOffsetTimes=sort([dioOnsetTimes dioOffsetTimes]);
% 
% 
% nlxTtlApprox = zeros( length(dio), 1 );
% for idx=1:length(ups)
%     nlxTtlApprox(round(ups(idx):downs(idx)))=ones(length(ups(idx):downs(idx)),1);
% end
% 
% [xcev,lag]=xcorr( abs(dio(:,2)), nlxTtlApprox );
% [~,I]=max(abs(xcev));
% lag(I)
% figure; plot(lag,xcev)
% find(max(xcev)==xcev)
% %11670 indices (?) which is a ??? ms delay
% qw=diff(sort([dioOnsetTimes dioOffsetTimes])); %FSCV
% as=diff(sort(onsetoffset)); % NlX
% figure; 
% subplot(3,1,1);hold off; plot(qw(1+lag(I):100+lag(I)));hold on; plot(as(1:100)); legend('fscv','nlx');
% subplot(3,1,2); plot(qw(1:100));hold on; plot(as(1:100));
% subplot(3,1,3); plot(qw(1:100));hold on; plot(as(1+lag(I):100+lag(I)));
% 
% figure;
% plot( find(abs(dio(:,2))), ones(length(find(abs(dio(:,2)))),1), 'or')
% hold on;
% plot( find(nlxTtlApprox)+lag(I), ones(length(find(nlxTtlApprox)),1), 'b.');
% plot(lag(I),1,'*g') % start nlx
% plot(round((EventStamps(end)-EventStamps(1))/100000)+lag(I),1,'g*') % end nlx
% 
% 
% [xcev,lag]=xcorr(diff(sort([dioOnsetTimes dioOffsetTimes])),diff(sort(onsetoffset)));
% [~,I]=max(abs(xcev));
% lag(I)
% figure; plot(lag,xcev)
% find(max(xcev)==xcev)
% %11670 indices (?) which is a ??? ms delay
% qw=diff(sort([dioOnsetTimes dioOffsetTimes])); %FSCV
% as=diff(sort(onsetoffset)); % NlX
% figure; 
% subplot(3,1,1);hold off; plot(qw(1+lag(I):100+lag(I)));hold on; plot(as(1:100)); legend('fscv','nlx');
% subplot(3,1,2); plot(qw(1:100));hold on; plot(as(1:100));
% subplot(3,1,3); plot(qw(1:100));hold on; plot(as(1+lag(I):100+lag(I)));
% 
% figure; hold off; plot(qw(1+1786-50:200+1786-50));hold on; plot(as(1+3468-50:200+3468-50)); legend('fscv','nlx');
% 
% 
% figure;
% subplot(2,1,1);
% plot([0:.1:((length(platterda.daConcData)-1)/10)]/60, platterda.daConcData)
% subplot(2,1,2);
% plot((platterpos.posvars(:,1)-100)/60,platterpos.posvars(:,3));
% 
% 
% 
% 
% figure;
% plot(dioOnsetTimes, zeros(length(dioOnsetTimes),1), 'or')
% hold on;
% plot( adjustedUps, zeros(length(adjustedUps), 1), 'b.');
% 
% 
% 
% figure; hold on;  for ii = 0:10:150; plot(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset)+ii, zeros(1, length(ups)), 'k.'); end; plot(aa-min(aa)+50, zeros(1, length(aa)), 'ro');
% for ii = 0:10:150; plot(0.9986*(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset))+ii, zeros(1, length(ups))+.3e-5, 'k.'); end; plot(aa-min(aa)+90, zeros(1, length(aa))+.3e-5, 'ro');
% 
% 
% 
% 
% divider=30000; signalOn = min(dio(find(abs(dio(:,2))),1)); figure; subplot(3,1,1); [ny,nx]=hist(([ ups; ups+100]+signalOn)/divider, 0:divider/60000:60); plot(nx,ny); legend('neuralynx'); subplot(3,1,2); [cy,cx]=hist((dio(find(abs(dio(:,2))),1))/divider, 0:divider/60000:60); plot(cx,cy, 'r'); legend('fscv'); subplot(3,1,3); hold on; plot(nx, ny, 'b+-'); plot(cx,cy,'ro-'); legend('nlx','fscv');
% 
% 
% nlxTtlIpi=onsetoffset(3:2:length(onsetoffset))-onsetoffset(1:2:length(onsetoffset)-2);
% dioTtlIpi= dioOnsetTimes(2:2:length(dioOnsetTimes))-dioOnsetTimes(1:2:length(dioOnsetTimes));
% 
% figure; hold on; plot(cumsum(nlxTtlIpi)); cumsum(dioTtlIpi, 'r')
% 
% 
% figure; plot( zeroadjonsetoffset, 1:length(zeroadjonsetoffset), 'r' );
% 
% zeroadjonsetoffset = [0.9986*(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset))];
% hold on; plot(aa-min(aa),(0:length(aa)-1)*length(zeroadjonsetoffset)/length(aa), 'b')
% aa-min(aa)
% 
% 
% 
% 
% 
% zeroadjonsetoffset = [0.9991*(onsetoffset(1:2:length(onsetoffset))-min(onsetoffset))];
% figure; plot( zeroadjonsetoffset, 1:length(zeroadjonsetoffset), 'r' );
% hold on; plot(aa-min(aa),(0:length(aa)-1)*length(zeroadjonsetoffset)/length(aa), 'b')
% 
% 
% %idx of first dopamine sync signal is 2355
% 
% % find the reward delivery events for one of the dispensers
% min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )))))
% 
% 
% 
% hist(platterda.daConcData(round(2355+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/100000))),100)
% 
% rewardDeliveriesNlxTime = EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') ))));
% rewardDeliveriesNlxTime = [ rewardDeliveriesNlxTime EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C6).') )))) ];
% zone2EntriesNlxTime = EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone2 Entered') ))));
% platterda = load('B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC\daConcData.mat');
% round(0.9991*((nlxTime/1000)-3.1061e3))/100)+2355
% 
% 
% 
% ts=(23.54+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/1000000));
% 
% 
% %tso=(23.54+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings,  'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C6).') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/1000000));
% 
% tso=(23.54+(0.9991*(EventStamps(find(not(cellfun('isempty', strfind(EventStrings,  'TTL Output on PCI-DIO24_2 board 0 port 2') )))) - min(EventStamps(find(not(cellfun('isempty', strfind(EventStrings, 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0001).') ))))))/1000000));
% 
% 
% pellet drops vs dopamine
% maze location vs dopamine
% zone entries vs dopamine

