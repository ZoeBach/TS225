function [H_enforme] = identification(X_1,Y_1, X_2, Y_2)

% On retourne H la matrice d'homographie
A = zeros(8,8);
B = zeros(1,8);
for i = 1:4
    A(2*i -1,:) = [X_1(i) Y_1(i) 1 0 0 0 -X_1(i)*X_2(i) -Y_1(i)*Y_2(i)];
    A(2*i,:) = [0 0 0 X_1(i) Y_1(i) 1 -X_1(i)*Y_2(i) -Y_1(i)*Y_2(i)];
    B(1, 2*i -1) = X_2(i);
    B(1,2*i) = Y_2(i);
end

H = A\B';
    
H_enforme = zeros(3,3);

k = 1;
for i = 1 : length(H_enforme)
    for j = 1 : length(H_enforme)
        if ((i == 3) && (j == 3))
            H_enforme(i,j) = 1;
        else
            H_enforme(i,j) = H(k);
            k = k + 1;
        end
    end
end

end