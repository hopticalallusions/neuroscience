function speed = calculateSmoothedSpeed( xpos, ypos, boxcarSize, pxPerCm, framesPerSecond )

    if nargin < 4
        warning('NO cm/px value provided!! returning px/s!')
        pxPerCm = 1;
    end
    
    if nargin < 5
        %warning('framesPerSecond defaulted to 29.97.')
        framesPerSecond = 29.97; % neuralynx default.
    end
    
    if nargin < 3
        boxcarSize = 45; % second
    end

    dx = zeros(size(xpos));
    dy = zeros(size(ypos));
    for kk=2:length(dx)-1
        dy(kk)=( ypos(kk-1) - ypos(kk+1) );
        dx(kk)=( xpos(kk-1) - xpos(kk+1) );
    end
    dxs=conv(dx,ones(1,boxcarSize)/boxcarSize, 'same');
    dys=conv(dy,ones(1,boxcarSize)/boxcarSize, 'same');
    speed = sqrt( ( dxs ).^2 + ( dys ).^2 ) * (1/2) * 1/pxPerCm * framesPerSecond;

    return;

end

