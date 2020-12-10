function [ output ] = threeDHistogram( xx, yy, zz, divisionFactorX, divisionFactorY, divisionFactorZ, maxX, maxY, maxZ, offsetX, offsetY, offsetZ, minRequiredSamples, zBins )

if nargin < 14
    zBins = [];
end


xx = xx + offsetX;
yy = yy + offsetY;
zz = zz + offsetZ;


% divide the distribution into 10 even bins
% this function doesn't know anything about this distribution, so this is a
% cheap way to linearize this data to avoid over-representation in one
% particular bin.
%
% Apparently, there exit various methods for automatically determining
% histogram bin width.
% 
% square root : bins = sqrt(n)
% sturges     : bins = ceil(log2(n))
% rice        : bins = 2 * n^(-1/3)
% scott       : bins = ( max(X) - min(X) ) / ( 3.5 * std(X) / cuberoot(n)  )
% freedman-diaconis  : bins = ( max(X) - min(X) ) / ( 2 * IQR(X) / cuberoot(n)  )
% unknown      : 1 + 3.3333 log10(n)
% shimazaki & shinamoto  :  http://www.neuralengine.org
% 
% S&S is more complicated. min( ( 2*mean(X)-var#(X) ) / binWidth^2
%
%
if isempty(zBins)
    uzz=unique(zz);
    first   = prctile( uzz, 10 );
    second  = prctile( uzz, 20 );
    third   = prctile( uzz, 30 );
    fourth  = prctile( uzz, 40 );
    fifth   = prctile( uzz, 50 );
    sixth   = prctile( uzz, 60 );
    seventh = prctile( uzz, 70 );
    eigth   = prctile( uzz, 80 );
    ninth   = prctile( uzz, 90 );
else
    %if ( ceil(max(zz)) > 350 && ceil(max(zz)) < 361 ) && ( floor(min(zz)) > 0 && floor(min(zz)) < 10 )
%     first   = 36;
%     second  = 36*2;
%     third   = 36*3;
%     fourth  = 36*4;
%     fifth   = 36*5;
%     sixth   = 36*6;
%     seventh = 36*7;
%     eigth   = 36*8;
%  ninth   = 36*9;

    first   = zBins(1);
    second  = zBins(2);
    third   = zBins(3);
    fourth  = zBins(4);
    fifth   = zBins(5);
    sixth   = zBins(6);
    seventh = zBins(7);
    eigth   = zBins(8);
    ninth   = zBins(9);

end

%output=zeros( ceil(maxY/divisionFactorX)+1 , ceil(maxX/divisionFactorX)+1, ceil(maxZ/divisionFactorZ)+1 );
output=zeros( ceil(maxY/divisionFactorX)+1 , ceil(maxX/divisionFactorX)+1, 10 );

if (length(xx) ~= length(yy)) | (length(yy) ~= length(zz))
    error('unequal data lengths!!!')
    return;
end

for ii=1:length(xx)
    xxs = floor(xx(ii)/divisionFactorX)+1;
    yys = floor(yy(ii)/divisionFactorY)+1;
    if zz(ii) < first
        zzs = 1;
    elseif zz(ii) < second
        zzs = 2;
    elseif zz(ii) < third
        zzs = 3;
    elseif zz(ii) < fourth
        zzs = 4;
    elseif zz(ii) < fifth
        zzs = 5;
    elseif zz(ii) < sixth
        zzs = 6;
    elseif zz(ii) < seventh
        zzs = 7;
    elseif zz(ii) < eigth
        zzs = 8;
    elseif zz(ii) < ninth
        zzs = 9;
    else
        zzs = 10;
    end
    
    output( yys, xxs, zzs) = output( yys, xxs, zzs) + 1;
end


output(output(:)<minRequiredSamples) = NaN;
