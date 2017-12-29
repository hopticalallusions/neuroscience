

%swrLfp61 = filtfilt( filters.ao.swr , lfp61 );
%swrLfp88 = filtfilt( filters.ao.swr , lfp88 );
%swrLfp64 = filtfilt( filters.ao.swr , lfp64 );



videoSampleRate=29.97;
lfpSampleRate=32000;

pxPerCm = 2.385;
lagTime = 1.5; % seconds
speed=calculateSpeed(xpos, ypos, lagTime, pxPerCm);
[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat( '/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/VT0.nvt' );
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);


lfp61=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/rawChannel_61.dat');
lfp64=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/rawChannel_64.dat');
lfp76=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/rawChannel_76.dat');
lfp88=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/rawChannel_88.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;



thisLfp  = lfp88;
liaLfp   = filtfilt( filters.lia, thisLfp );
thetaLfp = filtfilt( filters.theta, thisLfp );
loGamLfp = filtfilt( filters.lowGamma, thisLfp );
midGamLfp= filtfilt( filters.midGamma, thisLfp );
swrLfp   = filtfilt( filters.swr, thisLfp );


liaEnv   = abs( hilbert( liaLfp ) );
thetaEnv = abs( hilbert( thetaLfp ) );
loGamEnv = abs( hilbert( loGamLfp ) );
midGamEnv= abs( hilbert( midGamLfp ) );
swrEnv   = abs( hilbert( swrLfp ) );





figure(2); hold off; clf;
fig = gcf;
ax = axes('Parent', fig);
plotInterval = 10; % seconds
lfpSampleRate = 32000; % Hz
videoSampleRate = 29.97; % Hz 
startIdx = 1;
sax1=subplot(6,1,1); sax2=subplot(6,1,2); sax3=subplot(6,1,3); sax4=subplot(6,1,4); sax5=subplot(6,1,5); sax6=subplot(6,1,6); 
swrBandBumps=[];

lfpStd=std(thisLfp);      lfpYlim=   [ min(thisLfp) max(thisLfp) ];
liaStd=std(liaLfp);       liaYlim=   [ min(liaLfp) max(liaLfp) ];
thetaStd=std(thetaLfp);   thetaYlim= [ min(thetaLfp) max(thetaLfp) ];
loGamStd=std(loGamLfp);   loGamYlim= [ min(loGamLfp) max(loGamLfp) ];
midGamStd=std(midGamLfp); midGamYlim=[ min(midGamLfp) max(midGamLfp) ];
swrStd=std(swrLfp);       swrYlim=   [ min(swrLfp) max(swrLfp) ];

spdYlim=   [ min(speed) max(speed) ];


lfp88Ylim=[ min(lfp88) max(lfp88) ];

while 1
    
    [x, y, button]=ginput(1); 
    if  (button==1); swrBandBumps = [swrBandBumps x]; end;
    if  (button==93) || (button==29) || (button==30); startIdx = startIdx +  plotInterval*lfpSampleRate; end;
    if  (button==91) || (button==28) || (button==31); startIdx = startIdx -  plotInterval*lfpSampleRate; end;
    if (button==113) || (button==27); break; end;
    
    if ( startIdx > length (timestampSeconds) )
        startIdx = length (timestampSeconds)-plotInterval*lfpSampleRate-1;
    elseif ( ( startIdx + plotInterval*lfpSampleRate ) < length (timestampSeconds) )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    elseif ( startIdx > 0 )
        endIdx = startIdx + plotInterval*lfpSampleRate; ii=(startIdx:endIdx);
    else
        beep();
    end
    
    hold( sax1, 'off');  plot( sax1, timestampSeconds(ii), liaLfp(ii)    ); hold( sax1, 'on'); plot( sax1, timestampSeconds(ii), liaEnv(ii)    ); axis( sax1, 'tight'); ylabel( sax1, 'c61+LIA'); ylim(sax1,liaYlim); line(sax1,[ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ liaStd*5 liaStd*5 ],'Color','green'); line(sax1,[ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ liaStd*3 liaStd*3 ],'Color','cyan'); line(sax1,[ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ liaStd*2 liaStd*2 ],'Color','red'); %plot( sax1, timestampSeconds(ii), thisLfp(ii)   );
    hold( sax2, 'off'); plot( sax2, timestampSeconds(ii), thetaLfp(ii)  ); hold( sax2, 'on'); plot( sax2, timestampSeconds(ii), thetaEnv(ii)  ); axis( sax2, 'tight'); ylabel( sax2, 'c\Theta');   ylim( sax2, thetaYlim);  line( sax2, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ thetaStd*5 thetaStd*5 ],'Color','green');  line( sax2, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ thetaStd*3 thetaStd*3 ],'Color','cyan'); line( sax2, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ thetaStd*2 thetaStd*2 ],'Color','red');
    %hold( sax3, 'off'); plot( sax3, timestampSeconds(ii), loGamLfp(ii)  ); hold( sax3, 'on'); plot( sax3, timestampSeconds(ii), loGamEnv(ii)  ); axis( sax3, 'tight'); ylabel( sax3, 'lo\gamma'); ylim( sax3, loGamYlim);  line( sax3, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ loGamStd*5 loGamStd*5 ],'Color','green'); line( sax3, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ loGamStd*3 loGamStd ],'Color','cyan'); line( sax3, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ loGamStd*2 loGamStd*2 ],'Color','red');
    hold( sax4, 'off'); plot( sax4, timestampSeconds(ii), midGamLfp(ii) ); hold( sax4, 'on'); plot( sax4, timestampSeconds(ii), midGamEnv(ii) ); axis( sax4, 'tight'); ylabel( sax4, 'mid\gamma'); ylim( sax4, midGamYlim); line( sax4, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ midGamStd*5 midGamStd*5 ],'Color','green'); line( sax4, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ midGamStd*3 midGamStd*3 ],'Color','cyan');line( sax4, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ midGamStd*2 midGamStd*2 ],'Color','red');
    hold( sax5, 'off'); plot( sax5, timestampSeconds(ii), swrLfp(ii)    ); hold( sax5, 'on'); plot( sax5, timestampSeconds(ii), swrEnv(ii)    ); axis( sax5, 'tight'); ylabel( sax5, 'SWR');       ylim( sax5, swrYlim);    line( sax5, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ swrStd*5 swrStd*5 ],'Color','green'); line( sax5, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ swrStd*3 swrStd*3 ],'Color','cyan'); line( sax5, [ timestampSeconds(startIdx) timestampSeconds(endIdx) ],[ swrStd*2 swrStd*2 ],'Color','red');
    hold( sax6, 'off'); plot( sax6, timestampSeconds(ii), lfp88(ii)     ); hold( sax6, 'on'); axis tight; ylabel( sax6, 'c88');  ylim( lfp88Ylim )
    hold( sax3, 'off'); plot( sax3, xytimestampSeconds(1+round(videoSampleRate*ii/lfpSampleRate)), speed(1+round(videoSampleRate*ii/lfpSampleRate))); axis(sax3, 'tight'); ylabel( sax3, 'cm/s'); ylim( sax3, spdYlim); 
    
end


% 
% thetaEnv=abs(hilbert(aoFilterLfp));
% ii=1+floor((1:length(speed))*32000/29.97);
% xyHist=twoDHistogram(speed/max(speed),thetaEnv(ii)/max(thetaEnv),.025);
% figure; imagesc(flipud(log(xyHist))); colormap(build_NOAA_colorgradient);
% figure; scatter(speed,thetaEnv(ii), 2,'filled', 'k'); alpha(.1)

