function [splice_data] = MB_DataSplice( HPPfile, baserate )

lfp = dlmread(HPPfile);
chanum=lfp(1);
dsfact=lfp(2);
dcosize=lfp(3);
srate=round(baserate/lfp(2)); %compute sampling rate for the data file
lfp=lfp(4:end); %truncate channel and downsampling rate to obtain u(t)
timestamps=[(1/srate):(1/srate):length(lfp)/srate]-1/srate;

scrsz = get(groot,'ScreenSize');
figure('Position',[50 scrsz(4)/2 scrsz(3)/1.2 scrsz(4)/2])
plot(timestamps, lfp);
xlabel('Time (s)');
title('Left click L & R bounds of zoom area, Right click to zoom out (SPACE to accept selection)');

xbound=[];
button=0;
splice_x=[1 length(timestamps)];
while ~(button==32)
    [x, y, button]=ginput(1);
    if button==1
        xbound=[xbound x];
        if length(xbound)>1
            lbound=min(xbound);
            rbound=max(xbound);
            set(gca,'XLim',[lbound rbound]);
            xbound=[];
            splice_x = [find(timestamps>=lbound,1,'first') find(timestamps>=rbound,1,'first')];
        end
    end
    if button==3
            lbound=min(timestamps);
            rbound=max(timestamps);
            set(gca,'XLim',[lbound rbound]);
            xbound=[];
            splice_x = [find(timestamps>=lbound,1,'first') find(timestamps>=rbound,1,'first')];
    end
end

splice_data = lfp(splice_x(1):splice_x(2));

temp=strfind(HPPfile,'.hpp');
outfile=[HPPfile(1:temp-1) '_selected.hpp'];
%store the weight file for use by the tester
fileID = fopen(outfile,'w');
fprintf(fileID,'%d\n',chanum);
fprintf(fileID,'%d\n',dsfact);
fprintf(fileID,'%d\n',dcosize);
fprintf(fileID,'%d\n',splice_data);
fclose(fileID);