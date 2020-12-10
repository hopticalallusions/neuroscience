% this script is for manually calibrating the camera's distorted image of
% the tracking area using a photoshop-corrected registration image
%
% it doesn't work well to try to fix the perspective skewing and also the
% rotation at the same time

% read images
distortedImage=imread('~/Desktop/mazetracking.jpg');
fixedImage=imread('~/Desktop/undistortedRotatedUnskewed.png');
% display images
figure; imshowpair(distortedImage,fixedImage,'montage');
% manually select pairs of control points from each image
cpselect(distortedImage,fixedImage);
% calculate the transform
tform = fitgeotrans(movingPoints3,fixedPoints3,'projective');
% demonstrate the transform
Jregistered = imwarp(fixedImage,tform,'OutputView',imref2d(size(distortedImage)));
figure
imshow(Jregistered)

% need to have some x and y positions loaded.
%
% this will undistort the x-y positions into 
temp=tform.T*[ xpos ypos ones(size(xpos)) ]';

figure;  plot(xpos,ypos); hold on; plot(temp(1,:),temp(2,:))






[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat('/Volumes/Seagate Expansion Drive/telemetryCalibration/VT0.nvt');
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds=(xytimestamps-xytimestamps(1))/1e6;
speed = calculateSpeed( xpos, ypos, 1, 2.63);
figure; plot(xpos,ypos);


idealMazePointsX = [ -78,  78,  78, -78,   0,  42,   0, -42 ]; % idealMazePointsX = [   0, 109,    0, -109 ];
idealMazePointsY = [  78,  78, -78, -78,  42,   0, -42,   0 ]; % idealMazePointsY = [ 109,   0, -109,    0 ];
idealMazePoints = [ idealMazePointsX' idealMazePointsY' ];
% [xr,yr]=rotateXYPositions(idealMazePointsX, idealMazePointsY, 0,0, 45, 0,0)
% figure; scatter(xr,yr)
actualMazePointsX = [ -276,  261,  217, -224,  -2, 140,   -2, -139 ];
actualMazePointsY = [  235,  245, -195, -199, 138,   4, -117,   -7 ];
actualMazePoints = [actualMazePointsX' actualMazePointsY' ];
tform = fitgeotrans(actualMazePoints,idealMazePoints*2.9,'projective');
temp=tform.T*[ xpos-335 ypos-209 ones(size(xpos)) ]';
figure;  plot(xpos-335,ypos-209); hold on; plot(temp(1,:),temp(2,:))



tform = fitgeotrans(actualMazePoints,idealMazePoints,'polynomial',2);
temp=tform.T*[ xpos-335 ypos-209 ones(size(xpos)) ]';
figure;  plot(xpos,ypos); hold on; plot(temp(1,:),temp(2,:))


xx=xpos-335; yy=ypos-209;
T=tform.T;

temp=T*[ xx yy ones(size(xpos)) ]';
figure;  plot(xx,yy); hold on; plot(temp(1,:),temp(2,:))



xx=xpos+335; yy=ypos+209;

%% remove barrel distortion (depends on the zoom and aperature and whatnot of the camera)
%
% do this step first, then do the next mappings to fix the lens distortion


[ xx, yy, xytimestamps, ~, ~ ]=nvt2mat('/Volumes/Seagate Expansion Drive/2018-04-30_calibrateAgain/VT0.nvt');
xx=nlxPositionFixer(xx); yy=nlxPositionFixer(yy);

imageWidth=720;
imageHeight=480;
halfWidth=imageWidth/2;
halfHeight=imageHeight/2;
zoom=1;

strength=2;
correctionRadius = sqrt(imageWidth ^ 2 + imageHeight ^ 2) / strength;

for idx = 1:length(xx)
    
    newX = xx(idx) - halfWidth;
    newY = yy(idx) - halfHeight;

    distance = sqrt(newX ^ 2 + newY ^ 2);
    rr = distance / correctionRadius;
    if rr == 0
        theta = 1;
    else
        theta = atan(rr) / rr;
    end
     xxc(idx) = halfWidth + theta * newX * zoom;
     yyc(idx) = halfHeight + theta * newY * zoom;
end

figure; hold on; plot(xx,yy); plot(xxc,yyc)






%                        middle arm ends; square platform points;
idealMazePointsX = [   0, 109,    0, -109, 29,  29, -29, -29,      ];
idealMazePointsY = [ 109,   0, -109,    0, 29, -29, -29,  29,      ];

%                   N rt side arm points; N lt side arm points |  W hi side arm points; W lo side arm points |  E hi side arm points; E lo side arm points |    S hi side arm points; S lo side arm points |  center square pts  |   NE sq. arm |  SE sq. arm   |  SW sq. arm    | NW sq. arm     |   NE sq. arm |  SE sq. arm   |  SW sq. arm    | NW sq. arm   
idealMazePointsX = [   5,   5,    5,    5,  -5,  -5,   -5,   -5, -109, -97,  -83,  -29, -109, -97,  -83,  -29,  109,  97,   83,   29,  109,  97,   83,   29,     5,   5,    5,    5,   -5,  -5,   -5,   -5,   29,  29, -29, -29,    51,  25, 77,  51,  25,  77,   -51,  -25, -77,  -51,  -25, -77 ,    44,  22, 66,  44,  22,  66,   -44,  -22, -66,  -44,  -22, -66 ];
idealMazePointsY = [ 109,  97,   83,   29, 109,  97,   83,   29,    5,   5,    5,    5,   -5,  -5,   -5,   -5,    5,   5,    5,    5,   -5,  -5,   -5,   -5,  -109, -97,  -83,  -29, -109, -97,  -83,  -29,   29, -29, -29,  29,    51,  77, 25, -51, -77, -25,   -51,  -77, -25,   51,   77,  25 ,    44,  66, 22, -44, -66, -22,   -44,  -66, -22,   44,   66,  22 ];

idealMazePointsX = idealMazePointsX *2.9; 
idealMazePointsY = idealMazePointsY *2.9;

[ idealMazePointsX ,idealMazePointsY ] = rotateXYPositions(idealMazePointsX ,idealMazePointsY, 0,0,45, 427,238);
figure;  hold on; plot(xx,yy); scatter(idealMazePointsX, idealMazePointsY);





[ idealMazePointsX ,idealMazePointsY ] = rotateXYPositions(idealMazePointsX ,idealMazePointsY, 427,238, -45, 0,0);
[ xr ,yr ] = rotateXYPositions(xx ,yy, 427,238, -45, 0,0);
figure;  hold on; plot(xr,yr); scatter(idealMazePointsX, idealMazePointsY);


%                     N rt side arm points; N lt side arm points |  W hi side arm points; W lo side arm points |  E hi side arm points; E lo side arm points |    S hi side arm points; S lo side arm points |  center square pts  |   NE sq. arm   |  SE sq. arm      |  SW sq. arm      | NW sq. arm     ||  NE sq. arm  |  SE sq. arm    |  SW sq. arm      |   NW sq. arm   
actualMazePointsX = [  -2,   1,    1,    7, -36, -37,  -36,  -30, -354, -328, -289, -353, -332, -284, -94,  -95,  307, 275,  253,   92, 310,  283,  253,   94,    30,   30,   32,   27,   -3,   -8,  -10, -12,   85, 101, -90, -93,    152,  65, 211,  176,   92, 244,   -161,  -81, -249, -193, -85, -292,  133,  54, 186,  143,   78, 206,  -135,  -66, -215,  -171,  -70, -248 ];
actualMazePointsY = [ 319, 287,  259,  102, 329, 291,  261,  107,   59,   56,   49,   30,   27,   22,  34,    8,   12,  13,   15,   32,  -25, -15,  -13,   -8,  -328, -298, -245, -101, -330, -298, -249, -98,   84,-100, -93, 104,    150, 244,  92, -162, -242, -73,   -154, -238,  -70,  189, 267,  102,  133, 212,  73, -140, -203, -63,  -134, -202,  -57,   160,  235,   89 ];

figure;  hold on; plot(xr,yr); scatter(idealMazePointsX, idealMazePointsY); scatter(actualMazePointsX, actualMazePointsY,'*')


idealMazePoints = [ idealMazePointsX' idealMazePointsY' ];
actualMazePoints = [actualMazePointsX' actualMazePointsY' ];
tform = fitgeotrans(actualMazePoints,idealMazePoints,'projective');
temp=tform.T*[ xr yr ones(size(xr)) ]';
figure;  hold on; plot(xr,yr);  plot(temp(1,:),temp(2,:)); scatter(idealMazePointsX, idealMazePointsY); scatter(actualMazePointsX, actualMazePointsY,'*')

