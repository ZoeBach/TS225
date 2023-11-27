close all
clear
clc

%% Paramètres

IMG = imread("photo.jpeg");

X_2 = [0, 0, 1, 1];

Y_2 = [0, 1, 0, 1];

%% 3.1 Travaux péparatoires sur l'homographie

% Choix des sommets du quadrangle

imshow(IMG);
title('Choix des sommets du quadrangle');
[X, Y] = ginput;

H = identification(X, Y, X_2, Y_2);

close;


