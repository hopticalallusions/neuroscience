Wn = [f_low_LFP f_high_LFP]/(LFPsamplingrate/2);                     %filtering for other LFP, e.g. theta.
[b,a] = butter(n_LFP,Wn); %finds the coefficients for the butter filter
LFPvoltage = filtfilt(b, a, LFPvoltage); %zero-phase digital filtering

