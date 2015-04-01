if laser_artifact_removal=='y'

pulselength=laserartifacts.pulselength;
    
abstrialstarttime=(trial-1)*(laserartifacts.trialduration)/samplingrate;
abstrialendtime=(trial)*length(bkdatach)/samplingrate;

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
         if artifact_tf>length(bkdatach)
            adjust_arttf=artifact_tf-length(bkdatach);
            artifact_tf=length(bkdatach);
         end
       
        artifacti=laserartifactchani((1+adjust_artt0):(length(laserartifactchani)-adjust_arttf )); 
    
        bkdatach(artifact_t0:artifact_tf)=bkdatach(artifact_t0:artifact_tf)-artifacti;
    
    end
    
    end
       
end