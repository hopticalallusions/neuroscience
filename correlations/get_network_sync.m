disp(['Finding epochs of network synchrony in firing.'])

set_plot_parameters

slidingwindow_stepsize=0.001;   %default=0.001. specifies by how much time to step the sliding window (in seconds).

slidingwindow_halfwidth=0.005;       %default=0.005. specifies half width of sliding window (in seconds).

permute_iterations=1000;    %default=1000. number of iterations to run for corr. coef. permutation test (randomly shuffle binned firing rates without replacement).

permutesamples=1e5;    %number of bins in vector use to calculate random synchrony. Can be as long as the data set, but longer sample lengths will take more processing time.

max_pvalue=0.01;   

%************************************************
docelltypes='all';            %options; '1', '2', '3', 'all'. if 'all' will use all cell types.

if exist([syncdir 'sync.mat'],'file') 
   load([syncdir 'sync.mat'])
   syncfile=dir([syncdir 'sync.mat']);
   syncdate=syncfile.datenum;
    
   dosync=[];
   dosync=input(['detected sync file previously created on '  datestr(syncdate,1) ' using max p-value=' num2str(sync.max_pvalue) ' and ' num2str(sync.permute_iterations) ' data permutations; redo (y/n)? [n]: '], 's');
   if isempty(dosync)
   dosync='n';
   end
else dosync='y';
end
 
if dosync=='y'    
mkdir(syncdir)
delete([syncdir '*.*'])
close all
load_results

origdounits=dounits;

uniquecelltypes=setdiff(unique(unitclassnumbers),0);
celltypes=[uniquecelltypes 5]; %by convention celltype=5 means all cell types including unclassified.
if strcmp(docelltypes,'all')~=1
    celltypes=str2num(docelltypes);
end

timebincenters=slidingwindow_halfwidth:slidingwindow_stepsize:(recordingduration-slidingwindow_halfwidth);

disp('counting number of spikes in a sliding window...this can take several hrs.')
for unitind=1:length(dounits)
    slidingwindow_spikes=[]; 
    unitj=dounits(unitind);
    stimesj=spiketimes{unitj};
    tic    
    for timeind=1:length(timebincenters);
        timecenteri=timebincenters(timeind);
        tbin_min=timecenteri-slidingwindow_halfwidth;
        tbin_max=timecenteri+slidingwindow_halfwidth;       
        numberspikesinbin=length(find(stimesj<tbin_max & stimesj>=tbin_min)); 
        slidingwindow_spikes(timeind)=numberspikesinbin;   
    end
    toc
    save([syncdir 'slidingwindow_u' num2str(unitj) '.mat'], 'slidingwindow_spikes', '-mat')
end

sync=[];
sync.subject=subject;
sync.docelltypes=docelltypes;
sync.slidingwindow_stepsize=slidingwindow_stepsize;
sync.slidingwindow_halfwidth=slidingwindow_halfwidth;
sync.max_pvalue=max_pvalue;
sync.permute_iterations=permute_iterations;
sync.timebincenters=timebincenters;

for classind=1:length(celltypes)
    celltype=celltypes(classind);
   
    if celltype==5
    dounits=origdounits;
    classname='all';
    disp(['Finding network synchrony among all unit classes'])       
    else unitclassinds=find(unitclassnumbers==celltype);
    dounits=origdounits(unitclassinds);
    classname=unitclassnames{dounits(1)};
    disp(['Finding network synchrony among putative ' classname ' units'])
    end

    summedtimes=zeros(size(timebincenters));   %counts number of co-active cells in each window.
    for unitind=1:length(dounits)
        unitj=dounits(unitind);
        load([syncdir 'slidingwindow_u' num2str(unitj) '.mat'])
        spikesj=slidingwindow_spikes;
        binary_counts=spikesj;
        binary_counts(find(spikesj>0))=1;  %converts number of spikes per window into a binary number: 0 if no spikes, 1 if >0 spikes.
        summedtimes=summedtimes+binary_counts;   
    end  
    
    tic
    permutetimes=[]; 
    permutebins=timebincenters(1:permutesamples);
    for i=1:permute_iterations
        permutetimes_i=zeros(size(permutebins));
        for unitind=1:length(dounits)
            unitj=dounits(unitind);
            load([syncdir 'slidingwindow_u' num2str(unitj) '.mat'])
            spikesj=slidingwindow_spikes;
            binary_counts=spikesj;
            binary_counts(find(spikesj>0))=1;  %converts number of spikes per window into a binary number: 0 if no spikes, 1 if >0 spikes. 
            x=randsample(length(permutebins),length(permutebins));
            x=x(1:permutesamples);
            permutetimes_i=permutetimes_i+binary_counts(x);    %randomly shuffle bins, without replacement.                      
        end    
        permutetimes=[permutetimes; permutetimes_i];

    end
    toc

    maxpercentile=100-100*(max_pvalue/2);
    minpercentile=100*(max_pvalue/2);
    
    upperbound=prctile(permutetimes,maxpercentile);
    randomsyncfiring=ceil(mean(upperbound));
       
    sync.classname{celltype}=classname;
    sync.dounits{celltype}=dounits;
    sync.summedtimes{celltype}=summedtimes;  %number of simultaneously firing units in each time bin.
    sync.randomsyncfiring{celltype}=randomsyncfiring;   %number of simultaneously firing cells expected by chance with p=max_pvalue.  
end

save([syncdir 'sync.mat'], 'sync', '-mat')

disp(['Done calculating network-level synchrony.'])

end
