function [ subplotDimensions, additionalArguments ] = subplotCheat(plotsNeeded)

    % assumes a widescreen display

    subplotCheatTable = [ 1,1; 2,1; 2,2; 2,2; 3,2; 3,2; 3,3; 3,3; 3,3; 4,3; 4,3; 4,3; 4,4; 4,4; 4,4; 4,4; 5,4; 5,4; 5,4; 5,4; 5,5; 5,5; 5,5; 5,5; 5,5; 6,5; 6,5; 6,5; 6,5; 6,5; 6,6; 6,6; 6,6; 6,6; 6,6; 6,6; 7,6; 7,6; 7,6; 7,6; 7,6; 7,6 ];

    if plotsNeeded > length(subplotCheatTable)
        subplotDimensions = [];
        additionalArguments = '';
        return
    end
    
    if plotsNeeded > 42
        additionalArguments = 'add things to shut off axes and what have you to improve packing';
    else
        additionalArguments = [];
    end

    subplotDimensions = subplotCheatTable(plotsNeeded,:);

return;



% to expand the plots 
% pos = get(gca, 'Position');
%     pos(1) = 0.055;
%     pos(3) = 0.9;
%     set(gca, 'Position', pos)