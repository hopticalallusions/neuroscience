function makeItRain_v2()

	serverName = 'PHYSIO_RIG';	% neuralynx router server name 
	eventLogName = 'Events';	% name of the stream structure in neuralynx cheetah
	timeToRun = 20 ;% minutes
	dispenseInitialReward = true;	% are we going to give an initial reward
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
	ready = false;
	currentZone = -1;

	%
	% set up history variables
	%
	eventIdx = 1;
	eventHistory = [];
	eventHistoryTimesNlx = -1 * ones(1,10000);
	eventHistoryTimesMatlab = -1 * ones(1,10000);
	%
	% initialize history
	%
	eventHistory(eventIdx) = cellstr(['starting trial']);
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;
	
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
				ready = true;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone5 Entered')
				currentZone = 5;
			end
			% Are we in a zone?
			if strcmpi(eventStringArray(idx),strrep(eventStringArray(idx),'Exited', 'Exit'))
				inAZone = false;
				currentZone = -1;
				% because if we were in a zone, we would not have exited, so the string would not have changed, so the compare is TRUE
			else
				inAZone = true;
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
			end
		end
	end

	%
	% terminate event history
	%
	eventHistory = [eventHistory ; 'end of trial' ];
	eventHistoryTimesNlx(eventIdx) = 0;
	eventHistoryTimesMatlab(eventIdx) = now();
	eventIdx = eventIdx + 1;

	%
	% store data to disk
	%
	save(['makeItRain_eventHistory_' startTimeString], 'eventHistory');
	save(['makeItRain_eventHistoryTimes_' startTimeString], 'eventHistoryTimesNlx');
	save(['makeItRain_eventHistoryTimes_' startTimeString], 'eventHistoryTimesMatlab');

	disconnectResult = NlxDisconnectFromServer();
	
	disp('makeItRain finished')
	%fclose(logFileId);
	beep

end