figure;

%function data = loadTarheelCsvData(filename)

    dir='C:\Users\toSort\Desktop\andrewhowe_blairlab\V4\3-10-2015\run\platterSimple\BATCH_PC\STACKED_PC\';
    
    dir = '~/toSort/blairlab_data/giantsharpwaves/3-20-2015/run/maze/BATCH_PC/STACKED_PC/';
    filename='Stacked_Cal';


    alpha = .999;

    stackedData=load([dir filename]);
    % stacked data arrives in columnar form
    % the row dimension is 10 * seconds per file
    % the col dimension is the number of files
    % the first column is ALWAYS the time within a file
    % so we cut that out
    dims = size(stackedData);
    stackedData = stackedData(:,2:dims(2));
    dims = size(stackedData);
    % eliminate NaNs
    stackedData(isnan(stackedData)) = 0;
    % FSCV probes drift over time.
    % each file (column) is re-baselined
    % this step produces continuous data without hard jumps
    % ("rebaselining" in Wassum lab terminology)
    for col = 2:dims(2) 
        offset=stackedData(dims(1),col-1); 
        for row=1:dims(1); 
            stackedData(row,col)=offset+stackedData(row,col); 
        end;
    end;
    % we don't really want a matrix, we want a time series
    linearizedData=stackedData(:);
    % drift will provide low frequency changes, which we want to remove
    %
    % we accomplish this by creating a slow, bidirectional moving average
    % forward
    avg=zeros(1,length(linearizedData));
    avg(1) = linearizedData(1);
    avg(length(linearizedData))=linearizedData(length(linearizedData));
    for idx=2:length(linearizedData);
        avg(idx)=alpha*avg(idx-1)+(1-alpha)*linearizedData(idx);
    end;
   
    % backward
    ravg=zeros(1,length(linearizedData));
    ravg(length(linearizedData))=linearizedData(length(linearizedData));
    for idx=length(linearizedData)-1:-1:2;
        ravg(idx)=alpha*ravg(idx+1)+(1-alpha)*linearizedData(idx);
    end;
    
    % just ignore the trend in the first and last 
    %avg = 
    %ravg = 
    
    
    % slow moving averages are quite far behind the trend much of the time
    % for example, given a signal drifting up, the forward average will
    % be too low and the backward too high, but their average is centered
    %
    
    % avg these together to find the center
    agAvg=mean([avg;ravg]);
    
    
   % de-trend (de-drift) the data
   data = linearizedData - agAvg';
   

   plot([linearizedData';ravg;avg;agAvg;data']')
   figure;
   hold on;
   plot(linearizedData, 'Color', [ .6 .6 .6 ] )
   plot(ravg, '--', 'Color', [ .2 .2 .2 ] )
   plot(avg, '--', 'Color', [ .2 .2 .2 ] )
   plot(agAvg, 'Color', [ 1 0 0 ] )
   plot(data, 'Color', 'b' )
   legend('original','rev avg','fwd avg','avg avg','corrected')
%end



autocorr=xcorr(data,300,'coeff');
windowedAutoCorr=(autocorr-mean(autocorr)).*hann(length(autocorr));
cvfft=fft([windowedAutoCorr; zeros(2^19-length(windowedAutoCorr),1)],2^19);
cvpower=cvfft.*conj(cvfft)/2^19;
f=0:(5/2^18):5;
plot(f(1:length(f)-1),log(cvpower(1:length(cvpower)/2)))
hold on;

   dir='C:\Users\UCLA\Desktop\andrewhowe_blairlab\V4\3-5-2015\run\platter\BATCH_PC\STACKED_PC\';
    filename='Stacked_Cal';
    alpha = .999;
    stackedData=load([dir filename]);
    % stacked data arrives in columnar form
    % the row dimension is 10 * seconds per file
    % the col dimension is the number of files
    % the first column is ALWAYS the time within a file
    % so we cut that out
    dims = size(stackedData);
    stackedData = stackedData(:,2:dims(2));
    dims = size(stackedData);
    % eliminate NaNs
    stackedData(isnan(stackedData)) = 0;
    % FSCV probes drift over time.
    % each file (column) is re-baselined
    % this step produces continuous data without hard jumps
    % ("rebaselining" in Wassum lab terminology)
    for col = 2:dims(2) 
        offset=stackedData(dims(1),col-1); 
        for row=1:dims(1); 
            stackedData(row,col)=offset+stackedData(row,col); 
        end;
    end;
    % we don't really want a matrix, we want a time series
    linearizedData=stackedData(:);
    % drift will provide low frequency changes, which we want to remove
    %
    % we accomplish this by creating a slow, bidirectional moving average
    % forward
    avg=zeros(1,length(linearizedData));
    avg(1) = linearizedData(1);
    avg(length(linearizedData))=linearizedData(length(linearizedData));
    for idx=2:length(linearizedData);
        avg(idx)=alpha*avg(idx-1)+(1-alpha)*linearizedData(idx);
    end;
    % backward
    ravg=zeros(1,length(linearizedData));
    ravg(length(linearizedData))=linearizedData(length(linearizedData));
    for idx=length(linearizedData)-1:-1:2;
        ravg(idx)=alpha*ravg(idx+1)+(1-alpha)*linearizedData(idx);
    end;
    % slow moving averages are quite far behind the trend much of the time
    % for example, given a signal drifting up, the forward average will
    % be too low and the backward too high, but their average is centered
    % avg these together to find the center
    agAvg=mean([avg;ravg]);
   % de-trend (de-drift) the data
   data = linearizedData - agAvg';



autocorr=xcorr(data,300,'coeff');
windowedAutoCorr=(autocorr-mean(autocorr)).*hann(length(autocorr));
cvfft=fft([windowedAutoCorr; zeros(2^19-length(windowedAutoCorr),1)],2^19);
cvpower=cvfft.*conj(cvfft)/2^19;
f=0:(5/2^18):5;
plot(f(1:length(f)-1),log(cvpower(1:length(cvpower)/2)), 'r')




   dir='C:\Users\UCLA\Desktop\andrewhowe_blairlab\V4\2-23-2015\run\BATCH_PC\STACKED_PC\';
    filename='Stacked_Cal';
    alpha = .999;
    stackedData=load([dir filename]);
    % stacked data arrives in columnar form
    % the row dimension is 10 * seconds per file
    % the col dimension is the number of files
    % the first column is ALWAYS the time within a file
    % so we cut that out
    dims = size(stackedData);
    stackedData = stackedData(:,2:dims(2));
    dims = size(stackedData);
    % eliminate NaNs
    stackedData(isnan(stackedData)) = 0;
    % FSCV probes drift over time.
    % each file (column) is re-baselined
    % this step produces continuous data without hard jumps
    % ("rebaselining" in Wassum lab terminology)
    for col = 2:dims(2) 
        offset=stackedData(dims(1),col-1); 
        for row=1:dims(1); 
            stackedData(row,col)=offset+stackedData(row,col); 
        end;
    end;
    % we don't really want a matrix, we want a time series
    linearizedData=stackedData(:);
    % drift will provide low frequency changes, which we want to remove
    %
    % we accomplish this by creating a slow, bidirectional moving average
    % forward
    avg=zeros(1,length(linearizedData));
    avg(1) = linearizedData(1);
    avg(length(linearizedData))=linearizedData(length(linearizedData));
    for idx=2:length(linearizedData);
        avg(idx)=alpha*avg(idx-1)+(1-alpha)*linearizedData(idx);
    end;
    % backward
    ravg=zeros(1,length(linearizedData));
    ravg(length(linearizedData))=linearizedData(length(linearizedData));
    for idx=length(linearizedData)-1:-1:2;
        ravg(idx)=alpha*ravg(idx+1)+(1-alpha)*linearizedData(idx);
    end;
    % slow moving averages are quite far behind the trend much of the time
    % for example, given a signal drifting up, the forward average will
    % be too low and the backward too high, but their average is centered
    % avg these together to find the center
    agAvg=mean([avg;ravg]);
   % de-trend (de-drift) the data
   data = linearizedData - agAvg';



autocorr=xcorr(data,300,'coeff');
windowedAutoCorr=(autocorr-mean(autocorr)).*hann(length(autocorr));
cvfft=fft([windowedAutoCorr; zeros(2^19-length(windowedAutoCorr),1)],2^19);
cvpower=cvfft.*conj(cvfft)/2^19;
f=0:(5/2^18):5;
plot(f(1:length(f)-1),log(cvpower(1:length(cvpower)/2)), 'g')


legend('3-10','3-5','2-23')
title('poewr spectrum over 3 days')
xlabel('Hz')
ylabel('log(power)')