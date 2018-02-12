function im = mergeImages(im1, im2, transf)


invtransf = inv(transf(:, 1:2));
invtransf = [invtransf, -invtransf*transf(:,end)];

[h1, w1, ~] = size(im1);
[h2, w2, ~] = size(im2);
im2 = double(im2);

c2 = [1 w2 w2 1; 1 1 h2 h2];

%Calculate transformed pixel coordinates
c2 = transf*[c2; ones(1, size(c2, 2))];

%Calculate maximum and minimum dimensions
txmin = floor(min(c2(1,:)));
txmax = ceil(max(c2(1,:)));
tymin = floor(min(c2(2,:)));
tymax = ceil(max(c2(2,:)));

%Calculate new dimensions of the final image
xmin = floor(min(1, txmin));
xmax = ceil(max(w1, txmax));
ymin = floor(min(1, tymin));
ymax = ceil(max(h1, tymax));

h = ymax-ymin+1;    w = xmax-xmin+1;
im = zeros(h, w, size(im1,3), 'uint8');
ox = max(0, -xmin+1);
oy = max(0, -ymin+1);

im(oy+(1:h1), ox+(1:w1),:) = im1;
[X, Y] = meshgrid(txmin:txmax, tymin:tymax);
X = X(:);   Y = Y(:);

%Calculate area of overlap
overlap = X>=1 & X<=w1 & Y>=1 & Y<=h1;
X(overlap) = [];    Y(overlap) = [];
c = [X(:), Y(:), ones(numel(X), 1)]';
c = invtransf*c;


valid = c(1,:)>1 & c(1,:)<=w2 & c(2,:)>1 & c(2,:)<=h2;
sel = 1:size(c, 2); sel = sel(valid);
c = c(:, sel); X = X(sel); Y = Y(sel);

[X1, Y1] = meshgrid(1:w2, 1:h2);
Vqr = interp2(X1, Y1, im2(:,:,1), c(1,:), c(2,:));
Vqg = interp2(X1, Y1, im2(:,:,2), c(1,:), c(2,:));
Vqb = interp2(X1, Y1, im2(:,:,3), c(1,:), c(2,:));

Vqr(Vqr<0) = 0; Vqr(Vqr>255) = 255;
Vqg(Vqg<0) = 0; Vqg(Vqg>255) = 255;
Vqb(Vqb<0) = 0; Vqb(Vqb>255) = 255;

for i=1:numel(X)
    im(oy+Y(i), ox+X(i), :) = uint8([Vqr(i), Vqg(i), Vqb(i)]);
end

im = uint8(im);