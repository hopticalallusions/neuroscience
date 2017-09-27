function xcValues = xcorrVectorAlgebra( vectorA, vectorB, maxLagtime)

    % pad the vectors so indexing violoations cannot arise
    vectorA = [ zeros( 1, maxLagtime ), vectorA, zeros( 1, maxLagtime ) ];
    vectorB = [ zeros( 1, maxLagtime ), vectorB, zeros( 1, maxLagtime ) ];
    
    idxA = find( vectorA );
    idxB = find( vectorB );
    
    xcValues = zeros( 1, 1 + 2 * maxLagtime );
    
    if length( idxA ) <= length( idxB )
        for offset = -maxLagtime:maxLagtime
            % multiply together and sum to 
            xcValues( offset + maxLagtime + 1 ) = vectorA(idxA) * vectorB(idxA-offset)';
        end
    else
        for offset = -maxLagtime:maxLagtime
            % multiply together and sum to 
            xcValues( offset + maxLagtime + 1 ) = vectorB(idxB) * vectorA(idxB+offset)';
        end
    end
           
end