% This function visualizes the wordMap created by the function
% getVisualWords for three different images of the same category
% alongside the original images, using the function imagesc().


load 'sun_aaaxsldstlpzwrbe.mat';
load 'dictionary.mat';
imagesc(wordMap);
% h = getImageFeatures(wordMap, size(dictionary,1));
clc
% 
%fullPath = '/Users/utopiansocialist/Documents/MATLAB/matlab_workspace/CSE 573/Assignment - 1/release/data/garden/';
 
% guessedImage = guessImage(strcat(fullPath, 'sun_aanfdszdggeqrclh.jpg'));
% index = find(contains(mapping, guessedImage));
% disp(index);


evaluateRecognitionSystem();