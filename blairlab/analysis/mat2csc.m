function mat2csc( fname, path, header, data, timestamps, channel, nValSamp, sampFreq )

% ahowe April 2015

if nargin ~= 8
    disp('wrong number of input arguments!!!')
    return;
end

fid=fopen([path filesep fname],'w');
if fid==-1
    warning('bad filename; could not open specified location. quiting...');
    return;
    %[fname, pathname, filterindex] = uigetfile('*.Ncs', 'Pick an CSC file');
    %uisave(
    %fid=fopen(,'r');
end

fwrite(fid, header, 'uchar');

% go to the start of the data, after the header
%fseek(fid, 16384+((recordStart-1)*1044), 'bof');
%fseek(fid, 16384, 'bof');

% the file is a 16K header with a bunch of CSC records afterwards.
% each CSC record is 64+32+32+32+512*16 bits = 1044 bytes

if mod(length(data),512) ~= 0
    warning('bad news. things are not working. Sample data is not divisble evenly by 512')
end

recordsToRead = length(data)/512;
data = reshape( data, 512, recordsToRead )';

if length(channel) > 1 
    if sum(channel~=channel(1)) > 1 
        warning('yo, there are multiple channels in channel! defaulting to the first one.');
    end
    channel = channel(1);
end

if length(sampFreq) > 1 
    if sum(sampFreq~=sampFreq(1)) > 1 
        warning('yo, there are multiple channels in sampFreq! defaulting to the first one.');
    end
    sampFreq = sampFreq(1);
end

if length(nValSamp) > 1 
    if sum(nValSamp~=nValSamp(1)) > 1 
        warning('yo, there are multiple channels in nValSamples! defaulting to the first one.');
    end
    nValSamp = nValSamp(1);
end

timestamps = downsample( timestamps, 512);

for recX=1:recordsToRead
    fwrite( fid, timestamps(recX), 'int64' ); % timestamps
    fwrite( fid,          channel, 'int32' ); % channel
    fwrite( fid,         sampFreq, 'int32' ); % sample freq
    fwrite( fid,         nValSamp, 'int32' ); % nValSamp
    fwrite( fid,     data(recX,:), 'int16' ); % data
end

return;

end