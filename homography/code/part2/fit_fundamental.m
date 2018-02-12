function F = fit_fundamental(matches, norm)

    x1 = matches(:,1:2);
    x2 = matches(:,3:4);
    
    homo_x1 = ones(length(x1), 1);
    homo_x2 = ones(length(x2), 1);
    
    x1 = cat(2, x1, homo_x1);
    x2 = cat(2, x2, homo_x2);
    
    if norm == 1
        [trans_1, x1_norm] = getNormCoord(x1);
        [trans_2, x2_norm] = getNormCoord(x2);
    
        x1 = x1_norm;
        x2 = x2_norm;
    end 
        
    u1 = x1(:,1);
    v1 = x1(:,2);
    u2 = x2(:,1);
    v2 = x2(:,2);
   
    
    temp = [ u2.*u1, u2.*v1, u2, v2.*u1, v2.*v1, v2, u1, v1, ones(size(matches,1), 1)];
    
    [~,~,V] = svd(temp);
    F = V(:,9);
    
    F = reshape(F, 3,3); 
    [U,S,V] = svd(F);
    
    S(end) = 0;
    F = U*S*V';
    
    if norm == 1
        F = trans_2' * F * trans_1;
    end
    
end