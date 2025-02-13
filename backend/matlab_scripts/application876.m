%-------------------------------------------------------------------
% Algorithme de variation de SCS en fonction de phi
% D�finition des angles d'incidence phi1
phi1 = [0, pi/3, pi/2, pi];

% Param�tres suppl�mentaires
f = 1e9; % Fr�quence (exemple : 1 GHz)
lambda = 3e8 / f; % Calcul de la longueur d'onde (en m)
k = 2 * pi / lambda; % Vecteur d'onde (k = 2*pi/lambda)
eta = 377; % Imp�dance caract�ristique de l'espace libre (en Ohms)
Z = 1; % Imp�dance de la source (� ajuster selon le mod�le)
Vi = 1; % Amplitude du potentiel de la source

% D�finition de x et y (exemples)
N = 100; % Nombre de points
x = linspace(-1, 1, N);
y = linspace(-1, 1, N);

% Initialisation des variables
SCS = zeros(4, length(0:pi/100:(2*pi))); % Matrice pour stocker les SCS pour chaque phi1

%---------------------------------------------------------------
% Pour chaque valeur de phi1 (angle d'incidence)
for nn = 1:4
    phi_1 = phi1(nn);
    
    % Vecteur des angles d'observation phi2
    phi2 = 0:pi/100:(2*pi);  % De 0 � 2*pi avec un pas de pi/100
    M = length(phi2);

    % Calcul du SCS pour chaque valeur de phi2
    for n = 1:M
        % Calcul du vecteur de potentiel Vs pour chaque point
        Vs = zeros(1, N);
        for m = 1:N
            % Calcul de Vs en fonction de phi2
            Vs(m) = delta * exp(complex(0, k * (x(m) * cos(phi2(n)) + y(m) * sin(phi2(n)))));
        end

        % Calcul du terme SRC pour chaque point
        c = abs((Vs / Z) * Vi);  % Calcul du terme SRC

        % Calcul du SCS - Moyenne des valeurs de SCS sur tous les points
        SCS(nn, n) = k * (eta / 4) * sum(c.^2) / N;  % Utilisation de sum pour r�duire � une seule valeur
        
        % Affichage des valeurs de SCS � chaque it�ration
        disp(['SCS pour phi1 = ', num2str(phi_1), ' et phi2 = ', num2str(phi2(n)), ' : ', num2str(SCS(nn, n))]);
    end
end

%---------------------------------------------------------------
% Trac� du graphe de SCS en fonction de phi2
couleur = ['m', 'r', 'b', 'c'];  % Choix des couleurs pour les courbes

% Tracer les courbes pour les diff�rentes valeurs de phi1
figure;
hold on;
for k = 1:4
    plot(phi2, SCS(k, :), couleur(k), 'LineWidth', 1.5);
end
hold off;

% Titre et l�gende
title('Diagramme de SCS en fonction de l''angle d''ouverture pour diff�rentes valeurs de l''angle d''incidence');
legend('phi1=0', 'phi1=\pi/3', 'phi1=\pi/2', 'phi1=\pi');
xlabel('phi2 (angle d''observation) en radians');
ylabel('SCS');
grid on;

% Create the directory if it doesn't exist.
if ~exist('results/application876', 'dir')
    mkdir('results/application876');
end

% Base filename for text results
baseFilename_text = 'results/application876/application876_results.txt';
filename_text = baseFilename_text;
count_text = 1;

% Check if the text file exists and update the filename with a count
while exist(filename_text, 'file')
    filename_text = sprintf('results/application876/application876_results_%d.txt', count_text);
    count_text = count_text + 1;
end

% Open the text file for writing results
fileID_text = fopen(filename_text, 'w');

% Write header information to the text file
fprintf(fileID_text, 'SCS Calculation Results\n');
fprintf(fileID_text, '-------------------------\n');
fprintf(fileID_text, 'Frequency (f): %.2e Hz\n', f);
fprintf(fileID_text, 'Wavelength (lambda): %.2f m\n', lambda);
fprintf(fileID_text, 'Wave vector (k): %.2f rad/m\n', k);
fprintf(fileID_text, 'Free space impedance (eta): %.2f Ohms\n', eta);
fprintf(fileID_text, 'Source impedance (Z): %.2f Ohms\n', Z);
fprintf(fileID_text, 'Source potential amplitude (Vi): %.2f V\n', Vi);
fprintf(fileID_text, 'Number of points (N): %d\n', N);
fprintf(fileID_text, '\n');

% Write SCS values for each phi1 and phi2 combination
for nn = 1:4
    phi_1 = phi1(nn);
    fprintf(fileID_text, 'SCS values for phi1 = %.2f:\n', phi_1);
    for n = 1:length(phi2)
        fprintf(fileID_text, '  phi2 = %.2f: SCS = %.2e\n', phi2(n), SCS(nn, n));
    end
    fprintf(fileID_text, '\n');
end

% Close the text file
fclose(fileID_text);

% Base filename for image results
baseFilename_image = 'results/application876/application876_SCS_diagram';
filename_image = baseFilename_image;
count_image = 1;

% Check if the image file exists and update the filename with a count
while exist([filename_image '.png'], 'file')
    filename_image = sprintf('results/application876/application876_SCS_diagram_%d.png', count_image);
    count_image = count_image + 1;
end

% Save the plot as an image
saveas(gcf, filename_image);
end