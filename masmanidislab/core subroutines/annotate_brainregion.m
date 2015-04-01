% disp('Annotating units with brain region.')

%****Set annotation parameters****

AP_Str=1.3;
AP_min_Str=0.8;
AP_max_Str=1.5;
ML_min_DS=0.8;
ML_max_DS=2.5;
ML_max_NAc=2.5;
ML_min_NAc=0.4;
ML_max_OT=3;
ML_min_OT=0.6;
DV_max_DS=-2.4;
DV_min_OT=-6;
ML_DS_boundary=(ML_max_DS-ML_min_DS)/2+ML_min_DS;   %ML axis boundary between DMS-DLS
ML_NAc_boundary=(ML_max_NAc-ML_min_NAc)/2+ML_min_NAc;  %ML axis boundary between medial NAc - lateral NAc
DV_DS_NAc_boundary=-3.8;  %DV axis boundary between DS-NAc
DV_NAc_OT_boundary=-5.3;  %DV axis boundary between NAc-OT

%*********************************


if domultisubject=='n'; %finds significantly modulated (by event 1) units.    Note: need to run get_response_pvalue
load([timesdir 'finalspiketimes.mat'])
load([unitclassdir 'positions' '.mat'])
qualitycutoff=1;
select_dounits
end

suggest_brainregion=[];    
for unitind=1:length(dounits)
    unit=dounits(unitind);
    AP=positions.unity{unit};
    ML=positions.unitx{unit};
    depth=positions.unitz{unit};
        
    if AP>AP_min_Str & AP<AP_max_Str    %probe is in striatum.
        
    if abs(ML)<=ML_DS_boundary & abs(ML)>ML_min_DS & depth>=DV_DS_NAc_boundary & depth<DV_max_DS
    suggest_brainregion{unit}='DMS';
    elseif abs(ML)<=ML_max_DS & abs(ML)>ML_DS_boundary & depth>=DV_DS_NAc_boundary & depth<DV_max_DS
    suggest_brainregion{unit}='DLS';
    elseif abs(ML)<=ML_NAc_boundary & abs(ML)>ML_min_NAc & depth>=DV_NAc_OT_boundary & depth<DV_DS_NAc_boundary
    suggest_brainregion{unit}='medial NAc';
    elseif abs(ML)<=ML_max_NAc & abs(ML)>ML_NAc_boundary & depth>=DV_NAc_OT_boundary & depth<DV_DS_NAc_boundary
    suggest_brainregion{unit}='lateral NAc';
    elseif abs(ML)<=ML_max_OT & abs(ML)>ML_min_OT & depth>=DV_min_OT & depth<DV_NAc_OT_boundary
    suggest_brainregion{unit}='OT';    
    else 
    suggest_brainregion{unit}='outside';
    end
    
    end
    
end


% do_manualannotation=[];
% do_manualannotation=input('do you want to manually annotate the brain region (y/n)? [n]: ', 's');
% if isempty(do_manualannotation)
%     do_manualannotation='n';
% end  


% if do_manualannotation=='n'   
brainregion=suggest_brainregion;  
% elseif do_manualannotation=='y'
% end

striatumx=[ML_DS_boundary   ML_max_DS       ML_NAc_boundary     ML_max_NAc          ML_max_OT; 
           ML_min_DS        ML_DS_boundary  ML_min_NAc          ML_NAc_boundary     ML_min_OT;
           ML_min_DS        ML_DS_boundary  ML_min_NAc          ML_NAc_boundary     ML_min_OT;
           ML_DS_boundary   ML_max_DS       ML_NAc_boundary     ML_max_NAc          ML_max_OT];
       
striatumz=[AP_Str  AP_Str  AP_Str  AP_Str  AP_Str;
           AP_Str  AP_Str  AP_Str  AP_Str  AP_Str;
           AP_Str  AP_Str  AP_Str  AP_Str  AP_Str;
           AP_Str  AP_Str  AP_Str  AP_Str  AP_Str];
       
striatumy=[DV_max_DS            DV_max_DS           DV_DS_NAc_boundary  DV_DS_NAc_boundary  DV_NAc_OT_boundary;
           DV_max_DS            DV_max_DS           DV_DS_NAc_boundary  DV_DS_NAc_boundary  DV_NAc_OT_boundary;
           DV_DS_NAc_boundary   DV_DS_NAc_boundary  DV_NAc_OT_boundary  DV_NAc_OT_boundary  DV_min_OT;
           DV_DS_NAc_boundary   DV_DS_NAc_boundary  DV_NAc_OT_boundary  DV_NAc_OT_boundary  DV_min_OT];


figure(50)
close 50
figure(50)
patch(striatumx, striatumy, striatumz, 'FaceColor','none')
axis equal
text(2, -3, AP_Str,'DLS')
text(1, -3, AP_Str,'DMS')
text(1.6, -4.5, AP_Str, 'lateral NAc')
text(0.5, -4.5, AP_Str, 'medial NAc')
text(1.5, -5.7, AP_Str, 'OT/VP')
hold on
plot(abs(positions.elecx),positions.elecz,'o','MarkerSize',1,'MarkerFaceColor','b', 'MarkerEdgeColor','b')
xlabel('ML axis (mm)')
ylabel('depth (mm)')
title([subject])
       

save([unitclassdir 'positions' '.mat'], 'positions', '-mat')