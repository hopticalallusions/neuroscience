% hdpath='/Users/andrewhowe/data/hd_mice_indianna/WT-striatum-old/';
% hdfilename = 'BC471-May-9.nex';
% nexFileData = readNexFile([ hdpath hdfilename ]);
% 
% hdDoAnalysis(hdpath, hdfilename, '_ctx_young_test_');
% 



% WT   Ctx and STR
% 
% 'WT_BC471Nov13'     29 W
hdpath='/Volumes/BlueFatVol/hdDatosRebec/WT/WT CTX para young and old/WT CTX young/';
hdfilename='WT_BC471 Nov 13.nex';
hdDoAnalysis(hdpath, hdfilename, '_ctx_young_');
hdpath='/Volumes/BlueFatVol/hdDatosRebec/WT/WT Striatum pa Andrew/WT striatum young/';
hdfilename='WT_BC471 Nov 13.nex';
hdDoAnalysis(hdpath, hdfilename, '_str_young_');
% 'BC471July5'              62 W
% /Volumes/BlueFatVol/hdDatosRebec/WT/WT CTX para young and old/WT CTX old/BC471 July 5.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/WT/WT CTX para young and old/WT CTX old/';
hdfilename='BC471 July 5.nex';
hdDoAnalysis(hdpath, hdfilename, '_ctx_old_');
% /Volumes/BlueFatVol/hdDatosRebec/WT/WT Striatum pa Andrew/WT striatum old/BC471 July 5.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/WT/WT Striatum pa Andrew/WT striatum old/';
hdfilename='BC471 July 5.nex';
hdDoAnalysis(hdpath, hdfilename, '_str_old_');
%
%
% BE CTX and STR
% 'BE_BC516Feb25'      29W
% /Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE CTX/BE CTX young/BE_BC516 Feb25.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE CTX/BE CTX young/';
hdfilename='BE_BC516 Feb25.nex';
hdDoAnalysis(hdpath, hdfilename, '_ctx_young_');
% /Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE Striatum/BE Striatum young /BE_BC516 Feb 25.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE Striatum/BE Striatum young /';
hdfilename='BE_BC516 Feb 25.nex';
hdDoAnalysis(hdpath, hdfilename, '_str_young_');
%
% 'BC430June4'              65W
% /Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE CTX/BE CTX Old/BC430 June 4.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE CTX/BE CTX Old/';
hdfilename='BC430 June 4.nex';
hdDoAnalysis(hdpath, hdfilename, '_ctx_old_');
% /Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE Striatum/BE Striatum Old/BC430 June 4.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BE/BE para Andrew/BE Striatum/BE Striatum Old/';
hdfilename='BC430 June 4.nex';
hdDoAnalysis(hdpath, hdfilename, '_str_old');

% 
%
% BACHD
% 'HD_BC521Jan22'      22W  
% /Volumes/BlueFatVol/hdDatosRebec/BACHD/HD CTX para Andrew/HD CTX Young/HD_BC521 Jan 22.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BACHD/HD CTX para Andrew/HD CTX Young/';
hdfilename='HD_BC521 Jan 22.nex';
hdDoAnalysis(hdpath, hdfilename, '_ctx_young_');
% /Volumes/BlueFatVol/hdDatosRebec/BACHD/HD striatum /HD striatum young/HD_BC521 Jan 22.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BACHD/HD striatum /HD striatum young/';
hdfilename='HD_BC521 Jan 22.nex';
hdDoAnalysis(hdpath, hdfilename, '_str_young_');
%
% 'BC476July24'            64    
% /Volumes/BlueFatVol/hdDatosRebec/BACHD/HD CTX para Andrew/HD CTX Old/BC485 July 24.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BACHD/HD CTX para Andrew/HD CTX Old/';
hdfilename='BC476 July 24.nex';
hdDoAnalysis(hdpath, hdfilename, '_ctx_old_');
% /Volumes/BlueFatVol/hdDatosRebec/BACHD/HD striatum /HD striatum old/BC476 July 24.nex
hdpath='/Volumes/BlueFatVol/hdDatosRebec/BACHD/HD striatum /HD striatum old/';
hdfilename='BC476 July 24.nex';
hdDoAnalysis(hdpath, hdfilename, '_str_old_');
%
% Andrew, estos son los ratones para hacer la figura. CTX y STR para cada uno. 



return;



hddir='/Users/andrewhowe/data/hd_mice_indianna/WT-striatum-old/';
hdfilename = 'BC471-May-9.nex';
%hdfilename = 'BC471-May-21.nex';
%hdfilename = 'BC471-July-5.nex';
nexFileData = readNexFile([ hddir hdfilename ]);
figure;
hdts=(1:length(nexFileData.contvars{1,1}.data))/(60*1000);
subplot(4,1,1); plot(hdts,nexFileData.contvars{1,1}.data)
subplot(4,1,2); plot(hdts,nexFileData.contvars{2,1}.data)
subplot(4,1,3); plot(hdts,nexFileData.contvars{3,1}.data)
subplot(4,1,4); plot(hdts,nexFileData.contvars{4,1}.data)




hdts=(1:length(nexFileData.contvars{1,1}.data))/(60*1000);
figure; plot(hdts,nexFileData.contvars{1,1}.data); hold on; 
evts=nexFileData.events{1,1}.timestamps;
scatter( evts/60, ones(1,length(evts))*0.8*max(nexFileData.contvars{1,1}.data), 'o', 'filled');
%1 s around
evts=nexFileData.intervals{3,1}.intStarts;
scatter( evts/60, ones(1,length(evts))*0.9*max(nexFileData.contvars{1,1}.data), 'o', 'filled');
evts=nexFileData.intervals{3,1}.intEnds;
scatter( evts/60, ones(1,length(evts))*0.7*max(nexFileData.contvars{1,1}.data), 'o', 'filled');
figure; spectrogram(nexFileData.contvars{1,1}.data)


windowWidth = 3; % seconds
hd.powers=zeros( 97, 1+1000*2*windowWidth, length(evts) );
hd.global_wss=zeros( length(evts), 97 );
hd.global_signifs=zeros( length(evts), 97 );
hd.sig95s=zeros( 97, 1+1000*2*windowWidth, length(evts) );
% hd.period % hd.time % hd.coi
for ii=1:length(evts)
    if ( (evts-windowWidth) > 0)
        secStartIdx = round((evts(ii) - windowWidth)*1000);
    else
        secStartIdx = 1;
    end
    if ( (evts+windowWidth) <= length(nexFileData.contvars{1,1}.data) )
        secEndIdx = round((evts(ii) + windowWidth)*1000);
    else
        secEndIdx = length(nexFileData.contvars{1,1}.data);
    end
    sst=nexFileData.contvars{1,1}.data(secStartIdx:secEndIdx);
    [ hd.powers(:,:,ii), hd.global_wss(ii,:), hd.global_signifs(ii,:), hd.period, hd.time, hd.sig95s(:,:,ii), hd.coi  ] = hdWavelet( sst, 0 );
end

avgPwrs=zeros(97,6001);
for ii=1:97
    for jj=1:6001
        avgPwrs(ii,jj)=median(hd.powers(ii,jj,:));
    end
end

figure;
Yticks = 2.^(fix(log2(min(hd.period))):fix(log2(max(hd.period))));
imagesc( hd.time,log2(hd.period), avgPwrs ); 
colormap(build_NOAA_colorgradient); colorbar;
xlabel('Time (s)'); ylabel('Freq (Hz)'); title('Wavelet Power Spectrum');
set(gca,'YLim',log2([min(hd.period),max(hd.period)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',1./Yticks)
hold on; plot(hd.time,log2(hd.coi),'k')

figure;
Yticks = 2.^(fix(log2(min(hd.period))):fix(log2(max(hd.period))));
imagesc( hd.time,log2(hd.period), hd.powers(:,:,50) ); 
colormap(build_NOAA_colorgradient); colorbar;
xlabel('Time (s)'); ylabel('Freq (Hz)'); title('Wavelet Power Spectrum');
%set(gca,'XLim',xlim(:))
set(gca,'YLim',log2([min(hd.period),max(hd.period)]), ...
	'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel',1./Yticks)

figure;
plot(median(hd.global_wss),log2(hd.period))
hold on
plot(median(hd.global_signifs),log2(hd.period),'--')
hold off
xlabel('Power (...)'); ylabel('Freq (Hz)')
title('c) Global Wavelet Spectrum')
set(gca,'YLim',log2([min(hd.period),max(hd.period)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel','')
set(gca,'XLim',[0,1.25*max(median(hd.global_wss))])


% load('/Volumes/BlueFatVol/hdDatosRebec/WT/WT CTX para young and old/WT CTX old/matlabdata_BC471 July 5.nex.mat');
% file=' old CTX BC471 July 5';
% figure;
% % [left bottom width height]
% subplot('position',[0.05 0.07 0.80 0.9])
% Yticks = 2.^(fix(log2(min(hd.period))):fix(log2(max(hd.period))));
% imagesc( hd.time,log2(hd.period), hd.medianPwrs ); 
% colormap(build_NOAA_colorgradient); colorbar;
% xlabel('Time (s)'); ylabel('Freq (Hz)'); title(['Wavelet Power Spectrum' file]);
% set(gca,'YLim',log2([min(hd.period),max(hd.period)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',1./Yticks)
% hold on; plot(hd.time,log2(hd.coi),'k') 
% subplot('position',[0.87 0.07 0.1 0.9])
% plot(median(hd.global_wss),log2(hd.period))
% hold on
% plot(median(hd.global_signifs),log2(hd.period),'--')
% hold off
% xlabel('Power (...)'); ylabel('Freq (Hz)')
% title('Global Wavelet Spectrum')
% set(gca,'YLim',log2([min(hd.period),max(hd.period)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel','')
% set(gca,'XLim',[0,1.25*max(median(hd.global_wss))])
% 
% figure;
% boundedline
% size()
% (prctile(hd.global_wss,25))
% (prctile(hd.global_wss,75))
% 
% 
% figure; hold on;
% plot(log2(hd.period), prctile(hd.global_wss, 5), ':k');
% plot(log2(hd.period), prctile(hd.global_wss,95), ':k');
% plot(log2(hd.period), median(hd.global_wss),'k', 'LineWidth', 2);
% plot(log2(hd.period), prctile(hd.global_wss, 25), 'color', [.2 .2 .2]);
% plot(log2(hd.period), prctile(hd.global_wss,75), 'color', [.2 .2 .2]);
% ylabel('Power (...)'); xlabel('Freq (Hz)'); title('Global Wavelet Spectrum')
% Yticks = 2.^(fix(log2(min(hd.period))):fix(log2(max(hd.period))));
% set(gca,'XLim',log2([min(hd.period),max(hd.period)]), 'XDir','reverse', 'XTick',log2(Yticks(:)), 'XTickLabel',1./Yticks)
% set(gca,'YLim',[0,1.25*max(median(hd.global_wss))]);
% 
% 
