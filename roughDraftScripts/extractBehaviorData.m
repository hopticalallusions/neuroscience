%basedir = '/Volumes/BlueMiniSeagateData/behaviorControlComputer/MATLAB/behavior/data/rhombus-maze/'

basedir = '/Volumes/BlueMiniSeagateData/behaviorControlComputer/ahowe/data/rhombus-maze/'

basedir = '/Volumes/Seagate Backup Plus Drive/behavior/matlabdata/'

fileList = dir( fullfile( basedir, '*.mat' ) );
if isempty(fileList) 
    warning(['There are no files in the path supplied : ' basedir]);
    return;
end

% not to be fooled by funny directory names, ignore directories, only
% choose actual files here.
% TODO figure out how to fix this, in case it's a problem
% matlab complains about this line for some reason
%fileList = { fileList.name( ~[fileList.isdir]) }';
fileList = { fileList.name }';

if isempty(fileList) 
    warning(['There are no files I want to process in the path supplied! : ' basedir]);
    return;
end


% now we're going to actually process the files in the directory
for fileIdx = 1:numel(fileList)
    filename = char(fileList(fileIdx));
    %disp(['STARTING : ' filename ]);
    load([basedir filename]);
    eventRat = ['ratX'];
    eventRewards = 0;
    errors = 0;
    firstPelletAwardTime = '?';
    firstPelletLock = 0;
    lastPelletAwardTime = '?';
    try
        for idx=1:length(runSummary.eventHistory)
            if strfind(runSummary.eventHistory{idx},'rat')
                eventRat = [eventRat ';' runSummary.eventHistory{idx}];
            end
            if strfind(runSummary.eventHistory{idx},'pellet')
                eventRewards = eventRewards + 1;
            end
            if strfind(runSummary.eventHistory{idx},'error')
                errors = errors + 1;
            end
            if strfind(runSummary.eventHistory{idx},'made it rain')
                eventRewards = eventRewards + 1;
            end
            if strfind(runSummary.eventHistory{idx},'@')
                if firstPelletLock == 0
                    firstPelletAwardTime = runSummary.eventHistory{idx};
                    firstPelletLock = 1;
                end
                lastPelletAwardTime = runSummary.eventHistory{idx};
            end
        end
    catch
    end
    
    try
        summaryRewards = num2str(runSummary.totalRewards);
    catch
        summaryRewards = '?';
    end
    try
        if isempty(runSummary.eventHistoryTimesNlx)
            matlabEventTime = '?';
        else
            matlabEventTime = num2str((max(runSummary.eventHistoryTimesMatlab)-min(runSummary.eventHistoryTimesMatlab))*24*60*60);
        end
    catch
        matlabEventTime = '?';
    end
    try
        % for events that are internally generated and not sent to
        % neuralynx, there are no timestamps...
        if isempty(runSummary.eventHistoryTimesNlx)
            nlxEventTime = '?';
        else
            [rr,cc,val]=find(runSummary.eventHistoryTimesNlx);
            nlxEventTime = num2str((max(val)-min(val))/1e6);            
        end
    catch
        nlxEventTime = '?';
    end
    try
       videoTime = num2str((runSummary.videoTimeStamps(end)-runSummary.videoTimeStamps(1))/1e6);
    catch
        videoTime = '?';
    end
    try
        version = runSummary.version;
    catch
        version = '?';
    end
    
    disp(filename);
    disp(eventRat);
    disp([ num2str(errors) '	' num2str(eventRewards) '	' summaryRewards]);
    disp([ matlabEventTime '	' nlxEventTime '	' videoTime ]);
    disp(firstPelletAwardTime);
    disp(lastPelletAwardTime);
    disp([ version '	=====' ]);

end




return;


%%
vOne=[1	6	199.1;  2	6	199.8;  3	1	1487.3;  6	11	185.5;  7	1	1679.6;  8	3	828.3;  9	1	1683.9;  10	40	45.5;  13	171	12.3;  14	78	21.1;  15	124	19.8;  16	142	12.9;  17	136	11.5;  21	99	13.0;  27	66	18.8;  37	21	96.3];
vThree = [1	10	119.6;  2	3	403.4;  3	3	401.7;  6	2	1025.9;  7	4	735.2;  8	6	402.9;  9	22	66.1;  10	34	55.8;  13	27	64.8;  14	60	25.3;  15	169	18.6;  16	75	21.4;  17	25	54.6;  21	17	69.2];
vFourPre=[1	27	44.7;  2	1	1203.4;  3	6	200.0;  6	3	627.8;  7	7	430.6;  8	10	434.0;  9	179	20.2;  10	181	15.0;  13	130	16.8;  14	158	9.7;  15	200	8.1;  16	213	9.2;  17	149	7.5;  21	84	11.2;  37	95	10.9];
vFourPost=[1	2	1771.4; 2	2	1856.8; 3	2	946.3; 6	19	313.2; 10	13	148.1; 13	0	NaN; 14	17	186.0; 21	174	17.8; 24	241	15.6; 27	308	11.3; 28	420	12.2; 29	223	19.0; 31	298	19.4; 34	226	23.3; 35	297	20.9; 37	168	20.0; 38	201	25.9; 42	204	12.7; 43	191	16.4; 51	157	28.6; 52	167	12.7; 55	137	15.8];
figure; subplot(1,2,1); plot(vOne(:,1),vOne(:,2),'-o'); hold on; plot(vThree(:,1),vThree(:,2),'-+'); plot(vFourPre(:,1),vFourPre(:,2),'-*');  ylabel('total rewards'); xlabel('training day'); 
subplot(1,2,2); plot(vOne(:,1),vOne(:,3),'-o'); hold on; plot(vThree(:,1),vThree(:,3),'-+'); plot(vFourPre(:,1),vFourPre(:,3),'-*');  ylabel('reward interval (s)'); xlabel('training day');
figure; subplot(1,2,1); hold on; plot(0,0,'.'); plot(0,0,'.');  plot(vFourPre(:,1),vFourPre(:,2),'-*'); plot(vFourPost(:,1),vFourPost(:,2),'-*'); ylabel('total rewards'); xlabel('training day'); 
subplot(1,2,2);  hold on; plot(0,0,'.'); plot(0,0,'.');  plot(vFourPre(:,1),vFourPre(:,3),'-*'); plot(vFourPost(:,1),vFourPost(:,3),'-*'); ylabel('reward interval (s)'); xlabel('training day');


%%     
% 
%     % check that the deartifacted file doesn't exist
%     % if the file doesn't exist, process it.
%     % OR
%     % if the file exists AND we want to overwrite, process the file
%     if ~( exist( fullfile( pathToFile, '/deartifacted/', filename ), 'file' ) ) || ( ( exist( fullfile( pathToFile, '/deartifacted/', filename ), 'file' ) ) && overwrite )
%             % set up some variables
%             temp = strsplit( filename, '.' );
%             deartName = char(strcat(temp(1), '_deart.ncs' ));
%             fullPathDearted = fullfile( pathToFile, '/deartifacted/' );
%             % load the file
%             [ cscLFP, nlxCscTimestamps, cscHeader, channel, sampFreq, nValSamp ] = csc2mat( fullfile( pathToFile, '/',filename ) );
%             % deartifact the file
%             [ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( cscLFP, nlxCscTimestamps );
%             %[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( pathToFile, fileName, saveFile)
%             % save the file
%             mat2csc( deartName, fullPathDearted, cscHeader, correctedCsc, nlxCscTimestamps, channel, nValSamp, sampFreq );
%             disp(['FINISHED : ' filename ]);
%     else
%         disp(['SKIPPING : ' filename ]);
%     end
%     disp([num2str(round(100*fileIdx/numel(fileList))) '% ( ' num2str(fileIdx) ' of ' num2str(numel(fileList)) ' )' ]);
% end
% 





return;




%% load the events during recording
%[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-6-2016/Events.nev');
%unique(EventStrings)
%for idx=1:length(EventStrings)
%    if strfind(EventStrings{idx},'pellet')
%        disp(EventStrings(idx))
%    end
%end

% [ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-8-2016/Events.nev');
% unique(EventStrings)
% for idx=1:length(EventStrings)
%     if strfind(EventStrings{idx},'pellet')
%         disp(EventStrings(idx))
%     end
% end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-15-2016/Events.nev');
startIdx = 1;
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-18-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-20-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
        pellets=0;
    end
    if strfind(EventStrings{idx},'pellet')
        %disp(EventStrings{idx})
        pellets = pellets+1;
    end    
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-21-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-25-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//april-27-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//may-13-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end


[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//may-20-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end


[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//may-27-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Volumes/SILVRSURFER/behaviorData/nlx//june-17-2016/Events.nev');
for idx=1:length(EventStrings)
    if strfind(EventStrings{idx},'rat')
        disp(EventStrings(idx))
        startIdx = idx;
    end
    if strfind(EventStrings{idx},'holding')
        startIdx = idx+1;
    end
    if strfind(EventStrings{idx},'rewards')
        disp(EventStrings(idx))
        disp(num2str((EventStamps(idx) - EventStamps(startIdx))/1e6))
    end
    if strfind(EventStrings{idx},'version')
        disp(EventStrings(idx))
    end
    if strfind(EventStrings{idx},'Administrator')
        disp(EventStrings{idx}(100:end))
    end    
end












idxs=find(not(cellfun('isempty', strfind(events, 'rat :') )));
idxs=find(not(cellfun('isempty', strfind(events, 'total rewards') )));


rat
date
session
total rewards
check if it was laser or not
estimate time on maze







%% make pretty graphs and find events
% TODO make this more robust; nlx tells you the up and the down of all
% output ttls every time one changes. woooo.
ttlRewardCSevenIdx=find(not(cellfun('isempty', strfind(events, 'pellet awarded ') )));
%
vidIdxSevens=zeros(length(ttlRewardCSevenIdx),1);
for idx=1:length((ttlRewardCSevenIdx))
    vidIdxSevens(idx) = min(find((EventStamps(ttlRewardCSevenIdx(idx))<xyPositionTimestamps)));
end
figure; plot(xpos,ypos,'Color', [ .5 .5 .5]);
hold on; plot(xpos(vidIdxSevens), ypos(vidIdxSevens), '*');
%plot(xpos(vidIdxSevens(end-10:end)), ypos(vidIdxSevens(end-10:end)), 'o');
%
zoneZeroIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
zoneZeroIdxs=[zoneZeroIdxs; find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Exited') )))];
vidIdxZoneZero=zeros(length(zoneZeroIdxs),1);