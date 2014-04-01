% unitclass='2';        %if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj
% 
% syncpeaktime=0.45;      %approximate time of synchrony peak (post-event).
% syncwindowsize=0.05;    %amount of +/- time to search around syncpeaktime for highest synchrony.
% 
% 
% %************************************************
% 
% timeoffset=sync.timebincenters(1);  %used for aligning peak synchrony time to t=0 on raster plot.
% syncrange=syncwindowsize/slidingwindow_stepsize;
% 
% close all
% load_results
% 
% if strcmp(unitclass, 'all')
%     classnumber=5;     %class number of 5 means use all units (defined in get_network_sync)
%     cellname='all';
% else classnumber=str2num(unitclass);
%     unitclassinds=find(unitclassnumbers==str2num(unitclass));
%     dounits=dounits(unitclassinds);
%     cellname=unitclassnames{dounits(1)};
% end
% 
% 
% syncnumber=sync.summedtimes{classnumber};
% 
% %pick out only units that are synced during the peak of interest.
% synced_units=[];
% for trialind=1:length(doevent1trials);
%     trialk=doevent1trials(trialind);
%     trialktime=event1times(trialk);   
%     synctime_trialk=round((trialktime+syncpeaktime)/slidingwindow_stepsize);
%     syncnumber_trialk=syncnumber((synctime_trialk-syncrange):(synctime_trialk+syncrange));  
%     
%     maxsyncind=find(syncnumber_trialk==max(syncnumber_trialk));
%     maxsyncind=maxsyncind(1);
%     
%     localsynctime=synctime_trialk+maxsyncind-syncrange-1;  %time of maximum local synchrony, in units of samples.
%     
%     disp(['trial ' num2str(trialk) ' has local synchrony of ' num2str(syncnumber(localsynctime)) '/' num2str(length(dounits)) ' cells.'])
%         
%     synced_units{trialk}=[];
%     for unitind=1:length(dounits)
%         unitj=dounits(unitind);
%   
%         load([syncdir 'slidingwindow_u' num2str(unitj) '.mat'])
%         numberofspikesj=slidingwindow_spikes(localsynctime);  %number of spikes in the local synchrony time.
%         if numberofspikesj>0
%         synced_units{trialk}=[synced_units{trialk} unitj];
%         end
%     end
%     
% end
% 
% 
% 

%***Create high synchrony-triggered psth of sync (similar to generating high LFP amplitude-triggered psth)***

syncwindowsize=0.25;    %amount of +/- time to search around syncpeaktime for highest synchrony.
syncrange=syncwindowsize/slidingwindow_stepsize;

MSNsyncnumber=sync.summedtimes{1};
FSIsyncnumber=sync.summedtimes{2};
TANsyncnumber=sync.summedtimes{3};
allsyncnumber=sync.summedtimes{5};

MSNthresh=sync.randomsyncfiring{1};
FSIthresh=sync.randomsyncfiring{2};
TANthresh=sync.randomsyncfiring{3};
allthresh=sync.randomsyncfiring{5};

highFSI_syncbins=find(TANsyncnumber>=TANthresh);
length(highFSI_syncbins)

timebins=-syncrange:1:syncrange;

MSNpsth=zeros(length(highFSI_syncbins), length(timebins)); FSIpsth=zeros(length(highFSI_syncbins), length(timebins)); TANpsth=zeros(length(highFSI_syncbins), length(timebins));
for ind=1:length(highFSI_syncbins)
    syncbini=highFSI_syncbins(ind);
    if (syncbini-syncrange)<1 | (syncbini+syncrange)>length(MSNsyncnumber)
        continue
    end        
    local_MSNsync=MSNsyncnumber((syncbini-syncrange):(syncbini+syncrange));
    local_FSIsync=FSIsyncnumber((syncbini-syncrange):(syncbini+syncrange));
    local_TANsync=TANsyncnumber((syncbini-syncrange):(syncbini+syncrange));

    MSNpsth(ind,:)=local_MSNsync;
    FSIpsth(ind,:)=local_FSIsync;
    TANpsth(ind,:)=local_TANsync;
end

meanMSNpsth=mean(MSNpsth);
meanFSIpsth=mean(FSIpsth);
meanTANpsth=mean(TANpsth);

close all
subplot(2,1,1)
plot(timebins,(meanMSNpsth-min(meanMSNpsth))/max(meanMSNpsth),'b')  %MSN
hold on
plot(timebins,(meanFSIpsth-min(meanFSIpsth))/max(meanFSIpsth),'r')  %FSI
plot(timebins,(meanTANpsth-min(meanTANpsth))/max(meanTANpsth),'g')  %TAN

subplot(2,1,2)
[a, lags]=xcorr(TANsyncnumber, FSIsyncnumber, syncwindowsize/slidingwindow_stepsize);    %time lag convention: xcorr(i,j) will calculate the cross-correlation of events with latency ti-tj.
plot(lags,a)
xlabel('t_T_A_N-t_F_S_I (ms)')   

%**************************************************************




% 
% %***plots psth of each MSN invividually, triggered on peak FSI synchrony events***
% timebins=-syncwindowsize:slidingwindow_stepsize:syncwindowsize;
% MSNspikecounts=[]; MSNunit_psth=[];
% for unitind=1:length(dounits)
%     unitj=dounits(unitind);
%     MSNspikecounts{unitj}=[];
%     stimesj=spiketimes{unitj};
%     
%     for ind=1:length(highFSI_syncbins)
%         synctimei=(highFSI_syncbins(ind)*slidingwindow_stepsize);
%         if (syncbini-syncrange)<1 | (syncbini+syncrange)>length(MSNsyncnumber)
%             continue
%         end   
%         foundtimes=find(stimesj<(synctimei+syncwindowsize) & stimesj>(synctimei-syncwindowsize));
%         if length(foundtimes)>0
%         reltimes=stimesj(foundtimes)-synctimei;
%         MSNspikecounts{unitj}=[MSNspikecounts{unitj} reltimes];
%         end
%     end
%     
%     MSNunit_psth{unitj}=histc(MSNspikecounts{unitj}, timebins)/length(highFSI_syncbins);
%     close all
%     plot(timebins, MSNunit_psth{unitj})
%     input('d')
% end
% 
% 
% %**************************************************************
% 
% 
% 
% %*******Analysis of chain distance vs Nsync/Ntot*******
% 
% %aim: show that synchrony can occur over large distances, supporting
% %widespread sharing of information.
% 
% %details: for every time bin, find the maximum end-to-end distance of the sync chain. plot the average max. chain distance vs Nsync/Ntot.
% preeventtime=0;               %time in sec to use before event onset.
% posteventtime=8;              %time in sec to use after event onset.
% 
% close all
% load_results
% 
% load([syncdir 'sync.mat'])
% slidingwindow_halfwidth=sync.slidingwindow_halfwidth;
% synctimebins=sync.timebincenters; 
% slidingwindow_stepsize=sync.slidingwindow_stepsize;
% 
% MSNsyncnumber=sync.summedtimes{1};
% FSIsyncnumber=sync.summedtimes{2};
% TANsyncnumber=sync.summedtimes{3};
% 
% MSNthresh=sync.randomsyncfiring{1};
% FSIthresh=sync.randomsyncfiring{2};
% TANthresh=sync.randomsyncfiring{3};
% 
% event1_inds=[]; 
% for trialind=1:length(doevent1trials);
%     trialk=doevent1trials(trialind);
%     t0=event1times(trialk);      
%     spikeinds=find(synctimebins<(t0+posteventtime) & synctimebins>(t0-preeventtime));
%     event1_inds=[event1_inds spikeinds];
% end
% 
% unitclass='2'
% unitclassinds=find(unitclassnumbers==str2num(unitclass));
% dounits=dounits(unitclassinds);
% cellname=unitclassnames{dounits(1)};
% 
% FSIbinnedspikes=[];
% for unitind=1:length(dounits)
%     unitj=dounits(unitind);
%     load([syncdir 'slidingwindow_u' num2str(unitj) '.mat'])
%     FSIbinnedspikes{unitj}=slidingwindow_spikes(event1_inds);
% end
% 
% 
% chainlength=[]; nsync_FSIs=[];
% for i=1:length(event1_inds)
%     synced_FSIpositions=[];
%     if FSIsyncnumber(event1_inds(i))>=2
%     nsync_FSIs=[nsync_FSIs FSIsyncnumber(event1_inds(i))];  %number of synchronized FSIs in the current bin.
%     for unitind=1:length(dounits)
%         unitj=dounits(unitind);
%         if FSIbinnedspikes{unitj}(i)>0
%             synced_FSIpositions=[synced_FSIpositions; [positions.unitx{unitj} positions.unity{unitj} positions.unitz{unitj}]];
%         end
%     end    
%     chainlength=[chainlength max(pdist(synced_FSIpositions))];   %maximum Euclidean distance in the sync chain.
%     end
% end
%  
% unique_nsync=sort(unique(nsync_FSIs));
% mean_lengths=[]; sd_lengths=[]; sem_lengths=[];
% for i=1:length(unique_nsync)
%     nsynci=unique_nsync(i);
%     lengths_nsynci=chainlength(find(nsync_FSIs==nsynci));
%     mean_lengths=[mean_lengths mean(lengths_nsynci)];
%     sd_lengths=[sd_lengths std(lengths_nsynci)];
%     sem_lengths=[sem_lengths std(lengths_nsynci)/sqrt(length(lengths_nsynci))];
% end
% errorbar(unique_nsync/length(dounits), mean_lengths, sd_lengths)
% title('maximum chain length vs fraction of synced FSIs (Mean+/-SD)')
%     
    
   

%*******************************************


% synced_units=[];
% 
% for unitind=1:length(dounits)
%         unitj=dounits(unitind);
%   
%         load([syncdir 'slidingwindow_u' num2str(unitj) '.mat'])
%         spikesj=slidingwindow_spikes(syncbin);
%         if spikesj>0
%         synced_units=[synced_units unitj];
%         end
% end
% 
% 
% 
% %1. plot all units, even if they are not firing at the peak of interest.
% syncbintime=syncbin*slidingwindow_stepsize;
% plotunits=synced_units;
% for trialind=1; %:length(doevent1trials);
% trialk=doevent1trials(trialind);
% t0=event1times(trialk)+syncpeaktime;
% 
%     for unitind=1:length(plotunits)
%         unitj=plotunits(unitind);   
%         stimesj=spiketimes{unitj};      
%         spikeinds=find(stimesj<(t0+syncbinsize) & stimesj>(t0-syncbinsize));
%         rel_spiketimes=stimesj(spikeinds)-t0;
%         if length(rel_spiketimes)==0
%         rel_spiketimes=-syncbinsize;
%         end
%     
%         plot([rel_spiketimes; rel_spiketimes],[0.8*ones(size(rel_spiketimes))+(unitind-0.4); zeros(size(rel_spiketimes))+(unitind-0.4)],'Color', 'k')
%         hold on
%     end
% 
% end
