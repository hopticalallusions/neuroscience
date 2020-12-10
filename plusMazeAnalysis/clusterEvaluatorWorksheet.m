% 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT9a.NTT'  
% 'TT10a.NTT' 'TT11a.NTT'  'TT12a.NTT' 'TT13a.NTT'  'TT14a.NTT'  'TT15a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT18a.NTT' 'TT19a.NTT' 
% 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT23a.NTT' 'TT24a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 
% 'TT30a.NTT' 'TT31a.NTT'  'TT32a.NTT'

dir='/Volumes/Seagate Expansion Drive/h5/2018-05-02_training4_bananas/';
ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT' 'TT8precut.NTT' 'TT10precut.NTT' 'TT12precut.NTT' 'TT13precut.NTT' 'TT14precut.NTT' 'TT15precut.NTT' 'TT16precut.NTT' 'TT20precut.NTT' 'TT26precut.NTT' 'TT27precut.NTT' 'TT29precut.NTT' 'TT32precut.NTT' };
dateStr='2018-05-02';


dir='/Volumes/Seagate Expansion Drive/h5/2018-05-01_training3_bananas/';
ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT'  'TT21precut.NTT' };
dateStr='2018-05-01';
 
 
dir='/Volumes/Seagate Expansion Drive/h5/2018-05-07_training6_bananas/';
ttFilenames={ 'TT4precut.NTT' 'TT5precut.NTT' 'TT6precut.NTT'  'TT8precut.NTT'   'TT13precut.NTT' 'TT14precut.NTT' 'TT15precut.NTT' 'TT17precut.NTT' 'TT19precut.NTT'  'TT20precut.NTT' 'TT21precut.NTT' 'TT24precut.NTT' 'TT25precut.NTT' };
dateStr='2018-05-07';

 
dir='/Volumes/Seagate Expansion Drive/h5/2018-05-08_training7_bananas/';
ttFilenames={ 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT'  'TT12a.NTT' 'TT13a.NTT'   'TT5_recut.NTT' 'TT6_recut.NTT' 'TT8_recut.NTT'  'TT12_recut.NTT'   'TT13_recut.NTT' 'TT14_recut.NTT' 'TT15_recut.NTT' 'TT16_recut.NTT' 'TT17_recut.NTT' 'TT19_recut.NTT'  'TT20_recut.NTT' 'TT21_recut.NTT' 'TT27_recut.NTT'  };
dateStr='2018-05-08';


dir='/Volumes/AHOWETHESIS/h5/2018-05-09_training8_bananas/';
ttFilenames={ 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT'  'TT12a.NTT' 'TT13a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT20a.NTT' 'TT21a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT31a.NTT' };
dateStr='2018-05-09';
ratName = 'h5';



%%%%%%%%%%%%
%%%%%%%%%%%%         H1       %%%%%%%
%%%%%%%%%%%%

% 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT9a.NTT'  
% 'TT10a.NTT' 'TT11a.NTT'  'TT12a.NTT' 'TT13a.NTT'  'TT14a.NTT'  'TT15a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT18a.NTT' 'TT19a.NTT' 
% 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT23a.NTT' 'TT24a.NTT'




dir='/Volumes/AHOWETHESIS/h1/2018-09-08_17-11-31/';
ttFilenames={ 'TT1a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT13a.NTT' 'TT15a.NTT' 'TT17a.NTT' 'TT21a.NTT' 'TT22a.NTT'  };
dateStr='2018-09-08';
ratName = 'h1';
clusterEvaluator( dir, ttFilenames, dateStr, ratName ) 





dir='/Volumes/AHOWETHESIS/h1/2018-09-08_17-11-31/';
ttFilenames={ 'TT1a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT13a.NTT' 'TT15a.NTT' 'TT17a.NTT' 'TT21a.NTT' 'TT22a.NTT'  };
dateStr='2018-09-08';
ratName = 'h1';
clusterEvaluator( dir, ttFilenames, dateStr, ratName ) 





% 'TT1a.NTT' 'TT2a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT7a.NTT' 'TT8a.NTT' 'TT9a.NTT'  
% 'TT10a.NTT' 'TT11a.NTT'  'TT12a.NTT' 'TT13a.NTT'  'TT14a.NTT'  'TT15a.NTT' 'TT16a.NTT' 'TT17a.NTT' 'TT18a.NTT' 'TT19a.NTT' 
% 'TT20a.NTT' 'TT21a.NTT' 'TT22a.NTT' 'TT23a.NTT' 'TT24a.NTT' 'TT25a.NTT' 'TT26a.NTT' 'TT27a.NTT' 'TT28a.NTT' 'TT29a.NTT' 
% 'TT30a.NTT' 'TT31a.NTT'  'TT32a.NTT'




ttFilenames={ 'TT1a.NTT' 'TT3a.NTT' 'TT4a.NTT' 'TT5a.NTT' 'TT6a.NTT' 'TT8a.NTT' 'TT9a.NTT' 'TT10a.NTT' 'TT13a.NTT' 'TT15a.NTT' 'TT17a.NTT' 'TT21a.NTT' 'TT22a.NTT'  };
dateStr='2018-09-08';
clusterEvaluator( path, ttFilenames, dateStr, ratName ) 



ratName = 'h5';
path='/Volumes/AHOWETHESIS/h5/2018-06-15_training20_bananas/';
dateStr='2018-06-15';
clusterEvaluator( path, { 'TT6a.NTT' }, dateStr, ratName ) 





ratName = 'h7';
path='/Volumes/AHOWETHESIS/h7/2018-08-06_14-51-31/';
dateStr='2018-08-06';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-07_14-16-23/';
dateStr='2018-08-07';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-08_13-26-07/';
dateStr='2018-08-13';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-09_14-08-56/';
dateStr='2018-08-09';
clusterEvaluator( path, {}, dateStr, ratName ) 

ratName = 'h7';
path='/Volumes/AHOWETHESIS/h7/2018-08-10_14-44-53/';
dateStr='2018-08-10';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-13_17-25-37/';
dateStr='2018-08-13';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-14_15-15-39/';
dateStr='2018-08-14';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-15_14-43-49/';
dateStr='2018-08-15';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-22_12-28-01/';
dateStr='2018-08-22';
clusterEvaluator( path, {}, dateStr, ratName ) 

ratName = 'h7';
path='/Volumes/AHOWETHESIS/h7/2018-08-27_15-28-03/';
dateStr='2018-08-27';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-28_14-05-30/';
dateStr='2018-08-28';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-08-31_16-54-02/';
dateStr='2018-08-31';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-09-04_18-27-56/';
dateStr='2018-09-04';
clusterEvaluator( path, {}, dateStr, ratName ) 
path='/Volumes/AHOWETHESIS/h7/2018-09-05_17-04-14/';
dateStr='2018-09-05';
clusterEvaluator( path, {}, dateStr, ratName ) 