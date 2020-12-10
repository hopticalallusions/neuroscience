%% readme
% the plan with the miniscopes is to put an array in the contralateral
% hippocampus and look for SWR coinciding with the calcium signals
%
% it is also known that SWR can be coordinated or not along the
% septotemporal axis
%
% POINT : check DA5 data and see how the cross-hemisphere data and
% intra-hemisphere data look
%
% Useful References :
%
% intra-vs-contra hemispheric :
%
% Villalobos C, Maldonado PE, Valde ?s JL (2017) Asynchronous ripple oscillations between left and right hippocampi during slow-wave sleep. PLoS ONE 12(2): e0171304. doi:10.1371/journal. pone.0171304
%
% across the septo-temporal pole :
%
% Local Generation and Propagation of Ripples along the Septotemporal Axis of the Hippocampus
% Jagdish Patel, Erik W. Schomburg, Antal Berenyi, Shigeyoshi Fujisawa, and Gyorgy Buzsaki. 
% J. Neurosci., October 23, 2013 ? 33(43):17029 ?17041
%

%% placement information
% rat : DA5
% tt1  - CA1  ; 0-1 units; low amp signal lfp
% tt2  - CA1  ; >10 units; great lfp; swr due to layer; ch4-7; LEFT HF;
% tt3  - VTA  ; 0 units?; low amp signal lfp, little events
% tt4  - VTA  ; 0 units?; low amp signal lfp, little events
% tt5  - Nacc ; 0 units?; broken?; flat LFP
% tt6  - Nacc ; flat LFP
% tt7  - CA1  ; units; strong LFP; SWR?  ;  ch 24-27; LEFT HF
% tt8  - CA1  ; units; medium LFP        ;  ch 28-31; LEFT HF
% tt9  - VTA  ; 0 units?; broken?
% tt10 - CA1  ;               SWR?       ; ch 36-40; RIGHT HF
% tt11 - CA1  ; 
% tt12 - CA1  ; very good Theta LFP
% tt13 - CA1  ; 2-3 units; medium LFP action     ; ch 48-51; RIGHT HF
% tt14 - Nacc ; 2 units; uneventful LFP 
% tt15 - Nacc ; 2 units; uneventful LFP
% tt16 - VTA  ; x-connected; noisy, mainly uninteresting LFP
%

%% code 


dir='/Users/andrewhowe/data/plusMazeAnalysisFigures/swrTimesData/';
