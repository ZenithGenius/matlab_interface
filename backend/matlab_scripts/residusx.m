function residusx
x=linspace(0,1,100);
%D�finition des fonctions d'expansion
u1=x.*(1-x);u2=(x.^2).*(1-x);
%Solution exacte
y=(1/30)*(x-((sin(sqrt(30)*x))/(sin(sqrt(30)))));
%Collocation
y1=(-9/4).*u1+(3/2).*u2;
%Sous-r�gion
y2=(7/18).*u1-(4/9).*u2;
%Galerkin
y3=(5/12).*u1-(7/12).*u2;
hold on
plot(x,y,'b')
plot(x,y1,'r')
plot(x,y2,'g')
plot(x,y3,'y')
legend('exacte','collocation','sous-r�gion','Galerkin')
hold off

% Create the results directory if it doesn't exist
if ~exist('results/residusx', 'dir')
    mkdir('results/residusx');
end

% Base filename for the plot
baseFilename = 'results/residusx/residusx_plot.png';
filename = baseFilename;
count = 1;

% Check if the file exists and update the filename with a count
while exist(filename, 'file')
    filename = sprintf('results/residusx/residusx_plot_%d.png', count);
    count = count + 1;
end

% Save the plot to a file
saveas(gcf, filename);

% Close the figure
close(gcf);
end
