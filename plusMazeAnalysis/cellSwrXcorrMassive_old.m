 %% load data

% dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2016-08-22_orientation1/1.maze-habituation/';
% ttFilenames={'TT2CUTaftermerge.NTT' 'TT5cut.NTT' 'TT7cut.NTT' 'TT8cut.NTT' 'TT10cut.NTT' 'TT14cut.NTT' 'TT15cut.NTT'};
% dateStr='2016-08-22';

function cellSwrXcorrMassive( path, ratName, dateStr, swrFilename )
    %%
    ttFilenames = dir( [path '*a.ntt']);
    tetrodeExtension = '.ntt';
    %
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*a.NTT']);
        tetrodeExtension = '.NTT';
    end
     if isempty(ttFilenames)
        ttFilenames = dir( [path '*cut.ntt']);
        tetrodeExtension = '.ntt';
    end
    if isempty(ttFilenames)
        ttFilenames = dir( [path '*cut.NTT']);
        tetrodeExtension = '.NTT';
    end
    
    subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6 ];

    speedThreshold = 10; % cm/s

    [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ path '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
    speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
    speed=speedAll;

    gcf(1)=figure(1); 



    %% SWR band

    if  strcmp( swrFilename(1:3), 'SWR');
        [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ] );
    else
        [ lfpSwr, lfpTimestamps ]=csc2mat( [ path swrFilename ] );
        swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
        swrLfp = filtfilt( swrFilter, lfpSwr );
    end

    if ~exist([path '/swrData.mat']);
        lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
        swrLfpEnv = abs(hilbert(swrLfp));
        swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number
        [swrPeakValues,      ...
         swrPeakTimes,       ... 
         swrPeakProminances, ...
         swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                                      lfpTimestampSeconds,                     ... % sampling frequency
                                      'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                                      'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
        swrData.times = swrPeakTimes;
        swrData.peaks = swrPeakValues;
        swrData.file = swrFilename;
        save( [ path '/swrData' ], 'swrData' )
    else
        load( [ path '/swrData.mat' ] );
        swrPeakTimes = swrData.times;
        swrPeakValues = swrData.peaks;
        swrFilename  = swrData.file;
    end

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
    swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
    swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);
    %
    temptext = path;
    disp( temptext );
    
    temptext = dateStr;
    disp( temptext );

plateCounter = 1;
    for ttIdx=1:length(ttFilenames)
        
        try
            disp( ttFilenames{ttIdx} );
        catch
            disp( ttFilenames(ttIdx).name );
        end

        try
 %           [ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames{ttIdx} ]);
            thisTtFilename = ttFilenames{ttIdx};
            disp( thisTtFilename );
        catch
            %[ spikeWaveforms, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ path ttFilenames(ttIdx).name ]);
            thisTtFilename = ttFilenames(ttIdx).name;
            disp( thisTtFilename );
        end
        
        cellPosAll = zeros(2,length(spiketimes));   % row 1 is X, row 2 is Y
        cellSpeedAll = zeros(1,length(spiketimes)); % collect all the speeds
        cellTimesAll = zeros(1,length(spiketimes));
        for ii=1:length(spiketimes)
            tempIdx=find(spiketimes(ii)<=xytimestamps, 1 );
                if ~isempty(tempIdx)
                    cellPosAll(1,ii) = xpos (tempIdx);
                    cellPosAll(2,ii) = ypos (tempIdx);
                    cellSpeedAll(ii) = speed (tempIdx);
                    cellTimesAll(ii) = spiketimes(ii);
                end
        end
        cellTimesAllSeconds = (cellTimesAll-lfpTimestamps(1))/1e6;
        % simple speed filter hack
        cellNFast = cellNumber(cellSpeedAll>speedThreshold);
        cellTimesFast = cellTimesAll(cellSpeedAll>speedThreshold);
        cellTimesFastSeconds = (cellTimesFast-lfpTimestamps(1))/1e6;
        %
        cellNSlow = cellNumber(cellSpeedAll<=speedThreshold);
        cellTimesSlow = cellTimesAll(cellSpeedAll<=speedThreshold);
        cellTimesSlowSeconds = (cellTimesSlow-lfpTimestamps(1))/1e6;
        %
        subplotIdx = 1;
        for whichCell=0:max(cellNFast)
            if sum(cellNFast==whichCell) > 2                
%%                % plot swr X cell firing
                subplot(8,16,subplotIdx);
                hold off;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesAllSeconds(cellNumber==whichCell), swrPeakTimes );
                plot(lagtimes,xcorrValues, 'k');
                hold on;
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesFastSeconds(cellNFast==whichCell), swrPeakTimes(swrSpeedAll>speedThreshold) );
                plot(lagtimes,xcorrValues,'g'); 
                [ xcorrValues, lagtimes] = xcorrEventTimes( cellTimesSlowSeconds(cellNSlow==whichCell), swrPeakTimes(swrSpeedAll<=speedThreshold) );
                scatter(0,0,1,'.','k'); alpha(.01);%hack to force to zero.
                plot(lagtimes,xcorrValues,'r'); 
                set( gca, 'XTick', [], 'YTick', [] )
                %subplot tight;
                try
                    title( [strrep(ttFilenames{ttIdx},tetrodeExtension,'') ' c' num2str(whichCell) ]);
                catch
                    title( [strrep(ttFilenames(ttIdx).name,tetrodeExtension,'') '_c_' num2str(whichCell) ]);
                end
%%              
                if ( subplotIdx > 16*8 )
                    try
                        print(gcf(1), [ path ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_.png'],'-dpng','-r200');
                    catch
                        print(gcf(1), [ path ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_.png'],'-dpng','-r200');
                    end
                    plateCounter = plateCounter + 1;
                    clf(gcf(1));
                    subplotIdx = 1;
                else
                    subplotIdx = subplotIdx + 1;
                end
               
            else
                warning([ ' not enough spikes w/ ' num2str(sum(cellNFast==whichCell)) ]);
            end
        end
    end
    
try
    print(gcf(1), [ path ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_.png'],'-dpng','-r200');
catch
    print(gcf(1), [ path ratName '_swrMassive_' dateStr  '_' num2str(plateCounter) '_.png'],'-dpng','-r200');
end

return; 
