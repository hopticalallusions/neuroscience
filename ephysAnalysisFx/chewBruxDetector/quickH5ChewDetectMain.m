%detectChewNoiseController

% full lists
% dateStrArray={'2018-04-25' '2018-04-26' '2018-04-27' '2018-04-30' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-10' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15' };

fileListGoodLfp = { 'CSC0.ncs' 'CSC4.ncs' 'CSC8.ncs' 'CSC12.ncs' 'CSC16.ncs' 'CSC20.ncs' 'CSC28.ncs' 'CSC32.ncs' };

% this will be much faster, and seems similarly effective.
%fileListGoodLfp = { 'CSC0.ncs' };


dateStrArray={'2018-04-25' '2018-04-27' '2018-04-30' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-10' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15' };

for ii=1:length(dateStrArray) 
    path = [ '/Volumes/AHOWETHESIS/h5/' dateStrArray{ii} '/' ];
    try
        [ chewPeakTimestampSeconds, chewPeakTimestamps, chewPeakValues ] = detectH5chews( path, fileListGoodLfp );
        chewArtifactData.chewTimeSec      = chewPeakTimestampSeconds;
        chewArtifactData.chewTimestamps   = chewPeakTimestamps;
        chewArtifactData.chewPeakValues   = chewPeakValues;
        chewArtifactData.chewFilesAvgd    = fileListGoodLfp;
        chewArtifactData.chewDecectMethod = 'direct SWR band detection';
        save( [ '/Volumes/AHOWETHESIS/h5/h5_' dateStrArray{ii}  '_direct_chewArtifactData.mat' ] , 'chewArtifactData' )
        xx=0:ceil(max(chewArtifactData.chewTimeSec))+1;
        yy=histogram(chewArtifactData.chewTimeSec,xx);
        xlim([ 0 ceil(max(chewArtifactData.chewTimeSec))+1 ])
        print([ '/Volumes/AHOWETHESIS/h5/h5_chewDetectDirect_' dateStrArray{ii}  '.png'],'-dpng','-r200');
    catch err
        disp(['FAILED ON ' dateStrArray{ii} ]);
    end
end



(out.chewData.chewStartTimestamps-out.lfpTimestampZero)/1e6
(out.chewData.chewStartTimestamps)/1e6


ii=17
chewBruxArtifactDetectorOut=detectH5chewBruxEpisodes( path, fileListGoodLfp, 'h5', '2018-06-11', '/Volumes/AHOWETHESIS/h5/' );
hold off;
scatter( chewBruxArtifactDetectorOut.chewData.chewStartTimes, zeros(1,length(chewBruxArtifactDetectorOut.chewData.chewStartTimes)), '>', 'r', 'filled');
hold on;
scatter( chewBruxArtifactDetectorOut.chewData.chewEndTimes, zeros(1,length(chewBruxArtifactDetectorOut.chewData.chewEndTimes)), '<', 'r', 'filled');
scatter( chewBruxArtifactDetectorOut.bruxData.bruxStartTimes, zeros(1,length(chewBruxArtifactDetectorOut.bruxData.bruxStartTimes)), 'v', 'filled');
scatter( chewBruxArtifactDetectorOut.bruxData.bruxEndTimes, zeros(1,length(chewBruxArtifactDetectorOut.bruxData.bruxEndTimes)), 'v', 'filled');






ratName = 'h5';
outputDir = '/Volumes/AHOWETHESIS/h5/';
dateStrArray={'2018-04-25' '2018-04-27' '2018-04-30' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-10' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15' };

for ii=1:length(dateStrArray) 
    path = [ '/Volumes/AHOWETHESIS/h5/' dateStrArray{ii} '/' ];
    try
        [ chewBruxArtifactDetectorOut ] = detectH5chewBruxEpisodes( path, fileListGoodLfp, ratName, dateStrArray{ii}, outputDir );
        chewBruxArtifactDetectorOut.chewFilesAvgd    = fileListGoodLfp;
        chewArtifactData.chewDecectMethod = 'chew brux & episode detection';
        save( [ '/Volumes/AHOWETHESIS/h5/h5_' dateStrArray{ii}  '_chewBruxEpisodes.mat' ] , 'chewBruxArtifactDetectorOut' )
%         scatter( chewBruxArtifactDetectorOut.chewStartTimes, zeros(1,length(chewBruxArtifactDetectorOut.chewStartTimes)), '>', 'r', 'filled');
%         scatter( chewBruxArtifactDetectorOut.chewEndTimes, zeros(1,length(chewBruxArtifactDetectorOut.chewEndTimes)), '<', 'r', 'filled');
%         scatter( chewBruxArtifactDetectorOut.bruxStartTimes, zeros(1,length(chewBruxArtifactDetectorOut.bruxStartTimes)), 'v', 'filled');
%         scatter( chewBruxArtifactDetectorOut.bruxEndTimes, zeros(1,length(chewBruxArtifactDetectorOut.bruxEndTimes)), 'v', 'filled');      
%         xx=0:ceil(max(chewArtifactData.chewTimeSec))+1;
%         yy=histogram(chewArtifactData.chewTimeSec,xx);
%         xlim([ 0 ceil(max(chewArtifactData.chewTimeSec))+1 ])
%         print([ '/Volumes/AHOWETHESIS/h5/h5_chewBruxEpisodes' dateStrArray{ii}  '.png'],'-dpng','-r200');
    catch err
        disp(['FAILED ON ' dateStrArray{ii} ]);
    end
end
