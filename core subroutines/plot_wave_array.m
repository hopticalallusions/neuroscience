load([finalwavedir 'waveforms_i' num2str(1) '_cl' num2str(unitj) '.mat'])
bestchan=bestchannels{unitj};
lengthperchan=size(waveforms{bestchan},2);

shaftofbestchan=s.shaft(bestchan);
chansonshaft=intersect(plotchannels,find(s.shaft==shaftofbestchan));
bestchanneighbors=chansonshaft(find(abs(elecz(chansonshaft)-elecz(bestchan))<=maxmergedistance/1000));  %find all channels on the shaft that are within specified vertical distance from best channel.
currentplotchannels=setdiff(bestchanneighbors, bestchan);  %rearranges plot channels s.t. will plot chanswithspikes last, so they are not obscured by other channels.
currentplotchannels=[currentplotchannels; bestchan];
    
    for chanind=1:length(currentplotchannels);
    channel=currentplotchannels(chanind);
    wavesinchani=waveforms{channel};
    
        if length(wavesinchani)>0
        
            if size(wavesinchani,1)>plotmax
            wavesinchani=wavesinchani(1:plotmax,:);
            end
            
        xchan=1000*(elecx(channel)+0.25);
        timex=(-xcompression*leftpoints+xchan):xcompression:(xcompression*rightpoints+xchan-extraright);   %converts the time to an x-coordinate. 
                                                                                                            %default = timex=(-xcompression*leftpoints+xchan):xcompression:(xcompression*rightpoints+xchan);     
        while length(timex)~=size(wavesinchani,2)
           timex=[-xcompression+min(timex) timex];
        end
        
        zchan=1000*elecz(channel);
                        
%            if channel==bestchan  
%            hold on
%            plot(timex,ycompression*mean(wavesinchani)+zchan,'-b','LineWidth',2)
%            plot(timex,ycompression*(mean(wavesinchani)+std(wavesinchani))+zchan,'--b')
%            plot(timex,ycompression*(mean(wavesinchani)-std(wavesinchani))+zchan,'--b')     
%            hold off
%            Vpp=round(range(mean(wavesinchani)));
%            else
%            plot(timex,ycompression*mean(wavesinchani)+zchan,'-k')
%            hold on
%            plot(timex,ycompression*(mean(wavesinchani)+std(wavesinchani))+zchan,'--k')
%            plot(timex,ycompression*(mean(wavesinchani)-std(wavesinchani))+zchan,'--k')
%            end

           %****Plotting using boundedline function*****
            if channel==bestchan  
            hold on
            boundedline(timex, ycompression*mean(wavesinchani)+zchan, std(wavesinchani)/sqrt(size(wavesinchani,1)),'-b');  %do not use 'alpha' (transparent shading) because this will mess up eps export.
            Vpp=round(range(mean(wavesinchani)));
            hold off
            else
            boundedline(timex, ycompression*mean(wavesinchani)+zchan, std(wavesinchani)/sqrt(size(wavesinchani,1)),'-k');  %do not use 'alpha' (transparent shading) because this will mess up eps export.
            hold on 
            end
           
           
        end
             
    end

        axis image
        set(gca,'XTickLabel',''); set(gca,'XTick',[]); set(gca,'YTickLabel',''); set(gca,'YTick',[])
        set(gcf,'Position',[0.8*scrsz(1)+40 0.8*scrsz(2)+100 0.8*scrsz(3) 0.8*scrsz(4)])   
        title(['Unit ' num2str(unitj) ', ' subject ', ' filename ', Vpp = ' num2str(Vpp) ' \muV'],'FontSize', 8)
        if length(unitclassnumbers)>1
        xlabel(['putative ' unitclassnames{unitj} ', shaft ' num2str(shaftofbestchan)],'FontSize',8)
        else xlabel(['shaft ' num2str(shaftofbestchan)],'FontSize',8)
        end
%         axis equal

        
