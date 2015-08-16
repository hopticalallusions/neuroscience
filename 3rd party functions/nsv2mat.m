function [events, timestamps, header]=nev2mat(fname)

fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
    [fname, pathname, filterindex] = uigetfile('*.nev', 'Pick an nev file');
    fid=fopen([pathname filesep fname],'r');
end

header=fread(fid,16384);
header=char(header');

% go to end of file to get filesize.
% note, that this info is also in the header... maybe in future do a double
% check of the header info and the file size.

fseek(fid, 0, 1);
pos=ftell(fid);

fseek(fid, 16384, 'bof');

% the file is a 16K header with a bunch of CSC records afterwards.
% each CSC record is 64+32+32+32+512*16 bits = 1044 bytes

num_recs=(pos-16384)/1044;

if mod(num_recs,1)>0
    warning('some bad records or sumptin')
    return;
end

timestamps=zeros(num_recs, 1);
events={};

for recX=1:num_recs
    timestamps(recX)=fread(fid, 1, 'int64');
    events(recX,:)=fread(fid,512,'int16');
end

csc.ts=timestamps;
if numel(unique(channel))==1
csc.channel=channel(1);
else
    warning('WIERD channel information')
    csc.channel=channel;
end

if numel(unique(sampFreq))==1
csc.sampFreq=sampFreq(1);
else
    warning('WIERD sampFreq infomation')
    csc.sampFreq=sampFreq;
end

if sum(nValSamp < 512) 
    warning('some of the records have fewer than 512 valid samples!');
end

csc.nValSamp=nValSamp;
csc.data=data;
csc.hd=header;
