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
% leaving 10,000 bytes for a header
%
% I can't figure the header out quickly. It has some regular structure.
% Using the hex dump program "od" helps
% od -t c /Volumes/AGHTHESIS2/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_100100 |less
% there is definitely regular structure, but I don't know what it is.
% the end has a bunch of nulls
% od -t c -N 10000 /Volumes/AGHTHESIS2/andrewhowe_blairlab/V4/3-5-2015/run/platter/3-5-2015platter-left-ch1_100100 | tail -n 20

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


%% Header Information Includes
%
% Total points in buffer 1000
% Waveform 0 -0.4
% Offset (V) 0.1
% Multiplier 4
% Width of Waveform 8.5
% Actual Scan Rate V/s 400
% Actual Update Rate 117647
% CV Frequency Hz 10
% User Header Information 
% Pre Stim/FIA Scans 50
% Post Stim/FIA Scans 100
% NUm Channels 1
% Channel List 0 2
% Gain Multiplier 0 0.061035
% STIM of FIA 3
% FIA Scans 50
% nA/V Array 0 200
% vSTIM File
% STIM Freq

% Waveform  <possily 1000 numbers>