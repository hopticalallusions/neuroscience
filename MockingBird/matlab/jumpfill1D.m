function [x, gapdex, gaplengths] = jumpfill1D(tstamps, x, gapthresh)   

%REMOVES LARGE JUMPS FROM data

%ARGUMENTS:
%tstamps = timestamps
%x = data
%gapthresh = largest gap (in samples) across which to interpolate missing values after jumpremoval

%RETURN VALUES:
%x = data with small NaN gaps replaced by interpolated values
%gapdex = indices of first NaN in gaps to large to interpolate
%gaplengths = lengths of the gaps (number of NaNs) whose starting indices are found in 'gapdex'

%%%fill in missing x values
x_nandex=find(isnan(x)); %%indices of NaNs
nd_x=[100; diff(x_nandex)]; %%how far back was previous NaN?
x_firstnansdex=find(nd_x>1); %%indices of indices of NaNs that are the first of a sequence
nanlengths=diff(x_firstnansdex); %%lengths of the sequences
gapdex=x_firstnansdex(find(nanlengths>=gapthresh)); %%indicies of first NaN in sequences greater than gapthresh long
gaplengths=nanlengths(find(nanlengths>=gapthresh)); %%lengths of NaN sequences greater than gapthresh long
x_firstnansdex=x_firstnansdex(find(nanlengths<gapthresh)); %%indicies of first NaN in sequences less than gapthresh long
nanlengths=nanlengths(find(nanlengths<gapthresh)); %%lengths of NaN sequences less than gapthresh long

%%construct a list of indices for NaN values that can be filled in by interpolation
filldex=[];
for dd=1:length(nanlengths)-1  
    filldex=[filldex x_nandex(x_firstnansdex(dd)):x_nandex((x_firstnansdex(dd))+nanlengths(dd)-1)];
end
if ~isnan(filldex)
    fillx=interp1(tstamps(find(~isnan(x))),x(find(~isnan(x))),tstamps(filldex),'linear'); %%interpolate missing values
    x(filldex)=fillx;
end

