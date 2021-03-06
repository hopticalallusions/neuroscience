% 
dir='/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/2017-09-13_/';
% 
% tt1  - CA  ; 0-1 units; low amp signal lfp
% tt2  - CA  ; >10 units; great lfp; swr due to layer
% tt3  - VTA ; 0 units?; low amp signal lfp, little events
% tt4  - VTA ; 0 units?; low amp signal lfp, little events
% tt5  - Nacc; 0 units?; broken?; flat LFP
% tt6  - Nacc; flat LFP
% tt7  - CA  ; units; strong LFP; SWR?
% tt8  - CA  ; units; medium LFP
% tt9  - VTA ; 0 units?; broken?
% tt10 - CA  ; 
% tt11 - CA  ; 
% tt12 - CA  ; very good Theta LFP
% tt13 - CA  ; 2-3 units; medium LFP action
% tt14 - Nacc; 2 units; uneventful LFP 
% tt15 - Nacc; 2 units; uneventful LFP
% tt16 - VTA ; x-connected; noisy, mainly uninteresting LFP
%
% [ 'CSC2.ncs'  'CSC6.ncs'  'CSC10.ncs'  'CSC14.ncs'  'CSC18.ncs'  'CSC26.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC46.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  ]
% SWR    'CSC26.ncs'   'CSC6.ncs'
% Theta  'CSC46.ncs'


[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
pxPerCm = 2.7;   % ???? in cage... sqrt((298-75)^2+(232-425)^2) px/109 cm {half maze width}
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;

[ lfp32, lfpTimestamps ] = csc2mat([ dir 'CSC32.ncs']); % inverted SWR; below layer
timestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ lfp58 ] = csc2mat([ dir 'CSC58.ncs']); % above layer (non inverted SWR)
[ lfp75 ] = csc2mat([ dir 'CSC75.ncs']); % 
[ lfp76 ] = csc2mat([ dir 'CSC76.ncs']); % 
[ lfp87 ] = csc2mat([ dir 'CSC87.ncs']); % 

avgLfp=mean([lfp32,lfp58,lfp75,lfp76,lfp87],2);

figure; hold on; plot(timestampSeconds,lfp76); plot(timestampSeconds,avgLfp); 
electricAvgLfp = filtfilt( filters.so.electric, avgLfp ); plot(timestampSeconds,electricAvgLfp); 

figure; plot(timestampSeconds, avgChew)



% before=ee(round(32000*2529):round(32000*2530));
% after=ee(round(32000*2599):round(32000*2600));
% [h,p,ci]=ttest2(before,after)



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


% avgChew = filtfilt( filters.so.chew, moreLfp ); figure; plot(timestampSeconds, avgChew)
% env=abs(hilbert(avgChew)); hold on; plot(timestampSeconds, env);
% 
% 
% avgSpindle = filtfilt( filters.so.nrem, moreLfp ); figure; plot(timestampSeconds, avgSpindle)
% env=abs(hilbert(avgSpindle)); hold on; plot(timestampSeconds, env);



% avgLfp=median([lfp35,lfp58,lfp59,lfp43,lfp32],2);
% moreLfp=median([lfp35,lfp58,lfp59,lfp43,lfp32,lfp71, lfp75, lfp87, lfp46],2);




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
    
    hold(sax1, 'off'); plot( sax1, timestampSeconds(ii), lfp32(ii) ); axis tight; ylabel( sax1, 'c32'); hold(sax1, 'on');
    hold(sax2, 'off'); plot( sax2, timestampSeconds(ii), lfp58(ii) ); axis tight; ylabel( sax2, 'c58'); hold(sax2, 'on');
    hold(sax3, 'off'); plot( sax3, timestampSeconds(ii), lfp75(ii) ); axis tight; ylabel( sax3, 'c75'); hold(sax3, 'on');
    hold(sax4, 'off'); plot( sax4, timestampSeconds(ii), lfp87(ii) ); axis tight; ylabel( sax4, 'c87'); hold(sax4, 'on');
    hold(sax5, 'off'); plot( sax5, timestampSeconds(ii), lfp76(ii) ); axis tight; ylabel( sax5, 'c76'); hold(sax5, 'on');
    plot( sax6, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis tight; ylabel( sax6, 'cm/s')
    
end

% 27, 31, 35, 43, 59, 71, 75, 87

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



