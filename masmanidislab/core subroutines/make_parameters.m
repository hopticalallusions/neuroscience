['make_parameters']
['Do not alter the line position of parameters in the text file.']

paramcheck=dir([savedir 'parameters.txt']);
if length(paramcheck)==0
    ['no parameter file exists yet, creating one...'];
    useparamfile='n';
    sot='empty';
    dlmwrite([savedir 'parameters.txt'],sot,'delimiter','','newline','pc')
else
useparamfile=input('use the existing parameters.txt file to load preferences (y/n)? ', 's');
end




if useparamfile=='n'  %stores parameters in spikesort_muxi for future reference.

%-1. savedir.
sot=['savedir = ' savedir ';'];
dlmwrite([savedir 'parameters.txt'],sot,'delimiter','','newline','pc')

%0. raw data path.
sot=['rawpath = ' rawpath ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc'); 
    
%1. probetype.
sot=['probetype = ''' probetype ''';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc'); 

%2. dosets.
    if length(dosets)>1
    if dosets=='all'; 
    sot=['dosets = [''all'']'];   
    else
    diffsetsx=diff(dosets);    diffsetsx=diffsetsx(1);  
    sot=['dosets = [' num2str(min(dosets)) ':' num2str(diffsetsx) ':' num2str(max(dosets)) '];'];
    clear diffsetsx;
    end
    else 
    sot=['dosets = [' num2str(dosets) '];'];
    end
    dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc');  

%3. dotrials.
if length(dotrials)>1
difftrialsx=diff(dotrials); difftrialsx=difftrialsx(1);   
sot=['dotrials = [' num2str(min(dotrials)) ':' num2str(difftrialsx) ':' num2str(max(dotrials)) '];'];
clear difftrialsx; 
else 
sot=['dotrials = [' num2str(dotrials) '];'];
end
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc'); 

% %4. trialgroupsize.
% sot=['trialgroupsize = ' num2str(trialgroupsize) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%5. noiseprctile.
sot=['noiseprctile = ' num2str(noiseprctile) ';']; 
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')
  
%6. detectstdev.
sot=['detectstdev = ' num2str(detectstdev) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%7. samplingrate.
invertrate=1/samplingrate*1e6;
sot=['samplingrate = 1/(' num2str(invertrate) 'e-6);'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%8. f_low.
sot=['f_low = ' num2str(f_low) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%9. f_high.
sot=['f_high = ' num2str(f_high) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%10. filterpoles.
sot=['n = ' num2str(n) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%11. minoverlap.
sot=['minoverlap = ' num2str(minoverlap) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%12. rejecttime.
sot=['rejecttime = ' num2str(rejecttime) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%13. leftpoints. 
sot=['leftpoints = ' num2str(leftpoints) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%14. rightpoints. 
sot=['rightpoints = ' num2str(rightpoints) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%15. upsamplingfactor.
sot=['upsamplingfactor = ' num2str(upsamplingfactor) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

% %16. templeftpoints.
% sot=['templeftpoints = ' num2str(templeftpoints) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')
% 
% %17. temprightpoints.
% sot=['temprightpoints = ' num2str(temprightpoints) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%18. clusterstdev.
sot=['clusterstdev = ' num2str(clusterstdev) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%19. mergeclusterstdev.
sot=['mergeclusterstdev = ' num2str(mergeclusterstdev) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

% %20. pruneclusterstdev.
% sot=['pruneclusterstdev = ' num2str(pruneclusterstdev) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%21. allcluststdev
sot=['allcluststdev = [' num2str(allcluststdev) '];'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%22. minspikesperunit.
sot=['minspikesperunit = ' num2str(minspikesperunit) ';'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

% %23. minamplitude
% sot=['minamplitude = ' num2str(minamplitude) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

% %24. mergefactor.
% sot=['mergefactor = ' num2str(mergefactor) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

% %25. spikestokeep
% sot=['spikestokeep = ' num2str(spikestokeep) ';'];
% dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%26. badchannels.
sot=['badchannels = [' num2str(badchannels) '];'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')

%27. backgroundchans1.
sot=['backgroundchans1 = [' num2str(backgroundchans1) '];'];
dlmwrite([savedir 'parameters.txt'],sot,'-append','delimiter','','newline','pc')



elseif useparamfile=='y';
    
fid=fopen([savedir 'parameters.txt']);
params = textscan(fid,'%s','delimiter','\n','whitespace','');
fid=fclose(fid);    
params=params{:};
pind=2;

%1. probetype
pind=pind+1; a=findstr(params{pind},''''); b=findstr(params{pind},';');
probetype=params{pind}((a(1)+1):(a(2)-1)); probetype=num2str(probetype);

%2. dosets
pind=pind+1; 
if length(findstr(params{pind},'all'))>0
    dosets='all';
else
a=findstr(params{pind},'='); b=findstr(params{pind},';');
dosets=str2num(params{pind}((a+1):(b-1)));
end

%3. dotrials
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
dotrials=str2num(params{pind}((a+1):(b-1)));

% %4. trialgroupsize
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% trialgroupsize=str2num(params{pind}((a+1):(b-1)));

%5. noiseprctile.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
noiseprctile=str2num(params{pind}((a+1):(b-1)));
  
%6. detectstdev.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
detectstdev=str2num(params{pind}((a+1):(b-1)));

%7. samplingrate.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
samplingrate=str2num(params{pind}((a+1):(b-1)));

%8. f_low.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
f_low=str2num(params{pind}((a+1):(b-1)));

%9. f_high.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
f_high=str2num(params{pind}((a+1):(b-1)));

%10. filterpoles.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
n=str2num(params{pind}((a+1):(b-1)));

%11. minoverlap.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
minoverlap=str2num(params{pind}((a+1):(b-1)));

%12. rejecttime.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
rejecttime=str2num(params{pind}((a+1):(b-1)));

%13. leftpoints. 
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
leftpoints=str2num(params{pind}((a+1):(b-1)));

%14. rightpoints. 
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
rightpoints=str2num(params{pind}((a+1):(b-1)));

%15. upsamplingfactor.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
upsamplingfactor=str2num(params{pind}((a+1):(b-1)));

% %16. templeftpoints. 
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% templeftpoints=str2num(params{pind}((a+1):(b-1)));
% 
% %17. temprightpoints. 
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% temprightpoints=str2num(params{pind}((a+1):(b-1)));

%18. clusterstdev.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
clusterstdev=str2num(params{pind}((a+1):(b-1)));

%19. mergeclusterstdev.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
mergeclusterstdev=str2num(params{pind}((a+1):(b-1)));

% %20. pruneclusterstdev.
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% pruneclusterstdev=str2num(params{pind}((a+1):(b-1)));

%21. allcluststdev
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
allcluststdev=str2num(params{pind}((a+1):(b-1)));

%22. minspikesperunit.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
minspikesperunit=str2num(params{pind}((a+1):(b-1)));

% %23. minamplitude
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% minamplitude=str2num(params{pind}((a+1):(b-1)));

% %24. mergefactor.
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% mergefactor=str2num(params{pind}((a+1):(b-1)));

% %25. spikestokeep
% pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
% spikestokeep=str2num(params{pind}((a+1):(b-1)));

%26. badchannels.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
badchannels=str2num(params{pind}((a+1):(b-1)));

%27. backgroundchans1.
pind=pind+1; a=findstr(params{pind},'='); b=findstr(params{pind},';');
backgroundchans1=str2num(params{pind}((a+1):(b-1)));

    
end

                                                   