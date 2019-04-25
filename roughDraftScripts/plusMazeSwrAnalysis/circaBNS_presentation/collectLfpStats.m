% metadata.day = '2017-11-01_training4';
% dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/' metadata.day  '/' ];
% metadata.swrLfpFile =  'rawChannel_56.dat'; 
% test.avoidStupidMatlabError = [ dir metadata.swrLfpFile ];
% test.rawTemp = loadCExtractedNrdChannelData(test.avoidStupidMatlabError);
% %blob.swrLfp = filtfilt( DCO, rawTemp );
% test.dcoComponent = conv( test.rawTemp, ones(8000,1)/8000, 'same');
% test.swrLfp = test.rawTemp - test.dcoComponent ;
% test.lfpTimestamps = loadCExtractedNrdTimestampData([ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/' 'timestamps.dat' ]);
% test.lfpTimestampSeconds=(test.lfpTimestamps-test.lfpTimestamps(1))/1e6;
% test.swrLfp = filtfilt( filters.so.swr, test.swrLfp );
% test.swrLfpEnv = abs( hilbert(test.swrLfp) );
% test.thetaLfp = filtfilt( filters.so.theta, test.rawTemp - test.dcoComponent );
% test.thetaLfpEnv = abs( hilbert(test.thetaLfp) );
% temp=test.swrLfpEnv; temp(test.thetaLfpEnv<.25) = 0;
% [ test.swrPeakValues,      ...
%   test.swrPeakTimes,       ...
%   test.swrPeakProminances, ...
%   test.swrPeakWidths ] = findpeaks( temp,                        ... % data
%                              test.lfpTimestampSeconds,                     ... % sampling frequency
%                              'MinPeakHeight',  mean(test.swrLfpEnv)+std(test.swrLfpEnv), ... % prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
%                              'MinPeakDistance', 0.05  );               % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
% figure; hold on; histogram(test.swrPeakValues,0:0.001:0.5)
% figure; plot(test.lfpTimestampSeconds,test.rawTemp); hold on; plot(test.lfpTimestampSeconds,test.dcoComponent); 
% figure; plot(test.lfpTimestampSeconds,test.rawTemp-test.dcoComponent); hold on; plot(test.lfpTimestampSeconds,test.swrLfpEnv);
% 
% figure; [ff,bb]=hist(test.swrPeakValues,100); plot(bb,log(ff))
% figure; hold on; plot(test.lfpTimestampSeconds,test.rawTemp - test.dcoComponent);plot(test.lfpTimestampSeconds,test.thetaLfp);
% figure; hist(test.thetaLfpEnv,1000)




makeFilters;

% theta power
% best channel for theta : ch56
% second best channel for theta : ch52
% dirDays = { '2017-10-24_orientation2' '2017-10-27_training1' '2017-10-30_training2' '2017-10-31_training3_probe1' '2017-11-01_training4' '2017-11-02_training5' '2017-11-03_training6' '2017-11-06_training7' '2017-11-07_training8' '2017-11-08_training9_probe2' };
% fileListGoodLfp = { 'rawChannel_32.dat'  'rawChannel_37.dat' 'rawChannel_44.dat' 'rawChannel_46.dat' 'rawChannel_48.dat' 'rawChannel_52.dat' 'rawChannel_56.dat'  'rawChannel_61.dat'  }; 
% recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  }; 
% for jj=1:length(recDays)
%     gcf=figure; hold on;
%     for  ii=1:length(fileListGoodLfp)
%         test.avoidStupidMatlabError = [ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/' (dirDays{jj}) '/' (fileListGoodLfp{ii}) ];
%         test.rawTemp = loadCExtractedNrdChannelData(test.avoidStupidMatlabError);
%         test.dcoComponent = conv( test.rawTemp, ones(8000,1)/8000, 'same');
%         test.thetaLfp = filtfilt( filters.so.theta, test.rawTemp - test.dcoComponent );
%         test.thetaLfpEnv = abs( hilbert(test.thetaLfp) );
%         histogram( test.thetaLfpEnv, 0:0.01:0.5)
%     end
%     legend('ch32', 'ch37', 'ch44', 'ch46', 'ch48', 'ch52', 'ch56', 'ch61');
%     print( gcf, [ '~/data/da12_' (dirDays{jj}) '_thetaPower.png'],'-dpng','-r200');
%     close;
% end



symbols={ 'o', '*', 'v', '^', '>', '<', '+', 's', 'x' };

% SWR power
% best channel for SWR : 
% second best channel for SWR : 
try
    dirDays = { '2017-10-24_orientation2' '2017-10-27_training1' '2017-10-30_training2' '2017-10-31_training3_probe1' '2017-11-01_training4' '2017-11-02_training5' '2017-11-03_training6' '2017-11-06_training7' '2017-11-07_training8' '2017-11-08_training9_probe2' };
    fileListGoodLfp = { 'rawChannel_32.dat'  'rawChannel_37.dat' 'rawChannel_44.dat' 'rawChannel_46.dat' 'rawChannel_48.dat' 'rawChannel_52.dat' 'rawChannel_56.dat'  'rawChannel_61.dat'  }; 
    recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  }; 
    for jj=1:length(recDays)
        gcfa=figure; hold on;
        gcfb=figure; hold on;
        gcfc=figure; hold on;
        gcfd=figure; hold on;
        for  ii=1:length(fileListGoodLfp)
            test.avoidStupidMatlabError = [ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da12/' (dirDays{jj}) '/' (fileListGoodLfp{ii}) ];
            test.rawTemp = loadCExtractedNrdChannelData(test.avoidStupidMatlabError);
            test.dcoComponent = conv( test.rawTemp, ones(8000,1)/8000, 'same');
            test.lfp = test.rawTemp - test.dcoComponent;
            test.swrLfp = filtfilt( filters.so.swr, test.lfp );
            test.swrLfpEnv = abs( hilbert(test.swrLfp) );
            test.thetaLfp = filtfilt( filters.so.theta, test.lfp );
            test.thetaLfpEnv = abs( hilbert(test.thetaLfp) );
            
            test.liaLfp = filtfilt( filters.so.lia, test.lfp );
            test.liaLfpEnv = abs( hilbert(test.liaLfp) );
            test.nremLfp = filtfilt( filters.so.nrem, test.lfp );
            test.nremLfpEnv = abs( hilbert(test.nremLfp) );
            
            figure(gcfa);
            [ff,bb]=histcounts( test.swrLfpEnv, 0:0.001:0.2 );
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            figure(gcfb);
            [ff,bb]=histcounts( test.thetaLfpEnv, 0:0.0025:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            figure(gcfc);
            [ff,bb]=histcounts( test.liaLfpEnv, 0:0.0025:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            figure(gcfd);
            [ff,bb]=histcounts( test.nremLfpEnv, 0:0.0025:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            
            disp([ ' day ' (dirDays(jj)) '  channel ' (fileListGoodLfp(ii)) ]);
            disp( [ 'swr   : mean ' num2str(mean(test.swrLfpEnv)) ' std ' num2str(std(test.swrLfpEnv)) ' median ' num2str(median(test.swrLfpEnv)) ' madam ' num2str(median(abs(test.swrLfpEnv-median(test.swrLfpEnv)))) ' threshold ' num2str(std(test.swrLfpEnv)*6)  ' skew ' num2str(skewness(test.swrLfpEnv))  ' kurt ' num2str(kurtosis(test.swrLfpEnv)) ' min ' num2str(min(test.swrLfpEnv))  ' max ' num2str(max(test.swrLfpEnv))   ]);
            disp( [ 'theta : mean ' num2str(mean(test.thetaLfpEnv)) ' std ' num2str(std(test.thetaLfpEnv)) ' median ' num2str(median(test.thetaLfpEnv)) ' madam ' num2str(median(abs(test.thetaLfpEnv-median(test.thetaLfpEnv)))) ' threshold ' num2str(std(test.thetaLfpEnv)*6)  ' skew ' num2str(skewness(test.thetaLfpEnv))  ' kurt ' num2str(kurtosis(test.thetaLfpEnv)) ' min ' num2str(min(test.thetaLfpEnv))  ' max ' num2str(max(test.thetaLfpEnv))   ]);
            disp( [ 'lia   : mean ' num2str(mean(test.liaLfpEnv)) ' std ' num2str(std(test.liaLfpEnv)) ' median ' num2str(median(test.liaLfpEnv)) ' madam ' num2str(median(abs(test.liaLfpEnv-median(test.liaLfpEnv)))) ' threshold ' num2str(std(test.liaLfpEnv)*6)  ' skew ' num2str(skewness(test.liaLfpEnv))  ' kurt ' num2str(kurtosis(test.liaLfpEnv)) ' min ' num2str(min(test.liaLfpEnv))  ' max ' num2str(max(test.liaLfpEnv))   ]);
            disp( [ 'nrem  : mean ' num2str(mean(test.nremLfpEnv)) ' std ' num2str(std(test.nremLfpEnv)) ' median ' num2str(median(test.nremLfpEnv)) ' madam ' num2str(median(abs(test.nremLfpEnv-median(test.nremLfpEnv)))) ' threshold ' num2str(std(test.nremLfpEnv)*6)  ' skew ' num2str(skewness(test.nremLfpEnv))  ' kurt ' num2str(kurtosis(test.nremLfpEnv)) ' min ' num2str(min(test.nremLfpEnv))  ' max ' num2str(max(test.nremLfpEnv))   ]);
        end
        figure(gcfa);
        legend('ch32', 'ch37', 'ch44', 'ch46', 'ch48', 'ch52', 'ch56', 'ch61');
        figure(gcfb);
        legend('ch32', 'ch37', 'ch44', 'ch46', 'ch48', 'ch52', 'ch56', 'ch61');
        figure(gcfc);
        legend('ch32', 'ch37', 'ch44', 'ch46', 'ch48', 'ch52', 'ch56', 'ch61');
        figure(gcfd);
        legend('ch32', 'ch37', 'ch44', 'ch46', 'ch48', 'ch52', 'ch56', 'ch61');
        
        print( gcfa, [ '~/data/da12_' (dirDays{jj}) '_swrPower.png'],'-dpng','-r200');
        print( gcfb, [ '~/data/da12_' (dirDays{jj}) '_thetaPower.png'],'-dpng','-r200');
        print( gcfc, [ '~/data/da12_' (dirDays{jj}) '_liaPower.png'],'-dpng','-r200');
        print( gcfd, [ '~/data/da12_' (dirDays{jj}) '_nremPower.png'],'-dpng','-r200');
        close(gcfa); close(gcfb); close(gcfc); close(gcfd);
    end
catch
end
%     '2017-10-24_orientation2'
%  mean 0.0095175 std 0.0058207 median 0.0087102 madam 0.0034314 threshold 0.034924
%     '2017-10-27_training1'
%  mean 0.0092499 std 0.014659 median 0.0083047 madam 0.003307 threshold 0.087954
%     '2017-10-30_training2'
%  mean 0.0094203 std 0.0054831 median 0.0086113 madam 0.0034128 threshold 0.032899
%     '2017-10-31_training3_probe1'
%  mean 0.0075316 std 0.0042337 median 0.0069617 madam 0.0027176 threshold 0.025402
%     '2017-11-01_training4'
%  mean 0.0081379 std 0.012186 median 0.0072309 madam 0.0028337 threshold 0.073117
%     '2017-11-02_training5'
%  mean 0.0070021 std 0.0070985 median 0.0064377 madam 0.0025093 threshold 0.042591
%     '2017-11-03_training6'
%  mean 0.007964 std 0.00457 median 0.0073738 madam 0.0028651 threshold 0.02742
%     '2017-11-06_training7'
%  mean 0.0080328 std 0.0045406 median 0.007426 madam 0.0028929 threshold 0.027244
%     '2017-11-07_training8'
%  mean 0.0075872 std 0.0060002 median 0.0069928 madam 0.0027024 threshold 0.036001
%     '2017-11-08_training9_probe2'
%  mean 0.0085347 std 0.0078207 median 0.0077065 madam 0.0030539 threshold 0.046924

try
    disp('=============')
    disp('da5')
    disp('=============')
    dirDays = { '/2016-08-22_orientation1/' '/2016-08-23_orientation2/' '/2016-08-24_training1/' '/2016-08-25_training2/'  '/2016-08-26_probe1/'  '/2016-08-27_training3/'  '/2016-08-28_training4/'  '/2016-08-29_training5/' '/2016-08-31_training7/'  '/2016-09-01_training8/'  '/2016-09-02_probe2/'  '/2016-09-06_training9_x2/'  '/2016-09-07_training10_x2/'  '/2016-09-08_probe3_training11/' }; % '/2016-08-30_training6/'
    fileListGoodLfp = { 'CSC2.ncs'  'CSC10.ncs'  'CSC14.ncs'  'CSC18.ncs'  'CSC30.ncs'  'CSC38.ncs'  'CSC42.ncs'  'CSC50.ncs'  'CSC54.ncs'  'CSC58.ncs'  'CSC62.ncs'  };  % theta 'CSC46.ncs'  lots of cells 'CSC6.ncs'  'CSC26.ncs'
    recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29'  'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %'aug30'
    for jj=1:length(recDays)
        gcfa=figure; hold on;
        gcfb=figure; hold on;
        gcfc=figure; hold on;
        gcfd=figure; hold on;
        for  ii=1:length(fileListGoodLfp)
            test.avoidStupidMatlabError = [ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da5/' (dirDays{jj}) '/' (fileListGoodLfp{ii}) ];
            test.lfp = csc2mat(test.avoidStupidMatlabError);

            test.swrLfp = filtfilt( filters.so.swr, test.lfp );
            test.swrLfpEnv = abs( hilbert(test.swrLfp) );
            test.thetaLfp = filtfilt( filters.so.theta, test.lfp );
            test.thetaLfpEnv = abs( hilbert(test.thetaLfp) );
            
            test.liaLfp = filtfilt( filters.so.lia, test.lfp );
            test.liaLfpEnv = abs( hilbert(test.liaLfp) );
            test.nremLfp = filtfilt( filters.so.nrem, test.lfp );
            test.nremLfpEnv = abs( hilbert(test.nremLfp) );
            
            figure(gcfa);
            [ff,bb]=histcounts( test.swrLfpEnv, 0:0.001:0.2 );
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            figure(gcfb);
            [ff,bb]=histcounts( test.thetaLfpEnv, 0:0.0025:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            figure(gcfc);
            [ff,bb]=histcounts( test.liaLfpEnv, 0:0.0025:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            figure(gcfd);
            [ff,bb]=histcounts( test.nremLfpEnv, 0:0.0025:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{ii}, 'LineStyle', '-' );
            
            disp( [ ' day ' (dirDays(jj)) '  channel ' (fileListGoodLfp(ii)) ]);
            disp( [ 'swr   : mean ' num2str(mean(test.swrLfpEnv)) ' std ' num2str(std(test.swrLfpEnv)) ' median ' num2str(median(test.swrLfpEnv)) ' madam ' num2str(median(abs(test.swrLfpEnv-median(test.swrLfpEnv)))) ' threshold ' num2str(std(test.swrLfpEnv)*6)  ' skew ' num2str(skewness(test.swrLfpEnv))  ' kurt ' num2str(kurtosis(test.swrLfpEnv)) ' min ' num2str(min(test.swrLfpEnv))  ' max ' num2str(max(test.swrLfpEnv))   ]);
            disp( [ 'theta : mean ' num2str(mean(test.thetaLfpEnv)) ' std ' num2str(std(test.thetaLfpEnv)) ' median ' num2str(median(test.thetaLfpEnv)) ' madam ' num2str(median(abs(test.thetaLfpEnv-median(test.thetaLfpEnv)))) ' threshold ' num2str(std(test.thetaLfpEnv)*6)  ' skew ' num2str(skewness(test.thetaLfpEnv))  ' kurt ' num2str(kurtosis(test.thetaLfpEnv)) ' min ' num2str(min(test.thetaLfpEnv))  ' max ' num2str(max(test.thetaLfpEnv))   ]);
            disp( [ 'lia   : mean ' num2str(mean(test.liaLfpEnv)) ' std ' num2str(std(test.liaLfpEnv)) ' median ' num2str(median(test.liaLfpEnv)) ' madam ' num2str(median(abs(test.liaLfpEnv-median(test.liaLfpEnv)))) ' threshold ' num2str(std(test.liaLfpEnv)*6)  ' skew ' num2str(skewness(test.liaLfpEnv))  ' kurt ' num2str(kurtosis(test.liaLfpEnv)) ' min ' num2str(min(test.liaLfpEnv))  ' max ' num2str(max(test.liaLfpEnv))   ]);
            disp( [ 'nrem  : mean ' num2str(mean(test.nremLfpEnv)) ' std ' num2str(std(test.nremLfpEnv)) ' median ' num2str(median(test.nremLfpEnv)) ' madam ' num2str(median(abs(test.nremLfpEnv-median(test.nremLfpEnv)))) ' threshold ' num2str(std(test.nremLfpEnv)*6)  ' skew ' num2str(skewness(test.nremLfpEnv))  ' kurt ' num2str(kurtosis(test.nremLfpEnv)) ' min ' num2str(min(test.nremLfpEnv))  ' max ' num2str(max(test.nremLfpEnv))   ]);
        end
        figure(gcfa);
        legend('ch2', 'ch10', 'ch14', 'ch18', 'ch30', 'ch38', 'ch42', 'ch50', 'ch54', 'ch58', 'ch62' );
        figure(gcfb);
        legend('ch2', 'ch10', 'ch14', 'ch18', 'ch30', 'ch38', 'ch42', 'ch50', 'ch54', 'ch58', 'ch62' );
        figure(gcfc);
        legend('ch2', 'ch10', 'ch14', 'ch18', 'ch30', 'ch38', 'ch42', 'ch50', 'ch54', 'ch58', 'ch62' );
        figure(gcfd);
        legend('ch2', 'ch10', 'ch14', 'ch18', 'ch30', 'ch38', 'ch42', 'ch50', 'ch54', 'ch58', 'ch62' );
        
        print( gcfa, [ '~/data/da5_' strrep((dirDays{jj}),'/','') '_swrPower.png'],'-dpng','-r200');
        print( gcfb, [ '~/data/da5_' strrep((dirDays{jj}),'/','') '_thetaPower.png'],'-dpng','-r200');
        print( gcfc, [ '~/data/da5_' strrep((dirDays{jj}),'/','') '_liaPower.png'],'-dpng','-r200');
        print( gcfd, [ '~/data/da5_' strrep((dirDays{jj}),'/','') '_nremPower.png'],'-dpng','-r200');
        close(gcfa); close(gcfb); close(gcfc); close(gcfd);
    end
catch
end








try
    disp('=============')
    disp('da10')
    disp('=============')
    dirDays = { 'da10_2017-09-11/explore/' '2017-09-12_/training/'  '2017-09-13_/training/'  '2017-09-14_/'  '2017-09-15_/'  '2017-09-18_/training1/'  '2017-09-18_/training2/'  '2017-09-18_/training3/'  '2017-09-19_/'  '2017-09-20_/train/'  '2017-09-22_/'  '2017-09-25_/' }; %{ '/2016-08-22_orientation1/' '/2016-08-23_orientation2/' '/2016-08-24_training1/' '/2016-08-25_training2/'  '/2016-08-26_probe1/'  '/2016-08-27_training3/'  '/2016-08-28_training4/'  '/2016-08-29_training5/' '/2016-08-31_training7/'  '/2016-09-01_training8/'  '/2016-09-02_probe2/'  '/2016-09-06_training9_x2/'  '/2016-09-07_training10_x2/'  '/2016-09-08_probe3_training11/' }; % '/2016-08-30_training6/'
    %fileListGoodLfp = { 'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC17.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
    fileListGoodLfp = { 'CSC6.ncs'  'CSC9.ncs'  'CSC13.ncs'  'CSC21.ncs'  'CSC37.ncs'  'CSC45.ncs'  'CSC49.ncs'  'CSC53.ncs'  'CSC61.ncs'  'CSC65.ncs'  'CSC77.ncs' 'CSC88.ncs' };
   %recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29'  'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %'aug30'
    recDays = { 'sep11' 'sep12'  'sep13'  'sep14'  'sep15'  'sep18_1'  'sep18_2'  'sep18_3'  'sep19'  'sep20'  'sep22'  'sep25' };
    for jj=12:length(dirDays)
        gcfa=figure; hold on;
        gcfb=figure; hold on;
        gcfc=figure; hold on;
        gcfd=figure; hold on;
        for  ii=1:length(fileListGoodLfp)
            test.avoidStupidMatlabError = [ '/Volumes/Seagate Expansion Drive/plusmaze-habit/da10/' (dirDays{jj}) '/' (fileListGoodLfp{ii}) ];
            test.lfp = csc2mat(test.avoidStupidMatlabError);

            test.swrLfp = filtfilt( filters.so.swr, test.lfp );
            test.swrLfpEnv = abs( hilbert(test.swrLfp) );
            test.thetaLfp = filtfilt( filters.so.theta, test.lfp );
            test.thetaLfpEnv = abs( hilbert(test.thetaLfp) );

            test.liaLfp = filtfilt( filters.so.lia, test.lfp );
            test.liaLfpEnv = abs( hilbert(test.liaLfp) );
            test.nremLfp = filtfilt( filters.so.nrem, test.lfp );
            test.nremLfpEnv = abs( hilbert(test.nremLfp) );
            
            figure(gcfa);
            [ff,bb]=histcounts( test.swrLfpEnv, 0:0.0001:0.05 );
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{mod(ii,length(symbols)-1)+1}, 'LineStyle', '-' );
            figure(gcfb);
            [ff,bb]=histcounts( test.thetaLfpEnv, 0:0.001:0.2);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{mod(ii,length(symbols)-1)+1}, 'LineStyle', '-' );
            figure(gcfc);
            [ff,bb]=histcounts( test.liaLfpEnv, 0:0.002:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{mod(ii,length(symbols)-1)+1}, 'LineStyle', '-' );
            figure(gcfd);
            [ff,bb]=histcounts( test.nremLfpEnv, 0:0.002:0.5);
            plot( bb(1:end-1)+diff(bb)/2 , ff, symbols{mod(ii,length(symbols)-1)+1}, 'LineStyle', '-' );
            
            disp([ ' day ' (dirDays(jj)) '  channel ' (fileListGoodLfp(ii)) ]);
            disp( [ 'swr   : mean ' num2str(mean(test.swrLfpEnv)) ' std ' num2str(std(test.swrLfpEnv)) ' median ' num2str(median(test.swrLfpEnv)) ' madam ' num2str(median(abs(test.swrLfpEnv-median(test.swrLfpEnv)))) ' threshold ' num2str(std(test.swrLfpEnv)*6)  ' skew ' num2str(skewness(test.swrLfpEnv))  ' kurt ' num2str(kurtosis(test.swrLfpEnv)) ' min ' num2str(min(test.swrLfpEnv))  ' max ' num2str(max(test.swrLfpEnv))   ]);
            disp( [ 'theta : mean ' num2str(mean(test.thetaLfpEnv)) ' std ' num2str(std(test.thetaLfpEnv)) ' median ' num2str(median(test.thetaLfpEnv)) ' madam ' num2str(median(abs(test.thetaLfpEnv-median(test.thetaLfpEnv)))) ' threshold ' num2str(std(test.thetaLfpEnv)*6)  ' skew ' num2str(skewness(test.thetaLfpEnv))  ' kurt ' num2str(kurtosis(test.thetaLfpEnv)) ' min ' num2str(min(test.thetaLfpEnv))  ' max ' num2str(max(test.thetaLfpEnv))   ]);
            disp( [ 'lia   : mean ' num2str(mean(test.liaLfpEnv)) ' std ' num2str(std(test.liaLfpEnv)) ' median ' num2str(median(test.liaLfpEnv)) ' madam ' num2str(median(abs(test.liaLfpEnv-median(test.liaLfpEnv)))) ' threshold ' num2str(std(test.liaLfpEnv)*6)  ' skew ' num2str(skewness(test.liaLfpEnv))  ' kurt ' num2str(kurtosis(test.liaLfpEnv)) ' min ' num2str(min(test.liaLfpEnv))  ' max ' num2str(max(test.liaLfpEnv))   ]);
            disp( [ 'nrem  : mean ' num2str(mean(test.nremLfpEnv)) ' std ' num2str(std(test.nremLfpEnv)) ' median ' num2str(median(test.nremLfpEnv)) ' madam ' num2str(median(abs(test.nremLfpEnv-median(test.nremLfpEnv)))) ' threshold ' num2str(std(test.nremLfpEnv)*6)  ' skew ' num2str(skewness(test.nremLfpEnv))  ' kurt ' num2str(kurtosis(test.nremLfpEnv)) ' min ' num2str(min(test.nremLfpEnv))  ' max ' num2str(max(test.nremLfpEnv))   ]);
        end
        figure(gcfa);
        ylim([0 3e6]);
        legend( 'ch6', 'ch9', 'ch13', 'ch17', 'ch21', 'ch37', 'ch45', 'ch49', 'ch53', 'ch61', 'ch65', 'ch77', 'ch88' );
        figure(gcfb);
        ylim([0 3e6]);
        legend( 'ch6', 'ch9', 'ch13', 'ch17', 'ch21', 'ch37', 'ch45', 'ch49', 'ch53', 'ch61', 'ch65', 'ch77', 'ch88' );
        figure(gcfc);
        ylim([0 3e6]);
        legend( 'ch6', 'ch9', 'ch13', 'ch17', 'ch21', 'ch37', 'ch45', 'ch49', 'ch53', 'ch61', 'ch65', 'ch77', 'ch88' );
        figure(gcfd);
        ylim([0 3e6]);
        legend( 'ch6', 'ch9', 'ch13', 'ch17', 'ch21', 'ch37', 'ch45', 'ch49', 'ch53', 'ch61', 'ch65', 'ch77', 'ch88' );
        print( gcfa, [ '~/data/da10_' strrep((dirDays{jj}),'/','') '_swrPower.png'],'-dpng','-r200');
        print( gcfb, [ '~/data/da10_' strrep((dirDays{jj}),'/','') '_thetaPower.png'],'-dpng','-r200');
        print( gcfc, [ '~/data/da10_' strrep((dirDays{jj}),'/','') '_liaPower.png'],'-dpng','-r200');
        print( gcfd, [ '~/data/da10_' strrep((dirDays{jj}),'/','') '_nremPower.png'],'-dpng','-r200');
        close(gcfa); close(gcfb); close(gcfc); close(gcfd);
    end
catch
end
  