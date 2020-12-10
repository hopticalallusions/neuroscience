% LS Cells Phase Coding Analysis
% this is an evolving script; there will be a lot of notes.
%
% starting with H7, because the histo is in the best shape for that one
%
% H7 histo suggests that the headcap was further back than intended.
% H7 TT 1-9   never went into the LS due to tilt
% h7 TT 25-32 sort of go through the LS (see below)
%    TT 32, 31, 29 are in the targeted part of LS, at about ~ -0.2 AP
%    TT 30, 28     are a bit further back
%    TT 25, 26, 27 are more in the triangular nucleus; maybe early days in LSI?
%
% behaviorwise, the rat looks to be running pretty directly from Jul-12 to Jul-19
% barriers starting Jul 18 (no barrier on a few days including Aug 2)
% Jul-20  wanders more than before
% Jul-24  reversed start
% Jul-25  barriers moved from start to reward arms, clear contemplation
% Jul-26  reversed start
% Jul-27  wanders again
%
% I'm going to start with July 13 and try to figure out about visualizing
% what I have
%
%
% Tad would like the analysis focused on tetrodes that have correlations
% with SWR
%
% so, those would be from Jul-11 to Jul-27 and would be TT 32,31,30,27,25
%
% h7 SWR CSC is : 54
% h7 Theta CSC is : 60 (probably)


%get a system for dealing with the trial database spreadsheet
%make ribbon plot of phase for July 13


pxPerCm = 3.5;  % based on post-distortion corrected metrics as of 2019-01-12

circColor=buildCircularGradient(360);


rotationalParameters.centerX = 412;
rotationalParameters.centerY = 245;
rotationalParameters.degToRotate = -43;
rotationalParameters.xoffset = 440;
rotationalParameters.yoffset = 490;

folders = { '2018-07-13' };

% Temp
ii=1;

%%
% FOR

    filepath = [ '/Volumes/AGHTHESIS2/rats/h7/' folders{ii} '/' ];

    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;  % we're going to adjust this later.
    
    figure(1);
    subplot( 2, 3, 1 ); hold off; plot( xpos, ypos,'Color', [ 0 0 0 .1 ], 'LineWidth', 1 ); %drawnow;
    
   [xpos,ypos]=defishy(xpos,ypos,.000002);  %0.0000028; 4e-4; 2e-4
    ypos=ypos+1/2000.*(ypos).^2;
    xpos=xpos-1/3000.*(720-xpos);
    

    
    [ xpos, ypos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
    subplot(2,3,2); hold off; plot(xpos,ypos,'Color', [ 0 0 0 .1 ], 'LineWidth', 1);

%     speed=calculateSpeed(xpos, ypos, 1, 2.7);
%     subplot(2,3,3);
%     hold off;
%     x = xpos;
%     y = ypos;
%     z = zeros(size(x));
%     h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
%                  'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
%     colormap('jet');
%     colorbar;
%     title('position by speed');
    
    

%%
     %makeFilters;

    [ thetaLfp, lfpTimestamps, lfpHeader ] = csc2mat([ filepath 'CSC60.ncs']); 
    lfpTimestampsSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
    xytimestampSeconds = (xytimestamps-lfpTimestamps(1))/1e6;

    thetaFilter = designfilt( 'bandpassiir', ...
                    'StopbandFrequency1', 3, 'PassbandFrequency1', 4, ...
                   'PassbandFrequency2', 12, 'StopbandFrequency2', 13, ...
                   'StopbandAttenuation1', 30, 'PassbandRipple', 1, ...
                   'StopbandAttenuation2', 30, 'SampleRate', 32000);
    thetaBandLfp = filtfilt( thetaFilter, thetaLfp );
    thetaHilbert = hilbert(thetaBandLfp);
    thetaPhaseRads = angle(thetaHilbert);
    thetaEnvelope = abs(thetaHilbert);     

%%
%     spikeXYidxs  = zeros(size(spikeTimestampsSeconds));
%     spikeLfpIdxs = zeros(size(spikeTimestampsSeconds));
%     for ii=1:length(spikeTimestampsSeconds)
%         spikeXYidxs(ii) = find(xytimestampSeconds>spikeTimestampsSeconds(ii),1);
%         spikeLfpIdxs(ii) = find(lfpTimestampsSeconds>spikeTimestampsSeconds(ii),1);
%     end

    [ ~, spiketimes, spikeheader, ~, cellNumber ]=ntt2mat([ filepath 'TT32a.NTT' ]);
    %[ ~, spiketimes, spikeheader, ~, cellNumber ]=ntt2mat([ filepath 'TT27a.NTT' ]);
    spikeTimestampsSeconds=(spiketimes-lfpTimestamps(1))/1e6;

    
    % valuesAtQueryPoints = interp1( timeAtDataPoint, DataValues, timesReq );
    spikeThetaPhases = interp1( lfpTimestamps, thetaPhaseRads, spiketimes )*180/pi;
    spikeSpeeds = interp1( xytimestamps, speed, spiketimes );
    spikeX = interp1( xytimestamps, xpos, spiketimes );
    spikeY = interp1( xytimestamps, ypos, spiketimes );
    
    
    
%% plot the phase


for ii=0:max(cellNumber)
    figure(5);
    subplot(2,4,ii+1);
    hold off;
    plot(xpos,ypos,'Color', [ 0 0 0 .05]); 
    hold on;
    % select a specific cluster that is between a reasonable speed
    idxd =  (spikeSpeeds>10).*(spikeSpeeds<140).*(cellNumber==ii);
    idxd = idxd >= 1;
    scatter( spikeX(idxd), spikeY(idxd), 10, circColor(floor(spikeThetaPhases(idxd)+181),:), 'filled' );
    alpha(.5);
    axis square;
    title([ 'cluster ' num2str(ii) ]);
    if ( ii == 0)
        colormap(circColor);
        colorbar;
        caxis([0 360]);
    end
    %
    figure(6);
    subplot(2,4,ii+1);
    hold off;
    [ xcorrValues, lagtimes ] = acorrEventTimes( spikeTimestampsSeconds(cellNumber==ii) );
    plot( lagtimes, xcorrValues, 'k' ); 
    hold on;
    [ xcorrValues, lagtimes ] = acorrEventTimes( spikeTimestampsSeconds( ( (spikeSpeeds>10) .* ( cellNumber==ii) ) >0) );
    plot( lagtimes, xcorrValues, 'g' ); 
    [ xcorrValues, lagtimes ] = acorrEventTimes( spikeTimestampsSeconds( ( (spikeSpeeds<10) .* ( cellNumber==ii) ) >0) );
    plot( lagtimes, xcorrValues, 'r' ); 
    title([ 'cluster ' num2str(ii) ]);
end




figure(2);colormap(circColor);colorbar;


    
figure;
histogram(speeds)

figure;
histogram(thetaEnvs)
hold on;
histogram(thetaEnvs(speed>10))
histogram(thetaEnvs( ((spikeSpeeds>10).*(spikeSpeeds<140))>=1  ))

figure; scatter(thetaEnvs,speed,'k','filled'); alpha(.05); xlim([0 2]);


thetaEnvs = interp1( lfpTimestamps, thetaEnvelope, xytimestamps );
thetaEnvs = interp1( lfpTimestamps, thetaEnvelope, xytimestamps );


figure; plot(lfpTimestampsSeconds,thetaBandLfp)




   %% theta phase


% for some example cell, what is the preferred firing phase?
figure; rose(thetaPhaseRads(find(cellNumber==cellId)),72)
% for all phases, what is the distribution? it happens to not be uniform
% because the theta signal is not strictly sinusoidal; instead the
% frequency reflects the current speed of the motion; because the phase is
% a time integral of the frequency, and because we know the time integral
% is not a constant, but rather variable and dependent on the behavior, the
% distribution cannot be uniform.
figure; rose(thetaPhaseRads(:),72)








290, 336 bucket center
379, 313 radius measured

364, 500 west arm start

450, 392 is max Y  of South Arm
466, 55 bottom of South Arm


597, 533 start of East Arm


%% map things to flat-ish trajectory space
lPos=zeros(size(xpos));
for ii=1:length(xpos)
    if 98 >= distFromPoint( xpos(ii),ypos(ii) , 290,336)
        % Bucket
        lPos(ii)=-100;
    elseif ( ypos(ii)<400 )
        %disp('south');
        % South Arm
        %               offet correction from bottom of South Arm
        lPos(ii) = ypos(ii) - 50;
    elseif ( xpos(ii) < 364 )
        %disp('west');
        % West Arm
        %          westArm(centerConnectionX) - westArmMin(x) - xpos + length(SouthArm) + center offset
        %        
        lPos(ii) =  ((364-48) - xpos(ii) ) + 350 + 210; 
    elseif ( xpos(ii) < 450 ) && ( ypos(ii) < 500)
        %disp('center s2w')
        % South to West Direct
        lPos(ii) = distFromPoint( xpos(ii),ypos(ii), 450, 392 ) + 350;
    elseif ( xpos(ii) < 450 ) && ( ypos(ii) >= 500);
        % South to East Direct
        lPos(ii) = distFromPoint( xpos(ii),ypos(ii), 450, 392 ) + 350 + 210 + 350;
    elseif ( xpos(ii) > 597 )
        % East Arm
        %          EastArm(centerConnectionX) - EastArmMin(x) - xpos + length(SouthArm) + center offset
        %        
        lPos(ii) =  ((860-597) - xpos(ii) ) + 350 + 210 + 350 + 210; 
        
    else
        lPos(ii) = -1111;
    end
end
figure; plot(xytimestampSeconds,lPos); hold on; plot(xytimestampSeconds,xpos); plot(xytimestampSeconds,ypos);


spikeLp = interp1( xytimestamps, lPos, spiketimes );
spikeLp(spikeLp <1) = 0;
shrunkSpikeLp = floor(spikeLp/15)+1
shrunkSpikePhase = floor()

aa=twoDHistogram( spikeLp, spikeThetaPhases, 15 );
figure; imagesc(aa)
caxis([ 0 220])


ii=4;
idxd =  (spikeSpeeds>10).*(spikeSpeeds<140).*(cellNumber==ii); idxd = idxd >= 1;
figure; scatter( spikeLp(idxd), spikeThetaPhases(idxd), 'k', 'filled' ); alpha(.2)

aa=twoDHistogram( spikeLp(idxd), spikeThetaPhases(idxd), 15 ); figure; imagesc(aa)



figure;
plot3(xpos,ypos,zeros(size(ypos)),'Color', [ 0 0 0 .05]); 
    hold on; ii=4;
    % select a specific cluster that is between a reasonable speed
    idxd =  (spikeSpeeds>10).*(spikeSpeeds<140).*(cellNumber==ii);
    idxd = idxd >= 1;
    scatter3( spikeX(idxd), spikeY(idxd), floor(spikeThetaPhases(idxd)+181), 10, circColor(floor(spikeThetaPhases(idxd)+181),:), 'filled' );
    alpha(.5);
    
    

    figure;
    x = xytimestampSeconds;
    y = lPos;
    z = zeros(size(x));
    h = surface([x(idxd), x(idxd)], [y(idxd), y(idxd)], [z(idxd), z(idxd)], [floor(spikeThetaPhases(idxd)+181), floor(spikeThetaPhases(idxd)+181)], ...
                 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
    colormap(circColor);
    colorbar;
    title('position by speed');
    
    
    
    
idxd =  (spikeSpeeds>15).*(spikeSpeeds<140).*(cellNumber==ii); idxd = idxd >= 1;
figure;
plot( xytimestampSeconds, xpos, 'b' );
hold on;
plot( xytimestampSeconds, ypos, 'r' );
scatter( spikeTimestampsSeconds(idxd), spikeY(idxd)-20, 30, circColor(floor(spikeThetaPhases(idxd)+181),:), 'filled' );
plot( xytimestampSeconds, speed-200, 'Color', [ .1 .8 .2 ] );
colormap(circColor); colorbar;




