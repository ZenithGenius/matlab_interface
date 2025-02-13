function Zc = ligneruban
% Application de MoM pour calculer l'imp�dance caract�ristique
% d'une ligne de transmission ruban.

% Sp�cification des param�tres
N = 70;                     % Nombre de subdivisions par bande
Nt = 2 * N;                 % Nombre total de segments
u = 3e8;                    % Vitesse de la lumi�re
eps = 8.8541e-12;           % Permittivit� du vide
H = 2;                      % Hauteur entre les deux bandes
w = 5;                      % Largeur de la ligne ruban
Vp = 1;                     % Potentiel de la bande sup�rieure
Vn = 0;                     % Potentiel de la bande inf�rieure
Vd = Vp - Vn;               % Diff�rence de potentiel
delta = w / N;              % Largeur de chaque surface

% Calcul des milieux des sous-zones
x = zeros(1, Nt);
y = zeros(1, Nt);
for i = 1:N
    % Bande sup�rieure
    x(i) = i * delta;
    y(i) = H / 2;
    % Bande inf�rieure
    x(i + N) = x(i);
    y(i + N) = -H / 2;
end

facteur = delta / (2 * pi * eps);

% Initialisation de la matrice A
A = zeros(Nt, Nt);

% D�termination des �l�ments de [A]
for i = 1:Nt
    for j = 1:Nt
        if i == j
            A(i, j) = 0.5;
        else
            R = sqrt((x(i) - x(j))^2 + (y(i) - y(j))^2);
            A(i, j) = facteur / R;
        end
    end
end

% D�termination du vecteur second membre [V]
V = zeros(Nt, 1);
for i = 1:N
    V(i) = Vp;
    V(i + N) = Vn;
end

% R�solution du syst�me d'�quations lin�aires
Q = A \ V;

% Calcul de la charge totale sur la bande sup�rieure
Q_tot = sum(Q(1:N));

% Calcul de la capacit�
C = Q_tot / Vd;

% Calcul de l'imp�dance caract�ristique
Zc = 1 / (u * C);

% Affichage de l'imp�dance caract�ristique
disp(['Imp�dance caract�ristique Zc = ', num2str(Zc), ' Ohms']);

% Create the results directory if it doesn't exist
if ~exist('results/ligneruban', 'dir')
    mkdir('results/ligneruban');
end

% Base filename for text results
baseFilename_text = 'results/ligneruban/ligneruban_results.txt';
filename_text = baseFilename_text;
count_text = 1;

% Check if the text file exists and update the filename with a count
while exist(filename_text, 'file')
    filename_text = sprintf('results/ligneruban/ligneruban_results_%d.txt', count_text);
    count_text = count_text + 1;
end

% Open the text file for writing results
fileID_text = fopen(filename_text, 'w');

% Write variables and results to the text file
fprintf(fileID_text, 'N = %d\n', N);
fprintf(fileID_text, 'Nt = %d\n', Nt);
fprintf(fileID_text, 'u = %e\n', u);
fprintf(fileID_text, 'eps = %e\n', eps);
fprintf(fileID_text, 'H = %f\n', H);
fprintf(fileID_text, 'w = %f\n', w);
fprintf(fileID_text, 'Vp = %f\n', Vp);
fprintf(fileID_text, 'Vn = %f\n', Vn);
fprintf(fileID_text, 'Vd = %f\n', Vd);
fprintf(fileID_text, 'delta = %f\n', delta);
fprintf(fileID_text, 'Q_tot = %e\n', Q_tot);
fprintf(fileID_text, 'C = %e\n', C);
fprintf(fileID_text, 'Zc = %f Ohms\n', Zc);

% Close the text file
fclose(fileID_text);

% Create a figure to visualize the charge distribution
figure;
plot(1:Nt, Q, 'b.-');
title('Charge Distribution on Strips');
xlabel('Segment Index');
ylabel('Charge (C)');
grid on;

% Base filename for image results
baseFilename_image = 'results/ligneruban/ligneruban_charge_distribution';
filename_image = baseFilename_image;
count_image = 1;

% Check if the image file exists and update the filename with a count
while exist([filename_image '.png'], 'file')
    filename_image = sprintf('results/ligneruban/ligneruban_charge_distribution_%d', count_image);
    count_image = count_image + 1;
end

% Save the charge distribution plot as an image
saveas(gcf, [filename_image '.png']);
