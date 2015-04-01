%function makeItRain_v2()

close all
clear all

%%%%%%%
%
% Setup run data
%
%%%%%%%

ratName = 'v4';                 % name of rat
version = 'platter v1.11';         % version number for tracking which program used this; *manual*
timeToRun = 25;                 % minutes
maximumTime = 65;               % minutes
maxRewards = 100;                % pellets
dispenseInitialReward = true;	% are we going to give an initial reward
readyForTakeoff = true;         % false = wait for a signal to start
                                %       true = start immediately
left=false;                     % is the rat "right" or "left" handed

%%%%%%%
%
% Setup system information
%
%%%%%%%

serverName = 'PHYSIO_RIG';	% neuralynx router server name 
nlxEventLogName = 'Events';	% name of the Event stream object in neuralynx cheetah
videoTrackerName = 'VT0';	% name of the Video Tracker stream object in neuralynx cheetah
% this needs the Neuralynx files in the include path. modify as needed.
% it might be a good idea to check if these are available
savePath = 'C:\Documents and Settings\Administrator\My Documents\ahowe\data\rhombus-maze\';

%%%%%%%
%
% Initialize program 
%
%%%%%%%

% store timestamp for execution
startTimeString = [datestr(date) '_' num2str(now)];

events = eventLog();
events = logEvent( events, ['starting trial @ ', startTimeString], true );
events = logEvent( events, ['rat = ' ratName], true );

trialOver = false;
waitForReset = false;
totalRewards = 0;
lastRewardedSequence = [];

droppedEventRecords = 0;
droppedVideoRecords = 0;
videoTimeStamps = [];
videoLocations = [];


hud = figure();
button = uicontrol('style','push','string','quit','callback','trialOver = true;');


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
openStreamResult = NlxOpenStream(nlxEventLogName);
if ~openStreamResult
    disp(['ERROR : Failed to open stream ' nlxEventLogName ])
    beep;
    return
else
    disp(['Successfully opened ' nlxEventLogName])
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
%
% set up some state variables
%
inAZone = false;
currentZone = -1;
ready = false; %for pellet

% 
% track zone sequences for live error detection
% 
zoneHistory = -1 * ones(1,10000);
zoneHistoryTimes = zeros(size(zoneHistory));
zoneHistoryIdx = 1; %starts at two because the indexing is silly.

%
% behavioral error tracking variables
%
rewardExitError = 0;
centerError = 0;
jumpError = 0;
choicePointError = 0;
cornerError = 0;
alternationError = 0;
trialStartError = 0;

%%%%%%%
%
% Wait to start trial?
%
%%%%%%%

for waitingCounter = 1:(maximumTime*60)
    pause(1);
    [succeeded, timeStampArray, eventIDArray, ttlValueArray, eventStringArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewEventData('Events');
    % process event stream
    for idx = 1:length(eventStringArray)
        if strcmpi(eventStringArray(idx), 'Zoned Video: Zone6 Entered')
            readyForTakeoff = true;
            break;
        end
    end
    if readyForTakeoff
        % this foolishness is required to break the nested loops. :-/
        break;
    end
end



%%%%%%%
%
% Start trial
%
%%%%%%%

events = logEvent( events, 'Trial has gone live!', true );

% this sound sequence notifies us that the trial is live
beep; beep; pause(2); beep;

% make an initial attractive reward
if dispenseInitialReward
    events = logEvent( events, 'Dispensing an initial reward...', true );
    %
    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
    pause(.5);
    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
end

% graphics stuff
lookback=512;
% TODO  ugh. please fix this ugliness (see below) soon TODO
greyVector=fliplr(0:1/(lookback+1):1);
greyArray=[greyVector;greyVector;greyVector];
xx = [];
yy = [];
dx = [];
ddx = [];



left = false;
ready = false;
unilateral = 0;



%%%%%%%
%
% MAIN LOOP
%
%%%%%%%

tic;
startTime = toc;
elapsedTime = toc - startTime; % seconds

while (trialOver == false ) && ( elapsedTime < maximumTime*60 )

    %
    % Every 3-ish minutes, provide time elapsed
    %

    elapsedTime = toc - startTime; % seconds
    
    if 0 == mod( floor(elapsedTime), 180 )
        % datestr(aa/(24*60*60),formatOut) % this is to format seconds
        %     into fractions of a day...  'HH:MM:SS'
        disp(['Elapsed Time : ' datestr(elapsedTime/(24*60*60),'HH:MM:SS') ])
        if elapsedTime > timeToRun*60
            disp('!!! Trial is over !!!'); beep;
        end
    end

    %
    % retrieve neuralynx event data
    %
    [succeeded, timeStampArray, eventIDArray, ttlValueArray, eventStringArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewEventData(nlxEventLogName);
    %
    % detect if any event records are dropped.
    %
    if numRecordsDropped > 0
        droppedEventRecords = droppedEventRecords + 1;
        events = logEvent( events, ['System Error! : ' num2str(numRecordsDropped) ' event records dropped'], true );
    end

    %%%%%%%
    %
    % process all events in a loop
    %
    %%%%%%%

    for idx = 1:length(eventStringArray)
        
        % store event history
        events = logEvent( events, eventStringArray(idx), false, timeStampArray(idx) );
        
        %
        % parse events into meaningfulness
        %
        if strcmpi(eventStringArray(idx), 'Zoned Video: Zone0 Entered')
            currentZone = 0;
        elseif  strcmpi(eventStringArray(idx), 'Zoned Video: Zone1 Entered')
            currentZone = 1;
            ready = true;
        elseif strcmpi(eventStringArray(idx), 'Zoned Video: Zone2 Entered')
            currentZone = 2;
            ready=true;
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

%         %
%         % online sequence error detector
%         %
%         % this style of detection works because zoneHistory isn't updated until the rat exits a zone.
%         % TODO -- functionalize event additions
%         % TODO -- add comments about behavior error sequences.
%         % TODO -- these are all backwards for lefties
%         %
%         if ( currentZone == 3 || currentZone == 1 ) && zoneHistory(zoneHistoryIdx) == 4
%             % 4 -> ( 3 | 1 ) is a trial start error where animal goes to
%             % reward zone without passing through the center
%             trialStartError = trialStartError + 1;
%             events = logEvent( events, [ 'Behavior Error! : Start point to reward zone; ', num2str(zoneHistory(zoneHistoryIdx)), ' -> ', num2str(currentZone) ], true );
%         elseif ( currentZone == 4 ) && zoneHistory(zoneHistoryIdx) == 2
%             centerError = centerError + 1;
%             events = logEvent( events, [ 'Behavior Error! : Center to start point; ', num2str(zoneHistory(zoneHistoryIdx)), ' -> ', num2str(currentZone) ], true );
%         elseif (zoneHistory(zoneHistoryIdx) ~= currentZone) && ( currentZone == 3 || currentZone == 1 || currentZone == 2 ) && ( zoneHistory(zoneHistoryIdx) == 2 || zoneHistory(zoneHistoryIdx) == 1 || zoneHistory(zoneHistoryIdx) == 3)
%             % invalid logic before version 3.1
%             % movement from zone 3,2 or 1 to any of those three zones which is not the same zone as the previous requires jumping a gap
%             % the invalid logic existed in the context of entering and exiting the same zone, e.g. 3 -> 3
%             jumpError = jumpError + 1;
%             events = logEvent( events, [ 'Behavior Error! : Jump error; ', num2str(zoneHistory(zoneHistoryIdx)), ' -> ', num2str(currentZone) ], true );
%         elseif (( currentZone == 2 ) && zoneHistory(zoneHistoryIdx) == 0)
%             % if the rat goes from the choice point to the center
%             choicePointError = choicePointError + 1;
%             events = logEvent( events, [ 'Behavior Error! : Choice Point to Reward Zone; ', num2str(zoneHistory(zoneHistoryIdx)), ' -> ', num2str(currentZone) ], true );
%         elseif ( currentZone == 0 ) && ( zoneHistory(zoneHistoryIdx) == 1 || zoneHistory(zoneHistoryIdx) == 3 )
%             % if the rat goes from the reward point to the choice point
%             cornerError = cornerError + 1;
%             events = logEvent( events, [ 'Behavior Error! : Corner error; ', num2str(zoneHistory(zoneHistoryIdx)), ' -> ', num2str(currentZone) ], true );
%         end
        

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
            end
            currentZone = -1;
        end

        %
        % Should sugar pellets rain from the sky?
        %
        if currentZone == 0
            if unilateral > 1
                unilateral = 0;
                if left
                    left = false;
                else
                    left = true;
                end
            end
            if ready
                unilateral = unilateral + 1;
                if left
                    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
                    pause(.1);
                    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
                    events = logEvent( events, ['pellet awarded port 1 @ '  datestr(toc()/(24*60*60),'HH:MM:SS.FFF') ], true );
                else
                    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
                    pause(.1);
                    NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
                    events = logEvent( events, ['pellet awarded port 2 @ '  datestr(toc()/(24*60*60),'HH:MM:SS.FFF') ], true );
                end
                ready = false;
                totalRewards = totalRewards + 1;
            end
        elseif currentZone == 1 || currentZone == 2
            ready = true;
        end

        

%         if ( zoneHistoryIdx > 2 ) && currentZone == 3 && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~ isequal(lastRewardedSequence, [ 2 0 3 ] )
%             lastRewardedSequence = [ 2 0 3 ];
%             NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
%             pause(.1);
%             NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 2 0 High'); % master 8 port 1
%             % log event
%             events = logEvent( events, ['pellet awarded @ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ], true );
%             totalRewards = totalRewards + 1;
%         elseif ( zoneHistoryIdx > 2 ) && currentZone == 1 && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && ~ isequal(lastRewardedSequence, [ 2 0 1 ] )
%             lastRewardedSequence = [ 2 0 1 ];
%             NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
%             pause(.1);
%             NlxSendCommand('-DigitalIOTtlPulse PCI-DIO24_0 0 6 High'); % master 8 port 2
%             % log event
%             events = logEvent( events, ['pellet awarded @ '  datestr(tocNow/(24*60*60),'HH:MM:SS.FFF') ], true );
%             totalRewards = totalRewards + 1;
%         elseif ( zoneHistoryIdx > 2 ) && ( currentZone == 1 || currentZone == 3 ) && isequal( zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx), [ 4 2 0 ] ) && isequal(lastRewardedSequence, zoneHistory(zoneHistoryIdx-2:zoneHistoryIdx) )
%             alternationError = alternationError + 1;
%             events = logEvent( events, 'Behavior Error! : alternation error.', true );
%         end
    end
    
    %
    %%%% Video Data
    %
    % For future reference concerning video tracking :
    % locations are [ x y x y x y x y ... x y ]
    [ succeeded, timeStampArray, extractedLocationArray, extractedAngleArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewVTData(videoTrackerName);
    % detect if any video records are dropped.
    if numRecordsDropped > 0
        droppedVideoRecords = droppedVideoRecords + numRecordsDropped;
        events = logEvent( events, ['System Error! : ' num2str(numRecordsDropped) ' video records dropped'], true );
    end
    %
    videoTimeStamps = [ videoTimeStamps timeStampArray];
    videoLocations = [ videoLocations extractedLocationArray];
    %
    %calculate the speed of the rat
    if length(videoLocations) > 99;
        figure(hud);
        % 2-D spatial location calculations for building plots
        txx=extractedLocationArray( 1:2:length(extractedLocationArray) );
        tyy=extractedLocationArray( 2:2:length(extractedLocationArray) );
        xx = [ xx, txx ];
        yy = [ yy, tyy ];
        % plot linear velocity
        if isempty(txx) || isempty(tyy)
            disp('bad video data')
        else
            % TODO empty txx and or tyy cause problems
            tdx=sqrt(cast(((txx(2:length(txx))-txx(1:length(txx)-1))^2+(tyy(2:length(tyy))-tyy(1:length(tyy)-1))^2), 'double'));
            % zero out big jumps
            % 30 is a magic number; I think I got it by looking at a histogram.
            tdx(tdx>30)=0;
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
        plot(xx,-1*yy,'.')
        hold on;
        if length(xx) > lookback + 3
            for idx = 0:lookback-1
                plot(xx(length(xx)-idx),-1*yy(length(xx)-idx),'*', 'MarkerFaceColor',greyArray(:,idx+1),'MarkerEdgeColor',greyArray(:,idx+1));
            end
        end
        plot(xx(end),yy(end),'*r')
        axis([ 150 620  -470 0]);
        title('recent XY (bk->wt; old->now)')
        %
        % image of rat
        %
        %subplot(4,5,[13 14 18 19])
        %image(imread('http://164.67.14.239/oneshotimage.jpg'));
        %
        % transition map for zones --> basically Bayseian transition probability of
        % motion.
        %
        if 0 == mod(round(elapsedTime),5);
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
            plot(1,totalRewards,'o');
            hold on;
            plot(1,maxRewards,'*r');
            hold off;
            axis([ 0 2 0 1.03*max([maxRewards totalRewards])])
            %
            % the nice version of the colormap for occupancy.
            %
            subplot(4,5,[11,12,16,17])
            occupationHeat=zeros(max(yy)+1,max(xx)+1);
            for idx=1:length(xx)
                occupationHeat(yy(idx)+1,xx(idx)+1)=occupationHeat(yy(idx)+1,xx(idx)+1)+1;
            end
            hold off;
            plot(xx,-1*yy,'.k');
            hold on;
            markersize=4;
            [rr,cc]=find(occupationHeat>2);
            plot(cc,-1*rr,'.b','MarkerSize', markersize);
            [rr,cc]=find(occupationHeat>4);
            plot(cc,-1*rr,'.c','MarkerSize', markersize);
            [rr,cc]=find(occupationHeat>6);
            plot(cc,-1*rr,'.g','MarkerSize', markersize);
            [rr,cc]=find(occupationHeat>8);
            plot(cc,-1*rr,'.y','MarkerSize', markersize);
            [rr,cc]=find(occupationHeat>10);
            plot(cc,-1*rr,'.m','MarkerSize', markersize);
            [rr,cc]=find(occupationHeat>15);
            plot(cc,-1*rr,'.r','MarkerSize', markersize);
            axis([ 150 620 -470 0])
            %title('Fig 8 Maze Occupancy','FontWeight','bold','FontName','Arial');
            %xlabel('X coord. (px)','FontName','Arial');
            %ylabel('Y coord. (px)','FontName','Arial');
            %colormap([1 1 1; 0 0 0; 0 0 1; 0 1 1; 0 1 0; 1 1 0; 1 0 1; 1 0 0])
            %colorbar('YTickLabel',{'0','1','2','4','6','8','10','15'});
        end
        print([savePath 'makeItRain_' ratName '_' startTimeString '.png'], '-dpng' );
    end
end
%
% terminate event history
%
disp('-----------------------')
events = logEvent( events, ['total rewards = ' num2str(totalRewards)], true );
events = logEvent( events, ['stable zone occupacies = ' num2str(zoneHistoryIdx)], true );
events = logEvent( events, ['reward exit errors = ' num2str(rewardExitError)], true );
events = logEvent( events, ['center errors = ' num2str(centerError)], true );
events = logEvent( events, ['jumpError = ' num2str(jumpError)], true );
events = logEvent( events, ['choice Point Error = ' num2str(choicePointError)], true );
events = logEvent( events, ['corner errors = ' num2str(cornerError)], true );
events = logEvent( events, ['trial start errors = ' num2str(trialStartError)], true );
disp('-----------------------')
events = logEvent( events, ['dropped events = ' num2str(droppedEventRecords)], true );
events = logEvent( events, ['dropped video records = ' num2str(droppedVideoRecords)], true );
disp('-----------------------')
events = logEvent( events, 'end of trial' );
disp('-----------------------')
%
% store data to disk
%
runSummary.eventHistory = getEventStack(events);
runSummary.eventHistoryTimesNlx = getEventTimesNlx(events);
runSummary.eventHistoryTimesMatlab = getEventTimesMatlab(events);
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

%return
%end