datadir = 'E:\CheetahData\A36\2018-10-15_15-20-35_mscam3\';
fid = fopen([datadir 'VT1.smi']);

line_ex = fgetl(fid);  % read line excluding newline character
while ~(line_ex(3)=='Y')
    line_ex = fgetl(fid);  % read line excluding newline character
    while length(line_ex)<3
        line_ex = fgetl(fid);  % read line excluding newline character
    end
end

s=strfind(line_ex,'ENUSCC>');
e=strfind(line_ex,'</SYNC>');
tpos(1)=uint64(str2num(line_ex((s+7):(e-1))));
dex=2;
while ~(feof(fid))
    line_ex = fgetl(fid);  % read line excluding newline character
    s=strfind(line_ex,'ENUSCC>');
    e=strfind(line_ex,'</SYNC>');
    try
    tpos(dex)=uint64(str2num(line_ex((s+7):(e-1))));
    dex=dex+1;
    catch
        [num2str(dex) ' was  bad line']
    end
end

fclose(fid);