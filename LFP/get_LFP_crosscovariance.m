disp(['Getting LFP cross-covariance data'])

set_plot_parameters

triggerevent1='CS1';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'LFPenvelope_peaks'. 
                      %Selecting 'LFP' will use the entire LFP trace. 'LFPenvelope_peaks' will use the peaks from the LFP envelope over entire trace.

trialselection1='rewarded';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
 
laserfreqselect='10 Hz';  %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.
                            
f_low_LFP=35;               %used in LFP analyses
f_high_LFP=45;              %used in LFP analyses
 
timestep=0.1;                 %movie frame advances by this time.
timeperframe=0.25;             %takes x-covariance in +/-timeperframe window around frame time.

preeventtime=2;               %time in sec to use for detecting LFP peaks before event onset.  not used if triggerevent='LFP'
posteventtime=8;              %time in sec to use for detecting LFP peaks after event onset.   not used if triggerevent='LFP'
                             
peripktime=0.1;               %determines the maximum lag to use in x-covariance calculation.         

%************************************************
triggerevent2='none';   %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'none'.    
triggerevent3='none';  %options: 'CS1', 'CS2', 'laser', 'licking', 'none'. note: event3 not set up yet as of Jan 17 2013.    
                            
trialselection2='all';     %select which event2 trials to display. same options as trialselection1.

load_results

maxlags=round(LFPsamplingrate*peripktime);

select_triggers_trials 

disp(['filtering from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])

xcovdatadir=[xcovdir 'data\'];
mkdir(xcovdatadir);
% delete([xcovdatadir '*.*'])

xcovtimes=[];
for trialind=1:length(doevent1trials)
    trial=doevent1trials(trialind);       
    ti=event1times(trial);    
    xcovtimes{trial}=[(ti-preeventtime):timestep:(ti+posteventtime)];
end


orderedchannels=[];
for shaftind=1:length(uniqueshafts)
    currentshaft=uniqueshafts(shaftind);
    chansonshaft=s.channels(find(s.shaft==currentshaft));
    chansonshaft=intersect(chansonshaft,dochannels);
    channelseparation=sqrt((s.z).^2+(s.x).^2);
    channelseparation=channelseparation(chansonshaft);   
    [neworder, sortindices]=sort(channelseparation);
    orderedchannels=[orderedchannels; chansonshaft(sortindices)];  %orders channels according to their distance to the tip on the first shaft.
end
      

LFP_xcovdata=[]; tzero_xcov=[]; max_xcov=[]; peaklagtime=[]; xcov_movie=[];
tic
for i=1:length(dochannels);    %collecting LFP peak times for all specified electrode channels.
        chani=dochannels(i); 
        currentvoltagefile=['LFPvoltage_ch' num2str(chani) '.mat'];
        load([LFPvoltagedir currentvoltagefile]); 
        dofilter_LFP
        normVi=LFPvoltage/norm(LFPvoltage);  
             
    for j=1:length(dochannels);
        chanj=dochannels(j);
        disp(['LFP cross-covariance between channels ' num2str(chani) ' & ' num2str(chanj) '.']) 
        if chani==chanj
            LFP_xcovdata{chani}{chanj}=xcov(normVi,normVi, maxlags);
        elseif chani>chanj 
            LFP_xcovdata{chani}{chanj}=LFP_xcovdata{chanj}{chani};
        elseif chani<chanj
            currentvoltagefile=['LFPvoltage_ch' num2str(chanj) '.mat'];
            load([LFPvoltagedir currentvoltagefile]); 
            dofilter_LFP
            normVj=LFPvoltage/norm(LFPvoltage);
            LFP_xcovdata{chani}{chanj}=xcov(normVi,normVj,maxlags);
        end
        
        tzero_xcov{chani}{chanj}=LFP_xcovdata{chani}{chanj}(maxlags+1);   %value at dt=0.
        max_xcov{chani}{chanj}=max(LFP_xcovdata{chani}{chanj});           %maximum cross-covariance value.
        peaklagtime{chani}{chanj}=1000*find(LFP_xcovdata{chani}{chanj}==max(LFP_xcovdata{chani}{chanj}))/LFPsamplingrate-1000*(maxlags+1)/LFPsamplingrate;  %lag time to peak, in milliseconds.
        
%         for trialind=1:length(doevent1trials)
%              trial=doevent1trials(trialind);    
%              xcovtimes_trial=xcovtimes{trial};
%              for timeind=1:length(xcovtimes_trial)
%                  if chani==chanj
%                  xcov_movie{chani}{chanj}{trial}{timeind}=1;
%                  elseif chani>chanj 
%                  xcov_movie{chani}{chanj}{trial}{timeind}=xcov_movie{chanj}{chani}{trial}{timeind};
%                  elseif chani<chanj
%                  ti=xcovtimes_trial(timeind);
%                  t0=round((ti-timeperframe)*LFPsamplingrate);
%                  tf=round((ti+timeperframe)*LFPsamplingrate);
%                  xcov_movie{chani}{chanj}{trial}{timeind}=max(xcov(normVi(t0:tf),normVj(t0:tf),maxlags));   %keeps only the max value to prevent data overload.
%                  end
%              end   
%         end
        
    end
         
end

LFP_xcov=[];
LFP_xcov.f_low_LFP=f_low_LFP;
LFP_xcov.f_high_LFP=f_high_LFP;
LFP_xcov.preeventtime=preeventtime;
LFP_xcov.posteventtime=posteventtime;
LFP_xcov.timestep=0.1;
LFP_xcov.timeperframe=0.5;
LFP_xcov.triggerevent1=triggerevent1;
LFP_xcov.trialselection1=trialselection1;
LFP_xcov.LFP_xcovdata=LFP_xcovdata;
LFP_xcov.tzero_xcov=tzero_xcov;
LFP_xcov.max_xcov=max_xcov;
LFP_xcov.peaklagtime=peaklagtime;
LFP_xcov.xcov_movie=xcov_movie;


meanfrequency=round(mean([f_low_LFP f_high_LFP]));
save([xcovdatadir 'LFP_xcov_' num2str(meanfrequency) 'Hz.mat'],'LFP_xcov','-mat')

toc
disp(['done with LFP cross-covariance'])



%plot cross-covariances
max_xcovimage=[]; tzero_xcovimage=[]; peaklagtime_image=[];
for i=1:length(orderedchannels)
    chani=orderedchannels(i);
    for j=1:length(orderedchannels)
        chanj=orderedchannels(j);
        max_xcovimage(i,j)=LFP_xcov.max_xcov{chani}{chanj};
        tzero_xcovimage(i,j)=LFP_xcov.tzero_xcov{chani}{chanj};
        peaklagtime_image(i,j)=LFP_xcov.peaklagtime{chani}{chanj};
    end
end

figure(1)
close 1
figure(1)
max_xcovimage=flipud(max_xcovimage);
imagesc(max_xcovimage)
axis square

tickdiv=10;
axislabels=[0 s.z(orderedchannels(tickdiv:tickdiv:length(orderedchannels)))']/1000;  %z position of electrodes, in mm
xaxisticks=[0:tickdiv:length(orderedchannels)];
xyoffset=1+length(orderedchannels)-round(length(orderedchannels)/tickdiv)*tickdiv;
yaxisticks=[xyoffset:tickdiv:length(orderedchannels)];
set(gca,'XTick',xaxisticks)
set(gca,'XTickLabel',axislabels)
set(gca,'YTick',yaxisticks)
set(gca,'YTickLabel',fliplr(axislabels))
xlabel('z spacing from tip electrode (mm)')
ylabel('z spacing from tip electrode (mm)')
title(['Maximum LFP cross covariance, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz'])
colorbar
set(gca,'FontSize',8,'TickDir','out')

saveas(figure(1),[stimephysjpgdir 'max_xcov' num2str(meanfrequency) 'Hz.jpg' ]  ,'jpg')
saveas(figure(1),[stimephysepsdir 'max_xcov' num2str(meanfrequency) 'Hz.eps' ]  ,'psc2')
saveas(figure(1),[stimephysmfigdir 'max_xcov' num2str(meanfrequency) 'Hz.fig' ]  ,'fig')