clear all; 
close all;

 %39 is disconnected

metadata.rat = 'da12';  
metadata.baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
metadata.visualizeAll = true;
metadata.fileListGoodLfp = { 'rawChannel_32.dat' 'rawChannel_36.dat' 'rawChannel_40.dat' 'rawChannel_44.dat' 'rawChannel_48.dat' 'rawChannel_52.dat' 'rawChannel_56.dat' 'rawChannel_60.dat' };
metadata.fileListDisconnectedLfp={ };
metadata.swrLfpFile = 'rawChannel_52.dat';  % maybe 52**, 56* or 60 also
metadata.lfpStartIdx = 1;   % round(61.09316*32000);
metadata.outputDir = '/Users/andrewhowe/data/plusMazeEphys/';
metadata.sampleRate.lfp=32000;
metadata.sampleRate.telemetry=29.97;
metadata.autobins = true;
metadata.chewRemovalEnabled = false;



metadata.day = '2017-10-27_training1';
metadata.chewRemovalEnabled = true;
metadata.autobins = false;
metadata.touchdownTimes = [ 284 600 798 1098 1292 1526      1796 1880 2041 2241];
metadata.brickTimes =     [ 335 638 841 1141 1306 1570 1838 1898 2075 2276 ];
metadata.sugarTimes =     [ 380 668 900 1160 1358 1602 1907 2089 2303 ];
metadata.liftoffTimes =   [ 396 682 905 1167 1376 1622 1935 2111 2318 ];
outp=analyzeSWRdaTwelve(metadata);

