function eventLog = eventLog()
    eventLog = struct;
    eventLog.eventIdx = 1;
    eventLog.eventHistory = [];
    eventLog.eventHistoryTimesNlx = [];
    eventLog.eventHistoryTimesMatlab = [];
    eventLog = class(eventLog,'eventLog');
end