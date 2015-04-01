%This code tracks position of a single object by locking onto the darkest
%feature in the image, which should be the mouse. 
%May 2 2011, version 1, Sotiris Masmanidis

%Note: must first convert SEQ video file to JPG files.
%Use command:   seqIo(seqfilename,'toImgs',targetdirectory)   %seqIo code by Piotr Dollar
%type "help seqIo>toImgs" for more information.

%***Set parameters***
maindir='H:\nano mouse vids';
resultsdir='C:\data analysis\video tracking';
mousename='mouse nano2';
filenames={'May15a'};   %{'May6b'; 'May7a'; 'May8a'}

plotimage='n';  %will run slower if this option is 'y'.

LEDx=618;  %position of LED for synchronization.
LEDy=428;
fps=25.031928724110422;
%********************

for f=1:length(filenames);
    filename=filenames{f};

videodir=[maindir '\' mousename '\' filename '\'];
savedir=[resultsdir '\' mousename '\' filename '\'];
mkdir(savedir)

jpegfiles=dir([videodir '*.jpg']);
close all

position=[]; x=[]; y=[]; LEDtimes=[]; tracking=[];
figure(1)
for i=1:length(jpegfiles);
    fname = jpegfiles(i).name
    
  
currentimage=imread([videodir fname]);

[row,col,val]=find(currentimage<12);

% if length(row)>0
xpos=round(mean(col));
ypos=round(mean(row));
% else
% xpos=xpos;   %assigns previous position if tracking is lost.
% ypos=ypos;
% end

x=[x; xpos];
y=[y; ypos];

LEDimage=currentimage((LEDy-30):(LEDy+50), (LEDx-20):(LEDx+20));
maxbrightness=max(max(LEDimage));
    if i>1
        if maxbrightness==255 & previousbrightness~=255
        LEDtimes=[LEDtimes; i];
        end
    end    
previousbrightness=maxbrightness;
        
% if plotimage=='y'
% imagesc(currentimage)
% colormap('gray')
% hold on
% end
% % scatter(x,y,5,'MarkerFaceColor','b','MarkerEdgeColor','b')
% axis([0 size(currentimage,2) 0 size(currentimage,1)])
% figure(1)

end

close all
fignum=1
figure(fignum)
imagesc(currentimage)
colormap('gray')
hold on
% scatter(x,y,3,'MarkerFaceColor','b','MarkerEdgeColor','b')
line(x,y,'LineWidth',0.75)
axis off
saveas(figure(fignum),[savedir 'position.jpg' ]  ,'jpg')

tracking.x=x;
tracking.y=y;
tracking.LEDtimes=LEDtimes;
tracking.fps=fps;

save([savedir 'tracking.mat'],'tracking', '-mat')

end