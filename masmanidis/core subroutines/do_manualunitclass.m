figind=2;
figure(2);
close 2
figure(2)
set(gcf,'Position',[0.7*scrsz(1)+200 0.5*scrsz(2)+400 0.7*scrsz(3) 0.5*scrsz(4)])

trpktime=cell2mat(unitproperties.troughpeaktime);
pptime=cell2mat(unitproperties.peakpeaktime);
blrate=cell2mat(unitproperties.baselinerate);
anisot=cell2mat(unitproperties.peakanisotropy);
slope=cell2mat(unitproperties.waveslope);
hwtime=cell2mat(unitproperties.halfwidth);
peakisi=cell2mat(unitproperties.peakisi);
meanisi=cell2mat(unitproperties.meanisi);
cvisi=cell2mat(unitproperties.cvisi);
percentbursting=cell2mat(unitproperties.percentbursting);
percentpausing=cell2mat(unitproperties.percentpausing);

unitclassnames=[]; unitclassnumbers=[];
for unitind=1:length(dounits);
    unitj=dounits(unitind);
    
hold off


subplot(1,5,[1 2])   
load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unitj) '.mat']) 
bestchan=bestchannels{unitj};   
wavesinbestchan=waveforms{bestchan};
maxtime=size(wavesinbestchan,2)/samplingrate-1/samplingrate;
plott=1000*(0:1/samplingrate:maxtime);
bestmean=mean(wavesinbestchan);         %mean waveform.
plot(plott, wavesinbestchan,'r')
hold on
plot(plott,bestmean,'k','LineWidth',2)
hold off   


subplot(1,5,3)
histisi=unitproperties.binnedisi{unitj};
histisi(1:2)=0;  %set the first two points to zero to find other peaks at larger ISI.
hold off
semilogx(isiplottime,histisi)
set(gca,'FontSize',10,'TickDir','out')
peakisitime=unitproperties.peakisi{unitj};
meanisitime=unitproperties.meanisi{unitj};
cv=unitproperties.cvisi{unitj}; %coefficient of variation.
pctbursts=unitproperties.percentbursting{unitj};
pctpauses=unitproperties.percentpausing{unitj};
xlabel('ISI (s)')
ylabel('% spikes')
% title(['mode: ' num2str(round(1000*peakisitime)) ' ms; mean: ' num2str(round(1000*meanisitime)) ' ms; CV=' num2str(cv) '; % bursting: ' num2str(pctbursts)])
title(['% bursting: ' num2str(pctbursts) '; % pausing: ' num2str(pctpauses) '; CV_I_S_I: ' num2str(cv)])
axis([0 max(isiplottime) 0 1.05*max(histisi)])


% subplot(1,5,4)
% plot(anisot,log10(blrate),'o','MarkerFaceColor','b')
% hold on
% plot(unitproperties.peakanisotropy{unitj},log10(unitproperties.baselinerate{unitj}),'o','MarkerFaceColor','r', 'MarkerEdgeColor','r')
% grid on
% axis square
% xlabel('peak anisotropy')
% ylabel('log10 rate')
% title(['Unit ' num2str(unitj) ', Rate: ' num2str(round(unitproperties.baselinerate{unitj}*100)/100) ' Hz'])
% hold off
% 

% subplot(1,5,4)
% plot(trpktime,log10(blrate),'o','MarkerFaceColor','b')
% hold on
% plot(unitproperties.troughpeaktime{unitj},log10(unitproperties.baselinerate{unitj}), 'o','MarkerFaceColor','r', 'MarkerEdgeColor','r')
% grid on
% axis square
% xlabel('trough-peak time (ms)')
% ylabel('log10 rate')
% title(['t_t_p: ' num2str(unitproperties.troughpeaktime{unitj}) ' ms; slope: ' num2str(round(unitproperties.waveslope{unitj}))])
% hold off


subplot(1,5,[4 5])
plot3(trpktime,log10(blrate),anisot,'o','MarkerFaceColor','b')
hold on
plot3(unitproperties.troughpeaktime{unitj},log10(unitproperties.baselinerate{unitj}),unitproperties.peakanisotropy{unitj},'o','MarkerFaceColor','r', 'MarkerEdgeColor','r')
grid on
axis square
xlabel('trough-peak time (ms)')
ylabel('log10 rate')
zlabel('peak anisotropy')
title(['Unit ' num2str(unitj) ', Rate: ' num2str(round(unitproperties.baselinerate{unitj}*100)/100) ' Hz; Anisotropy: ' num2str(unitproperties.peakanisotropy{unitj})])
% title(['Anisotropy: ' num2str(unitproperties.peakanisotropy{unitj})])
hold off



figure(2)
classify_unitj

unitclassj=[];
unitclassj=input(['enter ID for unit # ' num2str(unitj) ', (1)=' celltype1 ', (2)=' celltype2 ',(3)=' celltype3 ', (0)=' celltype0 ', [recommended value is ' num2str(unitIDnumber) ']: '], 's');
if isempty(unitclassj)
          unitclassj=unitIDnumber;
end

if isstr(unitclassj)==1
    unitclassj=str2num(unitclassj);
end

unitclassnumbers=[unitclassnumbers unitclassj];
% disp([num2str(unitclassj)])

if length(strmatch(num2str(unitclassj), '1'))==1
    unitnamej=celltype1;
elseif length(strmatch(num2str(unitclassj), '2'))==1
    unitnamej=celltype2;
elseif length(strmatch(num2str(unitclassj), '3'))==1
    unitnamej=celltype3;
elseif length(strmatch(num2str(unitclassj), '0'))==1
    unitnamej=celltype0;
end

unitclassnames{unitj}=unitnamej;

end

unitproperties.unitclassnames=unitclassnames;
unitproperties.unitclassnumbers=unitclassnumbers;
save([unitclassdir 'unitproperties.mat'], 'unitproperties', '-MAT')

close 2
disp(['done classifying units, added IDs to unitproperties.'])
