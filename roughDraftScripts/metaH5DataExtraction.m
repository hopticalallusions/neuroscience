% h5MetaScript to extract data

% lfp68 -- good for theta
% lfp

% we might want to change these for each day, but for now, it's just the
% non-hippocampal LFPs
input.fileListGoodLfp = { 'CSC0.ncs' 'CSC4.ncs' 'CSC8.ncs' 'CSC12.ncs' 'CSC16.ncs' 'CSC20.ncs' 'CSC28.ncs' 'CSC32.ncs' 'CSC96.ncs' 'CSC100.ncs' 'CSC104.ncs' 'CSC108.ncs' 'CSC113.ncs' 'CSC116.ncs' 'CSC121.ncs' 'CSC124.ncs'  };
% this list of CSCs are in the hippocampus
% 'CSC44.ncs'  'CSC48.ncs' 'CSC52.ncs' 'CSC56.ncs' 'CSC60.ncs' 'CSC64.ncs' 'CSC68.ncs' 'CSC72.ncs' 'CSC76.ncs' 'CSC80.ncs' 'CSC92.ncs' 
input.rat = 'h5';


% NOTE : PARAMETERS WILL FAIL FOR DAYS BEFORE MAY 1 AND MAY 2
tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-04-25_orientation1/';
input.ttFilenames={  'TT5_recut.NTT' 'TT6recut.NTT'  'TT14_recut.NTT' 'TT22_recut.NTT' };
input.dateStr='2018-04-25';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate = [214, 232; 231, 343 ]; input.bucketRadius = [ 34  34 ];
input.rotationAmount = 45; input.center = [ 331 200 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

% orientation 2 is inside a raw file. will require significant work to use.
% input.dir='/Volumes/Seagate Expansion Drive/h5/2018-04-26_orientation2/';
% input.fileListGoodLfp = { '' };
% input.ttFilenames={  'TT5_recut.NTT' 'TT6recut.NTT'  'TT14_recut.NTT' 'TT22_recut.NTT' };
% input.dateStr='2018-04-26';
% input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
% input.bucketCoordinate = [214, 232; 231, 343 ]; input.bucketRadius = [ 34  34 ];
%input.rotationAmount = 45;  input.center = [ 331 200 ]; 

% not yet cluster cut
% input.dir='/Volumes/Seagate Expansion Drive/h5/2018-04-27_training1';
% input.ttFilenames={  };
% input.dateStr='2018-04-27';
% input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
% input.bucketCoordinate = [214, 232; 231, 343 ]; input.bucketRadius = [ 34  34 ];
% input.rotationAmount = 45;  input.center = [ 331 200 ]; 
tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-04-30_training2/';
input.ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT'  'TT10precut.NTT'  'TT14precut.NTT'  'TT20precut.NTT' };
input.dateStr='2018-04-30';
input.startCoordinate = [76 316]; input.startRadius = 50;%  {130,280}  start area  {radius}
input.bucketCoordinate = [216, 382; 231, 381; 194, 277; 214, 277; 234, 277 ]; input.bucketRadius = [ 34  22 34 34 22 ];
input.rotationAmount = 45; input.center = [ 296 220 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc


tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-01_training3_bananas/';
input.ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT'  'TT21precut.NTT' };
input.dateStr='2018-05-01';
input.startCoordinate = [ 83 308 ]; input.startRadius = 50;%  {130,280}  start area  {radius}
input.bucketCoordinate = [ 200, 364; 220, 267; 196, 263; 208, 263; 226, 260 ]; input.bucketRadius = [ 30  30 25 25 25  ];
input.rotationAmount = 45+180; input.center = [ 421 236 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc


%redo
tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-02_training4_bananas/';
input.ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT' 'TT8precut.NTT' 'TT10precut.NTT' 'TT12precut.NTT' 'TT13precut.NTT' 'TT14precut.NTT' 'TT15precut.NTT' 'TT16precut.NTT' 'TT20precut.NTT' 'TT26precut.NTT' 'TT27precut.NTT' 'TT29precut.NTT' 'TT32precut.NTT' };
input.dateStr='2018-05-02';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate = [225, 386; 241, 386; 206, 262; 229, 260 ]; input.bucketRadius = [ 50 50 30 30 ]; 
input.rotationAmount = 45+180; input.center = [ 421 236 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

tic;
% this day has some weird telemetry thing going on
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-07_training6_bananas/';
input.ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT'  'TT8precut.NTT'   'TT13precut.NTT' 'TT14precut.NTT' 'TT15precut.NTT' 'TT17precut.NTT' 'TT19precut.NTT'  'TT20precut.NTT' 'TT21precut.NTT' 'TT24precut.NTT' 'TT25precut.NTT' };
input.dateStr='2018-05-07';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate = [213, 377; 230, 385 ]; input.bucketRadius = [ 36  36 ];
input.rotationAmount = 45+180; input.center = [ 421 236 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-08_training7_bananas/';
% alternate versions of the clusters  'TT5_recut.NTT' 'TT6_recut.NTT' 'TT8_recut.NTT'  'TT12_recut.NTT'   'TT13_recut.NTT' 
input.ttFilenames={ 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT'  'TT12a.NTT' 'TT13a.NTT'   'TT14_recut.NTT' 'TT15_recut.NTT' 'TT16_recut.NTT' 'TT17_recut.NTT' 'TT19_recut.NTT'  'TT20_recut.NTT' 'TT21_recut.NTT' 'TT27_recut.NTT'  };  
input.dateStr='2018-05-08';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 214,246 ; 238, 217; 283, 147; 153, 212 ]; input.bucketRadius = [ 32 32  20 20 ];
input.rotationAmount = 45+180; input.center = [ 421 236 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-09_training8_bananas/';
input.ttFilenames={ 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT'  'TT12a.NTT' 'TT13a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT31a.NTT' };
input.dateStr='2018-05-09';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 228,195 ; 252, 177 ]; input.bucketRadius = [ 31  43 ];
input.rotationAmount = 45+180; input.center = [ 421 236 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

% 2018-05-10_training9_bananas is missing from this analysis because it was
% recorded in RAW mode. the probe positions from that day are the same as
% the probe positions from the subsequent day, 2018-05-11.

tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-11_training10_bananas/';
input.ttFilenames={ 'TT1a.NTT' 'TT2a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT19a.NTT' 'TT21a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT31a.NTT' };
input.dateStr='2018-05-11';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 226,429 ; 252, 444; 281, 480 ]; input.bucketRadius = [ 40 40 40 ];
input.rotationAmount = 45+180;  input.center = [ 416 249 ];
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc



tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-14_training11_bananas/';
input.ttFilenames={ 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT14a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 'TT30a.NTT' 'TT31a.NTT' 'TT32a.NTT' };
input.dateStr='2018-05-14';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 218, 195 ; 247, 173 ]; input.bucketRadius = [ 52  47 ];
input.rotationAmount = 45+180; input.center = [ 421 236 ]; 
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-15_training12_bananas/';
input.ttFilenames={ 'TT1a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT20a.NTT' 'TT30a.NTT'  };
input.dateStr='2018-05-15';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 224, 201 ; 248, 177; 202, 393; 228, 423; 266, 456; 292, 474; 314, 453 ]; input.bucketRadius = [ 51 51 45 42 40 42   25 ];
input.rotationAmount = 45+180;
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-16_training13_bananas/';
input.ttFilenames={ 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT10a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT24a.NTT' 'TT25a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 'TT31a.NTT' 'TT32a.NTT'  };
input.dateStr='2018-05-16';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 201, 250; 220, 226; 240, 207; 254, 197 ]; input.bucketRadius = [ 27 27 27 27 ];
input.rotationAmount = 45+180;
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc

tic;
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-05-18_training14_bananas/';
input.ttFilenames={ 'TT1a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT13a.NTT' 'TT14a.NTT' 'TT17a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT24a.NTT' 'TT25a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 'TT31a.NTT' 'TT32a.NTT'  };
input.dateStr='2018-05-18';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 220, 195; 246, 175 ]; input.bucketRadius = [ 50   47 ];
input.rotationAmount = 45+180;
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc





tic;
% we might want to change these for each day, but for now, it's just the
% non-hippocampal LFPs
input.fileListGoodLfp = { 'CSC0.ncs' 'CSC4.ncs' 'CSC8.ncs' 'CSC12.ncs' 'CSC16.ncs' 'CSC20.ncs' 'CSC28.ncs' 'CSC32.ncs' 'CSC96.ncs' 'CSC100.ncs' 'CSC104.ncs' 'CSC108.ncs' 'CSC113.ncs' 'CSC116.ncs' 'CSC121.ncs' 'CSC124.ncs'  };
% this list of CSCs are in the hippocampus
% 'CSC44.ncs'  'CSC48.ncs' 'CSC52.ncs' 'CSC56.ncs' 'CSC60.ncs' 'CSC64.ncs' 'CSC68.ncs' 'CSC72.ncs' 'CSC76.ncs' 'CSC80.ncs' 'CSC92.ncs' 
input.rat = 'h5';
input.dir='/Volumes/Seagate Expansion Drive/h5/2018-06-08_training15_bananas/';
input.ttFilenames={ 'TT1a.NTT' 'TT2a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT12a.NTT' 'TT13a.NTT' 'TT16a.NTT' 'TT25a_evenc0.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT'  };
input.dateStr='2018-06-08';
input.startCoordinate = [98 280]; input.startRadius = 32;%  {130,280}  start area  {radius}
input.bucketCoordinate =[ 220, 195; 246, 175 ]; input.bucketRadius = [ 50   47 ];
input.rotationAmount = 45+180;   input.center = [ 416 249 ];
output=h5DataExtraction(input);
save([ '~/data/cache/' input.rat '_' input.dateStr '_spikeData.dat'], 'output' );
toc





% 
% [ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ input.dir 'VT0.nvt']);
% xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
% figure; plot(xpos,ypos);
% [xrpos,yrpos]=rotateXYPositions(xpos,ypos,input.center(1),input.center(2),input.rotationAmount,360,320);
% figure; plot(xrpos,yrpos);
