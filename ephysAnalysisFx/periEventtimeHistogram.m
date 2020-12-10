function output = periEventtimeHistogram( eventSequence, dataTimes, windowSize, divisionSize )
    % let's assume this is all in seconds.
    output=zeros(ceil((2*windowSize)/divisionSize)+1, 1);
    
    
    for ii=1:length(eventSequence)
        %if eventSequence(ii) < windowSize/2
        %    disp('skipping event')
        %end
        temp = dataTimes - eventSequence(ii);
        idxs = floor((temp( find((temp>=-windowSize).* (temp<=windowSize) ))+windowSize)/divisionSize)+1;
        for jj=1:length(idxs)
            output(idxs(jj)) = output(idxs(jj))+1;
        end
    end
end
