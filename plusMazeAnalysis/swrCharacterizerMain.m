% disk='/Volumes/AHOWETHESIS/';
% disk = '/Volumes/AGHTHESIS2/rats/';

disk = '/media/blairlab/ThetaSeagate/andrew/';
outputPath = [ disk '/summaryData/' ];
rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
%swrFiles={ 'SWR84.ncs', 'CSC87.ncs', 'CSC56.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
swrFiles={ 'SWR20.ncs', 'CSC36.ncs', 'CSC54.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };

swrLookup = containers.Map(rats,swrFiles);


gcf(1)=figure(1);
fig = gcf(1);
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 16 9];

ratNames = dir( disk );
for ratIdx=5:7  % 3:length(ratNames)
    recordingDates = dir( [disk '/' ratNames(ratIdx).name '/' ]);
    for dateIdx=3:length(recordingDates)
        if   ~strcmp('summaryData',ratNames(ratIdx).name) && strcmp( ratNames(ratIdx).name, 'h7') 
            path= [disk '/' ratNames(ratIdx).name '/' recordingDates(dateIdx).name '/'];
            disp(path);
            clf(gcf(1));
            try
                swrCharacterizer( path, ratNames(ratIdx).name, recordingDates(dateIdx).name, swrLookup(ratNames(ratIdx).name), outputPath );
            catch err
                disp(path);
                disp(err.identifier);
                warning(err.message);
            end
        end
    end
end

return;


disk = '/media/blairlab/ThetaSeagate/andrew/';
outputPath = [ disk '/summaryData/' ];

rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
swrFiles={ 'SWR20.ncs', 'CSC36.ncs', 'CSC54.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
swrLookup = containers.Map(rats,swrFiles);


gcf(1)=figure(1);
fig = gcf(1);
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 16 9];                                                                        

ratNames = dir( disk );
for ratIdx=5:7  % 3:length(ratNames)
    recordingDates = dir( [disk '/' ratNames(ratIdx).name '/' ]);
    for dateIdx=3:length(recordingDates)
        if   ~strcmp('summaryData',ratNames(ratIdx).name) % && strcmp( ratNames(ratIdx).name, 'h5') &&
            path= [disk '/' ratNames(ratIdx).name '/' recordingDates(dateIdx).name '/'];
            disp(path);
            clf(gcf(1));
            try
                swrCharacterizer( path, ratNames(ratIdx).name, recordingDates(dateIdx).name, swrLookup(ratNames(ratIdx).name), outputPath );
            catch err
                disp(path);
                disp(err.identifier);
                warning(err.message);
            end
        end
    end
end



return;


disk = '/media/blairlab/ThetaSeagate/andrew/';
outputPath = [ disk '/summaryData/' ];

rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
swrFiles={ 'SWR84.ncs', 'CSC87.ncs', 'CSC56.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
swrLookup = containers.Map(rats,swrFiles);


gcf(1)=figure(1);
fig = gcf(1);
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 16 9];                                                                        

ratNames = dir( disk );
for ratIdx=3:length(ratNames)
    recordingDates = dir( [disk '/' ratNames(ratIdx).name '/' ]);
    for dateIdx=3:length(recordingDates)
        if  strcmp( ratNames(ratIdx).name, 'h5') && ~strcmp('summaryData',ratNames(ratIdx).name)
            path= [disk '/' ratNames(ratIdx).name '/' recordingDates(dateIdx).name '/'];
            disp(path);
            clf(gcf(1));
            try
                swrCharacterizer( path, ratNames(ratIdx).name, recordingDates(dateIdx).name, swrLookup(ratNames(ratIdx).name), outputPath );
            catch err
                disp(path);
                disp(err.identifier);
                warning(err.message);
            end
        end
    end
end











%% do the rest of the rats

for ratIdx=3:length(ratNames)
    recordingDates = dir( [disk '/' ratNames(ratIdx).name '/' ]);
    for dateIdx=3:length(recordingDates)
        if  (~strcmp( ratNames(ratIdx).name, 'h5') ) && (~strcmp( ratNames(ratIdx).name, 'h1') )
            path= [disk '/' ratNames(ratIdx).name '/' recordingDates(dateIdx).name '/'];
            disp(path);
            clf(gcf(1));
            try
                swrCharacterizer( path, ratNames(ratIdx).name, recordingDates(dateIdx).name, swrLookup(ratNames(ratIdx).name), outputPath );
            catch err
                disp(path);
                disp(err.identifier);
                warning(err.message);
            end
        end
    end
end




% 23M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-27a/SWR84.ncs
% 94M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-09/SWR84.ncs
% 97M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-10/SWR84.ncs
% 264M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-22/SWR84.ncs
% 266M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-17/SWR84.ncs
% 272M	/media/blairlab/ThetaSeagate/andrew/h1/2018-09-08/SWR84.ncs
% 298M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-15/SWR84.ncs
% 313M	/media/blairlab/ThetaSeagate/andrew/h1/2018-09-09/SWR84.ncs
% 324M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-30/SWR84.ncs
% 352M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-14/SWR84.ncs
% 357M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-28/SWR84.ncs
% 358M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-23/SWR84.ncs
% 362M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-13/SWR84.ncs
% 365M	/media/blairlab/ThetaSeagate/andrew/h1/2018-09-04/SWR84.ncs
% 368M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-27b/SWR84.ncs
% 395M	/media/blairlab/ThetaSeagate/andrew/h1/2018-09-07/SWR84.ncs
% 404M	/media/blairlab/ThetaSeagate/andrew/h1/2018-09-05/SWR84.ncs
% 438M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-31/SWR84.ncs
% 474M	/media/blairlab/ThetaSeagate/andrew/h1/2018-09-06/SWR84.ncs
% 496M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-29/SWR84.ncs
% 501M	/media/blairlab/ThetaSeagate/andrew/h1/2018-08-24/SWR84.ncs





% 
% 
% 
% 
% 
% 
% disk = '/media/blairlab/ThetaSeagate/andrew/';
% rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
% swrFiles={ 'SWR84.ncs', 'CSC76.ncs', 'CSC56.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
% swrLookup = containers.Map(rats,swrFiles);
% figureOutputPath = [ disk '/summaryData/' ];
% ratNames=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  }; ratIdx=1;
% % no figs produced   '2018-08-27a'
% % crashed  '2018-09-06'  '2018-08-24' '2018-09-05' 
% % out of memory   '2018-08-29'
% % tt problem '2018-08-27b'
% % missing SWR file :  '2018-09-08'
% % worked after lfp size fix '2018-08-24' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-23' 
% %recordingDates = {    '2018-09-09' '2018-08-17' '2018-08-14' '2018-08-28' '2018-08-23' '2018-08-13' '2018-09-04' '2018-09-07' '2018-08-31' };
% recordingDates = {  '2018-09-07'   '2018-09-06' };
% dateIdx = 1;
% path= [disk '/' ratNames{ratIdx} '/' recordingDates{dateIdx} '/'];
% for dateIdx=1:length(recordingDates)
%     path= [disk '/' ratNames{ratIdx} '/' recordingDates{dateIdx} '/'];
%     cellSwrXcorrMassive( path, ratNames{ratIdx}, recordingDates{dateIdx}, swrLookup(ratNames{ratIdx}), figureOutputPath );
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% disk = '/media/blairlab/ThetaSeagate/andrew/';
% rats=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  };
% swrFiles={ 'SWR84.ncs', 'CSC76.ncs', 'CSC56.ncs', 'CSC6.ncs', 'CSC88.ncs', 'CSC6.ncs' };
% swrLookup = containers.Map(rats,swrFiles);
% figureOutputPath = [ disk '/summaryData/' ];
% ratNames=    { 'h1'       , 'h5'       , 'h7'       , 'da5'     , 'da10'     , 'old_da5'  }; ratIdx=1;
% recordingDates = { '2018-07-11' '2018-07-30' '2018-08-01a' '2018-08-01b' '2018-08-02' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22' '2018-08-27' '2018-08-28' '2018-08-31' '2018-09-03' '2018-09-04' '2018-09-05'};
% ratIdx=3;
% dateIdx = 1;
% path= [disk '/' ratNames{ratIdx} '/' recordingDates{dateIdx} '/'];
% for dateIdx=1:length(recordingDates)
%     try
%         path= [disk '/' ratNames{ratIdx} '/' recordingDates{dateIdx} '/'];
%         cellSwrXcorrMassive( path, ratNames{ratIdx}, recordingDates{dateIdx}, swrLookup(ratNames{ratIdx}), figureOutputPath );
%     catch err
%                 disp(path);
%                 disp(err.identifier);
%                 warning(err.message);
%     end
% end
% 
