function [ sh_info ]=PhaseInfo(positions, phases)

% positions = bin numbers for position samples
% phases = bin numbers for phase samples

%phbins=size(jdist,1);

%for iter=1:numiter
    
%    I(iter)=0;
%    scramblephbin=[];

    I = 0;
    
    for angpos=1:12
%        scramblephbin=[scramblephbin; cycoff(angpos).angles'];
        P_pos=length(find(positions==angpos))/length(positions);
        for thphase=1:12
            P_phase=length(find(phases==thphase))/length(phases);
            P_joint=length(find(phases==thphase & positions==angpos))/length(phases);
            if P_joint>0
                I = I + P_joint * log2 ( P_joint / (P_pos*P_phase) );
%            else
%                I = NaN;
            end
            %[angpos thphase I(iter)]
        end
    end
    
sh_info = I;
%[h, pval]=ztest(sh_info,mean(I(2:end)),std(I(2:end)));