function hh = plotColoredLine( xx, yy, cc )

    sz = size(xx);
    if sz(2)>sz(1) 
        xx=xx';
    end
    sz = size(yy);
    if sz(2)>sz(1) 
        yy=yy';
    end
    sz = size(cc);
    if sz(2)>sz(1) 
        cc=cc';
    end

    zz = zeros(size(xx))';
    hh = surface([xx(:), xx(:)], [yy(:), yy(:)], [zz(:), zz(:)], [cc, cc], 'EdgeColor', 'flat', 'FaceColor','none', 'LineWidth', 1.5);
    
end