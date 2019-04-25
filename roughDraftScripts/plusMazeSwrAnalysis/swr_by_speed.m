figure; hold on; 
speedDist=saturdayData.speedDist;
swrEvents=saturdayData.swrEvents;

for ii=1:length(speedDist);
    swrnum(ii)=sum(swrEvents(:,ii));
    meanspd(ii)=mean(speedDist(:,ii));
    scatter(sum(swrEvents(:,ii)), mean((speedDist(:,ii))),'k','filled');
end
alpha(.1); xlabel('swr events (3s prior)'); ylabel('median speed (cm/s)');

slow=find(meanspd<20);
fast=find(meanspd>=20 & meanspd<50);

figure(5); clf;
histogram(meanspd,0:5:120);

figure(10);
subplot(2,1,1); slowswr=histogram(swrnum(slow));
subplot(2,1,2); 
fastswr=histogram(swrnum(fast));

slowpd=fitdist(swrnum(slow)','Poisson');
fastpd=fitdist(swrnum(fast)','Poisson');

for i=1:1000
    temp=sortrows([rand(1,length(meanspd)); swrnum]',1);
    temppd=fitdist(temp(1:length(fast),2),'Poisson');
    lambda(i)=temppd.lambda;
end

figure(6); clf; histogram(lambda,.5:.1:1.5);
c=find(lambda>fastpd.lambda);

length(c)/1000 %show significance for shuffle test
