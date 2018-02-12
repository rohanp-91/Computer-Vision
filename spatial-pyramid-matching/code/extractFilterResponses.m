function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses


% % % TODO Implement your code here% 
     
      if (~isa(img, 'double'))         
          img = double(img);         
      end
  
     if (size(img, 3) == 1)
         img = repmat(img, [1 1 3]);
     end
    
    [L, a, b] = RGB2Lab(img(:, :, 1), img(:, :, 2), img(:, :, 3));
    
    filterResponses = zeros(size(img,1), size(img, 2), length(filterBank)*3);
    
 
    for k = 1:length(filterBank)
        
        L_filt = imfilter(L, filterBank{k}, 'same', 'conv', 'replicate');
        filterResponses(:, :, k*3-2) = L_filt;
        
        a_filt = imfilter(a, filterBank{k}, 'same', 'conv', 'replicate');
        filterResponses(:, :, k*3-1) = a_filt;
        
        b_filt = imfilter(b, filterBank{k}, 'same', 'conv', 'replicate');
        filterResponses(:, :, k*3) = b_filt;
    end

end
