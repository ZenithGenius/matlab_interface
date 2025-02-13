function residus
x=0:0.01:1;
%Evaluation des diff�rentes solutions
%Solution vraie
f=[(cos(2*x-2)+2*sin(2*x))/(8*cos(2))]+((x.^2)/4)-1/8;
%m�thode de collocation
f1=-1.471*x+0.2993*x.^2+0.6241*x.^3;
%m�thode sous domaine
f2=-1.789*x+0.2895*x.^2+0.7368*x.^3;
%m�thode de Galerkin
f3=-1.85*x+0.4979*x.^2+0.6181*x.^3;
%m�thode de moindre carr�
f4=-1.6925*x+0.2785*x.^2+0.7118*x.^3;
%--------------------------------------------------------------------------
%Trac� des courbes et comparaison
plot(x,f,'b','linewidth',6)
hold on
plot(x,f1,'rs')
plot(x,f2,'g+')
plot(x,f3,'yd')
plot(x,f4,'m')
legend('valeur exacte','collocation','sous domaine','Galerkin','moindre carr�')
hold off

% Create the results directory if it doesn't exist
if ~exist('results/residus', 'dir')
    mkdir('results/residus');
end

% Base filename for the plot
baseFilename = 'results/residus/residus_plot.png';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/residus/residus_plot_%d.png', count);
    count = count + 1;
end

% Save the plot to a file
saveas(gcf, filename);

% Close the figure
close(gcf);

end
