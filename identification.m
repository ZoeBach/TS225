function [X_rect,Y_rect] = identification(X,Y)

% points repères du quadrangle donnent points repère du rectangle

X_rect = zeros(1,4);
Y_rect = zeros(1,4);

X_rect(1) = 1;
Y_rect(1) = 1;

dist_x = round(sqrt((X(2) - X(1))^2 + (Y(2) - Y(1))^2 ));
dist_y = round(sqrt((X(3) - X(1))^2 + (Y(3) - Y(1))^2 ));

X_rect(2) = X_rect(1) + dist_x;
Y_rect(2) = Y_rect(1);

X_rect(3) = X_rect(1);
Y_rect(3) = Y_rect(1) + dist_y;

X_rect(4) = X_rect(2);
Y_rect(4) = Y_rect(3);

end