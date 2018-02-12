function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    
    disp('running SPM');
    
    L = layerNum - 1;
    h = zeros((4^(L + 1) -1)/3, dictionarySize);
    hMem = zeros(2^(L), 2^(L));
    count = 1;
    
    for m = L:-1:0
        
        cells = 2^m;
        cellLength = floor(size(wordMap,1)/cells);
        cellWidth = floor(size(wordMap,2)/cells);
        weight = 1/2;
        
        for j = 1:cells
            for k = 1: cells
                
                if m == L
                    
                    eachCell = wordMap((j-1)*cellLength + 1 : ...
                                j*cellLength, (k-1)*cellWidth + 1 : ...
                                k*cellWidth);
                    h(count, :) = getImageFeatures(eachCell, dictionarySize) * weight;
                    
                else
                    
                    h(count, :) = h(hMem((j*2 - 1), (k*2 - 1)), :) + ...
                                    h(hMem((j*2 - 1), (k*2)), :) + ...
                                    h(hMem(j*2, (k*2 - 1)), :) + ...
                                    h(hMem(j*2, k*2), :);
                    if m ~= 0
                        
                        h(count, :) = h(count, :) * weight;
                        
                    end
                    
                end
                
                hMem(j,k) = count;
                count = count + 1;
                
            end
            
        end
        
    end
    
    h = reshape(h, size(h,1) * size(h,2), 1);
    h = h(:, 1)/sum(h(:, 1));
    
end
                      