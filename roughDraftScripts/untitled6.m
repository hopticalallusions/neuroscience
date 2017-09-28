% untitled6, working versions of stuff

%fix all the incongruities in the file.

[xxpos, yypos, xyPositionTimestamps, angles ] = nvt2mat([basedir '/nlx/platter/VT0.nvt']);
figure; plot(xxpos,yypos);
xyTime=double(fulltimestamps)/1000000;

yposCorrected=yypos; yposCorrected(find(yypos==0))=interp1(xyTime,yypos,find(yypos<2));
% in this particular file, 
figure;plot(xposCorrected(3500:end), yposCorrected(3500:end));
figure;plot(xxpos, 'k', 'LineWidth', 4);
hold on;xposCorrected=xxpos; xposCorrected(find(xxpos<2))=interp1(xyTime,xxpos,find(xxpos<2));
plot(xposCorrected);
xposCorrected(find(xposCorrected<2))=interp1(xyTime,xxpos,find(xposCorrected<2));
plot(xposCorrected);
plot(inpaint_nans(xposCorrected));
plot(xposNew,'c')


goodIdxs=find(xxpos<2);
boundaries=find(diff(goodIdxs)>1);






figure; plot3(1:length(xpos),xpos,ypos);



-3 to p+5






zoneIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone0 Entered') )));
daIdx=alignmentLag+ceil((EventStamps(zoneIdxs)-EventStamps(1))/100000);
daIdxBetter=daIdx(diff(daIdx)>20); % this is attempting to lock out times where he's hovering at the border
stack=zeros(1+lookbackward+lookforward,length(daIdx));
for ii=1:length(daIdxBetter)
    stack(:,ii) = yfilt(daIdxBetter(ii)-lookbackward:daIdxBetter(ii)+lookforward);
end
figure; plot(stack);
figure; subplot(2,1,1); hold off; dims=size(stack);
meanofdata=mean(stack');
stdev=std(stack');
stder=stdev/sqrt(dims(2));
tt=(-lookbackward:lookforward)/10;
fill_between_lines(tt,meanofdata-stder,meanofdata+stder,[.5 .6 .7])
hold on;
plot(tt,meanofdata);
title(['Zone 0 Triggered DA Average n=' num2str(length(daIdxBetter)) ]);
xlabel('Time Relative to Zone Entry (s)');
ylabel('DA (nM)');
legend('std err','vel');
subplot(2,1,2);
hold on;
meanofdata=mean(velocityStack');
stdev=std(velocityStack');
stder=stdev/sqrt(dims(2));
tt=(-lookbackward*3:lookforward*3)/30;
ttPrime=tt(1:end-1)+mean(diff(tt));
fill_between_lines(ttPrime,meanofdata-stder,meanofdata+stder,[.5 .6 .7])
plot(ttPrime, mean(velocityStack'));
title('Zone 0 Triggered Velocity Average');
xlabel('Time Relative to Zone Entry (s)');
ylabel('speed (pixels per frame)');
legend('std err','vel');



for ii=1:length(daIdxBetter)
    disp([ num2str(floor(daIdxBetter(ii)/600)) ':' num2str( (mod(daIdxBetter(ii)/600,1))*60) ]) ;
end


figure; plot(distLower,daConc(6:length(distLower)+5))
length

6:length(daConc)-6






 t = [0:length(daConc)];
 A = 1;
 f =.1167; % 0.1154;  0.1086
 y = A*sin(2*pi*f*t);
figure; plot(y)
 
 plot(t(1:100),y(1:100))
 
 
  %% Time specifications:
   Fs = 10;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = length(daConc)/10;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %% Sine wave:
   Fc = .1154;                     % hertz
   x = 40*sin(2*pi*Fc*t);
   % Plot the signal versus time:
   figure; hold on;
   plot(t,daConc); plot(t,x); 
   xlabel('time (in seconds)');
   title('Signal versus Time');
  
 
input = daConc;
sampHz = 10;
L=length(input);
y=input;
Fs=sampHz;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

X=

figure; plot(lessLowFreq(1:L)/max(lessLowFreq));

% Plot single-sided amplitude spectrum.
figure;
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

   
   
 
 
 
 
 
 
 
 %% load the fscv data
daConc=loadTarheelCsvData([basedir '/fscv/platter/'],.993);

[mycorr,lag]=xcorr(daConc,decimate(velocity,3), 1800); %max lag of 3 minutes * 600 samples per minute
% check that there are not 1 minute stitching artifacts
figure; subplot(2,1,1); plot(lag/600, mycorr); title('Correlation \Delta DA vs Velocity'); legend('w/ slow oscillation');
[mycorr,lag]=xcorr(daConc-yfilt,decimate(velocity,3), 1800); %max lag of 3 minutes * 600 samples per minute
% check that there are not 1 minute stitching artifacts
subplot(2,1,2); plot(lag/600, mycorr); legend('w/o slow oscillation'); 



[mycorr,lag]=xcorr(daConc,decimate(velocity,3), 1800); %max lag of 3 minutes * 600 samples per minute
% check that there are not 1 minute stitching artifacts
figure; subplot(2,1,1); plot(lag/600, mycorr); title('Correlation \Delta DA vs Velocity'); legend('w/ slow oscillation');



xlabel(''); ylabel('');

figure; plot(daConc); hold on; plot(yfilt)
figure; plot(daConc-yfilt);








axis([ -2.1 2.1 min(mycorr) 1e6 ]);



'/Users/andrewhowe/blairLab/blairlab_data/v4/march5_twotasks1/nlx/platter/CSC7.ncs'

figure; plot(decimate(correctedCsc(adjIdx:adjIdx+(32000*40)),320));
figure; plot(decimate(correctedCsceighteen(adjIdx:adjIdx+(32000*40)),320));
figure; plot(correctedCsceighteen(adjIdx:adjIdx+(32000*40)));

%% chewing detection demo/dev
% load a bunch of parallel data
[ cscLFP, nlxCscTimestamps, cscHeader ] = csc2mat([basedir '/nlx/platter/CSC7.ncs']);
%min(find((nlxCscTimestamps-nlxCscTimestamps(1))>860.751377*1e6))
%idx 27544046-60*32000*10
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( cscLFP(60*32000*10:end), nlxCscTimestamps(60*32000*10:end) );
adjIdx=27440444-60*32000*10;
% low pass filtered : 18, 23, 48
% high pass filtered : 7, 33, 41, 44, 49
[ cscLFPeighteen, nlxCscTimestampseighteen, cscHeadereighteen ] = csc2mat([basedir '/nlx/platter/CSC18.ncs']);
[ correctedCsceighteen, idxseighteen, mxValueseighteen, meanCscWindoweighteen ] = cscCorrection( cscLFPeighteen(60*32000*10:end), nlxCscTimestampseighteen(60*32000*10:end) );
[ cscLFPthirtythree, nlxCscTimestampsthirtythree, cscHeaderthirtythree ] = csc2mat([basedir '/nlx/platter/CSC33.ncs']);
[ correctedCscthirtythree, idxsthirtythree, mxValuesthirtythree, meanCscWindowthirtythree ] = cscCorrection( cscLFPthirtythree(60*32000*10:end), nlxCscTimestampsthirtythree(60*32000*10:end) );
[ cscLFPfortyone, nlxCscTimestampsfortyone, cscHeaderfortyone ] = csc2mat([basedir '/nlx/platter/CSC41.ncs']);
[ correctedCscfortyone, idxsfortyone, mxValuesfortyone, meanCscWindowfortyone ] = cscCorrection( cscLFPfortyone(60*32000*10:end), nlxCscTimestampsfortyone(60*32000*10:end) );
[ cscLFPfortyfour, nlxCscTimestampsfortyfour, cscHeaderfortyfour ] = csc2mat([basedir '/nlx/platter/CSC44.ncs']);
[ correctedCscfortyfour, idxsfortyfour, mxValuesfortyfour, meanCscWindowfortyfour ] = cscCorrection( cscLFPfortyfour(60*32000*10:end), nlxCscTimestampsfortyfour(60*32000*10:end) );
[ cscLFPfortynine, nlxCscTimestampsfortynine, cscHeaderfortynine ] = csc2mat([basedir '/nlx/platter/CSC49.ncs']);
[ correctedCscfortynine, idxsfortynine, mxValuesfortynine, meanCscWindowfortynine ] = cscCorrection( cscLFPfortynine(60*32000*10:end), nlxCscTimestampsfortynine(60*32000*10:end) );
%set up a gaussian filter
sigma = 1100;
filterWindowLength = 6770;
x = linspace(-filterWindowLength / 2, filterWindowLength / 2, filterWindowLength);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
% envelope, smooth, decimate
% these are now sampled at 100 Hz instead of 32,000 Hz
seven=(decimate(conv(abs(hilbert(correctedCsc(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
thirtythree=(decimate(conv(abs(hilbert(correctedCscthirtythree(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
fortyone=(decimate(conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
fortyfour=(decimate(conv(abs(hilbert(correctedCscfortyfour(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
fortynine=(decimate(conv(abs(hilbert(correctedCscfortynine(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
% plot things
figure;
subplot(5,1,1); plot(correctesdCsc(adjIdx:adjIdx+(32000*40))); 
subplot(5,1,2); plot(correctedCscthirtythree(adjIdx:adjIdx+(32000*40))); 
subplot(5,1,3); plot(correctedCscfortyone(adjIdx:adjIdx+(32000*40))); 
subplot(5,1,4); plot(correctedCscfortyfour(adjIdx:adjIdx+(32000*40))); 
subplot(5,1,5); plot(correctedCscfortynine(adjIdx:adjIdx+(32000*40))); 


myenv=decimate(conv(abs(hilbert(correctedCscfortynine)), gaussFilter, 'same'),320);
tt=((60*100*10):(60*100*10)+length(myenv)-1)/(60*100);
figure; 
subplot(3,1,1); plot(tt,myenv);axis tight;
subplot(3,1,2); plot(tt,[ 0; diff(myenv)]); axis tight;
subplot(3,1,3); plot(tt,myenv);

figure;
subplot(5,1,1); plot(seven); axis tight;
subplot(5,1,2); plot(thirtythree);  axis tight;
subplot(5,1,3); plot(fortyone);  axis tight;
subplot(5,1,4); plot(fortyfour);  axis tight;
subplot(5,1,5); plot(fortynine);  axis tight;
%pull 250 -> 2.5 seconds of data out
figure; 
[corrVal,lag]=(xcorr(fortynine(250:500),seven));
figure; plot(lag, corrVal)
% eats at 588, 2317, maybe 4060
% eats at 18.0+5.58 s, 18.0+23.20 s, maybe 18.0+40.60 s
%23.25 s 
%40.75 s
%58.6 s

%857513837 microseconds

min(find((nlxCscTimestamps-nlxCscTimestamps(1))>857513837))
%27440444 idx of where to start

%%

figure; subplot(4,1,1); plot(correctedCsc(adjIdx:adjIdx+(32000*40))); 
subplot(4,1,2); plot(correctedCsceighteen(adjIdx:adjIdx+(32000*40)));
subplot(4,1,3); plot(correctedCscfortyone(adjIdx:adjIdx+(32000*40)));
subplot(4,1,4); plot(correctedCscfortynine(adjIdx:adjIdx+(32000*40)));
subplot(4,1,4); plot(mean([correctedCsc(adjIdx:adjIdx+(32000*40)) correctedCsceighteen(adjIdx:adjIdx+(32000*40)) correctedCscfortyone(adjIdx:adjIdx+(32000*40))]'))

subplot(4,1,4); hold on; plot(abs(hilbert(mean([correctedCsc(adjIdx:adjIdx+(32000*40)) correctedCsceighteen(adjIdx:adjIdx+(32000*40)) correctedCscfortyone(adjIdx:adjIdx+(32000*40))]'))))

sigma = 1100;
filterWindowLength = 6770;
x = linspace(-filterWindowLength / 2, filterWindowLength / 2, filterWindowLength);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
plot(gaussFilter)

chewfilt = conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same');
chewfilt = conv (correctedCscfortyone(adjIdx:adjIdx+(32000*40)), gaussFilter, 'same');  % not phase shifted
figure; 
plot(chewfilt);


tt=(60*32000*10+(adjIdx:adjIdx+(32000*40)))/1e6;
figure;
subplot(4,1,1); plot(tt,conv(abs(hilbert(correctedCsc(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same')); axis tight;
subplot(4,1,2); plot(tt,conv(abs(hilbert(correctedCsceighteen(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same')); axis tight;
subplot(4,1,3); plot(tt,conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same')); axis tight;
subplot(4,1,4); plot(tt,conv(abs(hilbert(correctedCscfortynine(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same')); axis tight;


figure; 
%% for detection of chews
seven=(decimate(conv(abs(hilbert(correctedCsc(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
eighteen=(decimate(conv(abs(hilbert(correctedCsceighteen(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
fortyone=(decimate(conv(abs(hilbert(correctedCscfortyone(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
fortynine=(decimate(conv(abs(hilbert(correctedCscfortynine(adjIdx:adjIdx+(32000*40)))), gaussFilter, 'same'),320));
subplot(4,1,2); plot(tt,mean(eighteen))

figure; plot(xcorr(correctedCsceighteen(adjIdx+(0.99e5:1.03e5)), correctedCscfortyone(adjIdx:adjIdx+(32000*40))));




subplot(4,1,4); plot(mean([correctedCsc(adjIdx:adjIdx+(32000*40)) correctedCsceighteen(adjIdx:adjIdx+(32000*40)) correctedCscfortyone(adjIdx:adjIdx+(32000*40))]'))





103700-96930



figure; plot(conv(correctedCsceighteen(adjIdx:adjIdx+(32000*40)),correctedCscfortyone(adjIdx:adjIdx+(32000*40))))


figure; plot(xcorr(correctedCsceighteen(adjIdx+(0.99e5:1.03e5)), correctedCscfortyone(adjIdx:adjIdx+(32000*40))));
% abs(hilbert(xyz)) provides an envelope
figure; plot(abs(hilbert(correctedCscfortyone)));



[ cscLFPfortyone, nlxCscTimestampfortyone, cscHeaderfortyone ] = csc2mat([basedir '/nlx/platter/CSC41.ncs']);
[ correctedCscfortyone, idxsfortyone, mxValuesfortyone, meanCscWindowfortyone ] = cscCorrection( cscLFPfortyone(60*32000*10:end), nlxCscTimestampsfortyone(60*32000*10:end) );
figure; plot(correctedCscfortyone(adjIdx:adjIdx+(32000*40)));


6.36e5 to 

foodTimes=EventStamps(zoneOneIdxs);
cscIdx=find(nlxCscTimestamps>foodTimes(29), 1 )-60*32000*10;
figure; plot(correctedCsc(cscIdx:cscIdx+96000));



zoneZeroEntryIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Entered') )));
zoneZeroEntryIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Entered') )));
zoneZeroEntryIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Entered') )));
zoneZeroEntryIdxs=find(not(cellfun('isempty', strfind(EventStrings, 'Zoned Video: Zone1 Entered') )));
for ii=1:length(daIdxBetter)
    disp([ num2str(floor(daIdxBetter(ii)/600)) ':' num2str( (mod(daIdxBetter(ii)/600,1))*60) ]) ;
end



allIdxs=[ttlRewardCSevenIdx; zoneZeroIdxs; zoneOneIdxs; zoneTwoIdxs; zoneThreeIdxs];
allEventStrings=EventStrings(allIdxs);
allEventTimes=(EventStamps(allIdxs)-EventStamps(1))/1e6;


figure; plot(xpos,ypos)



figure; hist(metrics.max);
hist(metrics.max,100);
hist(metrics.maxLocation,100);
metrics.group=zeros(1,length(metrics.max));
metrics.group(find(metrics.maxLocation>14))=1;
hist(metrics.min,100);
metrics.group(find((metrics.group>0).*(metrics.min<-500)))=1;
hist(metrics.minLocation,100);
plot(spikes(:,find(metrics.minLocation>45)))
hist(metrics.width,100);
hist(metrics.amplitude,100);
plot(metrics.min, metrics.max,'.')
hist(metrics.mean,100);
hist(metrics.std,100);
hist(metrics.median,100);
plot(spikes(:,find(metrics.median>600)))
plot(metrics.rmsFreq,metrics.width, '.')
hist(metrics.madam,100);
hist(metrics.rmsSignal,100);
plot(spikes(:,find(metrics.rmsSignal>1800)))
hist(metrics.rmsFreq,100);
plot(spikes(:,find(metrics.rmsFreq>1.5)))
metrics.group(find((metrics.group>0).*(metrics.rmsFreq<1.5)))=1;
hist(metrics.avgAbsValue,100);
plot(spikes(:,find(metrics.avgAbsValue>1500)))
hist(metrics.medianAbsValue,100);
plot(spikes(:,find(metrics.medianAbsValue>1000)))
hist(metrics.madamMedianAbsValue,100);
plot(spikes(:,find(metrics.madamMedianAbsValue>1500)))
hist(metrics.sqrtEnergy,100);
plot(spikes(:,find(metrics.sqrtEnergy>1.2e4)))
hist(metrics.peakPointyness,100);
plot(spikes(:,find(metrics.peakPointyness<1)))
hist(metrics.peakCurvyness,100);
plot(spikes(:,find(metrics.peakCurvyness==0)))
metrics