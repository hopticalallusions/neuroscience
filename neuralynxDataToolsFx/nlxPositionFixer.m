function correctedPosition = nlxPositionFixer( positions, smoothFactor, runFilter )
    % I tried doing this with interp1 and also inpaint NaNs, and things weren't
    % working very ideally.
    
    if nargin < 2
        smoothFactor = 4;
        runFilter = 1;
    end
    
    pixelsPerFrame = 4; % 3.5-4 is a reasonable estimate for most of my mazes
    
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
    
    %% I. eliminate parts where the rat teleports to [0,0] because the
    %    tracker can't find him
    
    if positions(1)==0 % weird things happen if the position starts at zero
        endIdx=min(find(positions>2));
        positions(1:endIdx) = positions(endIdx);
    end
    if positions(end)==0 % weird things happen if the position ends at zero
        endIdx=max(find(positions>2));
        positions(endIdx:end) = positions(endIdx);
    end

    % when the system cannot find the animal, it reports him at [0,0]
    % so, find all the points where the signal is concentrated up in the zero corner
    zeroIdxs=find(positions<3);
    if ~isempty(zeroIdxs);
        size(zeroIdxs);
        start=zeroIdxs(1);
        last=zeroIdxs(2);
        correctedPosition=positions;
        for idx=3:length(zeroIdxs)
            % this is a straight up linear interpolation, which is probably
            % a bad assumption, but we'll deal with it for now.
            if (zeroIdxs(idx)-last > 1)
                delta = linspace(positions(start-1),positions(last+1),last-start+1);
                correctedPosition(start:last) = delta;
                start = zeroIdxs(idx);
            end
            last=zeroIdxs(idx);
        end
        delta= linspace(positions(start-1),positions(last+1),last-start+1);
        correctedPosition(start:last) = delta;
    end

    %% II. Use a median filter -- this is a simple way to eliminate big jumps
    % it's not perfect, but it works surprisingly well with few distortions
    % of the data. This will lag real teleports by fractions of a second
    %
    % note : median filtering seems to work well on quantized values. it
    % seems to introduce undesireable things to continuous valued data.
    %
    for ii = (smoothFactor+1):length(correctedPosition)-(smoothFactor+1)
        correctedPosition(ii) = median(correctedPosition(ii-smoothFactor:ii+smoothFactor));
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
%      speedLimit = 15;
%      velocity = [0; abs(diff(correctedPosition))];
% %      %findpeaks( velocity, 30, 'MinPeakHeight', 200,'MinPeakDistance', 3.5*60)
%      unreasonableSpeed = find(velocity>speedLimit);
% %     if ~isempty(unreasonableSpeed)
%         correctedPosition(unreasonableSpeed) = 0;
%         % call recursively 
%  %       correctedPosition = nlxPositionFixer( correctedPosition, smoothFactor, 0 );
%  %    end
%  
% 
%      %% Ib. eliminate parts where the rat teleports to [0,0] because the
%     %    tracker can't find him
%     
%     if correctedPosition(1)==0 % weird things happen if the position starts at zero
%         endIdx=min(find(correctedPosition>2));
%         correctedPosition(1:endIdx) = correctedPosition(endIdx);
%     end
%     if correctedPosition(end)==0 % weird things happen if the position ends at zero
%         endIdx=max(find(correctedPosition>2));
%         correctedPosition(endIdx:end) = correctedPosition(endIdx);
%     end
% 
%     % when the system cannot find the animal, it reports him at [0,0]
%     % so, find all the points where the signal is concentrated up in the zero corner
%     zeroIdxs=find(correctedPosition<3);
%     if ~isempty(zeroIdxs);
%         size(zeroIdxs);
%         start=zeroIdxs(1);
%         last=zeroIdxs(2);
%         for idx=3:length(zeroIdxs)
%             % this is a straight up linear interpolation, which is probably
%             % a bad assumption, but we'll deal with it for now.
%             if (zeroIdxs(idx)-last > 1)
%                 delta = linspace(positions(start-1),correctedPosition(last+1),last-start+1);
%                 correctedPosition(start:last) = delta;
%                 start = zeroIdxs(idx);
%             end
%             last=zeroIdxs(idx);
%         end
%         delta= linspace(correctedPosition(start-1),correctedPosition(last+1),last-start+1);
%         correctedPosition(start:last) = delta;
%     end
% 
%     %% IIb. Use a median filter -- this is a simple way to eliminate big jumps
%     % it's not perfect, but it works surprisingly well with few distortions
%     % of the data. This will lag real teleports by fractions of a second
%     %
%     % note : median filtering seems to work well on quantized values. it
%     % seems to introduce undesireable things to continuous valued data.
%     %
%     for ii = (smoothFactor+1):length(correctedPosition)-(smoothFactor+1)
%         correctedPosition(ii) = median(correctedPosition(ii-smoothFactor:ii+smoothFactor));
%     end
%      
%      vv=velocity;
%     for ii = (smoothFactor+1):length(correctedPosition)-(smoothFactor+1)
%         correctedPosition(ii) = median(correctedPosition(ii-smoothFactor:ii+smoothFactor));
%     end
%     for ii = (smoothFactor+1):length(velocity)-(smoothFactor+1)
%         vv(ii) = median(velocity(ii-smoothFactor:ii+smoothFactor));
%     end
%     accelLimit = 12;
%     accel = [0; diff(velocity)];
    
    
    
    %% IV. Filter to smooth
    % seems to reduce all the values, which is less than desireable
    % equivalent to "zooming out" I suppose?
    if runFilter
        xyFilter = designfilt( 'lowpassiir',                     ...
                             'FilterOrder',              8  , ...
                             'PassbandFrequency',        2  , ...
                             'PassbandRipple',           0.2, ...
                             'SampleRate',              30);
        correctedPosition = filtfilt( xyFilter, correctedPosition);
    end
    %% catch any weirdness that may have been introduced.
    if sum( correctedPosition < 1 )
        correctedPosition(find(correctedPosition < 1 ))=1;
        warning('some positions corrected out of minimum range. These have been replaced with 1.');
    end
    if sum( correctedPosition > 720 ) % lazy...
        correctedPosition(find(correctedPosition > 720 ))=1;
        warning('some positions corrected out of maximum range. These have been replaced with 720.');
    end
    
    return;
end