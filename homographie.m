function [M2] = homographie(H,M)
    M2=[];
    dim=size(M);
    for ii=1:dim(1)
        x = (H(1,1)*M(ii,1)+H(1,2)*M(ii,2)+H(1,3))/(H(3,1)*M(ii,1)+H(3,2)*M(ii,2)+H(3,3));
        y = (H(2,1)*M(ii,1)+H(2,2)*M(ii,2)+H(2,3))/(H(3,1)*M(ii,1)+H(3,2)*M(ii,2)+H(3,3));
        M2 = [M2;[x,y]];
    end
    
end