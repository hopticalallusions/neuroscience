set_plot_parameters

disp(['manually determine single-unit quality.'])
disp(['1=high-quality unit;  2=medium-quality unit;  3=low-quality non-single unit.'])

load([timesdir 'finalspiketimes.mat'])
load([savedir 'final_params.mat']);  %loads parameters file.
load([finalwavedir 'bestchannel.mat'])

scrsz=get(0,'ScreenSize');

unitquality=[];

figure(1)
close 1
figure(1)
set(gcf,'Position',[0.5*scrsz(1)+400 0.5*scrsz(2)+400 0.5*scrsz(3) 0.5*scrsz(4)])
for unit=1:length(spiketimes);
    timesuniti=spiketimes{unit};
    
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    
    bestchan=bestchannel{unit};
    
    if length(bestchan)==0
    disp(['unit ' num2str(unit) ' has no bestchannel; skipping this unit.'])
    unitquality=[unitquality, 3];   
    continue
    end
    
    lengthperchan=size(waveforms{bestchan},2);
   
    wavesinbestchan=waveforms{bestchan};
    maxtime=size(wavesinbestchan,2)/samplingrate-1/samplingrate;
    plott=1000*(0:1/samplingrate:maxtime);
    
    if length(wavesinbestchan)==0
        unitquality=[unitquality, 3];
        continue
    end
    
    summaryplotunit=imread([savedir 'units\unit' num2str(unit) '.jpg']);
    imshow(summaryplotunit)
    
    figure(1)
    qual=[];
    qual=input(['Specify quality of unit ' num2str(unit) ' [3]: '],'s'); 
    figure(1)
    while isempty(qual)==1
        qual=input(['You did not specify quality of unit ' num2str(unit) '[3]: '],'s');
        
    end
    
    unitquality=[unitquality, str2num(qual)];

end

disp(['*****Summary*****']);
disp(['Number of 1s: ', num2str(length(find(unitquality==1)))]);
disp(['Number of 2s: ', num2str(length(find(unitquality==2)))]);
disp(['Number of 3s: ', num2str(length(find(unitquality==3)))]);
disp(['*****************']);

save([savedir 'unitquality.mat'],'unitquality','-mat')

disp(['done manually assigning unit quality to ' filename '.'])
close 1
