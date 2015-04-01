disp(['Plotting LFP power vs laser frequency.'])

minplotf=1;
maxplotf=80;
plotdf=2;

plot_ymax=5;
%************************************************

close all

if exist([savedir 'final_params.mat']);  %loads parameters file.
load([savedir 'final_params.mat']);  %loads parameters file.
probetype=parameters.probetype;
badchannels=parameters.badchannels;
end

get_probegeometry
shafts=s.shaft;

load([stimulidir 'stimuli.mat']) 

mkdir(stimephysdir); 
 
figind=1;
scrsz=get(0,'ScreenSize');

dochannels=s.channels;
dochannels=setdiff(dochannels, badchannels);

sweeptime=stimuli.lasertimes.sweeptime;
sweepfreq=stimuli.lasertimes.sweepfreq;

figure(figind)
plot(sweeptime,sweepfreq,'o','MarkerFaceColor','k','MarkerEdgeColor','none','MarkerSize',2)
xlabel('time (s)')
ylabel('laser frequency (Hz)')
set(gca,'FontSize',10,'TickDir','out')

allfreqs=minplotf:plotdf:maxplotf;
[n,freqbin]=histc(sweepfreq,allfreqs);
uniquebins=setdiff(unique(freqbin),0);
plotfreqs=allfreqs(uniquebins);

laserLFPsweep=[];
laserLFPsweep.plotfreqs=plotfreqs;

for chanind=1:length(dochannels)
    chanj=dochannels(chanind);   
    disp(['*channel ' num2str(chanj)])
    load([LFPvoltagedir 'LFPvoltage_ch' num2str(chanj) '.mat']);
  
    powerperfreq=[];
    origplotfreqs=plotfreqs;
    for freqind=1:length(uniquebins)
        binvaluei=uniquebins(freqind);
        binsfreqi=find(freqbin==binvaluei);
        timesi=sweeptime(binsfreqi);   %times at which these frequencies were presented, in seconds.
        samplesi=round(timesi*LFPsamplingrate); %convert seconds to samples. note: this corresponds to the peak of the sine wave of the swept laser.
        
        difftimes=diff(timesi);
        endofsweep=[find(difftimes>10) length(timesi)];
        startofsweep=[1 endofsweep(1:end-1)+1];
        numberofsweeps=length(endofsweep);
        
        LFP_allsweeps=[];
        for sweepind=1:numberofsweeps
            t0=samplesi(startofsweep(sweepind));
            tf=samplesi(endofsweep(sweepind));
		if tf>length(LFPvoltage)
                tf=length(LFPvoltage);
                end
            LFP_allsweeps=[LFP_allsweeps LFPvoltage(t0:tf)];  %concatenate all voltage bins containing current frequency values.
        end
        
        N=length(LFP_allsweeps);
        xdft = fft(LFP_allsweeps);
        xdft = xdft(1:N/2+1);
        psdx = (1/(LFPsamplingrate*N)).*abs(xdft).^2;
        psdx(2:end-1) = 2*psdx(2:end-1);
        psdfreq=0:LFPsamplingrate/length(LFP_allsweeps):LFPsamplingrate/2;
        
        currentfreq=plotfreqs(freqind);      

%         if chanj==55
%         plot(psdfreq,psdx);  %psdx is power spectral density in units of microvolts square
%         title(['laser freq=' num2str(currentfreq) ' Hz'])
%         axis([minplotf maxplotf 0 1e6])
%         figure(1)
%         input('d')
%         end

%         psdxnear_currentfreq=psdx(find(psdfreq<currentfreq+10 & psdfreq>currentfreq-10));  %1st method (default).
        
     
%       psdxnear_currentfreq=mean(psdx(find(psdfreq<currentfreq+10 & psdfreq>currentfreq-10)));  %2nd method


        psdxnear_currentfreq=max(psdx(2:end));    %3rd method

        
        if length(psdxnear_currentfreq)==0
            origplotfreqs(find(origplotfreqs==currentfreq))=[];
        end
        
        millivoltsq=max(psdxnear_currentfreq)/(1e6);  %take maximum of local psd, and convert to millivolts square.
                     
        powerperfreq=[powerperfreq millivoltsq]; %average LFP power at the peak of sine wave at the selected frequency.
    end
    laserLFPsweep.power{chanj}=powerperfreq;
end

plotfreqs=origplotfreqs;
        
figind=figind+1;
figure(figind)

powerallchans=[];
for chanind=1:length(dochannels)
    chanj=dochannels(chanind);   
    plot(plotfreqs,laserLFPsweep.power{chanj},'-r')
    hold on
    powerallchans(chanind,:)=laserLFPsweep.power{chanj};
end
meanpower=mean(powerallchans);
sempower=std(powerallchans)/sqrt(length(dochannels));
boundedline(plotfreqs,meanpower,sempower,'k')
xlabel('laser frequency (Hz)')
ylabel('LFP power (mV^2)')
axis([0 max(plotfreqs) 0 plot_ymax])
set(gca,'FontSize',10,'TickDir','out')

