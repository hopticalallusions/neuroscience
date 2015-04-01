function eventsObj = logEvent( eventsObj, messageText, displayEvent, messageTimeNlx )
    % Check number of inputs.
    if nargin > 4
        error('mazes:logEvent:TooManyInputs', ...
            'requires at most 1 optional inputs');
    elseif nargin < 2
        error('mazes:logEvent:TooFewInputs', ...
            'requires 1 input');
    end

    % Fill in unset optional values.
    switch nargin
        case 2
            displayEvent = false;
            messageTimeNlx = 0;
        case 3
            messageTimeNlx = 0;
    end
    
    % actual function
    if displayEvent
        disp(messageText)
    end
    eventsObj.eventHistory = [ eventsObj.eventHistory ; cellstr(messageText) ];
    eventsObj.eventHistoryTimesNlx = [ eventsObj.eventHistoryTimesNlx, messageTimeNlx ];
    eventsObj.eventHistoryTimesMatlab = [ eventsObj.eventHistoryTimesMatlab, now()];
    %eventsObj.eventIdx = eventIdx + 1;
end

