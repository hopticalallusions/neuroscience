% * dataDir: full directory where data to plot is stored (e.g.
%   'G:\Jan 6 2011' or 'G:\Jan 6 2011\'
dataDir = 'D:\raw data\Mar 24 2011'

% * label: string identifying set of recordings, e.g. 'Jan6a' if the
%   recordings have names Jan6a_t01, etc.
label = 'D1.18P1.1';

% which 20-second trials and channels to include traces for
whichTrials = 1:3; % corresponding to numbers after _t in the filenames
whichChannels = 1:64;

blockSizeS = 5; % how many seconds in a block of data used to estimate the power spectrum.
%  nearest power of 2 # of points will actually be used.

plotRangeHz = [5 12000];
plotColor = [1 0 0]; % red (darker = earlier in set of trials)
Fs = 1/44.8 * 10^6; % 44.8 uS sampling interval
nChannels = 64;

%% end set parameters

for t = whichTrials
    if t < 10
        basefilename = fullfile(dataDir, [label '_t0' num2str(t)]);
    else
        basefilename = fullfile(dataDir, [label '_t' num2str(t)]);
    end
    disp(['TRIAL: ' basefilename ]);
    
    % retrieve mux1 data (ch 1:32)
    tic;
    mux1 = [basefilename '.mux1'];
    
    fileList = dir(mux1);
    blockPts = fileList(1).bytes / nChannels; % 2 files, 2 bytes per pt
    time = (1:blockPts)/Fs;
    rawData = zeros(blockPts, 64);

    fid = fopen(mux1, 'r', 'b');
    data = fread(fid, [1 inf], 'int16') / 2^20 * 10^6;
    fclose(fid);
    
    for ch = 1:32
        rawData(:, ch) = data(ch : 32 : end) - mean(data(ch : 32 : end));
    end
    fprintf(1, '\nRetrieved mux1 data (%5.2f s)\n', toc);
    
    % retrieve mux2 data (ch 33:64)
    tic
    mux2 = [basefilename '.mux2'];
    fid = fopen(mux2, 'r', 'b');
    data = fread(fid, [1 inf], 'int16') / 2^20 * 10^6;
    fclose(fid);
    
    for ch = 1:32
        rawData(:, ch+32) = data(ch : 32 : end) - mean(data(ch : 32 : end));
    end
    fprintf(1, 'Retrieved mux2 data (%5.2f s)\n', toc);
    
    % make ps plot
    log2(size(rawData,1))
    for ch = whichChannels
         [ps, psFreqs] = ...
            pwelch(rawData(:,ch), 2^round(log2(blockSizeS*Fs)), [], [], Fs);
         loglog(psFreqs(psFreqs > plotRangeHz(1) & psFreqs < plotRangeHz(2)), ...
            ps(psFreqs > plotRangeHz(1) & psFreqs < plotRangeHz(2)), ...
            'color', (t - min(whichTrials) + 1)/length(whichTrials) * plotColor); hold on;
    end
end

xlim(plotRangeHz); % make x-axis limits tight
         ylabel('uV^2 / Hz');
         xlabel('Hz');
