newparameters=[];
newparameters.filename=filename;
newparameters.rawpath=rawpath;
newparameters.savedir=savedir;
newparameters.probetype=parameters.probetype;
newparameters.backgroundchans1=parameters.backgroundchans1;
newparameters.badchannels=parameters.badchannels;
newparameters.bestchannels=bestchannel;

shafts=[];
for i=1:length(bestchannel);
shafts=[shafts s.shaft(bestchannel{i})];
    if length(bestchannel{i})==0
        shafts=[shafts -1];
    end
end
newparameters.shafts=shafts;

newparameters.depthzones=depthzones;
newparameters.channelsets=channelsets;

newparameters.badunits=parameters.badunits;   %update runparameters.mat file
newparameters.mergeunits=parameters.mergeunits;

newparameters.spikedetectionmethod=spikedetectionmethod;
newparameters.minamplitude=minamplitude;
% newparameters.noisedochannels=parameters.noisedochannels;

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
clear newparameters;



