['plot_summary_muxi']
set_plot_parameters

mkdir([penultunitsJPGdir])
delete([penultunitsJPGdir '*.jpg'])

load([timesdir 'penultimate_params.mat']);  %loads parameters file.
load([timesdir 'penult_spiketimes.mat'])
load([penultwavedir 'bestchannel.mat']);  %loads parameters file.

% if dounits=='all';
dounits=1:length(parameters.templates);
% end

close all
scrsz=get(0,'ScreenSize');

usechannels=parameters.allusechannels;

for unitind=1:length(dounits);
    unit=dounits(unitind);    
    timesuniti=spiketimes{unit};
    if length(timesuniti)<2
        continue
    end
    
    load([penultwavedir 'waveforms_i' num2str(1) '_cl' num2str(unit) '.mat'])   
    
    bestchan=bestchannel{unit};
    channeltipoffset=(round(y(bestchan))+tipelectrode)/1000;   %height offset between tip and best channel, in mm. this is an estimate of the depth of the unit relative to probe tip.

    currentplotchannels=setdiff(plotchannels, bestchan);  %rearranges plot channels s.t. will plot chanswithspikes last, so they are not obscured by other channels.
    currentplotchannels=[currentplotchannels bestchan];
    
    if length(waveforms{bestchan})==0
        continue
    end
  
    figure(2)
    hold off
    subplot(1,2,1)   %plot all waveforms    
    
    for chanind=1:length(currentplotchannels);
    channel=currentplotchannels(chanind);
    wavesinchani=waveforms{channel};
    
        if length(wavesinchani)>0
        
            if size(wavesinchani,1)>plotmax
            wavesinchani=wavesinchani(1:plotmax,:);
            end
            
        xchan=x(channel);
        timex=(-xcompression*leftpoints+xchan):xcompression:(xcompression*rightpoints+xchan-extraright);   %converts the time to an x-coordinate. 
                                                                                                            %default = timex=(-xcompression*leftpoints+xchan):xcompression:(xcompression*rightpoints+xchan);     
        while length(timex)~=size(wavesinchani,2)
            if length(timex)>size(wavesinchani,2)
            timex=timex(1:(length(timex)-1));    
            elseif length(timex)<size(wavesinchani,2)
            timex=[timex 1];  
            end
        end
        
        ychan=y(channel);

            if length(intersect(channel,bestchan))==1     %paints the best channels red, the remainder are gray
            plot(timex,ycompression*wavesinchani'+ychan,'Color','r','LineWidth',0.5)
            hold on
            
            else
            plot(timex,ycompression*wavesinchani'+ychan,'Color',[0.7 0.7 0.7],'LineWidth',0.5)
            hold on
            end
            plot(timex,ycompression*mean(wavesinchani)+ychan,'Color',[0.2,0.2,0.2],'LineWidth',0.5)
               
        end
             
    end

        axis([min(x)-100 max(x)+100 min(y)-100 max(y)+100])
        set(gca,'XTickLabel',''); set(gca,'XTick',[]); set(gca,'YTickLabel',''); set(gca,'YTick',[])
        set(gcf,'Position',[0.8*scrsz(1)+40 0.8*scrsz(2)+100 0.8*scrsz(3) 0.8*scrsz(4)])   
        title(['unit ' num2str(unit) ', ' num2str(length(spiketimes{unit})) ' spikes, depth ~' num2str(channeltipoffset) ' mm above tip.'],'FontSize',8)
        axis equal

    subplot(1,2,2)    %plot original and final template on best channel.   
    
    wavesinbestchan=waveforms{bestchan};
    maxtime=size(wavesinbestchan,2)/samplingrate-1/samplingrate;
    plott=1000*(0:1/samplingrate:maxtime);

    
    hold off
    plot(plott,wavesinbestchan','r')
    hold on
    plot(plott,mean(wavesinbestchan)','k','LineWidth',2)

    axis([0 1000*maxtime min(min(wavesinbestchan))-10 max(max(wavesinbestchan))+10])
    title(['Vpp = ' num2str(round(range(mean(wavesinbestchan)))) ' \muV.'],'FontSize',8)
    set(gca,'FontSize',8)
    xlabel(['time (ms)'],'FontSize',8) 
    ylabel(['amplitude (\muV)'],'FontSize',8)
    
    saveas(figure(2),[penultunitsJPGdir 'unit' num2str(unit) '.jpg' ]  ,'jpg')
   
    hold off
    close all

end

'done plotting putative unit waveforms.'