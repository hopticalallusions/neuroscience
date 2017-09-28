function dist=distFromPoint( xpos, ypos, fixedX, fixedY )
    dist=sqrt(cast((((xpos-fixedX)).^2+((ypos-fixedY)).^2), 'double'));
    return;
end