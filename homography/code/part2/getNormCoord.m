function [ transform, normCoord ] = getNormCoord( homoCoord )

    center = mean(homoCoord(:,1:2)); 
    
    offset = eye(3);
    offset(1,3) = -center(1); 
    offset(2,3) = -center(2); 

    sX= max(abs(homoCoord(:,1)));
    sY= max(abs(homoCoord(:,2)));
    
    scale = eye(3);
    scale(1,1)=1/sX;
    scale(2,2)=1/sY;          
                
    transform = scale * offset;
    normCoord = (transform * homoCoord')';
end