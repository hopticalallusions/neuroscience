%%
%this is where we make the figures for the grant

% figure; hold on;
% plot( lfptime, thetalfp, 'color', [ .6 .6 .6 ]); 
% plot( lfptime, thetaLfpCorr, 'color', [ .3 .5 .9 ] );
% plot( lfptime, thetaBandLfp, 'color', [ .8 .4 .2 ] );
% legend( 'csc15', 'LFP', '\Theta'); ylabel('\muV');


clear all; close all;

% demo
[thetalfp, lfptimestamps, header]=csc2mat('~/blairLab/nrsa2016/cscData/brief/CSC15.ncs');
lfptime=(lfptimestamps-lfptimestamps(1))/1e6;
tmpIdx = strfind(header, 'ADBitVolts'); ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
thetalfp=thetalfp*ADBitVolts;
figure;
twindow=[50 53];
idxWindow=50*32000+1:53*32000;
subplot( 4,1,1 ); hold on;
plot( lfptime(idxWindow), thetalfp(idxWindow), 'color', [ .6 .6 .6 ]); 
ylabel('\muV'); xlabel('time (s)');
%xlim( twindow); 
mxy=2e-3; ylim([-1.5e-3 1e-3]);
% theta
[ thetaLfpCorr ] = -cscCorrection( thetalfp, lfptimestamps );
thetaFilter = designfilt('bandpassiir', 'StopbandFrequency1', 3, 'PassbandFrequency1', 4, ...
                 'PassbandFrequency2', 12, 'StopbandFrequency2', 13, 'StopbandAttenuation1', 30, ...
                    'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
thetaBandLfp = filtfilt( thetaFilter, thetaLfpCorr );
twindow=[50 53];
idxWindow=50*32000+1:53*32000;
figure;
subplot( 4,1,1 ); hold on;
plot( lfptime(idxWindow), thetalfp(idxWindow), 'color', [ .6 .6 .6 ]); 
plot( lfptime(idxWindow), thetaLfpCorr(idxWindow), 'color', [ .3 .5 .9 ] );
plot( lfptime(idxWindow), thetaBandLfp(idxWindow), 'color', [ .8 .4 .2 ] );
legend( 'csc15', 'LFP', '\Theta'); ylabel('\muV'); 
%xlim( twindow); 
mxy=6e-4; ylim([-mxy mxy]);
subplot( 4,1,2 );
plot( lfptime(idxWindow), thetalfp(idxWindow), 'color', [ .6 .6 .6 ]); 
legend( 'csc28'); ylabel('\muV'); 
%xlim( twindow); 
mxy=6e-4; ylim([-mxy mxy]);
subplot( 4,1,3 );
plot( lfptime(idxWindow), thetaLfpCorr(idxWindow), 'color', [ .3 .5 .9 ] );
legend( 'LFP'); ylabel('\muV'); 
%xlim( twindow); 
mxy=6e-4; ylim([-mxy mxy]);
subplot( 4,1,4 );
plot( lfptime(idxWindow), thetaBandLfp(idxWindow), 'color', [ .8 .4 .2 ] );
legend( '\Theta'); ylabel('\muV'); 
%xlim( twindow); 
mxy=50e-5; ylim([-mxy mxy]);
 xlabel('time (s)');

%units
[unitslfpa, lfptimestamps, header]=csc2mat('~/blairLab/nrsa2016/cscData/brief/CSC4.ncs');
tmpIdx = strfind(header, 'ADBitVolts'); ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
unitslfpa=unitslfpa*ADBitVolts;
[ unitsACorr ] = -cscCorrection( unitslfpa, lfptimestamps );
spikeFilter = designfilt('bandpassiir', 'StopbandFrequency1', 400, 'PassbandFrequency1', 600, ...
                 'PassbandFrequency2', 5000, 'StopbandFrequency2', 6000, ...
                 'StopbandAttenuation1', 30, 'PassbandRipple', 1, ...
                 'StopbandAttenuation2', 30, 'SampleRate', 32000);
unitsBandLfpa = filtfilt( spikeFilter, unitsACorr );
twindow=[165.5 166.5];
idxWindow=twindow(1)*32000+1:twindow(2)*32000;
figure;
subplot( 4,1,1 ); hold on;
plot( lfptime(idxWindow), unitslfpa(idxWindow), 'color', [ .6 .6 .6 ]); 
plot( lfptime(idxWindow), unitsACorr(idxWindow), 'color', [ .3 .5 .9 ] );
plot( lfptime(idxWindow), unitsBandLfpa(idxWindow), 'color', [ .8 .4 .2 ] );
legend( 'csc28', 'LFP', 'units'); ylabel('\muV'); 
%xlim( twindow); 
mxy=2.5e-4; ylim([-mxy mxy]);
subplot( 4,1,2 );
plot( lfptime(idxWindow), unitslfpa(idxWindow), 'color', [ .6 .6 .6 ]); 
legend( 'csc28'); ylabel('\muV'); 
%xlim( twindow); 
mxy=2.5e-4; ylim([-mxy mxy]);
subplot( 4,1,3 );
plot( lfptime(idxWindow), unitsACorr(idxWindow), 'color', [ .3 .5 .9 ] );
legend( 'LFP'); ylabel('\muV'); 
%xlim( twindow); 
mxy=2.5e-4; ylim([-mxy mxy]);
subplot( 4,1,4 );
plot( lfptime(idxWindow), unitsBandLfpa(idxWindow), 'color', [ .8 .4 .2 ] );
legend( 'units'); ylabel('\muV'); 
%xlim( twindow); 
mxy=10e-5; ylim([-mxy mxy]);
 xlabel('time (s)');
 
 
 
twindow=[165.882 165.9];
twindow=[165.98 165.998];
twindow=[166.034 166.054];
twindow=[166.186 166.206];
idxWindow=twindow(1)*32000+1:twindow(2)*32000;
subplot( 4,1,4 );
plot( lfptime(idxWindow), unitsBandLfpa(idxWindow), 'color', [ .8 .4 .2 ] );
mxy=10e-5; ylim([-mxy mxy]);


 
% 
% [unitslfpb, lfptimestamps, header]=csc2mat('~/Desktop/nrsa2016/cscData/brief/CSC17.ncs');
% tmpIdx = strfind(header, 'ADBitVolts'); ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
% unitslfpb=unitslfpb*ADBitVolts;
% [ unitsBCorr ] = cscCorrection( unitslfpb, lfptimestamps );
% 
% [unitslfpc, lfptimestamps, header]=csc2mat('~/Desktop/nrsa2016/cscData/brief/CSC18.ncs');
% tmpIdx = strfind(header, 'ADBitVolts'); ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
% unitslfpc=unitslfpc*ADBitVolts;
% [ unitsCCorr ] = cscCorrection( unitslfpc, lfptimestamps );
% 
% [unitslfpd, lfptimestamps, header]=csc2mat('~/Desktop/nrsa2016/cscData/brief/CSC19.ncs');
% tmpIdx = strfind(header, 'ADBitVolts'); ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
% unitslfpd=unitslfpd*ADBitVolts;
% [ unitsDCorr ] = cscCorrection( unitslfpd, lfptimestamps );

%SWR
[swrlfp, lfptimestamps, header]=csc2mat('~/blairLab/nrsa2016/cscData/brief/CSC28.ncs');
tmpIdx = strfind(header, 'ADBitVolts'); ADBitVolts = sscanf(header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
swrlfp=swrlfp*ADBitVolts;
[ swrCorr ] = -cscCorrection( swrlfp, lfptimestamps );
[A,B,C,D] = butter(4,[125 250]/32000);
swrFilter = designfilt('bandpassiir','FilterOrder',8,'HalfPowerFrequency1',125,...
    'HalfPowerFrequency2',250,'SampleRate',32000);
swrBandLfp = filtfilt( swrFilter, swrCorr );
%subplot( 4,1,3 ); 
figure;
twindow=[ 115 116 ];
idxWindow=twindow(1)*32000+1:twindow(2)*32000;
subplot( 4,1,1 ); hold on;
plot( lfptime(idxWindow), swrlfp(idxWindow), 'color', [ .6 .6 .6 ]); 
plot( lfptime(idxWindow), swrCorr(idxWindow), 'color', [ .3 .5 .9 ] );
plot( lfptime(idxWindow), swrBandLfp(idxWindow), 'color', [ .8 .4 .2 ] );
%xlim([115 116]); 
mxy=.5e-3; ylim([-mxy mxy]);
legend('csc28', 'LFP', 'SWR'); ylabel('\muV'); 
subplot( 4,1,2 );
plot( lfptime(idxWindow), swrlfp(idxWindow), 'color', [ .6 .6 .6 ]); 
legend('csc28'); ylabel('\muV'); 
%xlim([115 116]); 
mxy=5e-4; ylim([-mxy mxy]);
subplot( 4,1,3 );
plot( lfptime(idxWindow), swrCorr(idxWindow), 'color', [ .3 .5 .9 ] );
legend('LFP'); ylabel('\muV'); 
%xlim([115 116]); 
mxy=5e-4; ylim([-mxy mxy]);
subplot( 4,1,4 );
plot( lfptime(idxWindow), swrBandLfp(idxWindow), 'color', [ .8 .4 .2 ] );
legend('SWR'); ylabel('\muV'); 
%xlim([115 116]); 
mxy=5e-5; ylim([-mxy mxy]);
 xlabel('time (s)');
 
return;
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( unitslfpa, lfptimestamps );
figure; plot(meanCscWindow)


%%
% this is where we make a book of figures

figure;
%
[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('~/Desktop/CSC4.ncs');
tins=[  11.1 20.94 26.56 33.12 58.13 124.38 136 166.5 ];
tmpIdx = strfind(fheader, 'ADBitVolts');
ADBitVolts = sscanf(fheader(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( flfp, ffulltimestamps );
swrSignal=filtfilt(dButter,exampleSwrSignal);
lfptime=(ffulltimestamps-ffulltimestamps(1))/1e6;
%
subplot( 4,1,1 ); plot( lfptime, -flfp*ADBitVolts, 'color', [ .6 .6 .6 ]); legend('csc4'); ylabel('?V'); % xlim([32 35]);% ylim([-0.0005 0.0015]);
subplot( 4,1,2 ); plot( lfptime, correctedCsc*ADBitVolts, 'b' ); legend('LFP'); ylabel('?V'); % xlim([32 35]); %ylim([-0.00025 0.0005]);
subplot( 4,1,3 ); plot( lfptime, exampleSwrSignal*ADBitVolts ); legend('SWR'); ylabel('?V'); % xlim([32 35]);   %ylim([-3e-5 3e-5]);
subplot( 4,1,4 ); plot( xyTime, xpos); hold on;  plot(xyTime, ypos); legend('xpos','ypos'); ylabel('pxl'); % xlim([32 35]); ylim([300 600]);
%
for idx=1:length(tins)
	subplot( 4,1,1 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,2 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,3 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,4 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	print( ['~/Desktop/csc4_t' num2str(tins(idx)) '.png'], '-dpng');
end
%	



%
[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('~/Desktop/CSC28.ncs');
tins =[  33.3  34   58  115.6250  120  124.3750  140.1562  169.0625];
tmpIdx = strfind(fheader, 'ADBitVolts');
ADBitVolts = sscanf(fheader(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( flfp, ffulltimestamps );
swrSignal=filtfilt(dButter,exampleSwrSignal);
lfptime=(ffulltimestamps-ffulltimestamps(1))/1e6;
%
subplot( 4,1,1 ); plot( lfptime, -flfp*ADBitVolts, 'color', [ .6 .6 .6 ]); legend('csc28'); ylabel('?V'); % xlim([32 35]);% ylim([-0.0005 0.0015]);
subplot( 4,1,2 ); plot( lfptime, correctedCsc*ADBitVolts, 'b' ); legend('LFP'); ylabel('?V'); % xlim([32 35]); %ylim([-0.00025 0.0005]);
subplot( 4,1,3 ); plot( lfptime, exampleSwrSignal*ADBitVolts ); legend('SWR'); ylabel('?V'); % xlim([32 35]);   %ylim([-3e-5 3e-5]);
subplot( 4,1,4 ); plot( xyTime, xpos); hold on;  plot(xyTime, ypos); legend('xpos','ypos'); ylabel('pxl'); % xlim([32 35]); ylim([300 600]);
%
for idx=1:length(tins)
	subplot( 4,1,1 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,2 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,3 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,4 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	print( ['~/Desktop/csc28_t' num2str(tins(idx)) '.png'], '-dpng');
end
%


%
[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('~/Desktop/CSC24.ncs');
tins=[  33.8 58.9 90 91.7 107.5 117.28 120 136.25 151.5 166.5 167 168.4 169.2 174.7 ];
tmpIdx = strfind(fheader, 'ADBitVolts');
ADBitVolts = sscanf(fheader(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( flfp, ffulltimestamps );
swrSignal=filtfilt(dButter,exampleSwrSignal);
lfptime=(ffulltimestamps-ffulltimestamps(1))/1e6;
%
subplot( 4,1,1 ); plot( lfptime, -flfp*ADBitVolts, 'color', [ .6 .6 .6 ]); legend('csc24'); ylabel('\muV'); % xlim([32 35]);% ylim([-0.0005 0.0015]);
subplot( 4,1,2 ); plot( lfptime, correctedCsc*ADBitVolts, 'b' ); legend('LFP'); ylabel('\muV'); % xlim([32 35]); %ylim([-0.00025 0.0005]);
subplot( 4,1,3 ); plot( lfptime, exampleSwrSignal*ADBitVolts ); legend('SWR'); ylabel('\muV'); % xlim([32 35]);   %ylim([-3e-5 3e-5]);
subplot( 4,1,4 ); plot( xyTime, xpos); hold on;  plot(xyTime, ypos); legend('xpos','ypos'); ylabel('pxl'); % xlim([32 35]); ylim([300 600]);
%
for idx=1:length(tins)
	subplot( 4,1,1 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,2 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,3 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	subplot( 4,1,4 ); xlim([tins(idx)-.5 tins(idx)+.5]);
	print( ['~/Desktop/csc24_t' num2str(tins(idx)) '.png'], '-dpng');
end
%	

return;







%%
% this is scratch pad space




%[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('/Volumes/SILVRSURFER/Brief_FSCV_unitonTT5_thetaonCSC15/CSC15.ncs');
% 4, 24, 28 might have sharp waves
% csc 15 reportedly has theta
% csc 16-19 might have a unit
%figure; plot(flfp(30*32000+1:33*32000));
[xpos, ypos, xyPositionTimestamps, angles, header ] = nvt2mat('/Volumes/SILVRSURFER/Brief_FSCV_unitonTT5_thetaonCSC15/VT0.nvt');
xpos=nlxPositionFixer(xpos);
ypos=nlxPositionFixer(ypos);
velocity=sqrt(cast(((diff(xpos)).^2+(diff(ypos)).^2), 'double'));
xyTime=(xyPositionTimestamps-xyPositionTimestamps(1))/1e6;

[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('/Volumes/SILVRSURFER/Brief_FSCV_unitonTT5_thetaonCSC15/CSC28.ncs');
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( flfp, ffulltimestamps );

Fs = 32000;  % Sampling Frequency
N   = 20;   % Order
Fc1 = 200;  % First Cutoff Frequency
Fc2 = 300;  % Second Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hdswr = design(h, 'butter');
exampleSwrSignal=filter(Hdswr, correctedCsc);

[A,B,C,D] = butter(4,[125 250]/32000);
dButter = designfilt('bandpassiir','FilterOrder',8, ...
    'HalfPowerFrequency1',125,'HalfPowerFrequency2',250, ...
    'SampleRate',32000);

[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('/Volumes/SILVRSURFER/Brief_FSCV_unitonTT5_thetaonCSC15/CSC4.ncs');
[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('/Volumes/SILVRSURFER/Brief_FSCV_unitonTT5_thetaonCSC15/CSC24.ncs');
[flfp, ffulltimestamps, fheader, fchannel, fsampFreq, fnValSamp ]=csc2mat('/Volumes/SILVRSURFER/Brief_FSCV_unitonTT5_thetaonCSC15/CSC28.ncs');
tmpIdx = strfind(fheader, 'ADBitVolts');
ADBitVolts = sscanf(fheader(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( flfp, ffulltimestamps );
swrSignal=filtfilt(dButter,exampleSwrSignal);
lfptime=(ffulltimestamps-ffulltimestamps(1))/1e6;
tidx=(32*32000)+1:(35*32000);
figure; 
subplot( 4,1,1 ); plot( lfptime(tidx), -flfp(tidx)*ADBitVolts, 'color', [ .6 .6 .6 ]); legend('csc24'); ylabel('?V'); xlim([32 35]);% ylim([-0.0005 0.0015]);
subplot( 4,1,2 ); plot( lfptime(tidx), correctedCsc(tidx)*ADBitVolts, 'b' ); legend('LFP'); ylabel('?V'); xlim([32 35]); %ylim([-0.00025 0.0005]);
subplot( 4,1,3 ); plot( lfptime(tidx), exampleSwrSignal(tidx)*ADBitVolts ); legend('SWR'); ylabel('?V'); xlim([32 35]);   %ylim([-3e-5 3e-5]);
subplot( 4,1,4 ); plot( xyTime(32*30+1:35*30), xpos(32*30+1:35*30)); hold on;  plot(xyTime(32*30+1:35*30), ypos(32*30+1:35*30)); legend('xpos','ypos'); ylabel('pxl'); xlim([32 35]); ylim([300 600]);

figure; plot(xyTime, xpos); hold on;  plot(xyTime, ypos);

figure; 
subplot( 4,1,1:3 );hold on; plot( lfptime, -flfp*ADBitVolts, 'color', [ .6 .6 .6 ]); legend('csc'); ylabel('?V'); %xlim([32 35]);% ylim([-0.0005 0.0015]);
subplot( 4,1,1:3 ); plot( lfptime, correctedCsc*ADBitVolts, 'b' ); legend('LFP'); ylabel('?V'); %xlim([32 35]); %ylim([-0.00025 0.0005]);
subplot( 4,1,1:3 ); plot( lfptime, exampleSwrSignal*ADBitVolts ); legend('SWR'); ylabel('?V'); %xlim([32 35]);   %ylim([-3e-5 3e-5]);
subplot( 4,1,4 ); plot( xyTime, xpos); hold on;  plot(xyTime(32*30+1:35*30), ypos(32*30+1:35*30)); legend('xpos','ypos'); ylabel('pxl');% xlim([32 35]); ylim([300 600]);

% 
% CSC4.ncs
% 3.55e5       11.1
% 6.7e5        20.94
% 8.5e5        26.56
% 1.06e5 - 1.1e5 good cluster       
% 1.86e5, 1.89e5 2 biggish ones     
% 3.98e5??
% cluster at 4.36e6
% 5.325e6
% 
% CSC24.csc
% tins=[  33.9 58.9 90 91.7 107.5 117.28 120 136.25 151.5 166.56 169.06 174.38 ];
% 1.085e6        
% 1.885e6         
% 2.88e6**        
% 2.935e6         
% 3.44e6*        
% 3.753e6 *big   
% 3.84e6 *big    
% 4.36e6 *cluster
% 4.85e6 *nice big thing
% 5.33e6         
% 5.41e6 cluster 
% 5.58e6         
% 
% 
% csc28.nsc
% 1.07-1.08e6
% 1.86-11.88e6
% 3.7e6
% 3.85e6
% 3.98e6
% 4.485e6
% 5.41e6
% tins =[  33.5937   57.8125  115.6250  120.3125  124.3750  140.1562  169.0625];


%figure; plot(-flfp(30*32000+1:33*32000), 'color', [ .6 .6 .6 ]); hold on; plot( correctedCsc(30*32000+1:33*32000), 'color', [ .7 .1 .1 ] ); legend('artifacted','corrected')
figure; subplot(8,1,1:5); plot( filter(highpassFilter,downsample(filter(lowpassFilter,correctedCsc),128))); hold on; plot(abs(hilbert(filter(highpassFilter,downsample(filter(lowpassFilter,correctedCsc),128)))));
subplot(8,1,6); plot(velocity); legend('velocity');
subplot(8,1,7); plot(xpos); legend('xpos');
subplot(8,1,8); plot(ypos); legend('ypos');




figure; plot((meanCscWindow))

normRadians=0:.01:2*pi;figure;
plot(normRadians,sin(normRadians));
hold on; 