disp(['Plotting cross-correlations.'])

set_plot_parameters

corrbinsize=0.001;         %default=0.001; note don't need to recalculate ccg if change this parameter.
barrange=0.05;               %0.1 is default. range for plotting cross-correlograms
barincrement=barrange/2;    %increment of tick marks on cross corr graphs.
plotbar='y';                %decides whether to plot cross-correlograms as bar plots or line plots.

% usetimeranges=1;
                             
%************************************************

close all
triggerevent2='none';  %options: 'none'.  (currently not in use in correlations)
triggerevent3='none';  %options: 'none'.  (currently not in use in correlations.)   
trialgroupsize=10;  %not in use in correlations.

load([xcorrdir 'relativetime_params.mat'])
triggerevent1=reltime_params.triggerevent1;
triggerevent2=reltime_params.triggerevent2;
trialselection1=reltime_params.trialselection1;
laserfreqselect=reltime_params.laserfreqselect;
preeventtime=reltime_params.preeventtime;
posteventtime=reltime_params.posteventtime;

format short;

load_results

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

bartime=[-(barrange):(corrbinsize):(barrange+0*corrbinsize)];

mkdir(xcorrjpgdir); mkdir(xcorrepsdir); 

nunits=length(dounits);
    
% for timerangeind=1:length(usetimeranges);
  
    %***Binning cross-correlations according to specified plot interval.*** 
    crosscorrspikes=[];   %initialize time-binned correlation array.
    for i=1:length(dounits); 
        uniti=dounits(i);       
        for j=1:length(dounits);
            unitj=dounits(j);
            crosscorrspikes{uniti}{unitj}=[];
        end
    end

    for i=1:length(dounits);
        uniti=dounits(i); 
    
        load([xcorr_reltimesdir 'relspiketimes_u' num2str(uniti) '.mat'])

        for j=1:length(dounits);
            unitj=dounits(j);
            if i>j
            continue
            end 
            psthij=histc(relspiketimes{unitj}, bartime);
            psthij=psthij(1:(length(psthij)-1));    %added Nov 7 2011.
            crosscorrspikes{uniti}{unitj}=psthij; %/corrbinsize;  %corrbinsize and numberofspikes are normalization factors to produce mean firing rate (Hz).   
        end
        clear relspiketimes
    end
    save([xcorrdir 'binnedcorr.mat'], 'crosscorrspikes', '-MAT')


%***Plot cross-correlations***

if barrange<=0.075 & barrange>=0.025
barincrement=0.025;   %increment of tick marks on cross corr graphs.
elseif barrange<=0.125 & barrange>0.1
    barincrement=0.05;
elseif barrange<=0.15 & barrange>0.125
    barincrement=0.075;
elseif barrange<=0.25 & barrange>0.15
    barincrement=0.1;
elseif barrange<1 & barrange>0.25
    barincrement=0.25;
end

plotbartime=bartime(1:(length(bartime)-1));   %[-(barrange-0.5*corrbinsize):(corrbinsize):(barrange-0.5*corrbinsize)];    %edited Nov 7 2011.
plotbartime=1000*plotbartime;

c=0;
fignumxcorr=nunits+1;
for i=1:length(dounits);
    uniti=dounits(i);
    for j=1:length(dounits);    
     unitj=dounits(j);   
     if length(crosscorrspikes{uniti}{unitj})==0
     continue
     end 
     
     if max(crosscorrspikes{uniti}{unitj})>0
          
        c=c+1;
        if c==17;
        c=1;
        set(gca, 'TickDir', 'out');
        saveas(figure(fignumxcorr),[xcorrjpgdir 'corr_' num2str(fignumxcorr-nunits)  '.jpg' ]  ,'jpg')
        saveas(figure(fignumxcorr),[xcorrepsdir 'corr_' num2str(fignumxcorr-nunits)  '.eps' ]  ,'psc2')
        close(fignumxcorr)
        fignumxcorr=fignumxcorr+1;
        end  
         
     figure(fignumxcorr)   
%      set(gcf,'Position',[scrsz(3)+70 20 0.9*scrsz(3) 0.9*scrsz(4)])
     subplot(4,4,c)
 
     if max(crosscorrspikes{uniti}{unitj})>0
        if plotbar=='n'    %plotbar specified in set_plot_parameters
        plot(plotbartime, crosscorrspikes{uniti}{unitj},'LineWidth',1,'k')  
        elseif plotbar=='y' 
            if length(crosscorrspikes{uniti}{unitj})<length(plotbartime)
            plotbartime=plotbartime(1:length(crosscorrspikes{uniti}{unitj}));
            end
        barfig=bar(plotbartime,crosscorrspikes{uniti}{unitj}(1:length(plotbartime)),1); 
        set(barfig,'FaceColor','k','EdgeColor','k')
        end
        set(gca,'XTick',-1000*barrange:1000*barincrement:1000*barrange,'FontSize',7)    
        hold on 
        line([0 0], [0 1.1*max(crosscorrspikes{uniti}{unitj})],'Color','r','LineStyle','--')
        axis([min(plotbartime) max(plotbartime) 0 1.1*max(crosscorrspikes{uniti}{unitj})])
        xlabel(['t' num2str(uniti) ' - t' num2str(unitj) ' (ms)'], 'FontSize',7)    
        ylabel(['counts'], 'FontSize', 7)
        set( gca, 'TickDir', 'out' );
     end
     
    end
       
    end

end

set( gca, 'TickDir', 'out' );
saveas(figure(fignumxcorr),[xcorrjpgdir 'corr_' num2str(fignumxcorr-nunits)  '.jpg' ]  ,'jpg')
saveas(figure(fignumxcorr),[xcorrepsdir 'corr_' num2str(fignumxcorr-nunits)  '.eps' ]  ,'psc2')
close(fignumxcorr)

disp(['done plotting pairwise correlations'])
