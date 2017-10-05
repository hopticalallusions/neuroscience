function nlxstruct = MB_TrainLSTM( FEMfile, nlxstruct, numf )

% This function trains two LSTM networks within a MockingBird filter emulator module (FEM), and  
% stores the resulting weight parameters to an FEM file

%Prior to executing this function, follow system configuration instructions in the MockingBird README file

%%% ARGUMENTS:
% FEMfile = filename of FEM parameter file (full path) to store after training
% nlxstruct = input data array created by the MB_bandpassiir() function
% numf = index of the filter to use (default is 1 if not specified)
 
%%% RETURN VALUES:
% status = returns 0 if output was successfully stored the specified FEM file 

if nargin<3
    numf = 1; %default filter number is 1
end

trainerpath=[pwd '/'];

%---------------------------------- TRAINING ------------------------------

%save training input data file for use by the LSTM trainer
lfp=nlxstruct.data(nlxstruct.filtered(numf).training_segment(1):nlxstruct.filtered(numf).training_segment(2));
lfp=(lfp+2^(nlxstruct.filtered(numf).input_scalefact-1))/2^(nlxstruct.filtered(numf).input_scalefact-15);
lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
lfp=lfp/(2^15);
save([trainerpath 'input.hpp'],'lfp','-ascii');

%train real LSTM
temp=real(nlxstruct.filtered(numf).teaching_signal(nlxstruct.filtered(numf).training_segment(1):nlxstruct.filtered(numf).training_segment(2))); %extract real component of the target vector
save([trainerpath 'target.hpp'],'temp','-ascii'); %save target data file for use by the LSTM trainer
status = system([trainerpath 'TrainLSTM ' trainerpath]); %execute the LSTM trainer from the Windows command prompt
realweights=importdata([trainerpath 'weight.hpp']); %read in the weight file
realweights=round(4096*realweights); %convert weights to fixed point

%train imaginary LSTM
temp=real(nlxstruct.filtered(numf).teaching_signal(nlxstruct.filtered(numf).training_segment(1):nlxstruct.filtered(numf).training_segment(2))); %extract imaginary component of the target vector
save([trainerpath 'target.hpp'],'temp','-ascii'); %save target data file for use by the LSTM trainer
status = system([trainerpath 'TrainLSTM ' trainerpath]); %execute the LSTM trainer from the Windows command prompt
imagweights=importdata([trainerpath 'weight.hpp']); %read in the weight file
imagweights=round(4096*imagweights); %convert weights to fixed point

%store the weight file for use by the tester
fileID = fopen('test_weight.hpp','w');
fprintf(fileID,'#SCALING_FACTOR %d\n',round(nlxstruct.filtered(numf).input_scalefact));
fprintf(fileID,'// LSTM0: real weights\n');
fprintf(fileID,'%d\n',realweights);
fprintf(fileID,'\n');
fprintf(fileID,'// LSTM1: imaginary weights\n');
fprintf(fileID,'%d\n',imagweights);
fclose(fileID);

%---------------------------------- TESTING ------------------------------

%compute output for training data
fileID = fopen('test_input.hpp','w');
fprintf(fileID,'%d\n',lfp);
fclose(fileID);
status = system([trainerpath 'TestLSTM ' trainerpath]); %execute the LSTM tester from the Windows command prompt
test_output=importdata([trainerpath 'output.hpp']); %read in the output data file
nlxstruct.filtered(numf).training_output=complex(test_output(:,1),test_output(:,2));


%compute output for testing data
lfp=nlxstruct.data(nlxstruct.filtered(numf).testing_segment(1):nlxstruct.filtered(numf).testing_segment(2));
lfp=(lfp+2^(nlxstruct.filtered(numf).input_scalefact-1))/2^(nlxstruct.filtered(numf).input_scalefact-15);
lfp(find(lfp>2^15))=2^15; lfp(find(lfp<0))=0;
lfp=lfp/(2^15);
fileID = fopen('test_input.hpp','w');
fprintf(fileID,'%d\n',lfp);
fclose(fileID);
status = system([trainerpath 'TestLSTM ' trainerpath]); %execute the LSTM tester from the Windows command prompt
test_output=importdata([trainerpath 'output.hpp']); %read in the output data file
nlxstruct.filtered(numf).testing_output=complex(test_output(:,1),test_output(:,2));

%status = unix(['cp ' trainerpath 'input.hpp ' trainerpath 'test_input.hpp']); %copy the training input data file to the test input data file

outenv=abs(test_output); %scale the envelope threshold detector by the median of the output envelope amplitude

%store the weight file for use by HPPterm
fileID = fopen(FEMfile,'w');
fprintf(fileID,'#SCALING_FACTOR %d\r\n',round(nlxstruct.filtered(numf).input_scalefact));
fprintf(fileID,'#ENVELOPE_REFERENCE %d\r\n',round(.44*median(outenv)));
fprintf(fileID,'// LSTM0: real weights\r\n');
fprintf(fileID,'%d\r\n',realweights);
fprintf(fileID,'\r\n');
fprintf(fileID,'// LSTM1: imaginary weights\r\n');
fprintf(fileID,'%d\r\n',imagweights);
fclose(fileID);





