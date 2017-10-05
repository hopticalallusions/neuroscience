%function [cmean cvar] = LSTM_v_Acausal( inputdata, out1, out2, srate, dsfact, btime, etime, envthresh)

%datapath = path to CSC file (must include '\' at the end of the string)
%datach - CSC channel containing raw LFP data
%pulsech = CSC channel containing trugger pulses
%srate = sample rate for raw EEG data 
%dsfact = downsampling factor for filtered data
%btime = beginning time (in seconds) for file data
%etime = ending time (in seconds) for file data
%envthresh = envelope threshold

%    example: Causal_v_Acausal( 'C:\Users\Blair\Documents\MATLAB\theta\ThetaDemo\', 56, 65, 32000, 100, 0, 370, 0, 2000)

%read in the raw LFP data
%[data, fulltimestamps, header, channel, sampFreq, nValSamp ]=csc2mat([datapath 'CSC' num2str(datach) '.Ncs'], btime, etime*srate);

clear;

%sp1=3; sp2=4;
sp1=1; sp2=1;

figure(1); clf;
figure(2); clf;
figure(3); clf;
figure(4); clf;
figure(5); clf;
figure(6); clf;

%    seedex=[16 15 14 13 12 11 10 9 8];

%    seedex=[10]; %3x2
    seedex=[9]; %1x2
    
for seednum=1

in_320=importdata('in-ds200.txt');
train1_320=importdata('train1-ds200.txt');
train2_320=importdata('train2-ds200.txt');

%3x2
%eval(['out1_320=importdata(''C:\Users\Blair\Documents\MATLAB\theta\QuantifyPrune2\n3_' num2str(seedex(seednum)) 'bit_p03_o1.txt'');']);
%eval(['out2_320=importdata(''C:\Users\Blair\Documents\MATLAB\theta\QuantifyPrune2\n3_' num2str(seedex(seednum)) 'bit_p03_o2.txt'');']);

%1x2
%eval(['out1_320=importdata(''C:\Users\Blair\Documents\MATLAB\theta\QuantifyPrune2\n1_' num2str(seedex(seednum)) 'bit_p03_s1_o1.txt'');']);
%eval(['out2_320=importdata(''C:\Users\Blair\Documents\MATLAB\theta\QuantifyPrune2\n1_' num2str(seedex(seednum)) 'bit_p03_s1_o2.txt'');']);

%50x2
out1_320=importdata('C:\Users\Blair\Documents\MATLAB\theta\QuantifyPrune2\rat1-n50-o1.txt');
out2_320=importdata('C:\Users\Blair\Documents\MATLAB\theta\QuantifyPrune2\rat1-n50-o2.txt');

%   SEQUENTIAL
out1_320=importdata('C:\Users\Blair\Documents\MATLAB\theta\Consecutive\LSTM50_Consecutive_O1.txt');
out2_320=importdata('C:\Users\Blair\Documents\MATLAB\theta\Consecutive\LSTM50_Consecutive_O2.txt');

%biasvec_320=[0.1375/3    0.0847*0    0*0.1960/2    0*0.3183/2    0.2517/4    0.1    0.0838    0.0113   0.0243*8    0.0322*8    0.0776*3    0.1272]; %3x2 10 bit
%biasvec_320=0*[ -0.0208*4    -0.1412    -0.1969    -0.1157*2   -0.0892   -0.0636   -0.0520   0.0782   0.2957/2   0.1337/10   -0.1293   0.1388/4]; %1x2 9 bit

biasvec_320=.1*[1 1 1 1 1 1 1 1 1 2 1 1]; %50x2 floating point

biasvec_320=.1*[1 1 1 1 1 1 1 2 3 2 1 1]; %50x2 floating point sequential

%in_160=importdata('in-ds200.txt');
%train1_160=importdata('train1-ds200.txt');
%train2_160=importdata('train2-ds200.txt');
%out1_320=importdata('out1-n50-ds200.txt');
%out2_320=importdata('out2-n50-ds200.txt');

%apply acausal theta bandpass filter (butterworth) to the full resolution LFP data, take Hilbert xform, then downsample  
%[ lfpHilbert ] = lfpThetaHilbert( data, dsfact );

phout_320=angle(complex(out1_320,out2_320));
%phout_160=angle(complex(out1_160,out2_160));
phtgt_320=angle(complex(train1_320,train2_320));
%phtgt_160=angle(complex(train1_160,train2_160));

envout_320=abs(complex(out1_320,out2_320));
%envout_160=abs(complex(out1_160,out2_160));
envtgt_320=abs(complex(train1_320,train2_320));
%envtgt_160=abs(complex(train1_160,train2_160));

 ethresh=.1;
% adex180=find(phtgt_320(1:end-1)>pi*.8 & phtgt_320(2:end)<-pi*.8);
% temp=find(env(adex180)>ethresh); adex180=adex180(temp);
% adex0=find(phtgt_320(1:end-1)<0 & phtgt_320(2:end)>=0);
% temp=find(env(adex0)>ethresh); adex0=adex0(temp);
% adex90=find(phtgt_320(1:end-1)<pi/2 & phtgt_320(2:end)>=pi/2);
% temp=find(env(adex90)>ethresh); adex90=adex90(temp);
% adex270=find(phtgt_320(1:end-1)<-pi/2 & phtgt_320(2:end)>=-pi/2);
% temp=find(env(adex270)>ethresh); adex270=adex270(temp);

odex0=find(phout_320(1:end-1)<0+biasvec_320(7) & phout_320(2:end)>=0+biasvec_320(7));
i=1; temp=find(envout_320(odex0)>ethresh); odex0=odex0(temp); cm(i)=circ_mean(phtgt_320(odex0)); cv(i)=circ_var(phtgt_320(odex0)); cr(i)=circ_r(phtgt_320(odex0));
odex30=find(phout_320(1:end-1)<circ_ang2rad(30)+biasvec_320(8) & phout_320(2:end)>=circ_ang2rad(30)+biasvec_320(8));
i=2; temp=find(envout_320(odex30)>ethresh); odex30=odex30(temp); cm(i)=circ_mean(phtgt_320(odex30)); cv(i)=circ_var(phtgt_320(odex30)); cr(i)=circ_r(phtgt_320(odex30));
odex60=find(phout_320(1:end-1)<circ_ang2rad(60)+biasvec_320(9) & phout_320(2:end)>=circ_ang2rad(60)+biasvec_320(9));
i=3; temp=find(envout_320(odex60)>ethresh); odex60=odex60(temp); cm(i)=circ_mean(phtgt_320(odex60)); cv(i)=circ_var(phtgt_320(odex60)); cr(i)=circ_r(phtgt_320(odex60));
odex90=find(phout_320(1:end-1)<pi/2+biasvec_320(10) & phout_320(2:end)>=pi/2+biasvec_320(10));
i=4; temp=find(envout_320(odex90)>ethresh); odex90=odex90(temp); cm(i)=circ_mean(phtgt_320(odex90)); cv(i)=circ_var(phtgt_320(odex90)); cr(i)=circ_r(phtgt_320(odex90));
odex120=find(phout_320(1:end-1)<circ_ang2rad(120)+biasvec_320(11) & phout_320(2:end)>=circ_ang2rad(120)+biasvec_320(11));
i=5; temp=find(envout_320(odex120)>ethresh); odex120=odex120(temp); cm(i)=circ_mean(phtgt_320(odex120)); cv(i)=circ_var(phtgt_320(odex120)); cr(i)=circ_r(phtgt_320(odex120));
odex150=find(phout_320(1:end-1)<circ_ang2rad(150)+biasvec_320(12) & phout_320(2:end)>=circ_ang2rad(150)+biasvec_320(12));
i=6; temp=find(envout_320(odex150)>ethresh); odex150=odex150(temp); cm(i)=circ_mean(phtgt_320(odex150)); cv(i)=circ_var(phtgt_320(odex150)); cr(i)=circ_r(phtgt_320(odex150));
temp1=phout_320(1:end-1)+pi; temp1(find(temp1>pi))=temp1(find(temp1>pi))-2*pi;
temp2=phout_320(2:end)+pi; temp2(find(temp2>pi))=temp2(find(temp2>pi))-2*pi;
odex180=find(temp1<biasvec_320(1) & temp2>biasvec_320(1)); clear temp1 temp2;
i=7; temp=find(envout_320(odex180)>ethresh); odex180=odex180(temp); cm(i)=circ_mean(phtgt_320(odex180)); cv(i)=circ_var(phtgt_320(odex180)); cr(i)=circ_r(phtgt_320(odex180));
odex210=find(phout_320(1:end-1)<-circ_ang2rad(150)+biasvec_320(2) & phout_320(2:end)>=-circ_ang2rad(150)+biasvec_320(2));
i=8; temp=find(envout_320(odex210)>ethresh); odex210=odex210(temp); cm(i)=circ_mean(phtgt_320(odex210)); cv(i)=circ_var(phtgt_320(odex210)); cr(i)=circ_r(phtgt_320(odex210));
odex240=find(phout_320(1:end-1)<-circ_ang2rad(120)+biasvec_320(3) & phout_320(2:end)>=-circ_ang2rad(120)+biasvec_320(3));
i=9; temp=find(envout_320(odex240)>ethresh); odex240=odex240(temp); cm(i)=circ_mean(phtgt_320(odex240)); cv(i)=circ_var(phtgt_320(odex240)); cr(i)=circ_r(phtgt_320(odex240));
odex270=find(phout_320(1:end-1)<-pi/2+biasvec_320(4) & phout_320(2:end)>=-pi/2+biasvec_320(4));
i=10; temp=find(envout_320(odex270)>ethresh); odex270=odex270(temp); cm(i)=circ_mean(phtgt_320(odex270)); cv(i)=circ_var(phtgt_320(odex270)); cr(i)=circ_r(phtgt_320(odex270));
odex300=find(phout_320(1:end-1)<-circ_ang2rad(60)+biasvec_320(5) & phout_320(2:end)>=-circ_ang2rad(60)+biasvec_320(5));
i=11; temp=find(envout_320(odex300)>ethresh); odex300=odex300(temp); cm(i)=circ_mean(phtgt_320(odex300)); cv(i)=circ_var(phtgt_320(odex300)); cr(i)=circ_r(phtgt_320(odex300));
odex330=find(phout_320(1:end-1)<-circ_ang2rad(30)+biasvec_320(6) & phout_320(2:end)>=-circ_ang2rad(30)+biasvec_320(6));
i=12; temp=find(envout_320(odex330)>ethresh); odex330=odex330(temp); cm(i)=circ_mean(phtgt_320(odex330)); cv(i)=circ_var(phtgt_320(odex330)); cr(i)=circ_r(phtgt_320(odex330));

envout_320z=(envout_320-mean(envout_320))/std(envout_320);
envtgt_320z=(envtgt_320-mean(envtgt_320))/std(envtgt_320);
enverr_320=envout_320z-envtgt_320z;

 figure(1); subplot(sp1,sp2,seednum);
 temp=histc(phtgt_320(odex0),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt_320(odex90),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt_320(odex180),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp');
 temp=histc(phtgt_320(odex270),-pi:pi/30:pi); temp(1:end-1)=temp(1:end-1)/sum(temp(1:end-1)); temp(end)=temp(1); hold on; polar((-pi:pi/30:pi)+pi/60,temp');
 
 
 figure(2); subplot(sp1,sp2,seednum); hold off; 
 errorbar(0:30:360,[circ_rad2ang(cm(1:6)) circ_rad2ang(cm(7)) circ_rad2ang(cm(8:12))+360 circ_rad2ang(cm(1))+360],[circ_rad2ang(cv(1:6)) circ_rad2ang(cv(7:12)) circ_rad2ang(cv(1))],'o-k');
 hold on; line([0 360],[0 360]);
 
 
 figure(3); subplot(sp1,sp2,seednum); 
 polar([-pi:pi/6:pi],[(cr(1:6)) (cr(7:12)) (cr(1))]);

out1_320z=(out1_320-mean(out1_320))/std(out1_320);
zzz=(train1_320-mean(train1_320))/std(train1_320);
sigerr_320=out1_320z-zzz; 

 figure(4); subplot(sp1,sp2,seednum); a=histogram(sigerr_320); %subplot(2,1,2); histogram(enverr_160); set(gca,'XLim',[-.4 .5]);
 figure(5); subplot(sp1,sp2,seednum); b=histogram(enverr_320); %subplot(2,1,2); histogram(enverr_160); set(gca,'XLim',[-.4 .5]);

 figure(44); hold on; plot(a.BinEdges(1:end-1)+a.BinWidth/2,a.Values/sum(a.Values));
 figure(55); hold on; plot(b.BinEdges(1:end-1)+b.BinWidth/2,b.Values/sum(b.Values));
 
err_sigmean(seednum)=mean(sigerr_320);
err_sigvar(seednum)=std(sigerr_320)^2;
err_envmean(seednum)=mean(enverr_320);
err_envvar(seednum)=std(enverr_320)^2;

err_ph320(seednum,1:12)=cv; %ac_ph320(3,1:12)=cv_160;

figure(6); subplot(sp1,sp2,seednum); polar([-pi:pi/6:pi],[err_ph320(seednum,:) err_ph320(seednum,1)]);

figure(66); hold on; polar([-pi:pi/6:pi],[err_ph320(seednum,:) err_ph320(seednum,1)]);

err_deg(seednum)=mean(err_ph320(seednum,:));

end

figure(10); subplot(2,2,1);
bar(err_deg); %set(gca,'YLim',[0 max(err_sigmean)]); 
subplot(2,2,2);
bar(err_sigvar);  set(gca,'YLim',[0 max(err_sigvar)]); 
subplot(2,2,3);
bar(err_envmean); %set(gca,'YLim',[0 max(err_envmean)]); 
subplot(2,2,4);
bar(err_envvar); set(gca,'YLim',[0 max(err_envvar)]);  

err_ph320(seednum,1:12)=cv; %ac_ph320(3,1:12)=cv_160;

%figure(6); subplot(sp1,sp2,seednum); polar([-pi:pi/6:pi],[err_ph320(seednum,:) err_ph320(seednum,1)]);