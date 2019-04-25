function [ timeElapsedSeconds, timestamp ]=smi2mat( dirname, VTstream )

% this function turns an SMI file from a video into 2 vectors to allow
% accurate alignment of behavioral data
%
% first column : milliseconds elapsed time in video
% second column : microsecond timestamps
%
% function returns elapsed video time in seconds and timestamp in 64 bit
% UINT elapsed microseconds (Neuralynx timestamp format)
%

%fname = [ '/Volumes/AGHTHESIS2/rats/h1/2018-08-09/' 'VT1.smi' ]


if nargin < 2
    VTstream = 1;
end


% run in "directory mode"
if 7 == exist( dirname, 'dir')
    fname = [ dirname 'VT' num2str(VTstream) '.smi' ];
end

timeElapsedSeconds = [];
timestamp = [];

fileIndexer = 1;

% run in "file mode"
while ( 2 == exist( fname, 'file') )

%    fhandle=fopen(fname,'r');
%    if fhandle==-1
%        error('bad filename');
%    end
%    filecontents = fread(fhandle); %, 'char*1');
    filecontents = fileread(fname);
%    fclose(fhandle);

    %class(filecontents)
    
    tokens = regexp(filecontents,'<SYNC Start=([0-9]+)> <P Class = ENUSCC>([0-9]+)</SYNC>','tokens');

    timeElapsedSecondsT = zeros(1,length(tokens));
    timestampT = zeros(1,length(tokens));
    for ii=1:length(tokens)
        timeElapsedSecondsT(ii) = str2num(tokens{ii}{1})/1e3;
        timestampT(ii) = str2num(tokens{ii}{2});
    end
    
% % removed because when processing multiple files, there are gaps in time
% in the timestamp stream, but not in the video file. Things get messed up
% later if this is not taken into account (see below)
% 
% %
%     if isempty(timeElapsedSeconds)
%         timeElapsedSeconds = [ timeElapsedSeconds timeElapsedSecondsT ];
%     else
%         timeElapsedSeconds = [ timeElapsedSeconds timeElapsedSecondsT+timeElapsedSeconds(end) ];
%     end

     timestamp = [ timestamp timestampT ];

    fname = [ dirname 'VT'  num2str(VTstream) '.000' num2str(fileIndexer) '.smi' ];
    fileIndexer = fileIndexer + 1;
    if fileIndexer > 9
        warning('The developer lacked cookies which made him slightly lazy so you probably need to modify this code to enable more SMI files.')
    end
    
end

timeElapsedSeconds = ( timestamp - timestamp(1) )/1e6;