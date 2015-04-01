
    stimfile=[datafilename '.stim'];    %stimulus file e.g., optical pulses.
    foundstim='n';

    if exist([stimfile],'file')>0
     
    foundstim='y';    
        
    fid = fopen(stimfile,'r','b');
    stimsignal = fread(fid,[1,inf],'int16');     %stimsignal is the digital signal indicate stimulus on/off.
    fclose(fid);

    stimtrialduration=length(stimsignal)/samplingrate;
    stimontimes=find(diff(stimsignal)>0);   
    stimofftimes=find(diff(stimsignal)<0); 
    
    duplicate1=find(diff(stimontimes)==1);
    stimontimes(duplicate1+1)=[];
    duplicate1=find(diff(stimofftimes)==1);
    stimofftimes(duplicate1+1)=[];
    
    stimontimes=stimontimes/samplingrate;
    stimofftimes=stimofftimes/samplingrate;
    
        if doneperiod=='n' & length(stimofftimes)>length(stimontimes) & length(stimofftimes)>1
        stimperiod=stimofftimes(2)-stimofftimes(1);
        doneinterval='y';
        elseif  doneperiod=='n' & length(stimofftimes)<length(stimontimes) & length(stimontimes)>1
        stimperiod=stimontimes(2)-stimontimes(1);
        doneinterval='y';
        elseif  doneperiod=='n' & length(stimontimes)>1
        stimperiod=stimontimes(2)-stimontimes(1); 
        doneinterval='y';
        end
    
        if length(stimofftimes)>length(stimontimes)
        stimofftimes(1)=[];
        elseif length(stimofftimes)<length(stimontimes)
        stimontimes(1)=[];    
        end
       
        if doneduration=='n'
        stimduration=stimofftimes(1)-stimontimes(1); 
        end
        
        if stimduration>0.0001;
            doneduration='y';
        end
                    
        numberofstims=length(stimontimes);    %number of stimuli in the current trial.
 
    end
   