function output = h5DataExtraction( input )

if ~exist( [ '~/data/cache/' input.rat '_' input.dateStr '_avgLfp.mat' ], 'file' )
    disp('building avg signal LFP');
    avgLfp=avgLfpFromList( input.dir, input.fileListGoodLfp, 1 );  % build average LFP
    save( [ '~/data/cache/' input.rat '_' input.dateStr '_avgLfp.mat' ], 'avgLfp');
else
    disp('loading avg signal LFP');
    load( [ '~/data/cache/' input.rat '_' input.dateStr '_avgLfp.mat' ], 'avgLfp' );
end


speedThreshold = 10; % cm/s

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ input.dir 'VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;
%% calculate the speed -- this is the same algorithm that was used to calculate the speed for the learnMem analysis
dx = zeros(size(xpos));
dy = zeros(size(ypos));
for jj=2:length(xpos)-1
    dy(jj)=( ypos(jj-1) - ypos(jj+1) );
    dx(jj)=( xpos(jj-1) - xpos(jj+1) );
end
boxcarSize = 45;  % samples
dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
output.speed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/2.75 * 29.97;  % sqrt() * ?? * 1/pxPerCm * framesPerSec
%speedAll=calculateSpeed(xpos, ypos, 1, 2.8);
%speed=speedAll;


[xrpos,yrpos]=rotateXYPositions(xpos,ypos,input.center(1),input.center(2),input.rotationAmount,360,320);

binResolution = round(15*2.9); % px/bin

% if the rat is in the bucket, adjust the speed such that he is below
% the speed threshold. (these are mutually exclusive positions, so add them
% together.
dims = size(input.bucketCoordinate);
inBucket = zeros(length(xpos),1);
% aggregate all the times the rat is within the bucket radii
for ii=1:dims(1)
    inBucket = inBucket+(distFromPoint( xrpos,yrpos, input.bucketCoordinate(ii,1), input.bucketCoordinate(ii,2) )<input.bucketRadius(ii));
end
output.inBucket=inBucket>0;  % flatten to 0s and 1s
% smooth the resulting bucket-ness
smoothFactor = 4;
output.inBucketSmoothed=inBucket;
for ii = (smoothFactor+1):length(inBucket)-(smoothFactor+1)
    output.inBucketSmoothed(ii) = median(inBucket(ii-smoothFactor:ii+smoothFactor));
end
%speed(inBucket>0) = speedAll(inBucket>0)/10;

output.xrpos=xrpos;
output.yrpos=yrpos; %+12;


makeFilters;


%% theta
% csc68 looks good in the screenshots ;; tt13, tt19 - theta   ch48, ch72
[ lfpTheta, lfpTimestamps ]=csc2mat( [ input.dir 'CSC68.ncs' ] );
lfpTimestampSeconds = (lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = filtfilt(  filters.so.theta , lfpTheta );
thetaLfpAnalytic = hilbert(thetaLfp);
thetaLfpEnv = abs(thetaLfpAnalytic);
thetaPhase = angle(thetaLfpAnalytic);




%% SWR band

% tt10, tt22 - swr  ch36; ch87
[ lfpSwr ]=csc2mat( [ input.dir 'CSC36.ncs' ] );
% Gyorgy Buzsaki. Hippocampal Sharp Wave-Ripple: A Cognitive Biomarker for
% Episodic Memory and Planning. HIPPOCAMPUS 25:1073?1188 (2015)  Fig 4c; pg
% 1077
swrFilter      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   140, 'HalfPowerFrequency2',  230, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article

swrLfp = filtfilt( swrFilter, lfpSwr );
swrLfpEnv = abs(hilbert(swrLfp));

swrThreshold = mean(swrLfpEnv) + ( 3  * std(swrLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

[output.swrPeakValues,      ...
 output.swrPeakTimes,       ... 
 ~, ...
 ~ ] = findpeaks( swrLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  swrThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


% build some structures for later SWR analysis
swrPosAll=zeros(2,length(output.swrPeakTimes));
swrSpeedAll=zeros(1,length(output.swrPeakTimes));
swrThetaAll=zeros(1,length(output.swrPeakTimes));
for ii=1:length(output.swrPeakTimes)
    tempIdx=find(output.swrPeakTimes(ii)<=xytimestampSeconds, 1 );
    if ~isempty(tempIdx)
        swrPosAll(1,ii) = xrpos (tempIdx);
        swrPosAll(2,ii) = yrpos (tempIdx);
        swrSpeedAll(ii) = output.speed (tempIdx);
    end
end
swrPosFast=swrPosAll(:,swrSpeedAll>speedThreshold);
swrPosSlow=swrPosAll(:,swrSpeedAll<=speedThreshold);
%
output.swrPosAll=swrPosAll;
output.swrSpeedAll=swrSpeedAll;
output.swrPosFast=swrPosFast;
output.swrPosSlow=swrPosSlow;

output.swrThetaAll = thetaLfpEnv ( floor(output.swrPeakTimes*32000)+1 );
output.swrThetaPhaseAll = thetaPhase (  floor(output.swrPeakTimes*32000)+1  );



%% high gamma

hiGammaFilter    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   80, 'HalfPowerFrequency2',  130, 'SampleRate', 32000); % Sullivan, Csicsvari ... Buzsaki, J Neuro 2011; Fig 1D

hiGammaLfp = filtfilt( hiGammaFilter, lfpSwr );
hiGammaLfpEnv = abs(hilbert(hiGammaLfp));

hiGammaThreshold = mean(hiGammaLfpEnv) + ( 3  * std(hiGammaLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

[output.hiGammaPeakValues,      ...
 output.hiGammaPeakTimes,       ... 
 ~, ...
 ~ ] = findpeaks( hiGammaLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  hiGammaThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


% build some structures for later SWR analysis
hiGammaPosAll=zeros(2,length(output.hiGammaPeakTimes));
hiGammaSpeedAll=zeros(1,length(output.hiGammaPeakTimes));
for ii=1:length(output.hiGammaPeakTimes)
    tempIdx=find(output.hiGammaPeakTimes(ii)<=xytimestampSeconds, 1 );
    if ~isempty(tempIdx)
        hiGammaPosAll(1,ii) = xrpos (tempIdx);
        hiGammaPosAll(2,ii) = yrpos (tempIdx);
        hiGammaSpeedAll(ii) = output.speed (tempIdx);
    end
end
hiGammaPosFast=hiGammaPosAll(:,hiGammaSpeedAll>speedThreshold);
hiGammaPosSlow=hiGammaPosAll(:,hiGammaSpeedAll<=speedThreshold);
%
output.hiGammaPosAll=hiGammaPosAll;
output.hiGammaSpeedAll=hiGammaSpeedAll;
output.hiGammaPosFast=hiGammaPosFast;
output.hiGammaPosSlow=hiGammaPosSlow;



%% try to find noise artifacts

swrAvgLfp = filtfilt( swrFilter, avgLfp );
swrAvgLfpEnv = abs(hilbert(swrAvgLfp));

swrAvgThreshold = mean(swrAvgLfpEnv) + ( 3  * std(swrAvgLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

[output.swrAvgPeakValues,      ...
 output.swrAvgPeakTimes,       ... 
 ~, ...
 ~ ] = findpeaks( swrAvgLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  swrAvgThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak



% build some structures for later SWR analysis
swrAvgPosAll=zeros(2,length(output.swrAvgPeakTimes));
swrAvgSpeedAll=zeros(1,length(output.swrAvgPeakTimes));
for ii=1:length(output.swrAvgPeakTimes)
    tempIdx=find(output.swrAvgPeakTimes(ii)<=xytimestampSeconds, 1 );
    if ~isempty(tempIdx)
        swrAvgPosAll(1,ii) = xrpos (tempIdx);
        swrAvgPosAll(2,ii) = yrpos (tempIdx);
        swrAvgSpeedAll(ii) = output.speed (tempIdx);
    end
end
swrAvgPosFast=swrAvgPosAll(:,swrAvgSpeedAll>speedThreshold);
swrAvgPosSlow=swrAvgPosAll(:,swrAvgSpeedAll<=speedThreshold);
%
output.swrAvgPosAll=swrAvgPosAll;
output.swrAvgSpeedAll=swrAvgSpeedAll;
output.swrAvgPosFast=swrAvgPosFast;
output.swrAvgPosSlow=swrAvgPosSlow;




hiGammaAvgLfp = filtfilt( hiGammaFilter, avgLfp );
hiGammaAvgLfpEnv = abs(hilbert(hiGammaAvgLfp));

hiGammaAvgThreshold = mean(hiGammaAvgLfpEnv) + ( 3  * std(hiGammaAvgLfpEnv) );  % 3 is a Karlsson & Frank 2009 number

[output.hiGammaAvgPeakValues,      ...
 output.hiGammaAvgPeakTimes,       ... 
 ~, ...
 ~ ] = findpeaks( hiGammaAvgLfpEnv,                        ... % data
                              lfpTimestampSeconds,                     ... % sampling frequency
                              'MinPeakHeight',  hiGammaAvgThreshold, ...  %std(swrblob.swrLfpEnv)*6, ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


% build some structures for later SWR analysis
hiGammaAvgPosAll=zeros(2,length(output.hiGammaAvgPeakTimes));
hiGammaAvgSpeedAll=zeros(1,length(output.hiGammaAvgPeakTimes));
for ii=1:length(output.hiGammaAvgPeakTimes)
    tempIdx=find(output.hiGammaAvgPeakTimes(ii)<=xytimestampSeconds, 1 );
    if ~isempty(tempIdx)
        hiGammaAvgPosAll(1,ii) = xrpos (tempIdx);
        hiGammaAvgPosAll(2,ii) = yrpos (tempIdx);
        hiGammaAvgSpeedAll(ii) = output.speed (tempIdx);
    end
end
hiGammaAvgPosFast=hiGammaAvgPosAll(:,hiGammaAvgSpeedAll>speedThreshold);
hiGammaAvgPosSlow=hiGammaAvgPosAll(:,hiGammaAvgSpeedAll<=speedThreshold);
%
output.hiGammaAvgPosAll=hiGammaAvgPosAll;
output.hiGammaAvgSpeedAll=hiGammaAvgSpeedAll;
output.hiGammaAvgPosFast=hiGammaAvgPosFast;
output.hiGammaAvgPosSlow=hiGammaAvgPosSlow;


%%
% if this fails, check to see if the camera distortion toolkit is in the
% path.
output.thetaTimestamps = downsample(lfpTimestamps,128);
output.thetaLfp = decimate(thetaLfp,128);
                          
%%

input.dir
input.dateStr

for ttIdx=1:length(input.ttFilenames)

    disp(input.ttFilenames{ttIdx});
    
    [ ~, spiketimestamps, ~, ~, cellNumber ]=ntt2mat([ input.dir input.ttFilenames{ttIdx} ]);
    
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).spiketimestamps  = spiketimestamps;
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).spiketimestampSeconds  = ( spiketimestamps - lfpTimestamps(1) )/1e6;
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellNumber  = cellNumber;
    
    cellPosAll = zeros(2,length(spiketimestamps));   % row 1 is X, row 2 is Y
    cellSpeedAll = zeros(1,length(spiketimestamps)); % collect all the speeds
    cellInBucket = zeros(1,length(spiketimestamps));
    for ii=1:length(spiketimestamps)
        tempIdx=find(spiketimestamps(ii)<=xytimestamps, 1 );
        if ~isempty(tempIdx) && cellNumber(ii)>0
            cellPosAll(1,ii) = xrpos (tempIdx);
            cellPosAll(2,ii) = yrpos (tempIdx);
            cellSpeedAll(ii) = output.speed (tempIdx);
            cellInBucket(ii) = inBucket(tempIdx);
        end
    end
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellPosAll = cellPosAll;
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellSpeedAll = cellSpeedAll;
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellInBucket = cellInBucket;
    
% this approach is very, very, very, very slow...
%     tempIdx = ones(1,length(spiketimestamps));
%     for ii=1:length(spiketimestamps)
%         if cellNumber(ii)>0
%             tempIdx(ii) = find(spiketimestamps(ii)<=lfpTimestamps, 1 );
%         end
%     end

% OK. so we will try to union to get the timestamps. Apparently, precision
% causes some issues here... so we will divide by 5e2 which appears to make
% things align while also avoiding non-uniqueness
    [~,~,tempIdx] = intersect(floor(spiketimestamps/5e2),floor(lfpTimestamps/5e2));
    if length(tempIdx) ~= length(spiketimestamps)
        disp('failure to properly match timestamps 1-to-1');
    end
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellThetaEnv   = thetaLfpEnv(tempIdx);
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellThetaPhase = thetaPhase(tempIdx);
    output.tt.( strrep(input.ttFilenames{ttIdx},'.NTT','') ).cellGammaEnv   = hiGammaLfpEnv(tempIdx);
    
end

[ output.histThetaEnv, output.histThetaEnvBins ] = histcounts(thetaLfpEnv,100);
[ output.histHiGammaEnv, output.histHiGammaEnvBins ] = histcounts(hiGammaLfpEnv,100);

return;


