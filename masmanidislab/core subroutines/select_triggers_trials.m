if exist([stimulidir 'stimuli.mat']) || exist('/Users/andrew.howe/trackforbackup/masmanidisLab/spike-jitter/data analysis/Licking Training/Mouse 100/December 7 2013/Dec7a/stimuli/stimuli.mat')
    
    if domultisubject=='n' | subjectind==1
        disp(['triggering on ' triggerevent1 ' and ' triggerevent2 '.'])
    end
    
    if strcmp(triggerevent1,'start')==1 | strcmp(triggerevent1,'stop')==1 | strcmp(triggerevent2,'start')==1 | strcmp(triggerevent2,'stop')==1
        get_startstop  %calculates start and stop times for running episodes.
    end
    
    if  strcmp(triggerevent1,'CS1')
        event1times=cue1times;
    elseif strcmp(triggerevent1,'CS2')
        event1times=cue2times;
    elseif strcmp(triggerevent1,'CS3')
        event1times=cue3times;
    elseif strcmp(triggerevent1,'CS4')
        event1times=cue4times;
    elseif strcmp(triggerevent1,'laser')
        event1times=pulsetrainstart;
    elseif strcmp(triggerevent1,'startlicking')
        event1times=lickepisodetimes;
    elseif strcmp(triggerevent1,'endlicking')
        event1times=endlickepisodetimes;
    elseif strcmp(triggerevent1,'solenoid')
        event1times=sol1times;
    elseif strcmp(triggerevent1,'positive acceleration')
        event1times=pos_acceltimes;
    elseif strcmp(triggerevent1,'negative acceleration')
        event1times=neg_acceltimes;
    elseif strcmp(triggerevent1,'start')
        event1times=run_starttimes;
    elseif strcmp(triggerevent1,'stop')
        event1times=run_stoptimes;
    elseif strcmp(triggerevent1,'room1 entries')
        event1times=roomentries{1};
    elseif strcmp(triggerevent1,'room2 entries')
        event1times=roomentries{2};
    elseif strcmp(triggerevent1,'room3 entries')
        event1times=roomentries{3};
    elseif strcmp(triggerevent1,'room4 entries')
        event1times=roomentries{4};
    elseif strcmp(triggerevent1,'LFP')
        event1times=[];
    elseif strcmp(triggerevent1,'LFPenvelope_peaks')
        event1times=[];
    elseif strcmp(triggerevent1, 'none')
        event1times=[];
    end
    
    if  strcmp(triggerevent2,'CS1')
        event2times=cue1times;
    elseif strcmp(triggerevent2,'CS2')
        event2times=cue2times;
    elseif strcmp(triggerevent2,'CS3')
        event2times=cue3times;
    elseif strcmp(triggerevent2,'CS4')
        event2times=cue4times;
    elseif strcmp(triggerevent2,'laser')
        event2times=pulsetrainstart;
    elseif strcmp(triggerevent2,'startlicking')
        event2times=lickepisodetimes;
    elseif strcmp(triggerevent2,'endlicking')
        event2times=endlickepisodetimes;
    elseif strcmp(triggerevent2,'solenoid')
        event2times=sol1times;
    elseif strcmp(triggerevent2,'positive acceleration')
        event2times=pos_acceltimes;
    elseif strcmp(triggerevent2,'negative acceleration')
        event2times=neg_acceltimes;
    elseif strcmp(triggerevent2,'start')
        event2times=run_starttimes;
    elseif strcmp(triggerevent2,'stop')
        event2times=run_stoptimes;
    elseif strcmp(triggerevent2,'room1 entries')
        event2times=roomentries{1};
    elseif strcmp(triggerevent2,'room2 entries')
        event2times=roomentries{2};
    elseif strcmp(triggerevent2,'room3 entries')
        event2times=roomentries{3};
    elseif strcmp(triggerevent2,'room4 entries')
        event2times=roomentries{4};
    elseif strcmp(triggerevent2,'LFP')
        event2times=[];
    elseif strcmp(triggerevent2,'none')
        event2times=[];
    end
    
    if  strcmp(triggerevent3,'CS1')
        event3times=cue1times;
    elseif strcmp(triggerevent3,'CS2')
        event3times=cue2times;
    elseif strcmp(triggerevent3,'laser')
        event3times=pulsetrainstart;
    elseif strcmp(triggerevent3,'startlicking')
        event3times=lickepisodetimes;
    elseif strcmp(triggerevent3,'endlicking')
        event3times=endlickepisodetimes;
    elseif strcmp(triggerevent3,'solenoid')
        event3times=sol1times;
    elseif strcmp(triggerevent3,'LFP')
        event3times=[];
    elseif strcmp(triggerevent3,'none')
        event3times=[];
    end
    
    
    event1_licktrials=[];
    event1_UStrials=[];
    event2_licktrials=[];
    event2_UStrials=[];
    
    if  strcmp(triggerevent1,'CS1')
        event1_licktrials=cue1_lickyesno;
        event1_UStrials=solenoid_aftercue1;
    elseif strcmp(triggerevent1,'CS2')
        event1_licktrials=cue2_lickyesno;
        event1_UStrials=solenoid_aftercue2;
    end
    
    if  strcmp(triggerevent2,'CS1')
        event2_licktrials=cue1_lickyesno;
        event2_UStrials=solenoid_aftercue1;
    elseif strcmp(triggerevent2,'CS2')
        event2_licktrials=cue2_lickyesno;
        event2_UStrials=solenoid_aftercue2;
    end
    
    if domultisubject=='n' | subjectind==1
        disp(['trial selection method for event 1: ' trialselection1])
    end
    
    doevent1trials=[];
    if strcmp(trialselection1,'all')
        doevent1trials=[1:length(event1times)];
    elseif strcmp(trialselection1,'rewarded')
        doevent1trials=find(event1_UStrials==1);
    elseif strcmp(trialselection1,'unrewarded')
        doevent1trials=find(event1_UStrials==0);
    elseif strcmp(trialselection1,'unexpectedUS')
        doevent1trials=unexpectedUStrials;
    elseif strcmp(trialselection1,'correct licking')
        licking_and_US=(event1_licktrials.*event1_UStrials);
        doevent1trials=find(licking_and_US==1);
    elseif strcmp(trialselection1,'incorrect licking')
        wronglicktrials=intersect(find(event1_licktrials==1),find(event1_UStrials==0));
        doevent1trials=wronglicktrials;
    elseif strcmp(trialselection1,'correct withholding')
        correctwithholdtrials=intersect(find(event1_licktrials==0),find(event1_UStrials==0));
        doevent1trials=correctwithholdtrials;
    elseif strcmp(trialselection1,'incorrect withholding')
        wrongwithholdtrials=intersect(find(event1_licktrials==0),find(event1_UStrials==1));
        doevent1trials=wrongwithholdtrials;
    elseif strcmp(trialselection1, 'CS1 licking')
        for cueind=1:length(cue1times);
            cue1time=cue1times(cueind);
            for lickind=1:length(lickepisodetimes)
                licktimei=lickepisodetimes(lickind);
                if (licktimei-cue1time)>0 & (licktimei-cue1time)<meancuesoldelay
                    doevent1trials=[doevent1trials lickind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection1, 'CS2 licking')
        for cueind=1:length(cue2times);
            cue2time=cue2times(cueind);
            for lickind=1:length(lickepisodetimes)
                licktimei=lickepisodetimes(lickind);
                if (licktimei-cue2time)>0 & (licktimei-cue2time)<meancuesoldelay
                    doevent1trials=[doevent1trials lickind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection1, 'spontaneous licking')
        for lickind=1:length(lickepisodetimes)
            licktimei=lickepisodetimes(lickind);
            endlicktimei=endlickepisodetimes(lickind);
            if length(find(abs(licktimei-cue1times)<spontangap))==0 & length(find(abs(endlicktimei-cue1times)<spontangap))==0 &  length(find(abs(licktimei-cue2times)<spontangap))==0 & length(find(abs(endlicktimei-cue2times)<spontangap))==0
                doevent1trials=[doevent1trials lickind];
            end
        end
    elseif strcmp(trialselection1, 'CS1 running')
        for cueind=1:length(cue1times);
            cue1time=cue1times(cueind);
            for eventind=1:length(event1times)
                eventtimei=event1times(eventind);
                if (eventtimei-cue1time)>0 & (eventtimei-cue1time)<meancuesoldelay
                    doevent1trials=[doevent1trials eventind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection1, 'CS2 running')
        for cueind=1:length(cue2times);
            cue2time=cue2times(cueind);
            for eventind=1:length(event1times)
                eventtimei=event1times(eventind);
                if (eventtimei-cue2time)>0 & (eventtimei-cue2time)<meancuesoldelay
                    doevent1trials=[doevent1trials eventind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection1, 'spontaneous running')
        for eventind=1:length(event1times)
            eventtimei=event1times(eventind);
            if length(find(abs(eventtimei-cue1times)<spontangap))==0 & length(find(abs(eventtimei-cue2times)<spontangap))==0 & length(find(abs(eventtimei-lickepisodetimes)<spontangap))==0 & length(find(abs(eventtimei-endlickepisodetimes)<spontangap))==0
                doevent1trials=[doevent1trials eventind];
            end
        end
    else
        doevent1trials=[str2num(trialselection1)];
    end
    
    
    if domultisubject=='n' | subjectind==1
        disp(['trial selection method for event 2: ' trialselection2])
    end
    
    doevent2trials=[];
    if strcmp(trialselection2,'all')
        doevent2trials=[1:length(event2times)];
    elseif strcmp(trialselection2,'rewarded')
        doevent2trials=find(event2_UStrials==1);
    elseif strcmp(trialselection2,'unrewarded')
        doevent2trials=find(event2_UStrials==0);
    elseif strcmp(trialselection2,'unexpectedUS')
        doevent2trials=unexpectedUStrials;
    elseif strcmp(trialselection2,'correct licking')
        licking_and_US=(event2_licktrials.*event2_UStrials);
        doevent2trials=find(licking_and_US==1);
    elseif strcmp(trialselection2,'incorrect licking')
        wronglicktrials=intersect(find(event2_licktrials==1),find(event2_UStrials==0));
        doevent2trials=wronglicktrials;
    elseif strcmp(trialselection2,'correct withholding')
        correctwithholdtrials=intersect(find(event2_licktrials==0),find(event2_UStrials==0));
        doevent2trials=correctwithholdtrials;
    elseif strcmp(trialselection2,'incorrect withholding')
        wrongwithholdtrials=intersect(find(event2_licktrials==0),find(event2_UStrials==1));
        doevent2trials=wrongwithholdtrials;
    elseif strcmp(trialselection2, 'CS1 licking')
        lickonset=[];
        for cueind=1:length(cue1times);
            cue1time=cue1times(cueind);
            for lickind=1:length(lickepisodetimes)
                licktimei=lickepisodetimes(lickind);
                if (licktimei-cue1time)>0 & (licktimei-cue1time)<meancuesoldelay
                    doevent2trials=[doevent2trials lickind];
                    lickonset=[lickonset (licktimei-cue1time)];
                    continue
                end
            end
        end
        meanlickonset=round(mean(lickonset)/timebinsize)*timebinsize;  %mean licking onset time during CS1 trials.
        disp(['mean licking onset during CS1 trials is ' num2str(meanlickonset) ' s.'])
    elseif strcmp(trialselection2, 'CS2 licking')
        for cueind=1:length(cue2times);
            cue2time=cue2times(cueind);
            for lickind=1:length(lickepisodetimes)
                licktimei=lickepisodetimes(lickind);
                if (licktimei-cue2time)>0 & (licktimei-cue2time)<meancuesoldelay
                    doevent2trials=[doevent2trials lickind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection2, 'spontaneous licking')
        for lickind=1:length(lickepisodetimes)
            licktimei=lickepisodetimes(lickind);
            endlicktimei=endlickepisodetimes(lickind);
            if length(find(abs(licktimei-sol1times)<spontangap))==0 & length(find(abs(endlicktimei-sol1times)<spontangap))==0 & length(find(abs(licktimei-cue1times)<spontangap))==0 & length(find(abs(endlicktimei-cue1times)<spontangap))==0 &  length(find(abs(licktimei-cue2times)<spontangap))==0 & length(find(abs(endlicktimei-cue2times)<spontangap))==0
                doevent2trials=[doevent2trials lickind];
            end
        end
    elseif strcmp(trialselection2, 'CS1 running')
        for cueind=1:length(cue1times);
            cue1time=cue1times(cueind);
            for eventind=1:length(event2times)
                eventtimei=event2times(eventind);
                if (eventtimei-cue1time)>0 & (eventtimei-cue1time)<meancuesoldelay
                    doevent2trials=[doevent2trials eventind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection2, 'CS2 running')
        for cueind=1:length(cue2times);
            cue2time=cue2times(cueind);
            for eventind=1:length(event2times)
                eventtimei=event2times(eventind);
                if (eventtimei-cue2time)>0 & (eventtimei-cue2time)<meancuesoldelay
                    doevent2trials=[doevent2trials eventind];
                    continue
                end
            end
        end
    elseif strcmp(trialselection2, 'spontaneous running')
        for eventind=1:length(event2times)
            eventtimei=event2times(eventind);
            if length(find(abs(eventtimei-cue1times)<spontangap))==0 & length(find(abs(eventtimei-cue2times)<spontangap))==0 & length(find(abs(eventtimei-lickepisodetimes)<spontangap))==0 & length(find(abs(eventtimei-endlickepisodetimes)<spontangap))==0
                doevent2trials=[doevent2trials eventind];
            end
        end
    else
        doevent2trials=[str2num(trialselection2)];
    end
    
    
    if strcmp(triggerevent1,'laser') & strcmp(laserfreqselect,'none')==0
        Hzindex=strfind(laserfreqselect, 'Hz');
        selectfreq=str2num(laserfreqselect(1:(Hzindex-1)));
        selectfreqtrials=[];
        for i=1:length(event1times)
            freqtriali=round(mean(100./diff(stimuli.lasertimes.pulsetimes{i})))/100;
            if freqtriali==selectfreq
                selectfreqtrials=[selectfreqtrials i];
            end
        end
        doevent1trials=selectfreqtrials;
        disp(['found ' num2str(length(doevent1trials)) ' trials with laser f = ' num2str(selectfreq) ' Hz.'])
    end
    
    if strcmp(triggerevent2,'laser') & strcmp(laserfreqselect,'none')==0
        Hzindex=strfind(laserfreqselect, 'Hz');
        selectfreq=str2num(laserfreqselect(1:(Hzindex-1)));
        selectfreqtrials=[];
        for i=1:length(event1times)
            freqtriali=round(mean(100./diff(stimuli.lasertimes.pulsetimes{i})))/100;
            if freqtriali==selectfreq
                selectfreqtrials=[selectfreqtrials i];
            end
        end
        doevent2trials=selectfreqtrials;
        disp(['found ' num2str(length(doevent1trials)) ' trials with laser f = ' num2str(selectfreq) ' Hz.'])
    end
    
    if strcmp(triggerevent3,'laser') & strcmp(laserfreqselect,'none')==0
        Hzindex=strfind(laserfreqselect, 'Hz');
        selectfreq=str2num(laserfreqselect(1:(Hzindex-1)));
        selectfreqtrials=[];
        for i=1:length(event1times)
            freqtriali=round(mean(100./diff(stimuli.lasertimes.pulsetimes{i})))/100;
            if freqtriali==selectfreq
                selectfreqtrials=[selectfreqtrials i];
            end
        end
        doevent3trials=selectfreqtrials;
        disp(['found ' num2str(length(doevent1trials)) ' trials with laser f = ' num2str(selectfreq) ' Hz.'])
    end
    
    if length(doevent1trials)==0
        disp(['***Warning: zero event1 trials were found that satisfy the selection criteria!***'])
    end
    
    if length(event2times)==0
        doevent2trials=[];
    elseif length(event2times)~=0 & length(doevent2trials)==0
        disp(['***Warning: zero event2 trials were found that satisfy the selection criteria!***'])
    end
    
    
    if strcmp(subselect1,'all')==0
        if max(str2num(subselect1))>length(doevent1trials)
            disp(['WARNING: designated trial subselection for event 1 is not possible.'])
        end
        doevent1trials=doevent1trials(str2num(subselect1));
    end
    
    if strcmp(subselect2,'all')==0
        if max(str2num(subselect2))>length(doevent2trials)
            disp(['WARNING: designated trial subselection for event 2 is not possible.'])
        end
        doevent2trials=doevent2trials(str2num(subselect2));
    end
    
    event1_trialgroups=floor(length(doevent1trials)/trialgroupsize);
    event2_trialgroups=floor(length(doevent2trials)/trialgroupsize);
    
else
    
    event1times=str2num(input('no stimuli found, enter event time(s) in seconds: ', 's'));
    disp(['event1times = ' num2str(event1times) ' s.'])
    doevent1trials=1:length(event1times);
    
end