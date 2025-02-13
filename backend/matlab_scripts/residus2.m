function residus2
% Définition des paramètres d'entrée du problème
N = 10; % Nombre de points de la subdivision du domaine
w = 0.5; % Largeur du domaine
d = 2 * w / N; % Distance entre 2 points de la subdivision

% Construction de la matrice A
A = zeros(N, N);
for m = 1:N
    for n = 1:N
        if m ~= n
            A(m, n) = [d * (n - m + 0.5) * log(abs(d * (m - n - 0.5))) - ...
                        d * (n - m - 0.5) * log(abs(d * (m - n + 0.5))) - d] * (-1 / (2 * pi));
        else
            A(m, n) = -d / (2 * pi); % Gestion de la singularité
        end
    end
end

% Affichage de la matrice A
disp('Matrice A:');
disp(A);

% Calcul de l'inverse de A
A_inv = inv(A);

% Affichage de la matrice inverse A
disp('Matrice inverse A:');
disp(A_inv);

% Résolution de l'équation matricielle
b = ones(N, 1); % Second membre de l'équation Ax = b
I = A_inv * b;

% Affichage de la solution I
disp('Solution I:');
disp(I);

% Tracé de la courbe I=f(z)
z = -w:0.0001:w;
zm = -w + d/2 : d : -w + d * (N - 1/2);
zz = [zm; I']';

% Génération de la fonction porte
h = pulstran(z, zz, 'rectpuls', d/2);

% Create the plot without displaying it
figure('Visible', 'off');
plot(z, h, 'b', zm, I, 'r--o');
title('Courbe I=f(z)');
xlabel('z'); ylabel('I');
legend('I: fonction porte', 'I: courbe linéaire');
grid on;

% Create the results directory if it doesn't exist
if ~exist('results/residus2', 'dir')
    mkdir('results/residus2');
end

% Base filename for the plot
baseFilename = 'results/residus2/residus2_plot.png';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/residus2/residus2_plot_%d.png', count);
    count = count + 1;
end

% Save the plot to a file
saveas(gcf, filename);

% Close the figure
close(gcf);
end
