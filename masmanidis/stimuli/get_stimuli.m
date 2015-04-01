%Created May 2012, updated Sept 2012. 
%Note: need to run spikesort_muxi to use this program.
%Results are saved in stimulidir.

stim_multfactor=4096;  %4096 starting May 22. previously 16384.
mouse_multfactor=4096;
stimsamplingrate=10000;
velocitysamplingrate=50; %originally is 10k, but becomes 50 Hz after downsampling in this subroutine.
min_peakdist=stimsamplingrate/10; %this will find everything below 10 Hz.  This is more accurate than 20 Hz.
detectthreshold=4.2; %detection threshold for licking. use high threshhold near 5 V since it's a digital signal.
laserthreshold=3.2;
precuetime=3;
postcuetime=8;
lickbinsize=0.05;
lickbins=-precuetime:lickbinsize:postcuetime;
mouseDCoffset=2500;   %this value is set in the mouse readout computer. 
mousemultfactor=1000; %this value is set in the mouse readout computer.
vel_calibrationfactor=9e-4; %calibrated Jan 8 2013. multiplication factor that converts the optical mouse velocity to real velocity in units of meters/second.
velocitytime=-precuetime:(1/velocitysamplingrate):postcuetime;   %downsampling the velocity by factor of 200 (=50 Hz).
max_cuesoldelay=5;        %max allowed time delay btwn cue and solenoid.
min_lickrate=4;             %minimum lick rate required to be considered a licking episode.
min_lickepseparation=5;     %minimum time allowed between successive licking episodes.
% *******************Finished setting parameters***********************

figure(1)
close 1

timebins=lickbins;

mkdir(stimulidir)

startscratch=[];
if exist([stimulidir 'stimuli.mat'],'file')>0
    startscratch=input('Re-do get_stimuli (y/n) [n]? ','s');  
    if isempty(startscratch)==1
    startscratch='n';
    end
else startscratch='y';
end

% if exist('lick_stim')>0
%     startscratch=[];                              
%     startscratch=input('Re-load super-vector of raw data (y/n) [n]? ','s');  
%     if isempty(startscratch)==1
%     startscratch='n';
%     end
% else startscratch='y';
% end

if startscratch=='y'
 
disp(['Results will be saved to ' stimulidir])    

%***Putting all stimulus data trial files into long vectors***
disp(['Extracting stimulus super-vectors for all trials.'])
lick_stim=[]; cue1_stim=[]; cue2_stim=[]; cue3_stim=[]; cue4_stim=[]; sol1_stim=[]; sol2_stim=[]; laser_stim=[]; motionx=[]; motiony=[]; motionVR=[];
for iterations=1:length(dotrials);
trial=dotrials(iterations);
  
if trial<10;
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end
  
datafilename=[rawpath filename '_t' trialstring];

stimfile=[datafilename '.lick'];
if exist([stimfile],'file')>0   %exist('A','file') checks for files or directories.
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

lick_stim=[lick_stim stim/stim_multfactor];
end

stimfile=[datafilename '.cue1'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

cue1_stim=[cue1_stim stim/stim_multfactor];
end

stimfile=[datafilename '.cue2'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

cue2_stim=[cue2_stim stim/stim_multfactor];
end

stimfile=[datafilename '.cue3'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

cue3_stim=[cue3_stim stim/stim_multfactor];
end


stimfile=[datafilename '.cue4'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

cue4_stim=[cue4_stim stim/stim_multfactor];
end

stimfile=[datafilename '.solenoid'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

sol1_stim=[sol1_stim stim/stim_multfactor];
end

stimfile=[datafilename '.solenoid2'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

sol2_stim=[sol2_stim stim/stim_multfactor];
end

stimfile=[datafilename '.laser'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

laser_stim=[laser_stim stim/stim_multfactor];
end

% stimfile=[datafilename '.motionx'];
% if exist([stimfile],'file')>0
% fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
% stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
% fclose(fid);
% 
% motionx=[motionx decimate(stim/mouse_multfactor,stimsamplingrate/velocitysamplingrate)];
% end

stimfile=[datafilename '.motiony'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

motiony=[motiony decimate(stim/mouse_multfactor,stimsamplingrate/velocitysamplingrate)];
end

stimfile=[datafilename '.motionVR'];
if exist([stimfile],'file')>0
fid = fopen(stimfile,'r','b');  %fopen(filename,permission,machineformat) r= read, b=big-endian byte ordering
stim = fread(fid,[1,inf],'int16');  %read binary data from file  fread(filename,size,precision) fill a 1xinfinty matrix, in column order, using integers in 16bit format  
fclose(fid);

motionVR=[motionVR decimate(stim/stim_multfactor,stimsamplingrate/velocitysamplingrate)];
end



end
%***Done getting super-vectors***

% if exist([rawpath filedate 'b_t' '01' '.lick'])>0;
%    reply=input(['Files with the filename ' filedate 'b exist in this directory. Include them in analysis? y/n [n]'],'s');
%          if isempty(reply)||reply=='n';
%             reply='n';
%          elseif reply=='y';
%              alphabetsolution;
%          end
% 
% end

disp(['Getting stimulus times.'])
if max(lick_stim)>detectthreshold
[licks,licktimes]=findpeaks(lick_stim,'minpeakheight',detectthreshold,'minpeakdistance',min_peakdist);   %min_peakdist ignores peaks around an identified peak for a specified number of indices.  makes two vectors
else licktimes=[];
end

if max(sol1_stim)>detectthreshold
[sol1,sol1times]=findpeaks(sol1_stim,'minpeakheight',detectthreshold,'minpeakdistance',min_peakdist);
else sol1times=[];
end

if max(sol2_stim)>detectthreshold
[sol2,sol2times]=findpeaks(sol2_stim,'minpeakheight',detectthreshold,'minpeakdistance',min_peakdist);
sol2times=sol2times/stimsamplingrate;
end

get_lasertimes

diffcue1_stim=diff(cue1_stim);
cue1times=find(diffcue1_stim>detectthreshold);  
diffcue2_stim=diff(cue2_stim);
cue2times=find(diffcue2_stim>detectthreshold);
diffcue3_stim=diff(cue3_stim);
cue3times=find(diffcue3_stim>detectthreshold);
diffcue4_stim=diff(cue4_stim);
cue4times=find(diffcue4_stim>detectthreshold);  

if length(cue1times)==0  %if this is a habituation session (i.e., no cues)
    habituation='y';
    cue1times=sol1times;
else habituation='n';
end


%getting cue-triggered velocity.
% motionx=motionx(1:length(motiony));
datafilename=[rawpath filename '_t01']; vy=[];
stimfile=[datafilename '.motiony'];
if exist([stimfile],'file')>0
%   vx=(motiony*mousemultfactor-mouseDCoffset); 
%   vx=vx*vel_calibrationfactor;
    vy=(motiony*mousemultfactor-mouseDCoffset); 
    vy=vy*vel_calibrationfactor;  %converts velocity to meters/second.
    
    diffvy=diff(vy);  
    b=find(abs(diffvy)<0.05);
    c=find(vy<0);
    d=intersect(b,c);
    backgroundvy=mean(vy(d));    %correction for baseline value of vy; typically~-120.
    vy=vy-backgroundvy;          %background-subtracted corrected vy.
    cue1trig_vy=[]; cue2trig_vy=[]; 
%     cue1trig_vx=[]; cue2trig_vx=[];  %cue-triggered velocity for each cue trial.
    for trialind=1:length(cue1times);
        cuetimei=cue1times(trialind);
        t0=cuetimei*(velocitysamplingrate/stimsamplingrate)-precuetime*(velocitysamplingrate);
        tf=cuetimei*(velocitysamplingrate/stimsamplingrate)+postcuetime*(velocitysamplingrate);
        if t0<1 | tf>length(vy)
            continue
        end
%         cue1trig_vx=[cue1trig_vx; vx(t0:tf)];
        cue1trig_vy=[cue1trig_vy; vy(t0:tf)];
    end
    
    if length(cue2times)>0
         for trialind=1:length(cue2times);
            cuetimei=cue2times(trialind);
            t0=cuetimei*(velocitysamplingrate/stimsamplingrate)-precuetime*(velocitysamplingrate);
            tf=cuetimei*(velocitysamplingrate/stimsamplingrate)+postcuetime*(velocitysamplingrate);
            if t0<1 | tf>length(vy)
                continue
            end
%             cue2trig_vx=[cue2trig_vx; vx(t0:tf)];
            cue2trig_vy=[cue2trig_vy; vy(t0:tf)];
         end
    end
    
end

licktimes=licktimes/stimsamplingrate;
cue1times=cue1times/stimsamplingrate;
cue2times=cue2times/stimsamplingrate;
cue3times=cue3times/stimsamplingrate;
cue4times=cue4times/stimsamplingrate;
sol1times=sol1times/stimsamplingrate;

cuesoldelays=[]; cuesoldelays.cue1=[]; cuesoldelays.cue2=[];   %list of all cue-solenoid delays; will take average of this to get meancuesoldelay;
cue1_licktimes=[]; cue1_alllicktimes=[];
solenoid_aftercue1=[];  %=1 if CS1 is followed by solenoid US; =0 if no US.
for trialind=1:length(cue1times)
    cuetimei=cue1times(trialind);
    lickinds=find(licktimes<(cuetimei+postcuetime) & licktimes>(cuetimei-precuetime));
    licktimesi=licktimes(lickinds);
    cue1_licktimes{trialind}=licktimesi-cuetimei;
    cue1_alllicktimes=[cue1_alllicktimes licktimesi-cuetimei];
       
    istheresolenoid=0;
    for solind=1:length(sol1times)
        soltimej=sol1times(solind);
        if soltimej-cuetimei>0 & soltimej-cuetimei<max_cuesoldelay;
            istheresolenoid=1;
            cuesoldelays.cue1=[cuesoldelays.cue1 soltimej-cuetimei];  %collects lists of all the cue-solenoid delays, and will define cuesolenoiddelay as the average of these.
            break
        end
    end
    solenoid_aftercue1=[solenoid_aftercue1 istheresolenoid];
                  
end

cue2_licktimes=[]; cue2_alllicktimes=[];
solenoid_aftercue2=[];  %=1 if CS2 is followed by solenoid US; =0 if no US.
for trialind=1:length(cue2times);
    cuetimei=cue2times(trialind);
    lickinds=find(licktimes<(cuetimei+postcuetime) & licktimes>(cuetimei-precuetime));
    licktimesi=licktimes(lickinds);
    cue2_licktimes{trialind}=licktimesi-cuetimei;  
    cue2_alllicktimes=[cue2_alllicktimes licktimesi-cuetimei];
        
    istheresolenoid=0;
    for solind=1:length(sol1times)
        soltimej=sol1times(solind);
        if soltimej-cuetimei>0 & soltimej-cuetimei<max_cuesoldelay;
            istheresolenoid=1;
             cuesoldelays.cue2=[cuesoldelays.cue2 soltimej-cuetimei];  %collects lists of all the cue-solenoid delays, and will define cuesolenoiddelay as the average of these.
            break
        end
    end
    solenoid_aftercue2=[solenoid_aftercue2 istheresolenoid];
    
end

cue1_lickrate=histc(cue1_alllicktimes,lickbins)/length(cue1times)/lickbinsize;
cue1_lickrate=smooth(cue1_lickrate,3);
cue2_lickrate=histc(cue2_alllicktimes,lickbins)/length(cue2times)/lickbinsize;
cue2_lickrate=smooth(cue2_lickrate,3);

meancuesoldelay=sum([cuesoldelays.cue1 cuesoldelays.cue2])/(length(cuesoldelays.cue1)+length(cuesoldelays.cue2));
disp(['found the mean cue-solenoid delay: ' num2str(meancuesoldelay) '+/-' num2str(std([cuesoldelays.cue1 cuesoldelays.cue2])) ' s.'])

cue1_lickyesno=[];  %describes whether animal licked at some point between the cue onset and solenoid onset.  0='no' for this trial, 1='yes' for this trial.
for trialind=1:length(cue1times)    
    if habituation=='n'
    foundlicks=find(cue1_licktimes{trialind}>0 & cue1_licktimes{trialind}<meancuesoldelay);
    else foundlicks=find(cue1_licktimes{trialind}>0 & cue1_licktimes{trialind}<0.5);  %must lick within 0.5 s of reward delivery to count.
    end
   
    if length(foundlicks)>0
        cue1_lickyesno=[cue1_lickyesno 1];
    else cue1_lickyesno=[cue1_lickyesno 0];
    end
end

cue2_lickyesno=[];    %describes whether animal licked at some point between the cue onset and solenoid onset.  0='no' for this trial, 1='yes' for this trial.
for trialind=1:length(cue2times);   
    foundlicks=find(cue2_licktimes{trialind}>0 & cue2_licktimes{trialind}<meancuesoldelay);
    if length(foundlicks)>0
        cue2_lickyesno=[cue2_lickyesno 1];
    else cue2_lickyesno=[cue2_lickyesno 0];
    end
end


disp('**finding sustained licking episodes')
max_lickdelay=2*meancuesoldelay;  %maximum time allowed between a cue and the onset of a licking episode.
lickepisodetimes=[];      %licking episode definition: when at least two licking events occur within a time 1/min_lickrate 
                          %and when the previous episode is at least min_lickepseparation apart in time
endlickepisodetimes=[];
eventsinepisodes=[];        %specifies which event (if any) coincides with each licking episode.  if no event then set to zero.
trialinepisodes=[];       %if the licking episode coincides with a event, specify the trial of that event presentation if no event then set to zero.
solenoidinepisodes=[];    %=1 if licking episode coincides with a solenoid presentation, =0 if no solenoid.
if length(licktimes)>0
for lickind=1:(length(licktimes)-1);
    if licktimes(lickind+1)-licktimes(lickind)<1/min_lickrate %& licktimes(lickind+2)-licktimes(lickind+1)<1/min_lickrate
        if length(lickepisodetimes)==0
        lickepisodetimes=[lickepisodetimes licktimes(lickind)];
        elseif length(lickepisodetimes)>0 & licktimes(lickind)-max(lickepisodetimes)>min_lickepseparation
        lickepisodetimes=[lickepisodetimes licktimes(lickind)];
        end
    end
end
   
for lickind=1:length(lickepisodetimes)
    lickepisodei=lickepisodetimes(lickind);
    nearbylickinds=find(abs(licktimes-lickepisodei)<=min_lickepseparation);
    endlickepisodei=licktimes(max(nearbylickinds));
    endlickepisodetimes=[endlickepisodetimes endlickepisodei];
end


for lickind=1:length(lickepisodetimes);
    lickepisodetimei=lickepisodetimes(lickind);
    eventsinepisodesi=0;
    trialinepisodesi=0;
    solenoidinepisodesi=0;
    for cueind=1:length(cue1times);
        event1timej=cue1times(cueind);
        if lickepisodetimei-event1timej>0 & lickepisodetimei-event1timej<max_lickdelay
            eventsinepisodesi=1;
            trialinepisodesi=cueind;
            break
        end
    end
    
    if eventsinepisodesi==0
    for cueind=1:length(cue2times);
        event2timej=cue2times(cueind);
        if lickepisodetimei-event2timej>0 & lickepisodetimei-event2timej<max_lickdelay
            eventsinepisodesi=2;
            trialinepisodesi=cueind;
            break
        end
    end
    end
    
    eventsinepisodes(lickind)=eventsinepisodesi;
    trialinepisodes(lickind)=trialinepisodesi;
    
    for solind=1:length(sol1times)
        sol1timei=sol1times(solind);
        if abs(lickepisodetimei-sol1timei)<max_lickdelay
        solenoidinepisodesi=1;
        end
    end
    
    solenoidinepisodes(lickind)=solenoidinepisodesi;
      
end
end


%***Plot results****
if length(licktimes)>0
disp(['plotting licking properties.'])
figure(1)
subplot(4,1,1)
hold off
for trialind=1:length(cue1times);
trialk=trialind;
licktimesi=cue1_licktimes{trialk};
plot([licktimesi;licktimesi],[0.8*ones(size(licktimesi))+(trialind-0.4); zeros(size(licktimesi))+(trialind-0.4)],'k')
hold on
    if solenoid_aftercue1(trialk)==1
    plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'b')
    end      
end
pctlick=round(100*length(find(cue1_lickyesno==1))/length(cue1_lickyesno));
if length(cue2times)>0
title([subject ', ' filename '.  Licking around CS-1. ' num2str(length(cue1times)) ' trials. ' num2str(pctlick) '% of trials with licks after cue.'])
else
title([subject ', ' filename '.  Habituation. Licking around solenoid (' num2str(length(cue1times)) ' trials. ' num2str(pctlick) '% of trials with licks after solenoid.'])
end
ylabel('trial')
axis([-precuetime postcuetime 0 length(cue1times)+1])
set(gca,'FontSize', 10,'TickDir','out')


if length(cue2times)>0
subplot(4,1,2)
hold off
for trialind=1:length(cue2times);
trialk=trialind;
licktimesi=cue2_licktimes{trialk};
plot([licktimesi;licktimesi],[0.8*ones(size(licktimesi))+(trialind-0.4); zeros(size(licktimesi))+(trialind-0.4)],'k')
hold on
    if solenoid_aftercue2(trialk)==1
    plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'b')
    end  
end
pctlick=round(100*length(find(cue2_lickyesno==1))/length(cue2_lickyesno));
title(['Licking around CS-2. ' num2str(length(cue2times)) ' trials. ' num2str(pctlick) '% of trials with licks after cue'])
ylabel('trial')
axis([-precuetime postcuetime 0 length(cue2times)+1])
end
set(gca,'FontSize', 10,'TickDir','out')


subplot(4,1,3)
hold off
plot(lickbins,cue1_lickrate,'k')
hold on 
if length(cue2times)>0
plot(lickbins,cue2_lickrate,'r')
end
title(['Mean lick rate (black=CS-1, red=CS-2)'])
ylabel('lick rate (Hz)')
axis([-precuetime postcuetime 0 round(max([cue1_lickrate; cue2_lickrate])+1)])
set(gca,'FontSize', 10,'TickDir','out')


subplot(4,1,4)
maxv=max([mean(cue1trig_vy) mean(cue2trig_vy) ]);
minv=min([mean(cue1trig_vy) mean(cue2trig_vy) ]);

% hold off
% plot(velocitytime,mean(cue1trig_vx),'--k')
% hold on 
plot(velocitytime,mean(cue1trig_vy),'k')
hold on
if length(cue2times)>0
% plot(velocitytime,mean(cue2trig_vx),'--r')
plot(velocitytime,mean(cue2trig_vy),'r')
end
title(['Mean forward ball velocity (black=CS-1, red=CS-2)'])
xlabel('time (s)')
ylabel('run speed (m/s)')
axis([-precuetime postcuetime minv maxv])

set(gca,'FontSize', 10,'TickDir','out')

saveas(figure(1),[stimulidir 'licking.fig' ]  ,'fig')

else disp(['no licks detected - not making plot.'])
end 

    stimuli=[];
    stimuli.stimsamplingrate=stimsamplingrate;
    stimuli.velocitysamplingrate=velocitysamplingrate;
    stimuli.meancuesoldelay=meancuesoldelay;
    stimuli.habituation=habituation;
    stimuli.detectthreshold=detectthreshold;
    stimuli.precuetime=precuetime;
    stimuli.postcuetime=postcuetime;
    stimuli.lickbinsize=lickbinsize;
    stimuli.stim_multfactor=stim_multfactor;
    stimuli.mouse_multfactor=mouse_multfactor;
    stimuli.licktimes=licktimes;
    stimuli.sol1times=sol1times;
    stimuli.lasertimes=lasertimes;  
    stimuli.cue1times=cue1times;
    stimuli.cue2times=cue2times;
    stimuli.cue3times=cue3times;
    stimuli.cue4times=cue4times;
    stimuli.solenoid_aftercue1=solenoid_aftercue1;
    stimuli.solenoid_aftercue2=solenoid_aftercue2;
    stimuli.cue1_lickyesno=cue1_lickyesno;  %specifies whether there was anticipatory licking.
    stimuli.cue2_lickyesno=cue2_lickyesno;  %specifies whether there was anticipatory licking.
    stimuli.lickepisodetimes=lickepisodetimes;    %licking episode definition: when at least two licking events occur within a time 1/min_lickrate and when the previous episode is at least min_lickepseparation apart in time
    stimuli.endlickepisodetimes=endlickepisodetimes;
    stimuli.eventsinepisodes=eventsinepisodes;    %specifies which event (if any) coincides with each licking episode.  if no event then set to zero.
    stimuli.trialinepisodes=trialinepisodes;       %if the licking episode coincides with a event, specify the trial of that event presentation if no event then set to zero.
    stimuli.solenoidinepisodes=solenoidinepisodes;  %=1 if licking episode coincides with a solenoid presentation, =0 if no solenoid.
    stimuli.vy=vy;    %downsampled forward rotational velocity, as of January 13 2013 should be in units of meters/second.
    stimuli.vel_calibrationfactor=vel_calibrationfactor;
%   stimuli.vx=vx;    %downsampled sideways rotational velocity.
    stimuli.motionVR=motionVR;
save([stimulidir 'stimuli.mat'],'stimuli','-mat')

clear cue1_stim cue2_stim cue3_stim cue4_stim lick_stim sol1_stim sol2_stim laser_stim motionx motiony vx vy motionVR

end

