if strcmp(zscore_or_norm,'zscore')
    stacks_e1=multi_zstack_e1;
    stacks_e2=multi_zstack_e2;
elseif strcmp(zscore_or_norm,'norm')
    stacks_e1=multistack_event1;
    stacks_e2=multistack_event2;
end

if length(minDV)==0
    minDV=min(unit_DV);
    disp('sot')
end
if length(maxDV)==0
    maxDV=max(unit_DV);
end
rangeDV=maxDV-minDV;
zoneDVs=[minDV:(rangeDV/plotDVzones):maxDV];  %min DV of each plot zone.

if length(minML)==0
    minML=min(unit_ML);
end
if length(maxML)==0
    maxML=max(unit_ML);
end
rangeML=maxML-minML;
zoneMLs=[minML:(rangeML/plotMLzones):maxML];  %min ML of each plot zone.


figind=figind+1;
figure(figind)

zoneplots2d=[];
for zoneDVind=1:plotDVzones
    minDVi=zoneDVs(zoneDVind);
    maxDVi=zoneDVs(zoneDVind+1);
    
    for zoneMLind=1:plotMLzones
        minMLi=zoneMLs(zoneMLind);
        maxMLi=zoneMLs(zoneMLind+1);

        if zoneMLind==plotMLzones & zoneDVind<plotDVzones
        cellsinzone=find(unit_ML>=minMLi & unit_DV>=minDVi & unit_DV<maxDVi);  %index of cells in the current ML-DV zone.
        elseif zoneMLind<plotMLzones & zoneDVind==plotDVzones
        cellsinzone=find(unit_ML>=minMLi & unit_ML<maxMLi & unit_DV>=minDVi);  %index of cells in the current ML-DV zone.
        elseif zoneMLind==plotMLzones & zoneDVind==plotDVzones
        cellsinzone=find(unit_ML>=minMLi & unit_DV>=minDVi);  %index of cells in the current ML-DV zone.
        else
        cellsinzone=find(unit_ML>=minMLi & unit_ML<maxMLi & unit_DV>=minDVi & unit_DV<maxDVi);  %index of cells in the current ML-DV zone.
        end
             
        if length(cellsinzone)<1
            continue
        end
       
        zoneplots2d.cellsinzone{zoneDVind}{zoneMLind}=length(cellsinzone);        
        zoneplots2d.rate_e1{zoneDVind}{zoneMLind}=stacks_e1(cellsinzone,:);
        zoneplots2d.rate_e2{zoneDVind}{zoneMLind}=stacks_e2(cellsinzone,:);        
        zoneplots2d.meanrate_e1{zoneDVind}{zoneMLind}=mean(zoneplots2d.rate_e1{zoneDVind}{zoneMLind});
        zoneplots2d.semrate_e1{zoneDVind}{zoneMLind}=std(zoneplots2d.rate_e1{zoneDVind}{zoneMLind})/sqrt(length(cellsinzone));
        zoneplots2d.meanrate_e2{zoneDVind}{zoneMLind}=mean(zoneplots2d.rate_e2{zoneDVind}{zoneMLind});
        zoneplots2d.semrate_e2{zoneDVind}{zoneMLind}=std(zoneplots2d.rate_e2{zoneDVind}{zoneMLind})/sqrt(length(cellsinzone));

        xoffset=(posteventtime+preeventtime+1)*(zoneMLind-1);
        newtime=timebins(1:(length(timebins)-1))+xoffset;
        yoffset=ydiv*(zoneDVind-1);
        hold on
        boundedline(newtime,zoneplots2d.meanrate_e2{zoneDVind}{zoneMLind}+yoffset, zoneplots2d.semrate_e1{zoneDVind}{zoneMLind}, set_CS2color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
        hold on
        boundedline(newtime,zoneplots2d.meanrate_e1{zoneDVind}{zoneMLind}+yoffset, zoneplots2d.semrate_e1{zoneDVind}{zoneMLind}, set_CS1color)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
        hold off
    end
end


axis([-preeventtime-1 plotMLzones*(posteventtime+preeventtime+1) min_ploty ydiv*plotDVzones])
set(gca,'XTick',[-1:xdiv2:posteventtime])
set(gca,'XTickLabel',[-preeventtime:xdiv2:posteventtime])
set(gca,'YTick',[0:1:ydiv])
xlabel(['medial <--> lateral'], 'FontSize', 8)
ylabel(['ventral <--> dorsal'] ,'FontSize', 8)
title([zscore_or_norm ' firing vs time, ' num2str(totalmodunits) ' ' plotlabel ', n=' num2str(length(subjects)) ' subjects.'], 'FontSize', 8)
set(gcf,'Position',[scrsz(1)+1150 0.6*scrsz(2)+100 0.4*scrsz(3) 0.75*scrsz(4)])   
set(gca,'FontSize',8,'TickDir','out')
