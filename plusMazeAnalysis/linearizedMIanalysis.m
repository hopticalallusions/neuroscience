rat = { 'h5' 'h7' }; %{ 'da5' 'da10' 'h5' 'h7' 'h1' };
% folders/dates
folders.da5   = { '2016-08-22' '2016-08-23' '2016-08-24' '2016-08-25' '2016-08-26' '2016-08-27' '2016-08-28' '2016-08-29' '2016-08-30' '2016-08-31' '2016-09-01' '2016-09-02' '2016-09-06' '2016-09-07' '2016-09-08' };
folders.da10  = { '2017-09-11' '2017-09-11b' '2017-09-12' '2017-09-13' '2017-09-14' '2017-09-15' '2017-09-18' '2017-09-19' '2017-09-20' '2017-09-20b' '2017-09-22' '2017-09-25' };
folders.h5    = { '2018-04-25' '2018-04-27' '2018-05-01' '2018-05-02' '2018-05-03' '2018-05-07' '2018-05-08' '2018-05-09' '2018-05-11' '2018-05-14' '2018-05-15' '2018-05-16' '2018-05-18' '2018-06-08' '2018-06-11' '2018-06-12' '2018-06-13' '2018-06-14' '2018-06-15'  };
folders.h7    = { '2018-07-05' '2018-07-06' '2018-07-11' '2018-07-12' '2018-07-13' '2018-07-16' '2018-07-18' '2018-07-19' '2018-07-20' '2018-07-23' '2018-07-24' '2018-07-25' '2018-07-26' '2018-07-27' '2018-07-30'  '2018-08-01a' '2018-08-01b' '2018-08-01c' '2018-08-02' '2018-08-03a' '2018-08-03b' '2018-08-06' '2018-08-07' '2018-08-08' '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-22'  '2018-09-04' '2018-09-05' '2018-08-31' };
folders.h1    = { '2018-08-09' '2018-08-10' '2018-08-13' '2018-08-14' '2018-08-15' '2018-08-17' '2018-08-22' '2018-08-23' '2018-08-24' '2018-08-27a' '2018-08-27b' '2018-08-28' '2018-08-29' '2018-08-30' '2018-08-31' '2018-09-04' '2018-09-05' '2018-09-06' '2018-09-08' '2018-09-09' '2018-09-14' };
% theta channels
thetaLfpNames.da5  = { 'CSC12.ncs' 'CSC46.ncs' };
thetaLfpNames.da10 = { 'CSC52.ncs' 'CSC56.ncs' };
thetaLfpNames.h5   = { 'CSC76.ncs' 'CSC44.ncs' 'CSC64.ncs'};
thetaLfpNames.h7   = { 'CSC64.ncs' 'CSC84.ncs' };
thetaLfpNames.h1   = { 'CSC20.ncs' 'CSC32.ncs' };
% SWR channels to use
swrLfpNames.da5  = { 'CSC6.ncs'  'CSC26.ncs' 'CSC28.ncs'  };
swrLfpNames.da10 = { 'CSC81.ncs' 'CSC61.ncs' 'CSC32.ncs' };
swrLfpNames.h5   = { 'CSC36.ncs' 'CSC87.ncs' };
swrLfpNames.h7   = { 'CSC44.ncs' 'CSC56.ncs' 'CSC54.ncs' }; 
swrLfpNames.h1   = { 'CSC84.ncs' 'CSC20.ncs' 'CSC17.ncs'  'CSC32.ncs'  'CSC64.ncs' };  % first two are the favorites

circColor = buildCircularGradient;
buildTtPositionDatabase;

thisTheta = 1; % 1:length(thetaLfpNames.(rat{ratIdx}))
thisSwr = 1; 

subplotCheatTable= [ 1,1; 1,2; 2,2; 2,2; 2,3; 2,3; 2,4; 2,4; 3,4; 3,4; 3,4; 3,4; 4,4; 4,4; 4,4; 4,4; 4,5; 4,5; 4,5; 4,5; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6; 7,6; 7,6; 7,6; 7,6; 7,6; 7,6 ];

basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';


speedThreshold = 3;
rejectedTrials = 0;
buildTrialSwitch = true;



fileID = fopen([ basePathOutput 'info_db_linearized_space_v2019-July-24.csv'],'w');

%make header
%message = [ 'rat,' 'folder,' 'TT,' 'unit,' 'region,maxJointMI,maxJointMIidx,minJointMI,minJointMIidx,maxSpikeInfo,maxSpikeInfoidx,minSpikeInfo,minSpikeInfoidx,maxphaseResultants,maxphaseResultantsidx,minphaseResultants,minphaseResultantsidx,totSpikes' ];
%fprintf( fileID, '%s\n' , message);
message = [ 'rat,date,tt,unit,region,trajectory,phaseMIjoint,phaseMIcondBitsPerCm,skaggsInfo,phaseResultant,circCorrRho,circCorrPva,totSpikes,fullSpatialBins,pctFiringArea,circLinPhasePrecSlope,circLinPhasePrecPhaseOffset,circLinCorrCoef,circLinPhasePrecPval,rayleighPvalTraj,rayleighZTraj' ];
fprintf( fileID, '%s\n' , message);



for ratIdx =  1:length( rat )
    for ffIdx =  1:length( folders.( rat{ratIdx} ) )  % 1:length( folders.(rat{ratIdx}) )            
        for ttNum = 1:32
            for cellId = 1:33
                if exist( [ basePathData 'angularCellData_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' num2str(ttNum) '_cell' num2str(cellId) '.mat'], 'file' )
                    load( [ basePathData 'angularCellData_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' num2str(ttNum) '_cell' num2str(cellId) '.mat'] );
                    
                     try

                        listOfTrajectories = { 'ne' 'en' 'se' 'es' 'sw' 'ws' 'nw' 'wn' 'xx' 'all' };
                        listOfObservedTrajectories = {};
                        % use spike data here, not position because the rat
                        % is in more positions than there are spikes. It is
                        % possible for no cells to ever spike despite the
                        % existence of valid trajectories.
                        for ii= 1:9
                            if ~isempty(angularCellData.phases.(listOfTrajectories{ii}))
                                listOfObservedTrajectories = [ listOfObservedTrajectories listOfTrajectories{ii} ];
                            end
                        end
                        %
                        %
                        % 
                        if ~isempty(listOfObservedTrajectories)
                            % 
                            angularCellData.circCorrPval.all = [];
                            angularCellData.circCorrRho.all  = [];
                            angularCellData.phases.all       = [];
                            angularCellData.pos.all          = [];
                            angularCellData.posIdx.all       = [];
                            angularCellData.spikeIdxs.all    = [];
                            angularCellData.spikePos.all     = [];
%                            angularCellData.trialList.all    = [];
                            angularCellData.turnDir.all      = [];
                            %
                            for ii=1:length(listOfObservedTrajectories)
                                angularCellData.phases.all     = [ angularCellData.phases.all     angularCellData.phases.(listOfObservedTrajectories{ii})    ];
                                angularCellData.pos.all        = [ angularCellData.pos.all        angularCellData.pos.(listOfObservedTrajectories{ii})       ];
                                angularCellData.posIdx.all     = [ angularCellData.posIdx.all     angularCellData.posIdx.(listOfObservedTrajectories{ii})    ];
                                angularCellData.spikeIdxs.all  = [ angularCellData.spikeIdxs.all  angularCellData.spikeIdxs.(listOfObservedTrajectories{ii}) ];
                                angularCellData.spikePos.all   = [ angularCellData.spikePos.all   angularCellData.spikePos.(listOfObservedTrajectories{ii})  ];
%                                angularCellData.trialList.all  = [ angularCellData.trialList.all  angularCellData.trialList.(listOfObservedTrajectories{ii}) ];
                                angularCellData.turnDir.all    = [ angularCellData.turnDir.all    angularCellData.turnDir.(listOfObservedTrajectories{ii})   ];    
                            end
                            [angularCellData.circCorrRho.all,angularCellData.circCorrPval.all] = circ_corrcl( deg2rad(angularCellData.phases.all), angularCellData.spikePos.all );

                            listOfObservedTrajectories = [ listOfObservedTrajectories 'all' ];

                            %% PROCESS ALL OBSERVED TRAJECTORIES
                            %
                            %                    
                            for ii=1:length(listOfObservedTrajectories)

                                spatialBinSize = 16; % 10; % (degrees)  10 might work better
                                minimumSpatialSampling = 3; % .5 % seconds.    this value will depend on bin size and session length.

                                freqXY = histcounts( angularCellData.pos.(listOfObservedTrajectories{ii}) , 0:spatialBinSize:200);
                                %disp([ 'removed ' num2str(nansum(nansum(  (freqXY< round(minimumSpatialSampling*29.97) & (freqXY>0) )))) ' ('  num2str( round(100*nansum(nansum(  (freqXY< round(minimumSpatialSampling*29.97) & (freqXY>0) )))/nansum(nansum( (freqXY>0) )) ))  '%)  spatial bins due to low sampling' ]);
                                freqXY(freqXY< round(minimumSpatialSampling*29.97) ) = NaN;
                                probOccupyXY = freqXY./nansum(freqXY(:));  % probability of being in place

                                cellXYHist = histcounts(angularCellData.spikePos.(listOfObservedTrajectories{ii}), 0:spatialBinSize:200);
                                %cellXYHist(cellXYHist==0)=NaN;
                                avgFiring=nansum(cellXYHist(:))/(nansum((freqXY(:)))/29.97);

                                %% measure spike information content    Skagg's formulation
                                %
                                rateMap = cellXYHist./(freqXY./29.97); % spike rate
                                %rateMap(isnan(rateMap)) = 0;
                                [ angularCellData.spikePlaceInfoPerSpike.(listOfObservedTrajectories{ii}), angularCellData.spikePlaceInfoPerSecond.(listOfObservedTrajectories{ii}), angularCellData.angularCellData.spikePlaceSparsity.(listOfObservedTrajectories{ii}), angularCellData.spatialFiringRateCoherence.(listOfObservedTrajectories{ii}), angularCellData.skaggsRatio.(listOfObservedTrajectories{ii}), angularCellData.spikePlaceInfoArray.(listOfObservedTrajectories{ii}) ] = skaggsSpatialInfo( probOccupyXY, rateMap, avgFiring );


                                %% how much area does firing cover?
                                % normalized for what the rat visited, of course
                                %
                                % only count bins that have a firing rate higher than 1 Hz
                                angularCellData.firingAreaProportion.(listOfObservedTrajectories{ii}) = (nansum(nansum(rateMap>1))/nansum(nansum(freqXY>0)));


                                %% resultant
                                angularCellData.phaseResultants.(listOfObservedTrajectories{ii})=circ_r(deg2rad(angularCellData.phases.(listOfObservedTrajectories{ii}))');


                                %% calculate phase Mutual Information
                                %
                                phaseBinSize = 36;  % degrees
                                freqPhase = histcounts( angularCellData.phases.(listOfObservedTrajectories{ii}) , 0:phaseBinSize:360);
                                probPhase = freqPhase./nansum(freqPhase(:));

                                freqPhasePosition = zeros( length(probOccupyXY)+1, length(probPhase)+1 );

                                thePhases    = angularCellData.phases.(listOfObservedTrajectories{ii});
                                thePositions = angularCellData.spikePos.(listOfObservedTrajectories{ii});

                                thePositions(thePositions>200) = 0; % protects against wrap around errors

                                for jj=1:length(thePhases)
                                    cc = floor( thePhases(jj)/phaseBinSize) + 1;
                                    rr = floor( thePositions(jj)/spatialBinSize) + 1;
                                    freqPhasePosition(rr,cc) = freqPhasePosition(rr,cc) + 1;
                                end
                                freqPhasePosition(freqPhasePosition==0) = NaN;
                                probPhasePosition = freqPhasePosition./nansum(freqPhasePosition(:));

                                phaseMImat = zeros(size(probPhasePosition));
                                condMImat = zeros(size(probPhasePosition));
                                expectationViolation = zeros(size(probPhasePosition));

                                for rr=1:length(probOccupyXY)
                                    for cc=1:length(probPhase)
                                            % division by zero causes problems, so we will exclude
                                            % these (MI cannot be infinite)
                                            % 
                                            % negative information values ARE NOT
                                            % IGNORED. see comments in function miThreeD.m
                                            if ( probOccupyXY(rr) * probPhase(cc) ) > 0
                                                expectationViolation(rr,cc) = log2( probPhasePosition(rr,cc) / ( probOccupyXY(rr) * probPhase(cc) ) );
                                                phaseMImat(rr,cc) = probPhasePosition(rr,cc) * expectationViolation(rr,cc);
                                                condMImat(rr,cc) = phaseMImat(rr,cc) / probOccupyXY(rr);
                                            end
                                    end
                                end

                                angularCellData.jointMI.(listOfObservedTrajectories{ii}) = nansum(phaseMImat(:));
                                angularCellData.condMI.(listOfObservedTrajectories{ii}) = nansum(condMImat(:));

                                [ circLinPhasePrecSlope, circLinPhasePrecPhaseOffsetBuz, circLinCorrCoefBuz, circLinPhasePrecPval ]= phasePositionCorr( deg2rad(thePhases), thePositions );
                                
                                
                                [ rayleighPvalTraj, rayleighZTraj ]=circ_rtest( deg2rad(thePhases) );

                                
                                %% output database information
                                %
                                % rat, date, tt, unit, region, trajectory
                                tempstr = [ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str(ttNum) ',' num2str(cellId) ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ',' (listOfObservedTrajectories{ii}) ',' ] ;
                                % phaseMIjoint
                                tempstr = [ tempstr num2str( angularCellData.jointMI.(listOfObservedTrajectories{ii}) )                ',' ];
                                % phaseMIcondBitsPerCm
                                tempstr = [ tempstr num2str( angularCellData.condMI.(listOfObservedTrajectories{ii})/200 )             ',' ];
                                % skaggsInfo
                                tempstr = [ tempstr num2str( angularCellData.spikePlaceInfoPerSpike.(listOfObservedTrajectories{ii}) ) ',' ];
                                % phaseResultant
                                tempstr = [ tempstr num2str( angularCellData.phaseResultants.(listOfObservedTrajectories{ii}) )        ',' ];
                                % circCorrRho
                                tempstr = [ tempstr num2str( angularCellData.circCorrRho.(listOfObservedTrajectories{ii}) )            ',' ];
                                % circCorrPval
                                tempstr = [ tempstr num2str( angularCellData.circCorrPval.(listOfObservedTrajectories{ii}) )           ',' ];
                                % totSpikes
                                tempstr = [ tempstr num2str( length(angularCellData.phases.(listOfObservedTrajectories{ii})) )         ',' ];
                                % occupied bins.
                                tempstr = [ tempstr num2str( sum(freqXY>0) )                                                           ',' ];
                                % firing area %
                                tempstr = [ tempstr num2str( angularCellData.firingAreaProportion.(listOfObservedTrajectories{ii}) )   ',' ];
                                % Buzsaki style circular Linear Correlation
                                tempstr = [ tempstr num2str(circLinPhasePrecSlope) ',' num2str(circLinPhasePrecPhaseOffsetBuz) ',' num2str(circLinCorrCoefBuz) ',' num2str(circLinPhasePrecPval) ',' ];
                                % Rayleigh test :
                                tempstr = [ tempstr num2str(rayleighPvalTraj) ',' num2str(rayleighZTraj)  ];
                                fprintf( fileID, '%s\n' , tempstr);

                            end

    %                         tempstr=[ rat{ratIdx} ',' folders.(rat{ratIdx}){ffIdx} ',' int2str(ttNum) ',' num2str(cellId) ',' ttPosition.(rat{ratIdx}).(strcat('YYYYMMDD',(strrep(folders.(rat{ratIdx}){ffIdx},'-','')))){ttNum} ',' ] ;
    %                         [ val, idx ] = max(structfun(@(x)max(x),angularCellData.jointMI ));
    %                         tempstr = [ tempstr num2str(val) ',' listOfObservedTrajectories{idx} ',' ];
    %                         [ val, idx ] = min(structfun(@(x)min(x),angularCellData.jointMI ));
    %                         tempstr = [ tempstr num2str(val) ',' listOfObservedTrajectories{idx} ',' ];
    % 
    %                         [ val, idx ] = max(structfun(@(x)max(x),angularCellData.spikePlaceInfoPerSpike ));
    %                         tempstr = [ tempstr num2str(val) ',' listOfObservedTrajectories{idx} ',' ];
    %                         [ val, idx ] = min(structfun(@(x)min(x),angularCellData.spikePlaceInfoPerSpike ));
    %                         tempstr = [ tempstr num2str(val) ',' listOfObservedTrajectories{idx} ',' ];
    % 
    %                         [ val, idx ] = max(structfun(@(x)max(x),angularCellData.phaseResultants ));
    %                         tempstr = [ tempstr num2str(val) ',' listOfObservedTrajectories{idx} ',' ];
    %                         [ val, idx ] = min(structfun(@(x)min(x),angularCellData.phaseResultants ));
    %                         tempstr = [ tempstr num2str(val) ',' listOfObservedTrajectories{idx} ',' num2str(length(angularCellData.phases.all)) ];
    %                         fprintf( fileID, '%s\n' , tempstr);
                        end
                    
                    catch err
                        disp([ basePathData 'angularCellData_' rat{ratIdx} '_' folders.(rat{ratIdx}){ffIdx} '_TT' num2str(ttNum) '_cell' num2str(cellId) '.mat']);
                        disp(err.identifier);
                        warning(err.message);
                        return;
                    end
                end
            end
        end
    end
end

fclose(fileID);


return;

%%

clear all;
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-24.csv'], 'ReadVariableNames',true);
swrCorrTable=readtable([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-07-23.csv' ], 'ReadVariableNames',true);
cellInfoTable=readtable([basePathOutput 'tt_unit_info_metrics_v2019-July-23_LSonly.csv'], 'ReadVariableNames', true);
rayleighTable=readtable([basePathOutput 'tt_unit_rayleighTest_v2019-July-24_LSonly.csv'], 'ReadVariableNames', true);
tempTableA = innerjoin( linInfoTable, swrCorrTable, 'Keys', [ 1 2 3 4 5 ]);
tempTableB = innerjoin( tempTableA, cellInfoTable, 'Keys', [ 1 2 3 4 ]);
tempTable = innerjoin( tempTableB, rayleighTable, 'Keys', [ 1 2 3 4 ]);
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region_cellInfoTable ) | strcmp( 'LS_SFi', ds.region_cellInfoTable )  | strcmp( 'LS_V', ds.region_cellInfoTable ) )& ( ~strcmp(ds.trajectory,'all') ) ; % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);
% Phase coders
%             minimum spatial samping    & min spikes/trajectory &  min slope significance             &  full cycle in > 20 cm                                   & full cycle in < 6 meters (at least 120 deg of change)               
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>50 ) & ( dbLS.circLinPhasePrecPval<=0.01 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) < -0.2 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) > -6 ) & ( dbLS.rateOnMazeMoving > 1 )  ;  sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseCodersSWRZ = phaseCodersSWRZ(idx);

% Phase Lockers
% this makes a bunch of analysis.
thisRat  = dbLS.rat(1);
thisDate = dbLS.date(1);
thisTT   = dbLS.tt(1);
thisUnit = dbLS.unit(1);
idxsToFlip = [];
alwaysLocked = -1*ones(length(dbLS),1);
thisIsLocked = 1;
%
for ii=2:length(dbLS)
    if ~( strcmp( thisRat, dbLS.rat(ii) ) & ( strcmp( thisDate, dbLS.date(ii) ) )  & ( thisTT == dbLS.tt(ii) ) & ( thisUnit == dbLS.unit(ii) ) )
        alwaysLocked(idxsToFlip) = thisIsLocked;
        thisRat  = dbLS.rat(ii);
        thisDate = dbLS.date(ii);
        thisTT   = dbLS.tt(ii);
        thisUnit = dbLS.unit(ii);
        idxsToFlip = [];
        thisIsLocked = 1;
    end
    %thisIsLocked = thisIsLocked * ( dbLS.rayleighPvalOnMazeMoving(ii) < 0.05 );
    thisIsLocked = thisIsLocked * ( dbLS.rayleighPvalTraj(ii) < 0.01 );
    idxsToFlip = [ idxsToFlip ii ];
end
alwaysLocked(idxsToFlip) = thisIsLocked;
sum(alwaysLocked)
%
% this makes a bunch of analysis.
thisRat  = dbLS.rat(1);
thisDate = dbLS.date(1);
thisTT   = dbLS.tt(1);
thisUnit = dbLS.unit(1);
idxsToFlip = [];
neverPhaseCode = -1*ones(length(dbLS),1);
thisIsLocked = 1;
%
for ii=2:length(dbLS)
    if ~( strcmp( thisRat, dbLS.rat(ii) ) & ( strcmp( thisDate, dbLS.date(ii) ) )  & ( thisTT == dbLS.tt(ii) ) & ( thisUnit == dbLS.unit(ii) ) )
        neverPhaseCode(idxsToFlip) = thisIsLocked;
        thisRat  = dbLS.rat(ii);
        thisDate = dbLS.date(ii);
        thisTT   = dbLS.tt(ii);
        thisUnit = dbLS.unit(ii);
        idxsToFlip = [];
        thisIsLocked = 1;
    end
    thisIsLocked = thisIsLocked * ( dbLS.circLinPhasePrecPval(ii) > 0.05 );
    idxsToFlip = [ idxsToFlip ii ];
end
neverPhaseCode(idxsToFlip) = thisIsLocked;
sum(neverPhaseCode)



selectWhat = ( dbLS.rayleighPvalTraj<=0.01 ) & ( dbLS.totSpikes>50 ) & ( dbLS.circLinPhasePrecPval > 0.05 ) & alwaysLocked ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseLockersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseLockersSWRZ = phaseLockersSWRZ(idx);
figure; hold off; histogram(phaseCodersSWRZ, -2:20); hold on; histogram(phaseLockersSWRZ, -2:20)
[~,pp, ~, stats]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)
[pp,~, stats]=ranksum(phaseCodersSWRZ,phaseLockersSWRZ)
xlabel('SWR Ratio Score'); ylabel('frequency');



figure;
% LOCK
selectWhatLock = ( neverPhaseCode ) &  alwaysLocked & ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); sum(selectWhatLock)  %( dbLS.circLinPhasePrecPval > 0.25  ) 
scatter( dbLS.thetaIndex(selectWhatLock), dbLS.rateOnMazeMoving(selectWhatLock), 100, 'filled' ); alpha(.5); hold on;
% CODE
selectWhatCode = ( dbLS.circLinPhasePrecPval<=0.005 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) < -0.5 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) > -6 ) & ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ) ;  sum(selectWhatCode)
scatter( dbLS.thetaIndex(selectWhatCode), dbLS.rateOnMazeMoving(selectWhatCode), 100, 'filled' ); alpha(.5); hold on;
% "ALL"
selectWhatAll = ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); sum(selectWhatAll)
scatter( dbLS.thetaIndex(selectWhatAll), dbLS.rateOnMazeMoving(selectWhatAll), 15, 'k', 'filled' );
legend('lock','code','many')

intersect(find(selectWhatLock),find(selectWhatCode))
strcat( dbLS.rat(selectWhatLock), '_', dbLS.date(selectWhatLock), '_', num2str(dbLS.tt(selectWhatLock)), '_', num2str(dbLS.unit(selectWhatLock)) ))
strcat( dbLS.rat(selectWhatCode), '_', dbLS.date(selectWhatCode), '_', num2str(dbLS.tt(selectWhatCode)), '_', num2str(dbLS.unit(selectWhatCode)) ))

figure; 
histogram( dbLS.totSpikes(selectWhatAll), 0:50:5000); hold on;
histogram( dbLS.totSpikes(selectWhatLock), 0:50:5000); hold on;
histogram( dbLS.totSpikes(selectWhatCode), 0:50:5000); hold on;


figure; histogram( dbLS.circLinPhasePrecPval(selectWhatLock), 0:0.05:1); hold on;

figure; histogram( dbLS.rayleighPvalTraj(selectWhatLock)); hold on;


histogram( dbLS.totSpikes(selectWhatAll), 0:50:5000); hold on;
histogram( dbLS.totSpikes(selectWhatCode), 0:50:5000); hold on;




%% 2019-07-25
%
% Phase Lockers
% this makes a bunch of analysis.
thisRat  = dbLS.rat(1);
thisDate = dbLS.date(1);
thisTT   = dbLS.tt(1);
thisUnit = dbLS.unit(1);
idxsToFlip = [];
alwaysLocked = -1*ones(length(dbLS),1);
thisIsLocked = 1;
%
for ii=2:length(dbLS)
    if ~( strcmp( thisRat, dbLS.rat(ii) ) & ( strcmp( thisDate, dbLS.date(ii) ) )  & ( thisTT == dbLS.tt(ii) ) & ( thisUnit == dbLS.unit(ii) ) )
        alwaysLocked(idxsToFlip) = thisIsLocked;
        thisRat  = dbLS.rat(ii);
        thisDate = dbLS.date(ii);
        thisTT   = dbLS.tt(ii);
        thisUnit = dbLS.unit(ii);
        idxsToFlip = [];
        thisIsLocked = 1;
    end
    thisIsLocked = thisIsLocked * ( dbLS.rayleighPvalTraj(ii) < 0.01 );
    idxsToFlip = [ idxsToFlip ii ];
end
alwaysLocked(idxsToFlip) = thisIsLocked;
sum(alwaysLocked)
%
% this makes a bunch of analysis.
thisRat  = dbLS.rat(1);
thisDate = dbLS.date(1);
thisTT   = dbLS.tt(1);
thisUnit = dbLS.unit(1);
idxsToFlip = [];
neverPhaseCode = -1*ones(length(dbLS),1);
thisIsLocked = 1;
%
for ii=2:length(dbLS)
    if ~( strcmp( thisRat, dbLS.rat(ii) ) & ( strcmp( thisDate, dbLS.date(ii) ) )  & ( thisTT == dbLS.tt(ii) ) & ( thisUnit == dbLS.unit(ii) ) )
        neverPhaseCode(idxsToFlip) = thisIsLocked;
        thisRat  = dbLS.rat(ii);
        thisDate = dbLS.date(ii);
        thisTT   = dbLS.tt(ii);
        thisUnit = dbLS.unit(ii);
        idxsToFlip = [];
        thisIsLocked = 1;
    end
    thisIsLocked = thisIsLocked * ( dbLS.circLinPhasePrecPval(ii) > 0.05 );
    idxsToFlip = [ idxsToFlip ii ];
end
neverPhaseCode(idxsToFlip) = thisIsLocked;
sum(neverPhaseCode)

figure;
% LOCK
selectWhatLock = neverPhaseCode &  alwaysLocked & ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); sum(selectWhatLock)  %( dbLS.circLinPhasePrecPval > 0.25  ) 
subplot(1,2,1); scatter( dbLS.thetaIndex(selectWhatLock), dbLS.rateOnMazeMoving(selectWhatLock), 100, 'filled' ); alpha(.5); hold on;
length(unique(strcat( dbLS.rat(selectWhatLock), '_', dbLS.date(selectWhatLock), '_', num2str(dbLS.tt(selectWhatLock)), '_', num2str(dbLS.unit(selectWhatLock)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhatLock), '_', dbLS.date(selectWhatLock), '_', num2str(dbLS.tt(selectWhatLock)), '_', num2str(dbLS.unit(selectWhatLock)) ));
phaseLockersSWRZ = dbLS.medRatioCtr(selectWhatLock);
phaseLockersSWRZ = phaseLockersSWRZ(idx);
% CODE
selectWhatCode = ( dbLS.circLinPhasePrecPval<=0.005 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) < -0.5 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) > -6 ) & ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ) ;  sum(selectWhatCode)
subplot(1,2,1); scatter( dbLS.thetaIndex(selectWhatCode), dbLS.rateOnMazeMoving(selectWhatCode), 100, 'filled' ); alpha(.5); hold on;
length( unique(strcat( dbLS.rat(selectWhatCode), '_', dbLS.date(selectWhatCode), '_', num2str(dbLS.tt(selectWhatCode)), '_', num2str(dbLS.unit(selectWhatCode)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhatCode), '_', dbLS.date(selectWhatCode), '_', num2str(dbLS.tt(selectWhatCode)), '_', num2str(dbLS.unit(selectWhatCode)) ));
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhatCode);
phaseCodersSWRZ = phaseCodersSWRZ(idx);
% ALL
selectWhatAll = ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); sum(selectWhatAll)
subplot(1,2,1); scatter( dbLS.thetaIndex(selectWhatAll), dbLS.rateOnMazeMoving(selectWhatAll), 15, 'k', 'filled' );
legend('lock','code','many')
%
subplot(1,2,2); hold off; histogram(phaseLockersSWRZ, -3:12 ); hold on; histogram(phaseCodersSWRZ, -3:12 ); 
[~,pp, ~, stats]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)
[pp,~, stats]=ranksum(phaseCodersSWRZ,phaseLockersSWRZ)
xlabel('SWR Ratio Score'); ylabel('frequency');




%% 2019-07-26
clear all;
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-24.csv'], 'ReadVariableNames',true);
swrCorrTable=readtable([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-07-26.csv' ], 'ReadVariableNames',true);
cellInfoTable=readtable([basePathOutput 'tt_unit_info_metrics_v2019-July-23_LSonly.csv'], 'ReadVariableNames', true);
rayleighTable=readtable([basePathOutput 'tt_unit_rayleighTest_v2019-July-24_LSonly.csv'], 'ReadVariableNames', true);
tempTableA = innerjoin( linInfoTable, swrCorrTable, 'Keys', [ 1 2 3 4 5 ]);
tempTableB = innerjoin( tempTableA, cellInfoTable, 'Keys', [ 1 2 3 4 ]);
tempTable = innerjoin( tempTableB, rayleighTable, 'Keys', [ 1 2 3 4 ]);
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region_cellInfoTable ) | strcmp( 'LS_SFi', ds.region_cellInfoTable )  | strcmp( 'LS_V', ds.region_cellInfoTable ) )& ( ~strcmp(ds.trajectory,'all') ) ; % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);
selectSWR = ( dbLS.pvalSwrShuff < 0.01 ) & ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); 
prctile( unique(dbLS.medRatioCtr(selectSWR)),90)
selectReactiveSwr = ( dbLS.medRatioCtr >= unique(prctile( dbLS.medRatioCtr(selectSWR),90)) ) & ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); 
unique(strcat( dbLS.rat(selectReactiveSwr), '_', dbLS.date(selectReactiveSwr), '_', num2str(dbLS.tt(selectReactiveSwr)), '_', num2str(dbLS.unit(selectReactiveSwr)) ))

figure; histogram( swrCorrTable.medRatioCtr(selectSWR), -1:10 )


figure; scatter( log10(dbLS.pvalSwrShuff+0.0009), log10(abs( dbLS.medRatioCtr+0.0001)) )

sum(dbLS.pvalSwrShuff<0.01)/length(dbLS.pvalSwrShuff)









% TRAJECTORIES
figure; histogram((dbLS.phaseMIcondBitsPerCm(selectWhat))); title('phaseMIcondBitsPerCm');
figure; histogram(dbLS.skaggsInfo(selectWhat)); title('skaggsInfo');
figure; histogram(log10(dbLS.phaseResultant(selectWhat))); title('phaseResultant');
figure; histogram(log10(dbLS.circCorrRho(selectWhat))); title('circCorrRho');
figure; histogram(dbLS.circCorrPva(selectWhat)); title('circCorrPva');
figure; histogram(log10(dbLS.totSpikes(selectWhat))); title('totSpikes');
figure; histogram(log10(1./dbLS.pctFiringArea(selectWhat))); title('pctFiringArea');
figure; histogram((dbLS.circLinPhasePrecSlope(selectWhat))); title('circLinPhasePrecSlope');
figure; histogram(dbLS.circLinCorrCoef(selectWhat)); title('circLinCorrCoef');
figure; histogram(dbLS.circLinPhasePrecPval(selectWhat)); title('circLinPhasePrecPval');
figure; histogram(log10(dbLS.rayleighPvalTraj(selectWhat))); title('rayleighPvalTraj');
figure; histogram(log10(dbLS.rayleighZTraj(selectWhat))); title('rayleighZTraj');







selectWhat = ( dbLS.rateOnMazeMoving > 1 ) & ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>200 ); 
% RAYLEIGH TABLE MAZE BEHAVIOR (not trajectory based)
figure; histogram(log10(dbLS.rayleighPvalOnMazeMoving(selectWhat))); title('rayleighPvalOnMazeMoving');
figure; histogram(log10(dbLS.rayleighZOnMazeMoving(selectWhat))); title('rayleighZOnMazeMoving');
%
figure; histogram(log10(dbLS.totalOnMazeMoving(selectWhat))); title('totalOnMazeMoving');
figure; histogram(dbLS.thetaIndex(selectWhat)); title('thetaIndex');
figure; histogram(log10(dbLS.rateOverall(selectWhat))); title('rateOverall');
figure; histogram(log10(dbLS.rateOffMaze(selectWhat))); title('rateOffMaze');
figure; histogram(log10(dbLS.rateOnMazeMoving(selectWhat))); title('rateOnMazeMoving');
figure; histogram(log10(dbLS.phaseResultantOnMazeMoving(selectWhat))); title('phaseResultantOnMazeMoving');
figure; histogram(log10(dbLS.phaseResultantAllTrajectories(selectWhat))); title('phaseResultantAllTrajectories');
figure; histogram(log10(dbLS.spikePlaceInfoPerSecondOnMazeMoving(selectWhat))); title('spikePlaceInfoPerSecondOnMazeMoving');
figure; histogram(log10(dbLS.spikePlaceInfoPerSpikeOnMazeMoving(selectWhat))); title('spikePlaceInfoPerSpikeOnMazeMoving');
figure; histogram(log10(dbLS.spikePlaceSparsityOnMazeMoving(selectWhat))); title('spikePlaceSparsityOnMazeMoving');
figure; histogram(dbLS.spatialFiringRateCoherenceOnMazeMoving(selectWhat)); title('spatialFiringRateCoherenceOnMazeMoving');
figure; histogram(log10(dbLS.spatialFieldsOnMazeMoving(selectWhat))); title('spatialFieldsOnMazeMoving');
figure; histogram(log10(dbLS.firingAreaProportionOnMazeMoving(selectWhat))); title('firingAreaProportionOnMazeMoving');
figure; histogram(dbLS.phaseInfoJointOnMazeMoving(selectWhat)); title('phaseInfoJointOnMazeMoving');

figure; histogram(dbLS.spikeRateMIjointOnMazeMoving(selectWhat)); title('spikeRateMIJointOnMazeMoving');
figure; histogram(log10(dbLS.spikePlaceInfoPerSpikePvalAllTrajectory(selectWhat))); title('spikePlaceInfoPerSpikePvalAllTrajectory');
figure; histogram(log10(dbLS.spikePlaceInfoPerSecondPvalAllTrajectory(selectWhat))); title('spikePlaceInfoPerSecondPvalAllTrajectory');
figure; histogram(log10(dbLS.spikePlaceSparsityPvalAllTrajectory(selectWhat))); title('spikePlaceSparsityPvalAllTrajectory');
figure; histogram(dbLS.spatialFiringRateCoherencePvalAllTrajectory(selectWhat)); title('spatialFiringRateCoherencePvalAllTrajectory');




















%%









figure; histogram(phaseLockersSWRZ)









selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>50 ) & ( dbLS.circLinPhasePrecPval<=0.01 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) < -0.2 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) > -6 )  ;  sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseCodersSWRZ = phaseCodersSWRZ(idx);
figure;
phaseCodersThetaIdx = dbLS.thetaIndex(selectWhat);
phaseCodersThetaIdx = phaseCodersThetaIdx(idx);
phaseCodersRate = dbLS.rateOnMazeMoving(selectWhat);
phaseCodersRate = phaseCodersRate(idx);
scatter( phaseCodersThetaIdx, phaseCodersRate, 100, 'filled' ); alpha(.5); hold on;

scatter(dbLS.thetaIndex,dbLS.rateOnMazeMoving, 10, 'k', 'filled');

figure; scatter( phaseCodersThetaIdx, phaseCodersSWRZ )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.thetaIndex(favCell), dbLS.medRatioCtr(favCell), 'filled' )

figure; scatter( phaseCodersRate, phaseCodersSWRZ )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.rateOnMazeMoving(favCell), dbLS.medRatioCtr(favCell), 'filled' )




selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>50 ) & ( dbLS.circLinPhasePrecPval<=0.005 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) < -0.5 ) & (((1./(dbLS.circLinPhasePrecSlope/(2*pi)))/100) > -6 ) & ( dbLS.rateOnMazeMoving > 1 )  ;  sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseCodersSWRZ = phaseCodersSWRZ(idx);
figure;
phaseCodersThetaIdx = dbLS.thetaIndex(selectWhat);
phaseCodersThetaIdx = phaseCodersThetaIdx(idx);
phaseCodersRate = dbLS.rateOnMazeMoving(selectWhat);
phaseCodersRate = phaseCodersRate(idx);
scatter( phaseCodersThetaIdx, phaseCodersRate, 100, 'filled' ); alpha(.5); hold on;

scatter(dbLS.thetaIndex,dbLS.rateOnMazeMoving, 10, 'k', 'filled');

figure; scatter( phaseCodersThetaIdx, phaseCodersSWRZ )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.thetaIndex(favCell), dbLS.medRatioCtr(favCell), 'filled' )

figure; scatter( phaseCodersRate, phaseCodersSWRZ )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.rateOnMazeMoving(favCell), dbLS.medRatioCtr(favCell), 'filled' )


figure; scatter( dbLS.rateOnMazeMoving(selectWhat), dbLS.circLinPhasePrecPval(selectWhat) )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.rateOnMazeMoving(favCell), dbLS.circLinPhasePrecPval(favCell), 'filled' )

figure; scatter( dbLS.thetaIndex(selectWhat), dbLS.circLinPhasePrecPval(selectWhat) )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.thetaIndex(favCell), dbLS.circLinPhasePrecPval(favCell), 'filled' )

figure; scatter( dbLS.thetaIndex(selectWhat), ((1./(dbLS.circLinPhasePrecSlope(selectWhat)/(2*pi)))/100) )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.thetaIndex(favCell), ((1./(dbLS.circLinPhasePrecSlope(favCell)/(2*pi)))/100), 'filled' )

figure; scatter( dbLS.medRatioCtr(selectWhat), ((1./(dbLS.circLinPhasePrecSlope(selectWhat)/(2*pi)))/100) )
favCell = strcmp( '2018-07-27', dbLS.date ) & dbLS.tt==32 & dbLS.unit ==1 ;
hold on; scatter( dbLS.medRatioCtr(favCell), ((1./(dbLS.circLinPhasePrecSlope(favCell)/(2*pi)))/100), 'filled' )




( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant>0.4)




selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4); sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseCodersSWRZ = phaseCodersSWRZ(idx);
selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseLockersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseLockersSWRZ = phaseLockersSWRZ(idx);
%figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
figure; hold off; histogram(phaseCodersSWRZ, -2:20); hold on; histogram(phaseLockersSWRZ, -2:20)
[~,pp, ~, stats]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)
[pp,~, stats]=ranksum(phaseCodersSWRZ,phaseLockersSWRZ)
xlabel('SWR Ratio Score'); ylabel('frequency');


%% emailed this to Tad

clear all;
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-20.csv'], 'ReadVariableNames',true);
%linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-15b.csv'], 'ReadVariableNames',true);
%linPlotsTable=readtable([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'], 'ReadVariableNames',true);
swrCorrTable=readtable([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-07-23.csv' ], 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
cellInfoTable=readtable([basePathOutput 'tt_unit_info_metrics_v2019-July-23_LSonly.csv'], 'ReadVariableNames', true);
%tempTable = innerjoin( linPlotsTable, linInfoTable, 'Keys', [ 1 2 3 4 5 ]);
%tempTable = innerjoin( tempTable, swrCorrTable, 'Keys', [ 1 2 3 4 ]);
tempTableA = innerjoin( linInfoTable, swrCorrTable, 'Keys', [ 1 2 3 4 5 ]);
tempTable = innerjoin( tempTableA, cellInfoTable, 'Keys', [ 1 2 3 4 ]);
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region_cellInfoTable ) | strcmp( 'LS_SFi', ds.region_cellInfoTable )  | strcmp( 'LS_V', ds.region_cellInfoTable ) )& ( ~strcmp(ds.trajectory,'all') ) ; % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);

%selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) & (( dbLS.peakXcorrLagTime > -.05 ) &  ( dbLS.peakXcorrLagTime < 0.05 )) ; sum(selectWhat)
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
%phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseCodersSWRZ = phaseCodersSWRZ(idx);
selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
%phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);
phaseLockersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseLockersSWRZ = phaseLockersSWRZ(idx);
%figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
figure; hold off; histogram(phaseCodersSWRZ, -2:20); hold on; histogram(phaseLockersSWRZ, -2:20)
[~,pp, ~, stats]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)
[pp,~, stats]=ranksum(phaseCodersSWRZ,phaseLockersSWRZ)
xlabel('SWR Ratio Score'); ylabel('frequency');



%

figure; scatter(dbLS.phaseResultant,dbLS.thetaIndex, 10*log10(dbLS.totalSpikes), 'filled')

figure; scatter(dbLS.thetaIndex,dbLS.rateOnMazeMoving, 10*log10(dbLS.totalSpikes), 'filled')
figure; scatter(dbLS.phaseResultant,dbLS.rateOnMazeMoving, 10*log10(dbLS.totalSpikes), 'filled')

figure; scatter(dbLS.thetaIndex,dbLS.rateOnMazeMoving, 10*log10(dbLS.totalSpikes), 'filled')



figure; scatter(dbLS.phaseResultant, dbLS.totalMoving, 'filled')



figure; scatter( dbLS.peakProminenceRatio(selectWhat), dbLS.peakXcorrLagTime(selectWhat) )


selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)
unique(strcat( '|1|', dbLS.rat(selectWhat), '|', dbLS.date(selectWhat), '|', num2str(dbLS.tt(selectWhat)), '|', num2str(dbLS.unit(selectWhat)), '|', num2str(dbLS.circCorrPva(selectWhat)), '|', num2str(dbLS.totSpikes(selectWhat)),  '|', num2str(dbLS.medRatioCtr(selectWhat)),'|1|' ))

selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
unique(strcat( '|1|', dbLS.rat(selectWhat), '|', dbLS.date(selectWhat), '|', num2str(dbLS.tt(selectWhat)), '|', num2str(dbLS.unit(selectWhat)), '|', num2str(dbLS.circCorrPva(selectWhat)), '|', num2str(dbLS.totSpikes(selectWhat)),  '|', num2str(dbLS.medRatioCtr(selectWhat)),'|1|' ))


figure; histogram(dbLS.thetaIndex, 100)
figure; scatter3(dbLS.thetaIndex, dbLS.circCorrPva, dbLS.skaggsInfo, 'filled'); alpha(.4); xlabel('theta'); ylabel('circPval'); zlabel('skaggs')
figure; scatter3( dbLS.phaseResultantOnMazeMoving, dbLS.phaseResultant, dbLS.thetaIndex, 'filled' ); alpha(.4); ylabel('phaseResultantTraj'); xlabel('phaseResultantOnMazeMoving'); zlabel('thetaIdx')

%selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) & (( dbLS.peakXcorrLagTime > -.05 ) &  ( dbLS.peakXcorrLagTime < 0.05 )) ; sum(selectWhat)
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
%phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);
phaseCodersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseCodersSWRZ = phaseCodersSWRZ(idx);
selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
%phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);
phaseLockersSWRZ = dbLS.medRatioCtr(selectWhat);
phaseLockersSWRZ = phaseLockersSWRZ(idx);
%figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
figure; hold off; histogram(phaseCodersSWRZ, -2:20); hold on; histogram(phaseLockersSWRZ, -2:20)
[~,pp, ~, stats]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)
[pp,~, stats]=ranksum(phaseCodersSWRZ,phaseLockersSWRZ)
xlabel('SWR Ratio Score'); ylabel('frequency');









figure; 
hold on;

selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseLockersThetaIdx = dbLS.thetaIndex(selectWhat);
phaseLockersThetaIdx = phaseLockersThetaIdx(idx);
phaseLockersRate = dbLS.rateOnMazeMoving(selectWhat);
phaseLockersRate = phaseLockersRate(idx);
scatter( phaseLockersThetaIdx, phaseLockersRate, 100, 'filled' ); alpha(.5)

selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) ; ; sum(selectWhat); %   & ( dbLS.skaggsInfo < .01 )
length(unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) )))
[~,idx]=unique(strcat( dbLS.rat(selectWhat), '_', dbLS.date(selectWhat), '_', num2str(dbLS.tt(selectWhat)), '_', num2str(dbLS.unit(selectWhat)) ));
phaseCodersThetaIdx = dbLS.thetaIndex(selectWhat);
phaseCodersThetaIdx = phaseCodersThetaIdx(idx);
phaseCodersRate = dbLS.rateOnMazeMoving(selectWhat);
phaseCodersRate = phaseCodersRate(idx);
scatter( phaseCodersThetaIdx, phaseCodersRate, 100, 'filled' ); alpha(.5); hold on;

scatter(dbLS.thetaIndex,dbLS.rateOnMazeMoving, 10, 'k', 'filled');

xlabel('theta index'); ylabel('rate on maze >10 cm/s (hz)'); legend('phase locker','phase coder', 'all')






figure; scatter(dbLS.circCorrPva,dbLS.estimatedSlopeBuz*190, 'filled');



%%


swrCorrTable=readtable('~/Desktop/tt_report_shuff_h5h7_swr_xcorr.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-15b.csv'], 'ReadVariableNames',true);
linPlotsTable=readtable([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'], 'ReadVariableNames',true);
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-15b.csv'], 'ReadVariableNames',true);
linPlotsTable=readtable([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'], 'ReadVariableNames',true);
tempTable = innerjoin( linPlotsTable, linInfoTable, 'Keys', [ 1 2 3 4 5 ]);
tempTable = innerjoin( tempTable, swrCorrTable, 'Keys', [ 1 2 3 4 ]);
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ); % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);
selectWhat = ( strcmp( 'LS', ds.region_tempTable ) | strcmp( 'LS_SFi', ds.region_tempTable )  | strcmp( 'LS_V', ds.region_tempTable ) ); % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);
figure;
scatter( swrCorrTable.maxZScoreVal, swrCorrTable.sumPosPwr )
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
sum(selectWhat)
sum(( ( dbLS.nSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) )
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseCodersSWRZ = dbLS.maxZScoreVal(selectWhat);
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.pval>0.06 ) & dbLS.maxphaseResultants>0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseLockersSWRZ = dbLS.maxZScoreVal(selectWhat);
sum(selectWhat)
figure; histogram(phaseCodersSWRZ); hold on; histogram(phaseLockersSWRZ)
figure; histogram(phaseCodersSWRZ,0:2:35); hold on; histogram(phaseLockersSWRZ,0:2:35)
figure; histogram(dbLS.maxJointMI)
dbLS(selectWhat,1:4)
selectWhat = ( ( dbLS.totSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseCodersSWRZ = dbLS.maxZScoreVal(selectWhat);
selectWhat = ( ( dbLS.totSpikes>10 ) & ( dbLS.pval>0.06 ) & dbLS.maxphaseResultants>0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseLockersSWRZ = dbLS.maxZScoreVal(selectWhat);
selectWhat = ( ( dbLS.totSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
dbLS(selectWhat,1:4)
dbLS(selectWhat,[ 1:4 13:15 18:19 22 23 26 32])
dbLS(selectWhat,[ 1:4 13:15 18:19 22 23 26 32])
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.totSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseCodersSWRZ = dbLS.maxZScoreVal(selectWhat);
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.totSpikes>10 ) & ( dbLS.pval>0.06 ) & dbLS.maxphaseResultants>0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseLockersSWRZ = dbLS.maxZScoreVal(selectWhat);
figure; histogram(phaseCodersSWRZ,0:2:35); hold on; histogram(phaseLockersSWRZ,0:2:35)
length(phaseCodersSWRZ)
length(phaseLockersSWRZ)
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.totSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
dbLS(selectWhat,[ 1:4 13:15 18:19 22 23 26 32])










%%

linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-15b.csv'], 'ReadVariableNames',true);
% to access the table in a useful way, it works better to convert it to a dataset
dsLinInfoTable = table2dataset(linInfoTable);



linPlotsTable=readtable([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'], 'ReadVariableNames',true);
dsLinPlotsTable = table2dataset(linInfoTable);







tempTable = innerjoin( linPlotsTable, linInfoTable, 'Keys', [ 1 2 3 4 5 ]);
ds = table2dataset(tempTable);

selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ); % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);


figure; histogram(dbLS.maxJointMI,0:.5:max(dbLS.maxJointMI)); % hold on; histogram(dbLS.minJointMI,0:.5:max(dbLS.minJointMI));

figure; histogram(dbLS.maxphaseResultants);


figure; scatter( dbLS.maxJointMI, dbLS.maxphaseResultants );
xlabel('MI'); ylabel('resultant');


figure; scatter3( dbLS.maxJointMI, dbLS.maxphaseResultants, dbLS.pval );
xlabel('MI'); ylabel('resultant');
favCell = strcmp( '2018-07-27', dbLS.folder ) & dbLS.TT==32 & dbLS.unit==1 ; 
hold on; scatter3( dbLS.maxJointMI(favCell), dbLS.maxphaseResultants(favCell), dbLS.pval(favCell), 'r', 'filled' );


figure; scatter( dbLS.maxphaseResultants, log10(1-dbLS.pval) );
ylabel('pval'); xlabel('resultant');
hold on; scatter(  dbLS.maxphaseResultants(favCell), log10(1-dbLS.pval(favCell)), 'r', 'filled' );


% putative phase precessing cells :  list of resultants < .5 and pvalues <0.06
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5);
dbLS(selectWhat,[ 1:5 7:9 12:14 18 22 26 ])
figure; histogram( dbLS.totSpikes,0:50:2000); hold on; histogram( dbLS.totSpikes(selectWhat),0:50:2000);
% phase locked cells : list of resultants > .5
selectWhat = ( dbLS.maxphaseResultants>0.5);
dbLS(selectWhat,1:5)
% obtain SWR sensitivity for the above cells






favCell = strcmp('h5', dbLS.rat) & strcmp( '2018-05-16', dbLS.folder ) & dbLS.TT==32 & dbLS.unit==2 ; 




%%

linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-15b.csv'], 'ReadVariableNames',true);
linPlotsTable=readtable([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'], 'ReadVariableNames',true);
swrCorrTable=readtable('~/Desktop/tt_report_shuff_h5h7_swr_xcorr.csv', 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
tempTable = innerjoin( linPlotsTable, linInfoTable, 'Keys', [ 1 2 3 4 5 ]);
tempTable = innerjoin( tempTable, swrCorrTable, 'Keys', [ 1 2 3 4 ]);
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region_tempTable ) | strcmp( 'LS_SFi', ds.region_tempTable )  | strcmp( 'LS_V', ds.region_tempTable ) ); % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);

selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.totSpikes>10 ) & ( dbLS.pval<0.06 ) & dbLS.maxphaseResultants<0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseCodersSWRZ = dbLS.maxZScoreVal(selectWhat);
selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.totSpikes>10 ) & ( dbLS.pval>0.06 ) & dbLS.maxphaseResultants>0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseLockersSWRZ = dbLS.maxZScoreVal(selectWhat);

figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
length(phaseCodersSWRZ)
length(phaseLockersSWRZ)

figure; histogram(dbLS.maxJointMI)

% information, and the sum metric thingy
% should go in and calculate the difference between the 99% shuffle and the
%       actual xcorr data, use that as the summary metric

dbLS(selectWhat,1:4)


figure;
scatter( swrCorrTable.maxZScoreVal, swrCorrTable.sumPosPwr )



figure; histogram(dbLS.maxSpikeInfo(selectWhat))
%%



linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-18.csv'], 'ReadVariableNames',true);
ds=table2dataset(linInfoTable);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( ds.totSpikes>10 ) & ( ds.circCorrPva<0.06 ) & ( ~strcmp(ds.trajectory,'all') ) & (ds.phaseResultant<0.5); % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
favCell = strcmp( '2018-07-27', ds.date ) & ds.tt==32 & ds.unit==1 ;
figure; scatter(ds.phaseMIjoint(selectWhat), ds.skaggsInfo(selectWhat)); hold on; scatter(ds.phaseMIjoint(favCell), ds.skaggsInfo(favCell), 'filled')
axis([-0.5 3 -0.5 3]);axis square





basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
swrTable=readtable([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-07-19.csv']);
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-18.csv'], 'ReadVariableNames',true);
ds=table2dataset(linInfoTable);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( ds.fullSpatialBins>=8 ) & ( ds.totSpikes>10 ) & ( ds.circCorrPva<0.06 ) & ( ~strcmp(ds.trajectory,'all') ) & (ds.phaseResultant<0.5); % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
favCell = strcmp( '2018-07-27', ds.date ) & ds.tt==32 & ds.unit==1 ;
figure; scatter(ds.phaseMIjoint(selectWhat), ds.skaggsInfo(selectWhat)); hold on; scatter(ds.phaseMIjoint(favCell), ds.skaggsInfo(favCell), 'filled')
axis([-0.5 3 -0.5 3]);axis square


selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( ds.fullSpatialBins>=8 ) & ( ds.totSpikes>10 ) & ( ds.circCorrPva<0.06 ) & ( ~strcmp(ds.trajectory,'all') ) & (ds.phaseResultant<0.5) & ( ds.phaseMIjoint > .6 ); 
ds(selectWhat, [ 1:6 ])
length(unique(strcat( ds.rat(selectWhat), '_', ds.date(selectWhat), '_', num2str(ds.tt(selectWhat)), '_', num2str(ds.unit(selectWhat)) )))




selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) ) & ( ds.fullSpatialBins>=8 ) & ( ds.totSpikes>10 ) & ( ds.circCorrPva<0.06 ) & ( ~strcmp(ds.trajectory,'all') ) & (ds.phaseResultant<0.5) & ( ds.phaseMIjoint > .6 ); 

histograms of SWR responsiveness between the selectWHat above and the phase lockers


correlate SWR measure against phase and space metrics (two 2d plots)




clear all;
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
swrTable=readtable([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-07-19.csv']);
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-18.csv'], 'ReadVariableNames',true);
tempTable = innerjoin( swrTable, linInfoTable, 'Keys', [ 1:4 ] );
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region_swrTable ) | strcmp( 'LS_SFi', ds.region_swrTable )  | strcmp( 'LS_V', ds.region_swrTable ) );
dbLS = ds(selectWhat,:);

selectWhat = ( dbLS.fullSpatialBins >=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<0.06 ) & ( ~strcmp(dbLS.trajectory,'all') ) & (dbLS.phaseResultant<0.5) & ( dbLS.phaseMIjoint > .6 ) ; %& (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )); 
sum(selectWhat)
phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);

selectWhat = (   ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva>=0.06 ) & ( ~strcmp(dbLS.trajectory,'all') ) & dbLS.phaseResultant>=0.5); %  & ( dbLS.phaseMIjoint <= .6 ) ; % & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
sum(selectWhat)
phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);





selectWhat = ( strcmp( 'LS', ds.region_swrTable ) | strcmp( 'LS_SFi', ds.region_swrTable )  | strcmp( 'LS_V', ds.region_swrTable ) ) & ( ds.fullSpatialBins>=8 ) & ( ds.totSpikes>10 ) & ( ds.circCorrPva<0.06 ) & ( ~strcmp(ds.trajectory,'all') ) & (ds.phaseResultant<0.5) & ( ds.phaseMIjoint > .6 ); 
figure; histogram( ds.peakProminenceRatio, -2:15 ); hold on; histogram( ds.peakProminenceRatio(selectWhat) );
selectWhat = ( strcmp( 'LS', ds.region_swrTable ) | strcmp( 'LS_SFi', ds.region_swrTable )  | strcmp( 'LS_V', ds.region_swrTable ) ) & ( ds.fullSpatialBins>=8 ) & ( ds.totSpikes>10 ) & ( ds.circCorrPva>=0.06 ) & ( ~strcmp(ds.trajectory,'all') ) & (ds.phaseResultant>=0.5) & ( ds.phaseMIjoint <= .6 ); 
 histogram( ds.peakProminenceRatio(selectWhat) );

 
 
 
 
 
 
 %%
 
clear all;
basePathData='/Volumes/AGHTHESIS2/rats/summaryData/';
basePathOutput = '/Volumes/AGHTHESIS2/rats/summaryFigures/';
linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-20.csv'], 'ReadVariableNames',true);
%linInfoTable=readtable([ basePathOutput 'info_db_linearized_space_v2019-July-15b.csv'], 'ReadVariableNames',true);
%linPlotsTable=readtable([ basePathOutput 'spatial_linearizer_db_v2019-June-26.csv'], 'ReadVariableNames',true);
swrCorrTable=readtable([ basePathOutput 'tt_report_shuff_h5h7_swr_xcorr_2019-07-20.csv' ], 'ReadVariableNames',true);%, 'Format', '%s%s%f%f%f%f%f%f%f%f%f%f%s%s%s');
%tempTable = innerjoin( linPlotsTable, linInfoTable, 'Keys', [ 1 2 3 4 5 ]);
%tempTable = innerjoin( tempTable, swrCorrTable, 'Keys', [ 1 2 3 4 ]);
tempTable = innerjoin( linInfoTable, swrCorrTable, 'Keys', [ 1 2 3 4 5 ]);
ds = table2dataset(tempTable);
selectWhat = ( strcmp( 'LS', ds.region ) | strcmp( 'LS_SFi', ds.region )  | strcmp( 'LS_V', ds.region ) )& ( ~strcmp(ds.trajectory,'all') ) ; % & ( strcmp( ds.rat, 'h7') ); %& ( (ds.peakXcorrLagTime<.2) & (ds.peakXcorrLagTime>-.2) ) ;
dbLS = ds( selectWhat, :);
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)
phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);
selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);
figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
[hh,pp]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)




figure; scatter( dbLS.circCorrPva, dbLS.pvalCircLinCorrBuz )
figure; scatter( dbLS.circCorrRho, dbLS.circLinCorrCoefBuz )
figure; scatter( dbLS.pvalCircLinCorrBuz, dbLS.circLinCorrCoefBuz )


% the goal here is to find phase coding cells that are not also rate coders and phase locked cells

figure;  
subplot( 3, 3,  1 ); histogram(dbLS.circCorrPva);              title('circCorrPva');
subplot( 3, 3,  2 ); histogram(dbLS.fullSpatialBins);          title('fullSpatialBins');
subplot( 3, 3,  3 ); histogram(dbLS.phaseMIjoint);             title('phaseMIjoint');
subplot( 3, 3,  4 ); histogram(dbLS.phaseResultant);           title('phaseResultant');
subplot( 3, 3,  5 ); histogram(dbLS.totSpikes);                title('totSpikes');
subplot( 3, 3,  6 ); histogram(dbLS.skaggsInfo);               title('skaggsInfo');
subplot( 3, 3,  7 ); histogram(dbLS.peakProminenceRatio);      title('peakProminenceRatio');
subplot( 3, 3,  8 ); histogram(dbLS.peakXcorrLagTime);         title('peakXcorrLagTime');
subplot( 3, 3,  9 ); histogram(dbLS.pctFiringArea);            title('pctFiringArea');
%subplot( 3, 4,  8 ); histogram(dbLS.peakProminenceDifference); title('peakProminenceDifference');
%subplot( 3, 4,  9 ); histogram(dbLS.peakProminenceZ);          title('peakProminenceZ');
%subplot( 3, 4, 11 ); histogram(dbLS.pvalSwrShuff);             title('pvalSwrShuff');


figure; scatter( dbLS.phaseMIcondBitsPerCm, dbLS.phaseMIjoint )

figure;
subplot( 2, 3, 1 ); scatter( dbLS.circCorrPva, dbLS.phaseMIjoint ); xlabel('circCorrPva'); ylabel('phaseMIjoint');
subplot( 2, 3, 2 ); scatter( dbLS.circCorrPva, dbLS.skaggsInfo );   xlabel('circCorrPva'); ylabel('skaggsInfo');
subplot( 2, 3, 3 ); scatter( dbLS.phaseMIjoint, dbLS.skaggsInfo );  xlabel('phaseMIjoint'); ylabel('skaggsInfo');

subplot( 2, 3, 4 ); scatter( dbLS.circCorrPva, log10(dbLS.totSpikes) ); xlabel('circCorrPva'); ylabel('totSpikes');
subplot( 2, 3, 5 ); scatter( dbLS.phaseResultant, dbLS.phaseMIjoint );   xlabel('phaseResultant'); ylabel('phaseMIjoint');
subplot( 2, 3, 6 ); scatter( dbLS.phaseResultant, dbLS.skaggsInfo );  xlabel('phaseResultant'); ylabel('skaggsInfo');



selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & ( ~strcmp(dbLS.trajectory,'all') ) & (dbLS.phaseResultant<0.4); sum(selectWhat)
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & ( ~strcmp(dbLS.trajectory,'all') ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)

% this is the one I like best
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)
phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);
selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);
figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
[hh,pp]=ttest2(phaseCodersSWRZ,phaseLockersSWRZ)



selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.phaseMIjoint>0.5 ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 ) ; sum(selectWhat)
phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);
selectWhat =  ( dbLS.totSpikes>10 ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) ; sum(selectWhat)
phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);
figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)




selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & ( dbLS.skaggsInfo < .01 ) & (dbLS.phaseResultant<0.4);sum(selectWhat)






%%

selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ); sum(selectWhat)
figure; subplot( 2,2,1 ); scatter( dbLS.skaggsInfo, dbLS.phaseResultant ); xlabel('skaggsInfo'); ylabel('phaseResultant');
subplot( 2,2,2 ); hold off; scatter( dbLS.skaggsInfo, dbLS.phaseMIjoint, 'k', 'filled' ); xlabel('skaggsInfo'); ylabel('phaseMIjoint');
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva>0.05 ); sum(selectWhat)
subplot( 2,2,2 ); hold on; scatter( dbLS.skaggsInfo(selectWhat), dbLS.phaseMIjoint(selectWhat), 'r', 'filled' ); xlabel('skaggsInfo'); ylabel('phaseMIjoint');
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ); sum(selectWhat)
subplot( 2,2,2 ); hold on; scatter( dbLS.skaggsInfo(selectWhat), dbLS.phaseMIjoint(selectWhat), 'MarkerFaceColor', [ .4 .6 .9 ],  'MarkerEdgeColor', [ .4 .6 .9 ] ); xlabel('skaggsInfo'); ylabel('phaseMIjoint');
legend('all','circCorr>0.5','circCorr<0.5');
subplot( 2,2,3 ); scatter( dbLS.phaseMIjoint, dbLS.phaseResultant ); ylabel('phaseResultant'); xlabel('phaseMIjoint');





subplot( 2,2,4 ); scatter( dbLS.phaseResultant, dbLS.skaggsInfo );



figure;
subplot( 2,2,1 ); scatter( dbLS.phaseMIjoint, log10(dbLS.peakProminenceRatio) ); xlabel('phaseMIjoint'); ylabel('log10(peakProminenceRatio)');
subplot( 2,2,2 ); scatter( dbLS.circCorrPva, log10(dbLS.peakProminenceRatio) ); xlabel('circCorrPva'); ylabel('log10(peakProminenceRatio)');
subplot( 2,2,3 ); scatter( dbLS.phaseResultant, log10(dbLS.peakProminenceRatio) ); xlabel('phaseResultant'); ylabel('log10(peakProminenceRatio)');
subplot( 2,2,4 ); scatter( dbLS.peakXcorrLagTime, log10(dbLS.peakProminenceRatio) ); xlabel('peakXcorrLagTime'); ylabel('log10(peakProminenceRatio)');


figure; scatter( -abs(dbLS.estimatedSlopeBuz), dbLS.skaggsInfo ); xlabel('circCorrPva'); ylabel('log10(peakProminenceRatio)');
subplot( 2,2,2 ); scatter( dbLS.pvalCircLinCorrBuz, log10(dbLS.peakProminenceRatio) ); xlabel('circCorrPva'); ylabel('log10(peakProminenceRatio)');



%% ?? mae


% graph stuff
selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<=0.05 ) & ( ~strcmp(dbLS.trajectory,'all') ) & (dbLS.phaseResultant<0.4) & ( dbLS.skaggsInfo < .01 )& (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ; sum(selectWhat)
phaseCodersSWRZ = dbLS.peakProminenceRatio(selectWhat);
selectWhat =  ( dbLS.totSpikes>10 )  & ( ~strcmp(dbLS.trajectory,'all') ) & (dbLS.phaseResultant>0.4) & ( dbLS.circCorrPva>0.05 ) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )); sum(selectWhat)
phaseLockersSWRZ = dbLS.peakProminenceRatio(selectWhat);
figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
length(phaseCodersSWRZ)
length(phaseLockersSWRZ)





selectWhat = ( dbLS.fullSpatialBins>=8 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva<0.06 ) & ( ~strcmp(dbLS.trajectory,'all') ) & (dbLS.phaseResultant<0.5) & ( dbLS.phaseMIjoint > .6 ) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
phaseCodersSWRZ = dbLS.maxZScoreVal(selectWhat);
%selectWhat = ( ( dbLS.nSpikes>10 ) & ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva>0.06 ) & dbLS.maxphaseResultants>0.5) & (( dbLS.peakXcorrLagTime > -.1 ) &  ( dbLS.peakXcorrLagTime < 0.1 )) ;
%( dbLS.fullSpatialBins>=8 ) & & ( ~strcmp(dbLS.trajectory,'all') )
selectWhat =  ( dbLS.totSpikes>10 ) & ( dbLS.circCorrPva>=0.06 )  & (dbLS.phaseResultant>=0.5) ;%& ( dbLS.phaseMIjoint < .6 );
phaseLockersSWRZ = dbLS.maxZScoreVal(selectWhat);

figure; histogram(phaseCodersSWRZ,0:2:30); hold on; histogram(phaseLockersSWRZ,0:2:30)
length(phaseCodersSWRZ)
length(phaseLockersSWRZ)