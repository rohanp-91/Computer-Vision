function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('traintest.mat');

	% TODO Implement your code here
    
    conf = zeros(size(mapping,2), size(mapping,2));
    
    
    for k = 1:length(test_imagenames)
        
        fullPath = '/Users/utopiansocialist/Documents/MATLAB/matlab_workspace/CSE 573/Assignment - 1/release/data/';
        imgFile = fullfile(fullPath, test_imagenames{k});
        guessedImage = guessImage(imgFile);
        class_index = test_labels(k);
        disp(strcat('Class Index: ', num2str(class_index)));
        guess_index = find(contains(mapping, guessedImage));
        disp(strcat('Guess Index: ', num2str(guess_index)));
        conf(class_index, guess_index) = conf(class_index, guess_index) + 1;
        
    end
    
    accuracy = (trace(conf)/ sum(conf(:))) * 100;
    disp(accuracy);
    
end