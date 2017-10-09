function nlxstruct = MB_SpliceTrain( nlxstruct, filternum )

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
% filternum = index of nlxstruct.filtered(i) to splice (default = 1)

if nargin<2
    filternum=1; %default is first filter
end

lfp=(nlxstruct.data/(2^16))+1.5;
sint=nlxstruct.dt
timestamps=[sint:sint:(length(lfp)*sint)]-sint;
m=max(timestamps); 
lbound=0;
rbound=m;

scrsz = get(groot,'ScreenSize');
figure('Position',[100 scrsz(4)/7 scrsz(3)/1.2 scrsz(4)/2]); clf; 
plot(timestamps, lfp, 'k'); hold on;
plot(timestamps, real(nlxstruct.filtered(filternum).teaching_signal));
plot(timestamps, imag(nlxstruct.filtered(filternum).teaching_signal));
line([0 m],[0 0]); line([0 m],[-1 -1]); line([0 m],[1 1]); line([0 m],[1.5 1.5]); line([0 m],[2 2]);
xlabel('Time (s)'); set(gca,'XLim',[0 m],'YTick',[], 'YLim', [-1.05 2.05]);
title('Left mouse = select bounds of zoom area; Right mouse = zoom out; T/S = save as training/testing segment; Q = quit');

xbound=[];
button=0;
splice_x=[1 length(timestamps)];
while ~(button==81) & ~(button==113)
    [x, y, button]=ginput(1);
    % ZOOM IN
    if button==1
        xbound=[xbound x];
        if length(xbound)>1
            lbound=min(xbound);
            rbound=max(xbound);
            set(gca,'XLim',[lbound rbound]);
            xbound=[];
            splice_x = [find(timestamps>=lbound,1,'first') find(timestamps>=rbound,1,'first')];
        else
            line([xbound xbound],[-1 2]);
        end
    end
    %ZOOM OUT
    if button==3
        lbound=min(timestamps);
        rbound=max(timestamps);
        hold off; plot(timestamps, lfp, 'k'); hold on;
        plot(timestamps, real(nlxstruct.filtered(filternum).teaching_signal));
        plot(timestamps, imag(nlxstruct.filtered(filternum).teaching_signal));
        line([0 m],[0 0]); line([0 m],[-1 -1]); line([0 m],[1 1]); line([0 m],[1.5 1.5]); line([0 m],[2 2]);
        xlabel('Time (s)'); set(gca,'XLim',[0 m],'YTick',[], 'YLim', [-1.05 2.05]);
        title('Left mouse = select bounds of zoom area; Right mouse = zoom out; T/S = save as training/testing segment; Q = quit');
        %            set(gca,'XLim',[lbound rbound]);
        xbound=[];
        splice_x = [1 length(timestamps)];
    end
    %STORE TESTING SEGMENT
    if button==84
        nlxstruct.filtered(filternum).training_segment=splice_x;
    end
    if button==116
        nlxstruct.filtered(filternum).training_segment=splice_x;
    end
    %STORE TRAINING SEGMENT
    if button==83
        nlxstruct.filtered(filternum).testing_segment=splice_x;
    end
    if button==115
        nlxstruct.filtered(filternum).testing_segment=splice_x;
    end
end


close(gcf);
