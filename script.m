close all;
clear;
clc;

%% Paramètres
img = imread("photo.jpeg");

largeur_rect = 200;
hauteur_rect = 200;
x_2 = [0, largeur_rect, largeur_rect, 0];
y_2 = [0, 0, hauteur_rect, hauteur_rect];

%% 3.1 Travaux préparatoires sur l'homographie

imshow(img);
title('Choix des sommets du premier quadrangle');
[x, y] = ginput(4);

h = identification2(x, y, x_2, y_2);

title('Choix des sommets du second quadrangle');
[x2, y2] = ginput(4);
h2 = identification2(x2, y2, x_2, y_2);

% Appliquer la homographie pour adapter le contenu des quadrangles
img_transformee1 = homographie2(img, h, largeur_rect, hauteur_rect);
img_transformee2 = homographie2(img, h2, largeur_rect, hauteur_rect);

% Masques pour les deux quadrangles
m1 = [x y]; % Premier quadrangle
m2 = [x2 y2]; % Second quadrangle

% Première étape: Projection du second quadrangle sur le premier
resultat_intermediaire = projection(img, img_transformee2, m1, h);

% Deuxième étape: Projection du contenu transformé du premier quadrangle sur le second
resultat_final = projection(resultat_intermediaire, img_transformee1, m2, h2);

% Affichage de l'image résultante finale avec les deux quadrangles échangés
figure;
imshow(resultat_final);
title('Image avec les deux quadrangles échangés');

%% Fonctions

function h = identification2(x, y, x_2, y_2)
    n = length(x);
    a = [];
    b = [];
    for i = 1:n
        a = [a;
             x(i), y(i), 1, 0, 0, 0, -x_2(i)*x(i), -x_2(i)*y(i);
             0, 0, 0, x(i), y(i), 1, -y_2(i)*x(i), -y_2(i)*y(i)];
        b = [b; x_2(i); y_2(i)];
    end
    h = a\b;
    h = [h; 1];
    h = reshape(h, 3, 3)';
end

function img_transformee = homographie2(img, h, largeur_rect, hauteur_rect)
    [lignes, colonnes, ~] = size(img);
    img_transformee = zeros(hauteur_rect, largeur_rect, size(img, 3), 'like', img);

    for i = 1:hauteur_rect
        for j = 1:largeur_rect
            dest_coords = [j; i; 1];
            src_coords = h \ dest_coords;
            src_coords = src_coords ./ src_coords(3);
            x = src_coords(1);
            y = src_coords(2);

            if x >= 1 && x <= colonnes && y >= 1 && y <= lignes
                img_transformee(i, j, :) = interpol(img, x, y);
            end
        end
    end
end

function pixel = interpol(img, x, y)
    [lignes, colonnes, ~] = size(img);
    x1 = floor(x);
    x2 = ceil(x);
    y1 = floor(y);
    y2 = ceil(y);

    if x1 < 1 || x2 > colonnes || y1 < 1 || y2 > lignes
        pixel = zeros(1, 1, size(img, 3));
        return;
    end

    q11 = double(img(y1, x1, :));
    q12 = double(img(y1, x2, :));
    q21 = double(img(y2, x1, :));
    q22 = double(img(y2, x2, :));

    pixel = (q11 * (x2 - x) * (y2 - y) + ...
             q21 * (x - x1) * (y2 - y) + ...
             q12 * (x2 - x) * (y - y1) + ...
             q22 * (x - x1) * (y - y1)) / ...
             ((x2 - x1) * (y2 - y1));
end

function resultat_image = projection(image1, image2, m, h)
    [lignes1, colonnes1, nb_canaux] = size(image1);
    
    % Créer un masque pour la région du quadrangle
    masque = poly2mask(m(:,1), m(:,2), lignes1, colonnes1);

    % Initialiser l'image résultante
    resultat_image = image1;

    % Appliquer la matrice d'homographie à chaque point dans le masque
    for k = 1:nb_canaux
        for i = 1:lignes1
            for j = 1:colonnes1
                if masque(i, j)
                    point_transforme = h * [j; i; 1];
                    point_transforme = point_transforme ./ point_transforme(3);

                    x = round(point_transforme(1));
                    y = round(point_transforme(2));

                    if x >= 1 && x <= size(image2, 2) && y >= 1 && y <= size(image2, 1)
                        resultat_image(i, j, k) = image2(y, x, k);
                    end
                end
            end
        end
    end
end
