function [ chData ] = loadCExtractedNrdChannelData( filename )

    % WARNING : this is an extremely barebones function that assumes it 
    % has been called correctly 
    
    channelsFileId=fopen( filename,'r');
    % Let's pull all the data points at once
    %
    % first figure out how many bytes long the file is
    fseek(channelsFileId, 0, 'eof'); %1
    % then determine how many data points there are
    dataPoints=ftell(channelsFileId)/4;
    % rewind the file to the beginning
    fseek(channelsFileId, 0, 'bof');
    % read the data
    chData = fread( channelsFileId, dataPoints, 'int32' );
    % close the file
    fclose(channelsFileId);
    
    chData = chData * 0.000015624999960550667 ; 
    
    return;
end