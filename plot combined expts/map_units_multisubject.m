actual_slice_height =6.0;
% drawnimg = imread([analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\' generic map template.jpg']);
drawnimg = imread([combinedir 'generic map template.jpg']);
conv_factor = actual_slice_height/size(drawnimg,1);
ventral_x_correction_factor = 0.25;
dorsal_x_correction_factor = 0.7;
z_correction_factor = 0.4;
mapdir = [combinedir 'Map figures/'];
mkdir(mapdir)
% annotate_brainregion
%**************************************************************************                                   
close all
image(drawnimg)
axis equal
colormap(gray);
hold on

big_z = [];
big_x = [];
region = [];
for groupind = 1:length(plotunits)
    for unitind = 1:length(plotunits{groupind})
        unitj = plotunits{groupind}(unitind);
        if isempty(alldepths{groupind}{unitj}) == 0 & isempty(strfind(allunitregions{groupind}{unitj},'out'))==1
        big_z = [big_z alldepths{groupind}{unitj}];
        big_x = [big_x allxpositions{groupind}{unitj}];
        region = [region {allunitregions{groupind}{unitj}}];
        end
    end
end
    
    
% plot((size(drawnimg,2)-x_correction_factor/conv_factor - (abs(positions.elecx)/conv_factor)),abs(positions.elecz)/conv_factor - z_correction_factor/conv_factor,'o','MarkerSize',2,'MarkerFaceColor',[0.8 0.8 0.8],'MarkerEdgeColor',[0.8 0.8 0.8]);

% text(.5/conv_factor, 3/conv_factor, AP_Str,'DLS')
% text(1.5/conv_factor, 3/conv_factor, AP_Str,'DMS')
% text(.6/conv_factor, 4.5/conv_factor, AP_Str, 'lateral NAc')
% text(1.9/conv_factor, 4.2/conv_factor, AP_Str, 'medial NAc')
% text(1/conv_factor, 5.7/conv_factor, AP_Str, 'OT/VP')

for i = 1:length(big_z)
    
    if isempty(strfind(region{i},'D')) == 0
    plot((size(drawnimg,2) - dorsal_x_correction_factor/conv_factor - (abs(big_x(i)/conv_factor)+(60*(rand-0.5)))),(abs(big_z(i))/conv_factor - z_correction_factor/conv_factor),'o','MarkerSize',5.5,'MarkerEdgeColor','k')
    elseif isempty(strfind(region{i},'NA')) == 0  | isempty(strfind(region{i},'OT')) == 0
    plot((size(drawnimg,2) - ventral_x_correction_factor/conv_factor - (abs(big_x(i)/conv_factor)+(60*(rand-0.5)))),(abs(big_z(i))/conv_factor - z_correction_factor/conv_factor),'o','MarkerSize',5.5,'MarkerEdgeColor','k')
    elseif isempty(strcmp(region{i},'outside')) == 0
        continue
    end
   
%     if isempty(intersect(unit,plot_units.one)) == 0
%        plot((size(drawnimg,2) - x_correction_factor/conv_factor - (abs(positions.unitx{unit})/conv_factor)+(60*(rand-0.5))),(abs(positions.unitz{unit})/conv_factor - z_correction_factor/conv_factor),'o','MarkerSize',5.5,'MarkerFaceColor','b','MarkerEdgeColor','k')
%     end
%     
%     if isempty(intersect(unit,plot_units.two)) == 0
%        plot((size(drawnimg,2) - x_correction_factor/conv_factor - (abs(positions.unitx{unit}/conv_factor))+(60*(rand-0.5))),(abs(positions.unitz{unit})/conv_factor - z_correction_factor/conv_factor),'o','MarkerSize',5.5,'MarkerFaceColor','r','MarkerEdgeColor','k')
%     end
        
   
end


% saveas(figure(1),[mapdir subject ' ' plot_criterion_1 '.jpg'],'jpg')
