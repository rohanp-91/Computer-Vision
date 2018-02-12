function blobs = blob_detect_efficient(img, sigma_init, numOfScales, k)

img = rgb2gray(img);
img = im2double(img);

[height, width] = size(img);
scale_space = zeros(height, width, numOfScales);

filtSize = 2*ceil(3*sigma_init) + 1;
LoG = sigma_init^2 * fspecial('log', filtSize, sigma_init);

%keeping filter size same and downsampling image

imgTemp = img;
 
 tic
 for s = 1:numOfScales
     imgFilt = imfilter(imgTemp, LoG, 'same', 'replicate');
     imgFilt = imgFilt .^ 2;
     scale_space(:, :, s) = imresize(imgFilt, size(img), 'bicubic');
     if s < numOfScales
         imgTemp = imresize(img, 1/(k^s), 'bicubic');
     end
 end
 toc


%non-maximum suppression in each scale  

supKern = 3;
maxScaleSpace = zeros(height, width, numOfScales);
for s = 1:numOfScales   
    maxScaleSpace(:, :, s) = ordfilt2(scale_space(:, :, s), supKern^2, ones(supKern));
end

%create adaptive threshold for each scale using Otsu's method

thresh = zeros([1 numOfScales]);
for s = 1:numOfScales
    thresh(:, s) = multithresh(maxScaleSpace(:, :, s));
end


%non-maximum suppression between scales

maxScaleSpace(:, :, 1) = max(maxScaleSpace(:, :, 1:2), [], 3);
for s = 2:(numOfScales - 1)  
    maxScaleSpace(:, :, s) = max(maxScaleSpace(:, :, (s-1):(s+1)), [], 3);
end
maxScaleSpace(:, :, numOfScales) = max(maxScaleSpace(:, :, (numOfScales - 1): ...
                                         numOfScales), [], 3);                     
maxScaleSpace = maxScaleSpace .* (maxScaleSpace == scale_space);

%calculating the location of blobs

row = [];
col = [];
rad = [];

for s = 1:numOfScales
    [r, c] = find(maxScaleSpace(:,:,s) >= thresh(:, s));
    numBlobs = length(r);
    radius =  sigma_init * k^(s-1) * sqrt(2); 
    radius = repmat(radius, numBlobs, 1);
    row = [row; r];
    col = [col; c];
    rad = [rad; radius];
end

blobs = [col, row, rad];

%displaying the result

%show_all_circles(img, col, row, rad, 'r', 1.5);


