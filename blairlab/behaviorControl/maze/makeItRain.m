function makeItRain()

serverName = 'PHYSIO_RIG';
eventLogName = 'Events';
timeToRun = 20 ;% minutes
% this needs 
path(path, 'C:\Documents and Settings\Dbuono\Desktop\NetComClientDevelopmentPackage_v211\Matlab_M-files');
zoneEntryIdx = 1;
zoneHistory = -1*ones(1,10000);

if ~NlxAreWeConnected()
	disconnectResult = NlxDisconnectFromServer();
	connectResult = NlxConnectToServer(serverName);
	if ~connectResult
		disp(['ERROR : Failed to connect to ' serverName ])
		return
	end
end

%locations are [ x y x y x y x y ... x y ]
%[aa,bb, locationArray, cc, VTRecsReturned, dd] =NlxGetNewVTData(videoTrackerName)
%NlxAreWeConnected()

openStreamResult = NlxOpenStream(eventLogName);
if ~openStreamResult
	disp(['ERROR : Failed to open stream ' eventLogName ])
	return
end

% make an initial attractive reward
NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
pause(1);
NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
pause(1);
NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
pause(1);
NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');


%lastZone = -1;
%currentZone = -1;
%lastSequence = [ currentZone lastZone ];
inAZone = false;
ready = false;

for pass = 1:(timeToRun*60)
	pause(1);
	[succeeded, timeStampArray, eventIDArray, ttlValueArray, eventStringArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewEventData('Events');
	for idx = 1:length(eventStringArray)
		% Oh where, oh where can my dear rat be? Oh where can my dear ratsky beeee? (sing this comment for added fun.)
		if strcmpi(eventStringArray(idx), 'Zoned Video: Zone0 Entered')
			zoneHistory(zoneEntryIdx) = 0;
		elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone1 Entered')
			zoneHistory(zoneEntryIdx) = 1;
		elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone2 Entered')
			zoneHistory(zoneEntryIdx) = 2;
		elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone3 Entered')
			zoneHistory(zoneEntryIdx) = 3;
		elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone4 Entered')
			zoneHistory(zoneEntryIdx) = 4;
			ready = true;
		elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone5 Entered')
			zoneHistory(zoneEntryIdx) = 5;
		end
		% Are we in a zone?
		if strcmpi(eventStringArray(idx),strrep(eventStringArray(idx),'Exited', 'Exit'))
			inAZone = false;
			% because if we were in a zone, we would not have exited, so the string would not have changed, so the compare is TRUE
		else
			inAZone = true;
		end
		% Should food rain from the sky?
		%
		% TODO : this isn't going to work properly, but it's a test.
		% mainly it's lacking alternation
		%disp(eventStringArray(idx))
		%disp(lastSequence)
		%disp(sum( lastSequence == [ currentZone lastZone ] ))
		%disp(( sum( lastSequence == [ currentZone lastZone ] ) == length(lastSequence) ))
		if zoneHistory(zoneEntryIdx) == 0 && ready
			ready = false;
			NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
			NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
			disp('made it rain');
		end
		% this goes AFTER the reward to make the indexing less obnoxious
		% If Ratsky entered a zone, increment the zone history index.
		if strcmpi(eventStringArray(idx),strrep(eventStringArray(idx),'Entered', 'Narf!'))
			zoneEntryIdx = zoneEntryIdx + 1;
		end
		disp(eventStringArray(idx))
	end
end


disconnectResult = NlxDisconnectFromServer();

end