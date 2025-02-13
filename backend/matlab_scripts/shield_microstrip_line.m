function shield_microstrip_line
    % Initialisation des constantes et normalisation
    a = 40; b = 50; h = 0.5; eps = 3.5;
    a0 = ceil(a / h) + 1;
    a1 = ceil(a0 / 2);
    b0 = ceil(b / h) + 1;
    b1 = ceil(0.4 * b0);
    b2 = ceil(0.46 * b0);
    b3 = ceil(0.54 * b0);
    b4 = ceil(0.6 * b0);
    e0 = 8.81e-12;
    e1 = eps * e0;

    % ****** EN absence du di�lectrique ******

    % Initialisation des matrices de potentiel
    V = zeros(a0, b0);
    U = V;

    % Application des conditions initiales
    for j = b3:b4
        V(a1, j) = 100;
    end

    % R�solution du potentiel
    V = calculate_potential(V, U, a0, b0, a1, b1, b2, b3, b4, e0, e0);

    % Affichage d'un point particulier
    fprintf('Potentiel en V(%d, %d) : %.4f\n', a1, ceil((b2 + b3) / 2), V(a1, ceil((b2 + b3) / 2)));

    % Visualisation du potentiel
    figure(1); surf(V); rotate3d on; title('Potentiel sans di�lectrique');

    % Calcul de la charge Q0
    Q0 = calculate_charge(V, e0, a0, b0, a1, b4);
    fprintf('Charge Q0 : %.4e C\n', Q0);

    % ****** EN pr�sence du di�lectrique ******

    % R�initialisation des matrices
    V = zeros(a0, b0);
    U = V;

    % Application des conditions initiales
    for j = b3:b4
        V(a1, j) = 100;
    end

    % R�solution du potentiel avec di�lectrique
    V = calculate_potential(V, U, a0, b0, a1, b1, b2, b3, b4, e0, e1);

    % Affichage d'un point particulier
    fprintf('Potentiel en V(%d, %d) avec di�lectrique : %.4f\n', a1, ceil((b2 + b3) / 2), V(a1, ceil((b2 + b3) / 2)));

    % Visualisation du potentiel
    figure(2); surf(V); rotate3d on; title('Potentiel avec di�lectrique');

    % Calcul de la charge Q
    Q = calculate_charge(V, e0, a0, b0, a1, b4, e1);
    fprintf('Charge Q : %.4e C\n', Q);

    % Calcul de la capacit�
    C = 4 * Q / 100;
    fprintf('Capacit� : %.4e F\n', C);
end

function V = calculate_potential(V, U, a0, b0, a1, b1, b2, b3, b4, e0, e1)
    % R�solution it�rative du potentiel
    n = 0;
    bool = true;
    tol = 0.001;

    while bool
        n = n + 1;
        for i = 1:a0
            for j = 1:b0
                if i == a0 && j == 1
                    V(i, j) = 0.5 * (V(i - 1, j) + V(i, j + 1));
                elseif i == a0 && j < b0 && j > 1
                    V(i, j) = 0.25 * (V(i, j - 1) + V(i, j + 1) + 2 * V(i - 1, j));
                elseif j == 1 && i > 1 && i < a0
                    V(i, j) = 0.25 * (2 * V(i, j + 1) + V(i - 1, j) + V(i + 1, j));
                elseif i == a1
                    if (j > 1 && j < b1) || (j > b2 && j < b3) || (j > b4 && j < b0)
                        V(i, j) = 0.25 * (V(i, j + 1) + V(i, j - 1) + (e1 / (e0 + e1)) * V(i - 1, j) + (e0 / (e0 + e1)) * V(i + 1, j));
                    end
                elseif i > 1 && i < a0 && j > 1 && j < b0
                    V(i, j) = 0.25 * (V(i, j + 1) + V(i, j - 1) + V(i + 1, j) + V(i - 1, j));
                end
            end
        end
        bool = (max(max(abs(U - V))) > tol);
        U = V;
    end

    fprintf('Convergence atteinte apr�s %d it�rations.\n', n);
end

function Q = calculate_charge(V, e0, a0, b0, a1, b4, e1)
    % Calcul de la charge totale
    Q = 0.5 * e0 * (V(a1 + 3, 1) - V(a1 + 2, 1));
    for j = 2:b4 + 1
        Q = Q + e0 * (V(a1 + 3, j) - V(a1 + 2, j));
    end
    for i = a1 + 2:-1:2
        Q = Q + e0 * (V(i, b4 + 2) - V(i, b4 + 1));
    end
    Q = Q + 0.5 * e0 * (V(1, b4 + 2) - V(1, b4 + 1));
    if nargin > 6
        Q = Q + (e0 + e1) / 2 * (V(a1, b4 + 2) - V(a1, b4 + 1));
        for i = a1 - 1:-1:2
            Q = Q + e1 * (V(i, b4 + 2) - V(i, b4 + 1));
        end
        Q = Q + 0.5 * e1 * (V(1, b4 + 2) - V(1, b4 + 1));
    end
end

    % Create the results directory if it doesn't exist
    if ~exist('results/shield_microstrip_line', 'dir')
        mkdir('results/shield_microstrip_line');
    end

    % Base filename for text results
    baseFilename_text = 'results/shield_microstrip_line/shield_microstrip_line_results.txt';
    filename_text = baseFilename_text;
    count_text = 1;

    % Check if the text file exists and update the filename with a count
    while exist(filename_text, 'file')
        filename_text = sprintf('results/shield_microstrip_line/shield_microstrip_line_results_%d.txt', count_text);
        count_text = count_text + 1;
    end

    % Open the text file for writing results
    fileID_text = fopen(filename_text, 'w');

    % Write variables and results to the text file
    fprintf(fileID_text, 'a = %f, b = %f, h = %f, eps = %f\n', a, b, h, eps);
    fprintf(fileID_text, 'Charge Q0 : %.4e C\n', Q0);
    fprintf(fileID_text, 'Charge Q : %.4e C\n', Q);
    fprintf(fileID_text, 'Capacit� C : %.4e F\n', C);
    fprintf(fileID_text, 'Potentiel en V(%d, %d) : %.4f\n', a1, ceil((b2 + b3) / 2), V(a1, ceil((b2 + b3) / 2)));

    % Close the text file
    fclose(fileID_text);

    % Base filename for image results
    baseFilename_image = 'results/shield_microstrip_line/shield_microstrip_line_results';
    filename_image = baseFilename_image;
    count_image = 1;

    % Check if the image file exists and update the filename with a count
    while exist([filename_image '.png'], 'file')
        filename_image = sprintf('results/shield_microstrip_line/shield_microstrip_line_results_%d', count_image);
        count_image = count_image + 1;
    end

    % Plotting and saving the potential (with dielectric)
    figure(2);

    % Plotting and saving the potential (with dielectric)
    filename_image_potential_with_dielectric = [filename_image '_potential_with_dielectric'];
    count_image_potential_with_dielectric = 1;
    while exist([filename_image_potential_with_dielectric '.png'], 'file')
        filename_image_potential_with_dielectric = sprintf('%s_potential_with_dielectric_%d', filename_image, count_image_potential_with_dielectric);
        count_image_potential_with_dielectric = count_image_potential_with_dielectric + 1;
    end
    saveas(figure(2), [filename_image_potential_with_dielectric '.png']);
end