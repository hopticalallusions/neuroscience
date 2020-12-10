[ '/Users/andrewhowe/src/MATLAB/defaultFolder' '/' 'movInitv3.mat' ]

bb=(movInitBlob.goTrigRatLabel{'h5'});

ratName = 'h5';
dateStr = '2018-04-27';

% this is stupid...
initMovementEpisodeTimes=[];
for ii = 1:length(movInitBlob.goTrigRatLabel)
    if strcmp( movInitBlob.goTrigRatLabel{ii}, ratName)
        if strcmp( movInitBlob.goTrigSession{ii}, dateStr)
            initMovementEpisodeTimes = [ initMovementEpisodeTimes movInitBlob.goTrigTime(ii) ];
        end
    end
end

stopMovementEpisodeTimes=[];
for ii = 1:length(movInitBlob.goTrigRatLabel)
    if strcmp( movInitBlob.goTrigRatLabel{ii}, ratName)
        if strcmp( movInitBlob.goTrigSession{ii}, dateStr)
            stopMovementEpisodeTimes = [ stopMovementEpisodeTimes movInitBlob.stopTrigTime(ii) ];
        end
    end
end
    