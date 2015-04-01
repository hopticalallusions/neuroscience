if length(exist([savedir 'unitquality.mat'],'file'))>0
load([savedir 'unitquality.mat'])
dounits=[find(unitquality<=qualitycutoff)];     %unit qualities: 1, 2, 3. 1=best, 2=medium quality, 3=not single-unit.
else dounits=1:length(spiketimes);
end


%note: qualitycutoff is set in set_plot_parameters.