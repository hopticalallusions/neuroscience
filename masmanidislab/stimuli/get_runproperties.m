%***Set parameters*****************
accelSD=5;              %default=5. threshold for detecting acceleration events.

%***********************************

motionVR=stimuli.motionVR;
if length(motionVR)>0
    isthis_VR='y';
    disp(['identified this experiment as Virtual Reality'])
else isthis_VR='n';
end

if isthis_VR=='y'  %have not yet calculated vy from motionVR.
    
    get_VR_velocity
    
end

[N,binvalue]=hist(vy,500);
maxNind=find(N==max(N));   %looks for most frequently occuring vy value, which should be the vy value at rest.
baselinevy=binvalue(maxNind);
vy=vy-baselinevy;   %ensures that vy=0 at rest.

accel=[0 diff(vy)*velocitysamplingrate]; %acceleration in meters per second squared.
accelthreshold=accelSD*std(accel);
  
[pks, pos_acceltimes]=findpeaks(accel,'minpeakheight',accelthreshold,'minpeakdistance',0.5*velocitysamplingrate);   %time in seconds.
[pks, neg_acceltimes]=findpeaks(-1*accel,'minpeakheight',accelthreshold,'minpeakdistance',0.5*velocitysamplingrate);  %time in seconds.
pos_acceltimes=pos_acceltimes/velocitysamplingrate; pos_acceltimes(find(pos_acceltimes<10))=[];
neg_acceltimes=neg_acceltimes/velocitysamplingrate; neg_acceltimes(find(neg_acceltimes<10))=[];
