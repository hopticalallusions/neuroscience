
function [gradient] = buildCircularGradient(resolution,offsetFactor);

% use this for phase plots and other circular data

if (nargin < 1)
    resolution = 128;
end
if (nargin < 2)
    offsetFactor = 1/3;
end
if (nargin > 2)
    error('ERROR:function takes at most 2 arguments')
end
if (resolution < 8)
    warning( [ 'WARN: RESOLUTION -- ' num2str(resolution) ' is a mighty small number for a gradient... shifting to 16' ] )
    resolution = 16;
end
if (resolution > 1000 )
    warning( [ 'WARN: RESOLUTION -- some folks find 50 shades of gray to be enough, but you want ' num2str(resolution) '! ... shifting to 1000' ] )
    resolution = 1000;
end
if (mod(resolution,2) ~= 0 )
    warning( [ 'WARN: RESOLUTION -- not a factor of 2, now fixed' ] )
    resolution = resolution+1;
end
if (offsetFactor < 0 )
    warning( [ 'WARN: offsetFactor -- less than zero, fixing somewhat arbitrarily'] )
    offsetFactor = abs(offsetFactor);
end
if (offsetFactor > 1 )
    warning( [ 'WARN: offsetFactor -- less than zero, fixing '] )
    offsetFactor = 1/3;
end

resolution=256;
gradient=zeros(resolution,3);
gray = 0:1/((resolution/2)-1):1;
offset = round(resolution*offsetFactor);
gradient(:,1) = [ gray fliplr(gray) ];
gradient(:,2) = [ gradient(offset+1:end,1); gradient(1:offset,1) ];
gradient(:,3) = [ gradient(2*offset+1:end,1); gradient(1:2*offset,1) ];

% this should never happen, but I'm not thinking too hard about this
% function
if max(max(gradient)) < 1
    gradient = abs(gradient);
end
if max(max(gradient)) > 1
    gradient = gradient./max(max(gradient))
end

return