cam1 = load('house1_camera.txt');
cam2 = load('house2_camera.txt');
matches = load('house_matches.txt');


[~, ~, V] = svd(cam1);
cam1center = V(:,end);
%disp(cam1center);
for i=1:size(cam1center,1)
    last = cam1center(end);
    cam1center(i) = cam1center(i)/last;
end
%cam1center = cam1center(:, 1:size(cam1center,2)-1);
disp(cam1center);
[~, ~, V] = svd(cam2);
cam2center = V(:,end);
disp(cam2center);
for i=1:size(cam2center,1)
    last = cam2center(end);
    cam2center(i) = cam2center(i)/last;
end
disp(cam2center);
%cam2center = cam2center(:, 1:size(cam2center,2)-1);

x1 = matches(:,1:2);
x2 = matches(:,3:4);

homo_x1 = ones(length(x1), 1);
homo_x2 = ones(length(x2), 1);

x1 = cat(2, x1, homo_x1);
x2 = cat(2, x2, homo_x2);

n = size(x1, 1);
tri_pts = zeros(n, 3);
proj_pts1 = zeros(n, 2);
proj_pts2 = zeros(n, 2);

for i=1:n
    p1 = x1(i, :);
    p2 = x2(i, :);
   
    mat1 = [  0   -p1(3)  p1(2); p1(3)   0   -p1(1); -p1(2)  p1(1)   0  ];
    mat2 = [  0   -p2(3)  p2(2); p2(3)   0   -p2(1); -p2(2)  p2(1)   0  ];
    
    mat = [mat1*cam1; mat2*cam2];
    [~, ~, V] = svd(mat);
    tri_pts_homo = V(:, end)';
    %disp(size(tri_pts_homo));
    tri_pts_homo = tri_pts_homo./tri_pts_homo(length(tri_pts_homo));
    tri_pts_homo = tri_pts_homo(1:length(tri_pts_homo) -1);
    
    %disp(size(tri_pts_homo));
    
    tri_pts(i, :) = tri_pts_homo;
    
    %disp(size(cam1));
    
    camproj1 = (cam1'*tri_pts_homo')';
    camproj1 = camproj1./camproj1(length(camproj1));
    camproj1 = camproj1(1:length(camproj1)-2);
    proj_pts1(i, :) = camproj1;
    
    camproj2 = (cam2'*tri_pts_homo')';
    camproj2 = camproj2./camproj2(length(camproj2));
    camproj2 = camproj2(1:length(camproj2)-2);
    proj_pts1(i, :) = camproj2;
    
end

figure;
axis equal;
hold on;

figure; axis equal;  hold on; 
plot3(-tri_pts(:,1), tri_pts(:,2), tri_pts(:,3), '.r');
plot3(-cam1center(1), cam1center(2), cam1center(3),'*g');
plot3(-cam2center(1), cam2center(2), cam2center(3),'*b');
grid on; xlabel('x'); ylabel('y'); zlabel('z'); axis equal;

    