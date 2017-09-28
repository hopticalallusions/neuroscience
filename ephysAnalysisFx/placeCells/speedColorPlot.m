function speedColorPlot( xpos, ypos, pxPerCm )

    if nargin < 2
        error('not enough arguments!');
    end
    
    if nargin < 3
        pxPerCm = 1;
        legendText = 'px/s';
    else
        legendText = 'cm/s';
    end

    speed=calculateSpeed(xpos, ypos, pxPerCm); 
    
    x = xpos;
    y = ypos;
    z = zeros(size(x));
    figure;
    h = surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], [speed(:), speed(:)], ...
                 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
    colormap( build_NOAA_colorgradient ); colorbar;
    title('place by speed plot');
    legend(legendText);
    
end