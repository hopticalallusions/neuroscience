subjects=[];
for subjectind=1:length(selectedpaths)
    selectedpath=[selectedpaths{subjectind} '/'];
    a=strfind(selectedpath,'/');
    mouse=selectedpath(a(3)+1:a(4)-1);
    possible_directories = dir(selectedpath);
    for dirind = 1:length(possible_directories)
        if length(possible_directories(dirind).name) > 3
            new_possibilities = dir([selectedpath possible_directories(dirind).name '/']);
            for newdirind = 1:length(new_possibilities)
                if length(new_possibilities(newdirind).name) > 3
                   if exist([selectedpath possible_directories(dirind).name '/' new_possibilities(newdirind).name '/single-unit/sortedtimes/finalspiketimes.mat'],'file') > 0
                      selectedpath = [selectedpath possible_directories(dirind).name '/'  new_possibilities(newdirind).name '/'];
                      break
                   end
                end
            end
        end
    end
    subjects{subjectind}=selectedpath;  
end
