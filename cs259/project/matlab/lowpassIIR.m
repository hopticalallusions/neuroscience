function [ lowpass_output ] = lowpassIIR( input_data, num_filter_coeffs, denom_filter_coeffs )
%lowpassIIR -- single stage lowpass IIR Butterworth with given coefficients
%   Produces lowpass filtered version of input data based on filter
%   coeffcients passed as argument to the function.
% num_filter_coeffs are the filter coefficients of the numerator
% denom_filter_coeffs are the filter coeffcients of the denominator
N_samples = length(input_data); % no. of samples in input data
N_coeffs  = length(num_filter_coeffs); % no. of filter coeffcients

lowpass_output = zeros(1, N_samples);

% nest loop for filter difference equation
for i=1:N_samples
   for k=1:min(i,N_coeffs) 
        lowpass_output(i) = lowpass_output(i) ...
            - lowpass_output(i-k+1)*denom_filter_coeffs(k)...
            + input_data(i-k+1)*num_filter_coeffs(k);
   end
end

end

