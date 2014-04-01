alldatafiles=dir([datadir filename '*']);

maxtrial=0;
for trialindq=1:length(alldatafiles);
    currenttrialfile=alldatafiles(trialindq).name;

a=strfind(currenttrialfile,'_t');
b=strfind(currenttrialfile,'.');

currenttrial=currenttrialfile((a+2):(b-1));
currenttrial=str2num(currenttrial);

if currenttrial>maxtrial
    maxtrial=currenttrial;
end

% if max(dotrials)>lasttrial
% maxtrial=lasttrial;
% else maxtrial=max(dotrials);
% end

end
disp(['max trial = ' num2str(maxtrial) '.'])