function makeItRain_v2()

	ratName = 'v1';
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

	disp('Starting makeItRain...')
	disp(['rat = ' ratName])
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
	% run from 2 -> 4 - ( 1 | 2 | 3 ) - > 0 = reward
	ready = false;
	% 
	% track zone sequences for live error detection
	% 
	zoneHistory = -1 * ones(1,10000);
	zoneHistory(1) = -2 ; % this is such a lazy hack.
	zoneHistoryTimes = zeros(size(zoneHistory));
	zoneHistoryIdx = 2; %starts at two because the indexing is silly.
	

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
			disp(['System Error! : ' num2str(numRecordsDropped) ' records dropped'])
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
			disp([ 'lastZone ' num2str(zoneHistory(zoneHistoryIdx-1)) ' : inZone ' num2str(currentZone) ' : ready ' num2str(ready)  ' : ' char(eventStringArray(idx))])
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
				if zoneHistory(zoneHistoryIdx-1) == 2
					ready = true;
				end
				currentZone = 4;
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
				%disp(zoneHistory(1:30))
				if zoneHistory(zoneHistoryIdx-1) ~= currentZone
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
				ready = false;
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
			% TODO -- implement alternation error detection
			%
			if ( currentZone == 3 || currentZone == 1 ) && zoneHistory(zoneHistoryIdx-1) == 0
				% 0 -> ( 3 | 1 ) is a reward exit error
				rewardExitError = rewardExitError + 1;
				disp('Behavior Error! : reward zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : reward zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif ( currentZone == 0 ) && zoneHistory(zoneHistoryIdx-1) == 2
				centerError = centerError + 1;
				disp('Behavior Error! : center zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : center zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif ( currentZone == 3 || currentZone == 1 || currentZone == 2 ) && ( zoneHistory(zoneHistoryIdx-1) == 2 || zoneHistory(zoneHistoryIdx-1) == 1 || zoneHistory(zoneHistoryIdx-1) == 3)
				jumpError = jumpError + 1;
				disp('Behavior Error! : jump error.')
				eventHistory = [eventHistory ; 'Behavior Error! : jump error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif currentZone == 2 && zoneHistory(zoneHistoryIdx-1) == 4
				choicePointError = choicePointError + 1;
				disp('Behavior Error! : choice point zone exit error.')
				eventHistory = [eventHistory ; 'Behavior Error! : choice point zone exit error.' ];
				eventHistoryTimesNlx(eventIdx) = 0;
				eventHistoryTimesMatlab(eventIdx) = now();
				eventIdx = eventIdx + 1;
			elseif currentZone == 4 && ( zoneHistory(zoneHistoryIdx-1) == 1 || zoneHistory(zoneHistoryIdx-1) == 3 )
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
	disp('-----------------------')
	%
	disp(['total rewards = ' num2str(totalRewards)])
	eventHistory = [eventHistory ; ['total rewards = ' num2str(totalRewards)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%
	disp(['stable zone occupacies = ' num2str(length(zoneHistory(1:min(find(zoneHistory==-1))-1)))])
	eventHistory = [eventHistory ; ['stable zone occupancies = ' num2str(length(zoneHistory(1:min(find(zoneHistory==-1))-1)))]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%
	disp(['reward exit errors = ' num2str(rewardExitError)])
	eventHistory = [eventHistory ; ['rewardExitError = ' num2str(rewardExitError)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%
	disp(['center errors = ' num2str(centerError)])
	eventHistory = [eventHistory ; ['centerError = ' num2str(centerError)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%	
	disp(['jump errors = ' num2str(jumpError)])
	eventHistory = [eventHistory ; ['jumpError = ' num2str(jumpError)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%	
	disp(['choice point error = ' num2str(choicePointError)])
	eventHistory = [eventHistory ; ['choice Point Error = ' num2str(choicePointError)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%	
	disp(['corner errors = ' num2str(cornerError)])
	eventHistory = [eventHistory ; ['corner Error = ' num2str(cornerError)]];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%
	eventHistory = [eventHistory ; 'end of trial' ];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	%
	disp('-----------------------')
	
	%
	% store data to disk
	%
	% pre-package data
	%
	% e.g. zoneHistory(1:min(find(zoneHistory==-1))-1) ; % ineer to outer : find all the -1 (i.e. unused) entries, get the minimum index for -1 values and subselect only the 1:prior to that -1 index.
	%
	runSummary.eventHistory = eventHistory;
	runSummary.eventHistoryTimesNlx = eventHistoryTimesNlx(1:min(find(eventHistoryTimesNlx==-1))-1);
	runSummary.eventHistoryTimesMatlab = eventHistoryTimesMatlab(1:min(find(eventHistoryTimesMatlab==-1))-1);
	runSummary.zoneHistory = zoneHistory(1:min(find(zoneHistory==-1))-1);
	runSummary.totalRewards = totalRewards;
	runSummary.stableZoneEntries = length(zoneHistory(1:min(find(zoneHistory==-1))-1));
	runSummary.rewardExitError = rewardExitError;
	runSummary.centerError = centerError;
	runSummary.jumpError = jumpError;
	runSummary.choicePointError = choicePointError;
	runSummary.cornerError = cornerError;
	save(['makeItRain_' ratName '_' startTimeString '.mat'], 'runSummary');
	
	disconnectResult = NlxDisconnectFromServer();
	
	disp('makeItRain finished')
	beep

end