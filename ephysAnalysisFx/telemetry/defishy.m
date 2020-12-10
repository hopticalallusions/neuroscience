function [ sourceX, sourceY ] = defishy( xx, yy, strength )

    kk(1) = strength;
    kk(2) = 0; % zoom;  % determined through experimentation to not actually be helping
    kk(3) = 0;
    pp(1) = 0 ; %.00005;
    pp(2) = 0;

    rr = sqrt((xx-720/2).^2 + (yy-480/2).^2);   % taken from the center of the image because the radial distortion due to the lens is from the center of the image
    
    %rr = sqrt((xx-425).^2 + (yy-180).^2);   % this is an estimate of where the camera is located over the image.
    
    rrp = sqrt((xx-494).^2 + (yy-232).^2);  % this is an estimate of where the camera is located over the image.
    
    xRecenteredLens = (xx-720/2);
    yRecenteredLens = (yy-480/2);
    xRecenteredCam =  (xx-494);
    yRecenteredCam =  (yy-232);
    sourceX = ( 1 + kk(1).*rr.^2 + kk(2).*rr.^4 + kk(3).*rr.^6 ).*xRecenteredLens + pp(1).*(2.*xRecenteredCam.^2 + rrp.^2) + 2.*pp(2).*xRecenteredCam; % xRecenteredCam isn't right, but I'm not sure what bar_{xy} means in http://lear.inrialpes.fr/people/triggs/pubs/isprs96/node10.html
    sourceY = ( 1 + kk(1).*rr.^2 + kk(2).*rr.^4 + kk(3).*rr.^6 ).*yRecenteredLens + pp(1).*(2.*yRecenteredCam.^2 + rrp.^2) + 2.*pp(2).*yRecenteredCam;
    sourceX = sourceX +720/2;
    sourceY = sourceY +480/2;






%     % based on http://www.tannerhelland.com/4743/simple-algorithm-correcting-lens-distortion/
%     % A simple algorithm for correcting lens distortion
%     % Tanner Helland
%     % posted February 10, 2013
%     % accessed December 9, 2018
% 
%     if nargin < 3
%         strength = 1;
%     end
% 
%     if nargin < 4
%         zoom = 1;
%     end
% 
%     if nargin < 6
%         imageWidth = 720;
%         imageHeight = 480;
%     end
%     
%     % 
%     halfWidth = imageWidth / 2;
%     halfHeight = imageHeight / 2;
%     
%     if strength == 0 
%         strength = 0.00001;
%     end
%     
%     correctionRadius = sqrt( imageWidth ^ 2 + imageHeight ^ 2) / strength;
% 
%     for ii= 1:length(xx)
%         
%         newX = xx(ii) - halfWidth;
%         newY = yy(ii) - halfHeight;
% 
%         distance = sqrt(newX ^ 2 + newY ^ 2);
%         r = distance / correctionRadius;
%         
%         if r == 0 
%             theta = 1;
%         else
%             theta = atan(r) / r;
%         end
% 
%         sourceX(ii) = halfWidth + theta * newX * zoom;
%         sourceY(ii) = halfHeight + theta * newY * zoom;
% 
%     end
    
return;
