%updated Sept 15 2012.

if exist('c:\data analysis\','dir')>0
analysisdrivename='c';
elseif exist('d:\data analysis\','dir')>0
analysisdrivename='d';  
elseif exist('e:\    data analysis\','dir')>0
analysisdrivename='e'; 
elseif exist('/Users/andrew.howe/trackforbackup/masmanidisLab/spike-jitter/testing-output/')
    analysisdrivename='/Users/andrew.howe/trackforbackup/masmanidisLab/spike-jitter/testing-output/';
else analysisdrivename=input('data analysis directory does not exist, specify drive name: ', 's');
    mkdir([analysisdrivename ':/data analysis/'])
end

reminderdir=[analysisdrivename ':/data analysis/'];

if exist([analysisdrivename ':/data analysis/lastopened_dir.txt'], 'file')==2;
    datanotes=importdata([reminderdir 'lastopened_dir.txt']);
    if isstr(datanotes{1})==1
    datanotes=datanotes{1};
    end
    lastopeneddir=datanotes(1:length(datanotes));
    if length(datanotes)>6;
        rawpath=lastopeneddir;
    else
        rawpath=[analysisdrivename ':/data analysis/'];
        dlmwrite([reminderdir 'lastopened_dir.txt'],rawpath,'delimiter','','newline','pc');
    end
else
   rawpath=[analysisdrivename ':/data analysis/'];
   dlmwrite([reminderdir 'lastopened_dir.txt'],rawpath,'delimiter','','newline','pc');
end

if length(findstr(rawpath,'analysis'))>0  %use data analysis folder   
[fname, rawpath]=uigetfile({[rawpath '*.mat']},'Select a file to open in the "muxi data" or "data analysis...single-unit" directory');
else
[fname, rawpath]=uigetfile({[rawpath '*.mux1']},'Select a file to open in the "muxi data" or "data analysis...single-unit" directory');
end   

get_file_subject_name

datadrivedir=rawpath(1);