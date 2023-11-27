close all
clear
clc

%% Paramètres

IMG = imread("photo.jpeg");

%% 3.1 Travaux péparatoires sur l'homographie

% Choix des sommets du quadrangle

imshow(IMG);
title('Choix des sommets du quadrangle');
[x, y] = ginput;
close;


