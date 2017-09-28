function [zoneCoords, zoneNames]=nzv2mat(fname)

% int currentZone
% int numberOfZones
% int zone0 left_coordinate   xmin
% int zone0 top_coordinate    ymin
% int zone0 right_coordinate  xmax
% int zone0 bottom_coordinate ymax
% int zone1 left_coordinate
% ?
% int zone49 bottom_coordinate
% char[128] zone0_name
% char[128] zone1_name
% ?
% char[128] zone49_name
% 
% The end of the file is just some values for how things are displayed in the program

if nargin > 1
    disp('Ignoring extraneous arguments');
end

fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
    [fname, pathname, filterindex] = uigetfile('*.nzv', 'Pick an nzv file');
    fid=fopen([pathname filesep fname],'r');
end

currentZone=fread( fid,   1, 'int32' );
numberOfZones=fread( fid,   1, 'int32' );
zoneCoords=zeros(numberOfZones,4);
zoneNames=cell(numberOfZones,1);
for zoneIdx = 1:numberOfZones
    zoneCoords(zoneIdx,:)=fread(fid,4,'int32');
end
% there are 5 blank zone name entries?
for zoneIdx = 1:5
    char(fread(fid,128,'char*1')'); % this is a lazy way to advance the file position
end
for zoneIdx = 1:numberOfZones
    zoneNames{zoneIdx}=(char(fread(fid,128,'char*1')'));
end
%zoneNames = strtrim(cellstr(zoneNames));
fclose(fid);
return;
end