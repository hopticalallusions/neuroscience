function speedColorPlot( xpos, ypos, pxPerCm, stillPeriods )

    if nargin < 2
        error('not enough arguments!');
    end
    
    if nargin < 3
        pxPerCm = 1;
        legendText = 'px/s';
    else
        legendText = 'cm/s';
    end
    
    if nargin < 4
        stillPeriods = ones(size(xpos))';
    end

    speed=stillPeriods.*calculateSpeed(xpos, ypos, 1, pxPerCm, 29.97); 
    
    x = xpos;
    y = ypos;
    z = zeros(size(x));
    %figure;
    h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
                 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
    colormap( build_NOAA_colorgradient ); colorbar;
    title('place by speed plot');
    legend(legendText);
    
end