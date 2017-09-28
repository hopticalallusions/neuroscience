clear all; close all;
% dir='/Volumes/SILVRSURFER/da5/day1_plusmaze_habituation_2016-08-22/'; hasStartBrick=0; hasEndBrick=0; hasTrials=0; isProbe=0; hasBox=0;
% day 2 is screwed up. re-copy data? check video? use unsplit data?
% dir='/Volumes/SILVRSURFER/da5/day2_plusmaze_habituation_2016-08-23/bucket/'; hasStartBrick=0; hasEndBrick=0; hasTrials=0; isProbe=0; hasBox=0;
 dir='/Volumes/SILVRSURFER/da5/day3_plusmaze-rewarded_training1_8x_2016-08-24/'; hasStartBrick=1; hasEndBrick=0; hasTrials=1; isProbe=0; hasBox=1;
% dir='/Volumes/SILVRSURFER/da5/day4_plusmaze-rewarded_training2_8x_2016-08-25/'; hasStartBrick=1; hasEndBrick=0; hasTrials=1; isProbe=0; hasBox=1;
%probe days cause some issues because there's only one point for estimati
% dir='/Volumes/SILVRSURFER/da5/day5_plusmaze-unrewarded_probe_1x_2016-08-26/'; hasStartBrick=1; hasEndBrick=0; hasTrials=0; isProbe=1; hasBox=1;
% dir='/Volumes/SILVRSURFER/da5/day6_plusmaze-rewarded_training3_8x_2016-08-27/'; hasStartBrick=1; hasEndBrick=0; hasTrials=1; isProbe=0; hasBox=1;
% dir='/Volumes/SILVRSURFER/da5/day7_plusemaze_rewarded_training4_8x_2016-08-28/'; hasStartBrick=1; hasEndBrick=1; hasTrials=1; isProbe=0; hasBox=0;
% [lfpData,lfpTs]=csc2mat([ dir 'CSC4.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC24.ncs']);
[lfpData,lfpTs,header]=csc2mat([ dir 'CSC28.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC36.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC41.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CS428.ncs']);

[events, eventTs]=nev2mat([ dir 'Events.nev' ] );
[xRaw,yRaw,xyTs]=nvt2mat([ dir 'VT0.nvt' ]);
xpos=nlxPositionFixer(xRaw);
ypos=nlxPositionFixer(yRaw);
%figure; plot(xpos,ypos,'k'); title('all positions (raw)');

%convert times to seconds and shift start time to zero
initialLfpTs=lfpTs(1);
initialEventTs=eventTs(1);
initialXyTs=xyTs(1);
lfpTs = (lfpTs-lfpTs(1))/1e6;
eventTs = (eventTs-eventTs(1))/1e6;
xyTs = (xyTs-xyTs(1))/1e6;

%% things that haven't been thoroughly explored

% alternate idea for segmenting space :
% plot an x(t) vs x(t-30) graph and find islands of occupancy;
% works because not all x coordinates can be occupied, and those which can
% show up as blobs along the y=x diagonal

% run sinusoids at angles and look at phase relationships. Once phase is
% constant along an axis, rotate to that axis because a straight line
% passing through a sine wave ought to hit the same phase if it is well
% aligned to the center

% variance minimization or something. This doesn't work as well as hoped.

% find paths by screening for velocity and watching the vector of motion
% align vectors and measure angle

% how to find the intersection point?

%%
% find arm ends
lowYIdxs=find(ypos<120 .* (xpos<350));
if (~isempty(lowYIdxs) ) % in case the rat doesn't run the arm
    FarEastX=round(median(xpos(lowYIdxs))); % why median? (1) less sensitive to outliers (2) matchable without rounding
    FarEastY=round(median(ypos(find((FarEastX.*(ypos<120).*(xpos<350))==xpos)))); % these shenanigans are to prevent it from choosing a high Y with binary masking
end
lowYIdxs=find( (ypos<160) .* (ypos>120) .* (xpos<350) );
if (~isempty(lowYIdxs) ) % in case the rat doesn't run the arm
    MidEastX=round(median(xpos(lowYIdxs))) % why median? (1) less sensitive to outliers (2) matchable without rounding
    MidEastY=round(median(ypos(find(MidEastX==(xpos.*(ypos<170).*(ypos>120).*(xpos<350))))))
end
lowYIdxs=find( (ypos<200) .* (ypos>160) .* (xpos<350) );
if (~isempty(lowYIdxs) ) % in case the rat doesn't run the arm
    NearEastX=round(median(xpos(lowYIdxs))); % why median? (1) less sensitive to outliers (2) matchable without rounding
    NearEastY=round(median(ypos(find(NearEastX==(xpos.*(ypos<200).*(ypos>160).*(xpos<350))))));
end
lowYIdxs=find( (ypos<240) .* (ypos>200) .* (xpos<350) );
if (~isempty(lowYIdxs) ) % in case the rat doesn't run the arm
    NearEastX=round(median(xpos(lowYIdxs))); % why median? (1) less sensitive to outliers (2) matchable without rounding
    NearEastY=round(median(ypos(find(NearEastX==(xpos.*(ypos<240).*(ypos>160).*(xpos<350))))));
end
lowYIdxs=find( (ypos<220) .* (ypos>160) .* (xpos<350) );
if (~isempty(lowYIdxs) ) % in case the rat doesn't run the arm
    CenterEastX=round(median(xpos(lowYIdxs))); % why median? (1) less sensitive to outliers (2) matchable without rounding
    CenterEastY=round(median(ypos(find(CenterEastX==(xpos.*(ypos<220).*(ypos>160).*(xpos<350))))));
end
figure; plot(xpos,ypos,'k'); hold on;
plot([ FarEastX MidEastX NearEastX CenterEastX ]', [ FarEastY MidEastY NearEastY CenterEastY ]', '*r')
title('points used for rotation operation')

angles=zeros(1,6);
angles(1)=atan((CenterEastY-FarEastY)/(CenterEastX-FarEastX));
angles(2)=atan((CenterEastY-MidEastY)/(CenterEastX-MidEastX));
angles(3)=atan((CenterEastY-NearEastY)/(CenterEastX-NearEastX));
angles(4)=atan((NearEastY-FarEastY)/(NearEastX-FarEastX));
angles(5)=atan((NearEastY-MidEastY)/(NearEastX-MidEastX));
angles(6)=atan((MidEastY-FarEastY)/(MidEastX-FarEastX));


centerXIdxs=find( (xpos<380).* (xpos>300) );
if (~isempty(lowYIdxs) ) % in case the rat doesn't run the arm
    centerY=round(median(ypos(centerXIdxs))) % why median? (1) less sensitive to outliers (2) matchable without rounding
    centerX=round(median(xpos(find(centerY==(ypos.*(xpos<400).* (xpos>320))))))
end
% this center-finding bit needs some more work.


centerX=313;
centerY=242;
theta= -median(angles)-pi;
xrpos= xpos.*cos(theta) - ypos.*sin(theta); xrpos=round(xrpos-min(xrpos)+1); % shift, and make integer
yrpos= ypos.*cos(theta) + xpos.*sin(theta); yrpos=round(yrpos-min(yrpos)+1); % shift, and make integer
figure; plot(xrpos,yrpos,'k'); title('rotated and shifted positions');
%hold on; plot(round(xrpos),round(yrpos), 'g');

% try to find the x position of the start arm
lowYIdxs=find( (yrpos<250) .* (yrpos>200) );
if (~isempty(lowYIdxs) )
    StartX=round(median(xrpos(lowYIdxs))); % why median? (1) less sensitive to outliers (2) matchable without rounding
    StartY=round(median(ypos(find(StartX==(xrpos.*(yrpos<250).*(yrpos>200))))));
end
hold on; plot(StartX, StartY, '*r')

StartBoxIdxs=find( (yrpos<100) .* (xrpos<StartX+35) .* (xrpos>StartX-35) );
plot(xrpos(StartBoxIdxs),yrpos(StartBoxIdxs),'g.')

%figure;
%subplot(2,1,1);  plot(diff(xrpos.*(yrpos<100) .* (xrpos<StartX+35) .* (xrpos>StartX-35)));
%subplot(2,1,2);  plot(diff(yrpos.*(yrpos<100) .* (xrpos<StartX+35) .* (xrpos>StartX-35)));
%findpeaks(diff(xrpos.*(yrpos<100) .* (xrpos<StartX+35) .* (xrpos>StartX-35)),30,'MinPeakHeight',200,'MinPeakDistance',3.5*60)

if hasStartBrick > 0

    startBrickX=xrpos.*(yrpos<100) .* (xrpos<StartX+35) .* (xrpos>StartX-35);
    lockoutSamples=3.5*60*30; % 3 minute rest + >=.5 minutes runtime * 60 seconds/minute * 30 fps
    trialCounter=1;
    lockoutCounter=0;
    for ii=1:30*8*4*60 % 30 fps * 8 trials * ~4 minutes per trial * 60 seconds/minute; this is to avoid box time
        if ( ( startBrickX(ii)>10) && (lockoutCounter < 1 ) )
            trialStartSampleIdx(trialCounter)=ii;
            trialCounter=trialCounter + 1;
            lockoutCounter=lockoutSamples;
        end
        lockoutCounter=lockoutCounter-1;
    end

    disp(['avg. time between starts : ' num2str(mean(diff(xyTs(trialStartSampleIdx))/60)) ' min' ])
end

if hasTrials>0

    startRunY=yrpos.*(yrpos>150) .* (xrpos<StartX+35) .* (xrpos>StartX-35);
    endRunY=yrpos.*(yrpos<250) .* (xrpos>StartX+35);
    lockoutSamples=3.5*60*30; % 3 minute rest + >=.5 minutes runtime * 60 seconds/minute * 30 fps
    trialCounter=1;
    lockoutCounter=0;
    inTrial=0;
    for ii=1:min([ 30*8*5*60, length(startRunY) ]) % 30 fps * 8 trials * ~4 minutes per trial * 60 seconds/minute; this is to avoid box time
        if ( ( startRunY(ii)>10) && (lockoutCounter < 1 ) )
            runStartSampleIdx(trialCounter)=ii-30; % trigger high, and work back the start
            trialCounter=trialCounter + 1;
            lockoutCounter=lockoutSamples;
            inTrial=1;
        end
        if ( ( endRunY(ii)>10) && (lockoutCounter > 1 ) && (inTrial>0) )
            runEndSampleIdx(trialCounter-1)=ii-60; % trigger conservatively and approximate the end
            inTrial=0; % can't start this unless a trial is triggered
        end
        lockoutCounter=lockoutCounter-1;
    end

    figure;
    subplot(2,1,1); plot(xyTs,xrpos,'k'); hold on; 
    plot(xyTs(trialStartSampleIdx), xrpos(trialStartSampleIdx),'bo');
    plot(xyTs(runStartSampleIdx), xrpos(runStartSampleIdx),'go');
    plot(xyTs(runEndSampleIdx), xrpos(runEndSampleIdx),'ro');
    subplot(2,1,2); plot(xyTs,yrpos,'k'); hold on; 
    plot(xyTs(trialStartSampleIdx), yrpos(trialStartSampleIdx),'bo');
    plot(xyTs(runStartSampleIdx), yrpos(runStartSampleIdx),'go');
    plot(xyTs(runEndSampleIdx), yrpos(runEndSampleIdx),'ro');
    
    disp([ 'trials detected : ' num2str(length(runEndSampleIdx)) ]);
end

if ( max(yrpos(1:runEndSampleIdx(end))) < median(yrpos(runEndSampleIdx(end):end))) 
    disp('YES box session detected')
else
    disp('NO box session detected')
end

% figure; 
% subplot(3,1,1); plot(xyTs, xrpos); legend('x'); 
% subplot(3,1,2); plot(xyTs, yrpos); legend('y');
% subplot(3,1,3); plot(lfpTs, lfpData); legend('lfp');


Fs = 32000;  % Sampling Frequency
N  = 8;    % Order
Fc = 100;  % Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
subSWRFilter = design(h, 'butter');

subSwrLfp= filt(subSWRFilter, lfpData);
subSwrLfpTs=downsample( lfpTs, 32e3/1e3);

%butterworth filter
%[B,A] = butter(2,[4 12]/(Fs/2));
%eeg.theta = filtfilt(B,A, sst);
% the 1-50 Hz filter doesn't seem to help much.
% [B,A] = butter(4,50/(Fs/2), 'low'); % after Buzsaki's 1-50 Hz "dips" in his 1986 publication
% subSwrLfp = filtfilt(B,A, lfpData);
[B,A] = butter(4,[50 250 ]/(Fs/2), 'bandpass'); % after Buzsaki's 1-50 Hz "dips" in his 1986 publication
wideSwrLfp = filtfilt(B,A, lfpData);



figure; hold on; plot( lfpTs, lfpData); plot(lfpTs,subSwrLfp); plot(lfpTs, wideSwrLfp)
legend('lfp','sub SWR','wide SWR');


Fs = 32000;  % Sampling Frequency
N  = 8;    % Order
Fc = 100;  % Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
lowpassSWRFilter = design(h, 'butter');

% all these tetrodes are available for the first training day
% [lfpData,lfpTs]=csc2mat([ dir 'CSC4.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC24.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC28.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC36.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC47.ncs']);
% [lfpData,lfpTs]=csc2mat([ dir 'CSC48.ncs']);



%     plot(xyTs(trialStartSampleIdx), xrpos(trialStartSampleIdx),'bo');
%     plot(xyTs(runStartSampleIdx), xrpos(runStartSampleIdx),'go');
%     plot(xyTs(runEndSampleIdx), xrpos(runEndSampleIdx),'ro');
trialNumber=7;
lfpSampleStart=min(find(lfpTs>=xyTts(trialStartSampleIdx(trialNumber))));
lfpSampleEnd=min(find(lfpTs>=xyTts(runEndSampleIdx(trialNumber))));
[lfpTemp,lfpTsTemp]=csc2mat([ dir 'CSC4.ncs'],lfpSampleStart,lfpSampleEnd);
lfpStack=zeros(6,length(lfpTemp));
lfpStackTs=zeros(6,length(lfpTsTemp));
lfpStack(1,:)=lfpTemp;
lfpStackTs(1,:)=lfpTsTemp;
[lfpStack(2,:),lfpStackTs(2,:)]=csc2mat([ dir 'CSC24.ncs'],lfpSampleStart,lfpSampleEnd);
[lfpStack(3,:),lfpStackTs(3,:)]=csc2mat([ dir 'CSC28.ncs'],lfpSampleStart,lfpSampleEnd);
[lfpStack(4,:),lfpStackTs(4,:)]=csc2mat([ dir 'CSC36.ncs'],lfpSampleStart,lfpSampleEnd);
[lfpStack(5,:),lfpStackTs(5,:)]=csc2mat([ dir 'CSC41.ncs'],lfpSampleStart,lfpSampleEnd);
[lfpStack(6,:),lfpStackTs(6,:)]=csc2mat([ dir 'CSC48.ncs'],lfpSampleStart,lfpSampleEnd);
figure; 
subplot(8,1,1); plot( (lfpStackTs(1,:)-initialLfpTs)/1e6, lfpStack(1,:) );
subplot(8,1,2); plot( (lfpStackTs(2,:)-initialLfpTs)/1e6, lfpStack(2,:) );
subplot(8,1,3); plot( (lfpStackTs(3,:)-initialLfpTs)/1e6, lfpStack(3,:) );
subplot(8,1,4); plot( (lfpStackTs(4,:)-initialLfpTs)/1e6, lfpStack(4,:) );
subplot(8,1,5); plot( (lfpStackTs(5,:)-initialLfpTs)/1e6, lfpStack(5,:) );
subplot(8,1,6); plot( (lfpStackTs(6,:)-initialLfpTs)/1e6, lfpStack(6,:) );
subplot(8,1,7); plot( xyTs(trialStartSampleIdx(trialNumber):runEndSampleIdx(trialNumber)), xrpos(trialStartSampleIdx(trialNumber):runEndSampleIdx(trialNumber)));
subplot(8,1,8);  plot( xyTs(trialStartSampleIdx(trialNumber):runEndSampleIdx(trialNumber)), yrpos(trialStartSampleIdx(trialNumber):runEndSampleIdx(trialNumber)));

% Looking at video -- day 3 trial 7 training da5 2016-08-24
% from the video.
% 28*60+47 % ---- % pick up
% 28*60+53 % 1733 % on maze
% 29*60+00 % 1740 % brick whack?
% 29*60+03 % 1743 % brick whack
% 29*60+06 % 1746 % brick climb
% 29*60+32 % 1773 % through ~30s standing on brick, investigating, moving head around, side to side, up down
% 29*60+34 % 1774 % brick remove hit
% 29*60+36 % 1776 % free to go
% 29*60+40 % 1780 % center barrier whack
% 29*60+49 % 1789 % @ reward
% 29*60+55 % 1795 % pick up
%
% 1749 s -- has some sharpwaveyness to it; there are like 2
trialSevenEventTimes=[ 28*60+53 29*60+00 29*60+03 29*60+06 29*60+32 29*60+34 29*60+36 29*60+40 29*60+49 29*60+55 ];
subplot(8,1,7); hold off;  plot( xyTs(trialStartSampleIdx(trialNumber):runEndSampleIdx(trialNumber)), xrpos(trialStartSampleIdx(trialNumber):runEndSampleIdx(trialNumber))); hold on; plot(trialSevenEventTimes,xrpos(trialSevenEventTimes*30),'*r');
% 1821.25

figure;
Fs = 32000;  % Sampling Frequency
N  = 8;    % Order
Fc = 100;  % Cutoff Frequency
[B,A] = butter(2,[ 130 250 ]/(Fs/2), 'bandpass'); % after Buzsaki's 1-50 Hz "dips" in his 1986 publication
swrLfp= filtfilt( B, A, lfpStack(2,:) );
plot((lfpStackTs(2,:)-initialLfpTs)/1e6, lfpStack(2,:)); hold on; plot((lfpStackTs(2,:)-initialLfpTs)/1e6, swrLfp);

figure;
[B,A] = butter(4,[ 600 5000 ]/(Fs/2), 'bandpass'); 
swrLfp= filtfilt( B, A, lfpStack(2,:) );
plot((lfpStackTs(2,:)-initialLfpTs)/1e6, lfpStack(2,:)); hold on; plot((lfpStackTs(2,:)-initialLfpTs)/1e6, swrLfp);
madam=median(abs(swrLfp-median(swrLfp)))
[pks,pksIdx]=findpeaks( swrLfp,'MinPeakHeight', 4*madam, 'MinPeakDistance', 16);
hold on; plot((lfpStackTs(2,pksIdx)-initialLfpTs)/1e6,pks,'g*')
hold on; plot((lfpStackTs(2,:)-initialLfpTs)/1e6, popSpikeRate*100)


popSpikeRate = zeros(1,length(swrLfp));

fullSpikeIdxs = zeros(1,length(swrLfp)); fullSpikeIdxs(pksIdx)=1;

sigma = 32000/16;
size = 32000/10;
x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2)); %gaussFilter = gaussFilter / sum (gaussFilter); % normalize
figure; plot(gaussFilter)
popSpikeRate = conv( fullSpikeIdxs, gaussFilter, 'same');
figure; hold on; plot((lfpStackTs(2,:)-initialLfpTs)/1e6, popSpikeRate*10)
    
%


zz=ones(1,32)*-40000; zz(12:14)=0;
xx=ones(1,32)*-40000; zz(12:14)=0;



spikes=zeros(32,length(pksIdx)); kk=1;
for ii=1:length(pksIdx)
    if pks(ii) > 4000
        spike=swrLfp(pksIdx(ii)-16:pksIdx(ii)+15);
        if min(spike)<-2400
            spikes(:,kk)=swrLfp(pksIdx(ii)-16:pksIdx(ii)+15); kk=kk+1;
        end
    end
end
figure; plot(spikes(:,1:kk)); hold on; plot(median(spikes(:,1:kk)'), 'LineWidth', 2); 
median(abs(spikes(:,1:kk)-median(spikes(:,1:kk)')'))
aa=(median(spikes(:,1:kk)');
templateMatched=conv(swrLfp,aa,'same'); figure; plot(templateMatched)

3000

figure; plot(swrLfp(pksIdx(1)-8:pksIdx(1)+23))


% signal whitening in the frequency domain
% mX = bsxfun(@minus,swrLfp,mean(swrLfp)); %remove mean
% fX = fft(fft(mX,[],2),[],3); %fourier transform of the images
% spectr = sqrt(mean(abs(fX).^2)); %Mean spectrum
% wX = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X
% figure; hold on; plot(swrLfp); plot(wX*(max(swrLfp)/max(wX)));
% figure; hold on; plot(swrLfp); plot(wX*(max(swrLfp)/max(wX)));

%halfdata is the raw stuff
figure; plot(halfdata(6:10,2:32000*10)'); % channel 23 (array position 8) seems worthless?
% 
% -SamplingFrequency 32000
% RAW data file
% -ADMaxValue 8,388,608
% -ADBitVolts 0.000000015624999960550667
% CSC File
% -ADMaxValue    32,767
% -ADBitVolts 0.000000061037020770982053
raw
legend('1','2','3','4','5','6','7','24','25','26')
%5,6,7
[B,A] = butter(4,[ 600 5000 ]/(Fs/2), 'bandpass'); 
rawLfp= filtfilt( B, A, halfdata(6,32000*10:32000*20) );
figure; plot(halfdata(6,32000*10:32000*20)); hold on;  plot(rawLfp);
rawLfp = filter( iirSpikeFilt , halfdata(6,32000*10:32000*20) );
plot(rawLfp);
rawLfp= filter( B, A, halfdata(6,32000*10:32000*20) );
plot(rawLfp);
isempty(rawLfp)


Fs = 32000;  % Sampling Frequency
Fstop1 = 300;         % First Stopband Frequency
Fpass1 = 600;         % First Passband Frequency
Fpass2 = 5000;        % Second Passband Frequency
Fstop2 = 9000;        % Second Stopband Frequency
Astop1 = 30;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 30;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
iirSpikeFilt = design(h, 'butter', 'MatchExactly', match);








lowpassNumeratorCoeffs =   [ 0.000000000006564694180131090961704897522  0.000000000039388165080786542539055117347  0.000000000098470412701966356347637793367  0.000000000131293883602621825696446486011  0.000000000098470412701966356347637793367  0.000000000039388165080786542539055117347  0.000000000006564694180131090961704897522  ];
lowpassDenominatorCoeffs = [ 1 -5.893323981110579090625378739787265658379 14.472294910655531197107848129235208034515  -18.955749009589681008947081863880157470703  13.966721637745113326900536776520311832428  -5.488755923739796926952294597867876291275  0.898812366459551981279219035059213638306  ];
lowpassDenominatorCoeffs(1) = 0; % compensate for loop design.
lowpassNCoeff = min(length(lowpassDenominatorCoeffs),length(lowpassNumeratorCoeffs));



% changing the filter order modifies the shapes
% BUT the effect is most dramatic on the unidirectional filter
% for some reason, the distortion seems least severe on a 2nd order 
% figure; plot(halfdata(6,32000*10:32000*20)); 
% [B,A] = butter(2,[ 600 6000 ]/(Fs/2), 'bandpass'); 
% rawLfp= filter( B, A, halfdata(6,32000*10:32000*20) );
% hold on;  plot(rawLfp);
% [B,A] = butter(2,[ 600 4000 ]/(Fs/2), 'bandpass'); 
% rawLfp= filter( B, A, halfdata(6,32000*10:32000*20) );
% plot(rawLfp);

[B,A] = butter(2,[ 600 6000 ]/(Fs/2), 'bandpass'); 
rawLfp= filter( B, A, halfdata(6,32000*10:32000*20) );


[Bswr,Aswr] = butter( 2, [ 150 250 ]/(Fs/2), 'bandpass');





[lfpData,lfpTs,header]=csc2mat([ '/Volumes/SILVERSURFER/CSC64.ncs']);
figure; plot((lfpTs(2165000:6009500)-lfpTs(1))/60e6,lfpData(2165000:6009500))

[llfpData,lfpTs,header]=csc2mat([ '/Volumes/SILVRSURFER/da5/day3_plusmaze-rewarded_training1_8x_2016-08-24/CSC4.ncs']);
figure; plot((lfpTs-lfpTs(1))/60e6, lfpSpikes)
[B,A] = butter(2,[ 600 6000 ]/(Fs/2), 'bandpass'); 
lfpSpikes= filter( B, A, llfpData );
