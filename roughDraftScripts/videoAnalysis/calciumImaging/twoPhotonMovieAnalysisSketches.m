% read the whole movie one frame at a time and play it as each frame is read
fname='/Users/andrewhowe/data/20150911_09_49_21_Sep_11_Q175_L97_Num_19_3/20150911_09_49_21_Sep_11_Q175_L97_Num_19_3_XYT.raw'; 
fid=fopen(fname,'r'); 
figure;
colormap('bone');  % black and white color scheme
caxis([500 4000]); % range of values for image
% number of frames can be calculated as 
% number_frames = size_of_file_in_bytes / ( 512 * 512 pixels per frame * 2 bytes per pixel )
% files have no headers and are raw 16 bit unsigned integer data in big
% endian format. Each frame is 512 * 512 pixels.
stack=zeros(512,512,400);
stackIdx=1;
for xx=1:8000;                                     % for all 8000 frames in the file
    frame = fread( fid,   512*512, 'uint16', 'b' ); % read next frame
    if mod(xx,20) == 0
        stack(:,:,stackIdx) = reshape(frame,[512 512]);
        stackIdx = stackIdx + 1;
    end
    %imagesc(reshape(frame,[512 512]));              % reshape the data from vector to matrix and graph it
    %drawnow;                                       % force graph update
end;
fclose(fid);
