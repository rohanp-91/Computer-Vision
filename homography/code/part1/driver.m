blob_parms.sigma = 2;
blob_parms.n = 12;
blob_parms.k = 1.5;

ransac_parms.iter = 100;
ransac_parms.thresh = 3;

putative_thresh = 0.8;

img_l = imread('left.jpg');
img_r = imread('right.jpg');

stitched = stitch_images(img_l, img_r, blob_parms, ransac_parms, putative_thresh);

figure();
imshow(stitched);