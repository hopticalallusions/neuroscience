function makeItRain_v2()

	serverName = 'PHYSIO_RIG';	% neuralynx router server name 
	eventLogName = 'Events';	% name of the stream structure in neuralynx cheetah
	timeToRun = 20 ;% minutes
	dispenseInitialReward = true;	% are we going to give an initial reward
	totalRewards = 0;
	% this needs the Neuralynx files in the include path. modify as needed.
	path(path, 'C:\Documents and Settings\Dbuono\Desktop\NetComClientDevelopmentPackage_v211\Matlab_M-files');

	%
	% store timestamp for execution
	%
	startTimeString = [datestr(date) '_' num2str(now)];
%	logFileName = ['makeItRain_eventLog_' startTimeString '.mat.log'];
%	logFileId = fopen(logFileName, 'w');

	disp('Starting makeItRain...')
%	fprintf(logFileId, '%22	%22s\r\n', [datestr(date) '_' num2str(now)], 'Starting makeItRain...');
	% turn on OS warning sound
	beep on;


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

	%
	% For future reference concerning video tracking :
	% locations are [ x y x y x y x y ... x y ]
	% [aa,bb, locationArray, cc, VTRecsReturned, dd] =NlxGetNewVTData(videoTrackerName)
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
	% make an initial attractive reward
	%
	if dispenseInitialReward
		disp('Dispensing an initial reward...')
		NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
		pause(1);
		NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
		pause(1);
		NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
	end
	
	% set up some state variables
	inAZone = false;
	currentZone = -1;
	% run from 2 -> 4 -> ( 1 | 3 ) -> 0 = reward
	% zone 2 = stepOne = True
	% zone 4 && stepOne = True
	% zone (1 | 3) && stepOne && stepTwo = True
	% zone 0 && stepOne && stepTwo && stepThree = Reward!
	stepOne = false;
	stepTwo = false;
	stepThree = false;
	% 
	% track zone sequences for live error detection
	% 
	zoneHistory = -1 * ones(1,10000);
	zoneHistoryTimes = zeros(size(zoneHistory));
	zoneHistoryIdx = 1;
	

	%
	% set up history variables
	%
	eventIdx = 1;
	% eventHistory = [];
	eventHistoryTimesNlx = -1 * ones(1,10000);
	eventHistoryTimesMatlab = -1 * ones(1,10000);
	%
	% initialize history
	%
	eventHistory = cellstr(['starting trial']);
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	
	
	% behavioral error tracking variables
	rewardExitError = 0;
	centerError = 0;
	jumpError = 0;
	choicePointError = 0;
	cornerError = 0;

	
	%
	% main loop
	%
	for pass = 1:(timeToRun*60)
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
		end
		%
		% detect if any records are dropped.
		%
		if numRecordsDropped > 0
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
			disp(['stepOne ' num2str(stepOne) ' : stepTwo ' num2str(stepTwo) ' : stepThree ' num2str(stepThree) ' : inZone ' num2str(currentZone) ' : ' char(eventStringArray(idx))])
			%
			% Oh where, oh where can my dear rat be? Oh where can my dear ratsky beeee? (sing this comment for added fun.)
			%
			if strcmpi(eventStringArray(idx), 'Zoned Video: Zone0 Entered')
				currentZone = 0;
			elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone1 Entered')
				currentZone = 1;
				if ( stepOne == true ) && ( stepTwo == true ) 
					stepTwo = true;
				end
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone2 Entered')
				currentZone = 2;
				stepOne = true;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone3 Entered')
				currentZone = 3;
				if ( stepOne == true ) && ( stepTwo == true ) 
					stepTwo = true;
				end
			elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone4 Entered')
				currentZone = 4;
				if stepOne == true
					stepTwo = true;
				end
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone5 Entered')
				currentZone = 5;
			end
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
				if zoneHistory(zoneHistoryIdx) ~= currentZone
					zoneHistory(zoneHistoryIdx) = currentZone;
					zoneHistoryIdx = zoneHistoryIdx + 1;
				end
				currentZone = -1;
			end
			%
			% Should sugar pellets rain from the sky?
			%
			% TODO : this isn't going to work properly, but it's a test.
			% mainly it's lacking alternation
			if currentZone == 0 && ready
				stepOne = false;
				stepTwo = false;
				stepThree = false;
				NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
				disp([num2str(round(pass/60)) ':' num2str(mod(pass, 60)) ' -- made it rain']);
				% log event
				eventHistory = [eventHistory ; 'made it rain' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
				totalRewards = totalRewards + 1;
			end

			%
			% online sequence error detector
			%
			% this style of detection works because zoneHistory isn't updated until the rat exits a zone.
			%
			% TODO -- functionalize event additions
			%
			% TODO -- add comments about behavior error sequences.
			%
			if ( currentZone == 3 || currentZone == 1 ) && zoneHistory(zoneHistoryIdx) == 0
				% 0 -> ( 3 | 1 ) is a reward exit error
				rewardExitError = rewardExitError + 1;
				disp('Behavior Error! : reward zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : reward zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif ( currentZone == 0 ) && zoneHistory(zoneHistoryIdx) == 2
				centerError = centerError + 1;
				disp('Behavior Error! : center zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : center zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif ( currentZone == 3 || currentZone == 1 ) && zoneHistory(zoneHistoryIdx) == 2
				jumpError = jumpError + 1;
				disp('Behavior Error! : jump error.')
				eventHistory = [eventHistory ; 'Behavior Error! : jump error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif currentZone == 2 && zoneHistory(zoneHistoryIdx) == 4
				choicePointError = choicePointError + 1;
				disp('Behavior Error! : choice point zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : choice point zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif currentZone == 4 && ( zoneHistory(zoneHistoryIdx) == 1 || zoneHistory(zoneHistoryIdx) == 3 )
				cornerError = cornerError + 1;
				disp('Behavior Error! : corner zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : corner zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			end
		end
	end

	%
	% terminate event history
	%
	eventHistory = [eventHistory ; ['total rewards = ' num2str(totalRewards)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%
	eventHistory = [eventHistory ; 'end of trial' ];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;

	
	%
	% store data to disk
	%
	save(['makeItRain_eventHistory_' startTimeString '.mat'], 'eventHistory');
	save(['makeItRain_eventHistoryTimes_' startTimeString '.mat'], 'eventHistoryTimesNlx');
	save(['makeItRain_eventHistoryTimes_' startTimeString '.mat'], 'eventHistoryTimesMatlab');

	disconnectResult = NlxDisconnectFromServer();
	
	disp('makeItRain finished')
	disp(['total rewards = ' num2str(totalRewards)])
	%fclose(logFileId);
	beep

end