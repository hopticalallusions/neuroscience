disp(['plot_summary_muxi'])
set_plot_parameters

psthbinsize=20;             %bin size in sec for PSTH in plot_summary_muxi

minisi=0.003;               %default=0.003;

%****************************************************************************

leftpoints=final_leftpoints;
rightpoints=final_rightpoints;

mkdir([finalunitsJPGdir])
delete([finalunitsJPGdir '*.*'])
% mkdir([finalunitsEPSdir])   %Dec 9 2012: commented this to increase running speed.
% delete([finalunitsEPSdir '*.eps'])

load([savedir 'final_params.mat']);  %loads parameters file.
load([timesdir 'finalspiketimes.mat'])
load([timesdir 'finalbaretimes.mat'])
load([timesdir 'finaljittertimes.mat']) 
load([finalwavedir 'bestchannel.mat']);  %loads parameters file.

close all
scrsz=get(0,'ScreenSize');
    
maxtrial=parameters.maxtrial;
minamplitude=parameters.minamplitude;
isi=[]; psth=[]; totaltime=((maxtrial-1)*trialduration)/samplingrate; 
if psthbinsize>totaltime
    psthbinsize=10;
end
plottime=psthbinsize:psthbinsize:totaltime;

dounits=1:length(spiketimes);

for unitind=1:length(dounits);
    unit=dounits(unitind);    
    timesuniti=spiketimes{unit};
    if length(timesuniti)<2
        continue
    end
    
    load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])
    
    bestchan=bestchannel{unit};
    lengthperchan=size(waveforms{bestchan},2);
   
    channeltipoffset=(round(s.z(bestchan))+tipelectrode)/1000;   %height offset between tip and best channel, in mm. this is an estimate of the depth of the unit relative to probe tip.
      
    shaftofbestchan=s.shaft(bestchan);
    chansonshaft=intersect(plotchannels,find(s.shaft==shaftofbestchan));
    bestchanneighbors=chansonshaft(find(abs(s.z(chansonshaft)-s.z(bestchan))<=50));  %find all channels on the shaft that are within specified vertical distance from best channel.
    currentplotchannels=setdiff(bestchanneighbors, bestchan);  %rearranges plot channels s.t. will plot chanswithspikes last, so they are not obscured by other channels.
    currentplotchannels=[currentplotchannels; bestchan];
        
    bestwaves=waveforms{bestchan};    %waveforms from most prominent channel of this unit.
    if size(bestwaves,1)>1
    bestmean=mean(bestwaves);         %mean waveform.
    else     
    bestmean=bestwaves;                  
    end

    if length(bestmean)==0   %fixes an occasional bug in which waveforms aren't stored for a unit.
        continue
    end

    Vmin=min(interp(bestmean,100));  %upsample 100x.
              
    figure(2)
    hold off
    subplot(2,3,[1 4])   %plot all waveforms    
    
    for chanind=1:length(currentplotchannels);
    channel=currentplotchannels(chanind);
    wavesinchani=waveforms{channel};
    
        if length(wavesinchani)>0
        
            if size(wavesinchani,1)>plotmax
            wavesinchani=wavesinchani(1:plotmax,:);
            end
            
        xchan=s.x(channel);
        
        timex=1000*(0:1/samplingrate:(size(wavesinchani,2)-1)/samplingrate);
                                                                                                                    %default = timex=(-xcompression*leftpoints+xchan):xcompression:(xcompression*rightpoints+xchan);     
        timex=15*timex+xchan/2;
                                                                                                                    
        zchan=s.z(channel);
         
            if channel==bestchan     %paints the best channels red, the remainder are gray
            plot(timex,ycompression*wavesinchani'+zchan,'Color','r','LineWidth',0.5)
            hold on
            else
            plot(timex,ycompression*wavesinchani'+zchan,'Color',[0.7 0.7 0.7],'LineWidth',0.5)
            hold on 
            end
            plot(timex,ycompression*mean(wavesinchani)+zchan,'Color',[0.2,0.2,0.2],'LineWidth',0.5)
               
        end
             
    end

        axis([min(timex)-25 max(timex)+25 min(s.z(currentplotchannels))-25 max(s.z(currentplotchannels))+25])
        set(gca,'XTickLabel',''); set(gca,'XTick',[]); set(gca,'YTickLabel',''); set(gca,'YTick',[])
        set(gcf,'Position',[0.8*scrsz(1)+40 0.8*scrsz(2)+100 0.8*scrsz(3) 0.8*scrsz(4)])   
        title(['unit ' num2str(unit) ', ' num2str(length(spiketimes{unit})) ' spikes, depth ~' num2str(channeltipoffset) ' mm above tip.'],'FontSize',8)
        axis equal

        
    subplot(2,3,2)    %plot original and final template on best channel.   
    
    wavesinbestchan=waveforms{bestchan};
    maxtime=size(wavesinbestchan,2)/samplingrate-1/samplingrate;
    plott=1000*(0:1/samplingrate:maxtime);

    
    hold off
    plot(plott,wavesinbestchan','r')
    hold on
    plot(plott,mean(wavesinbestchan)','k','LineWidth',2)
    axis([0 1000*maxtime min(min(wavesinbestchan))-10 max(max(wavesinbestchan))+10])
    title(['Vmin = ' num2str(round(Vmin)) ' \muV' ', f = ' num2str(f_low) '-' num2str(f_high) ' Hz'],'FontSize',8)
    set(gca,'FontSize',8)
    xlabel(['time (ms)'],'FontSize',8) 
    ylabel(['amplitude (\muV)'],'FontSize',8)
    

        isii=diff(timesuniti);
        isii=isii(find(isii<=isirange));
        if length(isii)>0
            isi{unit}=isii;
        else isi{unit}=2*isirange;
        end  
        fractionISIviolations=length(find(isi{unit}<minisi))/length(isi{unit});
        isiplottime=0:isibinsize:isirange;
        histisi=100*histc(isi{unit},isiplottime)/length(isi{unit});   %percentage of ISI per uniter in each bin  

        subplot(2,3,3)  %plot ISI
        hold off
        plot(isiplottime*1000,histisi,'.-','Color','k')
        xlabel(['interspike interval (ms)'],'FontSize',8) 
        ylabel(['% spikes'],'FontSize',8)
        if max(histisi)>0       
        axis([0 isirange*1000 0 ceil(1.1*max(histisi))])
        else   axis([0 isirange*1000 0 1])    
        end
        set(gca,'FontSize',8)
        title(['% spikes with ISI<' num2str(1000*minisi) ' ms: ' num2str(100*fractionISIviolations)] ,'FontSize',8)


        psth{unit}=histc(spiketimes{unit},0:psthbinsize:totaltime)/psthbinsize;   
        psthuniti=psth{unit}(1:(length(psth{unit})-1));   
        if length(psthuniti)==0
        psthuniti=0.01;
        end

        subplot(2,3,[5 6])    %plot psth
        hold off
        plot(plottime/60,psthuniti,'.-','Color','k')

        xlabel(['time (min)'],'FontSize',5) 
        ylabel(['firing rate (Hz)'],'FontSize',8)
        axis([0 totaltime/60 0 ceil(1.1*max(psthuniti)+0.01)])
        title(['mean rate: ' num2str(mean(psthuniti)) '+/-' num2str(std(psthuniti)) ' Hz.' ' bin size: ' num2str(psthbinsize) ' s.' ] ,'FontSize',8)
        set(gca,'XTick',0:5:max(totaltime/60))
        set(gca,'FontSize',8)
            for events=startevent:(length(timeannotations)-1);
            etime=timeannotations{events};
            line([etime/60 etime/60], [0 ceil(1.1*max(psthuniti))],'Color','r','LineStyle','-')  %convert times to minutes
            text(etime/60,1.05*max(psthuniti),[' \leftarrow' eventannotations{events}],'FontSize',8)
            end

    saveas(figure(2),[finalunitsJPGdir 'unit' num2str(unit) '.jpg' ]  ,'jpg')
%   saveas(figure(2),[finalunitsEPSdir 'unit' num2str(unit) '.eps' ],'psc2') %save time by not saving eps file (Dec 2012)
    hold off
    close all

end

get_finalparams

mkdir(stimephysjpgdir); mkdir(stimephysepsdir); mkdir(stimephysmfigdir);

save([savedir 'final_params.mat'],'parameters')

disp(['done. now run get_unitquality.'])