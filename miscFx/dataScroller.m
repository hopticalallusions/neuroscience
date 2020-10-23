
includeSetupMetaData;

% % % % %
% this particular copy of this is for scrolling through da5 looking for replay SWR, TT data, theta
% % % % %

rat = 'da5';
folder = '2016-08-22'; 
ttToLoad=[ 2 7 8 ];  
thetaLfpName = 'CSC44';
swrLfpName = 'CSC4';

datapath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ rawSWR, lfpTimestamps ] = csc2mat([ datapath swrLfpName '.ncs' ]);
[ rawTheta ] = csc2mat([ datapath thetaLfpName '.ncs']);

disp('load data')

timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

% swr
load( [ '~/data/dissertation/swrEnhanced/'  rat '_' folder '_theta-' thetaLfpName '_swr-' swrLfpName '.mat' ] );

% spikes
spikeTimes=[ 0 ];
spikeIds = [ 0 ]; % preload with zero so the max function doesn't die on the first one.
spikeTTs = [ 0 ];
spikeSpeeds = [ 0 ];
for fileIdx = 1:length(ttToLoad)
    if exist([ '/Volumes/AGHTHESIS2/rats/summaryData/ttDataRevised/' rat '_' folder '_theta-' thetaLfpName '_TT' num2str(ttToLoad(fileIdx)) '.mat'], 'file')
        load([ '/Volumes/AGHTHESIS2/rats/summaryData/ttDataRevised/' rat '_' folder '_theta-' thetaLfpName '_TT' num2str(ttToLoad(fileIdx)) '.mat'], '-mat');
        spikeTimes = [ spikeTimes; spikeData.timesSeconds ];
        spikeIds   = [ spikeIds; spikeData.cellNumber+max(spikeIds)+1 ];
        spikeTTs   = [ spikeTTs; ones(size(spikeData.cellNumber))*ttToLoad(fileIdx) ];
        spikeSpeeds = [ spikeSpeeds; spikeData.speedBumpy ];
    else
        disp(['skipped TT' num2str(ttToLoad(fileIdx)) ]);
    end
end

spikeColormap=[   0 0 0; .1 .1 .9; .2 .6 .2; .1 .9 .1;  .2 .2 .6; .9 .1 .1;  .2 .2 .2; .8 .1 .8;  .2 .6 .6; .8 .8 .1;  .6 .2 .6; .1 .8 .8 ];

spikeColormap = [ spikeColormap;spikeColormap;spikeColormap;spikeColormap;spikeColormap ];

% telelmetry
load(['/Volumes/AGHTHESIS2/rats/summaryData/telemetryEnhanced/' rat '_' folder '_telemetry.mat'], '-mat');


%% Read in behavioral data
table=readtable('~/data/dissertation/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
% now we can select via string comparison a particular set of dates
dbTrials = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 3);
dbTrials = dbTrials.Trial(:);
trialStartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 4);
trialStartTimes = trialStartTimes.TimeMazeSec(:);
jumpOneTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 6);
jumpOneTimes = jumpOneTimes.timeJ1se(:);
jumpTwoTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 7);
jumpTwoTimes = jumpTwoTimes.timeJ2sec(:);
trialRewardTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 8);
trialRewardTimes = trialRewardTimes.TimeSugarSec(:);
bucketTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 9);
bucketTimes = bucketTimes.TimeBucketSec(:);
contRestartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 10);
contRestartTimes = contRestartTimes.toContSec(:);
trialOutcome = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 11);
trialOutcome = trialOutcome.error(:);
    
    
    
disp('start filtering')



 filters.so.swr       = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  160, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
 filters.so.lia       = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    5, 'HalfPowerFrequency2',   40, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
 filters.so.theta     = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   10, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
% % filter and z-score;
% % filtering zero centers the trace, so the mean is not subtracted for efficiency
lfpLia   = filtfilt( filters.so.lia, rawSWR );     stdLia = std(abs(lfpLia)); lfpLia = ( lfpLia )/stdLia;
lfpSWR   = filtfilt( filters.so.swr, rawSWR );     stdSWR = std(abs(lfpSWR)); lfpSWR = ( lfpSWR )/stdSWR;
lfpTheta = filtfilt( filters.so.theta, rawTheta ); stdTheta = std(abs(lfpTheta)); lfpTheta = ( lfpTheta )/stdTheta;


%filters.ao.lia      = designfilt( 'bandpassiir', 'StopbandFrequency1',   1, 'PassbandFrequency1',    5, 'PassbandFrequency2',  40, 'StopbandFrequency2',   50, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
%filters.ao.swr      = designfilt( 'bandpassiir', 'StopbandFrequency1', 165, 'PassbandFrequency1',  180, 'PassbandFrequency2', 250, 'StopbandFrequency2',  265, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
% this theta filter is not good; it doesn't follow the contours of the raw signal well
%filters.ao.theta    = designfilt( 'bandpassiir', 'StopbandFrequency1',   5, 'PassbandFrequency1',    7, 'PassbandFrequency2',   9, 'StopbandFrequency2',   11, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
% filtering zero centers the trace, so the mean is not subtracted for efficiency
%lfpLia   = filtfilt( filters.ao.lia, rawSWR );     stdLia = std(abs(lfpLia)); lfpLia = ( lfpLia )/stdLia;
%lfpSWR   = filtfilt( filters.ao.swr, rawSWR );     stdSWR = std(abs(lfpSWR)); lfpSWR = ( lfpSWR )/stdSWR;
%lfpTheta = filtfilt( filters.ao.theta, rawTheta ); stdTheta = std(abs(lfpTheta)); lfpTheta = ( lfpTheta )/stdTheta;

lfpRawSwr = rawSWR./std(abs(rawSWR));
lfpRawTheta = rawTheta./std(abs(rawTheta));

lfpRawSwrMax =  max(abs(lfpRawSwr( 5*32000:end-5*32000)));
lfpLiaMax   = max(abs(lfpLia( 5*32000:end-5*32000)));
lfpSWRMax   = max(abs(lfpSWR( 5*32000:end-5*32000)));
lfpThetaMax = max(abs(lfpTheta( 5*32000:end-5*32000)));

disp('preparing to display')

figure(99);

scatterSize = 40;

startTime = 1030;  % 905
lfpSampleRate = 32000;
telSampleRate = 29.97;
plotInterval = 10;
scrollInterval = 6;
sax1=subplot(6,1,3); 
sax2=subplot(6,1,4); 
sax3=subplot(6,1,5); 
sax4=subplot(6,1,6); 
sax5=subplot(6,1,1:2); %sax6=subplot(6,1,6); 


lfpLiaMax=10;
lfpSWRMax=12;
while 1
    
    [ x, y, button ] = ginput(1); 
    if ~isempty(button) & ( ( button==93) | (button==29) | (button==30) ); startTime = startTime + scrollInterval; end;
    if ~isempty(button) & ( ( button==91) | (button==28) | (button==31) ); startTime = startTime - scrollInterval; end;
    if ( (button==113) | (button==27) ); break; end;
    
    
    if ( ( startTime + plotInterval ) <  timestampSeconds(end) )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    elseif ( startTime >= 0 )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    else
        beep();
    end
    
    % plot filtered LFPs
    hold(sax1, 'off'); plot( sax1, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax1, 'on'); plot( sax1, timestampSeconds(lfpII), lfpLia(lfpII), 'Color', [ .1 .5 .7 ], 'Linewidth', 1 );   ylim(sax1,[ -lfpLiaMax lfpLiaMax ]); xlim(sax1,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax1, 'LIA'); set( sax1, 'xticklabel', []);
    hold(sax2, 'off'); plot( sax2, timestampSeconds(lfpII), lfpSWR(lfpII), 'Color', [ .1 .7 .5 ], 'Linewidth', 1 ); hold(sax2, 'on'); plot( sax2, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax2, 'on');    ylim(sax2,[ -lfpSWRMax lfpSWRMax ]); xlim(sax2,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax2, 'SWR'); set( sax2, 'xticklabel', []);
    swrMask = ( swrData.timestampSeconds < timestampSeconds(lfpII(end)) ) & ( swrData.timestampSeconds > timestampSeconds(lfpII(1)) ) & ( swrData.speedBumpy < 5 );
    hold(sax2, 'on'); scatter(sax2, swrData.timestampSeconds(swrMask), -ones(size(find(swrMask)))*lfpSWRMax, '*' );
    
    hold(sax3, 'off'); plot( sax3, timestampSeconds(lfpII), lfpRawTheta(lfpII), 'k'); hold(sax3, 'on'); plot( sax3, timestampSeconds(lfpII), lfpTheta(lfpII), 'Linewidth', 1, 'Color', [ .6 .2 .7 ] ); ylim(sax3,[ -lfpThetaMax lfpThetaMax ]); xlim(sax3,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax3, '\Theta'); set( sax3, 'xticklabel', []);
    % plot telemetry and behavior information
    hold(sax4, 'off'); plot( sax4, telemetry.xytimestampSeconds(telII), log10(telemetry.speed(telII)+1), 'Color', [ .2 .7 .4 ] );
    hold(sax4, 'on'); plot( sax4, telemetry.xytimestampSeconds(telII), (telemetry.onMaze(telII)+1).*2, 'Color', [ .2 .4 .7 ] );
    scatter(sax4, trialStartTimes,  -ones(size(trialStartTimes)), scatterSize, 'gv', 'filled');
    scatter(sax4, jumpOneTimes,     -ones(size(jumpOneTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, jumpTwoTimes,     -ones(size(jumpTwoTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, trialRewardTimes, -ones(size(trialRewardTimes)),scatterSize,  'o', 'filled');
    scatter(sax4, bucketTimes,      -ones(size(bucketTimes)),     scatterSize, 'rs', 'filled');
    scatter(sax4, contRestartTimes, -ones(size(contRestartTimes)),scatterSize, 'md', 'filled');
    %outcomeColors = ([ 0 0 0 ; .9 .1 .1 ; .1 .9 .1 ]);
    %outcomeShapes = { 'd' 's' 'o' }
    colormap(sax4, [ .1 .8 .1; .8 .1 .1; .8 .1 .5 ] );
    scatter(sax4, trialRewardTimes, -ones(size(trialOutcome))+1, scatterSize, trialOutcome+1, 'o', 'filled');   % 'MarkerEgeColor', outcomeColors(trialOutcome,:), 'MarkerFaceColor', outcomeColors(trialOutcome,:),     '', 'filled');
    % CORRECT is a dark purple circle
    % INCORRECT is a light blue circle
    
    ylim(sax4,[ -1.5 10 ]); xlim(sax4,[ telemetry.xytimestampSeconds(telII(1)) telemetry.xytimestampSeconds(telII(end)) ]); ylabel( sax4, 'log10(speed; cm/s)');
    
    hold(sax5, 'off'); %    colormap(sax5, spikeColormap);

    hold(sax5, 'off'); 
    spikeMask = ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), spikeIds(spikeMask), scatterSize, spikeIds(spikeMask), '+'); 
    colormap(sax5, spikeColormap);
    ylim(sax5,[ -1 max(spikeIds)+1 ]); xlim(sax5,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax5, 'TT');
 
end

bins = -500:500; % ms
twoDHist = zeros( max(spikeIds), 1001);
for ii=1:length(swrData.timestampSeconds)
    if swrData.speedBumpy(ii) < 10
        swrDiffs = spikeTimes-swrData.timestampSeconds(ii);
        diffMask = (swrDiffs<=0.5) & (swrDiffs>=-0.5);
        for jj = 1:max(spikeIds)
            spikeMask = diffMask & (spikeIds==jj);
            if sum(spikeMask) > 0
                kk = round(501+(swrDiffs(spikeMask)*1000));
                twoDHist(jj,kk) = twoDHist(jj,kk) + 1;
            end
        end
    end
end

twoDHistNorm = twoDHist;
for ii=1:size(twoDHist,1)
    twoDHistNorm(ii,:) =  twoDHistNorm(ii,:)./max(twoDHistNorm(ii,:));
end

figure; hh = pcolor(twoDHistNorm); set(hh, 'EdgeColor', 'none');







spikeColormap=[   .1 .1 .9; .2 .6 .2; .1 .9 .1;  .2 .2 .6; .9 .1 .1;  .2 .2 .2; .8 .1 .8;  .2 .6 .6; .8 .8 .1;  .6 .2 .6; .1 .8 .8 ];
spikeColormap = [ spikeColormap;spikeColormap;spikeColormap;spikeColormap;spikeColormap ];

startTime = 631;

lfpLiaMax=10;
lfpSWRMax=12;
while 1
    
    [ x, y, button ] = ginput(1); 
    if ~isempty(button) & ( ( button==93) | (button==29) | (button==30) ); startTime = startTime + scrollInterval; end;
    if ~isempty(button) & ( ( button==91) | (button==28) | (button==31) ); startTime = startTime - scrollInterval; end;
    if ( (button==113) | (button==27) ); break; end;
    if startTime < 0; startTime = 1/29; end
    if startTime+plotInterval > timestampSeconds(end); startTime = timestampSeconds(end)-plotInterval-1/29; end;
    
    
    if ( ( startTime + plotInterval ) <  timestampSeconds(end) )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    elseif ( startTime >= 0 )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    else
        beep();
    end
    
    % plot filtered LFPs
    hold(sax1, 'off'); plot( sax1, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax1, 'on'); plot( sax1, timestampSeconds(lfpII), lfpLia(lfpII), 'Color', [ .1 .5 .7 ], 'Linewidth', 1 );   ylim(sax1,[ -lfpLiaMax lfpLiaMax ]); xlim(sax1,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax1, 'LIA'); set( sax1, 'xticklabel', []);
    hold(sax2, 'off'); plot( sax2, timestampSeconds(lfpII), lfpSWR(lfpII), 'Color', [ .1 .7 .5 ], 'Linewidth', 1 ); hold(sax2, 'on'); plot( sax2, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax2, 'on');    ylim(sax2,[ -lfpSWRMax lfpSWRMax ]); xlim(sax2,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax2, 'SWR'); set( sax2, 'xticklabel', []);
    swrMask = ( swrData.timestampSeconds < timestampSeconds(lfpII(end)) ) & ( swrData.timestampSeconds > timestampSeconds(lfpII(1)) ) & ( swrData.speedBumpy < 5 );
    hold(sax2, 'on'); scatter(sax2, swrData.timestampSeconds(swrMask), -ones(size(find(swrMask)))*lfpSWRMax, '*' );
    
    hold(sax3, 'off'); plot( sax3, timestampSeconds(lfpII), lfpRawTheta(lfpII), 'k'); hold(sax3, 'on'); plot( sax3, timestampSeconds(lfpII), lfpTheta(lfpII), 'Linewidth', 1, 'Color', [ .6 .2 .7 ] ); ylim(sax3,[ -lfpThetaMax lfpThetaMax ]); xlim(sax3,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax3, '\Theta'); set( sax3, 'xticklabel', []);
    % plot telemetry and behavior information
    hold(sax4, 'off'); plot( sax4, telemetry.xytimestampSeconds(telII), log10(telemetry.speed(telII)+1), 'Color', [ .2 .7 .4 ] );
    hold(sax4, 'on'); plot( sax4, telemetry.xytimestampSeconds(telII), (telemetry.onMaze(telII)+1).*2, 'Color', [ .2 .4 .7 ] );
    scatter(sax4, trialStartTimes,  -ones(size(trialStartTimes)), scatterSize, 'gv', 'filled');
    scatter(sax4, jumpOneTimes,     -ones(size(jumpOneTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, jumpTwoTimes,     -ones(size(jumpTwoTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, trialRewardTimes, -ones(size(trialRewardTimes)),scatterSize,  'o', 'filled');
    scatter(sax4, bucketTimes,      -ones(size(bucketTimes)),     scatterSize, 'rs', 'filled');
    scatter(sax4, contRestartTimes, -ones(size(contRestartTimes)),scatterSize, 'md', 'filled');
    %outcomeColors = ([ 0 0 0 ; .9 .1 .1 ; .1 .9 .1 ]);
    %outcomeShapes = { 'd' 's' 'o' }
    colormap(sax4, [ .1 .8 .1; .8 .1 .1; .8 .1 .5 ] );
    scatter(sax4, trialRewardTimes, -ones(size(trialOutcome))+1, scatterSize, trialOutcome+1, 'o', 'filled');   % 'MarkerEgeColor', outcomeColors(trialOutcome,:), 'MarkerFaceColor', outcomeColors(trialOutcome,:),     '', 'filled');
    % CORRECT is a dark purple circle
    % INCORRECT is a light blue circle
    
    ylim(sax4,[ -1.5 10 ]); xlim(sax4,[ telemetry.xytimestampSeconds(telII(1)) telemetry.xytimestampSeconds(telII(end)) ]); ylabel( sax4, 'log10(speed; cm/s)');
    
    hold(sax5, 'off'); %    colormap(sax5, spikeColormap);

    spikeMask = ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), spikeIds(spikeMask), scatterSize, spikeIds(spikeMask), 'k.'); 
    hold on;
    spikeMask = ( spikeIds == 3 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 1*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds == 14 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 2*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds == 9 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 3*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds == 5 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 4*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds == 11 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 5*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds == 1 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 6*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 

    spikeMask = ( spikeIds-21 == 1 ) & ( spikeTTs == 7 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 7*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), '+'); 
    spikeMask = ( spikeIds-21 == 2 ) & ( spikeTTs == 7 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 8*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds-21 == 9 ) & ( spikeTTs == 7 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 9*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds-21 == 10 ) & ( spikeTTs == 7 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 10*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 


    spikeMask = ( spikeIds == 2 ) & ( spikeTTs == 2 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 11*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    spikeMask = ( spikeIds-41 == 1 ) & ( spikeTTs == 8 ) & ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );
    scatter( sax5, spikeTimes(spikeMask), 12*ones(1,sum(spikeMask)), scatterSize, spikeIds(spikeMask), 'o', 'filled'); 
    colormap( sax5, spikeColormap);
    ylim(sax5,[ -1 max(spikeIds) ]); xlim(sax5,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax5, 'TT');
end








% 
% figure; histogram(spikeTimes,0:1500);
% hold on; histogram(swrData.timestampSeconds,0:1500)
% 
% spkMask = spikeSpeeds < 7;
% swrMask   = swrData.speedBumpy < 7;
% bins      = 0:.5:1500;
% spkRate   = histcounts( spikeTimes(spkMask), bins );
% swrRate   = histcounts( swrData.timestampSeconds(swrMask), bins );
% figure; plot(spkRate); hold on; plot(swrRate)
% 
% figure; plot(bins(1:end-1),spkRate.*swrRate)



return;

%% 

includeSetupMetaData;

% % % % %
% this particular copy of this is for scrolling through SWR, TT data, theta
% % % % %

rat = 'h1';
folder = '2018-09-07'; 
%folder = '2018-09-06'; 
ttToLoad=[ 22 ];  % H1 2018-09-06 :: 622-627 s has some big ripples with MUA on TT22

datapath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ rawSWR, lfpTimestamps ] = csc2mat([ datapath 'CSC84.ncs']);
[ rawTheta ] = csc2mat([ datapath 'CSC20.ncs']);

disp('load data')

timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

% swr
% Sept 7 doesn't have a SWR extraction for some reason.
load( [ '~/data/dissertation/swrEnhanced/'  rat '_' folder '_theta-CSC20_swr-CSC84.mat' ] );

% spikes
spikeTimes=[ 0 ];
spikeIds = [ 0 ]; % preload with zero so the max function doesn't die on the first one.
spikeTTs = [ 0 ];
for fileIdx = 1:length(ttToLoad)
    if exist([ '/Volumes/AGHTHESIS2/rats/summaryData/ttDataRevised/' rat '_' folder '_theta-CSC20_TT' num2str(ttToLoad(fileIdx)) '.mat'], 'file')
        load([ '/Volumes/AGHTHESIS2/rats/summaryData/ttDataRevised/' rat '_' folder '_theta-CSC20_TT' num2str(ttToLoad(fileIdx)) '.mat'], '-mat');
        spikeTimes = [ spikeTimes; spikeData.timesSeconds ];
        spikeIds   = [ spikeIds; spikeData.cellNumber+max(spikeIds)+1 ];
        spikeTTs   = [ spikeTTs; ones(size(spikeData.cellNumber))*ttToLoad(fileIdx) ];
    else
        disp(['skipped TT' num2str(ttToLoad(fileIdx)) ]);
    end
end

spikeColormap=[   0 0 0; .1 .1 .9; .2 .6 .2; .1 .9 .1;  .2 .2 .6; .9 .1 .1;  .2 .2 .2; .8 .1 .8;  .2 .6 .6; .8 .8 .1;  .6 .2 .6; .1 .8 .8 ];

spikeColormap = [ spikeColormap;spikeColormap;spikeColormap;spikeColormap;spikeColormap ];

% telelmetry
load(['/Volumes/AGHTHESIS2/rats/summaryData/telemetry/' rat '_' folder '_telemetry.mat'], '-mat');


%% Read in behavioral data
table=readtable('~/data/dissertation/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
% now we can select via string comparison a particular set of dates
dbTrials = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 3);
dbTrials = dbTrials.Trial(:);
trialStartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 4);
trialStartTimes = trialStartTimes.TimeMazeSec(:);
jumpOneTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 6);
jumpOneTimes = jumpOneTimes.timeJ1se(:);
jumpTwoTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 7);
jumpTwoTimes = jumpTwoTimes.timeJ2sec(:);
trialRewardTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 8);
trialRewardTimes = trialRewardTimes.TimeSugarSec(:);
bucketTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 9);
bucketTimes = bucketTimes.TimeBucketSec(:);
contRestartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 10);
contRestartTimes = contRestartTimes.toContSec(:);
trialOutcome = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 11);
trialOutcome = trialOutcome.error(:);
    
    
    
disp('start filtering')



 filters.so.swr       = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  160, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
 filters.so.lia       = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    5, 'HalfPowerFrequency2',   40, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
 filters.so.theta     = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   10, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
% % filter and z-score;
% % filtering zero centers the trace, so the mean is not subtracted for efficiency
lfpLia   = filtfilt( filters.so.lia, rawSWR );     stdLia = std(abs(lfpLia)); lfpLia = ( lfpLia )/stdLia;
lfpSWR   = filtfilt( filters.so.swr, rawSWR );     stdSWR = std(abs(lfpSWR)); lfpSWR = ( lfpSWR )/stdSWR;
lfpTheta = filtfilt( filters.so.theta, rawTheta ); stdTheta = std(abs(lfpTheta)); lfpTheta = ( lfpTheta )/stdTheta;


%filters.ao.lia      = designfilt( 'bandpassiir', 'StopbandFrequency1',   1, 'PassbandFrequency1',    5, 'PassbandFrequency2',  40, 'StopbandFrequency2',   50, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
%filters.ao.swr      = designfilt( 'bandpassiir', 'StopbandFrequency1', 165, 'PassbandFrequency1',  180, 'PassbandFrequency2', 250, 'StopbandFrequency2',  265, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
% this theta filter is not good; it doesn't follow the contours of the raw signal well
%filters.ao.theta    = designfilt( 'bandpassiir', 'StopbandFrequency1',   5, 'PassbandFrequency1',    7, 'PassbandFrequency2',   9, 'StopbandFrequency2',   11, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
% filtering zero centers the trace, so the mean is not subtracted for efficiency
%lfpLia   = filtfilt( filters.ao.lia, rawSWR );     stdLia = std(abs(lfpLia)); lfpLia = ( lfpLia )/stdLia;
%lfpSWR   = filtfilt( filters.ao.swr, rawSWR );     stdSWR = std(abs(lfpSWR)); lfpSWR = ( lfpSWR )/stdSWR;
%lfpTheta = filtfilt( filters.ao.theta, rawTheta ); stdTheta = std(abs(lfpTheta)); lfpTheta = ( lfpTheta )/stdTheta;

lfpRawSwr = rawSWR./std(abs(rawSWR));
lfpRawTheta = rawTheta./std(abs(rawTheta));

lfpRawSwrMax =  max(abs(lfpRawSwr( 5*32000:end-5*32000)));
lfpLiaMax   = max(abs(lfpLia( 5*32000:end-5*32000)));
lfpSWRMax   = max(abs(lfpSWR( 5*32000:end-5*32000)));
lfpThetaMax = max(abs(lfpTheta( 5*32000:end-5*32000)));

disp('preparing to display')

figure(99);

scatterSize = 40;

startTime = 211;  % 211 is a good start time for h1 2018-09-07
lfpSampleRate = 32000;
telSampleRate = 29.97;
plotInterval = 10;
scrollInterval = 6;
sax1=subplot(6,1,3); 
sax2=subplot(6,1,4); 
sax3=subplot(6,1,5); 
sax4=subplot(6,1,6); 
sax5=subplot(6,1,1:2); %sax6=subplot(6,1,6); 


lfpLiaMax=8;
lfpSWRMax=10;
while 1
    
    [ x, y, button ] = ginput(1); 
    if ~isempty(button) & ( ( button==93) | (button==29) | (button==30) ); startTime = startTime + scrollInterval; end;
    if ~isempty(button) & ( ( button==91) | (button==28) | (button==31) ); startTime = startTime - scrollInterval; end;
    if ( (button==113) | (button==27) ); break; end;
    
    
    if ( ( startTime + plotInterval ) <  timestampSeconds(end) )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    elseif ( startTime >= 0 )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    else
        beep();
    end
    
    % plot filtered LFPs
    hold(sax1, 'off'); plot( sax1, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax1, 'on'); plot( sax1, timestampSeconds(lfpII), lfpLia(lfpII), 'Color', [ .1 .5 .7 ], 'Linewidth', 1 );   ylim(sax1,[ -lfpLiaMax lfpLiaMax ]); xlim(sax1,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax1, 'LIA'); set( sax1, 'xticklabel', []);
    hold(sax2, 'off'); plot( sax2, timestampSeconds(lfpII), lfpSWR(lfpII), 'Color', [ .1 .7 .5 ], 'Linewidth', 1 ); hold(sax2, 'on'); plot( sax2, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax2, 'on');    ylim(sax2,[ -lfpSWRMax lfpSWRMax ]); xlim(sax2,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax2, 'SWR'); set( sax2, 'xticklabel', []);
    swrMask = ( swrData.timestampSeconds < timestampSeconds(lfpII(end)) ) & ( swrData.timestampSeconds > timestampSeconds(lfpII(1)) ) & ( swrData.speed < 5 );
    hold(sax2, 'on'); scatter(sax2, swrData.timestampSeconds(swrMask), -ones(size(find(swrMask)))*lfpSWRMax, '*' );
    
    hold(sax3, 'off'); plot( sax3, timestampSeconds(lfpII), lfpRawTheta(lfpII), 'k'); hold(sax3, 'on'); plot( sax3, timestampSeconds(lfpII), lfpTheta(lfpII), 'Linewidth', 1, 'Color', [ .6 .2 .7 ] ); ylim(sax3,[ -lfpThetaMax lfpThetaMax ]); xlim(sax3,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax3, '\Theta'); set( sax3, 'xticklabel', []);
    % plot telemetry and behavior information
    hold(sax4, 'off'); plot( sax4, telemetry.xytimestampSeconds(telII), log10(telemetry.speed(telII)+1), 'Color', [ .2 .7 .4 ] );
    hold(sax4, 'on'); plot( sax4, telemetry.xytimestampSeconds(telII), (telemetry.onMaze(telII)+1).*2, 'Color', [ .2 .4 .7 ] );
    scatter(sax4, trialStartTimes,  -ones(size(trialStartTimes)), scatterSize, 'gv', 'filled');
    scatter(sax4, jumpOneTimes,     -ones(size(jumpOneTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, jumpTwoTimes,     -ones(size(jumpTwoTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, trialRewardTimes, -ones(size(trialRewardTimes)),scatterSize,  'o', 'filled');
    scatter(sax4, bucketTimes,      -ones(size(bucketTimes)),     scatterSize, 'rs', 'filled');
    scatter(sax4, contRestartTimes, -ones(size(contRestartTimes)),scatterSize, 'md', 'filled');
    %outcomeColors = ([ 0 0 0 ; .9 .1 .1 ; .1 .9 .1 ]);
    %outcomeShapes = { 'd' 's' 'o' }
    colormap(sax4, [ .1 .8 .1; .8 .1 .1; .8 .1 .5 ] );
    scatter(sax4, trialRewardTimes, -ones(size(trialOutcome))+1, scatterSize, trialOutcome+1, 'o', 'filled');   % 'MarkerEgeColor', outcomeColors(trialOutcome,:), 'MarkerFaceColor', outcomeColors(trialOutcome,:),     '', 'filled');
    % CORRET is a dark purple circle
    % INCORRECT is a light blue circle
    
    ylim(sax4,[ -1.5 10 ]); xlim(sax4,[ telemetry.xytimestampSeconds(telII(1)) telemetry.xytimestampSeconds(telII(end)) ]); ylabel( sax4, 'log10(speed; cm/s)');
    
    spikeMask = ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );

    hold(sax5, 'off'); 
    colormap(sax5, spikeColormap);
    scatter( sax5, spikeTimes(spikeMask), spikeIds(spikeMask), scatterSize, spikeIds(spikeMask), '+'); 
    ylim(sax5,[ -1 15 ]); xlim(sax5,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax5, 'TT');
    
end



return;




%% scrolling LFPs

includeSetupMetaData;

rat = 'h7';
folder = '2018-07-13'; 

datapath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];

[ lfp0, lfpTimestamps ] = csc2mat([ datapath 'CSC44.ncs']);
[ lfp4 ] = csc2mat([ datapath 'CSC56.ncs']);
[ lfp24 ] = csc2mat([ datapath 'CSC54.ncs']);
[ lfp28 ] = csc2mat([ datapath 'CSC64.ncs']);
[ lfp46 ] = csc2mat([ datapath 'CSC84.ncs']);


%% h7

% over time, the "best" swr channel shifts
% SWR 56, 40, 44  (ripple)  at least sometimes 36, 60, 64, 84, 92, 76
% SW seem to be on 44 and 56, but also on the others ; e.g. untitled3 36 opposite 40, 44, 56, 60, 64  
% at the end ripples are on 56, 40, 44, 60, 64, 84

% 64, 84 might also have good Theta


%% H5

% 2018-05-02


% 2018-06-13
% 20  quiet; can see chewing
% 44  probably theta
% 68  seems mostly dead; can see chewing
% 36  ok-ish, not great
% 80  smaller signal, similar meh to 36
% 60  strong signal, not much theta, a little odd looking??
% 64  good theta
% 73  small signal
% 76  small signal
%



% 2018-05-19
% 60 through 80 are very similar
% 44 has clear sharp waves, reflected in 60 - 80;  80 seems similar but stronger
% 87 not sure what is going on here; seens very flat
% 68 has very regular theta
% 44 has theta, but less regular; ;also has SW, reflected in other HF chan
% 60, 64 very similar; relatively similar to 73, 76
% 80  theta
% 84, 87 small signals
% 88 is terrible; noisy; DC offsets
% *** this rat sleeps on this day!!
% 36 looks like HF??





%% da5 
% 2016-08-25 @ 444 seconds has a potential SWR
%
% [ lfp0, lfpTimestamps ] = csc2mat([ datapath 'CSC0.ncs']);
% [ lfp4 ] = csc2mat([ datapath 'CSC4.ncs']);
% [ lfp24 ] = csc2mat([ datapath 'CSC24.ncs']);
% [ lfp28 ] = csc2mat([ datapath 'CSC28.ncs']);
% [ lfp46 ] = csc2mat([ datapath 'CSC44.ncs']);


% % da10    ch 61, 88 are OK  52 has a big spike -- VTA.   20, 32 pure noise
% %     2 noisy; strong chewing, but signal
% %   4,8 same, probably just reference noise
% %    12 maybe Theta
% %    16  nearly silent
% %    38 no; chewing
% %    44 no; chewing
% %    61 ok
% %    64 big DC offset noise
% %    76 no; chewing
% %    86
% %
% [ lfp0, lfpTimestamps ] = csc2mat([ datapath 'CSC38.ncs']);
% [ lfp4 ] = csc2mat([ datapath 'CSC44.ncs']);
% [ lfp24 ] = csc2mat([ datapath 'CSC61.ncs']);
% [ lfp28 ] = csc2mat([ datapath 'CSC64.ncs']);
% [ lfp46 ] = csc2mat([ datapath 'CSC76.ncs']);


load([ '/Volumes/AGHTHESIS2/rats/summaryData/telemetryEnhanced/' rat '_' folder '_telemetry.mat' ], '-mat');

timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

filters.so.theta     = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
filters.so.swr       = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  180, 'HalfPowerFrequency2',  250, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article

%load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');
% 
% lfp76t =  filtfilt( filters.so.theta, lfp76 );
% lfp64 =  filtfilt( filters.so.theta, lfp64 );
% lfp36 =  filtfilt( filters.so.swr, lfp36 );
% lfp87 =  filtfilt( filters.so.swr, lfp87 );
% lfp77 =  filtfilt( filters.so.swr, lfp77 );

startIdx = 1;
lfpSampleRate = 32000;
plotInterval = 10;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6); 

while 1
    
    [x, y, button]=ginput(1); 
    if ~isempty(button) & ( (button== 93) | (button==29) | (button==30) ); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
    if ~isempty(button) & ( (button== 91) | (button==28) | (button==31) ); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
    if (button==113) | (button==27); break; end;
    
    
    if ( ( startIdx + plotInterval*lfpSampleRate ) < length (timestampSeconds) )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    elseif ( startIdx > 0 )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    else
        beep();
    end
    
    hold(sax1, 'off'); plot( sax1, timestampSeconds(ii), lfp0(ii) ); ylim(sax1,[ -1.0 1 ]); xlim(sax1,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax1, '\Theta c76');
    hold(sax2, 'off'); plot( sax2, timestampSeconds(ii), lfp4(ii) ); ylim(sax2,[ -1.0 1 ]); xlim(sax2,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax2, '\Theta c64'); 
    hold(sax3, 'off'); plot( sax3, timestampSeconds(ii), lfp24(ii) ); ylim(sax3,[ -1 1 ]); xlim(sax3,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax3, 'SWR c36');
    hold(sax4, 'off'); plot( sax4, timestampSeconds(ii), lfp28(ii) ); ylim(sax4,[ -1 1 ]); xlim(sax4,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax4, 'SWR c87');
    hold(sax5, 'off'); plot( sax5, timestampSeconds(ii), lfp46(ii) ); ylim(sax5,[ -1 1 ]); xlim(sax5,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax5, 'SWR c77');
    hold(sax6, 'off'); %plot( sax6, timestampSeconds(ii), lfp76(ii) ); ylim(sax6,[ -2 2 ]); xlim(sax6,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax6, 'raw c76');
    plot( sax6, telemetry.xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), telemetry.speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s'); ylim(sax6,[ -1 100 ]); % [ lfp0, lfpTimestamps ] = csc2mat([ datapath 'CSC0.ncs']);
    
end



return;





%%

clear all;

includeSetupMetaData;


% this particular copy of this is for scrolling through SWR, theta and
% other things

rat = 'da5';
folder = '2016-08-25'; 
ttToLoad=[ 4, 7, 13, 14, 15, 17, 20, 21, 24, 25, 26, 31 ];

datapath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ rawSWR, lfpTimestamps ] = csc2mat([ datapath 'CSC6.ncs']);
[ rawTheta ] = csc2mat([ datapath 'CSC46.ncs']);


%rat = 'h7';
%folder = '2018-08-14'; ttToLoad=[ 4, 9, 11, 12, 13, 14, 15, 17, 21, 24, 25, 26, 30, 32 ];
%folder = '2018-08-10'; ttToLoad=[ 4, 7, 13, 14, 15, 17, 20, 21, 24, 25, 26, 31 ];





disp('load data')

%[ rawSWR, lfpTimestamps ] = csc2mat([ datapath 'CSC56.ncs']);
%[ rawSWR, lfpTimestamps ] = csc2mat([ datapath 'CSC44.ncs']);
%[ rawTheta ] = csc2mat([ datapath 'CSC64.ncs']);

timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

% swr
load( [ '~/data/dissertation/swrEnhanced/'  rat '_' folder '_theta-CSC12_swr-CSC6.mat' ] );

% spikes
spikeTimes=[ 0 ];
spikeIds = [ 0 ]; % preload with zero so the max function doesn't die on the first one.
spikeTTs = [ 0 ];
for fileIdx = 1:length(ttToLoad)
    if exist([ '/Volumes/AGHTHESIS2/rats/summaryData/ttData/' rat '_' folder '_theta-CSC64_TT' num2str(ttToLoad(fileIdx)) '.mat'], 'file')
        load([ '/Volumes/AGHTHESIS2/rats/summaryData/ttData/' rat '_' folder '_theta-CSC64_TT' num2str(ttToLoad(fileIdx)) '.mat'], '-mat');
        spikeTimes = [ spikeTimes; spikeData.timesSeconds ];
        spikeIds   = [ spikeIds; spikeData.cellNumber+max(spikeIds)+1 ];
        spikeTTs   = [ spikeTTs; ones(size(spikeData.cellNumber))*ttToLoad(fileIdx) ];
    else
        disp(['skipped TT' num2str(ttToLoad(fileIdx)) ]);
    end
end

spikeColormap=[   0 0 0; .1 .1 .9; .2 .6 .2; .1 .9 .1;  .2 .2 .6; .9 .1 .1;  .2 .2 .2; .8 .1 .8;  .2 .6 .6; .8 .8 .1;  .6 .2 .6; .1 .8 .8 ];

spikeColormap = [ spikeColormap;spikeColormap;spikeColormap;spikeColormap;spikeColormap ];

% telelmetry
load(['/Volumes/AGHTHESIS2/rats/summaryData/telemetry/' rat '_' folder '_telemetry_preStartFix.mat'], '-mat');


%% Read in behavioral data
table=readtable('~/data/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
% to access the table in a useful way, it works better to convert it to a dataset
ds = table2dataset(table);
% now we can select via string comparison a particular set of dates
dbTrials = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 3);
dbTrials = dbTrials.Trial(:);
trialStartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 4);
trialStartTimes = trialStartTimes.TimeMazeSec(:);
jumpOneTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 6);
jumpOneTimes = jumpOneTimes.timeJ1se(:);
jumpTwoTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 7);
jumpTwoTimes = jumpTwoTimes.timeJ2sec(:);
trialRewardTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 8);
trialRewardTimes = trialRewardTimes.TimeSugarSec(:);
bucketTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 9);
bucketTimes = bucketTimes.TimeBucketSec(:);
contRestartTimes = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 10);
contRestartTimes = contRestartTimes.toContSec(:);
trialOutcome = ds( (strcmp( ds.Folder, folder).*strcmp( ds.Rat,rat))>0 , 11);
trialOutcome = trialOutcome.error(:);
    
    
    
disp('start filtering')



 filters.so.swr       = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  160, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
 filters.so.lia       = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    5, 'HalfPowerFrequency2',   40, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
% filters.so.theta     = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   10, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
% % filter and z-score;
% % filtering zero centers the trace, so the mean is not subtracted for efficiency
 lfpLia   = filtfilt( filters.so.lia, rawSWR );     stdLia = std(abs(lfpLia)); lfpLia = ( lfpLia )/stdLia;
 lfpSWR   = filtfilt( filters.so.swr, rawSWR );     stdSWR = std(abs(lfpSWR)); lfpSWR = ( lfpSWR )/stdSWR;
% lfpTheta = filtfilt( filters.so.theta, rawTheta ); stdTheta = std(abs(lfpTheta)); lfpTheta = ( lfpTheta )/stdTheta;


filters.ao.lia      = designfilt( 'bandpassiir', 'StopbandFrequency1',   1, 'PassbandFrequency1',    5, 'PassbandFrequency2',  40, 'StopbandFrequency2',   50, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
filters.ao.swr      = designfilt( 'bandpassiir', 'StopbandFrequency1', 165, 'PassbandFrequency1',  180, 'PassbandFrequency2', 250, 'StopbandFrequency2',  265, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
filters.ao.theta    = designfilt( 'bandpassiir', 'StopbandFrequency1',   5, 'PassbandFrequency1',    7, 'PassbandFrequency2',   9, 'StopbandFrequency2',   11, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
% filtering zero centers the trace, so the mean is not subtracted for efficiency
%lfpLia   = filtfilt( filters.ao.lia, rawSWR );     stdLia = std(abs(lfpLia)); lfpLia = ( lfpLia )/stdLia;
%lfpSWR   = filtfilt( filters.ao.swr, rawSWR );     stdSWR = std(abs(lfpSWR)); lfpSWR = ( lfpSWR )/stdSWR;
lfpTheta = filtfilt( filters.ao.theta, rawTheta ); stdTheta = std(abs(lfpTheta)); lfpTheta = ( lfpTheta )/stdTheta;

lfpRawSwr = rawSWR./std(abs(rawSWR));
lfpRawTheta = rawTheta./std(abs(rawTheta));

lfpRawSwrMax =  max(abs(lfpRawSwr( 5*32000:end-5*32000)));
lfpLiaMax   = max(abs(lfpLia( 5*32000:end-5*32000)));
lfpSWRMax   = max(abs(lfpSWR( 5*32000:end-5*32000)));
lfpThetaMax = max(abs(lfpTheta( 5*32000:end-5*32000)));

disp('preparing to display')

figure(99);

scatterSize = 40;

startTime = 420;
lfpSampleRate = 32000;
telSampleRate = 29.97;
plotInterval = 10;
scrollInterval = 6;
sax1=subplot(6,1,3); 
sax2=subplot(6,1,4); 
sax3=subplot(6,1,5); 
sax4=subplot(6,1,6); 
sax5=subplot(6,1,1:2); %sax6=subplot(6,1,6); 

while 1
    
    [ x, y, button ] = ginput(1); 
    if ~isempty(button) && ( ( button==93) || (button==29) || (button==30) ); startTime = startTime + scrollInterval; end;
    if ~isempty(button) && ( ( button==91) || (button==28) || (button==31) ); startTime = startTime - scrollInterval; end;
    if ~isempty(button) && ( (button==113) || (button==27) ); break; end;
    
    
    if ( ( startTime + plotInterval ) <  timestampSeconds(end) )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    elseif ( startTime >= 0 )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
        telII=floor(startTime*telSampleRate)+1:floor((startTime+plotInterval)*telSampleRate)+1;
    else
        beep();
    end
    
    % plot filtered LFPs
    hold(sax1, 'off'); plot( sax1, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax1, 'on'); plot( sax1, timestampSeconds(lfpII), lfpLia(lfpII), 'Color', [ .1 .5 .7 ], 'Linewidth', 1 );   ylim(sax1,[ -lfpLiaMax lfpLiaMax ]); xlim(sax1,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax1, 'LIA'); set( sax1, 'xticklabel', []);
    hold(sax2, 'off'); plot( sax2, timestampSeconds(lfpII), lfpRawSwr(lfpII), 'k' ); hold(sax2, 'on'); plot( sax2, timestampSeconds(lfpII), lfpSWR(lfpII), 'Color', [ .1 .7 .5 ], 'Linewidth', 1 );   ylim(sax2,[ -lfpSWRMax lfpSWRMax ]); xlim(sax2,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax2, 'SWR'); set( sax2, 'xticklabel', []);
    swrMask = ( swrData.timestampSeconds < timestampSeconds(lfpII(end)) ) & ( swrData.timestampSeconds > timestampSeconds(lfpII(1)) ) & ( swrData.speed < 5 );
    hold(sax2, 'on'); scatter(sax2, swrData.timestampSeconds(swrMask), -ones(size(find(swrMask)))*lfpSWRMax, '*' );
    
    hold(sax3, 'off'); plot( sax3, timestampSeconds(lfpII), lfpRawTheta(lfpII)./stdTheta, 'k'); hold(sax3, 'on'); plot( sax3, timestampSeconds(lfpII), lfpTheta(lfpII), 'Linewidth', 1, 'Color', [ .6 .2 .7 ] ); ylim(sax3,[ -lfpThetaMax lfpThetaMax ]); xlim(sax3,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax3, '\Theta'); set( sax3, 'xticklabel', []);
    % plot telemetry and behavior information
    hold(sax4, 'off'); plot( sax4, telemetry.xytimestampSeconds(telII), log10(telemetry.speed(telII)+1), 'Color', [ .2 .7 .4 ] );
    hold(sax4, 'on'); plot( sax4, telemetry.xytimestampSeconds(telII), (telemetry.onMaze(telII)+1).*2, 'Color', [ .2 .4 .7 ] );
    scatter(sax4, trialStartTimes,  -ones(size(trialStartTimes)), scatterSize, 'gv', 'filled');
    scatter(sax4, jumpOneTimes,     -ones(size(jumpOneTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, jumpTwoTimes,     -ones(size(jumpTwoTimes)),    scatterSize,  '^', 'filled');
    scatter(sax4, trialRewardTimes, -ones(size(trialRewardTimes)),scatterSize,  'o', 'filled');
    scatter(sax4, bucketTimes,      -ones(size(bucketTimes)),     scatterSize, 'rs', 'filled');
    scatter(sax4, contRestartTimes, -ones(size(contRestartTimes)),scatterSize, 'md', 'filled');
    %outcomeColors = ([ 0 0 0 ; .9 .1 .1 ; .1 .9 .1 ]);
    %outcomeShapes = { 'd' 's' 'o' }
    colormap(sax4, [ .1 .8 .1; .8 .1 .1; .8 .1 .5 ] );
    scatter(sax4, trialRewardTimes, -ones(size(trialOutcome))+1, scatterSize, trialOutcome+1, 'o', 'filled');   % 'MarkerEgeColor', outcomeColors(trialOutcome,:), 'MarkerFaceColor', outcomeColors(trialOutcome,:),     '', 'filled');
    % CORRET is a dark purple circle
    % INCORRECT is a light blue circle
    
    ylim(sax4,[ -1.5 10 ]); xlim(sax4,[ telemetry.xytimestampSeconds(telII(1)) telemetry.xytimestampSeconds(telII(end)) ]); ylabel( sax4, 'log10(speed; cm/s)');
    


%    spikeMask15 = ( spikeData15.timesSeconds < timestampSeconds(lfpII(end)) )  & ( spikeData15.timesSeconds > timestampSeconds(lfpII(1)));
%    spikeMask32 = ( spikeData32.timesSeconds < timestampSeconds(lfpII(end)) )  & ( spikeData32.timesSeconds > timestampSeconds(lfpII(1)));

    spikeMask = ( spikeTimes < timestampSeconds(lfpII(end)) ) & ( spikeTimes > timestampSeconds(lfpII(1)) );

    hold(sax5, 'off'); 
    colormap(sax5, spikeColormap);
    scatter( sax5, spikeTimes(spikeMask), spikeIds(spikeMask), scatterSize, spikeIds(spikeMask), '+'); 
%    hold(sax5, 'on');
%    scatter( sax5, spikeTimes(spikeMask), spikeIds(spikeMask)+1+max(spikeData15.cellNumber), scatterSize, spikeIds(spikeMask32), '+'); 
    ylim(sax5,[ -1 15 ]); xlim(sax5,[ timestampSeconds(lfpII(1)) timestampSeconds(lfpII(end)) ]); ylabel( sax5, 'TT');
    %hold(sax6, 'off'); plot( sax6, timestampSeconds(ii), lfp76(ii) ); ylim(sax6,[ -2 2 ]); xlim(sax6,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax6, 'raw c76');
    %plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
    
end



return;






return;


datapath = '/Volumes/AGHTHESIS2/rats/h5/2018-05-18/';

[ lfp76, lfpTimestamps ] = csc2mat([ datapath 'CSC76.ncs']);
[ lfp64 ] = csc2mat([ datapath 'CSC64.ncs']);

[ lfp36 ] = csc2mat([ datapath 'CSC36.ncs']);
[ lfp87 ] = csc2mat([ datapath 'CSC87.ncs']);
[ lfp77 ] = csc2mat([ datapath 'CSC77.ncs']);

timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

filters.so.theta     = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent

filters.so.swr       = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  180, 'HalfPowerFrequency2',  250, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article


%load([ basePathData rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_telemetry.mat' ], '-mat');


lfp76t =  filtfilt( filters.so.theta, lfp76 );
lfp64 =  filtfilt( filters.so.theta, lfp64 );

lfp36 =  filtfilt( filters.so.swr, lfp36 );
lfp87 =  filtfilt( filters.so.swr, lfp87 );
lfp77 =  filtfilt( filters.so.swr, lfp77 );

startIdx = 1;
lfpSampleRate = 32000;
plotInterval = 10;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6); 

while 1
    
    [x, y, button]=ginput(1); 
    if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
    if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
    if (button==113) || (button==27); break; end;
    
    
    if ( ( startIdx + plotInterval*lfpSampleRate ) < length (timestampSeconds) )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    elseif ( startIdx > 0 )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    else
        beep();
    end
    
    hold(sax1, 'off'); plot( sax1, timestampSeconds(ii), lfp76t(ii) ); ylim(sax1,[ -1.70 1.70 ]); xlim(sax1,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax1, '\Theta c76');
    hold(sax2, 'off'); plot( sax2, timestampSeconds(ii), lfp64(ii) ); ylim(sax2,[ -1.70 1.70 ]); xlim(sax2,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax2, '\Theta c64'); 
    hold(sax3, 'off'); plot( sax3, timestampSeconds(ii), lfp36(ii) ); ylim(sax3,[ -0.21 0.21 ]); xlim(sax3,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax3, 'SWR c36');
    hold(sax4, 'off'); plot( sax4, timestampSeconds(ii), lfp87(ii) ); ylim(sax4,[ -0.21 0.21 ]); xlim(sax4,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax4, 'SWR c87');
    hold(sax5, 'off'); plot( sax5, timestampSeconds(ii), lfp77(ii) ); ylim(sax5,[ -0.21 0.21 ]); xlim(sax5,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax5, 'SWR c77');
    hold(sax6, 'off'); plot( sax6, timestampSeconds(ii), lfp76(ii) ); ylim(sax6,[ -2 2 ]); xlim(sax6,[ timestampSeconds(ii(1)) timestampSeconds(ii(end)) ]); ylabel( sax6, 'raw c76');
    %plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
    
end



return;















% 
% dir='/Volumes/BlueMiniSeagateData/ratData/da10/da10_2017-09-19/';
 dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/2017-09-20_/';
% 
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;


[ lfp88, lfpTimestamps ] = csc2mat([ dir 'CSC88.ncs']); % inverted SWR; below layer
[ lfp61 ] = csc2mat([ dir 'CSC61.ncs']); % above layer (non inverted SWR)
[ lfp6 ] = csc2mat([ dir 'CSC6.ncs']); % NAc, to eliminate noise from bucket slam vs SWR
[ lfp76 ] = csc2mat([ dir 'CSC76.ncs']); % 
[ lfp64 ] = csc2mat([ dir 'CSC64.ncs']); % 
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;

[ lfp12 ] = csc2mat([ dir 'CSC12.ncs']); % 
[ lfp16 ] = csc2mat([ dir 'CSC16.ncs']); % 
[ lfp36 ] = csc2mat([ dir 'CSC36.ncs']); % 
[ lfp46 ] = csc2mat([ dir 'CSC46.ncs']); % 



% 
%filters.so.swr      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   99, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
%filters.ao.swr      = designfilt( 'bandpassiir', 'StopbandFrequency1',  100, 'PassbandFrequency1',  110, 'PassbandFrequency2',  240, 'StopbandFrequency2',  260, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
%swrLfp88 = filtfilt( filters.ao.swr, lfp88 );
%figure; plot(timestampSeconds, swrLfp88);
%swrLfp88 = filtfilt( filters.so.swr, lfp88 );
%hold on; plot(timestampSeconds, swrLfp88);
% lessLfp = decimate( lfp88, 320 );
% lesstt = downsample( timestampSeconds, 320 );
% env=abs(hilbert(lfp88));
% figure; fs=32000; ttwindow=round(1754.5*fs):round(1756.5*fs); plot(timestampSeconds(ttwindow),lfp88(ttwindow))
% hold on; fs=100; ttwindow=round(1754.5*fs):round(1756.5*fs); plot(lesstt(ttwindow),lessLfp(ttwindow)); axis tight;
% fs=32000; ttwindow=round(1754.5*fs):round(1756.5*fs); plot(timestampSeconds(ttwindow),env(ttwindow))
% 
% return;



% thisLfp=lfp88;
% filterBandLfp = filtfilt( filters.ao.swr, thisLfp );
% % find the envelope (to limit the peak detection)
% filterBandLfpHilbert = hilbert( filterBandLfp );
% env=abs(filterBandHilbert);
% plot(timestampSeconds,env);
% [yy,xx]=hist(env,1:1000);
% env=abs(filterBandLfpHilbert);
% plot(timestampSeconds,env);
% [yy,xx]=hist(env,1:1000);

filters.so.chew     = designfilt( 'bandpassiir', 'FilterOrder', 20, 'HalfPowerFrequency1',  100, 'HalfPowerFrequency2', 1000, 'SampleRate', 32000); % verified order, settings by testing
filters.so.electric = designfilt( 'bandpassiir', 'FilterOrder', 12, 'HalfPowerFrequency1',    59, 'HalfPowerFrequency2',  61, 'SampleRate', 32000); % verified order, settings by testing
filters.so.spindle  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    12, 'HalfPowerFrequency2',  14, 'SampleRate', 32000); % sleep spindles occur before k-complexes, and must be ~500+microscends
filters.so.nrem     = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   40, 'SampleRate', 32000);


avgChew = filtfilt( filters.so.chew, moreLfp ); figure; plot(timestampSeconds, avgChew)
env=abs(hilbert(avgChew)); hold on; plot(timestampSeconds, env);


avgSpindle = filtfilt( filters.so.nrem, moreLfp ); figure; plot(timestampSeconds, avgSpindle)
env=abs(hilbert(avgSpindle)); hold on; plot(timestampSeconds, env);



avgLfp=median([lfp6,lfp61,lfp64,lfp76,lfp88],2);
moreLfp=median([lfp6,lfp61,lfp64,lfp76,lfp88,lfp12, lfp16, lfp36, lfp46],2);


figure(2); hold off; clf;
fig = gcf;
ax = axes('Parent', fig);
plotInterval = 10; % seconds
lfpSampleRate = 32000; % Hz
videoSampleRate = 29.97; % Hz 
startIdx = 1;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6); 
bumps=[];

% % keymap
% % 
% %   1  left mouse
% %  91  [
% %  93  ]
% %  28  left
% %  29  right
% %  30  up
% %  31  down
% %  27  esc
% % 113  q

while 1
    
    [x, y, button]=ginput(1); 
    if  (button==1); bumps = [bumps x]; end;
    if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
    if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
    if (button==113) || (button==27); break; end;
    
    
    if ( ( startIdx + plotInterval*lfpSampleRate ) < length (timestampSeconds) )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    elseif ( startIdx > 0 )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    else
        beep();
    end
    
    hold(sax1, 'off'); plot( sax1, timestampSeconds(ii), lfp6 (ii) );  axis tight; ylabel( sax1, 'c6'); hold(sax1, 'on'); plot( sax1, timestampSeconds(ii), lfp6(ii)-moreLfp(ii) ); 
    hold(sax2, 'off'); plot( sax2, timestampSeconds(ii), lfp61(ii) ); axis tight; ylabel( sax2, 'c61');  hold(sax2, 'on'); plot( sax2, timestampSeconds(ii), lfp61(ii)-moreLfp(ii) ); 
    hold(sax3, 'off'); plot( sax3, timestampSeconds(ii), lfp88(ii) ); axis tight; ylabel( sax3, 'c88'); hold(sax3, 'on'); plot( sax3, timestampSeconds(ii), lfp88(ii)-moreLfp(ii) ); 
    hold(sax4, 'off'); plot( sax4, timestampSeconds(ii), lfp64(ii) ); axis tight; ylabel( sax4, 'c64');   hold(sax4, 'on'); plot( sax4, timestampSeconds(ii), lfp64(ii)-moreLfp(ii) ); 
    hold(sax5, 'off'); plot( sax5, timestampSeconds(ii), avgLfp(ii) ); axis tight; ylabel( sax5, 'c76'); hold(sax5, 'on'); plot( sax5, timestampSeconds(ii), lfp76(ii) ); plot( sax5, timestampSeconds(ii), moreLfp(ii) );
    plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
    
end



return;

% unless noted, 8 is ASSUMED to be an optimal order -- it may not be. see
% "da10SleepAnalysis.m" to see examples; it's basically guess and check to
% maximize the signal obtained while minimizing the residual signature
% after subtraction
filters.delta    = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.1, 'HalfPowerFrequency2',    4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
filters.lia      = designfilt( 'bandpassiir', 'FilterOrder',  2, 'HalfPowerFrequency1',    1, 'HalfPowerFrequency2',   50, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
filters.theta    = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
filters.alpha    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    8, 'HalfPowerFrequency2',   14, 'SampleRate', 32000);
filters.beta     = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   14, 'HalfPowerFrequency2',   31, 'SampleRate', 32000);
filters.lowGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   30, 'HalfPowerFrequency2',   80, 'SampleRate', 32000); % verified 8 is good
filters.midGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   60, 'HalfPowerFrequency2',  120, 'SampleRate', 32000);
filters.swr      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   99, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
filters.highLfp  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  250, 'HalfPowerFrequency2',  600, 'SampleRate', 32000);
filters.spike    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  600, 'HalfPowerFrequency2', 6000, 'SampleRate', 32000);
filters.nrem     = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   40, 'SampleRate', 32000);
filters.chew     = designfilt( 'bandpassiir', 'FilterOrder', 20, 'HalfPowerFrequency1',  100, 'HalfPowerFrequency2', 1000, 'SampleRate', 32000); % verified order, settings by testing
filters.electric = designfilt( 'bandpassiir', 'FilterOrder', 12, 'HalfPowerFrequency1',    59, 'HalfPowerFrequency2',  61, 'SampleRate', 32000); % verified order, settings by testing
filters.spindle  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    12, 'HalfPowerFrequency2',  14, 'SampleRate', 32000); % sleep spindles occur before k-complexes, and must be ~500+microscends

% local sleep in rats ; https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3085007/
% Phase-Locked Loop for Precisely Timed Acoustic Stimulation during Sleep; https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5169172/
% Effects of phase-locked acoustic stimulation during a nap on EEG ; www.sciencedirect.com/science/article/pii/S1389945715020456
% Acoustic Enhancement of Sleep Slow Oscillations and Concomitant Memory Improvement in Older Adults ; https://www.frontiersin.org/articles/10.3389/fnhum.2017.00109/full
% Cycle-Triggered Cortical Stimulation during Slow Wave Sleep Facilitates
% Learning a BMI Task: A Case Report in a Non-Human Primate ; https://www.frontiersin.org/articles/10.3389/fnbeh.2017.00059/full



