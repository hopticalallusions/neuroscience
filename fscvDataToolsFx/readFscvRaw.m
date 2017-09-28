function [ data, header ]=readFscvRaw(fname)

warning('This function DOES NOT fully work yet; it decodes the data, but not the header.')

% 
% 1,210,000 bytes
% 
% 60 * 10 = 600 records
% 1000 pts per record
% 
% 600,000 data points
% 1,200,000 2 byte floats
% leaving 10,000 bytes for a header???
%

fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
    [fname, pathname, filterindex] = uigetfile('*', 'Pick a file');
    fid=fopen([pathname filesep fname],'r');
end

header='none';

fseek(fid, 0, 1);
pos=ftell(fid);

% go to the start of the data, after the header
fseek(fid, 10000, 'bof');

data             = (fread( fid, 'int16', 'b' ));

data = reshape(data, 1000, length(data)/1000);

fclose(fid);

return;

