// LOWPASS FIR FILTER
// lowpass_output: lowpass filtered output
// input_data: input samples to be filtered
// input_size: number of input samples
// filter_coeffs: FIR filter coefficients
// n_coeffs: number of filter coefficients

void lowpassFIR(float *lowpass_output, float *input_data, int input_size, float *filter_coeffs, int n_coeffs) {
    // different equation representation of lowpass FIR filter
    int i, k, k_limit;
    for (i=0; i<input_size; i++) {
        k_limit = (k < n_coeffs) ? k : n_coeffs;
        for (k=0; k<k_limit; k++) {
            lowpass_output[i] += filter_coeffs[k]*input_data[i-k];
        }
    }

    return;
}
