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


X2 = [0,1,0,1];
Y2 = [0,0,1,1];

H = identification(x,y,X2,Y2);