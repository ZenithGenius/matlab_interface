function eq_poisson

% AUTOMAILLE
nx=5; ny=3; a=1; b=1;
%vecteurs pas du maillage: hx suivant x et hy suivant y
pax=a/(nx-1);
pay=b/(ny-1);
hx=pax*ones(1,nx-1);% Vecteur des pas suivant x
hy=pay*ones(1,ny-1);% Vecteur des pas suivant y
nd=nx*ny;  %nombre de noeuds de la structure
np=2*(nx+ny-2);%nombre de noeuds sur la frontière
ne=2*(nx-1)*(ny-1);%nombre d'élements


%calcul des coordonées
x(1)=0; y(1)=0;%en considerant le noeud 1 a l'origine

for k=2:1:nx
     x(k)= x(k-1)+hx(k-1);
end
xtot=x;
for k=1:1:ny-1
     xtot=[xtot x];
end

for k=2:1:ny
    y(k)=y(k-1)+hy(k-1);
end
ytot=y;
for k=1:1:nx-1
     ytot=[ytot y];
end



%maillage de la structure

for k=0:1:ny-2
    p=k*(2*nx-2)+1;
    q=1+k*nx;
    E(p,1)=q; E(p,2)=1+q+nx; E(p,3)=q+nx;
    E(p+1,1)=q; E(p+1,2)=q+1; E(p+1,3)=q+1+nx;
    for e=1:1:(nx-2)
        E(p+2*e,1)=E(p+2*(e-1),1)+1; E(p+2*e,2)=E(p+2*(e-1),2)+1; E(p+2*e,3)=E(p+2*(e-1),3)+1;
        E(p+1+2*e,1)=E(p+2*e-1,1)+1; E(p+1+2*e,2)=E(p+2*e-1,2)+1; E(p+1+2*e,3)=E(p+2*e-1,3)+1;
    end
end

E=E
X=xtot 
Y=ytot

%debut matrice_global
for e=1:1:size(E,1)
   %calcul de l' aire de l' élément
   aire=0.5*det([1 X(E(e,1)) Y(E(e,1));1 X(E(e,2)) Y(E(e,2));1 X(E(e,3)) Y(E(e,3))]);
   %calcul des pi et des qi de l' élement e
   P(1)=Y(E(e,2))-Y(E(e,3));
   Q(1)=X(E(e,3))-X(E(e,2));
   P(2)=Y(E(e,3))-Y(E(e,1));
   Q(2)=X(E(e,1))-X(E(e,3));
   P(3)=Y(E(e,1))-Y(E(e,2));
   Q(3)=X(E(e,2))-X(E(e,1));
   
   
  %calcul des Cij de la matrice de rigidité pr chaque élement e
    for i=1:3
        for j=1:3
            c_elt(i,j,e)=(0.25/aire)*(P(i)*P(j)+Q(i)*Q(j));
        end
    end
 end
c_elt

% calcul des  coefficients de la matrice globale C
Nn=length(x)*length(y);
for i=1:Nn
    for j=1:Nn
        C(i,j)=0;
    end
    for e=1:size(E,1)
        for j=1:3
           if E(e,j)==i
               for k=1:1:3
                  C(i,E(e,k))=C(i,E(e,k))+c_elt(j,k,e);
               end
          end
        end
    end
end
C

%calcul des elements de la matrice T
H=aire/12;   G=H*2;
for i=1:Nn
    for j=1:Nn
       if i~=j
            T(i,j)=H;
        else
            T(i,j)=G;
        end
    end
end
T
%calul effectif du potentiel
tol=10^-15;
Vref=zeros(1,15);
V1=zeros(1,15);
V1(2)=10^-17;
V1(3)=10^-17; 
V1(4)=10^-17; 
V1(6)=10^-15;
V1(10)=10^-13;%on initialise le potentiel aux noeuds connus  


indice=[1 5 7 8 9 11 12 13 14 15];
  %vecteur contenant les indices des noeuds de...
%potentiel inconnu

rho=10^-15;  eo=8.85*(10^12); eps=2.5*eo;

%initialisation des potentiel inconnus
%boucle de l'iteration
while norm(V1-Vref)>tol
    Vref=V1;
    
   for i=1:1:10
        k=indice(i);
        tempon=C(k,k)*V1(k);
        for j=1:1:15
            tempon=tempon-(C(k,j)*V1(j));
        end
        tempon1=0;
        for j=1:1:15
            tempon1=tempon1+(rho/(16*eps))*T(k,j);
        end
        tempon=tempon+tempon1;
        V1(k)=tempon/C(k,k);
   end
end

V1    %potentiels aux noeuds de la region 1(rho)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Potentiel dans la region 2(le vide donc rho=0:on a donc ici affaire à la résolution de l'equation de laplace)%%%%%%%%%%%%%%%%%%%%%%

% AUTOMAILLE
nx=5; ny=5; a=1; b=2;
%vecteurs pas du maillage: hx suivant x et hy suivant y
pax=a/(nx-1);
pay=b/(ny-1);
hx=pax*ones(1,nx-1);% Vecteur des pas suivant x
hy=pay*ones(1,ny-1);% Vecteur des pas suivant y
nd=nx*ny;  %nombre de noeuds de la structure
np=2*(nx+ny-2);%nombre de noeuds sur la frontière
ne=2*(nx-1)*(ny-1);%nombre d'élements
%calcul des coordonées
x(1)=0; y(1)=0;%en considerant le noeud 1 a l'origine

for k=2:1:nx
     x(k)= x(k-1)+hx(k-1);
end

% Create the results directory if it doesn't exist
if ~exist('results/poisson', 'dir')
    mkdir('results/poisson');
end

% Base filename
baseFilename = 'results/poisson/poisson_results.txt';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/poisson/poisson_results_%d.txt', count);
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
fprintf(fileID, '\n\nC = \n');
fprintf(fileID, '%f ', C);
fprintf(fileID, '\n\nT = \n');
fprintf(fileID, '%f ', T);
fprintf(fileID, '\n\nV1 = \n');
fprintf(fileID, '%f ', V1);

% Close the file
fclose(fileID);

% Display results in MATLAB console (optional)
disp('E = '), disp(E)
disp('X = '), disp(X)
disp('Y = '), disp(Y)
disp('C = '), disp(C)
disp('T = '), disp(T)
disp('V1 = '), disp(V1)

end
