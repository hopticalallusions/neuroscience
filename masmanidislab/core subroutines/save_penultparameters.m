     parameters.badunits=badunits;   %update runparameters.mat file
     parameters.bestchannel=newbestchan;
     parameters.chanswithspikes=newchanswithspikes;
     parameters.dochannels=newdochannels;
     parameters.lengthperchan=newlengthperchan;
     parameters.channelsetindex=newchannelsetindex;
     parameters.shaft=newshaft;
     parameters.allusechannels=allusechannels;
     parameters.templates=newmeanspikes;
     parameters.origtemplates=origmeans;
     parameters.finalminspikesperunit=final_minspikesperunit;   
     parameters.maxcluststdev=maxcluststdev;
     parameters.maxtrial=maxtrial;
     
     save([timesdir 'penultimate_params.mat'],'parameters')
       