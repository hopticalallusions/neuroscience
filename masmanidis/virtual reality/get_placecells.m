%Automated place cell plotter

%***Set VR parameters*******
min_mazeposition=0;
max_mazeposition=1.7;

mazebinsize=0.05;

numberofrooms=4;
%***************************

close all
load_results

VRtimebins=1/velocitysamplingrate:1/velocitysamplingrate:length(stimuli.motionVR)/velocitysamplingrate;
posbins=min_mazeposition:mazebinsize:(max_mazeposition);

[numberxinbin,xbinname]=histc(motionVR,posbins);  %numberxinbin is number of samples that occured in a particular position bin.
   
rate_position=[];
for unitind=1:length(dounits)
    unitj=dounits(unitind);
    stimesj=spiketimes{unitj};

    [numberspikesinbin,tbinname]=histc(stimesj,VRtimebins); %numberspikesinbin will count the number of spikes in time bins 

    spikesperbin=[]; 
    for posbinind=1:length(posbins);  
                                    
        bini=find(xbinname==posbinind);   % for whenever xbinname is the posbinind we'll add that to bini (there will be a lot).
        spikesinbini=sum(numberspikesinbin(bini)); 
        spikesperbin=[spikesperbin spikesinbini]; 
                                     
    end

    rate_posj=(spikesperbin*velocitysamplingrate)./numberxinbin; %firing rate normalized by the occupancy of each bin to remove any position preference bias in spike counting.
    rate_posj(isnan(rate_posj))=[]; 
    
    rate_position{unitj}=rate_posj;
    
    plotposbins=posbins(1:(length(posbins)-1));
    figure(1)
    hold off
    plot([plotposbins plotposbins+max_mazeposition], [rate_posj(1:(length(posbins)-1)) rate_posj(1:(length(posbins)-1))])  %repeat the plot twice to clearly see any place effects near maze boundaries
    
    hold on
    for roomind=1:2*numberofrooms
    plot([(roomind-1)*max_mazeposition/numberofrooms (roomind-1)*max_mazeposition/numberofrooms], [0 max(rate_posj)], '--r') 
    end
    axis tight
       
%     boundedline(posbins(1:(length(posbins)-1)), renormtimes, SDrate, '-r')     %do not use 'alpha' (transparent shading) because this will mess up eps export.

    ylabel('firing rate (Hz)')
    xlabel('maze distance traveled (m)')
    title(['unit ' num2str(unitj)])
    set(gca,'TickDir','out')
   
input('d')   
end