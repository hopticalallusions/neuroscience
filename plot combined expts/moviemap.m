function [vent_ex,dors_ex] = moviemap(input,big_x,big_z,region,colorbins,rand_xpos,frame,moviedir,combinedir,colors,frametime,excite_threshold)
actual_slice_height =6.0;
% drawnimg = imread([analysisdrivename ':\data analysis\' experiment '\' subject '\' datei '\' filename '\' generic map template.jpg']);
drawnimg = imread([combinedir 'generic map template.jpg']);
conv_factor = actual_slice_height/size(drawnimg,1);
ventral_x_correction_factor = 0.25;
dorsal_x_correction_factor = 0.7;
z_correction_factor = 0.4;
%**************************************************************************

close all
image(drawnimg)
axis equal
colormap(gray);
hold on

vent_ex = zeros(1,size(input,1));
dors_ex = zeros(1,size(input,1));
for i = 1:size(input,1)
    depth = big_z(i);
    xpos = big_x(i);
    value = input(i,1);
    act_color = min(find(colorbins >= value));
    if isempty(strfind(region{i},'NA'))==0 | isempty(strfind(region{i},'OT'))==0
    plot((size(drawnimg,2) - ventral_x_correction_factor/conv_factor - (abs(xpos/conv_factor)+rand_xpos(i))),(abs(depth)/conv_factor - z_correction_factor/conv_factor),'o','MarkerSize',5.5,'MarkerEdgeColor','k','MarkerFaceColor',colors(act_color,:))
        if value >= excite_threshold
        vent_ex(i) = 1;
        end
    elseif isempty(strfind(region{i},'D'))==0
    plot((size(drawnimg,2) - dorsal_x_correction_factor/conv_factor - (abs(xpos/conv_factor)+rand_xpos(i))),(abs(depth)/conv_factor - z_correction_factor/conv_factor),'o','MarkerSize',5.5,'MarkerEdgeColor','k','MarkerFaceColor',colors(act_color,:))
        if value >= excite_threshold
        dors_ex(i) = 1;
        end
    end
    hold on
end
set(figure(1),'Position',get(0,'ScreenSize'))
title(['Time: ' num2str(frametime)])

saveas(figure(1),[moviedir 'frame ' num2str(frame) '.jpg'],'jpg')
end
