%function makeItRain_v2()

close all
clear all

	ratName = 'agh';
	version = 'dual 4.5 four zone';
	timeToRun = 30; % minutes
	dispenseInitialReward = false;	% are we going to give an initial reward
	readyForTakeoff = true;
    maxRewards = 60;
    left=false;
    %
	serverName = 'PHYSIO_RIG';	% neuralynx router server name 
	eventLogName = 'Events';	% name of the Event stream object in neuralynx cheetah
	videoTrackerName = 'VT0';	% name of the Video Tracker stream object in neuralynx cheetah
    totalRewards = 0;
    lastRewardedSequence = [];
	% this needs the Neuralynx files in the include path. modify as needed.
    savePath = 'C:\Documents and Settings\Administrator\My Documents\ahowe\data\rhombus-maze\'
    left = false;
    waitForReset = false;
    maximumTime = 300; %minutes
	%
	droppedEventRecords = 0;
	droppedVideoRecords = 0;
	videoTimeStamps = [];
	videoLocations = [];
	%
    %ctrlFigure = figure;
    hud = figure();
    %
    trialOver = false;
    button = uicontrol('style','push','string','quit','callback','trialOver = true;');
  
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
	ready = false; %for pellet
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
	%
    % behavioral error tracking variables
    %
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
        %NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
        NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
        NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
        pause(.5);
		%NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
        %NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
        NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
        NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2

    end
    %
    %
    %
    % graphics stuff
    lookback=512;
    % TODO  ugh. please fix this ugliness (see below) soon TODO
    greyVector=fliplr(0:1/(lookback+1):1);
    greyArray=[greyVector;greyVector;greyVector];
    xx = [];
    yy = [];
    dx = [];
    ddx = [];
    %
    %
    beep; beep; pause(2); beep;
    %
	% main loop
	%
    tic;
    startTime = toc;
    for pass = 1:(maximumTime*60)
        if trialOver
            disp('Ending trial!!');
            beep;
            beep;
            break;
        end;

		[succeeded, timeStampArray, eventIDArray, ttlValueArray, eventStringArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewEventData('Events');
		%
		% If it is an even minute, provide time remaining in trial
		%
        tocNow = toc;
        if 0 == mod((maximumTime*60)-tocNow, 60 )
            %datestr(aa/(24*60*60),formatOut) % this is to format seconds
            %into fractions of a day...  'HH:MM:SS'
			disp(['T-Minus ' datestr((maximumTime*60)-tocNow/(24*60*60),'MM') ' minutes until lift off'])
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
			%disp([ 'lastZone ' num2str(zoneHistory(zoneHistoryIdx)) ' : inZone ' num2str(currentZone) ' : ready ' num2str(ready)  ' : ' char(eventStringArray(idx))])
			%
			if strcmpi(eventStringArray(idx), 'Zoned Video: Zone0 Entered')
				currentZone = 0;
            elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone1 Entered')
				currentZone = 1;
                waitForReset = false;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone2 Entered')
				currentZone = 2;
                ready=true;
			elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone3 Entered')
				currentZone = 3;
                waitForReset = false;
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
			% online sequence error detector
			%
			% this style of detection works because zoneHistory isn't updated until the rat exits a zone.
			%
			% TODO -- functionalize event additions
			%
			% TODO -- add comments about behavior error sequences.
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
            if zoneHistoryIdx > 3
                disp(zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx))
            end
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
				if zoneHistory(zoneHistoryIdx) ~= currentZone
					zoneHistoryIdx = zoneHistoryIdx + 1;
					zoneHistory(zoneHistoryIdx) = currentZone;
                    %disp([ 'lastZone ' num2str(zoneHistory(zoneHistoryIdx)) ' : inZone ' num2str(currentZone) ' : ready ' num2str(ready)  ' : ' char(eventStringArray(idx))])
				end
				currentZone = -1;
			end
   			%
			% Should sugar pellets rain from the sky?
			
            if ( zoneHistoryIdx > 2 ) && currentZone == 3 && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~ isequal(lastRewardedSequence, [ 2 0 3 ] )
				lastRewardedSequence = [ 2 0 3 ];
				NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
                pause(.1);
                NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
				% log event
                 tempStr = ['pellet awarded @ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ];
                 disp(tempStr);
                 eventHistory = [eventHistory ; cellstr(tempStr) ];
                eventHistoryTimesNlx(eventIdx) = 0;
                eventHistoryTimesMatlab(eventIdx) = now();
                eventIdx = eventIdx + 1;
                totalRewards = totalRewards + 1;
%                disp(zoneHistoryIdx(end-10:end))
            elseif ( zoneHistoryIdx > 2 ) && currentZone == 1 && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~ isequal(lastRewardedSequence, [ 2 0 1 ] )
				lastRewardedSequence = [ 2 0 1 ];
                NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
                pause(.1);
                NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
				% log event
                 tempStr = ['pellet awarded @ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ];
                 disp(tempStr);
                 eventHistory = [eventHistory ; cellstr(tempStr) ];
                eventHistoryTimesNlx(eventIdx) = 0;
                eventHistoryTimesMatlab(eventIdx) = now();
                eventIdx = eventIdx + 1;
                totalRewards = totalRewards + 1;
% 			elseif ( zoneHistoryIdx > 2 ) && ( currentZone == 1 || currentZone == 3 ) && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && isequal(lastRewardedSequence, zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx) )
% 				alternationError = alternationError + 1;
% 				disp('Behavior Error! : alternation error.')
% 				eventHistory = [eventHistory ; cellstr('Alternation Error! : alternation error.') ];
% 				eventHistoryTimesNlx(eventIdx) = 0;
% 				eventHistoryTimesMatlab(eventIdx) = now();
% 				eventIdx = eventIdx + 1;
             end
        end
        %
%         if ready
%             tempStr = ['pellet awarded @ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ];
%             disp(tempStr);
%             eventHistory = [eventHistory ; cellstr(tempStr) ];
%     		eventHistoryTimesNlx(eventIdx) = 0;
% 			eventHistoryTimesMatlab(eventIdx) = now();
% 			eventIdx = eventIdx + 1;
% 			totalRewards = totalRewards + 1;
%             if left
%                 NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
%                 pause(.1);
%                 NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
%                 left=false;
%             else
%                 NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
%                 pause(.1);
%                 NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
%                 left=true;
%             end
%             ready = false;
%             waitForReset = true;
%             rewardDisplayToggle = true;
%         end

%             if ready && ( zoneHistoryIdx > 2 ) && currentZone == 0 && isequal( zoneHistory(zoneHistoryIdx-1:zoneHistoryIdx), [ 4 2 ] )
%                 if left
%                     NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
%                     pause(.1);
%                     NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 2 High');
%                     left=false;
%                 else
%                     NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
%                     pause(.1);
%                     NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High');
%                     left=true;
%                 end
%                 ready = false;
%                 waitForReset = true;
%                 rewardDisplayToggle = true;				% log event
%                 tempStr = ['pellet awarded @ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ];
%                 disp(tempStr);
%                 eventHistory = [eventHistory ; cellstr(tempStr) ];
%                 eventHistoryTimesNlx(eventIdx) = 0;
%                 eventHistoryTimesMatlab(eventIdx) = now();
%                 eventIdx = eventIdx + 1;
%                 totalRewards = totalRewards + 1;
%             end

%         if (totalRewards > 0) && (0 == mod(totalRewards, 10)) && rewardDisplayToggle
%             disp([ '@ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ' total rewards : ' num2str(totalRewards)]);
%             rewardDisplayToggle = false;
%         elseif totalRewards > maxRewards 
%             beep; beep; beep; beep;
%             disp([ 'total rewards : ' num2str(totalRewards)]);
%         end
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
        %calculate the speed of the rat

        if length(videoLocations) > 99;
            figure(hud);
            % 2-D spatial location calculations for building plots
            txx=extractedLocationArray([1:2:length(extractedLocationArray)]);
            tyy=extractedLocationArray([2:2:length(extractedLocationArray)]);
            xx = [ xx, txx ];
            yy = [ yy, tyy ];
            % plot linear velocity
            if ( length(txx) == 0 ) || ( length(tyy) == 0 )
                disp('bad video data')
            else
                % TODO empty txx and or tyy cause problems
                tdx=sqrt(cast(((txx(2:length(txx))-txx(1:length(txx)-1))^2+(tyy(2:length(tyy))-tyy(1:length(tyy)-1))^2), 'double'));
                % zero out big jumps
                % 30 is a magic number; I think I got it by looking at a histogram.
                tdx(find((tdx>30)))=0;
                dx=[dx, tdx];
                subplot(4,5,3:5)
                lookback=1000;
                if length(dx) > lookback+3
                    plot(dx(end-lookback:end),'g')
                    axis([ -10 1.03*(lookback)  -5 1.03*max(dx) ]);
                else
                    plot(dx, 'g')
                    axis([ 0 1.03*length(dx)  -1 1.03*max(dx) ]);
                end
                % plot linear acceleration
                tddx=tdx(2:length(tdx))-tdx(1:length(tdx)-1);
                ddx=[ddx, tddx];
                subplot(4,5,8:10)
                if length(ddx) > lookback+3
                    plot(ddx(end-lookback:end), 'r');
                    if min(ddx) == max(ddx)
                        axis([ -10 lookback  -1 1 ]);
                    else
                        axis([ -10 lookback  min(ddx) 1.03*max(ddx) ]);
                    end
                else
                    plot(ddx, 'r');
                    %axis([ 0 1.03*length(ddx)  min(ddx) 1.03*max(ddx) ]);
                end
            end
            %
            % plot all locations occupied and then the last 512 locations occupied with
            % a black to white gradient of big circles
            %
            subplot(4,5,[1,2,6,7])
            hold off;
            lookback=512;
            plot(xx,yy,'.')
            hold on;
            if length(xx) > lookback + 3
                for idx = 0:lookback-1
                    plot(xx(length(xx)-idx),yy(length(xx)-idx),'*', 'MarkerFaceColor',greyArray(:,idx+1),'MarkerEdgeColor',greyArray(:,idx+1));
                end
                axis([ 150 620 0 470]);
                title('recent XY (bk->wt; old->now)')
            end
            %
            % image of rat
            %
            subplot(4,5,[13 14 18 19])
            image(imread('http://164.67.14.239/oneshotimage.jpg'));
            %
            % transition map for zones --> basically Bayseian transition probability of
            % motion.
            %
            if 0 == mod(round(tocNow),20);
                subplot(4,5,20)
                zoneNumberMinOffset = (1-min(zoneHistory(1:zoneHistoryIdx)) );
                possibleZones = max(zoneHistory(1:zoneHistoryIdx))+zoneNumberMinOffset;
                trans = zeros(possibleZones,possibleZones);
                for idx = 2 : length(zoneHistory(1:zoneHistoryIdx));
                    trans(zoneHistory(idx-1)+zoneNumberMinOffset,zoneHistory(idx)+zoneNumberMinOffset) = 1 + trans(zoneHistory(idx-1)+zoneNumberMinOffset,zoneHistory(idx)+zoneNumberMinOffset);
                end;
                qq=colormap;
                colormap([1 1 1; qq])
                imagesc(trans/sum(sum(trans)))
                %colorbar()
                subplot(4,5,15)
                %imagesc(trans/sum(sum(trans)))
                plot(1,totalRewards,'o')
                axis([ 0 2 0 1.03*maxRewards])
                %
                % the nice version of the colormap for occupancy.
                %
                subplot(4,5,[11,12,16,17])
                occupationHeat=zeros(max(yy)+1,max(xx)+1);
                for idx=1:length(xx)
                    occupationHeat(yy(idx)+1,xx(idx)+1)=occupationHeat(yy(idx)+1,xx(idx)+1)+1;
                end
                hold off;
                plot(xx,yy,'.k'); 
                hold on;
                markersize=4;
                [rr,cc,vv]=find(occupationHeat>2);
                plot(cc,rr,'.b','MarkerSize', markersize);
                [rr,cc,vv]=find(occupationHeat>4);
                plot(cc,rr,'.c','MarkerSize', markersize);
                [rr,cc,vv]=find(occupationHeat>6);
                plot(cc,rr,'.g','MarkerSize', markersize);
                [rr,cc,vv]=find(occupationHeat>8);
                plot(cc,rr,'.y','MarkerSize', markersize);
                [rr,cc,vv]=find(occupationHeat>10);
                plot(cc,rr,'.m','MarkerSize', markersize);
                [rr,cc,vv]=find(occupationHeat>15);
                plot(cc,rr,'.r','MarkerSize', markersize);
                axis([ 150 620 0 470])
                %title('Fig 8 Maze Occupancy','FontWeight','bold','FontName','Arial');
                %xlabel('X coord. (px)','FontName','Arial');
                %ylabel('Y coord. (px)','FontName','Arial');
                %colormap([1 1 1; 0 0 0; 0 0 1; 0 1 1; 0 1 0; 1 1 0; 1 0 1; 1 0 0])
                %colorbar('YTickLabel',{'0','1','2','4','6','8','10','15'});
            end
        end
    end
    %
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
    
%end