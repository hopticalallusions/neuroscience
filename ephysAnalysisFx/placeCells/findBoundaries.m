function [ labeledMatrix, labels, regionSizes ] = findBoundaries( data, threshold, minSize )

    % this is not an especially clever implementation, but it works.

    if nargin < 2
        threshold=1;
    end
    if nargin < 3
        minSize = 0;
    end

    %create variables
    labeledMatrix = zeros(size(data));
    temp=size(data);
    rows=temp(1);
    cols=temp(2);
    regionCounter = 0;

    % for all rows and columns, check to see if there is data
    % assign a label
    %        if any neighbor has a label, assign that label
    %        if not, assign a new label
    % now distribute that label to all neighbors with data
    for ii=2:rows-1
        for jj=1:cols-1
            % if there is data, label the region with the neighbors
            if data(ii,jj) > threshold
                if labeledMatrix(ii-1,jj-1) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii-1,jj-1);
                elseif labeledMatrix(ii,jj-1) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii,jj-1);
                elseif labeledMatrix(ii+1,jj-1) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii+1,jj-1);
                elseif labeledMatrix(ii-1,jj) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii-1,jj);
                elseif labeledMatrix(ii+1,jj) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii+1,jj);
                elseif labeledMatrix(ii-1,jj+1) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii-1,jj+1);
                elseif labeledMatrix(ii,jj+1) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii,jj+1);
                elseif labeledMatrix(ii+1,jj+1) > 0
                    labeledMatrix(ii,jj) = labeledMatrix(ii+1,jj+1);
                else
                    % or create a new region
                    regionCounter=regionCounter+1;
                    labeledMatrix(ii,jj) = regionCounter;
                end
                % now label the neighbors with this label, whatever it is.
                if data(ii-1,jj-1) > threshold
                    labeledMatrix(ii-1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj) > threshold
                    labeledMatrix(ii-1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj+1) > threshold
                    labeledMatrix(ii-1,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj-1) > threshold
                    labeledMatrix(ii,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj+1) > threshold
                    labeledMatrix(ii,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj-1) > threshold
                    labeledMatrix(ii+1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj) > threshold
                    labeledMatrix(ii+1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj+1) > threshold
                    labeledMatrix(ii+1,jj+1) = labeledMatrix(ii,jj);
                end
            end
        end
    end

    %figure; subplot(2,2,1); imagesc(labeledMatrix); title('labels');

    
    % order of processing matters, so go through and relabel everything in
    % all the other directions
    for jj=1:cols-1
        for ii=2:rows-1
            % if there is data, label the region with the neighbors
            if data(ii,jj) > threshold
                % now label the neighbors with this label, whatever it is.
                if data(ii-1,jj-1) > threshold
                    labeledMatrix(ii-1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj) > threshold
                    labeledMatrix(ii-1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj+1) > threshold
                    labeledMatrix(ii-1,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj-1) > threshold
                    labeledMatrix(ii,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj+1) > threshold
                    labeledMatrix(ii,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj-1) > threshold
                    labeledMatrix(ii+1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj) > threshold
                    labeledMatrix(ii+1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj+1) > threshold
                    labeledMatrix(ii+1,jj+1) = labeledMatrix(ii,jj);
                end
            end
        end
    end

    %subplot(2,2,2); imagesc(labeledMatrix); title('labels');


    for ii=rows-1:-1:2
        for jj=cols-1:-1:2
            % if there is data, label the region with the neighbors
            if data(ii,jj) > threshold
                % now label the neighbors with this label, whatever it is.
                if data(ii-1,jj-1) > threshold
                    labeledMatrix(ii-1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj) > threshold
                    labeledMatrix(ii-1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj+1) > threshold
                    labeledMatrix(ii-1,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj-1) > threshold
                    labeledMatrix(ii,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj+1) > threshold
                    labeledMatrix(ii,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj-1) > threshold
                    labeledMatrix(ii+1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj) > threshold
                    labeledMatrix(ii+1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj+1) > threshold
                    labeledMatrix(ii+1,jj+1) = labeledMatrix(ii,jj);
                end
            end
        end
    end

    %subplot(2,2,3); imagesc(labeledMatrix); title('labels');

    for jj=cols-1:-1:2
        for ii=rows-1:-1:2
            % if there is data, label the region with the neighbors
            if data(ii,jj) > threshold
                % now label the neighbors with this label, whatever it is.
                if data(ii-1,jj-1) > threshold
                    labeledMatrix(ii-1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj) > threshold
                    labeledMatrix(ii-1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii-1,jj+1) > threshold
                    labeledMatrix(ii-1,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj-1) > threshold
                    labeledMatrix(ii,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii,jj+1) > threshold
                    labeledMatrix(ii,jj+1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj-1) > threshold
                    labeledMatrix(ii+1,jj-1) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj) > threshold
                    labeledMatrix(ii+1,jj) = labeledMatrix(ii,jj);
                end
                if data(ii+1,jj+1) > threshold
                    labeledMatrix(ii+1,jj+1) = labeledMatrix(ii,jj);
                end
            end
        end
    end

    %subplot(2,2,4); imagesc(labeledMatrix); title('labels');

    % find all the labels
    [~,~,values]=find(labeledMatrix);
    labels=sort(unique(values));
    
    % measure the size of the regions
    regionSizes = zeros(size(labels));
    for ii=1:length(labels)
        regionSizes(ii)=sum(sum((labeledMatrix==labels(ii))));
    end

    % eliminate regions that are insufficiently large
    idxs=find(regionSizes < minSize);
    for ii=1:length(idxs)
        labeledMatrix(find(labeledMatrix == labels(idxs(ii))))=0;
    end
    regionSizes(idxs)=[];
    labels(idxs)=[];
    
    % compress the label values into the smallest non-zero integer set
    [~,~,values]=find(labeledMatrix);
    labels=sort(unique(values));
    if max(values) > length(labels)
        for ii=1:length(labels)
            if labels(ii)>ii
                labeledMatrix(find(labeledMatrix==labels(ii)))=ii;
            end
        end
    end
    [~,~,values]=find(labeledMatrix);
    labels=sort(unique(values));
    
return;

% 
% 
% 
% threshold=1;
% [rr,cc]=find(data>threshold);
% labels=zeros(size(rr));
% contiguousRegion=0;
% if ~isempty(rr)
%     for ii=1:length(rr)-1
%         if ( rr(ii+1) == rr(ii) ) || ( rr(ii+1) == rr(ii)+1 ) || ( rr(ii+1) == rr(ii)-1 ) && ( cc(ii+1) == rr(ii) ) || ( cc(ii+1) == rr(ii)+1 ) || ( cc(ii+1) == rr(ii)-1 )
%             regionSize = regionSize+1;
%         else
%             disp([' contiguous region ' num2str(contiguousRegion) ' ; size = ' num2str(regionSize) ] )
%             regionSize = 0;
%             contiguousRegion = contiguousRegion + 1;
%         end
%         %disp([ 'nextRow  ' num2str(rr(ii+1)) '  nextCol  ' num2str(cc(ii+1)) '  thisRow  ' num2str(rr(ii)) '  thisCol  ' num2str(cc(ii)) ])
%     end
% else
%     contiguousRegion=1;
% end
% 
% 


% 
% 
% 
% function infect( ii, jj, data, labeledRegions)
%     temp=size(data);
%     rows=temp(1);
%     cols=temp(2);
%     if ( data(ii-1,jj-1) > 0 ) &&
%         labeledRegions(ii-1,jj-1) = labeledRegions(ii,jj);
%     elseif data(ii-1,jj) > 0
%         labeledRegions(ii-1,jj) = labeledRegions(ii,jj);
%     elseif data(ii-1,jj+1) > 0
%         labeledRegions(ii-1,jj+1) = labeledRegions(ii,jj);
%     elseif data(ii,jj-1) > 0
%         labeledRegions(ii,jj-1) = labeledRegions(ii,jj);
%     elseif data(ii,jj+1) > 0
%         labeledRegions(ii,jj+1) = labeledRegions(ii,jj);
%     elseif data(ii+1,jj-1) > 0
%         labeledRegions(ii+1,jj-1) = labeledRegions(ii,jj);
%     elseif data(ii+1,jj) > 0
%         labeledRegions(ii+1,jj) = labeledRegions(ii,jj);
%     elseif data(ii+1,jj+1) > 0
%         labeledRegions(ii+1,jj+1) = labeledRegions(ii,jj);
%     
% 
% 
% labeledRegions = zeros(size(data));
% temp=size(data);
% rows=temp(1);
% cols=temp(2);
% regionCounter = 0;
% for ii=2:rows-1
%     for jj=1:cols-1
%         if ( data(ii,jj) > 0 ) && ( labeledRegions(ii,jj) == 0 )
%                 regionCounter=regionCounter+1;
%                 labeledRegions(ii,jj) = regionCounter;
%                 
%         elseif ( data(ii,jj) > 0 )
%             % spread label like a virus
%             qq=ii;
%             ww=jj;
%             while ( qq > 1 ) && ( qq < rows )
%                 while  ( ww > 1 ) && ( ww < cols )
%                     if labeledRegions(ii-1,jj-1) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii-1,jj-1);
%                     elseif labeledRegions(ii-1,jj) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii-1,jj);
%                     elseif labeledRegions(ii-1,jj+1) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii-1,jj+1);
%                     elseif labeledRegions(ii,jj-1) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii,jj-1);
%                     elseif labeledRegions(ii,jj+1) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii,jj-1);
%                     elseif labeledRegions(ii+1,jj-1) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii,jj-1);
%                     elseif labeledRegions(ii+1,jj) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii,jj-1);
%                     elseif labeledRegions(ii+1,jj+1) > 0
%                         labeledRegions(ii,jj) = labeledRegions(ii,jj-1);
%                     else
%         end
%     end
% end
% figure; imagesc(data); title('data');
% figure; imagesc(labeledRegions); title('labels');
% 
% 
% 
% 


            


% 
% I = imread('rice.png');
% % Convert grayscale image to binary image using local adaptive thresholding.
% %BW = imbinarize(I);
% BW = imbinarize(data);
% % Calculate boundaries of regions in image and overlay the boundaries on the image.
% [B,L] = bwboundaries(BW,'noholes');
% figure;
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end



