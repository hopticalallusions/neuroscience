if laser_artifact_removal=='y'

pulselength=laserartifacts.pulselength;
    
abstrialstarttime=(trial-1)*(laserartifacts.trialduration)/samplingrate;
abstrialendtime=(trial)*length(datach)/samplingrate;

laserpulsesintrial=find(laserartifacts.pulsetrainstart<abstrialendtime & laserartifacts.pulsetrainstart>=abstrialstarttime);    
pulsetimesintrial=laserartifacts.pulsetrainstart(laserpulsesintrial)-abstrialstarttime;

    if length(pulsetimesintrial)>0
    absolutechan=muxichans(chanind)+(muxi-1)*32;
    laserartifactchani=laserartifacts.channel{absolutechan};
    
    for pulseind=1:length(pulsetimesintrial)
        pulsetimei=pulsetimesintrial(pulseind);
        artifact_t0=floor(pulsetimei*samplingrate);
        adjust_artt0=0;
        if artifact_t0<1
            adjust_artt0=artifact_t0-1;
            artifact_t0=1;
        end
        adjust_arttf=0;
        artifact_tf=artifact_t0+pulselength;
         if artifact_tf>length(datach)
            adjust_arttf=artifact_tf-length(datach);
            artifact_tf=length(datach);
         end
       
        artifacti=laserartifactchani((1+adjust_artt0):(length(laserartifactchani)-adjust_arttf )); 
    
        datach(artifact_t0:artifact_tf)=datach(artifact_t0:artifact_tf)-artifacti;
    
    end
    
    end
       
end