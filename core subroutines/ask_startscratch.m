if length(findstr(rawpath,'analysis'))==0
    
    startfromscratch=[];                              
    startfromscratch=input('start sorting from scratch (y/n)? [n] ','s');  %answering no allows user to execute individual programs.  Answering yes will automatically run through all possible subroutines in order of appearance below.
    if isempty(startfromscratch)==1
    startfromscratch='n';
    end

else startfromscratch='n';  %automatically skip initial sorting if the root directory is analysis.
end

% if startfromscratch=='y';
% runAutoUnitQuality=input(['Run Automated Unit Quality? (y,default=yes, s=semi-automatic, d=demo, n=no): '], 's');  
% end
