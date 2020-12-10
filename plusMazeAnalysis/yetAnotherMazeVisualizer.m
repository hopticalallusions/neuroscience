figure; hold on;

%% DA5

rat = 'da5';
folders  = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' };
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    [xfpos,yfpos]=defishy(xpos,ypos,.000002);%34);
    %plot( xfpos, yfpos, 'Color', [ 0.9 0 0 .1] ); hold on;
    ys = yfpos + (( yfpos ).^2)/3000;
    xt = xfpos-320;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( yfpos ).^2)/26000;
    %plot( xs, ys, 'Color', [ 0 0 0 .1] ); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 320, 263, -138, 0, 0 );
    xrpos = xrpos * 1.15 * 1/3.6364;
    yrpos = yrpos * 1.15 * 1/3.6364;
    plot(xrpos,yrpos)%, 'Color', [ .1 .6 .6 .1 ] );hold on;
    %
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end



rat = 'da5';
folders  = {'2016-09-01' '2016-09-02'};
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);    
    [xfpos,yfpos]=defishy(xpos,ypos,.000002);%34);
    %plot( xfpos, yfpos, 'Color', [ 0.9 0 0 .1] ); hold on;
    ys = yfpos + (( yfpos ).^2)/3000;
    xt = xfpos-320;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( yfpos ).^2)/26000;
    %plot( xs, ys, 'Color', [ 0 0 0 .1] ); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 430, 300, -140, 0, 0 );
    xrpos = xrpos * 1.15 * 1/3.6364;
    yrpos = yrpos * 1.15 * 1/3.6364;
    plot(xrpos,yrpos, 'Color', [ .1 .6 .6 .1 ] );hold on;
    
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end


rat = 'da5';
folders  = {'2016-09-06' };
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);    
    [xfpos,yfpos]=defishy(xpos,ypos,.000002);%34);
    %plot( xfpos, yfpos, 'Color', [ 0.9 0 0 .1] ); hold on;
    ys = yfpos + (( yfpos ).^2)/3000;
    xt = xfpos-320;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( yfpos ).^2)/26000;
    %plot( xs, ys, 'Color', [ 0 0.9 0 .1] ); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 420, 304, -142, 0, 0 );
    xrpos = xrpos * 1.15 * 1/3.6364;
    yrpos = yrpos * 1.15 * 1/3.6364;
    plot(xrpos,yrpos, 'Color', [ .1 .6 .6 .1 ] );hold on;
    
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end


rat = 'da5';
folders  = { '2016-09-07' '2016-09-08' };
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);    
    [xfpos,yfpos]=defishy(xpos,ypos,.000002);%34);
    %plot( xfpos, yfpos, 'Color', [ 0.9 0 0 .1] ); hold on;
    ys = yfpos + (( yfpos ).^2)/3000;
    xt = xfpos-320;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( yfpos ).^2)/26000;
    %plot( xs, ys, 'Color', [ 0 0.9 0 .1] ); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 410, 278, -140, 0, 0 );
    % rescale to 1 cm per unit
    xrpos = xrpos * 1.15 * 1/3.6364;
    yrpos = yrpos * 1.15 * 1/3.6364;
    plot(xrpos,yrpos, 'Color', [ .1 .6 .6 .1 ] );hold on;
    
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end
axis square;
axis([ -140 140 -140 140 ])



rat = 'da5';
folders  = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' '2016-09-01' '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.mat' ], '-mat');
    figure; plot(telemetry.x, telemetry.y, 'k'); hold on; plot(telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0)); scatter(telemetry.x, telemetry.y, 3, telemetry.onMaze, 'filled'); title(folders{ii});
    axis([-150 150 -150 150]); axis square;
end
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.mat' ], '-mat');
    figure; scatter(telemetry.xytimestampSeconds, telemetry.x); hold on; scatter(telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, telemetry.onMaze*130); title([ rat '  ' folders{ii} ]);
end

    figure; scatter(telemetry.xytimestampSeconds, telemetry.x); hold on;plot(telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, telemetry.onMaze*130); scatter(telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, telemetry.onMaze*130); title([ rat '  ' folders{ii} ]);


return;


%% DA10

rat = 'da10';
folders  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
%    plot(xpos,ypos,'Color',[0 0 0 .1]); hold on;    
    ctrShiftX = 80;%45;%55 ;
    ctrShiftY = -40;%100;%-45;
    [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002);
    xfpos=xfpos-ctrShiftX;
    yfpos=yfpos-ctrShiftY;
%    plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); hold on;
    ys = yfpos - (( 520-yfpos ).^2)/2300;
    xt = xfpos-400;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( 520-yfpos ).^2)/28000;
%    plot(xs,ys,'Color',[0.9 0 0 .1]); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 330, 200, -46, 0, 0 );
    % rescale to 1 cm per unit
    xrpos = xrpos * 1/3.6364;
    yrpos = yrpos * 1/3.6364;
    plot( xrpos, yrpos, 'Color', [ .6 .1 .5 .1] ); hold on;
    
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end


rat = 'da10';
folders  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
    %
    [ ~, cscTimestamps ]=csc2mat([ filepath '/CSC20.ncs']);
    disp(filepath);
    disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
    disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
    disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
    disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
    disp([ 'max diff vid : ' num2str( max(diff(vidElapsedSec)) ) ' sec' ] )
    disp([ 'vid jumps    : ' num2str( sum(diff(vidElapsedSec)>.5) ) ' jumps' ] )
    disp([ 'max diff csc : ' num2str( max(diff(cscTimestamps)/1e6) ) ' sec' ] )
    disp([ 'csc jumps    : ' num2str( sum((diff(cscTimestamps)/1e6)>.5) ) ' jumps' ] )
%    figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
%    plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) ); title([ rat ' ' folders{ii} ]);
end


for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.mat' ], '-mat');
    figure; plot(telemetry.x, telemetry.y, 'k'); hold on; plot(telemetry.x(telemetry.onMaze>0), telemetry.y(telemetry.onMaze>0)); scatter(telemetry.x, telemetry.y, 3, telemetry.onMaze, 'filled'); title(folders{ii});
    axis([-150 150 -150 150]); axis square;
end
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.mat' ], '-mat');
    figure; scatter(telemetry.xytimestampSeconds, telemetry.x); hold on; scatter(telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, telemetry.onMaze*130); title([ rat '  ' folders{ii} ]);
end



%%   H5

rat = 'h5';
folders  = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };

% TODO
% handle the first 2 days here (really there are three, but one was
% excluded due to raw or something like that.)

for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    if ~strcmp( '2018-04-25', folders{ii} ) && ~strcmp( '2018-04-27', folders{ii})
        xpos = 720-xpos; ypos = 480-ypos;  % invert for these because the camera perspective changed.
    else
        xpos = xpos-25; ypos = ypos+25;
    end
%    figure; plot(xpos,ypos,'Color',[0 0 0 .1]); hold on;

    ctrShiftX = 60;%45;%55 ;
    ctrShiftY = 0;%100;%-45;
    [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002);
    xfpos=xfpos-ctrShiftX;
    yfpos=yfpos-ctrShiftY;
%    figure; plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); hold on;
    
    ys = yfpos - (( 520-yfpos ).^2)/2000;
    xt = xfpos-304;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/10000 .* (( 520-yfpos ).^2)/25000;
%   figure;  plot(xs,ys,'Color',[0.9 0 0 .1]); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 323, 200, -44, 0, 0 );
    % rescale to 1 cm per unit
    xrpos = xrpos * 1/3.6364;
    yrpos = yrpos * 1/3.6364;
    plot( xrpos,yrpos, 'Color', [.1 .1 .8 .1 ] ); hold on;
    
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end



rat = 'h5';
folders  = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    vidElapsedSec = (xytimestamps-xytimestamps(1))/1e6;
    %
    [ ~, cscTimestamps ]=csc2mat([ filepath '/CSC16.ncs']);
    disp(filepath);
    disp([ 'start offset : ' num2str( (cscTimestamps(1)-xytimestamps(1))/1e6 ) ' s' ] )
    disp([ 'end   offset : ' num2str( (cscTimestamps(end)-xytimestamps(end))/1e6 ) ' s' ] )
    disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
    disp([ 'telem elapsd : ' num2str( vidElapsedSec(end)/60 ) ' min' ] )
    disp([ 'max diff vid : ' num2str( max(diff(vidElapsedSec)) ) ' sec' ] )
    disp([ 'vid jumps    : ' num2str( sum(diff(vidElapsedSec)>.5) ) ' jumps' ] )
    disp([ 'max diff csc : ' num2str( max(diff(cscTimestamps)/1e6) ) ' sec' ] )
    disp([ 'csc jumps    : ' num2str( sum(diff(cscTimestamps)>.5) ) ' jumps' ] )
%    figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
%    plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) ); title([ rat ' ' folders{ii} ]);
end


% This is a quick and dirty way to check that the behavior data is well
% aligned with the telemetry
rat = 'h5';
folders  = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.mat' ], '-mat');
    figure; plot(telemetry.x, telemetry.y, 'k'); hold on; scatter(telemetry.x, telemetry.y, 3, telemetry.onMaze, 'filled'); title(folders{ii});
    axis([-150 150 -150 150]); axis square;
end
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.mat' ], '-mat');
    figure; scatter(telemetry.xytimestampSeconds, telemetry.x); hold on; scatter(telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, telemetry.onMaze*130); title([ rat '  ' folders{ii} ]);
end


return;


%%  H7
rat = 'h7';
folders = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22' };
% 1:29 in same room as before
% 30:35 are in the new room with the new camera rig.

% TODO -- these don't work so well
%
% '2018-08-01a' '2018-08-01b'  '2018-08-01c'  '2018-08-03a'  '2018-08-03b'
% '2018-08-06'  '2018-08-08'   '2018-08-09'   '2018-08-13'

% TODO this day is especially complicated; expected that SMI data is req.
% '2018-08-01c'

%folders = { '2018-08-08' }; % { '2018-08-06' };

% these are the days where there are multiple video files
%folders = { '2018-07-20' '2018-08-01a' '2018-08-01c' '2018-08-08' '2018-08-10' '2018-08-13' '2018-08-28' '2018-09-04' };

% THE 15TH RECORDING DAY, 2018-06-11, has a coverage of the whole plus maze

for ii = 1:length(folders)
    try
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        if exist( [ filepath 'position.mat' ], 'file')
            load( [ filepath 'position.mat' ] );
            xpos = mean([position.xGpos; position.xRpos]);
            ypos = mean([position.yGpos; position.yRpos]);
            try 
                headDir = position.angle;
            catch
                headDir = atan2( position.yGpos-position.yRpos, position.xGpos-position.xRpos );
            end
            [ xytimestampSeconds, xytimestamps ] = smi2mat( filepath );
            if length(xytimestamps) > length(xpos)
                xytimestamps = xytimestamps(1:length(xpos));
                xytimestampSeconds = xytimestampSeconds(1:length(xpos));
            elseif length(xytimestamps) < length(xpos)
                warning( 'WTF!?' )
                for kk = length(xytimestamps)+1:length(xpos)
                    xytimestampSeconds(kk) = xytimestampSeconds(kk-1) + 1/29.97;
                    xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
                end
            end
        else
            [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
            xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
        end
        xpos = 720-xpos; ypos = 480-ypos;  % invert for these because the camera perspective changed.

    %    plot(xpos,ypos); hold on;

        % THIS HAS THE SAME CORRECTIONS AS THE PREVIOUS RAT
        ctrShiftX = 60;%45;%55 ;
        ctrShiftY = 0;%100;%-45;
        [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002);
        xfpos=xfpos-ctrShiftX;
        yfpos=yfpos-ctrShiftY;
        figure; plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); hold on;

        ys = yfpos - (( 520-yfpos ).^2)/2000;
        xt = xfpos-304;
        xs = xfpos + xt./abs(xt) .* (xt.^2)/10000 .* (( 520-yfpos ).^2)/25000;
    %    plot(xs,ys,'Color',[0.9 0 0 .1]); hold on;
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 323, 200, -44, 0, 0 );
        % rescale to 1 cm per unit
        xrpos = xrpos * 1/3.6364;
        yrpos = yrpos * 1/3.6364;
        plot( xrpos, yrpos, 'Color', [ .1 .8 .1 .2 ] ); hold on;
        
        telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
    catch
        disp([ 'FAILED : ' filepath ])
    end
end

figure; scatter( (xytimestamps-xytimestamps(1))/1e6, xpos, 'filled'); hold on; scatter( (xytimestamps-xytimestamps(1))/1e6, ypos, 'filled');



% This is a quick and dirty way to check that the behavior data is well
% aligned with the telemetry
rat = 'h7';
folders = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.dat' ], '-mat');
    figure; plot(telemetry.x, telemetry.y, 'k'); hold on; scatter(telemetry.x, telemetry.y, 3, telemetry.onMaze, 'filled'); title([ rat '  ' folders{ii} ]);
    axis([-150 150 -150 150]); axis square;
end

% longwise version
rat = 'h7';
folders = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };

folders = { '2018-08-10' '2018-08-03b' '2018-08-03a' '2018-08-01c' '2018-08-08' };
for ii = 1:length(folders)
    load([ '~/Desktop/' rat '_' folders{ii} '_telemetry.dat' ], '-mat');
    figure; scatter(telemetry.xytimestampSeconds, telemetry.x); hold on; scatter(telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, telemetry.onMaze*130); title([ rat '  ' folders{ii} ]);
end



% These folders are in the NEW ROOM
folders = {  '2018-09-04' '2018-09-05' '2018-08-31' };

rat='h7';
%folders = {  };


% TODO -- these don't work so well
% '2018-08-28'   MULTIPLE VIDEO FILES
% '2018-08-31'   EXTRACTED POSITION DATA
% 
for ii = 1:length(folders)
    filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
%    plot( xpos, ypos, 'Color', [ 0 0 0 .1 ]); hold on; 
    ctrShiftX = -20;%45;%55 ;
    ctrShiftY = -60;%100;%-45;
    [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000001);
    xfpos=xfpos-ctrShiftX;
    yfpos=yfpos-ctrShiftY;
%    plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); hold on;
    ys = yfpos + (( yfpos ).^2)/4000;
    xt = xfpos-400;
    xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( yfpos ).^2)/26000;
%    plot(xs,ys,'Color',[0 0 0.9 .1]); hold on;
    [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 376, 266, -44, 0, 0 );
    xrpos = xrpos * 1.3;
    yrpos = yrpos * 1.3;
    % rescale to 1 cm per unit
    xrpos = xrpos * 1/3.6364;
    yrpos = yrpos * 1/3.6364;
    plot( xrpos, yrpos, 'Color', [ .1 .8 .1 .1 ] ); hold on; 
    
    telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
end


%% H1
rat='h1';
folders = { '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' };  % tent / old room


for ii = 1:length(folders)
    try
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    %    plot(xpos,ypos); hold on;
        xpos = 720-xpos; ypos = 480-ypos;  % invert for these because the camera perspective changed.

        % THIS HAS THE SAME CORRECTIONS AS THE PREVIOUS RAT
        ctrShiftX = 60;%45;%55 ;
        ctrShiftY = 0;%100;%-45;
        [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002);
        xfpos=xfpos-ctrShiftX;
        yfpos=yfpos-ctrShiftY;
        %plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); hold on;

        ys = yfpos - (( 520-yfpos ).^2)/2000;
        xt = xfpos-304;
        xs = xfpos + xt./abs(xt) .* (xt.^2)/10000 .* (( 520-yfpos ).^2)/25000;
    %    plot(xs,ys,'Color',[0.9 0 0 .1]); hold on;
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 323, 200, -44, 0, 0 );
        xrpos = xrpos * 1.1;
        yrpos = yrpos * 1.1;
        % rescale to 1 cm per unit
        xrpos = xrpos * 1/3.6364;
        yrpos = yrpos * 1/3.6364;
    %    plot( xrpos, yrpos, 'Color', [ .9 0 0 .1 ]); hold on;
        plot( xrpos, yrpos ); hold on; 

        telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
        
        disp(['SUCCESS : ' folders{ii} ]);
    catch
        disp(['FAILURE : ' folders{ii} ]);
    end
end



% NEW ROOM
folders = { '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04' '2018-09-05' '2018-09-06' '2018-09-08' '2018-09-09' '2018-09-14' };
% THE 15TH RECORDING DAY, 2018-06-11, has a coverage of the whole plus maze
%9 is good for quick tests


for ii = 1:length(folders)
    try
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    %    plot( xpos, ypos, 'Color', [ 0 0 0 .1 ]); hold on; 
        ctrShiftX = -20;%45;%55 ;
        ctrShiftY = -60;%100;%-45;
        [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000001);
        xfpos=xfpos-ctrShiftX;
        yfpos=yfpos-ctrShiftY;
    %    plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); hold on;
        ys = yfpos + (( yfpos ).^2)/4000;
        xt = xfpos-400;
        xs = xfpos + xt./abs(xt) .* (xt.^2)/13000 .* (( yfpos ).^2)/26000;
    %    plot(xs,ys,'Color',[0 0 0.9 .1]); hold on;
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 376, 266, -43, 0, 0 );
        xrpos = xrpos * 1.3;
        yrpos = yrpos * 1.3;
        % rescale to 1 cm per unit
        xrpos = xrpos * 1/3.6364;
        yrpos = yrpos * 1/3.6364;
        plot( xrpos, yrpos, 'Color', [ 0.9 0 0 .1 ]); hold on; 
    %    plot( xrpos, yrpos ); hold on; 

        telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );

        disp(['SUCCESS : ' folders{ii} ]);
    catch
        disp(['FAILURE : ' folders{ii} ]);
    end
end
axis square; axis([ -140 140 -140 140 ])
for ii=-600:50:600
    line([ -1000 1500 ],[ ii ii ], 'Color', [ .1 .9 .9 ] );
    line([ ii ii ],[ -1000 1500 ], 'Color', [ .1 .9 .9 ] );
end



%% live video extractions

% in tent / old room
folders = { '2018-08-06' '2018-08-14' };
figure;
rat='h7';
for ii = 1:length(folders)
    %try
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        load(['/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii}  '/position.mat' ]);
        xpos = mean([ position.xGpos; position.xRpos ]);
        ypos = mean([ position.yGpos; position.yRpos ]);
        %headDir = position.angle;
        headDir = atan2( position.yGpos-position.yRpos, position.xGpos-position.xRpos );
        [ vidElapsedSec, xytimestamps ] = smi2mat( ['/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii}  '/'] );
        if length(xytimestamps) > length(xpos)
            xytimestamps = xytimestamps(1:length(xpos));
            vidElapsedSec = vidElapsedSec(1:length(xpos));
        elseif length(xytimestamps) < length(xpos)
            warning('WTF!?')
        end
        
        %subplot(1,2,1); hold on; plot(xpos,ypos,'Color',[0.9 0 0 .1]); axis square; axis([ 0 720 0 720])
        subplot(1,2,1); hold on; plot(xpos,ypos); axis square; axis([ 0 800 -100 700])

        % THIS HAS THE SAME CORRECTIONS AS THE PREVIOUS RAT
        ctrShiftX = -30 ;
        ctrShiftY = -20;%100;%-45;
        [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002); 
        xfpos=xfpos-ctrShiftX;
        yfpos=yfpos-ctrShiftY;
        
        ys = yfpos + (( yfpos ).^2)/2000;
        xt = xfpos-304;
        xs = xfpos + xt./abs(xt) .* (xt.^2)/10000 .* (( yfpos ).^2)/25000;
        
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 417, 270, -42, 0, 0 );
        xrpos = xrpos * 1.1;
        yrpos = yrpos * 1.1;
        % rescale to 1 cm per unit
        xrpos = xrpos * 1/3.75;
        yrpos = yrpos * 1/3.75;
        
        subplot(1,2,2); 
        for jj=-800:50:800
            line([ -800 800 ],[ jj jj ],'Color','r');
            line([ jj jj ],[ -800 800 ],'Color','r');
        end
        %subplot(1,2,2); hold on; plot( xfpos, yfpos, 'Color', [ 0.9 0 0 .1 ] ); axis square; axis([ 0 720 0 720]);
        hold on; plot( xrpos, yrpos ); axis square; axis([ -150 150 -150 150 ]);

        telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
        
    end; 



% in new room
folders = { '2018-09-05' '2018-09-07' '2018-09-08' '2018-09-09' };
folders = { '2018-09-07'  };
figure;
rat = 'h1';
for ii = 1:length(folders)
    %try
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        load(['/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii}  '/position.mat' ]);
        xpos = mean([ position.xGpos; position.xRpos ]);
        ypos = mean([ position.yGpos; position.yRpos ]);
        %headDir = position.angle;
        headDir = atan2( position.yGpos-position.yRpos, position.xGpos-position.xRpos );
        [ vidElapsedSec, xytimestamps ] = smi2mat( ['/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii}  '/'] );
        if length(xytimestamps) > length(xpos)
            xytimestamps = xytimestamps(1:length(xpos));
            vidElapsedSec = vidElapsedSec(1:length(xpos));
        elseif length(xytimestamps) < length(xpos)
            warning('WTF!?')
            for kk = length(xytimestamps)+1:length(xpos)
                vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
                xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
            end
        end
        
        
        subplot(1,2,1); hold on; plot(xpos,ypos,'Color',[0.9 0 0 .1]); axis square; axis([ 0 720 0 720])
        

        % THIS HAS THE SAME CORRECTIONS AS THE PREVIOUS RAT
        ctrShiftX = -30 ;
        ctrShiftY = -20;%100;%-45;
        [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002); 
        xfpos=xfpos-ctrShiftX;
        yfpos=yfpos-ctrShiftY;
        
        ys = yfpos + (( yfpos ).^2)/4000;
        xt = xfpos-374;
        xs = xfpos + xt./abs(xt) .* (xt.^2)/18000 .* (( yfpos ).^2)/31000;
        
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 350, 270, -43, 0, 0 );
                
        % rescale to 1 cm per unit
        xrpos = xrpos * 1/3.04;
        yrpos = yrpos * 1/3.04;
        
        subplot(1,2,2); 
        for jj=-800:50:800
            line([ -800 800 ],[ jj jj ],'Color','r');
            line([ jj jj ],[ -800 800 ],'Color','r');
        end
        %subplot(1,2,2); hold on; plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); axis square; axis([ 0 720 0 720]);
        hold on; plot(xrpos,yrpos); axis square; axis([ -150 150 -150 150]);

        telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
        
end;     

[ ~, lfpTimestamps ]=csc2mat( [ filepath 'CSC84.ncs' ] );
lfpTimestamps(end)
xytimestamps(end)
lfpTimestamps(end)-xytimestamps(end)
lfpTimestamps(1)-xytimestamps(1)



folders = { '2018-08-31' };
figure;
rat = 'h7';
for ii = 1:length(folders)
    %try
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        load(['/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii}  '/position.mat' ]);
        xpos = mean([ position.xGpos; position.xRpos ]);
        ypos = mean([ position.yGpos; position.yRpos ]);
        %headDir = position.angle;
        headDir = atan2( position.yGpos-position.yRpos, position.xGpos-position.xRpos );
        [ vidElapsedSec, xytimestamps ] = smi2mat( ['/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii}  '/'] );
        if length(xytimestamps) > length(xpos)
            xytimestamps = xytimestamps(1:length(xpos));
            vidElapsedSec = vidElapsedSec(1:length(xpos));
        elseif length(xytimestamps) < length(xpos)
            warning('WTF!?')
            for kk = length(xytimestamps)+1:length(xpos)
                vidElapsedSec(kk) = vidElapsedSec(kk-1) + 1/29.97;
                xytimestamps(kk) = xytimestamps(kk-1) + (1/29.97 * 1e6 );
            end
        end
        
        
        subplot(1,2,1); hold on; plot(xpos,ypos,'Color',[0.9 0 0 .1]); axis square; axis([ 0 720 0 720])
        

        % THIS HAS THE SAME CORRECTIONS AS THE PREVIOUS RAT
        ctrShiftX = -30 ;
        ctrShiftY = -20;%100;%-45;
        [xfpos,yfpos]=defishy(xpos+ctrShiftX,ypos+ctrShiftY,.000002); 
        xfpos=xfpos-ctrShiftX;
        yfpos=yfpos-ctrShiftY;
        
        ys = yfpos + (( yfpos ).^2)/4000;
        xt = xfpos-374;
        xs = xfpos + xt./abs(xt) .* (xt.^2)/18000 .* (( yfpos ).^2)/31000;
        
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 350, 270, -43, 0, 0 );
                
        % rescale to 1 cm per unit
        xrpos = xrpos * 1/3.04;
        yrpos = yrpos * 1/3.04;
        
        subplot(1,2,2); 
        for jj=-800:50:800
            line([ -800 800 ],[ jj jj ],'Color','r');
            line([ jj jj ],[ -800 800 ],'Color','r');
        end
        %subplot(1,2,2); hold on; plot(xfpos,yfpos,'Color',[0.9 0 0 .1]); axis square; axis([ 0 720 0 720]);
        hold on; plot(xrpos,yrpos); axis square; axis([ -150 150 -150 150]);

        telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, rat, folders{ii} );
        
end;     


return;

    

load('/Volumes/AGHTHESIS2/rats//h1/2018-09-05/position.mat');
%	has 2 lights in video
subplot(3,3,1);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h1/2018-09-07/position.mat');
%	has 2 lights in video
subplot(3,3,2);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h1/2018-09-08/position.mat');
%	has 2 lights in video
subplot(3,3,3);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h1/2018-09-09/position.mat');
%	has 1 green light in video
subplot(3,3,4);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')

load('/Volumes/AGHTHESIS2/rats//h7/2018-08-06/position.mat');
%	has 2 lights in video
subplot(3,3,5);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h7/2018-08-14/position.mat');
%	has 2 lights in video
subplot(3,3,6);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h7/2018-08-31/position.mat');
%	has 1 green light in video
subplot(3,3,7);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')








%% CHECK THAT THE FILES ARE CUT APART INTO TRIALS CORRECTLY


%/Volumes/AGHTHESIS2/rats//h7/2018-08-01c
%/Volumes/AGHTHESIS2/rats//h7/2018-08-28


files = { '/Volumes/AGHTHESIS2/rats//h1/2018-08-10/' '/Volumes/AGHTHESIS2/rats//h1/2018-09-04/' '/Volumes/AGHTHESIS2/rats//h1/2018-09-07/' '/Volumes/AGHTHESIS2/rats//h7/2018-07-20/' '/Volumes/AGHTHESIS2/rats//h7/2018-08-01a/' '/Volumes/AGHTHESIS2/rats//h7/2018-08-08/' '/Volumes/AGHTHESIS2/rats//h7/2018-08-10/' '/Volumes/AGHTHESIS2/rats//h7/2018-08-13/' '/Volumes/AGHTHESIS2/rats//h7/2018-09-04/' }


%h7_2018-08-28_telemetry.dat
%h7_2018-08-01c_telemetry.dat

datafiles = { 'h1_2018-08-10_telemetry.dat' 'h1_2018-09-04_telemetry.dat' 'h1_2018-09-07_telemetry.dat' 'h7_2018-07-20_telemetry.dat' 'h7_2018-08-01a_telemetry.dat' 'h7_2018-08-08_telemetry.dat' 'h7_2018-08-10_telemetry.dat' 'h7_2018-08-13_telemetry.dat' 'h7_2018-09-04_telemetry.dat' };

for ii=1:length(datafiles);
    load([ '~/Desktop/' datafiles{ii}], '-mat' );
    ts = (0:length(telemetry.y)-1)/29.97;
    figure; plot( telemetry.xytimestampSeconds, telemetry.x); hold on; plot( telemetry.xytimestampSeconds, telemetry.y); plot( telemetry.xytimestampSeconds, (telemetry.onMaze)*130);
    title(datafiles{ii});
end
    

    load([ '~/Desktop/' datafiles{1}], '-mat' );



load([ '~/Desktop/' 'h7_2018-07-20_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats//h7/2018-07-20';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-telemetry.xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-telemetry.xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( telemetry.xytimestampSeconds(end)/60 ) ' min' ] )

figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(xytimestamps)), diff(xytimestamps/1e6) );
% here, there are two video files. I probebly turned the recording back on
% because he started sleeping in the bucket or something like that. The rat
% is clearly not moving in the second video and is in the bucket.
% TODO simply extend the bucket location data out









load([ '~/Desktop/' 'h7_2018-08-28_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats//h7/2018-08-28';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-telemetry.xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-telemetry.xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( telemetry.xytimestampSeconds(end)/60 ) ' min' ] )
% TODO -- FIXED

figure; plot( cscTimestamps(1001:1000:length(cscTimestamps)), diff(cscTimestamps(2:1000:length(cscTimestamps))/1e6) ); hold on;
plot( xytimestamps(2:length(telemetry.xytimestamps)), diff(telemetry.xytimestamps/1e6) );








load([ '~/Desktop/' 'h1_2018-09-07_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats/h1/2018-09-07/';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
cscTimestamps(1)-telemetry.xytimestamps(1)
(cscTimestamps(end)-telemetry.xytimestamps(end))/1e6
(cscTimestamps(end)-cscTimestamps(1))/60e6
telemetry.xytimestampSeconds(end)/60
figure; plot( (2:length(cscTimestamps))/32000, diff(cscTimestamps/1e6) ); hold on;
plot( (2:length(telemetry.xytimestamps))/29.97, diff(telemetry.xytimestamps/1e6) );
% This one has a 32 second gap at the end. It looks like there is just more
% ephys data than there is behavior. In any event the rat is in the bucket.
% TODO extend the behavior data out to the end of the ephys data to reflect
% his bucket state
%
% FIXED
% TODO --


% H7 and H1 on 2018-08-10 have screwed up on-maze graphs.



% h7 2018-08-08
% this one needs to be fixed to reflect the fact that it has 2 video files which need to be joined AND the database is wrong.    
    filepath = [ '/Volumes/AGHTHESIS2/rats/h7/2018-08-08/' ];
    [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
    xytsSec = (xytimestamps-xytimestamps(1))/1e6;
    xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
    xpos = 720-xpos; ypos = 480-ypos;  % invert for these because the camera perspective changed.

load([ '~/Desktop/' 'h7_2018-08-08_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats//h7/2018-08-08';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-telemetry.xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-telemetry.xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( telemetry.xytimestampSeconds(end)/60 ) ' min' ] )
figure; plot( cscTimestamps(2:end), diff(cscTimestamps/1e6) ); hold on;
plot( telemetry.xytimestamps(2:end), diff(telemetry.xytimestamps/1e6) );
% during last ~11 minutes, the rat is in the bucket.
% vid 1 :  00:10:53
% vid 2 :  01:51:17
% the telemetry data seems to be missing about ~9 minutes at the end.
% this probably happened because the telemetry is extracted from the
% videos; my guess is that it was cut off.
% it's also possible that frames dropped?
% I think maybe this is missing the vid 1 data at the front, and then needs
% to have the timstamps interpolated at the end. The gap in the timestamps
% aligns, so the SMI builder worked across multiple files, but perhaps the
% position extractor doesn't do that.
% TODO -- see above. check stuff out. extend the bucket time.    
% FIXED
% TODO rerun telemetry builder. (needs to be adjusted for live view)



% h1 2018-08-10
% this thing has 2 video files. confirm the behavior length is correct with
% the actual ephys data
filepath='/Volumes/AGHTHESIS2/rats/h1/2018-08-10/';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC10.ncs']);
% this day is very confusing. There are 36.816 minutes of recording with a
% maximum gap of ~400 ms. There are 512 gaps of 443 ms (266.8 s or 3.78 
% minutes). The two videos are 25:58 and 7:04 long. Plotting the histogram
% of differences and the sequential version of the differences was
% informative. at Around 4.986e7 data points, the diff spikes to 443 ms. 26
% minutes * 60 sec/min * 32000 samples/sec is 4.992e7 data points, so this
% spike appears to correspond to a brief window when the acquisition was
% turned off and a second video file was created. Adding the gap and the
% two video file lengths, gives a complete record. However, there are only
% 25.96 minutes in the behavior file, suggesting that the NVT was closed
% and not updated during the second part of the recording. 
% FIXED
% TODO rerun telemetry builder. (needs to be adjusted for live view)



load([ '~/Desktop/' 'h1_2018-09-04_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats/h1/2018-09-04/';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
cscTimestamps(1)-telemetry.xytimestamps(1)
(cscTimestamps(end)-telemetry.xytimestamps(end))/1e6
(cscTimestamps(end)-cscTimestamps(1))/60e6
telemetry.xytimestampSeconds(end)/60
% this one seems to check out OK

load([ '~/Desktop/' 'h7_2018-08-01a_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats//h7/2018-08-01a';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-telemetry.xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-telemetry.xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( telemetry.xytimestampSeconds(end)/60 ) ' min' ] )
% ALL GOOD!

load([ '~/Desktop/' 'h7_2018-08-01c_telemetry.dat' ], '-mat' );
filepath='/Volumes/AGHTHESIS2/rats//h7/2018-08-01c';
[ ~, cscTimestamps ]=csc2mat([ filepath '/CSC15.ncs']);
disp([ 'start offset : ' num2str( (cscTimestamps(1)-telemetry.xytimestamps(1))/1e6 ) ' s' ] )
disp([ 'end   offset : ' num2str( (cscTimestamps(end)-telemetry.xytimestamps(end))/1e6 ) ' s' ] )
disp([ 'csc  elapsed : ' num2str( (cscTimestamps(end)-cscTimestamps(1))/60e6 ) ' min' ] )
disp([ 'telem elapsd : ' num2str( telemetry.xytimestampSeconds(end)/60 ) ' min' ] )
% ALL GOOD!



%%



    figure; plot( xytsSec, xpos ); hold on; plot(  xytsSec, ypos ); plot((1:length(telemetry.onMaze))/29.97 ,(telemetry.onMaze)*130);


% /Volumes/AGHTHESIS2/rats//h1/2018-09-05
% 	has 2 lights in video
% 	sw video in room
% 	nw in extraction
% /Volumes/AGHTHESIS2/rats//h1/2018-09-07
% 	has 2 lights in video
% 	sw video in room
% 	1:45:14
% 	nw in extraction	
% /Volumes/AGHTHESIS2/rats//h1/2018-09-08
% 	has 2 lights in video
% 	sw video in room
% 		nw in extraction
% /Volumes/AGHTHESIS2/rats//h1/2018-09-09
% 	has 1 green light in video
% 	sw video in room
% 		nw in extraction
% 
% 
% /Volumes/AGHTHESIS2/rats//h7/2018-08-06
% 	has 2 lights in video
% 	sw video in tent
% 		nw in extraction
% /Volumes/AGHTHESIS2/rats//h7/2018-08-14
% 	has 2 lights in video
% 	nw video in tent
% 		sw in extraction
% /Volumes/AGHTHESIS2/rats//h7/2018-08-31
% 	has 1 green light in video
% 	se video in room
% 	ne in extraction






%% Display the live video extracted tracking data for both R & G channels

load('/Volumes/AGHTHESIS2/rats//h1/2018-09-05/position.mat');
%	has 2 lights in video
subplot(3,3,1);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h1/2018-09-07/position.mat');
%	has 2 lights in video
subplot(3,3,2);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h1/2018-09-08/position.mat');
%	has 2 lights in video
subplot(3,3,3);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h1/2018-09-09/position.mat');
%	has 1 green light in video
subplot(3,3,4);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')

load('/Volumes/AGHTHESIS2/rats//h7/2018-08-06/position.mat');
%	has 2 lights in video
subplot(3,3,5);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h7/2018-08-14/position.mat');
%	has 2 lights in video
subplot(3,3,6);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')
load('/Volumes/AGHTHESIS2/rats//h7/2018-08-31/position.mat');
%	has 1 green light in video
subplot(3,3,7);plot(position.xGpos,position.yGpos,'g'); hold on; plot(position.xRpos,position.yRpos,'r')















%%


rat = 'da5';
folder = '2016-08-25';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
plot(xpos,ypos); hold on;

rat = 'da10';
folder = '2017-09-22';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
plot(xpos,ypos); hold on;

rat = 'h5';
folder = '2018-05-18';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
plot(xpos,ypos); hold on;

rat = 'h7';
folder = '2018-07-25';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
plot(xpos,ypos); hold on;

rat = 'h1';
folder = '2018-09-05';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
plot(xpos,ypos); hold on;

legend('da5','da10','h5','h7','h1')

for ii=-500:50:1500
    line([ -500 1500 ],[ ii ii ], 'Color', [ .1 .9 .9 ] );
    line([ ii ii ],[ -500 1500 ], 'Color', [ .1 .9 .9 ] );
end
 
 axis square; axis([ -200 700 -200 700 ]);
 title([ num2str(ctrShiftX) ' ' num2str(ctrShiftY) ])
 scatter(720/2-ctrShiftX,480/2-ctrShiftY,'o','filled')



%% ????




legend('1','2','3','4','5','6','7','8')
legend('4','5','6','7','8')

figure;
    for ii = 4:length(folders)
        filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folders{ii} '/' ];
        [ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
        xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
        [xpos,ypos]=defishy(xpos,ypos,.000001);
        %plot(xpos,ypos); hold on;
        xt = xpos - 460;
        ys = ypos + 1/15000.*(xt.^2) .* 1/15000.*(ypos.^2);
        xs = xt + (xt./abs(xt)) .* 1/15000.*(xt.^2) .* 1/15000.*(ypos.^2);
        xs = xs + 370;
        ys = ys * 1.15;
        [ xrpos, yrpos ] = rotateXYPositions( xs, ys, 284, 279, 90+44, 450, 450 );
        hold on; plot(xs,ys);
    end
    axis square; axis([ 50 750 -100 700])
    
    
    plot(xrpos,yrpos)

    
    
    
    axis square; axis([ 100 800 0 800])


    figure; plot(xpos,ypos);
    
    
    figure;
    xt = xpos - 460;
    ys = ypos + 1/15000.*(xt.^2) .* 1/15000.*(ypos.^2);
    xs = xt + (xt./abs(xt)) .* 1/15000.*(xt.^2) .* 1/15000.*(ypos.^2);
    xs = xs + 460;
    ys = ys * 1.15;
    hold on; plot(xs,ys);
axis square; axis([ 50 750 -100 700])




% 'h7'
% 2018-08-14 -- unknown; index exceeds matrix dimensions
% 2018-08-27 -- unknown; index exceeds matrix dimensions
% 2018-08-31 --
folder='2018-08-14'; rat='h7';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
figure; plot(xpos,ypos); hold on;
[ aa, bb ] = smi2mat(filepath);



folder='2018-08-31'; rat='h7';
filepath = [ '/Volumes/AGHTHESIS2/rats/' rat '/' folder '/' ];
load([filepath 'position.mat']);
xpos = mean([ position.xGpos; position.xGpos ]);
ypos = mean([ position.yRpos; position.yRpos ]);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
figure; plot(xpos,ypos,'k'); hold on; 
plot(position.xGpos,position.yGpos,'g');  
plot(position.xRpos,position.yRpos,'r');


[~,lfpTimestamps]=csc2mat([filepath 'CSC64.ncs']);

figure; plot(xpos);hold on; plot(position.xxMedianMaxG); plot(position.xxMedianMaxR); plot(position.xGpos);  plot(position.xRpos)


figure; plot(position.xGpos,position.yGpos ,'g'); hold on; plot(position.xRpos,position.yRpos, 'r'); 
figure; plot(position.xGpos); hold on; plot(position.yGpos);


[ xpos, ypos, xytimestamps, headDir, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
figure; plot(xpos,ypos); hold on;
[ smiElapsed, smiTimestamp  ] = smi2mat(filepath);