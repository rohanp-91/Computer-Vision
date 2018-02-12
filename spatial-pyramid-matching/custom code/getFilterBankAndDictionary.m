function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();

    % TODO Implement your code here

    T = length(imPaths);
    F = length(filterBank);
    
    K = 250;
    alpha = 150;
    
    finalFilterResponses = zeros(alpha*T, 3*F);
    
    for k = 1:length(imPaths)
        
        img = imread(imPaths{k});
        filterResponses = reshape(extractFilterResponses(img, filterBank), ...
                            size(img,1) * size(img,2), []);
        
        alphaRows = randperm(size(filterResponses,1), alpha);
        alphaResponses = filterResponses(alphaRows, :);
        
        startIndex = (k - 1)*alpha + 1;
        endIndex = startIndex + alpha - 1;
        
        finalFilterResponses(startIndex:endIndex, :) = alphaResponses;
        
    end
    
    [~, dictionary] = kmeans(finalFilterResponses, K, 'EmptyAction', 'drop');
    
end
