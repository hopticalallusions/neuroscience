/*
//// obtain data
clear all;
load('~/Desktop/cs259demodata.mat')
//// create data structures
// constants
//choose hilbert algorithm
whatHilbert = 'delay'; // 'fir' 'diff' 'delay'
bitvolts = 0.015624999960550667; // microvolts per bit
powerThreshold = 60; // microvolts
phaseSegmentsDesired = 10; // divisions of the phase of theta
nativeSampleRate = 32000; // Hz
downsampleRate = 250; // Hz
everyNthSample = round(nativeSampleRate/downsampleRate); // 128 samples of each 32,000 (Hz) is 250 Hz
lowpassNumeratorCoeffs =   [ 0.000000000006564694180131090961704897522  0.000000000039388165080786542539055117347  0.000000000098470412701966356347637793367  0.000000000131293883602621825696446486011  0.000000000098470412701966356347637793367  0.000000000039388165080786542539055117347  0.000000000006564694180131090961704897522  ];
lowpassDenominatorCoeffs = [ 1 -5.893323981110579090625378739787265658379 14.472294910655531197107848129235208034515  -18.955749009589681008947081863880157470703  13.966721637745113326900536776520311832428  -5.488755923739796926952294597867876291275  0.898812366459551981279219035059213638306  ];
lowpassNCoeff = min(length(lowpassDenominatorCoeffs),length(lowpassNumeratorCoeffs));
//
// be carfeul about changing this, because the matrix sizes are hard coded
numberOfBandsToPass = 34;
bandpassDenominatorCoeffs = zeros(numberOfBandsToPass,5);
bandpassNumeratorCoeffs = zeros(numberOfBandsToPass,5);
bandpassNCoeff = min(length(bandpassDenominatorCoeffs),5);
bandpassCenterFrequencies = zeros(1,numberOfBandsToPass);
delay_samples = zeros(1,numberOfBandsToPass);
responsePoints = 1024;
//// filter analysis
wc = zeros(numberOfBandsToPass,responsePoints);
zc = zeros(numberOfBandsToPass,responsePoints);
pc = zeros(numberOfBandsToPass,responsePoints);
oc = zeros(numberOfBandsToPass,responsePoints);
for ii=1:numberOfBandsToPass
    Fstop1 = 2;         // First Stopband Frequency
    Fpass1 = 3.4 + ii/4;         // First Passband Frequency
    Fpass2 = 3.8 + ii/4;         // Second Passband Frequency
    Fstop2 = 18;        // Second Stopband Frequency
    Astop1 = 30;          // First Stopband Attenuation (dB)
    Apass  = 1;           // Passband Ripple (dB)
    Astop2 = 30;          // Second Stopband Attenuation (dB)
    match  = 'passband';  // Band to match exactly
    // Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, downsampleRate);
    thetaFilter = design(h, 'butter', 'MatchExactly', match);
    // analyze the filter
    [wc(ii,:),zc(ii,:)]=freqz(thetaFilter,responsePoints);
    [pc(ii,:),oc(ii,:)]=phasez(thetaFilter,responsePoints);
    // Get the transfer function values.
    [b, a] = tf(thetaFilter);
    // Convert to a singleton filter.
    thetaFilter = dfilt.df2(b, a);
    // extract the coefficients
    bpcoefs = thetaFilter.coefficients; 
    bandpassDenominatorCoeffs(ii,:) = bpcoefs{2};
    bandpassNumeratorCoeffs(ii,:) = bpcoefs{1};
    bandpassCenterFrequencies(ii) = mean([Fpass1 Fpass2]);
    delay_samples(ii) = round(downsampleRate/(bandpassCenterFrequencies(ii) * 4)) ; // the 6.95 is the center frequency of the bandpass filter; need a bank of these values normally
end
bandpassGain = downsampleRate./(bandpassCenterFrequencies.^2);
// for checking the results
lowpassed = zeros(size(lfp));
downsampled = zeros(size(lfp));
bandpassed = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
hilberted = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
angled = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
enveloped = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
envelopeTemporalSmoothed = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
envelopeTemporalBandSmoothed = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
thresholded = zeros(numberOfBandsToPass,ceil(length(lfp)/everyNthSample));
maxBandpassIdx = zeros(1,ceil(length(lfp)/everyNthSample));
instantFrequency = zeros(1,ceil(length(lfp)/everyNthSample)); // what's the center frequency?
digitized = zeros(1,ceil(length(lfp)/everyNthSample)); // what port is active? -1 == NULL

deltaEnvTemporal=.1;
*/

//// simulate the arrival of data samples
// cheat a little on the spool up



// CORDIC lookup table
// the following is a table of arctan values for the small steps used to
// binary search for the angle and hypotenuse of the provided coordinate
double arctanLookup[] = {
	0.78539816339745,   0.46364760900081,   0.24497866312686,	0.12435499454676,	
	0.06241880999596,   0.03123983343027,   0.01562372862048,   0.00781234106010, 	
	0.00390623013197,   0.00195312251648,   0.00097656218956,   0.00048828121119,	
	0.00024414062015,   0.00012207031189,   0.00006103515617,   0.00003051757812, 	
	0.00001525878906,   0.00000762939453,   0.00000381469727,   0.00000190734863,	
	0.00000095367432,   0.00000047683716,   0.00000023841858,   0.00000011920929, 	
	0.00000005960464,   0.00000002980232,   0.00000001490116,   0.00000000745058 
};

int envThreshold = 3480; // 60 uV / 1.5625e-8 bits per volt

int input_size = 0;
int dataIndex = 0;
int freqBandIdx = 0;
int k_limit = 0;
int tempMax = 0;
int tempMaxIdx = 0;
int k = 0;
int dsIdx = 0;
int cordicX = 0;
int xordicY = 0;
int cordicZ = 0;
int offset = 0;
float pi = 3.1415;

int lfp[]
int lowpassed[]
int downsampled[]
int bandpassed[][] 
int hilberted[][]
int arctanLookup[]
int enveloped[][]
int angled[][]
int envelopeTemporalSmoothed[][]
int envelopeTemporalBandSmoothed[][]
int maxBandpassIdx[]
int digitized[]
int instantFrequency[]

int nLowpassCoeffs
lowpassDenomCoeffs[]
lowpassNumerCoeffs[]
int nBandpassCoeffs
int numberOfBandsToPass
bandpassDenominatorCoeffs[][] = { {}, {}, {} };
bandpassNumeratorCoeffs[][]
int delaySamples[]
int everyNthSample
deltaEnvTemporal
powerThreshold
bandpassCenterFrequencies[]

tempUp[]
tempDown[]



for ( dataIndex=0; dataIndex < input_size; dataIndex++ ) {

    // LOW PASS FILTER

    k_limit = (k < nLowpassCoeffs) ? dataIndex : nLowpassCoeffs;
    for (k=0; k<k_limit; k++) {
        lowpassed[i] += -lowpassDenomCoeffs[k]*lowpassed[i-k] + lowpassNumerCoeffs[k]*lfp[i-k];
	}
    
   // DOWN SAMPLE
   
   if ( 0 == dataIndex % everyNthSample )  {
   
         dsIdx = dataIndex/everyNthSample;
         downsampled[dsIdx] = lowpassed[dataIndex];

        // BANDPASS FILTERING  

        //bandpassCache = [ bandpassCache(2:end) lowpassed(dataIndex) ]; // shift register
        //bandpassed(dsIdx) = bandpassCache*bandpassNumeratorCoeffs' + bandpassCache*-bandpassDenominatorCoeffs';

        for ( freqBandIdx = 0; freqBandIdx < numberOfBandsToPass; freqBandIdx++ ) {
        
            k_limit = (k < nBandpassCoeffs) ? dataIndex : nBandpassCoeffs;
	        for ( k = 0; k < k_limit; k++ ) {
    	        bandpassed[freqBandIdx][dsIdx] += - bandpassed[freqBandIdx][dsIdx-k]*bandpassDenominatorCoeffs[freqBandIdx][k] + downsampled[dsIdx-k]*bandpassNumeratorCoeffs[freqBandIdx][k];
			}

            //  HILBERT TRANSFORM APPROXIMATION

            if dsIdx > delaySamples[freqBandIdx] {
                hilberted[freqBandIdx][dsIdx] =  bandpassed[freqBandIdx][dsIdx-delaySamples[freqBandIdx]];
            } else {
            	hilberted[freqBandIdx][dsIdx] = 0;
            }
            
            //// BEGIN CORDIC
			
			cordicX = bandpassed[freqBandIdx][dsIdx]; 
			xordicY = hilberted[freqBandIdx][dsIdx];
			cordicZ = 0;
			
			if ( cordicX > 0 )  {
				offset = 0;
			} else {
				cordicX = -cordicX;
				cordicY = -cordicY;
				offset = 180;
			}

			for ( k=0; k < 25 ; k++ ) {

				if ( cordicY < 0 ) {
					cordicX = cordicX - ( cordicY >> k );
					cordicY = cordicY + ( cordicX >> k );
					cordicZ = cordicZ - ( arctanLookup[k] );
				} else {
					cordicX = cordicX + ( cordicY >> k );
					cordicY = cordicY - ( cordicX >> k );
					cordicZ = cordicZ + ( arctanLookup[k] );
				}
			}

			//    TODO  integers...
			enveloped[freqBandIdx][dsIdx] = cordicX * 0.6073;
			angled[freqBandIdx][dsIdx] = 270 - offset + cordicZ*180/pi ;
            
            // END CORDIC
        }    

         //// SMOOTH ENVELOPE

		// temporal smoothing
		
		for ( k = 0; k < numberOfBandsToPass; k++ ) {
			if dsIdx == 1 {
				envelopeTemporalSmoothed[k][dsIdx] = enveloped[k][dsIdx];
			} else {
				// this may require modification to deal with integer only calculation?
				envelopeTemporalSmoothed[k][dsIdx] = (1-deltaEnvTemporal)*envelopeTemporalSmoothed[k][dsIdx-1] + (deltaEnvTemporal)*enveloped[k][dsIdx];
			}
         }
         
        // frequency band smoothing
        //
		// TODO (1) to just use ints and bitshifts
		//              maybe do this by rounding off the 'big' number by shift and shift back
		//              then shift the smaller component(s) and add
		//
		// TODO (2) instead of doing this bi-directional silliness, start at 1 and go to n-1 
		//              with a m-1 m m+1 filter
		//
        for ( k = 0; k < numberOfBandsToPass; k++ ) {
        	tempUp[k] = envelopeTemporalSmoothed[k][dsIdx];
        	tempDown[k] = envelopeTemporalSmoothed[k][dsIdx];
    	}
        for ( k=1; k<numberOfBandsToPass; k++ ) {
            tempUp[k] = (1-deltaEnvTemporal) * envelopeTemporalSmoothed[k-1][dsIdx] + deltaEnvTemporal * envelopeTemporalSmoothed[k][dsIdx];
            tempDown(numberOfBandsToPass-k+1) = (1-deltaEnvTemporal)*envelopeTemporalSmoothed[numberOfBandsToPass-k+1][dsIdx] + (deltaEnvTemporal)*envelopeTemporalSmoothed[numberOfBandsToPass-k][dsIdx]);
        }
        for ( k=0; k<numberOfBandsToPass; k++ ) {
	         envelopeTemporalBandSmoothed[k][dsIdx] = (tempUp[k]+tempDown[k]) >> 2 ; // can be replaced with a bitshift
    	}
         
         // THRESHOLD CHECK

		int tempMax = 0;
		int tempMaxIdx = 0;
		for ( k=0; k<numberOfBandsToPass; k++ ) {
			if ( tempMax < envelopeTemporalBandSmoothed[k][dsIdx] ) {
				tempMax = envelopeTemporalBandSmoothed[k][dsIdx];
				tempMaxIdx = k;
			}
		}

         maxBandpassIdx[dsIdx] = tempMaxIdx;    // accounting
         
         if ( tempMax < powerThreshold ) {  // make this somehow integer-y
             digitized[bp][dsIdx] = NULL;
         } else {
         
             //// DIGITAL OUTPUT
             // i.e. what TTL is currently on

             instantFrequency[dsIdx]= bandpassCenterFrequencies[tempMaxIdx];
             // m >>= n  // divide m by 2^n
             // m <<= n  // multiply m by 2^n
             digitized[dsIdx] = angled[tempMaxIdx][dsIdx] >> 5; // this really depends on both the output size of the CORDIC and the desired number of levels
         }
    }
}
