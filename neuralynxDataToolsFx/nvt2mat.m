
function [xpos, ypos, xytimestamps, angles, header ]=nvt2mat(fname, recordStart, recordEnd)

if nargin < 2
    recordStart = 1;
end
if nargin > 1
    recordStart = floor(recordStart/512);
end
if nargin > 2
    recordEnd = floor(recordEnd/512); % the records come in blocks of 512, so specifying how many samples in will cause problems.
end

fid=fopen(fname,'r');
if fid==-1
    error('bad filename');
%     [fname, pathname, filterindex] = uigetfile('*.nvt', 'Pick an nvt file');
%     fid=fopen([pathname filesep fname],'r');
end

header=fread(fid,16384);
header=char(header');

% go to end of file to get filesize.
% note, that this info is also in the header... maybe in future do a double
% check of the header info and the file size.

fseek(fid, 0, 1);
pos=ftell(fid);

if recordStart <1
    recordStart = 1;
end

% go to the start of the data, after the header
fseek(fid, 16384+((recordStart-1)*1044), 'bof');

% the file is a 16K header with a bunch of records afterwards.
% 16*3+64+400*32+16+32*3+50*32 bits = 1828 bytes

num_recs=(pos-16384)/1828;

if mod(num_recs,1)>0
    warning('some bad records or sumptin')
    return;
elseif recordStart > num_recs
    warning('record start cannot be greater than the number of records in the file.');
    return;
end

if nargin < 3
    recordEnd = num_recs;
elseif recordEnd > num_recs
    recordEnd = num_recs;
elseif recordEnd < recordStart
    warning( [ 'recordStart is larger then recordEnd, defaulting to record 1 through ' num2str(recordEnd) ] );
    recordStart = 1;
end

recordsToRead = recordEnd - recordStart + 1;

% UInt16 swstx Value indicating the beginning of a record. Always 0x800 (2048).
% UInt16 swid ID for the originating system of this record.
% UInt16 swdata_size Size of a VideoRec in bytes.
% UInt64 qwTimeStamp Cheetah timestamp for this record. This value is in microseconds.
% UInt32[400] dwPoints Points with the color bitfield values for this record. This is a 400 element array. See Video Tracker Bitfield Information below.
% Int16 sncrc Unused*
% Int32 dnextracted_x  Extracted X location of the target being tracked.
% Int32 dnextracted_y Extracted Y location of the target being tracked.
% Int32 dnextracted_angle The calculated head angle in degrees clockwise from the positive Y axis. Zero will be assigned if angle tracking is disabled.**
% Int32[50] dntargets Colored targets using the samebitfield format used by the dwPoints array. Instead of transitions, the bitfield indicates the colors that make up each particular target and the center point of that target. This is a 50 element array sorted by size from largest (index 0) to smallest (index 49). A target value of 0 means that no target is present in that index location. See Video Tracker Bitfield Information below.
%
% 16*3+64+400*32+16+32*3+50*32 bits = 1828 bytes

swstx       = 0;                            % value indicating record start; always 0x800 (2048)
swid        = 0;                            % ID for originating system of record
swdata_size = 0;                            % Size of a VideoRec in bytes
xytimestamps = zeros( recordsToRead,   1 ); % timestamps
dwPoints    = 0;                            % Points with the color bitfield values for this record. This is a 400 element array. See Video Tracker Bitfield Information below.
sncrc       = 0;                            % Unused*
xpos        = zeros( recordsToRead,   1 ); % Extracted X location of the target being tracked.
ypos        = zeros( recordsToRead,   1 ); % Extracted Y location of the target being tracked.
angles      = zeros( recordsToRead,   1 ); % The calculated head angle in degrees clockwise from the positive Y axis. Zero will be assigned if angle tracking is disabled.**
dntargets   = 0;                            % Colored targets using the samebitfield format used by the dwPoints array.

% records 1 through records to read because we already moved the file to an
% appropriate location.

for recX=1:recordsToRead
    
    swstx             = fread( fid,   1, 'uint16' );
    swid              = fread( fid,   1, 'uint16' );
    swdata_size       = fread( fid,   1, 'uint16' );
    xytimestamps(recX) = fread( fid,   1, 'uint64' );  % timestamps
    dwPoints          = fread( fid, 400, 'uint32' );
    sncrc             = fread( fid,   1,  'int16' );
    xpos(recX)        = fread( fid,   1,  'int32' ); % Extracted X location of the target being tracked.
    ypos(recX)        = fread( fid,   1,  'int32' ); % Extracted Y location of the target being tracked.
    angles(recX)      = fread( fid,   1,  'int32' ); % The calculated head angle in degrees clockwise from the positive Y axis. Zero will be assigned if angle tracking is disabled.**
    dntargets         = fread( fid,  50,  'int32' );

end

% added to start all records at zero and convert to seconds.
%timestamps = ( timestamps - timestamps(1) ) / 1e6 ;
% the reason we aren't using relative time is because aligning spikes, LFPs
% events, and location won't work unless we have the original timestamps
% available.


% things are upsidedown, so this will flip them back around
% and then put the zeros back where they belong

%warning('unsafely assuming a 480x720 camera and inverting the y values because matlab will plot things from an underneath view otherwise');
%whereAreTheZeros=find(ypos==0);
%ypos=480-ypos;
%ypos(whereAreTheZeros) = 0;

fclose(fid);

return;

end