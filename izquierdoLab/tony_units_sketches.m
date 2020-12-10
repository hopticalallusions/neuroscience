
nsFile = openNSx('~/data/sampleData/blackrockSamples/spikesLFPs/array_Sc2.ns6');

nsFile = openNSx('?~/data/sampleData/blackrockSamples/spikesLFPs/array_Sc2.ns6');
nsFile = openNSx('array_Sc2.ns6');

nsFile = openNSx('~/data/izquierdo/ty4/090920/datafile002.ns5');
% TODO
%
% this system seems to default to a weird number (155) for channels that
% are off. Maybe rather than doing it this way, use "unique" to determine
% how many unique values there are. If the number is small, maybe <10, then
% the channel is probably off.
%
activeChannels = (100*sum(nsFile.Data==155,2)./length(nsFile.Data))<1;
activeChannels(97:99)=0;
timestampSeconds = (1:length(nsFile.Data))./nsFile.MetaTags.SamplingFreq;

filters.so.spike    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  600, 'HalfPowerFrequency2', 6000, 'SampleRate', nsFile.MetaTags.SamplingFreq);


spikeLfp = filtfilt( filters.so.spike, double(nsFile.Data(1,:)) )./4; % the x/4 converts it to microvolts, which is safe because we cast it to double
[ spikePeakValues,  ...
  spikePeakTimes,   ... 
  spikePeakWidths,  ...
  spikePeakProminances ] = findpeaks( -spikeLfp,          ... % data
                                          30000,          ... % sampling frequency
                                'MinPeakHeight', 35,   ... % 100 mV
                              'MinPeakDistance', 0.0012  );    % 1.2 ms lockout
timestampSeconds = (1:length(nsFile.Data))./nsFile.MetaTags.SamplingFreq;
figure; plot(timestampSeconds, -spikeLfp); hold on; scatter(spikePeakTimes, spikePeakValues.*1.1,'v', 'filled')


spks = findSpikes(nsFile, 'channels', 1:3, 'duration', 1:10000, 'threshold', -65);



fid = fopen('~/data/izquierdo/ty4/090920/datafile002.ns5');
fileTypeID = fread(fid,[1,8],'*char')
fileSpec = fread(fid,[1,2],'*uchar')
fileHeaderBytes = fread(fid,4,'uint32')

fclose(fid)






/Users/andrewhowe/data/sampleData/blackrockSamples/spikesLFPs





filename = 'BC577_2013-10-15_DOI.nex';

filename = 'BC563_2013-11-26_WC.nex';

filename = 'BC607_2013-12-05_WC.nex'; % chs 4, 7
hdpath = '~/data/ana/doiData/nexfiles/';
nexFileData = readNexFile([hdpath filename]);
signal = nexFileData.contvars{4,1}.data;
figure; plot(signal);
ch4fh=figure;
[ ch4power, ch4global_ws, ch4global_signif, ch4period, ch4time, ch4sig95, ch4coi  ]=hdWavelet( nexFileData.contvars{4,1}.data, 1, ch4fh, 2 );
ch7fh=figure;
[ ch7power, ch7global_ws, ch7global_signif, ch7period, ch7time, ch7sig95, ch7coi  ]=hdWavelet( nexFileData.contvars{7,1}.data, 1, ch7fh, 2 );



colormap('parula')



