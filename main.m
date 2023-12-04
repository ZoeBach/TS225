close all
clear
clc

%% Paramètres

IMG = imread("photo.jpeg");

X_2 = [0, 1, 0, 1];

Y_2 = [0, 0, 1, 1];

% Prendre les points dans le sens horaire en partant d'en haut à gauche

%% 3.1 Travaux péparatoires sur l'homographie


% Choix des sommets du quadrangle

imshow(IMG);
title('Choix des sommets du quadrangle');
[X, Y] = ginput(4);
close;

H = identification(X, Y, X_2, Y_2);
H_gpt = identification2(X, Y, X_2, Y_2);

M = [X, Y];

M2 = homographie(H,M);
M2_gpt = homographie(H_gpt,M);

close;

% Fonction d'identification pour calculer la matrice d'homographie
function h = identification2(X, Y, X_2, Y_2)
    n = length(X);
    A = [];
    b = [];
    for i = 1:n
        A = [A;
             X(i), Y(i), 1, 0, 0, 0, -X_2(i)*X(i), -X_2(i)*Y(i);
             0, 0, 0, X(i), Y(i), 1, -Y_2(i)*X(i), -Y_2(i)*Y(i)];
        b = [b; X_2(i); Y_2(i)];
    end
    h = A\b;
    h = [h; 1]; % Ajouter le 1 pour la dernière valeur de h
    h = reshape(h, 3, 3)';
end

% Fonction pour appliquer la matrice d'homographie à l'image
function IMG_transformee = homographie2(IMG, hMatrix, rect_width, rect_height)
    h = projective2d(hMatrix');
    outputView = imref2d([rect_height, rect_width]); 
    IMG_transformee = imwarp(IMG, h, 'OutputView', outputView);
end
