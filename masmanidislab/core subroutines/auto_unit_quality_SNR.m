set_plot_parameters

%Added 2012/11/15, allow automated unit quality? 
%Parameters
autoSNRTwoCutoff = 4.5; %default=4.5. Minimum SNR to be counted as low
autoSNROneCutoff = 10; %default=10. Minimum SNR to bw counted as low
autoMinSNROneCutoff = 5; %default=6.
autoMinSNRTwoCutoff = 2;
autoSNROneCountCutoff = 0.15; %Maximum ratio below MinCutoff allowed
autoSNRTwoCountCutoff = 0.15; %Maximum ratio below MinCutoff allowed
% 
% ['manually determine single-unit quality.']
% ['1=high-quality unit;  2=medium-quality unit;  3=low-quality non-single unit.']

load([timesdir 'finalspiketimes.mat'])
load([savedir 'final_params.mat']);  %loads parameters file.
bestchannel=parameters.bestchannels;
halfwidth=parameters.wavespecs.halfwidth;

scrsz=get(0,'ScreenSize');

unitquality=[];
% 
% figure(1)
% close 1
% figure(1)
% set(gcf,'Position',[0.5*scrsz(1)+400 0.5*scrsz(2)+400 0.5*scrsz(3) 0.5*scrsz(4)])
    
disp(['Spike Number Low Cutoff: ', num2str(final_minspikesperunit)]);
disp(['Mean SNR 2 Cutoff: ', num2str(autoSNRTwoCutoff)]);
disp(['Mean SNR 1 Cutoff: ', num2str(autoSNROneCutoff)]);
disp(['Vpp Cutoff: ', num2str(minVtrough), ' uV']);
disp(['Minimum 1 SNR Cutoff: ', num2str(autoMinSNROneCutoff)]);
disp(['Minimum 2 SNR Cutoff: ', num2str(autoMinSNRTwoCutoff)]);
disp(['Minimum SNR Count Cutoff: ', num2str(autoSNROneCountCutoff)]);

%Added 2012/11/15, keep track of number of each
oneCount = 0;
twoCount = 0;
threeCount = 0;
    
for unit=1:length(spiketimes);
    timesuniti=spiketimes{unit};
    
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    
    bestchan=bestchannel{unit};
    
    if length(bestchan)==0
    ['unit ' num2str(unit) ' has no bestchannel; skipping this unit.']
    unitquality=[unitquality, 3];   
    continue
    end
    
    lengthperchan=size(waveforms{bestchan},2);
   
    wavesinbestchan=waveforms{bestchan};
    maxtime=size(wavesinbestchan,2)/samplingrate-1/samplingrate;
    
    
    if length(wavesinbestchan)==0
        unitquality=[unitquality, 3];
        continue
    end
if(runAutoUnitQuality=='d')
    
    summaryplotunit=imread([savedir 'units\unit' num2str(unit) '.jpg']);
    imshow(summaryplotunit)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Experimental SNR Calculations (Beginning 2012/11/9)
    %Fixed average SNR Calculation (2012/11/15)
    peakLeftInterval = round(final_leftpoints/2);
    peakRightInterval = round(final_leftpoints + final_rightpoints/2);
    peakIntervalSize = (peakRightInterval - peakLeftInterval) + 1;
    [nRowsWavesInBestChan, nColsWavesInBestChan] = size(wavesinbestchan);
    peakReferenceSignal = mean(wavesinbestchan(:, peakLeftInterval:peakRightInterval));
    %Allocate a matrix for the noise data (efficency improved with larger matricies)
    peakNoiseData = zeros(nRowsWavesInBestChan, peakIntervalSize);
    %Allocate a vector for the Root Mean Square power of the noise
    peakNoiseRmsAmplitude = zeros(1, nRowsWavesInBestChan);
    %Root Mean Square Power of the signal
    peakReferenceSignalRmsAmplitude = sqrt((1/peakIntervalSize) * sum(peakReferenceSignal.^2));
    %SNR of each noise waveform
    peakSignalToNoise = zeros(1, nRowsWavesInBestChan);
    %Average Signal to noise
    peakMeanSignalToNoise = 0;
    
    %Semi-redundant calculations for the entire waveform
    longReferenceSignal = mean(wavesinbestchan);
    longNoiseData = zeros(nRowsWavesInBestChan, nColsWavesInBestChan);
    longNoiseRmsAmplitude = zeros(1, nColsWavesInBestChan);
    longReferenceSignalRmsAmplitude = sqrt((1/nColsWavesInBestChan) * sum(longReferenceSignal.^2));
    longSignalToNoise = zeros(1, nRowsWavesInBestChan);
    longMeanSignalToNoise = 0;
    
    %Calculate the noise by subtracting the reference signal from each wave
    for currentRow=1:nRowsWavesInBestChan
        peakNoiseData(currentRow, :) = wavesinbestchan(currentRow, peakLeftInterval:peakRightInterval) - peakReferenceSignal;
    end
    %Calculate the RMS power of the noise
    for currentRow=1:nRowsWavesInBestChan
        %Square root of sum of all of the elemtents of a row squared divided
        %by the number of elements
        peakNoiseRmsAmplitude(currentRow) = sqrt((1/peakIntervalSize) * sum(peakNoiseData(currentRow, :).^2));
    end
    %Calculate the SNR of each of the noise waveforms
    peakSignalToNoise = (peakReferenceSignalRmsAmplitude./peakNoiseRmsAmplitude).^2;
    peakMeanSignalToNoise = mean(peakSignalToNoise);
    %Possibly check if there is any relationship between meanSignalToNoise
    %and the unit quality assigned

    for currentRow=1:nRowsWavesInBestChan
        longNoiseData(currentRow, :) = wavesinbestchan(currentRow, :) - longReferenceSignal;
        longNoiseRmsAmplitude(currentRow) = sqrt((1/nColsWavesInBestChan) * sum(longNoiseData(currentRow, :).^2));
    end
    longSignalToNoise = (longReferenceSignalRmsAmplitude./longNoiseRmsAmplitude).^2;
    longMeanSignalToNoise = mean(longSignalToNoise);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    minSNRCount = 0;
    if(length(timesuniti) <= final_minspikesperunit)
        disp(['Assigning 3, number of spikes too low']);
        unitquality = [unitquality, 3];
        threeCount = threeCount + 1;
    elseif(round(range(mean(wavesinbestchan))) < minVtrough)
        disp(['Assigning 3, Vpp below cutoff']);
        unitquality = [unitquality, 3];
        threeCount = threeCount + 1;
    else
        disp(['Mean SNR = ' num2str(peakMeanSignalToNoise)]);
        disp(['Mean Long SNR = ' num2str(longMeanSignalToNoise)]);
        madeDecision = false;
        if(peakMeanSignalToNoise > autoSNROneCutoff)

            for current=1:nRowsWavesInBestChan
                if(peakSignalToNoise(current) <= autoMinSNROneCutoff)
                   minSNRCount = minSNRCount + 1;
                end
            end

            if(minSNRCount >= autoSNROneCountCutoff*nRowsWavesInBestChan)
            disp(['Minimum SNR Count for 1 too high, proceeding with other checks']);
            else
            unitquality = [unitquality, 1];
            disp(['Assigning 1']);
            oneCount = oneCount + 1;
            madeDecision = true;
            end
        end
        if(~madeDecision && peakMeanSignalToNoise > autoSNRTwoCutoff)
            minSNRCount = 0;
            for current=1:nRowsWavesInBestChan
                if(peakSignalToNoise(current) <= autoMinSNRTwoCutoff)
                    minSNRCount = minSNRCount + 1;
                end
            end
            if(minSNRCount >= autoSNRTwoCountCutoff*nRowsWavesInBestChan)
            disp(['Minimum SNR Count for 2 too high, proceeding with other checks']);
            else
            unitquality = [unitquality, 2];
            disp(['Assigning 2']);
            twoCount = twoCount + 1;
            madeDecision = true;
            end
        end
        if(~madeDecision)
            unitquality = [unitquality, 3];
            disp(['Assigning 3']);
            threeCount = threeCount + 1;
            madeDecision = true;
        end
    end
 
    if(runAutoUnitQuality=='d')
        disp(['Min SNR: ', num2str(min(peakSignalToNoise))]);
        disp(['Min SNR Ratio (only has meaning if tried 1 or 2): ', num2str(minSNRCount/nColsWavesInBestChan)]);
        disp(['========================================================']);
        pause
    end

end
disp(['*****Summary*****']);
disp(['Number of 1s: ', num2str(length(find(unitquality==1)))]);
disp(['Number of 2s: ', num2str(length(find(unitquality==2)))]);
disp(['Number of 3s: ', num2str(length(find(unitquality==3)))]);
disp(['*****************']);

if(runAutoUnitQuality=='s')
    disp('Running Manual Portion of Semi-Automatic Unit Quality');
    nColsUnitQuality = length(unitquality);
    reCheckIndicies=[];
    for current=1:nColsUnitQuality
        if unitquality(current) == 2
            reCheckIndicies = [reCheckIndicies, current];
        end
    end
    nColsRecheckIndicies = length(reCheckIndicies);
    for current=1:nColsRecheckIndicies
        unit=reCheckIndicies(current);
       
        summaryplotunit=imread([savedir 'units\unit' num2str(unit) '.jpg']);
        imshow(summaryplotunit)
         
        figure(1)

        qual=[];
        qual=input(['Specify quality of unit ' num2str(unit) ': '],'s'); 
        figure(1)
            while isempty(qual)==1
                qual=input(['You did not specify quality of unit ' num2str(unit) ': '],'s');
            end
        unitquality(unit) = str2num(qual);

    end
    
disp(['*****Summary*****']);
disp(['Number of 1s: ', num2str(length(find(unitquality==1)))]);
disp(['Number of 2s: ', num2str(length(find(unitquality==2)))]);
disp(['Number of 3s: ', num2str(length(find(unitquality==3)))]);
disp(['*****************']);
   
end

save([savedir 'unitquality.mat'],'unitquality','-mat')

disp(['done assigning unit quality to ' filename '.'])
% close 1
