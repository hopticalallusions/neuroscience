unitclass1='all';           %first type of unit used in pairwise comparison. 
unitclass2='all';           %second type of unit used in pairwise comparison. 

use_corr_CS='4';           %if '1' will load pearson_corr_CS1, if '2' will load pearson_corr_CS2, if '3' will load pearson_corr_CS3, if '4' will load pearson_corr_CS4. (if they exist)

correlationtype='noise';   %'noise', 'signal', or 'cosine'.

max_pvalue_pearson=0.01;   %default=0.01. used to determine if Pearson correlation is significant.

confidence_interval=0.05;  %default=0.05;

distance_binsize=0.1;       %size of bin in mm to use for plotting average correlation coefficient & other properties vs distance.
max_plotdistance=1;         %maximum distance in mm to use in correlation vs distance plots.  
min_unitseparation=0.05;    %minimum pairwise separation of units (in mm) to be added to correlation plots. setting minimum separation helps compensate for any possible spike sorting errors.
max_radius=0.5;             %radius for calculating LAN density, and for calculating mean LAN corr. coeff.

only_sameshaft='n';        %if 'y' will only compare units that occur on the same shaft. note: only_samez must be 'n'
only_samez='n';            %if 'y' will only compare units that occur at the same depth +/-0.2 mm. note: only_sameshaft must be 'n'

plotlist=[];               %default=[]; If specify list of cells grouped by subject, then will only plot those cells and will override the onlysigmod setting. e.g., xcorr_stats.connectedcells.

onlysigmod='n';            %if 'y' uses only significantly modulated units (triggered on event 1). used in trigged_spiketimes. note: only applies if triggerevent~=allspikes. 
query_start=0;             %default=0. start time of rate query period relative to event onset. used if onlysigmod='y'. used in get_sigfiring_units.
query_end=8;               %default=8. end time of rate query period relative to event onset. used if onlysigmod='y'. used in get_sigfiring_units.
max_pvalue_sigfiring=0.01; %default=0.05. threshold for accepting event-triggered firing rate changes as significant. used in get_sigfiring_units.

plotpearsonmatrix='n';
%************************************************
use_sig_event=use_corr_CS;      %if '1' will determine firing significance from event1; if '2' will use event 2.  If 'either' will require significance on either event 1 or 2.  Used in get_sigfiring_units.
only_positive_negative='positive';  %default='positive'. if 'positive' will only use positively correlated pairs; if 'negative' will only use negatively correlated pairs; if 'both' will use both pos and neg correlated pairs.  
baseline_start=-5; 
baseline_end=0;
smoothingwindow='y';       %default='y' for plot_pearson. used in event_trigrates. does not affect calculate of correlation coefficients.
triggerevent2='none';     %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'none'.                               
trialselection2='unrewarded';     %select which event2 trials to display. same options as trialselection1.
triggerevent3='none';     %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.    
subselect1='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1.  '[a b c]' will use the designated trials.          
subselect2='all';           %optional subselection of trials.  'all' will use all trials from trialselection 1.  '[a b c]' will use the designated trials.          

distance=min_unitseparation:distance_binsize:(max_plotdistance+distance_binsize);

domultisubject='y';
backgroundchans1=['all'];            %default=['all']. can leave empty or write numeric list. The channels in the current set are not used in backgroundchans.  badchannels are removed from this list.
samplingrate=25000;
qualitycutoff=1;           %default=1. unit qualities: 1, 2, 3. 1=best, 2=medium quality, 3=not single-unit. used in select_douniters.
trialgroupsize=10;         %used in select_triggers_trials
grouptimebinsize=0.1;


figindi=1;
scrsz=get(0,'ScreenSize');

if strcmp(use_corr_CS,'1')
    disp(['Doing Pearson analysis around CS1'])
elseif strcmp(use_corr_CS,'2')
    disp(['Doing Pearson analysis around CS2'])
end

initialize_scatvars='y';

if initialize_scatvars=='y'
disp('resetting scatter plot variables. ')
scatplot_distance=[]; scatplot_ccoef=[]; scatplot_pvalue=[]; 
pearsonstats=[];
    
    close_figures=[];
    close_figures=input('Do you want to close the figures and plot on fresh graph (y/n) [y]: ', 's');
    if isempty(close_figures)==1
        close_figures='y';
    end
    
    if close_figures=='y'
        close all
    end

    set_plotcolor=[];
    set_plotcolor=input('Select a color for the plots [blac(k)]: ', 's');
    if isempty(set_plotcolor)==1
        set_plotcolor='k';
    end   
end

selectedpaths=uipickfiles('FilterSpec','C:\data analysis\');  %prompts to pick subjects.

get_subject_dir

analysisdrivename=subjects{1}(1);
combinedir = [analysisdrivename ':\data analysis\figures\'];
if isdir(combinedir) == 0
   mkdir(combinedir)
end

for subjectind = 1:length(subjects)
    rawpath = [subjects{subjectind} '\'];
    savedir = [rawpath 'single-unit\'];
    timesdir = [savedir 'sortedtimes\'];
    unitclassdir = [savedir 'properties\'];
    stimulidir = [rawpath '\stimuli\'];
    stimephysdir = [rawpath 'stim-ephys\'];
    
    get_file_subject_name
        
    pearsonstats.subjects{subjectind}=subject;   
    
    clear pearson_corr pearson_cc
    
    if exist([savedir 'pearson_corr_CS1 ' correlationtype '.mat']) & strcmp(use_corr_CS,'1')
    filespec=['pearson_corr_CS1 ' correlationtype '.mat'];
    load([savedir filespec])
    elseif exist([savedir 'pearson_corr_CS2 ' correlationtype '.mat']) & strcmp(use_corr_CS,'2')
    filespec=['pearson_corr_CS2 ' correlationtype '.mat'];
    load([savedir filespec])
    elseif exist([savedir 'pearson_corr_CS3 ' correlationtype '.mat']) & strcmp(use_corr_CS,'3')
    filespec=['pearson_corr_CS3 ' correlationtype '.mat'];
    load([savedir filespec])
    elseif exist([savedir 'pearson_corr_CS4 ' correlationtype '.mat']) & strcmp(use_corr_CS,'4')
    filespec=['pearson_corr_CS4 ' correlationtype '.mat'];
    load([savedir filespec])
    else
    filespec=uigetfile([savedir 'pearson_corr*'], 'select the pearson_corr file for use in signifance test');
    load([savedir filespec])
        if strcmp(filespec, 'pearson_cc.mat')
        pearson_corr=pearson_cc;
        end
    end
    
    triggerevent1=pearson_corr.triggerevent1;
    trialselection1=pearson_corr.trialselection1;
    timebinsize=pearson_corr.timebinsize;
    preeventtime=pearson_corr.preeventtime;
    posteventtime=pearson_corr.posteventtime;
    eventtrig_corrcoef=pearson_corr.eventtrig_corrcoef;
    corrcoef_pvalue=pearson_corr.corrcoef_pvalue;
    grouptimebins=-preeventtime:grouptimebinsize:posteventtime;

    load_results

    select_triggers_trials 

    disp([subject])

    timebins=-preeventtime:timebinsize:posteventtime;
    grouptimebins=-preeventtime:grouptimebinsize:posteventtime;

    lickbinsize=0.05;  
    licktimebins=-preeventtime:lickbinsize:posteventtime;

    if length(licktimes)>0
    get_lickproperties
    end
    
    orig_dounits=dounits;    
    if strcmp(triggerevent1,'allspikes')
    unit_depths=[];
    for unitind=1:length(dounits);
        unitj=dounits(unitind);
        unit_depths=[unit_depths unitz{unitj}];
    end
    else
    max_pvalue=max_pvalue_sigfiring;
    trigged_spiketimes   %event-triggered spike times. Also generates some latency plots if event1 & event2 are CS1, CS2 respectively.
    end
    
%     %***************************  
%     unitinds=find(cell2mat(unitz)>-4);    %SELECT ONLY UNITS IN DORSAL STRIATUM.
%     dounits=dounits(unitinds);    
%     if length(dounits)<2
%         continue
%     end
%     %****************************
    
    if strcmp(unitclass1,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass1));
    dounits1=orig_dounits(unitclassinds);
    dounits1=intersect(dounits1, dounits);
    plotlabel1=unitclassnames{dounits1(1)};
    else
    dounits1=dounits;
    plotlabel1=['all'];
    end
   
  
    if strcmp(unitclass2,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass2));
    dounits2=orig_dounits(unitclassinds);
    dounits2=intersect(dounits2, dounits);
    plotlabel2=unitclassnames{dounits2(1)};
    else
    dounits2=dounits;
    plotlabel2=['all'];
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

    pairwise_dist=[]; did_pairs=[];
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
            did_pairs{uniti}{unitj}='n';
        end
    end
    
    pearsonstats.cell1number{subjectind}=length(dounits1);
    pearsonstats.cell2number{subjectind}=length(dounits2);
    
    pearsonstats.onlysigmod=onlysigmod; 
    pearsonstats.use_corr_CS=use_corr_CS; 
    pearsonstats.max_pvalue_sigfiring=max_pvalue_sigfiring; 
    pearsonstats.max_pvalue_pearson=max_pvalue_pearson;

    pearsonstats.connectedcells{subjectind}=[];    
    pearsonstats.pearson{subjectind}=[];
    pearsonstats.distance{subjectind}=[];

    max_pvalue=max_pvalue_pearson;
    
    possibleconnections=0; actualconnections=0; connected_corrcoefs=[];
    for unitindi=1:length(dounits1);
        uniti=dounits1(unitindi);
       
        for unitindj=1:length(dounits2);
            unitj=dounits2(unitindj);                    
             
            if uniti~=unitj & did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation & pairwise_dist{uniti}{unitj}<max_radius
                possibleconnections=possibleconnections+1;
            end
            
            if uniti~=unitj & did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation & pairwise_dist{uniti}{unitj}<max_radius & corrcoef_pvalue{uniti}{unitj}<max_pvalue/2 & eventtrig_corrcoef{uniti}{unitj}>0
                actualconnections=actualconnections+1;
                connected_corrcoefs=[connected_corrcoefs eventtrig_corrcoef{uniti}{unitj}];
            end                
            
            if pairwise_dist{uniti}{unitj}>=min_unitseparation & corrcoef_pvalue{uniti}{unitj}<max_pvalue/2 & eventtrig_corrcoef{uniti}{unitj}>0
                pearsonstats.connectedcells{subjectind}=[pearsonstats.connectedcells{subjectind}; uniti unitj];    
                pearsonstats.pearson{subjectind}=[pearsonstats.pearson{subjectind}; eventtrig_corrcoef{uniti}{unitj}];
                pearsonstats.distance{subjectind}=[pearsonstats.distance{subjectind}; pairwise_dist{uniti}{unitj}];
            end
            
            if uniti~=unitj & did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation & only_sameshaft=='y' & only_samez=='n' & s.shaft(bestchannels{uniti})==s.shaft(bestchannels{unitj})  %doesn't double-count pairs, and only considers units separated by >= specified distance (to minimize likelihood of spike sorting errors contaminating the C-C analysis).
            scatplot_distance=[scatplot_distance pairwise_dist{uniti}{unitj}];  
            scatplot_ccoef=[scatplot_ccoef eventtrig_corrcoef{uniti}{unitj}];
            scatplot_pvalue=[scatplot_pvalue corrcoef_pvalue{uniti}{unitj}];
            did_pairs{uniti}{unitj}='y'; did_pairs{unitj}{uniti}='y';               
            elseif uniti~=unitj & did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation & only_sameshaft=='n' & only_samez=='y' & abs(unitz{uniti}-unitz{unitj})<0.2 %& abs(unitx{uniti}-unitx{unitj})<0.1  & s.shaft(bestchannels{uniti})==s.shaft(bestchannels{unitj})  %doesn't double-count pairs, and only considers units separated by >= specified distance (to minimize likelihood of spike sorting errors contaminating the C-C analysis).
            scatplot_distance=[scatplot_distance pairwise_dist{uniti}{unitj}];  
            scatplot_ccoef=[scatplot_ccoef eventtrig_corrcoef{uniti}{unitj}];
            scatplot_pvalue=[scatplot_pvalue corrcoef_pvalue{uniti}{unitj}];
            did_pairs{uniti}{unitj}='y'; did_pairs{unitj}{uniti}='y';
            elseif uniti~=unitj & did_pairs{uniti}{unitj}=='n' & pairwise_dist{uniti}{unitj}>=min_unitseparation & only_sameshaft=='n' & only_samez=='n' 
            scatplot_distance=[scatplot_distance pairwise_dist{uniti}{unitj}];  
            scatplot_ccoef=[scatplot_ccoef eventtrig_corrcoef{uniti}{unitj}];
            scatplot_pvalue=[scatplot_pvalue corrcoef_pvalue{uniti}{unitj}];
            did_pairs{uniti}{unitj}='y'; did_pairs{unitj}{uniti}='y';            
            end   
                              
        end
    
    end
    
    
    pearsonstats.actualconnections(subjectind)=actualconnections;                 %number of unique connections between min_unitseparation and max_radius.
    pearsonstats.possibleconnections(subjectind)=possibleconnections;                 %number of unique possible connections between min_unitseparation and max_radius.
    pearsonstats.density(subjectind)=actualconnections/possibleconnections;   %probability of finding a significantly correlated pair of cells between min_unitseparation and max_radius.
    pearsonstats.mean_corrcoef(subjectind)=mean(connected_corrcoefs);  %mean correlation coefficient of all the significant positively correlated cell pairs.
    pearsonstats.corrcoefinradius{subjectind}=connected_corrcoefs;
      
    %****correlation coefficient matrices for each subject****

    if plotpearsonmatrix=='y'

    pearson_matrix=[]; sig_pearson_matrix=[];
    for i=1:length(unitorder1);
        uniti=unitorder1(i);
        for j=1:length(unitorder2);
            unitj=unitorder2(j);
            if did_pairs{uniti}{unitj}=='n'
            continue
            end
            pearson_matrix(i,j)=eventtrig_corrcoef{uniti}{unitj};
            if isnan(pearson_matrix(i,j))
            pearson_matrix(i,j)=0;
            end
            if corrcoef_pvalue{uniti}{unitj}<max_pvalue/2 & pairwise_dist{uniti}{unitj}>=min_unitseparation & eventtrig_corrcoef{uniti}{unitj}>0 %assigns +1 to all sig. positively correlated pairs. exclude units closer than min_unitseparation to compensate for any possible spike sorting errors.
            sig_pearson_matrix(i,j)=1;    %signifance correlation matrix is a binary matrix with 1=significant cc and 0=n.s.
            elseif corrcoef_pvalue{uniti}{unitj}<max_pvalue/2 & pairwise_dist{uniti}{unitj}>=min_unitseparation & eventtrig_corrcoef{uniti}{unitj}<0 %assigns -1 to all significant negatively correlated pairs.
            sig_pearson_matrix(i,j)=-1;    %signifance correlation matrix is a binary matrix with 1=significant cc and 0=n.s.
            else sig_pearson_matrix(i,j)=0;
            end
        end
    end

        
    figure(figindi)     %plot correlation coefficient matrix (a la Olaf Sporns network connectivity matrix)
    set(gcf,'Position',[0.35*scrsz(1)+500 0.35*scrsz(2)+200 0.7*scrsz(3) 0.7*scrsz(4)])   

    subplot(2,1,1)
    hold off
    imagesc(pearson_matrix, [-0.2 0.2])
    axis square
    colorbar
    colormap('jet')  %red white blue color map

    hold on
    numberofunits1=0.5; numberofunits2=0.5;   %draw lines dividing correlation matrix by shaft.
    for shaftind=1:(length(uniqueshafts)-1);
        currentshaft=uniqueshafts(shaftind);
        unitsonshaft1=find(parameters.shafts==currentshaft);
        unitsonshaft1=intersect(origunitorder1,unitsonshaft1,'stable');
        numberofunits1=numberofunits1+length(unitsonshaft1);
        line([numberofunits1 numberofunits1], [0 length(unitorder2)+0.5])
    
        unitsonshaft2=find(parameters.shafts==currentshaft);
        unitsonshaft2=intersect(origunitorder2,unitsonshaft2,'stable');
        numberofunits2=numberofunits2+length(unitsonshaft2);
        line([0 length(unitorder2)+0.5], [numberofunits2 numberofunits2])
    end

    title([subject ', ' plotlabel1 ' vs ' plotlabel2 ' pair correlation coefficients'],'FontSize',8)
    xlabel('units ordered by depth & shaft', 'FontSize',8)
    set(gca,'FontSize',8,'TickDir','out')

    subplot(2,1,2)
    hold off
    imagesc(sig_pearson_matrix, [-1 1])
    axis square
    colorbar
    % c=[0 0 1; 1 1 1; 1 0 0];  %three-point color map matrix
    % colormap(c)  %red white blue color map
    title([plotlabel1 ' vs ' plotlabel2 ' pairs with sig. corr. coeffs. (p<' num2str(max_pvalue) '), excluding units closer than ' num2str(min_unitseparation) ' mm'],'FontSize',8)
    xlabel('units ordered by depth & shaft', 'FontSize',8)
    set(gca,'FontSize',8,'TickDir','out')

    hold on
    numberofunits1=0.5; numberofunits2=0.5;  %draw lines dividing correlation matrix by shaft.
    for shaftind=1:(length(uniqueshafts)-1);
        currentshaft=uniqueshafts(shaftind);
        unitsonshaft1=find(parameters.shafts==currentshaft);
        unitsonshaft1=intersect(origunitorder1,unitsonshaft1,'stable');
        numberofunits1=numberofunits1+length(unitsonshaft1);
        line([numberofunits1 numberofunits1], [0 length(unitorder2)+0.5])
    
        unitsonshaft2=find(parameters.shafts==currentshaft);
        unitsonshaft2=intersect(origunitorder2,unitsonshaft2,'stable');
        numberofunits2=numberofunits2+length(unitsonshaft2);
        line([0 length(unitorder2)+0.5], [numberofunits2 numberofunits2])
    end

    figindi=figindi+1;
    
    end


end


%******************************************
pearsonstats.celltype1=plotlabel1;
pearsonstats.celltype2=plotlabel2;

[bincount,binindex]=histc(scatplot_distance,distance);
usedbins=setdiff(unique(binindex),0);  %excludes bins that fall outside distance vector (i.e. zeros)

mean_corrcoef=[]; sem_corrcoef=[]; mean_sig_corrcoef=[]; sem_sig_corrcoef=[];
prob_sigcorr=[]; prob_sig_positivecorr=[]; prob_sig_negativecorr=[]; probability_error=[];  possibleconnections=length(scatplot_pvalue); totalsigneg=0; totalsigpos=0;
for currentbin=usedbins;
    inds=find(binindex==currentbin);
    scatplot_ccoefsi=scatplot_ccoef(inds);
    scatplot_ccoefsi=scatplot_ccoefsi(find(scatplot_ccoefsi>=0));
    mean_corrcoef=[mean_corrcoef nanmean(scatplot_ccoefsi)];  %mean corr coef of positive corr. coef.
    sem_corrcoef=[sem_corrcoef nanstd(scatplot_ccoefsi)/sqrt(length(scatplot_ccoefsi))];   %error bars are SEM, SEM=std/sqrt(N) where N=# of samples.
   
    pvaluesi=scatplot_pvalue(inds);
    corrcoefsi=scatplot_ccoef(inds);
    siginds=find(pvaluesi<max_pvalue/2);
    sigcorrcoefs=corrcoefsi(siginds);   
        
    prob_sig_positivecorr=[prob_sig_positivecorr length(find(sigcorrcoefs>0))/length(inds)];  %probability of finding a significant positive correlation coefficient (with p<max_pvalue).
    prob_sig_negativecorr=[prob_sig_negativecorr length(find(sigcorrcoefs<0))/length(inds)];   %probability of finding a significant negative correlation coefficient (with p<max_pvalue).
   
    totalsigpos=totalsigpos+length(find(sigcorrcoefs>0));
    totalsigneg=totalsigneg+length(find(sigcorrcoefs<0));
        
    if strmatch(only_positive_negative,'positive') 
        prob_sigcorr=prob_sig_positivecorr;
        [phat,pci]=binofit(length(find(sigcorrcoefs>0)),length(inds),confidence_interval);      
        sigcorrinds=find(sigcorrcoefs>0);     
    elseif  strmatch(only_positive_negative,'negative') 
        prob_sigcorr=prob_sig_negativecorr;
        [phat,pci]=binofit(length(find(sigcorrcoefs<0)),length(inds),confidence_interval);
        sigcorrinds=find(sigcorrcoefs<0);
    elseif  strmatch(only_positive_negative,'both') 
        prob_sigcorr=[prob_sigcorr length(siginds)/length(inds)];  %probability of finding a significant positive OR negative correlation coefficient (with p<max_pvalue).    
        [phat,pci]=binofit(length(siginds),length(inds),confidence_interval);    %confidence interval that observed number is within binomial distribution. (uses Clopper-Pearson method). alpha=0.05 means find 95% confidence intervals.
        sigcorrinds=1:length(sigcorrcoefs);
    end
        
    probability_error=[probability_error; pci];  
        
    mean_sig_corrcoef=[mean_sig_corrcoef nanmean(sigcorrcoefs(sigcorrinds))]; 
    sem_sig_corrcoef=[sem_sig_corrcoef nanstd(sigcorrcoefs(sigcorrinds))/sqrt(length(sigcorrinds))]; 
 
    
end 

disp([num2str(totalsigpos) '/' num2str(possibleconnections) ' pairs are sig positively correlated, ' num2str(totalsigneg) '/' num2str(possibleconnections) ' pairs are sig negatively correlated.'])


figure(100)

set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.15*scrsz(3) 0.8*scrsz(4)])   
subplot(4,1,1)
hold on
plot(scatplot_distance,scatplot_ccoef,'o','MarkerSize', 3, 'MarkerFaceColor', set_plotcolor,'MarkerEdgeColor',set_plotcolor)
ylabel('corr. coef.', 'FontSize',8)
title([plotlabel1 ' vs ' plotlabel2 ', event-triggered \rho.'], 'FontSize',8)
axis([0 max_plotdistance min(scatplot_ccoef)-0.1 max(scatplot_ccoef)+0.01])
set(gca,'FontSize',8,'TickDir','out')

subplot(4,1,2)
hold on
errorbar(distance(usedbins), mean_corrcoef, sem_corrcoef, ['o' set_plotcolor],'MarkerSize', 3,'MarkerEdgeColor', set_plotcolor, 'MarkerFaceColor',set_plotcolor)
% xlabel('pairwise distance (mm)', 'FontSize',8)
ylabel('mean positive \rho', 'FontSize',8)
title('Pearson \rho (mean+/-SEM, non-sig+sig pairs)', 'FontSize',8)
axis([0 max_plotdistance 0 1.5*(max(mean_corrcoef)+max(sem_corrcoef))])
set(gca,'FontSize',8,'TickDir','out')

subplot(4,1,3)
hold on
errorbar(distance(usedbins), prob_sigcorr, prob_sigcorr'-probability_error(:,1), probability_error(:,2)-prob_sigcorr', ['o' set_plotcolor],'MarkerSize', 3,'MarkerEdgeColor',set_plotcolor, 'MarkerFaceColor',set_plotcolor)
ylabel('probability', 'FontSize',8)
title(['prob. of sig (p<' num2str(max_pvalue) ') \rho' '. ' num2str(100*(1-confidence_interval)) '% confidence intervals.'], 'FontSize',8)
axis([0 max_plotdistance 0 0.5])
set(gca,'FontSize',8,'TickDir','out')

subplot(4,1,4)
hold on
errorbar(distance(usedbins), mean_sig_corrcoef, sem_sig_corrcoef, ['o' set_plotcolor],'MarkerSize', 3,'MarkerEdgeColor', set_plotcolor, 'MarkerFaceColor',set_plotcolor)
% xlabel('pairwise distance (mm)', 'FontSize',8)
ylabel('<corr. coef.>', 'FontSize',8)
title('Pearson \rho (mean+/-SEM, only sig pairs)', 'FontSize',8)
axis([0 max_plotdistance 0 1.5*(max(mean_sig_corrcoef)+max(sem_sig_corrcoef))])
xlabel('pairwise distance (mm)', 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

hold off


% %*******Network topology analysis*******
% if strcmp(plotlabel1,plotlabel2)==0
%     disp(['Network topology: cell 1 is not equal to cell 2; network topology measures cannot be applied.'])
%     
% else disp(['Network topology metrics:'])
% all_clustercoeffs=[]; all_degrees=[];
% for subjectind=1:length(subjects);
% connections=pearsonstats.connectedcells{subjectind};
% numberofunits=pearsonstats.cell1number{subjectind};
% vertices=unique(connections(:,1));
% 
%     for vind=1:length(vertices)
%         vertexi=vertices(vind);
%         neighbors=connections(find(connections(:,1)==vertexi),2);
%         if length(neighbors)<2
%             continue
%         end
%         degree=length(neighbors);
%         all_degrees=[all_degrees degree];  %normalize by numberofunits to account for subject differences in unit number.
%         observednodes=0; 
%         possiblenodes=degree*(degree-1);  %do not divide by two because we consider each connection in the neighborhood twice (for loop below).
%         for i=1:degree
%             neighbori=neighbors(i);
%             allconnectedcells=connections(find(connections(:,1)==neighbori),2);  %all cells that neighbori is connected to.
%             allconnectedneighbors=intersect(allconnectedcells,neighbors);  %all cells that neighbori is connected to which are also neighbors of vertexi. 
%             observednodes=observednodes+length(allconnectedneighbors);
%         end
%         all_clustercoeffs=[all_clustercoeffs observednodes/possiblenodes];
%     
%     end
%         
% end

% mean_clustercoeff=mean(all_clustercoeffs);
% sem_clustercoeff=std(all_clustercoeffs)/sqrt(length(all_clustercoeffs));
% mean_degree=mean(all_degrees);
% sem_degree=std(all_degrees)/sqrt(length(all_degrees));
% 
% disp(['network clustering coefficient=' num2str(mean_clustercoeff) '+/-' num2str(sem_clustercoeff) ' (mean+/-sem).'])
% disp(['network degree=' num2str(mean_degree) '+/-' num2str(sem_degree) '.'])
% 
% pearsonstats.mean_clustercoeff=mean_clustercoeff;
% % pearsonstats.sem_clustercoeff=sem_clustercoeff;
% pearsonstats.mean_degree=mean_degree;
% % pearsonstats.sem_degree=sem_degree;
% % pearsonstats.all_clustercoeffs=all_clustercoeffs;
% % pearsonstats.all_degrees=all_degrees;
% 
% end

pearsonstats.totalconnected=sum(pearsonstats.actualconnections);      %total number of unique cell pairs with significant Pearson rho within radius of min_unitseparation to max_radius
pearsonstats.totalpossible=sum(pearsonstats.possibleconnections);     %total possible number of unique pairwise cell connections among the selected population.

pearsonstats.min_unitseparation=min_unitseparation;
pearsonstats.max_radius=max_radius;
pearsonstats.LANdensity=pearsonstats.totalconnected/pearsonstats.totalpossible;   %local area network density.
pearsonstats.meanpearson=mean(cell2mat(pearsonstats.corrcoefinradius));   %mean pearson of significantly correlated cell pairs.
pearsonstats.sdpearson=std(cell2mat(pearsonstats.corrcoefinradius));

pearsonstats


