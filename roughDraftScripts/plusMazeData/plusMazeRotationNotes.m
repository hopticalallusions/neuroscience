trans=[];
step=5*30;
for ii=step+1:step:length(xrpos)-step-1
    lastMean=mean(xrpos(ii-step:ii));
    lastStd=var(xrpos(ii-step:ii));
    nextMean=mean(xrpos(ii:ii+step));
    nextStd=var(xrpos(ii:ii+step));
    if nextMean<(lastMean+4*lastStd)
        trans=[trans ii];
    end
end

figure;plot(xrpos,'k'); hold on; plot(trans,xrpos(trans),'o');
length(trans)


figure;plot(xrpos(1:length(xrpos)-30),xrpos(31:length(xrpos)));



% idea that doesn't work. minimize variance in x and y to find best
% rotation

% centerX=313;
% centerY=242;
% theta= -median(angles)-pi;
% xrpos= xpos.*cos(theta) - ypos.*sin(theta); xrpos=round(xrpos-min(xrpos)+1); % shift, and make integer
% yrpos= ypos.*cos(theta) + xpos.*sin(theta); yrpos=round(yrpos-min(yrpos)+1); % shift, and make integer
% figure; plot(xrpos,yrpos,'k'); title('rotated and shifted positions');
% 
angles=90:30:240; angles=angles*pi/180;
xvar=zeros(1,length(angles));
yvar=zeros(1,length(angles));
figure;hold on;
for ii=1:length(angles)
    xtrp= xpos.*cos(angles(ii)) - ypos.*sin(angles(ii)); xtrp=round(xtrp-min(xtrp)+1); % shift, and make integer
    ytrp= ypos.*cos(angles(ii)) + xpos.*sin(angles(ii)); ytrp=round(ytrp-min(ytrp)+1); % shift, and make integer
    xvar(ii)=var(xtrp); yvar(ii)=var(ytrp);
    [yy,xx]=hist(xtrp,50);
    plot(xx,yy);
end


legend('90','120','150','180','210','240','270','300','330')



ttTwo=[ tttwo(1,:); tttwo(2,:); tttwo(3,:); halfdata(1,:)];
for ii=1:4
    ttTwo(ii,:) = ttTwo(ii,:) - mean(ttTwo(ii,:));
    ttTwo(ii,:) = 6*ttTwo(ii,:)./(max(ttTwo(ii,:))-min(ttTwo(ii,:)));
end

for ii=2:2:17
    ttForTemplate = ttTwo(:,32000*(60*(ii-2))+1:32000*(60*(ii)));
    save(['/Volumes/SILVRSURFER/ttTwo_min' num2str(ii-2) '-' num2str(ii) '.mat'], 'ttForTemplate');
end
ttForTemplate = ttTwo(:,32000*(60*(16))+1:end);
save(['/Volumes/SILVRSURFER/ttTwo_min16-end.mat'], 'ttForTemplate');




qq=60*diff([ 3.13  3.246 5.245 5.362 7.361 7.452 9.452 9.554 11.55 11.64 13.64 13.72 15.72 15.81 17.81 19.92 ])



qq=32000*60*[ 0.0001 1.1 3.14  3.245 5.247 5.360 7.363 7.450 9.454 9.552 11.57 11.62 13.66 13.70 15.74 15.79 17.83 19.90 ]
qq(1)=1;
qq = [     1     2165000     6009500     6230400    10072000    10294000    14136960 ...
    14304000    18151680    18339840    22184400    22340400    26187200    26340000 ...
    30184000    30346000    34188600    34395000    39350000    39940608 ];
diff(qq)/32000
figure; plot(lfpData); hold on; plot(qq,ones(1,length(qq)),'or')
jj=1;
for ii=1:2:length(qq)-1
    snip=lfpData(qq(ii):qq(ii+1));
    rppNoise(jj)=max(snip)-min(snip);
    rmsNoise(jj)=sqrt(length(snip)*sum(snip.^2));
    jj=jj+1;
end
jj=1;
for ii=2:2:length(qq)-1
    snip=lfpData(qq(ii):qq(ii+1));
    rppSignal(jj)=max(snip)-min(snip);
    rmsSignal(jj)=sqrt(length(snip)*sum(snip.^2));
    jj=jj+1;
end
figure; plot(rppNoise,rmsNoise, 'or'); hold on; plot(rppSignal,rmsSignal,'og');
legend('noise','signal+noise');
xlabel('rpp'); ylabel('rms');

plot(max(lfpSpikes)-min(lfpSpikes), sqrt(length(lfpSpikes)*sum(lfpSpikes.^2)),'k*');