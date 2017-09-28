function [xcor, xcor_centers] = xcorrelogram(refdata, tgtdata, binsize, maxISI)

%maxISI=0.5;% + thstart*.002;
xcor_edges = 0:binsize:maxISI;
xcor_centers = linspace(xcor_edges(1)+(xcor_edges(2)-xcor_edges(1))/2,xcor_edges(end)-(xcor_edges(2)-xcor_edges(1))/2,length(xcor_edges)-1);

xcor = zeros(length([[-maxISI:binsize:-binsize] [0:binsize:maxISI]]),1); %cross correlogam for speed filtered spikes

    if length(refdata)==length(tgtdata)
            refdata=refdata(1:end-1); %drop one value to prevent error on next step
    end
    %compute cross correlogram (speed but not direction filtered)
    try 
        [bothcell IX] = sort([refdata tgtdata]);
    catch
        [bothcell IX] = sort([refdata; tgtdata]);
    end
    idlist = bothcell;
    idlist(find(IX<=length(refdata))) = -1; %label reference cell spikes as -1
    idlist(find(IX>length(refdata))) = 1;   %label target cell spikes as +1
    offset=1; range1=(offset+1):length(bothcell); range2=1:(length(bothcell)-offset);
    spkdiff=bothcell(range1)-bothcell(range2);
    idsum=idlist(range1)+idlist(range2);
    spkdiff=spkdiff(find(idsum==0)).*idlist(range1(find(idsum==0))); %idsum==0 keeps only timestamp differences between spikes fired by different cells
    %multiplication by idlist(range1) sets the sign of the timestamp difference to
    %positive if ref cell fires first, negative if target cell fires first
    inrange = find(abs(spkdiff)<maxISI);
    while ~isempty(inrange) %if there are intervals within range
        phaserange = find(abs(spkdiff)<maxISI & abs(spkdiff)>0);
        if ~isempty(phaserange)
            [spkdist,spkbins] = histc(spkdiff(phaserange),[[-maxISI:binsize:-binsize] [0:binsize:maxISI]]);
            try
                xcor(1:(2*maxISI/binsize+1)) = xcor(1:(2*maxISI/binsize+1)) + spkdist;
            catch
                xcor(1:(2*maxISI/binsize+1)) = xcor(1:(2*maxISI/binsize+1)) + spkdist';
            end
        end
        offset=offset+1; range1=(offset+1):length(bothcell); range2=1:(length(bothcell)-offset);
        spkdiff=bothcell(range1)-bothcell(range2);
        idsum=idlist(range1)+idlist(range2);
        iddex = find(idsum==0);
        spkdiff=spkdiff(iddex).*idlist(range1(iddex)); %only keep timestamp differences between spikes fired by different cells
        inrange = find(abs(spkdiff)<maxISI);
    end

xcor=xcor(1:(end-1));
xcor_centers=[-xcor_centers(length(xcor_centers):(-1):1) xcor_centers];
%xcor=[xcor(end:-1:1); acor(:) ];
