%function [ data, timestamps, header ] = nrd2mat( fname, recordStart, recordEnd )
%TODO make it possible to extract data from just certain channels
%% FIX ARGUMENTS
% TODO fix more silly things that could be provided as arguments.

%testing...
nargin=1;
%fname='/Users/andrewhowe/Downloads/DemoNeurodata.nrd';
%fname='/Users/andrewhowe/blairLab/DigitalLynxSXRawDataFile.nrd';
basedir='/Users/andrewhowe/Downloads/da5fscEphysRecheck/';
fname=[basedir 'DigitalLynxSXRawDataFile.nrd'];
channelsRequested=1:32;

% TODO if channalesRequested doesn't exist, make it equal [1:NumADChannels]
% somewhere below

if nargin < 2
    recordStart = 1;
end
% error checking
if recordStart <1
    recordStart = 1;
end


%% OPEN THE FILE
%TODO -- type check the file for corrcet extension?
fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
    [ fname, pathname ] = uigetfile('*.nrd', 'Pick an CSC file');
    fid=fopen([pathname filesep fname],'r');
end

%% EXTRACT THE HEADER
header=fread(fid,2^14);
header=char(header')


%% PARSE THE HEADER
% attempt to extract the number of AD channels so we know the width of the
% data portion of these records.
tt = regexp( strcat(header), 'NumADChannels\s+(?<NumADChannels>[0-9]+)\s+', 'names' );
NumADChannels=str2num(tt.NumADChannels);
% TODO -- check that this is some kind of reasonable number
% it should be an even power of 2?

if ( max(channelsRequested) > NumADChannels )
    warning('Channels Requested contains a channel higher than the number of channels available, defaulting to all channels.');
    channelsRequested = [1:NumADChannels];
elseif ( min(channelsRequested) < 1 )
    warning('Channels Requested contains a channel lower than 1, defaulting to all channels.');
    channelsRequested = [1:NumADChannels];
end

%% ESTIMATE THE NUMBER OF RECORDS
% go to end of file to get filesize.

% the file is a 16kB header with a bunch of CSC records afterwards.
% each nrd record is 32+32+32+32+32+32+32+10*32+n*32+32 bits = 576 + n*32 bits / 8 bits-per-byte = 304 bytes
bytesPerRecord=((18+NumADChannels)*32 )/ 8;
fseek(fid, 0, 1);
pos=ftell(fid);
num_recs=(pos-16384)/bytesPerRecord;

if mod(num_recs,1)>0
   warning('Fractional number of records detected! Expect more errors.')
elseif recordStart >= floor(num_recs)
   warning('record start cannot be greater than or equal to the number of records in the file.');
   return;
end

% rationality check argument 3
if nargin < 3
    recordEnd = ceil(num_recs); % ceiling because we expect some bad partial record possibly in the middle of things
elseif recordEnd > ceil(num_recs)
    recordEnd = ceil(num_recs);
elseif recordEnd < recordStart
    warning( [ 'recordEnd is larger then recordEnd, defaulting to record 1 through ' num2str(recordEnd) ] );
    recordEnd = ceil(num_recs);
    recordStart = 1;
end

%% BEGIN READING DATA
% seek start of data section
fseek(fid, 16384, 'bof');
% TODO make this not start at one, perhaps by doing the below and throwing
% out records until the right position is reached or something like that.
%
% the file is a 16kB header with a bunch of CSC records afterwards.
% each nrd record is 32+32+32+32+32+32+32+10*32+n*32+32 bits = 576 + n*32 bits / 8 bits-per-byte = 304 bytes
% go to the start of the data, after the header
%%%%% fseek(fid, 16384+((recordStart-1)*304), 'bof');
% note, there is no simple way to "zoom" these files! this will need to
% involve something like iteratively reading through to get the next record_start
% and packet_size fields to figure out how far to zoom (actually, maybe
% these files are zoomable once the first record has been read


recordsToRead = ceil(recordEnd) - recordStart + 1
%recordsToRead = 32000;
timestamps = zeros( recordsToRead, 1 );
%data = zeros( NumADChannels, recordsToRead);
data = zeros( length(channelsRequested), recordsToRead);
goodRecordsRead = 0;
dataWordsSkipped = 0;

while ( ~feof(fid) ) %&& ( goodRecordsRead < recordsToRead ) )
    % check for start of record 
    startTransmission          = fread( fid,        1,  'int32' );  % almost useless, always == 2048
    if startTransmission == 2048;
        %disp(startTransmission)
        % check for second field
        packetId                   = fread( fid,        1,  'int32' );  % almost useless, always == 1
        if packetId == 1;
            % check for packet size (data size) consistency (see Nlx
            % file specification)
            packetSize                 = fread( fid,        1,  'int32' );  % almost useless, always == 10 + num_channels
            % we know that this should always be true
            if packetSize == 10 + NumADChannels 
                % I. attempt to read the whole record and OR everything
                % together to check integrity
                % 1. rewind
                % we have read 3 32-bit integers which are 4 bytes each
                pos = ftell(fid);
                fseek(fid, pos-(3*4), 'bof');
                % 2. initialize the integrity check result
                tempCrc = uint64(fread( fid,1, 'uint32' ));
                %s1 = 'read value %10d is %64s in binary\n';
                %fprintf(s1,tempCrc,dec2bin(tempCrc))
                %because matlab doesn't seem to want to allow me to force
                %it to use a reasonable data type... it's stuffing this 32
                %bit integer into a double, so when I force it into unint32
                %to make the bitwise OR work, it gives me 2 freakin
                %numbers.
                % 3. bitwise OR every entry
                for idx=2:(18+NumADChannels)
                    % I'm not actually certain I need to recast these to
                    % uint64, but this is currently working.
                    tempEntry = uint64(fread( fid, 1, 'uint32' ));
                    % WARNING : The Neuralynx documentation says this is an
                    % OR but that is incorrect, it is an XOR
                    tempCrc = bitxor((tempCrc),(tempEntry));
                    %fprintf(s1,tempEntry,dec2bin(tempEntry))
                end
                % 4. check the result
                if tempCrc ~= 0
                    % go back to 1 entry after the bogus record start and
                    % keep trying
                    pos = ftell(fid);
                    fseek(fid, pos-(4*(17+NumADChannels)), 'bof');
                    dataWordsSkipped = dataWordsSkipped+1;
                else
                    % II. extract the record
                    % 1. rewind
                    pos = ftell(fid); % yes, it's redundant with the one in the if statement, but this is clear.
                    fseek(fid, pos-(4*(18-3+NumADChannels)), 'bof'); % we already read the first three
                    goodRecordsRead = goodRecordsRead + 1;
                    timestampHighbits          = fread( fid,        1, 'uint32' ); % half of a 64 bit number
                    timestampLowbits           = fread( fid,        1, 'uint32' ); % half of a 64 bit number
                    status                     = fread( fid,        1,  'int32' ); % almost useless? "reserved" whatever that means
                    TTLState                   = fread( fid,        1, 'uint32' ); % parallel port input, 2^32 states, but only 32 signals
                    extras                     = fread( fid,       10,  'int32' ); % magical hardware codes
                    dataframe                  = fread( fid, NumADChannels,  'int32' ); % read the whole frame
                    data(:,goodRecordsRead)    = dataframe( channelsRequested ); % select the requested channels
                    crc                        = fread( fid,        1,  'int32' ); % check sum value
                    % combine the timestamps into a 64 bit integer
                    %
                    % TODO (?) can't this simply be read as a 64 bit uint
                    % directly?
                    % TODO -- there's no checking or correction provided
                    % for out of order records here. fix this at some
                    % point.
                    timestamps(goodRecordsRead) = bitshift(uint64(timestampHighbits),32)+uint64(timestampLowbits);
                    % try to read the timestamps and guess where the
                    % appropriate one will be and then gradient descent or
                    % birthday guess to it.
                end
            end
        end
    end

end
fclose(fid);


save( [basedir 'nrdTimestamps.mat'], 'timestamps' );
save( [basedir 'nrdData.mat'], 'data' );
save( [basedir 'nrdChannels.mat'], 'channelsRequested' );

%return;
%end

%                   %let's assume this was correct, but check anyway.
%                     crcResult = startTransmission;
%                     crcResult = bitor(crcResult, PacketId);
%                     crcResult = bitor(crcResult, packetSize);
%                     crcResult = bitor(crcResult, timestampHighbits);
%                     crcResult = bitor(crcResult, timestampLowbits);
%                     crcResult = bitor(crcResult, status);
%                     crcResult = bitor(crcResult, TTLState);
%                     crcResult = bitor(crcResult, extras);
%                     crcResult = bitor(crcResult, data);
%                     crcResult = bitor(crcResult, crc);
% 
%                     if crcResult ~= 0
%                         warning ('bad record! moving on...');
%                     end