disp(['Plotting field triggered average data'])

set_plot_parameters

trialselection1='all';     %select which event1 trials to display. 
                            %['all'] will use all trials.  
                            %['a...b'] will only use specified trials.   
                            %'rewarded' only uses CS trials with a US. triggerevent must be a CS.
                            %'unrewarded' only uses CS trials with no solenoid. triggerevent must be a CS.
                            %'correct licking' only uses trials where anticipatory licking occurs before the US. 
                            %'incorrect licking' only uses trials where anticipatory licking occurs before the CS- or omitted expected reward. 
                            %'correct withholding' only uses trials where animals do not lick to the CS- cue or omitted expected reward. 
                            %'incorrect withholding' only uses trials where animals do not lick to the CS+ cue. 
                            %'unexpectedUS' only uses trials with unexpected US (i.e. not preceded by cue). triggerevent must be 'solenoid'. note that sol1times have time offset to align with cue times in plots.
                            
plotLFPraster='n';

%************************************************

trialselection2='all';     %select which event2 trials to display. same options as trialselection1.


close all
currentFTAdir=uigetdir([FTAdir],'Select an FTA folder');
FTAdatadir=[currentFTAdir '\data\'];
load([FTAdatadir 'FTA.mat'])

FTAjpgdir=[currentFTAdir '\jpeg\'];
FTAepsdir=[currentFTAdir '\eps\'];
FTAmfigdir=[currentFTAdir '\matlab figures\'];
mkdir([FTAjpgdir]); mkdir([FTAepsdir]); mkdir([FTAmfigdir])
delete([FTAjpgdir '*.*']); delete([FTAepsdir '*.*']); delete([FTAmfigdir '*.*'])

load_results

select_triggers_trials 

% LFPthreshold=FTA.LFPthreshold;
minLFPamp=FTA.minLFPamp;
maxLFPamp=FTA.maxLFPamp;

f_low_LFP=FTA.f_low_LFP;
f_high_LFP=FTA.f_high_LFP;
periFTAwidth=FTA.periFTAwidth;
FTAtimebinsize=FTA.FTAtimebinsize;
triggerevent1=FTA.triggerevent1;
% triggerevent2=FTA.triggerevent2;
preeventtime=FTA.preeventtime;
posteventtime=FTA.posteventtime;

event1_LFPpktimes=FTA.event1_LFPpktimes;
event1_LFPpktimes=event1_LFPpktimes;
event1_FTAspiketimes=FTA.event1_FTAspiketimes;
event1_FTAnormrate=FTA.event1_FTAnormrate;

% event2_LFPpktimes=FTA.event2_LFPpktimes;
% event2_LFPpktimes=event2_LFPpktimes;
% event2_FTAspiketimes=FTA.event2_FTAspiketimes;
% event2_FTAnormrate=FTA.event2_FTAnormrate;

FTAtimebins=-periFTAwidth:FTAtimebinsize:periFTAwidth;


figind=1;
figure(figind)
close
figure(figind)

if plotLFPraster=='y';

for chanind=1:length(dochannels) 
    chan=dochannels(chanind);
    event1_LFPpktimeschani=event1_LFPpktimes{chan};
    if length(event2_LFPpktimes)>0
    event2_LFPpktimeschani=event2_LFPpktimes{chan};
    end
           
    subplot(2,1,1)
    hold off
     
    for trialind=1:length(doevent1trials);
        trialk=doevent1trials(trialind);
        LFPpktimesik=event1_LFPpktimeschani{trialk};
        if length(LFPpktimesik)==0
        LFPpktimesik=-2*preeventtime;
        end
           
            plot([LFPpktimesik;LFPpktimesik],[0.8*ones(size(LFPpktimesik))+(trialind-0.4); zeros(size(LFPpktimesik))+(trialind-0.4)],'Color', 'k') 
            hold on
            if strmatch(triggerevent1,'CS1')==1
            if solenoid_aftercue1(trialk)==1
            plot([meancuesoldelay; meancuesoldelay], [0.8+trialind-0.4; 0+trialind-0.4], 'Color', 'b')
            end
            end
        
    end
    
    xlabel('time (s)','FontSize', 8)
    ylabel('trial','FontSize', 8)
    title([triggerevent1 ' triggered high-amplitude LFP peak, channel ' num2str(chan) ', threshold=' num2str(minLFPamp) ' uV, f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'],'FontSize', 8)
    axis([-preeventtime posteventtime 0 length(doevent1trials)+1])
    set(gca,'FontSize', 8,'TickDir','out')
    hold off
   

    saveas(figure(figind),[FTAjpgdir 'LFPpeak_raster_ch' num2str(chan) '.jpg' ]  ,'jpg')
    saveas(figure(figind),[FTAepsdir 'LFPpeak_raster_ch' num2str(chan) '.eps' ]  ,'psc2')
    saveas(figure(figind),[FTAmfigdir 'LFPpeak_raster_ch' num2str(chan) '.fig' ]  ,'fig')

end

end

figind=2;
figure(figind)
close
figure(figind)
% set(figure(figind),'Position',[0 0 scrsz(3) scrsz(4)]);

for unitind=1:length(dounits);
    unitj=dounits(unitind);
    bestchan=bestchannels{unitj};
    
    if length(intersect(badchannels,bestchan))==1
        continue
    end
   
    subplot(2,2,1)
    bar(FTAtimebins(1:(length(FTAtimebins)-1)),event1_FTAnormrate{unitj}{bestchan},'k')
    xlabel('time (s)')
    title([triggerevent1 ' triggered FTA normalized rate'])
    axis([min(FTAtimebins) max(FTAtimebins) 0 1])
              
    subplot(2,2,[2 4])  %plot best channel location and LFP source
    hold off
    plot(s.x,s.z,'.k')
    hold on
    plot(s.x(bestchan),s.z(bestchan),'*r','LineWidth',3,'MarkerSize',10)
    set(gca,'FontSize',10)
    ylabel(['distance from probe tip'],'FontSize',10)
    title(['Unit # ' num2str(unitj) ', best ch=' num2str(bestchan) ', f=' num2str(f_low_LFP) '-' num2str(f_high_LFP) ' Hz.'])

    saveas(figure(figind),[FTAjpgdir 'FTA_unit' num2str(unitj) '.jpg' ]  ,'jpg')
    saveas(figure(figind),[FTAepsdir 'FTA_unit' num2str(unitj) '.eps' ]  ,'psc2')
    saveas(figure(figind),[FTAmfigdir 'FTA_unit' num2str(unitj) '.fig' ]  ,'fig')

end
