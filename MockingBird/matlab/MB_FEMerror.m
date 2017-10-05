function phase_error = MB_FEMerror( target_output, actual_output, biasvec )

% This function compares the target versus actual output of a MockingBird
% FEM, and generates several error measures from the comparison. The target
% and actual output vectors are z-score normalized before the comparison is
% made, obviating the need to wory about whether they are matched in scale.

%%% ARGUMENTS:
% target_output = name of the complex vector containing the target output data
% actual_output = name of the complex vector containing the actual output data
% biasvec = an optional list of 12 angular values (in radians) which, if
% supplied, are used to shift the target phase in 30 degree intervals; this
% bias vector provides a way to check whether adding a constant phase bias
% can correct a constant bias in phase estimation by th FEM
 
%%% RETURN VALUES:
% phase error = returns 0 if output was successfully stored the specified FEM file 

if nargin<3
    biasvec=0*[1 1 1 1 1 1 1 1 1 2 1 1]; %50x2 floating point
end

figure(2); clf; 

%perform z-score normalization on both vectors (use real component to obtain the normalization factors)
real_mu = mean(real(target_output)); real_std = std(real(target_output));
imag_mu = mean(imag(target_output)); imag_std = std(imag(target_output));
target_output = complex((real(target_output) - real_mu)/real_std,(imag(target_output) - imag_mu)/imag_std);
real_mu = mean(real(actual_output)); real_std = std(real(actual_output));
imag_mu = mean(imag(actual_output)); imag_std = std(imag(actual_output));
actual_output = complex((real(actual_output) - real_mu)/real_std,(imag(actual_output) - imag_mu)/imag_std);

subplot(4,3,1:3); 
plot(real(actual_output)); hold on; plot(real(target_output));
ylabel('Z-Score'); title('Real Component {\color{red}target \color{black}vs \color{blue}actual}');
subplot(4,3,4:6); 
plot(imag(actual_output)); hold on; plot(imag(target_output));
ylabel('Z-Score'); title('Imaginary Component {\color{red}target \color{black}vs \color{blue}actual}');

%raw signal error
real_sqerr = real(target_output)-real(actual_output);
imag_sqerr = imag(target_output)-imag(actual_output);
subplot(4,3,7); hold off;
h1=histogram(real_sqerr,32);
tempx1=h1.BinEdges(1:end-1)+(h1.BinEdges(2)-h1.BinEdges(1))/2;
tempy1=h1.Values;
h2=histogram(imag_sqerr,32);
tempx2=h2.BinEdges(1:end-1)+(h2.BinEdges(2)-h2.BinEdges(1))/2;
tempy2=h2.Values;
subplot(4,3,7); hold off;
plot(tempx1,tempy1,'b-');
hold on;
plot(tempx2,tempy2,'r-');
xlabel('target-actual'); ylabel('sample count'); title('Raw Signal Error');
legend('real','imag');

%envelope error
env_err = abs(target_output)-abs(actual_output);
subplot(4,3,8); hold off;
h=histogram(env_err,32);
tempx=h.BinEdges(1:end-1)+(h.BinEdges(2)-h.BinEdges(1))/2;
tempy=h.Values;
subplot(4,3,8); hold off;
plot(tempx,tempy,'k-');
xlabel('target-actual'); ylabel('sample count'); title('Envelope Error');
%sqerr= sqerr.^2;

%phase error
phout=angle(actual_output);
phtgt=angle(target_output);

envout=abs(actual_output);
envtgt=abs(target_output);
ethresh=.1;

odex0=find(phout(1:end-1)<0+biasvec(7) & phout(2:end)>=0+biasvec(7));
i=1; temp=find(envout(odex0)>ethresh); odex0=odex0(temp); cm(i)=circ_mean(phtgt(odex0)); cv(i)=circ_var(phtgt(odex0)); cr(i)=circ_r(phtgt(odex0));
odex30=find(phout(1:end-1)<circ_ang2rad(30)+biasvec(8) & phout(2:end)>=circ_ang2rad(30)+biasvec(8));
i=2; temp=find(envout(odex30)>ethresh); odex30=odex30(temp); cm(i)=circ_mean(phtgt(odex30)); cv(i)=circ_var(phtgt(odex30)); cr(i)=circ_r(phtgt(odex30));
odex60=find(phout(1:end-1)<circ_ang2rad(60)+biasvec(9) & phout(2:end)>=circ_ang2rad(60)+biasvec(9));
i=3; temp=find(envout(odex60)>ethresh); odex60=odex60(temp); cm(i)=circ_mean(phtgt(odex60)); cv(i)=circ_var(phtgt(odex60)); cr(i)=circ_r(phtgt(odex60));
odex90=find(phout(1:end-1)<pi/2+biasvec(10) & phout(2:end)>=pi/2+biasvec(10));
i=4; temp=find(envout(odex90)>ethresh); odex90=odex90(temp); cm(i)=circ_mean(phtgt(odex90)); cv(i)=circ_var(phtgt(odex90)); cr(i)=circ_r(phtgt(odex90));
odex120=find(phout(1:end-1)<circ_ang2rad(120)+biasvec(11) & phout(2:end)>=circ_ang2rad(120)+biasvec(11));
i=5; temp=find(envout(odex120)>ethresh); odex120=odex120(temp); cm(i)=circ_mean(phtgt(odex120)); cv(i)=circ_var(phtgt(odex120)); cr(i)=circ_r(phtgt(odex120));
odex150=find(phout(1:end-1)<circ_ang2rad(150)+biasvec(12) & phout(2:end)>=circ_ang2rad(150)+biasvec(12));
i=6; temp=find(envout(odex150)>ethresh); odex150=odex150(temp); cm(i)=circ_mean(phtgt(odex150)); cv(i)=circ_var(phtgt(odex150)); cr(i)=circ_r(phtgt(odex150));
temp1=phout(1:end-1)+pi; temp1(find(temp1>pi))=temp1(find(temp1>pi))-2*pi;
temp2=phout(2:end)+pi; temp2(find(temp2>pi))=temp2(find(temp2>pi))-2*pi;
odex180=find(temp1<biasvec(1) & temp2>biasvec(1)); clear temp1 temp2;
i=7; temp=find(envout(odex180)>ethresh); odex180=odex180(temp); cm(i)=circ_mean(phtgt(odex180)); cv(i)=circ_var(phtgt(odex180)); cr(i)=circ_r(phtgt(odex180));
odex210=find(phout(1:end-1)<-circ_ang2rad(150)+biasvec(2) & phout(2:end)>=-circ_ang2rad(150)+biasvec(2));
i=8; temp=find(envout(odex210)>ethresh); odex210=odex210(temp); cm(i)=circ_mean(phtgt(odex210)); cv(i)=circ_var(phtgt(odex210)); cr(i)=circ_r(phtgt(odex210));
odex240=find(phout(1:end-1)<-circ_ang2rad(120)+biasvec(3) & phout(2:end)>=-circ_ang2rad(120)+biasvec(3));
i=9; temp=find(envout(odex240)>ethresh); odex240=odex240(temp); cm(i)=circ_mean(phtgt(odex240)); cv(i)=circ_var(phtgt(odex240)); cr(i)=circ_r(phtgt(odex240));
odex270=find(phout(1:end-1)<-pi/2+biasvec(4) & phout(2:end)>=-pi/2+biasvec(4));
i=10; temp=find(envout(odex270)>ethresh); odex270=odex270(temp); cm(i)=circ_mean(phtgt(odex270)); cv(i)=circ_var(phtgt(odex270)); cr(i)=circ_r(phtgt(odex270));
odex300=find(phout(1:end-1)<-circ_ang2rad(60)+biasvec(5) & phout(2:end)>=-circ_ang2rad(60)+biasvec(5));
i=11; temp=find(envout(odex300)>ethresh); odex300=odex300(temp); cm(i)=circ_mean(phtgt(odex300)); cv(i)=circ_var(phtgt(odex300)); cr(i)=circ_r(phtgt(odex300));
odex330=find(phout(1:end-1)<-circ_ang2rad(30)+biasvec(6) & phout(2:end)>=-circ_ang2rad(30)+biasvec(6));
i=12; temp=find(envout(odex330)>ethresh); odex330=odex330(temp); cm(i)=circ_mean(phtgt(odex330)); cv(i)=circ_var(phtgt(odex330)); cr(i)=circ_r(phtgt(odex330));

envout_z=(envout-mean(envout))/std(envout);
envtgt_z=(envtgt-mean(envtgt))/std(envtgt);
enverr=envout_z-envtgt_z;

meanphase=[circ_rad2ang(cm(1:6)) circ_rad2ang(cm(7)) circ_rad2ang(cm(8:12))+360 circ_rad2ang(cm(1))+360];
meanphase(find(meanphase<-90))=meanphase(find(meanphase<-90))+360;
subplot(4,3,9);
 errorbar(0:30:360,meanphase,[circ_rad2ang(cv(1:6)) circ_rad2ang(cv(7:12)) circ_rad2ang(cv(1))],'.-k');
 hold on; line([0 360],[0 360]); axis tight;
xlabel('target'); ylabel('actual'); title('Phase Error (degs)');
phase_error=meanphase-[0:30:360];

subplot(4,3,10);
 temp=histc(phtgt(odex0),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt(odex90),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt(odex180),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp','g');
 temp=histc(phtgt(odex270),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp','k');
xlabel('{\color{blue}0 \color{red}90 \color{green}180} 270');

subplot(4,3,11);
 temp=histc(phtgt(odex30),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt(odex120),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt(odex210),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp','g');
 temp=histc(phtgt(odex300),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp','k');
xlabel('{\color{blue}30 \color{red}120 \color{green}210} 300');
 
subplot(4,3,12);
 temp=histc(phtgt(odex60),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt(odex150),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt(odex240),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp','g');
 temp=histc(phtgt(odex330),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp','k');
xlabel('{\color{blue}60 \color{red}150 \color{green}240} 330');

%figure(2); histogram(sqerr); 

