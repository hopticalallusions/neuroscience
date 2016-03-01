function [ decimated_output ] = c_decimator( input_data, decimation_factor )
%c_decimator -- downsamples the input data by the given decimation factor
%   Extracts every decimation_factor sample from input_data and stores it
%   in decimated_output. (i.e. for decimation_factor = 10, every 10 sample
%   of input data is stored in decimated_output, starting with the first
%   sample.

N_samples = length(input_data); % no. of samples in input data
decimated_output = zeros(1, ceil(N_samples/decimation_factor));

k = 1;
for i=1:N_samples
    if (mod(i-1, decimation_factor) == 0)
        decimated_output(k) = input_data(i);
        k = k + 1;
    end 
end

end

