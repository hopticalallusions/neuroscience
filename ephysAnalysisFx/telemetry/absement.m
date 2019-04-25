function absmnt = absement( xpos, ypos, timeStart, timeEnd, refX, refY, pxPerCm)

xySampleRate = 29.97;
if nargin<7
    pxPerCm = 2.7;
end
if nargin < 5
    refX=0;
    refY=0;
end
if nargin < 3
    timeStart=0;
    timeEnd = length(xpos)*xySampleRate;
end

pxPerM = pxPerCm/100;

startIdx = round(timeStart * xySampleRate)+1;  % this should really have some defaults\
endIdx = round(timeEnd * xySampleRate);  % this should really have some defaults\

absmnt=0;
dt=1/round(xySampleRate/3);  % seconds

for ii=startIdx:round(xySampleRate/3):endIdx-round(xySampleRate/3)
    jj=ii+round(1/dt);
    absmnt = absmnt + (  sqrt(( refX-xpos(ii) )^2 + ( refY-ypos(ii) )^2) *pxPerM * dt );
end

