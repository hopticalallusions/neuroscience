MSNrate=[]; FSIrate=[]; TANrate=[]; unclassrate=[];
MSNwidth=[]; FSIwidth=[]; TANwidth=[]; unclasswidth=[];
MSNCVisi=[]; FSICVisi=[]; TANCVisi=[]; unclassCVisi=[];
totalunits=0;

selectedpaths=uipickfiles('FilterSpec','C:\data analysis\');  %prompts to pick subjects.

get_subject_dir

analysisdrivename=subjects{1}(1);
combinedir = [analysisdrivename ':\data analysis\figures\'];
if isdir(combinedir) == 0
   mkdir(combinedir)
end


for subjectind = 1:length(subjects)
    rawpath = [subjects{subjectind} '\'];
    savedir = [rawpath 'single-unit\'];
    unitclassdir = [savedir 'properties\'];

    load([unitclassdir 'unitproperties.mat'])   

    dounits=unitproperties.dounits;

    totalunits=totalunits+length(dounits);

    for unitind=1:length(dounits)
        uniti=dounits(unitind);
        celltype=unitproperties.unitclassnames{uniti};
    
        if strmatch(celltype,'MSN')
            MSNrate=[MSNrate unitproperties.baselinerate{uniti}];
            MSNwidth=[MSNwidth unitproperties.troughpeaktime{uniti}];
            MSNCVisi=[MSNCVisi unitproperties.cvisi{uniti}];
        elseif strmatch(celltype,'FSI')
            FSIrate=[FSIrate unitproperties.baselinerate{uniti}];
            FSIwidth=[FSIwidth unitproperties.troughpeaktime{uniti}];
            FSICVisi=[FSICVisi unitproperties.cvisi{uniti}];
        elseif strmatch(celltype,'TAN')
            TANrate=[TANrate unitproperties.baselinerate{uniti}];
            TANwidth=[TANwidth unitproperties.troughpeaktime{uniti}];
            TANCVisi=[TANCVisi unitproperties.cvisi{uniti}];
        else 
            unclassrate=[unclassrate unitproperties.baselinerate{uniti}];
            unclasswidth=[unclasswidth unitproperties.troughpeaktime{uniti}];
            unclassCVisi=[unclassCVisi unitproperties.cvisi{uniti}];
        end
    end
end

disp(['total # of units = ' num2str(totalunits) ' from n = ' num2str(length(subjects)) ' subjects.'])
disp(['MSNs: ' num2str(100*length(MSNrate)/totalunits) '%, rate = ' num2str(mean(MSNrate)) '+/-' num2str(std(MSNrate)) ' Hz.'])
disp(['FSIs: ' num2str(100*length(FSIrate)/totalunits) '%, rate = ' num2str(mean(FSIrate)) '+/-' num2str(std(FSIrate)) ' Hz.'])
disp(['TANs: ' num2str(100*length(TANrate)/totalunits) '%, rate = ' num2str(mean(TANrate)) '+/-' num2str(std(TANrate)) ' Hz.'])
disp(['unclassified: ' num2str(100*length(unclassrate)/totalunits) '%, rate = ' num2str(mean(unclassrate)) '+/-' num2str(std(unclassrate)) ' Hz.'])



figure(1)
close 1
figure(1)
hold off
plot(MSNwidth, log10(MSNrate),'^','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','none')
hold on
plot(FSIwidth, log10(FSIrate),'o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','none')
plot(TANwidth, log10(TANrate),'s','MarkerSize',3,'MarkerFaceColor','g','MarkerEdgeColor','none')
plot(unclasswidth, log10(unclassrate),'o','MarkerSize',3,'MarkerFaceColor','none','MarkerEdgeColor','k')
set(gca,'FontSize',8,'TickDir','out')
xlabel(['t trough-peak (ms)'],'FontSize',8)
ylabel(['log10(rate)'],'FontSize',8)
title(['total # of units = ' num2str(totalunits) ' from n = ' num2str(length(subjects)) ' subjects.'],'FontSize',8)
axis([0 1.4 -2.1 2.1])
axis square

