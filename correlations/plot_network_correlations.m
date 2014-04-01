set_plot_parameters

unitclass2='1';           %second type of unit used in pairwise comparison. if have classified units, you can select to either plot 'all' or just one numeric class in plot_unitstack. to check the unit class names go to classify_unitj

max_pvalue=0.01;            %default=0.01. threshold for accepting abs(correlation coefficient) as significant.
minconsec=1;                %default=1. minimum number of consecutive time points that need to exceed uncertainty to be considered significant. 

distance_binsize=0.1;       %size of bin in mm to use for plotting average correlation coefficient & other properties vs distance.
min_unitseparation=0.05;    %minimum pairwise separation of units (in mm) to be added to correlation plots. setting minimum separation helps compensate for any possible spike sorting errors.
max_plotdistance=3;         %maximum distance in mm to use in correlation vs distance plots.  
                    
do_quickplots='y';          %shows the significant cross-correlation plots with the 99th percent confidence intervals.

%************************************************
close all

currentxcorrdir=uigetdir([networkxcorrdir],'Select a "network cross-correlations" folder');
xcorrdatadir=[currentxcorrdir '\unit data\'];
load([currentxcorrdir '\ntwrk_crosscorr_params.mat'])

ntwrksync1=ntwrk_crosscorr_params.ntwrksync1;
spk_burst_ntwrksync2=ntwrk_crosscorr_params.spk_burst_ntwrksync2;
unitclass1=ntwrk_crosscorr_params.unitclass1;
got_unitclass2=ntwrk_crosscorr_params.unitclass2;
got_dounits1=ntwrk_crosscorr_params.dounits1;
got_dounits2=ntwrk_crosscorr_params.dounits2; 

triggerevent1=ntwrk_crosscorr_params.triggerevent1;
trialselection1=ntwrk_crosscorr_params.trialselection1;
timebinsize=ntwrk_crosscorr_params.timebinsize;
preeventtime=ntwrk_crosscorr_params.preeventtime;
posteventtime=ntwrk_crosscorr_params.posteventtime;
maxcorrtime=ntwrk_crosscorr_params.maxcorrtime;
max_jittertime=ntwrk_crosscorr_params.max_jittertime;
maxlag=ntwrk_crosscorr_params.maxlag;
jitter_iterations=ntwrk_crosscorr_params.jitter_iterations;

upperbound_percentile=100*(1-max_pvalue); 
lowerbound_percentile=100*max_pvalue;
timerange=(maxlag-round(1000*max_jittertime)):(maxlag+round(1000*max_jittertime)); %looks for significance in the interval of +/- the jitter time around t=0.
distance=min_unitseparation:distance_binsize:(max_plotdistance+distance_binsize);

initialize_distvars=[];
initialize_distvars=input('Do you want to reset the distance variables (y/n)? [y]: ', 's');
if isempty(initialize_distvars)==1
initialize_distvars='y';
end

if initialize_distvars=='y'
disp('resetting distance variables. ')
distance_sigpairs=[]; distance_sigpospairs=[]; distance_signegpairs=[]; distance_allpairs=[];
end

if strcmp(ntwrksync1,'sync_s')
    label_cell1=['Cell 1 class = ' unitclass1 ' (Sync Spikes)'];
elseif strcmp(ntwrksync1,'sync_b')
    label_cell1=['Cell 1 class = ' unitclass1 ' (Sync Bursts)'];
end
if strcmp(spk_burst_ntwrksync2,'s')
    label_cell2=['Cell 2 class = ' got_unitclass2 ' (Spikes)'];
elseif strcmp(spk_burst_ntwrksync2,'sync_s')
    label_cell2=['Cell 2 class = ' got_unitclass2 ' (Sync Spikes)'];
elseif strcmp(spk_burst_ntwrksync2,'b') 
    label_cell2=['Cell 2 class = ' got_unitclass2 ' (Bursts)'];
elseif strcmp(spk_burst_ntwrksync2,'sync_b') 
    label_cell2=['Cell 2 class = ' got_unitclass2 ' (Sync Bursts)'];
end

disp(['Got cross-correlations on event ' triggerevent1 ' with ' num2str(jitter_iterations) ' jitter iterations.'])
disp(['Got ' label_cell1 ' & ' label_cell2])

if length(strfind(ntwrksync1,'b'))>0  | length(strfind(spk_burst_ntwrksync2,'b'))>0 
slow_or_rapid=ntwrk_crosscorr_params.slow_or_rapid2;   
minburstisi=ntwrk_crosscorr_params.minburstisi2;
minspikesperburst=ntwrk_crosscorr_params.minspikesperburst2;
burstlabel=['burst criteria: minimum ISI = ' num2str(minburstisi) ' s; minimum spikes/burst = ' num2str(minspikesperburst)];
disp(burstlabel)
end

load_results

corrtimebins=(-maxlag:1:maxlag)*1000*timebinsize;

figindi=1;
scrsz=get(0,'ScreenSize');


if strcmp(unitclass1,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass1));
    dounits1=dounits(unitclassinds);
    plotlabel1=['Only using putative ' unitclassnames{dounits1(1)} ' units for the first cell (sync) in the pair'];
else
    dounits1=dounits;
    plotlabel1=['Using all unit classes (or unclassified) for the first cell (sync) in the pair.'];
end
    newdounits1=intersect(dounits1, got_dounits1);  %ensures that only units that were used in get_pairwise_crosscorr will be accessed.
    if length(newdounits1)<length(dounits1)
        disp('***WARNING: the selected unit 1 class attempts to access units that were not used in get_pairwise_crosscorr***')
    end
    dounits1=newdounits1;

disp(plotlabel1)

if strcmp(unitclass2,'all')==0 & uniqueunitclasses(1)~=0
    unitclassinds=find(unitclassnumbers==str2num(unitclass2));
    dounits2=dounits(unitclassinds);
    plotlabel2=['Only using putative ' unitclassnames{dounits2(1)} ' units for the second cell in the pair'];
else
    dounits2=dounits;
    plotlabel2=['Using all unit classes (or unclassified) for the second cell in the pair.'];
end
    newdounits2=intersect(dounits2, got_dounits2);  %ensures that only units that were used in get_pairwise_crosscorr will be acceessed.
    if length(newdounits2)<length(dounits2)
        disp('***WARNING: the selected unit 2 class attempts to access units that were not used in get_pairwise_crosscorr***')
    end
    dounits2=newdounits2;

disp(plotlabel2)


load([xcorrdatadir 'ntwrk_crosscorr.mat'])   

sig_modunits=[];   %list of units that are significantly modulated by the network-level synchronous times.
sig_correlation=[];   %cross-correlation of the significantly modulated units.
for unitindj=1:length(dounits2);
    unitj=dounits2(unitindj);     
                                      
    xcorr_observed=ntwrk_crosscorr.xcorr_observed{unitj};
    xcorr_jittered=ntwrk_crosscorr.xcorr_jittered{unitj};
    upperbound_error=prctile(xcorr_jittered,upperbound_percentile);
    lowerbound_error=prctile(xcorr_jittered,lowerbound_percentile);

    upper_corrected_xcorr=xcorr_observed-upperbound_error;
    lower_corrected_xcorr=xcorr_observed-lowerbound_error;
    
    if length(upper_corrected_xcorr)==0 | length(lower_corrected_xcorr)==0
        continue
    end
        
    uppersigpoints=find(upper_corrected_xcorr(timerange)>0);
    lowersigpoints=find(lower_corrected_xcorr(timerange)<0);
        
    if min(diff(uppersigpoints))<=minconsec & max(upper_corrected_xcorr(timerange))>=abs(min(lower_corrected_xcorr(timerange)))
        
      sig_modunits=[sig_modunits unitj]; 
      sig_correlation{unitj}=xcorr_observed;
          
      if do_quickplots=='y'
      hold off
      plot(corrtimebins, xcorr_observed,'k')
      hold on
      plot(corrtimebins, upperbound_error,'r')
      plot(corrtimebins, lowerbound_error,'r')
      xlabel(['lag time (ms)'])
      ylabel(['# spikes'])
      title([label_cell1 ' vs ' label_cell2 '; sig. +ve correlation.'])
      figure(1)
      input('press any key to continue')
      hold off
      end
         
      continue
      
    elseif min(diff(lowersigpoints))<=minconsec & abs(min(lower_corrected_xcorr(timerange)))>max(upper_corrected_xcorr(timerange))
         
      if do_quickplots=='y'
      hold off
      plot(corrtimebins, xcorr_observed,'k')
      hold on
      plot(corrtimebins, upperbound_error,'r')
      plot(corrtimebins, lowerbound_error,'r')
      xlabel(['lag time (ms)'])
      ylabel(['# spikes'])
      title([label_cell1 ' vs ' label_cell2 '; sig. -ve correlation.'])
      figure(1)
      input('press any key to continue')
      hold off
      end    
      
    end

end
