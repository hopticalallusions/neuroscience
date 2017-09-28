function hdDoAnalysis(hdpath, file, label)

nexFileData = readNexFile([hdpath file]);

hd.file = file;
hd.evts=nexFileData.events{1,1}.timestamps;

windowWidth       = 3;                                                  % seconds
hd.eegSnips       = zeros( 1+1000*2*windowWidth, length(hd.evts) );     % collect all eeg snippets
hd.spectrograms   = zeros( length(hd.evts), 4097 );
hd.specfreqs      = 0;
hd.powers         = zeros( 97, 1+1000*2*windowWidth, length(hd.evts) ); % collect all power matrices
hd.global_wss     = zeros( length(hd.evts), 97 );
hd.global_signifs = zeros( length(hd.evts), 97 );
hd.sig95s         = zeros( 97, 1+1000*2*windowWidth, length(hd.evts) );
% hd.period % hd.time % hd.coi
for ii=1:length(hd.evts)
    if ( (hd.evts-windowWidth) > 0)
        secStartIdx = round((hd.evts(ii) - windowWidth)*1000);
    else
        secStartIdx = 1;
    end
    if ( (hd.evts+windowWidth) <= length(nexFileData.contvars{1,1}.data) )
        secEndIdx = round((hd.evts(ii) + windowWidth)*1000);
    else
        secEndIdx = length(nexFileData.contvars{1,1}.data);
    end
    % lazy...
    if secEndIdx > length(nexFileData.contvars{1,1}.data)
        break;
        %secEndIdx = nexFileData.contvars{1,1}.data);
    end
    sst=nexFileData.contvars{1,1}.data(secStartIdx:secEndIdx);
    hd.eegSnips(:,ii) = sst; 
    [ hd.powers(:,:,ii), hd.global_wss(ii,:), hd.global_signifs(ii,:), hd.period, hd.time, hd.sig95s(:,:,ii), hd.coi  ] = hdWavelet( sst, 0 );
    [ hd.specfreqs, ~, ~, hd.spectrograms(ii,:) ] = hdPwrSpectrum( sst, 1000 ); 
end


hd.medianPwrs=zeros(97,6001);
for ii=1:97
    for jj=1:6001
        hd.medianPwrs(ii,jj)=median(hd.powers(ii,jj,:));
    end
end


figure;
% [left bottom width height]
subplot('position',[0.05 0.07 0.80 0.9])
Yticks = 2.^(fix(log2(min(hd.period))):fix(log2(max(hd.period))));
imagesc( hd.time,log2(hd.period), hd.medianPwrs ); 
colormap(build_NOAA_colorgradient); colorbar;
xlabel('Time (s)'); ylabel('Freq (Hz)'); title(['Wavelet Power Spectrum' file]);
set(gca,'YLim',log2([min(hd.period),max(hd.period)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',1./Yticks)
hold on; plot(hd.time,log2(hd.coi),'k') 
subplot('position',[0.87 0.07 0.1 0.9])
plot(median(hd.global_wss),log2(hd.period))
hold on
plot(median(hd.global_signifs),log2(hd.period),'--');
plot( prctile(hd.global_wss, 5),  log2(hd.period), ':k');
plot( prctile(hd.global_wss,95),  log2(hd.period), ':k');
plot( median(hd.global_wss),      log2(hd.period), 'k', 'LineWidth', 2);
plot( prctile(hd.global_wss, 25), log2(hd.period), 'color', [.2 .2 .2]);
plot( prctile(hd.global_wss, 75), log2(hd.period), 'color', [.2 .2 .2]);
hold off
xlabel('Power (...)'); ylabel('Freq (Hz)')
title('Global Wavelet Spectrum')
set(gca,'YLim',log2([min(hd.period),max(hd.period)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel','')
set(gca,'XLim',[0,1.25*max(median(hd.global_wss))])
set(gcf,'PaperPositionMode','auto')
print(['/Volumes/BlueFatVol/hdDatosRebec/dataImages/' label '_metaWavelet_' file '.png'],'-dpng','-r0')


figure;
hold on
plot( hd.specfreqs, prctile(hd.spectrograms, 5), ':k');
plot( hd.specfreqs, prctile(hd.spectrograms,95), ':k');
plot( hd.specfreqs, median(hd.spectrograms),     'k', 'LineWidth', 2);
plot( hd.specfreqs, prctile(hd.spectrograms, 25), 'color', [.2 .2 .2]);
plot( hd.specfreqs, prctile(hd.spectrograms, 75), 'color', [.2 .2 .2]);
hold off
title('Single-Sided Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([0 64]);
set(gcf,'PaperPositionMode','auto')
print(['/Volumes/BlueFatVol/hdDatosRebec/dataImages/' label '_spectrograms_' file '.png'],'-dpng','-r0')



tempEeg = median(hd.eegSnips');

[ hd.avgEegPowers, hd.avgEegGlobal_wss, hd.avgEegGlobal_signifs, hd.avgEegPeriod, hd.avgEegTime, hd.avgEegSig95s, hd.avgEegCoi  ] = hdWavelet( tempEeg, 0 );
[ hd.avgEegSpecFreqs, ~, ~, hd.avgEegSpectrograms ] = hdPwrSpectrum( tempEeg, 1000 ); 
figure;
% [left bottom width height]
subplot('position',[0.05 0.07 0.80 0.9])
Yticks = 2.^(fix(log2(min(hd.avgEegPeriod))):fix(log2(max(hd.avgEegPeriod))));
imagesc( hd.time,log2(hd.avgEegPeriod), hd.avgEegPowers ); 
colormap(build_NOAA_colorgradient); colorbar;
xlabel('Time (s)'); ylabel('Freq (Hz)'); title(['Avg Eeg Wavelet Power Spectrum' file]);
set(gca,'YLim',log2([min(hd.avgEegPeriod),max(hd.avgEegPeriod)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',1./Yticks)
hold on; plot(hd.avgEegTime,log2(hd.avgEegCoi),'k') 
subplot('position',[0.87 0.07 0.1 0.9])
plot( (hd.avgEegGlobal_wss),      log2(hd.avgEegPeriod), 'k', 'LineWidth', 2);
xlabel('Power (...)'); ylabel('Freq (Hz)')
title('Global Wavelet Spectrum')
set(gca,'YLim',log2([min(hd.avgEegPeriod),max(hd.avgEegPeriod)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel','')
set(gca,'XLim',[0,1.25*max(hd.avgEegGlobal_wss)])
set(gcf,'PaperPositionMode','auto')
print(['/Volumes/BlueFatVol/hdDatosRebec/dataImages/' label '_medianEegWavelet_' file '.png'],'-dpng','-r0')


[ hd.avgEegSpecFreqs, ~, ~, hd.avgEegSpectrograms ] = hdPwrSpectrum( tempEeg, 1000 ); 

figure;
plot( hd.avgEegSpecFreqs, hd.avgEegSpectrograms,     'k', 'LineWidth', 2);
title('Avg Eeg Single-Sided Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([0 64]);
set(gcf,'PaperPositionMode','auto')
print(['/Volumes/BlueFatVol/hdDatosRebec/dataImages/' label '_medianEegPwrSpec_' file '.png'],'-dpng','-r0')


figure;
subplot(3,1,1); plot(mean(hd.eegSnips')); xlim([0 6001]); xlabel('mean');
subplot(3,1,2); plot(hd.eegSnips, 'Color', [ 0 0 0 .05 ], 'LineWidth', 2); xlim([0 6001]); xlabel('all');
subplot(3,1,3); plot(median(hd.eegSnips')); xlim([0 6001]); xlabel('median');
set(gcf,'PaperPositionMode','auto')
print(['/Volumes/BlueFatVol/hdDatosRebec/dataImages/' label '_allEegs_' file '.png'],'-dpng','-r0')

close all;

%save([hdpath 'matlabdata_' file '.mat'],'hd')

end

