function [pvalue,pvalue_ind] = KolmoSmirno_permutation(var1,var2,timebins,timebinsize,iterations,max_pvalue)

observed_hist1 = histc(var1,timebins);
obscumsum1 = cumsum(observed_hist1);
obscumsum1 = [0 obscumsum1(1:end-1)/max(obscumsum1)];

observed_hist2 = histc(var2,timebins);
obscumsum2 = cumsum(observed_hist2);
obscumsum2 = [0 obscumsum2(1:end-1)/max(obscumsum2)];

figure(2)
subplot(2,2,1)
group_width = timebinsize;
bar(timebins,observed_hist1/(trapz(observed_hist1)),0.5,'r')
hold on
bar(timebins+group_width/2,observed_hist2/(trapz(observed_hist2)),0.5,'k')

subplot(2,2,2)
plot(timebins,obscumsum1,'r','LineWidth',2)
hold on
plot(timebins,obscumsum2,'k','LineWidth',2)

[obsdiff,pvalue_ind] = max(abs(obscumsum2 - obscumsum1));
plot([timebins(pvalue_ind);timebins(pvalue_ind)],[obscumsum2(pvalue_ind);obscumsum1(pvalue_ind)],'--b','LineWidth',2)

pooledvalues = [var1 var2];
randdiffs = zeros(1,iterations);
allrand1 = zeros(iterations,length(timebins));
allrand2 = zeros(iterations,length(timebins));
for permuteind = 1:iterations
    randsamp1_indeces = randperm(length(pooledvalues),length(var1));
    randsamp1 = pooledvalues(randsamp1_indeces);
    randsamp2 = pooledvalues;
    randsamp2(randsamp1_indeces) = [];
 
    randhist1 = histc(randsamp1,timebins);
    randcumsum1 = cumsum(randhist1);
    randcumsum1 = [0 randcumsum1(1:end-1)/max(randcumsum1)];
    if sum(isnan(randcumsum1)) > 0
       allrand1(permuteind,:) = 0;
    else
       allrand1(permuteind,:) = randcumsum1;
    end
     
    randhist2 = histc(randsamp2,timebins);
    randcumsum2 = cumsum(randhist2);
    randcumsum2 = [0 randcumsum2(1:end-1)/max(randcumsum2)];
    if sum(isnan(randcumsum1))>0
       allrand2(permuteind,:) = 0;
    else
       allrand2(permuteind,:) = randcumsum2;
    end
    
    randdiffs(permuteind) = max(abs(randcumsum2 - randcumsum1));
end

permutebins = floor(min(randdiffs)*100)/100:0.001:(ceil(max(randdiffs)*100))/100;
randdiff_dist = histc(randdiffs,permutebins);
randdiff_distnorm = randdiff_dist/trapz(randdiff_dist);

pvalue = (sum(randdiffs > obsdiff)+1)/(iterations+1);  %This pvalue estimate is described in Smyth and Phipson 2010: "Permutation Pvalues should never be zero"
[H,autopvalue] = kstest2(var1,var2,max_pvalue,'unequal');

subplot(2,2,3)
boundedline(timebins,mean(allrand1),std(allrand1),'r')
hold on
boundedline(timebins,mean(allrand2),std(allrand2),'k')
plot(timebins,obscumsum1,'--r')
plot(timebins,obscumsum2,'--k')
set(subplot(2,2,3),'YLim',[0 1])
if H == 1
title(['K-S function result: ' num2str(autopvalue) '*'],'FontSize',7)
else
title(['K-S function result: ' num2str(autopvalue)],'FontSize',7)
end

subplot(2,2,4)
bar(permutebins,randdiff_distnorm)
hold on
plot([obsdiff,obsdiff],get(subplot(2,2,4),'YLim'),'--g','LineWidth',2)
title(['Pvalue = ' num2str(pvalue)])
end

    
    
    
    