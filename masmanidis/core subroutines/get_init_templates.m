
meanspikes=[];
for clustind=1:length(allclusters);
    clust=allclusters(clustind);
    
origdochannels=origtemplates.dochannels{clust};   
dochannels=intersect(origdochannels,allusechannels);        %channels in the current set.

templatei=origtemplates.meanspikes{clust};     
lengthperchan=origtemplates.lengthperchan{clust};

    newtemplate=[];
    for chanind=1:length(dochannels);
        channel=dochannels(chanind);
        origind=find(origdochannels==channel);
        t0=lengthperchan*(origind-1)+1;
        tf=lengthperchan*origind;
        newtemplate=[newtemplate templatei(t0:tf)];
    end
    
    meanspikes{clust}=newtemplate;
    
end
        
originaltemplates=meanspikes;