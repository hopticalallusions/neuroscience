function [tmean, tste] = trigavg(estamps, wstamps, wdata, begtime, endtime, binsize)

% estamps = event time stamps in seconds
% wstamps = wave time stamps in seconds
% wdata = wave data
% begtime = start time of trigger window
% endtime = end time of trigger window
% binsize = spacing at which to sample averaged waveform

tdata = [];

for t=1:length(estamps)
    
    tstamps = wstamps - estamps(t);
    tdata = [tdata; interp1(tstamps, wdata, begtime:binsize:endtime)]; 
    
end

tmean = nanmean(tdata);
tste = sqrt(nanstd(tdata));
    