%function daConcData = rebaselineTarheelCsvData( folderpath, alpha )

    %dir='B:\Users\UCLA\Desktop\andrewhowe_blairlab\V4\3-10-2015\run\platterSimple\BATCH_PC\STACKED_PC\';
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-23-2015\run\maze\BATCH_PC\STACKED_PC\';
    
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-20-2015\run\maze\BATCH_PC\STACKED_PC';
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-20-2015\run\platterSync\BATCH_PC\STACKED_PC';
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-20-2015\run\platterNoSync\BATCH_PC\STACKED_PC';

    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-19-2015\run\BATCH_PC\STACKED_PC';
    % nice looking stuff here!
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-10-2015\run\maze\BATCH_PC\STACKED_PC';
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-10-2015\run\platterSimple\BATCH_PC\STACKED_PC';
    
    
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-6-2015\run\maze\BATCH_PC\STACKED_PC'; % board pop-out
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-6-2015\run\platterSimple\BATCH_PC\STACKED_PC'; % looks nice
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-6-2015\run\platterSequence\BATCH_PC\STACKED_PC'; % looks nice
    
    % might be good?
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-5-2015\run\maze\BATCH_PC\STACKED_PC'; % pop out but not terrible
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-5-2015\run\platter\BATCH_PC\STACKED_PC'; % pop out but not terrible
        
    % Something really weird happened here after about 35 minutes!!!
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\2-24-2015\run\BATCH_PC\STACKED_PC\'
    
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\platter\BATCH_PC\STACKED_PC'; %%%
    folderpath = 'B:\fscv\andrewhowe_blairlab\V4\3-11-2015\run\maze\BATCH_PC\STACKED_PC';%%%

    
    filename='\Stacked_Cal';
    %filename='\Stacked_pH';
    fullpath = [folderpath filename];

    alpha = .997;

    stackedData=load(fullpath);
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
    deNaNedStackData = stackedData;
    % FSCV probes drift over time.
    % each file (column) is re-baselined
    % this step produces continuous data without hard jumps
    % ("rebaselining" in Wassum lab terminology)
    for col = 2:dims(2) 
        offset=mean(stackedData(dims(1)-9:dims(1),col-1)); % Kate recommends rebaselinging on the prior 10 samples.
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
    %
    % avg these together to find the center
    agAvg=mean([avg;ravg]);
    
    
   % de-trend (de-drift) the data
   daConcData = linearizedData - agAvg';
   
   %generate a nice x vector in minutes
   xx = [0:.1:(length(daConcData)-1)/10]/60;
   
   axisArgument = [ 0-(max(xx)*.03) (max(xx)*1.03) min([ deNaNedStackData(:) ; linearizedData; daConcData ] ) max([ deNaNedStackData(:); linearizedData; daConcData ] ) ];
   %fxfh = figure('Visible', 'Off');
   figure;
   subplot(3,1,1);
   plot( xx, deNaNedStackData(:), 'Color', [ .6 .6 .6 ] );
   ylabel('DA (nM)');
   title('Reprocess FSCV data to Continuous DA Concentration');
   legend('original','Location','northwest');
   axis(axisArgument);
   subplot(3,1,2);
   hold on;
   plot( xx, linearizedData, 'Color', [ 0 0.6 0.8 ] )
   plot( xx, agAvg, 'Color', [ 1 0 0 ] )
   plot( xx, avg, '--', 'Color', [ 0 0 0 ] )
   plot( xx, ravg, '--', 'Color', [ 0 0 0 ] )
   legend('rebaselined','center','mv avgs','Location','northwest')
   ylabel('DA (nM)');
   axis(axisArgument);
   subplot(3,1,3);
   plot( xx, daConcData, 'Color', [ .8 0 .2 ] )
   legend('corrected','Location','northwest');
   ylabel('DA (nM)');
   axis(axisArgument);
   xlabel('time (minutes)');
   
   % save data and print the figure   
   save( [ folderpath '\daConcData.mat' ],'daConcData')
   print([ folderpath '\daConcData.fig' ]) ;
   
%end


