function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('traintest.mat');

	% TODO create train_features
    
    L = 2;             % L = numOfLayers - 1. numOfLayers = 3 for this project.
    fullPath = '/Users/utopiansocialist/Documents/MATLAB/matlab_workspace/CSE 573/Assignment - 1/release/data/';
    
    train_features = zeros((4^(L+1) - 1)/3 * size(dictionary,1), length(train_imagenames));
    
    for k = 1:length(train_imagenames)
        
        imageFileName = strrep(strcat(fullPath,train_imagenames{k, 1}), '.jpg', '.mat');
        load(imageFileName);
        
        h = getImageFeaturesSPM((L + 1), wordMap, size(dictionary, 1));
        h = reshape(h, size(h,1) * size(h,2), 1);
        
        train_features(:, k) = h;
        
    end
    

	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end