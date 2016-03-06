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
// working variables
int input_size 	= 0;
int dataIndex 	= 0;
int freqBandIdx = 0;
int k_limit 	= 0;
int tempMax 	= 0;
int tempMaxIdx 	= 0;
int k 			= 0;
int dsIdx		= 0;
int cordicX 	= 0;
int xordicY		= 0;
int cordicZ		= 0;
int offset		= 0;
float pi		= 3.1415;
// accounting variables
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
// parameters
int nLowpassCoeffs 		= 7;
double lowpassNumeratorCoeffs[nLowpassCoeffs] =   { 
	0.000000000006564694180131090961704897522,  0.000000000039388165080786542539055117347,  
	0.000000000098470412701966356347637793367,  0.000000000131293883602621825696446486011,  
	0.000000000098470412701966356347637793367,  0.000000000039388165080786542539055117347,  
	0.000000000006564694180131090961704897522  
};
double lowpassDenominatorCoeffs[nLowpassCoeffs] = { 
	1, -5.893323981110579090625378739787265658379, 
	14.472294910655531197107848129235208034515,  -18.955749009589681008947081863880157470703,  
	13.966721637745113326900536776520311832428,  -5.488755923739796926952294597867876291275, 
	 0.898812366459551981279219035059213638306 
};
int numberOfBandsToPass = 34;
int nBandpassCoeffs 	= 5;
double bandpassDenominatorCoeffs[numberOfBandsToPass][nBandpassCoeffs] = 
	{
		{1, -3.96150264904908, 5.90354242794449, -3.92222041251962, 0.980266823997447 },
		{1, -3.95900845805579, 5.89860348967342, -3.91975095390930, 0.980266823997463 },
		{1, -3.95635797218746, 5.89335846902837, -3.91712675024294, 0.980266823997454 },
		{1, -3.95355129608076, 5.88780819425899, -3.91434790511969, 0.980266823997449 },
		{1, -3.95058854053846, 5.88195354181801, -3.91141452824360, 0.980266823997452 },
		{1, -3.94746982252508, 5.87579543622291, -3.90832673541935, 0.980266823997453 },
		{1, -3.94419526516224, 5.86933484990992, -3.90508464854770, 0.980266823997453 },
		{1, -3.94076499772388, 5.86257280308052, -3.90168839562069, 0.980266823997446 },
		{1, -3.93717915563110, 5.85551036354037, -3.89813811071665, 0.980266823997461 },
		{1, -3.93343788044676, 5.84814864653041, -3.89443393399459, 0.980266823997449 },
		{1, -3.92954131987005, 5.84048881455121, -3.89057601168921, 0.980266823997454 },
		{1, -3.92548962773047, 5.83253207717898, -3.88656449610461, 0.980266823997453 },
		{1, -3.92128296398190, 5.82427969087479, -3.88239954560856, 0.980266823997454 },
		{1, -3.91692149469622, 5.81573295878612, -3.87808132462619, 0.980266823997453 },
		{1, -3.91240539205678, 5.80689323054103, -3.87361000363345, 0.980266823997452 },
		{1, -3.90773483435158, 5.79776190203511, -3.86898575915049, 0.980266823997462 },
		{1, -3.90291000596622, 5.78834041521093, -3.86420877373447, 0.980266823997454 },
		{1, -3.89793109737668, 5.77863025783052, -3.85927923597267, 0.980266823997455 },
		{1, -3.89279830514174, 5.76863296324030, -3.85419734047479, 0.980266823997456 },
		{1, -3.88751183189526, 5.75835011012895, -3.84896328786534, 0.980266823997456 },
		{1, -3.88207188633815, 5.74778332227820, -3.84357728477577, 0.980266823997457 },
		{1, -3.87647868323012, 5.73693426830632, -3.83803954383624, 0.980266823997454 },
		{1, -3.87073244338128, 5.72580466140473, -3.83235028366731, 0.980266823997455 },
		{1, -3.86483339364333, 5.71439625906735, -3.82650972887121, 0.980266823997453 },
		{1, -3.85878176690065, 5.70271086281320, -3.82051811002305, 0.980266823997456 },
		{1, -3.85257780206111, 5.69075031790176, -3.81437566366168, 0.980266823997455 },
		{1, -3.84622174404662, 5.67851651304176, -3.80808263228038, 0.980266823997458 },
		{1, -3.83971384378345, 5.66601138009278, -3.80163926431723, 0.980266823997456 },
		{1, -3.83305435819238, 5.65323689376029, -3.79504581414536, 0.980266823997456 },
		{1, -3.82624355017848, 5.64019507128378, -3.78830254206294, 0.980266823997461 },
		{1, -3.81928168862081, 5.62688797211817, -3.78140971428274, 0.980266823997458 },
		{1, -3.81216904836172, 5.61331769760870, -3.77436760292183, 0.980266823997454 },
		{1, -3.80490591019608, 5.59948639065906, -3.76717648599074, 0.980266823997460 },
		{1, -3.79749256086015, 5.58539623539289, -3.75983664738238, 0.980266823997455 }
	};
double bandpassNumeratorCoeffs[numberOfBandsToPass][nBandpassCoeffs] =  
{
    { 0.0000491622600867856, 0, -0.0000983245201735711, 0, 0.0000491622600867856 }, 
	{ 0.0000491622600867275, 0, -0.0000983245201734550, 0, 0.0000491622600867275 }, 
	{ 0.0000491622600867328, 0, -0.0000983245201734657, 0, 0.0000491622600867328 }, 
	{ 0.0000491622600867654, 0, -0.0000983245201735307, 0, 0.0000491622600867654 }, 
	{ 0.0000491622600867510, 0, -0.0000983245201735021, 0, 0.0000491622600867510 }, 
	{ 0.0000491622600867607, 0, -0.0000983245201735215, 0, 0.0000491622600867607 }, 
	{ 0.0000491622600867297, 0, -0.0000983245201734594, 0, 0.0000491622600867297 }, 
	{ 0.0000491622600867600, 0, -0.0000983245201735200, 0, 0.0000491622600867600 }, 
	{ 0.0000491622600867117, 0, -0.0000983245201734235, 0, 0.0000491622600867117 }, 
	{ 0.0000491622600867600, 0, -0.0000983245201735199, 0, 0.0000491622600867600 }, 
	{ 0.0000491622600867485, 0, -0.0000983245201734969, 0, 0.0000491622600867485 }, 
	{ 0.0000491622600867329, 0, -0.0000983245201734658, 0, 0.0000491622600867329 }, 
	{ 0.0000491622600867276, 0, -0.0000983245201734552, 0, 0.0000491622600867276 }, 
	{ 0.0000491622600867348, 0, -0.0000983245201734695, 0, 0.0000491622600867348 }, 
	{ 0.0000491622600867388, 0, -0.0000983245201734776, 0, 0.0000491622600867388 }, 
	{ 0.0000491622600867073, 0, -0.0000983245201734145, 0, 0.0000491622600867073 }, 
	{ 0.0000491622600867260, 0, -0.0000983245201734519, 0, 0.0000491622600867260 }, 
	{ 0.0000491622600867192, 0, -0.0000983245201734383, 0, 0.0000491622600867192 }, 
	{ 0.0000491622600867101, 0, -0.0000983245201734201, 0, 0.0000491622600867101 }, 
	{ 0.0000491622600867277, 0, -0.0000983245201734554, 0, 0.0000491622600867277 }, 
	{ 0.0000491622600867347, 0, -0.0000983245201734693, 0, 0.0000491622600867347 }, 
	{ 0.0000491622600867398, 0, -0.0000983245201734797, 0, 0.0000491622600867398 }, 
	{ 0.0000491622600867445, 0, -0.0000983245201734891, 0, 0.0000491622600867445 }, 
	{ 0.0000491622600867381, 0, -0.0000983245201734762, 0, 0.0000491622600867381 }, 
	{ 0.0000491622600867338, 0, -0.0000983245201734677, 0, 0.0000491622600867338 }, 
	{ 0.0000491622600867299, 0, -0.0000983245201734599, 0, 0.0000491622600867299 }, 
	{ 0.0000491622600867388, 0, -0.0000983245201734775, 0, 0.0000491622600867388 }, 
	{ 0.0000491622600867455, 0, -0.0000983245201734910, 0, 0.0000491622600867455 }, 
	{ 0.0000491622600867251, 0, -0.0000983245201734501, 0, 0.0000491622600867251 }, 
	{ 0.0000491622600867396, 0, -0.0000983245201734792, 0, 0.0000491622600867396 }, 
	{ 0.0000491622600867273, 0, -0.0000983245201734546, 0, 0.0000491622600867273 }, 
	{ 0.0000491622600867222, 0, -0.0000983245201734445, 0, 0.0000491622600867222 }, 
	{ 0.0000491622600867201, 0, -0.0000983245201734403, 0, 0.0000491622600867201 }, 
	{ 0.0000491622600867359, 0, -0.0000983245201734718, 0, 0.0000491622600867359 }
};
int delaySamples[numberOfBandsToPass] = {
	16, 15, 14, 14, 13, 12, 12, 11, 11, 10, 10, 9, 9, 9, 9, 8, 8, 8, 7, 7, 7, 7, 7, 7, 
	6, 6, 6, 6, 6, 6, 6, 5, 5, 5
};
int everyNthSample 		= 128;
double deltaEnvTemporal = 0.1;
double bandpassCenterFrequencies[numberOfBandsToPass] = {
	3.85, 4.10, 4.35, 4.60, 4.85, 5.10, 5.35, 5.60, 5.85, 6.10, 6.35, 6.60, 6.85, 7.10, 7.35, 
	7.60, 7.85, 8.10, 8.35, 8.60, 8.85, 9.10, 9.35, 9.60, 9.85, 10.1, 10.35, 10.6, 10.85, 11.1,
	11.35, 11.6, 11.85,	12.10
};

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
         
         if ( tempMax < envThreshold ) {  // make this somehow integer-y
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
