disp(['Getting unit properties for classification.'])

%***Set parameters****
isirange=1;
isibinsize=0.001;
max_burstisi=0.005;
min_pauseisi=2;
qualitycutoff=1;
timebinsize=0.05;


baseline_start=-7.5; %used in baseline_rate
baseline_end=-2.5;

waveupsamplingfact=100;   %default=100. upsampling factor for interpolating spike waveforms to improve fitting.
%******************************************
close all 

load_results

load([unitclassdir 'positions' '.mat'])

if exist([stimulidir 'stimuli.mat'])
event1times=cue1times;
end
baseline_rate


delete([unitclassdir 'unitproperties.txt'])
textline=['unit; depth; x; shaft; Vpp; troughpeaktime; halfwidth; slope; baselinerate'];  %header for text file
dlmwrite([unitclassdir 'unitproperties.txt'],textline,'-append','delimiter','','newline','pc')

unitproperties=[];
unitproperties.experiment=experiment;
unitproperties.subject=subject;
unitproperties.datei=datei;
unitproperties.filename=filename;
unitproperties.dounits=dounits;

binnedtimes=0:1:recordingduration;
isiplottime=0:isibinsize:isirange;

isi=[]; binnedisi=[]; peakisi=[]; meanisi=[]; cvisi=[]; percentbursting=[]; percentpausing=[];
for unitind=1:length(dounits)
unit=dounits(unitind);

load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])

bestchan=bestchannels{unit};

bestwaves=waveforms{bestchan};    %waveforms from most prominent channel of this unit.
if size(bestwaves,1)>1
bestmean=mean(bestwaves);         %mean waveform.
else     
bestmean=bestwaves;                  
end

    if length(bestmean)==0   %fixes an occasional bug in which waveforms aren't stored for a unit.
        continue
    end

meanwave=interp(bestmean,waveupsamplingfact);  %upsample 100x.
troughamp=min(meanwave);
halfpeakwave=troughamp/2;
nearvalues=find(meanwave>(halfpeakwave-2) & meanwave<(halfpeakwave+2));
diffvalues=diff(nearvalues);
minvalue=find(meanwave==min(meanwave));
postvalues=meanwave(minvalue:length(meanwave));
prevalues=meanwave(1:minvalue);
postpeakamp=max(postvalues);
prepeakamp=max(prevalues);
troughind=find(meanwave==troughamp);
postpeakind=find(meanwave==postpeakamp);
prepeakind=find(meanwave==prepeakamp);

Vpp=round(range(meanwave));
troughpeaktime=round((postpeakind-troughind)/waveupsamplingfact/samplingrate*1e6)/1e3;    %trough to post-trough peak time, in milliseconds. 
peakpeaktime=round((postpeakind-prepeakind)/waveupsamplingfact/samplingrate*1e6)/1e3;    %pre-peak to post-trough peak time, in milliseconds. 

halfwidth=round(max(diffvalues)/waveupsamplingfact/samplingrate*1e6)/1000; %finds width at half the trough amplitude, in milliseconds        

V260usectimes=find(meanwave<0.255*troughamp & meanwave>0.265*troughamp);   %slope at time=0.26*trough amplitude. from Lansink & Pennartz EJN 2010.
V260usectimes=V260usectimes(find(V260usectimes>troughind));
V260usectime=round(mean(V260usectimes));
waveslope=(meanwave(V260usectime)-troughamp)/(V260usectime-troughind)*samplingrate/(-1*troughamp);   %units of inverse seconds (normalize by -troughamp)

% peakanisotropy=(postpeakamp-prepeakamp)/(postpeakamp+prepeakamp);
peakanisotropy=1-(prepeakamp-troughamp)/(postpeakamp-troughamp); 

if exist([stimulidir 'stimuli.mat'])& length(sol1times)>0
    meanrate=baselinerate{unit};
else
    binnedspikes=histc(spiketimes{unit},binnedtimes);
    meanrate=mean(binnedspikes);
end

isi=diff(spiketimes{unit});
% isi=isi(find(isi<=isirange));
binnedisi{unit}=100*histc(isi,isiplottime)/length(isi);   %percentage of ISI per uniter in each bin  
peakisi{unit}=mode(isi);
meanisi{unit}=mean(isi);
cvisi{unit}=std(isi)/mean(isi);
percentbursting{unit}=100*length(find(isi<max_burstisi))/length(isi);
percentpausing{unit}=100*length(find(isi>min_pauseisi))/length(isi);

unitproperties.bestchan{unit}=bestchan;
unitproperties.shaft{unit}=s.shaft(bestchan);
unitproperties.Vpp{unit}=Vpp;
unitproperties.troughpeaktime{unit}=troughpeaktime;
unitproperties.peakpeaktime{unit}=peakpeaktime;
unitproperties.halfwidth{unit}=halfwidth;
unitproperties.waveslope{unit}=waveslope;
unitproperties.peakanisotropy{unit}=peakanisotropy;
unitproperties.baselinerate{unit}=meanrate;

textline=[num2str(unit) '; ' num2str(positions.unitz{unit}) '; ' num2str(positions.unitx{unit}) '; ' num2str(s.shaft(bestchan)) '; ' num2str(Vpp) '; ' num2str(troughpeaktime) '; ' num2str(halfwidth) '; ' num2str(waveslope) '; ' num2str(unitproperties.baselinerate{unit})];

dlmwrite([unitclassdir 'unitproperties.txt'],textline,'-append','delimiter','','newline','pc')

end

unitproperties.isiplottime=isiplottime;
unitproperties.binnedisi=binnedisi;
unitproperties.percentbursting=percentbursting;
unitproperties.percentpausing=percentpausing;
unitproperties.peakisi=peakisi;
unitproperties.meanisi=meanisi;
unitproperties.cvisi=cvisi;

unitproperties.unitclassnames=[];
unitproperties.unitclassnumbers=[];
save([unitclassdir 'unitproperties.mat'], 'unitproperties', '-MAT')


trpktime=cell2mat(unitproperties.troughpeaktime);
pptime=cell2mat(unitproperties.peakpeaktime);
blrate=cell2mat(unitproperties.baselinerate);
anisot=cell2mat(unitproperties.peakanisotropy);
slope=cell2mat(unitproperties.waveslope);
hwtime=cell2mat(unitproperties.halfwidth);
percentbursting=cell2mat(unitproperties.percentbursting);
halfwidth=cell2mat(unitproperties.halfwidth);

figind=1;
figure(figind)
hold off
subplot(2,4,1)
plot(pptime,log10(blrate),'o','MarkerFaceColor','b')
grid on
axis square
xlabel('peak to peak time (ms)')
ylabel('log10 of baseline firing rate')

subplot(2,4,2)
plot(trpktime,log10(blrate),'o','MarkerFaceColor','b')
grid on
axis square
xlabel('trough to peak time (ms)')
ylabel('log10 of baseline firing rate')

subplot(2,4,3)
plot(anisot,log10(blrate),'o','MarkerFaceColor','b')
grid on
axis square
xlabel('peak anisotropy')
ylabel('log10 of baseline firing rate')

subplot(2,4,4)
plot(slope,pptime,'o','MarkerFaceColor','b')
grid on
axis square
xlabel('wave slope')
ylabel('peak to peak time (ms)')


figure(figind)
hold off
for i=1:length(dounits)
    unit=dounits(i);
    
    subplot(2,4,5)
    text(pptime(i),log10(blrate(i)),num2str(unit),'FontSize', 7)
    axis([0 max(pptime)+0.1 min(log10(blrate))-0.5 max(log10(blrate))+0.5])
    axis square
    xlabel('peak to peak time (ms)')
    ylabel('log10 of baseline firing rate')
    hold on
    
    subplot(2,4,6)
    text(trpktime(i),log10(blrate(i)),num2str(unit), 'FontSize', 7)
    axis([min(trpktime)-1 max(trpktime)+1 min(log10(blrate))-0.5 max(log10(blrate))+0.5])
    axis square
    xlabel('trough to peak time (ms)')
    ylabel('log10 of baseline firing rate')
    hold on
    
    subplot(2,4,7)
    text(anisot(i),log10(blrate(i)),num2str(unit), 'FontSize', 7)
    axis([min(anisot)-0.1 max(anisot)+0.1 min(log10(blrate))-0.5 max(log10(blrate))+0.5])
    axis square
    xlabel('peak anisotropy')
    ylabel('log10 of baseline firing rate')
    hold on
    
    subplot(2,4,8)
    text(slope(i),pptime(i),num2str(unit), 'FontSize', 7)
    axis([min(slope)-1 max(slope)+1 0 max(pptime)+0.1])
    axis square
    xlabel('wave slope')
    ylabel('peak to peak time (ms)')
    hold on
   
end
 

scrsz=get(0,'ScreenSize');
set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.7*scrsz(3) 0.8*scrsz(4)])   

saveas(figure(figind),[unitclassdir 'unitprops.jpg' ]  ,'jpg')
% saveas(figure(figind),[unitclassdir 'unitprops.eps' ]  ,'psc2')
% saveas(figure(figind),[unitclassdir 'unitprops.fig' ]  ,'fig')

% figure(2)
% plot3(trpktime,log10(blrate),slope,'o','MarkerFaceColor','b')
% axis square
% xlabel('peak to peak time (ms)')
% ylabel('log10 of baseline firing rate')
% zlabel('wave slope')
% 

doclassif=[];
doclassif=input('do (m)anual, (a)utomatic, or (n)o unit classification [n]? ', 's');
if isempty(doclassif)
          doclassif='n';
end

close 1

if doclassif=='m'
    do_manualunitclass   %note: the subroutine classify_unitj contains important parameters about unit classification.
elseif doclassif=='a'
    do_autounitclass
end

