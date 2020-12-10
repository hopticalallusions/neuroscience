disk='/Volumes/AHOWETHESIS/';
disk = '/Volumes/AGHTHESIS2/rats/';

rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
swrFiles={ 'SWR84.ncs', 'CSC76.ncs', 'CSC56.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
swrLookup = containers.Map(rats,swrFiles);

ratNames = dir( disk );
for ratIdx=3:length(ratNames)
    recordingDates = dir( [disk '/' ratNames(ratIdx).name '/' ]);
    for dateIdx=3:length(recordingDates)
        path= [disk '/' ratNames(ratIdx).name '/' recordingDates(dateIdx).name '/'];
        disp(path);
       % try
            cellSwrXcorrMassive( path, ratNames(ratIdx).name, recordingDates(dateIdx).name, swrLookup(ratNames(ratIdx).name) );
        %catch err
        %    disp(path);
        %    disp(err.identifier);
        %    warning(err.message);
        %end
    end
end