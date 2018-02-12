function evaluateRecognitionSystem(numOfCores)
% Evaluates the recognition system for all test-images and returns the confusion matrix
    
    if(nargin < 1)
        
        numOfCores = 2
        
    end
    
    try
        fprintf('Closing any pools...\n');
        delete(gcp('nocreate')); 
    catch ME
        disp(ME.message);
    end
      
    fprintf('Starting a pool of workers with %d cores\n', numOfCores);
    parpool('local',numOfCores);
    
	load('vision.mat');
	load('traintest.mat');

	% TODO Implement your code here
       
    mapping = mapping;
    test_imagenames = test_imagenames;
    test_labels = test_labels;
    
    conf = zeros(length(mapping), length(mapping));
    
    parfor k = 1:length(test_imagenames)
        
        imgFile = fullfile('../data/', test_imagenames{k});
        guessedImage = guessImage(imgFile);
        class_index = test_labels(k);
        guess_index = contains(mapping, guessedImage);
        tempConf = zeros(length(mapping));
        tempConf(class_index, guess_index) = 1;
        conf = conf + tempConf;
        
    end
    
    accuracy = (trace(conf)/ sum(conf(:))) * 100;
    disp(accuracy);
    fprintf('Closing the pool\n');
    delete(gcp('nocreate'));

end