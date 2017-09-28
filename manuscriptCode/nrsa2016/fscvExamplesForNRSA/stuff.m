/Users/andrewhowe/Downloads/da5fscEphysRecheck


[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( data(5,:)', timestamps );


figure; plot((1:3200)/32,meanCscWindow*0.000015624999960550667); title('avg fscv artifact, raw, unfiltered data'); xlabel('time'); ylabel('mV')