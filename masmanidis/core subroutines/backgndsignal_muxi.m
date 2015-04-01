%background subtraction.
    backgnddata=[];
    for j=1:length(muxibackgndfiles);
        backgndmuxi=muxibackgndfiles(j);
        backgnddatafile=[datafilename '.mux' num2str(backgndmuxi)];   
        
        fid = fopen(backgnddatafile,'r','b');
        bkdata = fread(fid,[1,inf],'int16');    
        fclose(fid);
        bkdata=bkdata/2^20;  %divide by multiplication factor used in Labview DAQ system.

        backgndmuxichans=backgroundchans(find(backgroundchans<(32*backgndmuxi+1) & backgroundchans>32*(backgndmuxi-1)))-32*(backgndmuxi-1);
  
    for backgndchanind=1:length(backgndmuxichans);
    channel=backgndmuxichans(backgndchanind);
    
        bkdatach=bkdata(channel:32:length(bkdata));  %demultiplexing. 
      
        bkdatach=bkdatach-mean(bkdatach);  %removes dc offset that is produced from RHA2164.
        remove_bkgrndlaserartifacts  %optional: removes mean laser artifact found in get_laserartifacts. introduced Jan 20 2013.
        if length(backgnddata)~=0 
        backgnddata=[backgnddata+bkdatach];
        else backgnddata=bkdatach;
        end
    end
    end
    backgnddata=backgnddata/length(backgroundchans);