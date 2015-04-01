experiment=[];
if length(findstr(rawpath,'analysis'))>0  %use data analysis folder
    b=strfind(rawpath,'\');
    if isempty(b)
        b=strfind(rawpath,'/');
    end
    experiment=rawpath((b(2)+1):b(3)-1);
    subject=rawpath((b(3)+1):b(4)-1);
    datei=rawpath((b(4)+1):b(5)-1);
    filename=rawpath((b(5)+1):b(6)-1);
else
    a=strfind(rawpath,'\');
    if isempty(a)
        a=strfind(rawpath,'/');
    end
    b=strfind(rawpath,'Training');
    if length(b)==0
        b=strfind(rawpath,'Licking');
    end
    if length(b)==0
        b=strfind(rawpath,'Optogenetics');
    end
    if length(b)==0
        b=strfind(rawpath,'Pavlovian');
    end
    if length(b)==0
        b=strfind(rawpath,'Instrumental');
    end
    if length(b)==0
        b=strfind(rawpath,'Learning');
    end
    if length(b)==0
        b=strfind(rawpath,'Behavior');
    end
    if length(b)==0
        b=strfind(rawpath,'cluster');
    end
    if length(b)==0
        disp(['Error in data directory name. It must contain a recognized experiment name. Refer to recall_rawpath.m for options or to modify list of recognized experiment names.'])
        break
    end
    if length(a)==5
        datei=rawpath(((a(4)+1):(a(5)-1)));
    elseif length(a)==4
        datei=rawpath(((a(3)+1):(a(4)-1)));
    else
        datei = 'Jan1';
    end
    c=strfind(rawpath,datei);
    %d=strfind(fname,'_t');
    %filename=fname(1:(d-1));
    experiment=rawpath(((a(2)+1):((a(3)-1))));
    subject=rawpath((b+9):(c-2));
    % date=rawpath(((a(4)+1):((a(5)-1))));
end
