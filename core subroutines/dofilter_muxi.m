%****Apply bandpass & notch filters******
if dofilter=='y'
Wn = [f_low f_high]/(samplingrate/2); 
[b,a] = butter(n,Wn); %finds the coefficients for the butter filter
%[b,a] = cheby1(n,rcheb,Wn);  %type I Chebyshev filter.
datach = filtfilt(b, a, datach); %zero-phase digital filtering
end

if donotchfilter=='y'
notchfilter_mux
end
%*************end filters*********