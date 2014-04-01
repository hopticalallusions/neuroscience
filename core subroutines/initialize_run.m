%***initialize parameters***
clear sortspikes;
numberiterations=length(allcluststdev);
findpeakmethod=1;
upsamplewaves='y';
dofilter='y'; donotchfilter='n';
warning off

timesdir=[savedir 'sortedtimes\'];
mkdir([timesdir])
delete([timesdir '*.mat'])

disp(['matching to ' num2str(length(origtemplates.meanspikes)) ' total templates.'])

get_maxtrial        %added Sept. 18 2012.

% if savewaves=='y'   %saving each wave considerably slows down run_template_matching.
% wavedir=[savedir 'sortedwaves_mat\'];   
% mkdir([wavedir])
% delete([wavedir '*.mat'])
% end

corrdir=[savedir 'correlations\'];   %delete files in correlations dir.
delete([corrdir '*.*'])

totalclusters=length(origtemplates.meanspikes);
origcluststdev=clusterstdev;
allclusters=[1:totalclusters];   %default.
allusechannels=origtemplates.usechannels;  %represents all channels on the probe found to have unit activity.  
minamplitude=origtemplates.minamplitude;
dosets=origtemplates.dosets;

uniquesets=dosets; channelsperset=[]; setperunit=[];    %fixed Mar 8 2012.
for i=allclusters;
    setperunit=[setperunit origtemplates.channelsetindex{i}];
    channelsperset{origtemplates.channelsetindex{i}}=origtemplates.dochannels{i};   
end

    alltimes=[];    %initialize cluster spike times.
    alljitters=[];
    unsortedtimes=[]; unsortedjitters=[]; disttotemplates=[];
%     allwaves=[];    %initialize cluster waveforms.
%     spikesinallwaves=[];
    for clustind=1:length(allclusters);
    clustx=allclusters(clustind);
%     allwaves{clustx}=[];
        for clusterits=1:numberiterations;
        alltimes{clustx}{clusterits}=[];
        alljitters{clustx}{clusterits}=[];
        unsortedtimes{clusterits}=[];
        unsortedjitters{clusterits}=[];
%         spikesinallwaves{clustx}{clusterits}{1}=[];
        end
    end
       
    for clustind=1:(length(allclusters)+1);  %the last cluster is for unassigned spikes (i.e. spikeind=0).
        for clusterits=1:numberiterations;        
        disttotemplates{clustind}{clusterits}=[];      
        end
    end
    
unassignedcounter=[];
for setind=1:length(uniquesets);   %set normally refers to all channels per shaft.
    currentset=dosets(setind);
    unassignedcounter{currentset}=[];
end
    
get_init_templates   %loads meanspikes (i.e. the template waveforms) and only keeps data from channels corresponding to usechannels.

trialduration=0;  wavefilecounter=1;  timefilecounter=1; unsortedfilecounter=1; distcounter=1;

save([timesdir 'spiketimes_n' num2str(timefilecounter) '.mat'],'alltimes','-mat')  %saves empty matrix for initialization.

save([timesdir 'unsortedtimes_n' num2str(timefilecounter) '.mat'],'unsortedtimes','-mat')  %saves empty matrix for initialization.

save([timesdir 'disttotemplates_n' num2str(timefilecounter) '.mat'],'disttotemplates','-mat')  %saves empty matrix for initialization.

% if savewaves=='y'   %saving each wave considerably slows down run_template_matching.
%     for clusterits=1:numberiterations; 
%     save([wavedir 'waves_i' num2str(clusterits) '_n' num2str(wavefilecounter) '.mat'],'allwaves', '-mat');  %saves empty file.
%     end
% end
