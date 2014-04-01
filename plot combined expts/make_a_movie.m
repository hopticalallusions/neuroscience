%make_a_movie
sliding_inc = 0.01;
interp_size = timebinsize/sliding_inc;
moviedir = [combinedir 'movieframes\'];
if isdir(moviedir) == 0
   mkdir(moviedir);
end
excite_threshold = 0.8;

expanded_norm_e1 = [ventral_normstack_e1; dorsal_normstack_e1];

colors = colormap(jet);
colorbins = -1:1/32:1;
colorbins(1) = [];

rand_xpos = 1:size(expanded_norm_e1,1);
for i = 1:size(expanded_norm_e1,1)
    rand_xpos(i) = (60*(rand-0.5));
end

close all
dorsal_excited = zeros(1,size(expanded_norm_e1,2));
ventral_excited = zeros(1,size(expanded_norm_e1,2));
for i = 1:size(expanded_norm_e1,2)
    input = expanded_norm_e1(:,i);
    frame = i;
    if i < length(timebins)
    frametime = timebins(i);
    else frametime = timebins(i-1);
    end
    [vent_ex,dors_ex] = moviemap(input,big_x,big_z,region,colorbins,rand_xpos,frame,moviedir,combinedir,colors,frametime,excite_threshold);
    dorsal_excited(i) = sum(dors_ex)/numel(dors_ex);
    ventral_excited(i) = sum(vent_ex)/numel(vent_ex);
end
