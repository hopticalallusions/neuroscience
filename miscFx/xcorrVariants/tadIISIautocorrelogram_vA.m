function acor = autocorrelogram(spiketimes, binsize, maxISI)

%maxISI=0.5;% + thstart*.002;
auto_edges = 0:binsize:maxISI;

acor = zeros(length(auto_edges),1); %autocorrelogam for speed filtered spikes
offset=1; range1=(offset+1):length(spiketimes); range2=1:(length(spiketimes)-offset);
spkdiff=spiketimes(range1)-spiketimes(range2);
inrange = find(spkdiff<maxISI);
while ~isempty(inrange) %if there are intervals within range
    spkdist = histc(spkdiff(inrange),auto_edges);
    if size(spkdist,1)>size(spkdist,2)
        acor = acor + spkdist;
    else
        acor = acor + spkdist';
    end
    offset=offset+1; range1=(offset+1):length(spiketimes); range2=1:(length(spiketimes)-offset);
    spkdiff=spiketimes(range1)-spiketimes(range2);
    inrange = find(spkdiff<maxISI);
end
acor=acor(1:(end-1));
acor=[acor(end:-1:1); acor(:) ];

acor=acor/(offset-1); %convert to Hz
acor=acor/binsize;