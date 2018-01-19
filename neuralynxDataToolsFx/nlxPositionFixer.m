function [ correctedXPosition, correctedYPosition ] = nlxPositionFixer( xpositions, ypositions, smoothFactor, runFilter )
    % I tried doing this with interp1 and also inpaint NaNs, and things weren't
    % working very ideally.
    
    if  nargin < 2
        fixY = false;
    else
        fixY = true;
    end
    
    if nargin < 3
        smoothFactor = 6;
        runFilter = 0;
    end
    
    % pixelsPerFrame = 4; % 3.5-4 is a reasonable estimate for most of my mazes
    
    % diamond plus == 218 cm wide
    % square Fig 8 == 70 cm x 70 cm
    % long 8 maze == 92 cm x 152 cm
    
    %% References
    % what is a rat's maximum velocity?
    %
    % 361 cm/s  % (13 km/h) https://a-z-animals.com/animals/rat/  
    % < 90 cm/s  Long LL,Hinman JR, Chen C-M, Escabi MA, Chrobak JJ (2014) Theta Dynamics in Rat: Speed and Acceleration across the Septotemporal Axis. PLoS ONE 9(5): e97987. https://doi.org/10.1371/journal.pone.0097987
    % on a 140 straight track, they measured the animal's behavior. he
    % peaks in the track center at around 80 cm/s the majority of the time
    % the acceleration max is about 80 cm/s*s 
    %
    %
    % From Gillian Muir's "Locomotion" chapter in The Behavior of the Laboratory Rat: A Handbook with Tests; ed. Ian Q. Whishaw, Bryan Kolb
    %     80 cm/s * 4 px/cm * 1/30 s/frames = 10.7 px/frame
    % walk   18 - 55 cm/s  -->> 2.4 - 7.3 px/frame
    % trot   55 - 80 cm/s  -->> 7.3 - 10.7 px/frame
    % gallop 80 - 120 cm/s -->> 10.7 - 16 px/frame (assuming about 4 px per frame)
    %
    % I estimate my fast rat V4 was going at no more than 80 cm/s
    %
    % From Ian Golani, Yoav Benjamin, Anna Dvorkin, Dina Lipkind, Neri Kafkafi's "Locomotor & Exploratory Behavior" chapter in The Behavior of the Laboratory Rat: A Handbook with Tests; ed. Ian Q. Whishaw, Bryan Kolb
    % 68.4 cm/s is 95th percentile velocity
    % http://www.tau.ac.il/ilan99/see/help
    % these guys claim behavior segmentation should occur into arrests and
    % "progressions". (Hen et al 2004). arrests -- running medians (Tukey 1977)
    % use Robust Lowess (Cleveland 1977) to smooth remainder of time series
    %
    
    correctedXPosition = xpositions;
    if fixY
        correctedYPosition = ypositions;
    end
     
        % find pixels that seem to have unlikely favoritism. Accomplished by
    % taking a pixelwise histogram of the uncorrected xy stream. Should a
    % pixel value be (1) high and (2) have neighbors which are not high, we
    % can infer that this pixel is not highly visited, since the rat can't
    % simply teleport itself to a pixel and then away again (thus all high
    % values should have somewhat high values alongside them) We will set
    % these suspected bad values to zero.
    [qq,ww]=histcounts(correctedXPosition,min(correctedXPosition):max(correctedXPosition));
    badPxl = [];
    for ii=3:length(qq)-3
        % divide by zero causes bad results, so the 1e-3 helps
        freakPeak = ( (qq(ii)/(1e-3+qq(ii-1))) + (qq(ii)/(1e-3+qq(ii+1))) ) / 2;
        %disp(num2str(freakPeak));
        if freakPeak > 20
            %disp (['arg : ' num2str(ww(ii)) ' @ ' num2str(qq(ii)) ]);
            badPxl = [ badPxl ww(ii) ];
        end
    end
    for ii=1:length(badPxl)
        correctedXPosition(find(correctedXPosition==badPxl(ii))) = 0;
    end

    
    if fixY
       [qq,ww]=histcounts(correctedYPosition,min(correctedYPosition):max(correctedYPosition));
        badPxl = [];
        for ii=3:length(qq)-3
            % divide by zero causes bad results, so the 1e-3 helps
            freakPeak = ( (qq(ii)/(1e-3+qq(ii-1))) + (qq(ii)/(1e-3+qq(ii+1))) ) / 2;
            %disp(num2str(freakPeak));
            if freakPeak > 20
                %disp (['arg : ' num2str(ww(ii)) ' @ ' num2str(qq(ii)) ]);
                badPxl = [ badPxl ww(ii) ];
            end
        end
        for ii=1:length(badPxl)
            correctedYPosition(find(correctedYPosition==badPxl(ii))) = 0;
        end     
    end
    
    

    %% I. eliminate parts where the rat teleports to [0,0] because the
    %    tracker can't find him
    % reset initial positions to first "valid" position detected
    if correctedXPosition(1)<3 % weird things happen if the position starts at zero
        endIdx=min(find(correctedXPosition>2));
        correctedXPosition(1:endIdx) = correctedXPosition(endIdx);
    end
    % reset final positions to first "valid" position detected
    if correctedXPosition(end)<3 % weird things happen if the position ends at zero
        endIdx=max(find(correctedXPosition>2)); % TODO this part isn't quite right. it will probably find the end.
        correctedXPosition(endIdx:end) = correctedXPosition(endIdx);
    end
    % when the system cannot find the animal, it reports him at [0,0]
    % so, find all the points where the signal is concentrated up in the zero corner
    zeroIdxs=find(correctedXPosition<3);
    if ~isempty(zeroIdxs);
        size(zeroIdxs);
        start=zeroIdxs(1);
        last=zeroIdxs(2);
        for idx=3:length(zeroIdxs)
            % this is a straight up linear interpolation, which is probably
            % a bad assumption, but we'll deal with it for now.
            if (zeroIdxs(idx)-last > 1)
                delta = linspace(correctedXPosition(start-1),correctedXPosition(last+1),last-start+1);
                correctedXPosition(start:last) = delta;
                start = zeroIdxs(idx);
            end
            last=zeroIdxs(idx);
        end
        if abs(correctedXPosition(start-1)-correctedXPosition(last+1))/(last-start) < 15
            delta= linspace(correctedXPosition(start-1),correctedXPosition(last+1),last-start+1);
            correctedXPosition(start:last) = delta;
        else
            correctedXPosition(start:last) = correctedXPosition(start-1);
        end
    end

    % FIX THE Y POSITIONS
    if fixY
        if correctedYPosition(1)==0 % weird things happen if the position starts at zero
            endIdx=min(find(correctedYPosition>2));
            correctedYPosition(1:endIdx) = correctedYPosition(endIdx);
        end
        if correctedYPosition(end)==0 % weird things happen if the position ends at zero
            endIdx=max(find(correctedYPosition>2));
            correctedYPosition(endIdx:end) = correctedYPosition(endIdx);
        end

        % when the system cannot find the animal, it reports him at [0,0]
        % so, find all the points where the signal is concentrated up in the zero corner
        zeroIdxs=find(correctedYPosition<3);
        if ~isempty(zeroIdxs);
            size(zeroIdxs);
            start=zeroIdxs(1);
            last=zeroIdxs(2);
            for idx=3:length(zeroIdxs)
                % this is a straight up linear interpolation, which is probably
                % a bad assumption, but we'll deal with it for now.
                if (zeroIdxs(idx)-last > 1)
                    if abs(correctedYPosition(start-1)-correctedYPosition(last+1))/(last-start) < 2
                        delta= linspace(correctedYPosition(start-1),correctedYPosition(last+1),last-start+1);
                        correctedYPosition(start:last) = delta;
                    else
                        correctedYPosition(start:last) = correctedYPosition(start-1);
                    end
%                     delta = linspace(correctedYPosition(start-1),correctedYPosition(last+1),last-start+1);
%                     correctedYPosition(start:last) = delta;
                     start = zeroIdxs(idx);
                end
                last=zeroIdxs(idx);
            end

           % disp(num2str(abs(correctedYPosition(start-1)-correctedYPosition(last+1))/(last-start)))
            if abs(correctedYPosition(start-1)-correctedYPosition(last+1))/(last-start) < 8
                delta= linspace(correctedYPosition(start-1),correctedYPosition(last+1),last-start+1);
                correctedYPosition(start:last) = delta;
            else
                correctedYPosition(start:last) = correctedYPosition(start-1);
            end
        end
    end
   
    %% II. Use a median filter -- this is a simple way to eliminate big, short jumps
    % it's not perfect, but it works surprisingly well with few distortions
    % of the data. This will lag real teleports by fractions of a second
    %
    % note : median filtering seems to work well on quantized values. it
    % seems to introduce undesireable things to continuous valued data.
    %
    for ii = (smoothFactor+1):length(correctedXPosition)-(smoothFactor+1)
        correctedXPosition(ii) = median(correctedXPosition(ii-smoothFactor:ii+smoothFactor));
    end
    
    if fixY
        for ii = (smoothFactor+1):length(correctedYPosition)-(smoothFactor+1)
            correctedYPosition(ii) = median(correctedYPosition(ii-smoothFactor:ii+smoothFactor));
        end
    end
    

    

    %% III. now that we have eliminated the parts where the tracker couldn't find
    %     the rat, now lets try to detect unreasonable velocity / acceleration
    %
    % let's assume the rat can peak out in these mazes at 
    %   velocity 90 cm/s -->>  12 px/frame  (see above)
    %   accel    80 cm/s -->>   (let's just use 12)
%
% TODO this would definitely work, but needs more time than is strictly
% required to fix things; idea here is ID the parts that are unreasonable
% and find some way to smooth them out;
% DO NOT wholesale median filter the velocity and acceleration because it will
% introduce accumlating error as observed in a graph
%
%      speedLimit = 12;
%      velocity = [0; abs(diff(correctedXPosition))];
% %      %findpeaks( velocity, 30, 'MinPeakHeight', 200,'MinPeakDistance', 3.5*60)
%      unreasonableSpeed = find(velocity>speedLimit);
% %     if ~isempty(unreasonableSpeed)
%         correctedXPosition(unreasonableSpeed) = 0;
%         % call recursively 
%  %       correctedXPosition = nlxPositionFixer( correctedXPosition, smoothFactor, 0 );
%  %    end
%  
% 
%     if fixY
%         pxPerCm = 2; 
%         framesPerSecond = 29.97;
%         lagCenterIdx = 5;
%         lagFrames = lagCenterIdx-4:2:lagCenterIdx+4; % frames; this is to mitigate jumps that may occur
%         laggedSpeed = zeros(length(lagFrames), length(correctedXPosition));
%         for ii = 1 : length(lagFrames)
%             for jj=lagFrames(ii)+1:length(correctedXPosition)-lagFrames(ii)
%                 % px/period * 1/lagFrames * 30 frames/second * 1/pxPerCm
%                 laggedSpeed(ii,jj) = sqrt( ( correctedYPosition(jj+lagFrames(ii)) - correctedYPosition(jj-lagFrames(ii)) ).^2 + ( correctedXPosition(jj+lagFrames(ii)) - correctedXPosition(jj-lagFrames(ii)) ).^2 ) * (1/lagFrames(ii)) * 1/pxPerCm * framesPerSecond;
%             end
%         end
%         speed = median(laggedSpeed);
%         figure;
%         subplot(2,1,1);
%         plot(xpositions, 'Color', [ .8 .8 .8 ] )
%         hold on; 
%         plot(correctedXPosition);
%         plot(speed)
%         subplot(2,1,2);
%         plot(ypositions, 'Color', [ .8 .8 .8 ])
%         hold on; 
%         plot(correctedYPosition);
%         plot(speed)
%         [peakvalue, peaktime]=findpeaks( speed, 1, 'MinPeakHeight', 200,'MinPeakDistance', 30);
%         plot(peaktime,peakvalue,'v')
%     end
    
    
    %% IV. Filter to smooth
    % seems to reduce all the values, which is less than desireable
    % equivalent to "zooming out" I suppose?
    if runFilter
        xyFilter = designfilt( 'lowpassiir',                     ...
                             'FilterOrder',              8  , ...
                             'PassbandFrequency',        2  , ...
                             'PassbandRipple',           0.2, ...
                             'SampleRate',              30);
        correctedXPosition = filtfilt( xyFilter, correctedXPosition);
        if fixY
            correctedYPosition = filtfilt( xyFilter, correctedYPosition);
        end
    end
    %% catch any weirdness that may have been introduced.
    if sum( correctedXPosition < 1 )
        %correctedXPosition(find(correctedXPosition < 1 ))=1;
        correctedXPosition=correctedXPosition-min(correctedXPosition);
        %warning('some xpositions corrected out of minimum range. These have been replaced with 1.');
    end
    if sum( correctedXPosition > 720 ) % lazy...
        correctedXPosition(find(correctedXPosition > 720 ))=720;
        %warning('some xpositions corrected out of maximum range. These have been replaced with 720.');
    end
    
    if fixY
        if sum( correctedYPosition < 1 )
            %correctedYPosition(find(correctedYPosition < 1 ))=1;
            correctedYPosition=correctedYPosition-min(correctedYPosition);
            %warning('some xpositions corrected out of minimum range. These have been replaced with 1.');
        end
        if sum( correctedYPosition > 720 ) % lazy...
            correctedYPosition(find(correctedYPosition > 720 ))=720;
            %warning('some xpositions corrected out of maximum range. These have been replaced with 480.');
        end 
    end
    
    
    return;
end