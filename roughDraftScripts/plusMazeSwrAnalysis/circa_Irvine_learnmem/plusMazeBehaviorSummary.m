M = csvread(filename)
M = csvread(filename,R1,C1)
M = csvread(filename,R1,C1,[R1 C1 R2 C2])
load fisheriris
s1 = meas(51:100,3);
s2 = meas(101:150,3);
Create a box plot using the sample data. Include a notch on the plot and label each box with the name of the iris species it represents.

figure;
boxplot([s1 s2],'notch','on',...
        'labels',{'versicolor','virginica'})
    

% RatNum	Trial	TrialTimeSec	WaitTimeSec	Error	WentOutOfBounds	WasForfeit	ReturnsToStart	BrickJumps	WasTeleported	ElapsedDays	Session	TrialsCompleted	Serial
% 1         2       3               4           5       6               7           8               9           10              11          12      13              14          
    
    
    
    
%behaviorData = csvread('~/data/matlabPlusMazeTrainingTrials.csv');

% *** manually import behavior data
behaviorData = matlabPlusMazeTrainingTrials;

figure; boxplot(   behaviorData(:,3), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')
ylim([0 400]);
;
aa=splitapply(@mean, behaviorData(:,5)>0, findgroups(behaviorData(:,12)));
figure; plot(1-aa); xlabel('training sessions (n)'); ylabel('proportion'); title('Proportion of Correct Trials'); ylim([ 0 1 ]); line([0 25],[.5 .5],'color','red')

figure; boxplot(   behaviorData(:,5), behaviorData(:,12), 'notch','on'); xlabel('training session'); title('trial time per training session'); ylabel('trial time (s)')



figure; histogram(behaviorData(:,12),1:24)
title('trials per training session')
ylabel('trial count (n)')
xlabel('session (days)')



return;



% there are some things missing...  like the data...
plusTrials=zeros(23,8);
plusErrors=zeros(23,8);
plusTrialTimes=zeros(23,8);
figure; plot(plusTrials)
figure;
subplot(3,1,1); plot(plusTrials); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,2); plot(plusErrors); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,3); plot(plusTrialTimes); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,1); plot(plusTrials); title('trials'); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,2); plot(plusErrors); title('errors'); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
subplot(3,1,3); plot(plusTrialTimes); title('mean trial times'); axis tight; legend('bh1','bh2','bh3','bh4','da10','da12','da5','da8');
figure;
subplot(3,1,1); plot(plusTrials(:,7)); title('trials'); axis tight;
subplot(3,1,2); plot(plusErrors(:,7)); title('errors'); axis tight;
subplot(3,1,3); plot(plusTrialTimes(:,7)); title('mean trial times'); axis tight;
figure;  % da5
subplot(3,1,1); plot(plusTrials(1:13,7)); title('trials'); axis tight;
subplot(3,1,2); plot(plusErrors(1:13,7)); title('errors'); axis tight;
subplot(3,1,3); plot(plusTrialTimes(1:13,7)); title('mean trial times'); axis tight;
figure;  % da5
subplot(3,1,1); plot(plusTrials(1:13,5:8)); title('trials'); axis tight; ylim([0 20]);
subplot(3,1,2); plot(plusErrors(1:13,5:8)); title('errors'); axis tight;  ylim([0 20]);
subplot(3,1,3); plot(plusTrialTimes(1:13,5:8)); title('mean trial times'); axis tight; ylim([0 200]);
figure;  % da5
subplot(3,1,1); plot(plusTrials(1:13,5:8)); title('trials'); axis tight; ylim([0 20]);
subplot(3,1,2); plot(plusErrors(1:13,5:8)./plusTrials(1:13,5:8)); title('errors'); axis tight;  ylim([0 1]);
subplot(3,1,3); plot(plusTrialTimes(1:13,5:8)); title('mean trial times'); axis tight; ylim([0 85]);
legend('da10','da12','da5','da8');
da5=zeros(121,6);
figure; % da5
subplot(5,1,1); plot(da5(:,1), da5(:,2)); legend('trial time'); axis tight;
subplot(5,1,2); plot(da5(:,1), da5(:,3)); legend('error'); axis tight;
subplot(5,1,3); plot(da5(:,1), da5(:,4)); legend('probe'); axis tight;
subplot(5,1,4); plot(da5(:,1), da5(:,5)); legend('out bounds'); axis tight;
subplot(5,1,5); plot(da5(:,1), da5(:,6)); legend('brick jump'); axis tight;
subplot(5,1,1); plot(da5(:,1), da5(:,2), '*-' ); legend('trial time'); axis tight;
subplot(5,1,2); plot(da5(:,1), da5(:,3), '*-' ); legend('error'); axis tight;
subplot(5,1,3); plot(da5(:,1), da5(:,4), '*-' ); legend('probe'); axis tight;
subplot(5,1,4); plot(da5(:,1), da5(:,5), '*-' ); legend('out bounds'); axis tight;
subplot(5,1,5); plot(da5(:,1), da5(:,6), '*-' ); legend('brick jump'); axis tight;
bh1=zeros(188,9);
bh2=zeros(146,9);
bh3=zeros(188,9);
bh4=zeros(177,9);
da5=zeros(121,9);
da8=zeros(44,9);
da10=zeros(78,9);
da12=zeros(76,9);
figure; % bh1
subplot(8,1,1); plot(bh1(:,1), bh1(:,2) );  hold on; plot(bh1(:,1), bh1(:,2), 'o' ); title('bh1'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh1(:,1), bh1(:,3) );  hold on; plot(bh1(:,1), bh1(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh1(:,1), bh1(:,4) );  hold on; plot(bh1(:,1), bh1(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,5) );  hold on; plot(bh1(:,1), bh1(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,6) );  hold on; plot(bh1(:,1), bh1(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh1(:,1), bh1(:,7) );  hold on; plot(bh1(:,1), bh1(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh1(:,1), bh1(:,8) );  hold on; plot(bh1(:,1), bh1(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh1(:,1), bh1(:,9) );  hold on; plot(bh1(:,1), bh1(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh2
subplot(8,1,1); plot(bh2(:,1), bh2(:,2) );  hold on; plot(bh2(:,1), bh2(:,2), 'o' ); title('bh2'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh2(:,1), bh2(:,3) );  hold on; plot(bh2(:,1), bh2(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh2(:,1), bh2(:,4) );  hold on; plot(bh2(:,1), bh2(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,5) );  hold on; plot(bh2(:,1), bh2(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,6) );  hold on; plot(bh2(:,1), bh2(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh2(:,1), bh2(:,7) );  hold on; plot(bh2(:,1), bh2(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh2(:,1), bh2(:,8) );  hold on; plot(bh2(:,1), bh2(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh2(:,1), bh2(:,9) );  hold on; plot(bh2(:,1), bh2(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh3
subplot(8,1,1); plot(bh3(:,1), bh3(:,2) );  hold on; plot(bh3(:,1), bh3(:,2), 'o' ); title('bh3'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh3(:,1), bh3(:,3) );  hold on; plot(bh3(:,1), bh3(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh3(:,1), bh3(:,4) );  hold on; plot(bh3(:,1), bh3(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,5) );  hold on; plot(bh3(:,1), bh3(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,6) );  hold on; plot(bh3(:,1), bh3(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh3(:,1), bh3(:,7) );  hold on; plot(bh3(:,1), bh3(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh3(:,1), bh3(:,8) );  hold on; plot(bh3(:,1), bh3(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh3(:,1), bh3(:,9) );  hold on; plot(bh3(:,1), bh3(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh4
subplot(8,1,1); plot(bh4(:,1), bh4(:,2) );  hold on; plot(bh4(:,1), bh4(:,2), 'o' ); title('bh4'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh4(:,1), bh4(:,3) );  hold on; plot(bh4(:,1), bh4(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(bh4(:,1), bh4(:,4) );  hold on; plot(bh4(:,1), bh4(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,5) );  hold on; plot(bh4(:,1), bh4(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,6) );  hold on; plot(bh4(:,1), bh4(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh4(:,1), bh4(:,7) );  hold on; plot(bh4(:,1), bh4(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh4(:,1), bh4(:,8) );  hold on; plot(bh4(:,1), bh4(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(bh4(:,1), bh4(:,9) );  hold on; plot(bh4(:,1), bh4(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da5
subplot(8,1,1); plot(da5(:,1), da5(:,2) );  hold on; plot(da5(:,1), da5(:,2), 'o' ); title('da5'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da5(:,1), da5(:,3) );  hold on; plot(da5(:,1), da5(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da5(:,1), da5(:,4) );  hold on; plot(da5(:,1), da5(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,5) );  hold on; plot(da5(:,1), da5(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,6) );  hold on; plot(da5(:,1), da5(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da5(:,1), da5(:,7) );  hold on; plot(da5(:,1), da5(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da5(:,1), da5(:,8) );  hold on; plot(da5(:,1), da5(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da5(:,1), da5(:,9) );  hold on; plot(da5(:,1), da5(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da8
subplot(8,1,1); plot(da8(:,1), da8(:,2) );  hold on; plot(da8(:,1), da8(:,2), 'o' ); title('da8'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da8(:,1), da8(:,3) );  hold on; plot(da8(:,1), da8(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da8(:,1), da8(:,4) );  hold on; plot(da8(:,1), da8(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,5) );  hold on; plot(da8(:,1), da8(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,6) );  hold on; plot(da8(:,1), da8(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da8(:,1), da8(:,7) );  hold on; plot(da8(:,1), da8(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da8(:,1), da8(:,8) );  hold on; plot(da8(:,1), da8(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da8(:,1), da8(:,9) );  hold on; plot(da8(:,1), da8(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da10
subplot(8,1,1); plot(da10(:,1), da10(:,2) );  hold on; plot(da10(:,1), da10(:,2), 'o' ); title('da10'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da10(:,1), da10(:,3) );  hold on; plot(da10(:,1), da10(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da10(:,1), da10(:,4) );  hold on; plot(da10(:,1), da10(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,5) );  hold on; plot(da10(:,1), da10(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,6) );  hold on; plot(da10(:,1), da10(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da10(:,1), da10(:,7) );  hold on; plot(da10(:,1), da10(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da10(:,1), da10(:,8) );  hold on; plot(da10(:,1), da10(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da10(:,1), da10(:,9) );  hold on; plot(da10(:,1), da10(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % da12
subplot(8,1,1); plot(da12(:,1), da12(:,2) );  hold on; plot(da12(:,1), da12(:,2), 'o' ); title('da12'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da12(:,1), da12(:,3) );  hold on; plot(da12(:,1), da12(:,3), 'o' ); hold off;legend('trial time'); legend('wait time'); axis tight;
subplot(8,1,3); plot(da12(:,1), da12(:,4) );  hold on; plot(da12(:,1), da12(:,4), 'o' ); hold off;legend('trial time'); legend('errors'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,5) );  hold on; plot(da12(:,1), da12(:,5), 'o' ); hold off;legend('trial time'); legend('probe'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,6) );  hold on; plot(da12(:,1), da12(:,6), 'o' ); hold off;legend('trial time'); legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da12(:,1), da12(:,7) );  hold on; plot(da12(:,1), da12(:,7), 'o' ); hold off;legend('trial time'); legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da12(:,1), da12(:,8) );  hold on; plot(da12(:,1), da12(:,8), 'o' ); hold off;legend('trial time'); legend('return to start'); axis tight;
subplot(8,1,8); plot(da12(:,1), da12(:,9) );  hold on; plot(da12(:,1), da12(:,9), 'o' ); hold off;legend('trial time'); legend('teleports'); axis tight;
figure; % bh1
subplot(8,1,1); plot(bh1(:,1), bh1(:,2) );  hold on; plot(bh1(:,1), bh1(:,2), 'o' ); title('bh1'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh1(:,1), bh1(:,3) );  hold on; plot(bh1(:,1), bh1(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh1(:,1), bh1(:,4) );  hold on; plot(bh1(:,1), bh1(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,5) );  hold on; plot(bh1(:,1), bh1(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,6) );  hold on; plot(bh1(:,1), bh1(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh1(:,1), bh1(:,7) );  hold on; plot(bh1(:,1), bh1(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh1(:,1), bh1(:,8) );  hold on; plot(bh1(:,1), bh1(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh1(:,1), bh1(:,9) );  hold on; plot(bh1(:,1), bh1(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh2
subplot(8,1,1); plot(bh2(:,1), bh2(:,2) );  hold on; plot(bh2(:,1), bh2(:,2), 'o' ); title('bh2'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh2(:,1), bh2(:,3) );  hold on; plot(bh2(:,1), bh2(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh2(:,1), bh2(:,4) );  hold on; plot(bh2(:,1), bh2(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,5) );  hold on; plot(bh2(:,1), bh2(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,6) );  hold on; plot(bh2(:,1), bh2(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh2(:,1), bh2(:,7) );  hold on; plot(bh2(:,1), bh2(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh2(:,1), bh2(:,8) );  hold on; plot(bh2(:,1), bh2(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh2(:,1), bh2(:,9) );  hold on; plot(bh2(:,1), bh2(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh3
subplot(8,1,1); plot(bh3(:,1), bh3(:,2) );  hold on; plot(bh3(:,1), bh3(:,2), 'o' ); title('bh3'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh3(:,1), bh3(:,3) );  hold on; plot(bh3(:,1), bh3(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh3(:,1), bh3(:,4) );  hold on; plot(bh3(:,1), bh3(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,5) );  hold on; plot(bh3(:,1), bh3(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,6) );  hold on; plot(bh3(:,1), bh3(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh3(:,1), bh3(:,7) );  hold on; plot(bh3(:,1), bh3(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh3(:,1), bh3(:,8) );  hold on; plot(bh3(:,1), bh3(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh3(:,1), bh3(:,9) );  hold on; plot(bh3(:,1), bh3(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh4
subplot(8,1,1); plot(bh4(:,1), bh4(:,2) );  hold on; plot(bh4(:,1), bh4(:,2), 'o' ); title('bh4'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh4(:,1), bh4(:,3) );  hold on; plot(bh4(:,1), bh4(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh4(:,1), bh4(:,4) );  hold on; plot(bh4(:,1), bh4(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,5) );  hold on; plot(bh4(:,1), bh4(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,6) );  hold on; plot(bh4(:,1), bh4(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(bh4(:,1), bh4(:,7) );  hold on; plot(bh4(:,1), bh4(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh4(:,1), bh4(:,8) );  hold on; plot(bh4(:,1), bh4(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh4(:,1), bh4(:,9) );  hold on; plot(bh4(:,1), bh4(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da5
subplot(8,1,1); plot(da5(:,1), da5(:,2) );  hold on; plot(da5(:,1), da5(:,2), 'o' ); title('da5'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da5(:,1), da5(:,3) );  hold on; plot(da5(:,1), da5(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da5(:,1), da5(:,4) );  hold on; plot(da5(:,1), da5(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,5) );  hold on; plot(da5(:,1), da5(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,6) );  hold on; plot(da5(:,1), da5(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da5(:,1), da5(:,7) );  hold on; plot(da5(:,1), da5(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da5(:,1), da5(:,8) );  hold on; plot(da5(:,1), da5(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da5(:,1), da5(:,9) );  hold on; plot(da5(:,1), da5(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da8
subplot(8,1,1); plot(da8(:,1), da8(:,2) );  hold on; plot(da8(:,1), da8(:,2), 'o' ); title('da8'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da8(:,1), da8(:,3) );  hold on; plot(da8(:,1), da8(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da8(:,1), da8(:,4) );  hold on; plot(da8(:,1), da8(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,5) );  hold on; plot(da8(:,1), da8(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,6) );  hold on; plot(da8(:,1), da8(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da8(:,1), da8(:,7) );  hold on; plot(da8(:,1), da8(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da8(:,1), da8(:,8) );  hold on; plot(da8(:,1), da8(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da8(:,1), da8(:,9) );  hold on; plot(da8(:,1), da8(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da10
subplot(8,1,1); plot(da10(:,1), da10(:,2) );  hold on; plot(da10(:,1), da10(:,2), 'o' ); title('da10'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da10(:,1), da10(:,3) );  hold on; plot(da10(:,1), da10(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da10(:,1), da10(:,4) );  hold on; plot(da10(:,1), da10(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,5) );  hold on; plot(da10(:,1), da10(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,6) );  hold on; plot(da10(:,1), da10(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da10(:,1), da10(:,7) );  hold on; plot(da10(:,1), da10(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da10(:,1), da10(:,8) );  hold on; plot(da10(:,1), da10(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da10(:,1), da10(:,9) );  hold on; plot(da10(:,1), da10(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da12
subplot(8,1,1); plot(da12(:,1), da12(:,2) );  hold on; plot(da12(:,1), da12(:,2), 'o' ); title('da12'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da12(:,1), da12(:,3) );  hold on; plot(da12(:,1), da12(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da12(:,1), da12(:,4) );  hold on; plot(da12(:,1), da12(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,5) );  hold on; plot(da12(:,1), da12(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,6) );  hold on; plot(da12(:,1), da12(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,5); plot(da12(:,1), da12(:,7) );  hold on; plot(da12(:,1), da12(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da12(:,1), da12(:,8) );  hold on; plot(da12(:,1), da12(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da12(:,1), da12(:,9) );  hold on; plot(da12(:,1), da12(:,9), 'o' ); hold off; legend('teleports'); axis tight;
close all;
figure; % bh1
subplot(8,1,1); plot(bh1(:,1), bh1(:,2) );  hold on; plot(bh1(:,1), bh1(:,2), 'o' ); title('bh1'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh1(:,1), bh1(:,3) );  hold on; plot(bh1(:,1), bh1(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh1(:,1), bh1(:,4) );  hold on; plot(bh1(:,1), bh1(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh1(:,1), bh1(:,5) );  hold on; plot(bh1(:,1), bh1(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh1(:,1), bh1(:,6) );  hold on; plot(bh1(:,1), bh1(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh1(:,1), bh1(:,7) );  hold on; plot(bh1(:,1), bh1(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh1(:,1), bh1(:,8) );  hold on; plot(bh1(:,1), bh1(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh1(:,1), bh1(:,9) );  hold on; plot(bh1(:,1), bh1(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh2
subplot(8,1,1); plot(bh2(:,1), bh2(:,2) );  hold on; plot(bh2(:,1), bh2(:,2), 'o' ); title('bh2'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh2(:,1), bh2(:,3) );  hold on; plot(bh2(:,1), bh2(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh2(:,1), bh2(:,4) );  hold on; plot(bh2(:,1), bh2(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh2(:,1), bh2(:,5) );  hold on; plot(bh2(:,1), bh2(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh2(:,1), bh2(:,6) );  hold on; plot(bh2(:,1), bh2(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh2(:,1), bh2(:,7) );  hold on; plot(bh2(:,1), bh2(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh2(:,1), bh2(:,8) );  hold on; plot(bh2(:,1), bh2(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh2(:,1), bh2(:,9) );  hold on; plot(bh2(:,1), bh2(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh3
subplot(8,1,1); plot(bh3(:,1), bh3(:,2) );  hold on; plot(bh3(:,1), bh3(:,2), 'o' ); title('bh3'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh3(:,1), bh3(:,3) );  hold on; plot(bh3(:,1), bh3(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh3(:,1), bh3(:,4) );  hold on; plot(bh3(:,1), bh3(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh3(:,1), bh3(:,5) );  hold on; plot(bh3(:,1), bh3(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh3(:,1), bh3(:,6) );  hold on; plot(bh3(:,1), bh3(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh3(:,1), bh3(:,7) );  hold on; plot(bh3(:,1), bh3(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh3(:,1), bh3(:,8) );  hold on; plot(bh3(:,1), bh3(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh3(:,1), bh3(:,9) );  hold on; plot(bh3(:,1), bh3(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % bh4
subplot(8,1,1); plot(bh4(:,1), bh4(:,2) );  hold on; plot(bh4(:,1), bh4(:,2), 'o' ); title('bh4'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(bh4(:,1), bh4(:,3) );  hold on; plot(bh4(:,1), bh4(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(bh4(:,1), bh4(:,4) );  hold on; plot(bh4(:,1), bh4(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(bh4(:,1), bh4(:,5) );  hold on; plot(bh4(:,1), bh4(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(bh4(:,1), bh4(:,6) );  hold on; plot(bh4(:,1), bh4(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(bh4(:,1), bh4(:,7) );  hold on; plot(bh4(:,1), bh4(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(bh4(:,1), bh4(:,8) );  hold on; plot(bh4(:,1), bh4(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(bh4(:,1), bh4(:,9) );  hold on; plot(bh4(:,1), bh4(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da5
subplot(8,1,1); plot(da5(:,1), da5(:,2) );  hold on; plot(da5(:,1), da5(:,2), 'o' ); title('da5'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da5(:,1), da5(:,3) );  hold on; plot(da5(:,1), da5(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da5(:,1), da5(:,4) );  hold on; plot(da5(:,1), da5(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da5(:,1), da5(:,5) );  hold on; plot(da5(:,1), da5(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da5(:,1), da5(:,6) );  hold on; plot(da5(:,1), da5(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da5(:,1), da5(:,7) );  hold on; plot(da5(:,1), da5(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da5(:,1), da5(:,8) );  hold on; plot(da5(:,1), da5(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da5(:,1), da5(:,9) );  hold on; plot(da5(:,1), da5(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da8
subplot(8,1,1); plot(da8(:,1), da8(:,2) );  hold on; plot(da8(:,1), da8(:,2), 'o' ); title('da8'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da8(:,1), da8(:,3) );  hold on; plot(da8(:,1), da8(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da8(:,1), da8(:,4) );  hold on; plot(da8(:,1), da8(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da8(:,1), da8(:,5) );  hold on; plot(da8(:,1), da8(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da8(:,1), da8(:,6) );  hold on; plot(da8(:,1), da8(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da8(:,1), da8(:,7) );  hold on; plot(da8(:,1), da8(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da8(:,1), da8(:,8) );  hold on; plot(da8(:,1), da8(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da8(:,1), da8(:,9) );  hold on; plot(da8(:,1), da8(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da10
subplot(8,1,1); plot(da10(:,1), da10(:,2) );  hold on; plot(da10(:,1), da10(:,2), 'o' ); title('da10'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da10(:,1), da10(:,3) );  hold on; plot(da10(:,1), da10(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da10(:,1), da10(:,4) );  hold on; plot(da10(:,1), da10(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da10(:,1), da10(:,5) );  hold on; plot(da10(:,1), da10(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da10(:,1), da10(:,6) );  hold on; plot(da10(:,1), da10(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da10(:,1), da10(:,7) );  hold on; plot(da10(:,1), da10(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da10(:,1), da10(:,8) );  hold on; plot(da10(:,1), da10(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da10(:,1), da10(:,9) );  hold on; plot(da10(:,1), da10(:,9), 'o' ); hold off; legend('teleports'); axis tight;
figure; % da12
subplot(8,1,1); plot(da12(:,1), da12(:,2) );  hold on; plot(da12(:,1), da12(:,2), 'o' ); title('da12'); hold off;legend('trial time'); axis tight;
subplot(8,1,2); plot(da12(:,1), da12(:,3) );  hold on; plot(da12(:,1), da12(:,3), 'o' ); hold off; legend('wait time'); axis tight;
subplot(8,1,3); plot(da12(:,1), da12(:,4) );  hold on; plot(da12(:,1), da12(:,4), 'o' ); hold off; legend('errors'); axis tight;
subplot(8,1,4); plot(da12(:,1), da12(:,5) );  hold on; plot(da12(:,1), da12(:,5), 'o' ); hold off; legend('probe'); axis tight;
subplot(8,1,5); plot(da12(:,1), da12(:,6) );  hold on; plot(da12(:,1), da12(:,6), 'o' ); hold off; legend('out of bounds'); axis tight;
subplot(8,1,6); plot(da12(:,1), da12(:,7) );  hold on; plot(da12(:,1), da12(:,7), 'o' ); hold off; legend('brick jumps'); axis tight;
subplot(8,1,7); plot(da12(:,1), da12(:,8) );  hold on; plot(da12(:,1), da12(:,8), 'o' ); hold off; legend('return to start'); axis tight;
subplot(8,1,8); plot(da12(:,1), da12(:,9) );  hold on; plot(da12(:,1), da12(:,9), 'o' ); hold off; legend('teleports'); axis tight;
