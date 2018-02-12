
img_l = imread('library1.jpg');
img_r = imread('library2.jpg');

%Detect feature points
blobs_l = blob_detect_efficient(img_l, 2, 12, 1.5);
blobs_r = blob_detect_efficient(img_r, 2, 12, 1.5);

%Generate SIFT descriptor
sift_l = find_sift(img_l, blobs_l);
sift_r = find_sift(img_r, blobs_r);

%Select putative matches that meets the putative_threshold condition
matches = computeMatches(sift_l, sift_r, 0.5);
disp(size(matches));

%Use RANSAC model to estimate homography mapping
[inliers, inliers_n, H] = ransac(matches, blobs_l, blobs_r, 2000, 7);


bestMatches(inliers) = matches(inliers);
disp(inliers_n);

matches_l = zeros(inliers_n, 2);
matches_r = zeros(inliers_n, 2);

count = 1;

for i=1:length(bestMatches)
    if bestMatches(i) > 0
        matches_l(count, :) = blobs_l(i, 1:2);
        matches_r(count, :) = blobs_r(bestMatches(i), 1:2);
        count = count + 1;
    end
end

clear matches;
matches = cat(2, matches_l, matches_r);

disp(matches);


N = length(matches);
% first, fit fundamental matrix to the matches
F = fit_fundamental(matches, 1); % this is a function that you should write
L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
disp(mean(abs(pt_line_dist)));
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);


% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;


I2 = img_r;
% display points and segments of corresponding epipolar lines
clf;
imshow(I2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
