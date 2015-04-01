set_VR_parameters

motionVR=stimuli.motionVR;
motionVR(find(motionVR<min_mazeposition))=min_mazeposition;   %correct motionVR by eliminating points that appear to lie outside the maze min-max boundaries.
motionVR(find(motionVR>max_mazeposition))=max_mazeposition;

unwrap_motionVR=0;
for i=2:length(motionVR);
    if (motionVR(i)-motionVR(i-1))>-0.1
    unwrap_motionVR(i)=[unwrap_motionVR(i-1)+motionVR(i)-motionVR(i-1)]; 
    else unwrap_motionVR(i)=unwrap_motionVR(i-1);
    end
end
vy=diff(unwrap_motionVR)*velocitysamplingrate;
vy(find(vy>max_vy | vy<min_vy))=0;

roomentries=[];
for init=1:4
roomentries{init}=[];
end

for room=1:numberofrooms
    
    minpos=(room-1)*max_mazeposition/numberofrooms;
    maxpos=room*max_mazeposition/numberofrooms;
    
    timesinroom=find(motionVR>=minpos & motionVR<maxpos)/velocitysamplingrate;
    
    largedifftimes=find(diff(timesinroom)>min_completiontime);
    
    roomentries{room}=timesinroom(largedifftimes+1);    %time in seconds that animal entered a particular room.  Note: sometimes animals move backwards and transiently reenter;
end
