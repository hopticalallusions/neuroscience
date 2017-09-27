function [ events, eventTimestamps, header, eventTtl, eventIds ] = nev2mat( fname )

fid = fopen( fname, 'r' );
if fid == -1
    warning( 'bad filename' );
    [ fname, pathname, filterindex ] = uigetfile( '*.nev', 'Pick an nev file' );
    fid=fopen( [ pathname filesep fname ], 'r' );
end

header = fread( fid, 16384 );
header = char( header' );

% go to end of file to get filesize.
% note, that this info is also in the header... maybe in future do a double
% check of the header info and the file size.

fseek(fid, 0, 1);
pos=ftell(fid);

fseek(fid, 16384, 'bof');

% the file is a 16K header with a bunch of event records afterwards.
% each Event record is 3*16+64+5*16+8*32+128*8(?) bits = 1248 bytes
%
% Int16       - n/a
% Int16       - n/a
% Int16       - 2
% UInt64      - timestamp, us
% Int16       - id
% Int16       - decimal ttl
% Int16       - n/a
% Int16       - n/a
% Int16       - n/a
% Int32[8]    - n/a
% String[128] - event string

% 1+ because there is a null record at the end
numberOfRecords=(pos-16384)/((3*16+64+5*16+8*32+128*8)/8);

if mod(numberOfRecords,1)>0
    warning('Non-integer number of records!')
    return;
end

% rewind to the start of data 
fseek(fid, 16384, 'bof');

% set up data structures to capture things
eventTimestamps = zeros( numberOfRecords, 1 );
eventIds = zeros( numberOfRecords, 1 );
eventTtl = zeros( numberOfRecords, 1 );
events = repmat( {''}, numberOfRecords, 1 );

for idx = 1:numberOfRecords
    nstx                 = fread( fid, 1, 'int16' );
    npkt_id              = fread( fid, 1, 'int16' );
    npkt_data_size       = fread( fid, 1, 'int16' ); % should always be 2???
    eventTimestamps(idx) = fread( fid, 1, 'uint64' );%%
    eventId(idx)         = fread( fid, 1, 'int16' );%%
    evttl(idx)           = fread( fid, 1, 'int16' );%%
    ncrc                 = fread( fid, 1, 'int16' ); % n/a
    ndummy1              = fread( fid, 1, 'int16' ); % n/a
    ndummy2              = fread( fid, 1, 'int16' ); % n/a
    dnExtra              = fread( fid, 8, 'int32' ); % n/a
    events(idx)          = cellstr( fread( fid, 128, '*char')' );%%
end

% added to start all records at zero and convert to seconds.
%eventTimestamps = ( eventTimestamps - eventTimestamps(1) ) / 1e6 ;
% can't align the timestamps across files if we zero them relative to this
% file

fclose(fid);

% for recX=1:numberOfRecords
%    timestamps(recX)=fread(fid, 1, 'int64');
%    events(recX,:)=cellstr(fread(fid,512,'char'));
% end
return;