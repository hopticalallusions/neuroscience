// DECIMATOR
// decimated_output: downsampled output
// input_data: input samples to be filtered
// input_size: number of input samples
// decimation_factor: determines number of samples in downsampled output

void decimator(float *decimated_output, float *input_data, int input_size, int decimation_factor) {
    int output_size, i;

    if (input_size % decimation_factor == 0) output_size = input_size/decimation_factor;
    else output_size = input_size/decimation_factor + 1; 

    // take every decimation_factor th sample from the input and ouput, starting from 0
    decimated_output[0] = input_data[0];
    for (i=1; i<output_size; i++) {
        decimated_output[i] = input_data[i*decimation_factor];
    }

    return;
}
