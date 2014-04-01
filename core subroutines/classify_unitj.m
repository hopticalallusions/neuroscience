%***Unit classification criteria.
%Used in do_autounitclass and do_manualunitclass

celltype0='Unclassified';
celltype1='MSN';
celltype2='FSI';
celltype3='TAN';


%Classification criteria.
%July 23 2013: Current classification criteria are:
%1. Easy distinction between FSIs and non-FSIs based on trough-to-peak time.
%2a. If a non-FSI has min_TAN_rate<rate<max_nonFSI_rate Hz and CV of ISI <max_TAN_cv, it is a putative TAN,
%2b. If a non-FSI is not a TAN, and min_MSN_rate<rate<max_nonFSI_rate, it is a putative MSN.
%3. If none of these are satisfied, it is unclassified.

%Rationale:
%i.   The narrow waveform of FSIs is often cited. e.g. Gage & Berke 2010.
%ii.  Unfortunately putative TANs and MSNs do not have entirely non-overlapping waveforms.  But TANs tend to fire more steadily (low CV), are not bursty at very low ISI, and the pre-trough and 
      %post-trough peaks are similar amplitude (low anisotropy).  Also unfortunate is that the Graybiel group never details their TAN classification criteria.  Another useful reference besides Aosaki 1994, is English 2012.
%iii. The parameters below were selected by looking at histograms collected from 10 mice (#42-64).

%Note: 
%i.   FSIs have higher baseline firing than non-FSIs.
%ii.  Most TANs have lower CV of ISI (<2), low percent of bursting spikes (<2% @ ISI<5 ms), and low waveform anisotopy (<+/-0.15); however, there do appear to be some exceptions, making this classification scheme imperfect.
%iii. In contrast to TANs, most MSNs have higher CV, more bursting spikes, and higher waveform anisotropy.

max_FSI_troughpeaktime=0.5;
min_FSI_rate=1;  %in Hz.

min_nonFSI_troughpeaktime=0.55;

min_MSN_rate=0.05;

min_TAN_rate=2;  %Aosaki &Graybiel use 2 Hz.
max_nonFSI_rate=10;
max_TAN_percentbursting=2;
max_TAN_cv=2;


slopeunitj=unitproperties.waveslope{unitj};
pptimeunitj=unitproperties.peakpeaktime{unitj};
trpktimeunitj=unitproperties.troughpeaktime{unitj};
rateunitj=unitproperties.baselinerate{unitj};
anisotunitj=unitproperties.peakanisotropy{unitj};
percentburstunitj=unitproperties.percentbursting{unitj};
cvisiunitj=unitproperties.cvisi{unitj};


if trpktimeunitj<max_FSI_troughpeaktime & rateunitj>min_FSI_rate
    unitIDname=celltype2;
    unitIDnumber=2;
elseif trpktimeunitj>min_nonFSI_troughpeaktime & rateunitj>=min_MSN_rate & rateunitj<=max_nonFSI_rate   
%     if rateunitj>=min_TAN_rate & percentburstunitj<=max_TAN_percentbursting
    if rateunitj>=min_TAN_rate & cvisiunitj<=max_TAN_cv
    unitIDname=celltype3;
    unitIDnumber=3; 
    else
    unitIDname=celltype1;
    unitIDnumber=1;    
    end
else
    unitIDname=celltype0;
    unitIDnumber=0;    
end

