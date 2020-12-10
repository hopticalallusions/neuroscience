function output=twoDGuassianSmooth( input, windowSize, sd )

if nargin < 2
    windowSize = 4; % seconds
end

if nargin < 3
    sd = 2; % seconds
end

x = [-windowSize:windowSize]; 
norm = normpdf(x,0,sd);
kernel=(norm'*norm);
%figure; plot(x,norm); surf(norm'*norm)

dims=size(input);

% pad the input with NaNs
toSmooth=zeros(dims(1)+2*windowSize,dims(2)+2*windowSize);
toSmooth(:) = NaN;
toSmooth(windowSize+1:dims(1)+windowSize,windowSize+1:dims(2)+windowSize)=input;

output=input;

for row=windowSize+1:dims(1)+windowSize % for all points in the surface to smooth
    for col=windowSize+1:dims(2)+windowSize
        if ~isnan(toSmooth(row,col)) % && toSmooth(row,col)>0 % if the entry is not NaN (or below zero; for plotting tricks, NaNs are replaced with a value below zero)
            % copy the Gaussian kernel
            toApply = kernel;
            % mask the kernel against the NaNs, which we know are out of bounds
            toApply = ~isnan(toSmooth(row-windowSize:row+windowSize,col-windowSize:col+windowSize)).*kernel;
            % normalize the remaining pieces of the kernel
            toApply = toApply./nansum(toApply(:));
            % multiply and insert the smoothed result
            output(row-windowSize,col-windowSize)=nansum(nansum(toSmooth(row-windowSize:row+windowSize,col-windowSize:col+windowSize).*toApply));
        end
    end
end

output=output.*(input~=0);
output=output./nansum(output(:));

return;







for row=1:dims(1) % for all points in the surface to smooth
    for col=1:dims(2)
        if ~isnan(toSmooth(row,col)) % if the entry is not NaN
            appliedKernel=kernel;
            if row < windowSize+1 % if the kernel extends beyond the top of the surface to smooth, 
                appliedKernel = appliedKernel(windowSize+1-row:windowSize,:); % cut off the top rows which are out of bounds
            elseif row+windowSize > dims(1) % if the kernel extends beyond the bottom of the surface to smooth, 
                appliedKernel = appliedKernel(1:windowSize+1+dims(1)-row,:); % cut off the bottom rows which are out of bouds
            end
            % now handle the column edges
            if col < windowSize+1 % if the kernel extends beyond the top of the surface to smooth,
                appliedKernel = appliedKernel(:,windowSize+1-row:windowSize); % cut off the top rows which are out of bounds
            elseif col+windowSize > dims(2) % if the kernel extends beyond the bottom of the surface to smooth, 
                appliedKernel = appliedKernel(:,1:windowSize+1+dims(1)-row); % cut off the bottom rows which are out of bouds
            end
            % remove any NaN entries and re-normalize
   %         toSmooth()
        end
    end
end