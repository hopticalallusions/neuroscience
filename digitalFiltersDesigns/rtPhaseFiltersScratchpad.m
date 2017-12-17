
    lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    if ( idx >= lowpassNCoeff )
          lowPassOut = ...    %    - lowpassed(idx-0)*lowpassDenominatorCoeffs(1) 
        + lfp(idx-0)*lowpassNumeratorCoeffs(1) ...
        - lowpassed(idx-1)*lowpassDenominatorCoeffs(2) + lfp(idx-1)*lowpassNumeratorCoeffs(2) ...
        - lowpassed(idx-2)*lowpassDenominatorCoeffs(3) + lfp(idx-2)*lowpassNumeratorCoeffs(3) ...
        - lowpassed(idx-3)*lowpassDenominatorCoeffs(4) + lfp(idx-3)*lowpassNumeratorCoeffs(4) ...
        - lowpassed(idx-4)*lowpassDenominatorCoeffs(5) + lfp(idx-4)*lowpassNumeratorCoeffs(5) ...
        - lowpassed(idx-5)*lowpassDenominatorCoeffs(6) + lfp(idx-5)*lowpassNumeratorCoeffs(6) ...
        - lowpassed(idx-6)*lowpassDenominatorCoeffs(7) + lfp(idx-6)*lowpassNumeratorCoeffs(7);
    else
        lowPassOut = lowpassed(idx);
    end
    lp(idx) = lowPassOut;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
    disp(lpcc)
    
    
    
    
    
    
        
    lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    lowpassDenominatorCache = [ lp(idx) lowpassDenominatorCache(1:end-1)  ];
    for k=1:min(idx,lowpassNCoeff) 
        lp(idx) = lp(idx) ...
            - lowpassDenominatorCache(k)*lowpassDenominatorCoeffsB(k)...
            + lowpassNumeratorCache(k)*lowpassNumeratorCoeffs(k);
    end

    
    
    
    %%works
        lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    %    - lowpassed(idx-0)*lowpassDenominatorCoeffs(1) this part is never needed
        lowPassOut =                                           + lowpassNumeratorCache(1)*lowpassNumeratorCoeffs(1);
    if ( idx > 1 )
        lowPassOut = lowPassOut - lowpassDenominatorCache(1)*lowpassDenominatorCoeffs(2) + lowpassNumeratorCache(2)*lowpassNumeratorCoeffs(2);
    end
    if ( idx > 2 )
        lowPassOut = lowPassOut - lowpassDenominatorCache(2)*lowpassDenominatorCoeffs(3) + lowpassNumeratorCache(3)*lowpassNumeratorCoeffs(3);
    end
    if ( idx > 3 )
        lowPassOut = lowPassOut - lowpassDenominatorCache(3)*lowpassDenominatorCoeffs(4) + lowpassNumeratorCache(4)*lowpassNumeratorCoeffs(4);
    end
    if ( idx > 4 )
        lowPassOut = lowPassOut - lowpassDenominatorCache(4)*lowpassDenominatorCoeffs(5) + lowpassNumeratorCache(5)*lowpassNumeratorCoeffs(5);
    end
    if ( idx > 5 )
        lowPassOut = lowPassOut - lowpassDenominatorCache(5)*lowpassDenominatorCoeffs(6) + lowpassNumeratorCache(6)*lowpassNumeratorCoeffs(6);
    end
    if ( idx > 6 )
        lowPassOut = lowPassOut - lowpassDenominatorCache(6)*lowpassDenominatorCoeffs(7) + lowpassNumeratorCache(7)*lowpassNumeratorCoeffs(7);
    end
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
    lp(idx) = lowPassOut;
    
    %% also works
        lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    if ( idx >= lowpassNCoeff )
          %    - lowpassed(idx-0)*lowpassDenominatorCoeffs(1) 
          lowPassOut =                                           + lowpassNumeratorCache(1)*lowpassNumeratorCoeffs(1) ...
        - lowpassDenominatorCache(1)*lowpassDenominatorCoeffs(2) + lowpassNumeratorCache(2)*lowpassNumeratorCoeffs(2) ...
        - lowpassDenominatorCache(2)*lowpassDenominatorCoeffs(3) + lowpassNumeratorCache(3)*lowpassNumeratorCoeffs(3) ...
        - lowpassDenominatorCache(3)*lowpassDenominatorCoeffs(4) + lowpassNumeratorCache(4)*lowpassNumeratorCoeffs(4) ...
        - lowpassDenominatorCache(4)*lowpassDenominatorCoeffs(5) + lowpassNumeratorCache(5)*lowpassNumeratorCoeffs(5) ...
        - lowpassDenominatorCache(5)*lowpassDenominatorCoeffs(6) + lowpassNumeratorCache(6)*lowpassNumeratorCoeffs(6) ...
        - lowpassDenominatorCache(6)*lowpassDenominatorCoeffs(7) + lowpassNumeratorCache(7)*lowpassNumeratorCoeffs(7);
        %lowPassOut = sum(lowpassNumeratorCache.*lowpassNumeratorCoeffs) - sum(lowpassDenominatorCache(2:7).*lowpassDenominatorCoeffs(2:7));
    else
        lowPassOut = lowpassed(idx);
    end
    lp(idx) = lowPassOut;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
    
%% also works

    lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
          %    - lowpassed(idx-0)*lowpassDenominatorCoeffs(1) 
          lowPassOut =                                           + lowpassNumeratorCache(1)*lowpassNumeratorCoeffs(1) ...
        - lowpassDenominatorCache(1)*lowpassDenominatorCoeffs(2) + lowpassNumeratorCache(2)*lowpassNumeratorCoeffs(2) ...
        - lowpassDenominatorCache(2)*lowpassDenominatorCoeffs(3) + lowpassNumeratorCache(3)*lowpassNumeratorCoeffs(3) ...
        - lowpassDenominatorCache(3)*lowpassDenominatorCoeffs(4) + lowpassNumeratorCache(4)*lowpassNumeratorCoeffs(4) ...
        - lowpassDenominatorCache(4)*lowpassDenominatorCoeffs(5) + lowpassNumeratorCache(5)*lowpassNumeratorCoeffs(5) ...
        - lowpassDenominatorCache(5)*lowpassDenominatorCoeffs(6) + lowpassNumeratorCache(6)*lowpassNumeratorCoeffs(6) ...
        - lowpassDenominatorCache(6)*lowpassDenominatorCoeffs(7) + lowpassNumeratorCache(7)*lowpassNumeratorCoeffs(7);
        %lowPassOut = sum(lowpassNumeratorCache.*lowpassNumeratorCoeffs) - sum(lowpassDenominatorCache(2:7).*lowpassDenominatorCoeffs(2:7));
     lp(idx) = lowPassOut;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];

    % also works
        lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
          %    - lowpassed(idx-0)*lowpassDenominatorCoeffs(1) 
    lowPassOut = 0;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
%     for k=1:lowpassNCoeff
%         lowPassOut = lowPassOut                                     ...
%             + lowpassNumeratorCache(k)*lowpassNumeratorCoeffs(k)    ...
%             - lowpassDenominatorCache(k)*lowpassDenominatorCoeffs(k);
%     end
          lowPassOut = - lowpassDenominatorCache(1)*lowpassDenominatorCoeffs(1) + lowpassNumeratorCache(1)*lowpassNumeratorCoeffs(1) ...
        - lowpassDenominatorCache(2)*lowpassDenominatorCoeffs(2) + lowpassNumeratorCache(2)*lowpassNumeratorCoeffs(2) ...
        - lowpassDenominatorCache(3)*lowpassDenominatorCoeffs(3) + lowpassNumeratorCache(3)*lowpassNumeratorCoeffs(3) ...
        - lowpassDenominatorCache(4)*lowpassDenominatorCoeffs(4) + lowpassNumeratorCache(4)*lowpassNumeratorCoeffs(4) ...
        - lowpassDenominatorCache(5)*lowpassDenominatorCoeffs(5) + lowpassNumeratorCache(5)*lowpassNumeratorCoeffs(5) ...
        - lowpassDenominatorCache(6)*lowpassDenominatorCoeffs(6) + lowpassNumeratorCache(6)*lowpassNumeratorCoeffs(6) ...
        - lowpassDenominatorCache(7)*lowpassDenominatorCoeffs(7) + lowpassNumeratorCache(7)*lowpassNumeratorCoeffs(7);
        %lowPassOut = sum(lowpassNumeratorCache.*lowpassNumeratorCoeffs) - sum(lowpassDenominatorCache(2:7).*lowpassDenominatorCoeffs(2:7));
    lp(idx) = lowPassOut;
    lowpassDenominatorCache(1) = lowPassOut;
    
% also works

    lowpassNumeratorCache = [ lfp(idx) lowpassNumeratorCache(1:end-1) ]; % shift register  
    lowPassOut = 0;
    lowpassDenominatorCache = [ lowPassOut lowpassDenominatorCache(1:end-1)  ];
     for k=1:lowpassNCoeff
         lowPassOut = lowPassOut - lowpassDenominatorCache(k)*lowpassDenominatorCoeffs(k) + lowpassNumeratorCache(k)*lowpassNumeratorCoeffs(k);
     end
    lp(idx) = lowPassOut;
    lowpassDenominatorCache(1) = lowPassOut;








function createfigure(X1, YMatrix1, Y1, Y2)
%CREATEFIGURE(X1, YMATRIX1, Y1, Y2)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data
%  Y1:  vector of y data
%  Y2:  vector of y data

%  Auto-generated by MATLAB on 09-Mar-2016 00:29:32

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'FontSize',14,...
    'Position',[0.13 0.548172043010753 0.775 0.376827956989247]);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 8]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 120]);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','alg env','LineWidth',2,'Color',[1 0 0]);
set(plot1(2),'DisplayName','true env','LineWidth',4,'Color',[0.4 0.4 0.4]);
set(plot1(3),'DisplayName','CORDIC env(true hilbert)','LineWidth',1,...
    'Color',[0.1 0.9 0.2]);

% Create ylabel
ylabel('\muV');

% Create title
title('C/FPGA Algorithm Approximations vs True');

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','southeast','FontSize',12);

% Create subplot
subplot1 = subplot(4,1,3,'Parent',figure1,'FontSize',14);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot1,[0 8]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot1,[-0.01 0]);
box(subplot1,'on');
hold(subplot1,'on');

% Create plot
plot(X1,Y1,'Parent',subplot1,'DisplayName','env. error true-CORDIC');

% Create ylabel
ylabel('\muV');

% Create legend
legend2 = legend(subplot1,'show');
set(legend2,'FontSize',12);

% Create subplot
subplot2 = subplot(4,1,4,'Parent',figure1,'FontSize',14);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot2,[0 8]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot2,[-7 7]);
box(subplot2,'on');
hold(subplot2,'on');

% Create plot
plot(X1,Y2,'Parent',subplot2,'DisplayName','env. true-est');

% Create xlabel
xlabel('time (s)');

% Create ylabel
ylabel('\muV');

% Create legend
legend3 = legend(subplot2,'show');
set(legend3,'FontSize',12);





aa=reshape(1:20,5,4)'
i=4;j=5;
while (i>1)
    aa(i,1) = 0;
    for j=2:5
        aa(i,j)=aa(i,j-1);
    end
end

aa








 hilbertNumeratorCoeffs = ...
 [ 0.000000000000001127662575653774979689441 ...
-0.000130476138946636967567635490006239252 ...
 0.000000000000001084406434006142992862232 ...
-0.000202974874492264191006354878688000554 ...
 0.000000000000001306970218913347628410693 ...
-0.000354719283426647362215955450182036657 ...
 0.00000000000000246669069323427698405669  ...
-0.000575250463727568087449193434679273196 ...
 0.000000000000002806901698824692312863782 ...
-0.000883857088375641052058195867857648409 ...
 0.000000000000004339819138687855845588155 ...
-0.001303301689776132678277864584970302531 ...
 0.000000000000004555116984364625691741079 ...
-0.00185939798324038021992699043494212674  ...
 0.000000000000007196699404630617933781969 ...
-0.002581673560742158042569105447228139383 ...
 0.000000000000007487084802012430804420114 ...
-0.003503797920068961457840117645901045762 ...
 0.000000000000008765282697374901866514888 ...
-0.004664131994992812280109717448794981465 ...
 0.000000000000009638574345629789427635214 ...
-0.006106840275994708522322440558127709664 ...
 0.000000000000011729763644065942984460419 ...
-0.007883785040501717356065114472585264593 ...
 0.000000000000011521229975995736189508857 ...
-0.010057477023547291283822602281361469068 ...
 0.000000000000012821254253207087832683143 ...
-0.012705784627037419731721001880941912532 ...
 0.000000000000013170520384854908769943733 ...
-0.015929742752346390255446806349937105551 ...
 0.000000000000013162616998395538802510608 ...
-0.019866759569211356328821693750796839595 ...
 0.000000000000013291186108429386259346121 ...
-0.024713514254879220821692342724418267608 ...
 0.000000000000012940365701555507551359594 ...
-0.030767476745944988270053954693139530718 ...
 0.000000000000012540823779124972839215067 ...
-0.038507103880309478949328649832750670612 ...
 0.000000000000010583817777527944690031015 ...
-0.048759874539129832715644852214609272778 ...
 0.000000000000009652095623049988689913729 ...
-0.063094520517915864132874048664234578609 ...
 0.00000000000000868191076750970078165346  ...
-0.084885445881223930975068014959106221795 ...
 0.000000000000006027117295506470495021365 ...
-0.122931145484904802422931879846146330237 ...
 0.000000000000004386224423203370569983616 ...
-0.209544916583793261466439616924617439508 ...
 0.000000000000002006719327650789301782679 ...
-0.635728180480658489059919702413026243448 ...
 0                                         ...
 0.635728180480658489059919702413026243448 ...
-0.000000000000002006719327650789301782679 ...
 0.209544916583793261466439616924617439508 ...
-0.000000000000004386224423203370569983616 ...
 0.122931145484904802422931879846146330237 ...
-0.000000000000006027117295506470495021365 ...
 0.084885445881223930975068014959106221795 ...
-0.00000000000000868191076750970078165346  ...
 0.063094520517915864132874048664234578609 ...
-0.000000000000009652095623049988689913729 ...
 0.048759874539129832715644852214609272778 ...
-0.000000000000010583817777527944690031015 ...
 0.038507103880309478949328649832750670612 ...
-0.000000000000012540823779124972839215067 ...
 0.030767476745944988270053954693139530718 ...
-0.000000000000012940365701555507551359594 ...
 0.024713514254879220821692342724418267608 ...
-0.000000000000013291186108429386259346121 ...
 0.019866759569211356328821693750796839595 ...
-0.000000000000013162616998395538802510608 ...
 0.015929742752346390255446806349937105551 ...
-0.000000000000013170520384854908769943733 ...
 0.012705784627037419731721001880941912532 ...
-0.000000000000012821254253207087832683143 ...
 0.010057477023547291283822602281361469068 ...
-0.000000000000011521229975995736189508857 ...
 0.007883785040501717356065114472585264593 ...
-0.000000000000011729763644065942984460419 ...
 0.006106840275994708522322440558127709664 ...
-0.000000000000009638574345629789427635214 ...
 0.004664131994992812280109717448794981465 ...
-0.000000000000008765282697374901866514888 ...
 0.003503797920068961457840117645901045762 ...
-0.000000000000007487084802012430804420114 ...
 0.002581673560742158042569105447228139383 ...
-0.000000000000007196699404630617933781969 ...
 0.00185939798324038021992699043494212674  ...
-0.000000000000004555116984364625691741079 ...
 0.001303301689776132678277864584970302531 ...
-0.000000000000004339819138687855845588155 ...
 0.000883857088375641052058195867857648409 ...
-0.000000000000002806901698824692312863782 ...
 0.000575250463727568087449193434679273196 ...
-0.00000000000000246669069323427698405669  ...
 0.000354719283426647362215955450182036657 ...
-0.000000000000001306970218913347628410693 ...
 0.000202974874492264191006354878688000554 ...
-0.000000000000001084406434006142992862232 ...
 0.000130476138946636967567635490006239252 ...
-0.000000000000001127662575653774979689441];





lowpass_output(i) = ...
    - sum([ lowpass_output(i)   * denom_filter_coeffs(1) ...
     lowpass_output(i-1) * denom_filter_coeffs(2) ...
     lowpass_output(i-2) * denom_filter_coeffs(3) ...
     lowpass_output(i-3) * denom_filter_coeffs(4) ...
     lowpass_output(i-4) * denom_filter_coeffs(5) ...
     lowpass_output(i-5) * denom_filter_coeffs(6) ...
     lowpass_output(i-6) * denom_filter_coeffs(7) ] ) ...
    + sum([ input_data(i)   * num_filter_coeffs(1)       ...
     input_data(i-1) * num_filter_coeffs(2)       ...
     input_data(i-2) * num_filter_coeffs(3)       ...
     input_data(i-3) * num_filter_coeffs(4)       ...
     input_data(i-4) * num_filter_coeffs(5)       ...
     input_data(i-5) * num_filter_coeffs(6)       ...
     input_data(i-6) * num_filter_coeffs(7) ]);
 
 sum(lowpassNumeratorCache.*lowpassNumeratorCoeffs)
 -sum(lowpassDenominatorCache.*lowpassDenominatorCoeffs)
 
 
 
 hilbertNumeratorCoeffs =
 [ 0.000000000000001127662575653774979689441 ...
-0.000130476138946636967567635490006239252 ...
 0.000000000000001084406434006142992862232 ...
-0.000202974874492264191006354878688000554 ...
 0.000000000000001306970218913347628410693 ...
-0.000354719283426647362215955450182036657 ...
 0.00000000000000246669069323427698405669  ...
-0.000575250463727568087449193434679273196 ...
 0.000000000000002806901698824692312863782 ...
-0.000883857088375641052058195867857648409 ...
 0.000000000000004339819138687855845588155 ...
-0.001303301689776132678277864584970302531 ...
 0.000000000000004555116984364625691741079 ...
-0.00185939798324038021992699043494212674  ...
 0.000000000000007196699404630617933781969 ...
-0.002581673560742158042569105447228139383 ...
 0.000000000000007487084802012430804420114 ...
-0.003503797920068961457840117645901045762 ...
 0.000000000000008765282697374901866514888 ...
-0.004664131994992812280109717448794981465 ...
 0.000000000000009638574345629789427635214 ...
-0.006106840275994708522322440558127709664 ...
 0.000000000000011729763644065942984460419 ...
-0.007883785040501717356065114472585264593 ...
 0.000000000000011521229975995736189508857 ...
-0.010057477023547291283822602281361469068 ...
 0.000000000000012821254253207087832683143 ...
-0.012705784627037419731721001880941912532 ...
 0.000000000000013170520384854908769943733 ...
-0.015929742752346390255446806349937105551 ...
 0.000000000000013162616998395538802510608 ...
-0.019866759569211356328821693750796839595 ...
 0.000000000000013291186108429386259346121 ...
-0.024713514254879220821692342724418267608 ...
 0.000000000000012940365701555507551359594 ...
-0.030767476745944988270053954693139530718 ...
 0.000000000000012540823779124972839215067 ...
-0.038507103880309478949328649832750670612 ...
 0.000000000000010583817777527944690031015 ...
-0.048759874539129832715644852214609272778 ...
 0.000000000000009652095623049988689913729 ...
-0.063094520517915864132874048664234578609 ...
 0.00000000000000868191076750970078165346  ...
-0.084885445881223930975068014959106221795 ...
 0.000000000000006027117295506470495021365 ...
-0.122931145484904802422931879846146330237 ...
 0.000000000000004386224423203370569983616 ...
-0.209544916583793261466439616924617439508 ...
 0.000000000000002006719327650789301782679 ...
-0.635728180480658489059919702413026243448 ...
 0                                         ...
 0.635728180480658489059919702413026243448 ...
-0.000000000000002006719327650789301782679 ...
 0.209544916583793261466439616924617439508 ...
-0.000000000000004386224423203370569983616 ...
 0.122931145484904802422931879846146330237 ...
-0.000000000000006027117295506470495021365 ...
 0.084885445881223930975068014959106221795 ...
-0.00000000000000868191076750970078165346  ...
 0.063094520517915864132874048664234578609 ...
-0.000000000000009652095623049988689913729 ...
 0.048759874539129832715644852214609272778 ...
-0.000000000000010583817777527944690031015 ...
 0.038507103880309478949328649832750670612 ...
-0.000000000000012540823779124972839215067 ...
 0.030767476745944988270053954693139530718 ...
-0.000000000000012940365701555507551359594 ...
 0.024713514254879220821692342724418267608 ...
-0.000000000000013291186108429386259346121 ...
 0.019866759569211356328821693750796839595 ...
-0.000000000000013162616998395538802510608 ...
 0.015929742752346390255446806349937105551 ...
-0.000000000000013170520384854908769943733 ...
 0.012705784627037419731721001880941912532 ...
-0.000000000000012821254253207087832683143 ...
 0.010057477023547291283822602281361469068 ...
-0.000000000000011521229975995736189508857 ...
 0.007883785040501717356065114472585264593 ...
-0.000000000000011729763644065942984460419 ...
 0.006106840275994708522322440558127709664 ...
-0.000000000000009638574345629789427635214 ...
 0.004664131994992812280109717448794981465 ...
-0.000000000000008765282697374901866514888 ...
 0.003503797920068961457840117645901045762 ...
-0.000000000000007487084802012430804420114 ...
 0.002581673560742158042569105447228139383 ...
-0.000000000000007196699404630617933781969 ...
 0.00185939798324038021992699043494212674  ...
-0.000000000000004555116984364625691741079 ...
 0.001303301689776132678277864584970302531 ...
-0.000000000000004339819138687855845588155 ...
 0.000883857088375641052058195867857648409 ...
-0.000000000000002806901698824692312863782 ...
 0.000575250463727568087449193434679273196 ...
-0.00000000000000246669069323427698405669  ...
 0.000354719283426647362215955450182036657 ...
-0.000000000000001306970218913347628410693 ...
 0.000202974874492264191006354878688000554 ...
-0.000000000000001084406434006142992862232 ...
 0.000130476138946636967567635490006239252 ...
-0.000000000000001127662575653774979689441];



lowpass_output(i) = 
    - lowpass_output(i)*denom_filter_coeffs(1)   ...
    + input_data(i)*num_filter_coeffs(1)         ...

    - lowpass_output(i-1)*denom_filter_coeffs(2) ...
    + input_data(i-1)*num_filter_coeffs(2)       ...

    - lowpass_output(i-2)*denom_filter_coeffs(3) ...
    + input_data(i-2)*num_filter_coeffs(3)       ...

    - lowpass_output(i-3)*denom_filter_coeffs(4) ...
    + input_data(i-3)*num_filter_coeffs(4)       ...

    - lowpass_output(i-4)*denom_filter_coeffs(5) ...
    + input_data(i-4)*num_filter_coeffs(5)       ...

    - lowpass_output(i-5)*denom_filter_coeffs(6) ...
    + input_data(i-5)*num_filter_coeffs(6)       ...

    - lowpass_output(i-6)*denom_filter_coeffs(7) ...
    + input_data(i-6)*num_filter_coeffs(7);

lowpass_output(i) = 
    - lowpass_output(i)  *denom_filter_coeffs(1) ...
    - lowpass_output(i-1)*denom_filter_coeffs(2) ...
    - lowpass_output(i-2)*denom_filter_coeffs(3) ...
    - lowpass_output(i-3)*denom_filter_coeffs(4) ...
    - lowpass_output(i-4)*denom_filter_coeffs(5) ...
    - lowpass_output(i-5)*denom_filter_coeffs(6) ...
    - lowpass_output(i-6)*denom_filter_coeffs(7) ...
    + input_data(i)  *num_filter_coeffs(1)       ...
    + input_data(i-1)*num_filter_coeffs(2)       ...
    + input_data(i-2)*num_filter_coeffs(3)       ...
    + input_data(i-3)*num_filter_coeffs(4)       ...
    + input_data(i-4)*num_filter_coeffs(5)       ...
    + input_data(i-5)*num_filter_coeffs(6)       ...
    + input_data(i-6)*num_filter_coeffs(7);

order 10
hilbertNumeratorCoeffs = ...
[ -0.222066272080177151693192172388080507517 ...
-0.000000000000000311075173987210473627683 ...
-0.207067108122114873491881326117436401546 ...
 0.000000000000000175151608711747348340728 ...
-0.634683409629884787150899683183524757624 ...
 0                                         ...
 0.634683409629884787150899683183524757624 ...
-0.000000000000000175151608711747348340728 ...
 0.207067108122114873491881326117436401546 ...
 0.000000000000000311075173987210473627683 ...
 0.222066272080177151693192172388080507517 ];



hilbertNumeratorCoeffs = ...
 [ 0.000000000000001127662575653774979689441 ...
-0.000130476138946636967567635490006239252 ...
 0.000000000000001084406434006142992862232 ...
-0.000202974874492264191006354878688000554 ...
 0.000000000000001306970218913347628410693 ...
-0.000354719283426647362215955450182036657 ...
 0.00000000000000246669069323427698405669  ...
-0.000575250463727568087449193434679273196 ...
 0.000000000000002806901698824692312863782 ...
-0.000883857088375641052058195867857648409 ...
 0.000000000000004339819138687855845588155 ...
-0.001303301689776132678277864584970302531 ...
 0.000000000000004555116984364625691741079 ...
-0.00185939798324038021992699043494212674  ...
 0.000000000000007196699404630617933781969 ...
-0.002581673560742158042569105447228139383 ...
 0.000000000000007487084802012430804420114 ...
-0.003503797920068961457840117645901045762 ...
 0.000000000000008765282697374901866514888 ...
-0.004664131994992812280109717448794981465 ...
 0.000000000000009638574345629789427635214 ...
-0.006106840275994708522322440558127709664 ...
 0.000000000000011729763644065942984460419 ...
-0.007883785040501717356065114472585264593 ...
 0.000000000000011521229975995736189508857 ...
-0.010057477023547291283822602281361469068 ...
 0.000000000000012821254253207087832683143 ...
-0.012705784627037419731721001880941912532 ...
 0.000000000000013170520384854908769943733 ...
-0.015929742752346390255446806349937105551 ...
 0.000000000000013162616998395538802510608 ...
-0.019866759569211356328821693750796839595 ...
 0.000000000000013291186108429386259346121 ...
-0.024713514254879220821692342724418267608 ...
 0.000000000000012940365701555507551359594 ...
-0.030767476745944988270053954693139530718 ...
 0.000000000000012540823779124972839215067 ...
-0.038507103880309478949328649832750670612 ...
 0.000000000000010583817777527944690031015 ...
-0.048759874539129832715644852214609272778 ...
 0.000000000000009652095623049988689913729 ...
-0.063094520517915864132874048664234578609 ...
 0.00000000000000868191076750970078165346  ...
-0.084885445881223930975068014959106221795 ...
 0.000000000000006027117295506470495021365 ...
-0.122931145484904802422931879846146330237 ...
 0.000000000000004386224423203370569983616 ...
-0.209544916583793261466439616924617439508 ...
 0.000000000000002006719327650789301782679 ...
-0.635728180480658489059919702413026243448 ...
 0                                         ...
 0.635728180480658489059919702413026243448 ...
-0.000000000000002006719327650789301782679 ...
 0.209544916583793261466439616924617439508 ...
-0.000000000000004386224423203370569983616 ...
 0.122931145484904802422931879846146330237 ...
-0.000000000000006027117295506470495021365 ...
 0.084885445881223930975068014959106221795 ...
-0.00000000000000868191076750970078165346  ...
 0.063094520517915864132874048664234578609 ...
-0.000000000000009652095623049988689913729 ...
 0.048759874539129832715644852214609272778 ...
-0.000000000000010583817777527944690031015 ...
 0.038507103880309478949328649832750670612 ...
-0.000000000000012540823779124972839215067 ...
 0.030767476745944988270053954693139530718 ...
-0.000000000000012940365701555507551359594 ...
 0.024713514254879220821692342724418267608 ...
-0.000000000000013291186108429386259346121 ...
 0.019866759569211356328821693750796839595 ...
-0.000000000000013162616998395538802510608 ...
 0.015929742752346390255446806349937105551 ...
-0.000000000000013170520384854908769943733 ...
 0.012705784627037419731721001880941912532 ...
-0.000000000000012821254253207087832683143 ...
 0.010057477023547291283822602281361469068 ...
-0.000000000000011521229975995736189508857 ...
 0.007883785040501717356065114472585264593 ...
-0.000000000000011729763644065942984460419 ...
 0.006106840275994708522322440558127709664 ...
-0.000000000000009638574345629789427635214 ...
 0.004664131994992812280109717448794981465 ...
-0.000000000000008765282697374901866514888 ...
 0.003503797920068961457840117645901045762 ...
-0.000000000000007487084802012430804420114 ...
 0.002581673560742158042569105447228139383 ...
-0.000000000000007196699404630617933781969 ...
 0.00185939798324038021992699043494212674  ...
-0.000000000000004555116984364625691741079 ...
 0.001303301689776132678277864584970302531 ...
-0.000000000000004339819138687855845588155 ...
 0.000883857088375641052058195867857648409 ...
-0.000000000000002806901698824692312863782 ...
 0.000575250463727568087449193434679273196 ...
-0.00000000000000246669069323427698405669  ...
 0.000354719283426647362215955450182036657 ...
-0.000000000000001306970218913347628410693 ...
 0.000202974874492264191006354878688000554 ...
-0.000000000000001084406434006142992862232 ...
 0.000130476138946636967567635490006239252 ...
-0.000000000000001127662575653774979689441];