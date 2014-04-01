['Delete old avi or wave files before running.']
['This generates a video and audio of selected channels. Note: this program does not compress video or combine audio with video.']
['To do that, open Virtual Dub after running this, open AVI file, go to Video-->Compression and select "Microsoft Video 1".']
['Then go to Audio-->Audio from other file and select the audio file. Then save the output as a new avi file or overwrite the old one.']

dochannels=[1:63]; 
left_chan_sound=11;
right_chan_sound=57;

trial=5;                %use load_muxi to identify an interesting trial.
t_start=2;            %start time in s to begin movie.  use load_muxi to identify good t_start.
VideoLength=6;          %default=2.  total number of seconds of data to make video with, starting from t_start.
SecondsToPlot=2;      %default=0.1.  length of time to plot every frame
speed=0.5;              %default=0.2.   speed at which to play the video (e.g. 0.1 is at 1/10 of real time)
FPS=24;                 %default=20.  frames per second of the video
offset=125;             %default=100. offset betweem channels in uV

videofile='video_data.avi';    %.avi file
audiofile='audio_data.wav';   %.wav file

%***End set paramaters***

%% creates a movie of data
% % function Generate_Movie(channels, trial, samplingrate, rawpath, f_low, f_high, n,speed)

close all; warning off
t_start=round(samplingrate*t_start);

mkdir(animationdir)
clear mov
delete([animationdir videofile])
delete([animationdir audiofile])

screenres=[1024 768];   %frame pixel resolution
plotwindow =  SecondsToPlot*samplingrate;
SamplesToJump = samplingrate/FPS * speed;
SamplesPerSegment = SecondsToPlot*samplingrate;

select_channels    %plots channels in specific order according to probetype;

newchannels=[];    %removes bad channels and keeps plot order set in select_channels.
for i=1:length(channels);
   chani=channels(i);
    foundmatch=0;
    for j=1:length(badchannels);
        badchanj=badchannels(j);
        if chani==badchanj
        foundmatch=foundmatch+1;
        end
    end
    if length(find(dochannels==chani))~=1
        foundmatch=1;
    end
    if foundmatch==0
        newchannels=[newchannels chani];
    end
end
channels=newchannels;

backgroundchans=setdiff(backgroundchans1,badchannels);
muxifiles=unique(ceil(dochannels/32));  %specifies which dot muxi files to open for plotting, e.g. mux1 and mux2 for chs 1-64.

if trial<10;   %adds '0' to file name is trial<10.
trialstring=['0' num2str(trial)];
else trialstring=num2str(trial);
end

datafilename=[rawpath filename '_t' trialstring];  
%***Calculate average signal for background removal*** 
muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.
if length(backgroundchans)>0;
backgndsignal_muxi    %calculated only once per channel set per trial.
clear data
else
backgnddata=0;
end


datadochannels=[]; stimesdochannels=[]; stimes=[]; noisechani=[];
    
for muxind=1:length(muxifiles);      
    muxi=muxifiles(muxind);     
    datafile=[datafilename '.mux' num2str(muxi)];   

    fid = fopen(datafile,'r','b');
    data = fread(fid,[1,inf],'int16');    
    fclose(fid);
    data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

    muxichans=dochannels(find(dochannels<(32*muxi+1) & dochannels>32*(muxi-1)))-32*(muxi-1);  %selects only channels in the active muxi file.

    for chanind=1:length(muxichans);
        channel=muxichans(chanind);
        absolutechan=muxichans(chanind)+(muxi-1)*32;

        if muxi==1
        datach=data(channel:32:length(data));  %demultiplexing. 
        elseif muxi>1
        channel=channel-1;
            if channel==0;
                channel=32;
            end
        datach=data(channel:32:length(data));  %demultiplexing. April 9 2011.  takes into account that when reading out muxi files where i>1, the channel order is shifted by 1.
        end
        
        datach=datach-backgnddata-mean(datach);  %subtracts the background channel if backgroundchans were specified.
     
        dofilter_muxi

        datach=1e6*datach;  %convert to microvolts.
        
        datadochannels{absolutechan}=datach;
        clear datach;

    end

end
clear data;

%% plots data frame by frame and saves to a movie

fig1=figure(1);
set(fig1,'color','w')  %set background color. default='k'.
set(fig1, 'Position', [60 60 screenres(1) screenres(2)]);
ax = axes('Color', 'w', 'Visible', 'off');    %makes axes invisible.
set(gcf,'visible','on')  
numframes=(VideoLength*samplingrate)/SamplesToJump
time=(1/samplingrate):(1/samplingrate):(plotwindow/samplingrate);
 scrsz=get(0,'ScreenSize');

FrameNumber=0;
for i=1:(numframes+1);
t0=round((i-1)*VideoLength/numframes*1000);    %time at current frame in ms.
    for chi=1:length(channels);
        channel=channels(chi);
        tempdata=datadochannels{channel}((t_start+(i-1)*SamplesToJump+1):(t_start+(i-1)*SamplesToJump+plotwindow));
        plot(ax,time, tempdata+offset*chi,'Color', 'k')      %cols(chi,:) multicolor data lines
        hold on
        text(max(time)/2.5,-offset,[num2str(speed) 'x   ' num2str(t0) ' ms'],'Color','k','FontSize',14,'FontName','Arial')     %display time in milliseconds on plot
    end
    set(ax, 'Color', 'w');    
    set(fig1,'color','w');      %background color
%     set(fig1, 'Position', [60 60 screenres(1) screenres(2)]); 
    set(fig1,'Position',[0.6*scrsz(1)+100 0.6*scrsz(2)+100 0.7*scrsz(3) 0.7*scrsz(4)])
    ylim([-1.5*offset (offset)*(length(channels)+1)])
    xlim([min(time) max(time)])
%    xlabel('Time (s)','fontsize', 24)
%    ylabel('Amplitude (uV)','fontsize', 24)  
   FrameNumber = FrameNumber+1;
   axis off
   mov(:, FrameNumber) = getframe(fig1);
   
   hold off;
end

movie2avi(mov,[animationdir videofile],'Compression','none','fps',FPS)

close 1

%% now get audio for video
t0=round(SecondsToPlot*samplingrate)+t_start;
tf=round(SecondsToPlot*samplingrate)+VideoLength*samplingrate+t_start;
audio_left_ch=datadochannels{left_chan_sound}(t0:tf);
audio_right_ch=datadochannels{right_chan_sound}(t0:tf);

datach=audio_left_ch;
stdsignal=prctile(datach,noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes
detectthreshold=round(detectstdev*stdsignal);  %detection threshold voltage.
findpeaktimes_muxi   %finds peak times on one channel.       
alltimes=[];
for i=1:length(spiketimes);
timei=spiketimes(i);
alltimes=[alltimes (timei-15):1:(timei+15)];
end
a=1:length(datach);
badpks=find(alltimes>max(a) & alltimes<1);
alltimes(badpks)=[];
notpeaks=setdiff(a,alltimes);
datach(notpeaks)=0;
audio_left_ch=datach;


datach=audio_right_ch;
stdsignal=prctile(datach,noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes
detectthreshold=round(0.75*detectstdev*stdsignal);  %detection threshold voltage.
findpeaktimes_muxi   %finds peak times on one channel.       
alltimes=[];
for i=1:length(spiketimes);
timei=spiketimes(i);
alltimes=[alltimes (timei-15):1:(timei+15)];
end
a=1:length(datach);
badpks=find(alltimes>max(a) & alltimes<1);
alltimes(badpks)=[];
notpeaks=setdiff(a,alltimes);
datach(notpeaks)=0;
audio_right_ch=datach;


maxamp_left=max([max(audio_left_ch) abs(min(audio_left_ch))]);
maxamp_right=max([max(audio_right_ch) abs(min(audio_right_ch))]);
audio_left_ch=audio_left_ch/maxamp_left;
audio_right_ch=audio_right_ch/maxamp_right;

audio_stereo=[audio_left_ch; audio_right_ch]';
wavwrite(audio_stereo,round(samplingrate*speed),16,[animationdir audiofile])

% soundsc(audio_stereo,round(samplingrate*speed))    %play audio.

%% save A/V parameters.
audiovideo_params=[];
audiovideo_params.left_chan_sound=left_chan_sound;
audiovideo_params.right_chan_sound=right_chan_sound;
audiovideo_params.trial=trial;              
audiovideo_params.t_start=t_start;              
audiovideo_params.VideoLength=VideoLength;          
audiovideo_params.SecondsToPlot=SecondsToPlot;      
audiovideo_params.speed=speed;              
audiovideo_params.FPS=FPS;                 
audiovideo_params.offset=offset;            
save([animationdir 'audiovideo_params.mat'], 'audiovideo_params', '-MAT')

['Done making Audio & Video. Use VirtualDub to compress and combine A & V.']