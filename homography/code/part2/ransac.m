function [inliers, inliers_n, transf] = ransac(matches, c1, c2, ransac_iter, ransac_thresh)

N_match = size(matches,1);
M = size(c2,1);
arr = [];

%Creating an array of the corner coordinates of the second image
for x = 1:M
    arr = [arr;([c2(x,1) c2(x,2)])];
end

arr = [arr ones(M,1)];
inliers = [];
inliers_n = 0;
sample_size = 4;

%Creating a randomized array from the sample set with sample size = 4
for num_iter = 1:ransac_iter
    random_array = [];
    random_numbers = randi([1, N_match], 1, 1);
    c=1;
    while(c<=sample_size)
        if(matches(random_numbers,1)~=0)
            random_array = [random_array; random_numbers];
            c=c+1;
        end
        random_numbers = randi([1, N_match], 1, 1);
    end
    
matrix_A = [];
matrix_B = [];

%Generating the homography (non-homogeneous system) = points_for_img_left/points_for_img_right
for x=1:size(random_array,1)
    in = random_array(x);
    x1 = c1(in,1);
    y1 = c1(in,2);
    matrix_B = [matrix_B; [x1,y1]];
    x1_prime = c2(matches(in),1);
    y1_prime = c2(matches(in),2);
    matrix_A = [matrix_A;([x1_prime, y1_prime, 1])];
end

res = matrix_A\matrix_B;
H = arr*res;

number_of_inliers = 0;
best =[];
residual = [];

%Calculating best model based on ransac threshold
for x=1:N_match
    if(matches(x,1)~=0)
        x1 = c1(x,1);
        y1 = c1(x,2);
        if((((x1-H(matches(x),1))^2)+((y1-H(matches(x),2))^2))<=ransac_thresh)
            number_of_inliers = number_of_inliers + 1;
            best = [best;x];
            residual = [residual; sqrt((x1-H(matches(x),1))^2)+((y1-H(matches(x),2))^2)];
        end
    end
end

%Returning the best model values
if(number_of_inliers>inliers_n)
    inliers_n = number_of_inliers;
    inliers = best;
    transf = res;
    transf = transf';
    residual = mean(mean(residual));
end

%disp(residual);

end