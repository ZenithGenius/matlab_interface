function imedance_ligne_microruban
a=2.5;b=2.5;c=0.001;d=0.5;v1=100;h=0.025;ep1=1;ep2=2.35;ep3=5; %initialisation
e0=8.81*10^(-12);
eps=[ep1,ep2,ep3];
t=0.2:0.1:1.1;
for r=1:3
    e1=eps(r)*e0;
for k=1:10
    w=t(k);
    V=zeros(round(a/h)+1);
    U=V;
    for i=1:round(w/h)+1
	V(i,round((d+c)/h)+1)=v1;
    end
    m=0;   %indice d'it�ration
    bool=1;
    e=0.001; %pr�cision%
%calcul du potentiel lorsque le di�l�ctrique est le vide%
    while bool
	m=m+1;
	for i=1:round(a/h)+1
	    for j=1:round(b/h)+1
		if i==1 && j==1
		    V(i,j)=0.5*(V(i+1,j)+V(i,j+1));
		elseif i==1 && j<round(b/h)+1 && j~=round((d+c) /h)+1
		    V(i,j)=0.25*(V(i, j-1)+V(i,j+1) +2*V(i+1,j));
		elseif j==1 && i<round(a/h)+1
		    V(i,j)=0.25*(2*V(i, j+1)+V(i-1, j)+V(i+1,j));
		elseif j==round((d+c) /h+1)
		    if i>round(w/h)+1 && i<round(a/h)+1
			V(i,j)=0.25*(V(i,j+1)+V(i, j-1)+V(i-1,j)+V(i+1,j));
		    end
		elseif i>1 && i<round((a/h)+1 && j>1 && j<round(b/h)+1)
			V(i,j)=0.25*(V(i, j+1) +V(i, j-1) +V(i-1, j)+V(i+1,j));
		end
	    end
	end
     bool=(e<max(max(abs(V-U))));
     U=V;
     end
    %d�termination de la charge lorsque le di�lectrique est vide%
     Q0=0.5*e0*(V(1,round((c+d) /h) +4) +V(1,round((c+d) /h) +3));
     for i=1:42
	Q0=Q0+e0*(V(i,round((c+d) /h) +4) -V(i,round((c+d) /h) +3));
     end
     for j=round((c+d) /h) +3:1:2
	Q0=Q0+e0*(V(round((w/h) +3,j) -V(round(w/h) +2, j)));
     end
     Q0=Q0+e0*V(round(w/h) +2,round((c+d) /h) +3);
     Q0=Q0+ (e0*0.5*(V(round((w/h) +3), 1 -V(round(w/h) +2), 1)));
	C0=4*Q0/100;
     %EN pr�sence du di�l�ctrique%
     %initialisation!
     V=zeros(round(a/h)+1);
     bool=(e<max(max(abs(V-U))));
   U=V;
   e0=0.81*10^(-12);
   for i=1:round(w/h)+1
	V(i, round((d+c) /h)+1)=100;
   end

   n=0; %indice d'it�ration%
   bool=1;
   e=0.001; %pr�cision%
   %calcul du potentiel en pr�sence du di�lectrique%
   while bool
	n=n+1;
	for i=1:round(a/h)+1
	    for j=1:round(b/h)+1
		if i==1 && j==1
		   V(i,j)=0.5*(V(i+1,j) +V(i,j+1));
		elseif i==1 && j<round(b/h) +1 &&j~=round((d+c) /h)+1
		   V(i,j)=0.25*(V(i,j-1) +V(i,j+1)+2*V(i+1,j)); 
		elseif j==1 && i<round(a/h) +1
		   V(i,j)=0.25*(2*V(i,j+1) +V(i-1,j) +V(i+1,j)); 
		elseif j==round((d+c) /h)+1
		   if i>round(w/h)+1 && i<round(a/h)+1
			V(i,j)=0.25*((e1/ (2*(e0+e1))) *V(i, j+1)+(e0/ (2*(e0+e1))) *V(i, j-1) +V(i+1, j) +V(i+1, j));
		   end
		elseif i>i && i<round(a/h)+1 && j>i && j<round(b/h)+1
		end
	     end
	end
   	bool=(e<max(max(abs(V-U))));
	U=V;
	end
	%d�termination de la charge en pr�sence du di�lectrique%
Q=0.5*e0*(V(1,round((c+d) /h) +4) -V(1,round((c+d) /h)+3));
	for i=1:round(w/h) +2
	    Q=Q0+e0*(V(i,round((c+d) /h) +4)-V(i,round((c+d) /h) +3));
	end
	for j=round((c+d) /h) +3:-1:22
	    Q=Q+e0*(V(round(w/h) +3, j) -V(round(w/h)+2, j));
	end
            Q=Q-e0*V(round(w/h) +2, round((c+d) /h) +3);
	Q=Q+((e0+e1) /2)*(V(round(w/h) +3,round ((d+c) /h)+1)-V(round(w/h) +2, round((d+c) /h) +1));
	for j=20:-1:2
	Q=Q+e0*(V(round(w/h)+3,j)-V(round(w/h)+2,j));
end
Q=Q+(e0*0.5*(V(round(w/h)+3,1)-V(round(w/h)+2,1)));
    C=4*Q/100;
%calcul de l'imp�dance caract�ristique%
Z0=1/(3*10^8*(C*C0)^0.5);
u0=3*10^8*(C0/C)^0.5;
    Z(r,k)=Z0; 
    u(r,k)=u0;
end
end

% Create the results directory if it doesn't exist
if ~exist('results/imedance_ligne_microruban', 'dir')
    mkdir('results/imedance_ligne_microruban');
end

% Base filename for text results
baseFilename_text = 'results/imedance_ligne_microruban/imedance_ligne_microruban_results.txt';
filename_text = baseFilename_text;
count_text = 1;

% Check if the text file exists and update the filename with a count
while exist(filename_text, 'file')
    filename_text = sprintf('results/imedance_ligne_microruban/imedance_ligne_microruban_results_%d.txt', count_text);
    count_text = count_text + 1;
end

% Open the text file for writing results
fileID_text = fopen(filename_text, 'w');

% Write variables and results to the text file
fprintf(fileID_text, 'a = %f, b = %f, c = %f, d = %f, v1 = %f, h = %f\n', a, b, c, d, v1, h);
fprintf(fileID_text, 'ep1 = %f, ep2 = %f, ep3 = %f\n', ep1, ep2, ep3);
fprintf(fileID_text, 'e0 = %e\n', e0);
fprintf(fileID_text, 'Z = \n');
fprintf(fileID_text, '%f ', Z);
fprintf(fileID_text, '\n\nu = \n');
fprintf(fileID_text, '%f ', u);
fprintf(fileID_text, '\n');

% Close the text file
fclose(fileID_text);

% Base filename for image results
baseFilename_image = 'results/imedance_ligne_microruban/imedance_ligne_microruban_plot';
filename_image = baseFilename_image;
count_image = 1;

% Check if the image file exists and update the filename with a count
while exist([filename_image '.png'], 'file')
    filename_image = sprintf('results/imedance_ligne_microruban/imedance_ligne_microruban_plot_%d', count_image);
    count_image = count_image + 1;
end

% Plotting and saving impedance results
filename_image_Z = [filename_image '_Z'];
count_image_Z = 1;
while exist([filename_image_Z '.png'], 'file')
    filename_image_Z = sprintf('%s_Z_%d', filename_image, count_image_Z);
    count_image_Z = count_image_Z + 1;
end
figure(1);
plot(t, Z(1,:), 'r', t, Z(2,:), 'g', t, Z(3,:), 'b');
xlabel('longueur omega en [cm]');
ylabel('imedance en ohm');
saveas(figure(1), [filename_image_Z '.png']);

% Plotting and saving phase velocity results
filename_image_u = [filename_image '_U'];
count_image_u = 1;
while exist([filename_image_u '.png'], 'file')
    filename_image_u = sprintf('%s_U_%d', filename_image, count_image_u);
    count_image_u = count_image_u + 1;
end
figure(2);
plot(t, u(1,:), 'r', t, u(2,:), 'g', t, u(3,:), 'b');
xlabel('longueur omega en [ohm]');
ylabel('vitesse de phase en m/s');
saveas(figure(2), [filename_image_u '.png']);
