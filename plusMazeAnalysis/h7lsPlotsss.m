% LS Cells
%
% Autocorrelegram + rose theta phase + SWR Auto Correlegram
%
% this is another evolving script; there will be a lot of notes.
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

% '2018-07-11' 

folders = {    '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30' '2018-07-12' };
ttFilenames={  'TT32a.NTT'  'TT31a.NTT'  'TT30a.NTT'  'TT27a.NTT'  'TT25a.NTT' };

thetaFilter = designfilt( 'bandpassiir', ...
                'StopbandFrequency1', 3, 'PassbandFrequency1', 4, ...
               'PassbandFrequency2', 12, 'StopbandFrequency2', 13, ...
               'StopbandAttenuation1', 30, 'PassbandRipple', 1, ...
               'StopbandAttenuation2', 30, 'SampleRate', 32000);
    
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
               


           
subplotIdx=1;
subplotIdxPhase=1;

%%
% FOR
for folderIdx = 1:length(folders)
    
    filepath = [ '/Volumes/AGHTHESIS2/rats/h7/' folders{folderIdx} '/' ];

    %% load and prepare positional data
    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;  % we're going to adjust this later.
    
    [ xpos, ypos ]=defishy( xpos, ypos, 0.000002 );  %0.0000028; 4e-4; 2e-4
    ypos = ypos + 1/2000 .* ( ypos ).^2;
    xpos = xpos - 1/3000 .* ( 720 - xpos );
 
    [ xpos, ypos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
 
    speed=calculateSpeed(xpos, ypos, 1, 3.5);

%% load theta LFP

    [ thetaLfp, lfpTimestamps, lfpHeader ] = csc2mat([ filepath 'CSC84.ncs']); 
    lfpTimestampsSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
    xytimestampSeconds = (xytimestamps-lfpTimestamps(1))/1e6;

    thetaBandLfp = filtfilt( thetaFilter, thetaLfp );
    thetaHilbert = hilbert(thetaBandLfp);
    thetaPhaseRads = angle(thetaHilbert);
    thetaEnvelope = abs(thetaHilbert);     

    
%% load SWR stuff

    [ lfpSwr, lfpSwrTimestamps ]=csc2mat( [ filepath 'CSC56.ncs' ] );
    lfpSwrTimestampSeconds = (lfpSwrTimestamps-lfpSwrTimestamps(1))/1e6;
    
    swrLfp = filtfilt( swrFilter, lfpSwr );
    swrLfpEnv = abs(hilbert(swrLfp));

    swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

    [swrPeakValues,      ...
     swrPeakTimes,       ... 
     swrPeakProminances, ...
     swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                  lfpSwrTimestampSeconds,                     ... % sampling frequency
                                  'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                  'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

    % build some structures for later SWR analysis
    swrPosAll=zeros(2,length(swrPeakTimes));
    swrSpeedAll=zeros(1,length(swrPeakTimes));
    for ii=1:length(swrPeakTimes)
        tempIdx=find(swrPeakTimes(ii)<=xytimestampSeconds, 1 );
        if ~isempty(tempIdx)
            swrPosAll(1,ii) = xpos (tempIdx);
            swrPosAll(2,ii) = ypos (tempIdx);
            swrSpeedAll(ii) = speed (tempIdx);
        end
    end
    swrPosFast=swrPosAll(:,swrSpeedAll>8);
    swrPosSlow=swrPosAll(:,swrSpeedAll<=8);
    %
    

    

    for ttIdx = 1:length(ttFilenames)

        if exist([ filepath ttFilenames{ttIdx} ], 'file')
            
            [ ~, spiketimes, spikeheader, ~, cellNumber ] = ntt2mat( [ filepath ttFilenames{ttIdx} ] );
            spikeTimestampsSeconds = ( spiketimes - lfpTimestamps(1) )/1e6;

            % valuesAtQueryPoints = interp1( timeAtDataPoint, DataValues, timesReq );
            spikeThetaPhases = interp1( lfpTimestamps, thetaPhaseRads, spiketimes )*180/pi;
            spikeSpeeds = interp1( xytimestamps, speed, spiketimes );
            spikeX = interp1( xytimestamps, xpos, spiketimes );
            spikeY = interp1( xytimestamps, ypos, spiketimes );

%%  PROCESS THE CLUSTERS
            
            for cellId = 0:max(cellNumber)

                % select spikes from a specific cluster that are between reasonable speeds
                idxd = (spikeSpeeds>15).*(spikeSpeeds<140).*(cellNumber==cellId);
                idxd = idxd >= 1;
                
                gcf(1)=figure(1);
                
                subplot( 7, 8, subplotIdx );
                hold off;
                [ xcorrValues, lagtimes ] = acorrEventTimes( spikeTimestampsSeconds(cellNumber==cellId) );
                plot( lagtimes, xcorrValues, 'k' ); 
                hold on;
                [ xcorrValues, lagtimes ] = acorrEventTimes( spikeTimestampsSeconds( ( (spikeSpeeds>15) .* ( cellNumber==cellId) ) >0) );
                plot( lagtimes, xcorrValues, 'g' ); 
                [ xcorrValues, lagtimes ] = acorrEventTimes( spikeTimestampsSeconds( ( (spikeSpeeds<15) .* ( cellNumber==cellId) ) >0) );
                plot( lagtimes, xcorrValues, 'r' ); 
                
                
                subplot( 7, 8, subplotIdx+1 );
                % this bit of code puts color under the rose plot
                hold off;
                [tout, rout] = rose(spikeThetaPhases(idxd),36);
                polar(tout, rout);
                [xout, yout] = pol2cart(tout, rout);                    
                for ii=1:2:length(xout)-2
                    patch(xout(ii:ii+2),yout(ii:ii+2),'c');
                end
                hold on;
                plot(xout,yout, 'k');
                title([ '_{' folders{folderIdx}  ' ' strrep(ttFilenames{ttIdx},'.NTT','') ' ' num2str(cellId) '}' ]);
                axis square;
                
                
                
                subplot( 7, 8, subplotIdx+2 );
                hold off;
                [ xcorrValues, lagtimes ] = xcorrEventTimes( swrPeakTimes, spikeTimestampsSeconds(cellNumber==cellId) );
                plot( lagtimes, xcorrValues, 'k' ); 
                hold on;
                [ xcorrValues, lagtimes ] = xcorrEventTimes( swrPeakTimes(swrSpeedAll>8), spikeTimestampsSeconds(idxd) );
                plot( lagtimes, xcorrValues, 'g' ); 
                [ xcorrValues, lagtimes ] = xcorrEventTimes( swrPeakTimes(swrSpeedAll<=8), spikeTimestampsSeconds( ( ( spikeSpeeds < 15 ) .* ( cellNumber == cellId ) ) >0) );
                plot( lagtimes, xcorrValues, 'r' );

%% LONG BLOCK -- this is just going to produce several colored rose plots

                %start arm
                %460, 314 and less than 86 
                subplot( 7, 8, subplotIdx+3 );
                idxdd = (  idxd .* ( distFromPoint(spikeX,spikeY,460,314 ) < 90 )  ) > 0;
                [tout, rout] = rose(spikeThetaPhases(idxdd),36);
                [xout, yout] = pol2cart(tout, rout/max(rout) );
                for ii=1:2:length(xout)-2
                    patch(xout(ii:ii+2),yout(ii:ii+2), [ .8 .1 .1 ]); 
                end
                alpha(.5);
                hold on;
                plot(xout,yout,'k')


                %middle bit
                %387, 456  less than 90
                idxdd = (  idxd .* ( distFromPoint(spikeX,spikeY,387,486 ) < 90 )  ) > 0;
                [tout, rout] = rose(spikeThetaPhases(idxdd),36);
                [xout, yout] = pol2cart(tout, rout/max(rout) );
                for ii=1:2:length(xout)-2
                    patch(xout(ii:ii+2),yout(ii:ii+2), [ .1 .8 .1 ]); 
                end
                alpha(.5);
                plot(xout,yout,'k')


                %West reward arm
                %136, 498  less than 100
                idxdd = (   idxd .* ( distFromPoint(spikeX,spikeY,136,498 ) < 90 )  ) > 0;
                [tout, rout] = rose(spikeThetaPhases(idxdd),36);
                [xout, yout] = pol2cart(tout, rout/max(rout) );
                for ii=1:2:length(xout)-2
                    patch(xout(ii:ii+2),yout(ii:ii+2), [ .1 .1 .8 ]); 
                end
                alpha(.5);
                plot(xout,yout,'k')


                %East Reward Arm
                %810, 542 less than 100               
                idxdd = (   idxd .* ( distFromPoint(spikeX,spikeY,810,542 ) < 100 )  ) > 0;
                [tout, rout] = rose(spikeThetaPhases(idxdd),36);
                [xout, yout] = pol2cart(tout, rout/max(rout) );
                for ii=1:2:length(xout)-2
                    patch(xout(ii:ii+2),yout(ii:ii+2), [ .1 .8 .8 ]); 
                end
                alpha(.5);
                plot(xout,yout,'k');

                axis square;
                xlim ([ -1.02 1.02 ]);
                ylim ([ -1.02 1.02 ]);
                %polar( tout, rout/max(rout) );
                %rose(spikeThetaPhases(idxd),36);


%% Do important accounting type things
                
                
                subplotIdx = subplotIdx + 4
                
                if ( subplotIdx > 7*8 )
                    subplotIdx = 1;
                    print(gcf(1), [ filepath '/../../../summaryData/' 'h7_lsAcorrThetaRoseSwrXcorr_' folders{folderIdx}  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(cellId) '_.png'],'-dpng','-r200');
                    clf(gcf(1));
                    %break;
                end

                
%                 gcf(2)=figure(2);
%                 subplot(2,4,subplotIdxPhase);
%                 hold off;
%                 plot(xpos,ypos,'Color', [ 0 0 0 .05]); 
%                 hold on;
%                 % select a specific cluster that is between a reasonable speed
%                 idxd =  (spikeSpeeds>10).*(spikeSpeeds<140).*(cellNumber==cellId);
%                 idxd = idxd >= 1;
%                 scatter( spikeX(idxd), spikeY(idxd), 10, circColor(floor(spikeThetaPhases(idxd)+181),:), 'filled' );
%                 alpha(.5);
%                 axis square;
%                 title([ '_{' folders{folderIdx}  ' ' strrep(ttFilenames{ttIdx},'.NTT','') ' ' num2str(cellId) '}' ]);
%                 if ( cellId == 0)
%                     colormap(circColor);
%                     colorbar;
%                     caxis([0 360]);
%                 end
%                 subplotIdxPhase = subplotIdxPhase + 1;
%                 if ( subplotIdxPhase > 8 )
%                     subplotIdxPhase = 1;
%                     print(gcf(2), [ filepath '/../../../summaryData/' 'h7_lsPhaseMap_' folders{folderIdx}  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(cellId) '_.png'],'-dpng','-r200');
%                     clf(gcf(2));
%                     %break;
%                 end
                
            end
        
            ttData.cellNumber = cellNumber;
            ttData.timestamp = spiketimes;
            ttData.timestampSeconds = spikeTimestampsSeconds;
            ttData.speed = spikeSpeeds;
            ttData.x = spikeY;
            ttData.y = spikeX;
            ttData.thetaPhase = spikeThetaPhases;
            ttData.metadata = [ 'h7_' folders{folderIdx}  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(cellId) ];
            
            
            save( [ filepath '/../../../summaryData/' 'h7_lsAcorrThetaRoseSwrXcorrZones_' folders{folderIdx}  '_' strrep(ttFilenames{ttIdx},'.NTT','') '.dat'], 'ttData' );
            
        end
        
    end
    
end

            
                    print(gcf(1), [ filepath '/../../../summaryData/' 'h7_lsAcorrThetaRoseSwrXcorrZones_' folders{folderIdx}  '_' strrep(ttFilenames{ttIdx},'.NTT','') '_cluster_' num2str(cellId) '_.png'],'-dpng','-r200');

% 
%     
% figure;
% idxd = (  (cellNumber==1 ) .* (spikeSpeeds>15)  ) > 0;
% [tout, rout] = rose(spikeThetaPhases(idxd),36);
% [xout, yout] = pol2cart(tout, rout/max(rout) );
% for ii=1:2:length(xout)-2
%     patch(xout(ii:ii+2),yout(ii:ii+2), [ .5 .1 .8 ]); 
% end
% alpha(.5)
% hold on;
% plot(xout,yout,'k')
% axis square;
% xlim ([ -1.02 1.02 ]);
% ylim ([ -1.02 1.02 ]);
% %polar( tout, rout/max(rout) );
% %rose(spikeThetaPhases(idxd),36);
% 
% 
% start arm
% 460, 314
% and less than 86 
% 
% middle bit
% 387, 456  less than 90
% 
% West reward arm
% 136, 498  less than 100
% 
% East Reward Arm
% 810, 542 less than 100