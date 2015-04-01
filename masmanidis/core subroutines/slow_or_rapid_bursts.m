load([savedir 'slowbursts.mat'])
load([savedir 'rapidbursts.mat'])


slow_or_rapid=[];
slow_or_rapid=input('do you want to use (s)low or (r)apid bursts? [s]: ', 's');
if isempty(slow_or_rapid)
    slow_or_rapid='s';
end  

minspikesperburst=[];
minspikesperburst=input('specify minimum number of spikes per burst (usually 2 or 3) [2]: ');
if isempty(minspikesperburst)
    minspikesperburst=2;
end  

if slow_or_rapid=='s'
bursts=slowbursts.first;
counts=slowbursts.spikes;
minburstisi=slowbursts.slowburstISI;
elseif slow_or_rapid=='r'
bursts=rapidbursts.first;
counts=rapidbursts.spikes;
minburstisi=rapidbursts.rapidburstISI;
end