channelsets=parameters.channelsetindex;
dosets=parameters.dosets;
meanspikes=parameters.templates;
origmeanspikes=parameters.origtemplates;
allusechannels=parameters.allusechannels;
channelsperset=parameters.channelsperset;
setperunit=parameters.setperunit;
noisedochannels=parameters.noisedochannels;


newmeanspikes=[]; origmeans=[]; newtimes=[]; newbaretimes=[]; newjittertimes=[]; newbestchan=[]; newchanswithspikes=[];
newdochannels=[]; newlengthperchan=[]; newchannelsetindex=[]; newshaft=[];
unitcounter=1;  mergeclusts=[]; usedclusts=[];


allinds=setdiff([1:length(meanspikes)],usedclusts);
 
    for ind=1:length(allinds);    %discard units with insufficient number of spikes.
        clust=allinds(ind);
               
        stimesi=spiketimes{clust};
            
            if length(stimesi)<(minspikesperunit+1) 
            continue
            end
          
        newmeanspikes{unitcounter}=parameters.templates{clust};  %average of the templates to be merged.
        origmeans{unitcounter}=parameters.origtemplates{clust};
        newtimes{unitcounter}=stimesi;
        newbaretimes{unitcounter}=baretimes{clust};
        newjittertimes{unitcounter}=jittertimes{clust};
        
        newbestchan{unitcounter}=parameters.bestchannel{clust};
        newchanswithspikes{unitcounter}=parameters.chanswithspikes{clust};
        newdochannels{unitcounter}=parameters.dochannels{clust};        
        newlengthperchan{unitcounter}=parameters.lengthperchan{clust};
        newchannelsetindex{unitcounter}=parameters.channelsetindex{clust};
        newshaft{unitcounter}=parameters.shaft{clust};
        
        unitcounter=unitcounter+1; 
 
    end

spiketimes=newtimes;
baretimes=newbaretimes;
jittertimes=newjittertimes;


disp(['pruned penultimate number of units from ' num2str(length(meanspikes)) ' to ' num2str(length(newtimes)) '.'])
    