function [test_output] = MB_UnixLSTM( FEMfile, inputdata, inputscale, targetdata, trainerpath )

% This function trains two LSTM networks within a MockingBird filter emulator module (FEM), and  
% stores the resulting weight parameters to an FEM file so that it can be uploaded to the HPP fabric 

%Prior to executing this function, follow system configuration instructions
%in the MockingBird README file

%%% ARGUMENTS:
% FEMfile = name of FEM parameter file to store after training
% inputdata = input data array created by the MB_bandpassiir() function
% inputscale = input scaling factor derived by the MB_bandpassiir() function
% targetdata = complex target data array for the LSTM output, created by the MB_bandpassiir() function
% trainerpath = directory path for locating the TrainLSTM program file
 
%%% RETURN VALUES:
% status = returns 0 if output was successfully stored the specified FEM file 

if nargin<5
    trainerpath = './'; %if no directory is specified for training program, then assume it is the current directory
end

%---------------------------------- TRAINING ------------------------------

%save training input data file for use by the LSTM trainer
save([trainerpath 'input.hpp'],'inputdata','-ascii');

%train real LSTM
realtarget=real(targetdata); %extract real component of the target vector
save([trainerpath 'target.hpp'],'realtarget','-ascii'); %save target data file for use by the LSTM trainer
status = unix([trainerpath 'TrainLSTM ' trainerpath]); %execute the LSTM trainer from the Unix command prompt
realweights=importdata([trainerpath 'weight.hpp']); %read in the weight file
realweights=round(4096*realweights); %convert weights to fixed point

%train imaginary LSTM
imagtarget=imag(targetdata); %extract real component of the target vector
save([trainerpath 'target.hpp'],'imagtarget','-ascii'); %save target data file for use by the LSTM trainer
status = unix([trainerpath 'TrainLSTM ' trainerpath]); %execute the LSTM trainer from the Unix command prompt
imagweights=importdata([trainerpath 'weight.hpp']); %read in the weight file
imagweights=round(4096*imagweights); %convert weights to fixed point

%store the weight file for use by the tester
fileID = fopen('test_weight.hpp','w');
fprintf(fileID,'#SCALING_FACTOR %d\n',round(inputscale));
fprintf(fileID,'// LSTM0: real weights\n');
fprintf(fileID,'%d\n',realweights);
fprintf(fileID,'\n');
fprintf(fileID,'// LSTM1: imaginary weights\n');
fprintf(fileID,'%d\n',imagweights);
fclose(fileID);

%---------------------------------- TESTING ------------------------------

%save testing input data file for use by the LSTM trainer
inputdata=inputdata*(2^inputscale)-2^(inputscale-1);
fileID = fopen('test_input.hpp','w');
fprintf(fileID,'%d\n',inputdata);
fclose(fileID);
%save([trainerpath 'test_input.hpp'],'inputdata','-ascii');

%status = unix(['cp ' trainerpath 'input.hpp ' trainerpath 'test_input.hpp']); %copy the training input data file to the test input data file


status = unix([trainerpath 'TestLSTM ' trainerpath]); %execute the LSTM tester from the Unix command prompt

test_output=importdata([trainerpath 'output.hpp']); %read in the weight file
test_output=complex(test_output(:,1),test_output(:,2));
outenv=abs(test_output);


fileID = fopen(FEMfile,'w');
fprintf(fileID,'#SCALING_FACTOR %d\n',round(inputscale));
fprintf(fileID,'#ENVELOPE_REFERENCE %d\n',round(.44*median(outenv)));
fprintf(fileID,'// LSTM0: real weights\n');
fprintf(fileID,'%d\n',realweights);
fprintf(fileID,'\n');
fprintf(fileID,'// LSTM1: imaginary weights\n');
fprintf(fileID,'%d\n',imagweights);
fclose(fileID);





