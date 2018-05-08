function [ spikeWaveforms, spikeTimestamps, spikeHeader, ttNumber, cellNumber, selectedFeatures ] = ntt2mat(fname, recordStart, recordEnd)

if nargin < 2
    recordStart = 1;
end

%!! see below for header if parsing later is desired

fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
    [fname, pathname, filterindex] = uigetfile('*.Ntt', 'Pick an CSC file');
    fid=fopen([pathname filesep fname],'r');
end

spikeHeader=fread(fid,2^14); %16kB header
spikeHeader=char(spikeHeader');

% go to end of file to get filesize.
% note, that this info is also in the header... maybe in future do a double
% check of the header info and the file size.

fseek(fid, 0, 1);
pos=ftell(fid);

if recordStart <1
    recordStart = 1;
end

% go to the start of the data, after the header
fseek(fid, 16384+((recordStart-1)*304), 'bof');
%38 bytes, brah
% the file is a 16K header with a bunch of CSC records afterwards.
% each tt record is 64+32+32+32*8+16*32*4 bits = 2432 bits / 8 bits-per-byte = 304 bytes

num_recs=(pos-16384)/304;

if mod(num_recs,1)>0
   warning('record count is non-integer! bad records?')
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

spikeTimestamps  = zeros( recordsToRead, 1     );
ttNumber         = zeros( recordsToRead, 1     );
cellNumber       = zeros( recordsToRead, 1     );
selectedFeatures = zeros( recordsToRead, 8     );
spikeWaveforms   = zeros( recordsToRead, 4, 32 );

% records 1 through records to read because we already moved the file to an
% appropriate location.

for recX=1:recordsToRead

    spikeTimestamps( recX )     = fread( fid,  1, 'uint64' );
    ttNumber( recX )            = fread( fid,  1, 'uint32' );
    cellNumber( recX )          = fread( fid,  1, 'uint32' );
    selectedFeatures( recX, : ) = fread( fid,  8, 'uint32' );
    % wrap this in a for loop fixed at 4 waveforms
    for tidx = 1:32 % assuming this is a tettrode
        tdata                   = fread( fid,  4, 'int16'  ); % 32 points x 4 channels per waveform
        spikeWaveforms( recX, :, tidx )   = tdata;
    end
end

fclose(fid);

% tmpIdx = strfind(spikeHeader, 'ADBitVolts');
% ADBitVolts = sscanf(spikeHeader(tmpIdx(1) + length('ADBitVolts'):end), '%g %g %g %g', 1);
% data = data * ADBitVolts * 1000; % milivolts


return;

end

% actually, this depends on what version of neuralynx this is.

% ######## Neuralynx Data File Header
% 
% ## File Name: C:\CheetahData\Theta12_square_circle_Day10\01. File Beginning To 357771370189\TT4.ntt
% 
% ## Time Opened: (m/d/y): 8/21/2015 At Time: 16:39:50.476
% 
% 	-FileType	Spike
% 
% 	-FileVersion	3.3.0
% 
% 	-RecordSize	304
% 
% 	-CheetahRev	5.6.0
% 
% 	-HardwareSubSystemName	AcqSystem1
% 
% 	-HardwareSubSystemType	DigitalLynxSX
% 
% 	-SamplingFrequency	32000
% 
% 	-ADMaxValue	32767
% 
% 	-ADBitVolts	0.000000004577776380187970	0.000000004577776380187970	0.000000004577776380187970	0.000000004577776380187970
% 
% 	-AcqEntName	TT4
% 
% 	-NumADChannels	4
% 
% 	-ADChannel	12	13	14	15
% 
% 	-InputRange	150	150	150	150
% 
% 	-InputInverted	True
% 
% 	-DSPLowCutFilterEnabled	True
% 
% 	-DspLowCutFrequency	600
% 
% 	-DspLowCutNumTaps	64
% 
% 	-DspLowCutFilterType	FIR
% 
% 	-DSPHighCutFilterEnabled	True
% 
% 	-DspHighCutFrequency	6000
% 
% 	-DspHighCutNumTaps	32
% 
% 	-DspHighCutFilterType	FIR
% 
% 	-DspDelayCompensation	Disabled
% 
% 	-DspFilterDelay_µs	1468
% 
% 	-WaveformLength	32
% 
% 	-AlignmentPt	8
% 
% 	-ThreshVal	40	40	40	40
% 
% 	-MinRetriggerSamples	24
% 
% 	-SpikeRetriggerTime	750
% 
% 	-DualThresholding	False
% 
% 	-Feature	Valley	7	3	0	31