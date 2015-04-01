unitclass1='all';           %first type of unit used in pairwise comparison. if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj
unitclass2='all';           %second type of unit used in pairwise comparison. if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

max_pvalue=0.01;            %default=0.01. threshold for accepting abs(correlation coefficient) as significant.
minconsec=1;                %default=1. minimum number of consecutive time points that need to exceed uncertainty to be considered significant.

confidence_interval=0.01;  %default=0.05;

distance_binsize=0.1;       %size of bin in mm to use for plotting average correlation coefficient & other properties vs distance.
max_plotdistance=1;         %maximum distance in mm to use in correlation vs distance plots.
min_unitseparation=0.05;    %minimum pairwise separation of units (in mm) to be added to correlation plots. setting minimum separation helps compensate for any possible spike sorting errors.
max_radius=0.5;             %radius for calculating probability of finding connected cells, and for calculating mean corr. coeff. per animal.

do_quickplots='y';          %shows the significant cross-correlation plots with the 99th percent confidence intervals. user can reject any outlier pairs that show spuriuosly high cross-correlation.

plot_maxlag=50;            %maximum lag in ms to use in plotting.

%************************************************
baseline_start=-5;
baseline_end=0;
smoothingwindow='y';       %default='y' for plot_pearson. used in event_trigrates. does not affect calculate of correlation coefficients.
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'none'.
trialselection2='unrewarded';     %select which event2 trials to display. same options as trialselection1.
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.

distance=min_unitseparation:distance_binsize:(max_plotdistance+distance_binsize);

domultisubject='y';
backgroundchans1=['all'];            %default=['all']. can leave empty or write numeric list. The channels in the current set are not used in backgroundchans.  badchannels are removed from this list.
samplingrate=25000;
qualitycutoff=1;           %default=1. unit qualities: 1, 2, 3. 1=best, 2=medium quality, 3=not single-unit. used in select_douniters.
trialgroupsize=10;         %used in select_triggers_trials
grouptimebinsize=0.1;

figindi=1;
scrsz=get(0,'ScreenSize');

initialize_scatvars='y';

if initialize_scatvars=='y'
    disp('resetting scatter plot variables. ')
    distance_sigpairs=[]; distance_sigpospairs=[]; distance_signegpairs=[]; distance_allpairs=[]; all_xcorr=[]; pos_xcorr=[]; neg_xcorr=[];
    xcorr_stats=[];
    
    close_figures=[];
    close_figures=input('Do you want to close the figures and plot on fresh graph (y/n) [y]: ', 's');
    if isempty(close_figures)==1
        close_figures='y';
    end
    
    if close_figures=='y'
        close all
    end
    
    set_plotcolor=[];
    set_plotcolor=input('Select a color for the plot [blac(k)]: ', 's');
    if isempty(set_plotcolor)==1
        set_plotcolor='k';
    end
end

selectedpaths=uipickfiles('FilterSpec','/Users/andrew.howe/trackforbackup/current-classes/masmanidisLab/spike-jitter/data analysis/Licking Training/Mouse 100/December 7 2013/Dec7a/single-unit/cross-correlations/allspikes/unit data/');  %prompts to pick subjects.

get_subject_dir

analysisdrivename=subjects{1}(1);
combinedir = [analysisdrivename ':/data analysis/figures/'];
if isdir(combinedir) == 0
    mkdir(combinedir)
end

totalunits=0; totalplotunits=0;
for subjectind = 1:length(subjects)
    rawpath = [subjects{subjectind} '/'];
    savedir = [rawpath 'single-unit/'];
    timesdir = [savedir 'sortedtimes/'];
    unitclassdir = [savedir 'properties/'];
    stimulidir = [rawpath '/stimuli/'];
    stimephysdir = [rawpath 'stim-ephys/'];
    xcorrdir=[savedir 'cross-correlations/'];
    
    get_file_subject_name
    disp([subject])
    
    xcorr_stats.subjects{subjectind}=subject;
    xcorr_stats.connectedcells{subjectind}=[];
    xcorr_stats.distance{subjectind}=[];
    
    % currentxcorrdir=uigetdir([xcorrdir],'Select a "cross-correlations" folder');
    currentxcorrdir=[xcorrdir 'allspikes/'];  %default is to use allspikes folder.
    xcorrdatadir=[currentxcorrdir 'unit data/'];
    load('/Users/andrew.howe/trackforbackup/current-classes/masmanidisLab/spike-jitter/data analysis/Licking Training/Mouse 100/December 7 2013/Dec7a/single-unit/cross-correlations/allspikes/crosscorr_params.mat');
    %load([currentxcorrdir 'crosscorr_params.mat'])
    
    spikes_or_bursts1=crosscorr_params.spikes_or_bursts1;
    spikes_or_bursts2=crosscorr_params.spikes_or_bursts2;
    got_unitclass1=crosscorr_params.unitclass1;
    got_unitclass2=crosscorr_params.unitclass2;
    got_dounits1=crosscorr_params.dounits1;
    got_dounits2=crosscorr_params.dounits2;
    
    triggerevent1=crosscorr_params.triggerevent1;
    trialselection1=crosscorr_params.trialselection1;
    timebinsize=crosscorr_params.timebinsize;
    preeventtime=crosscorr_params.preeventtime;
    posteventtime=crosscorr_params.posteventtime;
    maxcorrtime=crosscorr_params.maxcorrtime;
    max_jittertime=crosscorr_params.max_jittertime;
    maxlag=crosscorr_params.maxlag;
    jitter_iterations=crosscorr_params.jitter_iterations;
    
    upperbound_percentile=100*(1-max_pvalue/2);  %divide max_pvalue by 2 because this is a two-tailed distribution.
    lowerbound_percentile=100*max_pvalue/2;      %divide max_pvalue by 2 because this is a two-tailed distribution.
    timerange=(maxlag-ceil(1000*max_jittertime)):(maxlag+ceil(1000*max_jittertime)); %looks for significance in the interval of +/- the jitter time around t=0.
    distance=min_unitseparation:distance_binsize:(max_plotdistance+distance_binsize);
    
    
    if spikes_or_bursts1=='s'
        label_cell1=['Cell 1 class = ' got_unitclass1 ' (Spikes)'];
    elseif spikes_or_bursts1=='b'
        label_cell1=['Cell 1 class = ' got_unitclass1 ' (Bursts)'];
    end
    if spikes_or_bursts2=='s'
        label_cell2=['Cell 2 class = ' got_unitclass2 ' (Spikes)'];
    elseif spikes_or_bursts2=='b'
        label_cell2=['Cell 2 class = ' got_unitclass2 ' (Bursts)'];
    end
    
    if subjectind==1
        disp(['Got cross-correlations on event ' triggerevent1 ' with ' num2str(jitter_iterations) ' jitter iterations.'])
        disp(['Got ' label_cell1 ' & ' label_cell2])
    end
    
    if spikes_or_bursts1=='b' | spikes_or_bursts2=='b'
        slow_or_rapid=crosscorr_params.slow_or_rapid;
        minburstisi=corsscorr_params.minburstisi;
        minspikesperburst=crosscorr_params.minspikesperburst;
        burstlabel=['burst criteria: minimum ISI = ' num2str(minburstisi) ' s; minimum spikes/burst = ' num2str(minspikesperburst)];
        disp(burstlabel)
    end
    
    load_results
    
    %longtimebins=0:timebinsize:recordingduration;
    longtimebins=0:timebinsize:5400;

    corrtimebins=(-maxlag:1:maxlag)*1000*timebinsize;
    plot_corrtime=(-plot_maxlag:1:plot_maxlag)*1000*timebinsize;
    
    
    if length(strmatch(unitclass1,'all'))==0 & uniqueunitclasses(1)~=0
        unitclassinds=find(unitclassnumbers==str2num(unitclass1));
        dounits1=dounits(unitclassinds);
        plotlabel1=unitclassnames{dounits1(1)};
    else
        dounits1=dounits;
        plotlabel1=['all'];
    end
    newdounits1=intersect(dounits1, got_dounits1);  %ensures that only units that were used in get_pairwise_crosscorr will be acceessed.
    if length(newdounits1)<length(dounits1)
        disp('***WARNING: the selected unit 1 class attempts to access units that were not used in get_pairwise_crosscorr***')
    end
    dounits1=newdounits1;
    
    if length(strmatch(unitclass2,'all'))==0 & uniqueunitclasses(1)~=0
        unitclassinds=find(unitclassnumbers==str2num(unitclass2));
        dounits2=dounits(unitclassinds);
        plotlabel2=unitclassnames{dounits2(1)};
    else
        dounits2=dounits;
        plotlabel2=['all'];
    end
    newdounits2=intersect(dounits2, got_dounits2);  %ensures that only units that were used in get_pairwise_crosscorr will be acceessed.
    if length(newdounits2)<length(dounits2)
        disp('***WARNING: the selected unit 2 class attempts to access units that were not used in get_pairwise_crosscorr***')
    end
    dounits2=newdounits2;
    
    if subjectind==1
        disp(['Using ' plotlabel1 ' units for first cell in the pair.']);
        disp(['Using ' plotlabel2 ' units for second cell in the pair.']);
    end
    
    unit_depths1=[];
    for unitind=1:length(dounits1);
        unitj=dounits1(unitind);
        unit_depths1=[unit_depths1 unitz{unitj}];
    end
    
    [neworder1, sortindices1]=sort(unit_depths1);
    units_depthordered1=dounits1(sortindices1);   %orders the units according to depth (low to high # = shallow-to-deep);
    origunitorder1=units_depthordered1;
    
    unit_depths2=[];
    for unitind=1:length(dounits2);
        unitj=dounits2(unitind);
        unit_depths2=[unit_depths2 unitz{unitj}];
    end
    
    [neworder2, sortindices2]=sort(unit_depths2);
    units_depthordered2=dounits2(sortindices2);   %orders the units according to depth (low to high # = shallow-to-deep);
    origunitorder2=units_depthordered2;
    
    unitorder1=[];  %units ordered by depth & shaft. used in generating corr. coef. matrices.
    unitorder2=[];
    for shaftind=1:length(uniqueshafts);
        currentshaft=uniqueshafts(shaftind);
        unitsonshaft=find(parameters.shafts==currentshaft);
        unitorder1=[unitorder1 intersect(origunitorder1,unitsonshaft,'stable')];   %'stable' keeps the original order of unitorder;
        unitorder2=[unitorder2 intersect(origunitorder2,unitsonshaft,'stable')];   %'stable' keeps the original order of unitorder;
    end
    
    pairwise_dist=[]; did_pairs=[]; significant_pairs=[];
    for unitindi=1:length(dounits);
        uniti=dounits(unitindi);
        xi=unitx{uniti};
        yi=unity{uniti};
        zi=unitz{uniti};
        
        for unitindj=1:length(dounits);
            unitj=dounits(unitindj);
            xj=unitx{unitj};
            yj=unity{unitj};
            zj=unitz{unitj};
            distij=sqrt((xj-xi)^2+(yj-yi)^2+(zj-zi)^2);
            pairwise_dist{uniti}{unitj}=distij;
            
            did_pairs{uniti}{unitj}='n';   %initialize values.
            significant_pairs{uniti}{unitj}=0; significant_pairs{unitj}{uniti}=0;   %initialize values.
        end
    end
    
    xcorr_stats.cell1number{subjectind}=length(dounits1);
    xcorr_stats.cell2number{subjectind}=length(dounits2);
    
    if spikes_or_bursts1=='s' & spikes_or_bursts2=='s'
        
        possibleconnections=0; actualconnections=0;
        for unitindi=1:length(dounits1);
            uniti=dounits1(unitindi);
            
            for unitindj=1:length(dounits2);
                unitj=dounits2(unitindj);
                
                if uniti~=unitj & did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation & pairwise_dist{uniti}{unitj}<max_radius
                    possibleconnections=possibleconnections+1;  %possible number of unique connections within radius of min_unitseparation to max_radius.
                end
                
                xcorr_observed=[]; xcorr_jittered=[];  %added Jan 14 2014.
                if  did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation
                    if uniti<unitj & exist([xcorrdatadir 'crosscorr_' num2str(uniti) '.mat'])    %ensures pairs are only counted once if cell 1 & 2 are from the same spike/burst category and class.
                        load([xcorrdatadir 'crosscorr_' num2str(uniti) '.mat'])
                        xcorr_observed=crosscorr.xcorr_observed{unitj};
                        xcorr_jittered=crosscorr.xcorr_jittered{unitj};
                        flipunits='n';
                    elseif uniti>unitj & exist([xcorrdatadir 'crosscorr_' num2str(unitj) '.mat'])
                        load([xcorrdatadir 'crosscorr_' num2str(unitj) '.mat'])
                        xcorr_observed=crosscorr.xcorr_observed{uniti};
                        xcorr_jittered=crosscorr.xcorr_jittered{uniti};
                        flipunits='y';
                    elseif uniti==unitj
                        continue
                    end
                elseif did_pairs{uniti}{unitj}=='y' | pairwise_dist{uniti}{unitj}<min_unitseparation | pairwise_dist{uniti}{unitj}>max_plotdistance
                    continue
                end
                
                if length(xcorr_observed)==0
                    continue
                end
                
                did_pairs{uniti}{unitj}='y'; did_pairs{unitj}{uniti}='y';
                distance_allpairs=[distance_allpairs pairwise_dist{uniti}{unitj}];   %pairwise distance between all qualified pairs, regardless of whether they are significant or not. used in calculating probability of finding significant cross-correlation btwn pairs.
                
                upperbound_error=prctile(xcorr_jittered,upperbound_percentile);
                lowerbound_error=prctile(xcorr_jittered,lowerbound_percentile);
                
                upper_corrected_xcorr=xcorr_observed-upperbound_error;
                lower_corrected_xcorr=xcorr_observed-lowerbound_error;
                
                uppersigpoints=find(upper_corrected_xcorr(timerange)>0);
                lowersigpoints=find(lower_corrected_xcorr(timerange)<0);
                
                if flipunits=='y'
                    xcorr_observed=fliplr(xcorr_observed);
                    upperbound_error=fliplr(upperbound_error);
                    lowerbound_error=fliplr(lowerbound_error);
                end
                
                
                if min(diff(uppersigpoints))<=minconsec & max(upper_corrected_xcorr(timerange))>=abs(min(lower_corrected_xcorr(timerange))) & pairwise_dist{uniti}{unitj}<=max_plotdistance
                    
                    spikecountsi=histc(spiketimes{uniti},longtimebins);  %binned spike counts.
                    spikecountsj=histc(spiketimes{unitj},longtimebins);  %binned spike counts.
                    new_xcorr_observed=xcorr(spikecountsi, spikecountsj, plot_maxlag);
                    
                    backgroundcorr=mean(new_xcorr_observed([1:round(plot_maxlag/2) round(1.5*plot_maxlag:2*plot_maxlag)]));
                    
                    all_xcorr=[all_xcorr; new_xcorr_observed/backgroundcorr];   %array containing all significantly connected pairs; normalize by the mean value.
                    pos_xcorr=[pos_xcorr; new_xcorr_observed/backgroundcorr];   %array containing all significantly connected pairs; normalize by the mean value.
                    
                    if do_quickplots=='n'
                        
                        distance_sigpairs=[distance_sigpairs pairwise_dist{uniti}{unitj}];
                        distance_sigpospairs=[distance_sigpospairs pairwise_dist{uniti}{unitj}];
                        significant_pairs{uniti}{unitj}=1;
                        significant_pairs{unitj}{uniti}=1;
                        actualconnections=actualconnections+1;
                        xcorr_stats.connectedcells{subjectind}=[xcorr_stats.connectedcells{subjectind}; uniti unitj];
                        xcorr_stats.distance{subjectind}=[xcorr_stats.distance{subjectind} pairwise_dist{uniti}{unitj}];
                        
                    elseif do_quickplots=='y'
                        hold off
                        plot(corrtimebins, xcorr_observed,'k')
                        hold on
                        plot(corrtimebins, upperbound_error,'r')
                        plot(corrtimebins, lowerbound_error,'r')
                        xlabel(['lag time (ms)'])
                        ylabel(['# spikes'])
                        title(['unit ' num2str(uniti) ' vs ' num2str(unitj) ' (' plotlabel1 ' vs ' plotlabel2 '); sig. +ve correlation (d=' num2str(pairwise_dist{uniti}{unitj}) ' mm).'])
                        figure(1)
                        
                        is_sig=[];
                        is_sig=input('Is this cross-correlation significant (y/n)? [y]: ', 's');
                        if isempty(is_sig)==1
                            is_sig='y';
                        end
                        
                        if is_sig=='y'
                            distance_sigpairs=[distance_sigpairs pairwise_dist{uniti}{unitj}];
                            distance_sigpospairs=[distance_sigpospairs pairwise_dist{uniti}{unitj}];
                            significant_pairs{uniti}{unitj}=1;
                            significant_pairs{unitj}{uniti}=1;
                        end
                        
                        hold off
                    end
                    
                    continue
                    
                elseif min(diff(lowersigpoints))<=minconsec & abs(min(lower_corrected_xcorr(timerange)))>max(upper_corrected_xcorr(timerange)) & pairwise_dist{uniti}{unitj}<=max_plotdistance
                    
                    spikecountsi=histc(spiketimes{uniti},longtimebins);  %binned spike counts.
                    spikecountsj=histc(spiketimes{unitj},longtimebins);  %binned spike counts.
                    new_xcorr_observed=xcorr(spikecountsi, spikecountsj, plot_maxlag);
                    
                    backgroundcorr=mean(new_xcorr_observed([1:round(plot_maxlag/2) round(1.5*plot_maxlag:2*plot_maxlag)]));
                    
                    all_xcorr=[all_xcorr; new_xcorr_observed/backgroundcorr];  %normalize by the mean value.
                    neg_xcorr=[neg_xcorr; new_xcorr_observed/backgroundcorr];  %normalize by the mean value.
                    
                    if do_quickplots=='n'
                        
                        distance_sigpairs=[distance_sigpairs pairwise_dist{uniti}{unitj}];
                        distance_signegpairs=[distance_signegpairs pairwise_dist{uniti}{unitj}];
                        significant_pairs{uniti}{unitj}=-1;
                        significant_pairs{unitj}{uniti}=-1;
                        actualconnections=actualconnections+1;
                        xcorr_stats.connectedcells{subjectind}=[xcorr_stats.connectedcells{subjectind}; uniti unitj];
                        xcorr_stats.distance{subjectind}=[xcorr_stats.distance{subjectind} pairwise_dist{uniti}{unitj}];
                        
                    elseif do_quickplots=='y'
                        hold off
                        plot(corrtimebins, xcorr_observed,'k')
                        hold on
                        plot(corrtimebins, upperbound_error,'r')
                        plot(corrtimebins, lowerbound_error,'r')
                        xlabel(['lag time (ms)'])
                        ylabel(['# spikes'])
                        title(['unit ' num2str(uniti) ' vs ' num2str(unitj) ' (' plotlabel1 ' vs ' plotlabel2 '); sig. -ve correlation (d=' num2str(pairwise_dist{uniti}{unitj}) ' mm).'])
                        figure(1)
                        
                        is_sig=[];
                        is_sig=input('Is this cross-correlation significant (y/n)? [y]: ', 's');
                        if isempty(is_sig)==1
                            is_sig='y';
                        end
                        
                        if is_sig=='y'
                            distance_sigpairs=[distance_sigpairs pairwise_dist{uniti}{unitj}];
                            distance_signegpairs=[distance_signegpairs pairwise_dist{uniti}{unitj}];
                            significant_pairs{uniti}{unitj}=-1;
                            significant_pairs{unitj}{uniti}=-1;
                        end
                        
                        hold off
                    end
                end
            end
        end
        
        xcorr_stats.actualconnections(subjectind)=actualconnections;                 %number of connections between min_unitseparation and max_radius.
        xcorr_stats.possibleconnections(subjectind)=possibleconnections;                 %number of connections between min_unitseparation and max_radius.
        xcorr_stats.connection_prob(subjectind)=actualconnections/possibleconnections;   %probability of finding a significantly connected pair of cells between min_unitseparation and max_radius.
        
    elseif spikes_or_bursts1=='b' | spikes_or_bursts2=='b'
        %in progress.
    end
    
    connectivity_matrix=[];
    for i=1:length(unitorder1);
        uniti=unitorder1(i);
        for j=1:length(unitorder2);
            unitj=unitorder2(j);
            connectivity_matrix(i,j)=significant_pairs{uniti}{unitj};  %note: diagonals will be zero because of exclusion of uniti=unitj.  Also note that pairs closer than min_unitseparation will appear unconnected.
        end
    end
    
    figure(figindi)     %plot correlation coefficient matrix (a la Olaf Sporns network connectivity matrix)
    set(gcf,'Position',[0.35*scrsz(1)+500 0.35*scrsz(2)+100 0.35*scrsz(3) 0.35*scrsz(4)])
    
    imagesc(connectivity_matrix, [-1 1])
    axis square
    colorbar
    c=[0 0 1; 1 1 1; 1 0 0];  %three-point color map matrix
    colormap(c)  %red white blue color map
    title([subject ' connectivity matrix from significant (p<' num2str(max_pvalue) ') cross-correlation pairs'],'FontSize',8)
    xlabel('units ordered by depth & shaft', 'FontSize',8)
    set(gca,'FontSize',8,'TickDir','out')
    close(figindi)
    figindi=figindi+1;
    
    
end
%****************************************

xcorr_stats.celltype1=plotlabel1;
xcorr_stats.celltype2=plotlabel2;


%***connection probability vs. distance***
sigpaircounter=length(distance_sigpairs);
disp([num2str(length(distance_sigpospairs)) '/' num2str(sigpaircounter) ' pairs are positively correlated and ' num2str(length(distance_signegpairs)) '/' num2str(sigpaircounter) ' pairs are negatively correlated.'])
if length(distance_sigpairs)>0
    
    [allbincount,allbinindex]=histc(distance_allpairs,distance);
    [bincount,binindex]=histc(distance_sigpairs,distance);
    usedbins=setdiff(unique(allbinindex),0);  %identifies bins with an occupancy number of >=1.
    
    totalpaircounter=0; totalsigpairs=0;
    prob_sigcrosscorr=[]; prob_sig_positivecrosscorr=[]; prob_sig_negativecrosscorr=[]; prob_error_crosscorr=[];
    for currentbin=usedbins;
        total_pairsinbin=length(find(allbinindex==currentbin));  %number of pairs in the current distance bin, including significant and non-significantly cross-correlated pairs.
        sig_pairsinbin=length(find(binindex==currentbin)); %number of pairs in the current distance bin with significant cross-correlation.
        
        totalsigpairs=totalsigpairs+sig_pairsinbin;
        totalpaircounter=totalpaircounter+total_pairsinbin;
        
        prob_sigcrosscorr=[prob_sigcrosscorr sig_pairsinbin/total_pairsinbin];  %probability of finding a significant positive OR negative correlation coefficient (with p<max_pvalue).
        
        [phat,pci]=binofit(sig_pairsinbin,total_pairsinbin,confidence_interval);    %confidence interval that observed number is within binomial distribution. (uses Clopper-Pearson method). alpha=0.05 means find 95% confidence intervals.
        prob_error_crosscorr=[prob_error_crosscorr; pci];
    end
    disp(['Found ' num2str(sigpaircounter) ' of ' num2str(totalpaircounter) ' significantly correlated pairs.'])
    
    disp([num2str(totalsigpairs) '/' num2str(totalpaircounter) ' pairs are significantly coupled.'])
    
    
    figure(100)
    set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.15*scrsz(3) 0.2*scrsz(4)])
    hold off
    errorbar(distance(usedbins), prob_sigcrosscorr, prob_sigcrosscorr'-prob_error_crosscorr(:,1), prob_error_crosscorr(:,2)-prob_sigcrosscorr','ok','MarkerSize', 3,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
    
    xlabel('pairwise distance (mm)', 'FontSize',8)
    ylabel('connection probability', 'FontSize',8)
    title(['prob. of finding significant (p<' num2str(max_pvalue) ') cross-correlation. ' num2str(100*(1-confidence_interval)) '% confidence intervals.'], 'FontSize',8)
    axis([0 max_plotdistance+distance_binsize 0 max(prob_sigcrosscorr)+2*max(prob_error_crosscorr(:,2))])
    set(gca,'FontSize',8,'TickDir','out')
    
    figindi=figindi+1;
    figure(figindi)
    subplot(2,1,1)
    hold off
    plot(plot_corrtime,all_xcorr', '-k')
    hold on
    plot([0 0], [min(min(all_xcorr)) max(max(all_xcorr))])
    % xlabel([plotlabel1 '-' plotlabel2 ' lag (ms)'],'FontSize',8)
    ylabel(['normalized firing probability'],'FontSize',8)
    title(['CCGs for all significantly coupled pairs. Normalized to background.'], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')
    
    subplot(2,1,2)
    hold off
    boundedline(plot_corrtime, mean(all_xcorr), std(all_xcorr)/sqrt(totalsigpairs),'-k')
    hold on
    plot([0 0], [min(mean(all_xcorr)) max(mean(all_xcorr))])
    xlabel([plotlabel1 '-' plotlabel2 ' lag (ms)'],'FontSize',8)
    ylabel(['normalized firing probability'],'FontSize',8)
    set(gca,'FontSize',8,'TickDir','out')
    set(gcf,'Position',[0.35*scrsz(1)+500 0.35*scrsz(2)+650 0.35*scrsz(3) 0.35*scrsz(4)])
    
end

if 1==0 
    xcorr_stats.totalconnected=sum(xcorr_stats.actualconnections);   %total number of unique cell pairs with significant x-corr within radius of min_unitseparation to max_radius
    xcorr_stats.totalpossible=sum(xcorr_stats.possibleconnections);  %total possible number of cell connections among the selected population.
    xcorr_stats.meanprob=mean(xcorr_stats.connection_prob);          %mean connection probability.
    xcorr_stats.sdprob=std(xcorr_stats.connection_prob);             %standard deviation of connection probability.

    xcorr_stats.min_unitseparation=min_unitseparation;
    xcorr_stats.max_radius=max_radius;
    xcorr_stats.LANdensity=xcorr_stats.totalconnected/xcorr_stats.totalpossible;

    xcorr_stats
end