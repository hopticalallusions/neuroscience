

for rowIdx=1:512
    for colIdx=1:512
        minFrameRaw(rowIdx,colIdx) = min(Y(rowIdx,colIdx,:));
        maxFrameRaw(rowIdx,colIdx) = max(Y(rowIdx,colIdx,:));
        avgFrameRaw(rowIdx,colIdx) = mean(Y(rowIdx,colIdx,:));
        skewFrameRaw(rowIdx,colIdx) = skewness(double(Y(rowIdx,colIdx,:)));
        varFrameRaw(rowIdx,colIdx) = var(double(Y(rowIdx,colIdx,:)));
        stdFrameRaw(rowIdx,colIdx) = std(double(Y(rowIdx,colIdx,:)));
        medFrameRaw(rowIdx,colIdx) = median(Y(rowIdx,colIdx,:));
        kurtFrameRaw(rowIdx,colIdx) = kurtosis(double(Y(rowIdx,colIdx,:)));
        madamFrameRaw(rowIdx,colIdx) = median(abs(double(Y(rowIdx,colIdx,:))-median(double(Y(rowIdx,colIdx,:)))));
    end
end
rangeFrameRaw=maxFrameRaw-minFrameRaw;


figure;
subplot(3,4,1); imagesc(Y(:,:,400)); title('frame 814'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,2); imagesc(minFrameRaw); title('minimum'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,3); imagesc(maxFrameRaw); title('max'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,4); imagesc(avgFrameRaw); title('mean'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,5); imagesc(skewFrameRaw); title('skewness'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,6); imagesc(varFrameRaw); title('var'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,7); imagesc(stdFrameRaw); title('std'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,8); imagesc(medFrameRaw); title('median'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,9); imagesc(madamFrameRaw); title('MADAM'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,10); imagesc(kurtFrameRaw); title('kurtosis'); colormap(build_NOAA_colorgradient); colorbar;
subplot(3,4,11); imagesc(rangeFrameRaw); title('range'); colormap(build_NOAA_colorgradient); colorbar;


framesMedFlattened=zeros(size(Y));
for idx=1:1000
    framesMedFlattened(:,:,1,idx)=double(Y(:,:,idx))-(medFrameRaw);
end
