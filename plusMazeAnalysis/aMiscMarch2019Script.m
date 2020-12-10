
rats = { 'h1', 'h5', 'h7', 'da5', 'da10' };
for rr=1:length(rats)
    folderList = GetSubDirsFirstLevelOnly([ '/Volumes/AGHTHESIS2/rats/' rats{rr} ]);
    for ff = 1:length(folderList)
        packageTelelmetry()





telem = packageTelemetry( xrpos, yrpos, xytimestamps, headDir, 'h1', '2018-09-14' );



x = xrpos;
y = yrpos;
z = zeros(size(x));
figure;
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [telem.movDir(:), telem.movDir(:)], ...
             'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap( buildCircularGradient ); colorbar;
axis square;
axis([ -150 150 -150 150 ])

figure; plot(telem.movDir)

figure; plot(diff(unwrap(telem.movDir*2*pi/180)))
hold on; plot(telem.onMaze)

% After Redish, ...
% Discrete-Time Adaptive Windowing for Velocity Estimation
% Farrokh Janabi-Sharifi, Vincent Hayward, and Chung-Shin J. Chen
% IEEE TRANSACTIONS ON CONTROL SYSTEMS TECHNOLOGY, VOL. 8, NO. 6, NOVEMBER 2000 1003

displacement = [ 0; sqrt(  (xrpos(2:end)-xrpos(1:end-1)).^2  +  (yrpos(2:end)-yrpos(1:end-1)).^2 )];
xytimes = (xytimestamps-xytimestamps(1))/1e6;
speed = zeros(size(displacement));
origin=1;
stepsize=1;
while origin+stepsize < 200 % length(xrpos)
    fitParams = polyfit( xytimes(origin:origin+stepsize), displacement(origin:origin+stepsize), 1 );
    fitVals   = polyval( fitParams, xytimes(origin:origin+stepsize) );
    fitResidual = displacement(origin:origin+stepsize) - fitVals;
    if max(fitResidual) < 3
        stepsize = stepsize + 1;
        max(fitResidual)
    else
        speed( origin:origin+stepsize-1 ) = fitParams(1);
        origin = origin+stepsize;
        stepsize = 1;
    end
end



figure; subplot(1,2,1);
x = xrpos; y = yrpos; z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [telem.speed(:), telem.speed(:)], ...
             'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap( build_NOAA_colorgradient ); colorbar; axis square; axis([ -150 150 -150 150 ]);
subplot(1,2,2);
x = xrpos; y = yrpos; z = zeros(size(x));
h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
             'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
colormap( build_NOAA_colorgradient ); colorbar; axis square; axis([ -150 150 -150 150 ]);


figure; histogram(speed)
