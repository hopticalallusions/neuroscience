% untitled no numbers

aa=load('/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/3-11-2015/run/maze-left-ch1-100102');


datadir = '/Users/andrewhowe/blairLab/blairlab_data/v4/march5/';
fileNum = 7;
[ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([datadir '/CSC' num2str(fileNum) 'platter.ncs']); %we don't need all the data.


[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat( [ datadir, '/', 'Events.nev' ] );





















qw=load('/Users/andrewhowe/blairLab/blairlab_data/v4/march5/STACKED_PCplatform/Stacked_Cal');

getFscvNlxAlignmentLag('/Users/andrewhowe/blairLab/blairlab_data/v4/march5/fscv/platform/','/Users/andrewhowe/blairLab/blairlab_data/v4/march5/nlx/platform/',7)

[ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat('/Users/andrewhowe/blairLab/blairlab_data/v4/march5/nlx/platform/CSC7.ncs',1,10000);

[ cscLFP1 ] = csc2mat([datadir '/CSC' num2str(fileNum) '.ncs']); %we don't need all the data.


getFscvNlxAlignmentLag('/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/fscv/platter/','/Users/andrewhowe/blairLab/blairlab_data/v4/3-11_v4_twotasks_day3/nlx/',7)


%%
+680
getFscvNlxAlignmentLag('/Users/andrewhowe/blairLab/blairlab_data/v4/giantsharpwaves/fscv/maze/','/Users/andrewhowe/blairLab/blairlab_data/v4/giantsharpwaves/nlx/maze/',7)
+2560

[ EventStrings, EventStamps, eventHeader, EventTTLs ] = nev2mat('/Users/andrewhowe/blairLab/blairlab_data/v4/giantsharpwaves/nlx/maze/Events.nev');

% find reward event strings
ttlRewardCSevenIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C7).') )));
ttlRewardCSixIdx=find(not(cellfun('isempty', strfind(EventStrings, 'TTL Output on PCI-DIO24_0 board 0 port 2 value (0x00C6).') )));

% extract some data for plotting
xyTime=double(runSummary.videoTimeStamps-runSummary.videoTimeStamps(1))/1000000;
xpos=double(runSummary.videoLocations(1:2:length(runSummary.videoLocations)));
ypos=double(runSummary.videoLocations(2:2:length(runSummary.videoLocations)));
figure;plot(xpos,ypos);

% fix all the incongruities in the file.
figure; plot(xpos,ypos);
xposCorrected=xpos; xposCorrected(find(xpos==0))=interp1(xyTime,xpos,find(xpos==0));
yposCorrected=ypos; yposCorrected(find(ypos==0))=interp1(xyTime,ypos,find(ypos==0));
% in this particular file, 
figure;plot(xposCorrected(2500:end), yposCorrected(2500:end));


figure;plot(xposCorrected(2500:end), yposCorrected(2500:end)); hold on;
vidIdxSevens=zeros(length(ttlRewardCSevenIdx),1);
for idx=1:length((ttlRewardCSevenIdx))
    vidIdxSevens(idx) = min(find((EventStamps(ttlRewardCSevenIdx(idx))<runSummary.videoTimeStamps)));
end
plot(xposCorrected(vidIdxSevens), yposCorrected(vidIdxSevens), 'o');
vidIdxSixes=zeros(length(ttlRewardCSixIdx),1);
for idx=1:length((ttlRewardCSixIdx))
    vidIdxSixes(idx) = min(find((EventStamps(ttlRewardCSixIdx(idx))<runSummary.videoTimeStamps)));
end
plot(xposCorrected(vidIdxSixes), yposCorrected(vidIdxSixes), 'o');
% positive lag = nlx started after da, so look into future of daConc. data
numFscvWindowsNlx = ceil((EventStamps(nlxEndRecordingIdx) - EventStamps(nlxStartRecordingIdx))/100000);
%+2560 to align. this is suspiciously similar to the amount of time from
%the weirdness on the maze as seen above. I think ****** that maybe this
%means the alignment value should be taken relative to the appearance of
%the ttl and the first time in the record.maybe think more about this.
xx   %this is in minutes. great.
daConcData
%I think the alignment lag is in units of 100 ms
%procedure will be
% find idx of event
% find time of event
% divide time of event by 100,000 to makie it 100's of a second
% ceil or round or whatever
% add the offset above
% pull da values
vidRewardIdxs=[vidIdxSevens; vidIdxSixes];
daIdx=2560+ceil((runSummary.videoTimeStamps(vidRewardIdxs)-EventStamps(1))/100000);
daRewards = daConcData(daIdx);
figure; subplot(3,1,1); hist(daConcData,min(daConcData):max(daConcData));
subplot(3,1,2); hist(daConcData(daIdx-2560),min(daConcData):max(daConcData));
subplot(3,1,3); hist( [daConcData(daIdx);daConcData(daIdx+1);daConcData(daIdx+2);daConcData(daIdx+3);daConcData(daIdx+4)],min(daConcData):max(daConcData));



%%




tt=csc2mat('/Users/andrewhowe/blairLab/blairlab_data/v4/3-23/01. File Beginning To 15420344398/CSC6.ncs',1,100000);
yy=csc2mat('/Users/andrewhowe/blairLab/blairlab_data/v4/3-23/01. File Beginning To 15420344398/CSC7.ncs',1,100000);

tt=csc2mat('/Users/andrewhowe/blairLab/blairlab_data/v4/giantsharpwaves/03. 7591955835 To File End/deartifacted/CSC21_deart.ncs',1,100000);





aa=load('/Users/andrewhowe/Downloads/minute14.csv');
% make a voltage trace
vv=-.4:1.7/499:1.3;
vv=[vv fliplr(vv)];
% check out the backgrounds
figure; plot(aa');
% dirty PCA; no covariance, just variance
figure; plot(var(aa))
ff=peakDetector(var(aa),.08,10,2)
% 
length(find(min(aa(:,100))*1.0007>=aa(:,100)))
ii=find(min(aa(:,100))*1.0007>=aa(:,100));
bg=mean(aa(ii,:));
bgg=ones(600,1)*bg;
bb=aa-bgg;
bb=flipud(bb');
figure; plot(bb(:,181));
figure;
xyIdx=ceil((29.97*14*60:29.97*15*60)-(0.5/60));
subplot(6,1,1:3); imagesc((1:600)/10,vv,bb); %colorbar;
subplot(6,1,4); vtt=((1:60*29.97+1)/29.97); plot(vtt, xpos(xyIdx)); axis tight;
subplot(6,1,5); plot(vtt, ypos(xyIdx)); axis tight;
subplot(6,1,6); plot(vtt, velocity(xyIdx)); axis tight;


figure; plot(vv,bb(:,181));

figure;
edges = [-1 0 1.01 2:10:1000];
h = histogram(diff(sevenSpikeTimes)*1e3,edges);
figure; plot(correctedCsc(32000:96000))
