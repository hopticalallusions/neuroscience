function [data, header ]=tarheel2mat(fname)

fid=fopen(fname,'r');
if fid==-1
    warning('bad filename');
%    [fname, pathname, filterindex] = uigetfile('*.Ncs', 'Pick an CSC file');
%    fid=fopen([pathname filesep fname],'r');
    return;
end

header=fread(fid,10000);
header=char(header');

data = fread( fid, 250000, 'short' );

fclose(fid);

return;

end