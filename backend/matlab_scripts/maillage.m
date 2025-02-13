 function maillage
%cr�ation de la matrice E ;chaque ligne representant un �l�ment dont les
%3 noeuds representatifs qui sont les 3 colonnes dans l' ordre
E=[1 10 2;10 9 2;9 3 2;9 4 3;9 12 4;10 12 9;10 11 12;1 8 10;8 11 10;8 7 11;7 6 11;11 6 12;12 6 5;12 5 4];
X=[0 4 8 8 8 4 0 0 6 2 2 6];Y=[6 6 6 3 0 0 0 3 4.5 4.5 1.5 1.5];
 for e=1:1:14
   %calcul de l' aire de l' �l�ment
   aire=0.5*det([1 X(E(e,1)) Y(E(e,1));1 X(E(e,2)) Y(E(e,2));1 X(E(e,3)) Y(E(e,3))])
   %calcul des pi et des qi de l' �lement e
   P(1)=Y(E(e,2))-Y(E(e,3));
   Q(1)=X(E(e,3))-X(E(e,2));
   P(2)=Y(E(e,3))-Y(E(e,1));
   Q(2)=X(E(e,1))-X(E(e,3));
   P(3)=Y(E(e,1))-Y(E(e,2));
   Q(3)=X(E(e,2))-X(E(e,1));
   %calcul des Cij(e)
   for i=1:1:3
       for j=1:1:3
             c_elt(i,j+3*e)=0.25*(1/aire)*(P(i)*P(j)+Q(i)*Q(j));      
       end
   end
end
c_elt(1:3,1:42)=c_elt(1:3,4:45);
c_elt

% calcul des  coefficients de la matrice globale C
for i=1:1:12
    for j=1:1:12
        C(i,j)=0;
    end
    for e=1:1:14
        for j=1:1:3
            if E(e,j)==i
                for k=1:1:3
                    C(i,E(e,k))=C(i,E(e,k))+c_elt(j,k+3*(e-1));
                end
            end
        end
    end
end

%r�solutuion par it�ration
%tol�rance de l'it�ration=0.01
erreur=0.01;
Vref=[0 0 0 0 0 0 0 0 0 0 0 0];
%Potentiels connus
V(2)=100;
V(4)=20;
V(6)=60;
V(8)=80;
%initialisation des potentiels inconnus
V(1)=60;V(3)=60;V(5)=60;V(7)=60;V(9)=60;V(10)=60;V(11)=60;V(12)=60;
% recup�ration des indices o� on doit calculer le potentiel
ind=[1 3 5 7 9 10 11 12];  %on recup�re les indices des potentiels inconnus dans "ind"
%boucles de l'it�ration
while norm(V-Vref)>erreur
    Vref=V;
    for i=1:1:8
         k=ind(i);
         V(k)=0;
         for j=1:1:12
             if(j~=k)
                V(k)=V(k)+C(j,k)*V(j);
             end
         end
         V(k)=-V(k)/C(k,k);  %potentiel au noeud k
    end
end

% Create the results directory if it doesn't exist
if ~exist('results/maillage', 'dir')
    mkdir('results/maillage');
end

% Base filename for the plot
baseFilename = 'results/maillage/maillage_results.txt';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/maillage/maillage_results_%d.txt', count);
    count = count + 1;
end

% Open the file for writing results
fileID = fopen(filename, 'w');

% Write matrices and results to the file
fprintf(fileID, 'E = \n');
fprintf(fileID, '%f ', E);
fprintf(fileID, '\n\nX = \n');
fprintf(fileID, '%f ', X);
fprintf(fileID, '\n\nY = \n');
fprintf(fileID, '%f ', Y);
fprintf(fileID, '\n\nc_elt = \n');
fprintf(fileID, '%f ', c_elt);
fprintf(fileID, '\n\nC = \n');
fprintf(fileID, '%f ', C);
fprintf(fileID, '\n\nV = \n');
fprintf(fileID, '%f ', V);

% Close the file
fclose(fileID);

end
