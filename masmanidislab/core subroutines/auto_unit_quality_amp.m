set_plot_parameters

load([timesdir 'finalspiketimes.mat'])
load([savedir 'final_params.mat']);  %loads parameters file.
load([finalwavedir 'bestchannel.mat'])

unitquality=[];

%Added 2012/11/15, keep track of number of each
oneCount = 0;
twoCount = 0;
threeCount = 0;
    
for unit=1:length(spiketimes);
    timesuniti=spiketimes{unit};
    
    if length(timesuniti)<final_minspikesperunit
        disp(['unit ' num2str(unit) ' has < ' num2str(final_minspikesperunit) ' spikes; assigning score of 3.'])
        unitquality=[unitquality, 3];  
        continue
    end
         
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    
    bestchan=bestchannel{unit};
    
    if length(bestchan)==0
        disp(['unit ' num2str(unit) ' has no bestchannel; skipping this unit.'])
        unitquality=[unitquality, 3];   
        threeCount=threeCount+1;
        continue
    end
      
    wavesinbestchan=waveforms{bestchan};
    Vminuniti=abs(min(mean(wavesinbestchan)));
     
    if Vminuniti<minVtrough
        disp(['unit ' num2str(unit) ' has Vmin < ' num2str(minVtrough) ' uV; assigning score of 3.'])
        unitquality=[unitquality, 3];
        threeCount=threeCount+1;
        continue
    end
    
    
    unitquality=[unitquality, 2];
    twoCount=twoCount+1;
    
end

disp(['*****Summary*****']);
disp(['Number of 1s: ', num2str(length(find(unitquality==1))) ' (default is zero for auto-scoring.)']);
disp(['Number of 2s: ', num2str(length(find(unitquality==2)))]);
disp(['Number of 3s: ', num2str(length(find(unitquality==3)))]);
disp(['*****************']);

if(runAutoUnitQuality=='s')
    disp('Running Manual Portion of Semi-Automatic Unit Quality');
    disp(['1=high-quality unit;  2=medium-quality unit;  3=low-quality non-single unit.'])
    nColsUnitQuality = length(unitquality);
    reCheckIndicies=[];
    for current=1:nColsUnitQuality
        if unitquality(current) == 2
            reCheckIndicies = [reCheckIndicies, current];
        end
    end
    nColsRecheckIndicies = length(reCheckIndicies);
    for current=1:nColsRecheckIndicies
        unit=reCheckIndicies(current);
       
        summaryplotunit=imread([savedir 'units\unit' num2str(unit) '.jpg']);
        imshow(summaryplotunit)
         
        figure(1)

        qual=[];
        qual=input(['Specify quality of unit ' num2str(unit) ': '],'s'); 
        figure(1)
            while isempty(qual)==1
                qual=input(['You did not specify quality of unit ' num2str(unit) ': '],'s');
            end
        unitquality(unit) = str2num(qual);

    end
    
disp(['*****Summary*****']);
disp(['Number of 1s: ', num2str(length(find(unitquality==1)))]);
disp(['Number of 2s: ', num2str(length(find(unitquality==2)))]);
disp(['Number of 3s: ', num2str(length(find(unitquality==3)))]);
disp(['*****************']);
   
end

save([savedir 'unitquality.mat'],'unitquality','-mat')

disp(['done assigning unit quality to ' filename '.'])
% close 1
