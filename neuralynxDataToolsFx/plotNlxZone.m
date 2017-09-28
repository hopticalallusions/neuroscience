function plotNlxZone( zoneCoords )

temp=size(zoneCoords);
rows=temp(1);

colors=[0.2 0.2 0.2; 0.9 0.1 0.1; 0.1 0.9 0.1; 0.1 0.1 0.9; 0.9 0.8 0.2; 0.9 0.1 0.9; 0.8 0.3 0.3; 0.3 0.9 0.3; 0.1 0.9 0.9; 0.1 0.1 0.5];
colorIdx=1;
%dark gray; red; green; blue; yellow; magenta; green; cyan; dark blue; 

for ii=1:rows
    %yy=720-zoneCoords([2,4]); % assumes correction to flip was used
    tempZoneCoord = zoneCoords(ii,:);
    yy=tempZoneCoord([2,4]); % assumes correction to flip was used
    xx=tempZoneCoord([1,3]);
    line([xx(1) xx(1)],[yy(1) yy(2)],'Color',colors(colorIdx,:));
    line([xx(2) xx(2)],[yy(1) yy(2)],'Color',colors(colorIdx,:));
    line([xx(1) xx(2)],[yy(1) yy(1)],'Color',colors(colorIdx,:));
    line([xx(1) xx(2)],[yy(2) yy(2)],'Color',colors(colorIdx,:));
    colorIdx = colorIdx + 1;
    if colorIdx > 10
        colorIdx=1;
    end
end

