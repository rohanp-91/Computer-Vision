% Computes filter bank and dictionary, and saves it in dictionary.mat 

function computeDictionary()

	load traintest.mat

	interval= 1;
	train_imagenames = train_imagenames(1:interval:end);
    fullPath = '/Users/utopiansocialist/Documents/MATLAB/matlab_workspace/CSE 573/Assignment - 1/release/data/';
	[filterBank,dictionary] = getFilterBankAndDictionary(strcat(fullPath,train_imagenames));

	save('dictionary.mat','filterBank','dictionary'); 

end
