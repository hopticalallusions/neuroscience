disp(['Determining probe, electrode, and unit coordinates in brain. Enter the best known coordinates for the probes'])

set_plot_parameters

load([savedir 'final_params.mat']);  %loads parameters file.

mkdir(unitclassdir); mkdir(stimephysjpgdir); mkdir(stimephysepsdir); mkdir(stimephysmfigdir);

qualitycutoff=1;
select_dounits

probetype=parameters.probetype;
get_probegeometry

bestchannels=parameters.bestchannels;
allshafts=parameters.shafts;
shafts=allshafts(dounits);  
uniqueshafts=unique(shafts);
numberofshafts=length(unique(shafts));

sameplane=[];
if length(uniqueshafts)>1    
sameplane=input('are all probe shafts in the same (c)oronal or (s)agittal plane? [n]: ', 's');
end

if isempty(sameplane)==1
    sameplane='n';
end

if length(s.channels(find(s.z==min(s.z))))==length(uniqueshafts)
samedepth='y';
else samedepth='n';
end


AP=[]; ML=[]; tipz=[]; elecx=[]; elecy=[]; elecz=[];
for shaftind=1:length(uniqueshafts);
    currentshaft=uniqueshafts(shaftind);
    channelsonshaft=s.channels(find(s.shaft==currentshaft));
    disp(['shaft # ' num2str(currentshaft) '.'])
    
    if length(strmatch(sameplane,'c'))==1 & shaftind==1
    AP{currentshaft}=str2num(input('--- specify AP coordinates for the probe (mm relative to bregma): ', 's'));
    elseif length(strmatch(sameplane,'c'))==1 & shaftind>1
    AP{currentshaft}=AP{uniqueshafts(1)};
    else AP{currentshaft}=str2num(input('--- specify AP coordinates for this shaft (mm relative to bregma): ', 's'));
    end
       
    if length(strmatch(sameplane,'s'))==1 & shaftind==1
    ML{currentshaft}=str2num(input('--- specify ML coordinates for the probe (left is -ve, right is +ve): ', 's'));
    elseif length(strmatch(sameplane,'s'))==1 & shaftind>1
    ML{currentshaft}=ML{uniqueshafts(1)};
    else ML{currentshaft}=str2num(input('--- specify ML coordinates for this shaft (left is -ve, right is +ve): ', 's'));
    end
        
    if shaftind==1
    tipz{currentshaft}=-1*abs(str2num(input('--- specify depth for the tip of this shaft (mm relative to bregma): ', 's')));    %number is always negative.
    elseif shaftind>1   
    shaftheightoffset=min(s.z(channelsonshaft))-min(s.z(s.channels(find(s.shaft==min(s.shaft)))));
    shaftheightoffset=shaftheightoffset/1000; %convert to mm
    tipz{currentshaft}=tipz{min(s.shaft)}+shaftheightoffset;      
    end
    
    elecx(channelsonshaft)=s.x(channelsonshaft)/1000-mean(s.x(channelsonshaft))/1000+ML{currentshaft};   %Cartesian coordinates of each recording site relative to bregma, in mm.  Note: x is along ML, y is along AP.
    elecy(channelsonshaft)=AP{currentshaft};
    elecz(channelsonshaft)=tipz{currentshaft}+round(100*(s.z(channelsonshaft)-min(s.z(channelsonshaft))+tipelectrode))/100/1000;
    
end

unitx=[]; unity=[]; unitz=[]; %position of units in x-y-z space relative to bregma.

for unitind=1:length(dounits);
    unit=dounits(unitind);
 
    if length(bestchannels{unit})>0
    unitx{unit}=elecx(bestchannels{unit});
    unity{unit}=elecy(bestchannels{unit});
    unitz{unit}=elecz(bestchannels{unit});
    end
         
end

positions=[];
positions.info=['shaft coordinates, electrode coordinates, unit coordinates relative to bregma'];
positions.AP=AP;
positions.ML=ML;
positions.z=tipz;
positions.elecx=elecx;
positions.elecy=elecy;
positions.elecz=elecz;
positions.unitx=unitx;
positions.unity=unity;
positions.unitz=unitz;

save([unitclassdir 'positions' '.mat'], 'positions', '-mat')



figure(1)
close 1
figure(1)
hold off
plot3(elecx,elecy, elecz,'.k','MarkerSize',2)        %plots small markers over electrodes (optional).
hold on

for unitind=1:length(dounits);
    unit=dounits(unitind);
   
    plot3(unitx{unit}+0.02*randn(1), unity{unit}, unitz{unit},'o','MarkerSize', 4, 'MarkerFaceColor', 'r','MarkerEdgeColor', 'k')

end
axis([min(elecx)-0.2 max(elecx)+0.2 min(elecy)-0.2 max(elecy)+0.2 min(elecz)-0.2 max(elecz)+0.2])
set(gca,'FontSize',8)
xlabel(['ML axis (mm)'],'FontSize',8) 
ylabel(['AP axis (mm)'],'FontSize',8)
zlabel(['z axis (mm)'],'FontSize',8)
title(['Unit coordinates relative to bregma'],'FontSize',8)
scrsz=get(0,'ScreenSize');
set(gcf,'Position',[0.6*scrsz(1)+40 0.6*scrsz(2)+100 0.6*scrsz(3) 0.8*scrsz(4)])
axis equal

saveas(figure(1),[unitclassdir 'unitlocations' '.jpg' ]  ,'jpg')
saveas(figure(1),[unitclassdir 'unitlocations' '.eps' ]  ,'psc2')
saveas(figure(1),[unitclassdir 'unitlocations' '.fig' ]  ,'fig')

hold off

%http://api.brain-map.org/doc/index.html  link to page on plotting Allen brain atlas data with Matlab


