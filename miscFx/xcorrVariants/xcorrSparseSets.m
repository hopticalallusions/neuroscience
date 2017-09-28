function xcorrValues = xcorrSparseSets( vectorA, vectorB, maxLagtime )

    idxA=find(vectorA);
    idxB=find(vectorB);
    xcorrValues = zeros(1,1+2*maxLagtime);
    for offset = -maxLagtime:maxLagtime
        %
        shiftedIdxB=idxB+offset;
        % use the indices of the ms where the spike occurs as sets to detect
        % coincidence (firing at the same time)
        %
        % find coincidence [ 1 1 ]
        idxBoth = intersect(idxA,shiftedIdxB);
        %
        corrNumerator = vectorA(idxBoth)*vectorB(idxBoth-offset)';
        xcorrValues(offset+maxLagtime+1) = corrNumerator;
    end

end