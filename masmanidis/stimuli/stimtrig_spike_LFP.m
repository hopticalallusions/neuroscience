['calculating stimulus-triggered field and psth profile.']

set_plot_parameters

xdiv=0.2; %units in seconds.
ydiv=0.2;  %units in mm.

refchan=37;  %used for spike-phase analysis.

selectstim='n'; %if 'y', will only select the specified stimulus value (e.g., moving bar angle=90 degrees) for triggered averaging.
stimulusvalue=90;  %use if selectstim=='y' to downselect the rangle of stimuli. (e.g., specify 90 for angle of visual bar stimulus).
%************************************************

load([LFPdir 'LFPparams.mat'])
load([timesdir 'finalspiketimes.mat'])
load([timesdir 'final_params.mat']);  %loads parameters file.
load([savedir 'units\wave specs\' 'spikeposition' '.mat'])
load([stimulidir 'stimuli.mat'])

mkdir(rasterjpgdir); mkdir(rasterepsdir); mkdir(rastermfigdir)
mkdir(tuningcurvejpgdir); mkdir(tuningcurveepsdir); mkdir(tuningcurvefigdir)

select_dounits

LFPsamplingrate=LFPparameters.samplingrate;
roughyposition=spikeposition.y;
halfwidth=parameters.wavespecs.halfwidth;
troughamp=parameters.wavespecs.troughamp;
peakamp=parameters.wavespecs.postpeakamp;

[sortedangles,sortedtrials]=sort(stimuli.anglepertrial); 
uniqueangles=unique(sortedangles);
trialstarttimes=stimuli.trialstarttimes*LFPsamplingrate;
meanendtime=mean(stimuli.trialendtimes-stimuli.trialstarttimes);
stimtime=[0+LFPleftpoints meanendtime+LFPleftpoints];
meanintertrialinterval=mean(diff(stimuli.trialstarttimes))-mean(stimuli.trialendtimes-stimuli.trialstarttimes);

phasebins=[0:phaseincrement:(360-phaseincrement)];  

trigtimebins=-LFPleftpoints:trigbinsize:LFPrightpoints;

fi=(0:1:360)*pi/180;
cosineref=cos(fi);

uniquedepths=unique(s.y);
probedepths=-(uniquedepths-max(uniquedepths)-tipelectrode)/1000;
   

LFPtrigtimes=[]; spikeLFPphase=[]; trigtimespertrial=[]; firstspikelatency=[];  %initializes vectors.
for unitind=1:length(dounits)
unitj=dounits(unitind);
LFPtrigtimes{unitj}=[];
spikeLFPphase{unitj}=zeros(size(phasebins))';
trigtimespertrial{unitj}=[];
firstspikelatency{unitj}=[];
end

spikelatency_depth=[]; spikeamplitude_depth=[];
for i=1:length(uniquedepths); %initializes vectors.
spikelatency_depth{i}=[];
spikeamplitude_depth{i}=[];
end

stimoffspiketimes=[]; stimonspiketimes=[]; totalstimofftime=0; totalstimontime=[];  
for unitind=1:length(dounits)
    unitj=dounits(unitind);
    stimoffspiketimes{unitj}=[];
    stimonspiketimes{unitj}=[];
    for q=1:length(uniqueangles)
        stimonspiketimes{unitj}{q}=[];
        totalstimontime{q}=0;
    end
end


%1.
['finding stimulus-triggered LFP profiles.']
FTA_LFP=[]; 
for i=1:length(uniquedepths);
    depthi=uniquedepths(i);
    chansi=find(s.y==depthi);
    chansi=setdiff(chansi,badchannels);
   
    for j=1:length(chansi);
        chanj=chansi(j);
%         ['collecting stimulus-triggered average for channel ' num2str(chanj) '.']
        currentvoltagefile=['LFPvoltage_ch' num2str(chanj) '.mat'];
        load([LFPvoltagedir currentvoltagefile]); 
        dofilter_LFP
        
        LFPdepthi=[]; voltagedepthi=[];
        for k=1:length(sortedangles);
            trial=sortedtrials(k);         %select specific angle for stimulus-triggered LFP averaging.
            ti=trialstarttimes(trial);
            t0=ti-round(LFPleftpoints*LFPsamplingrate);
            tf=ti+round(LFPrightpoints*LFPsamplingrate);
            if t0<1 | tf>length(LFPvoltage) 
            continue
            end
            
            if selectstim=='y' & stimuli.anglepertrial(trial)~=stimulusvalue  %trial~=7     %select specific angle for stimulus-triggered LFP averaging.            
            continue
            end
       
            voltagedepthi=[voltagedepthi; LFPvoltage(t0:tf)];            %take LFP voltage.
        end        
    end
        
    if  size(voltagedepthi,1)>1
    FTA_LFP=[FTA_LFP; mean(voltagedepthi)];
    else
    FTA_LFP=[FTA_LFP; voltagedepthi];
    end
    clear LFPdepthi
    
end

FTA_LFP=flipud(FTA_LFP);
h=fspecial('gaussian',3,0.75);  %gaussian filter.
smoothFTA_LFP = filter2(h, FTA_LFP);


%1b.
['finding tuning curve of LFP.']
LFP_tuning=[]; 
for q=1:length(uniqueangles)
LFP_tuning{q}=[];   
end
    
currentvoltagefile=['LFPvoltage_ch' num2str(refchan) '.mat'];
load([LFPvoltagedir currentvoltagefile]); 
dofilter_LFP
        
for k=1:length(sortedangles);
    trial=sortedtrials(k);         %select specific angle for stimulus-triggered LFP averaging.
    angle=stimuli.anglepertrial(trial);
    q=find(uniqueangles==angle);    %identifies q index for stimonspiketimes 
    ti=stimuli.trialendtimes(trial)*LFPsamplingrate;
    t0=ti;
    tf=ti+round(meanintertrialinterval*LFPsamplingrate);
    if t0<1 | tf>length(LFPvoltage) 
    continue
    end
    LFP_tuning{q}=[LFP_tuning{q} rms(LFPvoltage(t0:tf))];            %take rms LFP voltage.
end        

LFPpowervsangle=[];
for q=1:length(uniqueangles)
    LFPpowervsangle=[LFPpowervsangle sqrt(sum(LFP_tuning{q}.^2))]; 
end

  
%2. 
['calculating firing rates during stimulus-on and baseline.']
for k=1:length(sortedangles);
    trial=sortedtrials(k);
    angle=stimuli.anglepertrial(trial);
    q=find(uniqueangles==angle);    %identifies q index for stimonspiketimes
  
    if  trial==1 
        tstart=stimuli.trialstarttimes(trial)-meanintertrialinterval;
        totalstimofftime=meanintertrialinterval;
    elseif trial>1 
        tstart=stimuli.trialendtimes(trial-1);
        totalstimofftime=[totalstimofftime+(stimuli.trialstarttimes(trial)-stimuli.trialendtimes(trial-1))];
    end 
    
    totalstimontime{q}=[totalstimontime{q}+(stimuli.trialendtimes(trial)-stimuli.trialstarttimes(trial))];
    
    for unitind=1:length(dounits);
        unitj=dounits(unitind);
        stimesunitj=spiketimes{unitj};
        stimoffspiketimesj=stimesunitj(find(stimesunitj<stimuli.trialstarttimes(trial) & stimesunitj>tstart));
        stimoffspiketimes{unitj}=[stimoffspiketimes{unitj} stimoffspiketimesj];
        
        stimonspiketimesj=stimesunitj(find(stimesunitj<=stimuli.trialendtimes(trial) & stimesunitj>stimuli.trialstarttimes(trial)));
        stimonspiketimes{unitj}{q}=[stimonspiketimes{unitj}{q} stimonspiketimesj];
        
    end

end

stimoffrate=[]; stimonrate=[]; 
for unitind=1:length(dounits);    %firing rate as a function of stimulus parameter (e.g., angle) & baseline rate.
	unitj=dounits(unitind);
    stimoffrate{unitj}=length(stimoffspiketimes{unitj})/totalstimofftime;
    stimonrate{unitj}=[];
    for q=1:length(uniqueangles)
        stimonrate{unitj}=[stimonrate{unitj} length(stimonspiketimes{unitj}{q})/totalstimontime{q}];
    end
end

stimonrate_depth=[]; stimoffrate_depth=[];  
for i=1:length(uniquedepths);
    depthi=uniquedepths(i);
    chansi=find(s.y==depthi);
    chansi=setdiff(chansi,badchannels);
    
    unitsdepthi=find(roughyposition==depthi);
    unitsdepthi=intersect(unitsdepthi,dounits);
    
    stimonrate_depth{i}=[]; stimoffrate_depth{i}=[]; 
    
    for j=1:length(unitsdepthi);
        unitj=unitsdepthi(j);
        stimonrate_depth{i}=[stimonrate_depth{i} stimonrate{unitj}];
        stimoffrate_depth{i}=[stimoffrate_depth{i} stimoffrate{unitj}];
    end
end
        

%3. 
['calculating LFP peak-triggered spike PSTH & latency to first spike.']
for k=1:length(sortedangles);
    trial=sortedtrials(k);
    ti=trialstarttimes(trial)/LFPsamplingrate;  %start of stimulus presentation for the current trial.
    t0=ti-LFPleftpoints;
    tf=ti+LFPrightpoints;

%   if ti<(nictime) | ti>(nictime+5*60)
%   continue
%   end
  
    if selectstim=='y' &  stimuli.anglepertrial(trial)~=stimulusvalue    %select specific angle for stimulus-triggered LFP averaging.        
    continue
    end

    for unitind=1:length(dounits)
        unitj=dounits(unitind);
        stimesunitj=spiketimes{unitj};
        trigtimesj=stimesunitj(find(stimesunitj<=tf & stimesunitj>t0));
        if length(trigtimesj)>0
        trigtimesj=trigtimesj-stimuli.trialendtimes(trial); %ti;  %realign times to start of stimulus presentation for the current trial.
        positivtimes=trigtimesj;
        positivtimes(find(positivtimes<=0))=[];
            if min(positivtimes)<0.1  %add first spike latency only if latency < 0.1 s.
            firstspikelatency{unitj}=[firstspikelatency{unitj} positivtimes(find(positivtimes==min(positivtimes)))];
            end
        else trigtimesj=-2*LFPleftpoints;
        end
             
        LFPtrigtimes{unitj}=[LFPtrigtimes{unitj}, trigtimesj];  
        
        trialcounter=length(trigtimespertrial{unitj})+1;
        trigtimespertrial{unitj}{trialcounter}=trigtimesj;
          
    end

end


FTA_spikes_zscore=[]; FTA_spikes_psth=[];
for i=1:length(uniquedepths);
    depthi=uniquedepths(i);
    chansi=find(s.y==depthi);
    chansi=setdiff(chansi,badchannels);
    
    unitsdepthi=find(roughyposition==depthi);
    unitsdepthi=intersect(unitsdepthi,dounits);
    
    psth=[]; zscore=[]; timesdepthi=[];
    for j=1:length(unitsdepthi);
        unitj=unitsdepthi(j);
        timesj=LFPtrigtimes{unitj};
        
        spikeamplitude_depth{i}=[spikeamplitude_depth{i} peakamp{unitj}-troughamp{unitj}];
        
        if length(timesj)>1 %& halfwidth{unitj}<205   %narrow selection for spike rate plotting.
        timesdepthi=[timesdepthi timesj];
        spikelatency_depth{i}=[spikelatency_depth{i} firstspikelatency{unitj}];  
        end        
    end
    
    psth=histc(timesdepthi,trigtimebins);                %removes last point, which because of binning has zero  value in psth.
    psth=psth(1:(length(psth)-1));
    zscore=(psth-mean(psth))/std(psth);
    
    if length(unitsdepthi)==0
    zscore=zeros(1,length(trigtimebins)-1);
    psth=zeros(1,length(trigtimebins)-1);
    end
  
    FTA_spikes_zscore=[FTA_spikes_zscore; zscore]; 
    FTA_spikes_psth=[FTA_spikes_psth; psth];
 
end

FTA_spikes_zscore=flipud(FTA_spikes_zscore);    %flip to put tip electrodes at bottom

h=fspecial('gaussian',3 ,0.75);  %gaussian filter. only applied along horizontal direction (i.e., time).
smoothFTA_spikes_zscore=filter2(h, FTA_spikes_zscore);

%4.
['calculating spike-LFP phase distribution.']       %note: in its current form the entire LFP trace is included, not just the peaks.

load([LFPvoltagedir 'LFPvoltage_ch' num2str(refchan)])
dofilter_LFP

hilbertLFP=hilbert(LFPvoltage);  %hilbert transform of LFP voltage from reference channel.
LFPphase=180*(atan2(imag(hilbertLFP),real(hilbertLFP)))/pi;  %cosine of this angle equals the LFP wave.       
negphaseinds=find(LFPphase<0);
LFPphase(negphaseinds)=LFPphase(negphaseinds)+360;
       
[nbins,binindex]=histc(LFPphase,phasebins);

LFPbins=0:1/LFPsamplingrate:(length(LFPvoltage)-1)/LFPsamplingrate;

for unitind=1:length(dounits)
    unitj=dounits(unitind);
    
    stimesunitj=spiketimes{unitj};
    spikesinbin=[];
    spikeLFPbincount=histc(stimesunitj,LFPbins);
        for binindk=1:length(phasebins);
        pointsinbin=find(binindex==binindk);
        spikesinbin=[spikesinbin; sum(spikeLFPbincount(pointsinbin))];
        end
    spikeLFPphase{unitj}=[spikeLFPphase{unitj}+spikesinbin];   
end

meanangle=[];
for unitind=1:length(dounits)
    unit=dounits(unitind);
    sumsine=0; sumcosine=0;
    for binindk=1:(length(phasebins))
        phasek=phasebins(binindk);
        spikesinbink=spikeLFPphase{unit}(binindk);
        sumsine=sumsine+spikesinbink*sin(phasek*pi/180);
        sumcosine=sumcosine+spikesinbink*cos(phasek*pi/180);
    end
    meanangleuniti=atan2(sumsine,sumcosine)*180/pi;
    if meanangleuniti<0
        meanangleuniti=meanangleuniti+360;
    end
meanangle=[meanangle; meanangleuniti];
end

[histphase,bins]=histc(meanangle, phasebins);



figure(1)
subplot(2,1,1)
hold off
imagesc(smoothFTA_LFP)   %plot command. remove ranges if want to show entire range

colorbar
colormap jet

set(gca,'XTick',[0:(LFPsamplingrate*xdiv):size(FTA_LFP,2)])
set(gca,'XTickLabel',[-LFPleftpoints:xdiv:LFPrightpoints])
xlabel('time (s)','FontSize',10)

lines_permm=size(FTA_LFP,1)/(max(probedepths));
set(gca,'YTick',[0:lines_permm*ydiv:size(FTA_LFP,1)])
set(gca,'YTickLabel',[ceil(size(FTA_LFP,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)

title([filename '; Stimulus triggered average LFP vs depth. f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')

for events=1:length(stimtime);  %plot lines at trial start & end.
    etime=stimtime(events);
    line([LFPsamplingrate*etime LFPsamplingrate*etime], [0+1 size(FTA_LFP,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes
end


subplot(2,1,2)
hold off
imagesc(smoothFTA_spikes_zscore)
colormap('jet')
colorbar

set(gca,'XTick',[0:(size(FTA_spikes_zscore,2)*xdiv/(LFPleftpoints+LFPrightpoints)):size(FTA_spikes_zscore,2)])
set(gca,'XTickLabel',[-LFPleftpoints:xdiv:LFPrightpoints])
xlabel('time (s)','FontSize',10)

lines_permm=size(FTA_LFP,1)/(max(probedepths));
set(gca,'YTick',[0:lines_permm*ydiv:size(FTA_LFP,1)])
set(gca,'YTickLabel',[ceil(size(FTA_LFP,1)/lines_permm/ydiv)*ydiv:-ydiv:0])
ylabel('distance from probe tip (mm)','FontSize',10)

title([filename '; Stimulus triggered average z-score of firing rate vs depth.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')

for events=1:length(stimtime);  %plot lines at trial start & end.
    etime=stimtime(events);
    line([size(FTA_spikes_zscore,2)*etime/(LFPleftpoints+LFPrightpoints) size(FTA_spikes_zscore,2)*etime/(LFPleftpoints+LFPrightpoints)], [0+1 size(FTA_LFP,1)-1],'Color','k','LineStyle','-','LineWidth',1)  %convert times to minutes
end

scrsz=get(0,'ScreenSize');
set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   

saveas(figure(1),[spikeLFPjpgdir 'stimtrig_average' '.jpg' ]  ,'jpg')
saveas(figure(1),[spikeLFPepsdir 'stimtrig_average' '.eps' ]  ,'psc2')
saveas(figure(1),[spikeLFPmfigdir 'stimtrig_average' '.fig' ]  ,'fig')



figure(2)
subplot(1,3,[1 2])
hold off
bar([phasebins max(phasebins)+phaseincrement],[histphase; histphase(1)])
hold on
plot((cosineref+1)*max(histphase)/2,'g','LineWidth',2)
set(gca,'XTick',[0:45:360])
xlim([0 360])
xlabel('angle (degrees)','FontSize',10)
ylabel('number of units','FontSize',10)
title([filename '; mean spike-LFP phase per units. reference ch. = ' num2str(refchan) '.'], 'FontSize',10)
set(gca,'FontSize',10,'TickDir','out')
subplot(1,3,3)
hold off
rose(meanangle*pi/180)

saveas(figure(2),[spikeLFPjpgdir 'stimtrig_spikeLFPphase' '.jpg' ]  ,'jpg')
saveas(figure(2),[spikeLFPepsdir 'stimtrig_spikeLFPphase' '.eps' ]  ,'psc2')
saveas(figure(2),[spikeLFPmfigdir 'stimtrig_spikeLFPphase' '.fig' ]  ,'fig')


%5. Get spike latency vs depth plot.
figure(4)
close 4
meanlatency=[]; stdlatency=[]; tipdepths=[]; 
for i=1:length(uniquedepths); %initializes vectors.
figure(4)
depthi=(uniquedepths(i)+tipelectrode)/1000;  %distance from tip in mm.  
latenciesindepth=spikelatency_depth{i}
if length(latenciesindepth)>0
    plot(depthi,latenciesindepth,'ok','MarkerSize',2)
    tipdepths=[tipdepths; depthi];
    meanlatency=[meanlatency mean(latenciesindepth)];
    stdlatency=[stdlatency std(latenciesindepth)];
end
hold on
end
% semilogy(tipdepths,meanlatency,'-r','LineWidth',2)
plot(tipdepths,meanlatency, '-r','LineWidth',2)
plot(tipdepths,meanlatency+stdlatency, '--r','LineWidth',1)
plot(tipdepths,meanlatency-stdlatency, '--r','LineWidth',1)
set(gca,'FontSize',10,'TickDir','out')
xlim([0 (max(uniquedepths)+tipelectrode)/1000])
xlabel('distance from tip (mm)','FontSize',10)
ylabel('latency to first spike (s)','FontSize',10)  
title(['Latency to first spike vs depth'])

saveas(figure(4),[spikeLFPjpgdir 'spikelatency' '.jpg' ]  ,'jpg')
saveas(figure(4),[spikeLFPepsdir 'spikelatency' '.eps' ]  ,'psc2')
saveas(figure(4),[spikeLFPmfigdir 'spikelatency' '.fig' ]  ,'fig')


%6. Get spike amplitude vs depth plot.
figure(5)
close 5
figure(5)
meanampdepth=[]; tipdepths=[];
for i=1:length(uniquedepths); %initializes vectors.
depthi=(uniquedepths(i)+tipelectrode)/1000;  %distance from tip in mm.  
ampsindepth=abs(spikeamplitude_depth{i});
if length(ampsindepth)>0
    plot(depthi,ampsindepth,'ok','MarkerSize',2)
    tipdepths=[tipdepths; depthi];
    meanampdepth=[meanampdepth mean(ampsindepth)];
end
hold on
end
plot(tipdepths,meanampdepth,'-r','LineWidth',2)
set(gca,'FontSize',10,'TickDir','out')
xlim([0 (max(uniquedepths)+tipelectrode)/1000])
xlabel('distance from tip (mm)','FontSize',10)
ylabel('unit amplitude (\mum)','FontSize',10)  
title(['Peak-to-trough amplitude of units vs depth'])
saveas(figure(5),[spikeLFPjpgdir 'spikeamplitude' '.jpg' ]  ,'jpg')
saveas(figure(5),[spikeLFPepsdir 'spikeamplitude' '.eps' ]  ,'psc2')
saveas(figure(5),[spikeLFPmfigdir 'spikeamplitude' '.fig' ]  ,'fig')


%7. Get firing rates during stimulus on & off vs depth.
figure(8)
close 8
figure(8)
tipdepths=[]; meanonrate=[]; meanoffrate=[]; stdonrate=[]; stdoffrate=[];
for i=1:length(uniquedepths); %initializes vectors.
depthi=(uniquedepths(i)+tipelectrode)/1000;  %distance from tip in mm.  
onrate_depth=abs(stimonrate_depth{i});
offrate_depth=abs(stimoffrate_depth{i});
highfiring=find(onrate_depth>6);
onrate_depth(highfiring)=[];
% highfiring=find(offrate_depth>6);
offrate_depth(highfiring)=[];

if length(onrate_depth)>0
    subplot(2,1,1)
    plot(depthi,onrate_depth,'ok','MarkerSize',2)
    tipdepths=[tipdepths; depthi];
    meanonrate=[meanonrate mean(onrate_depth)];
    stdonrate=[stdonrate std(onrate_depth)];
    title(['Mean rate during stimulus.'])
    ylim([-1 35])
    hold on

    subplot(2,1,2)
    plot(depthi,offrate_depth,'ok','MarkerSize',2)
    meanoffrate=[meanoffrate mean(offrate_depth)];
    stdoffrate=[stdoffrate std(offrate_depth)];
    title(['Mean rate after stimulus.'])
    ylim([-1 35])
    hold on

end

end

subplot(2,1,1)
plot(tipdepths,meanonrate,'-r','LineWidth',2)
plot(tipdepths,meanonrate+stdonrate,'--r','LineWidth',1)
plot(tipdepths,meanonrate-stdonrate,'--r','LineWidth',1)
set(gca,'FontSize',10,'TickDir','out')
xlim([0 (max(uniquedepths)+tipelectrode)/1000])
ylabel('Firing rate (Hz)','FontSize',10)

subplot(2,1,2)
plot(tipdepths,meanoffrate,'-r','LineWidth',2)
plot(tipdepths,meanoffrate+stdoffrate,'--r','LineWidth',1)
plot(tipdepths,meanoffrate-stdoffrate,'--r','LineWidth',1)
set(gca,'FontSize',10,'TickDir','out')
xlim([0 (max(uniquedepths)+tipelectrode)/1000])
ylabel('Firing rate (Hz)','FontSize',10)

xlabel('distance from tip (mm)','FontSize',10)
saveas(figure(8),[spikeLFPjpgdir 'ratevsdepth' '.jpg' ]  ,'jpg')
saveas(figure(8),[spikeLFPepsdir 'ratevsdepth' '.eps' ]  ,'psc2')
saveas(figure(8),[spikeLFPmfigdir 'ratevsdepth' '.fig' ]  ,'fig')



plotraster=[];
plotraster=input('Do you want to create stimulus tuning curves & raster plots for each unit [y/n] (n)? ', 's');
if isempty(plotraster)==1
plotraster='n';
end

if plotraster=='y'
% %7. Plot LFP tuning curve.
% figure(7)
% close 7
% figure(7)
% plotLFPpower=[LFPpowervsangle LFPpowervsangle(1)]; %adds another point at 360 degrees (same as 0 deg).
% plot([uniqueangles 360],plotLFPpower,'ok','MarkerSize',5,'MarkerFaceColor','k')
% xlim([-5 365])
% ylim([min(plotLFPpower)-10 max(plotLFPpower)+10])
% xlabel('stimulus angle (deg)','FontSize',10)
% ylabel('RMS LFP power (\muV)','FontSize',10)  
% title(['Stimulus tuning curve of LFP'])
% saveas(figure(7),[spikeLFPjpgdir 'LFPtuning' '.jpg' ]  ,'jpg')
% saveas(figure(7),[spikeLFPepsdir 'LFPtuning' '.eps' ]  ,'psc2')
% saveas(figure(7),[spikeLFPmfigdir 'LFPtuning' '.fig' ]  ,'fig')


%8. Plot tuning curves.
figure(6)
for unitind=1:length(dounits)
    hold off
    unitj=dounits(unitind);
    rateunitj=(stimonrate{unitj}-stimoffrate{unitj});
    rateunitj=[rateunitj rateunitj(1)]; %adds another point at 360 degrees (same as 0 deg).
    plot([uniqueangles 360],rateunitj,'ok','MarkerSize',5,'MarkerFaceColor','k')
    set(gca,'FontSize',10,'TickDir','out')
    xlim([-5 365])
    ylim([-1 5*ceil(max(rateunitj)/5)])
    xlabel('stimulus angle (deg)','FontSize',10)
    ylabel('baseline-subtracted firing rate (Hz)','FontSize',10)  
    title(['Stimulus tuning curve of unit ' num2str(unitj) ', ' num2str(roughyposition(unitj)+tipelectrode) ' \mum above tip'])
    saveas(figure(6),[tuningcurvejpgdir 'tuning_u' num2str(unitj) '.jpg' ]  ,'jpg')
    saveas(figure(6),[tuningcurveepsdir 'tuning_u' num2str(unitj) '.eps' ]  ,'psc2')
    saveas(figure(6),[tuningcurvefigdir 'tuning_u' num2str(unitj) '.fig' ]  ,'fig')  
end


%9. Get raster plot. 
['doing raster plots.']
LFPtime=[-LFPleftpoints:1/LFPsamplingrate:LFPrightpoints];
refchandepthind=find(uniquedepths==roughyposition(refchan));
refLFPvoltage=FTA_LFP(refchandepthind,:);
for unitind=1:length(dounits)
    unitj=dounits(unitind);

    figure(3)
    close 3
    figure(3)
    hold off
     
    subplot(4,1,[1,2])
    timespertrialunitj=trigtimespertrial{unitj};
    rateunitj=histc(LFPtrigtimes{unitj},trigtimebins)/length(timespertrialunitj);
    rateunitj=smooth(rateunitj,'moving',5);
    for trialind=1:length(timespertrialunitj)
        timesintrial=timespertrialunitj{trialind};
        hold on
        plot([timesintrial; timesintrial], [0.8*ones(size(timesintrial))+(trialind-0.4); zeros(size(timesintrial))+(trialind-0.4)],'k')
    end   
    set(gca,'FontSize',10,'TickDir','out')
    set(gca,'XTickLabel','')
    xlim([-LFPleftpoints LFPrightpoints])
    ylim([0.5 length(timespertrialunitj)+0.5])
    ylabel('trial','FontSize',10)
    if selectstim=='y'
    title(['unit ' num2str(unitj) ', ' num2str(roughyposition(unitj)+tipelectrode) ' \mum above tip, stimulus = ' num2str(stimulusvalue) '.'])
    else title(['unit ' num2str(unitj) ', ' num2str(roughyposition(unitj)+tipelectrode) ' \mum above tip, all trials.'])
    end
   
    subplot(4,1,3)
    plot(trigtimebins, rateunitj,'k')
    set(gca,'FontSize',10,'TickDir','out')
    set(gca,'XTickLabel','')
    ylim([0.5*min(rateunitj)-0.01 1.5*max(rateunitj)+0.01])
    ylabel('rate (Hz)','FontSize',10)
    
    subplot(4,1,4)
    plot(LFPtime,refLFPvoltage,'k')
    ylim([-max(abs(refLFPvoltage))-10 max(abs(refLFPvoltage))+10])
    xlabel('time (s)','FontSize',10)
    ylabel(['LFP (' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz. \muV)'],'FontSize',8)
    set(gca,'FontSize',10,'TickDir','out')
    
    saveas(figure(3),[rasterjpgdir 'raster_u' num2str(unitj) '.jpg' ]  ,'jpg')
    saveas(figure(3),[rasterepsdir 'raster_u' num2str(unitj) '.eps' ]  ,'psc2')
    saveas(figure(3),[rastermfigdir 'raster_u' num2str(unitj) '.fig' ]  ,'fig')
    
end

end

stimtrig_spikeLFP=[];
stimtrig_spikeLFP.refchan=refchan;
stimtrig_spikeLFP.trialstarttimes=trialstarttimes;
stimtrig_spikeLFP.LFPsamplingrate=LFPsamplingrate;
stimtrig_spikeLFP.f_low_LFP=f_low_LFP;
stimtrig_spikeLFP.f_high_LFP=f_high_LFP;
stimtrig_spikeLFP.LFPtrigtimes=LFPtrigtimes;
stimtrig_spikeLFP.FTA_LFP=FTA_LFP;
stimtrig_spikeLFP.smoothFTA_LFP=smoothFTA_LFP;
stimtrig_spikeLFP.FTA_spikes_zscore=FTA_spikes_zscore;
stimtrig_spikeLFP.smoothFTA_spikes_zscore=smoothFTA_spikes_zscore;
stimtrig_spikeLFP.spikeLFPphase=spikeLFPphase;
stimtrig_spikeLFP.meanangle=meanangle;
stimtrig_spikeLFP.LFPphase=LFPphase;
stimtrig_spikeLFP.LFPbins=LFPbins;
stimtrig_spikeLFP.trigtimebins=trigtimebins;
stimtrig_spikeLFP.phasebins=phasebins;
stimtrig_spikeLFP.cosineref=cosineref;
stimtrig_spikeLFP.LFPleftpoints=LFPleftpoints;
stimtrig_spikeLFP.LFPrightpoints=LFPrightpoints;
stimtrig_spikeLFP.phaseincrement=phaseincrement;
stimtrig_spikeLFP.trigbinsize=trigbinsize;
stimtrig_spikeLFP.uniqueangles=uniqueangles;
stimtrig_spikeLFP.stimoffrate=stimoffrate;
stimtrig_spikeLFP.stimonrate=stimonrate;



save([spikeLFPdir 'stimtrig_spikeLFP.mat'], 'stimtrig_spikeLFP', '-MAT')

