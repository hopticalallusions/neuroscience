function makeItRain_v2()

    readyForTakeoff = true;
	ratName = 'v4';
	version = 'dual 3.1';
	serverName = 'PHYSIO_RIG';	% neuralynx router server name 
	eventLogName = 'Events';	% name of the Event stream object in neuralynx cheetah
	videoTrackerName = 'VT1';	% name of the Video Tracker stream object in neuralynx cheetah
	timeToRun = 11; % minutes
	dispenseInitialReward = false;	% are we going to give an initial reward
	totalRewards = 0;
    lastRewardedSequence = [];
	% this needs the Neuralynx files in the include path. modify as needed.
    savePath = 'C:\Documents and Settings\Administrator\My Documents\ahowe\data\rhombus-maze\'
    %
    maximumTime = 300; %minutes
	%
	droppedEventRecords = 0;
	droppedVideoRecords = 0;
	videoTimeStamps = [];
	videoLocations = [];
	
	%
	% store timestamp for execution
	%
	startTimeString = [datestr(date) '_' num2str(now)];
	
	disp('Starting makeItRain ...')
	disp(['version ' version])
	disp(['rat = ' ratName])
	% turn on OS warning sound
	beep on;
	
	%%%% connect to Neuralynx
	%
	if ~NlxAreWeConnected()
		disconnectResult = NlxDisconnectFromServer();
		connectResult = NlxConnectToServer(serverName);
		if ~connectResult
			disp(['ERROR : Failed to connect to ' serverName ])
			beep;
			return
		else
			disp(['Successful connection to ' serverName])
		end
	end

	%%%% open streams
	%
	openStreamResult = NlxOpenStream(eventLogName);
	if ~openStreamResult
		disp(['ERROR : Failed to open stream ' eventLogName ])
		beep;
		return
	else
		disp(['Successfully opened ' eventLogName])
	end
	%
	%%%%%%%%%%%%%%%%%
	%
	openStreamResult = NlxOpenStream(videoTrackerName);
	if ~openStreamResult
		disp(['ERROR : Failed to open stream ' videoTrackerName ])
		beep;
		return
	else
		disp(['Successfully opened ' videoTrackerName])
	end
	%
	%%%%

	% set up some state variables
	inAZone = false;
	currentZone = -1;
	% run from 2 -> 4 - ( 1 | 2 | 3 ) - > 0 = reward
	ready = true;
    %pause(60);
	% 
	% track zone sequences for live error detection
	% 
	zoneHistory = -1 * ones(1,10000);
	zoneHistoryTimes = zeros(size(zoneHistory));
	zoneHistoryIdx = 1; %starts at two because the indexing is silly.
	

	%
	% set up history variables
	%
	eventIdx = 1;
	eventHistoryTimesNlx = -1 * ones(1,10000);
	eventHistoryTimesMatlab = -1 * ones(1,10000);
	%
	% initialize history
	%
	eventHistory = cellstr(['starting trial']);
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	eventHistory = cellstr(['rat = ' ratName]);
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	
	
	% behavioral error tracking variables
	rewardExitError = 0;
	centerError = 0;
	jumpError = 0;
	choicePointError = 0;
	cornerError = 0;
    alternationError = 0;
	
    %
    % holding pattern
    %

    for waitingCounter = 1:(maximumTime*60)
   		pause(1);
		[succeeded, timeStampArray, eventIDArray, ttlValueArray, eventStringArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewEventData('Events');
		% process event stream
		for idx = 1:length(eventStringArray)
            if strcmpi(eventStringArray(idx), 'Zoned Video: Zone6 Entered')
                readyForTakeoff = true
				break;
            end
        end
        if readyForTakeoff
            % this foolishness is required to break the nested loops. :-/
            break;
        end
    end
    %
    disp('Trial has gone live!')
	eventHistory = [eventHistory ; cellstr('Trial has gone live!') ];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
    %
  	%
	% make an initial attractive reward
	%
	if dispenseInitialReward
		%pause(10);
		disp('Dispensing an initial reward...')
		%NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
        pause(.5);
		%NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
    end
    %
    beep; beep; pause(2); beep;
    %
	% main loop
	%
    trialOver = false;
	for pass = 1:(maximumTime*60)
        if trialOver
            disp('Ending trial!!');
            beep;
            beep;
            break;
        end;
		%
		% each ~1 second sample the event state
		%
		pause(1);
		[succeeded, timeStampArray, eventIDArray, ttlValueArray, eventStringArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewEventData('Events');
		%
		% If it is an even minute, provide time remaining in trial
		%
		if 0 == mod(pass, 60)
			disp(['T-Minus ' num2str(round(((timeToRun*60)-pass)/60)) ' minutes until lift off'])
			% get it? get it? we pick the rat up off the maze... (groan)
			if ( round(((timeToRun*60)-pass)/60) == 1 ) || ( round(((timeToRun*60)-pass)/60) < -9 )
                beep
				disp('!!!!')
				disp('!!!!')
                pause(.5)
                beep
                pause(.5)
                beep
			end
		end
		%
		% detect if any event records are dropped.
		%
		if numRecordsDropped > 0
			droppedEventRecords = droppedEventRecords + 1;
			disp(['System Error! : ' num2str(numRecordsDropped) ' event records dropped'])
			eventHistory = [eventHistory ; [num2str(numRecordsDropped) ' event records dropped!'] ];
			eventHistoryTimesNlx(eventIdx) = 0;
			eventHistoryTimesMatlab(eventIdx) = now();
			eventIdx = eventIdx + 1;
		end
		%
		% process event stream
		%
		for idx = 1:length(eventStringArray)
			%
			% store event history
			%
			eventHistory = [eventHistory ; eventStringArray(idx) ];
			eventHistoryTimesNlx(eventIdx) = timeStampArray(idx);
			eventHistoryTimesMatlab(eventIdx) = now();
			eventIdx = eventIdx + 1;
			%
			%
			%
			%disp([ 'lastZone ' num2str(zoneHistory(zoneHistoryIdx)) ' : inZone ' num2str(currentZone) ' : ready ' num2str(ready)  ' : ' char(eventStringArray(idx))])
			%
			% Oh where, oh where can my dear rat be? Oh where can my dear ratsky beeee? (sing this comment for added fun.)
			%
			if strcmpi(eventStringArray(idx), 'Zoned Video: Zone0 Entered')
				currentZone = 0;
            elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone1 Entered')
				currentZone = 1;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone2 Entered')
				currentZone = 2;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone3 Entered')
				currentZone = 3;
			elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone4 Entered')
				currentZone = 4;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone5 Entered')
				% the OFF switch
                trialOver = true;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone6 Entered')
				currentZone = 6;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone7 Entered')
				currentZone = 7;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone8 Entered')
				currentZone = 8;
			end
			%
			%
						%
			% online sequence error detector
			%
			% this style of detection works because zoneHistory isn't updated until the rat exits a zone.
			%
			% TODO -- functionalize event additions
			%
			% TODO -- add comments about behavior error sequences.
			%
			%
			if ( currentZone == 3 || currentZone == 1 ) && zoneHistory(zoneHistoryIdx) == 4
				% 0 -> ( 3 | 1 ) is a reward exit error
				rewardExitError = rewardExitError + 1;
				disp('Behavior Error! : reward zone exit error.')
				eventHistory = [eventHistory ; cellstr('Behavior Error! : reward zone exit error.') ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif ( currentZone == 4 ) && zoneHistory(zoneHistoryIdx) == 2
				centerError = centerError + 1;
				disp('Behavior Error! : center zone exit error.')
				eventHistory = [eventHistory ; cellstr('Behavior Error! : center zone exit error.') ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif (zoneHistory(zoneHistoryIdx) ~= currentZone) && ( currentZone == 3 || currentZone == 1 || currentZone == 2 ) && ( zoneHistory(zoneHistoryIdx) == 2 || zoneHistory(zoneHistoryIdx) == 1 || zoneHistory(zoneHistoryIdx) == 3)
				% invalid logic before version 3.1
				% movement from zone 3,2 or 1 to any of those three zones which is not the same zone as the previous requires jumping a gap
				% the invalid logic existed in the context of entering and exiting the same zone, e.g. 3 -> 3
				jumpError = jumpError + 1;
				disp('Behavior Error! : jump error.')
				eventHistory = [eventHistory ; cellstr('Behavior Error! : jump error.') ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			end
			%
			%			
			% Are we in a zone?
			if strcmpi(eventStringArray(idx),strrep(eventStringArray(idx),'Exited', 'Exit'))
				% we're in a zone
				% because if we were *not* in a zone, we would not have exited, so the string would not have changed, so the compare is TRUE
				inAZone = true;
			else
				% we're not in a zone
				inAZone = false;
				% if the currentZone is not the same as the last zone, record the zone in the sequence history
				% the goal here is to make sequence error detection online simpler by smoothing out
				% the jumpiness of the zone detection software, and the ability of the rat to stand at the edge
				% of a zone and move his body in and out
				% disp(zoneHistory(1:30))
				if zoneHistory(zoneHistoryIdx) ~= currentZone
					zoneHistoryIdx = zoneHistoryIdx + 1;
					zoneHistory(zoneHistoryIdx) = currentZone;
                    disp([ 'lastZone ' num2str(zoneHistory(zoneHistoryIdx)) ' : inZone ' num2str(currentZone) ' : ready ' num2str(ready)  ' : ' char(eventStringArray(idx))])
				end
				currentZone = -1;
			end
            %
            % debug
            if (zoneHistoryIdx > 2 )
            %    disp(lastRewardedSequence)
                disp(zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx))
            end
   			%
			% Should sugar pellets rain from the sky?
			%
            if ( zoneHistoryIdx > 2 ) && currentZone == 3 && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~ isequal(lastRewardedSequence, [ 2 0 3 ] )
				lastRewardedSequence = [ 2 0 3 ];
				disp('lastRewardedSequence : ')
				disp(lastRewardedSequence);
                disp('pulse')
				NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
                pause(.5);
                NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
				% a fluffy logic block to fix the formating, because there doesn't seem to be a proper matlab solution to this
				if mod(pass, 60) == 0
					disp([num2str(round(pass/60)) ':00 -- made it rain']);
				elseif mod(pass, 60) < 10
					disp([num2str(round(pass/60)) ':0' num2str(mod(pass, 60)) ' -- made it rain']);
				else
					disp([num2str(round(pass/60)) ':' num2str(mod(pass, 60)) ' -- made it rain']);
				end
				% log event
				eventHistory = [eventHistory ; cellstr('made it rain') ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
				totalRewards = totalRewards + 1;
            elseif ( zoneHistoryIdx > 2 ) && currentZone == 1 && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~ isequal(lastRewardedSequence, [ 2 0 1 ] )
				lastRewardedSequence = [ 2 0 1 ];
				disp('lastRewardedSequence : ')
				disp(lastRewardedSequence);
				disp('pulse')
                NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
                pause(.5);
                NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
				% a fluffy logic block to fix the formating, because there doesn't seem to be a proper matlab solution to this
				if mod(pass, 60) == 0
					disp([num2str(round(pass/60)) ':00 -- made it rain']);
				elseif mod(pass, 60) < 10
					disp([num2str(round(pass/60)) ':0' num2str(mod(pass, 60)) ' -- made it rain']);
				else
					disp([num2str(round(pass/60)) ':' num2str(mod(pass, 60)) ' -- made it rain']);
				end
				% log event
				eventHistory = [eventHistory ; cellstr('made it rain') ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
				totalRewards = totalRewards + 1;
			elseif ( zoneHistoryIdx > 2 ) && ( currentZone == 1 || currentZone == 3 ) && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~isequal(lastRewardedSequence, zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx) )
				alternationError = alternationError + 1;
				disp('Behavior Error! : alternation error.')
				eventHistory = [eventHistory ; cellstr('Alternation Error! : alternation error.') ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
            end
            %
            %
%             if  ready
% 				ready = false;
%                 if left
%     				NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
%                     pause(.5);
%        				NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
%                     disp('LEFT (0)');
%                     left = false;
%                 else
%                     NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
%                     pause(.5);
%                     NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
%                     disp('RIGHT (2)');
%                     left = true;
%                 end;
% 				if mod(pass, 60) == 0
% 					disp([num2str(round(pass/60)) ':00 -- made it rain']);
% 				elseif mod(pass, 60) < 10
% 					disp([num2str(round(pass/60)) ':0' num2str(mod(pass, 60)) ' -- made it rain']);
% 				else
% 					disp([num2str(round(pass/60)) ':' num2str(mod(pass, 60)) ' -- made it rain']);
% 				end
% 				% log event
% 				eventHistory = [eventHistory ; 'made it rain' ];
% 				eventHistoryTimesNlx(eventIdx) = 0;
% 				eventHistoryTimesMatlab(eventIdx) = now();
% 				eventIdx = eventIdx + 1;
% 				totalRewards = totalRewards + 1;
% 			end
        end
        if totalRewards > 75 
            beep; beep; beep; beep;
            disp([ 'total rewards : ' num2str(totalRewards)]);
        end
		%
		%%%% Video Data
		%
		%
		% For future reference concerning video tracking :
		% locations are [ x y x y x y x y ... x y ]
		% [aa,bb, locationArray, cc, VTRecsReturned, dd] =NlxGetNewVTData(videoTrackerName)
		[ succeeded, timeStampArray, extractedLocationArray, extractedAngleArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewVTData(videoTrackerName);
		%
		% detect if any video records are dropped.
		%
		if numRecordsDropped > 0
			droppedVideoRecords = droppedVideoRecords + 1;
			disp(['System Error! : ' num2str(numRecordsDropped) ' video records dropped'])
			eventHistory = [eventHistory ; [num2str(numRecordsDropped) ' video records dropped!'] ];
			eventHistoryTimesNlx(eventIdx) = 0;
			eventHistoryTimesMatlab(eventIdx) = now();
			eventIdx = eventIdx + 1;
		end
		videoTimeStamps = [ videoTimeStamps timeStampArray];
		videoLocations = [ videoLocations extractedLocationArray];

    end

    % terminate event history
    %
    disp('-----------------------')
    %
    disp(['total rewards = ' num2str(totalRewards)])
    eventHistory = [eventHistory ; cellstr(['total rewards = ' num2str(totalRewards)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %
    disp(['stable zone occupacies = ' num2str(zoneHistoryIdx)])
    eventHistory = [eventHistory ; cellstr(['stable zone occupancies = ' num2str(zoneHistoryIdx)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %
    disp(['reward exit errors = ' num2str(rewardExitError)])
    eventHistory = [eventHistory ; cellstr(['rewardExitError = ' num2str(rewardExitError)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %
    disp(['center errors = ' num2str(centerError)])
    eventHistory = [eventHistory ; cellstr(['centerError = ' num2str(centerError)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %	
    disp(['jump errors = ' num2str(jumpError)])
    eventHistory = [eventHistory ; cellstr(['jumpError = ' num2str(jumpError)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %	
    disp(['choice point error = ' num2str(choicePointError)])
    eventHistory = [eventHistory ; cellstr(['choice Point Error = ' num2str(choicePointError)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %	
    disp(['corner errors = ' num2str(cornerError)])
    eventHistory = [eventHistory ; cellstr(['corner Error = ' num2str(cornerError)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %
    disp('-----------------------')
    %	
    disp(['dropped events = ' num2str(droppedEventRecords)])
    eventHistory = [eventHistory ; cellstr(['dropped events = ' num2str(droppedEventRecords)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %	
    disp(['dropped video records = ' num2str(droppedVideoRecords)])
    eventHistory = [eventHistory ; cellstr(['dropped video records = ' num2str(droppedVideoRecords)])];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %
    disp('-----------------------')
    %
    eventHistory = [eventHistory ; cellstr('end of trial') ];
    eventHistoryTimesNlx(eventIdx) = 0;
    eventHistoryTimesMatlab(eventIdx) = now();
    eventIdx = eventIdx + 1;
    %
    disp('-----------------------')

    %
    % store data to disk
    %
    runSummary.eventHistory = eventHistory;
    runSummary.eventHistoryTimesNlx = eventHistoryTimesNlx(1:min(find(eventHistoryTimesNlx==-1))-1);
    runSummary.eventHistoryTimesMatlab = eventHistoryTimesMatlab(1:min(find(eventHistoryTimesMatlab==-1))-1);
    runSummary.zoneHistory = zoneHistory(1:zoneHistoryIdx);
    runSummary.totalRewards = totalRewards;
    runSummary.stableZoneEntries = zoneHistoryIdx;
    runSummary.rewardExitError = rewardExitError;
    runSummary.centerError = centerError;
    runSummary.jumpError = jumpError;
    runSummary.choicePointError = choicePointError;
    runSummary.cornerError = cornerError;
    runSummary.version = version;
    runSummary.droppedEventRecords = droppedEventRecords;
    runSummary.droppedVideoRecords = droppedVideoRecords;
    runSummary.videoTimeStamps = videoTimeStamps;
    runSummary.videoLocations = videoLocations;
    runSummary.ratName = ratName;
    %
    %
    save([savePath 'makeItRain_' ratName '_' startTimeString '.mat'], 'runSummary');
    %
    disconnectResult = NlxDisconnectFromServer();
    %
    disp('makeItRain finished')
    beep
    return
    
end