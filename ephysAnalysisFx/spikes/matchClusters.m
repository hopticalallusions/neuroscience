function []=matchClusters( pathA, pathB )

    if strcmp(pathA,pathB)
        [ spikeWaveformsA, spikeTimestampsA, spikeHeaderA, ~, cellNumberA ] = ntt2mat(pathA);
        spikeWaveformsB = spikeWaveformsA;
        spikeTimestampsB = spikeTimestampsA;
        spikeHeaderB = spikeHeaderA;
        cellNumberB = cellNumberA;
    else
        [ spikeWaveformsA, spikeTimestampsA, spikeHeaderA, ~, cellNumberA ] = ntt2mat(pathA);
        [ spikeWaveformsB, spikeTimestampsB, spikeHeaderB, ~, cellNumberB ] = ntt2mat(pathB);
    end

    for jj=1:length(unique(cellNumberA))-1

        out=zeros(6,length(unique(cellNumberB))-1);
        %counts=histcounts(log10(diff(spikeTimestampsA (cellNumberA==jj))/1e3),-0.1:0.03:3); pdfFiring=(counts./sum(counts))';
        pdfFiring=0;
        qq=[ squeeze(median(spikeWaveformsA(cellNumberA==jj,1,:))); squeeze(median(spikeWaveformsA(cellNumberA==jj,2,:))); squeeze(median(spikeWaveformsA(cellNumberA==jj,3,:))); squeeze(median(spikeWaveformsA(cellNumberA==jj,4,:))); pdfFiring ];
        for ii=1:length(unique(cellNumberB))-1
            if ~( strcmp(pathA,pathB) && ii==jj )
                %counts=histcounts(log10(diff(spikeTimestampsB (cellNumberB==ii))/1e3),-0.1:0.03:3); pdfFiring=(counts./sum(counts))';
                ww=[ squeeze(median(spikeWaveformsB(cellNumberB==ii,1,:))); squeeze(median(spikeWaveformsB(cellNumberB==ii,2,:))); squeeze(median(spikeWaveformsB(cellNumberB==ii,3,:))); squeeze(median(spikeWaveformsB(cellNumberB==ii,4,:))); pdfFiring ];
                % xcorr and the ratio thing work for 1 channel, but fail on the concatenated verion. weird.
                % xcorr over n_samples ;; same as xcorr(qq,ww,0)/32
                %out(1,ii)=sum(qq.*ww)/length(qq);  % maximize this
                % ratio method (probably has a name, but I just sorta made it up)
                %out(2,ii)=abs(1-mean(abs(qq./ww))); % minimize this
                % Pearson Correlation;; maximize
                %out(3,ii)=(32*sum(qq.*ww)-(sum(qq)*sum(ww)) )/sqrt( (32*sum(qq.^2)-(sum(qq)^2))*(32*sum(ww.^2)-(sum(ww)^2)) );
                %out(3,ii)=abs(sum(abs(qq)-abs(ww)));
                [  corrCoefPearson,  corrPvalPearson ] = corr(qq,ww, 'Type', 'Pearson'); % max
                [  corrCoefKendall,  corrPvalKendall ] = corr(qq,ww, 'Type', 'Kendall'); % max
                [ corrCoefSpearman, corrPvalSpearman ] = corr(qq,ww, 'Type', 'Spearman'); % max
                out(:,ii) = [ corrCoefPearson,  corrPvalPearson corrCoefKendall,  corrPvalKendall  corrCoefSpearman, corrPvalSpearman ];
            else
                out(:,ii) = [ 0 1 0 1 0 1 ];
            end
        end 

        choice = zeros(1,6);
        [~,dd]=max(out(1,:));
        choice(1) = [  dd ];
        [~,dd]=min(out(2,:));
        choice(2) = [  dd ];
        [~,dd]=max(out(3,:));
        choice(3) = [  dd ];
        [~,dd]=min(out(4,:));
        choice(4) = [  dd ];
        [~,dd]=max(out(5,:));
        choice(5) = [  dd ];
        [~,dd]=min(out(6,:));
        choice(6) = [  dd ];

        disp([ 'unit ' num2str(jj) ' ' num2str(mode(choice)) ' ' num2str(sum(choice==mode(choice))/length(choice)) ' '  num2str(out(5,mode(choice))) ' ' num2str(out(6,mode(choice)))  ]);

    end

end


% 
% 
% figure; scatter(qq,ww)
% %if exist([ filepath  'TT' int2str(ttIdx) 'a.ntt' ], 'file')
% %                        if ~exist([ '~/Desktop/' rat{ratIdx} '_' (folders.(rat{ratIdx}){thisFolder}) '_theta-' strrep( thetaLfpNames.(rat{ratIdx}){thisTheta}, '.ncs', '') '_TT' int2str(ttIdx) '.mat' ], 'file' ) && skipExisting
%                             [ ~, spiketimes, spikeHeader, ~, cellNumber ]=ntt2mat([ filepath 'TT' int2str(ttIdx) 'a.ntt'  ]);
%  
%                             
% [ spikeWaveforms, spikeTimestamps, spikeHeader, ~, cellNumber ] = ntt2mat([ filepath 'TT' int2str(ttIdx) 'a.ntt'  ]);
% 
% 
% %h7_2018-08-10_
% 
% %TT15b.ntt
% 
% clear all
% [ spikeWaveformsA, spikeTimestampsA, spikeHeaderA, ~, cellNumberA ] = ntt2mat('/Volumes/AGHTHESIS2/rats/h7/2018-08-03a/TT13a.ntt');
% [ spikeWaveformsB, spikeTimestampsB, spikeHeaderB, ~, cellNumberB ] = ntt2mat('/Volumes/AGHTHESIS2/rats/h7/2018-08-03b/TT13a.ntt');
% 
% 
% 
% figure;
% for ii=1:length(unique(cellNumberA))-1
%     subplot(2,4,1); hold on; plot(1:32,squeeze(median(spikeWaveformsA(cellNumberA==ii,1,:)))); legend('1','2','3','4','5');
%     subplot(2,4,2); hold on; plot(1:32,squeeze(median(spikeWaveformsA(cellNumberA==ii,2,:)))); legend('1','2','3','4','5');
%     subplot(2,4,3); hold on; plot(1:32,squeeze(median(spikeWaveformsA(cellNumberA==ii,3,:)))); legend('1','2','3','4','5');
%     subplot(2,4,4); hold on; plot(1:32,squeeze(median(spikeWaveformsA(cellNumberA==ii,4,:)))); legend('1','2','3','4','5');
% end
% for ii=1:length(unique(cellNumberB))-1
%     subplot(2,4,5); hold on; plot(1:32,squeeze(median(spikeWaveformsB(cellNumberB==ii,1,:)))); legend('1','2','3','4','5','6','7','8','9','10');
%     subplot(2,4,6); hold on; plot(1:32,squeeze(median(spikeWaveformsB(cellNumberB==ii,2,:)))); legend('1','2','3','4','5','6','7','8','9','10');
%     subplot(2,4,7); hold on; plot(1:32,squeeze(median(spikeWaveformsB(cellNumberB==ii,3,:)))); legend('1','2','3','4','5','6','7','8','9','10');
%     subplot(2,4,8); hold on; plot(1:32,squeeze(median(spikeWaveformsB(cellNumberB==ii,4,:)))); legend('1','2','3','4','5','6','7','8','9','10');
% end 
% 
%     figure;histogram(log10(diff(spikeTimestampsA (cellNumberA==3))/1e3),-0.1:0.03:3)
%     counts=histcounts(log10(diff(spikeTimestampsA (cellNumberA==3))/1e3),-0.1:0.03:3); pdfFiring=(counts./sum(counts))';
%     
%     figure; plot(counts)
% 
% 
% 
%     
%     
%     
%     
%             [ spikeWaveformsA, spikeTimestampsA, spikeHeaderA, ~, cellNumberA ] = ntt2mat('/Volumes/AGHTHESIS2/rats/h7/2018-08-03a/TT13a.ntt');
%         [ spikeWaveformsB, spikeTimestampsB, spikeHeaderB, ~, cellNumberB ] = ntt2mat('/Volumes/AGHTHESIS2/rats/h7/2018-08-03b/TT13a.ntt');
% 
%     for jj=1:length(unique(cellNumberA))-1
% 
%         out=zeros(6,10);
%         %counts=histcounts(log10(diff(spikeTimestampsA (cellNumberA==jj))/1e3),-0.1:0.03:3); pdfFiring=(counts./sum(counts))';
%         pdfFiring=0;
%         qq=[ squeeze(median(spikeWaveformsA(cellNumberA==jj,1,:))); squeeze(median(spikeWaveformsA(cellNumberA==jj,2,:))); squeeze(median(spikeWaveformsA(cellNumberA==jj,3,:))); squeeze(median(spikeWaveformsA(cellNumberA==jj,4,:))); pdfFiring ];
%         for ii=1:length(unique(cellNumberB))-1
%             %counts=histcounts(log10(diff(spikeTimestampsB (cellNumberB==ii))/1e3),-0.1:0.03:3); pdfFiring=(counts./sum(counts))';
%             ww=[ squeeze(median(spikeWaveformsB(cellNumberB==ii,1,:))); squeeze(median(spikeWaveformsB(cellNumberB==ii,2,:))); squeeze(median(spikeWaveformsB(cellNumberB==ii,3,:))); squeeze(median(spikeWaveformsB(cellNumberB==ii,4,:))); pdfFiring ];
%             % xcorr and the ratio thing work for 1 channel, but fail on the concatenated verion. weird.
%             % xcorr over n_samples ;; same as xcorr(qq,ww,0)/32
%             %out(1,ii)=sum(qq.*ww)/length(qq);  % maximize this
%             % ratio method (probably has a name, but I just sorta made it up)
%             %out(2,ii)=abs(1-mean(abs(qq./ww))); % minimize this
%             % Pearson Correlation;; maximize
%             %out(3,ii)=(32*sum(qq.*ww)-(sum(qq)*sum(ww)) )/sqrt( (32*sum(qq.^2)-(sum(qq)^2))*(32*sum(ww.^2)-(sum(ww)^2)) );
%             %out(3,ii)=abs(sum(abs(qq)-abs(ww)));
%             [  corrCoefPearson,  corrPvalPearson ] = corr(qq,ww, 'Type', 'Pearson'); % max
%             [  corrCoefKendall,  corrPvalKendall ] = corr(qq,ww, 'Type', 'Kendall'); % max
%             [ corrCoefSpearman, corrPvalSpearman ] = corr(qq,ww, 'Type', 'Spearman'); % max
%             out(:,ii) = [ corrCoefPearson,  corrPvalPearson corrCoefKendall,  corrPvalKendall  corrCoefSpearman, corrPvalSpearman ];
%         end 
% 
%         choice = zeros(1,6);
%         [~,dd]=max(out(1,:));
%         choice(1) = [  dd ];
%         [~,dd]=min(out(2,:));
%         choice(2) = [  dd ];
%         [~,dd]=max(out(3,:));
%         choice(3) = [  dd ];
%         [~,dd]=min(out(4,:));
%         choice(4) = [  dd ];
%         [~,dd]=max(out(5,:));
%         choice(5) = [  dd ];
%         [~,dd]=min(out(6,:));
%         choice(6) = [  dd ];
% 
%         [ mode(choice)  sum(choice==mode(choice))/length(choice) ]
% 
% 
