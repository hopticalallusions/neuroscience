function[discriminating_bins,observed_difference,upperbound,lowerbound] = difference_permutation(var1_base,var2_base,var1_post,var2_post,timebinsize,permute_iterations,max_pvalue)
discrim_bins = zeros(1,size(var1_post,2));
permut_this1 = mean(var1_base)/timebinsize;

observed_diff = (mean(var1_post)/timebinsize - mean(var2_post)/timebinsize);

difference = zeros(permute_iterations,size(var2_base,2));
for i = 1:permute_iterations
              
    rand_group = permut_this1(randperm(size(permut_this1,2),size(permut_this1,2)));
    
    difference(i,:) = rand_group - mean(var2_base)/timebinsize;
end

upperbound = prctile(difference(:),100*(1-max_pvalue/2));
lowerbound = prctile(difference(:),100*max_pvalue/2);

discrim_bins(observed_diff >= upperbound) = 1;
discrim_bins(observed_diff <= lowerbound) = -1;

discriminating_bins = discrim_bins;
observed_difference = observed_diff;
end
