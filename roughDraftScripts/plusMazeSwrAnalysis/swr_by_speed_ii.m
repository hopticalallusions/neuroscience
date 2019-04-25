%clear all; %vars -except lambdas;
load 'saturdayData';
speedDist=saturdayData.speedDist';
speedPre=saturdayData.speedDistPre';

speedDist=speedDist';

diffDist=diff(speedDist,1,1);
swrEvents=saturdayData.swrEvents;

figure; hold on;
for ii=1:length(speedDist);
    swrnum(ii)=sum(swrEvents(1:90,ii));
    meanspd(ii)=mean(speedDist(:,ii));
    meanspd3190(ii)=mean(speedDist(121:180,ii));
    maxspd(ii)=max(speedDist(91:180,ii));
%                                         maxpre(ii)=max(speedPre(:,ii));
    maxpre(ii)=max(speedDist(1:90,ii));
    maxdiff(ii)=max(abs(diffDist(:,ii)));
    scatter(sum(swrEvents(:,ii))+((rand(1)-.5)/1.5), mean((speedDist(:,ii))),'k'); 
end

figure(5); clf;
histogram(meanspd3190,0:5:120);

good=find(meanspd<50 & meanspd>5 & maxspd<100  & maxdiff<10  & meanspd3190>15 & maxpre<12);

meanspd=meanspd(good);
meanspd3190=meanspd3190(good);
swrnum=swrnum(good);

cutoff=20;

slow=find(meanspd3190<cutoff);
fast=find(meanspd3190>=cutoff+10);

slowpd=fitdist(swrnum(slow)','Poisson');
fastpd=fitdist(swrnum(fast)','Poisson');

slowhist=histc(swrnum(slow),0:1);
fasthist=histc(swrnum(fast),0:1);

percnonzero_slow=slowhist(2)/sum(slowhist);
percnonzero_fast=fasthist(2)/sum(fasthist);
[percnonzero_slow percnonzero_fast]
    
numiter=1000;
for i=1:numiter
    temp=sortrows([rand(1,length([slow fast])); swrnum([slow fast])]',1);
    temppd=fitdist(temp(1:length(fast),2),'Poisson');
    lambda(i)=temppd.lambda;
    temphist=histc(temp(1:length(fast),2),0:1);
    percnonzero(i)=temphist(2)/sum(temphist);
end

figure(6); clf; 
subplot(2,1,1); histogram(lambda,.5:.1:1.5);
subplot(2,1,2); histogram(percnonzero,.5:.1:1.5);
c=find(lambda>fastpd.lambda);
d=find(percnonzero>percnonzero_fast);

%lambdas=[lambdas; [cutoff slowpd.lambda fastpd.lambda]];
pval=length(c)/numiter; %show significance for shuffle test
pval_perc=length(d)/numiter

speedsort = sortrows([meanspd3190([slow fast])' speedDist(1:90,good([slow fast]))' speedDist(:,good([slow fast]))' swrEvents(:,good([slow fast]))']);
swrsort = speedsort(:,182:end);
speedsort = speedsort(:,2:181);

%swrsort = sortrows([meanspd3190([slow fast])'

figure(20); clf; 
subplot(24,2,1:18);
imagesc(speedsort(1:length(slow),:)); caxis([0 60]); set(gca,'XTick',[],'YTick',[]);
ylabel('Slow Trials (sorted by speed)');
subplot(24,2,19:28);
imagesc(speedsort((length(slow)+1):end,:)); caxis([0 60]); set(gca,'XTick',[],'YTick',[]);
ylabel('Fast Trials');
%subplot(24,2,1:28);
%imagesc(speedsort); caxis([0 50]); set(gca,'XTick',[],'YTick',[]);
subplot(24,2,29:38);
plot((-3+(1/30)):(1/30):3,mean([speedPre(:,good(fast))' speedDist(:,good(fast))']));  set(gca,'YLim',[0 60]); xlabel('Time (s)'); ylabel('Speed (cm/s)');
hold on; plot((-3+(1/30)):(1/30):3,mean([speedPre(:,good(slow))' speedDist(:,good(slow))'])); set(gca,'XLim',[-3 3]);
legend('fast','slow','Location','northwest');
subplot(24,2,[43 45 47]); slowswr=histogram(swrnum(slow),'FaceColor',[1 0 0]); axis tight; set(gca,'XLim',[-.5 8]); xlabel('SWR count'); title(num2str(slowpd.lambda));
subplot(24,2,[44 46 48]); fastswr=histogram(swrnum(fast)); axis tight; set(gca,'XLim',[-.5 8]); xlabel(['p=' num2str(pval)]); title(num2str(fastpd.lambda));


binedges=.5:5:90.5;
maxy=6;
swrt=[];
fastheat=[];
for i=1:length(fast)
    swrt=[swrt; find(swrEvents(:,fast(i)))];
    temp=histogram(find(swrsort(length(slow)+i,:)),binedges);
    fastheat=[fastheat; temp.Values];
end
swrf=histogram(swrt(:),binedges); 

nswrf=30*swrf.Values/length(fast);
figure(102); clf;
subplot(24,2,[46:2:48]); bar(nswrf,1); axis tight;
set(gca,'YLim',[0 maxy]);

swrt=[];
slowheat=[];
for i=1:length(slow)
    swrt=[swrt; find(swrEvents(:,slow(i)))];
    temp=histogram(find(swrsort(i,:)),binedges);
    slowheat=[slowheat; temp.Values];
end
subplot(24,2,45:2:47); 
swrs=histogram(swrt(:),binedges);
        
nswrs=30*swrs.Values/length(slow);
figure(102); 
bar(nswrs,1); axis tight;
set(gca,'YLim',[0 maxy]);

subplot(24,2,[1:2:43]);
imagesc(slowheat); set(gca,'XTick',[]);
subplot(24,2,[16:2:44]);
imagesc(fastheat); set(gca,'XTick',[]);


slowcounts=sum(slowheat(:,1:9)');
fastcounts=sum(fastheat(:,1:9)');
[nanmean(slowcounts(find(slowcounts>0))) nanmean(fastcounts(find(fastcounts>0)))]

[h,p]=ttest2((slowcounts(find(slowcounts>0))),(fastcounts(find(fastcounts>0))))

subplot(24,2,[46:2:48]); bar(sum(fastheat)/length(fast),1); axis tight;
set(gca,'YLim',[0 .2]);
subplot(24,2,[45:2:47]); bar(sum(slowheat)/length(slow),1); axis tight;
set(gca,'YLim',[0 .2]);

figure; hold on; [ff,bb]=histcounts(slowcounts, 0:10); plot(ff./sum(ff)); [ff,bb]=histcounts(fastcounts, 0:10); plot(ff./sum(ff));



figure; hold on; histogram(slowcounts, 0:6, 'Normalization', 'pdf');  histogram(fastcounts, 0:6, 'Normalization',  'pdf');
legend('slow','fast'); xlabel('SWR events, prior 3s'); ylabel('probability')


plot(ff./sum(ff)); [ff,bb]=histcounts(fastcounts, 0:10); plot(ff./sum(ff));
