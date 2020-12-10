function [ coherence, cyclicalFreq ] = crossFreqCoherence( lfp1, lfp2, samplingFrequency, winSizeSec, overlapSizeSec, frequencyResolution, lowerFrequencyLimit, upperFrequencyLimit )
    %
    % lfp1                - 1st LFP to analyze; 
    % lfp2                - 2nd LFP to analyze; 
    % samplingFrequency   - self explanatory; in Hz  (samples per second)
    % winSize             - how wide is the short FFT window in seconds? (informs mimimum freq. resolution; will be converted to a power of 2)
    % overlapSize         - how wide is the overlap in seconds?
    % lowerFrequencyLimit - optional; in Hz (samples per second)
    % upperFrequencyLimit - optional; in Hz (samples per second)
    % frequencyResolution - how wide are the frequency bands in Hz (samples per second)
    %
    % (c) Andrew G. Howe 2019
    %
    % REFERENCES
    % 
    %  B. Masimore, J. Kakalios, A.D. Redish (2004) ?Measuring fundamental frequencies in local field potentials? Journal of Neuroscience Methods 138(1-2):97-105.
    %  
    %  MA Kramer. An Introduction to Field Analysis Techniques: The Power Spectrum and Coherence. 2013.  
    %
    %  A. Johnson, A. D. Redish (2007) ?Neural ensembles in CA3 transiently encode paths forward of the animal at a decision point? Journal of Neuroscience 27(45):12176-12189.
    %
    %  A Nakhnikian, S Ito, LL Dwiel, LM Grasse, GV Rebec, LN Lauridsen, JM Beggs. A novel cross-frequency coupling detection method using the generalized Morse wavelets. Journal of Neuroscience Methods 269 (2016) 61?73. 
    %
    if nargin < 3; samplingFrequency = 1000; end;
    if nargin < 4; winSize     = 2^( round( log2( samplingFrequency * .333 )) ); else winSize     = 2^( round(log2(samplingFrequency*winSizeSec))     ); end;
    if nargin < 5; overlapSize = 2^( round( log2( samplingFrequency * .16  )) ); else overlapSize = 2^( round(log2(samplingFrequency*overlapSizeSec)) ); end;
    %
    if nargin < 6; frequencyResolution = 1; end;
    if nargin < 7; lowerFrequencyLimit = ceil(2/(winSize/samplingFrequency)); end;  % assume 2 cycles are required to determine power in any given window, thus 2 over the window size in seconds gives the lower frequency bound
    if nargin < 8; upperFrequencyLimit = floor( samplingFrequency/2 ); end;
    %
    spectrogramPoints = lowerFrequencyLimit:frequencyResolution:upperFrequencyLimit;
    % [ FFT, cyclicalFreqs, sampleTimes ]
    [ sfftLfp1,            ~, ~ ] = spectrogram( lfp1, blackman(winSize), overlapSize, spectrogramPoints, samplingFrequency );
    [ sfftLfp2, cyclicalFreq, ~ ] = spectrogram( lfp2, blackman(winSize), overlapSize, spectrogramPoints, samplingFrequency );
%
% OLD FORMULATION
%    pwrSpecsLfp2 = abs(sfftLfp2);
%    pwrSpecsLfp1 = abs(sfftLfp1);
%
% NEW FORMULATION
    [ rawPsdLfp1 ] = computepsd( sfftLfp1, cyclicalFreq, overlapSize, spectrogramPoints, samplingFrequency);
    pwrSpecsLfp1 = 10*log10(abs(rawPsdLfp1)+eps);
    [ rawPsdLfp2 ] = computepsd( sfftLfp2, cyclicalFreq, overlapSize, spectrogramPoints, samplingFrequency);
    pwrSpecsLfp2 = 10*log10(abs(rawPsdLfp2)+eps);
    
    avgPwrPerFreqLfp2 = mean(pwrSpecsLfp2,2);
    avgPwrPerFreqLfp1 = mean(pwrSpecsLfp1,2);
    stdAtFreqStr = std(pwrSpecsLfp2');
    stdAtFreqCtx = std(pwrSpecsLfp1');
    
    coherence = zeros(round(size(pwrSpecsLfp2,1)/2));
    %
    for freq1 = 1:round(size(pwrSpecsLfp2,1))
        for freq2 = 1:round(size(pwrSpecsLfp2,1))
            coherence(freq1,freq2) = ( sum(  ( pwrSpecsLfp2(freq1,:)-avgPwrPerFreqLfp2(freq1) ) .*  ( pwrSpecsLfp1(freq2,:)-avgPwrPerFreqLfp1(freq2) )  )  )/( stdAtFreqStr(freq1) * stdAtFreqCtx(freq2) );
        end
    end
end