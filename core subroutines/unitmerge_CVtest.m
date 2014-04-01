load([penultwavedir 'waveforms_i' num2str(1) '_cl' num2str(uniti) '.mat'])
waveformsi=waveforms;
t0i=leftpoints-origleftpoints+3;   %reduced t0:tf by 6 samples on July 29 2013.
tfi=t0i+origleftpoints+origrightpoints-3;        

load([penultwavedir 'waveforms_i' num2str(1) '_cl' num2str(unitj) '.mat'])
waveformsj=waveforms;

usechans=s.channels(find(abs(s.z-s.z(bestchani))<=maxmergedistance | abs(s.z-s.z(bestchanj))<=maxmergedistance));
usechans=intersect(usechans,s.channels(find(s.shaft==currentshaft)));
usechans=setdiff(usechans,badchannels);

mergeunitsij='n';  %don't merge unless CV test is satisfied. 
for k=1:length(jittersamples);
    jitterk=jittersamples(k); 
    t0=leftpoints-origleftpoints-jitterk+3;   %reduced t0:tf by 6 samples on July 29 2013.
    tf=t0+origleftpoints+origrightpoints-3;  
    
    mergedwaves=[]; meanwavei=[]; meanwavej=[]; sdwavei=[]; sdwavej=[];
    for chanind=1:length(usechans);   %for each channel.  
        chan=usechans(chanind);                 
        wavesi=waveformsi{chan}(:,t0i:tfi);
        wavesj=waveformsj{chan}(:,t0:tf);
        wavesij=[wavesi; wavesj];
        mergedwaves=[mergedwaves, wavesij];
        meanwavei=[meanwavei, mean(wavesi)];
        meanwavej=[meanwavej, mean(wavesj)];
        sdwavei=[sdwavei, std(wavesi)];
        sdwavej=[sdwavej, std(wavesj)];
    end
    minsdwaves=min([sdwavei; sdwavej]);
    diffij=abs(meanwavei-meanwavej); 
    numberviolations=length(find(diffij>finalmergeSDfactor*minsdwaves));
       
    CVmerged=abs(std(mergedwaves)./min(mean(mergedwaves)));   %new CV test (more rigorous). introduced July 24 2013. Absolute value of coefficient of variation (aka relative standard deviation).  CV is small for high quality units.
    inverseCVmerged=1./CVmerged; %requires the worst inverse CV value around the trough to be > finalCVtestfactor.
              
%     disp(num2str(prctile(inverseCVmerged,5)))
%     hold off
%     plot(mergedwaves')
%     title(['5th percent 1/CV=' num2str(prctile(inverseCVmerged,5)) '; number of SD violations=' num2str(numberviolations)])
%     figure(1)
%     input('press enter to continue')
 
    if numberviolations==0 & prctile(inverseCVmerged,5)>finalCVtestfactor
    mergeunitsij='y';  %passes the distance & CV test so the merger is approved.
    break
    end
end





