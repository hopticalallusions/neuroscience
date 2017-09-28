function xcValues = xcorrWindow( vectorA, vectorB, maxLagtime)
    % find all the spike times in spikeTrainA
    % for each spike time
    %    find the high and low boundaries for the window
    %    check the boundary conditions (edges)
    %    extract the window
    %    add it to the cross correlation sum
    %
    % pad the vectors so indexing violoations cannot arise
    vectorA = [ zeros( 1, maxLagtime ), vectorA, zeros( 1, maxLagtime ) ];
    vectorB = [ zeros( 1, maxLagtime ), vectorB, zeros( 1, maxLagtime ) ];
    
    idxA = find( vectorA );
    idxB = find( vectorB );

    idxA = find( vectorA );
    xcValues=zeros( 1, 1 + 2 * maxLagtime );
    
%    for idx=1:length( idxA )
%    
%         lowTime = idxA( idx ) - maxLagtime;
%         highTime = idxA( idx ) + maxLagtime;
%         lowPad = 0;
%         highPad = 0;
%         
%         if ( lowTime <= 0 )
%             lowPad = 1+abs(lowTime);
%             lowTime = 1;
%         end
%         
%         if( highTime > length(vectorB) )
%             highPad = highTime - length(vectorB);
%             highTime = length(vectorB);
%         end
% 
%         if lowPad > 0
%             temp = [ zeros(1,lowPad), vectorB(lowTime:highTime)];
%         elseif highPad > 0
%             temp = [ vectorB(lowTime:highTime), zeros(1,highPad) ];
%         else
%             temp = vectorB(lowTime:highTime);
%         end
%
%        temp = vectorB(lowTime:highTime);
%
%        xcValues = xcValues + ( temp * vectorA(idxA(idx)) );
%    end
%    xcValues = fliplr(xcWindowing);
    
    if length( idxA ) <= length( idxB )
        for idx=1:length( idxA )
            temp = vectorB(idxA( idx ) - maxLagtime:idxA( idx ) + maxLagtime);
            xcValues = xcValues + ( temp * vectorA( idxA( idx ) ) );
        end
        xcValues = fliplr( xcValues );
    else
        for idx=1:length( idxB )
            temp = vectorA( idxB( idx ) - maxLagtime:idxB( idx ) + maxLagtime );
            xcValues = xcValues + ( temp * vectorB( idxB( idx ) ) );
        end            
        
    end
    
end