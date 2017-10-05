function [splice_data] = MB_SpliceTrain( nlxstruct, filternum )

%ARGUMENTS:
% nlxstruct contains data to splice; fields of the structure are as follows:
%    nlxstruct.gapstart = any gaps in the data are filled with NaNs; this vector contains the start index of each gap
%    nlxstruct.gaplength = this vector contains the length (number of NaNs) of each NaN gap
%    nlxstruct.channel = channel number for this data
%    nlxstruct.dsfactor = downsampling factor (DS) for this data
%    nlxstruct.dt = sample interval for this data
%    nlxstruct.dcowidth = DCO window size for this data
%    nlxstruct.data = 24 bit signed integer data, downsampled and DCO filtered (centered at zero)
%    nlxstruct.filtered(i) = substructure containing filtered versions of the data
%    filternum = index of nlxstruct.filtered(i) to splice (default = 1)


scalefact=17;
lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
sint=nlxstruct.dt
timestamps=[sint:sint:(length(lfp)*sint)]-sint;
m=max(timestamps); 
lbound=0;
rbound=m;

scrsz = get(groot,'ScreenSize');
figure('Position',[100 scrsz(4)/7 scrsz(3)/1.2 scrsz(4)/2])
plot(timestamps, lfp, 'k');
line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
title('Left mouse = select L & R bounds of zoom area; Right mouse = zoom out;  +/- = adjust Scale Factor; SPACE = accept');
set(gca,'XLim',[0 m]);

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
            if lbound<rbound
                set(gca,'XLim',[lbound rbound]);
                xbound=[];
                splice_x = [find(timestamps>=lbound,1,'first') find(timestamps>=rbound,1,'first')];
            else
                beep;
            end
        end
    end
    if button==3
            lbound=min(timestamps);
            rbound=max(timestamps);
            set(gca,'XLim',[lbound rbound]);
            xbound=[];
            splice_x = [find(timestamps>=lbound,1,'first') find(timestamps>=rbound,1,'first')];
    end
    if button==43
            scalefact=scalefact-1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('Left mouse = select L & R bounds of zoom area; Right mouse = zoom out;  +/- = adjust Scale Factor; SPACE = accept');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
    if button==61
            scalefact=scalefact-1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('Left mouse = select L & R bounds of zoom area; Right mouse = zoom out;  +/- = adjust Scale Factor; SPACE = accept');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
    if button==45
            scalefact=scalefact+1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('Left mouse = select L & R bounds of zoom area; Right mouse = zoom out;  +/- = adjust Scale Factor; SPACE = accept');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
    if button==95
            scalefact=scalefact+1;
            lfp=(nlxstruct.data+2^(scalefact-1))/2^(scalefact-15);
            lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
            plot(timestamps, lfp, 'k');
            line([0 m],[0 0]); line([0 m],[2^15 2^15]); line([0 m],[2^14 2^14]);
            xlabel('Time (s)'); ylabel(['Scale Factor ' num2str(scalefact)]);
            title('Left mouse = select L & R bounds of zoom area; Right mouse = zoom out;  +/- = adjust Scale Factor; SPACE = accept');
            set(gca,'XLim',[0 m]);
            set(gca,'XLim',[lbound rbound]);
    end
end

splice_data = lfp(splice_x(1):splice_x(2));

% temp=strfind(HPPfile,'.hpp');
% outfile=[HPPfile(1:temp-1) '_selected.hpp'];
% %store the weight file for use by the tester
% fileID = fopen(outfile,'w');
% fprintf(fileID,'%d\n',chanum);
% fprintf(fileID,'%d\n',dsfact);
% fprintf(fileID,'%d\n',dcosize);
% fprintf(fileID,'%d\n',splice_data);
% fclose(fileID);