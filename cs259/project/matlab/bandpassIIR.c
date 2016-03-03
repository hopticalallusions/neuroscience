// BANDPASS IIR FILTER
// bandpass_output: bandpass filtered output
// input_data: input samples to be filtered
// input_size: number of input samples
// num_coeffs: IIR numerator filter coefficients
// denom_coeffs: IIR denominator filter coefficients
// n_coeffs: number of filter coefficients

void lowpassFIR(float *lowpass_output, float *input_data, int input_size, float *num_coeffs, float *denom_coeffs, int n_coeffs) {
    // different equation representation of bandpass IIR filter
    int i, k, k_limit;
    for (i=0; i<input_size; i++) {
        k_limit = (k < n_coeffs) ? k : n_coeffs;
        for (k=0; k<k_limit; k++) {
            lowpass_output[i] += -denom_coeffs[k]*lowpass_output[i-k] + num_coeffs[k]*input_data[i-k];
        }
    }

    return;
}
