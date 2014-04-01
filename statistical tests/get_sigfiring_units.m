if query_start<firing_pvalue.query_start | query_end>firing_pvalue.query_end
    disp(['WARNING: YOUR QUERY START OR END TIMES EXCEED THE RANGE SPECIFIED IN GET_PVALUE_FIRING. REDUCE QUERY PERIOD.'])
end

querybins=firing_pvalue.querybins;

newqueryinds=find(querybins<=query_end & querybins>=query_start);
querybins=querybins(newqueryinds);

event1_pvalue_excitation1=firing_pvalue.event1_pvalue_excitation;
event1_pvalue_inhibition1=firing_pvalue.event1_pvalue_inhibition;
event1_sigbins=[]; sig_excit_units_e1=[]; sig_inhib_units_e1=[]; 

for unitind=1:length(dounits);
    unitj=dounits(unitind);
    event1_sigbins{unitj}=zeros(size(querybins));
    for queryind=1:length(querybins)
        excitedbins=round(find(event1_pvalue_excitation1{unitj}(newqueryinds)<max_pvalue/2));
        inhibitedbins=round(find(event1_pvalue_inhibition1{unitj}(newqueryinds)<max_pvalue/2));
        event1_sigbins{unitj}(excitedbins)=1;
        event1_sigbins{unitj}(inhibitedbins)=-1;
    end
            
    sig_excitedinds=find(event1_sigbins{unitj}==1);   
    if min(diff(sig_excitedinds))==1   %at least two consecutive significant bins
%     if length(find(diff(diff(sig_excitedinds))==0))>0   %at least three consecutive significant bins
    sig_excit_units_e1=[sig_excit_units_e1 unitj];
    end
    
    sig_inhibitedinds=find(event1_sigbins{unitj}==-1);   
    if min(diff(sig_inhibitedinds))==1   %at least two consecutive significant bins
%     if length(find(diff(diff(sig_inhibitedinds))==0))>0   %at least three consecutive significant bins
    sig_inhib_units_e1=[sig_inhib_units_e1 unitj];
    end

end
       
event2_pvalue_excitation2=firing_pvalue.event2_pvalue_excitation;
event2_pvalue_inhibition2=firing_pvalue.event2_pvalue_inhibition;
event2_sigbins=[]; sig_excit_units_e2=[]; sig_inhib_units_e2=[]; 

for unitind=1:length(dounits);
    unitj=dounits(unitind);
    event2_sigbins{unitj}=zeros(size(querybins));
    for queryind=1:length(querybins)
        excitedbins=round(find(event2_pvalue_excitation2{unitj}(newqueryinds)<max_pvalue/2));
        inhibitedbins=round(find(event2_pvalue_inhibition2{unitj}(newqueryinds)<max_pvalue/2));
        event2_sigbins{unitj}(excitedbins)=1;
        event2_sigbins{unitj}(inhibitedbins)=-1;
    end
  
    sig_excitedinds=find(event2_sigbins{unitj}==1);   
    if min(diff(sig_excitedinds))==1   %at least two consecutive significant bins
%     if length(find(diff(diff(sig_excitedinds))==0))>0   %at least three consecutive significant bins
    sig_excit_units_e2=[sig_excit_units_e2 unitj];
    end
    
    sig_inhibitedinds=find(event2_sigbins{unitj}==-1);   
    if min(diff(sig_inhibitedinds))==1   %at least two consecutive significant bins
%     if length(find(diff(diff(sig_inhibitedinds))==0))>0   %at least three consecutive significant bins
    sig_inhib_units_e2=[sig_inhib_units_e2 unitj];
    end
  
end

if strcmp(use_sig_event,'1')
sigfiring_units=unique([sig_excit_units_e1 sig_inhib_units_e1]);
only_excited=setdiff(sig_excit_units_e1, sig_inhib_units_e1);
only_inhibited=setdiff(sig_inhib_units_e1,sig_excit_units_e1);
both_excite_inhib=intersect(sig_excit_units_e1, sig_inhib_units_e1);
elseif strcmp(use_sig_event,'2')
sigfiring_units=unique([sig_excit_units_e2 sig_inhib_units_e2]);
only_excited=setdiff(sig_excit_units_e2, sig_inhib_units_e2);
only_inhibited=setdiff(sig_inhib_units_e2,sig_excit_units_e2);
both_excite_inhib=intersect(sig_excit_units_e2, sig_inhib_units_e2);
elseif strcmp(use_sig_event,'either')
sigfiring_units=unique([sig_excit_units_e1 sig_inhib_units_e1 sig_excit_units_e2 sig_inhib_units_e2]);
only_excited=setdiff([sig_excit_units_e1 sig_excit_units_e2], [sig_inhib_units_e1 sig_inhib_units_e2]);
only_inhibited=setdiff([sig_inhib_units_e1 sig_inhib_units_e2], [sig_excit_units_e1 sig_excit_units_e2]);
both_excite_inhib=intersect([sig_excit_units_e1 sig_excit_units_e2], [sig_inhib_units_e1 sig_inhib_units_e2]);
end

number_only_excited=length(only_excited);
number_only_inhibited=length(only_inhibited);
number_both_excite_inhib=length(both_excite_inhib);
total_modulated=length(sigfiring_units);

only_e1_excit=setdiff(sig_excit_units_e1, sig_excit_units_e2);
only_e2_excit=setdiff(sig_excit_units_e2, sig_excit_units_e1);
bothevents_excit=intersect(sig_excit_units_e1, sig_excit_units_e2);

only_e1_inhib=setdiff(sig_inhib_units_e1, sig_inhib_units_e2);
only_e2_inhib=setdiff(sig_inhib_units_e2, sig_inhib_units_e1);
bothevents_inhib=intersect(sig_inhib_units_e1, sig_inhib_units_e2);

only_e1_mod=setdiff([sig_excit_units_e1 sig_inhib_units_e1], [sig_excit_units_e2 sig_inhib_units_e2]);
only_e2_mod=setdiff([sig_excit_units_e2 sig_inhib_units_e2], [sig_excit_units_e1 sig_inhib_units_e1]);
bothevents_mod=intersect([sig_excit_units_e1 sig_inhib_units_e1], [sig_excit_units_e2 sig_inhib_units_e2]);

disp([subject ': found ' num2str(number_only_excited) ' only excited, ' num2str(number_only_inhibited) ' only inhibited, ' num2str(number_both_excite_inhib) ' both exc AND inhib, ' num2str(total_modulated) ' exc OR inhib out of ' num2str(length(orig_dounits)) ' units.'])
dounits=sigfiring_units;

