%function that performs the Pearson's chi square test for equality of distributions (e.g., proportion of all functionally connected cell pairs between two groups).
%"tests a null hypothesis stating that the frequency distribution of certain events observed in a sample is consistent with a particular theoretical distribution."

function [chisq, pvalue]= test_chisquare(group1number,group1total,group2number,group2total);

g1a=group1number;  %eg number of connected cells.
g1b=group1total-group1number;   %eg number of unconnected cell.
g2a=group2number;
g2b=group2total-group2number;
total=group1total+group2total;
totala=g1a+g2a;

g1a_expect=round(group1total*totala/total);  %the expected, i.e. theoretical distribution if the null hypothesis were true.
g1b_expect=group1total-g1a_expect;

g2a_expect=round(group2total*totala/total);
g2b_expect=group2total-g2a_expect;


chisq=(g1a-g1a_expect)^2/g1a_expect+(g1b-g1b_expect)^2/g1b_expect+(g2a-g2a_expect)^2/g2a_expect+(g2b-g2b_expect)^2/g2b_expect;
  
pvalue=chi2pdf(chisq,1);  %probability of distributions being equal.  note; number degrees of freedom = 1.

disp(['p-value = ' num2str(pvalue) '.'])
        
end

