disp(['This electrode array (' probetype ') has ' num2str(length(channelsets)) ' unique channelsets.'])

dosplit=[];                              
dosplit=input('Split channel sets on multiple network-connected computers (y/n)? [n] ','s');  %answering no allows user to execute individual programs.  Answering yes will automatically run through all possible subroutines in order of appearance below.
if isempty(dosplit)==1
dosplit='n';
end

if dosplit=='y'
    masterdrive=[];
    masterdrive=input(['Specify master network drive on which all final spiketime analysis will be copied prior to running get_final_units [' analysisdrivename ']: '],'s'); 
    if isempty(masterdrive)==1
    masterdrive=analysisdrivename;
    disp(['master drive is ' masterdrive])
    end
    
save([savedir 'dosplit.mat'], 'dosplit','-mat')

if masterdrive==analysisdrivename
    
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
    for i=1:(length(sharedrivestring))
        stringpos=2*i-1;
        sharedrives{i}=sharedrivestring(stringpos);
    end
end

% disp(['Sharing files among specified network drives (not overwriting existing files).'])
% for sourcedriveind=1:length(sharedrives);   
%     sourcedrive=sharedrives{sourcedriveind};
%     
%     sourcedir=[sourcedrive ':\muxi data\' experiment '\' subject '\' datei '\'];
%     sourcefiles=dir([sourcedir '*' filename '*']);
%     
%     for targetdriveind=1:length(sharedrives);
%     targetdrive=sharedrives{targetdriveind};
%     if sourcedrive==targetdrive
%         continue
%     end
%     disp(['source drive: ' sourcedrive ' --> target drive: ' targetdrive])
%    
%     targetdir=[targetdrive ':\muxi data\' experiment '\' subject '\' datei '\'];
%     mkdir(targetdir)
%         numberofcopiedfiles=0;
%         for i=1:length(sourcefiles)
%              sourcefilei=sourcefiles(i).name;
%              if exist([targetdir sourcefilei],'file')==0
%              [SUCCESS,MESSAGE,MESSAGEID]=copyfile([sourcedir sourcefilei],[targetdir sourcefilei]);     
%              disp(['copied ' sourcefilei])
%              numberofcopiedfiles=numberofcopiedfiles+1;
%              end    
%         end
%     disp(['Copied ' num2str(numberofcopiedfiles) ' files from ' sourcedrive ' to ' targetdrive '.'])
%     
%     end
%     
% end
% disp(['Done sharing files among specified network drives.'])

numberofsetsplits=length(sharedrives);   %interleave sets
dosetsindrive=[];
for i=1:numberofsetsplits
    dosetsindrive{i}=[i:numberofsetsplits:length(channelsets)];
end

for targetdriveind=1:numberofsetsplits;
    targetdrive=sharedrives{targetdriveind};
    targetanalysisdir=[targetdrive  ':\data analysis\' experiment '\' subject '\' datei '\' filename '\single-unit\'];
    mkdir(targetanalysisdir)
    dosets=dosetsindrive{targetdriveind};
    groupnumber=targetdriveind;
    disp(['Network drive ' targetdrive ' assigned ' num2str(length(dosets)) ' channel sets.'])
    save([targetanalysisdir 'dosets.mat'], 'dosets','-mat')
    save([targetanalysisdir 'groupnumber.mat'], 'groupnumber','-mat')
    save([savedir 'masterdrive.mat'], 'masterdrive','-mat')
end

else
    
    save([savedir 'masterdrive.mat'], 'masterdrive','-mat')

end

else
masterdrive=analysisdrivename;
targetanalysisdir=[analysisdrivename  ':\data analysis\' experiment '\' subject '\' datei '\' filename '\single-unit\'];
mkdir(targetanalysisdir)
dosets=1:length(channelsets);
save([savedir 'dosets.mat'], 'dosets','-mat')
save([savedir 'masterdrive.mat'], 'masterdrive','-mat')

end
    