filepath='/Volumes/AGHTHESIS2/rats/h7/2018-08-27/';

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;

figure; plot(xpos,ypos);

rotationalParameters.centerX = 412;
rotationalParameters.centerY = 245;
rotationalParameters.degToRotate = 49;
rotationalParameters.xoffset = 340-4;
rotationalParameters.yoffset = 390-7;
[ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );

[xx,yy]=defishy(xpos,ypos,.0000028);
[ xdfrpos, ydfrpos ] = rotateXYPositions( xx, yy, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
figure;
plot(xrpos,yrpos,'k');
hold on;
plot(xdfrpos, ydfrpos, 'Color', [ .1 .3 .7 ])
binResolution=20;
for ii=binResolution:binResolution:700
    line( [ii ii], [0 700], 'Color', 'r' )
    line( [0 700], [ii ii], 'Color', 'r' )
end








filepath='/Volumes/AHOWETHESIS/h7/2018-08-07_14-16-23/';

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
xytimestampSeconds = (xytimestamps-xytimestamps(1))/1e6;

figure; plot(xpos,ypos);

rotationalParameters.centerX = 412;
rotationalParameters.centerY = 245;
rotationalParameters.degToRotate = -48;
rotationalParameters.xoffset = 340-4;
rotationalParameters.yoffset = 390-7;
[ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );

[xx,yy]=defishy(xpos,ypos,.0000028,0);
[ xdfrpos, ydfrpos ] = rotateXYPositions( xx, yy, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
figure;
plot(xrpos,yrpos,'k');
hold on;
plot(xdfrpos, ydfrpos, 'Color', [ .1 .3 .7 ])
binResolution=20;
for ii=binResolution:binResolution:700
    line( [ii ii], [0 700], 'Color', 'r' )
    line( [0 700], [ii ii], 'Color', 'r' )
end


vidObj = VideoReader([ filepath 'VT1.mpg' ]);
frame = readFrame(vidObj);
bwframe=rgb2gray(frame);
idxX = [ 162 164 170 180 188 206 147 124  83  29  53 110 161 587 591 591 589 582 ];
idxY = [  85 149 217 296 333 418  84 109 161 227 369 421 457 153 194 246 301 372 ];
[xx,yy]=defishy(idxX,idxY,.0000028,0);
figure;
hold on; imshow(bwframe); hold on;
scatter(idxX,idxY); scatter(xx,yy)



vidObj = VideoReader([ filepath 'VT1.mpg' ]);
figure;
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
frameIdx=1;  plotFrames = 0;
vidObj.CurrentTime = 800; plotFrames = 1;
frame = readFrame(vidObj);
figure;
imshow(frame);
bwframe=rgb2gray(frame);
bwframeArray=bwframe(:);
rebuiltFrame = reshape(bwframeArray, 480, 720);
imshow(rebuiltFrame)

idxX=zeros(1,length(bwframeArray));
idxY=zeros(size(idxX));
kk=1;
for ii=1:720
    for jj=1:480
        idxX(kk) = ii;
        idxY(kk) = jj;
        kk=kk+1;
    end
end

[xx,yy]=defishy(idxX,idxY,.5);
    


idxX = [ 55 57 66 70 77 ];
idxY = [ 223 148 353 6 439  ] ;
[xx,yy]=defishy(idxX,idxY,.0000028,0);
figure;
hold on; imshow(bwframe); hold on;
scatter(idxX,idxY); scatter(xx,yy)




syms k_1 k_2 p_1 p_2 real
syms r x y
distortionX = subs(x * (1 + k_1 * r^2 + k_2 * r^4) + 2 * p_1 * x * y + p_2 * (r^2 + 2 * x^2), r, sqrt(x^2 + y^2))
distortionY = subs(y * (1 + k_1 * r^2 + k_2 * r^4) + 2 * p_2 * x * y + p_1 * (r^2 + 2 * y^2), r, sqrt(x^2 + y^2))
parameters = [k_1 k_2 p_1 p_2];
parameterValues = [-0.15 0 0 0];
figure;
plotLensDistortion(distortionX,distortionY,parameters,parameterValues)




length(bwframe(:))




filepath='/Volumes/AHOWETHESIS/h7/2018-08-13_17-25-37/';

[ xpos, ypos, xytimestamps, ~, ~ ]=nvt2mat([ filepath '/VT0.nvt']);
xpos=nlxPositionFixer(xpos); ypos=nlxPositionFixer(ypos);
hold on; plot(xpos,ypos,'r') ;

figure; 
plot(xpos,ypos); hold on;
[xx,yy]=defishy(xpos,ypos,.0000028,0);
plot(xx,yy);

rotationalParameters.centerX = 412;
rotationalParameters.centerY = 245;
rotationalParameters.degToRotate = -42;
rotationalParameters.xoffset = 340-4;
rotationalParameters.yoffset = 390-7;
[ xrpos, yrpos ] = rotateXYPositions( xpos, ypos, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
[ xdfrpos, ydfrpos ] = rotateXYPositions( xx, yy, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
figure;
plot(xrpos,yrpos,'k');
hold on;
plot(xdfrpos, ydfrpos, 'Color', [ .1 .3 .7 ])
binResolution=20;
for ii=binResolution:binResolution:700
    line( [ii ii], [0 700], 'Color', 'r' )
    line( [0 700], [ii ii], 'Color', 'r' )
end


[xx,yy]=defishy(xpos,ypos,.0000028,0);  %0.0000028; 4e-4; 2e-4
subplot(1,3,1); plot(xpos,ypos); axis square; axis([0 700 0 700])
subplot(1,3,2); plot(xx,yy); axis square; axis([0 850 -100 750])
[ xrpos, yrpos ] = rotateXYPositions( xxstretch, yystretch, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
subplot(1,3,3); plot(xrpos,yrpos); axis square; axis([0 850 -100 750])



%this is pretty good
[xx,yy]=defishy(xpos,ypos,.0000025,0);  %0.0000028; 4e-4; 2e-4
for ii=1:length(yy)
    yystretch(ii) = yy(ii)+(4e-4)*(yystretch(ii))^2;
    xxstretch(ii) = xx(ii)-(1e-4)*(800-xxstretch(ii))^2 ;
end
subplot(1,3,1); plot(xx,yy); axis square
subplot(1,3,2); plot(xxstretch,yystretch); axis square
rotationalParameters.centerX = 409;
rotationalParameters.centerY = 362;
rotationalParameters.degToRotate = -46;
rotationalParameters.xoffset = 450;
rotationalParameters.yoffset = 500;
[ xrpos, yrpos ] = rotateXYPositions( xxstretch, yystretch, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
subplot(1,3,3); plot(xrpos,yrpos); axis square
binResolution=40;
for ii=binResolution:binResolution:1000
    line( [ii ii], [ min(xrpos) 1000], 'Color', 'r' )
    line( [ min(yrpos) 1000], [ii ii], 'Color', 'r' )
end























yy = yy+100;


figure; plot(xpos,ypos)

yystretch = yy;
xxstretch = xx;

[xx,yy]=defishy(xpos,ypos,.0000025,0);  %0.0000028; 4e-4; 2e-4
for ii=1:length(yy)
    yystretch(ii) = yy(ii)+(2e-4)*(293-yystretch(ii))^2;
    xxstretch(ii) = xx(ii)+(1e-4)*(495-xxstretch(ii))^2 ;
end
subplot(1,3,1); plot(xx,yy); axis square
subplot(1,3,2); plot(xxstretch,yystretch); axis square
rotationalParameters.centerX = 409;
rotationalParameters.centerY = 362;
rotationalParameters.degToRotate = -46;
rotationalParameters.xoffset = 450;
rotationalParameters.yoffset = 500;
[ xrpos, yrpos ] = rotateXYPositions( xxstretch, yystretch, rotationalParameters.centerX, rotationalParameters.centerY, rotationalParameters.degToRotate, rotationalParameters.xoffset, rotationalParameters.yoffset );
subplot(1,3,3); plot(xrpos,yrpos); axis square
binResolution=40;
for ii=binResolution:binResolution:1000
    line( [ii ii], [ min(xrpos) 1000], 'Color', 'r' )
    line( [ min(yrpos) 1000], [ii ii], 'Color', 'r' )
end


sqrt( ( 408-147 )^2 + ( 356-111 )^2 )
sqrt( ( 408-681 )^2 + ( 356- 91 )^2 )
sqrt( ( 408-685 )^2 + ( 356-619 )^2 )
sqrt( ( 681-147 )^2 + (  91-111 )^2 )
sqrt( ( 681-685 )^2 + (  91-619 )^2 )
