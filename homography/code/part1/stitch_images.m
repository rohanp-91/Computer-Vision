
function [output, inliers_n] = stitch_images(img_l, img_r, blob_parms, ransac_parms, putative_thresh)


%Detect feature points
blobs_l = blob_detect_efficient(img_l, blob_parms.sigma, blob_parms.n, blob_parms.k);
blobs_r = blob_detect_efficient(img_r, blob_parms.sigma, blob_parms.n, blob_parms.k);


%Generate SIFT descriptor
sift_l = find_sift(img_l, blobs_l, 1.5);
sift_r = find_sift(img_r, blobs_r, 1.5);

%Select putative matches that meets the putative_threshold condition
matches = computeMatches(sift_l, sift_r, putative_thresh);
%disp(size(matches));

%Use RANSAC model to estimate homography mapping
[inliers, inliers_n, H] = ransac(matches, blobs_l, blobs_r, ransac_parms.iter, ransac_parms.thresh);

disp(inliers_n);

bestMatches = zeros(size(matches));
bestMatches(inliers) = matches(inliers);

displayMatched(img_l, img_r, blobs_l, blobs_r, bestMatches);
output = mergeImages(img_l, img_r, H);

end