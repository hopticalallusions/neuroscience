dir='/Volumes/Seagate Expansion Drive/h5/2018-04-27_training1/';
[lfpData,lfpTs,header]=csc2mat([ dir 'CSC87.ncs']);
nlxSwrLfp=csc2mat([ dir 'SWR87.ncs']);
[xRaw,yRaw,xyTs]=nvt2mat([ dir 'VT0.nvt' ]);
xpos=nlxPositionFixer(xRaw);
ypos=nlxPositionFixer(yRaw);

makeFilters;

swrLfp = filtfilt( filters.so.swr, lfpData );

lfpTimestampSeconds = (lfpTs-lfpTs(1))/1e6;
xyTimestampSeconds = (xyTs-xyTs(1))/1e6;
speed=calculateSpeed(xpos,ypos,1.5,2.9,29.97);
figure; plot(lfpTimestampSeconds, swrLfp); hold on; plot(xyTimestampSeconds, speed/100); plot(lfpTimestampSeconds, nlxSwrLfp);
figure; plot(lfpTimestampSeconds, lfpData);

lfpData=csc2mat([ dir 'CSC87.ncs']);
swrLfp = filtfilt( filters.so.swr, lfpData );
plot(lfpTimestampSeconds, swrLfp);

swrThreshold = mean(swrLfp) + ( 4  * std(swrLfp) );  % 3 is a Karlsson & Frank 2009 number
swrLfpEnv = abs(hilbert(swrLfp));
[swrPeakValues,      ...
 swrPeakTimes,       ... 
 swrPeakProminances, ...
 swrPeakWidths ] = findpeaks( swrLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
swrPeakTimes36=swrPeakTimes;
swrPeakTimes87=swrPeakTimes;
[acorr,lag]=xcorr(swrPeakTimes36,swrPeakTimes87,100);

acorr=xcorrSparseSets(full(swrPeakTimes36),full(swrPeakTimes87),100);

idxA=round(swrPeakTimes36*20)/20;
idxB=round(swrPeakTimes87*20)/20;

maxLagtime = 2;
% fix this later...
xcorrValues = zeros(1,200); % zeros(1,1+2*maxLagtime);
ii=1;
for offset = -maxLagtime:.05:maxLagtime
        %
        shiftedIdxB=idxB+offset;
        %
        corrNumerator = length(intersect(idxA,shiftedIdxB));
        xcorrValues(ii) = corrNumerator;
        ii=ii+1;
end
xcorrValues=xcorrValues(1:ii-1);
lagtimes = -maxLagtime:.05:maxLagtime;
figure; plot(lagtimes,xcorrValues)





xx 
yy