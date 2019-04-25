%% all of this code is terrible cut-n-paste spaghetti. don't judge.



metadata.rat='da10';
metadata.day = '2017-09-20_/train/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ xpos, ypos, xytimestamps ] = nvt2mat([ dir 'VT0.nvt']);
[ xpos, ypos ] = nlxPositionFixer( xpos, ypos );
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
figure; plot(xpos,ypos); axis([0 720 0 480])
hold on;scatter(330,233,'ro')
% length : start arm 
sqrt((330-90)^2+(233-438)^2)
% length : error arm 
sqrt((330-558)^2+(233-459)^2)
% length : reward arm 
sqrt((330-128)^2+(233-50)^2)

afm=[ 1 0 .3; 0 1 0; 0 0 1];


afm=[.93527 -.13043 75; 0.06289 0.88380 -18.000; 0.00006 -0.00018 1.0000]; % from gimp

I = imread('pout.tif');
I = imread('~/Desktop/unwarpme.png');
IF = imread('~/Desktop/unwarpmeFixed.png');
[]=cpselect('~/Desktop/unwarpme.png','~/Desktop/unwarpmeFixed.png')
t_concord = fitgeotrans(fixedPoints,movingPoints,'projective');
registered = imwarp(I,t_concord);

figure, imshowpair(registered,ortho,'blend')

theta = 0; %135;
tm = [cosd(theta) -sind(theta) -0.0001; ...
    sind(theta) cosd(theta) -0.0001; ...
    0 0 1];
tform = projective2d(tm);

afm=[1 0 18/1e5; ...
    0 1 -75/1e5; ...
    0 -0 1.0000]; % from gimp
tform = projective2d(afm);
outputImage = imwarp(I,tform);
%figure;
subplot(1,2,1); imshow(I);
subplot(1,2,2); imshow(outputImage);
subplot(1,2,2); imshow(registered);




cb = checkerboard(4,2);
cb_ref = imref2d(size(cb));
background = zeros(150);
figure;
imshowpair(cb,cb_ref,background,imref2d(size(background)))
aform_t = projective2d(afm);
[out] = imwarp(cb,aform_t);


T = [1 0 0;0 1 0;100 0 1];
tform_t = affine2d(T);
R = [cosd(30) sind(30) 0;-sind(30) cosd(30) 0;0 0 1];
tform_r = affine2d(R);
TR = T*R;
tform_tr = affine2d(TR);
[out,out_ref] = imwarp(cb,cb_ref,tform_tr);
imshowpair(out,out_ref,background,imref2d(size(background)))



%clear all; close all;

% List of Things TO DO
% X measure distance to reward
% X accumulate distance to reward
% X accumulate speed prior to movement
% X accumulate which rat, day, trial
%
% accumulate SWR LFP envelope
% accumulate Theta LFP envelope
% 
% sharp wave spatial distribution
% stillness spatial distribution
% confirm the rat numbers
%
%

recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %
rat='da5';
pxPerCm = mean([(288/106) (225/100) (255/106) (255/106)]);
for ii=1:length(recDays)
    speedColorPlot(  aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos, pxPerCm );
    caxis([-3 97])
    xlim([50 750]);
    ylim([-100 600]);
    axis square;
    print( [ '~/Desktop/' rat '_' (recDays{ii}) '_speedColor_max87.png'],'-dpng','-r200');
    pause(.2);
    close;
end

recDays = { 'sept11'  'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' }; % 
rat='da10';
pxPerCm = mean([(276/100) (269/100) (306/106) (335/106)]);
for ii=1:length(recDays)
    speedColorPlot(  agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, pxPerCm );
    caxis([-3 97])
    xlim([0 800]);
    ylim([0 800]);
    axis square;
    print( [ '~/Desktop/' rat '_' (recDays{ii}) '_speedColor_max87.png'],'-dpng','-r200');
    pause(.2);
    close;
end

recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  };
rat='da12';
pxPerCm = mean([(315/100) (300/100) (310/106) (275/106)]);
for ii=1:length(recDays)
    speedColorPlot(  aggda12.(recDays{ii}).xpos, aggda12.(recDays{ii}).ypos, pxPerCm );
    caxis([-3 97])
    xlim([0 700]);
    ylim([150 850]);
    axis square;
    print( [ '~/Desktop/' rat '_' (recDays{ii}) '_speedColor_max87.png'],'-dpng','-r200');
    pause(.2);
    close;
end



    
    
    for jj=1:length(aggda5.(recDays{ii}).trial)
    speed=calculateSpeed( aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos, 1, 2.7, 29.97 );

        stillness = zeros(size(speed));
        medianSpeed = zeros(size(speed));
        % build a moving boxcar that handles edge cases
            for jj=1:45
                medianSpeed(jj) = median(speed(1:jj));
                if median(speed(1:jj)) < 6
                    stillness(jj) = 1;
                else
                    stillness(jj) = 0;
                end
            end
            for jj=46:length(speed)-46
                medianSpeed(jj) = median(speed(jj-45:jj+45));
                if median(speed(jj-45:jj+45)) < 6
                    stillness(jj) = 1; 
                else
                    stillness(jj) = 0;
                end
            end
            for jj=length(speed)-46:length(speed)
                medianSpeed(jj) = median(speed(jj:end));
                if median(speed(jj:end)) < 6
                    stillness(jj) = 1;
                else
                    stillness(jj) = 0;
                end
            end

    speedColorPlot(  aggda5.aug25.xpos, aggda5.aug25.ypos, 2.7, stillness );

mvdir=calculateDirection(  aggda5.aug25.xpos, aggda5.aug25.ypos);
    
        x = aggda5.aug25.xpos;
        y = aggda5.aug25.ypos;
        z = zeros(size(x));
        figure;
        h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [mvdir(:), mvdir(:)], ...
                     'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
        colormap( build_NOAA_colorgradient ); colorbar;
        title('place by speed plot');


        mvdir=calculateDirection(  aggda5.aug25.xpos, aggda5.aug25.ypos);
        x = aggda5.aug25.xpos;
        y = aggda5.aug25.ypos;
        z = zeros(size(x));
        figure;
        h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [mvdir(:), mvdir(:)], ...
                     'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
        colormap( buildCircularGradient ); colorbar; caxis([-180 180]);
        title('place by direction plot');  
        
        
        
return;        
        
        
    perTrial(ii).stillness = stillness;
    % now find 3+s periods
    startIdx = 1; % when did the period start
    endIdx = 1;   % when did the period end
    inAnEpisode = 0; % are we currently tracking an episode of stillness
    endIdxList = []; % list of >3s stillness period *ends*
    for jj = 1:length(stillness)
        if ( inAnEpisode == 0 ) && ( stillness(jj) == 1 )
            inAnEpisode = 1;
            startIdx = jj;
        elseif ( inAnEpisode == 1 ) && ( stillness(jj) == 0 )
            inAnEpisode = 0;
            endIdx = jj-1;
            if (endIdx-startIdx) > 89
                endIdxList = [ endIdxList endIdx ];
            end
        end
    end
    % track how many 
    goodEpisodesFound(ii) = length(endIdxList);
    perTrial(ii).endIdxList = endIdxList;
end







%% DA5
%load('~/src/MATLAB/defaultFolder/aggDa5NewLess.mat');
recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %
% over days, how does sharp wave ripple production vary while the rat is on the maze?
% construct the needed data structure
rat='da5';
clear perTrial;
trialIdx=0;
for ii=1:length(recDays)
    for jj=1:length(aggda5.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat = rat;
        perTrial(trialIdx).day      = ii-1;
        try
            perTrial(trialIdx).trial    = aggda5.(recDays{ii}).trial(jj);
        catch
            perTrial(trialIdx).trial    = -1;
        end
%         if jj>1
%             startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %startIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).trialStartAction(jj) ) , 1 );
                % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( ( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).firstArmEndReached(jj) ) , 1 ); 
        %endIdx = find( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = find( aggda5.(recDays{ii}).xytimestampSeconds > aggda5.(recDays{ii}).leaveMazeToBucket(jj), 1 );
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;  % added 1 s extra to prevent problems later
        perTrial(trialIdx).xpos     = aggda5.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = aggda5.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = aggda5.(recDays{ii}).xyspeed(xyIdxs);
        perTrial(trialIdx).instantSpeed    = aggda5.(recDays{ii}).instantSpeed(xyIdxs);
        perTrial(trialIdx).lagSpeed    = aggda5.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = aggda5.(recDays{ii}).xylinearized(xyIdxs);  
        %
        perTrial(trialIdx).proxToReward     = aggda5.(recDays{ii}).proxToReward(xyIdxs);
        %
        perTrial(trialIdx).xytimestampSeconds = aggda5.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( aggda5.(recDays{ii}).swrTimes > aggda5.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( aggda5.(recDays{ii}).swrTimes < aggda5.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes         = aggda5.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos          = aggda5.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos          = aggda5.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized    = aggda5.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed         = aggda5.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = aggda5.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed  = aggda5.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial       = aggda5.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error            = aggda5.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds      = aggda5.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe            = aggda5.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline          = aggda5.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed    = aggda5.(recDays{ii}).sugarConsumed(jj);
        %perTrial(trialIdx).wasTeleported   = aggda5.(recDays{ii}).wasTeleported(jj);
        perTrial(trialIdx).explore          = aggda5.(recDays{ii}).explore(jj);
        perTrial(trialIdx).centerExplore    = aggda5.(recDays{ii}).centerExplore(jj);

        tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
        perTrial(trialIdx).swrEnv = aggda5.(recDays{ii}).swrEnv(tempIdxs);
        tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
        perTrial(trialIdx).thetaEnv = aggda5.(recDays{ii}).thetaEnv(tempIdxs);
    end
end


%% DA10
%load('~/src/MATLAB/defaultFolder/aggDa10NewLess.mat');
recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
rat='da10';
for ii=1:length(recDays)
    for jj=1:length(agg.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat      = rat;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = agg.(recDays{ii}).trial(jj);
%         if jj>1
%             %startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %startIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialStartAction(jj) ) , 1 );
        % %%  leaveBucketToMaze trialStartAction trialCompleted leaveMazeToBucket
        %endIdx = find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).firstEndArmReached(jj) ) , 1 );
        %endIdx = find( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).trialCompleted(jj), 1 );
        endIdx = 16+find( ( agg.(recDays{ii}).xytimestampSeconds > agg.(recDays{ii}).leaveMazeToBucket(jj) ) , 1 );
        %
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;
        perTrial(trialIdx).xpos     = agg.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = agg.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = agg.(recDays{ii}).xyspeed(xyIdxs);
        perTrial(trialIdx).instantSpeed    = agg.(recDays{ii}).instantSpeed(xyIdxs);
        perTrial(trialIdx).lagSpeed    = agg.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).proxToReward     = agg.(recDays{ii}).proxToReward(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = agg.(recDays{ii}).xylinearized(xyIdxs);  
        %
        perTrial(trialIdx).xytimestampSeconds = agg.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( agg.(recDays{ii}).swrTimes > agg.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( agg.(recDays{ii}).swrTimes < agg.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes      = agg.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos       = agg.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos       = agg.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized = agg.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed      = agg.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed     = agg.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed = agg.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial    = agg.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error         = agg.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds   = agg.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe         = agg.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline       = agg.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed = agg.(recDays{ii}).sugarConsumed(jj);
        perTrial(trialIdx).wasTeleported = agg.(recDays{ii}).wasTeleported(jj);
        perTrial(trialIdx).explore       = agg.(recDays{ii}).explore(jj);
        perTrial(trialIdx).centerExplore = agg.(recDays{ii}).centerExplore(jj);

        tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
        perTrial(trialIdx).swrEnv = agg.(recDays{ii}).swrEnv(tempIdxs);
        tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
        perTrial(trialIdx).thetaEnv = agg.(recDays{ii}).thetaEnv(tempIdxs);
    end
end


%% DA 12
%load('~/src/MATLAB/defaultFolder/aggDa12NewLess.mat');
recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  };
rat='da12';
for ii=1:length(recDays)
    for jj=1:length(aggda12.(recDays{ii}).trial)
        %disp( [ num2str(ii) ' . ' num2str(jj) ]);
        trialIdx=trialIdx+1;
        perTrial(trialIdx).rat=rat;
        perTrial(trialIdx).day      = ii-1;
        perTrial(trialIdx).trial    = aggda12.(recDays{ii}).trial(jj);
%         if jj>1
%             startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveMazeToBucket(jj-1) ) , 1 );
%         else
%             startIdx=1;
%         end
        startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveBucketToMaze(jj) ) , 1 );
        %startIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).trialStartAction(jj) ) , 1 );
        % leaveBucketToMaze trialStartAction sugarConsumeTimes leaveMazeToBucket
        %endIdx = find( ( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).firstEndArmReached(jj) ) , 1 );
        %endIdx = find( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).sugarConsumeTimes(jj), 1 );
        endIdx = 30+find( aggda12.(recDays{ii}).xytimestampSeconds > aggda12.(recDays{ii}).leaveMazeToBucket(jj), 1 );
        % endIdx = startIdx + (20*30);
        disp([ num2str((endIdx-startIdx)./29.97) ' s'])
        xyIdxs  = startIdx:endIdx;
        perTrial(trialIdx).xpos     = aggda12.(recDays{ii}).xpos(xyIdxs);
        perTrial(trialIdx).ypos     = aggda12.(recDays{ii}).ypos(xyIdxs);
        %
        perTrial(trialIdx).speed    = aggda12.(recDays{ii}).xyspeed(xyIdxs);
        perTrial(trialIdx).instantSpeed    = aggda12.(recDays{ii}).instantSpeed(xyIdxs);
        perTrial(trialIdx).lagSpeed    = aggda12.(recDays{ii}).lagSpeed(xyIdxs);
        %
        perTrial(trialIdx).proxToReward     = aggda12.(recDays{ii}).proxToReward(xyIdxs);
        %
        perTrial(trialIdx).xylinearized = aggda12.(recDays{ii}).xylinearized(xyIdxs);  
        %
        perTrial(trialIdx).xytimestampSeconds = aggda12.(recDays{ii}).xytimestampSeconds(xyIdxs);
        swrIdxs = find( ( aggda12.(recDays{ii}).swrTimes > aggda12.(recDays{ii}).xytimestampSeconds(startIdx) ) .* ( aggda12.(recDays{ii}).swrTimes < aggda12.(recDays{ii}).xytimestampSeconds(endIdx) ) );
        perTrial(trialIdx).swrTimes         = aggda12.(recDays{ii}).swrTimes(swrIdxs);
        perTrial(trialIdx).swrXpos          = aggda12.(recDays{ii}).swrXpos(swrIdxs);
        perTrial(trialIdx).swrYpos          = aggda12.(recDays{ii}).swrYpos(swrIdxs);
        perTrial(trialIdx).swrLinearized    = aggda12.(recDays{ii}).swrxylinearized(swrIdxs);
        perTrial(trialIdx).swrSpeed         = aggda12.(recDays{ii}).swrSpeed(swrIdxs);
        perTrial(trialIdx).swrLagSpeed      = aggda12.(recDays{ii}).swrLagSpeed(swrIdxs);
        perTrial(trialIdx).swrInstantSpeed  = aggda12.(recDays{ii}).swrInstantSpeed(swrIdxs);
        perTrial(trialIdx).isSubTrial       = 0;% aggda12.(recDays{ii}).isSubTrial(jj);
        perTrial(trialIdx).error            = aggda12.(recDays{ii}).error(jj);
        perTrial(trialIdx).outOfBounds      = aggda12.(recDays{ii}).outOfBounds(jj);
        perTrial(trialIdx).probe            = aggda12.(recDays{ii}).probe(jj);
        perTrial(trialIdx).beeline          = 0; % aggda12.(recDays{ii}).beeline(jj);
        perTrial(trialIdx).sugarConsumed    = aggda12.(recDays{ii}).sugarConsumed(jj);
        perTrial(trialIdx).explore          = aggda12.(recDays{ii}).explore(jj);
        %perTrial(trialIdx).wasTeleported   = aggda12.(recDays{ii}).wasTeleported(jj);
        perTrial(trialIdx).centerExplore    = aggda12.(recDays{ii}).centerExplore(jj);

        tempIdxs = floor(startIdx*2000/29.97)+1:floor(endIdx*2000/29.97)+1;
        perTrial(trialIdx).swrEnv = aggda12.(recDays{ii}).swrEnv(tempIdxs);
        tempIdxs = floor(startIdx*250/29.97)+1:floor(endIdx*250/29.97)+1;
        perTrial(trialIdx).thetaEnv = aggda12.(recDays{ii}).thetaEnv(tempIdxs);
    end
end

figure; 
for ii=1:length(perTrial) ;
    figure;
    speedColorPlot(perTrial(ii).xpos,perTrial(ii).ypos,2.6);
    caxis([-3 97])
    xlim([0 900]);
    ylim([-100 800]);
    axis square;
    print( [ '~/Desktop/' perTrial(ii).rat '_d' num2str(perTrial(ii).day) '_t' num2str(perTrial(ii).trial) '_ptIdx-' num2str(ii) '_speedColor.png'],'-dpng','-r200');
    pause(.1);
    close;
end



figure; speedColorPlot(agg.sept18.xpos, agg.sept18.ypos,2.6);

line( [ median(agg.sept18.xpos) median(agg.sept18.xpos)],[ -100 900 ])
agg.sept18.ypos



return;


% everything is in trials, so we know we are ignoring bucket and rest
% periods
goodEpisodesFound = zeros(1, length(perTrial) );
for ii=1:length(perTrial)
    stillness = zeros(size(perTrial(ii).speed));
    % built a moving boxcar that handles edge cases
    if length(perTrial(ii).speed)>46
        for jj=1:45
            if median(perTrial(ii).speed(1:jj)) < 6
                stillness(jj) = 1;
            end
        end
        for jj=46:length(perTrial(ii).speed)-46
            if median(perTrial(ii).speed(jj-45:jj+45)) < 6
                stillness(jj) = 1;
            end
        end
        for jj=length(perTrial(ii).speed)-46:length(perTrial(ii).speed)
            if median(perTrial(ii).speed(jj:end)) < 6
                stillness(jj) = 1;
            end
        end
    else
        disp('skipped a short trial');
    end
    perTrial(ii).stillness = stillness;
    % now find 3+s periods
    startIdx = 1; % when did the period start
    endIdx = 1;   % when did the period end
    inAnEpisode = 0; % are we currently tracking an episode of stillness
    endIdxList = []; % list of >3s stillness period *ends*
    for jj = 1:length(stillness)
        if ( inAnEpisode == 0 ) && ( stillness(jj) == 1 )
            inAnEpisode = 1;
            startIdx = jj;
        elseif ( inAnEpisode == 1 ) && ( stillness(jj) == 0 )
            inAnEpisode = 0;
            endIdx = jj-1;
            if (endIdx-startIdx) > 89
                endIdxList = [ endIdxList endIdx ];
            end
        end
    end
    % track how many 
    goodEpisodesFound(ii) = length(endIdxList);
    perTrial(ii).endIdxList = endIdxList;
end


swrEvents=zeros( 90 , sum(goodEpisodesFound));
speedDist=zeros( 180 , sum(goodEpisodesFound));
swrEventsPost=zeros( 90 , sum(goodEpisodesFound));
speedDistPre=zeros( 180 , sum(goodEpisodesFound));
proxToReward=zeros( 180 , sum(goodEpisodesFound));
%proxToRewardPre=zeros( 90 , sum(goodEpisodesFound));
%proxToRewardPost=zeros( 90 , sum(goodEpisodesFound));
xpos = zeros( 180 , sum(goodEpisodesFound));
ypos = zeros( 180 , sum(goodEpisodesFound));
%
% swrEnvPre=zeros( 3*2000 , sum(goodEpisodesFound));
% swrEnvPost=zeros( 3*2000 , sum(goodEpisodesFound));
% thetaEnvPre=zeros( 3*250 , sum(goodEpisodesFound));
% thetaEnvPost=zeros( 3*250 , sum(goodEpisodesFound));
%
timeToBucket = zeros(  1 , sum(goodEpisodesFound));
timeSinceBucket = zeros(  1 , sum(goodEpisodesFound));
err=zeros(  1 , sum(goodEpisodesFound));
oob=zeros(  1 , sum(goodEpisodesFound));
prb=zeros(  1 , sum(goodEpisodesFound));
code=zeros(  1 , sum(goodEpisodesFound));
ratNum=zeros(  1 , sum(goodEpisodesFound));
day=zeros(  1 , sum(goodEpisodesFound));
trial=zeros(  1 , sum(goodEpisodesFound));
currentEpisode = 1;
for currentTrial = 1:length(perTrial)
    for stillEpisode = 1:goodEpisodesFound(currentTrial)
        if ( perTrial(currentTrial).endIdxList(stillEpisode)+89 < length(perTrial(currentTrial).speed) ) % && ( floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1+749 < length(perTrial(currentTrial).thetaEnv) ) &&( floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1+5999 < length(perTrial(currentTrial).swrEnv) )
            %disp('loop start')
            speedDist(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
            %speedDistPre(:,currentEpisode) = perTrial(currentTrial).speed(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
            %
            proxToReward(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
            %proxToRewardPost(:,currentEpisode) = perTrial(currentTrial).proxToReward(perTrial(currentTrial).endIdxList(stillEpisode)-89:perTrial(currentTrial).endIdxList(stillEpisode));
            %
%             %disp('before swr')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*2000/29.97)+1;
%             swrEnvPre( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx-5999:tIdx);
%             swrEnvPost( : , currentEpisode)=perTrial(currentTrial).swrEnv(tIdx:tIdx+5999);
%             %disp('before theta')
%             tIdx = floor(perTrial(currentTrial).endIdxList(stillEpisode)*250/29.97)+1;
%             thetaEnvPre( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx-749:tIdx);
%             thetaEnvPost( : , currentEpisode)=perTrial(currentTrial).thetaEnv(tIdx:tIdx+749);
            %
            %disp('after lfps');
            endTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
            startTime = endTime-3;
            swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
            tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
            swrEvents( tempIdxs, currentEpisode ) = 1;
            %
            % where is the rat
            xpos(:,currentEpisode) = perTrial(currentTrial).xpos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
            ypos(:,currentEpisode) = perTrial(currentTrial).ypos(perTrial(currentTrial).endIdxList(stillEpisode)-90:perTrial(currentTrial).endIdxList(stillEpisode)+89);
            %
            %disp('after swrEvents')
            startTime = perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
            endTime = startTime+3;
            swrTimeList = perTrial(currentTrial).swrTimes(find( (perTrial(currentTrial).swrTimes>startTime).*(perTrial(currentTrial).swrTimes<=endTime) ));
            tempIdxs = floor((swrTimeList-startTime)*29.97)+1;
            swrEventsPost( tempIdxs, currentEpisode ) = 1;
            %disp('after swrEventsPost')
            %
            ratNum(currentEpisode) = str2num(strrep( perTrial(currentTrial).rat ,'da','') );
            day(currentEpisode)    = perTrial(currentTrial).day;
            trial(currentEpisode)  = perTrial(currentTrial).trial;
            %
            % report how much time remains until the trial ends
            % this will measure from the end of the stillness/start of the motion
            timeToBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(end) - perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode));
            timeSinceBucket(currentEpisode)= perTrial(currentTrial).xytimestampSeconds(perTrial(currentTrial).endIdxList(stillEpisode)) - perTrial(currentTrial).xytimestampSeconds(1);
            %
            err(currentEpisode)= perTrial(currentTrial).error;
            oob(currentEpisode)= perTrial(currentTrial).outOfBounds;
            prb(currentEpisode)= perTrial(currentTrial).probe;
            code(currentEpisode)= perTrial(currentTrial).error + 2*perTrial(currentTrial).outOfBounds + 4*perTrial(currentTrial).probe;
            %
            currentEpisode = currentEpisode + 1;
        else
            disp('skipping because exceeds end of trial')
        end
        
    end
end
% this will end up skipping episodes at the very end, so just save the
% non-zero episode
swrEvents=swrEvents( : , 1:currentEpisode-1 );
speedDist=speedDist( : , 1:currentEpisode-1 )';
swrEventsPost=swrEventsPost(:, 1:currentEpisode-1);
speedDistPre=speedDistPre(:, 1:currentEpisode-1)';
err=err(1:currentEpisode-1);
oob=oob(1:currentEpisode-1);
prb=prb(1:currentEpisode-1);
code=code(1:currentEpisode-1);
ratNum=ratNum(1:currentEpisode-1);
day=day(1:currentEpisode-1);
trial=trial(1:currentEpisode-1);
xpos=xpos( : , 1:currentEpisode-1 );
ypos=ypos( : , 1:currentEpisode-1 );
timeToBucket=timeToBucket(1:currentEpisode-1);
timeSinceBucket=timeSinceBucket(1:currentEpisode-1);
proxToReward=proxToReward(:, 1:currentEpisode-1);

% swrEnvPre=swrEnvPre(:,1:currentEpisode-1);
% swrEnvPost=swrEnvPost(:,1:currentEpisode-1);
% thetaEnvPre=thetaEnvPre(:,1:currentEpisode-1);
% thetaEnvPost=thetaEnvPost(:,1:currentEpisode-1);

%proxToRewardPre=proxToRewardPre(:, 1:currentEpisode-1);
%proxToRewardPost=proxToRewardPost(:,1:currentEpisode-1);


figure;hold on;
for ii=1:length(good)
    if ratNum(good(ii))==5
        subplot(2,2,1); hold on;
    elseif ratNum(good(ii))==10
        subplot(2,2,2); hold on;
    elseif ratNum(good(ii))==12
        subplot(2,2,3); hold on;
    end
    speedColorPlot(xpos(:,good(ii)),ypos(:,good(ii)),2.5)
end

subplot(2,2,1); title('da5');
subplot(2,2,2); title('da10');
subplot(2,2,3); title('da12');


figure;
subplot(2,1,1); histogram(timeSinceBucket(good), 0:30:90*10);
subplot(2,1,2); histogram(timeToBucket(good), 0:30:90*10);


saturdayData.swrEvents=swrEvents;
saturdayData.speedDist=speedDist;
saturdayData.swrEventsPost=swrEventsPost;
saturdayData.speedDistPre=speedDistPre;
saturdayData.err=err;
saturdayData.oob=oob;
saturdayData.prb=prb;
saturdayData.code=code;
saturdayData.ratNum=ratNum;
saturdayData.day=day;
saturdayData.trial=trial;
saturdayData.proxToReward=proxToReward;
% saturdayData.proxToRewardPre=proxToRewardPre;
% saturdayData.proxToRewardPost=proxToRewardPost;
saturdayData.xpos=xpos;
saturdayData.ypos=ypos;
saturdayData.proxToReward=proxToReward;
saturdayData.timeToBucket=timeToBucket;
saturdayData.timeSinceBucket=timeSinceBucket;


saturdayData.swrEnvPre=swrEnvPre;
saturdayData.swrEnvPost=swrEnvPost;
saturdayData.thetaEnvPre=thetaEnvPre;
saturdayData.thetaEnvPost=thetaEnvPost;


saturdayData.swrEnvPre=[];
saturdayData.swrEnvPost=[];
saturdayData.thetaEnvPre=[];
saturdayData.thetaEnvPost=[];







speedDist=speedDist';
[~,ii]=sort(median(speedDist(:,61:90),2));
figure;
subplot(3,2,2); imagesc(speedDist(ii,:)); colorbar; caxis([0 70])
subplot(3,2,1); imagesc(speedDistPre(ii,:)); caxis([0 70])
subplot(3,2,3); imagesc(thetaEnvPre(:,ii)');caxis([0 1]);
subplot(3,2,4); imagesc(thetaEnvPost(:,ii)');caxis([0 1]);colorbar;
subplot(3,2,5); imagesc(swrEnvPre(:,ii)');caxis([0 .35]);
subplot(3,2,6); imagesc(swrEnvPost(:,ii)');caxis([0 .35]);colorbar;


figure;[~,ii]=sort(median(speedDist(:,1:45),2)); imagesc([speedDistPre(ii,:) speedDist(ii,:) ]); colorbar; caxis([0 70])
%figure;
subplot(1,2,1); imagesc(speedDistPre(ii,:)); caxis([0 20])
subplot(1,2,2); imagesc(speedDist(ii,:)); colorbar; caxis([0 70])


figure;
subplot(2,2,1); imagesc(speedDistPre(ii,:)); caxis([0 70])
subplot(2,2,2); imagesc(speedDist(ii,:)); colorbar; caxis([0 70])
subplot(2,2,3); imagesc(thetaEnvPre(:,ii)');caxis([0 1]);
subplot(2,2,4); imagesc(thetaEnvPost(:,ii)');caxis([0 1]);colorbar;

figure;
subplot(2,2,1); imagesc(speedDistPre(ii,:)); caxis([0 70])
subplot(2,2,2); imagesc(speedDist(ii,:)); colorbar; caxis([0 70])
subplot(2,2,3); imagesc(swrEnvPre(:,ii)');caxis([0 .35]);
subplot(2,2,4); imagesc(swrEnvPost(:,ii)');caxis([0 .35]);colorbar;






saturdayData.swrEvents = swrEvents;
saturdayData.speedDist = speedDist;
saturdayData.error = err;
saturdayData.outOfBounds = oob;
saturdayData.probe = prb;
saturdayData.behviorCode = code;



figure; hold on; kk=(rand(1,length(code))/1.2)+.1; ll=+(rand(1,length(code))/1.2)+.1; scatter( sum(swrEvents,1)+kk, code+ll,'o', 'filled' ); alpha(.1); scatter( sum(swrEvents,1)+kk, code+ll,'k.' );  ylabel('code'); xlabel('swr events (count)');
line([1 1],[0 6], 'Color', [.8 .8 .8]);
line([2 2],[0 6], 'Color', [.8 .8 .8]);
line([3 3],[0 6], 'Color', [.8 .8 .8]);
line([4 4],[0 6], 'Color', [.8 .8 .8]);
line([5 5],[0 6], 'Color', [.8 .8 .8]);
line([6 6],[0 6], 'Color', [.8 .8 .8]);
line([7 7],[0 6], 'Color', [.8 .8 .8]);
line([0 8],[1 1], 'Color', [.8 .8 .8]);
line([0 8],[2 2], 'Color', [.8 .8 .8]);
line([0 8],[3 3], 'Color', [.8 .8 .8]);
line([0 8],[4 4], 'Color', [.8 .8 .8]);
line([0 8],[5 5], 'Color', [.8 .8 .8]);








figure; plot(sum(swrEvents,2)); title(''); xlabel('samples prior to movement initiated (1s/30)'); ylabel('swr events (count)');
aa=sum(swrEvents,2);
swrCount(1) = sum(aa(1:15)); swrCount(2) = sum(aa(16:30)); swrCount(3) = sum(aa(31:45)); swrCount(4) = sum(aa(46:60)); swrCount(5) = sum(aa(61:75)); swrCount(6) = sum(aa(76:90));
hold on; plot( (15:15:90)-7 , swrCount/15, '*'); legend('each sample','.5 s bins');

figure; histogram(sum(swrEvents,1),-1:9); title(''); xlabel('swr events prior to movement initiated (count)'); ylabel('frequency (count)');

figure; hold on; for ii=1:length(speedDist); scatter(sum(swrEvents(:,ii)), mean((speedDist(:,ii))),'k','filled'); end; alpha(.1); xlabel('swr events (3s prior)'); ylabel('median speed (cm/s)');

figure; hold on; for ii=1:length(speedDist); scatter( 1:90, speedDist(:,ii), 'o', 'filled' ); end; alpha(.01); title(''); ylabel('speed (cm/s)'); xlabel('samples after movement initiated (1s/30)');
figure; hold on; for ii=1:length(speedDist); scatter( 1:90, speedDist(:,ii), '.' ); end; alpha(.01); title(''); ylabel('speed (cm/s)'); xlabel('samples after movement initiated (1s/30)');




eventsPriorToMotion = sum(swrEvents,1);
mean(eventsPriorToMotion( mean(speedDist) < 20 ))
var(eventsPriorToMotion( mean(speedDist) < 20 ))
mean(eventsPriorToMotion( find( (mean(speedDist) >= 20).*(mean(speedDist) < 50) )))
var(eventsPriorToMotion( find( (mean(speedDist) >= 20).*(mean(speedDist) < 50) )))

figure;
[ff,bb]=histcounts( (eventsPriorToMotion( mean(speedDist) < 20 )),0:8); ff./sum(ff);
subplot(1,2,1); hold on; plot(0:7,ff./sum(ff)); plot(0:7, poisspdf(0:7,mean(eventsPriorToMotion( mean(speedDist) < 20 ))));
title('data vs. poisson estimation, slow'); xlabel('swr events (3s prior)'); ylabel('probability of event'); legend('data','fit pdf'); xlim([-1 8]); ylim([0 .5])
[ff,bb]=histcounts( (eventsPriorToMotion( find( (mean(speedDist) >= 20).*(mean(speedDist) < 50) ))),0:8); ff./sum(ff);
subplot(1,2,2); hold on; plot(0:7,ff./sum(ff)); plot(0:7, poisspdf(0:7,mean(eventsPriorToMotion( ( find( (mean(speedDist) >= 20).*(mean(speedDist) < 50) ))))));
title('data vs. poisson estimation, fast'); xlabel('swr events (3s prior)'); ylabel('probability of event'); legend('data','fit pdf'); xlim([-1 8]); ylim([0 .5])



fitdist((eventsPriorToMotion( find( (mean(speedDist) >= 20).*(mean(speedDist) < 50) )))','Poisson');






%% Tad stuff
figure; hold on; 

for ii=1:length(speedDist);
    swrnum(ii)=sum(swrEvents(:,ii));
    meanspd(ii)=mean(speedDist(:,ii));
    scatter(sum(swrEvents(:,ii)), mean((speedDist(:,ii))),'k','filled');
end
alpha(.1); xlabel('swr events (3s prior)'); ylabel('median speed (cm/s)');

slow=find(meanspd<20);
fast=find(meanspd>=20 & meanspd<50);

figure(5); clf;
histogram(meanspd,0:5:120);

figure(10);
subplot(2,1,1); slowswr=histogram(swrnum(slow));
subplot(2,1,2); 
fastswr=histogram(swrnum(fast));

slowpd=fitdist(swrnum(slow)','Poisson');
fastpd=fitdist(swrnum(fast)','Poisson');

for i=1:1000
    temp=sortrows([rand(1,length(meanspd)); swrnum]',1);
    temppd=fitdist(temp(1:length(fast),2),'Poisson');
    lambda(i)=temppd.lambda;
end

figure(6); clf; histogram(lambda,.5:.1:1.5);
c=find(lambda>fastpd.lambda);

length(c)/1000 %show significance for shuffle test

%%






 

spd=calculateSpeed( agg.sept15.xpos,agg.sept15.ypos, 1, 2.7, 29.97 );
still=zeros(size(spd));
for ii=46:length(spd)-46
    if median(spd(ii-45:ii+45)) < 6
        still(ii) = 1;
    end
end
figure; hold on; plot( agg.sept15.xytimestampSeconds, spd ); plot( agg.sept15.xytimestampSeconds, still ); 
plot( agg.sept15.xytimestampSeconds, .5*(spd<6) ); 
 detectorOutput = detectPeaksEdges( spd, agg.sept15.xytimestampSeconds, 29.97, 90, 6, 3, 7 );
figure; hold on; plot( agg.sept15.xytimestampSeconds, spd ); 
scatter( agg.sept15.xytimestampSeconds(detectorOutput.EpisodeStartIdxs), spd(detectorOutput.EpisodeStartIdxs), '<', 'filled');
scatter( agg.sept15.xytimestampSeconds(detectorOutput.EpisodeEndIdxs), spd(detectorOutput.EpisodeEndIdxs), '>', 'filled');






% 
% % 600 px / 218 cm  => 2.75
% binSize = 20; %cm    % 55 px
% %bins = [ -100 6 26 46 66 86 111 129 131 149 170 190 210 230 240 255 270 290 310 330 350 360 375 385 398 420 440 460 480 500 520 1000 ];
% bins = [ -100 -15            115 129 131 155                  289    292                         410 430                 560 580 1000 ];
% %bins = [ -100 -15 20 40 60 80 100 115 129 131 155 175 195 215 235 255 275 289    292  312 332 352 372 392  410 430  450 470 490 510 530 550   560 580 1000 ];
% binCenters = (bins(1:end-1))+diff(bins)/2;
% occupancyAll=[];
% swrAll=[];
% swrRateAll=[];
% bee=[]; err=[]; oob=[];
% trialSwr=[];
% trialOcc=[];
% avgVel = [];
% probe = [];
% explore = [];
% centerExplore = [];
% rat=[];
% for ii=1:length(perTrial)
%     freqOcc=histcounts( perTrial(ii).xylinearized, bins );
%     freqOcc = freqOcc/29.97; % convert occupany to seconds, instead of accumulated pixels
%     occupancyAll = [ occupancyAll ; freqOcc ];
%     freqSwr=histcounts( perTrial(ii).swrLinearized, bins );
%     swrAll = [ swrAll ; freqSwr ];
%     tIdxs = find(freqOcc);
%     tResult = freqSwr(tIdxs)./freqOcc(tIdxs);
%     freqSwr(tIdxs) = tResult;
%     swrRateAll = [ swrRateAll ; freqSwr ];
%     bee = [ bee perTrial(ii).beeline ];
%     oob = [ oob perTrial(ii).outOfBounds ];
%     err = [ err perTrial(ii).error ];
%     probe = [ probe perTrial(ii).probe ];
%     trialSwr = [ trialSwr sum(freqSwr) ];
%     trialOcc = [ trialOcc sum(freqOcc) ];
%     avgVel= [ avgVel median(perTrial(ii).speed) / (length(perTrial(ii).speed)./29.97)];
%     rat = [ rat str2num(strrep( perTrial(ii).rat, 'da','')) ];
%     explore = [ explore perTrial(ii).explore ];
%     centerExplore = [ centerExplore perTrial(ii).centerExplore];
% end
% 
% %pxPerCm=2.535;
% figure; colormap(build_NOAA_colorgradient);%  newColorMap = [ .7 .7 .7 ; colormap ]; colormap(newColorMap);  colormap(newColorMap);
% subplot(7,4,1:4:6*4); %imagesc(occupancyAll); 
% hold on;
% for ii=1:length(perTrial)
%     scatter( perTrial(ii).xylinearized,  ones(size(perTrial(ii).xylinearized))*ii, 'o', 'filled'); alpha(.01);
% end; set(gca, 'Ydir', 'reverse'); axis tight; xlim([0 580]);
% title('occupancy')
% subplot(7,4,2:4:6*4); %imagesc(swrAll);  
% hold on;
% for ii=1:length(perTrial)
%     scatter( perTrial(ii).swrLinearized,  ones(size(perTrial(ii).swrLinearized))*ii, 'o', 'filled'); alpha(.2);
% end; set(gca, 'Ydir', 'reverse'); axis tight; xlim([0 580]);
% title('swr freq. X space')
% subplot(7,4,3:4:6*4); imagesc(swrRateAll); title('swr Rate')
% subplot(7,4,25); hold on; 
%     plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,median(occupancyAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b'); 
%     axis tight; xlim([0 580]);
% subplot(7,4,26); hold on; 
%     plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,median(swrAll(       find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b'); 
%     axis tight; xlim([0 580]);
% subplot(7,4,27); hold on; 
%     plot(binCenters,median(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,mean(swrRateAll(   find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1)),:)),'b'); 
%     axis tight; xlim([0 580]);
% subplot(7,4,4:4:6*4); hold off;
% xx=trialSwr./trialOcc; %mean(swrRateAll,2); 
% yy=1:length(perTrial); plot(xx,yy); axis tight; set(gca, 'Ydir', 'reverse')
% hold on; scatter( xx(err>0), yy(err>0), 'x' ) ; scatter( xx(probe>0),yy(probe>0), '*' ); scatter( xx(oob>0),yy(oob>0), 'o' ); scatter( xx(oob>0),yy(oob>0), 'o' ) ; scatter( xx(bee>0),yy(bee>0), '>' ) ;
% title('SWR Rate')
% 
% 
% [ 'n_trials = ' num2str(length(perTrial)) ' ; n_correct = ' num2str(sum((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0))) ' ; n_error = '  num2str(sum((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0))) ' ; n_outOfBounds = ' num2str(sum((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==1))) ]
% 
% 
% 
% 
% 
% 
% 
% figure;
% subplot(4,1,1); hold on; ylabel('da5');  
%     plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(oob==1)),:)),'b');  %axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:))+std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+');
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:))-std(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+');
%     axis tight; xlim([0 580]);
% subplot(4,1,2); hold on; ylabel('da10');
%     plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(oob==0)),:)),'b'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==10).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     axis tight; xlim([0 580]); 
% subplot(4,1,3); hold on; ylabel('da12'); 
%     plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(oob==0)),:)),'b'); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%    % scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%    % scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(rat==12).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%    axis tight; xlim([0 580]); 
% subplot(4,1,4); hold on; ylabel('all');  
%     plot(binCenters,median(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g'); 
%     plot(binCenters,median(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r'); 
%     %plot(binCenters,mean(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(oob==0)),:)),'b');            axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     scatter(binCenters,median(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==0)),:))+std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+');
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)),'g+'); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)),'r+'); 
%     axis tight; xlim([0 500]); 
%     %scatter(binCenters,mean(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==0)),:))-std(swrRateAll( find((centerExplore==0).*(explore==0).*(probe==0)          .*(oob==1)),:)),'b+'); axis tight; xlim([0 500]); % plot(mean(swrRateAll(bee==1,:)),'m'); plot(mean(swrRateAll), 'k');
% 
% 
%  
%  
%     
%     
%     
% figure;
% subplot(4,1,1); hold on; ylabel('da5');  
%     plot(binCenters, median(swrRateAll ( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
%     
%     plot(binCenters, median (swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==5) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
%     
%    axis tight; xlim([0 580]);
% subplot(4,1,2); hold on; ylabel('da10');
%     plot(binCenters, median(swrRateAll ( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
%    
%     plot(binCenters, median (swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==10) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
%      axis tight; xlim([0 580]); 
% subplot(4,1,3); hold on; ylabel('da12'); 
%     plot(binCenters, median(swrRateAll ( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
%     
%     plot(binCenters, median (swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0).*(rat==12) .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
%     axis tight; xlim([0 580]); 
% subplot(4,1,4); hold on; ylabel('all');  
%     plot(binCenters, median(swrRateAll ( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:)), 'Color', [ .1 .7 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),75), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),25), '--', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),95), ':', 'Color', [ .1 .7 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==0).*(oob==0)),:),5), ':', 'Color', [ .1 .7 .1 ] ); 
%     
%     plot(binCenters, median (swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:)), 'Color', [ .7 .1 .1 ] );
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),75), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),25), '--', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),95), ':', 'Color', [ .7 .1 .1 ] ); 
%     plot(binCenters, prctile(swrRateAll( find((centerExplore==0)           .*(explore==0).*(probe==0).*(err==1).*(oob==0)),:),5), ':', 'Color', [ .7 .1 .1 ] ); 
%      axis tight; xlim([0 500]); 
%  
    
    
   
     
  

%% DA5
recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %
baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
swrLfpFile =  'CSC30.ncs' ;
thetaLfpFile = 'CSC44.ncs';
% tt12 - CA  ; very good Theta LFP  ch44-47
% tt2,7,8 have hippocampal cells, to provide alternate MUA-based estimates of SWR
load('/Users/andrewhowe/data/plusMazeEphys/da5/cache/filters.mat', 'filters');
metadata.rat = 'da5';
metadata.day = '2016-08-22_orientation1/1.maze-habituation/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug22.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug22.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug22.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug22.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-23_orientation2/1.maze-habituation/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug23.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug23.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug23.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug23.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-24_training1/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug24.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug24.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug24.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug24.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-25_training2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug25.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug25.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug25.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug25.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-26_probe1/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug26.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug26.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug26.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug26.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-27_training3/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug27.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug27.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug27.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug27.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-28_training4/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug28.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug28.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug28.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug28.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-29_training5/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug29.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug29.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug29.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug29.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

%this one is messed up
'/2016-08-30_training6/'
metadata.day = '2016-08-30_training6/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug30.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug30.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug30.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug30.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-08-31_training7/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.aug31.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.aug31.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.aug31.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.aug31.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-09-01_training8/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.sep1.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.sep1.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.sep1.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.sep1.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-09-02_probe2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.sep2.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.sep2.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.sep2.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.sep2.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-09-06_training9_x2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.sep6.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.sep6.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.sep6.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.sep6.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-09-07_training10_x2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.sep7.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.sep7.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.sep7.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.sep7.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2016-09-08_probe3_training11/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda5.sep8.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda5.sep8.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda5.sep8.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda5.sep8.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

% this section is to rebuild agg additional structures from re-runs of the agg scripts.

%% da10
recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
metadata.rat = 'da10';
baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
swrLfpFile =  'CSC88.ncs';
thetaLfpFile = 'CSC61.ncs';

metadata.day = 'da10_2017-09-11/explore/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept11.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept11.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept11.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept11.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-12_/training/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept12.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept12.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept12.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept12.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-13_/training/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept13.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept13.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept13.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept13.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-14_/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept14.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept14.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept14.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept14.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-15_/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept15.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept15.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept15.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept15.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

% some wierd stuff happens
metadata.day = '2017-09-18_/training1/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept18.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept18.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept18.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept18.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-18_/training2/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept18.swrEnv = [  agg.sept18.swrEnv; downsample(swrLfpEnv,round(32000/2000))   ];
agg.sept18.swrEnvTimestamps = [  agg.sept18.swrEnvTimestamps;  agg.sept18.swrEnvTimestamps(end)+1/250+downsample(lfpTimestampSeconds,round(32000/2000))  ];
agg.sept18.thetaEnv = [ agg.sept18.thetaEnv;  downsample(thetaLfpEnv,round(32000/250))  ];
agg.sept18.thetaEnvTimestamps = [ agg.sept18.thetaEnvTimestamps;   agg.sept18.thetaEnvTimestamps(end)+1/4000+downsample(lfpTimestampSeconds,round(32000/250)) ];

metadata.day = '2017-09-18_/training3/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept18.swrEnv = [  agg.sept18.swrEnv; downsample(swrLfpEnv,round(32000/2000))   ];
agg.sept18.swrEnvTimestamps = [  agg.sept18.swrEnvTimestamps;  agg.sept18.swrEnvTimestamps(end)+1/250+downsample(lfpTimestampSeconds,round(32000/2000))  ];
agg.sept18.thetaEnv = [ agg.sept18.thetaEnv;  downsample(thetaLfpEnv,round(32000/250))  ];
agg.sept18.thetaEnvTimestamps = [ agg.sept18.thetaEnvTimestamps;   agg.sept18.thetaEnvTimestamps(end)+1/4000+downsample(lfpTimestampSeconds,round(32000/250)) ];

metadata.day = '2017-09-19_/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept19.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept19.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept19.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept19.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-20_/train/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept20.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept20.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept20.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept20.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-22_/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept22.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept22.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept22.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept22.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

metadata.day = '2017-09-25_/';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day ];
[ swrLfp, lfpTimestamps ] = csc2mat( [ dir swrLfpFile ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
[ thetaLfp, lfpTimestamps ] = csc2mat( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
agg.sept25.swrEnv = downsample(swrLfpEnv,round(32000/2000));
agg.sept25.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
agg.sept25.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
agg.sept25.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));


%% da12

recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  };
metadata.rat = 'da12';
baseDir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' ];
swrLfpFile =  'rawChannel_56.dat'; 
thetaLfpFile = 'rawChannel_56.dat'; 


metadata.day = '2017-10-24_orientation2';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.oct24.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.oct24.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.oct24.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.oct24.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));


metadata.day = '2017-10-27_training1';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.oct27.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.oct27.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.oct27.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.oct27.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

 
metadata.day = '2017-10-30_training2';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day '/'  ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.oct30.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.oct30.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.oct30.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.oct30.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

 
metadata.day = '2017-10-31_training3_probe1';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.oct31.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.oct31.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.oct31.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.oct31.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));


metadata.day = '2017-11-01_training4';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.nov1.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.nov1.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.nov1.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.nov1.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

 
metadata.day = '2017-11-02_training5';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.nov2.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.nov2.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.nov2.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.nov2.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

 
metadata.day = '2017-11-03_training6';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.nov3.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.nov3.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.nov3.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.nov3.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));


metadata.day = '2017-11-06_training7';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.nov6.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.nov6.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.nov6.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.nov6.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));

 
metadata.day = '2017-11-07_training8';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.nov7.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.nov7.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.nov7.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.nov7.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));


metadata.day = '2017-11-08_training9_probe2';
dir=[ '/Volumes/Seagate Expansion Drive/plusmaze-habit/' metadata.rat '/' metadata.day  '/' ];
swrLfp = loadCExtractedNrdChannelData( [ dir swrLfpFile ] );
lfpTimestamps = loadCExtractedNrdTimestampData( [ dir 'timestamps.dat' ] );
lfpTimestampSeconds=(lfpTimestamps-lfpTimestamps(1))/1e6;
thetaLfp = loadCExtractedNrdChannelData( [ dir thetaLfpFile ] );
swrLfpEnv = abs( hilbert(filtfilt( filters.so.swr, swrLfp )));
thetaLfpEnv = abs( hilbert(filtfilt( filters.so.theta, thetaLfp )));
aggda12.nov8.swrEnv = downsample(swrLfpEnv,round(32000/2000));
aggda12.nov8.swrEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/2000));
aggda12.nov8.thetaEnv = downsample(thetaLfpEnv,round(32000/250));
aggda12.nov8.thetaEnvTimestamps = downsample(lfpTimestampSeconds,round(32000/250));



%% DA5

load('~/src/MATLAB/defaultFolder/aggDa5New.mat');

recDays = { 'aug22' 'aug23' 'aug24' 'aug25' 'aug26' 'aug27' 'aug28' 'aug29' 'aug30' 'aug31' 'sep1' 'sep2' 'sep6' 'sep7' 'sep8'  }; %


% figure; hold on;
% for ii=1:round(length(recDays))
%     hold on; plot( aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos );
% end
% for ii=1:round(length(recDays))
%     hold on; scatter( aggda5.(recDays{ii}).swrXpos, aggda5.(recDays{ii}).swrYpos );
% end


for ii=1:length(recDays)

    [angle, radius] = cart2pol( aggda5.(recDays{ii}).xpos-390, aggda5.(recDays{ii}).ypos-260 ); angle=angle*180/pi+180;
    rad=radius;
    aggda5.(recDays{ii}).xylinearized(find((rad <= 35))) =  130; % Center Point                                                                                     px / cm  + offset
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 )))/(288/106) + 225 + 3*20; % South
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 )))/(225/100) + 330 + 5*20; % East
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 )))/(255/106) + 125 + 1*20; % North  ; invert this so the rat starts at x=0
    aggda5.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 )))/(255/106)); % West
    aggda5.(recDays{ii}).radiusFromCenter=rad;    
    
    aggda5.(recDays{ii}).xyspeed=[ 0 calculateSpeed(aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos, 1, 2.52, 29.97 ) ];
    
    idxs = floor(aggda5.(recDays{ii}).swrTimes*29.97)+1; if max(idxs)>length(aggda5.(recDays{ii}).xylinearized); idxs(idxs==max(idxs))=length(aggda5.(recDays{ii}).xylinearized); end;
    idxs(idxs>length(aggda5.(recDays{ii}).xylinearized))=[];
    aggda5.(recDays{ii}).swrxylinearized = aggda5.(recDays{ii}).xylinearized(idxs);
    
    aggda5.(recDays{ii}).swrSpeed = aggda5.(recDays{ii}).xyspeed(idxs);
    
    aggda5.(recDays{ii}).instantSpeed = zeros(size(aggda5.(recDays{ii}).xpos));
    dx = zeros(size(aggda5.(recDays{ii}).xpos));
    dy = zeros(size(aggda5.(recDays{ii}).xpos));
    for jj=2:length(aggda5.(recDays{ii}).xpos)-1
    	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda5.(recDays{ii}).instantSpeed(jj) = sqrt( ( aggda5.(recDays{ii}).ypos(jj-1) - aggda5.(recDays{ii}).ypos(jj+1) ).^2 + ( aggda5.(recDays{ii}).xpos(jj-1) - aggda5.(recDays{ii}).xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
    end
    
    aggda5.(recDays{ii}).swrInstantSpeed = aggda5.(recDays{ii}).instantSpeed(idxs);
    
    aggda5.(recDays{ii}).lagSpeed = zeros(size(aggda5.(recDays{ii}).xpos));
    for jj=61:length(aggda5.(recDays{ii}).xpos)
   	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda5.(recDays{ii}).instantSpeed(jj) = sqrt( ( aggda5.(recDays{ii}).ypos(jj-60) - aggda5.(recDays{ii}).ypos(jj) ).^2 + ( aggda5.(recDays{ii}).xpos(jj-60) - aggda5.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
    end
    
    aggda5.(recDays{ii}).swrLagSpeed = aggda5.(recDays{ii}).lagSpeed(idxs);
    aggda5.(recDays{ii}).proxToReward = proxToPoint( aggda5.(recDays{ii}).xpos, aggda5.(recDays{ii}).ypos, 384, 482 );
end     


%% DA10
%load('~/src/MATLAB/defaultFolder/aggDa10New.mat');
recDays = { 'sept11' 'sept12' 'sept13' 'sept14' 'sept15' 'sept18' 'sept19' 'sept20' 'sept22' 'sept25' };
% 
% figure; hold on;
% for ii=1:round(length(recDays))
%     hold on; plot( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos );
% end
% for ii=1:round(length(recDays))
%     hold on; scatter( agg.(recDays{ii}).swrXpos, agg.(recDays{ii}).swrYpos );
% end

for ii=1:length(recDays)

    [angle, radius] = cart2pol( agg.(recDays{ii}).xpos-395, agg.(recDays{ii}).ypos-403 ); angle=angle*180/pi+180;
    rad=radius;
    agg.(recDays{ii}).xylinearized=rad;
    % * each arm is 109 cm. Let's assume the rat sticks his head at most 6 cm
    % off the end of the start arm, so that is 115 cm.
    % * let's place the center point at 115, and anything within a 25 px
    % radius is just considered "center"
    % * to orient the start arm, subtract whatever the radius is in cm 
    % (custom to each rat) from 110
    % * on each subsequent 
    agg.(recDays{ii}).xylinearized(find((rad <= 35))) =  130; % Center Point
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 )))/(276/100) + 125 + 1*20; % South
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 )))/(269/100) + 330 + 5*20; % East
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 )))/(306/106) + 225 + 3*20; % North  ; invert this so the rat starts at x=0
    agg.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 )))/(335/106)) ; % West
    agg.(recDays{ii}).radiusFromCenter=rad;
    
    agg.(recDays{ii}).xyspeed=[ 0 calculateSpeed(agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 1, 2.9, 29.97 ) ];
    
    idxs = floor(agg.(recDays{ii}).swrTimes*29.97)+1; if max(idxs)>length(agg.(recDays{ii}).xylinearized); idxs(idxs==max(idxs))=length(agg.(recDays{ii}).xylinearized); end;
    agg.(recDays{ii}).swrxylinearized = agg.(recDays{ii}).xylinearized(idxs);
    
    agg.(recDays{ii}).swrSpeed = agg.(recDays{ii}).xyspeed(idxs);
    
    agg.(recDays{ii}).instantSpeed = zeros(size(agg.(recDays{ii}).xpos));
    dx = zeros(size(agg.(recDays{ii}).xpos));
    dy = zeros(size(agg.(recDays{ii}).xpos));
    for jj=2:length(agg.(recDays{ii}).xpos)-1
    	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        agg.(recDays{ii}).instantSpeed(jj) = sqrt( ( agg.(recDays{ii}).ypos(jj-1) - agg.(recDays{ii}).ypos(jj+1) ).^2 + ( agg.(recDays{ii}).xpos(jj-1) - agg.(recDays{ii}).xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
    end
    agg.(recDays{ii}).swrInstantSpeed = agg.(recDays{ii}).instantSpeed(idxs);
    agg.(recDays{ii}).lagSpeed = zeros(size(agg.(recDays{ii}).xpos));
    for jj=61:length(agg.(recDays{ii}).xpos)
   	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        agg.(recDays{ii}).instantSpeed(jj) = sqrt( ( agg.(recDays{ii}).ypos(jj-60) - agg.(recDays{ii}).ypos(jj) ).^2 + ( agg.(recDays{ii}).xpos(jj-60) - agg.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
    end
    agg.(recDays{ii}).swrLagSpeed = agg.(recDays{ii}).lagSpeed(idxs);
    agg.(recDays{ii}).proxToReward = proxToPoint( agg.(recDays{ii}).xpos, agg.(recDays{ii}).ypos, 389, 137 );
end

%% DA 12
%load('~/src/MATLAB/defaultFolder/aggDa12New.mat');
recDays = { 'oct24' 'oct27' 'oct30' 'oct31' 'nov1' 'nov2' 'nov3' 'nov6' 'nov7' 'nov8'  };

% figure; hold on;
% for ii=1:length(recDays)
%     hold on; plot( aggda12.(recDays{ii}).xpos, aggda12.(recDays{ii}).ypos );
%     hold on; scatter( aggda12.(recDays{ii}).swrXpos, aggda12.(recDays{ii}).swrYpos );
% end

for ii=1:length(recDays)

    [angle, radius] = cart2pol( aggda12.(recDays{ii}).xpos-310, aggda12.(recDays{ii}).ypos-533 ); angle=angle*180/pi+180;
    rad=radius;
    aggda12.(recDays{ii}).xylinearized(find((rad <= 35))) =  130; % Center Point                                                                                     px / cm  + offset
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 ))) =      rad(find((rad > 35) .* ( angle >  45 ) .* ( angle <= 135 )))/(315/100) + 225 + 3*20; % South
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 ))) =      rad(find((rad > 35) .* ( angle > 135 ) .* ( angle <= 225 )))/(300/100) + 330 + 5*20; % East
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 ))) =      rad(find((rad > 35) .* ( angle > 225 ) .* ( angle <= 315 )))/(310/106) + 125 + 1*20; % North  ; invert this so the rat starts at x=0
    aggda12.(recDays{ii}).xylinearized(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 ))) = 115-(rad(find((rad > 35) .* ( angle > 315 )  + ( angle <=  45 )))/(275/106)) ; % West
    aggda12.(recDays{ii}).radiusFromCenter=rad;    
    
    aggda12.(recDays{ii}).xyspeed=[ 0 calculateSpeed(aggda12.(recDays{ii}).xpos, aggda12.(recDays{ii}).ypos, 1, 2.92, 29.97 ) ];    
    
    idxs=[]; for jj=1:length(aggda12.(recDays{ii}).swrTimes); idxs=[ idxs find( (aggda12.(recDays{ii}).swrTimes(jj) < aggda12.(recDays{ii}).xytimestampSeconds) , 1 )]; end; 
    aggda12.(recDays{ii}).swrxylinearized = aggda12.(recDays{ii}).xylinearized(idxs);                            
    
    aggda12.(recDays{ii}).swrSpeed = aggda12.(recDays{ii}).xyspeed(idxs);
    
    aggda12.(recDays{ii}).instantSpeed = zeros(size(aggda12.(recDays{ii}).xpos));
    dx = zeros(size(aggda12.(recDays{ii}).xpos));
    dy = zeros(size(aggda12.(recDays{ii}).xpos));
    for jj=2:length(aggda12.(recDays{ii}).xpos)-1
    	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda12.(recDays{ii}).instantSpeed(jj) = sqrt( ( aggda12.(recDays{ii}).ypos(jj-1) - aggda12.(recDays{ii}).ypos(jj+1) ).^2 + ( aggda12.(recDays{ii}).xpos(jj-1) - aggda12.(recDays{ii}).xpos(jj+1) ).^2 ) * (1/2) * 1/2.75 * 29.97;
    end
    
    aggda12.(recDays{ii}).swrInstantSpeed = aggda12.(recDays{ii}).instantSpeed(idxs);
    
    aggda12.(recDays{ii}).lagSpeed = zeros(size(aggda12.(recDays{ii}).xpos));
    for jj=61:length(aggda12.(recDays{ii}).xpos)
   	% px / delta_frames * 30 frames/second * 1 cm / 2.75 px
        aggda12.(recDays{ii}).instantSpeed(jj) = sqrt( ( aggda12.(recDays{ii}).ypos(jj-60) - aggda12.(recDays{ii}).ypos(jj) ).^2 + ( aggda12.(recDays{ii}).xpos(jj-60) - aggda12.(recDays{ii}).xpos(jj) ).^2 ) * (1/60) * 1/2.75 * 29.97;
    end
    
    aggda12.(recDays{ii}).swrLagSpeed = aggda12.(recDays{ii}).lagSpeed(idxs);
    
    aggda12.(recDays{ii}).proxToReward = proxToPoint( aggda12.(recDays{ii}).xpos, aggda12.(recDays{ii}).ypos, 338, 811 );
end

