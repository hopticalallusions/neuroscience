     parameters=[];
     
     parameters.filename=filename;
     parameters.rawpath=rawpath;
     parameters.savedir=savedir;
     
     parameters.bestchannel=origtemplates.bestchannel;
     parameters.chanswithspikes=origtemplates.chanswithspikes;
     parameters.dochannels=origtemplates.dochannels;
     parameters.lengthperchan=origtemplates.lengthperchan;
     parameters.channelsetindex=origtemplates.channelsetindex;
     parameters.shaft=origtemplates.shaft;
     parameters.allusechannels=origtemplates.usechannels;
     parameters.templates=meanspikes;
     parameters.origtemplates=originaltemplates;
     parameters.probetype=probetype;
     parameters.badchannels=badchannels;
     
     parameters.minspikesperunit=minspikesperunit;
     parameters.minamplitude=minamplitude;
     parameters.dosets=uniquesets;
     parameters.setperunit=setperunit;
     parameters.channelsperset=channelsperset;
     parameters.noisedochannels=noisedochannels;
     
     parameters.clusterstdev=origcluststdev;
     parameters.mergeclusterstdev=mergeclusterstdev;
     parameters.allcluststdev=allcluststdev;

     parameters.backgroundchans1=backgroundchans1;
     parameters.dotrials=dotrials;
     parameters.trialduration=trialduration;
     parameters.maxtrial=trial;
     parameters.noiseprctile=noiseprctile;
     parameters.detectstdev=detectstdev;
     parameters.samplingrate=samplingrate;
     parameters.f_low=f_low;
     parameters.f_high=f_high;
     parameters.filterpoles=n;
     parameters.minoverlap=minoverlap;
     parameters.rejecttime=rejecttime;
     parameters.leftpoints=leftpoints;
     parameters.rightpoints=rightpoints;
     parameters.upsamplingfactor=upsamplingfactor;
     paramaters.unassignedcounter=unassignedcounter;
    

     save([savedir 'runparameters.mat'],'parameters')
         