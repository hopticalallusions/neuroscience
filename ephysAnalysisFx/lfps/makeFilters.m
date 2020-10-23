% specified order
filters.so.delta    = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',  0.1, 'HalfPowerFrequency2',    4, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
filters.so.lia      = designfilt( 'bandpassiir', 'FilterOrder',  2, 'HalfPowerFrequency1',    1, 'HalfPowerFrequency2',   50, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
filters.so.theta    = designfilt( 'bandpassiir', 'FilterOrder', 10, 'HalfPowerFrequency1',    4, 'HalfPowerFrequency2',   12, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
filters.so.alpha    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    8, 'HalfPowerFrequency2',   14, 'SampleRate', 32000);
filters.so.beta     = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   14, 'HalfPowerFrequency2',   31, 'SampleRate', 32000);
filters.so.lowGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   30, 'HalfPowerFrequency2',   80, 'SampleRate', 32000); % verified 8 is good
filters.so.midGamma = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   70, 'HalfPowerFrequency2',  120, 'SampleRate', 32000);
filters.so.gamma    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',   70, 'HalfPowerFrequency2',  150, 'SampleRate', 32000); % Sullivan, Csicsvari ... Buzsaki, J Neuro 2011; Fig 1D
filters.so.swr      = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  150, 'HalfPowerFrequency2',  250, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
filters.so.highLfp  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  250, 'HalfPowerFrequency2',  600, 'SampleRate', 32000);
filters.so.spike    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  600, 'HalfPowerFrequency2', 6000, 'SampleRate', 32000);
filters.so.nrem     = designfilt( 'bandpassiir', 'FilterOrder',  4, 'HalfPowerFrequency1',    6, 'HalfPowerFrequency2',   40, 'SampleRate', 32000);
filters.so.chew     = designfilt( 'bandpassiir', 'FilterOrder', 20, 'HalfPowerFrequency1',  100, 'HalfPowerFrequency2', 1000, 'SampleRate', 32000); % verified order, settings by testing
filters.so.electric = designfilt( 'bandpassiir', 'FilterOrder', 12, 'HalfPowerFrequency1',    59, 'HalfPowerFrequency2',  61, 'SampleRate', 32000); % verified order, settings by testing
filters.so.spindle  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',    12, 'HalfPowerFrequency2',  14, 'SampleRate', 32000); % sleep spindles occur before k-complexes, and must be ~500+microscends

filters.so.hiSwr    = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  180, 'HalfPowerFrequency2',  250, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
filters.so.hiGamma  = designfilt( 'bandpassiir', 'FilterOrder',  8, 'HalfPowerFrequency1',  120, 'HalfPowerFrequency2',  170, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article





% ao -> Algorithmic Order Filters
filters.ao.delta    = designfilt( 'bandpassiir', 'StopbandFrequency1', 0.08, 'PassbandFrequency1',  0.1, 'PassbandFrequency2',    4, 'StopbandFrequency2',    6, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order 2 or 4; 6 blows up the signal
filters.ao.lia      = designfilt( 'bandpassiir', 'StopbandFrequency1',  0.5, 'PassbandFrequency1',    1, 'PassbandFrequency2',   50, 'StopbandFrequency2',   55, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order; after Vanderwolf; Ranck; Buzsaki's slow depictions of SWR
filters.ao.theta    = designfilt( 'bandpassiir', 'StopbandFrequency1',    3, 'PassbandFrequency1',    4, 'PassbandFrequency2',   12, 'StopbandFrequency2',   14, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order 8 or 10 seems good;;;;                  2,4,6,8 seem pretty equivalent
filters.ao.alpha    = designfilt( 'bandpassiir', 'StopbandFrequency1',    6, 'PassbandFrequency1',    8, 'PassbandFrequency2',   14, 'StopbandFrequency2',   18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
filters.ao.beta     = designfilt( 'bandpassiir', 'StopbandFrequency1',   12, 'PassbandFrequency1',   14, 'PassbandFrequency2',   31, 'StopbandFrequency2',   36, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
filters.ao.lowGamma = designfilt( 'bandpassiir', 'StopbandFrequency1',   25, 'PassbandFrequency1',   30, 'PassbandFrequency2',   80, 'StopbandFrequency2',   90, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified 8 is good
filters.ao.midGamma = designfilt( 'bandpassiir', 'StopbandFrequency1',   55, 'PassbandFrequency1',   60, 'PassbandFrequency2',  120, 'StopbandFrequency2',  130, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
filters.ao.swr      = designfilt( 'bandpassiir', 'StopbandFrequency1',  100, 'PassbandFrequency1',  110, 'PassbandFrequency2',  240, 'StopbandFrequency2',  260, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % equivalent to "High Gamma", Buzsaki SWR review article
filters.ao.highLfp  = designfilt( 'bandpassiir', 'StopbandFrequency1',  250, 'PassbandFrequency1',  260, 'PassbandFrequency2',  550, 'StopbandFrequency2',  600, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
filters.ao.spike    = designfilt( 'bandpassiir', 'StopbandFrequency1',  550, 'PassbandFrequency1',  600, 'PassbandFrequency2', 6000, 'StopbandFrequency2', 6500, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
filters.ao.nrem     = designfilt( 'bandpassiir', 'StopbandFrequency1',    4, 'PassbandFrequency1',    6, 'PassbandFrequency2',   40, 'StopbandFrequency2',   45, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000);
filters.ao.electric = designfilt( 'bandpassiir', 'StopbandFrequency1',   58, 'PassbandFrequency1',   59, 'PassbandFrequency2',   61, 'StopbandFrequency2',   62, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order, settings by testing
filters.ao.spindle  = designfilt( 'bandpassiir', 'StopbandFrequency1',   10, 'PassbandFrequency1',   12, 'PassbandFrequency2',   14, 'StopbandFrequency2',   18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % sleep spindles occur before k-complexes, and must be ~500+microscends


filters.ao.chew     = designfilt( 'bandpassiir', 'StopbandFrequency1',   80, 'PassbandFrequency1',  100, 'PassbandFrequency2', 1000, 'StopbandFrequency2', 1200, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', 32000); % verified order, settings by testing
%filters.ao.nomnom   = designfilt( 'bandpassiir', 'StopbandFrequency1',    3, 'PassbandFrequency1',    4, 'PassbandFrequency2',    6, 'StopbandFrequency2',    8, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate);
%filters.ao.brux     = designfilt( 'bandpassiir', 'StopbandFrequency1',    8, 'PassbandFrequency1',    9, 'PassbandFrequency2',   15, 'StopbandFrequency2',   18, 'StopbandAttenuation1', 30, 'PassbandRipple', 1, 'StopbandAttenuation2', 30, 'SampleRate', chewCrunchEnvSampleRate); 


%report order
filters.ao.order.delta=filtord(filters.ao.delta    );
filters.ao.order.lia=filtord(filters.ao.lia      );
filters.ao.order.theta=filtord(filters.ao.theta    );
filters.ao.order.alpha=filtord(filters.ao.alpha    );
filters.ao.order.beta=filtord(filters.ao.beta     );
filters.ao.order.lowGamma=filtord(filters.ao.lowGamma );
filters.ao.order.midGamma=filtord(filters.ao.midGamma );
filters.ao.order.swr=filtord(filters.ao.swr      );
filters.ao.order.highLfp=filtord(filters.ao.highLfp  );
filters.ao.order.spike=filtord(filters.ao.spike    );
filters.ao.order.nrem=filtord(filters.ao.nrem     );
filters.ao.order.chew=filtord(filters.ao.chew     );
filters.ao.order.electric=filtord(filters.ao.electric );
filters.ao.order.spindle=filtord(filters.ao.spindle  );


% 
% Delta wave ? (0.1 ? 4 Hz)
% Theta wave ? (4 ? 8 Hz)
% Alpha wave ? (8 ? 14 Hz)
%       Mu wave ? (7 ? 13 Hz) (sensirimotor)
%       SMR wave ? (12.5 ? 15.5 Hz)
% Beta wave ? (14 ? 31 Hz)
% Gamma wave ? (32 ? 90 Hz)
% fast Gamma wave ? (90 ? 130 Hz)
% sharp wave ? (130 ? 250 Hz)


% Buzsaki SWR review 2015 says gamma is :
%     slow  30-80  Hz
%     mid   60-120 Hz
%     fast  >100Hz

% from https://en.wikipedia.org/wiki/Gamma_wave
% see also the Table here :
% https://en.wikipedia.org/wiki/Electroencephalography 
% these frequencies seem a bit squishy



% Delta wave ? (0.1 ? 4 Hz)
% Theta wave ? (4 ? 8 Hz)
% Alpha wave ? (8 ? 14 Hz)
% Beta wave ? (14 ? 31 Hz)
% Gamma wave ? (32 ? 90 Hz)
% fast Gamma wave ? (90 ? 130 Hz)
% sharp wave ? (130 ? 250 Hz)
