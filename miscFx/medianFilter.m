function signal = medianFilter( data, width )

% width is how many samples on ONE SIDE.

signal = zeros(size(data));

for ii=1:width+1
    signal(ii) = median(data(1:width+ii));
end
for ii=width+1:length(data)-width-1
    signal(ii) = median(data(ii-width:ii+width));
end
for ii=length(data)-width-1:length(data)
    signal(ii) = median(data(ii:length(data)));
end