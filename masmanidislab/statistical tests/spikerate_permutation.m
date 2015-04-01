%written by KB (October 2013). used in get_pvalue_firing.

function[pvalue1,pvalue2,obs_deltas] = spikerate_permutation(var1_base,var1_post,var2_base,var2_post,baseline_start,baseline_end,sigtest_binsize,permute_iterations)

baseline_time = abs(abs(baseline_start) - abs(baseline_end));
groups = [ones(1,size(var1_base,2)) 2];
obs_deltas.event1 = zeros(1,size(var1_post,2));
pvalue1.excite = zeros(1,size(var1_post,2));
pvalue1.inhib = zeros(1,size(var1_post,2));
for i = 1:size(var1_post,2)     %all query bins are tested individually.
    obs_deltas.event1(i) = mean(var1_post(:,i))/sigtest_binsize - sum(mean(var1_base))/baseline_time;   %observed delta between mean querybin(i) and mean baseline 
    permut_this = [var1_base var1_post(:,i)];
    new_deltas = zeros(1,permute_iterations);
    for j = 1:permute_iterations
        row_scramble = zeros(size(permut_this));
        for k = 1:size(permut_this,1)
            row_scramble(k,:) = groups(randperm(length(groups),length(groups)));
        end
        
        new_post = mean(permut_this(row_scramble == 2))/sigtest_binsize;
        new_baseline = sum(mean(reshape(permut_this(row_scramble == 1),size(var1_post,1),size(var1_base,2))))/baseline_time;
        new_deltas(j) = (new_post - new_baseline);
        
    end
    
    pvalue1.excite(i) = sum(new_deltas > obs_deltas.event1(i))/permute_iterations;       %fraction of new_deltas that are greater or equal to the observed delta value for this query bin.
    pvalue1.inhib(i) = sum(new_deltas < obs_deltas.event1(i))/permute_iterations;
    
end

obs_deltas.event2 = zeros(1,size(var2_post,2));
pvalue2.excite = zeros(1,size(var2_post,2));
pvalue2.inhib = zeros(1,size(var2_post,2));
for i = 1:size(var2_post,2)
    obs_deltas.event2(i) = mean(var2_post(:,i)/sigtest_binsize) - sum(mean(var2_base))/baseline_time;
    permut_this = [var2_base var2_post(:,i)];
    new_deltas = zeros(1,permute_iterations);
    for j = 1:permute_iterations
        row_scramble = zeros(size(permut_this));
        for k = 1:size(permut_this,1)
            row_scramble(k,:) = groups(randperm(length(groups),length(groups)));
        end
        
    new_post = mean(permut_this(row_scramble == 2))/sigtest_binsize;
    new_baseline = sum(mean(reshape(permut_this(row_scramble == 1),size(var2_base,1),size(var2_base,2))))/baseline_time;
    new_deltas(j) = (new_post - new_baseline);
    end
    
    pvalue2.excite(i) = sum(new_deltas > obs_deltas.event2(i))/permute_iterations;
    pvalue2.inhib(i)= sum(new_deltas < obs_deltas.event2(i))/permute_iterations;
    
end

end