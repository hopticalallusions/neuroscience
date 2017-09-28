function [peakIdxs] = peakDetector( data, threshold, windowWidth, makePlots )
    % data -- peaks will be detected in this data
    % threshold -- set a threshold for things you might want to consider as a peak
    % width -- this is useful for excluding multiple local peaks from your results
    if nargin < 4
        makePlots =0;
    end
    if nargin < 3
        windowWidth = 1;
    end
    %
    superThresholdIdxs = find( data > threshold );
    putativeApPeakIdxs = [];
    idx = 1;
    while idx < length(superThresholdIdxs)
        startIdx = idx;
        %disp([num2str(superThresholdIdxs(idx+1)) ' == '  num2str(superThresholdIdxs(idx)+1) 'is ' num2str(superThresholdIdxs(idx+1) == superThresholdIdxs(idx)+1)] )
        while (idx+1 < length(superThresholdIdxs) ) && (superThresholdIdxs(idx+1) < superThresholdIdxs(idx)+windowWidth)
            idx = idx + 1;
        end
        endIdx = idx;
        %disp([num2str(startIdx) '   ' num2str(endIdx)]);
        offset = find(data(superThresholdIdxs(startIdx:endIdx))==max(data(superThresholdIdxs(startIdx:endIdx))));
        offset = offset(1)-1;
        putativeApPeakIdxs = [ putativeApPeakIdxs startIdx+offset];
        idx=endIdx+1;
    end
    % look, it works!
    if makePlots > 0
        figure;
        plot( data, 'b')
        hold on;
        plot( superThresholdIdxs(putativeApPeakIdxs), data(superThresholdIdxs(putativeApPeakIdxs)),'ro'); title('peaks found'); ylabel('value'); xlabel('data point');
        figure; hist(data(superThresholdIdxs(putativeApPeakIdxs)),250); title('frequency distribution of peak values'); ylabel('frequency'); xlabel('data value');
    end
    %tt(superThresholdIdxs(putativeApPeakIdxs))'
    peakIdxs = superThresholdIdxs(putativeApPeakIdxs);
    return
end