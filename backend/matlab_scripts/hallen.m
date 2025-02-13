function hallen
    % Résolution de l'équation intégrale de Allen
    % a : rayon de l'antenne
    % l : la longueur de l'antenne
    % N : nombre de segments de largeur delta
    %--------------------------------------------------------------------------
    % on recherche les fonctions d'expansion In
    % initialisation des paramètres
    % définitions des constantes
    c = 3*10^8;         % célérité de la lumière
    N = 200;            % nombre de segments de largeur delta
    f = 10^9 * [2.4 5]; % vecteur formé des différentes valeurs de la fréquence
    nu = 377;           % impédance magnétique du vide
    Vt = 1;             % Potentiel aux extrémités de l'antenne
    %--------------------------------------------------------------------------
    
    z = zeros(1, N);
    F = zeros(N + 1, N + 1);
    Q = zeros(N + 1, 1);
    J = zeros(N + 1, 1);
    
    %--------------------------------------------------------------------------
    for h = 1:2 % pour chaque fréquence on détermine I pour différentes valeurs de la longueur de l'antenne
        lamda = c / f(h);                % longueur d'onde
        l = lamda * [0.5 1 1.5];         % vecteur formé des différentes valeurs de la longueur de l'antenne
        a = 0.001 * lamda;               % rayon de l'antenne
        k = (2 * pi) / lamda;            % nombre d'onde
        coul = ['r','b','g'];
        for g = 1:3                      % pour chaque valeur de la longueur
            delta = l(g) / N;            % largeur de la subdivision
            
            %--------------------------------------------------------------------------
            % vecteur position défini en fonction de la longueur de l'antenne
            z = -l(g) / 2 : delta : l(g) / 2;
            %--------------------------------------------------------------------------
            % calcul des éléments de la matrice F
            for m = 1:N+1
                for n = 1:N
                    F(m, n) = (1 / (4 * pi)) * ...
                        (cos(k * sqrt(a^2 + (z(m) - z(n))^2))) * ...
                        log((z(m) + delta / 2 - z(n) + ...
                        sqrt(a^2 + (z(m) - z(n) + delta / 2)^2)) / ...
                        (z(m) - delta / 2 - z(n) + ...
                        sqrt(a^2 + (z(m) - z(n) - delta / 2)^2))) - ...
                        (complex(0, delta) * sin(k * sqrt(a^2 + (z(m) - z(n))^2))) / ...
                        (4 * pi * sqrt(a^2 + (z(m) - z(n))^2));
                end
            end
            
            for i = 1:N + 1
                F(i, N + 1) = complex(0, 1 / nu) * cos(k * z(i)); % remplissage de la matrice F
                Q(i, 1) = complex(0, -0.5 / nu) * Vt * sin(k * abs(z(i))); % matrice colonne Q
            end
            
            J = abs(inv(F) * Q);  % Module des courants élémentaires J(i)
            J(N + 1, 1) = J(1, 1);  % Assure la continuité des courants
            
            t = -l(g) / 2 : delta : l(g) / 2;
            
            %--------------------------------------------------------------------------
            % Calcul du courant I en chaque point t(i)
            for j = 1:N + 1
                I(g, j) = 0;
                for i = 1:N + 1
                    I(g, j) = I(g, j) + ((t(i) < z(j) + delta / 2) & (t(i) > z(j) - delta / 2)) * J(j);
                end
            end
            %------------------------------------------------------------------------
            
            %%% Affichage de la répartition du courant %%%
            % Create the plot without displaying it
            figure('Visible', 'off');
            e = coul(g);
            hold on
            if h == 1
                subplot(2, 1, 1), plot(t, I(g, :), e) % Répartition du courant f=f1
                grid on
                title('Répartition du courant le long du conducteur pour f=2.4 GHz')
                xlabel('Cte z en [m]')
                ylabel('Courant I en [A]')
            else
                subplot(2, 1, 2), plot(t, I(g, :), e) % Répartition du courant f=f2
                grid on
                title('Répartition du courant le long du conducteur pour f=5 GHz')
                xlabel('Cte z en [m]')
                ylabel('Courant I en [A]')
            end

            % Create the results directory if it doesn't exist
            if ~exist('results/hallen', 'dir')
                mkdir('results/hallen');
            end
            
            % Base filename for the plot
            baseFilename = sprintf('results/hallen/hallen_plot_f%d_l%d.png', h, g);
            filename = baseFilename;
            count = 1;

            % Check if the file exists and update the filename with a count
            while exist(filename, 'file')
                filename = sprintf('results/hallen/hallen_plot_f%d_l%d_%d.png', h, g, count);
                count = count + 1;
            end

            % Save the plot to a file
            saveas(gcf, filename);

            % Close the figure
            close(gcf);
            
            % Affichage des résultats de calculs dans la fenêtre de commande
            fprintf('Fréquence: %.1f GHz\n', f(h)/1e9);
            fprintf('Longueur d''onde: %.2f m\n', lamda);
            fprintf('Longueur de l''antenne: %.2f m\n', l(g));
            fprintf('Courants J aux points: \n');
            disp(J(1:N+1));
            fprintf('Courants I pour chaque position t:\n');
            disp(I(g, :));
            fprintf('---------------------------------\n');
            
        end
    end
    % Fin du tracé de I en fonction de la position pour différentes valeurs de fréquence
end
