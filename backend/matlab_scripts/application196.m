function application196
%definition des constantes
N=200; lamda=1; eta=377;
phi=pi/3;e=2.718; si=1.781;
k=2*pi/lamda;r=0.4;a=-pi/(N-1);
delta=2*pi*r/(N-1);
x=zeros(1,N);
y=zeros(1,N);
A=zeros(N,N);
E=zeros(1,N);
J=zeros(1,N);
%vecteur positions x,y
teta=pi/2;
for n=1:N
    x(1,n)=r*cos(teta);
    y(1,n)=sin(teta);
    teta=teta+a;
end

%vecteur E du champ incident
for n=1:N
    E(1,n)=exp(complex(0,(x(1,n)*cos(phi)+y(1,n)*sin(phi))));
end
%matrice A
for m=1:N
    for n=1:N
            if(n<m)||(n>m)
                   g=k*sqrt((x(n)-x(m))^2+(y(n)-y(m)^2));
                   A(m,n)=eta*k/4*delta*besselh(0,2,g);
            else
                A(n,n)=eta*k/4*(1-i*2/pi*log(si*k*delta/(4*e)));
            end
    end
end

%distribution de la densite de courant surfacique
J=E/A;
for n=1:N
    I(n)=abs(J(n));
end
plot(x,I)
phi1=pi/3; phi2=pi/4;
%vecteurs Vin et Vsn
Vin=zeros(N,1);
Vsn=zeros(1,N);
for m=1:N
    Vi(m,1)=delta*exp(complex(0,k*(x(m)*cos(phi1)+y(m)*sin(phi1))));
    Vs(1,m)=delta*exp(complex(0,k*(x(m)*cos(phi2)+y(m)*sin(phi2))));
end
%matrice Z
Z=delta*A;
%�valuons le terme SRC
SRC=k*eta/4*abs((Vs/Z)*Vi)

% Create the directory if it doesn't exist.
if ~exist('results/application196', 'dir')
    mkdir('results/application196');
end

% Base filename for text results
baseFilename_text = 'results/application196/application196_results.txt';
filename_text = baseFilename_text;
count_text = 1;

% Check if the text file exists and update the filename with a count
while exist(filename_text, 'file')
    filename_text = sprintf('results/application196/application196_results_%d.txt', count_text);
    count_text = count_text + 1;
end

% Open the text file for writing results
fileID_text = fopen(filename_text, 'w');

% Write variables and results to the text file
fprintf(fileID_text, 'N = %d\n', N);
fprintf(fileID_text, 'lamda = %f\n', lamda);
fprintf(fileID_text, 'eta = %f\n', eta);
fprintf(fileID_text, 'phi = %f\n', phi);
fprintf(fileID_text, 'k = %f\n', k);
fprintf(fileID_text, 'r = %f\n', r);
fprintf(fileID_text, 'a = %f\n', a);
fprintf(fileID_text, 'delta = %f\n', delta);
fprintf(fileID_text, 'SRC = %f\n', SRC);

% Close the text file
fclose(fileID_text);

% Base filename for image results
baseFilename_image = 'results/application196/application196_current_density';
filename_image = baseFilename_image;
count_image = 1;

% Check if the image file exists and update the filename with a count
while exist([filename_image '.png'], 'file')
    filename_image = sprintf('results/application196/application196_current_density_%d', count_image);
    count_image = count_image + 1;
end

% Save the current density plot as an image
saveas(gcf, [filename_image '.png']);

