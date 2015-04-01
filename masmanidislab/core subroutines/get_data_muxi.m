
            if trial<10;   %adds '0' to file name is trial<10.
            trialstring=['0' num2str(trial)];
            else trialstring=num2str(trial);
            end

            testdatafile=[rawpath filename '_t' trialstring '.mux1'  ];
            if exist(testdatafile,'file')==0
            testdatafile=[rawpath filename '_t' trialstring '.mux2'  ];
            end  
            if exist(testdatafile,'file')==0   %if this trial doesn't exist...
                if trial==1   %...if this is the first trial, something's wrong.
                ['error loading data files. check file name and directory.']
                break
                else   %...othersise it just ran out of trials to analyze.
                ['finished analyzing last trial in data set (' num2str(trial-1) ').']
                break     
                end
            end
            
            
    datafilename=[rawpath filename '_t' trialstring];  
 
            usechannels=channelsperset{currentset};       %channels in the current set.
            usechannels=intersect(usechannels, allusechannels);
            usechannels=setdiff(usechannels, badchannels);
            dochannels=usechannels;       
            shaftinuse=unique(s.shaft(dochannels));   %finds the shaft containing these channels; should only be single shaft.
            channelsonshaft=find(s.shaft==shaftinuse);    %finds all the channels on that shaft.
            backgroundchans=origbackgroundchans; 
            backgroundchans=intersect(backgroundchans,channelsonshaft);  
            backgroundchans=setdiff(backgroundchans,dochannels);  %background channels will only include other channels on the same shaft, because I found that's the best way of eliminating background.
            backgroundchans=setdiff(backgroundchans,badchannels);  
            muxibackgndfiles=unique(ceil(backgroundchans/32));   %specifies which dot muxi files to open for backgnd subtraction.       
            
            if length(backgroundchans)>0;  %Calculate average signal for background removal.
            backgndsignal_muxi    %calculated only once per channel set per trial.
            clear data     
            else
            backgnddata=0;
            end
            
            doclusters=find(setperunit==currentset);
            numberofclusters=length(doclusters);
    
        %loads all channels in use in datadochannels, with background subtraction.
        muxifiles=unique(ceil(usechannels/32));  %specifies which dot muxi files to open for plotting, e.g. mux1 and mux2 for chs 1-64.   
        datadochannels=[]; stimesdochannels=[];
        for muxind=1:length(muxifiles);      
            muxi=muxifiles(muxind);     
            datafile=[datafilename '.mux' num2str(muxi)];   

            fid = fopen(datafile,'r','b');
            data = fread(fid,[1,inf],'int16');    
            fclose(fid);
            data=data/2^20;  %divide by multiplication factor used in Labview DAQ system.

            muxichans=usechannels(find(usechannels<(32*muxi+1) & usechannels>32*(muxi-1)))-32*(muxi-1);  %selects only channels in the active muxi file.

                for chanind=1:length(muxichans);
                channel=muxichans(chanind);
                absolutechan=muxichans(chanind)+(muxi-1)*32;
                
                muxi_numbering
              
                datach=datach-backgnddata-mean(datach);  %subtracts the background channel if backgroundchans were specified.
                remove_laserartifacts  %optional: removes mean laser artifact found in get_laserartifacts.
     
                dofilter_muxi

                datach=1e6*datach;  %convert to microvolts.
                                      
                    if iterations>=1 & length(datach)>trialduration;
                    trialduration=length(datach);
                    end
        
                    if iterations>1 & length(datach)<trialduration;
                    lasttrial=trial;
                    lasttrialduration=length(datach);
                    end
        
                    if trial==max(dotrials)
                    lasttrial=trial;
                    lasttrialduration=length(datach);
                    end
        
                    
                    % stdsignal=std(datach);
                    stdsignal=prctile(datach,noiseprctile);   %calculates nth percentile.  This value is less sensitive to presence of lots of spikes               
                    if spikedetectionmethod==1
                    detectthreshold=minamplitude;  %round(detectstdev*stdsignal)  %detection threshold voltage.
                    elseif spikedetectionmethod==2
                    detectthreshold=round(run_detectstdev*stdsignal);  %detection threshold voltage.
                    end
             
                    findpeaktimes_muxi   %finds peak times on one channel.       
                    stimesdochannels=[stimesdochannels spiketimes];   %adds all spiketimes from dochannels into one vector; the same unit may be counted multiple times.

      
                datadochannels{absolutechan}=datach; 
                noisedochannels{absolutechan}=prctile(datach,run_noiseprctile);
                currenttrialduration=length(datach);
                clear datach;
                
                end
                
        end
        clear data
        clear backgnddata
        
      
    
    