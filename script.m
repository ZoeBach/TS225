close all
clear
clc

%% Paramètres

IMG = imread("photo.jpeg"); % Remplacer par le chemin de votre image

% Définir les points de destination pour former un rectangle ou un carré
rect_width = 200;  % Largeur de l'image de sortie
rect_height = 200; % Hauteur de l'image de sortie
X_2 = [0, rect_width, rect_width, 0];
Y_2 = [0, 0, rect_height, rect_height];

%% 3.1 Travaux préparatoires sur l'homographie

% Choix des sommets du quadrangle
imshow(IMG);
title('Choix des sommets du quadrangle');
[X, Y] = ginput(4); % Sélection de 4 points

% Calcul de la matrice d'homographie H
H = identification2(X, Y, X_2, Y_2);

% Application de la matrice d'homographie à l'image avec les paramètres de taille
IMG_transformee = homographie2(IMG, H, rect_width, rect_height);

% Affichage de l'image transformée
figure;
imshow(IMG_transformee);
title('Image du quadrangle transformée');

%% Fonctions

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
    [rows, cols, ~] = size(IMG);
    IMG_transformee = zeros(rect_height, rect_width, size(IMG, 3), 'like', IMG);

    for i = 1:rect_height
        for j = 1:rect_width
            % Coordonnées homogènes dans l'image de destination
            dest_coords = [j; i; 1];

            % Transformation inverse pour trouver les coordonnées dans l'image source
            src_coords = hMatrix \ dest_coords;
            src_coords = src_coords ./ src_coords(3);

            % Interpolation bilinéaire des pixels
            x = src_coords(1);
            y = src_coords(2);

            if x >= 1 && x <= cols && y >= 1 && y <= rows
                % Trouver les 4 points les plus proches pour l'interpolation
                x1 = floor(x);
                x2 = ceil(x);
                y1 = floor(y);
                y2 = ceil(y);

                % Valeurs aux points d'angle
                Q11 = double(IMG(y1, x1, :));
                Q12 = double(IMG(y1, x2, :));
                Q21 = double(IMG(y2, x1, :));
                Q22 = double(IMG(y2, x2, :));

                % Interpolation bilinéaire
                IMG_transformee(i, j, :) = (Q11 * (x2 - x) * (y2 - y) + ...
                                           Q21 * (x - x1) * (y2 - y) + ...
                                           Q12 * (x2 - x) * (y - y1) + ...
                                           Q22 * (x - x1) * (y - y1)) / ...
                                           ((x2 - x1) * (y2 - y1));
            end
        end
    end
end

