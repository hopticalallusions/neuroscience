minfreq=1;
maxfreq=60;

%************************************

minsignal=mean(laser_stim(1:1e4));
a=sort(laser_stim,'descend');
maxsignal=mean(a(1:1000));
meansignal=2.18; %mean(a(1:end/1.01));

newlaser=laser_stim-meansignal;
stimtime=0:1/stimsamplingrate:length(laser_stim)/stimsamplingrate;
stimtime(end)=[];

zeroinds=find(newlaser<0.05 & newlaser>-0.05);

% b=find(diff([newlaser(zeroinds+1) newlaser(zeroinds)])<0);
% zeroinds(b)=[];
% 
ipi=diff(zeroinds)/stimsamplingrate;   %interpeak interval
sweepfreq=1./ipi/2;  %instantaneous frequency. factor of 2 is because one full sine has two zero crossings.

badfreqinds=find(sweepfreq>maxfreq);% | freq<minfreq);

goodzeroinds=zeroinds;
goodzeroinds(badfreqinds)=[];
goodzeroinds(1)=[];
sweepfreq(badfreqinds)=[];
sweeptime=stimtime(goodzeroinds);

plot(sweeptime,sweepfreq,'o','MarkerFaceColor','k','MarkerEdgeColor','none','MarkerSize',2)
xlabel('time (s)')
ylabel('laser frequency (Hz)')

lasertimes.sweeptime=sweeptime;
lasertimes.sweepfreq=sweepfreq;

