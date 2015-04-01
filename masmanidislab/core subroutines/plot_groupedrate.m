
event1_groupstack_=[];
for groupk=1:event1_trialgroups
event1_groupstack=[event1_groupstack; event1_groupzscore{unitj}{groupk}];
end

h=fspecial('gaussian',3,0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
% h=fspecial('gaussian',[1 3],0.75);  %gaussian filter. [1 3] only filters in horizontal (time) direction
event1_groupstack=filter2(h, event1_groupstack);

surf(event1_groupstack)
shading interp
view(-20,75)