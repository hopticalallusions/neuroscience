if exist([savedir 'dosplit.mat'])>0

load([savedir 'dosplit.mat'])

if dosplit=='y';
    load([savedir 'masterdrive.mat'])
    
    load([savedir 'dosets.mat'])
    load([savedir 'groupnumber.mat'])
    
    if groupnumber~=1
    
    targetsavedir=[masterdrive ':\data analysis\' experiment '\' subject '\' datei '\' filename '\single-unit\'];
    targettimesdir=[targetsavedir 'sortedtimes' ' set group ' num2str(groupnumber) '\'];
    targetpenultwavedir=[targetsavedir 'amps & waves\penultimate' ' set group ' num2str(groupnumber) '\'];
    mkdir(targettimesdir)
    delete([targettimesdir '*.*'])
    mkdir(targetpenultwavedir)
    delete([targetpenultwavedir '*.*'])
    
    filename1='penult_spiketimes.mat';
    [SUCCESS,MESSAGE,MESSAGEID]=copyfile([timesdir filename1],[targettimesdir filename1]);     
    disp(['copied ' filename1])
    
    filename2='penult_baretimes.mat';
    [SUCCESS,MESSAGE,MESSAGEID]=copyfile([timesdir filename2],[targettimesdir filename2]);     
    disp(['copied ' filename2])
    
    filename3='penult_jittertimes.mat';
    [SUCCESS,MESSAGE,MESSAGEID]=copyfile([timesdir filename3],[targettimesdir filename3]);     
    disp(['copied ' filename3])
    
    sourcefiles=dir([penultwavedir '*.mat']);
    
    for i=1:length(sourcefiles)
             sourcefilei=sourcefiles(i).name;
             if exist([targetpenultwavedir sourcefilei],'file')==0
             [SUCCESS,MESSAGE,MESSAGEID]=copyfile([penultwavedir sourcefilei],[targetpenultwavedir sourcefilei]);     
             disp(['copied ' sourcefilei])       
             end    
    end
    
    disp(['Done copying files to master network drive. The \sortedtimes\set group 2...N\ folders should be erased. Now run get_final_units on master drive computer.'])
    
    elseif groupnumber==1
        
    oktoproceed=input('Press any key to proceed with combining channelsets from multiple network drives on this computer.', 's');    
    
    end
    
end


if masterdrive~=analysisdrivename   %this stops the spikes sorting here if the computer drive doesn't match the masterdrive letter.
    break
end


savedirfolders=ls(savedir);
numbernetworkgroups=1;
for i=1:size(savedirfolders,1)
foldername=savedirfolders(i,:);
if length(strfind(foldername,'sortedtimes set group'))==1
    numbernetworkgroups=numbernetworkgroups+1;
end
end
disp(['Found penultimate data from ' num2str(numbernetworkgroups) ' networked computer drives.'])


if numbernetworkgroups>1

load([timesdir 'penult_spiketimes.mat'])   %loads spiketimes created in collect_spiketimes;
load([timesdir 'penult_baretimes.mat'])   %loads spiketimes created in collect_spiketimes;
load([timesdir 'penult_jittertimes.mat'])   %loads spiketimes created in collect_spiketimes; 
origspiketimes=spiketimes;
origbaretimes=baretimes;
origjittertimes=jittertimes;
           
load([penultwavedir 'bestchannel.mat']);  %loads parameters file.
origbestchannel=bestchannel;
unitsonmasterdrive=length(origbestchannel);
unitindexcounter=unitsonmasterdrive;

disp(['There are ' num2str(unitsonmasterdrive) ' penultimate units on the master network drive (this computer).'])
    
    for i=2:numbernetworkgroups
    
    grouptimesdir=[savedir 'sortedtimes' ' set group ' num2str(i) '\'];   
    load([grouptimesdir 'penult_spiketimes.mat'])   %loads spiketimes created in collect_spiketimes;
    load([grouptimesdir 'penult_baretimes.mat'])   %loads spiketimes created in collect_spiketimes;
    load([grouptimesdir 'penult_jittertimes.mat'])   %loads spiketimes created in collect_spiketimes; 
    origspiketimes=[origspiketimes spiketimes];
    origbaretimes=[origbaretimes baretimes];
    origjittertimes=[origjittertimes jittertimes];
    
    grouppenultwavedir=[savedir 'amps & waves\penultimate' ' set group ' num2str(i) '\'];
    load([grouppenultwavedir 'bestchannel.mat']);  %loads parameters file.
    origbestchannel=[origbestchannel bestchannel]; 
    disp(['Appending ' num2str(length(bestchannel)) ' penultimate units from channelset group ' num2str(i) '.'])    
    sourcefiles=dir([grouppenultwavedir '*waveforms*']);
    
        for j=1:length(sourcefiles)
             sourcefilei=sourcefiles(j).name;
             a=strfind(sourcefilei,'cl');
             b=strfind(sourcefilei,'.');
             oldunitindex=str2num(sourcefilei((a+2):(b-1)));
             newunitindex=oldunitindex+unitindexcounter;
             newfilenamei=[sourcefilei(1:a+1) num2str(newunitindex) '.mat'];
             movefile([grouppenultwavedir sourcefilei],[penultwavedir newfilenamei]);                      
        end
        unitindexcounter=unitindexcounter+length(sourcefiles);
        delete([grouptimesdir '*.*'])
        rmdir(grouptimesdir)
        delete([grouppenultwavedir '*.*'])
        rmdir(grouppenultwavedir)
   
    end
    
spiketimes=origspiketimes;
baretimes=origbaretimes;
jittertimes=origjittertimes;
bestchannel=origbestchannel;

save([timesdir 'penult_spiketimes.mat'],'spiketimes', '-mat')
save([timesdir 'penult_baretimes.mat'],'baretimes','-mat')
save([timesdir 'penult_jittertimes.mat'],'jittertimes','-mat')
save([penultwavedir 'bestchannel.mat'],'bestchannel','-mat')

disp(['Done combining penultimate files from networked drives and deleted temporary set group directories.'])

end

end