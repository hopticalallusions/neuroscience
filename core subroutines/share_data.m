disp(['current computer analysis drive name: ' analysisdrivename])

if exist('sharedrivestring','var')>0 
    oldsharedrivestring=sharedrivestring;
    if length(sharedrivestring)>0
    sharedrivestring=input(['Select network drives on which to split channelsets (separated by space) [' sharedrivestring ']: '],'s');
    end
else 
    oldsharedrivestring='';
    sharedrivestring=input(['Select network drives on which to split channelsets (separated by space) [none]: '],'s');
end

if isempty(sharedrivestring)==1
sharedrivestring=oldsharedrivestring;
end

sharedrives=[];
if length(findstr(sharedrivestring,analysisdrivename))==0   
sharedrives{1}=analysisdrivename;
    for i=1:(length(sharedrivestring)-length(findstr(sharedrivestring,' ')))
        stringpos=2*i-1;
        sharedrives{i+1}=sharedrivestring(stringpos);
    end
else 
    for i=1:(length(sharedrivestring)-2)
        stringpos=2*i-1;
        sharedrives{i}=sharedrivestring(stringpos);
    end
end


disp(['Sharing files among specified network drives (not overwriting existing files).'])
for sourcedriveind=1:length(sharedrives);
    sourcedrive=sharedrives{sourcedriveind};
    
    sourcedir=[sourcedrive ':\muxi data\' experiment '\' subject '\' datei '\'];
    sourcefiles=dir([sourcedir '*' filename '*']);
    
    for targetdriveind=1:length(sharedrives);
    targetdrive=sharedrives{targetdriveind};
    if sourcedrive==targetdrive
        continue
    end
    disp(['source drive: ' sourcedrive ' --> target drive: ' targetdrive])
   
    targetdir=[targetdrive ':\muxi data\' experiment '\' subject '\' datei '\'];
    mkdir(targetdir)
        numberofcopiedfiles=0;
        for i=1:length(sourcefiles)
             sourcefilei=sourcefiles(i).name;
             if exist([targetdir sourcefilei],'file')==0
             [SUCCESS,MESSAGE,MESSAGEID]=copyfile([sourcedir sourcefilei],[targetdir sourcefilei]);     
             disp(['copied ' sourcefilei])
             numberofcopiedfiles=numberofcopiedfiles+1;
             end    
        end
    disp(['Copied ' num2str(numberofcopiedfiles) ' files from ' sourcedrive ' to ' targetdrive '.'])
    
    end
    
end
disp(['Done sharing files among specified network drives.'])        