h5
'BC 577 DOI Oct 15.plx';

filename = 'BC577_2013-10-15_DOI.nex';
hdpath = '~/data/ana/doiData/';
nexFileData = readNexFile([hdpath filename]);

recFreq = 1000; % Hz for EEG data


fh=figure;

twitchTimes = [ 47 100 116 127 164 186 222 274 343 373 ];
noTwitchTimes = [ 930 950 957 1015 1068 1120 1152 1209 1373 1421 ];
lookAround = 3; % seconds

twitchTimesIdx = 1;


for chIdx = 1:6:8
    for twitchTimesIdx = 1:length(twitchTimes)
        twitchTime = twitchTimes(twitchTimesIdx);
        secStartIdx = round((twitchTime-lookAround)*recFreq);
        secEndIdx   = round((twitchTime+lookAround)*recFreq);
        sst=nexFileData.contvars{chIdx,1}.data(secStartIdx:secEndIdx);

        hdWavelet( sst, 1, fh, 1 );

        outputFilename = [ hdpath 'waveletHeadTwitchVisualization/' 'norm_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_twitchTime-' num2str( twitchTime ) '_ch-' num2str( chIdx ) '.png' ];
        print( outputFilename, '-dpng', '-r200' );
        clf(fh);
    end
end


clf
decimateFactor=5;
channelList = [ 1 7 ]; 
for chIdx = 1:2
    for twitchTimesIdx = 1:length(twitchTimes)
        twitchTime = twitchTimes(twitchTimesIdx);
        secStartIdx = round((twitchTime-lookAround)*recFreq);
        secEndIdx   = round((twitchTime+lookAround)*recFreq);
        sst=nexFileData.contvars{channelList(chIdx),1}.data(secStartIdx:secEndIdx);
        [ pwr, ff] = plotFft( sst, 1e3, 0 );
        subplot(2,1,chIdx)
            plot(decimate(ff,decimateFactor),decimate(pwr,decimateFactor), 'LineWidth', 2); hold on;
    end
end
for chIdx = 1:2
    for twitchTimesIdx = 1:length(noTwitchTimes)
        twitchTime = noTwitchTimes(twitchTimesIdx);
        secStartIdx = round((twitchTime-lookAround)*recFreq);
        secEndIdx   = round((twitchTime+lookAround)*recFreq);
        sst=nexFileData.contvars{channelList(chIdx),1}.data(secStartIdx:secEndIdx);
        [ pwr, ff] = plotFft( sst, 1e3, 0 );
        subplot(2,1,chIdx)
            plot(decimate(ff,decimateFactor),decimate(pwr,decimateFactor), 'LineStyle', ':', 'LineWidth', 2); hold on;
    end
end









figure;  timesSeconds = (1:length(nexFileData.contvars{1,1}.data))/1e3;
for chIdx = 1:8
    plot(timesSeconds,nexFileData.contvars{chIdx,1}.data+(8-chIdx))
    hold on;
end
for twitchIdx = 1:10
    line( [twitchTimes(twitchIdx) twitchTimes(twitchIdx) ], [ -1 8], 'Color', 'g');
    line( [twitchTimes(twitchIdx)+1 twitchTimes(twitchIdx)+1 ], [ -1 8], 'Color', 'r');
end
legend('1','2','3','4','5','6','7','8')




figure;
for twitchTimesIdx = 1:length(twitchTimes)
    twitchTime = twitchTimes(twitchTimesIdx);
    secStartIdx = round((twitchTime-lookAround)*recFreq);
    secEndIdx   = round((twitchTime+lookAround)*recFreq);
    sstCtx=nexFileData.contvars{1,1}.data(secStartIdx:secEndIdx);
    sstStr=nexFileData.contvars{7,1}.data(secStartIdx:secEndIdx);
    [ corr, lags ] = xcorr(sstCtx,sstStr);
    hold on; plot(lags/1e3, corr);
end















filelist = { 'BC543_2013-10-25_DOI+WW.nex' 'BC577_2013-10-23_WW.nex' 'BC543_2013-10-25_WW.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC563_2013-10-18_DOI.nex' 'BC577_2013-11-27_WC.nex' 'BC563_2013-10-18_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC563_2013-10-22_DMSO.nex' 'BC586_2013-10-17_basal.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC586_2013-10-21_DOI.nex' 'BC563_2013-11-26_WC.nex' 'BC586_2013-10-21_basal.nex' 'BC565_2013-10-15_DOI.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC565_2013-10-15_basal.nex' 'BC586_2013-10-23_WW.nex' 'BC565_2013-10-18_DOI.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC565_2013-10-18_basal.nex' 'BC586_2013-11-26_WC.nex' 'BC565_2013-10-22_DMSO.nex' 'BC595_2013-10-17_DOI.nex' 'BC566_2013-10-16_DOI.nex' 'BC595_2013-10-17_basal.nex' 'BC566_2013-10-16_basal.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC597_2013-12-05_WC.nex' 'BC566_2013-10-24_WW.nex' 'BC607_2013-10-17_DOI.nex' 'BC567_2013-10-16_DOI.nex' 'BC607_2013-10-17_basal.nex' 'BC567_2013-10-16_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC607_2013-10-22_basal.nex' 'BC567_2013-11-01_WW.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC574_2013-10-22_dmso.nex' 'BC607_2013-11-28_WC.nex' 'BC577_2013-10-15_DOI.nex' 'BC607_2013-12-05_DOI+WC.nex' 'BC577_2013-10-15_basal.nex' 'BC607_2013-12-05_WC.nex' 'BC577_2013-10-23_DOI+WW.nex' };
RMSnoise = zeros(length(filelist),8);
pctMax = RMSnoise;

for ii = 1:length(filelist)
    filename = filelist{ii};
    nexFileData = readNexFile([hdpath filename]);
    %figure(111);  timesSeconds = (1:length(nexFileData.contvars{1,1}.data))/1e3;
    for chIdx = 1:8
    %    plot(timesSeconds,nexFileData.contvars{chIdx,1}.data-chIdx)
    %    hold on;
        RMSnoise(ii,chIdx) = sqrt( (1/length(nexFileData.contvars{chIdx,1}.data)) * sum(nexFileData.contvars{chIdx,1}.data.^2 ));
        pctMax(ii,chIdx) = sum(abs(nexFileData.contvars{chIdx,1}.data) > prctile(abs(nexFileData.contvars{chIdx,1}.data),99) ) ./ length(nexFileData.contvars{chIdx,1}.data);
    end
    %outputFilename = [ hdpath 'channels/' 'allCh_' filename(1:end-4) '_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_twitchTime-' num2str( twitchTime ) '_ch-' num2str( chIdx ) '.png' ];
    %print( outputFilename, '-dpng', '-r200' );
    %clf;
end


figure; 
colormap('jet')
imagesc(log(RMSnoise))
colorbar

figure; 
colormap('jet')
imagesc((pctMax))
colorbar

    figure(111);  timesSeconds = (1:length(nexFileData.contvars{1,1}.data))/1e3;
    for chIdx = 1:8
        plot(timesSeconds,nexFileData.contvars{chIdx,1}.data-chIdx)
        hold on;
    end
    
figure;
plot( timesSeconds, nexFileData.contvars{3,1}.data-nexFileData.contvars{6,1}.data ); hold on;
plot( timesSeconds, nexFileData.contvars{3,1}.data-nexFileData.contvars{7,1}.data );
plot( timesSeconds, nexFileData.contvars{3,1}.data-nexFileData.contvars{8,1}.data );
plot( timesSeconds, nexFileData.contvars{3,1}.data-nexFileData.contvars{2,1}.data );









decimateFactor = 10;
mouseNames = { 'BC543' 'BC563' 'BC565' 'BC566' 'BC567' 'BC574' 'BC577' 'BC586' 'BC595' 'BC597' 'BC607' };
filelist = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex'  'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-22_DMSO.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex'   };
ctxChs = [ 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1 2 3 3 2 2 1 3 3 3 3 3 3 2 2 2 2 2 2 2 2 1 1 2 2 4 4 4 4 4 4 4 4 ];
strChs = [ 7 7 8 8 8 8 8 8 8 8 8 8 7 7 7 8 7 7 6 6 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 6 6 7 7 7 7 7 7 7 7 ];
figure(12); clf; figure(13); clf;
for fileIdx = 1:length(filelist)
    filename = filelist{fileIdx}
    nexFileData = readNexFile([hdpath filename]);
    subplotIdx = find(strcmp(filename(1:5),mouseNames));
    figure(12);
    subplot(4,3,subplotIdx);
    sst=nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    [ pwr, ff] = plotFft( sst, 1e3, 0 );
    plot(decimate(ff,decimateFactor),decimate(pwr,decimateFactor)); hold on; title(filename(1:5)); drawnow; xlim([ 0 20 ]);
    figure(13);
    subplot(4,3,subplotIdx);
    sst=nexFileData.contvars{(strChs(fileIdx)),1}.data;
    [ pwr, ff] = plotFft( sst, 1e3, 0 );
    plot(decimate(ff,decimateFactor),decimate(pwr,decimateFactor)); hold on; xlim([ 0 20 ]);
    
end

nexFileData = readNexFile([hdpath 'BC543_2013-10-25_WW.nex']); length(nexFileData.contvars{1,1}.data)./1e3
nexFileData = readNexFile([hdpath 'BC543_2013-10-25_DOI+WW.nex']); length(nexFileData.contvars{1,1}.data)./1e3



nexFileData = readNexFile([hdpath 'BC567_2013-11-01_WW.nex']);
figure;
[ pwr, ff] = plotFft( nexFileData.contvars{((1)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((2)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((3)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((4)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((5)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((6)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((7)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
[ pwr, ff] = plotFft( nexFileData.contvars{((8)),1}.data, 1e3, 0 ); hold on; plot(ff, pwr);
legend('1','2','3','4','5','6','7','8')



hdpath = '~/data/ana/doiData/';
jumpAhead = 1;
lookAround = 5;
filename = 'BC543_2013-10-25_DOI+WW.nex';
nexFileData = readNexFile([hdpath filename]);
fileIdx=2;
pp=zeros(10e3,98);
row=1;
for  ii=round(lookAround*1e3)+1:round(jumpAhead*1e3):round(length(nexFileData.contvars{(ctxChs(fileIdx)),1}.data)-(lookAround*1e3))
    sst = nexFileData.contvars{(ctxChs(fileIdx)),1}.data(round(ii-lookAround*1e3):round(ii+lookAround*1e3));
    [ pwr, ff] = plotFft( sst, 1e3, 0 );
    temp = decimate(pwr,decimateFactor);
    pp(row,:) = temp(3:100);
    row=row+1;
end
pp=pp(1:row-1,:);

freqLabels=decimate(ff,decimateFactor); freqLabels=freqLabels(3:100);
timeLabels=(round(lookAround*1e3):round(jumpAhead*1e3):round(length(nexFileData.contvars{(ctxChs(fileIdx)),1}.data)-(lookAround*1e3)))./1e3;



filename = 'BC543_2013-10-25_WW.nex';
nexFileData = readNexFile([hdpath filename]);
fileIdx=2;
qq=zeros(10e3,98);
row=1;
for  ii=round(lookAround*1e3)+1:round(jumpAhead*1e3):round(length(nexFileData.contvars{(ctxChs(fileIdx)),1}.data)-(lookAround*1e3))
    sst = nexFileData.contvars{(ctxChs(fileIdx)),1}.data(round(ii-lookAround*1e3):round(ii+lookAround*1e3));
    [ pwr, ff] = plotFft( sst, 1e3, 0 );
    temp = decimate(pwr,decimateFactor);
    qq(row,:) = temp(3:100);
    row=row+1;
end
qq=qq(1:row-1,:);
ttLabels = 300-(round(lookAround*1e3)+1:round(jumpAhead*1e3):round(length(nexFileData.contvars{(ctxChs(fileIdx)),1}.data)-(lookAround*1e3)))./1e3;

ww=[qq;pp];
ttt=[ ttLabels timeLabels ];
figure; imagesc( freqLabels, ttt, ww )
colormap(build_NOAA_colorgradient); colorbar;



fh=figure; hdWavelet(sst,1,fh,0)


figure; surf( freqLabels, timeLabels, pp )
colormap(build_NOAA_colorgradient); colorbar;


figure; imagesc( freqLabels, timeLabels, pp )
colormap(build_NOAA_colorgradient); colorbar;



signalData = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
windowSize = 2024;
overlap    =  512;
spectrogramPoints = 1024;
sampleFreq = 1e3;

figure; 
[ss,freqs,timess,psd] = spectrogram( signalData, blackman(windowSize), overlap, spectrogramPoints, sampleFreq );
figure; subplot(2,1,1); imagesc(timess,freqs,abs(ss)); ylim([ 1 60]); colorbar; subplot(2,1,2); imagesc(timess,freqs,psd); ylim([ 1 60]); colorbar;

figure; spectrogram( signalData, blackman(windowSize), overlap, spectrogramPoints, sampleFreq );








htData=readtable([ '~/data/ana/doiData/doi-mice-htr-times.csv'], 'ReadVariableNames',true);


decimateFactor = 10;
mouseNames = { 'BC543' 'BC563' 'BC565' 'BC566' 'BC567' 'BC574' 'BC577' 'BC586' 'BC595' 'BC597' 'BC607' };
filelist = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex'  'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-22_DMSO.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex'   };
ctxChs = [ 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1 2 3 3 2 2 1 3 3 3 3 3 3 2 2 2 2 2 2 2 2 1 1 2 2 4 4 4 4 4 4 4 4 ];
strChs = [ 7 7 8 8 8 8 8 8 8 8 8 8 7 7 7 8 7 7 6 6 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 6 6 7 7 7 7 7 7 7 7 ];
windowSize = 512;
overlap    = round(windowSize/2);
spectrogramPoints = 1024;
sampleFreq = 1e3;
figure(41); cmap=build_NOAA_colorgradient;
for fileIdx = 1:length(filelist)
    filename = filelist{fileIdx}
    nexFileData = readNexFile([hdpath filename]);
    subplotIdx = find(strcmp(filename(1:5),mouseNames));
    
    signalData = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    [thisSpectrogram,freqs,timess] = spectrogram( signalData, blackman(windowSize), overlap, spectrogramPoints, sampleFreq );
    [rawPsd]=computepsd(thisSpectrogram,freqs,overlap,spectrogramPoints,sampleFreq);
    psd = 10*log10(abs(rawPsd)+eps);
    
    htMask = find(strcmp( htData.behaviorType, 'HT' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
    qrMask = find(strcmp( htData.behaviorType, 'QR' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
    
    figure(41);
    subplot(2,1,1);
    hold off;
    imagesc(timess,freqs,psd); colormap(cmap); colorbar; % ylim([1 60]);
    hold on;
    if ~isempty(qrMask)
        scatter(htData.start(qrMask),60*ones(1,length(qrMask)), 'o', 'filled');
        scatter(htData.start(htMask),60*ones(1,length(qrMask)), '^', 'filled');
    end
    title(strrep(filename(1:end-4),'_',' '));
    ylabel('frequency (Hz)');
    subplot(2,1,2);
    signalData = nexFileData.contvars{(strChs(fileIdx)),1}.data;
    [thisSpectrogram,freqs,timess] = spectrogram( signalData, blackman(windowSize), overlap, spectrogramPoints, sampleFreq );
    [rawPsd]=computepsd(thisSpectrogram,freqs,overlap,spectrogramPoints,sampleFreq);
    psd = 10*log10(abs(rawPsd)+eps);
    hold off;
    imagesc(timess,freqs,psd); colormap(cmap); colorbar; % ylim([1 60]);
    hold on;
    if ~isempty(qrMask)
        scatter(htData.start(qrMask),60*ones(1,10), 'o', 'filled');
        scatter(htData.start(htMask),60*ones(1,10), '^', 'filled');
    end
    xlabel('elapsed time (s)');
    ylabel('frequency (Hz)');
    
    outputFilename = [ hdpath 'spectrograms/' 'spectroWide_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fileIdx) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );
    
end




%%



decimateFactor = 10;
mouseNames = { 'BC543' 'BC563' 'BC565' 'BC566' 'BC567' 'BC574' 'BC577' 'BC586' 'BC595' 'BC597' 'BC607' };
filelist = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex'  'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-22_DMSO.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex'   };
ctxChs = [        3                         3                             1                          1                           1                            1                             1                             1                             1                             1                             1                             1                        1                        1                        4                        4                           3                           3                          4                         4                             1                           3                           3                           3                           3                           3                           3                           2                           2                           2                           2                           2                           2                           2                           2                           2                            2                           2                           2 4 4 4 4 4 4 4 4 ];
strChs = [        7                         7                             8                          8                           8                            8                             8                             8                             8                             8                             8                             8                        7                        7                        6                        6                           7                           7                          7                         7                             8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                            8                           6                           6 7 7 7 7 7 7 7 7 ];
htData=readtable([ '~/data/ana/doiData/doiMiceHtrTimes.csv'], 'ReadVariableNames',true);
windowSize = 512;
overlap    = round(windowSize/2);
spectrogramPoints = 1024;
sampleFreq = 1e3;
figure(41); cmap=build_NOAA_colorgradient;
prams.Fs=1e3;          % frequency in Hz
prams.pad=0;           % does padding
prams.fpass = [ 1 200]; % [ low high ] Hz
prams.err=[ 2 0.01];   % use jacknife, accept p<0.01
prams.trialave=0;      % don't average trials (none to avg)
prams.tapers=[5 10];   % 


notchOneTwenty = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',118,'HalfPowerFrequency2',122, ...
               'DesignMethod','butter','SampleRate',prams.Fs);
notchOneEighty = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',178,'HalfPowerFrequency2',182, ...
               'DesignMethod','butter','SampleRate',prams.Fs);
notchSixty = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',prams.Fs);
for fileIdx = 1:length(filelist)
    filename = filelist{fileIdx}
    nexFileData = readNexFile([hdpath filename]);
    lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;
    lfp1=locdetrend(lfp1,1e3,[4 3.5]);
    lfp2=locdetrend(lfp2,1e3,[4 3.5]);
%     lfp1 = filtfilt( notchSixty, lfp1 ); 
%     lfp1 = filtfilt( notchOneTwenty, lfp1 ); 
%     lfp1 = filtfilt( notchOneEighty, lfp1 ); 
%     lfp2 = filtfilt( notchSixty, lfp2 ); 
%     lfp2 = filtfilt( notchOneTwenty, lfp2 ); 
%     lfp2 = filtfilt( notchOneEighty, lfp2 ); 

    [C,phi,S12,S1,S2,timeLabels,freqLabels,confC,phistd,Cerr]=cohgramc(lfp1,lfp2,[ 2 .5 ], prams  );
    hold off;
    imagesc(timeLabels,freqLabels,C');
    
    htMask = find(strcmp( htData.behaviorType, 'HT' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
    qrMask = find(strcmp( htData.behaviorType, 'QR' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
    
    hold on;
    if ~isempty(qrMask)
        scatter(htData.start(qrMask),201*ones(1,length(qrMask)), 'o', 'filled');
        scatter(htData.start(htMask),201*ones(1,length(qrMask)), '^', 'filled');
    end
    ylim([0 202]);
    title(strrep(filename(1:end-4),'_',' '));
    xlabel('elapsed time (s)');
    ylabel('frequency (Hz)');
    colormap('jet');
    colorbar; caxis([0 1]);
    
    outputFilename = [ hdpath 'coheroWide_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fileIdx) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );
    
end

   
 
    







hdpath = '~/data/ana/doiData/';

filename = 'BC577_2013-10-15_basal.nex';
filename = 'BC577_2013-10-15_DOI.nex';
filename = 'BC563_2013-11-26_WC.nex';
filename = 'BC563_2013-11-26_DOI+WC.nex';
filename = 'BC566_2013-10-16_DOI.nex';
nexFileData = readNexFile([hdpath filename]);
lfp1 = nexFileData.contvars{1,1}.data;
lfp2 = nexFileData.contvars{7,1}.data;
prams.Fs=1e3;          % frequency in Hz
prams.pad=0;           % does padding
prams.fpass = [ 1 200]; % [ low high ] Hz
prams.err=[ 2 0.01];   % use jacknife, accept p<0.01
prams.trialave=0;      % don't average trials (none to avg)
prams.tapers=[5 10];   % 
figure; 

lfp1=locdetrend(lfp1,1e3,[4 3.5]);
lfp2=locdetrend(lfp2,1e3,[4 3.5]);

[C,phi,S12,S1,S2,timeLabels,freqLabels,confC,phistd,Cerr]=cohgramc(lfp1,lfp2,[ 1 0.8 ], prams  );
figure; imagesc(timeLabels,freqLabels,C')
[C,phi,S12,S1,S2,timeLabels,freqLabels,confC,phistd,Cerr]=cohgramc(data1,data2,[ 1 0.8 ], prams  );
figure; imagesc(timeLabels,freqLabels,C')


notchOneTwenty = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',118,'HalfPowerFrequency2',122, ...
               'DesignMethod','butter','SampleRate',prams.Fs);
notchOneEighty = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',178,'HalfPowerFrequency2',182, ...
               'DesignMethod','butter','SampleRate',prams.Fs);
notchSixty = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',prams.Fs);
data1 = filtfilt( notchSixty, lfp1 ); 
data1 = filtfilt( notchOneTwenty, data1 ); 
data1 = filtfilt( notchOneEighty, data1 ); 


plotFft( data1, 1e3, 1 );

locdetrend
rmlinesc

data = rmlinesc( lfp1, prams, 0.01, 'n', [ 60 120 180 240 ]);




%% OUTPUT FILES FOR ANA

hdpath = '~/data/ana/doiData/nexFiles/';
mouseNames = { 'BC543' 'BC563' 'BC565' 'BC566' 'BC567' 'BC574' 'BC577' 'BC586' 'BC595' 'BC597' 'BC607' };
filelist = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex'  'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-22_DMSO.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex'   };
ctxChs = [        3                         3                             1                          1                           1                            1                             1                             1                             1                             1                             1                             1                        1                        1                        4                        4                           3                           3                          4                         4                             1                           3                           3                           3                           3                           3                           3                           2                           2                           2                           2                           2                           2                           2                           2                           2                            2                           2                           2 4 4 4 4 4 4 4 4 ];
strChs = [        7                         7                             8                          8                           8                            8                             8                             8                             8                             8                             8                             8                        7                        7                        6                        6                           7                           7                          7                         7                             8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                            8                           6                           6 7 7 7 7 7 7 7 7 ];
for fileIdx = 1:length(filelist)
    filename = filelist{fileIdx}
    nexFileData = readNexFile([hdpath filename]);
    subplotIdx = find(strcmp(filename(1:5),mouseNames));
    signalData = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    fid = fopen(['~/data/ana/doiData/nexFiles/' filename(1:end-4) '_ch' num2str((ctxChs(fileIdx))) '.dat'],'wt');
    fwrite(fid,signalData,'float32');
    fclose(fid);
    signalData = nexFileData.contvars{(strChs(fileIdx)),1}.data;
    fid = fopen(['~/data/ana/doiData/nexFiles/' filename(1:end-4) '_ch' num2str((strChs(fileIdx))) '.dat'],'wt');
    fwrite(fid,signalData,'float32');
    fclose(fid);
end

...
fwrite(fid,signalData,'float32');
...
fid = fopen([ hdpath 'BC607_2013-11-28_WC_ch7.dat' ],'r');
aa=fread( fid, Inf, 'float32' );
fclose(fid);

figure; plot(aa)
fid = fopen([ hdpath 'BC607_2013-11-28_WC_ch4.dat' ],'r');
bb=fread( fid, Inf, 'float32' );
fclose(fid);
hold on; plot(bb)

%% channel matrix


hdpath = '~/data/ana/doiData/nexFiles/';
decimateFactor = 10;
mouseNames = { 'BC543' 'BC563' 'BC565' 'BC566' 'BC567' 'BC574' 'BC577' 'BC586' 'BC595' 'BC597' 'BC607' };
filelist = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex'  'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-22_DMSO.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex'   };
ctxChs = [        3                         3                             1                          1                           1                            1                             1                             1                             1                             1                             1                             1                        1                        1                        4                        4                           3                           3                          4                         4                             1                           3                           3                           3                           3                           3                           3                           2                           2                           2                           2                           2                           2                           2                           2                           2                            2                           2                           2 4 4 4 4 4 4 4 4 ];
strChs = [        7                         7                             8                          8                           8                            8                             8                             8                             8                             8                             8                             8                        7                        7                        6                        6                           7                           7                          7                         7                             8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                            8                           6                           6 7 7 7 7 7 7 7 7 ];
windowSize = 512;
overlap    = round(windowSize/2);
spectrogramPoints = 1024;
sampleFreq = 1e3;
figure(41); cmap=build_NOAA_colorgradient;
for fileIdx = 1:length(filelist)
    filename = filelist{fileIdx}
    nexFileData = readNexFile([hdpath filename]);
    subplotIdx = find(strcmp(filename(1:5),mouseNames));
    
    signalData = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    
    figure(41);
    
    
    xlabel('elapsed time (s)');
    ylabel('frequency (Hz)');
    
    outputFilename = [ hdpath 'coherence/' 'cfc_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fileIdx) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );
    
end


%%


windowSize = 2048;
overlap    = round(windowSize/2);
spectrogramPoints = 1024;

filename = 'BC563_2013-10-18_basal.nex'; folderIdx = 3;
nexFileData = readNexFile([hdpath filename]);

lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

figure(3);
[ coherenceCtxA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,1); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceXA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,2); pcolor( cyclicalFreq, cyclicalFreq, coherenceXA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceStrA, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,3); pcolor( cyclicalFreq, cyclicalFreq, coherenceStrA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

filename = 'BC563_2013-10-18_DOI.nex';   folderIdx = 4;
nexFileData = readNexFile([hdpath filename]);

lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

[ coherenceCtxB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,4); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceXB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,5); pcolor( cyclicalFreq, cyclicalFreq, coherenceXB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceStrB, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,6);  pcolor( cyclicalFreq, cyclicalFreq, coherenceStrB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

subplot(3,3,7); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceCtxB./max(coherenceCtxB(:)))-(coherenceCtxA./max(coherenceCtxA(:))) ); shading flat; colorbar; title('normalize; middle - top');
subplot(3,3,8); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceXB  ./max(coherenceXB(:))  )-(coherenceXA  ./max(coherenceXA(:)))   ); shading flat; colorbar; title('normalize; middle - top');
subplot(3,3,9); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceStrB./max(coherenceStrB(:)))-(coherenceStrA./max(coherenceStrA(:))) ); shading flat; colorbar; title('normalize; middle - top');

outputFilename = [ hdpath 'crossFreqCoherenceCompare/' 'cfc_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fileIdx) ) '.png' ];
print( outputFilename, '-dpng', '-r200' );






filename = 'BC563_2013-11-26_WC.nex'; folderIdx = 6;
nexFileData = readNexFile([hdpath filename]);

lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

figure(3);
[ coherenceCtxA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,1); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceXA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,2); pcolor( cyclicalFreq, cyclicalFreq, coherenceXA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceStrA, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,3); pcolor( cyclicalFreq, cyclicalFreq, coherenceStrA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

filename = 'BC563_2013-11-26_DOI+WC.nex';   folderIdx = 7;
nexFileData = readNexFile([hdpath filename]);

lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

[ coherenceCtxB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,4); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceXB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,5); pcolor( cyclicalFreq, cyclicalFreq, coherenceXB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
[ coherenceStrB, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
subplot(3,3,6);  pcolor( cyclicalFreq, cyclicalFreq, coherenceStrB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

subplot(3,3,7); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceCtxB./max(coherenceCtxB(:)))-(coherenceCtxA./max(coherenceCtxA(:))) ); shading flat; colorbar; title('normalize; middle - top');
subplot(3,3,8); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceXB  ./max(coherenceXB(:))  )-(coherenceXA  ./max(coherenceXA(:)))   ); shading flat; colorbar; title('normalize; middle - top');
subplot(3,3,9); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceStrB./max(coherenceStrB(:)))-(coherenceStrA./max(coherenceStrA(:))) ); shading flat; colorbar; title('normalize; middle - top');

outputFilename = [ hdpath 'crossFreqCoherenceCompare/' 'cfc_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fileIdx) ) '.png' ];
print( outputFilename, '-dpng', '-r200' );



%%  coherence


fLIdx    = [ 1 2 6 7 15 16 19 20 24 25 26 27 32 33 34 35 38 39 44 45 46 47 ];
fileList = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex' };

for ffi = 1:2:length(fileList)

    filename = fileList{ffi}; folderIdx = fLIdx(ffi);
    nexFileData = readNexFile([hdpath filename]);

    lfp1 = nexFileData.contvars{(ctxChs(folderIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(folderIdx)),1}.data;

    figure(3);
    [ coherenceCtxA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,1); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceXA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,2); pcolor( cyclicalFreq, cyclicalFreq, coherenceXA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceStrA, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,3); pcolor( cyclicalFreq, cyclicalFreq, coherenceStrA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

    
    filename = fileList{ffi+1}; folderIdx = fLIdx(ffi+1);
    nexFileData = readNexFile([hdpath filename]);

    lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

    lfp1 = lfp1(1:5*60*1e3);
    lfp2 = lfp2(1:5*60*1e3);
    
    [ coherenceCtxB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,4); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceXB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,5); pcolor( cyclicalFreq, cyclicalFreq, coherenceXB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceStrB, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,6);  pcolor( cyclicalFreq, cyclicalFreq, coherenceStrB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

    subplot(3,3,7); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceCtxB./max(coherenceCtxB(:)))-(coherenceCtxA./max(coherenceCtxA(:))) ); shading flat; colorbar; title('normalize; middle - top');
    subplot(3,3,8); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceXB  ./max(coherenceXB(:))  )-(coherenceXA  ./max(coherenceXA(:)))   ); shading flat; colorbar; title('normalize; middle - top');
    subplot(3,3,9); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceStrB./max(coherenceStrB(:)))-(coherenceStrA./max(coherenceStrA(:))) ); shading flat; colorbar; title('normalize; middle - top');

    outputFilename = [ hdpath 'crossFreqCoherenceCompare/' 'cfcShort_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fLIdx(ffi)) ) '-vs-' num2str( strChs(fLIdx(ffi)) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );

end;










%%

fLIdx    = [ 3 4 8 9 10 11 13 14 17 18 22 23 28 29 30 31 36 37 40 41 42 43 ];
fileList = { 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' };

for ffi = 1:2:length(fileList)

    filename = fileList{ffi}; folderIdx = fLIdx(ffi);
    nexFileData = readNexFile([hdpath filename]);

    lfp1 = nexFileData.contvars{(ctxChs(folderIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(folderIdx)),1}.data;

    figure(3);
    [ coherenceCtxA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,1); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceXA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,2); pcolor( cyclicalFreq, cyclicalFreq, coherenceXA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceStrA, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,3); pcolor( cyclicalFreq, cyclicalFreq, coherenceStrA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

    
    filename = fileList{ffi+1}; folderIdx = fLIdx(ffi+1);
    nexFileData = readNexFile([hdpath filename]);

    lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

    [ coherenceCtxB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,4); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceXB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,5); pcolor( cyclicalFreq, cyclicalFreq, coherenceXB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceStrB, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,6);  pcolor( cyclicalFreq, cyclicalFreq, coherenceStrB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

    subplot(3,3,7); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceCtxB./max(coherenceCtxB(:)))-(coherenceCtxA./max(coherenceCtxA(:))) ); shading flat; colorbar; title('normalize; middle - top');
    subplot(3,3,8); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceXB  ./max(coherenceXB(:))  )-(coherenceXA  ./max(coherenceXA(:)))   ); shading flat; colorbar; title('normalize; middle - top');
    subplot(3,3,9); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceStrB./max(coherenceStrB(:)))-(coherenceStrA./max(coherenceStrA(:))) ); shading flat; colorbar; title('normalize; middle - top');

    outputFilename = [ hdpath 'crossFreqCoherenceCompare/' 'cfc_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(folderIdx) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );

end;











channelMask = [ 0 0 1 0 0 0 1 0; 0 0 1 0 0 0 1 0; 1 1 1 0 1 1 1 1; 1 1 1 0 1 1 1 1; 1 1 1 0 1 1 1 1; 1 0 1 0 1 1 0 1; 1 0 1 0 1 1 0 1; 1 1 1 0 1 1 1 1; 1 1 1 0 1 1 1 1; 1 1 1 0 1 1 1 1; 1 1 1 0 1 1 1 1; 1 1 1 0 1 1 1 1; 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1; 1 0 1 0 0 0 1 0; 1 0 1 0 0 0 1 0; 0 1 1 1 1 1 0 1; 0 1 1 1 1 1 0 1; 1 1 0 0 0 0 0 1; 1 0 1 1 0 1 1 1; 1 0 1 1 0 1 1 1; 0 1 1 0 0 1 1 1; 0 1 1 0 0 1 1 1; 1 1 1 1 0 1 1 1; 1 1 1 1 0 1 1 1; 1 1 1 0 1 1 1 1; 0 1 0 0 1 0 1 1; 0 1 0 0 1 0 1 1; 0 1 0 0 1 0 1 1; 0 1 0 0 1 0 1 1; 0 1 0 0 1 0 1 1; 0 1 1 0 0 1 1 1; 0 1 1 0 0 1 1 1; 1 1 1 0 1 0 1 1; 1 1 1 0 1 0 1 1; 0 1 1 0 0 1 1 0; 0 1 1 0 0 1 1 0; 0 1 0 1 1 0 1 0; 0 1 0 1 1 0 1 0; 0 1 0 1 0 0 1 0; 0 1 0 1 0 0 1 0; 1 1 0 1 1 0 1 0; 1 1 0 1 1 0 1 0; 1 1 0 1 1 0 1 0; 1 1 0 1 1 0 1 0 ];
channelMaskFileList = { 'BC543_2013-10-25_DOI+WW.nex' 'BC543_2013-10-25_WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC563_2013-11-26_WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-18_DOI.nex' 'BC565_2013-10-22_DMSO.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC566_2013-10-24_WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC567_2013-11-01_WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC577_2013-11-27_WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC586_2013-11-26_WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC597_2013-12-05_WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-12-05_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' };

filename='BC577_2013-10-15_DOI.nex';
find(strcmp(filename,channelMaskFileList))  % FInd channeL infO


    nexFileData = readNexFile([hdpath filename]);

    
    
    avgCtx = mean( [ nexFileData.contvars{1,1}.data nexFileData.contvars{3,1}.data nexFileData.contvars{4,1}.data ],2);
 avgCtx = mean( [ nexFileData.contvars{6,1}.data nexFileData.contvars{7,1}.data nexFileData.contvars{4,1}.data ],2);
    filters.so.lia      = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    0.1, 'HalfPowerFrequency2',   2, 'SampleRate', 1e3);
    avgCtxSmooth = filtfilt( filters.so.lia, avgCtx );
    figure;
    plot( (1:length(avgCtx))./1e3, avgCtx); hold on;
    plot( (1:length(avgCtx))./1e3, avgCtxSmooth);
    
    
    
    figure;
    plot( (1:length(avgCtx))./1e3, nexFileData.contvars{1,1}.data);  hold on;
    plot( (1:length(avgCtx))./1e3, avgCtxSmooth);
    plot( (1:length(avgCtx))./1e3, nexFileData.contvars{1,1}.data-avgCtxSmooth)
    
    
    
    figure;
    plot( (1:length(avgCtx))./1e3, nexFileData.contvars{1,1}.data-avgCtxSmooth); hold on;
    plot( (1:length(avgCtx))./1e3, nexFileData.contvars{3,1}.data-avgCtxSmooth)
    plot( (1:length(avgCtx))./1e3, nexFileData.contvars{4,1}.data-avgCtxSmooth)

    
    
    
    
    
    
    
    
    
    
    
    
    
    
%%
    
fLIdx    = [ 1 2 6 7 15 16 19 20 24 25 26 27 32 33 34 35 38 39 44 45 46 47 ];
fileList = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex' };

for ffi = 1:2:length(fileList)

    filename = fileList{ffi}; folderIdx = fLIdx(ffi);
    nexFileData = readNexFile([hdpath filename]);

    lfp1 = nexFileData.contvars{(ctxChs(folderIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(folderIdx)),1}.data;

    figure(3);
    [ coherenceCtxA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,1); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceXA, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,2); pcolor( cyclicalFreq, cyclicalFreq, coherenceXA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceStrA, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,3); pcolor( cyclicalFreq, cyclicalFreq, coherenceStrA ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

    
    filename = fileList{ffi+1}; folderIdx = fLIdx(ffi+1);
    nexFileData = readNexFile([hdpath filename]);

    lfp1 = nexFileData.contvars{(ctxChs(fileIdx)),1}.data;
    lfp2 = nexFileData.contvars{(strChs(fileIdx)),1}.data;

    lfp1 = lfp1(1:5*60*1e3);
    lfp2 = lfp2(1:5*60*1e3);
    
    [ coherenceCtxB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp1, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,4); pcolor( cyclicalFreq, cyclicalFreq, coherenceCtxB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceXB, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,5); pcolor( cyclicalFreq, cyclicalFreq, coherenceXB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'ctx-str ' strrep(filename(1:end-4),'_','  ')]);
    [ coherenceStrB, cyclicalFreq ] = crossFreqCoherence( lfp2, lfp2, sampleFreq, windowSize/1e3, round(windowSize/2)/1e3, .5, 1, 60 );
    subplot(3,3,6);  pcolor( cyclicalFreq, cyclicalFreq, coherenceStrB ); shading flat; colormap(build_NOAA_colorgradient); colorbar; title([ 'str ' strrep(filename(1:end-4),'_','  ')]);

    subplot(3,3,7); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceCtxB./max(coherenceCtxB(:)))-(coherenceCtxA./max(coherenceCtxA(:))) ); shading flat; colorbar; title('normalize; middle - top');
    subplot(3,3,8); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceXB  ./max(coherenceXB(:))  )-(coherenceXA  ./max(coherenceXA(:)))   ); shading flat; colorbar; title('normalize; middle - top');
    subplot(3,3,9); pcolor( cyclicalFreq, cyclicalFreq,  (coherenceStrB./max(coherenceStrB(:)))-(coherenceStrA./max(coherenceStrA(:))) ); shading flat; colorbar; title('normalize; middle - top');

    outputFilename = [ hdpath 'crossFreqCoherenceCompare/' 'cfcShort_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fLIdx(ffi)) ) '-vs-' num2str( strChs(fLIdx(ffi)) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );

end;


% delta (1?4 Hz) 
filters.so.delta    = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    1, 'HalfPowerFrequency2',    4, 'SampleRate', 1e3); % verified order 2 or 4; 6 blows up the signal
%                                                                                theta (4?7 Hz)
filters.so.theta    = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   7, 'SampleRate', 1e3); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
%                                                                              real theta (7?10 Hz)
filters.so.realTheta    = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    7, 'HalfPowerFrequency2',   10, 'SampleRate', 1e3); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
%                                                                                alpha (7?13 Hz)
filters.so.alpha    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    7, 'HalfPowerFrequency2',   14, 'SampleRate', 1e3);
%                                                                                   beta (13?30 Hz)
filters.so.beta     = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   13, 'HalfPowerFrequency2',   31, 'SampleRate', 1e3);
%                                                                                   low gamma (30?50 Hz) oscillations
filters.so.lowGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   30, 'HalfPowerFrequency2',   50, 'SampleRate', 1e3); % verified 8 is good


ffi=4
filename = fileList{ffi}; folderIdx = fLIdx(ffi);
nexFileData = readNexFile([hdpath filename]);
lfp1 = nexFileData.contvars{(ctxChs(folderIdx)),1}.data;
lfp2 = nexFileData.contvars{(strChs(folderIdx)),1}.data;

deltaLfp = filtfilt( filters.so.delta, lfp1 );
thetaLfp = filtfilt( filters.so.theta, lfp1 );
realThetaLfp = filtfilt( filters.so.realTheta, lfp1 );
alphaLfp = filtfilt( filters.so.alpha, lfp1 );
betaLfp = filtfilt( filters.so.beta, lfp1 );
loGammaLfp = filtfilt( filters.so.lowGamma, lfp1 );



% realThetaLfpEnv = abs(hilbert( realThetaLfp );


deltaLfpEnv = abs(hilbert( deltaLfp ));
thetaLfpEnv = abs(hilbert( thetaLfp ));
alphaLfpEnv = abs(hilbert( alphaLfp ));
betaLfpEnv = abs(hilbert( betaLfp ));
loGammaLfpEnv = abs(hilbert( loGammaLfp ));


figure;plot(thetaLfp);hold on; plot(thetaLfpEnv)


figure; 
subplot(3,4,1);  plot( deltaLfpEnv./max(deltaLfpEnv), thetaLfpEnv./max(thetaLfpEnv),   'k' );
subplot(3,4,2);  plot( deltaLfpEnv./max(deltaLfpEnv), alphaLfpEnv./max(alphaLfpEnv),   'k' );
subplot(3,4,3);  plot( deltaLfpEnv./max(deltaLfpEnv), betaLfpEnv./max(betaLfpEnv),    'k' );
subplot(3,4,4);  plot( deltaLfpEnv./max(deltaLfpEnv), loGammaLfpEnv./max(loGammaLfpEnv), 'k' );
subplot(3,4,5);  plot( thetaLfpEnv./max(thetaLfpEnv), alphaLfpEnv./max(alphaLfpEnv),   'k' );
subplot(3,4,6);  plot( thetaLfpEnv./max(thetaLfpEnv), betaLfpEnv./max(betaLfpEnv),    'k' );
subplot(3,4,7);  plot( thetaLfpEnv./max(thetaLfpEnv), loGammaLfpEnv./max(loGammaLfpEnv), 'k' );
subplot(3,4,8);  plot( alphaLfpEnv./max(alphaLfpEnv), betaLfpEnv./max(betaLfpEnv),    'k' );
subplot(3,4,9);  plot( alphaLfpEnv./max(alphaLfpEnv), loGammaLfpEnv./max(loGammaLfpEnv), 'k' );
subplot(3,4,10); plot( betaLfpEnv./max(betaLfpEnv),  loGammaLfpEnv./max(loGammaLfpEnv), 'k' );




figure; 
subplot(3,4,1);  plot( deltaLfpEnv./max(deltaLfpEnv), thetaLfpEnv./max(thetaLfpEnv),   'k' );
subplot(3,4,2);  plot( deltaLfpEnv./max(deltaLfpEnv), alphaLfpEnv./max(alphaLfpEnv),   'k' );
subplot(3,4,3);  plot( deltaLfpEnv./max(deltaLfpEnv), betaLfpEnv./max(betaLfpEnv),    'k' );
subplot(3,4,4);  plot( deltaLfpEnv./max(deltaLfpEnv), loGammaLfpEnv./max(loGammaLfpEnv), 'k' );
subplot(3,4,5);  plot( thetaLfpEnv./max(thetaLfpEnv), alphaLfpEnv./max(alphaLfpEnv),   'k' );
subplot(3,4,6);  plot( thetaLfpEnv./max(thetaLfpEnv), betaLfpEnv./max(betaLfpEnv),    'k' );
subplot(3,4,7);  plot( thetaLfpEnv./max(thetaLfpEnv), loGammaLfpEnv./max(loGammaLfpEnv), 'k' );
subplot(3,4,8);  plot( alphaLfpEnv./max(alphaLfpEnv), betaLfpEnv./max(betaLfpEnv),    'k' );
subplot(3,4,9);  plot( alphaLfpEnv./max(alphaLfpEnv), loGammaLfpEnv./max(loGammaLfpEnv), 'k' );
subplot(3,4,10); plot( betaLfpEnv./max(betaLfpEnv),  loGammaLfpEnv./max(loGammaLfpEnv), 'k' );






maxLag = 2000; % in milliseconds
figure; 
subplot(3,4,1);  [ corrVal, lags ] = xcorr( deltaLfpEnv, thetaLfpEnv,   maxLag );
plot(lags./1e3,corrVal); title('\delta vs \theta')
subplot(3,4,2);  [ corrVal, lags ] = xcorr( deltaLfpEnv, alphaLfpEnv,   maxLag );
plot(lags./1e3,corrVal); title('\delta vs \theta')
subplot(3,4,3);  [ corrVal, lags ] = xcorr( deltaLfpEnv, betaLfpEnv,    maxLag );
plot(lags./1e3,corrVal); title('\delta vs \theta')
subplot(3,4,4);  [ corrVal, lags ] = xcorr( deltaLfpEnv, loGammaLfpEnv, maxLag );
plot(lags./1e3,corrVal); title('\delta vs \theta')
subplot(3,4,5);  [ corrVal, lags ] = xcorr( thetaLfpEnv, alphaLfpEnv,   maxLag );
plot(lags./1e3,corrVal); title('\theta vs \alpha')
subplot(3,4,6);  [ corrVal, lags ] = xcorr( thetaLfpEnv, betaLfpEnv,    maxLag );
plot(lags./1e3,corrVal); title('\theta vs \beta')
subplot(3,4,7);  [ corrVal, lags ] = xcorr( thetaLfpEnv, loGammaLfpEnv, maxLag );
plot(lags./1e3,corrVal); title('\theta vs \gamma')
subplot(3,4,8);  [ corrVal, lags ] = xcorr( alphaLfpEnv, betaLfpEnv,    maxLag );
plot(lags./1e3,corrVal); title('\alpha vs \beta')
subplot(3,4,9);  [ corrVal, lags ] = xcorr( alphaLfpEnv, loGammaLfpEnv, maxLag );
plot(lags./1e3,corrVal); title('\alpha vs \gamma')
subplot(3,4,10); [ corrVal, lags ] = xcorr( betaLfpEnv,  loGammaLfpEnv, maxLag );
plot(lags./1e3,corrVal); title('\beta  vs \gamma')












%% SHUFFLED CROSS CORRELATIONS LOOP

shufflesToDo = 1000;
dataLength = length(deltaLfpEnv);
minShift = 4; % seconds
avgShift = 15 * 60;
samplingFreq = 1e3; % Hz

clear all;

hdpath = '~/data/ana/doiData/';
mouseNames = { 'BC543' 'BC563' 'BC565' 'BC566' 'BC567' 'BC574' 'BC577' 'BC586' 'BC595' 'BC597' 'BC607' };
filelist = { 'BC543_2013-10-25_WW.nex' 'BC543_2013-10-25_DOI+WW.nex' 'BC563_2013-10-18_basal.nex' 'BC563_2013-10-18_DOI.nex' 'BC563_2013-10-22_DMSO.nex'  'BC563_2013-11-26_WC.nex' 'BC563_2013-11-26_DOI+WC.nex' 'BC565_2013-10-15_basal.nex' 'BC565_2013-10-18_basal.nex' 'BC565_2013-10-22_DMSO.nex' 'BC565_2013-10-15_DOI.nex' 'BC565_2013-10-18_DOI.nex' 'BC566_2013-10-16_basal.nex' 'BC566_2013-10-16_DOI.nex' 'BC566_2013-10-24_WW.nex' 'BC566_2013-10-24_DOI+WW.nex' 'BC567_2013-10-16_basal.nex' 'BC567_2013-10-16_DOI.nex' 'BC567_2013-11-01_WW.nex' 'BC567_2013-11-01_DOI+WW.nex' 'BC574_2013-10-22_DMSO.nex' 'BC577_2013-10-15_basal.nex' 'BC577_2013-10-15_DOI.nex' 'BC577_2013-10-23_WW.nex' 'BC577_2013-10-23_DOI+WW.nex' 'BC577_2013-11-27_WC.nex' 'BC577_2013-11-27_DOI+WC.nex' 'BC586_2013-10-17_basal.nex' 'BC586_2013-10-17_DOI.nex' 'BC586_2013-10-21_basal.nex' 'BC586_2013-10-21_DOI.nex' 'BC586_2013-10-23_WW.nex' 'BC586_2013-10-23_DOI+WW.nex' 'BC586_2013-11-26_WC.nex' 'BC586_2013-11-26_DOI+WC.nex' 'BC595_2013-10-17_basal.nex' 'BC595_2013-10-17_DOI.nex' 'BC597_2013-12-05_WC.nex' 'BC597_2013-12-05_DOI+WC.nex' 'BC607_2013-10-17_basal.nex' 'BC607_2013-10-17_DOI.nex' 'BC607_2013-10-22_basal.nex' 'BC607_2013-10-22_DOI.nex' 'BC607_2013-11-28_WC.nex' 'BC607_2013-11-28_DOI+WC.nex' 'BC607_2013-12-05_WC.nex' 'BC607_2013-12-05_DOI+WC.nex'   };
ctxChs = [        3                         3                             1                          1                           1                            1                             1                             1                             1                             1                             1                             1                        1                        1                        4                        4                           3                           3                          4                         4                             1                           3                           3                           3                           3                           3                           3                           2                           2                           2                           2                           2                           2                           2                           2                           2                            2                           2                           2 4 4 4 4 4 4 4 4 ];
strChs = [        7                         7                             8                          8                           8                            8                             8                             8                             8                             8                             8                             8                        7                        7                        6                        6                           7                           7                          7                         7                             8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                           8                            8                           6                           6 7 7 7 7 7 7 7 7 ];


for ffi = 1:length(fileList)
    filename = fileList{ffi}; folderIdx = fLIdx(ffi);
    nexFileData = readNexFile([hdpath filename]);
    lfp1 = nexFileData.contvars{(ctxChs(folderIdx)),1}.data;
    
   % lfp2 = nexFileData.contvars{(strChs(folderIdx)),1}.data;

    deltaLfp = filtfilt( filters.so.delta, lfp1 );
    thetaLfp = filtfilt( filters.so.theta, lfp1 );
    alphaLfp = filtfilt( filters.so.alpha, lfp1 );
    betaLfp = filtfilt( filters.so.beta, lfp1 );
    loGammaLfp = filtfilt( filters.so.lowGamma, lfp1 );
    
    % realThetaLfp = filtfilt( filters.so.realTheta, lfp1 );
    % realThetaLfpEnv = abs(hilbert( realThetaLfp );

    deltaLfpEnv = abs(hilbert( deltaLfp ));
    thetaLfpEnv = abs(hilbert( thetaLfp ));
    alphaLfpEnv = abs(hilbert( alphaLfp ));
    betaLfpEnv = abs(hilbert( betaLfp ));
    loGammaLfpEnv = abs(hilbert( loGammaLfp ));

    % % %
    % % %
    % % %
    
    [ corrVal, lags ] = xcorr( deltaLfpEnv, thetaLfpEnv,   maxLag );

    % shuffledIdxs = round(repmat(1:dataLength,shufflesToDo,1) + ...    % create matrix of indices to shift
    %                ( (minShift * samplingFreq) + ...                  % guarantee a shift of X
    %                ( (avgShift*samplingFreq) .* ...                   % 
    %                repmat(rand(1,shufflesToDo),dataLength,1)' )));  % generate a matrix of offsets to add to the indices

    listOfShifts = round( (minShift * samplingFreq) + ...                  % guarantee a shift of X
                   ( (avgShift*samplingFreq) .* ...                   % 
                   rand(shufflesToDo,1) ));

    shuffCorr = zeros( shufflesToDo, 2*maxLag + 1 );

    for rr = 1:shufflesToDo
        shuffledIdxs = mod( (1:dataLength) + listOfShifts(rr) , dataLength ) +1;
        shuffCorr(rr,:) = xcorr( betaLfpEnv, thetaLfpEnv(shuffledIdxs), maxLag );
    end

    [ corrVal, lags ] = xcorr( betaLfpEnv, thetaLfpEnv, maxLag );

    figure(99);
    subplot(2,3,1);
    fill_between_lines(lags, prctile(shuffCorr,0.5), prctile(shuffCorr,99.5),1); alpha(.2); hold on;
    fill_between_lines(lags, prctile(shuffCorr,2.5), prctile(shuffCorr,98.5),2); alpha(.2);
    fill_between_lines(lags, prctile(shuffCorr,25), prctile(shuffCorr,75),3); alpha(.2);
    plot(lags, prctile(shuffCorr,50), '--', 'Color', [ .4 .4 .4], 'LineWidth', 1);
    plot(lags,corrVal, 'Color', [ .9 .3 .3 ], 'LineWidth', 1);

    outputFilename = [ hdpath 'shuffXcorrHDlfp_' strrep(filename(1:length(filename)-4), ' ', '_' ) '_ch-' num2str( ctxChs(fLIdx(ffi)) ) '-vs-' num2str( strChs(fLIdx(ffi)) ) '.png' ];
    print( outputFilename, '-dpng', '-r200' );

end





%% DATA SCROLLING



times = (1:length(lfp1))./1e3;

figure;
plot( times, lfp1);
hold on;
plot( times, deltaLfp-0.2);
plot( times, thetaLfp-0.4);
plot( times, alphaLfp-0.55);
plot( times, betaLfp-0.7);
plot( times, loGammaLfp-0.8);
htMask = find(strcmp( htData.behaviorType, 'HT' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
qrMask = find(strcmp( htData.behaviorType, 'QR' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
if ~isempty(qrMask)
    scatter(htData.start(qrMask),0.5+zeros(1,length(qrMask)), 'o', 'filled');
    scatter(htData.start(htMask),0.5+zeros(1,length(qrMask)), '^', 'filled');
end
legend('raw','\Delta','\Theta','\alpha','\beta','\gamma')



startTime = 1;  % 905
lfpSampleRate = 1000;
plotInterval = 10;
scrollInterval = 6;
while 1
    
    [ x, y, button ] = ginput(1); 
    if ~isempty(button) & ( ( button==93) | (button==29) | (button==30) ); startTime = startTime + scrollInterval; end;
    if ~isempty(button) & ( ( button==91) | (button==28) | (button==31) ); startTime = startTime - scrollInterval; end;
    if ( (button==113) | (button==27) ); break; end;
    
    
    if ( ( startTime + plotInterval ) <  times(end) )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
    elseif ( startTime >= 0 )
        lfpII=floor(startTime*lfpSampleRate)+1:floor((startTime+plotInterval)*lfpSampleRate)+1;
    else
        beep();
    end
    
    % plot filtered LFPs
    hold off;
    plot( times(lfpII), lfp1(lfpII));
    hold on;
    plot( times(lfpII), deltaLfp(lfpII)  -0.2);
    plot( times(lfpII), thetaLfp(lfpII)  -0.4);
    plot( times(lfpII), alphaLfp(lfpII)  -0.55);
    plot( times(lfpII), betaLfp(lfpII)   -0.7);
    plot( times(lfpII), loGammaLfp(lfpII)-0.8);


    htMask = find(strcmp( htData.behaviorType, 'HT' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );
    qrMask = find(strcmp( htData.behaviorType, 'QR' ) & strcmp( htData.mouse, filename(1:5) ) & strcmp( htData.folder, filename(7:16) ) & strcmp( htData.condition, filename(18:end-4) ) );

    allQrTimes = htData.start(qrMask);
    allHtTimes = htData.start(htMask);

    thisHtMask = ( allHtTimes < times(lfpII(end)) ) & ( allHtTimes > times(lfpII(1)) );
    thisQrMask = ( allQrTimes < times(lfpII(end)) ) & ( allQrTimes > times(lfpII(1)) )

    if ~isempty(thisQrMask)
        scatter(allQrTimes(thisQrMask),0.5+zeros(1,sum(thisQrMask)), 'o', 'filled');
    end
    if ~isempty(thisHtMask)
        scatter(allHtTimes(thisHtMask),0.5+zeros(1,sum(thisHtMask)), '^', 'filled');
    end
    
    xlim([times(lfpII(1)) times(lfpII(end))])
    ylim([-1 1]);
 
end










swrLfpEnv = abs(hilbert(swrLfp));

