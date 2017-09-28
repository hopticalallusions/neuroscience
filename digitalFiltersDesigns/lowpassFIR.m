function [ lowpass_output ] = lowpassFIR( input_data, filter_coeffs )
%lowpassFIR -- Direct Form Lowpass FIR filter with given coefficients
%   Produces lowpass filtered version of the input based on filte
%   coefficients passed as an argument to the function.
N_samples = length(input_data); % no. of samples of input data
N_coeffs  = length(filter_coeffs); % no. of filter coefficients

lowpass_output = zeros(1, N_samples);

% nested loop for filter difference equation
for i=1:N_samples
    for k=1:min(i,N_coeffs)
        lowpass_output(i) = lowpass_output(i) + ...
            input_data(i-k+1)*filter_coeffs(k);
    end
end

end

