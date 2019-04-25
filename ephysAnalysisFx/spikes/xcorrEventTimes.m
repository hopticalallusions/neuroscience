function [ xcorrValues, lagtimes] = xcorrEventTimes( eventTimesA, eventTimesB,  binSize, maxLagtime, algorithm )

    % intended to cross-correlate two 1D vectors of event times provided in seconds
    % does not currently carefully check anything. likely to explode if
    % provided bad input. ideally should be merged with its twin,
    % acorrEventTimes.m such that acorr vs xcorr is automatically detected.
    % There may also exist more efficient methods for doing this, but this
    % seems to be reasonably fast.
    
    if nargin < 3
        binSize = 0.02; % seconds
    end

    if nargin < 4
        maxLagtime = 1; % seconds
    end

    if nargin < 5 || ( ~strcmp(algorithm,'sets') && ~strcmp(algorithm,'hist') )
        algorithm = 'sets';
    end

    if binSize <= 0.002
        warning('the bin size is small! processing will be slow! forcing algorithm to sets');
        algorithm = 'sets';
    end

    xcorrValues = zeros(1,ceil(maxLagtime/binSize));
    ii=1;

    if strcmp(algorithm, 'hist')
        % we just need one of these :
        eventTimeBins = min(eventTimesA,eventTimesB)-maxLagtime:binSize:max(eventTimesA, eventTimesB)+maxLagtime; 
        % eventTimeBins becomes large over long recordings and/or small
        % binSizes -- one might want to avoid using this technique for those
        % situations (in fact, the function currently forces the set version
        % for extra small binSizes
        for offset = -maxLagtime:binSize:maxLagtime
                %
                if offset ~= 0 % the autocorrelation is obviously highest at an offset of zero, so ignore this.
                   shiftedEventTimes= eventTimesB + offset;
                   xcorrValues(ii) = sum(min(histc(eventTimesA, eventTimeBins), histc(shiftedEventTimes, eventTimeBins)));
            end
            ii=ii+1;
        end
    else
        %
        % this version is probably faster / less memory intense, but I haven't
        % made any attempts to quantify it.
        %
        binnedEventTimes = round(eventTimesA/binSize)*binSize;  % this is like bit-shifting to bin the eventTime vector
        for offset = -maxLagtime:binSize:maxLagtime
            %
            % any autocorrelation is highest at an offset of zero, so ignore this value.
           % if 1 ~= 0 
                setA = binnedEventTimes;                            % setA must be reset each time due to later element deletions (see below)
                shiftedEventTimes = eventTimesB + offset;           % shift setB
                setB = round(shiftedEventTimes/binSize)*binSize;    % round setB
                uniqueMatches = 1;                                  % force the while to go one at least once
                corrNumerator = 0;                                  % reset the accumulator for this correlation
                %
                % intersect returns a unique list of matches, so we need to
                % accumulate correlation hits, eliminate those already found
                % and repeat until no common elements are found
                %
                % otherwise, bins with multiple matched elements will be
                % counted as only 1 match, leading to eroneously low counts
                %
                % iterate
                while length( uniqueMatches ) > 0 
                    [ uniqueMatches, matchesSetAIdx, matchesSetBIdx ] = intersect( setA, setB );
                    corrNumerator = corrNumerator + length(uniqueMatches);  % accumulate result
                    setA(matchesSetAIdx) = [];  % eliminate matched elements
                    setB(matchesSetBIdx) = [];
                end
                xcorrValues(ii) = corrNumerator;          
            %end
            ii=ii+1;
        end
    end
    % finalize returned structures
    xcorrValues=xcorrValues(1:ii-1);
    lagtimes = -maxLagtime:binSize:maxLagtime;

return

% testing, rudimentary; seems to work correctly

testTimes = 0:.2:500; % seconds
[ xcorrValues, lagtimes] = acorrEventTimes( testTimes );
figure; plot(lagtimes,xcorrValues);


idxs = floor(testTimes*32000*.02)+1;
fullVersion = zeros(1,500*32000*.02); fullVersion(idxs)=1;
[corr,lag]=xcorr(fullVersion,fullVersion,32000*.02);
figure; plot(lag,corr);



a = [9 12 8 7 8 3 3]; b = [3 2 9 9 3 5 8];  % result should be 4
a = [9 8 7 8 6];      b = [5 9 9 6 8];      % result should be 3
a = [8 1 2 3];        b = [8 8 8 4];        % result should be 1
a = [9 9 9 8 7 8 6];  b = [5 9 9 6 8 ];     % result should be 4    