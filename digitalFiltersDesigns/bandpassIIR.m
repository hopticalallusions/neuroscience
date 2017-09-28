function [ bandpass_output ] = bandpassIIR( input_data, num_filter_coeffs, denom_filter_coeffs )
%bandpassIIR -- IIR butterworth bandpass filter
%   bandpass filters the input data using the filter coeffcients provided
%   as arguments to the function.
% num_filter_coeffs are the filter coeffcients of numerator
% denom_filter_coeffs are the filter coefficients of the denominator
N_samples = length(input_data); % no. samples in input data
N_coeffs  = length(num_filter_coeffs); % no. filter coefficients

bandpass_output = zeros(1, N_samples);


for i=1:N_samples
   for k=1:min(i, N_coeffs)
        bandpass_output(i) = bandpass_output(i) - ...
            denom_filter_coeffs(k)*bandpass_output(i-k+1) ...
            + num_filter_coeffs(k)*input_data(i-k+1);
   end
end

end

