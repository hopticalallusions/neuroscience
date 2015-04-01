newparameters=[];    

parameters.filename=filename;
parameters.rawpath=rawpath;
parameters.savedir=savedir;
newparameters.probetype=probetype;
newparameters.badchannels=badchannels;
newparameters.backgroundchans1=backgroundchans1;
newparameters.depthzones=depthzones;
newparameters.channelsets=channelsets;
newparameters.lengthperchan=[];
newparameters.lengthperchan{1}=lengthperchan;

newparameters.shaft=newshaft;
newparameters.badunits=badunits;   %update runparameters.mat file
newparameters.mergeunits=mergeunits;
newparameters.bestchannels=bestchannel;

newparameters.minamplitude=minamplitude;

newparameters.detectstdev=detectstdev;     
newparameters.noiseprctile=noiseprctile;

newparameters.clusterstdev=origclusterstdev;
newparameters.mergeclusterstdev=mergeclusterstdev;
newparameters.allcluststdev=allcluststdev;

newparameters.final_minspikesperunit=final_minspikesperunit;           
newparameters.finalCVtestfactor=finalCVtestfactor;                 
newparameters.finalmergeSDfactor=finalmergeSDfactor;               

newparameters.trainingtrials=trainingtrials;
newparameters.dotrials=dotrials;
newparameters.trialduration=trialduration;
newparameters.maxtrial=maxtrial;

newparameters.samplingrate=samplingrate;
newparameters.f_low=f_low;
newparameters.f_high=f_high;
newparameters.filterpoles=n;
newparameters.minoverlap=minoverlap;
newparameters.rejecttime=rejecttime;
newparameters.leftpoints=origleftpoints;
newparameters.rightpoints=origrightpoints;
newparameters.extraleft=extraleft;
newparameters.extraright=extraright;
newparameters.upsamplingfactor=upsamplingfactor;
    
parameters=newparameters;
     
save([savedir 'final_params.mat'],'parameters')
       