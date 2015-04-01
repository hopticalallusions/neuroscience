prune_templates   %Not yet perfect.  Better to plot spikes and show examples of what would be merged, and ask user whether to mege.
                  %upsamples & aligns templates, removes likely duplicates in the same set. stores as sortspikes_mergedi.mat

plot_putative     %if plottemplates=='y', saves plots of all possible templates in \templates_jpeg\.  Manually delete the clusters that appear to be
                  %overlapping units. prune_templates will check for duplicates.

disp(['make_orig_templates'])

load([seedtempdir 'maybetemplates.mat'])

selecttemplates=[1:length(maybetemplates.meanspikes)];   

if length(selecttemplates)>0

origtemplates=[]; usechannels=[];
  
    for i=1:length(selecttemplates);
    tempi=selecttemplates(i);
        
    newrightpoints=40;    %reverted back to  default (=60) setting on Nov 9 2011.
    newleftpoints=40;
    
    origtemplates.meanspikes{i}=maybetemplates.meanspikes{tempi};
    origtemplates.chanswithspikes{i}=maybetemplates.chanswithspikes{tempi};  
    origtemplates.bestchannel{i}=maybetemplates.bestchannel{tempi};
    origtemplates.dochannels{i}=maybetemplates.channels{tempi};
    origtemplates.lengthperchan{i}=maybetemplates.lengthperchan{tempi};
    origtemplates.channelsetindex{i}=maybetemplates.channelsetindex{tempi};
    origtemplates.shaft{i}=s.shaft(maybetemplates.bestchannel{tempi});
    origtemplates.newleftpoints{i}=newleftpoints;
    origtemplates.newrightpoints{i}=newrightpoints;
    
    usechannels=[usechannels maybetemplates.chanswithspikes{tempi}];
    
    end
           
elseif length(selecttemplates)==0    %no templates in data set; cannot do template matching.
  disp(['no templates'])
end

usechannels=unique(usechannels);

origtemplates.usechannels=usechannels;
origtemplates.minamplitude=maybetemplates.minamplitude;
origtemplates.dosets=newsetlist;

save([seedtempdir 'origtemplates.mat'],'origtemplates', '-mat')

disp([num2str(length(selecttemplates)) ' original templates on a total of ' num2str(length(newsetlist)) ' sets.'])
