d = 20; h = 20; dr = 4;
v = zeros(5*d+1, 5*h+1);
bool1 = 1; e1 = 1e-5; e2 = 1e-5; e3 = 1e-5; e5 = 1e-5; e9 = 1e-5;
bool2 = 1; bool3 = 1; bool15 = 1; bool19 = 1;

% Initialisation des bords du potentiel
for j = 1:5*h+1
    v(1, j) = 0; 
    v(5*d+1, j) = 0;
end
for j = round((h-1)*5/2)+1:5*h-round((h-1)*5/2)
    v(round(2.5*d - 2.5*dr), j) = 100;
    v(round(2.5*d + 2.5*dr), j) = 100;
end

% Calcul du potentiel dans chaque sous-partie du syst�me
while bool1
    u = v;
    for i = 2:round(2.5*d)
        for j = 2:round((h-1)*5/2)
            v(i, j) = 0.25 * (v(i, j+1) + v(i, j-1) + v(i-1, j) + v(i+1, j));
        end
    end
    bool1 = (e1 <= max(max(abs(u - v))));
end

while bool2
    u = v;
    for i = 2:round(2.5*d)
        for j = 5*h:-1:(5*h-round((h-1)*5/2)+1)
            v(i, j) = 0.25 * (v(i, j+1) + v(i, j-1) + v(i-1, j) + v(i+1, j));
        end
    end
    bool2 = (e2 <= max(max(abs(u - v))));
end

s = 0; z = 0; t=0; a=0;

while bool3
    u = v;
    s = s + 1;
    for i = round((2.5*d - 2.5*dr) + 1):round(2.5*d)
        for j = round((h-1)*5/2)+1:5*h-round((h-1)*5/2)
            v(i, j) = 0.25 * (v(i, j+1) + v(i, j-1) + v(i-1, j) + v(i+1, j));
        end
    end
    bool3 = (e3 <= max(max(abs(u - v))));
end

while bool15
    u = v;
    for i = 2:round(2.5*d - 2.5*dr - 1)
        for j = round((h-1)*5/2)+1:5*h-round((h-1)*5/2)
            v(i, j) = 0.25 * (v(i, j+1) + v(i, j-1) + v(i-1, j) + v(i+1, j));
            z = z + 1;
        end
    end
    bool15 = (e5 <= max(max(abs(u - v))));
end

while bool19
    u = v;
    for j = 2:5*h
        v(round(2.5*d+1), j) = (1/6) * (v(round(2.5*d+1), j-1) + v(round(2.5*d+1), j+1) + 4*v(round(2.5*d+2), j));
    end
    bool19 = (e9 <= max(max(abs(u - v))));
end

% Sym�trie
for i = round(2.5*d+2):5*d+1
    for j = 1:5*h+1
        v(i, j) = v(5*d+2-i, j);
    end
end

% Affichage du nombre d'it�rations et du potentiel en un point particulier
%disp(["a =", a, "d =", d, "s =", s, "z =", z, "Potentiel(51,55) =", v(51,55)]);
a,d,s,z,v(51,55)

% Courbe du potentiel
surf(v, 'FaceColor', 'c', 'EdgeColor', 'm');
grid on;
rotate3d on;

if ~exist('results/code3', 'dir')
    mkdir('results/code3');
end

% Base filename for text results
baseFilename_text = 'results/code3/code3_results.txt';
filename_text = baseFilename_text;
count_text = 1;

% Check if the text file exists and update the filename with a count
while exist(filename_text, 'file')
    filename_text = sprintf('results/code3/code3_results_%d.txt', count_text);
    count_text = count_text + 1;
end

% Open the text file for writing results
fileID_text = fopen(filename_text, 'w');

% Write variables and results to the text file
fprintf(fileID_text, 'a = %f, d = %f, s = %f, z = %f, Potentiel(51,55) = %f\n', a, d, s, z, v(51,55));

% Close the text file
fclose(fileID_text);

% Base filename for image results
baseFilename_image = 'results/code3/code3_results';
filename_image = baseFilename_image;
count_image = 1;

% Check if the image file exists and update the filename with a count
while exist([filename_image '.png'], 'file')
    filename_image = sprintf('results/code3/code3_results_%d', count_image);
    count_image = count_image + 1;
end

% Plotting and saving the potential
filename_image_potential = [filename_image '_potential'];
count_image_potential = 1;
while exist([filename_image_potential '.png'], 'file')
    filename_image_potential = sprintf('%s_potential_%d', filename_image, count_image_potential);
    count_image_potential = count_image_potential + 1;
end
saveas(gcf, [filename_image_potential '.png']);