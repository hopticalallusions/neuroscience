% the point of this script is to do some examination of various frequency
% bands to get at David Redish's comments about the freqneucy band problems


% rat h1
% day 2018-09-09

% csc20 theta, swr, maybe LIA
% csc84 swr
% csc 17, 32, 64 also have some SWR looking things

%  638:640      0:10:40   "swr" but lots of theta power
% 5014:5016     1:23:36   "swr" bucket, still, no theta, good LIA

disk = '/Volumes/AGHTHESIS2/rats/';
rat = 'h1';
session = '2018-09-09';
datapath = [ disk '/' rat '/' session '/' ];

thetaFilename = 'CSC20.ncs';
swrFilename = 'CSC84.ncs';


% the position data for this day is weird.
% VT0.nvt is just plain bad; looked like an open field
% extracted position from VT0.mpg looks OK
% video is 1:23:40  (5020 seconds)
% SMI files with timestamps have weird data also;
% VT0 is far too short, and VT1 is about 1/2 the expected length

[ lfpTheta, lfpTimestamps ]=csc2mat( [ datapath thetaFilename ] );
[ lfpSwr, lfpSwrTimestamps ]=csc2mat( [ datapath swrFilename ] );
lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;


load([datapath 'position.mat']);
xpos = position.xGpos;
ypos = position.yGpos;
speed = calculateSpeed( xpos, ypos, 1, 2.63);
xytimestamps = lfpTimestamps(1):round(1e6*1/29.97):round(lfpTimestamps(1)+(lfpTimestampSeconds(end)*1e6));
% here I'm going to randomly eliminate a few of these to line up things up
tempIdx = floor(rand(1,length(xytimestamps)-length(speed))*length(xytimestamps))+1;
xytimestamps(tempIdx) = [];
xytimestampSeconds = ((1:length(speed))-1)/29.97;
% figure; plot(position.xGpos,position.yGpos)



      = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.1, 'HalfPowerFrequency2',    1, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
      = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    1, 'HalfPowerFrequency2',    2, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
      = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    2, 'HalfPowerFrequency2',    4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
      = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',    8, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
      = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    8, 'HalfPowerFrequency2',   16, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    16, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    32, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    64, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   , 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article






swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   150, 'HalfPowerFrequency2',  260, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article


swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   180, 'HalfPowerFrequency2',  200, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article

swrLfp = filtfilt( swrFilter, lfpSwr );
swrLfpEnv = abs(hilbert(swrLfp));

swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

[swrPeakValues,      ...
 swrPeakTimes,       ... 
 swrPeakProminances, ...
 swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak

                          
figure; plot( lfpTimestampSeconds, swrLfp)
                          
                          
% build some structures for later SWR analysis
swrPosAll=zeros(2,length(swrPeakTimes));
swrSpeedAll=zeros(1,length(swrPeakTimes));
for ii=1:length(swrPeakTimes)
    tempIdx=find(swrPeakTimes(ii)<=xytimestampSeconds, 1 );
    if ~isempty(tempIdx)
        swrPosAll(1,ii) = xrpos (tempIdx);
        swrPosAll(2,ii) = yrpos (tempIdx);
        swrSpeedAll(ii) = speed (tempIdx);
    end
end
swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);




subplot('position',[0.03 0.75 0.82 0.2]);
hold on;
yyaxis right
td=speed(round(secStart*29.97):round(secEnd*29.97));
tt=(1:length(td))/29.97;
plot(tt,td);

figure; plot(xytimestampSeconds, speed)




imagesc( time,log2(period), power );  %*** uncomment for 'image' plot
thedims=size(power);
normpower=zeros(thedims);
for ii=1:thedims(1)
    normpower(ii,:)=power(ii,:)/max(power(ii,:));
end
figure;
subplot('position',[0.03 0.07 0.82 0.62]) %[0.1 0.37 0.65 0.28])
levels = 0:2:10; % [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
%contourf(time,log2(period),log2(power), levels); %,log2(levels));  %*** or use 'contourf' (fill)
colormap(build_NOAA_colorgradient);
imagesc( time,log2(period), normpower );  %*** uncomment for 'image' plot
xlabel('Time (s)')
ylabel('Freq (Hz)')
title('b) Wavelet Power Spectrum')
set(gca,'XLim',xlim(:))
set(gca,'YLim',log2([min(period),max(period)]), ...
	'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel',1./Yticks)
% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
hold on
contour(time,log2(period),sig95,[-99,1],'r');
hold on
% cone-of-influence, anything "below" is dubious
plot(time,log2(coi),'k')
hold off







startSec =  809; endSec   =  840;  % in motion
startSec = 4900; endSec   = 4904;  % sharp wave
startSec =   10; endSec   =  750;  % bucket start
%startSec =  780; endSec   = 4500;  % running sessions period
startSec = 4529; endSec   = 5016;  % bucket end
originalRate    = 32e3;
downsampledRate = 4e3;
nPointsWindow   = round(downsampledRate*.1);
nPointsOverlap  = round(nPointsWindow/2);
nHzResolution   = round(downsampledRate/2);
%sst=lfpTheta(round(startSec*originalRate):round(endSec*originalRate));
sst=lfpSwr(round(startSec*originalRate):round(endSec*originalRate));
sst=decimate(sst,round(originalRate/downsampledRate));
[ sgFft, sgNormFreqs, sgTinsts, sgPwrSpec ]=spectrogram(sst,nPointsWindow,nPointsOverlap,nHzResolution,downsampledRate);
autoCrossFreqCoherence=zeros(length(sgNormFreqs),length(sgNormFreqs));
for ii=1:length(sgNormFreqs)
    for jj=1:length(sgNormFreqs)
        autoCrossFreqCoherence(ii,jj)=sum( (sgPwrSpec(ii,:)-mean(sgPwrSpec(ii,:))) .* (sgPwrSpec(jj,:)-mean(sgPwrSpec(jj,:))) )/( std(sgPwrSpec(ii,:)) * std(sgPwrSpec(jj,:)) );
    end
end
figure; h=pcolor(sgNormFreqs,sgNormFreqs,autoCrossFreqCoherence); colormap(build_NOAA_colorgradient(256)); colorbar;
set(h, 'EdgeColor', 'none');
title([ 'downsampled to ' num2str(downsampledRate) ' Hz; win size ' num2str(nPointsWindow) ])

figure; h=pcolor(sgPwrSpec); colormap(build_NOAA_colorgradient(256)); colorbar; set(h, 'EdgeColor', 'none');



sgPwrSpecNorm=zeros(size(sgPwrSpec));
for ii=1:513
    sgPwrSpecNorm(ii,:) = sgPwrSpec(ii,:)/max(sgPwrSpec(ii,:));
end

figure; h=pcolor( sgTinsts, sgNormFreqs, sgPwrSpecNorm); colormap(build_NOAA_colorgradient(256)); colorbar; set(h, 'EdgeColor', 'none');


figure;
subplot(3,1,1); hold on;
plot(sgPwrSpec(150,:))
plot(sgPwrSpec(160,:))
plot(sgPwrSpec(170,:))
plot(sgPwrSpec(180,:))
legend('150','160','170','180');
axis tight;
subplot(3,1,2); hold on;
plot(sgPwrSpec(190,:))
plot(sgPwrSpec(200,:))
plot(sgPwrSpec(210,:))
plot(sgPwrSpec(220,:))
legend('190','200','210','220');
axis tight;
subplot(3,1,3); hold on;
plot(sgPwrSpec(230,:))
plot(sgPwrSpec(240,:))
plot(sgPwrSpec(250,:))
legend('230','240','250');
axis tight;



figure; plot( (spectroOut(ii,:)-mean(spectroOut(ii,:))) .* (spectroOut(jj,:)-mean(spectroOut(jj,:))) /( std(spectroOut(ii,:)) * std(spectroOut(jj,:)))



0:751694

1575087750565
1575839522218


1/(length(xpos)/2871341)

1575087731899
1577959130716

(1577959130716-1575087731899)/1e6

1*60*60+23*60+40


1575087731899-1575087750565
1575087750565-lfpTimestamps(1)
1575087731899-lfpTimestamps(1)




ranges we might want to look at :

150-250 Hz "standard" (Frank uses this in other articles)
120 Hz is pretty blank
125-170 Hz
175-250 Hz seems to line up with better with auto-power correlation across frequencies
180 - 200 Hz Redish-Frank Range
365-480 Hz this range has high autocoherence for 2018-09-09 H1 CSC