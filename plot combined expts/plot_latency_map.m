
%***Modify to only use units that are significantly excite by the
%appropriate event.

figind=figind+1;
figure(figind)


colors = colormap(jet);
% shapes =  [{'d'} {'^'} {'o'} {'s'}];
shape='o';
latency_bins = [0:0.5:posteventtime];
color_bins = floor(1:64/length(latency_bins):64);
color_bins(end) = length(colors);
for unitind=1:length(event1_peaklatency)
%     shape = shapes{all_stats(statind,6)+1};
    what_bin=hist(event1_peaklatency(unitind),latency_bins);
    what_color=colors(color_bins(what_bin == 1),:);
  
    MLoffset=randi([-20 20], 1)/100;
    plot(mapunits_ML(unitind)+MLoffset,mapunits_DV(unitind), shape,'MarkerSize',5,'MarkerEdgeColor',what_color,'MarkerFaceColor',what_color)
    hold on
end

axis equal
colormap(jet)
colorbar
set(colorbar,'YTick',color_bins,'YTickLabel',latency_bins)
