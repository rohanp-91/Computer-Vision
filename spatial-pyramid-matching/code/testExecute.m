% This script does the following:

% 1) [first section] executes extractFilterResponses function and displays
%    the filter responses of each of the 20 different filters in the form
%    of a collage, for a given image.
%    
% 2) [second section] visualizes the wordMap created by the function
%    getVisualWords for three different images of the same category
%    alongside the original images, using the function imagesc().
%
% 3) [third section] tests the function guessImage for a given image
%    
% 4) [fourth section] executes the function evaluateRecognitionSystem and
%    prints the accuracy of recognition.

%% [first section]

img = imread('sun_advbapyfkehgemjf.jpg');

filterBank = createFilterBank();
filterResponses = extractFilterResponses(img, filterBank);
filterResponses = reshape(filterResponses, size(img,1), size(img,2), 3, []);

montage(filterResponses, 'size', [4 5]);

%% [second section]

load 'dictionary.mat';

img = imread(strcat('../data/garden', 'sun_aanfdszdggeqrclh.jpg'));
subplot(2,3,1);
imshow(img);
load '../data/garden/sun_aanfdszdggeqrclh.mat';
subplot(2,3,4);
imagesc(wordMap);

img = imread(strcat('../data/garden', 'sun_adtzimfqhvctqjdc.jpg'));
subplot(2,3,2);
imshow(img);
load '../data/garden/sun_adtzimfqhvctqjdc.mat';
subplot(2,3,5);
imagesc(wordMap);

img = imread(strcat('../data/', 'sun_advxoxobydqwuawd.jpg'));
subplot(2,3,3);
imshow(img);
load '../data/garden/sun_advxoxobydqwuawd.mat';
subplot(2,3,6);
imagesc(wordMap);


%% [third section]

guessImage('sun_aanfdszdggeqrclh.jpg');

%% [fourth section]

evaluateRecognitionSystem();


