%does permutation test on a list of scalar quantities belonging to two subject groups (e.g. peak firing latency, fractional rate change, correlation coefficients, etc...). 

function [pvalue]= test_groups(group1,group2,iterations)

    observedmeandiff=abs(mean(group1)-mean(group2));
    combinedvalues=[group1 group2]; 
                    
    shuffledmeandiffs=zeros(1,iterations);
    for permind=1:iterations
        shuffledinds=randperm(length(combinedvalues), length(combinedvalues));
        shuffled_group1=combinedvalues(shuffledinds(1:length(group1)));
        shuffled_group2=combinedvalues(shuffledinds((length(group1)+1):end));
        shuffledmeandiff=mean(shuffled_group1)-mean(shuffled_group2);
        shuffledmeandiffs(permind)=abs(shuffledmeandiff);
    end

       pvalue=length(find(shuffledmeandiffs>observedmeandiff))/iterations;
      
       %[h,pvalue]=ttest2(group1,group2); %built-in t-test for optional comparison.
       
       disp(['p-value = ' num2str(pvalue)])
        
end

