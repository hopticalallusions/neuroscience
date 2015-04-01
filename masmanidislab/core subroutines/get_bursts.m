%finds the burst episode start/end times over the entire recording.
slowburstISI=0.02;
rapidburstISI=0.005;

%**************************************

if exist([savedir 'slowbursts.mat'],'file') & exist([savedir 'rapidbursts.mat'],'file')
   load([savedir 'slowbursts.mat'])
   load([savedir 'rapidbursts.mat'])
   burstfile=dir([savedir 'slowbursts.mat']);
   burstdate=burstfile.datenum;
    
   slowburstISI=slowbursts.slowburstISI; 
   rapidburstISI=rapidbursts.rapidburstISI;

   dobursts=[];
   dobursts=input(['detected burst files with slow ISI=' num2str(slowburstISI) ' s, and rapid ISI=' num2str(rapidburstISI) ' s previously created on '  datestr(burstdate,1) '; redo (y/n)? [n]: '], 's');
   if isempty(dobursts)
   dobursts='n';
   end
else dobursts='y';
end
   
if dobursts=='y'    

tic

disp('finding initial & final times of slow/rapid burst episodes.')
slowbursts=[]; rapidbursts=[];
slowbursts.slowburstISI=slowburstISI;
rapidbursts.rapidburstISI=rapidburstISI;
for unitind=1:length(dounits)
    unitj=dounits(unitind);
    stimes=spiketimes{unitj};
    isi=diff(stimes);

    %1. slow bursting.
    slowbursts.first{unitj}=[];  %time of first spike in burst.
    slowbursts.final{unitj}=[];    %time of final spike in burst (i.e., "pause")
    slowbursts.spikes{unitj}=[];  %number of spikes in burst.
    slowburst_starts=find(isi<slowburstISI);
    slowburst_ends=find(isi>2*slowburstISI);    
    if length(slowburst_starts)>0
    newstarts=[]; newends=[];
    for i=2:length(slowburst_starts)
        previousstartind=slowburst_starts(i-1);
        startind=slowburst_starts(i);
        prev_matchinds=find(slowburst_ends>previousstartind & slowburst_ends<startind);     %if there are pauses between ith and (i-1)th burst
        if length(prev_matchinds)>0 & startind<max(slowburst_ends)
        newstarts=[newstarts startind];
        diffinds=slowburst_ends-startind;
        diffinds(find(diffinds<0))=[];
        endind=min(diffinds)+startind;
        newends=[newends endind];    
        slowbursts.spikes{unitj}=[slowbursts.spikes{unitj} length(startind:endind)];  
        end
    end
    slowbursts.first{unitj}=stimes(newstarts);        
    slowbursts.final{unitj}=stimes(newends);
    end
    
    %2. rapid bursting.
    rapidbursts.first{unitj}=[];  %time of first spike in burst.
    rapidbursts.final{unitj}=[];    %time of final spike in burst (i.e., "pause")
    rapidbursts.spikes{unitj}=[];  %number of spikes in burst.
    rapidburst_starts=find(isi<rapidburstISI);
    rapidburst_ends=find(isi>2*rapidburstISI);    
    if length(rapidburst_starts)>0
    newstarts=[]; newends=[];
    for i=2:length(rapidburst_starts)
        previousstartind=rapidburst_starts(i-1);
        startind=rapidburst_starts(i);
        prev_matchinds=find(rapidburst_ends>previousstartind & rapidburst_ends<startind);     %if there are pauses between ith and (i-1)th burst
        if length(prev_matchinds)>0 & startind<max(rapidburst_ends)
        newstarts=[newstarts startind];
        diffinds=rapidburst_ends-startind;
        diffinds(find(diffinds<0))=[];
        endind=min(diffinds)+startind;
        newends=[newends endind];    
        rapidbursts.spikes{unitj}=[rapidbursts.spikes{unitj} length(startind:endind)];  
        end
    end
    rapidbursts.first{unitj}=stimes(newstarts);        
    rapidbursts.final{unitj}=stimes(newends);
    end
    
end

save([savedir 'slowbursts.mat'], 'slowbursts', '-mat')
save([savedir 'rapidbursts.mat'], 'rapidbursts', '-mat')

toc

end


