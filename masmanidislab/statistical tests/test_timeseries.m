%does bin by bin permutation test on two time series.  series1 and 2 must have the same timebins.
%default max_pvalue1=0.05, max_pvalue2=0.01;

function [pvalue_perbin]= test_timeseries(series1,series2,iterations,max_pvalue1,max_pvalue2, timebins, xdiv, min_ploty, max_ploty, color1, color2) 

    pvalue_perbin=zeros(1,size(series1,2));

	for timeind=1:size(series1,2)
       stack1valuesi=series1(:,timeind);
       stack2valuesi=series2(:,timeind);
       observedmeandiffi=abs(mean(stack1valuesi)-mean(stack2valuesi));
       combinedvaluesi=[stack1valuesi; stack2valuesi]; 
                    
       shuffledmeandiffs=zeros(1,iterations);
       for permind=1:iterations
       shuffledinds=randperm(length(combinedvaluesi), length(combinedvaluesi));
       shuffled_stack1valuesi=combinedvaluesi(shuffledinds(1:length(stack1valuesi)));
       shuffled_stack2valuesi=combinedvaluesi(shuffledinds((length(stack1valuesi)+1):end));
       shuffledmeandiffi=mean(shuffled_stack1valuesi)-mean(shuffled_stack2valuesi);
       shuffledmeandiffs(permind)=abs(shuffledmeandiffi);
       end

       pvaluei=length(find(shuffledmeandiffs>observedmeandiffi))/iterations;
       
       %[h,pvaluei]=ttest2(series1,series2); %built-in t-test for optional comparison.
             
       pvalue_perbin(timeind)=pvaluei;
       
    end
    
    figure(100)
    preeventtime=-min(timebins);
    posteventtime=max(timebins);
    timebinsize=timebins(2)-timebins(1);
    
    mean_multievent1=sum(series1)/size(series1,1);    %mean of time series.
    sem_multievent1=std(series1)/sqrt(size(series1,1));
    mean_multievent2=sum(series2)/size(series2,1);
    sem_multievent2=std(series2)/sqrt(size(series2,1));
    hold off
    boundedline(timebins(1:end-1),mean_multievent2, sem_multievent2, color2)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
    hold on
    boundedline(timebins(1:end-1),mean_multievent1, sem_multievent1, color1)     %do not use 'alpha' (transparent shading) because this will mess up eps export.
    xlabel(['Time (s)'], 'FontSize', 8)
    ylabel(['Mean value'] ,'FontSize', 8)
    axis([-preeventtime posteventtime min_ploty max_ploty])
    set(gca,'XTick',[-1:xdiv:posteventtime])
    set(gca,'XTickLabel',[-preeventtime:xdiv:posteventtime])
    set(gca,'YTick',[0:1:max_ploty])
    set(gca,'FontSize',8,'TickDir','out')
    
    sigbins=find(pvalue_perbin<max_pvalue1);
    for ind=1:length(sigbins);
        line([timebins(sigbins(ind)) timebins(sigbins(ind))], [(max_ploty-0.25) (max_ploty-0.25)], 'Color','b','LineWidth',2)
    end

    disp(['found ' num2str(length(sigbins)) ' / ' num2str(length(timebins)) ' time bins that are significantly different (p<' num2str(max_pvalue1) ').'])

    sigbins=find(pvalue_perbin<max_pvalue2);
    for ind=1:length(sigbins);
        line([timebins(sigbins(ind)) timebins(sigbins(ind))], [(max_ploty-0.25) (max_ploty-0.25)], 'Color','r','LineWidth',2)
    end
    
    disp(['found ' num2str(length(sigbins)) ' / ' num2str(length(timebins)) ' time bins that are significantly different (p<' num2str(max_pvalue2) ').'])
   
end

