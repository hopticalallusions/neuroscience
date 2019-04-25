function dist = distanceTraveled( xpos, ypos, timeStart, timeEnd )

xySampleRate = 29.97;

startIdx = round(timeStart * xySampleRate);  % this should really have some defaults\
endIdx = round(timeEnd * xySampleRate);  % this should really have some defaults\
xx=xpos(startIdx:endIdx);
yy=ypos(startIdx:endIdx);

dist=0;

for ii=startIdx:round(xySampleRate/3):endIdx-round(xySampleRate/3)
    jj=ii+round(xySampleRate/3);
    dist = dist + sqrt(( xpos(jj)-xpos(ii) )^2 + ( ypos(jj)-ypos(ii) )^2);
end