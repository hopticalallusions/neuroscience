%function [ angle, hypotenuse ] = corvec(xo,yo)
clear all; close all;
oa=89;
yo=sin(oa*pi/180);
xo=cos(oa*pi/180);

    n=40;
    if ( xo > 0 ) %&& ( yo > 0 )
        xx = xo;
        yy = yo;
        zz = pi;  %0 offset
    else 
        if ( yo < 0 )
            xx = -yo;
            yy = xo;
            zz = pi/2; %-pi/2 offset
        else
            xx = yo;
            yy = -xo;
            zz = 3*pi/2; %pi/2 offset
        end
    end
    
    
    
    xh = zeros(1,n+1); xh(1) = xx;
    yh = zeros(1,n+1); yh(1) = yy;
    zh = zeros(1,n+1); zh(1) = zz;

    arctanLookup = atan(2.^-(0:n));
    gainCorrection = 1/prod(sqrt(1+(2.^(-2.*(0:n)))));

    
    for ii = 0:n-1
        ih = ii+2;
        yLast = yy;
        xLast = xx;
        if ( yy < 0 )
            %xx = xx - ( yLast * 2^-ii );  xh(ih)=xx;  
            %yy = yy + ( xLast * 2^-ii );  yh(ih)=yy;
            xx = xx - ( yLast / bitshift(1,ii) ); xh(ih)=xx;  
            yy = yy + ( xLast / bitshift(1,ii) ); yh(ih)=yy;
            %xx = xx - bitshift( yLast , -bitshift(1,ii) ); xh(ih)=xx;  
            %yy = yy + bitshift( xLast , -bitshift(1,ii) ); yh(ih)=yy;
            zz = zz - ( arctanLookup(ii+1) );     zh(ih)=zz;
        else
            %xx = xx + ( yLast * 2^-ii );  xh(ih)=xx;
            %yy = yy - ( xLast * 2^-ii );  yh(ih)=yy;
            xx = xx + ( yLast / bitshift(1,ii) ); xh(ih)=xx;  
            yy = yy - ( xLast / bitshift(1,ii) ); yh(ih)=yy;
            %xx = xx + bitshift( yLast , -bitshift(1,ii) ); xh(ih)=xx;  
            %yy = yy - bitshift( xLast , -bitshift(1,ii) ); yh(ih)=yy;
            zz = zz + ( arctanLookup(ii+1)  );  zh(ih)=zz; 
        end
    end

    %zz=offset+zz;
    hypotenuse = xx*gainCorrection;
    angle = zz*180/pi ;

    figure;
    subplot(3,1,1); plot(zh*180/pi,'o-k');
    subplot(3,1,2); plot(yh,'o-r');
    subplot(3,1,3); plot(xh,'o-b');

    disp(['hyp = ' num2str(hypotenuse) '  angle = ' num2str(angle) ]);
    
return
%     figure;
%     for ii=1:9;
%         gc = 1/prod(sqrt(1+(2.^(-2.*(0:n))))); 
%         subplot(3,3,ii); 
%         line([ -10 10 ],[ 0 0 ], 'Color', 'k'); line([ 0 0 ],[ -10 10 ], 'Color', 'k');
%         line([ 0 xh(ii)*gc ],[ 0 yh(ii) ], 'Color', rand(3,1)); axis([ -2 2 -2 2 ]);
%     end
    
    
    %return
%end



% 
% clear all; close all;
% 
% oa=90;
% yo=cos(oa*pi/180);
% xo=sin(oa*pi/180);
% n=25; 
% 
%     if ( xo > 0 ) %&& ( yo > 0 )
%         offset = 0;
%     else
%         xo = -xo;
%         yo = -yo;
%         offset = 180;
%     end
%     xx = zeros(1,n+1); xx(1) = xo;
%     yy = zeros(1,n+1); yy(1) = yo;
%     zz = zeros(1,n+1); zz(1) = 0;
% 
%     if n>25
%         n=25;
%         disp('limiting iterations to 25');
%     end
% 
%     % the following is a table of arctan values for the small steps used to
%     % binary search for the angle and hypotenuse of the provided coordinate
%     %
%     % these can be converted into degrees for better integer representation
%     % of the data in hardware (non-floating point calculations)
%     arctanLookup = [                                                              ...
%         0.78539816339745   0.46364760900081   0.24497866312686   0.12435499454676 ...
%         0.06241880999596   0.03123983343027   0.01562372862048   0.00781234106010 ...
%         0.00390623013197   0.00195312251648   0.00097656218956   0.00048828121119 ...
%         0.00024414062015   0.00012207031189   0.00006103515617   0.00003051757812 ...
%         0.00001525878906   0.00000762939453   0.00000381469727   0.00000190734863 ...
%         0.00000095367432   0.00000047683716   0.00000023841858   0.00000011920929 ...
%         0.00000005960464   0.00000002980232   0.00000001490116   0.00000000745058 ];
% 
%     % perform a series of psuedo-rotations to anneal y to zero,
%     % accumulating the angle of rotation required in z and measuring the
%     % hypotenuse in x
% 
%     for itr = 2:n+1
%         % dd is simply a switch which determines whether an add or a
%         % subtract occurs
%         if yy(itr-1) < 0
%             dd = 1;
%         else
%             dd = -1;
%         end
%         % ii is the actual iteration / power of i, but matlab is 1 based, not
%         % zero based, so the +1 compensates for this design.
%         ii=itr-2;
%         % xx is the "x" (real) coordinate of the signal
%         % yy is the "y" (imaginary) coordinate of the signal from the
%         %     Hilbert xform
%         % zz is the angle, initialized to zero
% %        xx(itr) = xx(ii+1) - ( dd * yy(ii+1) * 2^(-(ii)) );
% %        yy(itr) = yy(ii+1) + ( dd * xx(ii+1) * 2^(-(ii)) );
%         pwr=1;for jj=1:ii; pwr=pwr*2; end;
%         xx(itr) = xx(ii+1) - ( dd * yy(ii+1) / pwr );
%         yy(itr) = yy(ii+1) + ( dd * xx(ii+1) / pwr  );
%         zz(itr) = zz(ii+1) - ( dd * arctanLookup(ii+1) );
% 
%     end
% 
%     %
%     % to calculate the exact correction term  
%     % ww=sqrt(2); for ii=1:10; ww=ww*sqrt(1+(2^(-2*ii))); end; ww
%     % or
%     % 1/prod(sqrt(1+(2.^(-2.*(0:n)))))
%     %
%     % need to multiply by the scaling factor .6073 whatever for hypotenuse
%     % return a psuedo-rotation corrected length for each step
%     % xx(2:end)=xx(2:end)*0.6073;
%     %
% 
%     figure;
%     subplot(3,1,1); plot(zz*180/pi,'o-k'); legend('\theta');
%     subplot(3,1,2); plot(yy,'o-r'); legend('y');
%     subplot(3,1,3); plot(xx,'o-b'); legend('x');
%     
%     hypotenuse = xx(n)*.6073;
%     angle = 270 - offset + zz(n)*180/pi;
%     disp(['hyp = ' num2str(hypotenuse) '  angle = ' num2str(angle) ]);
%     return
