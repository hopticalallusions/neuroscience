function [delta,unit_firstdiscrimination,unit_maxdiscrimination,significant_cell] = discrim_cells(discriminating_bins,observed_difference,querybins,dounits,max_pvalue)
cue1_discr_time = cell(1,dounits(end));
cue2_discr_time = cell(1,dounits(end));
delta.firstdiscrtime = cell(1,(dounits(end)));
delta.firstdiscrdelta = cell(1,(dounits(end)));
delta.maxdiscrdelta = cell(1,(dounits(end)));
delta.maxdiscrtime = cell(1,(dounits(end)));

unit_firstdiscrimination = cell(1,(dounits(end)));
unit_maxdiscrimination = cell(1,(dounits(end)));
significant_cell = cell(1,dounits(end));
for i = 1:length(dounits)
    unit = dounits(i);
    
    sig_bins = discriminating_bins{unit};
    pos_bins = find(sig_bins == 1);
    diff_pos_bins = diff(pos_bins);
    if min(diff_pos_bins) == 1
       x = pos_bins(diff_pos_bins == 1);
       xmed(1) = median(x);
       pos_disc = mean(observed_difference{unit}(pos_bins));
       cue1_discr_time{unit} = querybins(x(1));
       disc_ind(1) = x(1);
   else disc_ind(1) = 100;
            xmed(1) = 0;
            cue1_discr_time{unit} = 100;
   end

   neg_bins = find(sig_bins == -1);
   diff_neg_bins = diff(neg_bins);
   if min(diff_neg_bins) == 1
          x = neg_bins(diff_neg_bins == 1);
          xmed(2) = median(x);
          neg_disc = mean(observed_difference{unit}(neg_bins));
          cue2_discr_time{unit} = querybins(x(1));
          disc_ind(2) = x(1);
       else disc_ind(2) = 100;
            xmed(2) = 0;
            cue2_discr_time{unit} = 100;
   end
       
   if cue1_discr_time{unit} < 100 & cue2_discr_time{unit} >= 100
      delta.firstdiscrtime{unit} = cue1_discr_time{unit};
      delta.firstdiscrdelta{unit} = observed_difference{unit}(disc_ind(1));
      delta.maxdiscrdelta{unit} = pos_disc;
      delta.maxdiscrtime{unit} = cue1_discr_time{unit};
   elseif cue1_discr_time{unit} >= 100 & cue2_discr_time{unit} < 100
      delta.firstdiscrtime{unit} = cue2_discr_time{unit};
      delta.firstdiscrdelta{unit} = observed_difference{unit}(disc_ind(2));
      delta.maxdiscrdelta{unit} = neg_disc;
      delta.maxdiscrtime{unit} = cue2_discr_time{unit};
   elseif cue1_discr_time{unit} < 100 & cue2_discr_time{unit} < 100
      discr_times = [cue1_discr_time{unit} cue2_discr_time{unit}];
      [delta.firstdiscrtime{unit},index] = min(discr_times);
      delta.firstdiscrdelta{unit} = observed_difference{unit}(disc_ind(index));
      [~,index] = max([abs(pos_disc) abs(neg_disc)]);
      maxdiscrmeans = [pos_disc neg_disc];
      delta.maxdiscrdelta{unit} = maxdiscrmeans(index);
      delta.maxdiscrtime{unit} = xmed(index);
   end
       
       
   if delta.firstdiscrdelta{unit} > 0
      unit_firstdiscrimination{unit} = 1;
   elseif delta.firstdiscrdelta{unit} < 0;
      unit_firstdiscrimination{unit} = -1;
   end
    
   if delta.maxdiscrdelta{unit} > 0
      unit_maxdiscrimination{unit} = 1;
   elseif delta.maxdiscrdelta{unit} < 0
      unit_maxdiscrimination{unit} = -1;
   end
    
end
end
        
    
