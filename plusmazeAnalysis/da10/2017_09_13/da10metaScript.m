clear all; 
close all;

metadata.rat = 'da10';
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.fileListDisconnectedLfp={ 'CSC32.ncs' 'CSC58.ncs' 'CSC75.ncs' 'CSC76.ncs' 'CSC87.ncs' };
metadata.lfpFile = 'CSC88.ncs';
metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.outputDir = '/Users/andrewhowe/data/plusMazeEphys/';


%
% this day has initial data from 1s? until about 1487 s
% then there is no data until 8.99755e4 seconds, which is weird.
metadata.lfpStartIdx = 1;
metadata.lfpStartIdx = round(1495*32000);
metadata.day = '2017-09-12_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ] ); end;

metadata.lfpStartIdx = 1954981;   % round(61.09316*32000);
metadata.day = '2017-09-13_';
% FOR da10 2017-09-13, SKIP THE INTRODUCTION
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;


metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.day = '2017-09-14_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;

metadata.day = '2017-09-15_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day] ); end;

metadata.fileListGoodLfp = {  'CSC6.ncs'  'CSC9.ncs'  'CSC17.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.day = '2017-09-18_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
% some wierd stuff happens

metadata.fileListGoodLfp = { 'CSC2.ncs'  'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' }; % 'CSC88.ncs' };
metadata.day = '2017-09-19_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
% some wierd stuff happens

metadata.lfpStartIdx = round(40*32000);
metadata.day = '2017-09-20_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;
% beginning seems to be cut off?
%has some errors identifying cutoffs; last trial is bad

metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.day = '2017-09-22_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;

metadata.day = '2017-09-25_';
try outp=analyzeSWR(metadata); catch; disp(['FAILED!! : ' metadata.rat ' ' metadata.day ]); end;





disp('ontoMazeTimes')
for ii=1:length(output.ontoMazeTimes)
    disp(num2str(round(output.ontoMazeTimes(ii))));
end
disp('runStartTimes')
for ii=1:length(output.runStartTimes)
    disp(num2str(round(output.runStartTimes(ii))));
end
disp('rewardTimes')
for ii=1:length(output.rewardTimes)
    disp(num2str(round(output.rewardTimes(ii))));
end
disp('intoBucketTimes')
for ii=1:length(output.intoBucketTimes)
    disp(num2str(round(output.intoBucketTimes(ii))));
end



filters.dc = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.000001, 'HalfPowerFrequency2',    3, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
filters.ac = designfilt( 'bandpassiir', 'StopbandFrequency1', 2, 'PassbandFrequency1',  3, 'PassbandFrequency2',    800000, 'StopbandFrequency2',    1600000, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 3200000); 

dcElectricEnv = filtfilt( filters.dc, outp.electricEnv );
acElectricEnv = filtfilt( filters.ac, outp.electricEnv );
dcElectricEnv =  outp.electricEnv- acElectricEnv;
figure; plot(outp.timestampSeconds, outp.electricEnv); hold on; plot( outp.timestampSeconds, dcElectricEnv); axis tight;



sampleRate.lfp = 32000;
%
inputElements = length(outp.electricEnv);
halfWindowSize = round(30*sampleRate.lfp);  % elements
overlapSize = round(1.8*halfWindowSize);    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
%
outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( jumpSize ) ) + 2;
mvgMedian = zeros( 1, outputPoints );
mvgMedianTimes = zeros( 1, outputPoints );
mvgMedianSampleRate = sampleRate.lfp/jumpSize;
% initialize...
mvgMedian(1)=median(outp.electricEnv(1:sampleRate.lfp));
mvgMedianTimes(1) = outp.timestampSeconds(1);
%
outputIdx = 2;
mvgMedian(outputIdx)=median(outp.electricEnv(1:round(halfWindowSize/2)));
mvgMedianTimes(outputIdx) = outp.timestampSeconds(round(halfWindowSize/4));
%
outputIdx = 3;
mvgMedian(outputIdx)=median(outp.electricEnv(1:halfWindowSize));
mvgMedianTimes(outputIdx) = outp.timestampSeconds(round(halfWindowSize/2));
%
outputIdx = 4;
for idx=halfWindowSize+1:jumpSize:inputElements-(1+halfWindowSize)
    ii=(idx-halfWindowSize:idx+halfWindowSize);
    mvgMedian(outputIdx)=median(outp.electricEnv(ii));
    mvgMedianTimes(outputIdx) = outp.timestampSeconds(idx);
    outputIdx = outputIdx + 1;
end
% finalize
mvgMedian(outputIdx)=median(outp.electricEnv(end-halfWindowSize:end));
mvgMedianTimes(outputIdx) = outp.timestampSeconds(end-round(halfWindowSize/2));
outputIdx = outputIdx+1;
mvgMedian(outputIdx)=median(outp.electricEnv(end-round(halfWindowSize/2):end));
mvgMedianTimes(outputIdx) = outp.timestampSeconds(end-round(halfWindowSize/4));
outputIdx = outputIdx+1;
mvgMedian(outputIdx)=median(outp.electricEnv(end-sampleRate.lfp:end));
mvgMedianTimes(outputIdx) = outp.timestampSeconds(end);
%
mvgMedian = mvgMedian(1:outputIdx);
mvgMedianTimes = mvgMedianTimes(1:outputIdx);
figure; plot(outp.timestampSeconds, outp.electricEnv); hold on; 
plot( mvgMedianTimes, mvgMedian); axis tight;
plot( mvgMedianTimes(1:end-1)+diff(mvgMedianTimes)/2, diff(mvgMedian))
