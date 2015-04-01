event1trig_vy=[]; event2trig_vy=[]; %event-triggered velocity for each event trial.
event1trig_accel=[]; event2trig_accel=[]; %event-triggered acceleration for each event trial.

    for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        eventtimek=event1times(trialk);
        t0=round(eventtimek*velocitysamplingrate-preeventtime*velocitysamplingrate);
        tf=round(eventtimek*velocitysamplingrate+posteventtime*velocitysamplingrate);
        if t0<1 | tf>length(vy)
            continue
        end
        event1trig_vy=[event1trig_vy; resample(vy(t0:tf), length(runtimebins)-1, (tf-t0))];   %resamples to match lick bin size.
        event1trig_accel=[event1trig_accel; resample(accel(t0:tf), length(runtimebins)-1, (tf-t0))];   %resamples to match lick bin size.
    end
    
    
    if size(event1trig_vy,1)>1
    meanevent1_vy=100*mean(event1trig_vy); %mean run speed in cm/sec.
    meanevent1_vy=meanevent1_vy(1:(length(runtimebins)-1));     
    
    semevent1_vy=100*std(event1trig_vy)/sqrt(length(doevent1trials));
    semevent1_vy=semevent1_vy(1:(length(runtimebins)-1));   
    
    meanevent1_accel=100*mean(event1trig_accel); %mean run speed in cm/sec.
    meanevent1_accel=meanevent1_accel(1:(length(runtimebins)-1));       

    semevent1_accel=100*std(event1trig_accel)/sqrt(length(doevent1trials));
    semevent1_accel=semevent1_accel(1:(length(runtimebins)-1)); 
    end

    if length(doevent2trials)>0
         for trialind=1:length(doevent2trials);
            trialk=doevent2trials(trialind);
            eventtimek=event2times(trialk);
            
            lick_to_cue_alignment  %only applies if event2 is startlicking.
          
            t0=round(eventtimek*velocitysamplingrate-preeventtime*velocitysamplingrate);
            tf=round(eventtimek*velocitysamplingrate+posteventtime*velocitysamplingrate);
            if t0<1 | tf>length(vy)
                continue
            end
            event2trig_vy=[event2trig_vy; resample(vy(t0:tf), length(runtimebins)-1, (tf-t0))];  %resamples to match lick bin size.
            event2trig_accel=[event2trig_accel; resample(accel(t0:tf), length(runtimebins)-1, (tf-t0))];   %resamples to match lick bin size.
         end
    end  
    
    if size(event2trig_vy,1)>1
    meanevent2_vy=100*mean(event2trig_vy); %mean run speed in cm/sec.
    meanevent2_vy=meanevent2_vy(1:(length(runtimebins)-1));     
    
    semevent2_vy=100*std(event2trig_vy)/sqrt(length(doevent2trials));
    semevent2_vy=semevent2_vy(1:(length(runtimebins)-1));     

    meanevent2_accel=100*mean(event2trig_accel); %mean run speed in cm/sec.
    meanevent2_accel=meanevent2_accel(1:(length(runtimebins)-1));       

    semevent2_accel=100*std(event2trig_accel)/sqrt(length(doevent2trials));
    semevent2_accel=semevent2_accel(1:(length(runtimebins)-1)); 
    end