%latency_map
%*************************************************************************
if load_combined_data == 'y' 
   combine_subject_data %This will run through each subject and aggregate all unit activity for use in subsequent analysis
                     %It will also trigger spiking activity on trigger
                     %events and calculate discrimination within query
                     %periods defined in do_multisub_analysis
else
   disp(['Data for ' num2str(length(subjects)) ' mice has already been loaded for ' triggerevent1 ' and ' triggerevent2 '.'])
end
%*************************************************************************
all_stats = [];

for subjectind = 1:length(subjects);
    for unitind = 1:length(plotunits{subjectind})
        unitj = plotunits{subjectind}(unitind);
        
        all_stats = [all_stats; subjectind unitj alldepths{subjectind}{unitj} allxpositions{subjectind}{unitj} allunitshafts{subjectind}{unitj} allunitclassi{subjectind}(unitind) allunitlatencies{subjectind}{unitj}]; 
    end
end

disp(['Mapping ' triggerevent1 ' vs ' triggerevent2 ' preferences. Query period: ' num2str(query_start) ' - ' num2str(query_end) '.'])
actual_slice_height =7.0;
drawnimg = imread([combinedir 'generic map template 2.jpg']);
conv_factor = actual_slice_height/size(drawnimg,1);
x_correction_factor = 0;
z_correction_factor = -0.7;

if strcmp(plotunitclass,'all') == 1 
mapdir = [combinedir 'Map figures all\'];
else mapdir = [combinedir 'Map figures ' unitclassnames{dounits(1)} '\'];
end
if isdir(mapdir)==0
mkdir(mapdir)
end

colors = colormap(jet);

close all
figure(1)
image(drawnimg)
axis equal
colormap(gray);
hold on

shapes =  [{'d'} {'^'} {'o'} {'s'}];
latency_bins = [-1 0 1 2 2.5 3.5 8.0];
color_bins = floor(1:64/length(latency_bins):64);
color_bins(end) = length(colors);
for statind = 1:size(all_stats,1)
    shape = shapes{all_stats(statind,6)+1};
    what_bin = hist(all_stats(statind,7),latency_bins);
    what_color = colors(color_bins(what_bin == 1),:);
   
    plot((size(drawnimg,2) - x_correction_factor/conv_factor - (abs(all_stats(statind,4)/conv_factor)+(150*(rand-0.5)))),(abs(all_stats(statind,3))/conv_factor - z_correction_factor/conv_factor),shape,'MarkerSize',5,'MarkerEdgeColor',what_color,'MarkerFaceColor',what_color)
    hold on
end

set(figure(1),'Position',get(0,'ScreenSize'))
set(gca,'XTick',[],'YTick',[])
if strcmp(plotunitclass,'all')==1
   title([plotunitclass ' units plotted by latency to peak normalized firing, sigmod = ' onlysigmod],'FontSize',15);
else
   title(['all ' unit_classnames{1}{1} 's plotted by latency to peak normalized firing, sigmod = ' onlysigmod],'FontSize',15);
end

disp(['saving map as ' mapdir triggerevent1 ' vs ' triggerevent2])
saveas(figure(1),[mapdir triggerevent1 ' vs ' triggerevent2 ' latency map.jpg'],'jpg')
saveas(figure(1),[mapdir triggerevent1 ' vs ' triggerevent2 ' latency map.fig'],'fig')
saveas(figure(1),[mapdir triggerevent1 ' vs ' triggerevent2 ' latency map.eps'],'psc2')

figure(2)
colormap(jet)
colorbar
set(colorbar,'YTick',color_bins,'YTickLabel',latency_bins)
saveas(figure(2),[mapdir 'color bar ' triggerevent1 ' vs ' triggerevent2 ' latency colorbar.jpg'],'jpg')
saveas(figure(2),[mapdir 'color bar ' triggerevent1 ' vs ' triggerevent2 ' latency colorbar.eps'],'psc2')

