function behaviorStateCode = da5MakeBehaviorCode(metadata)

    behaviorStateCode = ones(size(metadata.xpos));
    %tidxs = 1:round(29.97*(leaveBucketToMaze(idx)-5));
    %behaviorStateCode(tidxs) = 1;
    for idx=1:length(metadata.leaveBucketToMaze)
        tidxs = round(29.97*(metadata.leaveBucketToMaze(idx)-5)):round(29.97*(metadata.leaveBucketToMaze(idx)));
        behaviorStateCode(tidxs) = -1;
        tidxs = round(29.97*(metadata.leaveBucketToMaze(idx))):round(29.97*(metadata.trialStartAction(idx)));
        behaviorStateCode(tidxs) = 2;
        tidxs = round(29.97*(metadata.trialStartAction(idx))):round(29.97*(metadata.sugarConsumeTimes(idx)));
        behaviorStateCode(tidxs) = 3;
        tidxs = round(29.97*(metadata.sugarConsumeTimes(idx))):round(29.97*(metadata.leaveMazeToBucket(idx)));
        behaviorStateCode(tidxs) = 4;
        tidxs = round(29.97*(metadata.leaveMazeToBucket(idx))):round(29.97*(metadata.leaveMazeToBucket(idx)+5));
        behaviorStateCode(tidxs) = -1;
    end


