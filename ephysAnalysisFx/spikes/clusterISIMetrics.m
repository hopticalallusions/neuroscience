function clusterISIMetrics( cellId, cellNumber, spiketimes, elapsedTime )

cellIsis=diff(spiketimes(cellNumber==cellId))/1e3;
disp([' min ISI '      num2str( min(cellIsis) ) ' ms '])
disp([' median ISI '   num2str( round(median(cellIsis)) ) ' ms '])
disp([' mean ISI '     num2str( round(mean(cellIsis)) ) ' ms '])
disp([' max ISI '      num2str( round(max(cellIsis)/1e3) ) ' s '])
disp([' madam ISI '    num2str( median(abs(cellIsis-median(cellIsis))) ) ' ms '])
disp([' std ISI '      num2str( round(std(cellIsis)) ) ' ms '])
disp([' skew ISI '     num2str( round(skewness(cellIsis)) ) ' ms '])
disp([' kurtosis ISI ' num2str( round(kurtosis(cellIsis)) ) ' ms '])
disp('');
disp([' mean firing rate = ' num2str( sum(cellNumber==cellId)/((xytimestamps(end)-xytimestamps(1) )/1e6) ) ' Hz' ])



% TODO
% could add things like scatter plots of various metrics, histograms of
% metrics, 

figure; histogram( cellIsis, 100 ); title(['cell ' num2str(cellId) ' ISIs' ]); xlabel('ISI (ms)'); ylabel('frequency');

% TODO plot cross correlation & Confidence Intervals (?)
