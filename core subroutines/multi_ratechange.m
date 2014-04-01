ratechange=[];   
ratechange.saline=[]; ratechange.nicotine=[]; ratechange.chloral=[];

ratechange.filename=[subject '\' datei '\' filename];
ratechange.channels=plotsummedchannels';
ratechange.detectstdev=detectstdev;
ratechange.noiseprctile=noiseprctile;
ratechange.timerange=tcompare;
ratechange.depthofsomas=depthofsomas

for multichansetind=1:length(plot_multichannels)

stimesinset=spiketimes{multichansetind};

zsaline=0; znicotine=0; zchloral=0;
for eventind=1:(length(eventannotations)-1);
    eventname=eventannotations{eventind};
    t0=timeannotations{eventind};
    tpre=t0-tcompare*60;
    tpost=t0+tcompare*60;
    
    pretimes=find(stimesinset<t0 & stimesinset>tpre);
    posttimes=find(stimesinset>t0 & stimesinset<tpost);
        
    pretimes=stimesinset(pretimes);
    posttimes=stimesinset(posttimes);
          
    if strfind(eventname,'saline')>0
    zsaline=(length(posttimes)-length(pretimes))/length(pretimes);  
    elseif strfind(eventname,'nicotine')>0
    znicotine=(length(posttimes)-length(pretimes))/length(pretimes);     
    elseif strfind(eventname,'chloral')>0
    zchloral=(length(posttimes)-length(pretimes))/length(pretimes);
    else    
    continue       
    end    
end
        

ratechange.saline=[ratechange.saline zsaline];
ratechange.nicotine=[ratechange.nicotine znicotine];
ratechange.chloral=[ratechange.chloral zchloral];

end

ratechange
['rates calculated at depths of ' num2str(depthofsomas') ' mm from tip.']
save([multisavedir 'ratechange.mat'], 'ratechange','-MAT')


% sot=['filename: ' ratechange.filename ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'delimiter','','newline','pc')
% 
% sot=['used channels: ' num2str(ratechange.channels) ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc'); 
% 
% sot=['time range (min): ' num2str(ratechange.timerange) ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc');
% 
% sot=['detection threshold: ' num2str(detectstdev) ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc'); 
% 
% sot=['noise percentile: ' num2str(noiseprctile) ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc'); 
% 
% if length(zsaline)>0
% sot=['saline relative change: ' num2str(ratechange.saline) ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc'); 
% end
% 
% if length(znicotine)>0
% sot=['nicotine relative change: ' num2str(ratechange.nicotine') ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc'); 
% end
% 
% if length(zchloral)>0
% sot=['chloral hydrate relative change: ' num2str(ratechange.chloral') ';'];
% dlmwrite([multisavedir 'ratechange.txt'],sot,'-append','delimiter','','newline','pc'); 
% end