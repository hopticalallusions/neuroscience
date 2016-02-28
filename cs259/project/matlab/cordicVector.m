function [ angle, hypotenuse ] = cordicVector(xo,yo,n)

    % For reference, see 
    % especially for FPGA 
    %     http://www.ee.ic.ac.uk/pcheung/teaching/ee3_DSD/crdcsrvy.pdf
    % also
    %     http://www.uio.no/studier/emner/matnat/ifi/INF5430/v12/undervisningsmateriale/dirk/Lecture_cordic.pdf
    %     http://www.qc.cuny.edu/Academics/Degrees/DMNS/Faculty%20Documents/Sultan1.pdf
    % most introductory
    %     http://1uffakind.com/pdf/CORDICForDummies.pdf
    %

    % This function computes angle and hypotenuse of a point in 2 space
    % using n iterations. Increasing n will increase the precision.

    if ( xo > 0 ) %&& ( yo > 0 )
        offset = 0;
    else
        xo = abs(xo);
        offset = 90;
    end
    xx = zeros(1,n+1); xx(1) = xo;
    yy = zeros(1,n+1); yy(1) = yo;
    zz = zeros(1,n+1); zz(1) = 0;

    if n>25
        n=25;
        disp('limiting iterations to 25');
    end

    % the following is a table of arctan values for the small steps used to
    % binary search for the angle and hypotenuse of the provided coordinate
    %
    % these can be converted into degrees for better integer representation
    % of the data in hardware (non-floating point calculations)
    arctanLookup = [                                                              ...
        0.78539816339745   0.46364760900081   0.24497866312686   0.12435499454676 ...
        0.06241880999596   0.03123983343027   0.01562372862048   0.00781234106010 ...
        0.00390623013197   0.00195312251648   0.00097656218956   0.00048828121119 ...
        0.00024414062015   0.00012207031189   0.00006103515617   0.00003051757812 ...
        0.00001525878906   0.00000762939453   0.00000381469727   0.00000190734863 ...
        0.00000095367432   0.00000047683716   0.00000023841858   0.00000011920929 ...
        0.00000005960464   0.00000002980232   0.00000001490116   0.00000000745058 ];

    % perform a series of psuedo-rotations to anneal y to zero,
    % accumulating the angle of rotation required in z and measuring the
    % hypotenuse in x

    for itr = 2:n+1
        % dd is simply a switch which determines whether an add or a
        % subtract occurs
        if yy(itr-1) < 0
            dd = 1;
        else
            dd = -1;
        end
        % ii is the actual iteration / power of i, but matlab is 1 based, not
        % zero based, so the +1 compensates for this design.
        ii=itr-2;
        % xx is the "x" (real) coordinate of the signal
        % yy is the "y" (imaginary) coordinate of the signal from the
        %     Hilbert xform
        % zz is the angle, initialized to zero
        xx(itr) = xx(ii+1) - ( dd * yy(ii+1) * 2^(-(ii)) );
        yy(itr) = yy(ii+1) + ( dd * xx(ii+1) * 2^(-(ii)) );
        zz(itr) = zz(ii+1) - ( dd * arctanLookup(ii+1) );

    end

    %
    % to calculate the exact correction term  
    % ww=sqrt(2); for ii=1:10; ww=ww*sqrt(1+(2^(-2*ii))); end; ww
    %
    % need to multiply by the scaling factor .6073 whatever for hypotenuse
    % return a psuedo-rotation corrected length for each step
    % xx(2:end)=xx(2:end)*0.6073;
    %

    hypotenuse = xx(n)*.6073;
    if zz(n) < 0
        angle = 360 - offset + zz(n)*180/pi ;
    else
        angle = offset + zz(n)*180/pi ;
    end

    return

endfunction