%Bacchus_I

probe_256A

newexceldata = zeros(size(exceldata,1),5);
newexceldata(:,[1:2 4:5]) = exceldata(:,[1:2 3:4]);
newexceldata(:,1) = newexceldata(:,1) + 256;
newexceldata(:,2) = newexceldata(:,2) - 350;
newexceldata(:,3) = -1100;
newexceldata(:,5) = newexceldata(:,5) + 5;

exceldatastrprobe = newexceldata;

probe_256BL

newexceldata = zeros(size(exceldata,1),5);
newexceldata(:,[1:2 4:5]) = exceldata(:,[1:2 3:4]);
newexceldata(:,2) = newexceldata(:,2);
newexceldata(:,4) = newexceldata(:,4)+2000;
newexceldata(:,5) = newexceldata(:,5);

exceldataPFCprobe = newexceldata;

exceldata=[];

exceldata = [exceldataPFCprobe; exceldatastrprobe];
s=[];
s.channels=exceldata(:,1);
s.x=exceldata(:,2);   %the reference electrode is always the top right channel when the probes are pointing up.
s.y = exceldata(:,3);
s.z=exceldata(:,4);
s.shaft=exceldata(:,5);
s.tipelectrode=30;

[a,sortorder]=sort(s.channels);
s.channels=s.channels(sortorder);
s.x=s.x(sortorder);
s.y = s.y(sortorder);
s.z=s.z(sortorder);

% To plot the labeled channels:
figure(1)
close 1
figure(1)
plot3(s.x,s.y,s.z,'.b')
% for i=1:length(s.channels)
% text(s.x(i),s.y(i),s.z(i),num2str(s.channels(i)),'FontSize',6)
% end
axis equal
