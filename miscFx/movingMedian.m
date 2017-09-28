function [y]=movingMedian(input, )

aa=(round(rand(10000,1).*10.*rand(10000,1).*10));
plot(aa)
mid=aa(1);
nhi=0;
nlo=0;
neq=0;
for idx = 2:length(aa)
    if ( aa(idx) > mid )
        nhi = nhi + 1;
    elseif ( aa(adx) < mid )
        nlo = nlo + 1;
    else
        neq = neq + 1;
    end;
   if ( ( nhi + nlo + neq ) > 10 )
      estEqualness = 50 - 100*round(nhi/nlo);
      if estEqualness > 1 || estEqualness < -1
         %do some kind of weighting of the difference between the last value seen and the one we have now to estimate a new median.
         %maybe weight by the badness of the distribution
      end
   end
end
        
    
    

