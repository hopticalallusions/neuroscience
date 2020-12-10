aa=[ 73	70	82	83	78	74	81	69	62	74	74	60	72	66	69	64	52	68	55	42	72 ];
median(abs(aa-median(aa)))
var(aa)

ttIdx = 4;
load([ filepath '/../../../summaryData/' 'h7_lsAcorrThetaRoseSwrXcorrZones_' folders{folderIdx}  '_' strrep(ttFilenames{ttIdx},'.NTT','') '.dat'] );

load('/Volumes/AGHTHESIS2/summaryData/h7_lsAcorrThetaRoseSwrXcorrZones_2018-07-13_TT27a.dat', '-mat', 'ttData');


                plot(xpos,ypos,'Color', [ 0 0 0 .05]); 
                hold on;
                
                figure;
                cellId=5;
                % select a specific cluster that is between a reasonable speed
                idxd =  (ttData.speed>10).*(ttData.speed<140).*(ttData.cellNumber==cellId);
                idxd = idxd >= 1;
                scatter( ttData.x(idxd), ttData.y(idxd), 10, circColor(floor(ttData.thetaPhase(idxd)+181),:), 'filled' );
                alpha(.5);
                axis square;
                title([ '_{' folders{folderIdx}  ' ' strrep(ttFilenames{ttIdx},'.NTT','') ' ' num2str(cellId) '}' ]);

                    colormap(circColor);
                    colorbar;
                    caxis([0 360]);


                    

load('~/data/plusMazeBehaviorDatabase - Hx_rats.csv');

load('~/Downloads/plusMazeBehaviorDatabase - Hx_rats.tsv');


table=readtable('~/Downloads/plusMazeBehaviorDatabase - Hx_rats.csv', 'ReadVariableNames',true,'Format','%s%s%u%u%u%u%u%u%u%u%s%s%s%s%s%s%s%u%u%s%s%s%s%s%s%s%s%s%u%u%u%s%s%u%u%u%u%s');


% load CLEANED Hx rats data into a table from a CSV file (cleaning involves
% cutting some lines, removing any values that screw up the file)
% specifically, to clean, the following tricks are helpful ; after loading
% the file in matlab check which columns were imported as text (only need
% to spy a few rows); copy the column to a text file and remove duplicates;
% this should tell what lines are text and they can then be found with find
% and fixed in the various copies of the database (always adjust all the
% databases the same way); any invalid type values can be replaced with NaN
% and matlab will import them as NaN which allows for quality checks.
table=readtable('~/Downloads/plusMazeBehaviorDatabase-Hx_rats.csv', 'ReadVariableNames',true);
% to access the table in a useful way, it works better to convert it to a
% dataset
ds = table2dataset(table);
% now we can select via string comparison a particular set of dates
ds(strcmp( ds.Date,'2018-07-13'), 1:5)



table=readtable('~/Downloads/plusMazeBehaviorDatabase - Hx_rats.csv', 'ReadVariableNames',true,'Format','%s%s%u%u%u%u%u%u%u%u%s%s%s%s%s%s%s%u%u%s%s%s%s%s%s%s%s%s%u%u%u%s%s%u%u%u%u%s');