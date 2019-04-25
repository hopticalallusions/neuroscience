function [ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, centerX, centerY, angles, xadj, yadj)

    theta= median(angles*pi/180);

    xpos = xpos - centerX;
    ypos = ypos - centerY;

    xrpos= xpos.*cos(theta) - ypos.*sin(theta); 
    %xrpos=round(xrpos-min(xrpos)+1); % shift, and make integer
    xrpos=floor(xrpos); % shift, and make integer
    
    yrpos= ypos.*cos(theta) + xpos.*sin(theta); 
    %yrpos=round(yrpos-min(yrpos)+1); % shift, and make integer
    yrpos=floor(yrpos); % shift, and make integer
    
    xrpos = xrpos + xadj + 1;
    yrpos = yrpos + yadj + 1;
    
    %figure; plot(xrpos,yrpos,'k'); title('rotated and shifted positions');

end