%Developed March 23 2013
%This program renames multiple files (e.g. Feb21b, Feb21c, Feb21d) into one file (e.g. Feb21a). 
%Note: must manually delete the 'bad' files occuring just before the crash.

%***Set parameters***

renameletters='a';  %default='a'. specify which letter to rename all files. e.g. 'c' will rename Mar11d to Mar11c but Mar11a will not change.

%*******************

recall_rawpath

remember_rawpath

datadir=[datadrivedir ':\muxi data\' experiment '\' subject '\' datei '\'];

newdatadir=[datadrivedir ':\muxi data\' experiment '\' subject '\' datei ' Renamed\'];
disp(['copying renamed files into directory ' newdatadir])

mkdir(newdatadir)
delete([newdatadir '*.*'])

fileprefix=filename(1:(length(filename)-1));  %e.g. Feb21
alphabet=char('a'+(1:26)-1);    %list of letters in alphabet.

notesfiles=dir([datadir '*.txt'])
disp(['copying notes files'])
for i=1:length(notesfiles)
    currentfile=notesfiles(i).name;
    copyfile([datadir currentfile],[newdatadir currentfile])
end

fileswithletter=dir([datadir fileprefix renameletters '*']);
maxtrialcurrentletter=0;
disp(['copying files with letter ' renameletters '.'])
for i=1:length(fileswithletter)
    currentfile=fileswithletter(i).name;
    copyfile([datadir currentfile],[newdatadir currentfile])  
    findmarker1=strfind(currentfile,'_');
    findmarker2=strfind(currentfile,'.');
    currenttrial=str2num(currentfile((findmarker1+2):(findmarker2-1)));
    if currenttrial>maxtrialcurrentletter
        maxtrialcurrentletter=currenttrial;
    end
end

renamelettind=strfind(alphabet,renameletters)
firstletter=alphabet(renamelettind+1);
firstletterind=strfind(alphabet,firstletter);

renametrial=maxtrialcurrentletter+1;  %first trial to use when renaming files.
for letterind=firstletterind:length(alphabet);
    currentletter=alphabet(letterind);
    fileswithletter=dir([datadir fileprefix currentletter '*']);
    
    maxtrialcurrentletter=0;
    for i=1:length(fileswithletter)
        currentfile=fileswithletter(i).name;
        findmarker1=strfind(currentfile,'_');
        findmarker2=strfind(currentfile,'.');
        currenttrial=str2num(currentfile((findmarker1+2):(findmarker2-1)));
        if currenttrial>maxtrialcurrentletter
            maxtrialcurrentletter=currenttrial;
        end
    end
    
    if maxtrialcurrentletter==0
        continue
    end
    
    disp(['copying files with letter: ' currentletter])
    
    for trial=2:maxtrialcurrentletter
        if trial<10
        fileswithletterandtrial=dir([datadir fileprefix currentletter '_t0' num2str(trial) '.*']);
        else fileswithletterandtrial=dir([datadir fileprefix currentletter '_t' num2str(trial) '.*']);
        end
        for i=1:length(fileswithletterandtrial)
            currentfile=fileswithletterandtrial(i).name;
            findmarker1=strfind(currentfile,'.');
            filetermination=currentfile(findmarker1:length(currentfile));
            if renametrial<10
            newfilename=[fileprefix renameletters '_t0' num2str(renametrial) filetermination];
            else  newfilename=[fileprefix renameletters '_t' num2str(renametrial) filetermination];
            end 
            copyfile([datadir currentfile],[newdatadir newfilename])
            disp(['renaming ' currentfile ' to ' newfilename])
        end
        renametrial=renametrial+1;
    end

 
end

disp(['done renaming.'])
    