nx=input('nombre de noeuds suivant l"axe des x:');
ny=input('nombre de noeuds suivant l"axe des y:');
a=input('longueur:');
b=input('largeur:');
%vecteurs pas du maillage: hx suivant x et hy suivant y
pax=a/(nx-1);
pay=b/(ny-1);
hx=pax*ones(1,nx-1);% Vecteur des pas suivant x
hy=pay*ones(1,ny-1);% Vecteur des pas suivant y
nd=nx*ny;  %nombre de noeuds de la structure
np=2*(nx+ny-2); %nombre de noeuds sur la fronti�re
ne=2*(nx-1)*(ny-1); %nombre d'�lements

%calcul des coordon�es
x(1)=0; y(1)=0;  %en considerant le noeud 1 a l'origine
for k=2:1:nx
     x(k)= x(k-1)+hx(k-1);
end

for k=2:1:ny
    y(k)=y(k-1)+hy(k-1);
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
[X,Y]=meshgrid(x,y);
axis([0 a 0 b]);
trimesh(E,X,Y);
X=X';
Y=Y';
for i=1:nd
    text(X(i),Y(i),num2str(i));
end

% Create the results directory if it doesn't exist
if ~exist('results/maillageauto', 'dir')
    mkdir('results/maillageauto');
end

% Base filename for the plot
baseFilename = 'results/maillageauto/maillageauto_plot.png';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/maillageauto/maillageauto_plot_%d.png', count);
    count = count + 1;
end

% Save the plot to a file
saveas(gcf, filename);

% Close the figure
close(gcf);

