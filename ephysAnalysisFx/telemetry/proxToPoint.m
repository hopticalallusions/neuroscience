function prox = proxToPoint( xpos, ypos, fixedX, fixedY )
    dist=  distFromPoint( xpos, ypos, fixedX, fixedY );
    edgelessMax = max(dist(60:end-60)); % super cheap fix. sigh.
    prox = 1 - ( dist / max(edgelessMax) );
    return;
end