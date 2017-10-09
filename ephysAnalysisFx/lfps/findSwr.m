%find SWR events
function [ swrBandLfp, swrLfpEnvelope, peakValues, peakTimes, peakProminances, peakWidths ] = findSwr( filename, percentile )

if nargin < 2
    percentile = 98;
end

% testing
% filename='/Users/andrewhowe/data/da5/day1_plusmaze_habituation_2016-08-22/CSC4.ncs'
% percentile=98 % set as default based on Singer & Frank's analysis methods; percentile is a more reasonable metric than mean and median due to non-gaussian nature of envelope values

% get data
[rawLfp,timestamps,header]=csc2mat(filename);
% convert to volts
tmpIdx = strfind(header, 'ADBitVolts'); 
ADBitVolts = sscanf( header(tmpIdx(1) + length('ADBitVolts'):end), '%g', 1);
rawLfp = rawLfp * ADBitVolts; % volts
% set sampling frequency
tmpIdx = strfind(header, 'SamplingFrequency'); 
Fs = sscanf( header(tmpIdx(1) + length('SamplingFrequency'):end), '%g', 1);
% build a SWR filter
%[A,B,C,D] = butter( 4, [125 250]/32000 );
swrFilter = designfilt( 'bandpassiir',                 ...
                        'FilterOrder',              8, ...
                        'HalfPowerFrequency1',    110, ...
                        'HalfPowerFrequency2',    240, ...
                        'SampleRate',           Fs);
swrBandLfp = filtfilt( swrFilter, rawLfp);
% find the enveclope (to limit the peak detection)
swrBandLfpHilbert = hilbert( swrBandLfp );
swrLfpEnvelope = abs( swrBandLfpHilbert );
[ peakValues, ...
  peakTimes, ...
  peakProminances, ...
  peakWidths ] = findpeaks(  ...
                          swrLfpEnvelope,    ... % data
                          Fs,                 ... % sampling frequency
                          'MinPeakHeight',   prctile( swrLfpEnvelope, percentile ), ... % default 95th percentile peak height
                          'MinPeakDistance', 0.05  ); % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak


                      

% maybe also compare this with a few other methods
%     low pass version
%     get an event triggered LFP 2d version,
%     check for outlier traces
                      
                      
%
% testing
%
% figure;
% plot( timestamps, swrBandLfp); hold on; 
% plot( timestamps, swrBandEnvelope); 
% findpeaks(  ...
%                           swrBandEnvelope,    ... % data
%                           Fs,                 ... % sampling frequency
%                           'MinPeakHeight',   prctile( swrBandEnvelope, percentile ), ... % default 95th percentile peak height
%                           'MinPeakDistance', 0.05  ... % assumes "lockout" for SWR events; don't detect peaks within 50 ms on either side of peak
%                           ); % 'Annotate','extents','WidthReference','halfheight');


