function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % TODO Implement your code here

    if(size(img,3) == 1)
        
        img = repmat(img, [1 1 3]);
        
    end
    
    filterResponses = extractFilterResponses(img, filterBank);
    filterResponses = reshape(filterResponses, size(img,1) * size(img,2), []);
    
    dist = pdist2(filterResponses, dictionary);
    
    [~, wordMap] = min(dist, [], 2);
    
    wordMap = reshape(wordMap, [size(img,1) size(img,2)]);
    
end
