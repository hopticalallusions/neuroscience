disp(['Calculating field-triggered LFP and PSTH profile. triggered on a reference channel.'])
    
set_plot_parameters

triggerevent1='LFP';  %options: 'CS1', 'CS2', 'laser', 'startlicking', 'endlicking', 'solenoid', 'LFP', 'LFPenvelope_peaks'. 
                      %Selecting 'LFP' will use the entire LFP trace. 'LFPenvelope_peaks' will use the peaks from the LFP envelope over entire trace.

trialselection1='all';     %select which event1 trials to display. not used if triggerevent1='LFP'
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
                            
laserfreqselect='10 Hz';    %if doing triggerevent='laser', specify trials that contain only this frequency. options: 'x Hz' or 'none'. Note: if not set to 'none' this overrides the trialselection setting.

f_low_LFP=35;              
f_high_LFP=45;          

minLFPamp=250;               %default=100. use fixed LFP amplitude threshold instead of S.D. in peak detection; this keeps thresholds constant across all channels.
maxLFPamp=1000;              %default=250. any LFP peaks above this will be treated as movement artifacts.

% minLFPthreshold=3;           %default=5. threshold number of SDs for identifying high-amplitude oscillations.
% maxLFPthreshold=10;           %default=1000.  This will ensure that all peaks >minLFPthreshold will be detected.  
 
peripktime=0.1;            %collects spikes +/-peripktime from LFP peak.
timebinsize=0.002;

preLFPpeaktime=-1;         %default=-1 seconds. used in getting peri-event LFP peak times. not used if triggerevent='LFP'
postLFPpeaktime=5;         %default=5 seconds. used in getting peri-event LFP peak times. 

ydiv=0.5;  %units in mm.

slidingwindow=5;             %default=3. sliding window size for averaging firing rate.
% phaseincrement=15;         %default=15 degrees. used in spike-LFP;         %must be positive. default=0.5 s. duration to plot around LFP peaks in spike_LFP.
% trigbinsize=0.02;          %default=0.005; bin size for counting spikes triggered to LFP peaks.

%************************************************

xdiv=peripktime/5;     %units in seconds.

triggerevent2='none';  %currently not in use here.
triggerevent3='none';  %currently not in use here.  
trialselection2='all';  %currently not in use here.
trialgroupsize=10;  %currently not in use here.   

load_results

select_triggers_trials       %determines which event triggers and trials to use in plotting.  

timebins=-peripktime:timebinsize:peripktime;

% trigtimebins=-peripktime:trigbinsize:peripktime;
% phasebins=[0:phaseincrement:(360-phaseincrement)];  
% fi=(0:1:360)*pi/180;
% cosineref=cos(fi);
    
figure(2)
close 2

figure(1)
close 1
figure(1)

%1.
[refvoltagefile, LFPvoltagedir]=uigetfile({[LFPvoltagedir '*.mat']},'Select a channel to use as a reference for LFP analysis');
prechtxt=findstr(refvoltagefile,'_ch');
postchtxt=findstr(refvoltagefile,'.mat');
refchan=str2num(refvoltagefile((prechtxt+3):(postchtxt-1)));
disp(['reference channel = ' num2str(refchan) '.'])
load([LFPvoltagedir refvoltagefile]);
disp(['filtering LFP from ' num2str(f_low_LFP) ' to ' num2str(f_high_LFP) ' Hz.'])
dofilter_LFP

stdLFPvoltage=std(LFPvoltage);     
%     minLFPdetectthreshold=minLFPthreshold*stdLFPvoltage;     %detect LFP peaks on lower bound on of threshold. note: the lower the threshold, the more the number of detected peaks.   
minLFPdetectthreshold=minLFPamp;
[pks,LFPpktimes_lowerbound]=findpeaks(LFPvoltage,'minpeakheight',minLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));           
%     maxLFPdetectthreshold=maxLFPthreshold*stdLFPvoltage;  %detect LFP peaks on upper bound on of threshold. %upperbound peaks are fewer than lowerbound peaks.
maxLFPdetectthreshold=maxLFPamp;
[pks, LFPpktimes_upperbound]=findpeaks(LFPvoltage,'minpeakheight',maxLFPdetectthreshold,'minpeakdistance',round(LFPsamplingrate/100));  

LFPpktimes=setdiff(LFPpktimes_lowerbound,LFPpktimes_upperbound);  %get the LFP peaks that have amplitude >minLFPthreshold and <maxLFPthreshold.
  
if strmatch(triggerevent1,'LFP','exact')==0   %note: if triggerevent='LFP' then use all the LFP peak times.
event_trig_LFPpktimes=[];
for i=1:length(LFPpktimes)
    LFPpktimei=LFPpktimes(i);
    isnearevent=find((LFPpktimei/LFPsamplingrate-event1times(doevent1trials))<postLFPpeaktime & (LFPpktimei/LFPsamplingrate-event1times(doevent1trials))>=preLFPpeaktime);
    if length(isnearevent)>0
         if length(event_trig_LFPpktimes)==0
         event_trig_LFPpktimes=[event_trig_LFPpktimes LFPpktimei];
         elseif length(event_trig_LFPpktimes)>0 & (LFPpktimei-max(event_trig_LFPpktimes))>10*LFPsamplingrate
         event_trig_LFPpktimes=[event_trig_LFPpktimes LFPpktimei]; 
         end
    end
end
disp(['**among those peaks, found a subset of ' num2str(length(event_trig_LFPpktimes)) ' peri-event peaks in LFP.']) 
LFPpktimes=event_trig_LFPpktimes;    %LFPpktimes has units of samples.
end

if strmatch(triggerevent1,'LFPenvelope_peaks','exact')==1   
disp(['using LFP envelope function to select the peak times of each high amplitude episode.'])
get_LFPenvelope;
LFPpktimes=peakenvelopetimes;
end
    
disp(['found ' num2str(length(LFPpktimes)) ' supra-threshold events on the reference channel.'])

LFPtrig_spiketimes=[]; LFPtrig_spikerate=[]; normrate_LFPtrig=[]; spikeLFP_modindex=[];
for unitind=1:length(dounits)   %initialize
    unitj=dounits(unitind);
    LFPtrig_spiketimes{unitj}=[];
end

[neworder, sortindices]=sort(cell2mat(unitz));  %arranging plot order of unit stack according to depth
units_depthordered=dounits(sortindices);   %orders the units according to depth (low to high # = shallow-to-deep);
units_depthordered=fliplr(units_depthordered);  %flips from deep-to-shallow ordering to shallow-to-deep ordering
origunitorder=units_depthordered;    

for shaftind=1:numberofshafts;   
    currentshaft=uniqueshafts(shaftind);
    chansonshaft=find(s.shaft==currentshaft);
    goodchansonshaft=setdiff(chansonshaft,badchannels);   
    unitsonshaft=dounits(find(shafts==currentshaft));
    disp(['current shaft: ' num2str(currentshaft) ', containing ' num2str(length(unitsonshaft)) ' units.']) 
    unitorder=intersect(origunitorder,unitsonshaft,'stable');   %'stable' keeps the original order of unitorder;  


   
    fieldtrig_LFP=[]; 
    for i=1:length(uniquedepths);
     
        depthi=uniquedepths(i);
        chansi=find(s.z==depthi);
        chansi=intersect(chansi,chansonshaft);
   
        if length(chansi)>0
        for j=1:length(chansi);
            chanj=chansi(j);
            
            if length(intersect(chanj,badchannels))==1   %if current channel is bad, use the nearest good channel in its place.
                zchanj=s.z(chanj);
                zgoodchansonshaft=s.z(setdiff(goodchansonshaft,chanj));
                diffz=abs(zgoodchansonshaft-zchanj);
                minind=find(diffz==min(diffz));
                newchanj=min(goodchansonshaft(minind));
                disp(['channel ' num2str(chanj) ' is bad; using the nearest channel (' num2str(newchanj) ') in its place.'])
                chanj=newchanj;
            else disp(['collecting reference field-triggered average LFP for channel ' num2str(chanj) '.'])
            end
                     
            currentvoltagefile=[refvoltagefile(1:(prechtxt+2)) num2str(chanj) '.mat'];
            load([LFPvoltagedir currentvoltagefile]); 
            dofilter_LFP
        
            LFPdepthi=[]; voltagedepthi=[];
            for k=1:length(LFPpktimes);
                ti=LFPpktimes(k);
                t0=ti-round(peripktime*LFPsamplingrate);
                tf=ti+round(peripktime*LFPsamplingrate);
                if t0<1 | tf>length(LFPvoltage) 
                continue
                end
                voltagedepthi=[voltagedepthi; LFPvoltage(t0:tf)];            
            end        
        end
        
        if  size(voltagedepthi,1)>1
        fieldtrig_LFP=[fieldtrig_LFP; mean(voltagedepthi)];
        else
        fieldtrig_LFP=[fieldtrig_LFP; voltagedepthi];
        end
        clear LFPdepthi
        end
    
    end

    fieldtrig_LFP=flipud(fieldtrig_LFP);

%     h=fspecial('gaussian',3,0.75);  %gaussian filter.
    h=fspecial('gaussian',[1 3],0.75);  %gaussian filter only in time direction.
    smoothfieldtrig_LFP = filter2(h, fieldtrig_LFP);
    
    subplot(3,length(uniqueshafts),shaftind)
    hold off
    imagesc(smoothfieldtrig_LFP)   %plot command. remove ranges if want to show entire range
    colormap('jet')
    colorbar

    set(gca,'XTick',[0:(LFPsamplingrate*xdiv):size(fieldtrig_LFP,2)])
    set(gca,'XTickLabel',[-peripktime:xdiv:peripktime])
    xlabel(['shaft ' num2str(currentshaft) ', AP=' num2str(positions.AP{currentshaft}) ', ML=' num2str(positions.ML{currentshaft}) ' mm'] ,'FontSize',8)

    yticks=0:5:length(uniquedepths);
    remticks=rem(length(uniquedepths),max(yticks));
    set(gca,'YTick',yticks)
    lines_permm=length(uniquedepths)/max(probedepths);  %lines per millimeter.
    yticklabels=fliplr(yticks/lines_permm+shaftz{currentshaft}+remticks/lines_permm); 
    yticklabels=round(yticklabels*100)/100;
    set(gca,'YTickLabel',yticklabels)
    ylabel('electrode depth (mm)','FontSize', 8)
        
    title(['FTA, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection1 '. Ref ch. = ' num2str(refchan) '.' ], 'FontSize', 8)
    set(gca,'FontSize',8,'TickDir','out')

    refchanheight=-(s.z(refchan)-max(uniquedepths)-tipelectrode)/1000*lines_permm;
    line([1 size(fieldtrig_LFP,2)/20], [refchanheight refchanheight])      %draw short line at the height of the reference channel.
    
    figure(2)
    meanLFPpower=fliplr(mean((fieldtrig_LFP.^2)'));
    meanLFPamp=sqrt(meanLFPpower);
    subplot(2,length(uniqueshafts),shaftind)
    hold off
    plot(meanLFPamp)
    xticks=yticks;
    xticklabels=round(fliplr(yticklabels)*10)/10;
    set(gca,'XTick', xticks)
    set(gca,'XTickLabel',xticklabels)
    xlabel('electrode depth (mm)','FontSize', 8)
    ylabel('LFP amplitude (uV)','FontSize',8)
    title(['Shaft ' num2str(currentshaft) ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. Trials: ' trialselection1 '. Ref ch. = ' num2str(refchan) '.'],'FontSize',8)
    set(gca,'FontSize',8,'TickDir','out')
    
    peakFTAtimes=[];
    for i=1:size(fieldtrig_LFP,1)
      FTAi=fieldtrig_LFP(i,:);
      peakFTAtimes=[peakFTAtimes (find(FTAi==max(FTAi))-peripktime*LFPsamplingrate-1)*1000/LFPsamplingrate];
    end
    peakFTAtimes=fliplr(peakFTAtimes);
       
    subplot(2,length(uniqueshafts),length(uniqueshafts)+shaftind)
    hold off
    plot(peakFTAtimes,'-ok','MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','k')
    set(gca,'XTick', xticks)
    set(gca,'XTickLabel',xticklabels)
    xlabel('electrode depth (mm)','FontSize', 8)
    ylabel('lag time relative to reference (ms)','FontSize',8)
    set(gca,'FontSize',8,'TickDir','out')
   
    figure(1)
    
    %3. 
    disp(['finding LFP-triggered spike times and rate for units on shaft ' num2str(currentshaft) '.'])

    for i=1:length(LFPpktimes);
        ti=LFPpktimes(i)/LFPsamplingrate;
        t0=ti-peripktime;
        tf=ti+peripktime;

        for unitind=1:length(unitsonshaft)
            unitj=unitsonshaft(unitind);
            stimesunitj=spiketimes{unitj};
            trigtimesj=stimesunitj(find(stimesunitj<tf & stimesunitj>=t0));
            if length(trigtimesj)>0
            trigtimesj=trigtimesj-ti;  %realign times to local LFP peak.
            LFPtrig_spiketimes{unitj}=[LFPtrig_spiketimes{unitj}, trigtimesj];     
            end            
        end
    
    end

    for unitind=1:length(unitsonshaft)   %normalize field-triggered firing rates
        unitj=unitsonshaft(unitind);    
        if length(LFPtrig_spiketimes{unitj})==0
            LFPtrig_spiketimes{unitj}=2*recordingduration;
        end
        LFPtrig_spikerate{unitj}=histc(LFPtrig_spiketimes{unitj},timebins)/length(LFPpktimes)/timebinsize;
        LFPtrig_spikerate{unitj}=LFPtrig_spikerate{unitj}(1:(length(LFPtrig_spikerate{unitj})-1));  
        LFPtrig_spikerate{unitj}=smooth(LFPtrig_spikerate{unitj},slidingwindow); %sliding window average  
        
        maxmodulationj=max(LFPtrig_spikerate{unitj});
        minmodulationj=min(LFPtrig_spikerate{unitj});
        baselineratej=length(spiketimes{unitj})/recordingduration;  %mean firing over the entire recording trace.
        
        spikeLFP_modindex{unitj}=(maxmodulationj-minmodulationj)/baselineratej;   %spike-LFP modulation index.
        normrate_LFPtrig{unitj}=(LFPtrig_spikerate{unitj})/(max(LFPtrig_spikerate{unitj}));   %mean normalized firing rate. range = 0 to 1.
    end

    firingstack_LFPtrig=[];  depthtextlabel=[]; textxpos=[]; textypos=[];
    for unitind=1:length(unitorder);
        unitj=unitorder(unitind);    %proceed in the sorted order of units.    
        if  length(intersect(unitsonshaft,unitj))==1
            firingstack_LFPtrig=[firingstack_LFPtrig; normrate_LFPtrig{unitj}'-mean(normrate_LFPtrig{unitj})];
            
            if mod(unitind,3)==0
            textxpos=[textxpos 10];
            textypos=[textypos unitind];
            depthtextlabel=[depthtextlabel; num2str(unitz{unitj},3)];
            end
            
        end    
    end
   
    subplot(3,length(uniqueshafts),length(uniqueshafts)+shaftind)

    hold off
    
    imagesc(firingstack_LFPtrig, [-0.5 0.5])
    colormap('jet')
    colorbar
    text(textxpos,textypos,depthtextlabel,'FontSize',8,'Color','b')

    set(gca,'XTick',[0:(size(firingstack_LFPtrig,2)*xdiv/(peripktime+peripktime)):size(firingstack_LFPtrig,2)])
    set(gca,'XTickLabel',[-peripktime:xdiv:peripktime])
    xlabel('time (s)','FontSize', 8)
    ylabel('Cell index','FontSize', 8)
    title(['FTA firing rate, ordered by depth'], 'FontSize', 8)
    set(gca,'FontSize', 8,'TickDir','out')

    subplot(3,length(uniqueshafts),2*length(uniqueshafts)+shaftind)
    
    hold off
    
    plotindex=1; 
%     sigmodulated=0;
    for i=size(firingstack_LFPtrig,1):-1:1   %work backwards to ensure that ventral-most units are on bottom of plot      
%         unitj=unitorder(i);
%         if spikeLFP_modindex{unitj}<=3       
        plot(timebins(1:(length(timebins)-1)),firingstack_LFPtrig(i,:)+plotindex,'k')
%         else plot(timebins(1:(length(timebins)-1)),firingstack_LFPtrig(i,:)+plotindex,'r');   %plots units in red if they are significantly modulated.
%             sigmodulated=sigmodulated+1;
%         end
        plotindex=plotindex+1;
        hold on
    end  
    xlabel('time (s)','FontSize', 8)
    ylabel('Cell index','FontSize', 8)
    title(['FTA firing rate, ordered by depth'], 'FontSize', 8)
    set(gca,'FontSize', 8,'TickDir','out')
  
end

scrsz=get(0,'ScreenSize');
set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   


unit_depths=cell2mat(unitz);
unit_depths=unit_depths(fliplr(sortindices));
scat_modindices=cell2mat(spikeLFP_modindex);

figure(3)
subplot(2,1,1)
plot(unit_depths,log10(scat_modindices),'o','MarkerSize', 5,'MarkerEdgeColor','b')
xlabel('unit depth (mm)', 'FontSize',8)
ylabel('Log(spike-LFP modulation index)', 'FontSize',8)
title(['Log of spike-LFP modulation index, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'], 'FontSize',8)
set(gca,'FontSize',8,'TickDir','out')

set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.3*scrsz(3) 0.8*scrsz(4)])   


meanfrequency=round(mean([f_low_LFP f_high_LFP]));
saveas(figure(1),[stimephysjpgdir 'spikeLFP_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.jpg' ]  ,'jpg')
saveas(figure(1),[stimephysepsdir 'spikeLFP_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.eps' ]  ,'psc2')
saveas(figure(1),[stimephysmfigdir 'spikeLFP_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.fig' ]  ,'fig')

saveas(figure(2),[stimephysjpgdir 'meanLFPvsd_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.jpg' ]  ,'jpg')
saveas(figure(2),[stimephysepsdir 'meanLFPvsd_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.eps' ]  ,'psc2')
saveas(figure(2),[stimephysmfigdir 'meanLFPvsd_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.fig' ]  ,'fig')

saveas(figure(3),[stimephysjpgdir 'modindex_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.jpg' ]  ,'jpg')
saveas(figure(3),[stimephysepsdir 'modindex_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.eps' ]  ,'psc2')
saveas(figure(3),[stimephysmfigdir 'modindex_' num2str(meanfrequency) 'Hz_ref' num2str(refchan) '.fig' ]  ,'fig')
