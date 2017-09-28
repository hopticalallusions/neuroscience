
load('~/Desktop/goodplace_struct.mat');
load('~/Desktop/map_data_HH.mat');
map_data_hh=map_data;
load('~/Desktop/map_data_SS.mat');
map_data_ss=map_data;
clear map_data


stats.septum.ID=[];
stats.septum.spatialbitsperspike=[];
stats.septum.peakInFieldRate=[];
stats.septum.phasePrecessionRate=[];
stats.septum.allID=[];
stats.septum.allspatialbitsperspike=[];
stats.septum.allpeakInFieldRate=[];
stats.septum.allphasePrecessionRate=[];


multiday=false;
daysAveraged=1;
mapIdx=0;
cellIdx=0;
for ii=1:length(sepcells)
    if hipcells(ii) < 0
        if multiday
            daysAveraged=daysAveraged+1;
        else
            cellIdx=cellIdx+1;
        end
        multiday = true;
    else
        multiday = false;
        daysAveraged=1;
        cellIdx=cellIdx+1;
    end
    goodPlaceIdx=map_data_ss((abs(sepcells(ii)))).vals(1);
    stats.septum.ID(cellIdx)=goodplace_struct(goodPlaceIdx).cid;
    if multiday && daysAveraged > 1
        stats.septum.spatialbitsperspike(cellIdx)=(stats.septum.spatialbitsperspike(cellIdx)*daysAveraged+map_data_ss((abs(sepcells(ii)))).vals(2))/(daysAveraged+1);
        stats.septum.peakInFieldRate(cellIdx)=(stats.septum.peakInFieldRate(cellIdx)*daysAveraged+map_data_ss((abs(sepcells(ii)))).vals(3))/(daysAveraged+1);
        stats.septum.phasePrecessionRate(cellIdx)=(stats.septum.phasePrecessionRate(cellIdx)*daysAveraged+map_data_ss((abs(sepcells(ii)))).vals(4))/(daysAveraged+1);
    else
        stats.septum.spatialbitsperspike(cellIdx)=map_data_ss((abs(sepcells(ii)))).vals(2);
        stats.septum.peakInFieldRate(cellIdx)=map_data_ss((abs(sepcells(ii)))).vals(3);
        stats.septum.phasePrecessionRate(cellIdx)=map_data_ss((abs(sepcells(ii)))).vals(4);
    end
    stats.septum.allID(ii)=goodplace_struct(goodPlaceIdx).cid;
    stats.septum.allspatialbitsperspike(ii)=map_data_ss((abs(sepcells(ii)))).vals(2);
    stats.septum.allpeakInFieldRate(ii)=map_data_ss((abs(sepcells(ii)))).vals(3);
    stats.septum.allphasePrecessionRate(ii)=map_data_ss((abs(sepcells(ii)))).vals(4);
end
sepCellN=cellIdx;
% 
% figure;scatter(stats.septum.spatialbitsperspike,stats.septum.spatialbitsperspike+rand(1,cellIdx)/(25*(max(stats.septum.spatialbitsperspike)-min(stats.septum.spatialbitsperspike))))
% legend('spatiaBitRate');
% figure;scatter(stats.septum.peakInFieldRate,stats.septum.peakInFieldRate+rand(1,cellIdx)*(.3*(max(stats.septum.spatialbitsperspike)-min(stats.septum.spatialbitsperspike))))
% legend('peakInFieldRate');
% figure;scatter(stats.septum.phasePrecessionRate,stats.septum.phasePrecessionRate+rand(1,cellIdx)*(.3*(max(stats.septum.spatialbitsperspike)-min(stats.septum.spatialbitsperspike))))
% legend('phasePrecessionRate');



% 
% figure;hist(stats.septum.spatialbitsperspike,6)
% legend('spatiaBitRate');
% figure;hist(stats.septum.peakInFieldRate,6)
% legend('peakInFieldRate');
% figure;hist(stats.septum.phasePrecessionRate,6)
% legend('phasePrecessionRate');





hipcells(22)=abs(hipcells(22));
hipcells(23)=abs(hipcells(23));

stats.hipp.ID=[];
stats.hipp.spatialbitsperspike=[];
stats.hipp.peakInFieldRate=[];
stats.hipp.phasePrecessionRate=[];

stats.hipp.allID=[];
stats.hipp.allspatialbitsperspike=[];
stats.hipp.allpeakInFieldRate=[];
stats.hipp.allphasePrecessionRate=[];

multiday=false;
daysAveraged=1;
mapIdx=0;
cellIdx=0;
for ii=1:length(hipcells)
    %cellIdx=ii;
    if hipcells(ii) < 0
        if multiday
            daysAveraged=daysAveraged+1;
        else
            cellIdx=cellIdx+1;
        end
        multiday = true;
    else
        multiday = false;
        daysAveraged=1;
        cellIdx=cellIdx+1;
    end
    goodPlaceIdx=map_data_hh((abs(hipcells(ii)))).vals(1);
    stats.hipp.ID(cellIdx)=goodplace_struct(goodPlaceIdx).cid;
    if multiday && daysAveraged > 1
        stats.hipp.spatialbitsperspike(cellIdx)=(stats.hipp.spatialbitsperspike(cellIdx)*daysAveraged+map_data_hh((abs(hipcells(ii)))).vals(2))/(daysAveraged+1);
        stats.hipp.peakInFieldRate(cellIdx)=(stats.hipp.peakInFieldRate(cellIdx)*daysAveraged+map_data_hh((abs(hipcells(ii)))).vals(3))/(daysAveraged+1);
        stats.hipp.phasePrecessionRate(cellIdx)=(stats.hipp.phasePrecessionRate(cellIdx)*daysAveraged+map_data_hh((abs(hipcells(ii)))).vals(4))/(daysAveraged+1);
    else
        stats.hipp.spatialbitsperspike(cellIdx)=map_data_hh((abs(hipcells(ii)))).vals(2);
        stats.hipp.peakInFieldRate(cellIdx)=map_data_hh((abs(hipcells(ii)))).vals(3);
        stats.hipp.phasePrecessionRate(cellIdx)=map_data_hh((abs(hipcells(ii)))).vals(4);
    end
    stats.hipp.allID(ii)=goodplace_struct(goodPlaceIdx).cid;
    stats.hipp.allspatialbitsperspike(ii)=map_data_hh((abs(hipcells(ii)))).vals(2);
    stats.hipp.allpeakInFieldRate(ii)=map_data_hh((abs(hipcells(ii)))).vals(3);
    stats.hipp.allphasePrecessionRate(ii)=map_data_hh((abs(hipcells(ii)))).vals(4);
end
hippCellN=cellIdx;
% 
% figure;scatter(stats.hipp.spatialbitsperspike,stats.hipp.spatialbitsperspike+rand(1,cellIdx)/(25*(max(stats.hipp.spatialbitsperspike)-min(stats.hipp.spatialbitsperspike))))
% legend('spatiaBitRate');
% figure;scatter(stats.hipp.peakInFieldRate,stats.hipp.peakInFieldRate+rand(1,cellIdx)*(.3*(max(stats.hipp.spatialbitsperspike)-min(stats.hipp.spatialbitsperspike))))
% legend('peakInFieldRate');
% figure;scatter(stats.hipp.phasePrecessionRate,stats.hipp.phasePrecessionRate+rand(1,cellIdx)*(.3*(max(stats.hipp.spatialbitsperspike)-min(stats.hipp.spatialbitsperspike))))
% legend('phasePrecessionRate');



% 
% figure;hist(stats.hipp.spatialbitsperspike);
% legend('spatiaBitRate');
% figure;hist(stats.hipp.peakInFieldRate);
% legend('peakInFieldRate');
% figure;hist(stats.hipp.phasePrecessionRate);
% legend('phasePrecessionRate');




figure;
scatter(1+rand(1,sepCellN)/3,stats.septum.spatialbitsperspike)
hold on;
scatter(2+rand(1,hippCellN)/3,stats.hipp.spatialbitsperspike)
legend('spatialBitRate');

figure;
scatter(1+rand(1,sepCellN)/3,stats.septum.peakInFieldRate)
hold on;
scatter(2+rand(1,hippCellN)/3,stats.hipp.peakInFieldRate)
legend('peakInFieldRate');

figure;
scatter(1+rand(1,sepCellN)/3,stats.septum.phasePrecessionRate)
hold on;
scatter(2+rand(1,hippCellN)/3,stats.hipp.phasePrecessionRate)
legend('phasePrecessionRate');
