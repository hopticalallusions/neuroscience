function xcValues = xcorrVectorAlgebra( vectorA, vectorB, maxLagtime)

    % TODO try to make this faster
    % http://mathinsight.org/matrix_vector_multiplication
    % instead of the for loop, build a matrix of values across offsets (1
    % per row) and multiply that by the other. Eliminates the for loop and
    % should therefore be even faster.

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