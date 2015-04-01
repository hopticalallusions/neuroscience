eventannotations=[];
timeannotations=[];

if exist([savedir 'notes_' filename '.txt'])==0 & exist([datadir 'notes_' filename '.txt'])
    mkdir(savedir)
    copyfile([datadir 'notes_' filename '.txt'], [savedir 'notes_' filename '.txt'])
end

if length(findstr(rawpath,'muxi'))==0   %if raw data is available, will use that; otherwise will use information in analysis directory.

timeannotations{1}=[];

else datanotes=importdata([savedir 'notes_' filename '.txt'],':');

noteindex=0;
for i=1:size(datanotes,1);
    noteslinei=datanotes{i};
    noteslinei=lower(noteslinei);   %converts to lower case.
    lastnumberposn=findstr(noteslinei,':')-1;
    
    interestevent1=findstr(noteslinei,'injec');
    if length(interestevent1)>0
        noteindex=noteindex+1;
        presentorfuture=findstr(noteslinei,'will');
        if length(presentorfuture)==0
        timei=noteslinei(1:lastnumberposn);
        eventa=findstr(noteslinei,'nic');
        eventb=findstr(noteslinei, 'quin');
        eventc=findstr(noteslinei,'qp');
        eventd=findstr(noteslinei,'saline');
        evente=findstr(noteslinei, 'etic');
        eventf=findstr(noteslinei, 'chlor');
        eventg=findstr(noteslinei, 'pinch');
        eventh=findstr(noteslinei, 'urethan');
        
        if length(eventa)>0
            notei='nicotine';
        elseif length(eventb)>0
            notei='QP';
        elseif length(eventc)>0
            notei='QP';
        elseif length(eventd)>0
            notei='saline';
        elseif length(evente)>0
            notei='ETIC';
        elseif length(eventf)>0
            notei='chloral hydrate';
        elseif length(eventg)>0
            notei='pinch';
        elseif length(eventh)>0
            notei='urethane';
        end
        eventannotations{noteindex}=[notei];
%         timeannotations{noteindex}=[(str2num(timei)-trialduration*samplingrate)]/samplingrate;  %if there is a trial 0
          timeannotations{noteindex}=[(str2num(timei))]/samplingrate;  %if there is no trial 0
        end
    end     
end
noteindex=noteindex+1;
eventannotations{noteindex}=['finish'];
timeannotations{noteindex}=[0-trialduration];
%*************

end